module WB_STAGE (
    input  wire [31:0] ALU_Result,   
    input  wire [31:0] MEM_Result,   
    input  wire        MEM_R_EN,     
    output wire [31:0] WB_Value      
);
    assign WB_Value = (MEM_R_EN) ? MEM_Result : ALU_Result;
endmodule
