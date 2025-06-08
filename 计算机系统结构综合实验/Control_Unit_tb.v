`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 19:11:59
// Design Name: 
// Module Name: Control_Unit_tb
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


`timescale 1ns / 1ps

module tb_Control_Unit;

	// ���������ź�
	reg rsrtequ;
	reg [5:0] func, op;

	// ��������ź�
	wire wreg, m2reg, wmem, regrt, aluimm, sext, shift;
	wire [2:0] aluc;
	wire [1:0] pcsource;

	// ʵ����Ҫ���Ե�ģ��
	Control_Unit uut (
		.rsrtequ(rsrtequ),
		.func(func),
		.op(op),
		.wreg(wreg),
		.m2reg(m2reg),
		.wmem(wmem),
		.aluc(aluc),
		.regrt(regrt),
		.aluimm(aluimm),
		.sext(sext),
		.pcsource(pcsource),
		.shift(shift)
	);

	initial begin
		// ��ʼ�������ź�
		rsrtequ = 0;
		func = 6'b000000;
		op = 6'b000000;
        #100;
		// ��������1��beqָ��������㣨rsrtequ=1��
		op = 6'b001111; 
		rsrtequ = 1;
		#100;
		// ��������2��bneָ��������㣨rsrtequ=0��
		op = 6'b010000; 
		rsrtequ = 0;
		#100;
		// ��������3��addָ��
		op = 6'b000000; 
		func = 6'b000001; 
		#100;
		// ��������4��andiָ��
		op = 6'b001001; 
		#100;
		// ��������5��loadָ��
		op = 6'b001101;
		#100;
		// ��������6��storeָ��
		op = 6'b001110; 
		#100;
		// ��������7��jumpָ��
		op = 6'b010010; 
		#100;
	end


endmodule
