`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/08 15:48:53
// Design Name: 
// Module Name: test_clk_div
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


module test_clk_div();

    reg clk = 1'b0;
    wire clk506, clk165, clk152, clk761;
    
    clk_div dut (clk, clk506, clk165, clk152, clk761);
    
    always #2 clk = ~clk;
    
endmodule
