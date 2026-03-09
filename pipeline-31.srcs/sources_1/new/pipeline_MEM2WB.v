`timescale 1ns / 1ps

module pipeline_MEM2WB(
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

    output reg [31:0] out_CP0,
    output reg [31:0] out_CLZ,
    output reg [31:0] out_jal,
    output reg [31:0] out_HILO,
    output reg [31:0] out_ALUO,
    output reg [31:0] out_LMD,
    output reg [31:0] out_ALU_C,
    output reg [31:0] out_ALU_S,
    output reg [4:0]  out_Rdc,
    
    output reg out_RF_W,
    output reg [2:0] out_MUX_Rd
);
    always @(posedge clk, posedge rst) 
    begin
        if(rst) begin
            out_CP0   <= 32'b0;
            out_CLZ   <= 32'b0;
            out_jal   <= 32'b0;
            out_HILO  <= 32'b0;
            out_ALUO  <= 32'b0;
            out_LMD   <= 32'b0;
            out_ALU_C <= 32'b0;
            out_ALU_S <= 32'b0;
            out_Rdc <= 5'b0;
            out_RF_W <= 1'b0;
            out_MUX_Rd <= 3'b0;
        end
        else if(ena) begin
            out_CP0   <= in_CP0;
            out_CLZ   <= in_CLZ;
            out_jal   <= in_jal;
            out_HILO  <= in_HILO;
            out_ALUO  <= in_ALUO;
            out_LMD   <= in_LMD;
            out_ALU_C <= in_ALU_C;
            out_ALU_S <= in_ALU_S;
            out_Rdc <= in_Rdc;
            out_RF_W <= in_RF_W;
            out_MUX_Rd <= in_MUX_Rd;
        end
    end
    
endmodule