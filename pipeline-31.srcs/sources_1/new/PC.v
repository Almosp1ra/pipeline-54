`timescale 1ns / 1ps

module PC(
    input  PC_clk,     // Ê±ÖÓ
    input  rst,        // reset
    input  ena,
    input  stall,      // stall 
    input  [31:0] PC_in,    // ÊäÈë
    output [31:0] PC_out    // Êä³ö
);
    reg [31:0] PC_reg = 32'h00400000;

    assign PC_out = PC_reg;

    always @(posedge PC_clk, posedge rst) begin
        if(rst) begin
            PC_reg <= 32'h00400000;
        end
        else begin
            if(stall | ~ena)
               PC_reg <= PC_reg;
            else
               PC_reg <= PC_in;
        end
    end
endmodule
