`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2017 03:31:57 PM
// Design Name: 
// Module Name: vga_layer_info
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


module vga_layer_info(
    input EN_H,
    input EN_V,
    input [9:0] PIX_H,
    input [8:0] PIX_V,
    input [2:0] MODE_A,
    input [2:0] MODE_B,
    input [8:0] MOUSE_Y,
    output reg [11:0] LAYER_INF = 12'b0
    );
    
    // 30x15 Bitmaps of the waveform indicators
    parameter [449:0] SQR_BITMAP = {
        30'b_0011111110_0011111100_1111111100_, // 0  
        30'b_0111001110_0111001110_0111001110_, // 1  
        30'b_1110000110_0111001110_0111000110_, // 2  
        30'b_1110000110_1110000110_0111000111_, // 3  
        30'b_0111000000_1110000110_0111000110_, // 4  
        30'b_0111110000_1110000110_0111001110_, // 5  
        30'b_0001111100_1110000110_0111111100_, // 6  
        30'b_0000011110_1110000110_0111111000_, // 7  
        30'b_0000000110_1110000110_0111011100_, // 8  
        30'b_1100000110_1111110110_0111011100_, // 9  
        30'b_1110000110_0111111110_0111001110_, // 10 
        30'b_1111001110_0111011110_0111001110_, // 11 
        30'b_0111111100_0011111100_1111100111_, // 12 
        30'b_0000000000_0000011110_0000000000_, // 13
        30'b_0000000000_0000001111_0000000000_};// 14
        
    parameter [449:0] SAW_BITMAP = {
        30'b_0011111110_0001110000_1110110111_, // 0  
        30'b_0111001110_0001111000_1110110011_, // 1  
        30'b_1110000110_0001111000_1110110111_, // 2  
        30'b_1110000110_0001111000_0110110110_, // 3  
        30'b_0111000000_0011011000_0110111110_, // 4  
        30'b_0111110000_0011011100_0110111110_, // 5  
        30'b_0001111100_0011011100_0111111110_, // 6  
        30'b_0000011110_0011111100_0111111110_, // 7  
        30'b_0000000110_0110001100_0111111100_, // 8  
        30'b_1100000110_0110001110_0011111100_, // 9  
        30'b_1110000110_0110001110_0011111100_, // 10 
        30'b_1111001110_1110000110_0011011100_, // 11 
        30'b_0111111100_1111001111_0011001100_, // 12 
        30'b0, 30'b0};
        
    parameter [449:0] TRI_BITMAP = {
        30'b_0111111110_1111111100_0111111110_, // 0
        30'b_1110110111_0111001110_0000110000_, // 1
        30'b_1100110011_0111000110_0000110000_, // 2
        30'b_0000110000_0111000111_0000110000_, // 3
        30'b_0000110000_0111000110_0000110000_, // 4
        30'b_0000110000_0111001110_0000110000_, // 5
        30'b_0000110000_0111111100_0000110000_, // 6
        30'b_0000110000_0111111000_0000110000_, // 7
        30'b_0000110000_0111011100_0000110000_, // 8
        30'b_0000110000_0111011100_0000110000_, // 9
        30'b_0000110000_0111001110_0000110000_, // 10
        30'b_0000110000_0111001110_0000110000_, // 11
        30'b_0011111100_1111100111_0111111110_, // 12
        30'b0, 30'b0};
        
    parameter [449:0] SIN_BITMAP = {
        30'b_0011111110_0111111110_1111001111_, // 0  
        30'b_0111001110_0000110000_0111000110_, // 1  
        30'b_1110000110_0000110000_0111100110_, // 2  
        30'b_1110000110_0000110000_0111100110_, // 3  
        30'b_0111000000_0000110000_0111110110_, // 4  
        30'b_0111110000_0000110000_0111110110_, // 5  
        30'b_0001111100_0000110000_0110111110_, // 6  
        30'b_0000011110_0000110000_0110111110_, // 7  
        30'b_0000000110_0000110000_0110011110_, // 8  
        30'b_1100000110_0000110000_0110011110_, // 9  
        30'b_1110000110_0000110000_0110001110_, // 10 
        30'b_1111001110_0000110000_0110001110_, // 11 
        30'b_0111111100_0111111110_1111000111_, // 12 
        30'b0, 30'b0};
    
    // Coordinate of top-left corner of indicator bitmap: 590,20
    parameter [9:0] MAP_A_POS_X = 10'd590;
    parameter [8:0] MAP_A_POS_Y = 9'd20;
    parameter [9:0] MAP_B_POS_X = 10'd590;
    parameter [8:0] MAP_B_POS_Y = 9'd40;
    // Color of the indicator bitmap (RGB)
    parameter [11:0] MAP_A_COLOR = 12'hff4;
    parameter [11:0] MAP_B_COLOR = 12'h4ff;
    
    // 20x16 Bitmaps of zooming buttons
    parameter [479:0] ZOOM_BUTTON_MAP = {
        30'b_1111111111_1111111111_1111111111_, // 0  
        30'b_1000000001_1000000001_1000000001_, // 1  
        30'b_1000110001_1000000001_1000000001_, // 2  
        30'b_1000110001_1000000001_1011001101_, // 3  
        30'b_1000110001_1000000001_1011001101_, // 4  
        30'b_1000110001_1000000001_1011001101_, // 5  
        30'b_1000110001_1000000001_1011001101_, // 6  
        30'b_1111111111_1111111111_1011001101_, // 7  
        30'b_1111111111_1111111111_1011001101_, // 8  
        30'b_1000110001_1000000001_1011001101_, // 9  
        30'b_1000110001_1000000001_1011001101_, // 10 
        30'b_1000110001_1000000001_1011001101_, // 11 
        30'b_1000110001_1000000001_1011001101_, // 12 
        30'b_1000110001_1000000001_1000000001_, // 13
        30'b_1000000001_1000000001_1000000001_, // 14
        30'b_1111111111_1111111111_1111111111_};// 15
    
    // Coordinate of top-left corner of button bitmap: 20,440
    parameter [9:0] BTN_POS_X = 10'd20;
    parameter [8:0] BTN_POS_Y = 9'd440;
    // Color of the button bitmap (RGB)
    parameter [11:0] BTN_COLOR = 12'hf44;
    
    // Mouse on-screen voltage measurement
    parameter [9:0] AMPL_POS_X = 10'd20;
    parameter [8:0] AMPL_POS_Y = 9'd20;
    parameter [11:0] AMPL_COLOR = 12'h48f;
    wire [179:0] AMPL_MAP;  // 20x9
    
    vga_map_ampl ampmap (
        .MOUSE_Y(MOUSE_Y),
        .AMPL_MAP(AMPL_MAP)
        );

    // Indicator selection MUX
    wire [449:0] MODE_MAP_A;
    assign MODE_MAP_A = (MODE_A == 3'o0) ? SQR_BITMAP :
                        (MODE_A == 3'o1) ? SAW_BITMAP :
                        (MODE_A == 3'o2) ? TRI_BITMAP :
                        (MODE_A == 3'o3) ? SIN_BITMAP : 450'b0;
    wire [449:0] MODE_MAP_B;
    assign MODE_MAP_B = (MODE_B == 3'o0) ? SQR_BITMAP :
                        (MODE_B == 3'o1) ? SAW_BITMAP :
                        (MODE_B == 3'o2) ? TRI_BITMAP :
                        (MODE_B == 3'o3) ? SIN_BITMAP : 450'b0;

    
    // Relative coordinates calculation
    reg signed [10:0] DIFF_BTN_X = 0;
    reg signed [9:0] DIFF_BTN_Y = 0;
    
    reg signed [10:0] DIFF_MODE_A_X = 0;
    reg signed [9:0] DIFF_MODE_A_Y = 0;
    reg signed [10:0] DIFF_MODE_B_X = 0;
    reg signed [9:0] DIFF_MODE_B_Y = 0;
    
    reg signed [10:0] DIFF_AMPL_X = 0;
    reg signed [9:0] DIFF_AMPL_Y = 0;
    
    reg [8:0] PIX_INDEX = 0;
    
    always @ (*) begin
    
        DIFF_MODE_A_X = PIX_H - MAP_A_POS_X;
        DIFF_MODE_A_Y = PIX_V - MAP_A_POS_Y;
        
        DIFF_MODE_B_X = PIX_H - MAP_B_POS_X;
        DIFF_MODE_B_Y = PIX_V - MAP_B_POS_Y;
        
        DIFF_BTN_X = PIX_H - BTN_POS_X;
        DIFF_BTN_Y = PIX_V - BTN_POS_Y;
        
        DIFF_AMPL_X = PIX_H - AMPL_POS_X;
        DIFF_AMPL_Y = PIX_V - AMPL_POS_Y;
        
        if (~EN_H | ~EN_V)                                  // Not on screen
            LAYER_INF = 12'b0;
        else if ((PIX_H == 10'd320) || (PIX_V == 9'd240))   // Axises
            LAYER_INF = 12'hdda;
        else if ((DIFF_MODE_A_X >= 0) && (DIFF_MODE_A_X < 30) &&    // Mode Indicator A
                 (DIFF_MODE_A_Y >= 0) && (DIFF_MODE_A_Y < 15)) begin
            PIX_INDEX = 9'd449 - (DIFF_MODE_A_X + DIFF_MODE_A_Y * 30);
            LAYER_INF = MODE_MAP_A[PIX_INDEX] ? MAP_A_COLOR : 12'b0;
        end
        else if ((DIFF_MODE_B_X >= 0) && (DIFF_MODE_B_X < 30) &&    // Mode Indicator B
                 (DIFF_MODE_B_Y >= 0) && (DIFF_MODE_B_Y < 15)) begin
            PIX_INDEX = 9'd449 - (DIFF_MODE_B_X + DIFF_MODE_B_Y * 30);
            LAYER_INF = MODE_MAP_B[PIX_INDEX] ? MAP_B_COLOR : 12'b0;
        end
        else if ((DIFF_BTN_X >= 0) && (DIFF_BTN_X < 30) &&  // Zooming & Pause Buttons
                 (DIFF_BTN_Y >= 0) && (DIFF_BTN_Y < 16)) begin
            PIX_INDEX = 9'd479 - (DIFF_BTN_X + DIFF_BTN_Y * 30);
            LAYER_INF = ZOOM_BUTTON_MAP[PIX_INDEX] ? BTN_COLOR : 12'b0;
        end
        else if ((DIFF_AMPL_X >= 0) && (DIFF_AMPL_X < 20) &&  // Voltage indicator
                 (DIFF_AMPL_Y >= 0) && (DIFF_AMPL_Y < 9)) begin
            PIX_INDEX = 8'd179 - (DIFF_AMPL_X + DIFF_AMPL_Y * 20);
            LAYER_INF = AMPL_MAP[PIX_INDEX] ? AMPL_COLOR : 12'b0;
        end
        else                                                // Other blank area
            LAYER_INF = 12'b0;
    
    end
    
endmodule
