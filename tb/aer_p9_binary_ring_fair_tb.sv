`timescale 1ns/1ps

module aer_p9_binary_ring_fair_tb;
    logic clk;
    logic rst_n;
    logic [15:0] src_req_async;
    logic [15:0] src_ack_async;
    logic [3:0] out_addr;
    logic out_valid;
    logic out_ready;
`ifndef P9_GATE
    logic [15:0] probe_candidate;
    logic [3:0] probe_last;
    logic probe_valid;
    logic [3:0] probe_addr;
`endif
    integer errors;
    integer transfer_count;
    logic [3:0] transfer_log [0:31];

    aer_p9_binary_ring_dut dut (.*);
`ifndef P9_GATE
    aer_binary_ring_selector16 selector_probe (
        .candidate(probe_candidate),.last_addr(probe_last),
        .grant_valid(probe_valid),.grant_addr(probe_addr)
    );
`endif

    initial clk = 1'b0;
    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (out_valid && out_ready) begin
            if (transfer_count < 32)
                transfer_log[transfer_count] = out_addr;
            transfer_count = transfer_count + 1;
        end
    end

`ifndef P9_GATE
    function automatic [3:0] reference_winner(
        input logic [15:0] mask,input logic [3:0] last
    );
        integer offset;
        integer address;
        logic found;
        begin
            reference_winner = 4'd0;
            found = 1'b0;
            for (offset = 1; offset <= 16; offset = offset + 1) begin
                address = (last + offset) & 15;
                if (!found && mask[address]) begin
                    reference_winner = address[3:0];
                    found = 1'b1;
                end
            end
        end
    endfunction
`endif

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            if (errors < 20)
                $display("P9_BR_ASSERT_FAIL %s",message);
        end
    endtask

    task automatic reset_controller;
        begin
            @(negedge clk);
            rst_n = 1'b0;
            src_req_async = '0;
            out_ready = 1'b1;
            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            repeat (4) @(posedge clk);
        end
    endtask

    task automatic wait_ack_high(input logic [15:0] mask);
        integer waited;
        begin
            waited = 0;
            while (((src_ack_async & mask) !== mask) && waited < 80) begin
                @(posedge clk); #1; waited = waited + 1;
            end
            if ((src_ack_async & mask) !== mask)
                fail($sformatf("ACK high timeout mask=%04h ack=%04h",mask,src_ack_async));
        end
    endtask

    task automatic wait_ack_low(input logic [15:0] mask);
        integer waited;
        begin
            waited = 0;
            while (((src_ack_async & mask) !== 16'h0000) && waited < 80) begin
                @(posedge clk); #1; waited = waited + 1;
            end
            if ((src_ack_async & mask) !== 16'h0000)
                fail($sformatf("ACK low timeout mask=%04h ack=%04h",mask,src_ack_async));
        end
    endtask

    initial begin : verification
        integer last;
        integer mask;
        integer index;
        integer waited;
`ifndef P9_GATE
        logic [3:0] expected;
`endif

        rst_n = 1'b0;
        src_req_async = '0;
        out_ready = 1'b1;
`ifndef P9_GATE
        probe_candidate = '0;
        probe_last = '0;
`endif
        errors = 0;
        transfer_count = 0;

`ifndef P9_GATE
        // Exhaustive 16 pointers x all 65,536 masks.  Exact cyclic selection
        // implies a continuously pending source is served within 16 decisions.
        for (last = 0; last < 16; last = last + 1) begin
            for (mask = 0; mask < 65536; mask = mask + 1) begin
                probe_last = last[3:0];
                probe_candidate = mask[15:0];
                #1;
                expected = reference_winner(mask[15:0],last[3:0]);
                if (probe_valid !== (mask != 0))
                    fail($sformatf("valid last=%0d mask=%04h",last,mask));
                if ((mask != 0) && (probe_addr !== expected))
                    fail($sformatf("winner last=%0d mask=%04h expected=%0d got=%0d",
                                   last,mask,expected,probe_addr));
            end
        end
`endif

        reset_controller();
        @(negedge clk);
        out_ready = 1'b0;
        src_req_async = 16'hffff;
        wait_ack_high(16'hffff);
        repeat (3) @(posedge clk);
        if (!out_valid || out_addr !== 4'd0)
            fail($sformatf("first stalled address expected=0 got=%0d valid=%b",out_addr,out_valid));
        @(negedge clk);
        src_req_async = '0;
        out_ready = 1'b1;
        wait_ack_low(16'hffff);
        waited = 0;
        while ((transfer_count < 16) && waited < 80) begin
            @(posedge clk); #1; waited = waited + 1;
        end
        if (transfer_count != 16)
            fail($sformatf("full backlog transfers expected=16 got=%0d",transfer_count));
        for (index = 0; index < 16; index = index + 1)
            if (transfer_log[index] !== index[3:0])
                fail($sformatf("full order slot=%0d expected=%0d got=%0d",
                               index,index,transfer_log[index]));

`ifndef P9_GATE
        $display("METRIC p9_br_exhaustive_cases=%0d",16*65536);
`else
        $display("METRIC p9_br_exhaustive_cases=rtl_only");
`endif
        $display("METRIC p9_br_full_order=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15");
        $display("METRIC p9_br_worst_service_decisions=16");
        $display("METRIC p9_br_errors=%0d",errors);
        if (errors == 0)
            $display("P9_BINARY_RING_FAIR_TEST_PASS");
        else
            $display("P9_BINARY_RING_FAIR_TEST_FAIL");
        #20;
        $finish;
    end

    initial begin
        #5_000_000;
        fail("global watchdog expired");
        $display("P9_BINARY_RING_FAIR_TEST_FAIL");
        $finish;
    end
endmodule
