`timescale 1ns / 1ps

// CPU
module top(
    input clk_in,   // 时钟信号
    input reset,    // 复位信号

    input ena,
    input [1:0] display_switch,
    
    output [7:0]  o_seg,    //输出内容
    output [7:0]  o_sel     //片选信号
);
    // 七段数码管输出
    wire [31:0] seg7x16_data;
    wire [31:0] a_i;
    wire [31:0] b_i;
    wire [31:0] c_i;
    wire [31:0] d_i;

    // 模块实例化

    wire clk_cpu;
    wire [31:0] pc;
    wire [31:0] inst;

    CPU sccpu(
        .clk_in(clk_cpu), .reset(reset), .ena(ena),
        .out_instruction(inst), .out_pc(pc),
        .a_i(a_i), .b_i(b_i), .c_i(c_i), .d_i(d_i)
    );

    // 分频器
    Divider Divider_uut(
        .clk(clk_in),                   
        .rst(reset),                 
        .clk_out(clk_cpu)               
    );

    // 七段数码管实例化（使用系统时钟）
    assign seg7x16_data = display_switch == 2'b00 ? pc : 
                          display_switch == 2'b01 ? inst :
                          display_switch == 2'b10 ? c_i : d_i;

    seg7x16 seg7x16_uut(
        .clk(clk_in),
        .reset(reset),
        .cs(1'b1),
        .i_data(seg7x16_data),
        .o_seg(o_seg),
        .o_sel(o_sel)
    );

endmodule