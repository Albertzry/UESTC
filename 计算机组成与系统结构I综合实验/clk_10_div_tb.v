`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:57:24
// Design Name: 
// Module Name: clk_10_div_tb
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


module clk_10_div_tb;
    reg clk;
    reg rst_n;
    wire clk_div;
 
    clk_10_div uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_div(clk_div)
    );
    always #10 clk = ~clk;
 
    initial begin
        clk = 0;
        rst_n = 0;

        #10;

        rst_n = 1;
    end
endmodule
 
