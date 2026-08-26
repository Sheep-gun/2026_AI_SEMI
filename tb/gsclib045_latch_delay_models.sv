`timescale 1ns/1ps
module TLATX1(output logic Q,output logic QN,input logic D,input logic G);
    always_latch if(G)Q<=D;
    assign QN=~Q;
endmodule
module DLY4X1(output logic Y,input logic A);assign #1 Y=A;endmodule
