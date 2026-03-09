`timescale 1ns / 1ps

module DMEM(
    input D_clk,
    input DM_R,
    input DM_W,
    input [31:0] D_address,
    input [31:0] D_data_in,
    input D_sw_flag,
    input D_sb_flag,
    input D_sh_flag,
    input D_lbu_flag,
    input D_lhu_flag,
    input D_lb_flag,
    input D_lh_flag,
    input D_lw_flag,
    
    output [31:0] D_data_out
);

reg [31:0] dmem [0:4095]; // DMEM
assign D_data_out = (DM_R && !DM_W) ? 
                        (D_lw_flag ? dmem[D_address[13:2]] :
                        (D_lb_flag ? { {24{dmem[D_address[11:0]][7]}} , dmem[D_address[11:0]][7:0] } :
                        (D_lbu_flag ? { 24'h0 , dmem[D_address[11:0]][7:0] } :
                        (D_lh_flag ? { {16{dmem[D_address[12:1]][15]}} , dmem[D_address[12:1]][15:0] } :
                        (D_lhu_flag ? { 16'h0 , dmem[D_address[12:1]][15:0] } :
                         32'bz
                        )))))
                    : 32'bz;

always @(posedge D_clk) begin
    if(!DM_R && DM_W) begin
        if(D_sw_flag)
            dmem[D_address[13:2]] <= D_data_in;              // word
        else if(D_sb_flag)
            dmem[D_address[11:0]][7:0] <= D_data_in[7:0];    // bite
        else if(D_sh_flag)
            dmem[D_address[12:1]][15:0] <= D_data_in[15:0];  // halfword
    end
end
endmodule
