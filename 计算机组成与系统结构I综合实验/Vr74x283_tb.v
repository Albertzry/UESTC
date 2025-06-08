`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 09:31:28
// Design Name: 
// Module Name: Vr74x283_tb
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


module Vr74x283_tb;

    // 输入信号
    reg A0, A1, A2, A3;
    reg B0, B1, B2, B3;
    reg CI;

    // 输出信号
    wire S0, S1, S2, S3;
    wire CO;

    // 实例化被测试模块
    Vr74x283 uut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B0(B0),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .CI(CI),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .CO(CO)
    );

    // 产生测试激励
    initial begin
        // 初始化输入
        A0 = 0; A1 = 0; A2 = 0; A3 = 0;
        B0 = 0; B1 = 0; B2 = 0; B3 = 0;
        CI = 0;

        // 测试不同的输入组合
        #10 CI = 0; A0 = 0; A1 = 0; A2 = 0; A3 = 0; B0 = 0; B1 = 0; B2 = 0; B3 = 0;
        #10 CI = 0; A0 = 1; A1 = 1; A2 = 1; A3 = 1; B0 = 1; B1 = 1; B2 = 1; B3 = 1;
        #10 CI = 1; A0 = 1; A1 = 1; A2 = 1; A3 = 1; B0 = 1; B1 = 1; B2 = 1; B3 = 1;
        #10 CI = 0; A0 = 1; A1 = 0; A2 = 1; A3 = 0; B0 = 1; B1 = 1; B2 = 0; B3 = 1;
        #10 CI = 1; A0 = 1; A1 = 0; A2 = 1; A3 = 0; B0 = 1; B1 = 1; B2 = 0; B3 = 1;
        #10
        $stop;
    end

endmodule
