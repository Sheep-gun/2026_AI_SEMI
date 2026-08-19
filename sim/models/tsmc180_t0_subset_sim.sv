`timescale 1ns/1ps

// Functional simulation models for the exact characterized cells instantiated
// by T0-PPA. Physical synthesis and P&R use the Liberty/LEF definitions.
module TLATRX1 (
    input  wire D,
    input  wire G,
    input  wire RN,
    output wire Q,
    output wire QN
);
    reg iq;
    always @(D or G or RN) begin
        if (!RN)
            iq <= 1'b0;
        else if (G)
            iq <= D;
    end
    assign Q = iq;
    assign QN = ~iq;
endmodule

module DLY4X1 (
    input  wire A,
    output wire Y
);
    // The local functional model gives the self-timed RTL test a finite delay.
    // Signoff-oriented delay comes from the corner Liberty/SDF, not this value.
    assign #(0.200) Y = A;
endmodule
