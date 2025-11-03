`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 04:16:36 PM
// Design Name: 
// Module Name: pc
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


module pc ( input  wire clk,
    input  wire rst,
    input  wire freeze,
    input  wire [31:0] d,    
    output reg  [31:0] c      
);

always @(posedge clk, rst) begin
        if (rst) begin
            c <= 32'b0;
        end else begin
            if (freeze) begin
                c <= c;
            end else begin
            c <= d;
            end
        end
    end
endmodule

