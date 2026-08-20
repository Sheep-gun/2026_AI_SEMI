`timescale 1ns/1ps

// P8-DG-SCR experiment: shared-tree/direct-Gray controller with a synchronous
// core clear and asynchronous output isolation.
//
// Only reset_release_q uses asynchronous-reset flops.  ACK, pending storage,
// epoch, and out_valid clear synchronously while core_rst_n is low.  The two
// externally observable control outputs are AND-isolated by core_rst_n, so an
// asynchronous rst_n assertion still forces them low without a clock.  Reset
// deassertion cannot unmask stale core state: two clock edges both clear the
// core before reset_release_q[1] rises.
module aer_pending_direct_gray_sync_core_reset (
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
    logic b3, b2, b1, b0;
    logic [3:0] selected_addr;
    logic grant_valid;

    logic [3:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;

    integer pair_index;
    integer quarter_index;
    integer half_index;

    always_comb begin
        accept_mask = req_sync_q & ~ack_q & ~pending_q;
        accepted_pending = pending_q | accept_mask;
        ack_d = (ack_q & req_sync_q) | accept_mask;
        pending_d = accepted_pending;
        candidate = accepted_pending;

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

        grant_valid = half_valid[0] | half_valid[1];

        b3 = half_valid[epoch_gray_q[3]]
            ? epoch_gray_q[3] : ~epoch_gray_q[3];
        b2 = quarter_valid[{b3, epoch_gray_q[2]}]
            ? epoch_gray_q[2] : ~epoch_gray_q[2];
        b1 = pair_valid[{b3, b2, epoch_gray_q[1]}]
            ? epoch_gray_q[1] : ~epoch_gray_q[1];
        b0 = candidate[{b3, b2, b1, epoch_gray_q[0]}]
            ? epoch_gray_q[0] : ~epoch_gray_q[0];

        selected_addr = {b3, b2, b1, b0};
        can_load_output = !out_valid_q || out_ready;

        epoch_parity = ^epoch_gray_q;
        epoch_toggle[0] = ~epoch_parity;
        epoch_toggle[1] = epoch_parity & epoch_gray_q[0];
        epoch_toggle[2] = epoch_parity & ~epoch_gray_q[0] & epoch_gray_q[1];
        epoch_toggle[3] = epoch_parity & ~epoch_gray_q[0] & ~epoch_gray_q[1];

        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d = 1'b1;
                out_addr_d = selected_addr;
                pending_d[selected_addr] = 1'b0;
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

    // Synchronous core clear: only the two reset-release flops require an
    // asynchronous reset pin.  The core is cleared on both release edges before
    // core_rst_n can become one.
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

    // Isolation provides clock-independent safe-low assertion.  out_addr is
    // architecturally don't-care while the isolated out_valid is zero.
    assign src_ack_async = ack_q & {16{core_rst_n}};
    assign out_addr      = out_addr_q;
    assign out_valid     = out_valid_q & core_rst_n;
endmodule
