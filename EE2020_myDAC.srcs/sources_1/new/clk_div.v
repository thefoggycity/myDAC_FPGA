`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/08 15:12:35
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input CLK_IN,
    output reg CLK506 = 1'b0,
    output reg CLK165 = 1'b0,
    output reg CLK152 = 1'b0,
    output reg CLK761 = 1'b0
    );
    
    reg [4:0] CNT165 = 5'b0;
    reg [15:0] CNT152 = 16'b0;
    reg [15:0] CNT761 = 16'b0;
    
    always @ (posedge CLK_IN) begin
    
        CNT165 <= CNT165 + 1;
        CNT152 <= (CNT152 == 16'd33333) ? 16'b0 : CNT152 + 1;
        CNT761 <= CNT761 + 1;
        
        CLK506 <= ~CLK506;
        CLK165 <= CNT165 ? CLK165 : ~CLK165;
        CLK152 <= CNT152 ? CLK152 : ~CLK152;
        CLK761 <= CNT761 ? CLK761 : ~CLK761;
        
    end
    
endmodule
