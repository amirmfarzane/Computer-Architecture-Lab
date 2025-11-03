module MEM_STAGE (
    input  wire        clk,
    input  wire        rst,
    input  wire        MEM_R_EN,      
    input  wire        MEM_W_EN,      
    input  wire        WB_EN,        
    input  wire [31:0] ALU_Res,       
    input  wire [31:0] Val_Rm,        
    input  wire [3:0]  Dest,          
    
    output reg  [31:0] MEM_Result,    
    output wire [31:0] ALU_Res_out,   
    output wire [3:0]  Dest_out,      
    output wire        WB_EN_out,     
    output wire        MEM_R_EN_out   
);

    reg [31:0] data_memory [0:2047];  

    always @(*) begin
        if (MEM_R_EN)
            MEM_Result = data_memory[ALU_Res[12:2]];  // word-addressed memory
        else
            MEM_Result = 32'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 2048; i = i + 1)
                data_memory[i] <= 32'b0;
        end else if (MEM_W_EN) begin
            data_memory[ALU_Res[12:2]] <= Val_Rm;
        end
    end

    assign ALU_Res_out   = ALU_Res;
    assign Dest_out      = Dest;
    assign WB_EN_out     = WB_EN;
    assign MEM_R_EN_out  = MEM_R_EN;

endmodule
