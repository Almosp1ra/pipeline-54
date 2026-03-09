`timescale 1ns / 1ps

// CPU
module top(
    input clk_in,   // 时钟信号
    input reset,    // 复位信号
    input ena,
    output [31:0] inst, //输出指令
    output [31:0] pc,   //执行地址

    output [31:0] a_i,
    output [31:0] b_i,
    output [31:0] c_i,
    output [31:0] d_i
);
    // 模块实例化
    CPU sccpu(
        .clk_in(clk_in), .reset(reset), .ena(ena),
        .out_instruction(inst), .out_pc(pc),
        .a_i(a_i), .b_i(b_i), .c_i(c_i), .d_i(d_i)
    );

endmodule