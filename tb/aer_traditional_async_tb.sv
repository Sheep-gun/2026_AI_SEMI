`timescale 1ns/1ps

module aer_traditional_async_tb;

    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = $clog2(NUM_SOURCES);

    logic                   rst_n;
    logic [NUM_SOURCES-1:0] src_req;
    logic [NUM_SOURCES-1:0] src_ack;
    logic [ADDR_W-1:0]      aer_addr;
    logic                   aer_req;
    logic                   aer_ack;

    integer sink_ack_delay_ns;
    integer sink_release_delay_ns;
    integer issued_total;
    integer received_total;
    integer error_count;
    integer received_by_source [0:NUM_SOURCES-1];
    bit     pending [0:NUM_SOURCES-1];
    time    issue_time [0:NUM_SOURCES-1];
    time    total_latency_ns;
    time    max_latency_ns;
    time    hotspot_source15_latency_ns;

    bit     saturation_measure;
    time    saturation_last_receive_ns;
    time    saturation_gap_sum_ns;
    time    saturation_min_gap_ns;
    time    saturation_max_gap_ns;
    integer saturation_events;

    logic [ADDR_W-1:0] held_addr;
    bit                address_hold_active;

    aer_traditional_async #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W     (ADDR_W)
    ) dut (
        .rst_n    (rst_n),
        .src_req  (src_req),
        .src_ack  (src_ack),
        .aer_addr (aer_addr),
        .aer_req  (aer_req),
        .aer_ack  (aer_ack)
    );

    task automatic report_error(input string message);
        begin
            error_count = error_count + 1;
            $display("ASSERT_FAIL time_ns=%0d message=%s", $time, message);
        end
    endtask

    // Receiver-facing asynchronous four-phase model. The explicit delays are
    // environment delays, not a clock and not an ASIC performance claim.
    initial begin
        aer_ack = 1'b0;
        forever begin
            @(posedge aer_req or negedge rst_n);
            if (!rst_n) begin
                aer_ack = 1'b0;
            end else begin
                #(sink_ack_delay_ns);
                if (rst_n && aer_req) begin
                    aer_ack = 1'b1;
                    @(negedge aer_req or negedge rst_n);
                    if (!rst_n) begin
                        aer_ack = 1'b0;
                    end else begin
                        #(sink_release_delay_ns);
                        aer_ack = 1'b0;
                    end
                end
            end
        end
    end

    task automatic issue_event(input integer source);
        begin
            wait (rst_n === 1'b1);
            while ((src_req[source] !== 1'b0) || (src_ack[source] !== 1'b0))
                #1;
            if (pending[source])
                report_error($sformatf("source %0d issued while already pending", source));

            pending[source]  = 1'b1;
            issue_time[source] = $time;
            issued_total     = issued_total + 1;
            src_req[source]  = 1'b1;

            while ((src_ack[source] !== 1'b1) && (rst_n === 1'b1))
                #1;
            if (!rst_n) begin
                src_req[source] = 1'b0;
            end else begin
                #1;
                src_req[source] = 1'b0;
                while ((src_ack[source] !== 1'b0) && (rst_n === 1'b1))
                    #1;
            end
        end
    endtask

    task automatic issue_stream(
        input integer source,
        input integer count,
        input integer gap_ns
    );
        integer event_index;
        begin
            for (event_index = 0; event_index < count; event_index = event_index + 1) begin
                if (gap_ns > 0)
                    #(gap_ns);
                issue_event(source);
            end
        end
    endtask

    task automatic wait_for_count(
        input integer expected_received,
        input integer timeout_ns,
        input string  phase_name
    );
        time deadline;
        begin
            deadline = $time + timeout_ns;
            while ((received_total < expected_received) && ($time < deadline))
                #1;
            if (received_total != expected_received)
                report_error($sformatf(
                    "%s timeout expected=%0d received=%0d",
                    phase_name, expected_received, received_total
                ));
        end
    endtask

    // Scoreboard: every receiver acknowledge rise must correspond to exactly
    // one source event that was issued and not yet received.
    always @(posedge aer_ack) begin : receive_scoreboard
        integer source;
        time latency_ns;
        time gap_ns;

        if (rst_n) begin
            if (!aer_req)
                report_error("aer_ack rose while aer_req was low");

            source = aer_addr;
            if ((source < 0) || (source >= NUM_SOURCES)) begin
                report_error($sformatf("received out-of-range address %0d", source));
            end else if (!pending[source]) begin
                report_error($sformatf("duplicate/phantom event source=%0d", source));
            end else begin
                pending[source] = 1'b0;
                latency_ns = $time - issue_time[source];
                total_latency_ns = total_latency_ns + latency_ns;
                if (latency_ns > max_latency_ns)
                    max_latency_ns = latency_ns;
                if (source == 15)
                    hotspot_source15_latency_ns = latency_ns;

                received_by_source[source] = received_by_source[source] + 1;
                received_total = received_total + 1;

                if (saturation_measure) begin
                    if (saturation_events > 0) begin
                        gap_ns = $time - saturation_last_receive_ns;
                        saturation_gap_sum_ns = saturation_gap_sum_ns + gap_ns;
                        if (gap_ns < saturation_min_gap_ns)
                            saturation_min_gap_ns = gap_ns;
                        if (gap_ns > saturation_max_gap_ns)
                            saturation_max_gap_ns = gap_ns;
                    end
                    saturation_last_receive_ns = $time;
                    saturation_events = saturation_events + 1;
                end
            end
        end
    end

    // Protocol checks independent of a global clock.
    always @(posedge aer_req) begin
        if (aer_ack)
            report_error("new aer_req rose before old aer_ack returned low");
        held_addr = aer_addr;
        address_hold_active = 1'b1;
    end

    always @(aer_addr) begin
        if (address_hold_active && aer_req && (aer_addr !== held_addr))
            report_error($sformatf(
                "aer_addr changed while aer_req high old=%0d new=%0d",
                held_addr, aer_addr
            ));
    end

    always @(negedge aer_req)
        address_hold_active = 1'b0;

    always @(src_ack) begin : onehot_ack_check
        integer source;
        integer ack_count;
        if (rst_n) begin
            ack_count = 0;
            for (source = 0; source < NUM_SOURCES; source = source + 1)
                if (src_ack[source] === 1'b1)
                    ack_count = ack_count + 1;
            if (ack_count > 1)
                report_error($sformatf("src_ack is not onehot0 value=%h", src_ack));
        end
    end

    genvar source_index;
    generate
        for (source_index = 0; source_index < NUM_SOURCES; source_index = source_index + 1) begin : g_source_ack_check
            always @(posedge src_ack[source_index]) begin
                if (rst_n && (!aer_req || !aer_ack))
                    report_error($sformatf(
                        "src_ack[%0d] rose before receiver acceptance",
                        source_index
                    ));
            end
        end
    endgenerate

    initial begin : test_sequence
        integer source;
        integer expected;
        integer pending_count;
        time saturation_start_ns;
        time saturation_end_ns;

        rst_n = 1'b0;
        src_req = '0;
        sink_ack_delay_ns = 1;
        sink_release_delay_ns = 1;
        issued_total = 0;
        received_total = 0;
        error_count = 0;
        total_latency_ns = 0;
        max_latency_ns = 0;
        hotspot_source15_latency_ns = 0;
        saturation_measure = 1'b0;
        saturation_last_receive_ns = 0;
        saturation_gap_sum_ns = 0;
        saturation_min_gap_ns = 64'h7fff_ffff_ffff_ffff;
        saturation_max_gap_ns = 0;
        saturation_events = 0;
        held_addr = '0;
        address_hold_active = 1'b0;

        for (source = 0; source < NUM_SOURCES; source = source + 1) begin
            pending[source] = 1'b0;
            issue_time[source] = 0;
            received_by_source[source] = 0;
        end

        #10;
        rst_n = 1'b1;
        #2;

        $display("TEST_START async_single_event");
        expected = received_total + 1;
        issue_event(5);
        wait_for_count(expected, 200, "async_single_event");

        $display("TEST_START async_simultaneous_all_sources");
        expected = received_total + NUM_SOURCES;
        fork
            issue_event(0);  issue_event(1);  issue_event(2);  issue_event(3);
            issue_event(4);  issue_event(5);  issue_event(6);  issue_event(7);
            issue_event(8);  issue_event(9);  issue_event(10); issue_event(11);
            issue_event(12); issue_event(13); issue_event(14); issue_event(15);
        join
        wait_for_count(expected, 1000, "async_simultaneous_all_sources");

        $display("TEST_START async_burst_source_5");
        expected = received_total + 8;
        issue_stream(5, 8, 0);
        wait_for_count(expected, 500, "async_burst_source_5");

        $display("TEST_START async_receiver_backpressure");
        sink_ack_delay_ns = 20;
        expected = received_total + 4;
        fork
            issue_event(2);
            issue_event(7);
            issue_event(11);
            issue_event(15);
        join
        wait_for_count(expected, 1000, "async_receiver_backpressure");
        sink_ack_delay_ns = 1;

        $display("TEST_START async_no_stall_saturation");
        expected = received_total + (NUM_SOURCES * 4);
        saturation_measure = 1'b1;
        saturation_start_ns = $time;
        fork
            issue_stream(0, 4, 0);  issue_stream(1, 4, 0);
            issue_stream(2, 4, 0);  issue_stream(3, 4, 0);
            issue_stream(4, 4, 0);  issue_stream(5, 4, 0);
            issue_stream(6, 4, 0);  issue_stream(7, 4, 0);
            issue_stream(8, 4, 0);  issue_stream(9, 4, 0);
            issue_stream(10, 4, 0); issue_stream(11, 4, 0);
            issue_stream(12, 4, 0); issue_stream(13, 4, 0);
            issue_stream(14, 4, 0); issue_stream(15, 4, 0);
        join
        wait_for_count(expected, 3000, "async_no_stall_saturation");
        saturation_end_ns = $time;
        saturation_measure = 1'b0;

        $display("METRIC async_saturation_events=%0d", saturation_events);
        $display("METRIC async_saturation_elapsed_ns=%0d", saturation_end_ns - saturation_start_ns);
        $display("METRIC async_saturation_gap_sum_ns=%0d", saturation_gap_sum_ns);
        $display("METRIC async_saturation_min_gap_ns=%0d", saturation_min_gap_ns);
        $display("METRIC async_saturation_max_gap_ns=%0d", saturation_max_gap_ns);

        $display("TEST_START async_fixed_priority_hotspot");
        expected = received_total + 13;
        fork
            issue_stream(0, 12, 0);
            issue_event(15);
        join
        wait_for_count(expected, 1500, "async_fixed_priority_hotspot");
        $display("METRIC async_hotspot_source15_latency_ns=%0d", hotspot_source15_latency_ns);

        $display("TEST_START async_held_request_across_reset");
        expected = received_total + 1;
        rst_n = 1'b0;
        #2;
        if ((aer_req !== 1'b0) || (src_ack !== '0))
            report_error("outputs did not return idle during reset");
        pending[7] = 1'b1;
        issue_time[7] = $time;
        issued_total = issued_total + 1;
        src_req[7] = 1'b1;
        #5;
        rst_n = 1'b1;
        wait (src_ack[7] === 1'b1);
        #1;
        src_req[7] = 1'b0;
        wait (src_ack[7] === 1'b0);
        wait_for_count(expected, 200, "async_held_request_across_reset");

        $display("TEST_START async_independent_streams");
        expected = received_total + (NUM_SOURCES * 2);
        fork
            issue_stream(0, 2, 1);  issue_stream(1, 2, 2);
            issue_stream(2, 2, 3);  issue_stream(3, 2, 4);
            issue_stream(4, 2, 5);  issue_stream(5, 2, 1);
            issue_stream(6, 2, 2);  issue_stream(7, 2, 3);
            issue_stream(8, 2, 4);  issue_stream(9, 2, 5);
            issue_stream(10, 2, 1); issue_stream(11, 2, 2);
            issue_stream(12, 2, 3); issue_stream(13, 2, 4);
            issue_stream(14, 2, 5); issue_stream(15, 2, 1);
        join
        wait_for_count(expected, 3000, "async_independent_streams");

        pending_count = 0;
        for (source = 0; source < NUM_SOURCES; source = source + 1)
            if (pending[source])
                pending_count = pending_count + 1;

        if (pending_count != 0)
            report_error($sformatf("undrained pending sources=%0d", pending_count));
        if (received_total != issued_total)
            report_error($sformatf(
                "issued/received mismatch issued=%0d received=%0d",
                issued_total, received_total
            ));

        $display("METRIC async_events_issued=%0d", issued_total);
        $display("METRIC async_events_received=%0d", received_total);
        if (received_total > 0)
            $display("METRIC async_avg_latency_ns_x1000=%0d", (total_latency_ns * 1000) / received_total);
        $display("METRIC async_max_latency_ns=%0d", max_latency_ns);
        $display("METRIC async_assertion_errors=%0d", error_count);

        if (error_count == 0)
            $display("TEST_PASS async_baseline issued=%0d received=%0d", issued_total, received_total);
        else
            $display("TEST_FAIL async_baseline errors=%0d issued=%0d received=%0d", error_count, issued_total, received_total);

        #5;
        $finish;
    end

endmodule
