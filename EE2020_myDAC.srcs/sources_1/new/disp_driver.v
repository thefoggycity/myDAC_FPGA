`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/09 00:45:23
// Design Name: 
// Module Name: disp_driver
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


module disp_driver(
    input CLK,      // Full speed 100MHz clock
    input CLK_UPD,  // 64-div clock for data update
    input [2:0] MODE,
    // 0: Square; 1: Saw; 2: Triangle; 3: Sine; 4: Custom; 5: PC;
    input PCOL,     // PC mode connection flag
    input [2:0] PAGE,
    // 0: Mode; 1: Freq; 2: Freq_exp; 3: Amplitude_U; 4: Amplitude_D;
    input [7:0] FREQ,
    // ufix8_2, 1.0 ~ 63.75, init 2.00
    input [1:0] FREQ_EXP,
    // uint2, 0 ~ 3, init 2
    input [11:0] AMPL_U,
    input [11:0] AMPL_D,
    output reg [31:0] DISPDATA  // 7-seg data to display
    );
    
    parameter [7:0] DIG_F = 8'hf1;              // "F."
    parameter [7:0] DIG_U = 8'hbe;              // "U."
    parameter [7:0] DIG_D = 8'hb8;              // "L."
    parameter [15:0] DIGS_FE = 16'h71_f9;       // "FE."
    parameter [31:0] WORD_SR = 32'h40_6d_d0_40; // "-Sr.-"
    parameter [31:0] WORD_SA = 32'h40_6d_f7_40; // "-SA.-"
    parameter [31:0] WORD_TR = 32'h40_78_d0_40; // "-tr.-"
    parameter [31:0] WORD_SN = 32'h40_6d_d4_40; // "-Sn.-"
    parameter [31:0] WORD_CU = 32'h40_39_be_40; // "-CU.-"
    parameter [31:0] WORD_PC = 32'h40_73_39_40; // "-PC-"
    parameter [31:0] FAULT = 32'h40_40_40_40;   // "----"
    
    // Converted FREQ in decimal (BCD with 1-digit frac)
    wire [11:0] FREQ_DEC;
    // Converted AMPL(V) in decimal (BCD with 2-digit frac)
    wire [11:0] AMPL_U_DEC;
    wire [11:0] AMPL_D_DEC;
    
    function [6:0] encode;
        input [3:0] code_in;
        begin
            case (code_in)
                4'h0: encode = 7'h3f;
                4'h1: encode = 7'h06;
                4'h2: encode = 7'h5b;
                4'h3: encode = 7'h4f;
                4'h4: encode = 7'h66;
                4'h5: encode = 7'h6d;
                4'h6: encode = 7'h7d;
                4'h7: encode = 7'h07;
                4'h8: encode = 7'h7f;
                4'h9: encode = 7'h6f;
                4'ha: encode = 7'h77;
                4'hb: encode = 7'h7c;
                4'hc: encode = 7'h39;
                4'hd: encode = 7'h5e;
                4'he: encode = 7'h79;
                4'hf: encode = 7'h71;
                default: encode = 7'h00;    // Will not reach
            endcase
        end
    endfunction
    
    always @ (posedge CLK_UPD) begin
        
        case (PAGE)
            3'o0:
                DISPDATA <= (MODE == 3'o0) ? WORD_SR : 
                            (MODE == 3'o1) ? WORD_SA :
                            (MODE == 3'o2) ? WORD_TR :
                            (MODE == 3'o3) ? WORD_SN :
                            (MODE == 3'o4) ? WORD_CU :
                            (MODE == 3'o5) ? (PCOL ? WORD_PC : 
                            (WORD_PC & 32'h00_ff_ff_00) ) :
                            FAULT;  // Should never reach
            3'o1:
//                DISPDATA <= {DIG_F,         // TODO: CHANGE TO DECIMAL DISPLAY
//                            1'b0, encode ({2'b00, FREQ[7:6]}),
//                            1'b1, encode (FREQ[5:2]),
//                            1'b0, encode ({FREQ[1:0], 2'b00})};
                DISPDATA <= {DIG_F,
                            1'b0, encode (FREQ_DEC[11:8]),
                            1'b1, encode (FREQ_DEC[7:4]),
                            1'b0, encode (FREQ_DEC[3:0])};
            3'o2:
                DISPDATA <= {DIGS_FE, 8'h00,
                            1'b0, encode ({2'b00, FREQ_EXP})};
            3'o3:
//                DISPDATA <= {DIG_U,
//                            1'b0, encode (AMPL_U[11:8]),
//                            1'b0, encode (AMPL_U[7:4]),
//                            1'b0, encode (AMPL_U[3:0])};
                DISPDATA <= {DIG_U,
                            1'b1, encode (AMPL_U_DEC[11:8]),
                            1'b0, encode (AMPL_U_DEC[7:4]),
                            1'b0, encode (AMPL_U_DEC[3:0])};
            3'o4:
//                DISPDATA <= {DIG_D,
//                            1'b0, encode (AMPL_D[11:8]),
//                            1'b0, encode (AMPL_D[7:4]),
//                            1'b0, encode (AMPL_D[3:0])};
                DISPDATA <= {DIG_D,
                            1'b1, encode (AMPL_D_DEC[11:8]),
                            1'b0, encode (AMPL_D_DEC[7:4]),
                            1'b0, encode (AMPL_D_DEC[3:0])};
            default:    // Should never reach
                DISPDATA <= FAULT;
        endcase
    end
    
    // Hex-Dec converter for FREQ
    freq_decimal fdc (
        .FREQ(FREQ),
        .FREQ_DEC(FREQ_DEC)
        );
    
    ampl_decimal adcu (
        .AMPL(AMPL_U),
        .AMPL_DEC(AMPL_U_DEC)
        );
    
    ampl_decimal adcd (
        .AMPL(AMPL_D),
        .AMPL_DEC(AMPL_D_DEC)
        );
    
endmodule
