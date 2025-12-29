module EXE_STAGE (
    input  wire        clk,
    input  wire        rst,

    input  wire        WB_EN,
    input  wire        MEM_R_EN,
    input  wire        MEM_W_EN,
    input  wire [3:0]  EXE_CMD,
    input  wire        B,
    input  wire        S,
    input  wire [31:0] PC,
    input  wire [31:0] Val_Rn,
    input  wire [31:0] Val_Rm,
    input  wire [31:0] Imm,
    input  wire [11:0] Shift_operand,
    input  wire [23:0] Signed_EX_Imm24,
    input  wire [3:0]  Dest,         

    output wire        WB_EN_out,
    output wire        MEM_R_EN_out,
    output wire        MEM_W_EN_out,
    output wire [31:0] ALU_Res,
    output wire [31:0] Val_Rm_out,
    output wire [3:0]  Dest_out,
    output wire [31:0] Branch_Address,
    output wire [3:0]  Status_out   
);
    wire Val2_Src = MEM_W_EN | MEM_R_EN;
    wire cout;
    wire [31:0] Val2;
    Val2_Gen val2_gen_i (
        .Val_Rm(Val_Rm),
        .Imm(Imm),
        .Shift_operand(Shift_operand),
        .Val2_Src(Val2_Src),
        .Val2(Val2)
    );

    wire [3:0] alu_flags; // [N,Z,C,V]
    ALU alu_i (
        .Val1(Val_Rn),
        .Val2(Val2),
        .EXE_CMD(EXE_CMD),
        .Status(Status_out),
        .ALU_Res(ALU_Res),
        .Flags(alu_flags)
    );

    adder_32bit adder_inst (
        .a(PC),
        .b({8'b00000000, Signed_EX_Imm24}),
        .cin(1'b0),
        .sum(Branch_Address),
        .cout(cout)
    );

    Status_Reg psr_i (
        .clk(clk),
        .rst(rst),
        .S(S),
        .Flags_in(alu_flags),
        .Status_out(Status_out)
    );

    assign WB_EN_out     = WB_EN;
    assign MEM_R_EN_out  = MEM_R_EN;
    assign MEM_W_EN_out  = MEM_W_EN;
    assign Val_Rm_out    = Val_Rm;   
    assign Dest_out      = Dest;

endmodule
