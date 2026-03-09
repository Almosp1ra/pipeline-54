`timescale 1ns / 1ps

// CPU
module CPU(

    input clk_in,   // Ê±ÖÓ
    input reset,    // ¸´Î»

    output  [31:0]  out_pc,
    output  [31:0]  out_instruction

    // input [31:0] in_maxFloorNum,
    // input [31:0] in_threshold,

    // output [31:0] out_dropNum,
    // output [31:0] out_brokenNum,
    // output out_isLastBroken
);
    // if

    wire [31:0] if_out_NPC;
    wire [31:0] if_out_IR;
    wire [31:0] if_out_PC;

    // id

    wire [31:0] id_in_NPC;
    wire [31:0] id_in_IR;
    wire [31:0] id_in_PC;

    wire [31:0] id_out_A;
    wire [31:0] id_out_B;
    wire [4:0]  id_out_Rdc;
    wire [31:0] id_out_CP0;
    wire [31:0] id_out_jal;

    wire [3:0] id_out_ALUC;
    wire id_out_RF_W;
    wire id_out_DM_R;
    wire id_out_DM_W;
    wire id_out_HI_W;
    wire id_out_LO_W;
    wire [2:0] id_out_MUX_HI;
    wire [2:0] id_out_MUX_LO;
    wire id_out_MUX_HILO;
    wire [2:0] id_out_MUX_LMD;
    wire [2:0] id_out_MUX_Rd;

    wire id_out_start_mult;
    wire id_out_start_multu;
    wire id_out_start_div;
    wire id_out_start_divu;

    wire [31:0] id_out_PC;  // ¼´ if_in_PC
    wire id_out_MUX_Branch; // ¼´ if_in_MUX_Branch

    wire id_out_stall;

    // ex

    wire [31:0] ex_in_A;
    wire [31:0] ex_in_B;
    wire [4:0]  ex_in_Rdc;
    wire [31:0] ex_in_CP0;
    wire [31:0] ex_in_jal;
    
    wire [3:0] ex_in_ALUC;
    wire ex_in_RF_W;
    wire ex_in_DM_R;
    wire ex_in_DM_W;
    wire ex_in_HI_W;
    wire ex_in_LO_W;
    wire [2:0] ex_in_MUX_HI;
    wire [2:0] ex_in_MUX_LO;
    wire ex_in_MUX_HILO;
    wire [2:0] ex_in_MUX_LMD;
    wire [2:0] ex_in_MUX_Rd;

    wire ex_in_start_mult;
    wire ex_in_start_multu;
    wire ex_in_start_div;
    wire ex_in_start_divu;

    wire [31:0] ex_out_CP0;
    wire [31:0] ex_out_CLZ;
    wire [31:0] ex_out_jal;
    wire [31:0] ex_out_HI;
    wire [31:0] ex_out_LO;
    wire [31:0] ex_out_ALUO;
    wire [31:0] ex_out_B;
    wire [31:0] ex_out_ALU_C;
    wire [31:0] ex_out_ALU_S;
    wire [4:0]  ex_out_Rdc;
    
    wire ex_out_RF_W;
    wire ex_out_DM_R;
    wire ex_out_DM_W;
    wire ex_out_HI_W;
    wire ex_out_LO_W;
    wire ex_out_MUX_HILO;
    wire [2:0] ex_out_MUX_LMD;
    wire [2:0] ex_out_MUX_Rd;

    wire ex_out_mult_busy;  // ¼´ id_in_mult_busy
    wire ex_out_multu_busy; // ¼´ id_in_multu_busy
    wire ex_out_div_busy;   // ¼´ id_in_div_busy
    wire ex_out_divu_busy;  // ¼´ id_in_divu_busy

    // mem

    wire [31:0] mem_in_CP0;
    wire [31:0] mem_in_CLZ;
    wire [31:0] mem_in_jal;
    wire [31:0] mem_in_HI;
    wire [31:0] mem_in_LO;
    wire [31:0] mem_in_ALUO;
    wire [31:0] mem_in_B;
    wire [31:0] mem_in_ALU_C;
    wire [31:0] mem_in_ALU_S;
    wire [4:0]  mem_in_Rdc;
    
    wire mem_in_RF_W;
    wire mem_in_DM_R;
    wire mem_in_DM_W;
    wire mem_in_HI_W;
    wire mem_in_LO_W;
    wire mem_in_MUX_HILO;
    wire [2:0] mem_in_MUX_LMD;
    wire [2:0] mem_in_MUX_Rd;

    wire [31:0] mem_out_CP0;
    wire [31:0] mem_out_CLZ;
    wire [31:0] mem_out_jal;
    wire [31:0] mem_out_HILO;
    wire [31:0] mem_out_ALUO;
    wire [31:0] mem_out_LMD;
    wire [31:0] mem_out_ALU_C;
    wire [31:0] mem_out_ALU_S;
    wire [4:0]  mem_out_Rdc;
    
    wire mem_out_RF_W;
    wire [2:0] mem_out_MUX_Rd;

    // wb

    wire [31:0] wb_in_CP0;
    wire [31:0] wb_in_CLZ;
    wire [31:0] wb_in_jal;
    wire [31:0] wb_in_HILO;
    wire [31:0] wb_in_ALUO;
    wire [31:0] wb_in_LMD;
    wire [31:0] wb_in_ALU_C;
    wire [31:0] wb_in_ALU_S;
    wire [4:0]  wb_in_Rdc;
    
    wire wb_in_RF_W;
    wire [2:0] wb_in_MUX_Rd;

    wire wb_out_RF_W;       // ¼´ id_in_RF_W
    wire [31:0] wb_out_Rd;  // ¼´ id_in__Rd
    wire [4:0]  wb_out_Rdc; // ¼´ id_in_Rdc

    // ¸÷Á÷Ë®¶ÎÊµÀý»¯
    pipeline_IF pipeline_IF_uut(
        .clk(clk_in), .rst(reset), .in_stall(id_out_stall), .in_MUX_Branch(id_out_MUX_Branch),
        .in_PC(id_out_PC),
        .out_NPC(if_out_NPC), .out_IR(if_out_IR), .out_PC(if_out_PC)
    );

    pipeline_IF2ID pipeline_IF2ID_uut(
        .clk(clk_in), .rst(reset), .in_stall(id_out_stall), .in_MUX_Branch(id_out_MUX_Branch),
        .in_NPC(if_out_NPC), .in_IR(if_out_IR), .in_PC(if_out_PC),
        .out_NPC(id_in_NPC), .out_IR(id_in_IR), .out_PC(id_in_PC)
    );

    pipeline_ID pipeline_ID_uut(

        .clk(clk_in), .rst(reset),
        .in_NPC(id_in_NPC), .in_IR(id_in_IR), .in_PC(id_in_PC),
        .in_RF_W(wb_out_RF_W), .in_Rdc(wb_out_Rdc), .in_Rd(wb_out_Rd), 
        .ex_wena(ex_out_RF_W), .ex_Rdc(ex_out_Rdc), .mem_wena(mem_out_RF_W), .mem_Rdc(mem_out_Rdc),
        .in_mult_busy(ex_out_mult_busy), .in_multu_busy(ex_out_multu_busy), .in_div_busy(ex_out_div_busy), .in_divu_busy(ex_out_divu_busy),
        .out_A(id_out_A), .out_B(id_out_B), .out_Rdc(id_out_Rdc), .out_CP0(id_out_CP0), .out_jal(id_out_jal),
        .out_ALUC(id_out_ALUC), .out_RF_W(id_out_RF_W), .out_DM_R(id_out_DM_R), .out_DM_W(id_out_DM_W), .out_HI_W(id_out_HI_W), .out_LO_W(id_out_LO_W),
        .out_MUX_HI(id_out_MUX_HI), .out_MUX_LO(id_out_MUX_LO), .out_MUX_HILO(id_out_MUX_HILO), .out_MUX_LMD(id_out_MUX_LMD), .out_MUX_Rd(id_out_MUX_Rd),
        .out_start_mult(id_out_start_mult), .out_start_multu(id_out_start_multu), .out_start_div(id_out_start_div), .out_start_divu(id_out_start_divu),
        .out_PC(id_out_PC), .out_MUX_Branch(id_out_MUX_Branch),
        .out_stall(id_out_stall)
    );

    pipeline_ID2EX pipeline_ID2EX_uut(
        .clk(clk_in), .rst(reset), .in_stall(id_out_stall),
        .in_A(id_out_A), .in_B(id_out_B), .in_Rdc(id_out_Rdc), .in_CP0(id_out_CP0), .in_jal(id_out_jal),
        .in_ALUC(id_out_ALUC), .in_RF_W(id_out_RF_W), .in_DM_R(id_out_DM_R), .in_DM_W(id_out_DM_W), .in_HI_W(id_out_HI_W), .in_LO_W(id_out_LO_W),
        .in_MUX_HI(id_out_MUX_HI), .in_MUX_LO(id_out_MUX_LO), .in_MUX_HILO(id_out_MUX_HILO), .in_MUX_LMD(id_out_MUX_LMD), .in_MUX_Rd(id_out_MUX_Rd),
        .in_start_mult(id_out_start_mult), .in_start_multu(id_out_start_multu), .in_start_div(id_out_start_div), .in_start_divu(id_out_start_divu),
        .out_A(ex_in_A), .out_B(ex_in_B), .out_Rdc(ex_in_Rdc), .out_CP0(ex_in_CP0), .out_jal(ex_in_jal),
        .out_ALUC(ex_in_ALUC), .out_RF_W(ex_in_RF_W), .out_DM_R(ex_in_DM_R), .out_DM_W(ex_in_DM_W), .out_HI_W(ex_in_HI_W), .out_LO_W(ex_in_LO_W),
        .out_MUX_HI(ex_in_MUX_HI), .out_MUX_LO(ex_in_MUX_LO), .out_MUX_HILO(ex_in_MUX_HILO), .out_MUX_LMD(ex_in_MUX_LMD), .out_MUX_Rd(ex_in_MUX_Rd),
        .out_start_mult(ex_in_start_mult), .out_start_multu(ex_in_start_multu), .out_start_div(ex_in_start_div), .out_start_divu(ex_in_start_divu)
    );

    pipeline_EX pipeline_EX_uut(
        .clk(clk_in), .rst(reset),
        .in_A(ex_in_A), .in_B(ex_in_B), .in_Rdc(ex_in_Rdc), .in_CP0(ex_in_CP0), .in_jal(ex_in_jal),
        .in_ALUC(ex_in_ALUC), .in_RF_W(ex_in_RF_W), .in_DM_R(ex_in_DM_R), .in_DM_W(ex_in_DM_W), .in_HI_W(ex_in_HI_W), .in_LO_W(ex_in_LO_W),
        .in_MUX_HI(ex_in_MUX_HI), .in_MUX_LO(ex_in_MUX_LO), .in_MUX_HILO(ex_in_MUX_HILO), .in_MUX_LMD(ex_in_MUX_LMD), .in_MUX_Rd(ex_in_MUX_Rd),
        .in_start_mult(ex_in_start_mult), .in_start_multu(ex_in_start_multu), .in_start_div(ex_in_start_div), .in_start_divu(ex_in_start_divu),
        .out_CP0(ex_out_CP0), .out_CLZ(ex_out_CLZ), .out_jal(ex_out_jal), .out_HI(ex_out_HI), .out_LO(ex_out_LO),
        .out_ALUO(ex_out_ALUO), .out_B(ex_out_B), .out_ALU_C(ex_out_ALU_C), .out_ALU_S(ex_out_ALU_S), .out_Rdc(ex_out_Rdc),
        .out_RF_W(ex_out_RF_W), .out_DM_R(ex_out_DM_R), .out_DM_W(ex_out_DM_W), .out_HI_W(ex_out_HI_W), .out_LO_W(ex_out_LO_W),
        .out_MUX_HILO(ex_out_MUX_HILO), .out_MUX_LMD(ex_out_MUX_LMD), .out_MUX_Rd(ex_out_MUX_Rd),
        .out_mult_busy(ex_out_mult_busy), .out_multu_busy(ex_out_multu_busy), .out_div_busy(ex_out_div_busy), .out_divu_busy(ex_out_divu_busy)
    );

    pipeline_EX2MEM pipeline_EX2MEM_uut(
        .clk(clk_in), .rst(reset),
        .in_CP0(ex_out_CP0), .in_CLZ(ex_out_CLZ), .in_jal(ex_out_jal), .in_HI(ex_out_HI), .in_LO(ex_out_LO),
        .in_ALUO(ex_out_ALUO), .in_B(ex_out_B), .in_ALU_C(ex_out_ALU_C), .in_ALU_S(ex_out_ALU_S), .in_Rdc(ex_out_Rdc),
        .in_RF_W(ex_out_RF_W), .in_DM_R(ex_out_DM_R), .in_DM_W(ex_out_DM_W), .in_HI_W(ex_out_HI_W), .in_LO_W(ex_out_LO_W),
        .in_MUX_HILO(ex_out_MUX_HILO), .in_MUX_LMD(ex_out_MUX_LMD), .in_MUX_Rd(ex_out_MUX_Rd),
        .out_CP0(mem_in_CP0), .out_CLZ(mem_in_CLZ), .out_jal(mem_in_jal), .out_HI(mem_in_HI), .out_LO(mem_in_LO),
        .out_ALUO(mem_in_ALUO), .out_B(mem_in_B), .out_ALU_C(mem_in_ALU_C), .out_ALU_S(mem_in_ALU_S), .out_Rdc(mem_in_Rdc),
        .out_RF_W(mem_in_RF_W), .out_DM_R(mem_in_DM_R), .out_DM_W(mem_in_DM_W), .out_HI_W(mem_in_HI_W), .out_LO_W(mem_in_LO_W),
        .out_MUX_HILO(mem_in_MUX_HILO), .out_MUX_LMD(mem_in_MUX_LMD), .out_MUX_Rd(mem_in_MUX_Rd)
    );

    pipeline_MEM pipeline_MEM_uut(
        .clk(clk_in), .rst(reset),
        .in_CP0(mem_in_CP0), .in_CLZ(mem_in_CLZ), .in_jal(mem_in_jal), .in_HI(mem_in_HI), .in_LO(mem_in_LO),
        .in_ALUO(mem_in_ALUO), .in_B(mem_in_B), .in_ALU_C(mem_in_ALU_C), .in_ALU_S(mem_in_ALU_S), .in_Rdc(mem_in_Rdc),
        .in_RF_W(mem_in_RF_W), .in_DM_R(mem_in_DM_R), .in_DM_W(mem_in_DM_W), .in_HI_W(mem_in_HI_W), .in_LO_W(mem_in_LO_W),
        .in_MUX_HILO(mem_in_MUX_HILO), .in_MUX_LMD(mem_in_MUX_LMD), .in_MUX_Rd(mem_in_MUX_Rd),
        .out_CP0(mem_out_CP0), .out_CLZ(mem_out_CLZ), .out_jal(mem_out_jal), .out_HILO(mem_out_HILO),
        .out_ALUO(mem_out_ALUO), .out_LMD(mem_out_LMD), .out_ALU_C(mem_out_ALU_C), .out_ALU_S(mem_out_ALU_S), .out_Rdc(mem_out_Rdc),
        .out_RF_W(mem_out_RF_W), .out_MUX_Rd(mem_out_MUX_Rd)
    );

    pipeline_MEM2WB pipeline_MEM2WB_uut(
        .clk(clk_in), .rst(reset),
        .in_CP0(mem_out_CP0), .in_CLZ(mem_out_CLZ), .in_jal(mem_out_jal), .in_HILO(mem_out_HILO),
        .in_ALUO(mem_out_ALUO), .in_LMD(mem_out_LMD), .in_ALU_C(mem_out_ALU_C), .in_ALU_S(mem_out_ALU_S), .in_Rdc(mem_out_Rdc),
        .in_RF_W(mem_out_RF_W), .in_MUX_Rd(mem_out_MUX_Rd),
        .out_CP0(wb_in_CP0), .out_CLZ(wb_in_CLZ), .out_jal(wb_in_jal), .out_HILO(wb_in_HILO),
        .out_ALUO(wb_in_ALUO), .out_LMD(wb_in_LMD), .out_ALU_C(wb_in_ALU_C), .out_ALU_S(wb_in_ALU_S), .out_Rdc(wb_in_Rdc),
        .out_RF_W(wb_in_RF_W), .out_MUX_Rd(wb_in_MUX_Rd)
    );

    pipeline_WB pipeline_WB_uut(
        .clk(clk_in), .rst(reset),
        .in_CP0(wb_in_CP0), .in_CLZ(wb_in_CLZ), .in_jal(wb_in_jal), .in_HILO(wb_in_HILO),
        .in_ALUO(wb_in_ALUO), .in_LMD(wb_in_LMD), .in_ALU_C(wb_in_ALU_C), .in_ALU_S(wb_in_ALU_S), .in_Rdc(wb_in_Rdc),
        .in_RF_W(wb_in_RF_W), .in_MUX_Rd(wb_in_MUX_Rd),
        .out_RF_W(wb_out_RF_W), .out_Rd(wb_out_Rd), .out_Rdc(wb_out_Rdc)
    );

    assign out_pc = if_out_PC;
    assign out_instruction = if_out_IR;

endmodule