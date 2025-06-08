`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:56:07
// Design Name: 
// Module Name: clk_10_div
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


module clk_10_div(
    input clk,      
    input rst_n,     
    output reg clk_div 
);
    reg [3:0] cnt;  

    always @(posedge clk or negedge rst_n) begin
        // �����λ�ź���Ч���͵�ƽ�������������ͷ�Ƶʱ�Ӹ�λ
        if (!rst_n) begin
            cnt     <= 4'd0;   // ����������
            clk_div <= 1'b0;   // ��Ƶʱ�ӳ�ʼΪ�͵�ƽ
        end
        // ���������δ�ﵽ�����ڼ���ֵ��10/2 - 1 = 4������������
        else if (cnt < 4) begin
            cnt     <= cnt + 1'b1; // �������� 1
            clk_div <= clk_div;    // ��Ƶʱ�ӱ��ֵ�ǰ״̬
        end
        // ���������ﵽ�����ڼ���ֵʱ�����ü���������ת��Ƶʱ��
        else begin
            cnt     <= 4'd0;   // ����������
            clk_div <= ~clk_div; // ��Ƶʱ��ȡ����ʵ��Ƶ�ʳ��� 10��
        end
    end

endmodule
