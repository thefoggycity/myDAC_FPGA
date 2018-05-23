`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 12:26:41
// Design Name: 
// Module Name: saw_gen
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


module saw_gen(
    input CLK_UPD,
    input SIGN,
    input [11:0] PHASE,
    input DIRECTION,
    output reg [11:0] WAVE = 12'b0
    );
    
    wire [11:0] PHASE_D2 = PHASE >> 1;
    
    always @ (negedge CLK_UPD)
        WAVE <= DIRECTION ? 12'hfff - {SIGN, PHASE_D2[10:0]} : {SIGN, PHASE_D2[10:0]};
    
endmodule
