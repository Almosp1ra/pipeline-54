 `timescale 1ns / 1ps

module testbench;

	// Inputs
	reg clk_in;
	reg reset; 
	reg ena; 
	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;

    wire [31:0] a_i;
    wire [31:0] b_i;
    wire [31:0] c_i;
    wire [31:0] d_i;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk_in(clk_in),  .reset(reset), .ena(ena),
		.inst(inst), .pc(pc),
        .a_i(a_i), .b_i(b_i), .c_i(c_i), .d_i(d_i)
	);
	
	initial begin
		clk_in = 0;
		reset = 1;
		ena = 1;
		#6;
        reset = 0;		
		// # 100
		// ena = 0;
		// # 100
		// ena = 1;
	end

	// 仿真时查看寄存器的值
    wire [31:0] reg0    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[0];
    wire [31:0] reg1    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[1];
    wire [31:0] reg2    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[2];   
    wire [31:0] reg3    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[3];
    wire [31:0] reg4    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[4];
    wire [31:0] reg5    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[5];
    wire [31:0] reg6    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[6];
    wire [31:0] reg7    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[7];
    wire [31:0] reg8    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[8];
    wire [31:0] reg9    = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[9];
    wire [31:0] reg10   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[10];
    wire [31:0] reg11   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[11];
    wire [31:0] reg12   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[12];
    wire [31:0] reg13   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[13];
    wire [31:0] reg14   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[14];
    wire [31:0] reg15   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[15];
	wire [31:0] reg16   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[16];
	wire [31:0] reg17   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[17];
	wire [31:0] reg18   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[18];
	wire [31:0] reg19   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[19];
	wire [31:0] reg20   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[20];
	wire [31:0] reg21   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[21];
	wire [31:0] reg22   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[22];
	wire [31:0] reg23   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[23];
	wire [31:0] reg24   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[24];
	wire [31:0] reg25   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[25];
	wire [31:0] reg26   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[26];
	wire [31:0] reg27   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[27];
	wire [31:0] reg28   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[28];
	wire [31:0] reg29   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[29];
	wire [31:0] reg30   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[30];
	wire [31:0] reg31   = testbench.uut.sccpu.pipeline_ID_uut.regfile_uut.array_reg[31];
	
    wire [31:0] clk_counter = testbench.uut.sccpu.pipeline_ID_uut.clk_counter;
    // wire [31:0] alu_counter    = testbench.uut.sccpu.pipeline_ID_uut.alu_counter;
    // wire [31:0] branch_counter = testbench.uut.sccpu.pipeline_ID_uut.branch_counter;
    // wire [31:0] mem_counter    = testbench.uut.sccpu.pipeline_ID_uut.mem_counter;
    // wire [31:0] other_counter  = testbench.uut.sccpu.pipeline_ID_uut.other_counter;
   
	always begin		
		#2;	
		clk_in = ~clk_in;
	end
	
endmodule

