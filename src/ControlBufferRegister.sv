module ControlBufferRegister(
												input logic [15:0] controlWord,
							  output logic [3:0] nextAdr,
							  output logic NextPC, RegW, MemW, IRWrite, AdrSrc, ALUSrcA, Branch, ALUOp,
				   			  output logic [1:0] ResultSrc, ALUSrcB);
	
		always_comb
			{NextPC, RegW, MemW, IRWrite, AdrSrc, ResultSrc, 
					ALUSrcA, ALUSrcB, Branch, ALUOp, nextAdr} = controlWord[15:0];

endmodule