module pipe_hazard(
 input logic Match_1E_M, Match_1E_W, Match_2E_M, 
 input logic Match_2E_W, Match_12D_E, 
 input logic RegWriteM, RegWriteW, 
 input logic BranchTakenE, MemtoRegE, 
 input logic PCWrPendingF, PCSrcW, 

//Outputs
 output logic [1:0] ForwardAE, ForwardBE, 

 output logic StallF, StallD, 
 output logic FlushD, FlushE); 
 
						//RAW Hazard
 
 // forwarding logic 
 always_comb begin 
 if (Match_1E_M & RegWriteM) ForwardAE = 2'b10;      //check the matches with the last stage
 else if (Match_1E_W & RegWriteW) ForwardAE = 2'b01; //check the matches with the last second stage
 else ForwardAE = 2'b00; 			     //No RAW Hazard
 

//same for the second source
 if (Match_2E_M & RegWriteM) ForwardBE = 2'b10;	     
 else if (Match_2E_W & RegWriteW) ForwardBE = 2'b01; 
else ForwardBE = 2'b00; 
 end 

 					// Load RAW  // Branch hazard  // PC Write Hazard 
 logic check_StallD;

 assign check_StallD = Match_12D_E & MemtoRegE; 
 
 						 // stalls and flushes 
 assign StallD = check_StallD; 
 assign StallF = check_StallD | PCWrPendingF; 
 assign FlushE = check_StallD | BranchTakenE; 
 assign FlushD = PCWrPendingF | PCSrcW | BranchTakenE; 
 
endmodule
