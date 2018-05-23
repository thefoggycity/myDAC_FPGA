`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/03 11:57:41
// Design Name: 
// Module Name: seg_disp
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


module seg_disp(
    input CLK,  // Use the debouncer clock
    input [31:0] DISP,  // Display data
    output [6:0] SEG,
    output DP,
    output [3:0] AN
    );
    
    reg [3:0] AN_NBUFF = 4'h1;
    
    assign AN = ~AN_NBUFF;
    
    assign SEG = (AN_NBUFF == 4'h1) ? ~DISP[6:0] :
                 (AN_NBUFF == 4'h2) ? ~DISP[14:8] :
                 (AN_NBUFF == 4'h4) ? ~DISP[22:16] :
                 (AN_NBUFF == 4'h8) ? ~DISP[30:24] : 7'h00;
                 
    assign DP = (AN_NBUFF == 4'h1) ? ~DISP[7] :
                (AN_NBUFF == 4'h2) ? ~DISP[15] :
                (AN_NBUFF == 4'h4) ? ~DISP[23] :
                (AN_NBUFF == 4'h8) ? ~DISP[31] : 1'b0;
    
    always @ (posedge CLK)
        AN_NBUFF = (AN_NBUFF == 4'h8) ? 4'h1 : (AN_NBUFF << 1);
    
endmodule
