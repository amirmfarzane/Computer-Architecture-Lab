module IF_PIPE (
    input clk, rst, 
    input freeze, flush,
    input [31:0] instruction_in,
    input [31:0] pc_in, 
    output reg [31:0] instruction, pc
);
always @(posedge clk or posedge rst) begin
        if(rst || flush) begin
            instruction <= 32'b0;
            pc <= 32'b0;
        end
        else begin
            if(freeze==1'b0) begin
                pc <= pc_in;
                instruction <= instruction_in;
            end
        end
    end

endmodule
