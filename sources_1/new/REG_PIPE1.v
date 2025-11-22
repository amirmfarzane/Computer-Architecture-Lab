`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 05:01:31 PM
// Design Name: 
// Module Name: PIPE_REG
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


module REG_PIPE_1(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] instruction_memory,
    input flush,
    input freez,
    output reg [31:0] output_pc,
    output reg [31:0] output_instruction_memory
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_pc <= 32'b0;
            output_instruction_memory <= 32'b0;
        end else if (freez) begin
            // Keep current values (freeze)
            output_pc <= output_pc;
            output_instruction_memory <= output_instruction_memory;
        end else if (flush) begin
            // Clear outputs (flush)
            output_pc <= 32'b0;
            output_instruction_memory <= 32'b0;
        end else begin
            // Normal operation
            output_pc <= pc;
            output_instruction_memory <= instruction_memory;
        end
    end
    
endmodule
