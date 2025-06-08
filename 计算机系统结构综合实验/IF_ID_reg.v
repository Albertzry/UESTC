`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 09:06:57
// Design Name: 
// Module Name: IF_ID_reg
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


module IF_ID_reg(if_pc4, if_inst, clk, clrn, stall, id_pc4, id_inst);
    input [31:0] if_pc4, if_inst;
    input clk, clrn, stall;
    output [31:0] id_pc4, id_inst;
    
    reg [31:0] id_pc4, id_inst;
    always @ (posedge clk or negedge clrn)
        if(clrn == 0)
            begin
                id_pc4 <= 0;
                id_inst <= 0;
            end
        else if(~stall)
            begin
                id_pc4 <= if_pc4;
                id_inst <= if_inst;
            end
        else
            begin
                id_pc4 <= id_pc4;
                id_inst <= id_inst;
            end
endmodule
