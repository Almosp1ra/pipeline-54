`timescale 1ns / 1ps

module comparer(
    input  [31:0] A,
    input  [31:0] B,
    
    output Comparer_Z,
    output Comparer_S
);
    assign Comparer_Z = (A == B) ? 1'b1 : 1'b0;
    assign Comparer_S = (A < B)  ? 1'b1 : 1'b0;
endmodule
