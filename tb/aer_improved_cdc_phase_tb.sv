`timescale 1ps/1ps

// Digital CDC phase sweep.  This does not model analog metastability; it
// verifies the architectural contract around the sampling edge: every held
// asynchronous request is acknowledged and delivered exactly once.
module aer_improved_cdc_phase_tb;
    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = 4;

    logic clk;
    logic rst_n;
    logic [NUM_SOURCES-1:0] src_req_async;
    logic [NUM_SOURCES-1:0] src_ack_async;
    logic [ADDR_W-1:0] out_addr;
    logic out_valid;
    logic out_ready;

    integer error_count;
    integer trial_count;
    integer received_count;
    integer expected_source;
    integer received_before;
    integer wait_cycles;
    integer source;
    integer phase_index;
    integer phases_ps [0:11];
    logic expected_pending;

`ifdef AER_IMPROVED_GATE_NETLIST
    aer_improved_hybrid dut (
`else
    aer_improved_hybrid #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W(ADDR_W)
    ) dut (
`endif
        .clk(clk),
        .rst_n(rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr(out_addr),
        .out_valid(out_valid),
        .out_ready(out_ready)
    );

    initial clk = 1'b0;
    always #5000 clk = ~clk;

    task automatic report_error(input string message);
        begin
            error_count = error_count + 1;
            $display("ASSERT_FAIL time_ps=%0t trial=%0d message=%s",
                     $time, trial_count, message);
        end
    endtask

    always @(posedge clk) begin
        #1;
        if (rst_n && out_valid && out_ready) begin
            if (!expected_pending) begin
                report_error("duplicate or unexpected output event");
            end else if (out_addr !== expected_source[ADDR_W-1:0]) begin
                report_error("output address does not match requested source");
            end
            expected_pending = 1'b0;
            received_count = received_count + 1;
        end
    end

    task automatic run_trial(input integer requested_source,
                             input integer phase_ps);
        integer delay_ps;
        begin
            while ((src_ack_async !== '0) || (src_req_async !== '0))
                @(posedge clk);

            // Negative phases target the following edge; positive phases
            // target the current edge.  Zero is intentionally excluded so
            // testbench scheduling order is not mistaken for metastability.
            @(posedge clk);
            if (phase_ps < 0)
                delay_ps = 10000 + phase_ps;
            else
                delay_ps = phase_ps;
            #(delay_ps);

            expected_source = requested_source;
            expected_pending = 1'b1;
            received_before = received_count;
            src_req_async[requested_source] = 1'b1;
            trial_count = trial_count + 1;

            wait_cycles = 0;
            while ((src_ack_async[requested_source] !== 1'b1)
                   && (wait_cycles < 10)) begin
                @(posedge clk);
                #1;
                wait_cycles = wait_cycles + 1;
            end
            if (src_ack_async[requested_source] !== 1'b1)
                report_error("request was not acknowledged within 10 cycles");

            #700;
            src_req_async[requested_source] = 1'b0;

            wait_cycles = 0;
            while ((src_ack_async[requested_source] !== 1'b0)
                   && (wait_cycles < 10)) begin
                @(posedge clk);
                #1;
                wait_cycles = wait_cycles + 1;
            end
            if (src_ack_async[requested_source] !== 1'b0)
                report_error("acknowledge did not return low within 10 cycles");

            wait_cycles = 0;
            while ((received_count == received_before)
                   && (wait_cycles < 10)) begin
                @(posedge clk);
                #1;
                wait_cycles = wait_cycles + 1;
            end
            if (received_count != (received_before + 1))
                report_error("request was not delivered exactly once");

            // Leave an observation window before issuing the next trial.
            repeat (4) begin
                @(posedge clk);
                #1;
            end
            if (received_count != (received_before + 1))
                report_error("duplicate event appeared after handshake completion");
            if (src_ack_async !== '0)
                report_error("acknowledge vector was not idle between trials");
        end
    endtask

    initial begin
        phases_ps[0]  = -4900;
        phases_ps[1]  = -2500;
        phases_ps[2]  = -1000;
        phases_ps[3]  = -100;
        phases_ps[4]  = -10;
        phases_ps[5]  = -1;
        phases_ps[6]  = 1;
        phases_ps[7]  = 10;
        phases_ps[8]  = 100;
        phases_ps[9]  = 1000;
        phases_ps[10] = 2500;
        phases_ps[11] = 4900;

        rst_n = 1'b0;
        src_req_async = '0;
        out_ready = 1'b1;
        error_count = 0;
        trial_count = 0;
        received_count = 0;
        expected_source = 0;
        expected_pending = 1'b0;

        // Also clears the FPGA simulation global-set/reset interval.
        #120000;
        @(negedge clk);
        rst_n = 1'b1;

        for (source = 0; source < NUM_SOURCES; source = source + 1)
            for (phase_index = 0; phase_index < 12; phase_index = phase_index + 1)
                run_trial(source, phases_ps[phase_index]);

        $display("METRIC improved_cdc_phase_trials=%0d", trial_count);
        $display("METRIC improved_cdc_phase_received=%0d", received_count);
        $display("METRIC improved_cdc_phase_errors=%0d", error_count);
        if ((error_count == 0) && (received_count == trial_count))
            $display("CDC_PHASE_TEST_PASS trials=%0d", trial_count);
        else
            $display("CDC_PHASE_TEST_FAIL trials=%0d received=%0d errors=%0d",
                     trial_count, received_count, error_count);
        $finish;
    end
endmodule

