`timescale 1ns / 1ps

module MEM_STAGE (
    input  wire        clk,
    input  wire        rst,
    input  wire        MEM_R_EN,
    input  wire        MEM_W_EN,
    input  wire        WB_EN,
    input  wire [31:0] ALU_Res,
    input  wire [31:0] Val_Rm,
    input  wire [3:0]  Dest,

    output wire [31:0] MEM_Result,
    output wire [31:0] ALU_Res_out,
    output wire [3:0]  Dest_out,
    output wire        WB_EN_out,
    output wire        MEM_R_EN_out
);

    // -------------------------------------------------
    // Address adjustment (subtract 1024 safely)
    // -------------------------------------------------
    wire [31:0] alu_res_adj;
    assign alu_res_adj = (ALU_Res >= 32'd1024) ? (ALU_Res - 32'd1024) : 32'd0;

    // Word address (2048 words)
    wire [10:0] mem_addr;
    assign mem_addr = alu_res_adj;

    // -------------------------------------------------
    // Distributed RAM (Async Read / Sync Write)
    // -------------------------------------------------
    (* ram_style = "distributed" *)
    reg [31:0] data_mem [0:2047];

    // synchronous write
    always @(posedge clk) begin
        if (MEM_W_EN) begin
            data_mem[mem_addr] <= Val_Rm;
        end
    end

    // asynchronous read
    assign MEM_Result = (MEM_R_EN) ? data_mem[mem_addr] : 32'b0;

    // -------------------------------------------------
    // Pipeline pass-through
    // -------------------------------------------------
    assign ALU_Res_out  = ALU_Res;
    assign Dest_out     = Dest;
    assign WB_EN_out    = WB_EN;
    assign MEM_R_EN_out = MEM_R_EN;

endmodule
