`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 04:24:09 PM
// Design Name: 
// Module Name: IF_stage
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


module IF_STAGE(
    input clk,
    input rst,
    input freeze,
    input [31:0] Branch_Address,
    input Branch_Taken,
    output [31:0] pc,
    output [31:0] instruction_memory
);
    // Internal wires
    wire [11:0] pc_out;
    wire [31:0] adder_out;
    wire [31:0] mux_out;
    wire cout;
    // Program Counter (PC) module
    pc  pc_inst (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .d(mux_out),
        .c(pc_out)
    );
    // Adder for PC + 4
    adder_32bit adder_inst (
        .a(32'd1),
        .b(pc_out),
        .cin(1'b0),
        .sum(adder_out),
        .cout(cout)
    );
    // 2-to-1 MUX for branch selection
    mux_2to1 mux_inst (
        .a(adder_out),
        .b(Branch_Address),
        .sel(Branch_Taken),
        .out(mux_out)
    );
    // Instruction Memory Module
    dist_mem_gen_1 instance_name (
      .a(pc_out),      // input wire [10 : 0] a
      .spo(instruction_memory)  // output wire [31 : 0] spo
    );
    // Assign PC output
    assign pc = adder_out;
endmodule
