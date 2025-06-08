`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 08:31:21
// Design Name: 
// Module Name: Vr74x74
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


module Vr74x74( 
    CLK, D, PR_L, CLR_L,  // �����ź�
    Q, QN  // ����ź�
);

    input CLK, D, PR_L, CLR_L; 
    output Q, QN;  
    reg Q;  
    
    //ʱ�������ء���λ��λ�źŵ��½��ش���
    always @(posedge CLK or negedge PR_L or negedge CLR_L) 
    begin
        //��ƽ����
        if (PR_L == 0) 
            Q <= 1;  
        // ��λ
        else if (CLR_L == 0) 
            Q <= 0;  // ��λ
        // ����λ��λ����ʱ����ʱ�������ظ�������
        else 
            Q <= D;  
    end
    
    // ���ɷ������ QN
    nor (QN, Q); 

endmodule
