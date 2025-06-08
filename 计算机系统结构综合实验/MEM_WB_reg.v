`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 09:04:53
// Design Name: 
// Module Name: MEM_WB_reg
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


module MEM_WB_reg(
    clk, clrn,
    mem_m2reg, mem_wreg, mem_rn, mem_mo, mem_alu_result,
    wb_m2reg, wb_wreg, wb_rn, wb_mo, wb_alu_result
);
    input clk, clrn;
    input mem_m2reg, mem_wreg;
    input [4:0] mem_rn;
    input [31:0] mem_mo, mem_alu_result;

    output wb_m2reg, wb_wreg;
    output [4:0] wb_rn;
    output [31:0] wb_mo, wb_alu_result;

    reg wb_m2reg, wb_wreg;
    reg [4:0] wb_rn;
    reg [31:0] wb_mo, wb_alu_result;

    always @ (negedge clrn or posedge clk)
        if (clrn == 0)
            begin
                wb_m2reg <= 0;
                wb_wreg <= 0;
                wb_rn <= 0;
                wb_mo <= 0;
                wb_alu_result <= 0;
            end
        else
            begin
                wb_m2reg <= mem_m2reg;
                wb_wreg <= mem_wreg;
                wb_rn <= mem_rn;
                wb_mo <= mem_mo;
                wb_alu_result <= mem_alu_result;
            end
endmodule
