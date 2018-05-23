`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/24 16:25:29
// Design Name: 
// Module Name: vga_zoom_ctrl
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


module vga_zoom_ctrl(
    input [9:0] MOUSE_X,
    input [8:0] MOUSE_Y,
    input MOUSE_LB,
    output reg [15:0] ZOOM_CNT = 16'd4092,  // Initial zooming
    output reg PAUSE = 1'b0
    );
    
    // THESE COORDINATIES MUST BE IDENTICAL AS IN vga_layer_info
    // Coordinate of buttons bitmap: 20,440
    parameter [9:0] BTN_POS_X = 10'd20;
    parameter [8:0] BTN_POS_Y = 9'd440;
    parameter [4:0] BTN_WIDTH = 5'd10;
    parameter [4:0] BTN_HEIGHT = 5'd16;
    
    parameter [15:0] DELTA = 16'd100;
    
    always @ (posedge MOUSE_LB) begin
        if ((MOUSE_X >= BTN_POS_X) && (MOUSE_X < (BTN_POS_X + BTN_WIDTH)) &&    // z in
            (MOUSE_Y >= BTN_POS_Y) && (MOUSE_Y < (BTN_POS_Y + BTN_HEIGHT)))
            ZOOM_CNT <= ((ZOOM_CNT - DELTA) < ZOOM_CNT) ? 
                        ZOOM_CNT - DELTA : ZOOM_CNT;
        else if ((MOUSE_X >= (BTN_POS_X + BTN_WIDTH)) && 
                 (MOUSE_X < (BTN_POS_X + BTN_WIDTH * 2)) &&                     // z out
                 (MOUSE_Y >= BTN_POS_Y) && (MOUSE_Y < (BTN_POS_Y + BTN_HEIGHT)))
            ZOOM_CNT <= ((ZOOM_CNT + DELTA) > ZOOM_CNT) ? 
                        ZOOM_CNT + DELTA : ZOOM_CNT;
        else if ((MOUSE_X >= (BTN_POS_X + BTN_WIDTH * 2)) && 
                 (MOUSE_X < (BTN_POS_X + BTN_WIDTH * 3)) &&                     // pause
                 (MOUSE_Y >= BTN_POS_Y) && (MOUSE_Y < (BTN_POS_Y + BTN_HEIGHT)))
            PAUSE <= ~PAUSE;
        else
            ZOOM_CNT <= ZOOM_CNT;
    end
    
endmodule
