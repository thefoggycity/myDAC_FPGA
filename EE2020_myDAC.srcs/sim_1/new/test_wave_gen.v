`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 13:40:35
// Design Name: 
// Module Name: test_wave_gen
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


module test_wave_gen();

    reg clk = 1'b0;
    wire clk_u;
    reg [4:0] cnt = 5'b0;
    assign clk_u = cnt[4];
    // 32-div in test, not 64-div, but should be enough for cordic
    
    reg sign = 1'b1;
    reg [11:0] phase = 12'h000;
    wire [11:0] sqr_wv;
    wire [11:0] saw_wv;
    wire [11:0] tri_wv;
    wire [11:0] sin_wv;
    
    reg sqr_polarity = 1'b0;
    reg saw_direction = 1'b0;
    reg tri_polarity = 1'b0;
    reg sin_cos = 1'b0;
    
    always #1 clk <= ~clk;
    always @ (posedge clk) cnt <= cnt + 1;
    always @ (posedge clk_u) begin
        phase = phase + 11'h010;
        sign = phase ? sign : ~sign;
    end
    
    sin_gen dutsin (
        .CLK(clk),
        .CLK_UPD(clk_u),
        .SIGN(sign),
        .PHASE(phase),
        .COS(sin_cos),
        .WAVE(sin_wv)
        );
    
    saw_gen dutsaw (
        .CLK_UPD(clk_u),
        .SIGN(sign),
        .PHASE(phase),
        .DIRECTION(saw_direction),
        .WAVE(saw_wv)
        );
    
    tri_gen duttri (
        .CLK_UPD(clk_u),
        .SIGN(sign),
        .PHASE(phase),
        .POLARITY(tri_polarity),
        .WAVE(tri_wv)
        );
    
    sqr_gen dutsqr (
        .CLK_UPD(clk_u),
        .SIGN(sign),
        .POLARITY(sqr_polarity),
        .WAVE(sqr_wv)
        );
    
endmodule
