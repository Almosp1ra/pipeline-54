`timescale 1ns / 1ps

module decoder(
    // 32位指令
    input [31:0] instruction,
    // 操作码译码结果
    output add_flag,
    output addu_flag,
    output sub_flag,
    output subu_flag,
    output and_flag,
    output or_flag,
    output xor_flag,
    output nor_flag,
    output slt_flag,
    output sltu_flag,
    output sll_flag,
    output srl_flag,
    output sra_flag,
    output sllv_flag,
    output srlv_flag,
    output srav_flag,
    output jr_flag,
    output addi_flag,
    output addiu_flag,
    output andi_flag,
    output ori_flag,
    output xori_flag,
    output lw_flag,
    output sw_flag,
    output beq_flag,
    output bne_flag,
    output slti_flag,
    output sltiu_flag,
    output lui_flag,
    output j_flag,
    output jal_flag,
    output div_flag,
    output divu_flag,
    output mult_flag,
    output multu_flag,
    output bgez_flag,
    output jalr_flag,
    output lbu_flag,
    output lhu_flag,
    output lb_flag,
    output lh_flag,
    output sb_flag,
    output sh_flag,
    output break_flag,
    output syscall_flag,
    output eret_flag,
    output mfhi_flag,
    output mflo_flag,
    output mthi_flag,
    output mtlo_flag,
    output mfc0_flag,
    output mtc0_flag,
    output clz_flag,
    output teq_flag,
    // 操作数
    output [4:0] Rsc,
    output [4:0] Rtc,
    output [4:0] Rdc,
    output [4:0] shamt,
    output [15:0] imm16,
    output [25:0] J_address
);
    // 各个指令对应的操作码（R型、前六位扩展）
    parameter ADD_OPE   = 6'b100000;
    parameter ADDU_OPE  = 6'b100001;
    parameter SUB_OPE   = 6'b100010;
    parameter SUBU_OPE  = 6'b100011;
    parameter AND_OPE   = 6'b100100;
    parameter OR_OPE    = 6'b100101;
    parameter XOR_OPE   = 6'b100110;
    parameter NOR_OPE   = 6'b100111;
    parameter SLT_OPE   = 6'b101010;
    parameter SLTU_OPE  = 6'b101011;

    parameter SLL_OPE   = 6'b000000;
    parameter SRL_OPE   = 6'b000010;
    parameter SRA_OPE   = 6'b000011;

    parameter SLLV_OPE  = 6'b000100;
    parameter SRLV_OPE  = 6'b000110;
    parameter SRAV_OPE  = 6'b000111;

    parameter JR_OPE    = 6'b001000;

    // 各个指令对应的操作码（无扩展）
    parameter ADDI_OPE  = 6'b001000;
    parameter ADDIU_OPE = 6'b001001;
    parameter ANDI_OPE  = 6'b001100;
    parameter ORI_OPE   = 6'b001101;
    parameter XORI_OPE  = 6'b001110;
    parameter LW_OPE    = 6'b100011;
    parameter SW_OPE    = 6'b101011;
    parameter BEQ_OPE   = 6'b000100;
    parameter BNE_OPE   = 6'b000101;
    parameter SLTI_OPE  = 6'b001010;
    parameter SLTIU_OPE = 6'b001011;

    parameter LUI_OPE   = 6'b001111;

    parameter J_OPE     = 6'b000010;
    parameter JAL_OPE   = 6'b000011;

    // 各个指令对应的操作码（54-CPU新增，前六位扩展）
    parameter DIV_OPE   = 6'b011010;
    parameter DIVU_OPE  = 6'b011011;
    parameter MULT_OPE  = 6'b011000;
    parameter MULTU_OPE = 6'b011001;
    parameter JALR_OPE  = 6'b001001;

    parameter MFHI_OPE = 6'b010000;
    parameter MFLO_OPE = 6'b010010;
    parameter MTHI_OPE = 6'b010001;
    parameter MTLO_OPE = 6'b010011;

    parameter BREAK_OPE   = 6'b001101;
    parameter SYSCALL_OPE = 6'b001100;
    parameter TEQ_OPE     = 6'b110100;

    // 各个指令对应的操作码（54-CPU新增，无扩展）
    parameter BGEZ_OPE  = 6'b000001;
    parameter ERET_OPE  = 6'b010000;

    parameter LBU_OPE = 6'b100100;
    parameter LHU_OPE = 6'b100101;
    parameter LB_OPE  = 6'b100000;
    parameter LH_OPE  = 6'b100001;
    parameter SB_OPE  = 6'b101000;
    parameter SH_OPE  = 6'b101001;

    parameter MFC0_OPE = 6'b010000;
    parameter MTC0_OPE = 6'b010000;
    parameter CLZ_OPE  = 6'b011100;

    // 附加的识别码
    parameter ERET_SUBOPE = 5'b10000;
    parameter MFC0_SUBOPE = 5'b00000;
    parameter MTC0_SUBOPE = 5'b00100;

    // 译码
    assign add_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == ADD_OPE;
    assign addu_flag = instruction[31:26] == 6'd0 && instruction[5:0] == ADDU_OPE;
    assign sub_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == SUB_OPE;
    assign subu_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SUBU_OPE;
    assign and_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == AND_OPE;
    assign or_flag   = instruction[31:26] == 6'd0 && instruction[5:0] == OR_OPE;
    assign xor_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == XOR_OPE;
    assign nor_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == NOR_OPE;
    assign slt_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == SLT_OPE;
    assign sltu_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SLTU_OPE;

    assign sll_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == SLL_OPE;
    assign srl_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == SRL_OPE;
    assign sra_flag  = instruction[31:26] == 6'd0 && instruction[5:0] == SRA_OPE;

    assign sllv_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SLLV_OPE;
    assign srlv_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SRLV_OPE;
    assign srav_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SRAV_OPE;

    assign jr_flag   = instruction[31:26] == 6'd0 && instruction[5:0] == JR_OPE;

    assign addi_flag  = instruction[31:26] == ADDI_OPE;
    assign addiu_flag = instruction[31:26] == ADDIU_OPE;
    assign andi_flag  = instruction[31:26] == ANDI_OPE;
    assign ori_flag   = instruction[31:26] == ORI_OPE;
    assign xori_flag  = instruction[31:26] == XORI_OPE;
    assign lw_flag    = instruction[31:26] == LW_OPE;
    assign sw_flag    = instruction[31:26] == SW_OPE;
    assign beq_flag   = instruction[31:26] == BEQ_OPE;
    assign bne_flag   = instruction[31:26] == BNE_OPE;
    assign slti_flag  = instruction[31:26] == SLTI_OPE;
    assign sltiu_flag = instruction[31:26] == SLTIU_OPE;

    assign lui_flag   = instruction[31:26] == LUI_OPE;

    assign j_flag     = instruction[31:26] == J_OPE;
    assign jal_flag   = instruction[31:26] == JAL_OPE;

    
    assign div_flag     = instruction[31:26] == 6'd0 && instruction[5:0] == DIV_OPE;
    assign divu_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == DIVU_OPE;
    assign mult_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == MULT_OPE;
    assign multu_flag   = instruction[31:26] == 6'd0 && instruction[5:0] == MULTU_OPE;
    assign jalr_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == JALR_OPE;
    assign break_flag   = instruction[31:26] == 6'd0 && instruction[5:0] == BREAK_OPE;
    assign syscall_flag = instruction[31:26] == 6'd0 && instruction[5:0] == SYSCALL_OPE;
    assign mfhi_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == MFHI_OPE;
    assign mflo_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == MFLO_OPE;
    assign mthi_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == MTHI_OPE;
    assign mtlo_flag    = instruction[31:26] == 6'd0 && instruction[5:0] == MTLO_OPE;
    assign teq_flag     = instruction[31:26] == 6'd0 && instruction[5:0] == TEQ_OPE;

    
    assign bgez_flag = instruction[31:26] == BGEZ_OPE; 
    assign eret_flag = instruction[31:26] == ERET_OPE && instruction[25:21] == ERET_SUBOPE; 
    assign lbu_flag  = instruction[31:26] == LBU_OPE; 
    assign lhu_flag  = instruction[31:26] == LHU_OPE; 
    assign lb_flag   = instruction[31:26] == LB_OPE; 
    assign lh_flag   = instruction[31:26] == LH_OPE; 
    assign sb_flag   = instruction[31:26] == SB_OPE; 
    assign sh_flag   = instruction[31:26] == SH_OPE; 
    assign mfc0_flag = instruction[31:26] == MFC0_OPE && instruction[25:21] == MFC0_SUBOPE; 
    assign mtc0_flag = instruction[31:26] == MTC0_OPE && instruction[25:21] == MTC0_SUBOPE; 
    assign clz_flag  = instruction[31:26] == CLZ_OPE; 
    
    // 操作数
    assign Rsc = instruction[25:21];
    assign Rtc = instruction[20:16];
    assign Rdc = instruction[15:11];
    assign shamt  = instruction[10:6];
    assign imm16 = instruction[15:0];
    assign J_address = instruction[25:0];

endmodule