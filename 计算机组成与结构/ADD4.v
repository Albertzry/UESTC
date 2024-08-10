module CLA_32add4(X,S);
input [31:0] X;
output [31:0]S;
assign S = X + 32'b00000000000000000000000000000100;
endmodule


