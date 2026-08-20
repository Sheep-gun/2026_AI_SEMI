`timescale 1ns/1ps

// Compatibility wrapper for the frozen 192-point digital CDC phase sweep.
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
    aer_pending_gray_epoch implementation (
        .clk(clk),
        .rst_n(rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr(out_addr),
        .out_valid(out_valid),
        .out_ready(out_ready)
    );
endmodule
