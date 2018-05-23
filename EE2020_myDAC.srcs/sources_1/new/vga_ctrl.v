`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/24 17:23:28
// Design Name: 
// Module Name: vga_ctrl
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


module vga_ctrl(
    input CLK,
    input CLK_SMP,
    input [2:0] MODE_A,
    input [11:0] WAVE_DATA_A,
    input [2:0] MODE_B,
    input [11:0] WAVE_DATA_B,
    inout PS2CLK,
    inout PS2DATA,
    output [3:0] VGA_RED,
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE,
    output VGA_HS,
    output VGA_VS
    );
    
    wire [9:0] MOUSE_X;
    wire [8:0] MOUSE_Y;
    wire MOUSE_LB;
    wire MOUSE_RB;
    wire MOUSE_EVENT;   // Currently not used
    wire [15:0] ZOOM_CNT;
    wire PAUSE;
    wire PAUSE_STATE;   // The pause signal from controller
    // MOUSE_RB will serve as a temporary pause key.
    assign PAUSE = PAUSE_STATE | MOUSE_RB;
    
    wire [9:0] PIX_H;
    wire [8:0] PIX_V;
    wire VAILD_H;
    wire VAILD_V;
    wire VGA_CLOCK;     // Currently not used
    
    wire [11:0] LAYER_INF;
    vga_layer_info vgainf (
        .EN_H(VAILD_H),
        .EN_V(VAILD_V),
        .PIX_H(PIX_H),
        .PIX_V(PIX_V),
        .MODE_A(MODE_A),
        .MODE_B(MODE_B),
        .MOUSE_Y(MOUSE_Y),
        .LAYER_INF(LAYER_INF)
        );
    
    wire [11:0] LAYER_WAV_A;
    vga_layer_wave vgawav_a (
        .CLK_SMP(CLK_SMP),
        .EN_H(VAILD_H),
        .EN_V(VAILD_V),
        .PIX_H(PIX_H),
        .PIX_V(PIX_V),
        .WAVE_DATA(WAVE_DATA_A),
        .ZOOM_CNT(ZOOM_CNT),
        .WAV_COLOR(12'hff4),
        .PAUSE(PAUSE),
        .LAYER_WAV(LAYER_WAV_A)
        );
    
    wire [11:0] LAYER_WAV_B;
    vga_layer_wave vgawav_b (
        .CLK_SMP(CLK_SMP),
        .EN_H(VAILD_H),
        .EN_V(VAILD_V),
        .PIX_H(PIX_H),
        .PIX_V(PIX_V),
        .WAVE_DATA(WAVE_DATA_B),
        .ZOOM_CNT(ZOOM_CNT),
        .WAV_COLOR(12'h4ff),
        .PAUSE(PAUSE),
        .LAYER_WAV(LAYER_WAV_B)
        );
        
    wire [11:0] LAYER_CUR;
    vga_layer_cursor vgacur (
        .EN_H(VAILD_H),
        .EN_V(VAILD_V),
        .PIX_H(PIX_H),
        .PIX_V(PIX_V),
        .MOUSE_X(MOUSE_X),
        .MOUSE_Y(MOUSE_Y),
        .LAYER_CUR(LAYER_CUR)
        );
        
    wire [11:0] VGA_DISP_BUS;
    assign VGA_RED = VGA_DISP_BUS[11:8];
    assign VGA_GREEN = VGA_DISP_BUS[7:4];
    assign VGA_BLUE = VGA_DISP_BUS[3:0];
    
    vga_driver vgadrv (
        .CLK(CLK),
        // Use main clock @ 100 MHz
        .LAYER_CUR(LAYER_CUR),
        .LAYER_WAV_A(LAYER_WAV_A),
        .LAYER_WAV_B(LAYER_WAV_B),
        .LAYER_INF(LAYER_INF),
        .VGA_DISP(VGA_DISP_BUS),
        // Signal in RRRRGGGGBBBB
        .PIX_H(PIX_H),
        .PIX_V(PIX_V),
        // Pixel coordinate (640x480 screen)
        .EN_H(VAILD_H),
        .EN_V(VAILD_V),
        // Pixel displaying indicator
        .CLK_VGA(VGA_CLOCK),
        // 4-div clock, sync'd with vga signal
        .SYN_H(VGA_HS),
        .SYN_V(VGA_VS)
        );
    
    mouse_driver mousedrv (
        .CLK(CLK),
        .PS2_CLK(PS2CLK),
        .PS2_DATA(PS2DATA),
        .MOUSE_X(MOUSE_X),
        .MOUSE_Y(MOUSE_Y),
        .MOUSE_LB(MOUSE_LB),
        .MOUSE_RB(MOUSE_RB),
        .EVENT(MOUSE_EVENT)
        );
    
    vga_zoom_ctrl zmctrl (
        .MOUSE_X(MOUSE_X),
        .MOUSE_Y(MOUSE_Y),
        .MOUSE_LB(MOUSE_LB),
        .ZOOM_CNT(ZOOM_CNT),
        .PAUSE(PAUSE_STATE)
        );
    
endmodule
