`timescale 1ns/1ps

// P4-C: low-cost cut-through refinement of P3.
// A newly synchronized request is eligible in the same next-state decision
// that acknowledges it. P3 waited one additional pending-register cycle.
module aer_improved_cutthrough #(
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
        group_rr_d = group_rr_q;
        local_rr_d = local_rr_q;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;

        // Capture first. pending_d, rather than pending_q, feeds the scheduler.
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
        for (group_iter = 0; group_iter < NUM_GROUPS; group_iter = group_iter + 1) begin
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
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            req_meta_q <= '0;
            req_sync_q <= '0;
            ack_q <= '0;
            pending_q <= '0;
            group_rr_q <= '0;
            local_rr_q <= '0;
            out_addr_q <= '0;
            out_valid_q <= 1'b0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q <= ack_d;
            pending_q <= pending_d;
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
