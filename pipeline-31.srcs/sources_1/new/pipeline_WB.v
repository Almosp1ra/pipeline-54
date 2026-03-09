`timescale 1ns / 1ps

module pipeline_WB(
    input  clk,
    input  rst,
    input  ena,

    input [31:0] in_CP0,
    input [31:0] in_CLZ,
    input [31:0] in_jal,
    input [31:0] in_HILO,
    input [31:0] in_ALUO,
    input [31:0] in_LMD,
    input [31:0] in_ALU_C,
    input [31:0] in_ALU_S,
    input [4:0]  in_Rdc,
    
    input in_RF_W,
    input [2:0] in_MUX_Rd,

    output out_RF_W,
    output [31:0] out_Rd,
    output [4:0]  out_Rdc
);

    assign out_RF_W = in_RF_W;
    assign out_Rd = in_MUX_Rd == 3'b000 ? in_CP0 :
                    in_MUX_Rd == 3'b001 ? in_CLZ :
                    in_MUX_Rd == 3'b010 ? in_jal :
                    in_MUX_Rd == 3'b011 ? in_HILO :
                    in_MUX_Rd == 3'b100 ? in_ALUO :
                    in_MUX_Rd == 3'b101 ? in_LMD :
                    in_MUX_Rd == 3'b110 ? in_ALU_C : in_ALU_S;
    assign out_Rdc = in_Rdc;

endmodule