`timescale 1ns/1ps

// P9-GRR-OHD: P9-GRR with an explicit one-hot consume vector.  The cyclic
// selector still returns the four-bit rank needed by the output state, but the
// pending feedback uses an ordinary vector mask instead of a procedural
// variable-index assignment.  This exposes decoder/consume sharing to ASIC
// synthesis while preserving the 71-bit architecture.
module aer_pending_gray_rank_reuse_onehot_decode (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [15:0] src_req_async,
    output logic [15:0] src_ack_async,
    output logic [3:0]  out_addr,
    output logic        out_valid,
    input  logic        out_ready
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] reset_release_q;
    logic core_rst_n;
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)reset_release_q<=2'b00;
        else reset_release_q<={reset_release_q[0],1'b1};
    end
    assign core_rst_n=reset_release_q[1];

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q,req_sync_q;
    logic [15:0] req_rank;
    logic [15:0] ack_rank_q,ack_rank_d,ack_source;
    logic [15:0] pending_rank_q,pending_rank_d;
    logic [15:0] accept_rank,accepted_pending_rank,grant_onehot;
    logic [3:0] out_rank_q,out_rank_d,selected_rank;
    logic out_valid_q,out_valid_d,grant_valid,can_load_output;

    assign req_rank={req_sync_q[8],req_sync_q[9],req_sync_q[11],req_sync_q[10],
                     req_sync_q[14],req_sync_q[15],req_sync_q[13],req_sync_q[12],
                     req_sync_q[4],req_sync_q[5],req_sync_q[7],req_sync_q[6],
                     req_sync_q[2],req_sync_q[3],req_sync_q[1],req_sync_q[0]};
    assign ack_source={ack_rank_q[10],ack_rank_q[11],ack_rank_q[9],ack_rank_q[8],
                       ack_rank_q[13],ack_rank_q[12],ack_rank_q[14],ack_rank_q[15],
                       ack_rank_q[5],ack_rank_q[4],ack_rank_q[6],ack_rank_q[7],
                       ack_rank_q[2],ack_rank_q[3],ack_rank_q[1],ack_rank_q[0]};

    assign accept_rank=req_rank&~ack_rank_q&~pending_rank_q;
    assign accepted_pending_rank=pending_rank_q|accept_rank;
    assign ack_rank_d=(ack_rank_q&req_rank)|accept_rank;
    assign can_load_output=!out_valid_q||out_ready;

    aer_gray_rank_ring_selector16 selector(
        .rank_candidate(accepted_pending_rank),.last_rank(out_rank_q),
        .grant_valid(grant_valid),.grant_rank(selected_rank));

    always_comb begin
        grant_onehot=(grant_valid&&can_load_output)?
                     (16'h0001<<selected_rank):16'h0000;
        pending_rank_d=accepted_pending_rank&~grant_onehot;
        out_rank_d=out_rank_q;
        out_valid_d=out_valid_q;
        if(can_load_output)begin
            if(grant_valid)begin
                out_valid_d=1'b1;
                out_rank_d=selected_rank;
            end else out_valid_d=1'b0;
        end
    end

    always_ff @(posedge clk)begin
        req_meta_q<=src_req_async;
        req_sync_q<=req_meta_q;
    end
    always_ff @(posedge clk)begin
        if(!core_rst_n)begin
            ack_rank_q<='0;pending_rank_q<='0;out_rank_q<=4'hf;out_valid_q<=1'b0;
        end else begin
            ack_rank_q<=ack_rank_d;pending_rank_q<=pending_rank_d;
            out_rank_q<=out_rank_d;out_valid_q<=out_valid_d;
        end
    end
    assign src_ack_async=ack_source&{16{core_rst_n}};
    assign out_addr=out_rank_q^(out_rank_q>>1);
    assign out_valid=out_valid_q&core_rst_n;
endmodule
