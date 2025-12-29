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
    
        // After ID -> REG_PIPE_2 outputs
    wire        EXE_WB_EN_2;
    wire        EXE_MEM_R_EN_2;
    wire        EXE_MEM_W_EN_2;
    wire [3:0]  EXE_EXE_CMD_2;
    wire        EXE_B_2;
    wire        EXE_S_2;
    wire [31:0] EXE_Val_Rn_2;
    wire [31:0] EXE_Val_Rm_2;
    wire [11:0] EXE_shift_operand_2;
    wire        EXE_imm_2;
    wire [23:0] EXE_signed_imm_24_2;
    wire [3:0]  EXE_Dest_2;
    
    wire WB_PIPE_EN_out;
    wire MEM_PIPE_R_EN_out;
    wire MEM_PIPE_W_EN_out;
    wire Val_PIPE_Rm_out;
    wire [31:0] ALU_PIPE_Res_out;
    wire [31:0] ALU_PIPE_Res_out4;
    
    wire [31:0] MEM_Result_out;
    
    wire [31:0] MEM_Result_pip4;
    wire WB_EN_out_pip4;
    wire [31:0] ALU_Res_pip4;
    wire [3:0]  Dest_pip4;
    wire        MEM_W_EN_pip4;
    wire        MEM_R_EN_pip4;
    wire [31:0] WB_value;
    wire        WB_WB_en;

    wire        WB_EN_out;
    wire        MEM_R_EN_out;
    wire        MEM_W_EN_out;
    
    wire [31:0] ALU_Res;
    wire [31:0] Val_Rm_out;
    
    
    wire [3:0] Dest;
    wire [3:0]  WB_Dest;
    wire [3:0]  Dest_REG_PIPE_3;
    wire [3:0] EXE_Dest;
    wire [3:0] MEM_Dest;
    wire Dest_PIPE_out;
    
    wire [31:0] Branch_Address;
    wire [3:0]  Status_out;   // assuming NZCV or similar flags
    
    wire [3:0] src2;
    wire EXE_WB_EN;
    
    wire MEM_WB_EN;
    wire hazard_detected;
    wire MEM_R_EN_pip5;
    wire MEM_R_EN_out3;
    wire [31:0] ps_pipe_0;
    wire [31:0] ins_pipe_0;
    

    assign ba = 32'b0;
    assign bs = 1'b0;
    assign Hazard = 1'b0;
    assign WB_WB_value = 32'b0;
    assign WB_WB_dest = 4'b0;
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
        .WB_WB_EN(WB_WB_en),
        .WB_WB_value(WB_value),
        .WB_WB_dest(WB_Dest),
        .status(Status_out),
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
        .output_instruction_memory(ins_stage_2),
        .src2(src2)
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
    
        .out_WB_EN(EXE_WB_EN_2),
        .out_MEM_R_EN(EXE_MEM_R_EN_2),
        .out_MEM_W_EN(EXE_MEM_W_EN_2),
        .out_EXE_CMD(EXE_EXE_CMD_2),
        .out_B(EXE_B_2),
        .out_S(EXE_S_2),
        .out_Val_Rn(EXE_Val_Rn_2),
        .out_Val_Rm(EXE_Val_Rm_2),
        .out_shift_operand(EXE_shift_operand_2),
        .out_imm(EXE_imm_2),
        .out_signed_imm_24(EXE_signed_imm_24_2),
        .out_Dest(EXE_Dest_2)
    );
    
    // EXE stage (updated)
    EXE_STAGE m3 (
        .clk(clk),
        .rst(rst),
        .WB_EN(WB_EN),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN),
        .EXE_CMD(EXE_CMD),
        .B(Branch),
        .S(Status_update),
        .PC(ps_stage_2),
        .Val_Rn(Val_Rn),
        .Val_Rm(Val_Rm),
        .Imm(imm),  // assuming immediate is Val_Rm here; adjust as needed
        .Shift_operand(shift_operand),
        .Signed_EX_Imm24(signed_imm_24),
        .Dest(Dest),
        .WB_EN_out(EXE_WB_EN),
        .MEM_R_EN_out(MEM_R_EN_out3),
        .MEM_W_EN_out(MEM_W_EN_out),
        .ALU_Res(ALU_Res),
        .Val_Rm_out(Val_Rm_out),
        .Dest_out(EXE_Dest),
        .Branch_Address(Branch_Address),
        .Status_out(Status_out)
    );
    
    // REG_PIPE_3
    REG_PIPE_3 r3 (
        .clk(clk),
        .rst(rst),
        .WB_EN(EXE_WB_EN),
        .MEM_R_EN(MEM_R_EN),
        .MEM_W_EN(MEM_W_EN_out),
        .ALU_Res(ALU_Res),
        .Val_Rm(Val_Rm_out),
        .Dest(EXE_Dest),
        .WB_EN_out(WB_PIPE_EN_out),
        .MEM_R_EN_out(MEM_R_EN_out),
        .MEM_W_EN_out(MEM_W_EN_out),
        .Val_Rm_out(Val_PIPE_Rm_out),
        .Dest_out(Dest_REG_PIPE_3),
        .ALU_Res_out(ALU_PIPE_Res_out)
    );
    
    MEM_STAGE m4 (
        .clk(clk),
        .rst(rst),
        .MEM_R_EN(MEM_R_EN),      
        .MEM_W_EN(MEM_W_EN),      
        .WB_EN(WB_PIPE_EN_out),        
        .ALU_Res(ALU_Res),            
        .Dest(Dest_REG_PIPE_3), 
        .Val_Rm(Val_Rm),         
        
        .MEM_Result(MEM_Result_out), 
        .ALU_Res_out(ALU_PIPE_Res_out4),   
        .Dest_out(MEM_Dest),      
        .WB_EN_out(MEM_WB_EN),     
        .MEM_R_EN_out(MEM_R_EN_pip4)
    );
    
    REG_PIPE_4 r4 (
        .clk(clk),
        .rst(rst),
    
        .MEM_Result(MEM_Result_out),
        .WB_EN(MEM_WB_EN),
        .ALU_Res(ALU_Res),
        .Dest(MEM_Dest),
        .MEM_R_EN(MEM_R_EN_pip4),
    
        .MEM_Result_out(MEM_Result_pip4),
        .WB_EN_out(WB_EN_out_pip4),
        .ALU_Res_out(ALU_Res_pip4),
        .Dest_out(Dest_pip4),
        .MEM_R_EN_out(MEM_R_EN_pip5)
    );

    WB_STAGE m5 (
        .clk(clk),
        .rst(rst),
    
        .WB_EN(WB_EN),
        .Dest(Dest),
        .MEM_R_EN(MEM_R_EN),
        .ALU_res(ALU_Res),
        .MEM_res(MEM_Result_out),
    
        .WB_Dest(WB_Dest),
        .WB_value(WB_value),
        .WB_WB_en(WB_WB_en)
    );
    
    HAZARD_unit hazar_unit(
        .src2(src2),
        .src1(rn),
        .two_src(Two_src),
        .exe_wb_en(EXE_WB_EN),
        .exe_dest(EXE_Dest),
        .mem_dest(MEM_Dest),
        .mem_wb_en(MEM_WB_EN),
        .hazard_detected(Hazard)
    );
    
    always @(*) begin
        pc_out = ps_stage_5;
        instruction_memory_out = ins_stage_5;
    end
    
endmodule
