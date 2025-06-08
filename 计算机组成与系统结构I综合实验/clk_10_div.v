`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:56:07
// Design Name: 
// Module Name: clk_10_div
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


module clk_10_div(
    input clk,      
    input rst_n,     
    output reg clk_div 
);
    reg [3:0] cnt;  

    always @(posedge clk or negedge rst_n) begin
        // 如果复位信号有效（低电平），将计数器和分频时钟复位
        if (!rst_n) begin
            cnt     <= 4'd0;   // 计数器清零
            clk_div <= 1'b0;   // 分频时钟初始为低电平
        end
        // 如果计数器未达到半周期计数值（10/2 - 1 = 4），继续计数
        else if (cnt < 4) begin
            cnt     <= cnt + 1'b1; // 计数器加 1
            clk_div <= clk_div;    // 分频时钟保持当前状态
        end
        // 当计数器达到半周期计数值时，重置计数器并翻转分频时钟
        else begin
            cnt     <= 4'd0;   // 计数器清零
            clk_div <= ~clk_div; // 分频时钟取反（实现频率除以 10）
        end
    end

endmodule
