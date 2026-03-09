`timescale 1ns / 1ps

module ALU(
    // 控制信号
    input [3:0] ALUC,
    input [31:0] A,
    input [31:0] B,
    // 输出
    output [31:0] F,    // 运算结果
    output Z,   // 0标志位
    output C,   // 进位标志位
    output N,   // 符号标志位
    output O,   // 溢出标志位
    output S    // N 和 O 的异或结果
);
    // ALUC 的值对应的运算
    parameter ADD   = 4'b0000;
    parameter ADDU  = 4'b0001;
    parameter SUB   = 4'b0010;
    parameter SUBU  = 4'b0011;
    parameter AND   = 4'b0100;
    parameter OR    = 4'b0101;
    parameter XOR   = 4'b0110;
    parameter NOR   = 4'b0111;
    parameter SLL   = 4'b1000;
    parameter SRL   = 4'b1001;
    parameter SRA   = 4'b1010;

    // 执行运算
    reg [32:0] result;
    
    always @(*)
    begin
        case(ALUC)
            ADD:  begin result = {A[31], A} + {B[31], B};     end 
            ADDU: begin result = {1'b0, A} + {1'b0, B};     end
            SUB:  begin result = {A[31], A} - {B[31], B};     end
            SUBU: begin result = {1'b0, A} - {1'b0, B};     end
            AND:  begin result = A & B;     end
            OR:   begin result = A | B;     end
            XOR:  begin result = A ^ B;     end
            NOR:  begin result = ~(A | B);  end
            SLL:  begin result = ({1'b0, B} << A[4:0]);  end
            SRL:  begin result = ({1'b0, B} >> A[4:0]);  end
            SRA:  begin result = ($signed({B[31], B}) >>> A[4:0]); end
            default: result = 33'd0;
        endcase
    end
    
    assign F = result[31:0];
    assign Z = (F == 32'd0);
    assign C = result[32];
    assign N = F[31];
    assign O = (ALUC == ADD || ALUC == ADDU) ?
               ((A[31] == B[31]) && (F[31] != A[31])) :
               ((ALUC == SUB || ALUC == SUBU) ? ((A[31] != B[31]) && (F[31] != A[31])) : 1'b0);
    assign S = N ^ O;

endmodule