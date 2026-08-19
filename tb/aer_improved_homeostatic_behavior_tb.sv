`timescale 1ns/1ps

module aer_improved_homeostatic_behavior_tb;
    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = 4;

    logic clk;
    logic rst_n;
    logic [NUM_SOURCES-1:0] src_req_async;
    logic [NUM_SOURCES-1:0] src_ack_async;
    logic [ADDR_W-1:0] out_addr;
    logic out_valid;
    logic out_ready;

    integer errors;
    integer received;
    integer output_order [0:7];
    integer ack_cycle;
    integer valid_cycle;
    integer cycle_count;

    aer_improved_homeostatic dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic fail(input string message);
        begin
            errors = errors + 1;
            $display("P4_ASSERT_FAIL cycle=%0d message=%s", cycle_count, message);
        end
    endtask

    task automatic reset_dut;
        begin
            rst_n = 1'b0;
            src_req_async = '0;
            out_ready = 1'b1;
            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;
            repeat (3) @(posedge clk);
        end
    endtask

    task automatic issue_and_release(input integer source);
        begin
            src_req_async[source] = 1'b1;
            wait (src_ack_async[source] === 1'b1);
            #1 src_req_async[source] = 1'b0;
            wait (src_ack_async[source] === 1'b0);
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count <= 0;
            received <= 0;
        end else begin
            cycle_count <= cycle_count + 1;
            if (out_valid && out_ready) begin
                output_order[received] = out_addr;
                received <= received + 1;
            end
        end
    end

    initial begin
        integer expected_received;

        errors = 0;
        received = 0;
        cycle_count = 0;
        ack_cycle = -1;
        valid_cycle = -1;
        reset_dut();

        // Cut-through: source acknowledgement and output registration should
        // complete on the same active clock edge when the output is empty.
        $display("TEST_START p4_cut_through");
        @(negedge clk);
        src_req_async[6] = 1'b1;
        wait (src_ack_async[6] === 1'b1);
        #1;
        ack_cycle = cycle_count;
        if (!(out_valid && out_addr == 6))
            fail("fresh event did not cut through to output with acknowledgement");
        valid_cycle = cycle_count;
        src_req_async[6] = 1'b0;
        wait (src_ack_async[6] === 1'b0);
        wait (received == 1);
        if (ack_cycle != valid_cycle)
            fail("ack/output registration were not same-cycle");

        // Reset pointers, hold one event in the output, then create an older
        // pending event in group 1 and a fresh event in group 0. Initial RR
        // would choose group 0; the aged tier must instead choose source 5.
        $display("TEST_START p4_homeostatic_priority");
        reset_dut();
        received = 0;
        out_ready = 1'b0;

        issue_and_release(15);
        wait (out_valid && out_addr == 15);

        issue_and_release(5);
        repeat (2) @(posedge clk);
        if (!(dut.pending_q[5] && dut.group_aged_q[1]))
            fail("source 5 group did not enter aged tier");

        src_req_async[0] = 1'b1;
        wait (src_ack_async[0] === 1'b1);
        #1 src_req_async[0] = 1'b0;
        if (!(dut.pending_q[0] && !dut.group_aged_q[0]))
            fail("source 0 group was not fresh when stall released");

        @(negedge clk);
        out_ready = 1'b1;
        expected_received = 3;
        while (received < expected_received)
            @(posedge clk);
        #1;

        if (output_order[0] != 15)
            fail($sformatf("blocker order mismatch got=%0d", output_order[0]));
        if (output_order[1] != 5)
            fail($sformatf("aged source did not beat fresh RR-favored source got=%0d", output_order[1]));
        if (output_order[2] != 0)
            fail($sformatf("fresh source was lost or reordered got=%0d", output_order[2]));

        $display("METRIC p4_cut_through_ack_to_valid_cycles=%0d", valid_cycle - ack_cycle);
        $display("METRIC p4_homeostatic_order=%0d,%0d,%0d",
                 output_order[0], output_order[1], output_order[2]);
        $display("METRIC p4_behavior_errors=%0d", errors);

        if (errors == 0)
            $display("P4_BEHAVIOR_TEST_PASS");
        else
            $display("P4_BEHAVIOR_TEST_FAIL errors=%0d", errors);

        #20;
        $finish;
    end
endmodule
