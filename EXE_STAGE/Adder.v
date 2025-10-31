module Adder (
    input  wire [31:0] PC,
    input  wire [31:0] Signed_EX_Imm24,
    output wire [31:0] Branch_Address
);
    assign Branch_Address = PC + (Signed_EX_Imm24 << 2);
endmodule
