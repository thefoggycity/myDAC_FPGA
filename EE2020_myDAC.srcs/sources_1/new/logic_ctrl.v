`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/08 16:18:49
// Design Name: 
// Module Name: logic_ctrl
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


module logic_ctrl(
    input CLK,  // Use the debouncer clock
    input BTNC, // Circle the page
    input BTNU, // Increase large
    input BTND, // Decrease large
    input BTNL, // Increase small
    input BTNR, // Decrease small
    output reg [2:0] MODE = 3'o0,
    // 0: Square; 1: Saw; 2: Triangle; 3: Sine; 4: Custom; 5: PC;
    output reg [2:0] PAGE = 3'o0,
    // 0: Mode; 1: Freq; 2: Freq_exp; 3: Amplitude_U; 4: Amplitude_D;
    output reg [7:0] FREQ = 8'h08,
    // ufix8_2, 1.0 ~ 63.75, init 2.00
    output reg [1:0] FREQ_EXP = 2'o2,
    // uint2, 0 ~ 3, init 2
    output reg [11:0] AMPL_U = 12'hf00,
    output reg [11:0] AMPL_D = 12'h080
    );
    
    parameter [7:0] F_CHG_S = 8'h01;
    parameter [7:0] F_CHG_L = 8'h04;
    parameter [11:0] AMP_CHG_S = 12'h001;   // previously h020
    parameter [11:0] AMP_CHG_L = 12'h080;
    
    wire BTNC_P, BTNU_P, BTND_P, BTNL_P, BTNR_P;
    
    key_dbnc kdbc (.CLK(CLK), .KEY(BTNC), .PULSE(BTNC_P));
    key_dbnc kdbu (.CLK(CLK), .KEY(BTNU), .PULSE(BTNU_P));
    key_dbnc kdbd (.CLK(CLK), .KEY(BTND), .PULSE(BTND_P));
    key_dbnc kdbl (.CLK(CLK), .KEY(BTNL), .PULSE(BTNL_P));
    key_dbnc kdbr (.CLK(CLK), .KEY(BTNR), .PULSE(BTNR_P));
    
    always @ (negedge CLK) begin
        PAGE <= (MODE == 3'o5) ? PAGE :
                BTNC_P ? ((PAGE == 3'o4) ? 3'o0 : PAGE + 1) : PAGE;
        case (PAGE)
            3'o0:
                MODE <= ((BTNR_P | BTNU_P) == (BTND_P | BTNL_P)) ? MODE : 
                        ((BTNR_P | BTNU_P) ?
                        ((MODE == 3'o5) ? MODE : MODE + 1) :
                        ((MODE == 3'o0) ? MODE : MODE - 1));
            3'o1:
                FREQ <= ((BTNR_P | BTNU_P) == (BTND_P | BTNL_P)) ? FREQ : 
                        ((BTNR_P | BTNL_P) ? 
                        (BTNR_P ?
                        (((FREQ + F_CHG_S > FREQ) && (FREQ + F_CHG_S > 8'h03)) ? 
                            FREQ + F_CHG_S : FREQ) :
                        (((FREQ - F_CHG_S < FREQ) && (FREQ - F_CHG_S > 8'h03)) ? 
                            FREQ - F_CHG_S : FREQ) ):
                        (BTNU_P ?
                        (((FREQ + F_CHG_L > FREQ) && (FREQ + F_CHG_L > 8'h03)) ? 
                            FREQ + F_CHG_L : FREQ) :
                        (((FREQ - F_CHG_L < FREQ) && (FREQ - F_CHG_L > 8'h03)) ? 
                            FREQ - F_CHG_L : FREQ) ));
            3'o2:
                FREQ_EXP <= ((BTNR_P | BTNU_P) == (BTND_P | BTNL_P)) ? FREQ_EXP : 
                            ((BTNR_P | BTNU_P) ?
                            ((FREQ_EXP == 3'o7) ? FREQ_EXP : FREQ_EXP + 1) :
                            ((FREQ_EXP == 3'o0) ? FREQ_EXP : FREQ_EXP - 1));
            3'o3:
                AMPL_U <= ((BTNR_P | BTNU_P) == (BTND_P | BTNL_P)) ? AMPL_U : 
                          ((BTNR_P | BTNL_P) ? 
                          (BTNR_P ?
                          ((AMPL_U + AMP_CHG_S > AMPL_D) ? AMPL_U + AMP_CHG_S : AMPL_U) :
                          ((AMPL_U - AMP_CHG_S > AMPL_D) ? AMPL_U - AMP_CHG_S : AMPL_U) ):
                          (BTNU_P ?
                          ((AMPL_U + AMP_CHG_L > AMPL_D) ? AMPL_U + AMP_CHG_L : AMPL_U) :
                          ((AMPL_U - AMP_CHG_L > AMPL_D) ? AMPL_U - AMP_CHG_L : AMPL_U) ));
            3'o4:
                AMPL_D <= ((BTNR_P | BTNU_P) == (BTND_P | BTNL_P)) ? AMPL_D : 
                          ((BTNR_P | BTNL_P) ? 
                          (BTNR_P ?
                          ((AMPL_D + AMP_CHG_S < AMPL_U) ? AMPL_D + AMP_CHG_S : AMPL_D) :
                          ((AMPL_D - AMP_CHG_S < AMPL_U) ? AMPL_D - AMP_CHG_S : AMPL_D) ):
                          (BTNU_P ?
                          ((AMPL_D + AMP_CHG_L < AMPL_U) ? AMPL_D + AMP_CHG_L : AMPL_D) :
                          ((AMPL_D - AMP_CHG_L < AMPL_U) ? AMPL_D - AMP_CHG_L : AMPL_D) ));
            default:    // Should never reach
                MODE <= MODE;
        endcase
    end
    
endmodule
