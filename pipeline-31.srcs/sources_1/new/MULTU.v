`timescale 1ns / 1ps

module MULTU(
    input clk,
    input reset,
    input ena,
    input start,
    input [31:0] a,
    input [31:0] b,
    output [63:0] z,
    output reg busy
);
    reg [63:0] R; // accumulator (high) + multiplier (low)
    reg [63:0] M; // multiplicand shifted (upper 32 bits hold multiplicand)
    reg [5:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            R <= 64'd0;
            M <= 64'd0;
            cnt <= 6'd0;
            busy <= 1'b0;
        end
        else if(ena) begin
            if (start && !busy) begin
                R <= {32'd0, b};
                M <= {a, 32'd0};
                cnt <= 6'd32;
                busy <= 1'b1;
            end
            else if (busy && cnt > 0) begin
                if (R[0])
                    R <= (R + M) >> 1;
                else
                    R <= R >> 1;
                cnt <= cnt - 1'b1;
                if (cnt == 6'd1) begin
                    busy <= 1'b0;
                end
            end
        end
    end

    assign z = R;

endmodule
