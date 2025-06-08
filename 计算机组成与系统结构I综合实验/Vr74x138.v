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
    E1, E2, E3,  // 使能输入信号
    A, B, C,     // 地址输入信号
    Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7  // 输出信号
    );
    
    // 输入信号
    input E1, E2, E3;
    input A, B, C; 
    
    // 输出信号
    output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7; 
    
    // 内部信号
    wire enable; // 使能信号
    wire A_bar, B_bar, C_bar; // 地址信号的非值
    
    // 使能逻辑：只有当E1=1，E2=0，E3=0时，译码器才被激活
    and (enable, ~E2, ~E3, E1);

    not (A_bar, A); // A的非
    not (B_bar, B); // B的非
    not (C_bar, C); // C的非
    
    nand (Y0, enable, A_bar, B_bar, C_bar); // 地址000时激活
    nand (Y1, enable, A_bar, B_bar, C);     // 地址001时激活
    nand (Y2, enable, A_bar, B, C_bar);     // 地址100时激活
    nand (Y3, enable, A_bar, B, C);         // 地址011时激活
    nand (Y4, enable, A, B_bar, C_bar);     // 地址100时激活
    nand (Y5, enable, A, B_bar, C);         // 地址101时激活
    nand (Y6, enable, A, B, C_bar);         // 地址110时激活
    nand (Y7, enable, A, B, C);             // 地址111时激活
endmodule
