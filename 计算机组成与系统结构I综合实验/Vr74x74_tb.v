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

    // ʱ���ź�����
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // ��������Ϊ 10 ��ʱ���ź�
    end

    // ��ʼ�����Թ���
    initial begin
        // ��ʼ�������ź�
        PR_L = 1;
        CLR_L = 1;
        D = 0;

        // Ӧ�ò�ͬ�Ĳ��Լ���
        #10 PR_L = 0;  // ��λ���������͵�ƽ��Ч��
        #10 PR_L = 1;  // ȡ����λ

        #10 CLR_L = 0;  // ��λ���������͵�ƽ��Ч��
        #10 CLR_L = 1;  // ȡ����λ

        #10 D = 1;  // ��ʱ������������ D Ϊ 1
        #10 D = 0;  // ��ʱ������������ D Ϊ 0

        // ��������
        #20 $finish;
    end


endmodule
