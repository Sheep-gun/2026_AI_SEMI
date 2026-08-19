`timescale 1ns/1ps

// P2 timing-oriented AER transport.
//
// The P1 asynchronous source boundary, depth-2 queues and elastic output are
// unchanged.  Only the flat 16-way rotating scan is replaced by a 4x4
// hierarchical round-robin scheduler:
//   1. choose one non-empty group using a group round-robin pointer;
//   2. choose one source inside that group using a per-group pointer.
//
// This implementation is intentionally fixed to the contest configuration of
// 16 sources split into four groups of four.
module aer_improved_hierarchical #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  logic                   clk,
    input  logic                   rst_n,

    input  logic [NUM_SOURCES-1:0] src_req_async,
    output logic [NUM_SOURCES-1:0] src_ack_async,

    output logic [ADDR_W-1:0]      out_addr,
    output logic                   out_valid,
    input  logic                   out_ready
);
    localparam integer NUM_GROUPS = 4;
    localparam integer GROUP_SIZE = 4;
    localparam integer GROUP_W = 2;
    localparam integer LOCAL_W = 2;

    (* ASYNC_REG = "TRUE" *) logic [NUM_SOURCES-1:0] req_meta_q;
    (* ASYNC_REG = "TRUE" *) logic [NUM_SOURCES-1:0] req_sync_q;

    logic [NUM_SOURCES-1:0] ack_q, ack_d;
    logic [NUM_SOURCES-1:0][1:0] queue_count_q;
    logic [NUM_SOURCES-1:0][1:0] queue_count_d;

    logic [GROUP_W-1:0] group_rr_q, group_rr_d;
    logic [NUM_GROUPS-1:0][LOCAL_W-1:0] local_rr_q, local_rr_d;
    logic [NUM_GROUPS-1:0] local_valid;
    logic [NUM_GROUPS-1:0][LOCAL_W-1:0] local_winner;

    logic [ADDR_W-1:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;
    logic group_select_valid;
    logic select_valid;
    logic [GROUP_W-1:0] select_group;
    logic [LOCAL_W-1:0] select_local;
    logic [ADDR_W-1:0] select_idx;

    integer source_comb;
    integer source_ff;
    integer group_iter;
    integer group_offset;
    integer group_candidate;
    integer local_offset;
    integer local_candidate;
    integer source_candidate;

    always_comb begin
        ack_d = ack_q;
        group_rr_d = group_rr_q;
        local_rr_d = local_rr_q;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;
        local_valid = '0;
        local_winner = local_rr_q;

        for (source_comb = 0; source_comb < NUM_SOURCES; source_comb = source_comb + 1)
            queue_count_d[source_comb] = queue_count_q[source_comb];

        // Compute all four local winners in parallel. The global arbiter below
        // only selects among these registered-queue-derived candidates, rather
        // than placing a second scan after the group decision.
        for (group_iter = 0; group_iter < NUM_GROUPS;
             group_iter = group_iter + 1) begin
            for (local_offset = 0; local_offset < GROUP_SIZE;
                 local_offset = local_offset + 1) begin
                local_candidate = local_rr_q[group_iter] + local_offset;
                if (local_candidate >= GROUP_SIZE)
                    local_candidate = local_candidate - GROUP_SIZE;
                source_candidate = (group_iter * GROUP_SIZE) + local_candidate;
                if (!local_valid[group_iter] && (queue_count_q[source_candidate] != 0)) begin
                    local_valid[group_iter] = 1'b1;
                    local_winner[group_iter] = local_candidate[LOCAL_W-1:0];
                end
            end
        end

        // Source-facing four-phase handshake and queue admission are identical
        // to P1. Newly captured events are scheduled starting next cycle.
        for (source_comb = 0; source_comb < NUM_SOURCES; source_comb = source_comb + 1) begin
            if (ack_q[source_comb]) begin
                if (!req_sync_q[source_comb])
                    ack_d[source_comb] = 1'b0;
            end else if (req_sync_q[source_comb] && (queue_count_d[source_comb] < 2)) begin
                queue_count_d[source_comb] = queue_count_d[source_comb] + 1'b1;
                ack_d[source_comb] = 1'b1;
            end
        end

        can_load_output = !out_valid_q || out_ready;
        group_select_valid = 1'b0;
        select_valid = 1'b0;
        select_group = group_rr_q;
        select_local = local_winner[group_rr_q];
        select_idx = '0;

        if (can_load_output) begin
            // First 4-way scan: select a non-empty group.
            for (group_offset = 0; group_offset < NUM_GROUPS;
                 group_offset = group_offset + 1) begin
                group_candidate = group_rr_q + group_offset;
                if (group_candidate >= NUM_GROUPS)
                    group_candidate = group_candidate - NUM_GROUPS;
                if (!group_select_valid && local_valid[group_candidate]) begin
                    group_select_valid = 1'b1;
                    select_group = group_candidate[GROUP_W-1:0];
                end
            end

            if (group_select_valid) begin
                select_local = local_winner[select_group];
                select_valid = 1'b1;
            end

            if (select_valid) begin
                select_idx = {select_group, select_local};
                out_valid_d = 1'b1;
                out_addr_d = select_idx;
                queue_count_d[select_idx] = queue_count_d[select_idx] - 1'b1;

                if (select_group == NUM_GROUPS-1)
                    group_rr_d = '0;
                else
                    group_rr_d = select_group + 1'b1;

                if (select_local == GROUP_SIZE-1)
                    local_rr_d[select_group] = '0;
                else
                    local_rr_d[select_group] = select_local + 1'b1;
            end else begin
                out_valid_d = 1'b0;
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            req_meta_q <= '0;
            req_sync_q <= '0;
            ack_q <= '0;
            group_rr_q <= '0;
            local_rr_q <= '0;
            out_addr_q <= '0;
            out_valid_q <= 1'b0;
            for (source_ff = 0; source_ff < NUM_SOURCES; source_ff = source_ff + 1)
                queue_count_q[source_ff] <= '0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q <= ack_d;
            group_rr_q <= group_rr_d;
            local_rr_q <= local_rr_d;
            out_addr_q <= out_addr_d;
            out_valid_q <= out_valid_d;
            for (source_ff = 0; source_ff < NUM_SOURCES; source_ff = source_ff + 1)
                queue_count_q[source_ff] <= queue_count_d[source_ff];
        end
    end

    assign src_ack_async = ack_q;
    assign out_addr = out_addr_q;
    assign out_valid = out_valid_q;

endmodule
