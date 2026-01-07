`timescale 1ns / 1ps

module ArmFpgaWrapper(
    input clk,
    input key1
);

    wire deb_out, rst;
    debouncer deb_inst (
        .SIGNAL_I(key1),
        .CLK_I(clk),
        .SIGNAL_O(deb_out)
    );

    assign rst = ~deb_out;  // active-high reset

    ARM_Core arm_module (
        .clk(clk),
        .rst(rst)
    );

    ila_0 ila_inst (
        .clk(clk), // input wire clk

        .probe0(rst), // input wire [0:0] probe0 - reset
        .probe1(arm_inst.alu_res_exe)           // PC from IF/ID pipeline reg
//        .probe2(arm_inst.pc_id_exe),          // PC from ID/EXE pipeline reg
//        .probe3(arm_inst.pc_if),              // PC at IF stage (current instruction address)
//        .probe4(arm_inst.branch_address),     // Branch target (Exec output)
//        .probe5(arm_inst.pc_if_adder),        // PC+4
//        .probe6(arm_inst.instruction_if_id)   // instruction at IF/ID
    );

endmodule
