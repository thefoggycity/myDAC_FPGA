`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/04/01 14:02:49
// Design Name: 
// Module Name: vga_map_ampl
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


module vga_map_ampl(
    input [8:0] MOUSE_Y,
    output reg [179:0] AMPL_MAP
    // 20*9 map
    );
    
    parameter [44:0] DIG_1 = {
        5'b_00100_,
        5'b_01100_,
        5'b_00100_,
        5'b_00100_,
        5'b_00100_,
        5'b_00100_,
        5'b_00100_,
        5'b_00100_,
        5'b_01110_};
    
    parameter [44:0] DIG_2 = {
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_00001_,
        5'b_00010_,
        5'b_00100_,
        5'b_01000_,
        5'b_10000_,
        5'b_11111_};

    parameter [44:0] DIG_3 = {
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_00001_,
        5'b_01110_,
        5'b_00001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01110_};
    
    parameter [44:0] DIG_4 = {
        5'b_00010_,
        5'b_00110_,
        5'b_00110_,
        5'b_01010_,
        5'b_01010_,
        5'b_10010_,
        5'b_11111_,
        5'b_10010_,
        5'b_00010_};

    parameter [44:0] DIG_5 = {
        5'b_11111_,
        5'b_10000_,
        5'b_10000_,
        5'b_11110_,
        5'b_10001_,
        5'b_00001_,
        5'b_00001_,
        5'b_10001_,
        5'b_01110_};

    parameter [44:0] DIG_6 = {
        5'b_00110_,
        5'b_01000_,
        5'b_10000_,
        5'b_10000_,
        5'b_11110_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01110_};
        
    parameter [44:0] DIG_7 = {
        5'b_11111_,
        5'b_10001_,
        5'b_00001_,
        5'b_00010_,
        5'b_00010_,
        5'b_00010_,
        5'b_00100_,
        5'b_00100_,
        5'b_00100_};

    parameter [44:0] DIG_8 = {
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01110_};

    parameter [44:0] DIG_9 = {
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01111_,
        5'b_00001_,
        5'b_00001_,
        5'b_00010_,
        5'b_01100_};

    parameter [44:0] DIG_0 = {
        5'b_01110_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_10001_,
        5'b_01110_};
    
    parameter [44:0] DP = {
        {8{5'b_00000_}},
        {2{5'b_01100_}} };
    
    wire [3:0] FIRST_DATA;
    wire [3:0] SECOND_DATA;
    wire [3:0] THIRD_DATA;
    
    function [44:0] digsel;
        input [3:0] data;
        case (data)
            4'h0: digsel = DIG_0;
            4'h1: digsel = DIG_1;
            4'h2: digsel = DIG_2;
            4'h3: digsel = DIG_3;
            4'h4: digsel = DIG_4;
            4'h5: digsel = DIG_5;
            4'h6: digsel = DIG_6;
            4'h7: digsel = DIG_7;
            4'h8: digsel = DIG_8;
            4'h9: digsel = DIG_9;
            default: digsel = 45'b0;
        endcase
    endfunction
    
    wire [44:0] FIRST_DIG;
    wire [44:0] SECOND_DIG;
    wire [44:0] THIRD_DIG;
    wire [44:0] DP_DIG;
    
    assign FIRST_DIG = digsel(FIRST_DATA);
    assign SECOND_DIG = digsel(SECOND_DATA);
    assign THIRD_DIG = digsel(THIRD_DATA);
    
    reg [4:0] i;
    reg [3:0] j;
    
    always @ (*) begin
        for (j = 0; j < 9; j = j + 1) begin
            for (i = 0; i < 20; i = i + 1) begin
                if (i < 5)
                    AMPL_MAP[j * 20 + i] = THIRD_DIG[j * 5 + i];
                else if (i < 10)
                    AMPL_MAP[j * 20 + i] = SECOND_DIG[j * 5 + i - 5];
                else if (i < 15)
                    AMPL_MAP[j * 20 + i] = DP_DIG[j * 5 + i - 10];
                else
                    AMPL_MAP[j * 20 + i] = FIRST_DIG[j * 5 + i - 15];
            end 
        end
    end
    
    wire VAILD;
    assign VAILD = (MOUSE_Y < 430) && (MOUSE_Y > 47);
    
    wire [11:0] AMPL;
    wire [11:0] AMPL_DEC;
    
    wire [8:0] DIFF_Y = 9'd429 - MOUSE_Y;
    wire [6:0] MAGNITUDE = ~VAILD ? 7'b0 : DIFF_Y / 3;
    
    assign AMPL = ~VAILD ? 12'b0 : {MAGNITUDE, 5'b0};
    
    assign FIRST_DATA = VAILD ? AMPL_DEC[11:8] : 4'hf;
    assign SECOND_DATA = VAILD ? AMPL_DEC[7:4] : 4'hf;
    assign THIRD_DATA = VAILD ? AMPL_DEC[3:0] : 4'hf;
    assign DP_DIG = VAILD ? DP : 45'b0;
    
    ampl_decimal vgaadc (
        .AMPL(AMPL),
        .AMPL_DEC(AMPL_DEC)
        );
    
endmodule
