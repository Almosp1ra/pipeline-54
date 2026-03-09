`timescale 1ns / 1ps

module DIV(
    input clk,
    input reset,
    input ena,
    input start,
    input [31:0] dividend,
    input [31:0] divisor,
    output [31:0] q,
    output [31:0] r,
    output reg busy
);
    reg [63:0] r_reg;
    reg [31:0] divisor_abs_reg;
    reg [5:0] cnt;
    reg dividend_sign;
    reg divisor_sign;

    wire [31:0] dividend_abs = dividend[31] ? (~dividend + 1) : dividend;
    wire [31:0] divisor_abs  = divisor[31] ? (~divisor + 1) : divisor;

    always @(posedge clk) begin
        if (reset) begin
            r_reg <= 64'd0;
            divisor_abs_reg <= 32'd0;
            busy <= 1'b0;
            cnt <= 6'd0;
            dividend_sign <= 1'b0;
            divisor_sign <= 1'b0;
        end
        else if(ena) begin
            if (start && !busy) begin
                if (divisor == 32'sd0) begin
                    r_reg <= 64'd0;
                    divisor_abs_reg <= 32'd0;
                    cnt <= 6'd0;
                    busy <= 1'b0;
                    dividend_sign <= 1'b0;
                    divisor_sign <= 1'b0;
                end
                else begin
                    r_reg <= { 32'b0, dividend_abs };
                    divisor_abs_reg <= divisor_abs;
                    cnt <= 6'd32;
                    busy <= 1'b1;
                    dividend_sign <= dividend[31];
                    divisor_sign <= divisor[31];
                end
            end else if (busy && cnt > 0) begin
                if (r_reg[62:31] >= divisor_abs_reg) begin
                    r_reg <= { r_reg[62:31] - divisor_abs_reg, r_reg[30:0], 1'b1}; // 相当于左移一位后余数 - 除数，商加1
                end
                else begin
                    r_reg <= (r_reg << 1);
                end
                cnt <= cnt - 1'b1;
                if (cnt == 6'd1) begin
                    busy <= 1'b0;
                end
            end
        end
    end

    assign q = (dividend_sign ^ divisor_sign) ? (~(r_reg[31:0]) + 1) : r_reg[31:0];
    assign r = dividend_sign ? (~(r_reg[63:32]) + 1) : r_reg[63:32];

endmodule
