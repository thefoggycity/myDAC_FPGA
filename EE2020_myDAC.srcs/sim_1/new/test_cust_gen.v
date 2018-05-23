`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/16 01:19:18
// Design Name: 
// Module Name: test_cust_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_cust_gen();

    reg clk = 1'b0;
    reg [11:0] phase = 12'b0;
    reg sign = 1'b0;
    reg cont = 1'b1;
    reg [9:0] sw = 10'b01011_10010;
    
    wire [11:0] wave;
    
    always #5 clk <= ~clk;
    always #1 phase <= phase + 1;
    always @ (phase) sign <= phase ? sign : ~sign;
    
    initial begin
        #14300 cont = 1'b0;
        #50000;
//        $finish;
    end
    
    cust_gen dut (
        .CLK_UPD(clk),
        .SIGN(sign),
        .PHASE(phase),
        .CONT(cont),
        .SW(sw),
        .WAVE(wave)
        );
    
endmodule
