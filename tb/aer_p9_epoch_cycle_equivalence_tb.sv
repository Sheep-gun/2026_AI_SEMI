`timescale 1ns/1ps

module aer_p9_epoch_cycle_equivalence_tb;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [15:0] src_req_async = '0;
    logic out_ready = 1'b0;
    logic [31:0] lfsr = 32'h81f0a53c;
    integer cycles = 0;
    integer errors = 0;

    logic [15:0] ref_ack, case_ack, bool_ack, toggle_ack;
    logic [3:0] ref_addr, case_addr, bool_addr, toggle_addr;
    logic ref_valid, case_valid, bool_valid, toggle_valid;

    aer_pending_direct_gray_scr_onehot_tree ref_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(ref_ack), .out_addr(ref_addr),
        .out_valid(ref_valid), .out_ready(out_ready));
    aer_pending_direct_gray_oht_epoch_case case_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(case_ack), .out_addr(case_addr),
        .out_valid(case_valid), .out_ready(out_ready));
    aer_pending_direct_gray_oht_epoch_boolean bool_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(bool_ack), .out_addr(bool_addr),
        .out_valid(bool_valid), .out_ready(out_ready));
    aer_pending_direct_gray_oht_epoch_grant_toggle toggle_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(toggle_ack), .out_addr(toggle_addr),
        .out_valid(toggle_valid), .out_ready(out_ready));

    always #5 clk = ~clk;

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            if (errors <= 20)
                $display("P9_EPOCH_EQ_ASSERT_FAIL cycle=%0d message=%s", cycles, message);
        end
    endtask

    always @(posedge clk) begin
        #1;
        cycles = cycles + 1;
        if ({case_ack, bool_ack, toggle_ack} !== {3{ref_ack}})
            fail("ACK differs from P9-OHT");
        if ({case_valid, bool_valid, toggle_valid} !== {3{ref_valid}})
            fail("valid differs from P9-OHT");
        if (ref_valid && ((case_addr !== ref_addr) ||
            (bool_addr !== ref_addr) || (toggle_addr !== ref_addr)))
            fail("address differs from P9-OHT");
        if ((case_dut.core.pending_q !== ref_dut.pending_q) ||
            (bool_dut.core.pending_q !== ref_dut.pending_q) ||
            (toggle_dut.core.pending_q !== ref_dut.pending_q))
            fail("pending state differs from P9-OHT");
        if ((case_dut.core.epoch_gray_q !== ref_dut.epoch_gray_q) ||
            (bool_dut.core.epoch_gray_q !== ref_dut.epoch_gray_q) ||
            (toggle_dut.core.epoch_gray_q !== ref_dut.epoch_gray_q))
            fail("epoch state differs from P9-OHT");
    end

    always #7 begin
        lfsr = {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
        if (rst_n) begin
            src_req_async = src_req_async ^ lfsr[15:0];
            out_ready = lfsr[19] | lfsr[3];
        end
    end

    initial begin
        repeat (4) @(negedge clk);
        rst_n = 1'b1;
        repeat (1900) @(negedge clk);
        #2 rst_n = 1'b0;
        #1;
        if ({ref_ack, case_ack, bool_ack, toggle_ack} !== '0)
            fail("asynchronous reset ACK isolation differs");
        if ({ref_valid, case_valid, bool_valid, toggle_valid} !== '0)
            fail("asynchronous reset valid isolation differs");
        src_req_async = 16'h6996;
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        repeat (2100) @(negedge clk);

        $display("METRIC p9_epoch_equivalence_cycles=%0d", cycles);
        $display("METRIC p9_epoch_equivalence_variants=3");
        $display("METRIC p9_epoch_equivalence_errors=%0d", errors);
        if (errors == 0)
            $display("P9_EPOCH_CYCLE_EQUIVALENCE_PASS");
        else
            $display("P9_EPOCH_CYCLE_EQUIVALENCE_FAIL");
        $finish;
    end

    initial begin
        #100000;
        fail("global watchdog expired");
        $display("P9_EPOCH_CYCLE_EQUIVALENCE_FAIL");
        $finish;
    end
endmodule
