`timescale 1ns/1ps

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
    aer_traditional_latch_paa_45nm #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W(ADDR_W)
    ) implementation (.*);
endmodule
