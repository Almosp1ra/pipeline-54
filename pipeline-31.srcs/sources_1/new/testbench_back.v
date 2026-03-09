 `timescale 1ns / 1ps

module testbench;

	// Inputs
	reg clk_in;
	reg reset; 
	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;

    reg [31:0] in_maxFloorNum;
    reg [31:0] in_threshold;

    wire [31:0] out_dropNum;
    wire [31:0] out_brokenNum;
    wire out_isLastBroken;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk_in(clk_in),  .reset(reset), 
		
        .in_maxFloorNum(in_maxFloorNum), .in_threshold(in_threshold),
        .out_isLastBroken(out_isLastBroken)
	);
	
	initial begin
		clk_in = 0;
		reset = 1;
		in_maxFloorNum = 9;
		in_threshold = 7;
		#6;
        reset = 0;
        reset = 0;		
	end
   
	always begin		
		#2;	
		clk_in = ~clk_in;
	end
	
endmodule

