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


module PC (
    input clk, rst, freeze,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            pc_out <= 32'h0;
        end else if (!freeze) begin
            pc_out <= pc_in;
        end
    end

endmodule

