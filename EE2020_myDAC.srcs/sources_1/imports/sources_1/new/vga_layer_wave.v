`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/24 15:16:48
// Design Name: 
// Module Name: vga_layer_wave
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


module vga_layer_wave(
    input CLK_SMP,
    // Sampling clock, use the DAC's update clock.
    input EN_H,
    input EN_V,
    input [9:0] PIX_H,
    input [8:0] PIX_V,
    input [11:0] WAVE_DATA,
    // Wave data input, sync'd with CLK_SMP. Only one channel.
    input [15:0] ZOOM_CNT,
    // Counts of CLK_SMP cycles for WAVE_DATA sampling.
    input [11:0] WAV_COLOR,
    // Color of wave display.
    input PAUSE,
    // Pause the display refreshing.
    output [11:0] LAYER_WAV
    );
        
    reg [6:0] WAVE_CACHE [639:0];   // Only save 7 MSB (0~127)
    reg [9:0] i;
    initial for (i = 0; i < 640; i = i + 1)
        WAVE_CACHE[i] = 7'b0;
    
    reg [15:0] CNT = 16'b0;
    reg [9:0] SMP_ID = 10'b0;
    
    always @ (posedge CLK_SMP) begin
        if (!PAUSE) begin
            CNT <= (CNT >= ZOOM_CNT) ? 16'b0 : CNT + 1;
            SMP_ID <= (SMP_ID == 10'd639) ? 10'b0 :
                      (CNT >= ZOOM_CNT) ? SMP_ID + 1 : SMP_ID;
            WAVE_CACHE[SMP_ID] <= WAVE_DATA[11:5];
        end
        else
            CNT <= CNT;
    end
    
    // Exact Y of the sample point
    wire [8:0] SMP_DISP;
    // The range is 128*3=384, thus offset is (480-384)/2=48
    assign SMP_DISP = 9'd479 - 9'd48 - WAVE_CACHE[PIX_H] * 3;
    
    assign LAYER_WAV = (PIX_V == SMP_DISP) ? WAV_COLOR : 12'b0;
    
endmodule
