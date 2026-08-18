`timescale 1ns/1ps

// Reuse the frozen asynchronous protocol testbenches without editing their
// manifest-bound source. Compile this wrapper instead of A0-functional RTL.
module aer_traditional_async #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  logic                   rst_n,
    input  logic [NUM_SOURCES-1:0] src_req,
    output logic [NUM_SOURCES-1:0] src_ack,
    output logic [ADDR_W-1:0]      aer_addr,
    output logic                   aer_req,
    input  logic                   aer_ack
);
`ifdef TRAD_STRUCT_GATE_NETLIST
    aer_traditional_structural implementation (
        .rst_n    (rst_n),
        .src_req  (src_req),
        .src_ack  (src_ack),
        .aer_addr (aer_addr),
        .aer_req  (aer_req),
        .aer_ack  (aer_ack)
    );
`else
    aer_traditional_structural #(
        .NUM_SOURCES(NUM_SOURCES),
        .ADDR_W     (ADDR_W)
    ) implementation (
        .rst_n    (rst_n),
        .src_req  (src_req),
        .src_ack  (src_ack),
        .aer_addr (aer_addr),
        .aer_req  (aer_req),
        .aer_ack  (aer_ack)
    );
`endif
endmodule
