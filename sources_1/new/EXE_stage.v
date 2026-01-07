module EXE_STAGE (
    input clk, rst,
    input wb_en_in, mem_r_en_in, mem_w_en_in,
    input [3:0] exe_cmd_in,
    input [1:0] sel_src1, sel_src2,
    input s_in, b_in,
    input [31:0] pc_in,
    input [3:0] src1_in, src2_in,
    input [31:0] val_rn_in,
    input [31:0] val_rm_in,
    input [31:0] wb_value,
    input [31:0] alu_res_mem,
    input [11:0] shift_operand_in,
    input imm_in,
    input [23:0] signed_imm_24_in,
    input [3:0] dest_in,
    input c_in,
    output wb_en_out, mem_r_en_out, mem_w_en_out, branch_taken,
    output [3:0] src1_out, src2_out,
    output [31:0] alu_res,
    output [31:0] val_rm_out,
    output [3:0] dest_out,
    output [3:0] status_register_out,
    output [31:0] branch_address
);

    wire [31:0] val2, mux1_out, mux2_out;
    wire s_signal = mem_r_en_in | mem_w_en_in;
    wire [3:0] status_register_in;

    Mux_4To1 mux1(
        .in0(val_rn_in),
        .in1(alu_res_mem),
        .in2(wb_value),
        .in3(32'b0),
        .sel(sel_src1),
        .out(mux1_out)
    );

    Mux_4To1 mux2(
        .in0(val_rm_in),
        .in1(alu_res_mem),
        .in2(wb_value),
        .in3(32'b0),
        .sel(sel_src2),
        .out(mux2_out)
    );

    Val2Generator val2_gen_i(
        .s_flag(s_signal),
        .result(val2),
        .reg_value(mux2_out),
        .sh_operand(shift_operand_in),
        .is_imm(imm_in)
       
    );

    ALU alu_i(
        .a_in(mux1_out),
        .b_in(val2),
        .op_code(exe_cmd_in),
        .carry_in(c_in),
        .result(alu_res),
        .status(status_register_in)
    );

    Status_Register status_register(
        .clk(clk),
        .rst(rst),
        .status_en(s_in),
        .in_data(status_register_in),
        .out_data(status_register_out)
    );
    
    
    assign src1_out = src1_in;
    assign src2_out =  src2_in;
    assign dest_out = dest_in;
    assign wb_en_out = wb_en_in;
    assign mem_r_en_out = mem_r_en_in;
    assign mem_w_en_out = mem_w_en_in;
    assign val_rm_out = mux2_out;
    assign branch_taken = b_in;
    assign branch_address = pc_in + {{8{signed_imm_24_in[23]}}, signed_imm_24_in};
    assign src1_out = src1_in;
    assign src2_out =  src2_in;



endmodule













