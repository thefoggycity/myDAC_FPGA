`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/08 22:20:50
// Design Name: 
// Module Name: test_logic_ctrl
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


module test_logic_ctrl();

    reg clk = 1'b0,
        btnC = 1'b0,
        btnU = 1'b0,
        btnD = 1'b0,
        btnL = 1'b0,
        btnR = 1'b0;
    
    wire [2:0] MODE;
    wire [2:0] PAGE;
    wire [7:0] FREQ;
    wire [1:0] FREQ_EXP;
    wire [11:0] AMPL_U;
    wire [11:0] AMPL_D;
    
    initial begin
        
        btnU = #2 1'b1;     // p0 - mode
        btnU = #14 1'b0;
        btnR = #7 1'b1;
        btnR = #12 1'b0;
        btnD = #7 1'b1;  
        btnD = #12 1'b0; 
        #10;
        btnC = #7 1'b1;
        btnC = #11 1'b0;
        btnL = #2 1'b1;     // p1 - freq
        btnL = #13 1'b0;
        btnR = #2 1'b1;
        btnR = #13 1'b0;
        btnU = #2 1'b1;
        btnU = #13 1'b0;
        btnD = #2 1'b1;
        btnD = #13 1'b0;
        #10;
        btnC = #7 1'b1; 
        btnC = #11 1'b0;
        btnL = #2 1'b1;     // p2 - freq_exp
        btnL = #13 1'b0;
        btnR = #2 1'b1; 
        btnR = #13 1'b0;
        btnU = #2 1'b1; 
        btnU = #13 1'b0;
        btnD = #2 1'b1; 
        btnD = #13 1'b0;
        #10;
        btnC = #7 1'b1; 
        btnC = #11 1'b0;
        btnL = #2 1'b1;     // p3 - ampl_u
        btnL = #13 1'b0;
        btnR = #2 1'b1; 
        btnR = #13 1'b0;
        btnU = #2 1'b1; 
        btnU = #13 1'b0;
        btnD = #2 1'b1; 
        btnD = #13 1'b0;
        #10;
        btnC = #7 1'b1; 
        btnC = #11 1'b0;
        btnL = #2 1'b1;     // p4 - ampl_d
        btnL = #13 1'b0;
        btnR = #2 1'b1; 
        btnR = #13 1'b0;
        btnU = #2 1'b1; 
        btnU = #13 1'b0;
        btnD = #2 1'b1; 
        btnD = #13 1'b0;
        
    end
    
    logic_ctrl dut (
        .CLK(clk),
        .BTNC(btnC),
        .BTNU(btnU),
        .BTND(btnD),
        .BTNL(btnL),
        .BTNR(btnR),
        .MODE(MODE),
        .PAGE(PAGE),
        .FREQ(FREQ),
        .FREQ_EXP(FREQ_EXP),
        .AMPL_U(AMPL_U),
        .AMPL_D(AMPL_D)
        );
    
    always #5 clk <= ~clk;
    
endmodule
