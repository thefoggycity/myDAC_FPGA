`timescale 1ns / 1ps

module myDAC_TOP(
    // MAIN CLOCK
    input CLK,
    // BUTTONS
    input btnC,
    input btnU,
    input btnD,
    input btnR,
    input btnL,
    // UART
    input RsRx,
    // SWITCHES
    input [15:0] sw,
    // LED
    output [15:0] led,
    // 7-SEG DISPLAY
    output [6:0] seg,
    output dp,
    output [3:0] an,
    // PMOD_A (DAC)
    output [3:0] JA,
    // VGA
    output [3:0] VGA_RED,
    output [3:0] VGA_GREEN,
    output [3:0] VGA_BLUE,
    output VGA_HS,
    output VGA_VS,
    // PS-2 (MOUSE)
    inout PS2Clk,
    inout PS2Data
    );
    
    // CLOCKS
    wire HALF_CLOCK;
    wire SAMP_CLOCK;
    wire DBNC_CLOCK;
    wire UPDT_CLOCK;
    // INDICATIONS
    wire [31:0] DISP_DATA;
    wire PCOL;
    wire PCOL_A;
    wire PCOL_B;
    wire [2:0] ACTL_MODE_A; // Actual buffered working mode
    wire [2:0] ACTL_MODE_B;
    // STATUS
    wire [2:0] MODE;
    wire [2:0] PAGE;
    wire [7:0] FREQ;
    wire [1:0] FREQ_EXP;
    wire [11:0] AMPL_U;
    wire [11:0] AMPL_D;
    // CONTROLS
    wire [15:0] SW_LVL; // Debounced switches' signal
    wire LED;           // DAC done
    wire RESET;         // DAC reseting
    // DATA
    wire [11:0] DATA_A_SIG;
    wire [11:0] DATA_B_SIG;
    reg [11:0] DATA_A = 12'b0;
    reg [11:0] DATA_B = 12'b0;
    
    // SWITCHES: MSB -> LSB
    // CH1_SET, CH1_DC, CH2_SET, CH2_DC, DAC_RST, CUS_SEND, WAVEFORM[9:0]
    // LEDS : MSB -> LSB
    // SW[15:12], LED(DAC_DONE), SW[10:0]
    
    assign RESET = SW_LVL[11];
    assign led[10] = (MODE == 3'o5) ? 1'b0 : SW_LVL[10];
    assign led[9:0] = (MODE == 3'o4) ? SW_LVL[9:0] : 10'b0;
    assign led[11] = LED;   // DONE indicator of the DAC module
    assign led[15:12] = SW_LVL[15:12];
    
    assign PCOL = PCOL_A | PCOL_B;  // Actually A and B should fire together

//--------------------------------------------------------------------------------------------------------------------
    // You will need to implement the following below: 
    // 1) HALF_CLOCK : 50MHz Clock Signal
    // 2) SAMP_CLOCK : 1.5kHz Clock Signal  [CHANGED TO UPDT_CLOCK IN FAST VER]
    // 3) DATA_A : 12-bit reg with initial value between 12'h000 to 12'hFFF
    //
    // You can make use of the codes developed in your previous labs and import them into the project.
    
    always @ (negedge SAMP_CLOCK) begin
        DATA_A <= DATA_A_SIG;
        DATA_B <= DATA_B_SIG;
    end
    
//--------------------------------------------------------------------------------------------------------------------
    clk_div clksrc (
        .CLK_IN(CLK),
        .CLK506(HALF_CLOCK),    // 50MHZ, 2-div
        .CLK165(UPDT_CLOCK),    // 1.5625MHZ, 64-div
        .CLK152(),    // 1.50KHz
        .CLK761(DBNC_CLOCK)     // 763Hz, 2^17-div
        );  // NOTE: Baud rate generator is inside pc_gen.
    assign SAMP_CLOCK = UPDT_CLOCK;                     // FAST VERSION
    
    func_channel chnla (
        .CLK(CLK),
        .CLK_UPD(UPDT_CLOCK),
        .RS_RX(RsRx),
        .CHG_SEL(SW_LVL[15]),
        .DC_CUT(SW_LVL[14]),
        .AUX_SW(SW_LVL[10:0]),
        .MODE(MODE),
        .FREQ(FREQ),
        .FREQ_EXP(FREQ_EXP),
        .AMPL_U(AMPL_U),
        .AMPL_D(AMPL_D),
        .PCON(PCOL_A),
        .ACTUAL_MODE(ACTL_MODE_A),
        .DATA(DATA_A_SIG)
        );
        
    func_channel chnlb (
        .CLK(CLK),
        .CLK_UPD(UPDT_CLOCK),
        .RS_RX(RsRx),
        .CHG_SEL(SW_LVL[13]),
        .DC_CUT(SW_LVL[12]),
        .AUX_SW(SW_LVL[10:0]),
        .MODE(MODE),
        .FREQ(FREQ),
        .FREQ_EXP(FREQ_EXP),
        .AMPL_U(AMPL_U),
        .AMPL_D(AMPL_D),
        .PCON(PCOL_B),
        .ACTUAL_MODE(ACTL_MODE_B),
        .DATA(DATA_B_SIG)
        );
    
    sws_dbnc swsdbnc (
        .CLK(DBNC_CLOCK),
        .SW(sw),
        .SW_LVL(SW_LVL)
        );
    
    logic_ctrl lctr (
        .CLK(DBNC_CLOCK),
        .BTNC(btnC),
        .BTNU(btnU),
        .BTND(btnD),
        .BTNL(btnL),
        .BTNR(btnR),
        .MODE(MODE),
        // 0: Square; 1: Saw; 2: Triangle; 3: Sine; 4: Custom; 5: PC;
        .PAGE(PAGE),
        // 0: Mode; 1: Freq; 2: Freq_exp; 3: Amplitude_U; 4: Amplitude_D;
        .FREQ(FREQ),
        // ufix8_2, 1.0 ~ 63.75, init 2.00
        .FREQ_EXP(FREQ_EXP),
        // uint2, 0 ~ 3, init 2
        .AMPL_U(AMPL_U),
        .AMPL_D(AMPL_D)
        );
        
    disp_driver dispdrv (
        .CLK(CLK),
        .CLK_UPD(UPDT_CLOCK),
        .MODE(MODE),
        .PCOL(PCOL),
        .PAGE(PAGE),
        .FREQ(FREQ),
        .FREQ_EXP(FREQ_EXP),
        .AMPL_U(AMPL_U),
        .AMPL_D(AMPL_D),
        .DISPDATA(DISP_DATA)
        );
        
    seg_disp dispscan (
        .CLK(DBNC_CLOCK),
        .DISP(DISP_DATA),
        .SEG(seg),
        .DP(dp),
        .AN(an)
        );
    
    vga_ctrl vgactr (
        .CLK(CLK),
        .CLK_SMP(SAMP_CLOCK),
        .MODE_A(ACTL_MODE_A),
        .WAVE_DATA_A(DATA_A_SIG),
        .MODE_B(ACTL_MODE_B),
        .WAVE_DATA_B(DATA_B_SIG),
        .PS2CLK(PS2Clk),
        .PS2DATA(PS2Data),
        .VGA_RED(VGA_RED),
        .VGA_GREEN(VGA_GREEN),
        .VGA_BLUE(VGA_BLUE),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
        );
        
    DA2RefComp u1(
        //SIGNALS PROVIDED TO DA2RefComp
        .CLK(HALF_CLOCK), 
        .START(SAMP_CLOCK), 
        .DATA1(DATA_A), 
        .DATA2(DATA_B), 
        .RST(RESET), 
        //DO NOT CHANGE THE FOLLOWING LINES
        .D1(JA[1]), 
        .D2(JA[2]), 
        .CLK_OUT(JA[3]), 
        .nSYNC(JA[0]), 
        .DONE(LED)
        );

endmodule
