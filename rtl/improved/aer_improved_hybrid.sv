`timescale 1ns/1ps

// P1 improved AER transport.
// - Asynchronous level-held source request/acknowledge boundary.
// - Two-flop request synchronization per source.
// - Depth-2 event count queue per source (address is implicit in source index).
// - Round-robin scheduling.
// - One-entry elastic valid/ready address output.
module aer_improved_hybrid #(
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
    localparam integer IDX_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES);

    (* ASYNC_REG = "TRUE" *) logic [NUM_SOURCES-1:0] req_meta_q;
    (* ASYNC_REG = "TRUE" *) logic [NUM_SOURCES-1:0] req_sync_q;

    logic [NUM_SOURCES-1:0] ack_q, ack_d;
    logic [NUM_SOURCES-1:0][1:0] queue_count_q;
    logic [NUM_SOURCES-1:0][1:0] queue_count_d;

    logic [IDX_W-1:0] rr_ptr_q, rr_ptr_d;
    logic [ADDR_W-1:0] out_addr_q, out_addr_d;
    logic out_valid_q, out_valid_d;
    logic select_valid;
    logic [IDX_W-1:0] select_idx;
    logic can_load_output;

    integer source_comb;
    integer source_ff;
    integer offset;
    integer candidate;

    always_comb begin
        ack_d = ack_q;
        rr_ptr_d = rr_ptr_q;
        out_addr_d = out_addr_q;
        out_valid_d = out_valid_q;

        for (source_comb = 0; source_comb < NUM_SOURCES; source_comb = source_comb + 1)
            queue_count_d[source_comb] = queue_count_q[source_comb];

        // Four-phase asynchronous source boundary. A held request is accepted
        // exactly once when its local queue has space. Ack remains high until
        // the synchronized request returns low.
        for (source_comb = 0; source_comb < NUM_SOURCES; source_comb = source_comb + 1) begin
            if (ack_q[source_comb]) begin
                if (!req_sync_q[source_comb])
                    ack_d[source_comb] = 1'b0;
            end else if (req_sync_q[source_comb] && (queue_count_d[source_comb] < 2)) begin
                queue_count_d[source_comb] = queue_count_d[source_comb] + 1'b1;
                ack_d[source_comb] = 1'b1;
            end
        end

        // The output slot can be refilled in the same edge that the current
        // event transfers, enabling one accepted event per ready cycle.
        can_load_output = !out_valid_q || out_ready;
        select_valid = 1'b0;
        select_idx = rr_ptr_q;

        if (can_load_output) begin
            for (offset = 0; offset < NUM_SOURCES; offset = offset + 1) begin
                candidate = rr_ptr_q + offset;
                if (candidate >= NUM_SOURCES)
                    candidate = candidate - NUM_SOURCES;
                // Schedule only events already registered in queue_count_q.
                // A newly captured asynchronous event becomes eligible on the
                // next cycle, breaking the CDC/ack path from the 16-way scan.
                if (!select_valid && (queue_count_q[candidate] != 0)) begin
                    select_valid = 1'b1;
                    select_idx = candidate[IDX_W-1:0];
                end
            end

            if (select_valid) begin
                out_valid_d = 1'b1;
                out_addr_d = select_idx[ADDR_W-1:0];
                queue_count_d[select_idx] = queue_count_d[select_idx] - 1'b1;
                if (select_idx == NUM_SOURCES-1)
                    rr_ptr_d = '0;
                else
                    rr_ptr_d = select_idx + 1'b1;
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
            rr_ptr_q <= '0;
            out_addr_q <= '0;
            out_valid_q <= 1'b0;
            for (source_ff = 0; source_ff < NUM_SOURCES; source_ff = source_ff + 1)
                queue_count_q[source_ff] <= '0;
        end else begin
            req_meta_q <= src_req_async;
            req_sync_q <= req_meta_q;
            ack_q <= ack_d;
            rr_ptr_q <= rr_ptr_d;
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
