`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2025 05:07:35 PM
// Design Name: 
// Module Name: HAZARD_unit
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


module HAZARD_unit(
    input [3:0]src1,
    input [3:0]src2,
    input [3:0] exe_dest,
    input exe_wb_en,
    input [3:0]mem_dest,
    input mem_wb_en,
    input two_src,
    output reg hazard_detected
    );
    reg hazard_from_exe;
    reg hazard_from_mem;

    always @(*) begin
        
        hazard_from_exe = exe_wb_en && (
            (src1 == exe_dest) ||
            (two_src && (src2 == exe_dest))
        );

        hazard_from_mem = mem_wb_en && (
            (src1 == mem_dest) ||
            (two_src && (src2 == mem_dest))
        );
        hazard_detected = hazard_from_exe || hazard_from_mem;
    end
endmodule

