`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/22 15:37:29
// Design Name: 
// Module Name: ampl_decimal
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


module ampl_decimal(
    input [11:0] AMPL,
    output [11:0] AMPL_DEC
    );
    
    // AMPL in ufix12_12, 0 ~ 0.999
    // full voltage is 3.38V
    // represent in 9'd338
    parameter [8:0] VCC = 9'd338;
    
    wire [20:0] PRODUCT;
    wire [6:0] REM100;
    
    assign PRODUCT = AMPL * VCC;    // ufix21_12
    assign REM100 = PRODUCT[20:12] % 7'd100;
    assign AMPL_DEC[11:8] = PRODUCT[20:12] / 7'd100;
    assign AMPL_DEC[7:4] = REM100 / 4'd10;
    assign AMPL_DEC[3:0] = REM100 % 4'd10;
    
endmodule
