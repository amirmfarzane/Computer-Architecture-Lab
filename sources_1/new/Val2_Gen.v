module Val2_Gen (
    input  [31:0] Val_Rm,
    input  [11:0] Shift_operand,
    input  Imm,
    input  Val2_Src,
    output reg [31:0] Val2
);

    wire [7:0] imm_val     = Shift_operand[7:0];
    wire [3:0] rotate_imm  = Shift_operand[11:8];

    always @(*) begin
        if (Val2_Src == 1'b1) begin
            // Memory access
            Val2 = {{24'b0, imm_val}, {24'b0, imm_val}} >> (rotate_imm * 2);

        end else if (Imm == 1'b1) begin
            // Immediate rotate (ARM encoding)
            Val2 = {{24'b0, imm_val}, {24'b0, imm_val}} >> (rotate_imm * 2);

         end else begin
            case(imm_val[6:5])
               2'b00:
                  Val2 = Val_Rm << (Shift_operand[11:7]);
               2'b01:
                  Val2 = Val_Rm >> (Shift_operand[11:7]);
               2'b10:
                  Val2 = Val_Rm >>> (Shift_operand[11:7]);
               2'b11:
                Val2 = {{24'b0, Val_Rm},{24'b0, Val_Rm}} >> (Shift_operand[11:7]);
            endcase
        end
    end

endmodule
