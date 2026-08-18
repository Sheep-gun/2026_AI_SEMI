`timescale 1ns/1ps

module aer_improved_hybrid_tb;
    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = $clog2(NUM_SOURCES);
    localparam integer MAX_EVENTS_PER_SOURCE = 32;

    logic clk;
    logic rst_n;
    logic [NUM_SOURCES-1:0] src_req_async;
    logic [NUM_SOURCES-1:0] src_ack_async;
    logic [ADDR_W-1:0] out_addr;
    logic out_valid;
    logic out_ready;

    integer cycle_count;
    integer offered_total;
    integer accepted_total;
    integer received_total;
    integer error_count;
    integer issue_head [0:NUM_SOURCES-1];
    integer issue_tail [0:NUM_SOURCES-1];
    integer issue_cycle [0:NUM_SOURCES-1][0:MAX_EVENTS_PER_SOURCE-1];
    integer request_start_cycle [0:NUM_SOURCES-1];
    integer received_by_source [0:NUM_SOURCES-1];
    integer total_latency_cycles;
    integer max_latency_cycles;
    integer source15_hotspot_latency_cycles;

    bit saturation_measure;
    integer saturation_events;
    integer saturation_start_cycle;
    integer saturation_last_cycle;
    integer saturation_gap_sum;
    integer saturation_min_gap;
    integer saturation_max_gap;

    logic prev_out_valid;
    logic prev_out_ready;
    logic [ADDR_W-1:0] prev_out_addr;

`ifdef AER_IMPROVED_GATE_NETLIST
    aer_improved_hybrid dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr     (out_addr),
        .out_valid    (out_valid),
        .out_ready    (out_ready)
    );
`else
    aer_improved_hybrid #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W     (ADDR_W)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr     (out_addr),
        .out_valid    (out_valid),
        .out_ready    (out_ready)
    );
`endif

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic report_error(input string message);
        begin
            error_count = error_count + 1;
            $display("ASSERT_FAIL cycle=%0d time_ns=%0t message=%s", cycle_count, $time, message);
        end
    endtask

    task automatic issue_event(input integer source, input integer phase_offset_ns);
        begin
            if (phase_offset_ns > 0)
                #(phase_offset_ns);
            wait (rst_n === 1'b1);
            while ((src_req_async[source] !== 1'b0) || (src_ack_async[source] !== 1'b0))
                #1;
            request_start_cycle[source] = cycle_count;
            offered_total = offered_total + 1;
            src_req_async[source] = 1'b1;
            while ((src_ack_async[source] !== 1'b1) && (rst_n === 1'b1))
                #1;
            if (rst_n) begin
                #1;
                src_req_async[source] = 1'b0;
                while ((src_ack_async[source] !== 1'b0) && (rst_n === 1'b1))
                    #1;
            end else begin
                src_req_async[source] = 1'b0;
            end
        end
    endtask

    task automatic issue_stream(input integer source, input integer count, input integer gap_ns);
        integer event_index;
        begin
            for (event_index = 0; event_index < count; event_index = event_index + 1) begin
                if (gap_ns > 0)
                    #(gap_ns);
                issue_event(source, 0);
            end
        end
    endtask

    task automatic wait_for_received(input integer expected, input integer timeout_cycles, input string phase);
        integer deadline;
        begin
            deadline = cycle_count + timeout_cycles;
            while ((received_total < expected) && (cycle_count < deadline))
                @(posedge clk);
            if (received_total != expected)
                report_error($sformatf("%s timeout expected=%0d received=%0d", phase, expected, received_total));
        end
    endtask

    genvar source_index;
    generate
        for (source_index = 0; source_index < NUM_SOURCES; source_index = source_index + 1) begin : g_accept_monitor
            always @(posedge src_ack_async[source_index]) begin
                if (rst_n) begin
                    if (issue_tail[source_index] >= MAX_EVENTS_PER_SOURCE) begin
                        report_error($sformatf("issue FIFO overflow source=%0d", source_index));
                    end else begin
                        issue_cycle[source_index][issue_tail[source_index]] = request_start_cycle[source_index];
                        issue_tail[source_index] = issue_tail[source_index] + 1;
                        accepted_total = accepted_total + 1;
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin : output_scoreboard
        integer source;
        integer latency;
        integer gap;
        if (!rst_n) begin
            cycle_count <= 0;
            prev_out_valid <= 1'b0;
            prev_out_ready <= 1'b0;
            prev_out_addr <= '0;
        end else begin
            cycle_count <= cycle_count + 1;

            if (prev_out_valid && !prev_out_ready) begin
                if (!out_valid)
                    report_error("out_valid dropped while stalled");
                if (out_addr !== prev_out_addr)
                    report_error("out_addr changed while stalled");
            end

            if (out_valid && out_ready) begin
                source = out_addr;
                if ((source < 0) || (source >= NUM_SOURCES)) begin
                    report_error($sformatf("out-of-range output address=%0d", source));
                end else if (issue_head[source] >= issue_tail[source]) begin
                    report_error($sformatf("duplicate/phantom output source=%0d", source));
                end else begin
                    latency = cycle_count - issue_cycle[source][issue_head[source]];
                    issue_head[source] = issue_head[source] + 1;
                    received_by_source[source] = received_by_source[source] + 1;
                    received_total = received_total + 1;
                    total_latency_cycles = total_latency_cycles + latency;
                    if (latency > max_latency_cycles)
                        max_latency_cycles = latency;
                    if (source == 15)
                        source15_hotspot_latency_cycles = latency;

                    if (saturation_measure) begin
                        if (saturation_events > 0) begin
                            gap = cycle_count - saturation_last_cycle;
                            saturation_gap_sum = saturation_gap_sum + gap;
                            if (gap < saturation_min_gap)
                                saturation_min_gap = gap;
                            if (gap > saturation_max_gap)
                                saturation_max_gap = gap;
                        end
                        saturation_last_cycle = cycle_count;
                        saturation_events = saturation_events + 1;
                    end
                end
            end

            prev_out_valid <= out_valid;
            prev_out_ready <= out_ready;
            prev_out_addr <= out_addr;
        end
    end

`ifndef AER_IMPROVED_GATE_NETLIST
    always @(posedge clk) begin : queue_bounds
        integer source;
        if (rst_n) begin
            for (source = 0; source < NUM_SOURCES; source = source + 1)
                if (dut.queue_count_q[source] > 2)
                    report_error($sformatf("queue overflow source=%0d count=%0d", source, dut.queue_count_q[source]));
        end
    end
`endif

    initial begin : test_sequence
        integer source;
        integer expected;
        integer pending_count;

        rst_n = 1'b0;
        src_req_async = '0;
        out_ready = 1'b1;
        offered_total = 0;
        accepted_total = 0;
        received_total = 0;
        error_count = 0;
        total_latency_cycles = 0;
        max_latency_cycles = 0;
        source15_hotspot_latency_cycles = 0;
        saturation_measure = 1'b0;
        saturation_events = 0;
        saturation_start_cycle = 0;
        saturation_last_cycle = 0;
        saturation_gap_sum = 0;
        saturation_min_gap = 32'h7fff_ffff;
        saturation_max_gap = 0;
        prev_out_valid = 1'b0;
        prev_out_ready = 1'b0;
        prev_out_addr = '0;
        cycle_count = 0;

        for (source = 0; source < NUM_SOURCES; source = source + 1) begin
            issue_head[source] = 0;
            issue_tail[source] = 0;
            request_start_cycle[source] = 0;
            received_by_source[source] = 0;
        end

        repeat (4) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);

        $display("TEST_START improved_single_event");
        expected = received_total + 1;
        issue_event(5, 2);
        wait_for_received(expected, 100, "improved_single_event");

        $display("TEST_START improved_simultaneous_all_sources");
        expected = received_total + NUM_SOURCES;
        fork
            issue_event(0, 1); issue_event(1, 1); issue_event(2, 1); issue_event(3, 1);
            issue_event(4, 1); issue_event(5, 1); issue_event(6, 1); issue_event(7, 1);
            issue_event(8, 1); issue_event(9, 1); issue_event(10, 1); issue_event(11, 1);
            issue_event(12, 1); issue_event(13, 1); issue_event(14, 1); issue_event(15, 1);
        join
        wait_for_received(expected, 300, "improved_simultaneous_all_sources");

        $display("TEST_START improved_burst_source_5");
        expected = received_total + 8;
        issue_stream(5, 8, 0);
        wait_for_received(expected, 300, "improved_burst_source_5");

        $display("TEST_START improved_receiver_stall");
        @(negedge clk);
        out_ready = 1'b0;
        expected = received_total + 4;
        fork
            issue_event(2, 1); issue_event(7, 2); issue_event(11, 3); issue_event(15, 4);
        join
        repeat (12) @(posedge clk);
        @(negedge clk);
        out_ready = 1'b1;
        wait_for_received(expected, 200, "improved_receiver_stall");

        $display("TEST_START improved_no_stall_saturation");
        expected = received_total + (NUM_SOURCES * 4);
        saturation_measure = 1'b1;
        saturation_start_cycle = cycle_count;
        fork
            issue_stream(0, 4, 0); issue_stream(1, 4, 0); issue_stream(2, 4, 0); issue_stream(3, 4, 0);
            issue_stream(4, 4, 0); issue_stream(5, 4, 0); issue_stream(6, 4, 0); issue_stream(7, 4, 0);
            issue_stream(8, 4, 0); issue_stream(9, 4, 0); issue_stream(10, 4, 0); issue_stream(11, 4, 0);
            issue_stream(12, 4, 0); issue_stream(13, 4, 0); issue_stream(14, 4, 0); issue_stream(15, 4, 0);
        join
        wait_for_received(expected, 1000, "improved_no_stall_saturation");
        saturation_measure = 1'b0;
        $display("METRIC improved_saturation_events=%0d", saturation_events);
        $display("METRIC improved_saturation_elapsed_cycles=%0d", cycle_count - saturation_start_cycle);
        $display("METRIC improved_saturation_gap_sum_cycles=%0d", saturation_gap_sum);
        $display("METRIC improved_saturation_min_gap_cycles=%0d", saturation_min_gap);
        $display("METRIC improved_saturation_max_gap_cycles=%0d", saturation_max_gap);

        $display("TEST_START improved_hotspot_round_robin");
        expected = received_total + 13;
        fork
            issue_stream(0, 12, 0);
            issue_event(15, 1);
        join
        wait_for_received(expected, 400, "improved_hotspot_round_robin");
        $display("METRIC improved_hotspot_source15_latency_cycles=%0d", source15_hotspot_latency_cycles);

        $display("TEST_START improved_reset_held_request");
        expected = received_total + 1;
        @(negedge clk);
        rst_n = 1'b0;
        src_req_async[7] = 1'b1;
        request_start_cycle[7] = 0;
        offered_total = offered_total + 1;
        repeat (3) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        wait (src_ack_async[7] === 1'b1);
        #1 src_req_async[7] = 1'b0;
        wait (src_ack_async[7] === 1'b0);
        wait_for_received(expected, 150, "improved_reset_held_request");

        $display("TEST_START improved_independent_streams");
        expected = received_total + (NUM_SOURCES * 2);
        fork
            issue_stream(0, 2, 1); issue_stream(1, 2, 2); issue_stream(2, 2, 3); issue_stream(3, 2, 4);
            issue_stream(4, 2, 5); issue_stream(5, 2, 1); issue_stream(6, 2, 2); issue_stream(7, 2, 3);
            issue_stream(8, 2, 4); issue_stream(9, 2, 5); issue_stream(10, 2, 1); issue_stream(11, 2, 2);
            issue_stream(12, 2, 3); issue_stream(13, 2, 4); issue_stream(14, 2, 5); issue_stream(15, 2, 1);
        join
        wait_for_received(expected, 800, "improved_independent_streams");

        pending_count = 0;
        for (source = 0; source < NUM_SOURCES; source = source + 1)
            pending_count = pending_count + (issue_tail[source] - issue_head[source]);
        if (pending_count != 0)
            report_error($sformatf("undrained accepted events=%0d", pending_count));
        if (accepted_total != received_total)
            report_error($sformatf("accepted/received mismatch accepted=%0d received=%0d", accepted_total, received_total));
        if (offered_total != accepted_total)
            report_error($sformatf("offered/accepted mismatch offered=%0d accepted=%0d", offered_total, accepted_total));

        $display("METRIC improved_events_offered=%0d", offered_total);
        $display("METRIC improved_events_accepted=%0d", accepted_total);
        $display("METRIC improved_events_received=%0d", received_total);
        if (received_total > 0)
            $display("METRIC improved_avg_latency_cycles_x1000=%0d", (total_latency_cycles * 1000) / received_total);
        $display("METRIC improved_max_latency_cycles=%0d", max_latency_cycles);
        $display("METRIC improved_assertion_errors=%0d", error_count);

        if (error_count == 0)
            $display("TEST_PASS improved issued=%0d received=%0d", accepted_total, received_total);
        else
            $display("TEST_FAIL improved errors=%0d accepted=%0d received=%0d", error_count, accepted_total, received_total);

        #20;
        $finish;
    end
endmodule
