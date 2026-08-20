`timescale 1ns/1ps

module aer_contract_fairness_dut (
    input logic clk,input logic rst_n,input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,output logic [3:0] out_addr,
    output logic out_valid,input logic out_ready
);
    aer_pending_binary_ring_sync_core_reset u_dut (.*);
endmodule
