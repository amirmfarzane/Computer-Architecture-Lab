module ControlUnit(
    input  wire [1:0] mode_in,
    input  wire [3:0] opcode_in,
    input  wire s_in,
    output wire branch_out,
    output wire s_out,
    output reg  wb_enable,
    output reg  mem_read,
    output reg  mem_write,
    output reg [3:0]  exe_command
);

    assign s_out      = (mode_in == 2'b00) ? s_in : 1'b0;
    assign branch_out = (mode_in == 2'b10) ? 1'b1 : 1'b0;

    always @(*) begin
        exe_command = 4'b0000;
        wb_enable   = 1'b1;
        mem_read    = 1'b0;
        mem_write   = 1'b0;

        if (mode_in == 2'b00) begin
            case (opcode_in)
                4'b1101: exe_command = 4'b0001; // MOV
                4'b1111: exe_command = 4'b1001; // MVN
                4'b0100: exe_command = 4'b0010; // ADD
                4'b0101: exe_command = 4'b0011; // ADC
                4'b0010: exe_command = 4'b0100; // SUB
                4'b0110: exe_command = 4'b0101; // SBC
                4'b0000: exe_command = 4'b0110; // AND
                4'b1100: exe_command = 4'b0111; // ORR
                4'b0001: exe_command = 4'b1000; // EOR
                4'b1010: begin
                    exe_command = 4'b0100; // CMP
                    wb_enable = 1'b0;
                end
                4'b1000: begin
                    exe_command = 4'b0110; // TST
                    wb_enable = 1'b0;
                end
                default: wb_enable = 1'b0;
            endcase
        end
        else if (mode_in == 2'b01 && opcode_in == 4'b0100) begin
            exe_command = 4'b0010;
            if (s_in == 1'b0) begin
                mem_write = 1'b1;
                wb_enable = 1'b0;
            end
            else if (s_in == 1'b1) begin
                mem_read = 1'b1;
            end
        end
    end

endmodule
