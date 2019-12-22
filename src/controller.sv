module controller(input logic clk,
                  input logic reset,
                  input logic [31:12] Instr,
                  input logic [3:0]   ALUFlags,
                  output logic PCWrite,
                  output logic MemWrite,
                  output logic RegWrite,
                  output logic IRWrite,
                  output logic AdrSrc,
                  output logic [1:0] RegSrc,
                  output logic ALUSrcA,
                  output logic [1:0] ALUSrcB,
                  output logic [1:0] ResultSrc,
                  output logic [1:0] ImmSrc,
                  output logic [1:0] ALUControl);
                  
  logic [1:0] FlagW;
  logic PCS, NextPC, RegW, MemW;
	
  decode dec(clk, reset, Instr[27:26], Instr[25:20], Instr[15:12],
             FlagW, PCS, NextPC, RegW, MemW,
             IRWrite, AdrSrc, ALUSrcA, ResultSrc, 
             ALUSrcB, ImmSrc, RegSrc, ALUControl);
  condlogic cl(clk, reset, Instr[31:28], ALUFlags,
               FlagW, PCS, NextPC, RegW, MemW,
               PCWrite, RegWrite, MemWrite);
endmodule