`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2017 03:06:35 PM
// Design Name: 
// Module Name: vga_driver
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



module vga_driver(
    input CLK,
    // Use main clock @ 100 MHz
    input [11:0] LAYER_CUR,
    input [11:0] LAYER_WAV_A,
    input [11:0] LAYER_WAV_B,
    input [11:0] LAYER_INF,
    output [11:0] VGA_DISP,
    // Signal in RRRRGGGGBBBB
    output [9:0] PIX_H,
    output [8:0] PIX_V,
    // Pixel coordinate (640x480 screen)
    output EN_H,
    output EN_V,
    // Pixel displaying indicator
    output CLK_VGA,
    // 4-div clock, sync'd with vga signal
    output SYN_H,
    output SYN_V
    );
    
    parameter [11:0] BG_COLOR = 12'h131;
    
    reg [1:0] CNT_DIV = 2'b0;
    // 4-div clock divider. Driving clk @ 25 MHz
    
    reg [9:0] CNT_H;
    reg [9:0] CNT_V;
        
    // VGA Timing parameters table (refreshing @ 60 Hz)
    parameter PULSE_END_H   = 10'd95;
    parameter SIG_START_H  = 10'd111;
    parameter SIG_END_H  = 10'd752;
    parameter LINE_END_H  = 10'd799;
    parameter PULSE_END_V  = 10'd1;
    parameter SIG_START_V  = 10'd11;
    parameter SIG_END_V  = 10'd491;
    parameter FIELD_END_V  = 10'd520;
    
    // Clocking
    always @ (posedge CLK) CNT_DIV <= CNT_DIV + 1;
    assign CLK_VGA = CNT_DIV[1];
    
    // VGA timing driving    
    always @(posedge CLK_VGA) begin
        if (CNT_H == LINE_END_H) begin
            CNT_H <= 10'b0;
            if (CNT_V == FIELD_END_V)
            CNT_V <= 10'b0;
            else
            CNT_V <= CNT_V + 1;
        end
        else
            CNT_H <= CNT_H + 10'd1;
    end
    
    // Outputting syn signals
    assign SYN_H = CNT_H > PULSE_END_H;
    assign SYN_V = CNT_V > PULSE_END_V;
    
    // Examine whether the signal is on screen and output pixel coordinate
    assign EN_H = (CNT_H >= SIG_START_H) && (CNT_H < SIG_END_H);
    assign EN_V = (CNT_V >= SIG_START_V) && (CNT_V < SIG_END_V);
    assign PIX_H = (EN_H) ? (CNT_H - SIG_START_H) : 10'b0;
    assign PIX_V = (EN_V) ? (CNT_V - SIG_START_V) : 9'b0;
    
    // Mixing layers: (top -> bottom) cursor, wave_a, wave_b, infomation
    assign VGA_DISP = (~EN_H | ~EN_V) ? 12'b0 :
                      (LAYER_CUR != 12'b0) ? LAYER_CUR :
                      (LAYER_WAV_A != 12'b0) ? LAYER_WAV_A :
                      (LAYER_WAV_B != 12'b0) ? LAYER_WAV_B : 
                      (LAYER_INF != 12'b0) ? LAYER_INF: BG_COLOR;

endmodule
