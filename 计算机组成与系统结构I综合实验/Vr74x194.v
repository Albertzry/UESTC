`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 08:54:33
// Design Name: 
// Module Name: Vr74x194
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


module Vr74x194(CLK, CLR_L, LIN, RIN, S1, S0, A, B, C, D,
                QA, QB, QC, QD);
    input CLK, CLR_L, LIN, RIN, S1, S0, A, B, C, D;
    output QA, QB, QC, QD;

    wire CLK_D; // 时钟信号缓冲
    wire CLR_L_D; // 清零信号缓冲
    wire S1_L, S1_H;
    wire S0_L, S0_H;
    wire QAN, QBN, QCN, QDN; // 触发器的反相输出
    
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
    wire w11, w12, w13, w14, w15, w16, w17, w18, w19, w20;
    
    buf (CLK_D, CLK);
    buf (CLR_L_D, CLR_L);
    not (S1_L, S1);
    not (S1_H, S1_L);
    not (S0_L, S0);
    not (S0_H, S0_L);
    
    // 当 S1=1, S0=0 时，选择左移输入 LIN
    // 当 S1=0, S0=0 时，选择左移的内部连接（QC）
    // 当 S1=1, S0=1 时，选择并行加载输入 D
    // 当 S1=0, S0=1 时，选择右移的内部连接（QC）
    and (w1, LIN, S1_H, S0_L);
    and (w2, QD, S1_L, S0_L);
    and (w3, D, S1_H, S0_H);
    and (w4, QC, S1_L, S0_H);
    or  (w5, w1, w2, w3, w4);
    
    // 使用触发器存储 QD 的状态
    Vr74x74 u3 (CLK_D, w5, 1'b1, CLR_L_D, QD, QDN);
    
    and (w6, QD, S1_H, S0_L);
    and (w7, QC, S1_L, S0_L);
    and (w8, C, S1_H, S0_H);
    and (w9, QB, S1_L, S0_H);
    or  (w10, w6, w7, w8, w9);
    
    // 使用触发器存储 QC 的状态
    Vr74x74 u2 (CLK_D, w10, 1'b1, CLR_L_D, QC, QCN);
    
    and (w11, QC, S1_H, S0_L);
    and (w12, QB, S1_L, S0_L);
    and (w13, B, S1_H, S0_H);
    and (w14, QA, S1_L, S0_H);
    or  (w15, w11, w12, w13, w14);
    
    // 使用触发器存储 QB 的状态
    Vr74x74 u1 (CLK_D, w15, 1'b1, CLR_L_D, QB, QBN);
    
    and (w16, QB, S1_H, S0_L);
    and (w17, QA, S1_L, S0_L);
    and (w18, A, S1_H, S0_H);
    and (w19, RIN, S1_L, S0_H);
    or  (w20, w16, w17, w18, w19);
    
    // 使用触发器存储 QA 的状态
    Vr74x74 u0 (CLK_D, w20, 1'b1, CLR_L_D, QA, QAN);
    
endmodule
