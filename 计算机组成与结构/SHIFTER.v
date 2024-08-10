module SHIFTER26_L2(in,add,out);
input [25:0] in;
input [3:0]add;
output [31:0]out;
wire[27:0] internal;
assign internal=(in<<2);
assign out={add,internal};
endmodule
