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

    // 在时钟上升沿触发的同步操作
    always @(posedge CLK) begin
        // 如果 CLR_L 为低电平，则将 Q 清零
        if (CLR_L == 0)
            Q <= 4'b0; 
        // 否则，如果 LD_L 为低电平，则将 Q 加载为输入 D 的值
        else if (LD_L == 0)
            Q <= D; 
        // 否则，如果 ENP 和 ENT 都为高电平，则将 Q 增加 1
        else if ((ENT == 1) && (ENP == 1))
            Q <= Q + 1;
        // 否则，保持 Q 的值不变
        else
            Q <= Q;
    end

    // 观察 Q 或 ENT 的变化来更新 RCO
    always @(Q or ENT) begin
        // 如果 ENT 为高电平，并且 Q 的值为 15（即计数到最大值），则 RCO 输出高电平，否则输出低电平
        if ((ENT == 1) && (Q == 4'd15))
            RCO = 1;
        else
            RCO = 0;
    end

endmodule
