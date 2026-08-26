`timescale 1ns/1ps

// GPDK45/GSCLIB045 port of T0-PPA.
// GSCLIB045 provides characterized TLATX1 latches and DLY4X1 delay cells but
// no resettable transparent latch. Reset is therefore implemented by opening
// each latch with D=0 while rst_n is low, and the externally visible protocol
// outputs are isolated by rst_n. The traditional fixed-priority/no-pending/
// clockless contract and bundled-data delay chain remain unchanged.
module aer_traditional_latch_paa_45nm #(
    parameter integer NUM_SOURCES=16,
    parameter integer ADDR_W=(NUM_SOURCES<=1)?1:$clog2(NUM_SOURCES)
)(
    input  wire                   rst_n,
    input  wire [NUM_SOURCES-1:0] src_req,
    output wire [NUM_SOURCES-1:0] src_ack,
    output wire [ADDR_W-1:0]      aer_addr,
    output wire                   aer_req,
    input  wire                   aer_ack
);
    localparam integer IDX_W=(NUM_SOURCES<=1)?1:$clog2(NUM_SOURCES);
    reg [IDX_W-1:0]priority_idx;
    reg priority_valid;
    wire[IDX_W-1:0]grant_q;
    wire[NUM_SOURCES-1:0]grant_onehot;
    wire busy_q,selected_req,capture_raw;
    wire capture_delay_1,capture_delay_2,capture_delay_3,capture_delay_4,capture_delay_5;
    wire busy_launch_delay,release_busy,busy_gate;
    integer i;

    always @* begin
        priority_idx='0;priority_valid=1'b0;
        for(i=0;i<NUM_SOURCES;i=i+1)begin
            if(!priority_valid&&src_req[i])begin
                priority_idx=i[IDX_W-1:0];priority_valid=1'b1;
            end
        end
    end

    genvar bit_index;
    generate
        for(bit_index=0;bit_index<IDX_W;bit_index=bit_index+1)begin:g_grant_latch
            (* dont_touch="true" *) TLATX1 grant_latch(
                .D(rst_n?priority_idx[bit_index]:1'b0),
                .G((~busy_q)|(~rst_n)),.Q(grant_q[bit_index]),.QN());
        end
    endgenerate

    assign capture_raw=priority_valid&~busy_q&~aer_ack&rst_n;
    (* dont_touch="true" *) DLY4X1 capture_delay_cell_1(.A(capture_raw),.Y(capture_delay_1));
    (* dont_touch="true" *) DLY4X1 capture_delay_cell_2(.A(capture_delay_1),.Y(capture_delay_2));
    (* dont_touch="true" *) DLY4X1 capture_delay_cell_3(.A(capture_delay_2),.Y(capture_delay_3));
    (* dont_touch="true" *) DLY4X1 capture_delay_cell_4(.A(capture_delay_3),.Y(capture_delay_4));
    (* dont_touch="true" *) DLY4X1 capture_delay_cell_5(.A(capture_delay_4),.Y(capture_delay_5));
    assign grant_onehot={{(NUM_SOURCES-1){1'b0}},1'b1}<<grant_q;
    assign selected_req=|(src_req&grant_onehot);
    assign release_busy=busy_q&~selected_req&~aer_ack;
    assign busy_gate=(~rst_n)|capture_delay_5|release_busy;
    (* dont_touch="true" *) TLATX1 busy_latch(
        .D(rst_n?capture_delay_5:1'b0),.G(busy_gate),.Q(busy_q),.QN());
    (* dont_touch="true" *) DLY4X1 request_launch_delay_cell(.A(busy_q),.Y(busy_launch_delay));
    assign aer_addr=grant_q;
    assign aer_req=rst_n&busy_q&busy_launch_delay&selected_req;
    assign src_ack=(aer_req&aer_ack)?grant_onehot:'0;
endmodule
