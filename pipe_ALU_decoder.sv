module pipe_ALU_decoder(
input logic ALUOp,
input logic [4:0] Funct,
output logic [1:0] FlagW,
output logic [2:0] ALUControl,
output logic NoWrite);
always_comb
	begin
		if (ALUOp)
		  begin
			NoWrite = 0;
				casex(Funct[4:0])
					5'b0100x:ALUControl = 3'b000;  //ADD
          5'b0010x:ALUControl = 3'b001;  //SUB
          5'b0000x:ALUControl = 3'b010;  //AND
          5'b1100x:ALUControl = 3'b011;  //ORR
          5'b1110x:ALUControl = 3'b100;  //BIC
          5'b0001x:ALUControl = 3'b101;  //EOR
					5'b10101: begin
							ALUControl = 3'b101;
							if (Funct[0]) NoWrite = 1;  //CMP
						 end
					default:ALUControl = 3'bx;     //--
				endcase
				FlagW[1] = Funct[0];
				FlagW[0] = Funct[0] & (ALUControl == 3'b000 | ALUControl == 3'b001);
			end
		else 
			begin
				ALUControl =3'b000;
				FlagW = 2'b00;
			end
	end
endmodule

