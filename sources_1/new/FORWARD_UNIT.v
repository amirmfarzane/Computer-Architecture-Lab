module FORWARD_UNIT (
    input  [3:0] src1_id_exe,
    input  [3:0] src2_id_exe,
    input  [3:0] dest_mem,
    input  [3:0] wb_dest,
    input mem_en_mem,
    input wb_wb_en,
    output reg [1:0] sel_src1,
    output reg [1:0] sel_src2
);

    always @(*) begin
        sel_src1 = 2'b00;
        sel_src2 = 2'b00;

        if (dest_mem == src1_id_exe && mem_en_mem) begin
            sel_src1 = 2'd1;
        end else if (wb_dest == src1_id_exe && wb_wb_en) begin
            sel_src1 = 2'd2;
        end

        if (dest_mem == src2_id_exe && mem_en_mem) begin
            sel_src2 = 2'd1;
        end else if (wb_dest == src2_id_exe && wb_wb_en) begin
            sel_src2 = 2'd2;
        end
    end

endmodule
