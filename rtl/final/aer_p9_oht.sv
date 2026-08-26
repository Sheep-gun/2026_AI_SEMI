`timescale 1ns/1ps

// P9-OHT final: P9 contract implemented with a top-down one-hot arbitration
// path and a separate four-bit Gray epoch.
//
// The selected half, quarter, pair, and source are represented as one-hot
// vectors.  The same intermediate path produces the registered address and
// the pending consume mask; no dynamic-index pending assignment is used.
// Handshake, storage, direct reflected-Gray order, reset partition, output
// isolation, and receiver-stall behavior match the verified P9 contract.
module aer_pending_direct_gray_scr_onehot_tree (
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
    logic [15:0] candidate;

    logic [3:0] epoch_gray_q, epoch_gray_d;
    logic epoch_parity;
    logic [3:0] epoch_toggle;

    logic [7:0] pair_valid;
    logic [3:0] quarter_valid;
    logic [1:0] half_valid;
    logic [1:0] selected_half;
    logic [3:0] selected_quarter;
    logic [7:0] selected_pair;
    logic [15:0] selected_onehot;
    logic [15:0] grant_onehot;
    logic [3:0] selected_addr;
    logic grant_valid;

    logic [3:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;

    integer pair_index;
    integer quarter_index;
    integer half_index;

    always_comb begin
        accept_mask      = req_sync_q & ~ack_q & ~pending_q;
        accepted_pending = pending_q | accept_mask;
        ack_d            = (ack_q & req_sync_q) | accept_mask;
        candidate        = accepted_pending;

        epoch_gray_d = epoch_gray_q;
        out_addr_d   = out_addr_q;
        out_valid_d  = out_valid_q;

        for (pair_index = 0; pair_index < 8; pair_index = pair_index + 1)
            pair_valid[pair_index] =
                candidate[pair_index * 2] |
                candidate[(pair_index * 2) + 1];

        for (quarter_index = 0; quarter_index < 4; quarter_index = quarter_index + 1)
            quarter_valid[quarter_index] =
                pair_valid[quarter_index * 2] |
                pair_valid[(quarter_index * 2) + 1];

        for (half_index = 0; half_index < 2; half_index = half_index + 1)
            half_valid[half_index] =
                quarter_valid[half_index * 2] |
                quarter_valid[(half_index * 2) + 1];

        // Select the preferred Gray branch when it contains a request;
        // otherwise select the other non-empty branch.  Each level remains
        // one-hot, so the final source bit is already the pending clear mask.
        selected_half = '0;
        if (epoch_gray_q[3]) begin
            selected_half[1] = half_valid[1];
            selected_half[0] = half_valid[0] & ~half_valid[1];
        end else begin
            selected_half[0] = half_valid[0];
            selected_half[1] = half_valid[1] & ~half_valid[0];
        end

        selected_quarter = '0;
        for (half_index = 0; half_index < 2; half_index = half_index + 1) begin
            if (epoch_gray_q[2]) begin
                selected_quarter[(half_index * 2) + 1] =
                    selected_half[half_index] & quarter_valid[(half_index * 2) + 1];
                selected_quarter[half_index * 2] =
                    selected_half[half_index] & quarter_valid[half_index * 2] &
                    ~quarter_valid[(half_index * 2) + 1];
            end else begin
                selected_quarter[half_index * 2] =
                    selected_half[half_index] & quarter_valid[half_index * 2];
                selected_quarter[(half_index * 2) + 1] =
                    selected_half[half_index] & quarter_valid[(half_index * 2) + 1] &
                    ~quarter_valid[half_index * 2];
            end
        end

        selected_pair = '0;
        for (quarter_index = 0; quarter_index < 4; quarter_index = quarter_index + 1) begin
            if (epoch_gray_q[1]) begin
                selected_pair[(quarter_index * 2) + 1] =
                    selected_quarter[quarter_index] & pair_valid[(quarter_index * 2) + 1];
                selected_pair[quarter_index * 2] =
                    selected_quarter[quarter_index] & pair_valid[quarter_index * 2] &
                    ~pair_valid[(quarter_index * 2) + 1];
            end else begin
                selected_pair[quarter_index * 2] =
                    selected_quarter[quarter_index] & pair_valid[quarter_index * 2];
                selected_pair[(quarter_index * 2) + 1] =
                    selected_quarter[quarter_index] & pair_valid[(quarter_index * 2) + 1] &
                    ~pair_valid[quarter_index * 2];
            end
        end

        selected_onehot = '0;
        for (pair_index = 0; pair_index < 8; pair_index = pair_index + 1) begin
            if (epoch_gray_q[0]) begin
                selected_onehot[(pair_index * 2) + 1] =
                    selected_pair[pair_index] & candidate[(pair_index * 2) + 1];
                selected_onehot[pair_index * 2] =
                    selected_pair[pair_index] & candidate[pair_index * 2] &
                    ~candidate[(pair_index * 2) + 1];
            end else begin
                selected_onehot[pair_index * 2] =
                    selected_pair[pair_index] & candidate[pair_index * 2];
                selected_onehot[(pair_index * 2) + 1] =
                    selected_pair[pair_index] & candidate[(pair_index * 2) + 1] &
                    ~candidate[pair_index * 2];
            end
        end

        grant_valid = |selected_half;
        selected_addr[3] = selected_half[1];
        selected_addr[2] = selected_quarter[1] | selected_quarter[3];
        selected_addr[1] = selected_pair[1] | selected_pair[3] |
                           selected_pair[5] | selected_pair[7];
        selected_addr[0] = |(selected_onehot & 16'haaaa);
        can_load_output = !out_valid_q || out_ready;

        // The one-hot consume operation is an ordinary vector expression.
        // A stalled output makes grant_onehot zero, preserving all pending bits.
        grant_onehot = selected_onehot & {16{can_load_output}};
        pending_d = accepted_pending & ~grant_onehot;

        epoch_parity = ^epoch_gray_q;
        epoch_toggle[0] = ~epoch_parity;
        epoch_toggle[1] = epoch_parity & epoch_gray_q[0];
        epoch_toggle[2] = epoch_parity & ~epoch_gray_q[0] & epoch_gray_q[1];
        epoch_toggle[3] = epoch_parity & ~epoch_gray_q[0] & ~epoch_gray_q[1];

        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d  = 1'b1;
                out_addr_d   = selected_addr;
                epoch_gray_d = epoch_gray_q ^ epoch_toggle;
            end else begin
                out_valid_d = 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        req_meta_q <= src_req_async;
        req_sync_q <= req_meta_q;
        out_addr_q <= out_addr_d;
    end

    always_ff @(posedge clk) begin
        if (!core_rst_n) begin
            ack_q        <= '0;
            pending_q    <= '0;
            epoch_gray_q <= '0;
            out_valid_q  <= 1'b0;
        end else begin
            ack_q        <= ack_d;
            pending_q    <= pending_d;
            epoch_gray_q <= epoch_gray_d;
            out_valid_q  <= out_valid_d;
        end
    end

    assign src_ack_async = ack_q & {16{core_rst_n}};
    assign out_addr      = out_addr_q;
    assign out_valid     = out_valid_q & core_rst_n;
endmodule
