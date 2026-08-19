`timescale 1ns/1ps

// P4: cut-through, age-aware hierarchical AER controller.
//
// P3 compatibility retained:
//   * 16 asynchronous four-phase source interfaces;
//   * 2FF CDC synchronizers;
//   * one pending slot per source;
//   * one registered 4-bit valid/ready output;
//   * four parallel 4-way local arbiters and one global 4-way arbiter.
//
// P4 additions:
//   * cut-through scheduling sees a request in the same combinational decision
//     that accepts it, removing P3's mandatory extra pending cycle when idle;
//   * one aged bit per 4-source group implements coarse-grain homeostatic
//     backpressure steering. While the receiver stalls, the next group pointer
//     is moved toward an aged backlog before the output reopens;
//   * round-robin pointers remain the tie-breaker inside the selected tier, so
//     saturated aged traffic remains starvation-free.
module aer_improved_homeostatic #(
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
    logic [NUM_SOURCES-1:0] pending_q, pending_d;
    logic [NUM_GROUPS-1:0] group_aged_q, group_aged_d;
    logic [NUM_GROUPS-1:0] group_old_pending;
    logic steer_valid;

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
    integer group_iter;
    integer group_offset;
    integer group_candidate;
    integer local_offset;
    integer local_candidate;
    integer source_candidate;

    always_comb begin
        ack_d = ack_q;
        pending_d = pending_q;
        group_aged_d = group_aged_q;
        group_rr_d = group_rr_q;
        local_rr_d = local_rr_q;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;

        for (source_comb = 0; source_comb < NUM_SOURCES; source_comb = source_comb + 1) begin
            if (ack_q[source_comb]) begin
                if (!req_sync_q[source_comb])
                    ack_d[source_comb] = 1'b0;
            end else if (req_sync_q[source_comb] && !pending_d[source_comb]) begin
                pending_d[source_comb] = 1'b1;
                ack_d[source_comb] = 1'b1;
            end
        end

        local_valid = '0;
        local_winner = local_rr_q;
        group_old_pending = '0;
        for (group_iter = 0; group_iter < NUM_GROUPS; group_iter = group_iter + 1) begin
            // A group is promoted only from registered pending state. New
            // cut-through requests therefore receive one fresh opportunity.
            group_old_pending[group_iter] =
                |pending_q[(group_iter * GROUP_SIZE) +: GROUP_SIZE];
            group_aged_d[group_iter] = group_old_pending[group_iter];

            for (local_offset = 0; local_offset < GROUP_SIZE; local_offset = local_offset + 1) begin
                local_candidate = local_rr_q[group_iter] + local_offset;
                if (local_candidate >= GROUP_SIZE)
                    local_candidate = local_candidate - GROUP_SIZE;
                source_candidate = (group_iter * GROUP_SIZE) + local_candidate;
                if (!local_valid[group_iter] && pending_d[source_candidate]) begin
                    local_valid[group_iter] = 1'b1;
                    local_winner[group_iter] = local_candidate[LOCAL_W-1:0];
                end
            end
        end

        can_load_output = !out_valid_q || out_ready;
        group_select_valid = 1'b0;
        steer_valid = 1'b0;
        select_valid = 1'b0;
        select_group = group_rr_q;
        select_local = local_winner[group_rr_q];
        select_idx = '0;

        if (can_load_output) begin
            for (group_offset = 0; group_offset < NUM_GROUPS; group_offset = group_offset + 1) begin
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
                pending_d[select_idx] = 1'b0;

                group_rr_d = (select_group == NUM_GROUPS-1) ? '0 : select_group + 1'b1;
                local_rr_d[select_group] =
                    (select_local == GROUP_SIZE-1) ? '0 : select_local + 1'b1;
            end else begin
                out_valid_d = 1'b0;
            end
        end else begin
            // The output is blocked, so use otherwise-idle cycles to steer the
            // next group pointer toward established backlog. The ready-cycle
            // selection path remains the same as the low-cost cut-through core.
            for (group_offset = 0; group_offset < NUM_GROUPS; group_offset = group_offset + 1) begin
                group_candidate = group_rr_q + group_offset;
                if (group_candidate >= NUM_GROUPS)
                    group_candidate = group_candidate - NUM_GROUPS;
                if (!steer_valid && local_valid[group_candidate] &&
                    group_aged_q[group_candidate] && group_old_pending[group_candidate]) begin
                    steer_valid = 1'b1;
                    group_rr_d = group_candidate[GROUP_W-1:0];
                end
            end
        end

    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            req_meta_q <= '0;
            req_sync_q <= '0;
            ack_q <= '0;
            pending_q <= '0;
            group_aged_q <= '0;
            group_rr_q <= '0;
            local_rr_q <= '0;
            out_addr_q <= '0;
            out_valid_q <= 1'b0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q <= ack_d;
            pending_q <= pending_d;
            group_aged_q <= group_aged_d;
            group_rr_q <= group_rr_d;
            local_rr_q <= local_rr_d;
            out_addr_q <= out_addr_d;
            out_valid_q <= out_valid_d;
        end
    end

    assign src_ack_async = ack_q;
    assign out_addr = out_addr_q;
    assign out_valid = out_valid_q;
endmodule
