`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/11 00:55:14
// Design Name: 
// Module Name: test_wave_amp
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


module test_wave_amp();

    reg [11:0] tri_wv = 12'b0;
    reg sign = 1'b0;
    
    reg [11:0] ampl_u = 12'hc00;
    reg [11:0] ampl_d = 12'h200;
    
    wire [11:0] data;
    
    always #2 tri_wv <= sign ? tri_wv - 12'h010 : tri_wv + 12'h010;
    always @ (tri_wv) sign = (tri_wv == 12'hfff) ? 1'b1 :
                             (tri_wv == 12'h000) ? 1'b0 : sign;
    
    wave_amp dut (
        .AMPL_U(ampl_u),
        .AMPL_D(ampl_d),
        .WAVE(tri_wv),
        .DATA(data)
        );
    
endmodule
