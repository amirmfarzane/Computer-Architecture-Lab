module Adder (
    input  wire [31:0] PC,
    input  wire [23:0] Signed_EX_Imm24,
    output wire [31:0] Branch_Address
);
    wire [31:0] sign_ext_imm = {{8{Signed_EX_Imm24[23]}}, Signed_EX_Imm24};
    assign Branch_Address = PC + (sign_ext_imm << 2);
endmodule
