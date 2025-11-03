`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 05:19:43 PM
// Design Name: 
// Module Name: TEST_BENCH
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
`timescale 1ns / 1ps

module TEST_BENCH;
    // Inputs
    reg clk;
    reg rst;
    reg [31:0] pc;
    reg [31:0] instruction_memory;
    // Outputs
    wire [31:0] pc_out;
    wire [31:0] instruction_memory_out;
    // Instantiate the Unit Under Test (UUT)
    ARM_TOP uut (
        .clk(clk),
        .rst(rst),
        .pc(pc),
        .instruction_memory(instruction_memory),
        .pc_out(pc_out),
        .instruction_memory_out(instruction_memory_out)
    );
    // Clock generation
    always #5 clk = ~clk;  // 100MHz clock (10ns period)  
    // Test cases
    initial begin
        // Initialize Inputs
        rst = 1;
        clk = 0;
        pc = 32'h00000000;
        instruction_memory = 32'h00000000;
        #5
        rst = 0;
        #100
        $finish;
    end
   
endmodule
