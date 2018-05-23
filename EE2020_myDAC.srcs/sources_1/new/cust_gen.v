`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/15 23:48:53
// Design Name: 
// Module Name: cust_gen
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


module cust_gen(
    input CLK_UPD,
    input SIGN,
    input [11:0] PHASE,
    input CONT,
    input [9:0] SW,
    output reg [11:0] WAVE = 12'b0
    );
    
    wire [11:0] PHASE_D2 = PHASE >> 1;
    wire [11:0] T = {SIGN, PHASE_D2[10:0]};
    wire [11:0] WAVE_VAL;
    
    // CLK_UPD working at 64-div, 1.5625MHz. Burst interval is 1.49Hz.
    // When freqency is less than 1.49Hz, burst mode may have incomplete 
    // waveform or larger burst interval.
    // The idle state is HIGH, which is consistent with UART/IIC.
    reg [19:0] CNT_BURST = 20'b0;
    reg CNT_RUN = 1'b0;
    reg CONT_LAST = 1'b0;
    reg SIGN_LAST = 1'b0;
    reg BURST = 1'b0;
    reg BURSTED = 1'b0;
    
    assign WAVE_VAL = (T < 12'd410) ? {12{SW[0]}} :
                      (T < 12'd819) ? {12{SW[1]}} :
                      (T < 12'd1229) ? {12{SW[2]}} :
                      (T < 12'd1638) ? {12{SW[3]}} :
                      (T < 12'd2048) ? {12{SW[4]}} :
                      (T < 12'd2458) ? {12{SW[5]}} :
                      (T < 12'd2867) ? {12{SW[6]}} :
                      (T < 12'd3277) ? {12{SW[7]}} :
                      (T < 12'd3686) ? {12{SW[8]}} : {12{SW[9]}};
    
    always @ (negedge CLK_UPD) begin
        if (CONT) begin
            CNT_RUN <= 1'b0;
            BURST <= 1'b0;
            WAVE <= WAVE_VAL;
        end
        else begin
            if (CONT_LAST) begin    // Just turned to burst mode, CONT != CONT_LAST
                CNT_BURST <= 20'b0;
                CNT_RUN <= 1'b0;
                BURST <= 1'b0;
            end
            else begin              // Already in burst mode, CONT == CONT_LAST
                if (~SIGN && (SIGN != SIGN_LAST)) begin // negedge SIGN recently
                    BURST = BURST ? 1'b0 :
                            BURSTED ? 1'b0 : 1'b1;
                    BURSTED = BURST ? 1'b1 : BURSTED;
                    CNT_RUN = 1'b1;
                end
                CNT_BURST = CNT_RUN ? CNT_BURST + 1 : 12'b0;
                BURSTED = CNT_BURST ? BURSTED : 1'b0;
                WAVE = BURST ? WAVE_VAL : 12'hfff;
            end
        end
        SIGN_LAST = SIGN;
        CONT_LAST = CONT;
    end
    
endmodule
