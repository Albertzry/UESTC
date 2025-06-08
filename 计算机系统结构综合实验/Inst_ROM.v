`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:27 05/15/2019 
// Design Name: 
// Module Name:    Inst_ROM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Inst_ROM(a,inst
    );
	 input [5:0] a;
	 output [31:0] inst;
	 wire [31:0] rom [0:63];
	 
      assign rom[6'h00] = 32'h 00000000;
      assign rom[6'h01]=32'h 00100443;    //add r1,r2,r3
      assign rom[6'h02]=32'h 28000824;    //ori r4,r1,2
      assign rom[6'h03]=32'h 34000825;    //load r5,r1(2)
      assign rom[6'h04]=32'h 38000c45;    //store r5,r2(3)
      assign rom[6'h05]=32'h 40002485;    //bne r4,r5,6'h09
      assign rom[6'h06]=32'h 08208c02;    //srl r3,r2,1
      assign rom[6'h07]=32'h 08319003;    //sll r4,r3,3
      assign rom[6'h08]=32'h 3c000888;    //beq r4,r8,2
      assign rom[6'h09]=32'h 14001c89;    //addi r9,r4,7
      assign rom[6'h0A]=32'h 04102125;    //and r8,r9,r5
      assign rom[6'h0B]=32'h 4800000E;    //jump 0x000000E
      assign rom[6'h0C]=32'h 00000000;
      assign rom[6'h0D]=32'h 00000000;
      assign rom[6'h0E]=32'h 04401423;    //xor r5,r1,r3
      assign rom[6'h0F]=32'h 04101822;    //and r6,r1,r2
      assign rom[6'h10]=32'h 40002485;    //bne r4,r5,6'h09
      assign rom[6'h11] = 32'h00000000;  
      assign rom[6'h12] = 32'h00000000;  
      assign rom[6'h13] = 32'h00000000;  
      assign rom[6'h14] = 32'h00000000;   
      assign rom[6'h15] = 32'h00000000;   
      assign rom[6'h16] = 32'h00000000; 
      assign rom[6'h17] = 32'h00000000;  
      assign rom[6'h18]=32'h00000000;
      assign rom[6'h19]=32'h00000000;
      assign rom[6'h1A]=32'h00000000;
      assign rom[6'h1B]=32'h00000000;
      assign rom[6'h1C]=32'h00000000;
      assign rom[6'h1D]=32'h00000000;
      assign rom[6'h1E]=32'h00000000;
      assign rom[6'h1F]=32'h00000000;
      assign rom[6'h20]=32'h00000000;
      assign rom[6'h21]=32'h00000000;
      assign rom[6'h22]=32'h00000000;     
      assign rom[6'h23]=32'h00000000;
      assign rom[6'h24]=32'h00000000;
      assign rom[6'h25]=32'h00000000;
      assign rom[6'h26]=32'h00000000;
      assign rom[6'h27]=32'h00000000;
      assign rom[6'h28]=32'h00000000;
      assign rom[6'h29]=32'h00000000;
      assign rom[6'h2A]=32'h00000000;
      assign rom[6'h2B]=32'h00000000;
      assign rom[6'h2C]=32'h00000000;
      assign rom[6'h2D]=32'h00000000;
      assign rom[6'h2E]=32'h00000000;
      assign rom[6'h2F]=32'h00000000;
      assign rom[6'h30]=32'h00000000;
      assign rom[6'h31]=32'h00000000;
      assign rom[6'h32]=32'h00000000;
      assign rom[6'h33]=32'h00000000;
      assign rom[6'h34]=32'h00000000;
      assign rom[6'h35]=32'h00000000;
      assign rom[6'h36]=32'h00000000;
      assign rom[6'h37]=32'h00000000;
      assign rom[6'h38]=32'h00000000;
      assign rom[6'h39]=32'h00000000;
      assign rom[6'h3A]=32'h00000000;
      assign rom[6'h3B]=32'h00000000;
      assign rom[6'h3C]=32'h00000000;
      assign rom[6'h3D]=32'h00000000;
      assign rom[6'h3E]=32'h00000000;
      assign rom[6'h3F]=32'h00000000;

	 assign inst=rom[a];
endmodule
