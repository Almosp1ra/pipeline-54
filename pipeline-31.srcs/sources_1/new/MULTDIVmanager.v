`timescale 1ns / 1ps

// 管理乘除法模块，输出用于判断流水暂停的四个模块的 busy 标识，暂存和输出其 HILO 相关的控制信号

module MULTDIVmanager(
    input clk,
    input rst,
    input ena,

    input in_HI_W,
    input in_LO_W,
    input [2:0] in_MUX_HI,
    input [2:0] in_MUX_LO,
    
    input start_mult,
    input start_multu,
    input start_div,
    input start_divu,

    input in_mult_busy,
    input in_multu_busy,
    input in_div_busy,
    input in_divu_busy,

    output out_mult_busy,
    output out_multu_busy,
    output out_div_busy,
    output out_divu_busy,

    output out_HI_W,
    output out_LO_W,
    output [2:0] out_MUX_HI,
    output [2:0] out_MUX_LO
);

    // 状态常量

    parameter STATUS_IDLE = 2'b00;
    parameter STATUS_BUSY = 2'b01;
    parameter STATUS_COMPLETE = 2'b10;

    reg [1:0] mult_status;
    reg [1:0] multu_status;
    reg [1:0] div_status;
    reg [1:0] divu_status;

    // 保存的控制信号

    reg mult_HI_W_reg;
    reg mult_LO_W_reg;
    reg [2:0] mult_MUX_HI_reg;
    reg [2:0] mult_MUX_LO_reg;

    reg multu_HI_W_reg;
    reg multu_LO_W_reg;
    reg [2:0] multu_MUX_HI_reg;
    reg [2:0] multu_MUX_LO_reg;

    reg div_HI_W_reg;
    reg div_LO_W_reg;
    reg [2:0] div_MUX_HI_reg;
    reg [2:0] div_MUX_LO_reg;

    reg divu_HI_W_reg;
    reg divu_LO_W_reg;
    reg [2:0] divu_MUX_HI_reg;
    reg [2:0] divu_MUX_LO_reg;

    // 状态机，在 clk 下降沿触发，读取 start 信号和 busy 信号、保存控制信号

    always @(negedge clk) begin
        if (rst) begin
            mult_status <= STATUS_IDLE;
            multu_status <= STATUS_IDLE;
            div_status <= STATUS_IDLE;
            divu_status <= STATUS_IDLE;
            mult_HI_W_reg <= 1'b0;
            mult_LO_W_reg <= 1'b0;
            mult_MUX_HI_reg <= 3'b0;
            mult_MUX_LO_reg <= 3'b0;
            multu_HI_W_reg <= 1'b0;
            multu_LO_W_reg <= 1'b0;
            multu_MUX_HI_reg <= 3'b0;
            multu_MUX_LO_reg <= 3'b0;
            div_HI_W_reg <= 1'b0;
            div_LO_W_reg <= 1'b0;
            div_MUX_HI_reg <= 3'b0;
            div_MUX_LO_reg <= 3'b0;
            divu_HI_W_reg <= 1'b0;
            divu_LO_W_reg <= 1'b0;
            divu_MUX_HI_reg <= 3'b0;
            divu_MUX_LO_reg <= 3'b0;
        end
        else if(ena) begin

            // MULT
            if(mult_status == STATUS_IDLE) begin
                if(start_mult) begin
                    mult_status <= STATUS_BUSY;
                    mult_HI_W_reg <= in_HI_W;
                    mult_LO_W_reg <= in_LO_W;
                    mult_MUX_HI_reg <= in_MUX_HI;
                    mult_MUX_LO_reg <= in_MUX_LO;
                end
            end
            else if(mult_status == STATUS_BUSY) begin
                if (!in_mult_busy) begin
                    mult_status <= STATUS_COMPLETE;
                end
            end
            else if(mult_status == STATUS_COMPLETE) begin
                if(start_mult) begin
                    mult_status <= STATUS_BUSY;
                    mult_HI_W_reg <= in_HI_W;
                    mult_LO_W_reg <= in_LO_W;
                    mult_MUX_HI_reg <= in_MUX_HI;
                    mult_MUX_LO_reg <= in_MUX_LO;
                end
                else begin
                    mult_status <= STATUS_IDLE; 
                    mult_HI_W_reg <= 1'b0;
                    mult_LO_W_reg <= 1'b0;
                    mult_MUX_HI_reg <= 3'b0;
                    mult_MUX_LO_reg <= 3'b0;
                end
            end
            
            // MULTU
            if(multu_status == STATUS_IDLE) begin
                if(start_multu) begin
                    multu_status <= STATUS_BUSY;
                    multu_HI_W_reg <= in_HI_W;
                    multu_LO_W_reg <= in_LO_W;
                    multu_MUX_HI_reg <= in_MUX_HI;
                    multu_MUX_LO_reg <= in_MUX_LO;
                end
            end
            else if(multu_status == STATUS_BUSY) begin
                if (!in_multu_busy) begin
                    multu_status <= STATUS_COMPLETE;
                end
            end
            else if(multu_status == STATUS_COMPLETE) begin
                if(start_multu) begin
                    multu_status <= STATUS_BUSY;
                    multu_HI_W_reg <= in_HI_W;
                    multu_LO_W_reg <= in_LO_W;
                    multu_MUX_HI_reg <= in_MUX_HI;
                    multu_MUX_LO_reg <= in_MUX_LO;
                end
                else begin
                    multu_status <= STATUS_IDLE; 
                    multu_HI_W_reg <= 1'b0;
                    multu_LO_W_reg <= 1'b0;
                    multu_MUX_HI_reg <= 3'b0;
                    multu_MUX_LO_reg <= 3'b0;
                end
            end
            
            // DIV
            if(div_status == STATUS_IDLE) begin
                if(start_div) begin
                    div_status <= STATUS_BUSY;
                    div_HI_W_reg <= in_HI_W;
                    div_LO_W_reg <= in_LO_W;
                    div_MUX_HI_reg <= in_MUX_HI;
                    div_MUX_LO_reg <= in_MUX_LO;
                end
            end
            else if(div_status == STATUS_BUSY) begin
                if (!in_div_busy) begin
                    div_status <= STATUS_COMPLETE;
                end
            end
            else if(div_status == STATUS_COMPLETE) begin
                if(start_div) begin
                    div_status <= STATUS_BUSY;
                    div_HI_W_reg <= in_HI_W;
                    div_LO_W_reg <= in_LO_W;
                    div_MUX_HI_reg <= in_MUX_HI;
                    div_MUX_LO_reg <= in_MUX_LO;
                end
                else begin
                    div_status <= STATUS_IDLE; 
                    div_HI_W_reg <= 1'b0;
                    div_LO_W_reg <= 1'b0;
                    div_MUX_HI_reg <= 3'b0;
                    div_MUX_LO_reg <= 3'b0;
                end
            end
            
            // DIVU
            if(divu_status == STATUS_IDLE) begin
                if(start_divu) begin
                    divu_status <= STATUS_BUSY;
                    divu_HI_W_reg <= in_HI_W;
                    divu_LO_W_reg <= in_LO_W;
                    divu_MUX_HI_reg <= in_MUX_HI;
                    divu_MUX_LO_reg <= in_MUX_LO;
                end
            end
            else if(divu_status == STATUS_BUSY) begin
                if (!in_divu_busy) begin
                    divu_status <= STATUS_COMPLETE;
                end
            end
            else if(divu_status == STATUS_COMPLETE) begin
                if(start_divu) begin
                    divu_status <= STATUS_BUSY;
                    divu_HI_W_reg <= in_HI_W;
                    divu_LO_W_reg <= in_LO_W;
                    divu_MUX_HI_reg <= in_MUX_HI;
                    divu_MUX_LO_reg <= in_MUX_LO;
                end
                else begin
                    divu_status <= STATUS_IDLE; 
                    divu_HI_W_reg <= 1'b0;
                    divu_LO_W_reg <= 1'b0;
                    divu_MUX_HI_reg <= 3'b0;
                    divu_MUX_LO_reg <= 3'b0;
                end
            end

        end
    end

    assign out_mult_busy =  (start_mult  || mult_status == STATUS_BUSY);
    assign out_multu_busy = (start_multu || multu_status == STATUS_BUSY);
    assign out_div_busy =   (start_div   || div_status == STATUS_BUSY);
    assign out_divu_busy =  (start_divu  || divu_status == STATUS_BUSY);

    assign out_HI_W = (mult_status  == STATUS_COMPLETE) ? mult_HI_W_reg :
                      (multu_status == STATUS_COMPLETE) ? multu_HI_W_reg :
                      (div_status   == STATUS_COMPLETE) ? div_HI_W_reg :
                      (divu_status  == STATUS_COMPLETE) ? divu_HI_W_reg :
                      (start_mult | start_multu | start_div | start_divu) ? 1'b0 : in_HI_W;

    assign out_LO_W = (mult_status  == STATUS_COMPLETE) ? mult_LO_W_reg :
                      (multu_status == STATUS_COMPLETE) ? multu_LO_W_reg :
                      (div_status   == STATUS_COMPLETE) ? div_LO_W_reg :
                      (divu_status  == STATUS_COMPLETE) ? divu_LO_W_reg :
                      (start_mult | start_multu | start_div | start_divu) ? 1'b0 : in_LO_W;

    assign out_MUX_HI = (mult_status  == STATUS_COMPLETE) ? mult_MUX_HI_reg :
                        (multu_status == STATUS_COMPLETE) ? multu_MUX_HI_reg :
                        (div_status   == STATUS_COMPLETE) ? div_MUX_HI_reg :
                        (divu_status  == STATUS_COMPLETE) ? divu_MUX_HI_reg :
                        (start_mult | start_multu | start_div | start_divu) ? 3'b0 : in_MUX_HI;

    assign out_MUX_LO = (mult_status  == STATUS_COMPLETE) ? mult_MUX_LO_reg :
                        (multu_status == STATUS_COMPLETE) ? multu_MUX_LO_reg :
                        (div_status   == STATUS_COMPLETE) ? div_MUX_LO_reg :
                        (divu_status  == STATUS_COMPLETE) ? divu_MUX_LO_reg :
                        (start_mult | start_multu | start_div | start_divu) ? 3'b0 : in_MUX_LO;

endmodule
