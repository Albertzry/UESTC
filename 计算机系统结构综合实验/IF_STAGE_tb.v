`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 17:52:40
// Design Name: 
// Module Name: IF_STAGE_tb
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

module tb_IF_STAGE;

	// 定义输入信号
	reg clk;
	reg clrn;
	reg [1:0] pcsource;
	reg [31:0] bpc;
	reg [31:0] jpc;
	
	// 定义输出信号
	wire [31:0] pc4;
	wire [31:0] inst;
	wire [31:0] PC;
	
	// 实例化要测试的模块
	IF_STAGE uut (
		.clk(clk),
		.clrn(clrn),
		.pcsource(pcsource),
		.bpc(bpc),
		.jpc(jpc),
		.pc4(pc4),
		.inst(inst),
		.PC(PC)
	);
	always #50 clk = ~clk;
	initial begin
		clk=0;
		clrn = 0;
		pcsource = 0;
		bpc  =32'h32;
		jpc = 32'h54;
		#100
		clrn = 1;
		#100
		pcsource = 01;
		#100
		pcsource = 10;
		#100
		pcsource = 11;
	end
    
endmodule