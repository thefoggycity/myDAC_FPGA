`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/23 22:13:26
// Design Name: 
// Module Name: mouse_driver
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


module mouse_driver(
    input CLK,
    inout PS2_CLK,
    inout PS2_DATA,
    output [9:0] MOUSE_X,
    output [8:0] MOUSE_Y,
    output MOUSE_LB,
    output MOUSE_RB,
    output EVENT
    );
    
    reg [11:0] SET_VALUE = 12'b0;
    wire SET_MAX_X;
    wire SET_MAX_Y;
    reg [2:0] SET_INIT_STATE = 3'b0;
    
    assign SET_MAX_X = (SET_INIT_STATE == 3'b001);
    assign SET_MAX_Y = (SET_INIT_STATE == 3'b011);
    always @ (posedge CLK) begin
        SET_INIT_STATE[0] <= 1'b1;
        SET_INIT_STATE[1] <= SET_INIT_STATE[0];
        SET_INIT_STATE[2] <= SET_INIT_STATE[1];
        SET_VALUE <= (SET_INIT_STATE == 3'b000) ? 12'd639 :     // 640x480
                     (SET_INIT_STATE == 3'b001) ? 12'd479 : 12'b0;
    end
    
    wire [11:0] MOUSE_X_RAW;
    wire [11:0] MOUSE_Y_RAW;
    
    assign MOUSE_X = MOUSE_X_RAW[9:0];
    assign MOUSE_Y = MOUSE_Y_RAW[8:0];
    // Safe to truncate because they are positive integers in 640*480
    
    MouseCtl mousectl (
        .clk(CLK),
        .rst(1'b0),
        .xpos(MOUSE_X_RAW),
        .ypos(MOUSE_Y_RAW),
        .zpos(),
        .left(MOUSE_LB),
        .middle(),
        .right(MOUSE_RB),
        .new_event(EVENT),
        .value(SET_VALUE),
        .setx(),
        .sety(),
        .setmax_x(SET_MAX_X),
        .setmax_y(SET_MAX_Y),
        .ps2_clk(PS2_CLK),
        .ps2_data(PS2_DATA)
        );
    
endmodule
