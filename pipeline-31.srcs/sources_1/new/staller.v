`timescale 1ns / 1ps

// 流水线暂停控制
module staller(
    input clk,
    input rst,

    input [4:0] Rsc,
    input [4:0] Rtc,
    input Rs_R,
    input Rt_R,

    input ex_wena,
    input [4:0] ex_Rdc,
    input mem_wena,
    input [4:0] mem_Rdc,

    input div_flag,
    input divu_flag,
    input mult_flag,
    input multu_flag,
    input mfhi_flag,
    input mflo_flag,
    input mthi_flag,
    input mtlo_flag,

    input mult_busy,
    input multu_busy,
    input div_busy,
    input divu_busy,

    output final_stall
);
    // 需要新增的暂停：当乘除法正在进行，并且发生 资源相关 或 读写 HILO 时，暂停直到完成

    reg stall;
    reg [1:0] stall_time;
    reg multdiv_stall_flag;

    always @(negedge clk, posedge rst) begin
        if(rst) begin
            stall <= 0;
            stall_time <= 2'b0;
            multdiv_stall_flag <= 1'b0;
        end
        else begin
            // 已经暂停
            if(stall) begin
                if(stall_time == 2'b0)
                    stall <= 0;
                else
                    stall_time <= stall_time - 1;
            end
            // 当前指令的操作数寄存器在等待当前执行到 ex 阶段的指令写回
            else if(ex_wena && (Rsc == ex_Rdc && Rs_R || Rtc == ex_Rdc && Rt_R)) begin
                stall <= 1;
                stall_time <= 2'd1;
            end
            // 当前指令的操作数寄存器在等待当前执行到 mem 阶段的指令写回
            else if(mem_wena && (Rsc == mem_Rdc && Rs_R || Rtc == mem_Rdc && Rt_R)) begin
                stall <= 1;
                stall_time <= 2'd0;
            end
            else
                stall <= 0;
        end
    end

    assign final_stall = (stall) ||
                         (mult_busy && mult_flag) ||
                         (multu_busy && multu_flag) ||
                         (div_busy && div_flag) ||
                         (divu_busy && divu_flag) ||
                         ((mult_busy || multu_busy || div_busy || divu_busy) && (mfhi_flag || mflo_flag || mthi_flag || mtlo_flag));

endmodule