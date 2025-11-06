`timescale 1ns / 1ps

`timescale 1ns / 1ps

module ARM_TOP (
    input clk,
    input rst,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_memory_out
);
    
    // Stage and pipeline registers
    wire [31:0] ps_stage_1, ps_pipe_1;
    wire [31:0] ins_stage_1, ins_pipe_1;
    wire [31:0] ps_stage_2, ps_pipe_2;
    wire [31:0] ins_stage_2, ins_pipe_2;
    wire [31:0] ps_stage_3, ps_pipe_3;
    wire [31:0] ins_stage_3, ins_pipe_3;
    wire [31:0] ps_stage_4, ps_pipe_4;
    wire [31:0] ins_stage_4, ins_pipe_4;
    wire [31:0] ps_stage_5;
    wire [31:0] ins_stage_5;

    // ID stage signals
    wire [3:0] EXE_CMD;
    wire MEM_R_EN, MEM_W_EN, WB_EN, Branch, Status_update;
    wire [31:0] Val_Rn, Val_Rm;
    wire [11:0] shift_operand;
    wire imm;
    wire [23:0] signed_imm_24;
    wire [3:0] Dest;
    wire [3:0] rn, rm;
    wire Two_src;
    
    wire f;      // flush signal
    wire fz;     // freeze signal
    wire [31:0] ba; // branch address
    wire bs; // branch selector
    wire Hazard;

    // Write-back signals
    wire WB_WB_EN;
    wire [31:0] WB_WB_value;
    wire [3:0] WB_WB_dest;
    wire [3:0] status;

    assign ba = 32'b0;
    assign bs = 1'b0;
    assign Hazard = 1'b0;
    assign WB_WB_EN = 1'b1;
    assign WB_WB_value = 32'b0;
    assign WB_WB_dest = 4'b0;
    assign status = 4'b0;
    assign fz = 1'b0;

    // IF stage
    IF_STAGE m1 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_1),
        .instruction_memory(ins_stage_1),
        .Branch_Address(ba),
        .Branch_Taken(bs),
        .freeze(fz)
    );
    
    // REG_PIPE_1
    REG_PIPE_1 r1 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_1),
        .instruction_memory(ins_stage_1),
        .output_pc(ps_pipe_1),
        .output_instruction_memory(ins_pipe_1),
        .flush(f),
        .freez(fz)
    );
    
    // ID_STAGE
    ID_STAGE m2(
        .clk(clk),
        .rst(rst),
        .Hazard(Hazard),
        .instruction(ins_pipe_1),
        .pc(ps_pipe_1),
        .WB_WB_EN(WB_WB_EN),
        .WB_WB_value(WB_WB_value),
        .WB_WB_dest(WB_WB_dest),
        .status(status),
        .PC(ps_stage_2),
        .EXE_CMD(EXE_CMD),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .WB_EN(WB_EN),
        .Branch(Branch),
        .Status_update(Status_update),
        .Val_Rn(Val_Rn),
        .Val_Rm(Val_Rm),
        .shift_operand(shift_operand),
        .imm(imm),
        .signed_imm_24(signed_imm_24),
        .Dest(Dest),
        .rn(rn),
        .rm(rm),
        .Two_src(Two_src),
        .output_instruction_memory(ins_stage_2)
    );
    
    // Updated REG_PIPE_2
    REG_PIPE_2 r2 (
        .clk(clk),
        .rst(rst),
        .flush(f),
        .pc(ps_stage_2),
        .instruction_memory(ins_stage_2),
        .WB_EN(WB_EN),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .EXE_CMD(EXE_CMD),
        .B(Branch),
        .S(Status_update),
        .Val_Rn(Val_Rn),
        .Val_Rm(Val_Rm),
        .shift_operand(shift_operand),
        .imm(imm),
        .signed_imm_24(signed_imm_24),
        .Dest(Dest),
        .output_pc(ps_pipe_2),
        .output_instruction_memory(ins_pipe_2),
        .out_WB_EN(),
        .out_MEM_R_EN(),
        .out_MEM_W_EN(),
        .out_EXE_CMD(),
        .out_B(),
        .out_S(),
        .out_Val_Rn(),
        .out_Val_Rm(),
        .out_shift_operand(),
        .out_imm(),
        .out_signed_imm_24(),
        .out_Dest()
    );
    
    // EXE stage
    EXE_STAGE m3 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_2),
        .instruction_memory(ins_pipe_2),
        .output_pc(ps_stage_3),
        .output_instruction_memory(ins_stage_3),
        .flush(f)
    );
    
    // Remaining pipeline registers and stages
    REG_PIPE_3 r3 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_3),
        .instruction_memory(ins_stage_3),
        .output_pc(ps_pipe_3),
        .output_instruction_memory(ins_pipe_3)
    );
    
    MEM_STAGE m4 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_3),
        .instruction_memory(ins_pipe_3),
        .output_pc(ps_stage_4),
        .output_instruction_memory(ins_stage_4)
    );
    
    REG_PIPE_4 r4 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_4),
        .instruction_memory(ins_stage_4),
        .output_pc(ps_pipe_4),
        .output_instruction_memory(ins_pipe_4)
    );
    
    WB_STAGE m5 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_4),
        .instruction_memory(ins_pipe_4),
        .output_pc(ps_stage_5),
        .output_instruction_memory(ins_stage_5)
    );
    
    always @(*) begin
        pc_out = ps_stage_5;
        instruction_memory_out = ins_stage_5;
    end
    
endmodule
