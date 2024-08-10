module CPU_END(Clk,Clrn,Reset);
input Clk,Clrn,Reset;
wire	[31:0]Inst,Dread;
wire [31:0] Iaddr,Daddr,Dwrite;
wire Wmem;
CPU cpu(Inst,Clrn,Clk,Iaddr,Dread,Wmem,Daddr,Dwrite,Reset);
DATAMEM datamem(Daddr,Dwrite,Clk,Wmem,Dread);
INSTMEM instmem(Iaddr,Inst);
endmodule 
