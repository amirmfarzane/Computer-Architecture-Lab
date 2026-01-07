module Val2Generator(
    input  wire [31:0] reg_value,
    input  wire [11:0] sh_operand,
    input  wire        is_imm,
    input  wire        s_flag,
    output reg  [31:0] result
);

    wire [4:0] shift_amount   = sh_operand[11:7];
    wire [1:0] shift_code     = sh_operand[6:5];
    wire [7:0] imm_value      = sh_operand[7:0];
    wire [3:0] rotate_amount  = sh_operand[11:8];

    integer idx;

    always @(*) begin
        result = 32'b0;

        if (s_flag) begin
            result = {{20{sh_operand[11]}}, sh_operand};
        end
        else if (is_imm) begin
            result = {24'b0, imm_value};
            for (idx = 0; idx < (rotate_amount * 2); idx = idx + 1) begin
                result = {result[0], result[31:1]};
            end
        end
        else begin
            case (shift_code)
                2'b00: result = reg_value << shift_amount;
                2'b01: result = reg_value >> shift_amount;
                2'b10: result = $signed(reg_value) >>> shift_amount;
                2'b11: begin
                    result = reg_value;
                    for (idx = 0; idx < shift_amount; idx = idx + 1) begin
                        result = {result[0], result[31:1]};
                    end
                end
            endcase
        end
    end

endmodule
