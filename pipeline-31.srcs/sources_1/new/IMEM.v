`timescale 1ns / 1ps

module IMEM(
    input  [31:0] I_address,
    output [31:0] instruction
);
    // ipºË
    dist_mem_gen_0 imem(
        .a(I_address[12:2]),
        .spo(instruction)
    );
endmodule