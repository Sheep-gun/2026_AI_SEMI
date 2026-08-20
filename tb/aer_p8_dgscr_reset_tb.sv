`timescale 1ns/1ps

// Reset-specific checks for the synchronous-core-reset/isolation experiment.
module aer_p8_dgscr_reset_tb;
    logic clk;
    logic clock_enable;
    logic rst_n;
    logic [15:0] src_req_async;
    logic [15:0] src_ack_async;
    logic [3:0] out_addr;
    logic out_valid;
    logic out_ready;

    integer errors;
    integer transfer_count;
    logic [3:0] transfer_log [0:7];

    aer_p8_dgscr_dut dut (.*);

    initial clk = 1'b0;
    always #5 begin
        if (clock_enable)
            clk = ~clk;
        else
            clk = 1'b0;
    end

    always @(posedge clk) begin
        if (out_valid && out_ready) begin
            if (transfer_count < 8)
                transfer_log[transfer_count] = out_addr;
            transfer_count = transfer_count + 1;
        end
    end

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            $display("P8_DGSCR_RESET_ASSERT_FAIL message=%s", message);
        end
    endtask

    task automatic check_safe_low(input string phase);
        begin
            if (src_ack_async !== 16'h0000)
                fail($sformatf("%s ACK not safe-low: %04h", phase, src_ack_async));
            if (out_valid !== 1'b0)
                fail($sformatf("%s out_valid not safe-low: %b", phase, out_valid));
        end
    endtask

    task automatic wait_ack_high(input logic [15:0] mask);
        integer waited;
        begin
            waited = 0;
            while (((src_ack_async & mask) !== mask) && (waited < 40)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if ((src_ack_async & mask) !== mask)
                fail($sformatf("ACK-high timeout mask=%04h ack=%04h", mask, src_ack_async));
        end
    endtask

    task automatic wait_ack_low(input logic [15:0] mask);
        integer waited;
        begin
            waited = 0;
            while (((src_ack_async & mask) !== 16'h0000) && (waited < 40)) begin
                @(posedge clk);
                #1;
                waited = waited + 1;
            end
            if ((src_ack_async & mask) !== 16'h0000)
                fail($sformatf("ACK-low timeout mask=%04h ack=%04h", mask, src_ack_async));
        end
    endtask

    initial begin : test_sequence
        integer base_transfer_count;
        integer waited;

        errors = 0;
        transfer_count = 0;
        clock_enable = 1'b0;
        rst_n = 1'b1;
        src_req_async = '0;
        out_ready = 1'b1;

        // Assertion and deassertion while no clock exists.  Deassertion must not
        // unmask the stale/uninitialized core until the release clocks arrive.
        #1 rst_n = 1'b0;
        #1 check_safe_low("clockless assertion");
        #20 rst_n = 1'b1;
        #20 check_safe_low("clockless deassertion before release clocks");

        clock_enable = 1'b1;
        @(posedge clk);
        #1 check_safe_low("first release clock");
        @(posedge clk);
        #1;
        if ((src_ack_async !== 16'h0000) || (out_valid !== 1'b0))
            fail("second release clock exposed nonzero cleared state");

        // Establish an active ACK and stalled output, then remove the clock.
        @(negedge clk);
        out_ready = 1'b0;
        src_req_async[4] = 1'b1;
        wait_ack_high(16'h0010);
        waited = 0;
        while (!out_valid && (waited < 20)) begin
            @(posedge clk);
            #1;
            waited = waited + 1;
        end
        if (!out_valid || (out_addr !== 4'd4))
            fail($sformatf("failed to establish stalled source 4 addr=%0d valid=%b", out_addr, out_valid));

        @(negedge clk);
        clock_enable = 1'b0;
        #2 rst_n = 1'b0;
        #1 check_safe_low("mid-phase asynchronous assertion without clock");

        // A second request starts during reset.  Both requests must remain
        // masked after clockless deassertion and be captured after restart.
        src_req_async[9] = 1'b1;
        #20 rst_n = 1'b1;
        #20 check_safe_low("mid-phase clockless release remains isolated");

        base_transfer_count = transfer_count;
        clock_enable = 1'b1;
        wait_ack_high(16'h0210);
        if (!out_valid || (out_addr !== 4'd4))
            fail($sformatf("restart first address expected=4 got=%0d valid=%b", out_addr, out_valid));

        @(negedge clk);
        src_req_async[4] = 1'b0;
        src_req_async[9] = 1'b0;
        out_ready = 1'b1;
        wait_ack_low(16'h0210);

        waited = 0;
        while (((transfer_count - base_transfer_count) < 2) && (waited < 40)) begin
            @(posedge clk);
            #1;
            waited = waited + 1;
        end
        if ((transfer_count - base_transfer_count) != 2)
            fail($sformatf("restart transfer count expected=2 got=%0d", transfer_count - base_transfer_count));
        else begin
            if (transfer_log[base_transfer_count] !== 4'd4)
                fail($sformatf("restart transfer[0] expected=4 got=%0d", transfer_log[base_transfer_count]));
            if (transfer_log[base_transfer_count + 1] !== 4'd9)
                fail($sformatf("restart transfer[1] expected=9 got=%0d", transfer_log[base_transfer_count + 1]));
        end

        $display("METRIC p8_dgscr_clockless_reset_checks=4");
        $display("METRIC p8_dgscr_restart_transfers=%0d", transfer_count - base_transfer_count);
        $display("METRIC p8_dgscr_reset_errors=%0d", errors);
        if (errors == 0)
            $display("P8_DGSCR_RESET_TEST_PASS");
        else
            $display("P8_DGSCR_RESET_TEST_FAIL");
        #20;
        $finish;
    end

    initial begin
        #20000;
        fail("global watchdog expired");
        $display("P8_DGSCR_RESET_TEST_FAIL");
        $finish;
    end
endmodule
