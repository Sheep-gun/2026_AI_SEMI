`timescale 1ns/1ps

// Explicit active-high SR latch built from cross-coupled NOR gates.
// This is structural logic, not a metastability-safe MUTEX.
(* keep_hierarchy = "yes", dont_touch = "yes" *)
module aer_async_sr_latch (
    input  wire set_i,
    input  wire reset_i,
    input  wire rst_n,
    output wire q_o
);
    (* keep = "true" *) wire q_n;
    (* keep = "true" *) wire set_safe = set_i & rst_n;
    (* keep = "true" *) wire reset_safe = reset_i | ~rst_n;

`ifdef AER_ASYNC_SIM_DELAY
    // Physical gates are not zero-delay. Xcelium needs a finite primitive
    // delay to converge the cross-coupled loop; synthesis never sees it.
    nor #(0.001) (q_o, reset_safe, q_n);
    nor #(0.001) (q_n, set_safe, q_o);
`else
    nor (q_o, reset_safe, q_n);
    nor (q_n, set_safe, q_o);
`endif
endmodule

// Explicit data latch implemented with the structural SR primitive.
(* keep_hierarchy = "yes", dont_touch = "yes" *)
module aer_async_d_latch (
    input  wire d_i,
    input  wire enable_i,
    input  wire rst_n,
    output wire q_o
);
    wire set_i = enable_i & d_i;
    wire reset_i = enable_i & ~d_i;

    aer_async_sr_latch storage (
        .set_i   (set_i),
        .reset_i (reset_i),
        .rst_n   (rst_n),
        .q_o     (q_o)
    );
endmodule

// T0: traditional clockless shared-bus AER baseline.
//
// No global clock is present. A request is selected with fixed priority,
// captured in structural latches, and held until the four-phase source/sink
// handshake returns to idle.
//
// Deliberately retained baseline weakness:
//   The project library has no characterized MUTEX. The combinational fixed-
//   priority request selection is therefore not claimed metastability-safe for
//   near-simultaneous physical request changes.
module aer_traditional_structural #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  wire                   rst_n,
    input  wire [NUM_SOURCES-1:0] src_req,
    output wire [NUM_SOURCES-1:0] src_ack,
    output wire [ADDR_W-1:0]      aer_addr,
    output wire                   aer_req,
    input  wire                   aer_ack
);
    localparam integer IDX_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES);

    reg  [IDX_W-1:0] priority_idx;
    reg              priority_valid;
    wire [IDX_W-1:0] grant_q;
    wire [NUM_SOURCES-1:0] grant_onehot;
    wire busy_q;
    wire selected_req;
    wire capture_grant;
    wire release_busy;
    integer i;

    always @* begin
        priority_idx = '0;
        priority_valid = 1'b0;
        for (i = 0; i < NUM_SOURCES; i = i + 1) begin
            if (!priority_valid && src_req[i]) begin
                priority_idx = i[IDX_W-1:0];
                priority_valid = 1'b1;
            end
        end
    end

    assign grant_onehot = {{(NUM_SOURCES-1){1'b0}}, 1'b1} << grant_q;
    assign selected_req = |(src_req & grant_onehot);

    // Capture a new request only when the previous receiver acknowledge has
    // returned low. Once busy is set, grant latches close and hold the address.
    assign capture_grant = priority_valid & ~busy_q & ~aer_ack;

    // Source release lowers aer_req/src_ack. Receiver release then clears busy,
    // allowing the next already-pending request to be captured.
    assign release_busy = busy_q & ~selected_req & ~aer_ack;

    aer_async_sr_latch busy_latch (
        .set_i   (capture_grant),
        .reset_i (release_busy),
        .rst_n   (rst_n),
        .q_o     (busy_q)
    );

    genvar bit_index;
    generate
        for (bit_index = 0; bit_index < IDX_W; bit_index = bit_index + 1) begin : g_grant_latch
            aer_async_d_latch grant_latch (
                .d_i      (priority_idx[bit_index]),
                .enable_i (capture_grant),
                .rst_n    (rst_n),
                .q_o      (grant_q[bit_index])
            );
        end
    endgenerate

    assign aer_addr = grant_q;
    assign aer_req = busy_q & selected_req;
    assign src_ack = (busy_q & aer_ack & selected_req) ? grant_onehot : '0;

endmodule
