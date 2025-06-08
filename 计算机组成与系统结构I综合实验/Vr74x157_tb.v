`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 09:17:22
// Design Name: 
// Module Name: Vr74x157_tb
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


module Vr74x157_tb;

    // 输入信号
    reg E;
    reg S;
    reg A0, A1, A2, A3;
    reg B0, B1, B2, B3;

    // 输出信号
    wire Y0, Y1, Y2, Y3;

    // 实例化被测试模块
    Vr74x157 uut (
        .E(E),
        .S(S),
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );

    initial begin
        E = 1; S = 0;
        A0 = 0; A1 = 1; A2 = 0; A3 = 1;
        B0 = 1; B1 = 0; B2 = 1; B3 = 0;
        
        #10
        E=0;S=0;
        #10
        E=0;S=1;
        #10
        $stop;
    end

endmodule
