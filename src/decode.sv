module decode(input  logic clk, reset,
              input  logic [1:0] Op,
              input  logic [5:0] Funct,
              input  logic [3:0] Rd,
              output logic [1:0] FlagW,
              output logic PCS, NextPC, RegW, MemW,
              output logic IRWrite, AdrSrc, ALUSrcA,
              output logic [1:0] ResultSrc, ALUSrcB, 
              output logic [1:0] ImmSrc, RegSrc, ALUControl);

  // my code starts here

  logic Branch, ALUOp;
  
	ControlUnit cu(clk, reset,
				   Op,
				   Funct,
				   NextPC, RegW, MemW, IRWrite, AdrSrc, ALUSrcA, Branch, ALUOp,
				   ResultSrc, ALUSrcB);

	assign RegSrc = Op == 2'b00 ? (Funct[5] == 1'b1 ? 2'bX0 : 2'b00) : 
									(Op == 2'b01 ? (Funct[0] == 1'b1 ? 2'bX0 : 2'b10) : 
									 (Op == 2'b10 ? 2'bX1 : 2'bXX));
	assign ImmSrc = Op;

	always_comb
		if (ALUOp) 
			begin
				case(Funct[4:1])
					4'b0100: ALUControl = 2'b00; // ADD
					4'b0010: ALUControl = 2'b01; // SUB
					4'b0000: ALUControl = 2'b10; // AND
					4'b1100: ALUControl = 2'b11; // ORR
					default: ALUControl = 2'bXX; // unimplemented
				endcase

				FlagW[1] = Funct[0];
				FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
			end 
		else 
			begin
				ALUControl = 2'b00; // add for non-DP instructions
				FlagW = 2'b00; // don't update Flags
			end

	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
		
	// my code ends here

endmodule