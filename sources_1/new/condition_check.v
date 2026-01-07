module ConditionCheck(
    input  wire [3:0] condition,
    input  wire [3:0] status_flags,
    output reg        cond_out
);

    wire z_flag, c_flag, v_flag, n_flag;
    assign {z_flag, c_flag, v_flag, n_flag} = status_flags;


    always @(*) begin
        case (condition)
            4'b0000: cond_out = z_flag;
            4'b0001: cond_out = ~z_flag;
            4'b0010: cond_out = c_flag;
            4'b0011: cond_out = ~c_flag;
            4'b0100: cond_out = n_flag;
            4'b0101: cond_out = ~n_flag;
            4'b0110: cond_out = v_flag;
            4'b0111: cond_out = ~v_flag;
            4'b1000: cond_out = c_flag & ~z_flag;
            4'b1001: cond_out = ~c_flag | z_flag;
            4'b1010: cond_out = (n_flag & v_flag) | (~n_flag & ~v_flag);
            4'b1011: cond_out = (n_flag & ~v_flag) | (~n_flag & v_flag);
            4'b1100: cond_out = ~z_flag & ((n_flag & v_flag) | (~n_flag & ~v_flag));
            4'b1101: cond_out = z_flag | ((n_flag & ~v_flag) | (~n_flag & v_flag));
            default: cond_out = 1'b1;
        endcase
    end

endmodule
