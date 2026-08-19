`timescale 1ns/1ps

// Verify both round-robin levels with one pending event from every source.
module aer_improved_hierarchical_order_tb;
    localparam integer NUM_SOURCES = 16;
    localparam integer ADDR_W = 4;

    logic clk;
    logic rst_n;
    logic [NUM_SOURCES-1:0] src_req_async;
    logic [NUM_SOURCES-1:0] src_ack_async;
    logic [ADDR_W-1:0] out_addr;
    logic out_valid;
    logic out_ready;
    integer received;
    integer errors;
    integer expected_addr;
    integer timeout_cycles;

`ifdef P2_GATE_NETLIST
    aer_improved_hierarchical dut (
`else
    aer_improved_hierarchical #(
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
    always #5 clk = ~clk;

    always @(posedge clk) begin
        #0.001;
        if (rst_n && out_valid && out_ready) begin
            if (received >= NUM_SOURCES) begin
                errors = errors + 1;
                $display("ORDER_ASSERT_FAIL duplicate_output addr=%0d", out_addr);
            end else begin
                // Reset pointers produce group order 0,1,2,3 while each
                // group's local pointer advances 0,1,2,3.
                expected_addr = ((received % 4) * 4) + (received / 4);
                if (out_addr !== expected_addr[ADDR_W-1:0]) begin
                    errors = errors + 1;
                    $display("ORDER_ASSERT_FAIL index=%0d expected=%0d observed=%0d",
                             received, expected_addr, out_addr);
                end
            end
            received = received + 1;
        end
    end

    initial begin
        rst_n = 1'b0;
        src_req_async = '0;
        out_ready = 1'b1;
        received = 0;
        errors = 0;
        expected_addr = 0;
        timeout_cycles = 0;

        #120;
        @(negedge clk);
        rst_n = 1'b1;
        repeat (3) @(posedge clk);
        @(negedge clk);
        src_req_async = '1;

        while ((src_ack_async !== {NUM_SOURCES{1'b1}}) && (timeout_cycles < 20)) begin
            @(posedge clk);
            timeout_cycles = timeout_cycles + 1;
        end
        if (src_ack_async !== {NUM_SOURCES{1'b1}}) begin
            errors = errors + 1;
            $display("ORDER_ASSERT_FAIL not_all_sources_acknowledged");
        end

        @(negedge clk);
        src_req_async = '0;

        timeout_cycles = 0;
        while ((received < NUM_SOURCES) && (timeout_cycles < 40)) begin
            @(posedge clk);
            timeout_cycles = timeout_cycles + 1;
        end
        repeat (5) @(posedge clk);

        $display("METRIC p2_order_events=%0d", received);
        $display("METRIC p2_order_errors=%0d", errors);
        if ((received == NUM_SOURCES) && (errors == 0))
            $display("P2_ORDER_TEST_PASS events=%0d", received);
        else
            $display("P2_ORDER_TEST_FAIL events=%0d errors=%0d", received, errors);
        $finish;
    end
endmodule

