`timescale 1ns/1ps

// Frozen verification wrapper: the robust reset implementation is intentional.
module aer_pending_gray_epoch_frozen_wrapper (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    aer_pending_gray_epoch #(.ROBUST_RESET(1'b1)) implementation (
        .clk(clk),
        .rst_n(rst_n),
        .src_req_async(src_req_async),
        .src_ack_async(src_ack_async),
        .out_addr(out_addr),
        .out_valid(out_valid),
        .out_ready(out_ready)
    );
endmodule
