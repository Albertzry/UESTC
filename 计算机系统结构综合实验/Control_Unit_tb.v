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

	// 定义输入信号
	reg rsrtequ;
	reg [5:0] func, op;

	// 定义输出信号
	wire wreg, m2reg, wmem, regrt, aluimm, sext, shift;
	wire [2:0] aluc;
	wire [1:0] pcsource;

	// 实例化要测试的模块
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
		// 初始化输入信号
		rsrtequ = 0;
		func = 6'b000000;
		op = 6'b000000;
        #100;
		// 测试用例1：beq指令，条件满足（rsrtequ=1）
		op = 6'b001111; 
		rsrtequ = 1;
		#100;
		// 测试用例2：bne指令，条件满足（rsrtequ=0）
		op = 6'b010000; 
		rsrtequ = 0;
		#100;
		// 测试用例3：add指令
		op = 6'b000000; 
		func = 6'b000001; 
		#100;
		// 测试用例4：andi指令
		op = 6'b001001; 
		#100;
		// 测试用例5：load指令
		op = 6'b001101;
		#100;
		// 测试用例6：store指令
		op = 6'b001110; 
		#100;
		// 测试用例7：jump指令
		op = 6'b010010; 
		#100;
	end


endmodule
