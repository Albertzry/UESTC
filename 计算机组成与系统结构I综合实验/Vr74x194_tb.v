`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:01:10
// Design Name: 
// Module Name: Vr74x194_tb
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


module Vr74x194_tb;

    // 定义输入信号
    reg CLK, CLR_L, LIN, RIN, S1, S0, A, B, C, D;

    // 定义输出信号
    wire QA, QB, QC, QD;

    // 实例化 Vr74x194 模块
    Vr74x194 uut (
        .CLK(CLK),
        .CLR_L(CLR_L),
        .LIN(LIN),
        .RIN(RIN),
        .S1(S1),
        .S0(S0),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .QA(QA),
        .QB(QB),
        .QC(QC),
        .QD(QD)
    );

    // 时钟信号生成
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 产生周期为 10 的时钟信号
    end
    
    // 初始化测试过程
    initial begin
        CLR_L = 1;
        LIN = 0;
        RIN = 0;
        S1 = 0;
        S0 = 0;
        A = 0;
        B = 0;
        C = 0;
        D = 0;

        #10 CLR_L = 0;  // 同步复位
        #10 CLR_L = 1;  // 取消复位

        #10 S1 = 1; S0 = 1; 
        A = 1; B = 0; C = 1; D = 0;  // 输入数据 1010
        
        #10 S1 = 0; S0 = 0;
          
        #10 S1 = 0; S0 = 1;  // 左移模式
        LIN = 1;  // 左移输入使能
        #10 LIN = 0;  // 禁用左移输入

        #10 S1 = 1; S0 = 0;  // 右移模式
        RIN = 1;  // 右移输入使能
        #10 RIN = 0;  // 禁用右移输入

        #10 $finish;
    end

endmodule
