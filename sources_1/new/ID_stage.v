`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 04:34:05 PM
// Design Name: 
// Module Name: ID_stage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ID_STAGE (
    input clk,
    input rst,
    input Hazard,
    input [31:0] instruction,
    input [31:0] pc,
    input WB_WB_EN,
    input [31:0] WB_WB_value,
    input [3:0] WB_WB_dest,
    input [3:0] status,
    
    output [31:0] PC,
    output [3:0] EXE_CMD,
    output MEM_R_EN,
    output MEM_W_EN,
    output WB_EN,
    output Branch,
    output Status_update,
    
    output [31:0] Val_Rn,
    output [31:0] Val_Rm,
    output [11:0] shift_operand,
    output imm,
    output [23:0] signed_imm_24,
    output [3:0] Dest,
    output [3:0] rn,
    output [3:0] rm,
    output wire Two_src,
    output [31:0] output_instruction_memory
    );

    // Instruction fields
    wire [3:0] cond = instruction[31:28];
    wire [1:0] mode = instruction[27:26];
    wire i = instruction[25];
    wire [3:0] opcode = instruction[24:21];
    wire s = instruction[20];
    wire [3:0] rd = instruction[15:12];
    wire [4:0] shift_imm = instruction[11:7];
    wire [1:0] shift = instruction[6:5];

    // Control signals
    wire [8:0] CU_output;
    wire [3:0] src4_mux_out;
    wire [8:0] src9_mux_out;
    wire uncond_MEM_W_EN;
    wire uncond_MEM_R_EN;
    wire or_output;
    wire condition_passed;
    
    
    
    assign src4_mux_out = (uncond_MEM_W_EN) ? rd : rm;
    assign src9_mux_out = (or_output) ? CU_output : 9'b0;
    assign Two_src = !(imm || uncond_MEM_R_EN);
    assign or_output = Hazard || condition_passed;
    assign uncond_MEM_R_EN = CU_output[1];
    assign uncond_MEM_W_EN = CU_output[2];

    // Register File
    RegisterFile RF (
        .clk(clk),
        .rst(rst),
        .src_1(rn),
        .src_2(src4_mux_out),
        .Dest_WB(WB_WB_dest),
        .Result_WB(WB_WB_value),
        .writeBackEN(WB_WB_EN),
        .reg_out_1(Val_Rn),
        .reg_out_2(Val_Rm)
    );

    // Condition checker
    ConditionCheck CC (
        .inst_cond(cond),
        .status_reg_out(status),
        .condition_out(condition_passed)
    );
    
    // Control unit
    ControlUnit CU (
        .instruction(instruction),
        .cu_out(CU_output)
    );

    // Outputs
    assign PC = pc;
    assign EXE_CMD = CU_output[8:5]; // example mapping
    assign MEM_R_EN = uncond_MEM_R_EN;
    assign MEM_W_EN = uncond_MEM_W_EN;
    assign WB_EN = CU_output[3];
    assign Branch = CU_output[4];
    assign Status_update = s;
    assign shift_operand = instruction[11:0]; // example concatenation
//    assign rm = instruction[3:16];
    assign rn = instruction[19:16];
    
    assign imm = i;
    assign signed_imm_24 = instruction[23:0];
    assign Dest = rd;
    assign output_instruction_memory = instruction;

endmodule

