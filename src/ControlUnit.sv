module ControlUnit(input logic clk, reset,
				   input logic [1:0] Op,
				   input logic [5:0] Funct,
				   output logic NextPC, RegW, MemW, IRWrite, AdrSrc, ALUSrcA, Branch, ALUOp,
				   output logic [1:0] ResultSrc, ALUSrcB);

    logic [3:0] adr;
    logic [3:0] nextAdr;
    logic [15:0] controlWord;

	SequentialLogic sl(clk, reset,
				       Op,
				       Funct,
				   	   nextAdr,
				       adr);

	ControlMemory cmem(adr,
					   controlWord);

	ControlBufferRegister cbr(controlWord,
							  nextAdr,
							  NextPC, RegW, MemW, IRWrite, AdrSrc, ALUSrcA, Branch, ALUOp,
				   			  ResultSrc, ALUSrcB);

	
endmodule