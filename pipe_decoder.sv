module pipe_decoder(
input logic [1:0] Op, 
input logic [5:0] Funct,
input logic [3:0] Rd,
output logic PCS, RegW,  MemW,  MemtoReg, ALUSrc, Branch, ALUOp, NoWrite,
output logic [1:0] FlagW, ImmSrc, RegSrc,
output logic [2:0] ALUControl);
pipe_main_decoder main_decoderr(.Op(Op), .Funct(Funct), .RegSrc(RegSrc), .ImmSrc(ImmSrc), .ALUSrc(ALUSrc),
 			   .MemtoReg(MemtoReg), .RegW(RegW), .MemW(MemW), .Branch(Branch),  .ALUOp(ALUOp));
pipe_ALU_decoder ALU_decoderr(.ALUOp(ALUOp), .Funct(Funct[4:0]), .FlagW(FlagW),  .ALUControl(ALUControl), .NoWrite(NoWrite));
pipe_PC_logic PC_logicc(.Rd(Rd), .Branch(Branch), .RegW(RegW), .PCS(PCS));
endmodule
