`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/15 14:41:49
// Design Name: 
// Module Name: sws_dbnc
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


module sws_dbnc(
    input CLK,
    input [15:0] SW,
    output reg [15:0] SW_LVL = 16'h0000
    );
    
    reg [15:0] SW_LAST = 16'h0000;
    
    always @ (negedge CLK)
        SW_LAST <= SW;
    
    always @ (posedge CLK)
        SW_LVL <= (SW_LAST == SW) ? SW_LAST : SW_LVL;
    
endmodule
