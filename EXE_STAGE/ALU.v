module ALU (
    input  wire [31:0] Val1,        
    input  wire [31:0] Val2,        
    input  wire [3:0]  EXE_CMD,     
    input  wire [3:0]  Status,      
    output reg  [31:0] ALU_Res     
);
    always @(*) begin
        case (EXE_CMD)
            4'b0000: ALU_Res = Val1 & Val2;     // AND
            4'b0001: ALU_Res = Val1 | Val2;     // OR
            4'b0010: ALU_Res = Val1 + Val2;     // ADD
            4'b0011: ALU_Res = Val1 - Val2;     // SUB
            4'b0100: ALU_Res = Val1 ^ Val2;     // XOR
            4'b0101: ALU_Res = Val2;            // MOV / pass through
            4'b0110: ALU_Res = (Val1 < Val2);   // CMP
            default: ALU_Res = 32'b0;
        endcase
    end
endmodule
