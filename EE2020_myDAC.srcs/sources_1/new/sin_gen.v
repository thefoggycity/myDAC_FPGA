`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 12:26:41
// Design Name: 
// Module Name: sin_gen
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


module sin_gen(
    input CLK,
    input CLK_UPD,
    input SIGN,
    input [11:0] PHASE,
    input COS,
    output reg [11:0] WAVE = 12'b0
    );
    
    // THETA = PHASE * pi = PHASE * 12'd3217 / 2^10
    // PHASE in ufix12_12, 12'd3217 in uint_12, mult in ufix24_12
    // mult divided by 2^10 -> ufix24_22, THETA_ABS = mult[24:12]
    // THETA in fix13_10, which is SIGN_(2_int_bits)_(10_frac_bits)
    
    wire [11:0] THETA_ABS;      // ufix12_10
    reg [12:0] THETA = 13'b0;   // fix13_10
    wire [31:0] WAVE_RAW;   // cmpx:{IMAG[28:16] fix13_11, REAL[12:0] fix13_11}
    // WAVE_RAW is 2 cycles of CLK_UPD later than SIGN/PHASE
    reg SIGN_L = 1'b0;
    
    // DEBUG CODE, REMEMBER TO REMOVE
//    wire [12:0] WAVE_SINE_RAW;  //fix13_11
//    assign WAVE_SINE_RAW = WAVE_RAW[28:16];
    // DEBUG CODE END
    
    always @ (negedge CLK_UPD) begin
        SIGN_L <= SIGN;
        THETA <= SIGN ? ~{1'b0, THETA_ABS} + 1 : {1'b0, THETA_ABS};
        WAVE <= COS ? (SIGN_L ?
                ((WAVE_RAW[12] ^ WAVE_RAW[11]) ? {12{WAVE_RAW[11]}} :
                {~WAVE_RAW[12], WAVE_RAW[10:0]}) : 
                12'hfff - ((WAVE_RAW[12] ^ WAVE_RAW[11]) ? 
                {12{WAVE_RAW[11]}} : {~WAVE_RAW[12], WAVE_RAW[10:0]}) ) :
                12'hfff - ((WAVE_RAW[28] ^ WAVE_RAW[27]) ?              // floor when abs > 1
                {12{WAVE_RAW[27]}} : {~WAVE_RAW[28], WAVE_RAW[26:16]});
    end
    
    pi_mult pm (            // no latency
        .A(PHASE),
        .P(THETA_ABS)
        );
    
    cordic_sin_cos sc (     // 18 clk latency
        .aclk(CLK),
        .s_axis_phase_tvalid(1'b1),
        .s_axis_phase_tdata({3'b0, THETA}),
        .m_axis_dout_tvalid(),
        .m_axis_dout_tdata(WAVE_RAW)
        );
    
endmodule
