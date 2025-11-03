module Val2_Gen (
    input  wire [31:0] Val_Rm,         
    input  wire [31:0] Imm,             
    input  wire [11:0] Shift_operand,   
    input  wire        Val2_Src,        
    output reg  [31:0] Val2
);
    wire [1:0] shift_type   = Shift_operand[6:5];   // 00 LSL, 01 LSR, 10 ASR, 11 ROR
    wire [4:0] shift_amount = Shift_operand[11:7];
    wire [7:0] imm8         = Shift_operand[7:0];
    wire [3:0] rotate_imm   = Shift_operand[11:8];

    function [31:0] ROR32(input [31:0] x, input [4:0] s);
        begin
            ROR32 = (x >> s) | (x << (32 - s));
        end
    endfunction

    always @(*) begin
        if (Val2_Src) begin
            Val2 = {20'b0, Shift_operand};
        end else begin
            if (rotate_imm != 4'b0000) begin
                Val2 = ROR32({24'b0, imm8}, {1'b0, rotate_imm} << 1); // rotate_imm*2
            end
            else if (Imm !== 32'bx) begin
                Val2 = Imm;
            end
            else begin
                case (shift_type)
                    2'b00: Val2 = Val_Rm <<  shift_amount;            // LSL
                    2'b01: Val2 = Val_Rm >>  shift_amount;            // LSR
                    2'b10: Val2 = $signed(Val_Rm) >>> shift_amount;   // ASR
                    2'b11: Val2 = ROR32(Val_Rm, shift_amount);        // ROR
                    default: Val2 = Val_Rm;
                endcase
            end
        end
    end
endmodule
