`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 09:23:35
// Design Name: 
// Module Name: Vr74x283
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


module Vr74x283 (
    A0, A1, A2, A3, // 加数
    B0, B1, B2, B3, // 被加数
    CI,              // 进位输入
    S0, S1, S2, S3, // 和输出
    CO              // 进位输出
);
    // 输入信号
    input  A0, A1, A2, A3;
    input  B0, B1, B2, B3;
    input  CI;
    // 输出信号
    output  S0, S1, S2, S3;
    output  CO;
    
    wire CO0,CO1,CO2,CO3;
    // 实例化4位全加器
    full_adder fa0 (A0, B0, CI, S0, CO0);
    full_adder fa1 (A1, B1, CO0, S1, CO1);
    full_adder fa2 (A2, B2, CO1, S2, CO2);
    full_adder fa3 (A3, B3, CO2, S3, CO3);
    // 进位输出
    assign CO = CO3;
endmodule

// 1位全加器模块
module full_adder
    (
        a, b, cin,
        sum, cout		
    );
    input a,b,cin;
    output sum,cout;
    
	assign sum = a^b^cin;
	assign cout = (a&b)|((a^b)&cin);
endmodule

