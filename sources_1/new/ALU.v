module ALU (
    input  wire [31:0] Val1,
    input  wire [31:0] Val2,
    input  wire [3:0]  EXE_CMD,       
    input  wire [3:0]  Status,       
    output reg  [31:0] ALU_Res,
    output reg  [3:0]  Flags         
);
    wire C_in = Status[1];
    reg  C_out, V_out;

    always @(*) begin
        C_out = 1'b0; V_out = 1'b0; ALU_Res = 32'b0;

        case (EXE_CMD)
            4'b0001: ALU_Res = Val2;                    // MOV
            4'b1001: ALU_Res = ~Val2;                   // MVN
            4'b0010: begin                              // ADD
                {C_out, ALU_Res} = Val1 + Val2;
                V_out = (~(Val1[31]^Val2[31])) & (Val1[31]^ALU_Res[31]);
            end
            4'b0011: begin                              // ADC
                {C_out, ALU_Res} = Val1 + Val2 + C_in;
                V_out = (~(Val1[31]^Val2[31])) & (Val1[31]^ALU_Res[31]);
            end
            4'b0100: begin                              // SUB / CMP
                {C_out, ALU_Res} = Val1 - Val2;
                C_out = ~C_out;                         
                V_out = (Val1[31]^Val2[31]) & (Val1[31]^ALU_Res[31]);
            end
            4'b0101: begin                              // SBC
                {C_out, ALU_Res} = Val1 - Val2;
                C_out = ~C_out;
                V_out = (Val1[31]^Val2[31]) & (Val1[31]^ALU_Res[31]);
            end
            4'b0110: ALU_Res = Val1 & Val2;             // AND / TST
            4'b0111: ALU_Res = Val1 | Val2;             // ORR
            4'b1000: ALU_Res = Val1 ^ Val2;             // EOR
            default: ALU_Res = 32'b0;                  
        endcase

        Flags[3] = ALU_Res[31];             // N
        Flags[2] = (ALU_Res == 32'b0);      // Z
        Flags[1] = C_out;                   // C
        Flags[0] = V_out;                   // V
    end
endmodule
