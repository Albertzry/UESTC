`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 09:43:49
// Design Name: 
// Module Name: Vr74x163_tb
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

module Vr74x163_tb;

    reg CLK;
    reg CLR_L;
    reg LD_L;
    reg ENP;
    reg ENT;
    reg [3:0] D;
    wire [3:0] Q;
    wire RCO;

    Vr74x163 uut (
        .CLK(CLK),
        .CLR_L(CLR_L),
        .LD_L(LD_L),
        .ENP(ENP),
        .ENT(ENT),
        .D(D),
        .Q(Q),
        .RCO(RCO)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK; // 时钟周期为10ns（5ns上升沿，5ns下降沿）
    end

    // 测试进程
    initial begin
        CLR_L = 1;
        LD_L = 1;  
        ENP = 0;  
        ENT = 0;   
        D = 4'b0000; 
        
        #10; 
        CLR_L = 0; // 激活异步清零信号，将计数器清零
        #10; 
        CLR_L = 1; // 释放异步清零信号
        
        LD_L = 0; // 激活并行加载信号
        D = 4'b1010; // 同步置数1010
        #10; 
        LD_L = 1; 
        
        // 让计数器进行递增计数
        ENP = 1;
        ENT = 1; 
        #50;
        
        ENP = 0; // 禁止计数
        #10 ENT = 0; // 禁止计数
   
        $finish; 
    end

endmodule