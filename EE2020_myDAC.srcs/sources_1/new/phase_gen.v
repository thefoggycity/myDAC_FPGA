`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 00:56:37
// Design Name: 
// Module Name: phase_gen
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


module phase_gen(
    input CLK,
    input CLK_UPD,
    input [7:0] FREQ,
    input [1:0] FREQ_EXP,
    output reg SIGN = 1'b0,
    // indicates which part of the period
    output reg [11:0] PHASE = 12'b0
    // ufix12_12, run through 0~1 every HALF period
    );
    
    wire [9:0] TEN_EXP;
    reg [7:0] FREQ_M4_BUF = 8'b0;

    wire [21:0] N_DIVIDEND;
    reg [21:0] N_DIVIDEND_BUF = 22'b0;
        
    reg [21:0] CNT = 22'b0;
    
    wire [31:0] CNT_TOTAL_RAW;
    reg [21:0] CNT_TOTAL = 22'b0;
    
    wire [39:0] PHASE_RAW;
    
    // TEN_EXP = 10^(3-k), k = FREQ_EXP
    assign TEN_EXP = (FREQ_EXP == 2'o0) ? 10'd1000 :
                     (FREQ_EXP == 2'o1) ? 10'd100 :
                     (FREQ_EXP == 2'o2) ? 10'd10 : 10'd1;
    
    always @ (posedge CLK_UPD) begin
    
        FREQ_M4_BUF <= FREQ;
        N_DIVIDEND_BUF <= N_DIVIDEND;
        CNT_TOTAL <= CNT_TOTAL_RAW[29:8];
        
        CNT = ((CNT >= CNT_TOTAL) || 
               (CNT_TOTAL != CNT_TOTAL_RAW[29:8])) ?
               22'b0 : CNT + 1;
        SIGN = CNT ? SIGN : ~SIGN;
        
        PHASE <= PHASE_RAW[11:0];
        
    end
    
    m3125_mult cm (     // No latency
        .A(TEN_EXP),
        .P(N_DIVIDEND)
        );
    
    phase_div pd (      // 20 clk latency
        .aclk(CLK),
        .s_axis_divisor_tvalid(1'b1),
        .s_axis_divisor_tdata(FREQ_M4_BUF),
        .s_axis_dividend_tvalid(1'b1),
        .s_axis_dividend_tdata({2'b0, N_DIVIDEND_BUF}),
        .m_axis_dout_tvalid(),
        .m_axis_dout_tdata(CNT_TOTAL_RAW)  // quotient [29:8]
        );
    
    angle_div ad (      // 36 clk latency
        .aclk(CLK),
        .s_axis_divisor_tvalid(1'b1),
        .s_axis_divisor_tdata({2'b0, CNT_TOTAL}),
        .s_axis_dividend_tvalid(1'b1),
        .s_axis_dividend_tdata({2'b0, CNT}),
        .m_axis_dout_tvalid(),
        .m_axis_dout_tdata(PHASE_RAW)   // fraction [11:0]
        );
    
endmodule
