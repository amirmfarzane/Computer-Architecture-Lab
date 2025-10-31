module EXE_STAGE (
    // ===== Inputs =====
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
    input  wire [31:0] Signed_EX_Imm24,
    input  wire [3:0]  Dest,
    input  wire [3:0]  Status,

    // ===== Outputs =====
    output wire        WB_EN_out,
    output wire        MEM_R_EN_out,
    output wire        MEM_W_EN_out,
    output wire [31:0] ALU_Res,
    output wire [31:0] Val_Rm_out,
    output wire [3:0]  Dest_out
);

    // ----- Internal signals -----
    wire Val2_Src;
    wire [31:0] Val2;
    wire [31:0] Branch_Address;

    // ----- OR gate -----
    assign Val2_Src = MEM_W_EN | MEM_R_EN;

    // ----- Val2 Generator -----
    Val2_Gen val2_gen_inst (
        .Val_Rm(Val_Rm),
        .Imm(Imm),
        .Shift_operand(Shift_operand),
        .Val2_Src(Val2_Src),
        .Val2(Val2)
    );

    // ----- ALU -----
    ALU alu_inst (
        .Val1(Val_Rn),
        .Val2(Val2),
        .EXE_CMD(EXE_CMD),
        .Status(Status),
        .ALU_Res(ALU_Res)
    );

    // ----- Adder -----
    Adder adder_inst (
        .PC(PC),
        .Signed_EX_Imm24(Signed_EX_Imm24),
        .Branch_Address(Branch_Address)
    );

    // ----- Output connections -----
    assign WB_EN_out   = WB_EN;
    assign MEM_R_EN_out = MEM_R_EN;
    assign MEM_W_EN_out = MEM_W_EN;
    assign Val_Rm_out  = Val_Rm;
    assign Dest_out    = Dest;

endmodule
