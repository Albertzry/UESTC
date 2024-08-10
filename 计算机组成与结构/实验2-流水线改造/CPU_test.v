`timescale 10ns/10ns
module CPU_test;
reg Clk,En,Clrn;
wire[31:0] IF_ADDR,EX_R,EX_X,EX_Y;
initial begin 
Clk=0;
Clrn=0;
En=1;
#10
Clrn<=1;
end
always #10 Clk=~Clk;
CPU CPU_test(
.Clk(Clk),
.En(En),
.Clrn(Clrn),
.IF_ADDR(IF_ADDR),
.EX_R(EX_R),
.EX_X(EX_X),
.EX_Y(EX_Y));
endmodule
