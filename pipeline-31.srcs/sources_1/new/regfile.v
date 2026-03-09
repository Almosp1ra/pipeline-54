`timescale 1ns / 1ps

module regfile(
    input  reg_clk,     // 时钟
    input  rst,         // reset
    input  RF_W,        // 写入寄存器信号
    input  [4:0] Rdc,
    input  [4:0] Rtc,
    input  [4:0] Rsc,
    input  [31:0] Rd,
    output [31:0] Rs,
    output [31:0] Rt,

    output [31:0] a_i,
    output [31:0] b_i,
    output [31:0] c_i,
    output [31:0] d_i
);
    reg [31:0] array_reg [31:0];

    // 寄存器输出
    assign Rs = array_reg[Rsc];
    assign Rt = array_reg[Rtc];
    // assign out_dropNum      = array_reg[4];
    // assign out_brokenNum    = array_reg[5];
    // assign out_isLastBroken = array_reg[6][0];

    // 写入
    // 这里用 negedge，是为了让 wb 能够在一个时钟周期内把数据写到 reg 里，免得相关的时候还要多等一个周期
    always @(negedge reg_clk, posedge rst)
    begin
        if(rst) begin // 置0
            array_reg[0]  <= 32'h0;
            array_reg[1]  <= 32'h0;
            array_reg[2]  <= 32'h0;
            //array_reg[2]  <= {26'b0, in_maxFloorNum[5:0]}; 
            array_reg[3]  <= 32'h0;
            //array_reg[3]  <= {26'b0, in_threshold[5:0]}; 
            array_reg[4]  <= 32'h0;
            array_reg[5]  <= 32'h0;
            array_reg[6]  <= 32'h0;
            array_reg[7]  <= 32'h0;
            array_reg[8]  <= 32'h0;
            array_reg[9]  <= 32'h0;
            array_reg[10] <= 32'h0;
            array_reg[11] <= 32'h0;
            array_reg[12] <= 32'h0;
            array_reg[13] <= 32'h0;
            array_reg[14] <= 32'h0;
            array_reg[15] <= 32'h0;
            array_reg[16] <= 32'h0;
            array_reg[17] <= 32'h0;
            array_reg[18] <= 32'h0;
            array_reg[19] <= 32'h0;
            array_reg[20] <= 32'h0;
            array_reg[21] <= 32'h0;
            array_reg[22] <= 32'h0;
            array_reg[23] <= 32'h0;
            array_reg[24] <= 32'h0;
            array_reg[25] <= 32'h0;
            array_reg[26] <= 32'h0;
            array_reg[27] <= 32'h0;
            array_reg[28] <= 32'h0;
            array_reg[29] <= 32'h0;
            array_reg[30] <= 32'h0;
            array_reg[31] <= 32'h0;
        end
        else if(RF_W && Rdc != 5'h0)
            array_reg[Rdc] <= Rd;
    end

    assign a_i = array_reg[7];
    assign b_i = array_reg[8];
    assign c_i = array_reg[13];
    assign d_i = array_reg[14];
    
endmodule