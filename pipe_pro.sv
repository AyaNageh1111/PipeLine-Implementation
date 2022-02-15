module pipe_pro(input logic clk, reset,
                output logic StallF, StallD, FlushD, FlushE,
                output logic [31:0]ALUResultE,
                output logic [31:0]SrcAE, SrcBE,
                 output logic [31:0]RD1D, RD2D,
                 output logic [31:0]ExtImmD,
                 output logic ALUSrcE,
                 output logic [1:0]ImmSrcD,
                 output logic [1:0]RegSrcD,
                  output logic [31:0]PCF,
                  output logic [3:0] RA1D, RA2D,
                  output logic [31:0]ResultW);
     logic [31:0]InstrD;
     logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
     logic [1:0]ForwardAE, ForwardBE;
     logic RegWriteM, RegWriteW, MemtoRegE, MemtoRegW, BranchTakenE;   
     logic PCSrcW;
     //logic [1:0]RegSrcD;
     logic [2:0]ALUControlE;
     logic PCWrPendingF;
    
 
//logic ALUSrcE;
//logic [3:0] ALUFlagsE;





  pipe_control_unit maryomas(clk, reset, FlushE, InstrD[31:28], ALUFlagsE, InstrD[15:12], 
            InstrD[27:26], InstrD[25:20], 
            PCSrcW, RegWriteW, RegWriteM, MemWriteM, MemtoRegW, MemtoRegE, ALUSrcE, BranchTakenE, BranchE, BranchD, PCWrPendingF, 
            ALUOp, ImmSrcD, RegSrcD, ALUControlE);
  /*pipe_controller c(clk, reset, InstrD[31:12], ALUFlagsE,
            RegSrcD, ImmSrcD,
            ALUSrcE, BranchTakenE, ALUControlE,
            MemWriteM,
            MemtoRegW, PCSrcW, RegWriteW,
            RegWriteM, MemtoRegE, PCWrPendingF,
            FlushE);*/
            
  pipe_datapath jhjh(clk, reset, ALUSrcE, BranchTakenE, MemtoRegW, PCSrcW, RegWriteW, MemWriteM, 
             StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE,
             RegSrcD, ImmSrcD, ALUControlE,
             PCF, InstrD, ALUOutM, WriteDataM, ALUFlagsE, 
             Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,ALUResultE,SrcAE, SrcBE,
             RD1D, RD2D,ExtImmD, RA1D, RA2D, ResultW);
 
  pipe_hazard ayay(Match_1E_M, Match_1E_W, Match_2E_M,
              Match_2E_W, Match_12D_E, RegWriteM, RegWriteW, 
              BranchTakenE, MemtoRegE, PCWrPendingF, PCSrcW, 
              ForwardAE, ForwardBE, StallF, StallD, FlushD, FlushE);
endmodule
