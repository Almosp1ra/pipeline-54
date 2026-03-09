`timescale 1ns / 1ps

module Divider(
	input clk,
	input rst,
	output reg clk_out
);
	reg [31:0] counter = 32'd0;	// 500,000 ·ÖÆµ
	always @(posedge clk) begin 
	if(rst) begin
		counter <= 32'd0;
		clk_out <= 0;
	end
	else if(counter == 32'd500000) begin 
		counter <= 32'd0;
		clk_out <= ~clk_out; 
	end 
	else
		counter <= counter + 1; 
end
 endmodule