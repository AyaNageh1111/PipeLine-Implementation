module pipe_PC_logic(
input logic [3:0] Rd,
input logic Branch, RegW,
output logic PCS);
always_comb 
	begin
		assign PCS = (RegW & (Rd == 4'b1111));
	end
endmodule
