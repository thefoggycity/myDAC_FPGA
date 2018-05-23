`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/10 02:08:30
// Design Name: 
// Module Name: test_phase_gen
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


module test_phase_gen();

    reg clk = 1'b0;
    wire clk_u;
    reg [5:0] cnt = 6'b0;
    
    reg [7:0] freq = 8'h08;
    reg [1:0] f_e = 2'o2;
    
    wire sign;
    wire [11:0] phase;
    
    assign clk_u = cnt[5];
    
    always #5 clk = ~clk;
    
    always @ (posedge clk)
        cnt <= cnt + 1;
    
    phase_gen dut (
        .CLK(clk),
        .CLK_UPD(clk_u),
        .FREQ(freq),
        .FREQ_EXP(f_e),
        .SIGN(sign),
        .PHASE(phase)
        );
    
endmodule
