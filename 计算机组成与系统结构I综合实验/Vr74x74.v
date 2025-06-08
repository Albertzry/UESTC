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
    CLK, D, PR_L, CLR_L,  // 输入信号
    Q, QN  // 输出信号
);

    input CLK, D, PR_L, CLR_L; 
    output Q, QN;  
    reg Q;  
    
    //时钟上升沿、置位或复位信号的下降沿触发
    always @(posedge CLK or negedge PR_L or negedge CLR_L) 
    begin
        //电平触发
        if (PR_L == 0) 
            Q <= 1;  
        // 复位
        else if (CLR_L == 0) 
            Q <= 0;  // 复位
        // 无置位或复位操作时，在时钟上升沿更新数据
        else 
            Q <= D;  
    end
    
    // 生成反向输出 QN
    nor (QN, Q); 

endmodule
