`timescale 1ps/1ps

module aer_traditional_structural_race_tb;

    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = $clog2(NUM_SOURCES);
`ifdef AER_GATE_NETLIST
    localparam integer RESET_HOLD_PS = 2000;
    localparam integer RESET_SETTLE_PS = 5000;
    localparam integer RECEIVER_ACK_DELAY_PS = 5000;
    localparam integer RECEIVER_RELEASE_DELAY_PS = 5000;
    localparam integer SOURCE_RESPONSE_DELAY_PS = 1000;
    localparam integer MIN_REQUEST_WIDTH_PS = 1000;
`else
    localparam integer RESET_HOLD_PS = 200;
    localparam integer RESET_SETTLE_PS = 100;
    localparam integer RECEIVER_ACK_DELAY_PS = 100;
    localparam integer RECEIVER_RELEASE_DELAY_PS = 100;
    localparam integer SOURCE_RESPONSE_DELAY_PS = 50;
    localparam integer MIN_REQUEST_WIDTH_PS = 100;
`endif

    logic                   rst_n;
    logic [NUM_SOURCES-1:0] src_req;
    logic [NUM_SOURCES-1:0] src_ack;
    logic [ADDR_W-1:0]      aer_addr;
    logic                   aer_req;
    logic                   aer_ack;

    integer error_count;
    integer trial_count;
    integer first_wins_low;
    integer first_wins_high;
    integer unexpected_first_count;
    integer output_unknown_count;
    integer short_req_pulse_count;
    integer trial_received;
    integer trial_addr [0:1];
    time    req_rise_time_ps;
    bit     test_active;

`ifdef AER_GATE_NETLIST
    aer_traditional_async dut (
        .rst_n    (rst_n),
        .src_req  (src_req),
        .src_ack  (src_ack),
        .aer_addr (aer_addr),
        .aer_req  (aer_req),
        .aer_ack  (aer_ack)
    );
`else
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
`endif

    task automatic report_error(input string message);
        begin
            error_count = error_count + 1;
            $display("RACE_ASSERT_FAIL time_ps=%0d message=%s", $time, message);
        end
    endtask

    // Fixed environment delays provide a digital timing-stress harness. They
    // do not model transistor metastability or target-process PVT behavior.
    initial begin
        aer_ack = 1'b0;
        forever begin
            @(posedge aer_req);
            if (rst_n) begin
                #(RECEIVER_ACK_DELAY_PS);
                if (rst_n && aer_req) begin
                    aer_ack = 1'b1;
                    @(negedge aer_req);
                    #(RECEIVER_RELEASE_DELAY_PS);
                    aer_ack = 1'b0;
                end
            end
        end
    end

    always @(posedge aer_ack) begin
        if (test_active) begin
            if (!aer_req)
                report_error("aer_ack rose while aer_req was low");
            if (trial_received < 2)
                trial_addr[trial_received] = aer_addr;
            trial_received = trial_received + 1;
        end
    end

    always @(posedge aer_req)
        req_rise_time_ps = $time;

    always @(negedge aer_req) begin
        if (test_active && (req_rise_time_ps > 0) &&
            (($time - req_rise_time_ps) < MIN_REQUEST_WIDTH_PS)) begin
            short_req_pulse_count = short_req_pulse_count + 1;
            report_error($sformatf("short aer_req pulse width_ps=%0d", $time - req_rise_time_ps));
        end
    end

    always @(src_ack or aer_addr or aer_req) begin : output_known_check
        integer source;
        integer ack_count;
        if (test_active) begin
            if ($isunknown({src_ack, aer_addr, aer_req})) begin
                output_unknown_count = output_unknown_count + 1;
                report_error("unknown propagated to controller outputs");
            end

            ack_count = 0;
            for (source = 0; source < NUM_SOURCES; source = source + 1)
                if (src_ack[source] === 1'b1)
                    ack_count = ack_count + 1;
            if (ack_count > 1)
                report_error($sformatf("multiple source acknowledgements value=%h", src_ack));
        end
    end

    task automatic respond_source(input integer source);
        begin
            while ((src_ack[source] !== 1'b1) && (rst_n === 1'b1))
                #1;
            if (rst_n) begin
                #(SOURCE_RESPONSE_DELAY_PS);
                src_req[source] = 1'b0;
                while ((src_ack[source] !== 1'b0) && (rst_n === 1'b1))
                    #1;
            end
        end
    endtask

    task automatic reset_trial;
        begin
            test_active = 1'b0;
            rst_n = 1'b0;
            src_req = '0;
            #(RESET_HOLD_PS);
            rst_n = 1'b1;
            #(RESET_SETTLE_PS);
            trial_received = 0;
            trial_addr[0] = -1;
            trial_addr[1] = -1;
            req_rise_time_ps = 0;
            test_active = 1'b1;
        end
    endtask

    task automatic check_two_results(
        input integer source_a,
        input integer source_b,
        input integer expected_first,
        input integer skew_ps
    );
        bit seen_a;
        bit seen_b;
        begin
            seen_a = (trial_addr[0] == source_a) || (trial_addr[1] == source_a);
            seen_b = (trial_addr[0] == source_b) || (trial_addr[1] == source_b);
            if (trial_received != 2)
                report_error($sformatf("trial did not complete two events received=%0d", trial_received));
            if (!seen_a || !seen_b)
                report_error($sformatf(
                    "lost/duplicate pair a=%0d b=%0d got=%0d,%0d",
                    source_a, source_b, trial_addr[0], trial_addr[1]
                ));

            if (trial_addr[0] == source_a)
                first_wins_low = first_wins_low + 1;
            else if (trial_addr[0] == source_b)
                first_wins_high = first_wins_high + 1;

            if (trial_addr[0] != expected_first) begin
                unexpected_first_count = unexpected_first_count + 1;
                $display(
                    "RACE_WINNER_SHIFT pair=%0d,%0d skew_ps=%0d expected=%0d observed=%0d",
                    source_a, source_b, skew_ps, expected_first, trial_addr[0]
                );
            end
        end
    endtask

    task automatic run_pair(
        input integer source_a,
        input integer source_b,
        input integer skew_ps
    );
        integer expected_first;
        integer positive_skew_ps;
        begin
            reset_trial();
            trial_count = trial_count + 1;

            if (skew_ps >= 0) begin
                expected_first = source_a;
                fork
                    begin
                        src_req[source_a] = 1'b1;
                        respond_source(source_a);
                    end
                    begin
                        #(skew_ps);
                        src_req[source_b] = 1'b1;
                        respond_source(source_b);
                    end
                join
            end else begin
                expected_first = source_b;
                positive_skew_ps = -skew_ps;
                fork
                    begin
                        src_req[source_b] = 1'b1;
                        respond_source(source_b);
                    end
                    begin
                        #(positive_skew_ps);
                        src_req[source_a] = 1'b1;
                        respond_source(source_a);
                    end
                join
            end

            while ((aer_req !== 1'b0) || (aer_ack !== 1'b0))
                #1;
            check_two_results(source_a, source_b, expected_first, skew_ps);
        end
    endtask

    task automatic run_x_window(
        input integer source_low,
        input integer source_high
    );
        begin
            reset_trial();
            trial_count = trial_count + 1;
            src_req[source_low] = 1'bx;
            src_req[source_high] = 1'b1;

            fork
                respond_source(source_high);
                begin
                    #1;
                    src_req[source_low] = 1'b1;
                    respond_source(source_low);
                end
            join

            while ((aer_req !== 1'b0) || (aer_ack !== 1'b0))
                #1;
            check_two_results(source_low, source_high, source_high, 1);
            $display(
                "METRIC x_window_pair=%0d,%0d first_grant=%0d",
                source_low, source_high, trial_addr[0]
            );
        end
    endtask

    initial begin : race_sequence
        integer skew_ps;

        rst_n = 1'b0;
        src_req = '0;
        error_count = 0;
        trial_count = 0;
        first_wins_low = 0;
        first_wins_high = 0;
        unexpected_first_count = 0;
        output_unknown_count = 0;
        short_req_pulse_count = 0;
        trial_received = 0;
        trial_addr[0] = -1;
        trial_addr[1] = -1;
        req_rise_time_ps = 0;
        test_active = 1'b0;

        $display("TEST_START async_race_skew_sweep");
        for (skew_ps = -20; skew_ps <= 20; skew_ps = skew_ps + 1) begin
            run_pair(0, 15, skew_ps);
            run_pair(3, 7, skew_ps);
        end

        $display("METRIC race_trials=%0d", trial_count);
        $display("METRIC race_first_wins_earlier_or_low_path=%0d", first_wins_low);
        $display("METRIC race_first_wins_other_path=%0d", first_wins_high);
        $display("METRIC race_unexpected_first_count=%0d", unexpected_first_count);
        $display("METRIC race_output_unknown_count=%0d", output_unknown_count);
        $display("METRIC race_short_req_pulse_count=%0d", short_req_pulse_count);
        $display("METRIC race_errors=%0d", error_count);

        if (error_count == 0)
            $display("RACE_TEST_PASS digital_model trials=%0d", trial_count);
        else
            $display("RACE_TEST_FAIL digital_model errors=%0d trials=%0d", error_count, trial_count);

        #200;
        $finish;
    end

endmodule
