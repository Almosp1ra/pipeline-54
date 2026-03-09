`timescale 1ns / 1ps

module controller(
    // 操作码译码结果
    input add_flag,
    input addu_flag,
    input sub_flag,
    input subu_flag,
    input and_flag,
    input or_flag,
    input xor_flag,
    input nor_flag,
    input slt_flag,
    input sltu_flag,
    input sll_flag,
    input srl_flag,
    input sra_flag,
    input sllv_flag,
    input srlv_flag,
    input srav_flag,
    input jr_flag,
    input addi_flag,
    input addiu_flag,
    input andi_flag,
    input ori_flag,
    input xori_flag,
    input lw_flag,
    input sw_flag,
    input beq_flag,
    input bne_flag,
    input slti_flag,
    input sltiu_flag,
    input lui_flag,
    input j_flag,
    input jal_flag,
    input div_flag,
    input divu_flag,
    input mult_flag,
    input multu_flag,
    input bgez_flag,
    input jalr_flag,
    input lbu_flag,
    input lhu_flag,
    input lb_flag,
    input lh_flag,
    input sb_flag,
    input sh_flag,
    input break_flag,
    input syscall_flag,
    input eret_flag,
    input mfhi_flag,
    input mflo_flag,
    input mthi_flag,
    input mtlo_flag,
    input mfc0_flag,
    input mtc0_flag,
    input clz_flag,
    input teq_flag,
    input Comparer_Z,
    input Comparer_S,
    // 控制信号
    output [3:0] ALUC,
    output RF_W,
    output DM_R,
    output DM_W,
    output Exception,
    output HI_W,
    output LO_W,
    // 控制信号（MUX）
    output MUX_Branch,
    output MUX_Rdc,
    output [1:0] MUX_PC,
    output [1:0] MUX_A,
    output [1:0] MUX_B,
    output [2:0] MUX_HI,
    output [2:0] MUX_LO,
    output MUX_HILO,
    output [2:0] MUX_LMD,
    output [2:0] MUX_Rd
);
    // MUX 以外的控制信号

    assign ALUC[0] = addu_flag | subu_flag | or_flag | nor_flag | sltu_flag | srl_flag |
        srlv_flag | addiu_flag | ori_flag | beq_flag | bne_flag | sltiu_flag;
    assign ALUC[1] = sub_flag | subu_flag | xor_flag | nor_flag | slt_flag | sltu_flag |
        sra_flag | srav_flag | xori_flag | slti_flag | sltiu_flag;
    assign ALUC[2] = and_flag | or_flag | xor_flag | nor_flag | andi_flag | ori_flag | xori_flag;
    assign ALUC[3] = sll_flag | srl_flag | sra_flag | sllv_flag | srlv_flag | srav_flag | lui_flag;
    
    assign RF_W = ~(jr_flag | sw_flag | beq_flag | bne_flag | j_flag |
        div_flag | divu_flag | mult_flag | multu_flag | bgez_flag | sb_flag | sh_flag |
        break_flag | syscall_flag | eret_flag | mthi_flag | mtlo_flag | mtc0_flag | teq_flag);

    assign DM_R = lw_flag | lbu_flag | lhu_flag | lb_flag | lh_flag;
    assign DM_W = sw_flag | sb_flag | sh_flag;

    assign Exception = break_flag | syscall_flag | teq_flag & Comparer_Z;
    assign HI_W = div_flag | divu_flag | mult_flag | multu_flag | mthi_flag;
    assign LO_W = div_flag | divu_flag | mult_flag | multu_flag | mtlo_flag;

    // MUX 控制信号

    assign MUX_Branch = jr_flag | j_flag | jal_flag | jalr_flag | eret_flag |
        (beq_flag & Comparer_Z) | (bne_flag & ~Comparer_Z) | (bgez_flag & ~Comparer_S);

    assign MUX_Rdc = addi_flag | addiu_flag | andi_flag | ori_flag | xori_flag | lw_flag | slti_flag | sltiu_flag | lui_flag |
        lbu_flag | lhu_flag | lb_flag | lh_flag | mfc0_flag;
    
    assign MUX_PC[0] = jr_flag | beq_flag | bne_flag | bgez_flag | jalr_flag;
    assign MUX_PC[1] = jr_flag | jalr_flag | j_flag | jal_flag;

    assign MUX_A[0] = sllv_flag | srlv_flag | srav_flag | lui_flag;
    assign MUX_A[1] = sll_flag | srl_flag | sra_flag | lui_flag;

    assign MUX_B[0] = addi_flag | addiu_flag | lw_flag | sw_flag | slti_flag | sltiu_flag | lui_flag |
        lbu_flag | lhu_flag | lb_flag | lh_flag | sb_flag | sh_flag;
    assign MUX_B[1] = andi_flag | ori_flag | xori_flag;

    assign MUX_HI[0] = divu_flag | multu_flag;
    assign MUX_HI[1] = div_flag | divu_flag;
    assign MUX_HI[2] = mthi_flag;

    assign MUX_LO[0] = divu_flag | multu_flag;
    assign MUX_LO[1] = div_flag | divu_flag;
    assign MUX_LO[2] = mtlo_flag;

    assign MUX_HILO = mflo_flag;

    assign MUX_LMD[0] = lb_flag | lh_flag;
    assign MUX_LMD[1] = lhu_flag | lb_flag;
    assign MUX_LMD[2] = lbu_flag;

    assign MUX_Rd[0] = slt_flag | lw_flag | slti_flag | lbu_flag | lhu_flag | lb_flag | lh_flag | mfhi_flag | mflo_flag | clz_flag;
    assign MUX_Rd[1] = slt_flag | sltu_flag | slti_flag | sltiu_flag | jal_flag | jalr_flag | mfhi_flag | mflo_flag;
    assign MUX_Rd[2] = add_flag | addu_flag | sub_flag | subu_flag | and_flag | or_flag | xor_flag | nor_flag |
        slt_flag | sltu_flag | sll_flag | srl_flag | sra_flag | sllv_flag | srlv_flag | srav_flag |
        addi_flag | addiu_flag | andi_flag | ori_flag | xori_flag | lw_flag | slti_flag | sltiu_flag | lui_flag |
        lbu_flag | lhu_flag | lb_flag | lh_flag;

endmodule
