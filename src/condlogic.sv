module condlogic(input  logic       clk, reset,
                 input  logic [3:0] Cond,
                 input  logic [3:0] ALUFlags,
                 input  logic [1:0] FlagW,
                 input  logic       PCS, NextPC, RegW, MemW,
                 output logic       PCWrite, RegWrite, MemWrite);

  logic [1:0] FlagWrite;
  logic [3:0] Flags;
  logic       CondEx, XPrime;

  // Delay writing flags until ALUWB state
  // flopr #(2)flagwritereg(clk, reset, FlagW&{2{CondEx}}, FlagWrite);
	
	flopr #(1) condexreg(clk, reset, CondEx, XPrime);
	
	flopenr #(2)flagreg1(clk, reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]);
	flopenr #(2)flagreg0(clk, reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]);

	condcheck cc(Cond, Flags, CondEx);
	assign FlagWrite = FlagW & {2{CondEx}};
	assign PCWrite = (PCS & XPrime) | NextPC;
	assign RegWrite = RegW & XPrime;
	assign MemWrite = MemW & XPrime;

endmodule