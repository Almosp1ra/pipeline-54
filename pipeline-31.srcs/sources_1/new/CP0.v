`timescale 1ns / 1ps

module CP0(
    input clk,
    input rst,
    input mfc0,
    input mtc0,
    input [31:0] pc,
    input [4:0]  Rd,     // 指定CP0寄存器
    input [31:0] wdata, // 写入数据
    input exception,    // 当发生产生异常时置高
    input eret,
    input [4:0]cause,   // 异常原因代码（5位），写入cause寄存器
    input intr,         // 外部中断信号
    output [31:0] rdata, // 读出数据
    output [31:0] status,
    output reg timer_int, // 当count与compare匹配时产生定时器中断
    output reg inta,      // 外部中断确认信号
    output [31:0] exc_addr // 若eret有效返回EPC，否则返回异常入口向量地址
);
    integer i;
    // 寄存器定义
    reg [31:0] cp0_reg [0:31];
    reg [31:0] status_backup;   // 用于中断时保存status寄存器的值
    integer CP0_REG_STATUS = 12;
    integer CP0_REG_CAUSE  = 13;
    integer CP0_REG_EPC    = 14;
    // status寄存器的中断屏蔽位
    integer SYSCALL_MASK_BIT = 8;
    integer BREAK_MASK_BIT   = 9;
    integer TEQ_MASK_BIT     = 10;
    // 异常类型号
    integer EXC_SYSCALL = 5'b01000;
    integer EXC_BREAK   = 5'b01001;
    integer EXC_TEQ     = 5'b01101;
    // 异常入口
    integer EXCEPTION_ENTRY = 32'h0040_0004;
    //integer EXCEPTION_ENTRY = 32'h0040_0078;    // 测试程序中的异常入口位置

    always @(negedge clk, posedge rst) begin
        if(rst) begin   // 复位
            for (i = 0; i < 32; i = i + 1) begin
                cp0_reg[i] <= 32'b0;
            end
            status_backup <= 32'b0;
            cp0_reg[CP0_REG_STATUS] <= 32'h0000_0001;
            timer_int <= 1'b0;
            inta <= 1'b0;
        end
        else begin
            // 外部中断
            if (intr && cp0_reg[CP0_REG_STATUS][0] == 1'b1) begin
                cp0_reg[CP0_REG_CAUSE][6:2] <= 5'b00000;
                cp0_reg[CP0_REG_CAUSE][15:10] <= 6'b111111;
                inta <= 1'b1;
            end
            else begin
                inta <= 1'b0;
                // 异常响应，包括break、syscall、teq
                if (exception && cp0_reg[CP0_REG_STATUS][0] == 1'b1) begin
                    if(cause == EXC_BREAK   && cp0_reg[CP0_REG_STATUS][BREAK_MASK_BIT] == 1'b0 ||
                       cause == EXC_SYSCALL && cp0_reg[CP0_REG_STATUS][SYSCALL_MASK_BIT] == 1'b0 ||
                       cause == EXC_TEQ     && cp0_reg[CP0_REG_STATUS][TEQ_MASK_BIT] == 1'b0) begin
                        status_backup <= cp0_reg[CP0_REG_STATUS];   // 保存status
                        cp0_reg[CP0_REG_STATUS] <= cp0_reg[CP0_REG_STATUS] << 5;    // 左移5位关中断
                        cp0_reg[CP0_REG_EPC] <= pc + 32'h0000_0004; // pc + 4
                        cp0_reg[CP0_REG_CAUSE] <= {27'b0, cause, 2'b0};
                    end
                end 
                // mtc0 （写操作）
                else if (mtc0) begin
                    cp0_reg[Rd] <= wdata;
                end 
                // 异常返回
                else if (eret) begin
                    cp0_reg[CP0_REG_STATUS] <= status_backup;   // 写回status
                end
            end
        end
    end

    // 输出内容
    assign rdata = (mfc0) ? cp0_reg[Rd] : 32'b0;    // mfc0读数据
    assign status = cp0_reg[CP0_REG_STATUS];        // status寄存器内容
    assign exc_addr = eret ? cp0_reg[CP0_REG_EPC] : EXCEPTION_ENTRY;    // 异常起始地址
endmodule
