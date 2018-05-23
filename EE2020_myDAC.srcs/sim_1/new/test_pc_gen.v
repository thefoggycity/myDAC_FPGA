`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/03/20 12:57:07
// Design Name: 
// Module Name: test_pc_gen
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


module test_pc_gen();

    reg clk = 1'b0;
    wire clk_u;
    reg [5:0] cnt = 6'b0;
    
    reg rsrx = 1'b1;
    wire [11:0] wave;
    wire pcon;
    
    pc_gen dut (
        .CLK(clk),
        .CLK_UPD(clk_u),
        .RS_RX(rsrx),
        .PCON(pcon),
        .WAVE(wave)
        );
    
    assign clk_u = cnt[5];
    
    always #1 clk <= ~ clk;
    
    always @ (posedge clk) cnt <= cnt + 1;
    
    reg [3:0] bit_index = 4'b0;
    reg [3:0] byte_index = 4'b0;
    reg [7:0] byte_trans = 8'h6d;
    wire [9:0] dataframe = {1'b1, byte_trans, 1'b0};
    
    initial begin
        // Transmitting 4 byte 0x6d, 0xa2, 0xD7, 0x0c
        #5000;
        for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
            for (bit_index = 0; bit_index < 10; bit_index = bit_index + 1) begin
                #1732;
                rsrx = dataframe[bit_index];
            end
            byte_trans = byte_trans + 8'h35;
        end
        #5000;
        $finish;
    end
    
endmodule
