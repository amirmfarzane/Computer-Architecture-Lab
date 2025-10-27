`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 05:16:39 PM
// Design Name: 
// Module Name: REG_PIPE_3
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


module REG_PIPE_3(
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] instruction_memory,
    output reg [31:0] output_pc,
    output reg [31:0] output_instruction_memory
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_pc <= 32'b0;
            output_instruction_memory <= 32'b0;
        end else begin
            // Normal operation
            output_pc <= pc;
            output_instruction_memory <= instruction_memory;
        end
    end
    
endmodule
