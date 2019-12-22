module shifter (input logic [31:0] a,
									input logic [4:0] shamt,
										input logic [1:0] sh,
											output logic [31:0] out);

	always_comb
		case(sh)
			// LSL
			2'b00: out = a << shamt;
			// LSR
			2'b01: out = a >> shamt;
			// ASR
			2'b10: out = a >>> shamt;
			// ROR
			2'b11: out = (a >> shamt) | (a << (32 - shamt));
			default: out = a;
		endcase

endmodule