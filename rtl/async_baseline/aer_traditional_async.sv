`timescale 1ns/1ps

// Clockless functional reference for a traditional shared-bus AER controller.
//
// Protocol model:
//   * One level-held request per event source.
//   * Fixed priority, source 0 highest.
//   * One shared binary address bus.
//   * Receiver-facing active-high four-phase request/acknowledge.
//   * No input FIFO: a source may hold only one outstanding event.
//   * State advances from request/acknowledge transitions, not a global clock.
//
// IMPORTANT SAFETY BOUNDARY:
//   This module is an A0-functional clockless protocol baseline. The available
//   project library has no characterized MUTEX or Muller C-element. Therefore
//   simultaneous asynchronous request arbitration is not claimed to be
//   metastability-safe or ASIC-signoff ready. The fixed-priority encoder is a
//   deterministic functional model; it is not a physical mutual-exclusion cell.
module aer_traditional_async #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  logic                   rst_n,

    input  logic [NUM_SOURCES-1:0] src_req,
    output logic [NUM_SOURCES-1:0] src_ack,

    output logic [ADDR_W-1:0]      aer_addr,
    output logic                   aer_req,
    input  logic                   aer_ack
);

    localparam integer IDX_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES);

    typedef enum logic [1:0] {
        ST_IDLE,
        ST_WAIT_SINK_ACK,
        ST_WAIT_SOURCE_RELEASE,
        ST_WAIT_SINK_RELEASE
    } state_t;

    state_t           state_q;
    logic [IDX_W-1:0] grant_q;
    logic [IDX_W-1:0] priority_idx;
    logic             priority_valid;
    logic [NUM_SOURCES-1:0] grant_onehot;
    integer           i;

    // Functional fixed-priority selection. A physical fully asynchronous
    // implementation needs a characterized arbiter/MUTEX for near-simultaneous
    // requests; ordinary combinational priority logic does not provide that.
    always_comb begin
        priority_idx   = '0;
        priority_valid = 1'b0;
        for (i = 0; i < NUM_SOURCES; i = i + 1) begin
            if (!priority_valid && src_req[i]) begin
                priority_idx   = i[IDX_W-1:0];
                priority_valid = 1'b1;
            end
        end
    end

    // Self-timed control latch. Each state is held until the corresponding
    // handshake condition changes. No global clock participates in progress.
    // state_q is intentionally present in the sensitivity list. When one
    // handshake completes and the machine returns to IDLE, a request that was
    // already high must launch the next transaction without waiting for a new
    // input edge. This explicit event model is for clockless functional
    // simulation; physical mapping still requires asynchronous-cell review.
    always @(rst_n or state_q or priority_valid or priority_idx or
             aer_ack or src_req or grant_q) begin
        if (!rst_n) begin
            state_q <= ST_IDLE;
            grant_q <= '0;
        end else begin
            case (state_q)
                ST_IDLE: begin
                    if (!aer_ack && priority_valid) begin
                        grant_q <= priority_idx;
                        state_q <= ST_WAIT_SINK_ACK;
                    end
                end

                ST_WAIT_SINK_ACK: begin
                    if (aer_ack)
                        state_q <= ST_WAIT_SOURCE_RELEASE;
                end

                ST_WAIT_SOURCE_RELEASE: begin
                    if (!src_req[grant_q])
                        state_q <= ST_WAIT_SINK_RELEASE;
                end

                ST_WAIT_SINK_RELEASE: begin
                    if (!aer_ack)
                        state_q <= ST_IDLE;
                end

                default: begin
                    state_q <= ST_IDLE;
                    grant_q <= '0;
                end
            endcase
        end
    end

    // Single-expression outputs avoid a delta-cycle request glitch when the
    // state changes between the two request-high phases.
    assign grant_onehot = {{(NUM_SOURCES-1){1'b0}}, 1'b1} << grant_q;
    assign aer_addr = grant_q;
    assign aer_req = (state_q == ST_WAIT_SINK_ACK) ||
                     (state_q == ST_WAIT_SOURCE_RELEASE);
    assign src_ack = (state_q == ST_WAIT_SOURCE_RELEASE) ? grant_onehot : '0;

endmodule
