`timescale 1ns / 1ps

module pipeline_IF(
    input  clk,
    input  rst,
    input  ena,
    input  in_stall,
    input  in_MUX_Branch,

    input  [31:0] in_PC,

    output [31:0] out_NPC,
    output [31:0] out_IR,
    output [31:0] out_PC
);
    // Ä£¿éÊµÀý»¯
    wire [31:0] PC_in;
    assign PC_in = in_MUX_Branch ?  in_PC : out_NPC;

    PC PC_uut(
        .PC_clk(clk), .rst(rst), .ena(ena), .stall(in_stall), .PC_in(PC_in),
        .PC_out(out_PC)
    );

    wire [31:0] I_address;
    assign I_address = out_PC - 32'h00400000;

    IMEM IMEM_uut(
        .I_address(I_address),
        .instruction(out_IR)
    );

    assign out_NPC = out_PC + 4;
    
endmodule