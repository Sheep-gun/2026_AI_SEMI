`timescale 1ns/1ps

// P7-GE: elastic pending storage with a Gray-epoch XOR tournament.
//
// The external protocol remains the active-high four-phase AER contract:
// a source holds src_req_async high until src_ack_async rises, then lowers the
// request and waits for the acknowledge to return low.  Each source has one
// controller-resident pending bit, so acknowledgement means that the event has
// been accepted even when the receiver is stalled.
//
// Arbitration is work-conserving.  Among all pending events, it chooses the
// address that minimizes (address XOR gray(epoch)).  The binary epoch advances
// once per event loaded into the registered output.  A continuously pending
// source is therefore the exact preferred address once in every 16 grants and
// is served within at most 16 grants, excluding receiver stall time.
module aer_pending_gray_epoch #(
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
    // ROBUST_RESET=1 provides asynchronous assertion and two-clock synchronous
    // deassertion.  ROBUST_RESET=0 exists only to separate reset cost in PPA
    // experiments; the robust implementation is the default and main design.
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

    logic [3:0] epoch_bin_q, epoch_bin_d;
    logic [3:0] epoch_gray;
    logic [1:0] half_valid;
    logic [3:0] quarter_valid;
    logic [7:0] pair_valid;
    logic b3, b2, b1, b0;
    logic [3:0] selected_addr;
    logic grant_valid;

    logic [3:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic can_load_output;

    integer source_index;
    integer pair_index;

    always_comb begin
        ack_d       = ack_q;
        pending_d   = pending_q;
        epoch_bin_d = epoch_bin_q;
        out_addr_d  = out_addr_q;
        out_valid_d = out_valid_q;

        // Capture all newly synchronized requests before arbitration.  Using
        // pending_d below preserves P4-C cut-through: a newly accepted event is
        // eligible for the output register in this same next-state decision.
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

        // All subtree-valid signals are computed in parallel.  The four branch
        // decisions then walk the preferred Gray-epoch path, taking the other
        // branch only when the preferred subtree is empty.
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
        can_load_output = !out_valid_q || out_ready;

        if (can_load_output) begin
            if (grant_valid) begin
                out_valid_d = 1'b1;
                out_addr_d = selected_addr;
                pending_d[selected_addr] = 1'b0;
                epoch_bin_d = epoch_bin_q + 1'b1;
            end else begin
                out_valid_d = 1'b0;
            end
        end
    end

    always_ff @(posedge clk or negedge core_rst_n) begin
        if (!core_rst_n) begin
            req_meta_q <= '0;
            req_sync_q <= '0;
            ack_q       <= '0;
            pending_q   <= '0;
            epoch_bin_q <= '0;
            out_addr_q  <= '0;
            out_valid_q <= 1'b0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q       <= ack_d;
            pending_q   <= pending_d;
            epoch_bin_q <= epoch_bin_d;
            out_addr_q  <= out_addr_d;
            out_valid_q <= out_valid_d;
        end
    end

    assign src_ack_async = ack_q;
    assign out_addr      = out_addr_q;
    assign out_valid     = out_valid_q;
endmodule
