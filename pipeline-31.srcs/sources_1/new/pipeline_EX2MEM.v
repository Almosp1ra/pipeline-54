`timescale 1ns / 1ps

module pipeline_EX2MEM(
    input  clk,
    input  rst,
    input  ena,

    input [31:0] in_CP0,
    input [31:0] in_CLZ,
    input [31:0] in_jal,
    input [31:0] in_HI,
    input [31:0] in_LO,
    input [31:0] in_ALUO,
    input [31:0] in_Rt,
    input [31:0] in_ALU_C,
    input [31:0] in_ALU_S,
    input [4:0]  in_Rdc,
    
    input in_RF_W,
    input in_DM_R,
    input in_DM_W,
    input in_HI_W,
    input in_LO_W,
    input in_MUX_HILO,
    input [2:0] in_MUX_LMD,
    input [2:0] in_MUX_Rd,

    input in_sw_flag,
    input in_sb_flag,
    input in_sh_flag,
    input in_lbu_flag,
    input in_lhu_flag,
    input in_lb_flag,
    input in_lh_flag,
    input in_lw_flag,

    output reg [31:0] out_CP0,
    output reg [31:0] out_CLZ,
    output reg [31:0] out_jal,
    output reg [31:0] out_HI,
    output reg [31:0] out_LO,
    output reg [31:0] out_ALUO,
    output reg [31:0] out_Rt,
    output reg [31:0] out_ALU_C,
    output reg [31:0] out_ALU_S,
    output reg [4:0]  out_Rdc,
    
    output reg out_RF_W,
    output reg out_DM_R,
    output reg out_DM_W,
    output reg out_HI_W,
    output reg out_LO_W,
    output reg out_MUX_HILO,
    output reg [2:0] out_MUX_LMD,
    output reg [2:0] out_MUX_Rd,

    output reg out_sw_flag,
    output reg out_sb_flag,
    output reg out_sh_flag,
    output reg out_lbu_flag,
    output reg out_lhu_flag,
    output reg out_lb_flag,
    output reg out_lh_flag,
    output reg out_lw_flag
);

    always @(posedge clk, posedge rst) 
    begin
        if(rst) begin
            out_CP0   <= 32'b0;
            out_CLZ   <= 32'b0;
            out_jal   <= 32'b0;
            out_HI    <= 32'b0;
            out_LO    <= 32'b0;
            out_ALUO  <= 32'b0;
            out_Rt     <= 32'b0;
            out_ALU_C <= 32'b0;
            out_ALU_S <= 32'b0;
            out_Rdc <= 5'b0;
            out_RF_W <= 1'b0;
            out_DM_R <= 1'b0;
            out_DM_W <= 1'b0;
            out_HI_W <= 1'b0;
            out_LO_W <= 1'b0;
            out_MUX_HILO <= 1'b0;
            out_MUX_LMD <= 3'b0;
            out_MUX_Rd  <= 3'b0;
            out_sw_flag <= 1'b0;
            out_sb_flag <= 1'b0;
            out_sh_flag <= 1'b0;
            out_lbu_flag <= 1'b0;
            out_lhu_flag <= 1'b0;
            out_lb_flag <= 1'b0;
            out_lh_flag <= 1'b0;
            out_lw_flag <= 1'b0;
        end
        else if(ena) begin
            out_CP0   <= in_CP0;
            out_CLZ   <= in_CLZ;
            out_jal   <= in_jal;
            out_HI    <= in_HI;
            out_LO    <= in_LO;
            out_ALUO  <= in_ALUO;
            out_Rt     <= in_Rt;
            out_ALU_C <= in_ALU_C;
            out_ALU_S <= in_ALU_S;
            out_Rdc <= in_Rdc;
            out_RF_W <= in_RF_W;
            out_DM_R <= in_DM_R;
            out_DM_W <= in_DM_W;
            out_HI_W <= in_HI_W;
            out_LO_W <= in_LO_W;
            out_MUX_HILO <= in_MUX_HILO;
            out_MUX_LMD  <= in_MUX_LMD;
            out_MUX_Rd   <= in_MUX_Rd;
            out_sw_flag  <= in_sw_flag;
            out_sb_flag  <= in_sb_flag;
            out_sh_flag  <= in_sh_flag;
            out_lbu_flag <= in_lbu_flag;
            out_lhu_flag <= in_lhu_flag;
            out_lb_flag  <= in_lb_flag;
            out_lh_flag  <= in_lh_flag;
            out_lw_flag  <= in_lw_flag;
        end
    end
    
endmodule