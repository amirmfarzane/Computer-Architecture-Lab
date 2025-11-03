`timescale 1ns / 1ps

module REG_PIPE_3(
    input  clk,
    input  rst,

    input        WB_EN,
    input        MEM_R_EN,
    input        MEM_W_EN,
    input [31:0] ALU_Res,
    input [31:0] Val_Rm,
    input [3:0]  Dest,

    output reg        WB_EN_out,
    output reg        MEM_R_EN_out,
    output reg        MEM_W_EN_out,
    output reg [31:0] Val_Rm_out,
    output reg [3:0]  Dest_out,
    output reg [31:0] ALU_Res_out
  
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Val_Rm_out <= 32'b0;
            Dest_out <= 4'b0;
            ALU_Res_out <= 32'b0;
            WB_EN_out <= 1'b0;
            MEM_R_EN_out <= 1'b0;
            MEM_W_EN_out <= 1'b0;
        end else begin
            Val_Rm_out <= Val_Rm;
            Dest_out <= Dest;
            ALU_Res_out <= ALU_Res;
            WB_EN_out <=  WB_EN;
            MEM_R_EN_out <= MEM_R_EN;
            MEM_W_EN_out <= MEM_W_EN3
            
            
            
            
            
            
            
            3;
        end
    end
    
endmodule