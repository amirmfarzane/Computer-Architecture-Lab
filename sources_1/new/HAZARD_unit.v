module HAZARD_UNIT (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  src1_id_exe,
    input  wire [3:0]  src2_id_exe,
    input  wire [3:0]  exe_dest,
    input  wire [3:0]  mem_dest,
    input  wire        exe_wb_en,
    input  wire        mem_wb_en,
    input  wire        exe_mem_r_en,
    input  wire        forward_en,
    input  wire        two_src,
    output reg         hazard
);

    always @(*) begin
        hazard = 1'b0;

        if (forward_en) begin
            if ((src1_id_exe == exe_dest && exe_wb_en && exe_mem_r_en) ||
                (src2_id_exe == exe_dest && exe_wb_en && exe_mem_r_en)) begin
                hazard = 1'b1;
            end
        end else begin
            if ((src1_id_exe == exe_dest && exe_wb_en) ||
                (src1_id_exe == mem_dest && mem_wb_en) ||
                (two_src && src2_id_exe == exe_dest && exe_wb_en) ||
                (two_src && src2_id_exe == mem_dest && mem_wb_en)) begin
                hazard = 1'b1;
            end
        end
    end

endmodule
