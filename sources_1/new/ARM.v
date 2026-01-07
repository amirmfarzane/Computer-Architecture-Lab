module ARM_Core (
    input clk, rst
);

    /* ===================== WIRES ===================== */

    /* IF stage */
    wire [31:0] pc_if, pc_if_adder;
    wire [31:0] instruction_if;
    wire branch_taken;
    wire [31:0] branch_address;
    wire hazard;

    /* IF/ID pipe */
    wire [31:0] pc_if_id, instruction_if_id;

    /* ID stage */
    wire wb_en_id, mem_r_en_id, mem_w_en_id, b_id, s_id;
    wire [3:0] exe_cmd_id;
    wire [31:0] pc_id_out, val_rn_id, val_rm_id;
    wire imm_id;
    wire [11:0] shift_operand_id;
    wire [23:0] signed_imm_24_id;
    wire [3:0] dest_id;
    wire c_out_id, two_src_id;
    wire [3:0] src1_id, src2_id;
    wire [3:0] status_reg_out_id;

    /* WB feedback */
    wire wb_wb_en;
    wire [3:0] wb_dest;
    wire [31:0] wb_value;

    /* ID/EXE pipe */
    wire wb_en_id_exe, mem_r_en_id_exe, mem_w_en_id_exe, b_id_exe, s_id_exe;
    wire [3:0] exe_cmd_id_exe, dest_id_exe, src1_id_exe, src2_id_exe;
    wire [31:0] val_rn_id_exe, val_rm_id_exe, pc_id_exe;
    wire [11:0] shift_operand_id_exe;
    wire [23:0] signed_imm_24_id_exe;
    wire imm_id_exe, c_id_exe;

    /* EXE stage */
    wire wb_en_exe, mem_r_en_exe, mem_w_en_exe;
    wire [31:0] alu_res_exe, alu_res_mem, val_rm_exe;
    wire [3:0] dest_exe;
    wire [3:0] src1_exe, src2_exe;
    wire [1:0] sel_src1, sel_src2;

    /* EXE/MEM pipe */
    wire mem_w_en_mem, mem_r_en_mem, wb_en_mem;
    wire [31:0] val_rm_mem;
    wire [3:0] dest_mem;

    /* MEM stage */
    wire [31:0] data_mem_out;

    /* MEM/WB pipe */
    wire mem_r_en_wb, wb_en_wb;
    wire [31:0] alu_res_wb, data_memory_wb;
    wire [3:0] dest_wb;
    
    /* Forwarding */
    wire forward_enable;
    assign forward_enable = 1'b1;
    

    /* ===================== MODULES ===================== */

    /* IF stage */
    IF_STAGE if_stage (
        .pc_out(pc_if),
        .pc_adder_out(pc_if_adder),
        .instruction(instruction_if),
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .branch_taken(branch_taken),
        .branch_addr(branch_address)
    );

    /* IF pipe */
    IF_PIPE if_pipe (
        .pc(pc_if_id),
        .instruction(instruction_if_id),
        .clk(clk),
        .rst(rst),
        .freeze(hazard),
        .flush(branch_taken),
        .pc_in(pc_if_adder),
        .instruction_in(instruction_if)
    );

    /* ID stage */
    ID_STAGE id_stage (
        .wb_en(wb_en_id),
        .mem_r_en(mem_r_en_id),
        .mem_w_en(mem_w_en_id),
        .b(b_id),
        .s(s_id),
        .exe_cmd(exe_cmd_id),
        .pc_out(pc_id_out),
        .val_rn(val_rn_id),
        .val_rm(val_rm_id),
        .imm(imm_id),
        .shift_operand(shift_operand_id),
        .signed_imm_24(signed_imm_24_id),
        .dest(dest_id),
        .c_out(c_out_id),
        .two_src(two_src_id),
        .src1(src1_id),
        .src2(src2_id),
        .clk(clk),
        .rst(rst),
        .hazard(hazard),
        .wb_wb_en(wb_wb_en),
        .status_reg_out(status_reg_out_id),
        .wb_dest(wb_dest),
        .pc_in(pc_if_id),
        .instruction(instruction_if_id),
        .wb_value(wb_value)
    );

    /* ID pipe */
    ID_PIPE id_pipe (
        .pc_out(pc_id_exe),
        .src1_out(src1_id_exe),
        .src2_out(src2_id_exe),
        .wb_en_out(wb_en_id_exe),
        .mem_r_en_out(mem_r_en_id_exe),
        .mem_w_en_out(mem_w_en_id_exe),
        .b_out(b_id_exe),
        .s_out(s_id_exe),
        .val_rn_out(val_rn_id_exe),
        .val_rm_out(val_rm_id_exe),
        .dest_out(dest_id_exe),
        .exe_cmd_out(exe_cmd_id_exe),
        .shift_operand_out(shift_operand_id_exe),
        .signed_imm_24_out(signed_imm_24_id_exe),
        .imm_out(imm_id_exe),
        .c_out(c_id_exe),
        .clk(clk),
        .rst(rst),
        .flush(branch_taken),
        .pc_in(pc_id_out),
        .src1_in(src1_id),
        .src2_in(src2_id),
        .wb_en_in(wb_en_id),
        .mem_r_en_in(mem_r_en_id),
        .mem_w_en_in(mem_w_en_id),
        .b_in(b_id),
        .s_in(s_id),
        .val_rn_in(val_rn_id),
        .val_rm_in(val_rm_id),
        .dest_in(dest_id),
        .exe_cmd_in(exe_cmd_id),
        .shift_operand_in(shift_operand_id),
        .signed_imm_24_in(signed_imm_24_id),
        .imm_in(imm_id),
        .c_in(c_out_id)
    );

    /* EXE stage */
    EXE_STAGE exec_stage (
        .wb_en_out(wb_en_exe),
        .mem_r_en_out(mem_r_en_exe),
        .mem_w_en_out(mem_w_en_exe),
        .branch_taken(branch_taken),
        .src1_out(src1_exe),
        .src2_out(src2_exe),
        .alu_res(alu_res_exe),
        .val_rm_out(val_rm_exe),
        .dest_out(dest_exe),
        .status_register_out(status_reg_out_id),
        .branch_address(branch_address),
        .clk(clk),
        .rst(rst),
        .wb_en_in(wb_en_id_exe),
        .mem_r_en_in(mem_r_en_id_exe),
        .mem_w_en_in(mem_w_en_id_exe),
        .exe_cmd_in(exe_cmd_id_exe),
        .sel_src1(sel_src1),
        .sel_src2(sel_src2),
        .s_in(s_id_exe),
        .b_in(b_id_exe),
        .pc_in(pc_id_exe),
        .src1_in(src1_id_exe),
        .src2_in(src2_id_exe),
        .val_rn_in(val_rn_id_exe),
        .val_rm_in(val_rm_id_exe),
        .wb_value(wb_value),
        .alu_res_mem(alu_res_mem),
        .shift_operand_in(shift_operand_id_exe),
        .imm_in(imm_id_exe),
        .signed_imm_24_in(signed_imm_24_id_exe),
        .dest_in(dest_id_exe),
        .c_in(c_id_exe)
    );

    /* EXE pipe */
    EXE_PIPE exec_pipe (
        .mem_w_en_out(mem_w_en_mem),
        .mem_r_en_out(mem_r_en_mem),
        .wb_en_out(wb_en_mem),
        .alu_res_out(alu_res_mem),
        .val_rm_out(val_rm_mem),
        .dest_out(dest_mem),
        .clk(clk),
        .rst(rst),
        .mem_w_en_in(mem_w_en_exe),
        .mem_r_en_in(mem_r_en_exe),
        .wb_en_in(wb_en_exe),
        .alu_res_in(alu_res_exe),
        .val_rm_in(val_rm_exe),
        .dest_in(dest_exe)
    );

    /* MEM stage */
    dist_mem_gen_1 memory_stage (
        .spo(data_mem_out),
        .clk(clk),
        .we(mem_w_en_mem),
        .d(val_rm_mem),
        .a(alu_res_mem)
    );

    /* MEM pipe */
    MEM_PIPE memory_pipe (
        .mem_r_en_out(mem_r_en_wb),
        .wb_en_out(wb_en_wb),
        .alu_res_out(alu_res_wb),
        .data_memory_out(data_memory_wb),
        .dest_out(dest_wb),
        .clk(clk),
        .rst(rst),
        .wb_en_in(wb_en_mem),
        .mem_r_en_in(mem_r_en_mem),
        .alu_res_in(alu_res_mem),
        .data_memory_in(data_mem_out),
        .dest_in(dest_mem)
    );

    /* WB stage */
    WB_STAGE wb_stage (
        .wb_wb_en(wb_wb_en),
        .wb_dest(wb_dest),
        .wb_value(wb_value),
        .clk(clk),
        .rst(rst),
        .wb_en(wb_en_wb),
        .mem_r_en(mem_r_en_wb),
        .alu_res(alu_res_wb),
        .data_mem_res(data_memory_wb),
        .dest(dest_wb)
    );

    /* Hazard unit */
    HAZARD_UNIT hazard_unit (
        .hazard(hazard),
        .clk(clk),
        .rst(rst),
        .src1_id_exe(src1_id),
        .src2_id_exe(src2_id),
        .exe_dest(dest_exe),
        .mem_dest(dest_mem),
        .exe_wb_en(wb_en_exe),
        .mem_wb_en(wb_en_mem),
        .exe_mem_r_en(mem_r_en_exe),
        .forward_en(forward_enable),
        .two_src(two_src_id)
    );

    /* Forwawrd unit */
    FORWARD_UNIT forward_unit (
        .src1_id_exe(src1_id_exe),
        .src2_id_exe(src2_id_exe),
        .wb_dest(wb_dest),
        .dest_mem(dest_mem),
        .wb_wb_en(wb_wb_en),
        .mem_en_mem(wb_en_mem),
        .sel_src1(sel_src1),
        .sel_src2(sel_src2)
    );

endmodule
