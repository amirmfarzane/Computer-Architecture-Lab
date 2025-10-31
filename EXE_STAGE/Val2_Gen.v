module Val2_Gen (
    input  wire [31:0] Val_Rm,          
    input  wire [31:0] Imm,             
    input  wire [11:0] Shift_operand,   
    input  wire        Val2_Src,        
    output reg  [31:0] Val2             
);
    reg [1:0] shift_type;
    reg [4:0] shift_amount;

    always @(*) begin
        shift_type   = Shift_operand[6:5];
        shift_amount = Shift_operand[11:7];

        if (Val2_Src) begin
            Val2 = Imm;
        end else begin
            case (shift_type)
                2'b00: Val2 = Val_Rm << shift_amount;   // LSL
                2'b01: Val2 = Val_Rm >> shift_amount;   // LSR
                2'b10: Val2 = $signed(Val_Rm) >>> shift_amount; // ASR
                default: Val2 = Val_Rm;                
            endcase
        end
    end
endmodule
