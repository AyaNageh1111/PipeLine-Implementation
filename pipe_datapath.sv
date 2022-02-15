module pipe_datapath(input logic clk, reset,
  input logic ALUSrcE, BranchTakenE,
  input logic MemtoRegW, PCSrcW, RegWriteW, MemWriteM,
  input logic StallF, StallD, FlushD, FlushE,
  input logic [1:0] ForwardAE, ForwardBE,
  input logic [1:0] RegSrcD, ImmSrcD,
  input logic [2:0] ALUControlE,
  output logic [31:0] PCF,
  output logic [31:0] InstrD,
  output logic [31:0] ALUOutM, WriteDataM,
  output logic [3:0] ALUFlagsE,
  output logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
  output logic [31:0]ALUResultE,
  output logic [31:0]SrcAE, SrcBE,
  output logic [31:0]RD1D, RD2D,
  output logic [31:0]ExtImmD,
  output logic [3:0] RA1D, RA2D,
  output logic [31:0]ResultW); 

logic zero_0, one_1;
logic [31:0] InstrF;
logic [31:0] PCPlus4F, y1, PC;
logic [31:0] PCPlus8D;
logic [31:0] RD1E, RD2E, ExtImmE, WriteDataE; //ALUResultE;
logic [31:0] ReadDataW, ALUOutW;
logic [3:0] RA1E, RA2E, WA3E, WA3M, WA3W;
logic Match_1D_E, Match_2D_E;
//logic je_pc;
//logic je_insf;
//logic je_insd;
//logic je_RA1D;
//logic je_RA1D;
//logic je_r;
assign zero_0=1'b0;
assign one_1=1'b1;

//fetch
//if(reset==1)PCPlus4F=32'h0;
pipe_mux2 #(32) m1(PCPlus4F, ResultW, PCSrcW, y1);
pipe_mux2 #(32) m2(y1, ALUResultE, BranchTakenE, PC);
pipe_flopr_en_clear #(32)f1(clk, reset, ~StallF, zero_0, PC, PCF);
pipe_imem sad(PCF,InstrF);
pipe_flopr_en_clear #(32)f2(clk, reset, ~StallD, FlushD, InstrF, InstrD);
Pipe_Adder #(32) pcadd(PCF, 32'h4, PCPlus4F);

//decode
assign PCPlus8D = PCPlus4F;
pipe_mux2 #(4) c1(InstrD[19:16], 4'b1111, RegSrcD[0], RA1D);
pipe_mux2 #(4) c2(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2D);
Pipe_Extened e(InstrD[23:0], ImmSrcD, ExtImmD);
pipe_regfile r(clk, RegWriteW, RA1D, RA2D, WA3W, ResultW, PCPlus8D, RD1D, RD2D);
pipe_flopr_en_clear #(32)fRD1(clk, reset, one_1, FlushE, RD1D, RD1E);
pipe_flopr_en_clear #(32)fRD2(clk, reset, one_1, FlushE, RD2D, RD2E);
pipe_flopr_en_clear #(32)fRA1(clk, reset, one_1, FlushE, RA1D, RA1E);
pipe_flopr_en_clear #(32)fRA2(clk, reset, one_1, FlushE, RA2D, RA2E);
pipe_flopr_en_clear #(32)imm(clk, reset, one_1, FlushE, ExtImmD, ExtImmE);
pipe_flopr_en_clear #(4)WA3D(clk, reset, one_1, FlushE, InstrD[15:12], WA3E);

//execute
pipe_mux3 #(32) first_one(RD1E, ResultW, ALUOutM, ForwardAE, SrcAE);
pipe_mux3 #(32) second_one(RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
pipe_mux2 #(32) srcbe(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
pipe_ALU alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);
pipe_flopr_en_clear #(32)alur(clk, reset, one_1, zero_0, ALUResultE, ALUOutM);
pipe_flopr_en_clear #(32)wde(clk, reset, one_1, zero_0, WriteDataE, WriteDataM);
pipe_flopr_en_clear #(4)wa3e(clk, reset, one_1, zero_0, WA3E, WA3M);
//memory
pipe_dmem mama(clk,MemWriteM,ALUOutM,WriteDataM,ReadDataM);
pipe_flopr_en_clear #(32)aluout(clk, reset, one_1, zero_0, ALUOutM, ALUOutW);
pipe_flopr_en_clear #(32)rd(clk, reset, one_1, zero_0, ReadDataM, ReadDataW);
pipe_flopr_en_clear #(4)wa3w(clk, reset, one_1, zero_0, WA3M, WA3W);
//Writeback
pipe_mux2 #(32) lastm(ALUOutW, ReadDataW, MemtoRegW, ResultW);

//hazard comparison
pipe_cmp #(4) cm0(WA3M, RA1E, Match_1E_M);
pipe_cmp #(4) cm1(WA3W, RA1E, Match_1E_W);
pipe_cmp #(4) cm2(WA3M, RA2E, Match_2E_M);
pipe_cmp #(4) cm3(WA3W, RA2E, Match_2E_W);
pipe_cmp #(4) cm41(WA3E, RA1D, Match_1D_E);
pipe_cmp #(4) cm42(WA3E, RA2D, Match_2D_E);
assign Match_12D_E = Match_1D_E | Match_2D_E;
endmodule
