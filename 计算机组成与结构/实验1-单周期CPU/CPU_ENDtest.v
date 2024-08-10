`timescale 10ns/10ns
module CPU_END_TEST();
reg Clk,Clrn,Reset,En;
initial begin
Clk=0;
Clrn=0;
Reset=1;
En=1;
#10 Clrn<=1;

end

always #10 Clk=~Clk;



CPU_END CPU_END_TEST (
.Clk(Clk),
.Reset(Reset),
.En(En),
.Clrn(Clrn));
endmodule 
