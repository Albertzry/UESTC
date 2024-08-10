module ALU(X,Y,Aluc,R,Z);
input[31:0]X,Y;
input[3:0]Aluc;
output[31:0]R;
output Z;
wire[31:0]d_as,d_and,d_or,d_xor,d_lui,d_sh,d;
wire cout;
 ADDSUB_32 as32(X,Y,Aluc[0],d_as,cout);
assign d_and=X&Y;
assign d_or=X|Y;
assign d_xor=X^Y;
assign d_lui={Y[15:0],16'h0};
SHIFTER shift(Y,X[10:6],Aluc[3],Aluc[1],d_sh);
MUX6X32 select(d_and,d_or,d_xor,d_lui,d_sh,d_as,Aluc[3:0],R);
assign Z=~|R;
endmodule

module SHIFTER(X,Sa,Arith,Right,Sh);
input [31:0]X;
input [4:0]Sa;
input Arith,Right;
output [31:0]Sh;
wire [31:0]T4,T3,T2,T1,T0,S4,S3,S2,S1;
wire a=X[31]&Arith;
wire [15:0]e={16{a}};
parameter z=16'b0000000000000000;
wire [31:0]L1u,L1d,L2u,L2d,L3u,L3d,L4u,L4d,L5u,L5d;
assign L1u={X[15:0],z[15:0]};
assign L1d={e,X[31:16]};
MUX2X32 M1l(L1u,L1d,Right,T4);
MUX2X32 M1r(X,T4,Sa[4],S4);
assign L2u={S4[23:0],z[7:0]};
assign L2d={e[7:0],S4[31:8]};
MUX2X32 M2l(L2u,L2d,Right,T3);
MUX2X32 M2r(S4,T3,Sa[3],S3);
assign L3u={S3[27:0],z[3:0]};
assign L3d={e[3:0],S3[31:4]};
MUX2X32 M3l(L3u,L3d,Right,T2);
MUX2X32 M3r(S3,T2,Sa[2],S2);
assign L4u={S2[29:0],z[1:0]};
assign L4d={e[1:0],S2[31:2]};
MUX2X32 M4l(L4u,L4d,Right,T1);
MUX2X32 M4r(S2,T1,Sa[1],S1);
assign L5u={S1[30:0],z[0]};
assign L5d={e[0],S1[31:1]};
MUX2X32 M5l(L5u,L5d,Right,T0);
MUX2X32 M5r(S1,T0,Sa[0],Sh);
endmodule

module MUX2X32(A0,A1,S,Y);
input [31:0]A0,A1;
input S;
output [31:0]Y;
function [31:0]select;
input [31:0]A0,A1;
input S;
case(S)
1'b0:select=A0;
1'b1:select=A1;
endcase
endfunction
assign Y = select(A0,A1,S);
endmodule

module MUX6X32(d_and,d_or,d_xor,d_lui,d_sh,d_as,Aluc,d);
input [31:0]d_and,d_or,d_xor,d_lui,d_sh,d_as;
input [3:0]Aluc;
output [31:0]d;
function [31:0]select;
input [31:0]d_and,d_or,d_xor,d_lui,d_sh,d_as;
input [3:0]Aluc;
case(Aluc)
4'b0000:select=d_as;
4'b0001:select=d_as;
4'b0010:select=d_and;
4'b0011:select=d_or;
4'b0100:select=d_xor;
4'b0110:select=d_lui;
4'b0101:select=d_sh;
4'b0111:select=d_sh;
4'b1111:select=d_sh;
4'b1101:select=d_sh;
endcase
endfunction
assign d=select(d_and,d_or,d_xor,d_lui,d_sh,d_as,Aluc);
endmodule
module ADDSUB_32(X, Y, Sub, S, Cout);
input [31:0] X;
input [31:0] Y; 
input Sub;
output [31:0] S;
output Cout;
CLA_32 adder0 (X, Y^{32{Sub}}, Sub, S, Cout);  
endmodule

module CLA_32(X, Y, Cin, S, Cout);
input [31:0] X, Y; 
input Cin;   
output [31:0] S;
output Cout;
wire Cout0, Cout1, Cout2, Cout3, Cout4, Cout5, Cout6;    
CLA_4 add0 (X[3:0], Y[3:0], Cin, S[3:0], Cout0);
CLA_4 add1 (X[7:4], Y[7:4], Cout0, S[7:4], Cout1);
CLA_4 add2 (X[11:8], Y[11:8], Cout1, S[11:8], Cout2);
CLA_4 add3 (X[15:12], Y[15:12], Cout2, S[15:12], Cout3);
CLA_4 add4 (X[19:16], Y[19:16], Cout3, S[19:16], Cout4);
CLA_4 add5 (X[23:20], Y[23:20], Cout4, S[23:20], Cout5);
CLA_4 add6 (X[27:24], Y[27:24], Cout5, S[27:24], Cout6);
CLA_4 add7 (X[31:28], Y[31:28], Cout6, S[31:28], Cout);
endmodule 

module CLA_4(X, Y, Cin, S, Cout);
input [3:0] X;
input [3:0] Y;
input Cin;
output [3:0] S;
output Cout;
and get_0_0_0(tmp_0_0_0, X[0], Y[0]);
or get_0_0_1(tmp_0_0_1, X[0], Y[0]);
and get_0_1_0(tmp_0_1_0, X[1], Y[1]);
or get_0_1_1(tmp_0_1_1, X[1], Y[1]);
and get_0_2_0(tmp_0_2_0, X[2], Y[2]);
or get_0_2_1(tmp_0_2_1, X[2], Y[2]);
and get_0_3_0(tmp_0_3_0, X[3], Y[3]);
or get_0_3_1(tmp_0_3_1, X[3], Y[3]);
and get_1_0_0(tmp_1_0_0, ~tmp_0_0_0, tmp_0_0_1);
xor getS0(S0, tmp_1_0_0, Cin);
and get_1_1_0(tmp_1_1_0, ~tmp_0_1_0, tmp_0_1_1);
not get_1_1_1(tmp_1_1_1, tmp_0_0_0);
nand get_1_1_2(tmp_1_1_2, Cin, tmp_0_0_1);
nand get_2_0_0(tmp_2_0_0, tmp_1_1_1, tmp_1_1_2);
xor getS1(S1, tmp_1_1_0, tmp_2_0_0);
and get_1_2_0(tmp_1_2_0, ~tmp_0_2_0, tmp_0_2_1);
not get_1_2_1(tmp_1_2_1, tmp_0_1_0);
nand get_1_2_2(tmp_1_2_2, tmp_0_1_1, tmp_0_0_0);
nand get_1_2_3(tmp_1_2_3, tmp_0_1_1, tmp_0_0_1, Cin);
nand get_2_1_0(tmp_2_1_0, tmp_1_2_1, tmp_1_2_2, tmp_1_2_3);
xor getS2(S2, tmp_1_2_0, tmp_2_1_0);
and get_1_3_0(tmp_1_3_0, ~tmp_0_3_0, tmp_0_3_1);
not get_1_3_1(tmp_1_3_1, tmp_0_2_0);
nand get_1_3_2(tmp_1_3_2, tmp_0_2_1, tmp_0_1_0);
nand get_1_3_3(tmp_1_3_3, tmp_0_2_1, tmp_0_1_1, tmp_0_0_0);
nand get_1_3_4(tmp_1_3_4, tmp_0_2_1, tmp_0_1_1, tmp_0_0_1, Cin);
nand get_2_2_0(tmp_2_2_0, tmp_1_3_1, tmp_1_3_2, tmp_1_3_3, tmp_1_3_4);
xor getS3(S3, tmp_1_3_0, tmp_2_2_0);
not get_1_4_0(tmp_1_4_0, tmp_0_3_0);
nand get_1_4_1(tmp_1_4_1, tmp_0_3_1, tmp_0_2_0);
nand get_1_4_2(tmp_1_4_2, tmp_0_3_1, tmp_0_2_1, tmp_0_1_0);
nand get_1_4_3(tmp_1_4_3, tmp_0_3_1, tmp_0_2_1, tmp_0_1_1, tmp_0_0_0);
nand get_1_4_4(tmp_1_4_4, tmp_0_3_1, tmp_0_2_1, tmp_0_1_1, tmp_0_0_1, Cin);
nand getCout(Cout, tmp_1_4_0, tmp_1_4_1, tmp_1_4_2, tmp_1_4_3,tmp_1_4_4);
assign S = {S3,S2,S1,S0};
endmodule
