module datapath(input  logic        clk, reset,
                output logic [31:0] Adr, WriteData,
                input  logic [31:0] ReadData,
                output logic [31:0] Instr,
                output logic [3:0]  ALUFlags,
                input  logic        PCWrite, RegWrite,
                input  logic        IRWrite,
                input  logic        ALUSrcA, AdrSrc,
                input  logic [1:0]  RegSrc,
                input  logic [1:0]  ALUSrcB, ResultSrc,
                input  logic [1:0]  ImmSrc, ALUControl);

  logic [31:0] PC;
  logic [31:0] ExtImm, SrcA, SrcB, Result;
  logic [31:0] Data, RD1, RD2, A, ALUResult, ALUOut;
  logic [3:0]  RA1, RA2;
  
	// the clk with PCWrite enable
	flopenr #(32) pcreg(clk, reset, PCWrite, Result, PC);
	
	// AdrSrc mux 2:1
	mux2 #(32) adrmux(PC, Result, AdrSrc, Adr);

	// the clk for Instr with IRWrite enable
	flopenr #(32) instrreg(clk, reset, IRWrite, ReadData, Instr);
	
	// the clk for the Data with no enable
	flopr #(32) datareg(clk, reset, ReadData, Data);
	
	// RA1 mux
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
	
	// RA2 mux
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);

	// RF
	regfile rf(clk, RegWrite, RA1, RA2, Instr[15:12], Result, Result, RD1, RD2);
	
	// extend unit
	extend extimm(Instr[23:0], ImmSrc, ExtImm);
	
	// the clk for A and B with no enable
	flopr #(32) areg(clk, reset, RD1, A);
	
	logic [31:0] Temp;
	flopr #(32) readdatareg(clk, reset, RD2, Temp);
	shifter sh(Temp, Instr[11:7], Instr[6:5], WriteData);
	
	// ALUSrcA mux
	mux2 #(32) aluSrca(A, PC, ALUSrcA, SrcA);
	
	// ALUSrcB mux 3:1
	mux3 #(32) aluSrcb(WriteData, ExtImm, 4, ALUSrcB, SrcB);
	
	// ALU
	ALU alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
	
	// the clk for the ALUOut
	flopr #(32) aluoutreg(clk, reset, ALUResult, ALUOut);
	
	// the Result 3:1 mux
	mux3 #(32) aluoutmux(ALUOut, Data, ALUResult, ResultSrc, Result);

endmodule