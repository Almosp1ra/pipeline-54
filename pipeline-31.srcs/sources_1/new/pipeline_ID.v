`timescale 1ns / 1ps

module pipeline_ID(
    input  clk,
    input  rst,
    input  ena,

    input  [31:0] in_NPC,
    input  [31:0] in_IR,
    input  [31:0] in_PC,

    input  in_RF_W,
    input  [4:0] in_Rdc,
    input  [31:0] in_Rd,
    input ex_wena,
    input [4:0] ex_Rdc,
    input mem_wena,
    input [4:0] mem_Rdc,
    input in_mult_busy,
    input in_multu_busy,
    input in_div_busy,
    input in_divu_busy,

    output [31:0] out_A,
    output [31:0] out_B,
    output [31:0] out_Rt,
    output [4:0]  out_Rdc,
    output [31:0] out_CP0,
    output [31:0] out_jal,

    output [3:0] out_ALUC,
    output out_RF_W,
    output out_DM_R,
    output out_DM_W,
    output out_HI_W,
    output out_LO_W,
    output [2:0] out_MUX_HI,
    output [2:0] out_MUX_LO,
    output out_MUX_HILO,
    output [2:0] out_MUX_LMD,
    output [2:0] out_MUX_Rd,

    output out_start_mult,
    output out_start_multu,
    output out_start_div,
    output out_start_divu,

    output out_sw_flag,
    output out_sb_flag,
    output out_sh_flag,
    output out_lbu_flag,
    output out_lhu_flag,
    output out_lb_flag,
    output out_lh_flag,
    output out_lw_flag,

    output [31:0] out_PC,
    output out_MUX_Branch,

    output out_stall,

    output [31:0] a_i,
    output [31:0] b_i,
    output [31:0] c_i,
    output [31:0] d_i
);
    wire add_flag;
    wire addu_flag;
    wire sub_flag;
    wire subu_flag;
    wire and_flag;
    wire or_flag;
    wire xor_flag;
    wire nor_flag;
    wire slt_flag;
    wire sltu_flag;
    wire sll_flag;
    wire srl_flag;
    wire sra_flag;
    wire sllv_flag;
    wire srlv_flag;
    wire srav_flag;
    wire jr_flag;
    wire addi_flag;
    wire addiu_flag;
    wire andi_flag;
    wire ori_flag;
    wire xori_flag;
    wire lw_flag;
    wire sw_flag;
    wire beq_flag;
    wire bne_flag;
    wire slti_flag;
    wire sltiu_flag;
    wire lui_flag;
    wire j_flag;
    wire jal_flag;
    wire div_flag;
    wire divu_flag;
    wire mult_flag;
    wire multu_flag;
    wire bgez_flag;
    wire jalr_flag;
    wire lbu_flag;
    wire lhu_flag;
    wire lb_flag;
    wire lh_flag;
    wire sb_flag;
    wire sh_flag;
    wire break_flag;
    wire syscall_flag;
    wire eret_flag;
    wire mfhi_flag;
    wire mflo_flag;
    wire mthi_flag;
    wire mtlo_flag;
    wire mfc0_flag;
    wire mtc0_flag;
    wire clz_flag;
    wire teq_flag;

    wire [4:0] Rsc;
    wire [4:0] Rtc;
    wire [4:0] Rdc;
    wire [4:0] shamt;
    wire [15:0] imm16;
    wire [25:0] J_address;

    wire stall;

    // 模块实例化
    decoder decoder_uut(
        .instruction(in_IR),
        .add_flag(add_flag), .addu_flag(addu_flag), .sub_flag(sub_flag), .subu_flag(subu_flag),
        .and_flag(and_flag), .or_flag(or_flag), .xor_flag(xor_flag), .nor_flag(nor_flag),
        .slt_flag(slt_flag), .sltu_flag(sltu_flag), .sll_flag(sll_flag), .srl_flag(srl_flag),
        .sra_flag(sra_flag), .sllv_flag(sllv_flag), .srlv_flag(srlv_flag), .srav_flag(srav_flag),
        .jr_flag(jr_flag), .addi_flag(addi_flag), .addiu_flag(addiu_flag), .andi_flag(andi_flag),
        .ori_flag(ori_flag), .xori_flag(xori_flag), .lw_flag(lw_flag), .sw_flag(sw_flag),
        .beq_flag(beq_flag), .bne_flag(bne_flag), .slti_flag(slti_flag), .sltiu_flag(sltiu_flag),
        .lui_flag(lui_flag), .j_flag(j_flag), .jal_flag(jal_flag),
        .div_flag(div_flag), .divu_flag(divu_flag), .mult_flag(mult_flag), .multu_flag(multu_flag),
        .bgez_flag(bgez_flag), .jalr_flag(jalr_flag), .lbu_flag(lbu_flag), .lhu_flag(lhu_flag),
        .lb_flag(lb_flag), .lh_flag(lh_flag), .sb_flag(sb_flag), .sh_flag(sh_flag),
        .break_flag(break_flag), .syscall_flag(syscall_flag), .eret_flag(eret_flag),
        .mfhi_flag(mfhi_flag), .mflo_flag(mflo_flag), .mthi_flag(mthi_flag), .mtlo_flag(mtlo_flag),
        .mfc0_flag(mfc0_flag), .mtc0_flag(mtc0_flag), .clz_flag(clz_flag), .teq_flag(teq_flag),
        .Rsc(Rsc), .Rtc(Rtc), .Rdc(Rdc), .shamt(shamt), .imm16(imm16), .J_address(J_address)
    );

    wire Exception;
    wire MUX_Rdc;
    wire [1:0] MUX_PC;
    wire [1:0] MUX_A;
    wire [1:0] MUX_B;

    wire Comparer_Z;
    wire Comparer_S;

    controller controller_uut(
        .add_flag(add_flag), .addu_flag(addu_flag), .sub_flag(sub_flag), .subu_flag(subu_flag),
        .and_flag(and_flag), .or_flag(or_flag), .xor_flag(xor_flag), .nor_flag(nor_flag),
        .slt_flag(slt_flag), .sltu_flag(sltu_flag), .sll_flag(sll_flag), .srl_flag(srl_flag),
        .sra_flag(sra_flag), .sllv_flag(sllv_flag), .srlv_flag(srlv_flag), .srav_flag(srav_flag),
        .jr_flag(jr_flag), .addi_flag(addi_flag), .addiu_flag(addiu_flag), .andi_flag(andi_flag),
        .ori_flag(ori_flag), .xori_flag(xori_flag), .lw_flag(lw_flag), .sw_flag(sw_flag),
        .beq_flag(beq_flag), .bne_flag(bne_flag), .slti_flag(slti_flag), .sltiu_flag(sltiu_flag),
        .lui_flag(lui_flag), .j_flag(j_flag), .jal_flag(jal_flag),
        .div_flag(div_flag), .divu_flag(divu_flag), .mult_flag(mult_flag), .multu_flag(multu_flag),
        .bgez_flag(bgez_flag), .jalr_flag(jalr_flag), .lbu_flag(lbu_flag), .lhu_flag(lhu_flag),
        .lb_flag(lb_flag), .lh_flag(lh_flag), .sb_flag(sb_flag), .sh_flag(sh_flag),
        .break_flag(break_flag), .syscall_flag(syscall_flag), .eret_flag(eret_flag),
        .mfhi_flag(mfhi_flag), .mflo_flag(mflo_flag), .mthi_flag(mthi_flag), .mtlo_flag(mtlo_flag),
        .mfc0_flag(mfc0_flag), .mtc0_flag(mtc0_flag), .clz_flag(clz_flag), .teq_flag(teq_flag),
        .Comparer_Z(Comparer_Z), .Comparer_S(Comparer_S),

        .ALUC(out_ALUC), .RF_W(out_RF_W), .DM_R(out_DM_R), .DM_W(out_DM_W),
        .Exception(Exception), .HI_W(out_HI_W), .LO_W(out_LO_W),
        .MUX_Branch(out_MUX_Branch), .MUX_Rdc(MUX_Rdc), .MUX_PC(MUX_PC), .MUX_A(MUX_A), .MUX_B(MUX_B),
        .MUX_HI(out_MUX_HI), .MUX_LO(out_MUX_LO), .MUX_HILO(out_MUX_HILO), .MUX_LMD(out_MUX_LMD), .MUX_Rd(out_MUX_Rd)
    );

    wire [31:0] Rs;
    wire [31:0] Rt;

    regfile regfile_uut(
        .reg_clk(clk), .rst(rst), .RF_W(in_RF_W), .Rdc(in_Rdc), .Rsc(Rsc), .Rtc(Rtc), .Rd(in_Rd),
        .Rs(Rs), .Rt(Rt),
        .a_i(a_i), .b_i(b_i), .c_i(c_i), .d_i(d_i)
    );

    wire [31:0] Comparer_A;
    wire [31:0] Comparer_B;

    assign Comparer_A = Rs;
    assign Comparer_B = bgez_flag ? 32'b0 : Rt;

    comparer comparer_uut(
        .A(Comparer_A), .B(Comparer_B),
        .Comparer_Z(Comparer_Z), .Comparer_S(Comparer_S)
    );

    wire Rs_R = add_flag | addu_flag | sub_flag | subu_flag | and_flag | or_flag | xor_flag | nor_flag |
        slt_flag | sltu_flag | sllv_flag | srlv_flag | srav_flag | addi_flag | addiu_flag | andi_flag | ori_flag | xori_flag | lw_flag | sw_flag |
        slti_flag | sltiu_flag | div_flag | divu_flag | mult_flag | multu_flag | lbu_flag | lhu_flag | lb_flag | lh_flag |
        sb_flag | sh_flag | mthi_flag | mtlo_flag | clz_flag |
        beq_flag | bne_flag | bgez_flag | teq_flag | jr_flag | jalr_flag;

    wire Rt_R = add_flag | addu_flag | sub_flag | subu_flag | and_flag | or_flag | xor_flag | nor_flag |
        slt_flag | sltu_flag | sll_flag | srl_flag | sra_flag | sllv_flag | srlv_flag | srav_flag |
        div_flag | divu_flag | mult_flag | multu_flag |
        beq_flag | bne_flag | teq_flag;

    staller staller_uut(
        .clk(clk), .rst(rst),
        .Rsc(Rsc), .Rtc(Rtc), .Rs_R(Rs_R), .Rt_R(Rt_R),
        .ex_wena(ex_wena), .ex_Rdc(ex_Rdc), .mem_wena(mem_wena), .mem_Rdc(mem_Rdc),
        .div_flag(div_flag), .divu_flag(divu_flag), .mult_flag(mult_flag), .multu_flag(multu_flag),
        .mfhi_flag(mfhi_flag), .mflo_flag(mflo_flag), .mthi_flag(mthi_flag), .mtlo_flag(mtlo_flag),
        .mult_busy(in_mult_busy), .multu_busy(in_multu_busy), .div_busy(in_div_busy), .divu_busy(in_divu_busy),
        .final_stall(stall)
    );

    wire [31:0] CP0_pc, CP0_in;
    wire [4:0]  CP0_Addr;
    wire intr;
    wire [31:0] CP0_out, status, exc_addr;
    wire timer_int, inta;
    wire [4:0] cause;

    assign CP0_pc = in_NPC;
    assign CP0_Addr = Rdc;
    assign CP0_in = Rt;

    causeslist causeslist_uut(
        .break_flag(break_flag), .syscall_flag(syscall_flag), .teq_flag(teq_flag),
        .cause(cause)
    );

    CP0 CP0_uut(
        .clk(clk), .rst(rst), .mfc0(mfc0_flag), .mtc0(mtc0_flag), .eret(eret_flag),
        .pc(CP0_pc), .Rd(CP0_Addr), .wdata(CP0_in), .exception(Exception), .cause(cause),
        .intr(intr),
        .rdata(CP0_out), .status(status), .exc_addr(exc_addr),
        .timer_int(timer_int), .inta(inta)
    );



    // 数据扩展

    wire [31:0] ext5_shamt, ext5_rs, ext16, s_ext16, s_ext18, ext1_C, ext1_S;
    wire [31:0] ext8_lbu, ext16_lhu, s_ext8_lb, s_ext16_lh;
    assign ext5_shamt = {27'b0, shamt};
    assign ext5_rs    = {27'b0, Rs[4:0]};
    assign ext16      = {16'b0, imm16};
    assign s_ext16    = {{16{imm16[15]}}, imm16};
    assign s_ext18    = {{14{imm16[15]}}, imm16, 2'b0};

    // 输出

    assign out_A = MUX_A == 2'b00 ? Rs :
                   MUX_A == 2'b01 ? ext5_rs :
                   MUX_A == 2'b10 ? ext5_shamt : 32'd16;
    assign out_B = MUX_B == 2'b00 ? Rt :
                   MUX_B == 2'b01 ? s_ext16 :
                   MUX_B == 2'b10 ? ext16 : 32'b0;
    assign out_Rt = Rt;
    assign out_Rdc = MUX_Rdc ? Rtc : Rdc;
    assign out_CP0 = CP0_out;
    assign out_jal = in_NPC + 4;

    assign out_start_mult  = mult_flag;
    assign out_start_multu = multu_flag;
    assign out_start_div   = div_flag;
    assign out_start_divu  = divu_flag;

    assign out_sw_flag  = sw_flag;
    assign out_sb_flag  = sb_flag;
    assign out_sh_flag  = sh_flag;
    assign out_lbu_flag = lbu_flag;
    assign out_lhu_flag = lhu_flag;
    assign out_lb_flag  = lb_flag;
    assign out_lh_flag  = lh_flag;
    assign out_lw_flag  = lw_flag;

    assign out_PC = MUX_PC == 2'b00 ? exc_addr :
                    MUX_PC == 2'b01 ? in_NPC + s_ext18 :
                    MUX_PC == 2'b10 ? {in_NPC[31:28], J_address, 2'b0} : Rs;

    assign out_stall = stall;

    // 记录时钟周期数、指令条数，用于性能分析
    reg [31:0] clk_counter;
    // reg [31:0] alu_counter;
    // reg [31:0] branch_counter;
    // reg [31:0] mem_counter;
    // reg [31:0] other_counter;

    always @(posedge clk, posedge rst) 
    begin
        if(rst) begin
            clk_counter <= 23'b0;
    //         alu_counter <= 32'b0;
    //         branch_counter <= 32'b0;
    //         mem_counter <= 32'b0;
    //         other_counter <= 32'b0;
        end
        else begin
            clk_counter <= clk_counter + 1;
    //         if(~stall) begin
    //             if(add_flag | sub_flag | addi_flag)
    //                 alu_counter <= alu_counter + 1;
    //             else if(bz_flag | bn_flag)
    //                 branch_counter <= branch_counter + 1;
    //             else if(lw_flag | sw_flag)
    //                 mem_counter <= mem_counter + 1;
    //             else if(cmp_flag)
    //                 other_counter <= other_counter + 1;
    //         end
        end
    end

endmodule