`timescale 1ns/1ps

// Adapter for the frozen traditional asynchronous protocol testbench.
module aer_traditional_async #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  wire                   rst_n,
    input  wire [NUM_SOURCES-1:0] src_req,
    output wire [NUM_SOURCES-1:0] src_ack,
    output wire [ADDR_W-1:0]      aer_addr,
    output wire                   aer_req,
    input  wire                   aer_ack
);
    aer_traditional_latch_paa #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W(ADDR_W)
    ) implementation (
        .rst_n(rst_n),
        .src_req(src_req),
        .src_ack(src_ack),
        .aer_addr(aer_addr),
        .aer_req(aer_req),
        .aer_ack(aer_ack)
    );
endmodule
