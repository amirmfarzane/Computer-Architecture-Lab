module ID_STAGE (
    input clk, rst, hazard, wb_wb_en,
    input [3:0] status_reg_out, wb_dest,
    input [31:0] pc_in, instruction, wb_value,
    output wb_en, mem_r_en, mem_w_en, b, s,
    output [3:0] exe_cmd,
    output [31:0] pc_out, val_rn, val_rm,
    output imm,
    output [11:0] shift_operand,
    output [23:0] signed_imm_24,
    output [3:0] dest,
    output c_out,
    output two_src, 
    output [3:0] src1, src2
);

    wire S = instruction[20];
    wire [1:0] mode = instruction[27:26];
    wire [3:0] opcode = instruction[24:21];
    wire [3:0] cond = instruction[31:28];
    wire [3:0] rn = instruction[19:16];
    wire [3:0] rm = instruction[3:0];
    wire [3:0] rd = instruction[15:12];
    
    wire wb_en_cu_out, mem_read_cu_out, mem_write_cu_out, b_cu_out, s_cu_out, condition_check_out;
    wire [3:0] exe_cmd_cu_out;
    wire cu_en = (~condition_check_out | hazard);
    
    
    assign shift_operand = instruction[11:0];
    assign signed_imm_24 = instruction[23:0];
    assign dest = instruction[15:12];
    assign imm = instruction[25];
    assign pc_out = pc_in;
    assign c_out = status_reg_out[2];
    assign two_src = (~imm) | mem_write_cu_out;

    
    assign src1 = rn;
    assign src2 = mem_write_cu_out ? rd : rm;

    assign wb_en    = cu_en ? 1'b0 : wb_en_cu_out;
    assign mem_r_en = cu_en ? 1'b0 : mem_read_cu_out;
    assign mem_w_en = cu_en ? 1'b0 : mem_write_cu_out;
    assign b        = cu_en ? 1'b0 : b_cu_out;
    assign s        = cu_en ? 1'b0 : s_cu_out;
    assign exe_cmd  = cu_en ? 4'd0 : exe_cmd_cu_out;

    
    
    RegisterFile RF (
        .clk(clk),
        .rst(rst),  
        .src_1(src1),
        .src_2(src2),
        .Dest_WB(wb_dest),
        .Result_WB(wb_value),
        .writeBackEN(wb_wb_en),
        .reg_out_1(val_rn),
        .reg_out_2(val_rm)
    );

    ControlUnit CU (
        .mode_in(mode),
        .opcode_in(opcode),
        .s_in(S),
        .wb_enable(wb_en_cu_out),
        .mem_read(mem_read_cu_out),
        .mem_write(mem_write_cu_out),
        .branch_out(b_cu_out),
        .s_out(s_cu_out),
        .exe_command(exe_cmd_cu_out)
    );

    ConditionCheck CC(
        .condition(cond),
        .status_flags(status_reg_out),
        .cond_out(condition_check_out)
    );

    

endmodule


