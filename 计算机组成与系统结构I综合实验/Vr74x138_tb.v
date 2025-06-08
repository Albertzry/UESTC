`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/18 08:44:56
// Design Name: 
// Module Name: Vr74x138_tb
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


module Vr74x138_tb;

    reg E1, E2, E3;
    reg A, B, C;

    wire Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7;

    Vr74x138 uut (
        .E1(E1),
        .E2(E2),
        .E3(E3),
        .A(A),
        .B(B),
        .C(C),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3),
        .Y4(Y4),
        .Y5(Y5),
        .Y6(Y6),
        .Y7(Y7)
    );

    initial begin
        E1=0;E2=0;E3=0;
        A = 0; B = 0; C = 0;
        #10 E2=1;
        #10 E3=1;
        #10 E1=1;E2=0;E3=0;
        #10 A = 0; B = 0; C = 1;
        #10 A = 0; B = 1; C = 0;
        #10 A = 0; B = 1; C = 1;
        #10 A = 1; B = 0; C = 0;
        #10 A = 1; B = 0; C = 1;
        #10 A = 1; B = 1; C = 0;
        #10 A = 1; B = 1; C = 1;
        $stop;
    end

endmodule
