`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 08:34:42
// Design Name: 
// Module Name: Vr74x74_tb
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


module Vr74x74_tb;

    reg CLK, D, PR_L, CLR_L;
    wire Q, QN;

    Vr74x74 uut (
        .CLK(CLK),
        .D(D),
        .PR_L(PR_L),
        .CLR_L(CLR_L),
        .Q(Q),
        .QN(QN)
    );

    // 时钟信号生成
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 产生周期为 10 的时钟信号
    end

    // 初始化测试过程
    initial begin
        // 初始化输入信号
        PR_L = 1;
        CLR_L = 1;
        D = 0;

        // 应用不同的测试激励
        #10 PR_L = 0;  // 置位触发器（低电平有效）
        #10 PR_L = 1;  // 取消置位

        #10 CLR_L = 0;  // 复位触发器（低电平有效）
        #10 CLR_L = 1;  // 取消复位

        #10 D = 1;  // 在时钟上升沿设置 D 为 1
        #10 D = 0;  // 在时钟上升沿设置 D 为 0

        // 结束仿真
        #20 $finish;
    end


endmodule
