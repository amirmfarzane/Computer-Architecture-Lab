`timescale 1ns / 1ps

module ARM_TOP (
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] instruction_memory,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_memory_out
);
    
    // Wire declarations for all inter-module connections
    wire [31:0] ps_stage_1;
    wire [31:0] ins_stage_1;
    wire [31:0] ps_pipe_1;
    wire [31:0] ins_pipe_1;
    wire [31:0] ps_stage_2;
    wire [31:0] ins_stage_2;
    wire [31:0] ps_pipe_2;
    wire [31:0] ins_pipe_2;
    wire [31:0] ps_stage_3;
    wire [31:0] ins_stage_3;
    wire [31:0] ps_pipe_3;
    wire [31:0] ins_pipe_3;
    wire [31:0] ps_stage_4;
    wire [31:0] ins_stage_4;
    wire [31:0] ps_pipe_4;
    wire [31:0] ins_pipe_4;
    wire [31:0] ps_stage_5;
    wire [31:0] ins_stage_5;
    wire f;      // flush signal
    wire fz;     // freeze signal

    IF_STAGE m1 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_1),
        .instruction_memory(ins_stage_1)
    );
    
    REG_PIPE_1 r1 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_1),
        .instruction_memory(ins_stage_1),
        .pc_out(ps_pipe_1),
        .output_instruction_memory(ins_pipe_1),
        .flush(f),
        .freez(fz)
    );
    
    ID_STAGE m2(
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_1),
        .instruction_memory(ins_pipe_1),
        .pc_out(ps_stage_2),
        .instruction_memory_out(ins_stage_2)
    );
    
    REG_PIPE_2 r2 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_2),
        .instruction_memory(ins_stage_2),
        .pc_out(ps_pipe_2),
        .instruction_memory_out(ins_pipe_2),
        .flush(f)
    );
    
    EXE_STAGE m3 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_2),
        .instruction_memory(ins_pipe_2),
        .pc_out(ps_stage_3),
        .instruction_memory_out(ins_stage_3)
    );
    
    REG_PIPE_3 r3 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_3),
        .instruction_memory(ins_stage_3),
        .pc_out(ps_pipe_3),
        .instruction_memory_out(ins_pipe_3)
    );
    
    MEM_STAGE m4 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_3),
        .instruction_memory(ins_pipe_3),
        .pc_out(ps_stage_4),
        .instruction_memory_out(ins_stage_4)
    );
    
    REG_PIPE_4 r4 (
        .clk(clk),
        .rst(rst),
        .pc(ps_stage_4),
        .instruction_memory(ins_stage_4),
        .pc_out(ps_pipe_4),
        .instruction_memory_out(ins_pipe_4)
    );
    
    WB_STAGE m5 (
        .clk(clk),
        .rst(rst),
        .pc(ps_pipe_4),
        .instruction_memory(ins_pipe_4),
        .pc_out(ps_stage_5),
        .instruction_memory_out(ins_stage_5)
    );
    
    // You might want to connect the final outputs
    always @(*) begin
        pc_out = ps_stage_5;
        instruction_memory_out = ins_stage_5;
    end
    
endmodule