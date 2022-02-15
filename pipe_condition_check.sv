module pipe_condition_check(input logic [3:0] Cond,ALUFlags,Flags,
				input logic [1:0] FlagWrite,
				output logic CondEx,
				output logic[3:0] NextFlags);
logic Z,V,N,C;
assign {N,Z,C,V} = Flags;
always_comb
	casex(Cond)
		4'b0000: CondEx = Z;
		4'b0001: CondEx = ~Z;
		4'b0010: CondEx = C;
		4'b0011: CondEx = ~C;
		4'b0100: CondEx = N;
		4'b0101: CondEx = ~N;
		4'b0110: CondEx = V;
		4'b0111: CondEx = ~V;
		4'b1000: CondEx = ~Z & C;
		4'b1001: CondEx = Z | ~C;
		4'b1010: CondEx = ~(N ^ V);
		4'b1011: CondEx = (N ^ V);
		4'b1100: CondEx = ~(N ^ V) & ~Z;
		4'b1101: CondEx = (N ^ V) | Z;
		4'b1110: CondEx = 1'b1;
		4'b1111: CondEx = 1'bx;
	endcase
assign NextFlags[3:2] = (FlagWrite[1] & CondEx) ? ALUFlags[3:2] : Flags[3:2];
assign NextFlags[1:0] = (FlagWrite[0] & CondEx) ? ALUFlags[1:0] : Flags[1:0];
endmodule