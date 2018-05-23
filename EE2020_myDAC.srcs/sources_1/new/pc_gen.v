`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/20 12:14:57
// Design Name: 
// Module Name: pc_gen
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


module pc_gen(
    input CLK,
    input CLK_UPD,
    input RS_RX,
    output reg PCON = 1'b0,
    output reg [11:0] WAVE = 12'b0
    );
    
    // This module DOES NOT use PHASE nor SIGN, the waveform is
    // COMPLETELY DEPENDENT on RS_RX, the serial port.
    // Also, the amp module should be BYPASSED.
    // Instead of using CLK_UPD, the WAVE sample is updated when
    // a serial data frame transmission is finished.
    // CLK_UPD is for examining PC connection (i.e. update PCON).
    
    parameter COUNT = 4'd10;
    // 1 start bit plus 8 data bit plus 1 stop bit;
    // Data bits are LSB FIRST.
    parameter BAUD_CNT = 9'd432;
    // Slow baud rate is 115400. [10^8 / 115200 / 2 - 1 = 432].
    // Fast baud rate is 230800. [10^8 / 230800 / 2 - 1 = 216]. UNSTABLE
    
    reg RUN = 1'b0;
    reg BAUDCLK = 1'b0;
    reg BAUDCLK_L = 1'b0;
    reg [8:0] CNT = 9'b0;
    reg [3:0] PC_CNT = 4'b0;
    reg ISPC = 1'b0;
    reg [3:0] PULSES = 4'd0;
    reg [9:0] DATA = 9'b0;
    
    always @ (negedge CLK) begin
        if (!RS_RX && !RUN) begin
            RUN <= 1'b1;
        end
        else if (PULSES == COUNT)
            RUN <= 1'b0;
    end
    
    always @ (posedge CLK) begin
        if (RUN) begin
            CNT <= (CNT == (BAUD_CNT)) ? 14'b0 : CNT + 1;
            BAUDCLK <= CNT ? BAUDCLK : ~BAUDCLK;
            BAUDCLK_L <= BAUDCLK;
            DATA <= (!BAUDCLK_L && BAUDCLK) ? {DATA[8:0], RS_RX} : DATA;
            PULSES <= (!CNT && (BAUDCLK == 1'b1)) ? PULSES + 1 : PULSES;
        end
        else begin
            CNT <= BAUD_CNT >> 1;
            BAUDCLK <= 1'b0;
            BAUDCLK_L <= 1'b0;
            PULSES <= 4'd0;
        end
    end
    
    always @ (negedge RUN)
        WAVE <= {DATA[1], DATA[2], DATA[3], DATA[4],
                 DATA[5], DATA[6], DATA[7], DATA[8], 4'b0};
    
    always @ (posedge CLK_UPD) begin
        ISPC <= PC_CNT ? ISPC | RUN : 0;
        PCON <= PC_CNT ? PCON : ISPC;
        PC_CNT <= PC_CNT + 1;
    end
    
endmodule
