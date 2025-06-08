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

    wire CLK_D; // ʱ���źŻ���
    wire CLR_L_D; // �����źŻ���
    wire S1_L, S1_H;
    wire S0_L, S0_H;
    wire QAN, QBN, QCN, QDN; // �������ķ������
    
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
    wire w11, w12, w13, w14, w15, w16, w17, w18, w19, w20;
    
    buf (CLK_D, CLK);
    buf (CLR_L_D, CLR_L);
    not (S1_L, S1);
    not (S1_H, S1_L);
    not (S0_L, S0);
    not (S0_H, S0_L);
    
    // �� S1=1, S0=0 ʱ��ѡ���������� LIN
    // �� S1=0, S0=0 ʱ��ѡ�����Ƶ��ڲ����ӣ�QC��
    // �� S1=1, S0=1 ʱ��ѡ���м������� D
    // �� S1=0, S0=1 ʱ��ѡ�����Ƶ��ڲ����ӣ�QC��
    and (w1, LIN, S1_H, S0_L);
    and (w2, QD, S1_L, S0_L);
    and (w3, D, S1_H, S0_H);
    and (w4, QC, S1_L, S0_H);
    or  (w5, w1, w2, w3, w4);
    
    // ʹ�ô������洢 QD ��״̬
    Vr74x74 u3 (CLK_D, w5, 1'b1, CLR_L_D, QD, QDN);
    
    and (w6, QD, S1_H, S0_L);
    and (w7, QC, S1_L, S0_L);
    and (w8, C, S1_H, S0_H);
    and (w9, QB, S1_L, S0_H);
    or  (w10, w6, w7, w8, w9);
    
    // ʹ�ô������洢 QC ��״̬
    Vr74x74 u2 (CLK_D, w10, 1'b1, CLR_L_D, QC, QCN);
    
    and (w11, QC, S1_H, S0_L);
    and (w12, QB, S1_L, S0_L);
    and (w13, B, S1_H, S0_H);
    and (w14, QA, S1_L, S0_H);
    or  (w15, w11, w12, w13, w14);
    
    // ʹ�ô������洢 QB ��״̬
    Vr74x74 u1 (CLK_D, w15, 1'b1, CLR_L_D, QB, QBN);
    
    and (w16, QB, S1_H, S0_L);
    and (w17, QA, S1_L, S0_L);
    and (w18, A, S1_H, S0_H);
    and (w19, RIN, S1_L, S0_H);
    or  (w20, w16, w17, w18, w19);
    
    // ʹ�ô������洢 QA ��״̬
    Vr74x74 u0 (CLK_D, w20, 1'b1, CLR_L_D, QA, QAN);
    
endmodule
