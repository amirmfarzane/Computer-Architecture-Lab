`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 04:38:18 PM
// Design Name: 
// Module Name: EX_stage
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


module EXE_STAGE(
    input [31:0] pc,
    input [31:0] instruction_memory,
    output [31:0] output_pc,
    output [31:0] output_instruction_memory
);
    
    // Pass inputs directly to outputs
    assign output_pc = pc;
    assign output_instruction_memory = instruction_memory;
    
endmodule
