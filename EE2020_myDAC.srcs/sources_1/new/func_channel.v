`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/11 01:22:55
// Design Name: 
// Module Name: func_channel
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


module func_channel(
    input CLK,
    input CLK_UPD,
    input RS_RX,
    // The serial port receiving terminal. Not buffered.
    input CHG_SEL,
    // Enable changing channel working parameters.  1:Change, 0:Hold.
    input DC_CUT,
    // Cut wave to DC at lower voltage bound. Not buffered.
    input [10:0] AUX_SW,
    // Auxiliary switches, used in various mode.
    // For Custom Mode: [10] indicates custom mode works in continuous 
    //      (otherwise burst) mode. [9:0] are waveform switches.
    // For Saw Mode: [10] select between positive scan (switch off) and 
    //      negative scan (switch on).
    // For Sine Mode: [10] select between sine wave (switch off) and 
    //      cosine wave (switch on). Useful for multi-channel.
    // For Triangle & Square Mode: [10] changes polarity of waveform.
    input [2:0] MODE,
    // 0: Square; 1: Saw; 2: Triangle; 3: Sine; 4: Custom; 5: PC;
    input [7:0] FREQ,
    // ufix8_2, 1.0 ~ 63.75, init 2.00
    input [1:0] FREQ_EXP,
    // uint2, 0 ~ 3, init 2
    input [11:0] AMPL_U,
    // ufix12_12, 0 ~ 1, init 1
    input [11:0] AMPL_D,
    // ufix12_12, 0 ~ 1, init 0
    output PCON,
    // Indicates if PC is sending signal to pc_gen.
    output [2:0] ACTUAL_MODE,
    // Indicates the buffered mode that is actually using.
    output [11:0] DATA
    // Final data to DAC module
    );
    
    reg [2:0] MODE_BUF = 3'o0;
    reg [7:0] FREQ_BUF = 8'h08;
    reg [1:0] FREQ_EXP_BUF = 3'o2;
    reg [11:0] AMPL_U_BUF = 12'hfff;
    reg [11:0] AMPL_D_BUF = 12'h000;
    
    reg [10:0] AUX_SW_BUF = 11'b0;
    
    reg [11:0] WAVE = 12'b0;
    
    wire SIGN;
    wire [11:0] PHASE;
    
    wire [11:0] SQR_WV;
    wire [11:0] SAW_WV;
    wire [11:0] TRI_WV;
    wire [11:0] SIN_WV;
    wire [11:0] CUST_WV;
    wire [11:0] PC_WV;
    wire [11:0] AMPL_WV;
    // In PC mode, wave_amp is BYPASSED.
    
    always @ (posedge CLK_UPD) begin
        
        if (CHG_SEL) begin
            AUX_SW_BUF <= AUX_SW;
            MODE_BUF <= MODE;
            FREQ_BUF <= FREQ;
            FREQ_EXP_BUF <= FREQ_EXP;
            AMPL_U_BUF <= AMPL_U;
            AMPL_D_BUF <= AMPL_D;
        end
        
        if (DC_CUT) WAVE <= 12'b0;
        else begin
            case (MODE_BUF)
                3'o0: WAVE <= SQR_WV;
                3'o1: WAVE <= SAW_WV;
                3'o2: WAVE <= TRI_WV;
                3'o3: WAVE <= SIN_WV;
                3'o4: WAVE <= CUST_WV;
                3'o5: WAVE <= PC_WV;    // PC_WV is updated SLOWER
                default: WAVE <= WAVE;  // Should never reach
            endcase
        end
        
    end
    
    // Output the MODE_BUF value:
    assign ACTUAL_MODE = MODE_BUF;
    
    // Bypassing wave_amp if PC mode selected:
    assign DATA = (MODE_BUF == 3'o5) ? WAVE : AMPL_WV;
    // NOTE: if DC_CUT is asserted in PC mode, then output DC at 0V.
    
    wave_amp wamp (
        .AMPL_U(AMPL_U_BUF),
        .AMPL_D(AMPL_D_BUF),
        .WAVE(WAVE),
        .DATA(AMPL_WV)
        );
    
    phase_gen phagen (
        .CLK(CLK),
        .CLK_UPD(CLK_UPD),
        .FREQ(FREQ_BUF),
        .FREQ_EXP(FREQ_EXP_BUF),
        .SIGN(SIGN),
        .PHASE(PHASE)
        );
    
    sqr_gen sqrgen (
        .CLK_UPD(CLK_UPD),
        .SIGN(SIGN),
        .POLARITY(AUX_SW_BUF[10]),
        .WAVE(SQR_WV)
        );
    
    saw_gen sawgen (
        .CLK_UPD(CLK_UPD),
        .SIGN(SIGN),
        .PHASE(PHASE),
        .DIRECTION(AUX_SW_BUF[10]),
        .WAVE(SAW_WV)
        );
    
    tri_gen trigen (
        .CLK_UPD(CLK_UPD),
        .SIGN(SIGN),
        .PHASE(PHASE),
        .POLARITY(AUX_SW_BUF[10]),
        .WAVE(TRI_WV)
        );
    
    sin_gen singen (
        .CLK(CLK),
        .CLK_UPD(CLK_UPD),
        .SIGN(SIGN),
        .PHASE(PHASE),
        .COS(AUX_SW_BUF[10]),
        .WAVE(SIN_WV)
        );
    
    cust_gen custgen (
        .CLK_UPD(CLK_UPD),
        .SIGN(SIGN),
        .PHASE(PHASE),
        .CONT(AUX_SW_BUF[10]),
        .SW(AUX_SW_BUF[9:0]),
        .WAVE(CUST_WV)
        );
    
    pc_gen pcgen (
        .CLK(CLK),
        .CLK_UPD(CLK_UPD),
        .RS_RX(RS_RX),
        .PCON(PCON),
        .WAVE(PC_WV)
        );

endmodule
