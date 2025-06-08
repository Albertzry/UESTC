`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:35:36
// Design Name: 
// Module Name: Vr74x163
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


module Vr74x163 (CLK, CLR_L, LD_L, ENP, ENT, D, Q, RCO      
);
    input CLK, CLR_L, LD_L, ENP, ENT;   
    input [3:0] D;                       
    output [3:0] Q;                      
    output RCO;                          

    reg [3:0] Q;     
    reg RCO;         

    // ��ʱ�������ش�����ͬ������
    always @(posedge CLK) begin
        // ��� CLR_L Ϊ�͵�ƽ���� Q ����
        if (CLR_L == 0)
            Q <= 4'b0; 
        // ������� LD_L Ϊ�͵�ƽ���� Q ����Ϊ���� D ��ֵ
        else if (LD_L == 0)
            Q <= D; 
        // ������� ENP �� ENT ��Ϊ�ߵ�ƽ���� Q ���� 1
        else if ((ENT == 1) && (ENP == 1))
            Q <= Q + 1;
        // ���򣬱��� Q ��ֵ����
        else
            Q <= Q;
    end

    // �۲� Q �� ENT �ı仯������ RCO
    always @(Q or ENT) begin
        // ��� ENT Ϊ�ߵ�ƽ������ Q ��ֵΪ 15�������������ֵ������ RCO ����ߵ�ƽ����������͵�ƽ
        if ((ENT == 1) && (Q == 4'd15))
            RCO = 1;
        else
            RCO = 0;
    end

endmodule
