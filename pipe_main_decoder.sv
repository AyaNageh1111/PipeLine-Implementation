module pipe_main_decoder(
input logic [1:0] Op,
input logic [5:0] Funct,
output logic RegW,  MemW, MemtoReg, ALUSrc, ALUOp, Branch,
output logic [1:0] ImmSrc, RegSrc);
logic [9:0] controls;
always_comb
	begin
		casex(Op)
			//Data processing
			2'b00: if(Funct[5]) controls = 10'b0000101001;
			       else controls = 10'b0000001001;
			//Memory 
			2'b01: if(Funct[0]) controls = 10'b0001111000;
			       else controls = 10'b1001110100;
			//Branch
			2'b10: controls = 10'b0110100010;
			//2'b10: controls = 10'b1001110100;
			//Not supported
			default: controls = 10'bx;
		endcase
	end
assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW,  MemW,  Branch, ALUOp} = controls;
endmodule
