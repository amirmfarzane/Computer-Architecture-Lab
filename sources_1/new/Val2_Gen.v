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
            // Register shift
            
            Val2 = 32'b0;
        end
    end

endmodule
