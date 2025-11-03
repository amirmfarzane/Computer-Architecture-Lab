`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 04:59:01 PM
// Design Name: 
// Module Name: mux_2to1_9bit
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


module mux_2to1_9bit (
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] out
);
    
    assign out = sel ? b : a;
    
endmodule

