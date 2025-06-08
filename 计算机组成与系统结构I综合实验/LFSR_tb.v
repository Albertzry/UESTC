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

    // ���������ʹ�õ��ź�
    reg CLK;
    reg RESET;
    wire X2, X1, X0;

    // ʵ��������ģ�� LFSR
    LFSR uut (
        .CLK(CLK),
        .RESET(RESET),
        .X2(X2),
        .X1(X1),
        .X0(X0)
    );

    // ����ʱ���źţ�����Ϊ 10ns��5ns �����أ�5ns �½��أ�
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

 initial begin 
      // ��ʼ�� 
      CLK = 0; 
      RESET = 1; 
     
      // �ȴ�20ns
      #20; 
               
      RESET = 0 ; 
      #20 $finish;
 end 


endmodule
