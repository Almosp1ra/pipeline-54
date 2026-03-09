`timescale 1ns / 1ps

module HI_LO(
    input  clk,    // Ê±ÖÓ
    input  rst,    // reset
    input  HI_W,
    input  LO_W,
    input  [31:0] HI_in,
    input  [31:0] LO_in,
    output [31:0] HI_out,
    output [31:0] LO_out
);
    reg [31:0] HI_reg;
    reg [31:0] LO_reg;
    assign HI_out = HI_reg;
    assign LO_out = LO_reg;

    always @(posedge clk, posedge rst) begin
        if(rst) begin
            HI_reg <= 32'h00000000;
            LO_reg <= 32'h00000000;
        end
        else begin
            if(HI_W)
                HI_reg <= HI_in;
            if(LO_W)
                LO_reg <= LO_in;
        end
    end

endmodule
