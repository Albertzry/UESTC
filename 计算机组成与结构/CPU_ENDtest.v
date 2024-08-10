`timescale 10ns/10ns
module CPU_END_TEST();
reg Clk,Clrn,Reset;
initial begin
Clk=0;
Clrn=1;
Reset=1;
end
always #10 Clk=~Clk;



CPU_END CPU_END_TEST (
.Clk(Clk),
.Reset(Reset),
.Clrn(Clrn));
endmodule 
