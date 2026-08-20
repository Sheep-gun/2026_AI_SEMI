`timescale 1ns/1ps

// Compile exactly one FAIR_DUT_* define.  The common testbench below sees the
// same pins regardless of which controller contract is under evaluation.
module aer_contract_fairness_dut (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
`ifdef FAIR_DUT_P4C
    aer_improved_cutthrough u_dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );
`elsif FAIR_DUT_P6W
    aer_source_resident_wavefront u_dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );
`elsif FAIR_DUT_P6GE
    aer_source_resident_gray_epoch u_dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );
`elsif FAIR_DUT_P7GE
    aer_pending_gray_epoch #(.ROBUST_RESET(1'b1)) u_dut (
        .clk(clk), .rst_n(rst_n),
        .src_req_async(src_req_async), .src_ack_async(src_ack_async),
        .out_addr(out_addr), .out_valid(out_valid), .out_ready(out_ready)
    );
`else
    initial $error("Define FAIR_DUT_P4C, FAIR_DUT_P6W, FAIR_DUT_P6GE, or FAIR_DUT_P7GE");
`endif
endmodule
