`timescale 1ns/1ps

// Compile with P8_DIRECT_GRAY for P8-DG; the default selects P8-SR.
`ifdef P8_DIRECT_GRAY
    `define P8_IMPLEMENTATION aer_pending_direct_gray_sparse_reset
`else
    `define P8_IMPLEMENTATION aer_pending_gray_epoch_sparse_reset
`endif

module aer_source_resident_dut (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    `P8_IMPLEMENTATION implementation (.*);
endmodule

module aer_pending_gray_epoch_frozen_wrapper (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    `P8_IMPLEMENTATION implementation (.*);
endmodule

module aer_improved_hybrid #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = 4
) (
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [NUM_SOURCES-1:0] src_req_async,
    output logic [NUM_SOURCES-1:0] src_ack_async,
    output logic [ADDR_W-1:0]      out_addr,
    output logic                   out_valid,
    input  logic                   out_ready
);
    `P8_IMPLEMENTATION implementation (.*);
endmodule

`undef P8_IMPLEMENTATION
