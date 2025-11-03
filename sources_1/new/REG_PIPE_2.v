`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 05:13:19 PM
// Design Name: 
// Module Name: REG_PIPE_2
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
module REG_PIPE_2(
    input clk,
    input rst,
    input flush,
    
    // Control signals from ID_STAGE
    input WB_EN,
    input MEM_R_EN,
    input MEM_W_EN,
    input [3:0] EXE_CMD,
    input B,
    input S,
    
    // Data signals from ID_STAGE
    input [31:0] pc,
    input [31:0] instruction_memory,
    input [31:0] Val_Rn,
    input [31:0] Val_Rm,
    input [11:0] shift_operand,
    input imm,
    input [23:0] signed_imm_24,
    input [3:0] Dest,
    
    // Outputs to EXE_STAGE
    output reg [31:0] output_pc,
    output reg [31:0] output_instruction_memory,
    output reg out_WB_EN,
    output reg out_MEM_R_EN,
    output reg out_MEM_W_EN,
    output reg [3:0] out_EXE_CMD,
    output reg out_B,
    output reg out_S,
    output reg [31:0] out_Val_Rn,
    output reg [31:0] out_Val_Rm,
    output reg [11:0] out_shift_operand,
    output reg out_imm,
    output reg [23:0] out_signed_imm_24,
    output reg [3:0] out_Dest
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_pc <= 32'b0;
            output_instruction_memory <= 32'b0;
            out_WB_EN <= 1'b0;
            out_MEM_R_EN <= 1'b0;
            out_MEM_W_EN <= 1'b0;
            out_EXE_CMD <= 4'b0;
            out_B <= 1'b0;
            out_S <= 1'b0;
            out_Val_Rn <= 32'b0;
            out_Val_Rm <= 32'b0;
            out_shift_operand <= 12'b0;
            out_imm <= 1'b0;
            out_signed_imm_24 <= 24'b0;
            out_Dest <= 4'b0;
        end else if (flush) begin
            // Clear outputs (flush)
            output_pc <= 32'b0;
            output_instruction_memory <= 32'b0;
            out_WB_EN <= 1'b0;
            out_MEM_R_EN <= 1'b0;
            out_MEM_W_EN <= 1'b0;
            out_EXE_CMD <= 4'b0;
            out_B <= 1'b0;
            out_S <= 1'b0;
            out_Val_Rn <= 32'b0;
            out_Val_Rm <= 32'b0;
            out_shift_operand <= 12'b0;
            out_imm <= 1'b0;
            out_signed_imm_24 <= 24'b0;
            out_Dest <= 4'b0;
        end else begin
            // Normal operation
            output_pc <= pc;
            output_instruction_memory <= instruction_memory;
            out_WB_EN <= WB_EN;
            out_MEM_R_EN <= MEM_R_EN;
            out_MEM_W_EN <= MEM_W_EN;
            out_EXE_CMD <= EXE_CMD;
            out_B <= B;
            out_S <= S;
            out_Val_Rn <= Val_Rn;
            out_Val_Rm <= Val_Rm;
            out_shift_operand <= shift_operand;
            out_imm <= imm;
            out_signed_imm_24 <= signed_imm_24;
            out_Dest <= Dest;
        end
    end
    
endmodule

