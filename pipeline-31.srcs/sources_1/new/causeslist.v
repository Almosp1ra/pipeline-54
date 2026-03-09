`timescale 1ns / 1ps

module causeslist(
    input break_flag,
    input syscall_flag,
    input teq_flag,
    output [4:0] cause
);
    // “Ï≥£¿‡–Õ∫≈
    parameter EXC_SYSCALL = 5'b01000;
    parameter EXC_BREAK   = 5'b01001;
    parameter EXC_TEQ     = 5'b01101;

    assign cause = break_flag == 1   ? EXC_BREAK :
                   syscall_flag == 1 ? EXC_SYSCALL :
                   teq_flag == 1     ? EXC_TEQ : 
                   5'b00000;

endmodule
