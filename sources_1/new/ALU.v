module ALU(
    input  wire [31:0] a_in,
    input  wire [31:0] b_in,
    input  wire [3:0] op_code,
    input  wire carry_in,
    output reg  [31:0] result,
    output wire [3:0]  status
);

    reg  carry_out;
    reg  overflow;
    wire zero;
    wire negative;

    wire [32:0] a_ext = {1'b0, a_in};
    wire [32:0] b_ext = {1'b0, b_in};
    wire [32:0] carry_ext = {32'b0, carry_in};
    wire [32:0] not_carry_ext = {32'b0, ~carry_in};

    reg [32:0] temp;

    always @(*) begin
        carry_out = 0;
        overflow  = 0;

        case(op_code)
            4'b0010: begin
                temp    = a_ext + b_ext;
                result  = temp[31:0];
                carry_out = temp[32];
                overflow  = (a_in[31] == b_in[31]) && (result[31] != a_in[31]);
            end

            4'b0011: begin
                temp    = a_ext + b_ext + carry_ext;
                result  = temp[31:0];
                carry_out = temp[32];
                overflow  = (a_in[31] == b_in[31]) && (result[31] != a_in[31]);
            end

            4'b0100: begin
                temp    = a_ext - b_ext;
                result  = temp[31:0];
                carry_out = ~temp[32];
                overflow  = (a_in[31] != b_in[31]) && (result[31] != a_in[31]);
            end

            4'b0101: begin
                temp    = a_ext - b_ext - not_carry_ext;
                result  = temp[31:0];
                carry_out = ~temp[32];
                overflow  = (a_in[31] != b_in[31]) && (result[31] != a_in[31]);
            end

            4'b0110: begin
                result    = a_in & b_in;
                carry_out = 0;
                overflow  = 0;
            end

            4'b0111: begin
                result    = a_in | b_in;
                carry_out = 0;
                overflow  = 0;
            end

            4'b1000: begin
                result    = a_in ^ b_in;
                carry_out = 0;
                overflow  = 0;
            end

            4'b0001: begin
                result    = b_in;
                carry_out = 0;
                overflow  = 0;
            end

            4'b1001: begin
                result    = ~b_in;
                carry_out = 0;
                overflow  = 0;
            end

            default: begin
                result    = 32'd0;
                carry_out = 0;
                overflow  = 0;
            end
        endcase
    end

    assign zero     = (result == 32'd0);
    assign negative = result[31];
    assign status   = {zero, carry_out, overflow, negative};

endmodule
