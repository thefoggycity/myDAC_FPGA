`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/12 21:28:54
// Design Name: 
// Module Name: freq_decimal
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


module freq_decimal(
    input [7:0] FREQ,
    output [11:0] FREQ_DEC
    );
    
    wire [6:0] SIG_DIG; // Significant digit in decimal (*10)
    wire [5:0] REM;     // Remainder, should only have bit [3:0]
    
    // Fraction (2-bit): .0, .3(.25), .5, .8(.75)
    assign FREQ_DEC[3:0] = (FREQ[1:0] == 2'o0) ? 4'd0 :
                           (FREQ[1:0] == 2'o1) ? 4'd3 :
                           (FREQ[1:0] == 2'o2) ? 4'd5 : 4'd8;
    
    // Integer (6-bit): q = floor(f * 52 / 2^9), r = f - 10 * q
    // Note: should be f * 51 / 512, however error by truncation
    assign FREQ_DEC[11] = 1'b0;
    assign REM = FREQ[7:2] - SIG_DIG[5:0];
    assign FREQ_DEC[7:4] = REM[3:0];
    
    mod_ten_mult mtenm (
        .A(FREQ[7:2]),
        .P(FREQ_DEC[10:8])
        );
    
    ten_mult tenm (
        .A(FREQ_DEC[10:8]),
        .P(SIG_DIG)
        );
        
endmodule
