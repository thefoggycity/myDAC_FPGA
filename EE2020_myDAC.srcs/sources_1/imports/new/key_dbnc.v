`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/02/28 23:48:31
// Design Name: Key debouncer
// Module Name: key_dbnc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Require 1KHz clock input
// 
//////////////////////////////////////////////////////////////////////////////////


module key_dbnc(
    input CLK,
    input KEY,
    output PULSE
    );
    
    reg R1 = 1'b0, R2 = 1'b0;
    
    assign PULSE = R1 & ~R2;
    
    always @ (posedge CLK) begin
        R1 <= KEY;
        R2 <= R1;
    end
    
endmodule
