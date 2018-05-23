`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/23 20:56:45
// Design Name: 
// Module Name: vga_layer_cursor
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


module vga_layer_cursor(
    input EN_H,
    input EN_V,
    input [9:0] PIX_H,
    input [8:0] PIX_V,
    input [9:0] MOUSE_X,
    input [8:0] MOUSE_Y,
    output reg [11:0] LAYER_CUR = 12'b0
    );
    
    parameter [24:0] CUR_BITMAP = 
        { 5'b_00100_,
          5'b_00100_,
          5'b_11111_,
          5'b_00100_,
          5'b_00100_ };
    
    reg signed [10:0] DIFF_X = 0;
    reg signed [9:0] DIFF_Y = 0;
    reg [4:0] PIX_INDEX = 0;
    
    always @ (*) begin
        DIFF_X = PIX_H - MOUSE_X;
        DIFF_Y = PIX_V - MOUSE_Y;
        if (((DIFF_X > -3) && (DIFF_X < 3)) &&
            ((DIFF_Y > -3) && (DIFF_Y < 3)) && EN_H && EN_V) begin
            PIX_INDEX = (DIFF_X + 2) + (DIFF_Y + 2) * 5;
            LAYER_CUR = {12{CUR_BITMAP[PIX_INDEX]}};
        end
        else
            LAYER_CUR = 12'b0;
    end
    
endmodule
