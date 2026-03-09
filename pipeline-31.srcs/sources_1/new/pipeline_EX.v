`timescale 1ns / 1ps

module pipeline_EX(
    input  clk,
    input  rst,
    input  ena,

    input [31:0] in_A,
    input [31:0] in_B,
    input [31:0] in_Rt,
    input [4:0]  in_Rdc,
    input [31:0] in_CP0,
    input [31:0] in_jal,
    
    input [3:0] in_ALUC,
    input in_RF_W,
    input in_DM_R,
    input in_DM_W,
    input in_HI_W,
    input in_LO_W,
    input [2:0] in_MUX_HI,
    input [2:0] in_MUX_LO,
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

    input in_start_mult,
    input in_start_multu,
    input in_start_div,
    input in_start_divu,

    output [31:0] out_CP0,
    output [31:0] out_CLZ,
    output [31:0] out_jal,
    output [31:0] out_HI,
    output [31:0] out_LO,
    output [31:0] out_ALUO,
    output [31:0] out_Rt,
    output [31:0] out_ALU_C,
    output [31:0] out_ALU_S,
    output [4:0]  out_Rdc,
    
    output out_RF_W,
    output out_DM_R,
    output out_DM_W,
    output out_HI_W,
    output out_LO_W,
    output out_MUX_HILO,
    output [2:0] out_MUX_LMD,
    output [2:0] out_MUX_Rd,

    output out_sw_flag,
    output out_sb_flag,
    output out_sh_flag,
    output out_lbu_flag,
    output out_lhu_flag,
    output out_lb_flag,
    output out_lh_flag,
    output out_lw_flag,

    output out_mult_busy,
    output out_multu_busy,
    output out_div_busy,
    output out_divu_busy
);

    // 模块实例化

    wire ALU_C;
    wire ALU_S;

    ALU ALU_uut(
        .ALUC(in_ALUC), .A(in_A), .B(in_B),
        .F(out_ALUO), .Z(), .C(ALU_C), .N(), .O(), .S(ALU_S)
    );

    CLZ CLZ_uut(
        .CLZ_in(in_A),
        .CLZ_out(out_CLZ)
    );

    wire [63:0] mult_result;
    wire [63:0] multu_result;
    wire [31:0] div_q;
    wire [31:0] div_r;
    wire [31:0] divu_q;
    wire [31:0] divu_r;
    wire mult_busy;
    wire multu_busy;
    wire div_busy;
    wire divu_busy;    

    MULT MULT_uut(
        .clk(clk), .reset(rst), .ena(ena), .start(in_start_mult),
        .a(in_A), .b(in_B),
        .z(mult_result), .busy(mult_busy)
    );

    MULTU MULTU_uut(
        .clk(clk), .reset(rst), .ena(ena), .start(in_start_multu),
        .a(in_A), .b(in_B),
        .z(multu_result), .busy(multu_busy)
    );

    DIV DIV_uut(
        .clk(clk), .reset(rst), .ena(ena), .start(in_start_div),
        .dividend(in_A), .divisor(in_B),
        .q(div_q), .r(div_r), .busy(div_busy)
    );

    DIVU DIVU_uut(
        .clk(clk), .reset(rst), .ena(ena), .start(in_start_divu),
        .dividend(in_A), .divisor(in_B),
        .q(divu_q), .r(divu_r), .busy(divu_busy)
    );

    wire [2:0] MUX_HI;
    wire [2:0] MUX_LO;

    MULTDIVmanager MULTDIVmanager_uut(
        .clk(clk), .rst(rst), .ena(ena),
        .start_mult(in_start_mult), .start_multu(in_start_multu), .start_div(in_start_div), .start_divu(in_start_divu),
        .in_HI_W(in_HI_W), .in_LO_W(in_LO_W), .in_MUX_HI(in_MUX_HI), .in_MUX_LO(in_MUX_LO),
        .in_mult_busy(mult_busy), .in_multu_busy(multu_busy), .in_div_busy(div_busy), .in_divu_busy(divu_busy),
        .out_mult_busy(out_mult_busy), .out_multu_busy(out_multu_busy), .out_div_busy(out_div_busy), .out_divu_busy(out_divu_busy),
        .out_HI_W(out_HI_W), .out_LO_W(out_LO_W), .out_MUX_HI(MUX_HI), .out_MUX_LO(MUX_LO)
    );

    // 输出

    assign out_CP0 = in_CP0;
    assign out_jal = in_jal;

    assign out_HI = MUX_HI == 3'b000 ? mult_result[63:32] :
                    MUX_HI == 3'b001 ? multu_result[63:32] :
                    MUX_HI == 3'b010 ? div_r :
                    MUX_HI == 3'b011 ? divu_r : in_A;

    assign out_LO = MUX_LO == 3'b000 ? mult_result[31:0] :
                    MUX_LO == 3'b001 ? multu_result[31:0] :
                    MUX_LO == 3'b010 ? div_q :
                    MUX_LO == 3'b011 ? divu_q : in_A;

    assign out_Rt = in_Rt;
    assign out_ALU_C = {31'b0, ALU_C};
    assign out_ALU_S = {31'b0, ALU_S};
    assign out_Rdc = in_Rdc;
    
    assign out_RF_W = in_RF_W;
    assign out_DM_R = in_DM_R;
    assign out_DM_W = in_DM_W;
    // assign out_HI_W = in_HI_W;
    // assign out_LO_W = in_LO_W;
    assign out_MUX_HILO = in_MUX_HILO;
    assign out_MUX_LMD  = in_MUX_LMD;
    assign out_MUX_Rd   = in_MUX_Rd;
    assign out_sw_flag  = in_sw_flag;
    assign out_sb_flag  = in_sb_flag;
    assign out_sh_flag  = in_sh_flag;
    assign out_lbu_flag = in_lbu_flag;
    assign out_lhu_flag = in_lhu_flag;
    assign out_lb_flag  = in_lb_flag;
    assign out_lh_flag  = in_lh_flag;
    assign out_lw_flag  = in_lw_flag;

endmodule