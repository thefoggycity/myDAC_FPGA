`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/15 15:57:41
// Design Name: 
// Module Name: test_sws_dbnc
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


module test_sws_dbnc();

    reg clk = 1'b0;
    reg [15:0] sw = 16'b0;
    wire [15:0] sw_d;
    
    sws_dbnc dut (clk, sw, sw_d);
    
    always #2 clk <= ~clk;
    
    initial begin
        #5 sw <= 16'h0800;
        #17 sw <= 16'h0000;
        #23 sw <= 16'ha000;
    end
    
endmodule
