`timescale 1ns/1ps

module aer_traditional_tb;

    localparam integer NUM_SOURCES   = 16;
    localparam integer ADDR_W        = $clog2(NUM_SOURCES);
    localparam integer MAX_PER_SRC   = 512;
    localparam integer DRAIN_TIMEOUT = 20000;

    logic                   clk;
    logic                   rst_n;
    logic [NUM_SOURCES-1:0] src_req;
    logic [NUM_SOURCES-1:0] src_ack;
    logic [ADDR_W-1:0]      aer_addr;
    logic                   aer_req;
    logic                   aer_ack;

    integer cycle_count;
    integer errors;
    integer issued_total;
    integer received_total;
    integer latency_sum;
    integer latency_max;
    integer issue_cycle [0:NUM_SOURCES-1][0:MAX_PER_SRC-1];
    integer issue_tail  [0:NUM_SOURCES-1];
    integer receive_head[0:NUM_SOURCES-1];
    integer received_by_source[0:NUM_SOURCES-1];
    integer max_latency_by_source[0:NUM_SOURCES-1];
    integer accepted_sequence[0:4095];
    integer sequence_len;
    integer measurement_active;
    integer measurement_events;
    integer measurement_first_cycle;
    integer measurement_last_cycle;
    integer measurement_previous_cycle;
    integer measurement_min_gap;
    integer measurement_max_gap;
    integer i;
    integer j;
    integer seed;

    logic [NUM_SOURCES-1:0] prev_src_req;
    logic [ADDR_W-1:0]      held_addr;
    logic                   prev_aer_req;
    logic                   prev_transfer_level;
    integer                 sink_delay_cycles;
    integer                 sink_countdown;

    aer_traditional #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W(ADDR_W)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .src_req  (src_req),
        .src_ack  (src_ack),
        .aer_addr (aer_addr),
        .aer_req  (aer_req),
        .aer_ack  (aer_ack)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Receiver model: acknowledge each request after a programmable number of
    // full cycles, then return acknowledge low after request returns low.
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aer_ack        <= 1'b0;
            sink_countdown <= -1;
        end else if (!aer_ack) begin
            if (!aer_req) begin
                sink_countdown <= -1;
            end else if (sink_countdown < 0) begin
                if (sink_delay_cycles == 0) begin
                    aer_ack        <= 1'b1;
                    sink_countdown <= -1;
                end else begin
                    sink_countdown <= sink_delay_cycles;
                end
            end else if (sink_countdown == 0) begin
                aer_ack        <= 1'b1;
                sink_countdown <= -1;
            end else begin
                sink_countdown <= sink_countdown - 1;
            end
        end else if (!aer_req) begin
            aer_ack <= 1'b0;
        end
    end

    task automatic report_error(input string message);
        begin
            errors = errors + 1;
            $display("ASSERT_FAIL cycle=%0d time=%0t %s", cycle_count, $time, message);
        end
    endtask

    task automatic send_event(input integer source);
        integer guard;
        begin
            guard = 0;
            @(negedge clk);
            while (!rst_n) @(negedge clk);
            src_req[source] = 1'b1;

            while (src_ack[source] !== 1'b1) begin
                @(negedge clk);
                guard = guard + 1;
                if (guard > DRAIN_TIMEOUT) begin
                    report_error($sformatf("source %0d timed out waiting for ack high", source));
                    src_req[source] = 1'b0;
                    return;
                end
            end

            src_req[source] = 1'b0;
            guard = 0;
            while (src_ack[source] !== 1'b0) begin
                @(negedge clk);
                guard = guard + 1;
                if (guard > DRAIN_TIMEOUT) begin
                    report_error($sformatf("source %0d timed out waiting for ack low", source));
                    return;
                end
            end
        end
    endtask

    task automatic wait_for_drain(input integer expected_total);
        integer guard;
        begin
            guard = 0;
            while ((received_total < expected_total) && (guard < DRAIN_TIMEOUT)) begin
                @(posedge clk);
                guard = guard + 1;
            end
            if (received_total != expected_total)
                report_error($sformatf("drain timeout expected=%0d received=%0d", expected_total, received_total));
        end
    endtask

    task automatic random_stream(
        input integer source,
        input integer event_count,
        input integer stream_seed
    );
        integer k;
        integer gap;
        integer local_seed;
        begin
            local_seed = stream_seed;
            for (k = 0; k < event_count; k = k + 1) begin
                gap = $urandom(local_seed) % 4;
                repeat (gap) @(posedge clk);
                send_event(source);
            end
        end
    endtask

    task automatic saturation_stream(
        input integer source,
        input integer event_count
    );
        integer k;
        begin
            for (k = 0; k < event_count; k = k + 1)
                send_event(source);
        end
    endtask

    task automatic apply_reset;
        begin
            rst_n = 1'b0;
            repeat (3) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            repeat (2) @(posedge clk);
        end
    endtask

    // Self-checking scoreboard and procedural protocol assertions. These run in
    // Vivado Simulator and Xcelium. Additional SVA properties are enabled below for tools
    // with full property support.
    always @(posedge clk or negedge rst_n) begin
        integer src;
        integer latency;
        integer ack_count;
        if (!rst_n) begin
            prev_src_req        <= '0;
            prev_aer_req        <= 1'b0;
            prev_transfer_level <= 1'b0;
            held_addr           <= '0;
        end else begin
            cycle_count = cycle_count + 1;

            for (src = 0; src < NUM_SOURCES; src = src + 1) begin
                if (src_req[src] && !prev_src_req[src]) begin
                    if (issue_tail[src] >= MAX_PER_SRC) begin
                        report_error($sformatf("source %0d issue queue overflow", src));
                    end else begin
                        issue_cycle[src][issue_tail[src]] = cycle_count;
                        issue_tail[src] = issue_tail[src] + 1;
                        issued_total = issued_total + 1;
                    end
                end
            end

            ack_count = 0;
            for (src = 0; src < NUM_SOURCES; src = src + 1)
                if (src_ack[src]) ack_count = ack_count + 1;
            if (ack_count > 1)
                report_error($sformatf("multiple source acknowledgements asserted: %0d", ack_count));

            if (prev_aer_req && aer_req && (aer_addr !== held_addr))
                report_error($sformatf("address changed while request high old=%0d new=%0d", held_addr, aer_addr));

            if (!prev_transfer_level && aer_req && aer_ack) begin
                src = aer_addr;
                if ((src < 0) || (src >= NUM_SOURCES)) begin
                    report_error($sformatf("output address out of range: %0d", src));
                end else if (receive_head[src] >= issue_tail[src]) begin
                    report_error($sformatf("phantom or duplicate output from source %0d", src));
                end else begin
                    latency = cycle_count - issue_cycle[src][receive_head[src]];
                    receive_head[src] = receive_head[src] + 1;
                    received_by_source[src] = received_by_source[src] + 1;
                    received_total = received_total + 1;
                    latency_sum = latency_sum + latency;
                    if (latency > latency_max) latency_max = latency;
                    if (latency > max_latency_by_source[src])
                        max_latency_by_source[src] = latency;
                    accepted_sequence[sequence_len] = src;
                    sequence_len = sequence_len + 1;

                    if (measurement_active != 0) begin
                        if (measurement_events == 0) begin
                            measurement_first_cycle = cycle_count;
                        end else begin
                            if ((cycle_count - measurement_previous_cycle) < measurement_min_gap)
                                measurement_min_gap = cycle_count - measurement_previous_cycle;
                            if ((cycle_count - measurement_previous_cycle) > measurement_max_gap)
                                measurement_max_gap = cycle_count - measurement_previous_cycle;
                        end
                        measurement_previous_cycle = cycle_count;
                        measurement_last_cycle = cycle_count;
                        measurement_events = measurement_events + 1;
                    end
                end
            end

            prev_src_req         <= src_req;
            prev_aer_req         <= aer_req;
            prev_transfer_level  <= aer_req && aer_ack;
            if (!aer_req || !prev_aer_req)
                held_addr <= aer_addr;
        end
    end

`ifdef AER_ENABLE_SVA
    property p_address_stable_while_request;
        @(posedge clk) disable iff (!rst_n)
            aer_req && !aer_ack |=> aer_req && $stable(aer_addr);
    endproperty
    assert property (p_address_stable_while_request);

    property p_source_ack_onehot0;
        @(posedge clk) disable iff (!rst_n) $onehot0(src_ack);
    endproperty
    assert property (p_source_ack_onehot0);
`endif

    initial begin : test_sequence
        integer expected;
        integer random_events;
        rst_n                 = 1'b0;
        src_req               = '0;
        aer_ack               = 1'b0;
        sink_delay_cycles     = 0;
        sink_countdown        = -1;
        cycle_count           = 0;
        errors                = 0;
        issued_total          = 0;
        received_total        = 0;
        latency_sum           = 0;
        latency_max           = 0;
        sequence_len          = 0;
        measurement_active    = 0;
        measurement_events    = 0;
        measurement_first_cycle = 0;
        measurement_last_cycle = 0;
        measurement_previous_cycle = 0;
        measurement_min_gap   = DRAIN_TIMEOUT;
        measurement_max_gap   = 0;
        seed                  = 32'h5eed2026;
        prev_src_req          = '0;
        prev_aer_req          = 1'b0;
        prev_transfer_level   = 1'b0;
        held_addr             = '0;

        for (i = 0; i < NUM_SOURCES; i = i + 1) begin
            issue_tail[i] = 0;
            receive_head[i] = 0;
            received_by_source[i] = 0;
            max_latency_by_source[i] = 0;
        end

        apply_reset();

        $display("TEST_START single_event");
        expected = received_total + 1;
        send_event(3);
        wait_for_drain(expected);

        $display("TEST_START simultaneous_all_sources");
        expected = received_total + NUM_SOURCES;
        fork
            send_event(0);  send_event(1);  send_event(2);  send_event(3);
            send_event(4);  send_event(5);  send_event(6);  send_event(7);
            send_event(8);  send_event(9);  send_event(10); send_event(11);
            send_event(12); send_event(13); send_event(14); send_event(15);
        join
        wait_for_drain(expected);

        $display("TEST_START burst_source_5");
        expected = received_total + 12;
        for (j = 0; j < 12; j = j + 1)
            send_event(5);
        wait_for_drain(expected);

        $display("TEST_START receiver_backpressure");
        sink_delay_cycles = 7;
        expected = received_total + 4;
        fork
            send_event(2);
            send_event(6);
            send_event(10);
            send_event(14);
        join
        wait_for_drain(expected);
        sink_delay_cycles = 0;

        $display("TEST_START no_stall_saturation");
        expected = received_total + (NUM_SOURCES * 8);
        measurement_events = 0;
        measurement_first_cycle = 0;
        measurement_last_cycle = 0;
        measurement_previous_cycle = 0;
        measurement_min_gap = DRAIN_TIMEOUT;
        measurement_max_gap = 0;
        measurement_active = 1;
        fork
            saturation_stream(0,  8); saturation_stream(1,  8);
            saturation_stream(2,  8); saturation_stream(3,  8);
            saturation_stream(4,  8); saturation_stream(5,  8);
            saturation_stream(6,  8); saturation_stream(7,  8);
            saturation_stream(8,  8); saturation_stream(9,  8);
            saturation_stream(10, 8); saturation_stream(11, 8);
            saturation_stream(12, 8); saturation_stream(13, 8);
            saturation_stream(14, 8); saturation_stream(15, 8);
        join
        wait_for_drain(expected);
        measurement_active = 0;
        if (measurement_events != (NUM_SOURCES * 8))
            report_error($sformatf("saturation event count expected=%0d measured=%0d",
                                   NUM_SOURCES * 8, measurement_events));
        if (measurement_last_cycle >= measurement_first_cycle) begin
            $display("METRIC saturation_events=%0d", measurement_events);
            $display("METRIC saturation_inter_event_interval_sum_cycles=%0d",
                     measurement_last_cycle - measurement_first_cycle);
            $display("METRIC saturation_throughput_events_per_cycle_x1000000=%0d",
                     ((measurement_events - 1) * 1000000) /
                     (measurement_last_cycle - measurement_first_cycle));
            $display("METRIC saturation_min_inter_event_gap_cycles=%0d", measurement_min_gap);
            $display("METRIC saturation_max_inter_event_gap_cycles=%0d", measurement_max_gap);
        end

        $display("TEST_START hotspot_fixed_priority_characterization");
        max_latency_by_source[15] = 0;
        expected = received_total + 13;
        fork
            begin
                for (j = 0; j < 12; j = j + 1)
                    send_event(0);
            end
            send_event(15);
        join
        wait_for_drain(expected);
        $display("METRIC hotspot_source15_max_latency_cycles=%0d", max_latency_by_source[15]);

        $display("TEST_START held_request_across_reset");
        @(negedge clk);
        rst_n = 1'b0;
        src_req[7] = 1'b1;
        repeat (3) @(posedge clk);
        @(negedge clk);
        rst_n = 1'b1;
        expected = received_total + 1;
        while (src_ack[7] !== 1'b1) @(negedge clk);
        src_req[7] = 1'b0;
        while (src_ack[7] !== 1'b0) @(negedge clk);
        wait_for_drain(expected);

        $display("TEST_START long_random_traffic");
        expected = received_total + (NUM_SOURCES * 16);
        fork
            random_stream(0,  16, seed ^ 32'h00001021);
            random_stream(1,  16, seed ^ 32'h00002042);
            random_stream(2,  16, seed ^ 32'h00003063);
            random_stream(3,  16, seed ^ 32'h00004084);
            random_stream(4,  16, seed ^ 32'h000050a5);
            random_stream(5,  16, seed ^ 32'h000060c6);
            random_stream(6,  16, seed ^ 32'h000070e7);
            random_stream(7,  16, seed ^ 32'h00008108);
            random_stream(8,  16, seed ^ 32'h00009129);
            random_stream(9,  16, seed ^ 32'h0000a14a);
            random_stream(10, 16, seed ^ 32'h0000b16b);
            random_stream(11, 16, seed ^ 32'h0000c18c);
            random_stream(12, 16, seed ^ 32'h0000d1ad);
            random_stream(13, 16, seed ^ 32'h0000e1ce);
            random_stream(14, 16, seed ^ 32'h0000f1ef);
            random_stream(15, 16, seed ^ 32'h00010210);
        join
        wait_for_drain(expected);

        repeat (5) @(posedge clk);

        for (i = 0; i < NUM_SOURCES; i = i + 1) begin
            if (receive_head[i] != issue_tail[i])
                report_error($sformatf("source %0d not drained issued=%0d received=%0d",
                                       i, issue_tail[i], receive_head[i]));
        end
        if (issued_total != received_total)
            report_error($sformatf("total mismatch issued=%0d received=%0d", issued_total, received_total));

        $display("METRIC cycles=%0d", cycle_count);
        $display("METRIC events_issued=%0d", issued_total);
        $display("METRIC events_received=%0d", received_total);
        if (received_total > 0)
            $display("METRIC avg_latency_cycles_x1000=%0d", (latency_sum * 1000) / received_total);
        $display("METRIC max_latency_cycles=%0d", latency_max);
        if (cycle_count > 0)
            $display("METRIC throughput_events_per_cycle_x1000000=%0d",
                     (received_total * 1000000) / cycle_count);

        if (errors == 0) begin
            $display("TEST_PASS baseline issued=%0d received=%0d", issued_total, received_total);
            $finish;
        end else begin
            $display("TEST_FAIL baseline errors=%0d issued=%0d received=%0d",
                     errors, issued_total, received_total);
            $fatal(1, "baseline self-checking testbench failed");
        end
    end

    initial begin : global_timeout
        #5000000;
        $fatal(1, "global simulation timeout");
    end

endmodule
