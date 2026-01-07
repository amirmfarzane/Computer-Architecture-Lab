`timescale 1ns / 1ps

module TB();
    reg rst;
    reg clk;
    // ---------- OUR ARM INSTANCE ----------
    ARM_Core OUR_ARM (
        .clk(clk),
        .rst(rst)
    );
    
    initial begin
        #100 clk = 0;
        
        #100 rst = 0;
        
        #100 rst = 1;
        #100 rst = 0;
        #5000 $stop;
    end

    always #7 clk = ~clk;

endmodule