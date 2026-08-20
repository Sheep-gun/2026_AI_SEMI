`timescale 1ns/1ps

// P9-GRR-OI: power-oriented variant of P9-GRR.
//
// ACK and pending capture remain active during receiver backpressure.  Only
// the arbitration cone is operand-isolated because its result cannot be used
// while a valid output is stalled.  The same isolation also keeps the selector
// quiet while core reset is asserted.  Storage and service policy are exactly
// the same as P9-GRR: 71 FF and strict reflected-Gray cyclic fairness.
module aer_pending_gray_rank_reuse_operand_isolated (
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
        if (!rst_n)
            reset_release_q <= 2'b00;
        else
            reset_release_q <= {reset_release_q[0],1'b1};
    end
    assign core_rst_n = reset_release_q[1];

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q,req_sync_q;
    logic [15:0] req_rank;
    logic [15:0] ack_rank_q,ack_rank_d;
    logic [15:0] pending_rank_q,pending_rank_d;
    logic [15:0] accept_rank,accepted_pending_rank;
    logic [15:0] scheduler_candidate;
    logic [15:0] ack_source;
    logic [3:0] out_rank_q,out_rank_d,selected_rank;
    logic out_valid_q,out_valid_d;
    logic grant_valid;
    logic can_load_output,scheduler_enable;

    // Fixed rank/source permutations are wiring, not logic gates.
    always_comb begin
        req_rank[0]=req_sync_q[0];
        req_rank[1]=req_sync_q[1];
        req_rank[2]=req_sync_q[3];
        req_rank[3]=req_sync_q[2];
        req_rank[4]=req_sync_q[6];
        req_rank[5]=req_sync_q[7];
        req_rank[6]=req_sync_q[5];
        req_rank[7]=req_sync_q[4];
        req_rank[8]=req_sync_q[12];
        req_rank[9]=req_sync_q[13];
        req_rank[10]=req_sync_q[15];
        req_rank[11]=req_sync_q[14];
        req_rank[12]=req_sync_q[10];
        req_rank[13]=req_sync_q[11];
        req_rank[14]=req_sync_q[9];
        req_rank[15]=req_sync_q[8];

        ack_source[0]=ack_rank_q[0];
        ack_source[1]=ack_rank_q[1];
        ack_source[2]=ack_rank_q[3];
        ack_source[3]=ack_rank_q[2];
        ack_source[4]=ack_rank_q[7];
        ack_source[5]=ack_rank_q[6];
        ack_source[6]=ack_rank_q[4];
        ack_source[7]=ack_rank_q[5];
        ack_source[8]=ack_rank_q[15];
        ack_source[9]=ack_rank_q[14];
        ack_source[10]=ack_rank_q[12];
        ack_source[11]=ack_rank_q[13];
        ack_source[12]=ack_rank_q[8];
        ack_source[13]=ack_rank_q[9];
        ack_source[14]=ack_rank_q[11];
        ack_source[15]=ack_rank_q[10];
    end

    assign accept_rank = req_rank & ~ack_rank_q & ~pending_rank_q;
    assign accepted_pending_rank = pending_rank_q | accept_rank;
    assign ack_rank_d = (ack_rank_q & req_rank) | accept_rank;

    assign can_load_output = !out_valid_q || out_ready;
    assign scheduler_enable = core_rst_n && can_load_output;
    assign scheduler_candidate = accepted_pending_rank &
                                 {16{scheduler_enable}};

    aer_gray_rank_ring_selector16 selector (
        .rank_candidate(scheduler_candidate),
        .last_rank(out_rank_q),
        .grant_valid(grant_valid),
        .grant_rank(selected_rank)
    );

    always_comb begin
        pending_rank_d = accepted_pending_rank;
        out_rank_d = out_rank_q;
        out_valid_d = out_valid_q;

        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d = 1'b1;
                out_rank_d = selected_rank;
                pending_rank_d[selected_rank] = 1'b0;
            end else begin
                out_valid_d = 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        req_meta_q <= src_req_async;
        req_sync_q <= req_meta_q;
    end

    always_ff @(posedge clk) begin
        if (!core_rst_n) begin
            ack_rank_q <= '0;
            pending_rank_q <= '0;
            out_rank_q <= 4'hf;
            out_valid_q <= 1'b0;
        end else begin
            ack_rank_q <= ack_rank_d;
            pending_rank_q <= pending_rank_d;
            out_rank_q <= out_rank_d;
            out_valid_q <= out_valid_d;
        end
    end

    assign src_ack_async = ack_source & {16{core_rst_n}};
    assign out_addr = out_rank_q ^ (out_rank_q >> 1);
    assign out_valid = out_valid_q & core_rst_n;
endmodule
