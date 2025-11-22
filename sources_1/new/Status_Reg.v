module Status_Reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        S,          
    input  wire [3:0]  Flags_in,   
    output reg  [3:0]  Status_out  
);
    always @(posedge clk or posedge rst) begin
        if (rst)       Status_out <= 4'b0000;
        else if (S)    Status_out <= Flags_in;
        else           Status_out <= Status_out;
    end
endmodule
