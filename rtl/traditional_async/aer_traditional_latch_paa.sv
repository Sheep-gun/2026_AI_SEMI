`timescale 1ns/1ps

// T0-PPA: standard-cell latch implementation of the traditional clockless
// fixed-priority, single-bus, four-phase AER controller.
//
// This implementation deliberately preserves the traditional baseline limits:
//   * fixed priority, source 0 highest;
//   * no FIFO or pending-event storage;
//   * one shared binary address bus;
//   * active-high four-phase source/sink handshakes;
//   * no global clock.
//
// Unlike the structural-NOR T0 experiment, all state is held in characterized
// TLATRX1 standard cells and the bundled-data launch path uses characterized
// DLY4X1 delay cells. This removes unrecognized combinational storage loops from
// the Genus/Innovus flow.
//
// Physical validity boundary:
//   The supplied library has no characterized MUTEX. Therefore near-
//   simultaneous request changes inside the arbitration aperture remain an
//   explicit traditional-baseline limitation. Sources must hold src_req until
//   src_ack, and the PPA-qualified operating contract requires the request set
//   to be stable before the delayed transaction launch closes the grant latch.
module aer_traditional_latch_paa #(
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
    wire capture_raw;
    wire capture_delay_1;
    wire capture_delay_2;
    wire capture_delay_3;
    wire capture_delay_4;
    wire capture_delay_5;
    wire busy_launch_delay;
    wire release_busy;
    wire busy_gate;
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

    // Grant latches are transparent only while the link is idle. The request
    // set must remain stable through the capture-delay aperture.
    genvar bit_index;
    generate
        for (bit_index = 0; bit_index < IDX_W; bit_index = bit_index + 1) begin : g_grant_latch
            (* dont_touch = "true" *) TLATRX1 grant_latch (
                .D  (priority_idx[bit_index]),
                .G  (~busy_q),
                .RN (rst_n),
                .Q  (grant_q[bit_index]),
                .QN ()
            );
        end
    endgenerate

    // Five characterized delay cells create the bundled-data margin between
    // priority/address settling and transaction launch.
    assign capture_raw = priority_valid & ~busy_q & ~aer_ack;
    (* dont_touch = "true" *) DLY4X1 capture_delay_cell_1 (.A(capture_raw),     .Y(capture_delay_1));
    (* dont_touch = "true" *) DLY4X1 capture_delay_cell_2 (.A(capture_delay_1), .Y(capture_delay_2));
    (* dont_touch = "true" *) DLY4X1 capture_delay_cell_3 (.A(capture_delay_2), .Y(capture_delay_3));
    (* dont_touch = "true" *) DLY4X1 capture_delay_cell_4 (.A(capture_delay_3), .Y(capture_delay_4));
    (* dont_touch = "true" *) DLY4X1 capture_delay_cell_5 (.A(capture_delay_4), .Y(capture_delay_5));

    assign grant_onehot = {{(NUM_SOURCES-1){1'b0}}, 1'b1} << grant_q;
    assign selected_req = |(src_req & grant_onehot);

    // The state latch sets after the delayed capture request and resets only
    // after the selected source and receiver have both returned low.
    assign release_busy = busy_q & ~selected_req & ~aer_ack;
    assign busy_gate = capture_delay_5 | release_busy;

    (* dont_touch = "true" *) TLATRX1 busy_latch (
        .D  (capture_delay_5),
        .G  (busy_gate),
        .RN (rst_n),
        .Q  (busy_q),
        .QN ()
    );

    // Delay request assertion once more after busy closes the address latches.
    // Deassertion remains immediate when the selected source releases.
    (* dont_touch = "true" *) DLY4X1 request_launch_delay_cell (.A(busy_q), .Y(busy_launch_delay));

    assign aer_addr = grant_q;
    assign aer_req = busy_q & busy_launch_delay & selected_req;
    assign src_ack = (aer_req & aer_ack) ? grant_onehot : '0;
endmodule
