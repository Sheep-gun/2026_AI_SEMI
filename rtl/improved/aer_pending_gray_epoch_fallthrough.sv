`timescale 1ns/1ps

// P7-GE-FT: the P7 pending/early-ACK Gray-epoch scheduler with a fall-through
// output.  When the receiver is ready, a selected event is visible directly
// from registered controller state and transfers without first traversing an
// output register.  The five-bit hold register is used only when valid is
// presented while ready is low; it then preserves valid/address until transfer.
module aer_pending_gray_epoch_fallthrough #(
    parameter bit ROBUST_RESET = 1'b1
) (
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

    generate
        if (ROBUST_RESET) begin : g_robust_reset
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    reset_release_q <= 2'b00;
                else
                    reset_release_q <= {reset_release_q[0], 1'b1};
            end
            assign core_rst_n = reset_release_q[1];
        end else begin : g_raw_reset
            always_comb reset_release_q = 2'b11;
            assign core_rst_n = rst_n;
        end
    endgenerate

    (* ASYNC_REG = "TRUE" *) logic [15:0] req_meta_q;
    (* ASYNC_REG = "TRUE" *) logic [15:0] req_sync_q;
    logic [15:0] ack_q, ack_d;
    logic [15:0] pending_q, pending_d;
    logic [15:0] candidate;

    logic [3:0] epoch_bin_q, epoch_bin_d, epoch_gray;
    logic [1:0] half_valid;
    logic [3:0] quarter_valid;
    logic [7:0] pair_valid;
    logic b3, b2, b1, b0;
    logic [3:0] selected_addr;
    logic grant_valid;

    logic [3:0] hold_addr_q, hold_addr_d;
    logic hold_valid_q, hold_valid_d;
    integer source_index;
    integer pair_index;

    always_comb begin
        ack_d        = ack_q;
        pending_d    = pending_q;
        epoch_bin_d  = epoch_bin_q;
        hold_addr_d  = hold_addr_q;
        hold_valid_d = hold_valid_q;

        for (source_index = 0; source_index < 16; source_index = source_index + 1) begin
            if (ack_q[source_index]) begin
                if (!req_sync_q[source_index])
                    ack_d[source_index] = 1'b0;
            end else if (req_sync_q[source_index] && !pending_d[source_index]) begin
                pending_d[source_index] = 1'b1;
                ack_d[source_index]     = 1'b1;
            end
        end

        candidate = pending_d;
        epoch_gray = epoch_bin_q ^ (epoch_bin_q >> 1);
        half_valid[0] = |candidate[7:0];
        half_valid[1] = |candidate[15:8];
        quarter_valid[0] = |candidate[3:0];
        quarter_valid[1] = |candidate[7:4];
        quarter_valid[2] = |candidate[11:8];
        quarter_valid[3] = |candidate[15:12];
        for (pair_index = 0; pair_index < 8; pair_index = pair_index + 1)
            pair_valid[pair_index] = |candidate[(pair_index * 2) +: 2];

        b3 = half_valid[epoch_gray[3]]
            ? epoch_gray[3] : ~epoch_gray[3];
        b2 = quarter_valid[{b3, epoch_gray[2]}]
            ? epoch_gray[2] : ~epoch_gray[2];
        b1 = pair_valid[{b3, b2, epoch_gray[1]}]
            ? epoch_gray[1] : ~epoch_gray[1];
        b0 = candidate[{b3, b2, b1, epoch_gray[0]}]
            ? epoch_gray[0] : ~epoch_gray[0];
        selected_addr = {b3, b2, b1, b0};
        grant_valid = |candidate;

        // A held event owns the interface until it transfers.  Otherwise the
        // current tournament winner falls through.  Capturing on !ready makes
        // the registered hold state take over with the same valid/address at
        // the edge, satisfying the standard stall-stability requirement.
        if (hold_valid_q) begin
            out_valid = 1'b1;
            out_addr  = hold_addr_q;
        end else begin
            out_valid = grant_valid;
            out_addr  = selected_addr;
        end

        if (hold_valid_q) begin
            if (out_ready)
                hold_valid_d = 1'b0;
        end else if (grant_valid) begin
            // Either a direct ready transfer or reservation into the hold
            // register consumes this candidate and advances the fair epoch.
            pending_d[selected_addr] = 1'b0;
            epoch_bin_d = epoch_bin_q + 1'b1;
            if (!out_ready) begin
                hold_valid_d = 1'b1;
                hold_addr_d = selected_addr;
            end
        end
    end

    always_ff @(posedge clk or negedge core_rst_n) begin
        if (!core_rst_n) begin
            req_meta_q  <= '0;
            req_sync_q  <= '0;
            ack_q        <= '0;
            pending_q    <= '0;
            epoch_bin_q  <= '0;
            hold_addr_q  <= '0;
            hold_valid_q <= 1'b0;
        end else begin
            req_meta_q  <= src_req_async;
            req_sync_q  <= req_meta_q;
            ack_q        <= ack_d;
            pending_q    <= pending_d;
            epoch_bin_q  <= epoch_bin_d;
            hold_addr_q  <= hold_addr_d;
            hold_valid_q <= hold_valid_d;
        end
    end

    assign src_ack_async = ack_q;
endmodule
