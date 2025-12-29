`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 05:13:19 PM
// Design Name: 
// Module Name: REG_PIPE_4
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


module REG_PIPE_4 (
    input clk,
    input rst,

    input  [31:0] MEM_Result,
    input  WB_EN,
    input  [31:0] ALU_Res,
    input  [3:0]  Dest,
    input         MEM_W_EN,
    input         MEM_R_EN,

    output reg [31:0] MEM_Result_out,
    output reg WB_EN_out,
    output reg [31:0] ALU_Res_out,
    output reg [3:0]  Dest_out,
    output reg        MEM_W_EN_out,
    output reg        MEM_R_EN_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_Result_out <= 32'b0;
            ALU_Res_out    <= 32'b0;
            Dest_out       <= 4'b0;
            MEM_W_EN_out   <= 1'b0;
            MEM_R_EN_out   <= 1'b0;
            WB_EN_out   <= 1'b0;
        end else begin
            MEM_Result_out <= MEM_Result;
            WB_EN_out   <= WB_EN;
            ALU_Res_out    <= ALU_Res;
            Dest_out       <= Dest;
            MEM_W_EN_out   <= MEM_W_EN;
            MEM_R_EN_out   <= MEM_R_EN;
        end
    end

endmodule
