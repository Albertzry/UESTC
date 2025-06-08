`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/06 18:21:38
// Design Name: 
// Module Name: SCCPU_tb
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

module tb_SCCPU;

    // Inputs
   reg Clock;
   reg Resetn;
   // Outputs
   wire stall;
   wire [1:0] pcsource;
   wire [31:0] PC;
   wire [31:0] if_inst;
   wire [31:0] id_inst;
   wire [31:0] exe_alu_result;
   wire [31:0] mem_alu_result;
   wire [31:0] wb_alu_result;
   wire [31:0] bpc,jpc;

   // Instantiate the SCCPU module
   SCCPU uut (
       .Clock(Clock),
       .Resetn(Resetn),
       .pcsource(pcsource),
       .PC(PC),
       .if_inst(if_inst),
       .id_inst(id_inst),
       .exe_alu_result(exe_alu_result),
       .mem_alu_result(mem_alu_result),
       .wb_alu_result(wb_alu_result),
       .stall(stall),
       .bpc(bpc),
       .jpc(jpc)
   );


	always #50 Clock = ~Clock;
	initial begin
		Clock = 0; 
		Resetn = 0; 
		#50; 
		Resetn = 1; 
	end

endmodule
