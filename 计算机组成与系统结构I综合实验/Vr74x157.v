`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 09:05:28
// Design Name: 
// Module Name: Vr74x157
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


module Vr74x157 (
     E, S, 
     A0, A1, A2, A3, 
     B0, B1, B2, B3, 
     Y0, Y1, Y2, Y3 
);
    input E, S; // 选择信号
    input A0, A1, A2, A3;// 输入总线 A
    input B0, B1, B2, B3; // 输入总线 B
    output  Y0, Y1, Y2, Y3; // 输出
    
    wire S_bar, E_bar;
    wire y0_a, y0_b, y1_a, y1_b, y2_a, y2_b, y3_a, y3_b;
    and (E_bar,~E,~S);
    and (S_bar,~E,S);
    // Y0 实现
    and (y0_a,A0,E_bar);
    and (y0_b,B0,S_bar);
    or (Y0,y0_a,y0_b);
    // Y1 实现
    and (y1_a,A1,E_bar);
    and (y1_b,B1,S_bar);
    or (Y1,y1_a,y1_b);
    // Y2 实现
    and (y2_a,A2,E_bar);
    and (y2_b,B2,S_bar);
    or (Y2,y2_a,y2_b);   
    // Y3 实现
    and (y3_a,A3,E_bar);
    and (y3_b,B3,S_bar);
    or (Y3,y3_a,y3_b);

endmodule
