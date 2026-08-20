`timescale 1ns/1ps

module aer_p9_epoch_selected_dut (
    input logic clk, input logic rst_n, input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async, output logic [3:0] out_addr,
    output logic out_valid, input logic out_ready
);
`ifdef P9_EPOCH_BOOLEAN
    aer_pending_direct_gray_oht_epoch_boolean implementation (.*);
`elsif P9_EPOCH_GRANT_TOGGLE
    aer_pending_direct_gray_oht_epoch_grant_toggle implementation (.*);
`else
    aer_pending_direct_gray_oht_epoch_case implementation (.*);
`endif
endmodule

module aer_source_resident_dut (
    input logic clk, input logic rst_n, input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async, output logic [3:0] out_addr,
    output logic out_valid, input logic out_ready
);
    aer_p9_epoch_selected_dut implementation (.*);
endmodule

module aer_pending_gray_epoch_frozen_wrapper (
    input logic clk, input logic rst_n, input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async, output logic [3:0] out_addr,
    output logic out_valid, input logic out_ready
);
    aer_p9_epoch_selected_dut implementation (.*);
endmodule

module aer_improved_hybrid #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = 4
) (
    input logic clk, input logic rst_n,
    input logic [NUM_SOURCES-1:0] src_req_async,
    output logic [NUM_SOURCES-1:0] src_ack_async,
    output logic [ADDR_W-1:0] out_addr,
    output logic out_valid, input logic out_ready
);
    aer_p9_epoch_selected_dut implementation (.*);
endmodule

module aer_p8_dgscr_dut (
    input logic clk, input logic rst_n, input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async, output logic [3:0] out_addr,
    output logic out_valid, input logic out_ready
);
    aer_p9_epoch_selected_dut implementation (.*);
endmodule

module aer_contract_fairness_dut (
    input logic clk, input logic rst_n, input logic [15:0] src_req_async,
    output logic [15:0] src_ack_async, output logic [3:0] out_addr,
    output logic out_valid, input logic out_ready
);
    aer_p9_epoch_selected_dut implementation (.*);
endmodule
