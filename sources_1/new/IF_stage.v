module IF_STAGE (
    input clk, rst, freeze, branch_taken,
    input [31:0] branch_addr,
    output [31:0] pc_out, pc_adder_out,
    output [31:0] instruction
);
    
    
    dist_mem_gen_0 rom(.a(pc_out[10:0]), .spo(instruction));
    
    wire [31:0] mux_out;
    wire c_out;
    reg c_in = 1'b0;

    mux_2to1 mux_2to1 (
        .sel(branch_taken),
        .a(pc_adder_out),
        .b(branch_addr),
        .out(mux_out)
    );

    PC pc (
        .clk(clk),
        .rst(rst),
        .freeze(freeze),
        .pc_in(mux_out),
        .pc_out(pc_out)
    );

    adder_32bit adder (
        .a(pc_out),
        .b(32'd1),
        .sum(pc_adder_out),
        .cin(c_in),
        .cout(c_out)
    );

endmodule


