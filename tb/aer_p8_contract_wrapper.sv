`timescale 1ns/1ps

module aer_contract_fairness_dut (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
`ifdef P8_CONTRACT_DIRECT_GRAY_SHARED_TREE
    aer_pending_direct_gray_shared_tree u_dut (.*);
`elsif P8_CONTRACT_DIRECT_GRAY_SPLIT_RESET
    aer_pending_direct_gray_split_reset u_dut (.*);
`elsif P8_CONTRACT_DIRECT_GRAY_SYNC_CORE_RESET
    aer_pending_direct_gray_sync_core_reset u_dut (.*);
`elsif P8_CONTRACT_XOR2
    aer_pending_xor2_sparse_reset u_dut (.*);
`elsif P8_CONTRACT_GRAY_RING
    aer_pending_gray_ring_sparse_reset u_dut (.*);
`elsif P8_CONTRACT_DIRECT_GRAY
    aer_pending_direct_gray_sparse_reset u_dut (.*);
`else
    aer_pending_gray_epoch_sparse_reset u_dut (.*);
`endif
endmodule
