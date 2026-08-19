`timescale 1ns/1ps

// Present P2 under the P1 module name so the frozen P1 workload can be reused.
module aer_improved_hybrid #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [NUM_SOURCES-1:0] src_req_async,
    output logic [NUM_SOURCES-1:0] src_ack_async,
    output logic [ADDR_W-1:0]      out_addr,
    output logic                   out_valid,
    input  logic                   out_ready
);
`ifdef P2_GATE_NETLIST
    aer_improved_hierarchical implementation (
`else
    aer_improved_hierarchical #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W(ADDR_W)
    ) implementation (
`endif
        .clk(clk),
        .rst_n(rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr(out_addr),
        .out_valid(out_valid),
        .out_ready(out_ready)
    );

`ifndef P2_GATE_NETLIST
    // Preserve the queue-overflow assertion in the reused RTL testbench.
    wire [NUM_SOURCES-1:0][1:0] queue_count_q = implementation.queue_count_q;
`endif
endmodule

