


module RegisterFile(
    input clk,
    input rst,
    input [3:0] src_1,
    input [3:0] src_2,
    input [3:0] Dest_WB,
    input [31:0] Result_WB,
    input writeBackEN,
    output [31:0] reg_out_1,
    output [31:0] reg_out_2
);

    reg [31:0] registers [15:0];
    integer i;

    assign reg_out_1 = registers[src_1];
    assign reg_out_2 = registers[src_2];

    always @(negedge clk or negedge rst) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if (writeBackEN) begin
            registers[Dest_WB] <= Result_WB;
        end
    end

endmodule
