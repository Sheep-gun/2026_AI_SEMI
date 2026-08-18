`timescale 1ns/1ps

// Traditional AER comparison baseline.
//
// Protocol model:
//   * One level-held request per event source.
//   * Fixed priority, source 0 highest.
//   * One shared binary address bus.
//   * Four-phase receiver request/acknowledge.
//   * No input FIFO: a source may hold only one outstanding event.
//
// This controller is intentionally synchronous so it can be synthesized with a
// conventional standard-cell flow. It implements four-phase protocol semantics;
// it is not claimed to be a hand-crafted delay-insensitive AER implementation.
module aer_traditional #(
    parameter integer NUM_SOURCES = 16,
    parameter integer ADDR_W = (NUM_SOURCES <= 1) ? 1 : $clog2(NUM_SOURCES)
) (
    input  logic                   clk,
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

    state_t state_q, state_d;
    logic [IDX_W-1:0] grant_q;
    logic [IDX_W-1:0] priority_idx;
    logic             priority_valid;
    integer           i;

    // Lowest numeric source index wins. This deliberately models the fairness
    // weakness that the proposed round-robin arbiter must remove.
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

    always_comb begin
        state_d = state_q;

        case (state_q)
            ST_IDLE: begin
                // Four-phase protocol requires the old sink acknowledge to be
                // low before a new request is launched.
                if (!aer_ack && priority_valid)
                    state_d = ST_WAIT_SINK_ACK;
            end

            ST_WAIT_SINK_ACK: begin
                if (aer_ack)
                    state_d = ST_WAIT_SOURCE_RELEASE;
            end

            ST_WAIT_SOURCE_RELEASE: begin
                if (!src_req[grant_q])
                    state_d = ST_WAIT_SINK_RELEASE;
            end

            ST_WAIT_SINK_RELEASE: begin
                if (!aer_ack)
                    state_d = ST_IDLE;
            end

            default: state_d = ST_IDLE;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_q <= ST_IDLE;
            grant_q <= '0;
        end else begin
            state_q <= state_d;
            if ((state_q == ST_IDLE) && !aer_ack && priority_valid)
                grant_q <= priority_idx;
        end
    end

    always_comb begin
        src_ack  = '0;
        aer_req  = 1'b0;
        aer_addr = grant_q;

        case (state_q)
            ST_WAIT_SINK_ACK: begin
                aer_req = 1'b1;
            end

            ST_WAIT_SOURCE_RELEASE: begin
                aer_req         = 1'b1;
                src_ack[grant_q] = 1'b1;
            end

            default: begin
                aer_req = 1'b0;
            end
        endcase
    end

endmodule

