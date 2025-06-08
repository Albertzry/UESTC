`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 08:42:46
// Design Name: 
// Module Name: Vr74x138
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

module Vr74x138(
    E1, E2, E3,  // ʹ�������ź�
    A, B, C,     // ��ַ�����ź�
    Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7  // ����ź�
    );
    
    // �����ź�
    input E1, E2, E3;
    input A, B, C; 
    
    // ����ź�
    output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7; 
    
    // �ڲ��ź�
    wire enable; // ʹ���ź�
    wire A_bar, B_bar, C_bar; // ��ַ�źŵķ�ֵ
    
    // ʹ���߼���ֻ�е�E1=1��E2=0��E3=0ʱ���������ű�����
    and (enable, ~E2, ~E3, E1);

    not (A_bar, A); // A�ķ�
    not (B_bar, B); // B�ķ�
    not (C_bar, C); // C�ķ�
    
    nand (Y0, enable, A_bar, B_bar, C_bar); // ��ַ000ʱ����
    nand (Y1, enable, A_bar, B_bar, C);     // ��ַ001ʱ����
    nand (Y2, enable, A_bar, B, C_bar);     // ��ַ100ʱ����
    nand (Y3, enable, A_bar, B, C);         // ��ַ011ʱ����
    nand (Y4, enable, A, B_bar, C_bar);     // ��ַ100ʱ����
    nand (Y5, enable, A, B_bar, C);         // ��ַ101ʱ����
    nand (Y6, enable, A, B, C_bar);         // ��ַ110ʱ����
    nand (Y7, enable, A, B, C);             // ��ַ111ʱ����
endmodule
