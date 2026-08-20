`timescale 1ns/1ps

// P9-BR: state-compressed P8 transport using the registered output address as
// the strict round-robin state.  The output address is both the address held
// during receiver stalls and the last-grant pointer.  This removes the four
// independent epoch bits while retaining one pending slot per source plus the
// one-entry output slot.
module aer_binary_ring_selector16 (
    input  logic [15:0] candidate,
    input  logic [3:0]  last_addr,
    output logic         grant_valid,
    output logic [3:0]   grant_addr
);
    logic [1:0] last_group;
    logic [1:0] last_lane;
    logic [1:0] next_group;
    logic [3:0] group_valid;
    logic [3:0] start_group_req;
    logic [3:0] tail_mask;
    logic [3:0] tail_req;
    logic [3:0] selected_group_req;
    logic [2:0] tail_pick;
    logic [2:0] group_pick;
    logic [2:0] lane_pick;

    function automatic [2:0] fixed_priority4(input logic [3:0] request);
        logic [1:0] index;
        begin
            if (request[0])
                index = 2'd0;
            else if (request[1])
                index = 2'd1;
            else if (request[2])
                index = 2'd2;
            else
                index = 2'd3;
            fixed_priority4 = {|request, index};
        end
    endfunction

    function automatic [2:0] round_robin4(
        input logic [3:0] request,
        input logic [1:0] first_index
    );
        logic [1:0] index;
        begin
            case (first_index)
                2'd0: begin
                    if (request[0]) index = 2'd0;
                    else if (request[1]) index = 2'd1;
                    else if (request[2]) index = 2'd2;
                    else index = 2'd3;
                end
                2'd1: begin
                    if (request[1]) index = 2'd1;
                    else if (request[2]) index = 2'd2;
                    else if (request[3]) index = 2'd3;
                    else index = 2'd0;
                end
                2'd2: begin
                    if (request[2]) index = 2'd2;
                    else if (request[3]) index = 2'd3;
                    else if (request[0]) index = 2'd0;
                    else index = 2'd1;
                end
                default: begin
                    if (request[3]) index = 2'd3;
                    else if (request[0]) index = 2'd0;
                    else if (request[1]) index = 2'd1;
                    else index = 2'd2;
                end
            endcase
            round_robin4 = {|request, index};
        end
    endfunction

    always_comb begin
        // Search strictly after last_addr.  Testing the remainder of the last
        // group first removes a four-bit pointer incrementer; if it is empty,
        // the group search begins at the next group and wraps naturally.
        last_group = last_addr[3:2];
        last_lane = last_addr[1:0];
        next_group = last_group + 1'b1;

        group_valid[0] = |candidate[3:0];
        group_valid[1] = |candidate[7:4];
        group_valid[2] = |candidate[11:8];
        group_valid[3] = |candidate[15:12];

        case (last_group)
            2'd0: start_group_req = candidate[3:0];
            2'd1: start_group_req = candidate[7:4];
            2'd2: start_group_req = candidate[11:8];
            default: start_group_req = candidate[15:12];
        endcase

        case (last_lane)
            2'd0: tail_mask = 4'b1110;
            2'd1: tail_mask = 4'b1100;
            2'd2: tail_mask = 4'b1000;
            default: tail_mask = 4'b0000;
        endcase

        tail_req = start_group_req & tail_mask;
        tail_pick = fixed_priority4(tail_req);
        group_pick = round_robin4(group_valid, next_group);

        case (group_pick[1:0])
            2'd0: selected_group_req = candidate[3:0];
            2'd1: selected_group_req = candidate[7:4];
            2'd2: selected_group_req = candidate[11:8];
            default: selected_group_req = candidate[15:12];
        endcase
        lane_pick = fixed_priority4(selected_group_req);

        grant_valid = |candidate;
        grant_addr = tail_pick[2]
            ? {last_group, tail_pick[1:0]}
            : {group_pick[1:0], lane_pick[1:0]};
    end
endmodule

module aer_pending_binary_ring_sync_core_reset (
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
            reset_release_q <= {reset_release_q[0], 1'b1};
    end
    assign core_rst_n = reset_release_q[1];

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q;
    (* ASYNC_REG = "TRUE" *) logic [15:0] req_sync_q;

    logic [15:0] ack_q, ack_d;
    logic [15:0] pending_q, pending_d;
    logic [15:0] accept_mask;
    logic [15:0] accepted_pending;
    logic [3:0] selected_addr;
    logic grant_valid;
    logic [3:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;

    aer_binary_ring_selector16 selector (
        .candidate(accepted_pending),
        .last_addr(out_addr_q),
        .grant_valid(grant_valid),
        .grant_addr(selected_addr)
    );

    always_comb begin
        accept_mask = req_sync_q & ~ack_q & ~pending_q;
        accepted_pending = pending_q | accept_mask;
        ack_d = (ack_q & req_sync_q) | accept_mask;
        pending_d = accepted_pending;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;
        can_load_output = !out_valid_q || out_ready;

        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d = 1'b1;
                out_addr_d = selected_addr;
                pending_d[selected_addr] = 1'b0;
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
            ack_q       <= '0;
            pending_q   <= '0;
            // The first active search begins at address zero.
            out_addr_q  <= 4'hf;
            out_valid_q <= 1'b0;
        end else begin
            ack_q       <= ack_d;
            pending_q   <= pending_d;
            out_addr_q  <= out_addr_d;
            out_valid_q <= out_valid_d;
        end
    end

    assign src_ack_async = ack_q & {16{core_rst_n}};
    assign out_addr = out_addr_q;
    assign out_valid = out_valid_q & core_rst_n;
endmodule
