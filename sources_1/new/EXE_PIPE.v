module EXE_PIPE (
    input clk, rst,
    input [31:0] alu_res_in,
    input [31:0] val_rm_in,
    input [3:0] dest_in,
    input mem_w_en_in, mem_r_en_in, wb_en_in,

    output reg [31:0] alu_res_out,val_rm_out,
    output reg [3:0] dest_out,
    output reg wb_en_out, 
    output reg mem_w_en_out,
    output reg mem_r_en_out
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            mem_r_en_out <= 0;
            wb_en_out <= 0;
            alu_res_out <= 0;
            val_rm_out <= 0;
            dest_out <= 0;
            mem_w_en_out <= 0;
        end begin
            val_rm_out <= val_rm_in;
            dest_out <= dest_in;
            mem_w_en_out <= mem_w_en_in;
            mem_r_en_out <= mem_r_en_in;
            wb_en_out <= wb_en_in;
            alu_res_out <= alu_res_in;
        end
    end
endmodule
