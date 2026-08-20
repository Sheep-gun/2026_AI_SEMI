`timescale 1ns/1ps

// Randomized lockstep comparison against the frozen P8-DG-SCR reference.
// In addition to external pins, architecturally relevant internal state is
// compared after every active clock.  Asynchronous reset assertion is also
// checked while the clock is stopped from advancing the tested state.
module aer_p9_cycle_equivalence_tb;
    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [15:0] src_req_async = '0;
    logic out_ready = 1'b0;

    logic [15:0] ref_ack, oht_ack, lr_ack, ohd_ack;
    logic [3:0] ref_addr, oht_addr, lr_addr, ohd_addr;
    logic ref_valid, oht_valid, lr_valid, ohd_valid;
    logic [31:0] stimulus_lfsr = 32'hc001d00d;
    integer cycles = 0;
    integer errors = 0;

    aer_pending_direct_gray_sync_core_reset ref_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(ref_ack), .out_addr(ref_addr),
        .out_valid(ref_valid), .out_ready(out_ready)
    );
    aer_pending_direct_gray_scr_onehot_tree oht_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(oht_ack), .out_addr(oht_addr),
        .out_valid(oht_valid), .out_ready(out_ready)
    );
    aer_pending_direct_gray_scr_loop_reduce lr_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(lr_ack), .out_addr(lr_addr),
        .out_valid(lr_valid), .out_ready(out_ready)
    );
    aer_pending_direct_gray_scr_onehot_decode ohd_dut (
        .clk(clk), .rst_n(rst_n), .src_req_async(src_req_async),
        .src_ack_async(ohd_ack), .out_addr(ohd_addr),
        .out_valid(ohd_valid), .out_ready(out_ready)
    );

    always #5 clk = ~clk;

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            if (errors <= 20)
                $display("P9_EQ_ASSERT_FAIL cycle=%0d message=%s", cycles, message);
        end
    endtask

    task automatic compare_candidate(input integer which);
        logic [15:0] candidate_ack;
        logic [3:0] candidate_addr;
        logic candidate_valid;
        begin
            case (which)
                0: begin candidate_ack=oht_ack; candidate_addr=oht_addr; candidate_valid=oht_valid; end
                1: begin candidate_ack=lr_ack; candidate_addr=lr_addr; candidate_valid=lr_valid; end
                default: begin candidate_ack=ohd_ack; candidate_addr=ohd_addr; candidate_valid=ohd_valid; end
            endcase
            if (candidate_ack !== ref_ack)
                fail($sformatf("candidate=%0d ACK ref=%04h got=%04h", which, ref_ack, candidate_ack));
            if (candidate_valid !== ref_valid)
                fail($sformatf("candidate=%0d valid ref=%b got=%b", which, ref_valid, candidate_valid));
            if (ref_valid && (candidate_addr !== ref_addr))
                fail($sformatf("candidate=%0d addr ref=%0d got=%0d", which, ref_addr, candidate_addr));
        end
    endtask

    always @(posedge clk) begin
        #1;
        cycles = cycles + 1;
        compare_candidate(0);
        compare_candidate(1);
        compare_candidate(2);

        if (oht_dut.pending_q !== ref_dut.pending_q ||
            oht_dut.epoch_gray_q !== ref_dut.epoch_gray_q ||
            oht_dut.out_valid_q !== ref_dut.out_valid_q)
            fail("onehot-tree internal state differs");
        if (lr_dut.pending_q !== ref_dut.pending_q ||
            lr_dut.epoch_gray_q !== ref_dut.epoch_gray_q ||
            lr_dut.out_valid_q !== ref_dut.out_valid_q)
            fail("loop-reduce internal state differs");
        if (ohd_dut.pending_q !== ref_dut.pending_q ||
            ohd_dut.epoch_gray_q !== ref_dut.epoch_gray_q ||
            ohd_dut.out_valid_q !== ref_dut.out_valid_q)
            fail("onehot-decode internal state differs");
    end

    // Change both asynchronous requests and backpressure away from clock edges.
    always #7 begin
        stimulus_lfsr = {stimulus_lfsr[30:0],
            stimulus_lfsr[31] ^ stimulus_lfsr[21] ^
            stimulus_lfsr[1] ^ stimulus_lfsr[0]};
        if (rst_n) begin
            src_req_async = src_req_async ^ stimulus_lfsr[15:0];
            out_ready = stimulus_lfsr[20] | stimulus_lfsr[7];
        end
    end

    initial begin
        repeat (4) @(negedge clk);
        rst_n = 1'b1;
        repeat (1800) @(negedge clk);

        // Exercise clock-independent safe-low assertion with active traffic.
        #2 rst_n = 1'b0;
        #1;
        if ({ref_ack, oht_ack, lr_ack, ohd_ack} !== '0)
            fail("asynchronous reset did not isolate ACK low");
        if ({ref_valid, oht_valid, lr_valid, ohd_valid} !== '0)
            fail("asynchronous reset did not isolate valid low");
        src_req_async = 16'ha55a;
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        repeat (2200) @(negedge clk);

        $display("METRIC p9_cycle_equivalence_cycles=%0d", cycles);
        $display("METRIC p9_cycle_equivalence_candidates=3");
        $display("METRIC p9_cycle_equivalence_errors=%0d", errors);
        if (errors == 0)
            $display("P9_CYCLE_EQUIVALENCE_PASS");
        else
            $display("P9_CYCLE_EQUIVALENCE_FAIL");
        $finish;
    end

    initial begin
        #100000;
        fail("global watchdog expired");
        $display("P9_CYCLE_EQUIVALENCE_FAIL");
        $finish;
    end
endmodule
