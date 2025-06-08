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

    // ���������ź�
    reg CLK, CLR_L, LIN, RIN, S1, S0, A, B, C, D;

    // ��������ź�
    wire QA, QB, QC, QD;

    // ʵ���� Vr74x194 ģ��
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

    // ʱ���ź�����
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // ��������Ϊ 10 ��ʱ���ź�
    end
    
    // ��ʼ�����Թ���
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

        #10 CLR_L = 0;  // ͬ����λ
        #10 CLR_L = 1;  // ȡ����λ

        #10 S1 = 1; S0 = 1; 
        A = 1; B = 0; C = 1; D = 0;  // �������� 1010
        
        #10 S1 = 0; S0 = 0;
          
        #10 S1 = 0; S0 = 1;  // ����ģʽ
        LIN = 1;  // ��������ʹ��
        #10 LIN = 0;  // ������������

        #10 S1 = 1; S0 = 0;  // ����ģʽ
        RIN = 1;  // ��������ʹ��
        #10 RIN = 0;  // ������������

        #10 $finish;
    end

endmodule
