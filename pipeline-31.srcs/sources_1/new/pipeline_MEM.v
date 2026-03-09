`timescale 1ns / 1ps

module pipeline_MEM(
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

    output [31:0] out_CP0,
    output [31:0] out_CLZ,
    output [31:0] out_jal,
    output [31:0] out_HILO,
    output [31:0] out_ALUO,
    output [31:0] out_LMD,
    output [31:0] out_ALU_C,
    output [31:0] out_ALU_S,
    output [4:0]  out_Rdc,
    
    output out_RF_W,
    output [2:0] out_MUX_Rd
);
    // 模块实例化
    
    wire [31:0] D_data_out;

    DMEM DMEM_uut(
        .D_clk(clk), .DM_R(in_DM_R), .DM_W(in_DM_W), .D_address(in_ALUO), .D_data_in(in_Rt),
        .D_sw_flag(in_sw_flag), .D_sb_flag(in_sb_flag), .D_sh_flag(in_sh_flag),
        .D_lbu_flag(in_lbu_flag), .D_lhu_flag(in_lhu_flag), .D_lb_flag(in_lb_flag), .D_lh_flag(in_lh_flag), .D_lw_flag(in_lw_flag),
        .D_data_out(D_data_out)
    );

    wire [31:0] HI_out;
    wire [31:0] LO_out;

    HI_LO HI_LO_uut(
        .clk(clk), .rst(rst),
        .HI_W(in_HI_W), .LO_W(in_LO_W),
        .HI_in(in_HI), .LO_in(in_LO),
        .HI_out(HI_out), .LO_out(LO_out)
    );
    
    // 数据扩展

    wire [31:0] ext8_lbu, ext16_lhu, s_ext8_lb, s_ext16_lh;
    assign ext8_lbu   = {24'b0, D_data_out[7:0]};
    assign ext16_lhu  = {16'b0, D_data_out[15:0]};
    assign s_ext8_lb  = {{24{D_data_out[7]}}, D_data_out[7:0]};
    assign s_ext16_lh = {{16{D_data_out[15]}}, D_data_out[15:0]};

    // 输出
    
    assign out_CP0 = in_CP0;
    assign out_CLZ = in_CLZ;
    assign out_jal = in_jal;
    assign out_HILO = in_MUX_HILO ? LO_out : HI_out;
    assign out_ALUO = in_ALUO;
    assign out_LMD = in_MUX_LMD == 3'b000 ? D_data_out :
                     in_MUX_LMD == 3'b001 ? s_ext16_lh :
                     in_MUX_LMD == 3'b010 ? ext16_lhu :
                     in_MUX_LMD == 3'b011 ? s_ext8_lb : ext8_lbu;
    assign out_ALU_C = in_ALU_C;
    assign out_ALU_S = in_ALU_S;
    assign out_Rdc = in_Rdc;
    
    assign out_RF_W = in_RF_W;
    assign out_MUX_Rd = in_MUX_Rd;

endmodule