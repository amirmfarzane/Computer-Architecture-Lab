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
    
    // Test variables
    integer i;
    
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
        clk = 0;
        rst = 1;
        pc = 32'h00000000;
        instruction_memory = 32'h00000000;
        
        // Apply reset
        #20;
        rst = 0;
        
        $display("Starting ARM Pipeline Testbench");
        $display("Time\tCLK\tRST\tPC_IN\tINST_IN\t\tPC_OUT\tINST_OUT");
        $display("----------------------------------------------------------------");
        
        // Test Case 1: Simple instructions
        $display("\nTest Case 1: Simple Instructions");
        pc = 32'h00000000;
        instruction_memory = 32'hE3A01064;  // MOV R1, #100
        #10;
        display_status();
        
        pc = 32'h00000004;
        instruction_memory = 32'hE3A020C8;  // MOV R2, #200
        #10;
        display_status();
        
        pc = 32'h00000008;
        instruction_memory = 32'hE0813002;  // ADD R3, R1, R2
        #10;
        display_status();
        
        // Test Case 2: Memory operations
        $display("\nTest Case 2: Memory Operations");
        pc = 32'h0000000C;
        instruction_memory = 32'hE5914000;  // LDR R4, [R1]
        #10;
        display_status();
        
        pc = 32'h00000010;
        instruction_memory = 32'hE5815000;  // STR R5, [R1]
        #10;
        display_status();
        
        // Test Case 3: Branch instructions
        $display("\nTest Case 3: Branch Instructions");
        pc = 32'h00000014;
        instruction_memory = 32'hEA000005;  // B #20
        #10;
        display_status();
        
        pc = 32'h00000018;
        instruction_memory = 32'h0A000001;  // BEQ #4
        #10;
        display_status();
        
        // Test Case 4: Reset test
        $display("\nTest Case 4: Reset Test");
        rst = 1;
        #15;
        display_status();
        
        rst = 0;
        pc = 32'h0000001C;
        instruction_memory = 32'hE1A06000;  // MOV R6, R0
        #10;
        display_status();
        
        // Test Case 5: Pipeline filling with various instructions
        $display("\nTest Case 5: Pipeline Filling Test");
        for (i = 0; i < 10; i = i + 1) begin
            pc = 32'h00000020 + (i * 4);
            instruction_memory = 32'hE2800001 + i;  // Sequential instructions
            #10;
            display_status();
        end
        
        // Wait for pipeline to complete
        #50;
        
        $display("\nFinal Pipeline State:");
        display_status();
        
        $display("\nTestbench completed successfully!");
        $finish;
    end
    
    // Task to display current status
    task display_status;
        begin
            $display("%0t\t%b\t%b\t%h\t%h\t%h\t%h", 
                    $time, clk, rst, pc, instruction_memory, pc_out, instruction_memory_out);
        end
    endtask
endmodule
