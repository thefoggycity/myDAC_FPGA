`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 12:30:21
// Design Name: 
// Module Name: wave_amp
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


module wave_amp(
    input [11:0] AMPL_U,
    input [11:0] AMPL_D,
    input [11:0] WAVE,
    output [11:0] DATA
    );
    
    // AMPL_U, AMPL_D, WAVE are in ufix12_12
    
    wire [11:0] RANGE;
    wire [11:0] SCALED_WV;
    
    // AMPL_U must be larger than AMPL_D, otherwise error occurs
    assign RANGE = AMPL_U - AMPL_D;
    assign DATA = AMPL_D + SCALED_WV;
    
    scale_mult sm (
        .A(WAVE),
        .B(RANGE),
        .P(SCALED_WV)
        );
    
endmodule
