module pipe_control_unit(
input logic clk, reset, FlushE,
input logic [3:0] CondD, ALUFlagsE, Rd,
input logic [1:0] Op,
input logic [5:0] Funct,
output logic PCSrcW, RegWriteW, RegWriteM, MemWriteM, MemtoRegW, MemtoRegE, ALUSrcE, BranchTakenE, BranchE, BranchD, PCWrPendingF, ALUOp,
output logic [1:0] ImmSrcD, RegSrcD,
output logic [2:0] ALUControlE);
logic RegWriteD, MemRiteD, MemtoRegD, ALUSrcD, PCSrcD, NoWriteD,
 RegWriteE, MemWriteE, NoWriteE, PCSrcE,
 RegWriteE2, MemWriteE2, PCSrcE2,
 MemtoRegM, PCSrcM;
logic [1:0] FlagsWriteD, FlagsWriteE;
logic [2:0] ALUControlD;
logic [3:0] CondE, FlagsE, NextFlagsE;

pipe_decoder decoderr(Op, Funct, Rd, PCSrcD, RegWriteD, MemWriteD, MemtoRegD, ALUSrcD, BranchD,
 ALUOp, NoWriteD, FlagsWriteD, ImmSrcD, RegSrcD, ALUControlD);
 
pipe_flopr_en_clear #(1) flushed_PCSrc(clk, reset, 1'b1, FlushE, PCSrcD, PCSrcE);
pipe_flopr_en_clear #(1) flushed_Branch(clk, reset, 1'b1, FlushE, BranchD, BranchE);
pipe_flopr_en_clear #(1) flushed_NoWrite(clk, reset, 1'b1, FlushE, NoWriteD, NoWriteE);
pipe_flopr_en_clear #(2) flushed_FlagsWrite(clk, reset, 1'b1, FlushE, FlagsWriteD, FlagsWriteE);
pipe_flopr_en_clear #(1) flushed_RegWrite(clk, reset, 1'b1, FlushE, RegWriteD, RegWriteE);
pipe_flopr_en_clear #(1) flushed_MemWrite(clk, reset, 1'b1, FlushE, MemWriteD, MemWriteE);
pipe_flopr_en_clear #(1) flushed_MemtoReg(clk, reset, 1'b1, FlushE, MemtoRegD, MemtoRegE);
pipe_flopr_en_clear #(1) ALUSrc(clk, reset,1'b1, FlushE, ALUSrcD, ALUSrcE);
pipe_flopr_en_clear #(3) ALUControl(clk, reset, 1'b1, FlushE, ALUControlD, ALUControlE);
pipe_flopr_en_clear #(4) Condition_register(clk, reset, 1'b1, FlushE, CondD, CondE);
pipe_flopr_en_clear #(4) Flags_register(clk, reset, 1'b1, FlushE, NextFlagsE, FlagsE);


pipe_conditional_logic cl(CondE, ALUFlagsE, FlagsE, FlagWriteE, BranchE, RegWriteE, MemWriteE, PCSrcE, NoWriteE,
				 clk, reset, PCSrcE2, RegWriteE2, MemWriteE2, BranchTakenE,NextFlagsE);
 //memory
 pipe_flopr_en_clear #(1)lmaza1(clk, reset, 1'b1, 1'b0, PCSrcE2, PCSrcM);
pipe_flopr_en_clear #(1)lmaza2(clk, reset, 1'b1, 1'b0, RegWriteE2, RegWriteM);
pipe_flopr_en_clear #(1)lmaza3(clk, reset, 1'b1, 1'b0, MemWriteE2, MemWriteM);
pipe_flopr_en_clear #(1)lmaza4(clk, reset, 1'b1, 1'b0, MemtoRegE, MemtoRegM);
//Writeback
pipe_flopr_en_clear #(1)lma1(clk, reset, 1'b1, 1'b0, PCSrcM, PCSrcW);
pipe_flopr_en_clear #(1)lma2(clk, reset, 1'b1, 1'b0, RegWriteM, RegWriteW);
pipe_flopr_en_clear #(1)lma3(clk, reset, 1'b1, 1'b0, MemtoRegM, MemtoRegW);

assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
endmodule