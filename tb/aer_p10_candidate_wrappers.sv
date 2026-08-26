`timescale 1ns/1ps
module aer_p10_candidate_impl(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
`ifdef P10_IPRRA
    aer_pending_gray_rank_iprra_sync_core_reset implementation(.*);
`elsif P10_XOR1
    aer_pending_xor1_rank_reuse_sync_core_reset implementation(.*);
`else
    aer_pending_xor2_rank_reuse_sync_core_reset implementation(.*);
`endif
endmodule

module aer_source_resident_dut(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);aer_p10_candidate_impl implementation(.*);endmodule

module aer_improved_hybrid#(parameter integer NUM_SOURCES=16,ADDR_W=4)(
    input logic clk,input logic rst_n,input logic [NUM_SOURCES-1:0] src_req_async,
    output logic [NUM_SOURCES-1:0] src_ack_async,
    output logic [ADDR_W-1:0] out_addr,output logic out_valid,input logic out_ready
);aer_p10_candidate_impl implementation(.*);endmodule

module aer_p8_dgscr_dut(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);aer_p10_candidate_impl implementation(.*);endmodule

module aer_contract_fairness_dut(
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);aer_p10_candidate_impl u_dut(.*);endmodule

module aer_p10_selector_probe(
    input logic[15:0]rank_candidate,input logic[3:0]last_rank,
    output logic grant_valid,output logic[3:0]grant_rank
);
`ifdef P10_IPRRA
    aer_rank_iprra_ring_selector16 selector(.*);
`else
    aer_rank_grouped_ring_selector16 selector(.*);
`endif
endmodule
