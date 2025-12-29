`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 04:44:36 PM
// Design Name: 
// Module Name: WB_stage
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


module WB_STAGE (
    input clk,
    input rst,
    input        WB_EN,
    input [3:0]  Dest,
    input        MEM_R_EN,
    input [31:0] ALU_res,
    input [31:0] MEM_res,
    
    output reg [3:0]  WB_Dest,
    output reg [31:0] WB_value,
    output reg        WB_WB_en
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            WB_Dest   <= 4'b0;
            WB_value  <= 32'b0;
            WB_WB_en  <= 1'b0;
        end else begin
            WB_Dest  <= Dest;
            WB_WB_en <= WB_EN;

            // MUX: select write-back value
            if (MEM_R_EN)
                WB_value <= MEM_res;
            else
                WB_value <= ALU_res;
        end
    end

endmodule

