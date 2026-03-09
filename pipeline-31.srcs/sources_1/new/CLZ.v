`timescale 1ns / 1ps

module CLZ(
    input  [31:0] CLZ_in,
    output [31:0] CLZ_out
);

    assign CLZ_out = (CLZ_in[31] ? 32'd0  :
                      CLZ_in[30] ? 32'd1  :
                      CLZ_in[29] ? 32'd2  :
                      CLZ_in[28] ? 32'd3  :
                      CLZ_in[27] ? 32'd4  :
                      CLZ_in[26] ? 32'd5  :
                      CLZ_in[25] ? 32'd6  :
                      CLZ_in[24] ? 32'd7  :
                      CLZ_in[23] ? 32'd8  :
                      CLZ_in[22] ? 32'd9  :
                      CLZ_in[21] ? 32'd10 :
                      CLZ_in[20] ? 32'd11 :
                      CLZ_in[19] ? 32'd12 :
                      CLZ_in[18] ? 32'd13 :
                      CLZ_in[17] ? 32'd14 :
                      CLZ_in[16] ? 32'd15 :
                      CLZ_in[15] ? 32'd16 :
                      CLZ_in[14] ? 32'd17 :
                      CLZ_in[13] ? 32'd18 :
                      CLZ_in[12] ? 32'd19 :
                      CLZ_in[11] ? 32'd20 :
                      CLZ_in[10] ? 32'd21 :
                      CLZ_in[9] ? 32'd22 :
                      CLZ_in[8] ? 32'd23 :
                      CLZ_in[7] ? 32'd24 :
                      CLZ_in[6] ? 32'd25 :
                      CLZ_in[5] ? 32'd26 :
                      CLZ_in[4] ? 32'd27 :
                      CLZ_in[3] ? 32'd28 :
                      CLZ_in[2] ? 32'd29 :
                      CLZ_in[1] ? 32'd30 :
                      CLZ_in[0] ? 32'd31 : 32'd32);

endmodule
