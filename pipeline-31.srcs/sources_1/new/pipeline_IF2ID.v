`timescale 1ns / 1ps

module pipeline_IF2ID(
    input  clk,
    input  rst,
    input  ena,
    input  in_stall,
    input  in_MUX_Branch,

    input [31:0] in_NPC,
    input [31:0] in_IR,
    input [31:0] in_PC,

    output reg [31:0] out_NPC,
    output reg [31:0] out_IR,
    output reg [31:0] out_PC
);
    
    always @(posedge clk, posedge rst) 
    begin
        if(rst) begin
            out_NPC <= 32'b0;
            out_IR  <= 32'b0;
            out_PC  <= 32'b0;
        end
        else if(in_stall) begin
            out_NPC <= out_NPC;
            out_IR  <= out_IR;
            out_PC  <= out_PC;
        end
        else if(in_MUX_Branch) begin
            out_NPC <= 32'b0;
            out_IR  <= 32'b0;
            out_PC  <= 32'b0;
        end
        else begin
            out_NPC <= in_NPC;
            out_IR  <= in_IR;
            out_PC  <= in_PC;
        end
    end
    
endmodule