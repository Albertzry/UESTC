`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:24:51
// Design Name: 
// Module Name: LFSR_tb
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


module LFSR_tb;

    // 定义仿真中使用的信号
    reg CLK;
    reg RESET;
    wire X2, X1, X0;

    // 实例化被测模块 LFSR
    LFSR uut (
        .CLK(CLK),
        .RESET(RESET),
        .X2(X2),
        .X1(X1),
        .X0(X0)
    );

    // 产生时钟信号，周期为 10ns（5ns 上升沿，5ns 下降沿）
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

 initial begin 
      // 初始化 
      CLK = 0; 
      RESET = 1; 
     
      // 等待20ns
      #20; 
               
      RESET = 0 ; 
      #20 $finish;
 end 


endmodule
