`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 12:26:41
// Design Name: 
// Module Name: tri_gen
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


module tri_gen(
    input CLK_UPD,
    input SIGN,
    input [11:0] PHASE,
    input POLARITY,
    output reg [11:0] WAVE = 12'b0
    );
    
    always @ (negedge CLK_UPD)
        WAVE <= (POLARITY ^ SIGN) ? ~PHASE : PHASE;
    
endmodule
