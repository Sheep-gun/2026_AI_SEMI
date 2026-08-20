`timescale 1ns/1ps

// P8-DG experiment: sparse-reset P7-GE with the Gray preference stored
// directly.  This removes the binary-counter-to-Gray XOR network while keeping
// the exact 16-address reflected-Gray service sequence and fairness bound.
module aer_pending_direct_gray_sparse_reset (
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
    logic [15:0] candidate;

    logic [3:0] epoch_gray_q, epoch_gray_d;
    logic epoch_parity;
    logic [3:0] epoch_toggle;
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
        ack_d        = ack_q;
        pending_d    = pending_q;
        epoch_gray_d = epoch_gray_q;
        out_addr_d   = out_addr_q;
        out_valid_d  = out_valid_q;

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

        half_valid[0] = |candidate[7:0];
        half_valid[1] = |candidate[15:8];

        quarter_valid[0] = |candidate[3:0];
        quarter_valid[1] = |candidate[7:4];
        quarter_valid[2] = |candidate[11:8];
        quarter_valid[3] = |candidate[15:12];

        for (pair_index = 0; pair_index < 8; pair_index = pair_index + 1)
            pair_valid[pair_index] = |candidate[(pair_index * 2) +: 2];

        b3 = half_valid[epoch_gray_q[3]]
            ? epoch_gray_q[3] : ~epoch_gray_q[3];
        b2 = quarter_valid[{b3, epoch_gray_q[2]}]
            ? epoch_gray_q[2] : ~epoch_gray_q[2];
        b1 = pair_valid[{b3, b2, epoch_gray_q[1]}]
            ? epoch_gray_q[1] : ~epoch_gray_q[1];
        b0 = candidate[{b3, b2, b1, epoch_gray_q[0]}]
            ? epoch_gray_q[0] : ~epoch_gray_q[0];

        selected_addr = {b3, b2, b1, b0};
        grant_valid = |candidate;
        can_load_output = !out_valid_q || out_ready;

        // Reflected-Gray successor without a binary counter.  Even parity
        // toggles bit 0.  Odd parity toggles the bit above the least-significant
        // asserted bit, with bit 3 closing the 16-state cycle.
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
    end

    always_ff @(posedge clk)
        out_addr_q <= out_addr_d;

    always_ff @(posedge clk or negedge core_rst_n) begin
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

    assign src_ack_async = ack_q;
    assign out_addr      = out_addr_q;
    assign out_valid     = out_valid_q;
endmodule
