module PC(Clk,Reset,Result,Address);  
input Clk;
input Reset;  
input[31:0] Result;
output reg[31:0] Address;
initial begin
Address  <= 0;
end
always @(posedge Clk or negedge Reset)
begin  
if (!Reset)
begin  
Address <= 0;  
end  
else   
begin
Address =  Result;  
end  
end  
endmodule
