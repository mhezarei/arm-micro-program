module flopenr #(parameter WIDTH = 8)
								(input logic clk, reset, en,
									input logic [WIDTH-1:0] d,
										output logic [WIDTH-1:0] q);
										
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if (en) q <= d;
	
endmodule

module flopr #(parameter WIDTH = 8)
							(input logic clk, reset,
								input logic [WIDTH-1:0] d,
									output logic [WIDTH-1:0] q);
									
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else q <= d;
		
endmodule

module mux2 #(parameter WIDTH = 8)
			(input logic [WIDTH-1:0] d0, d1,
			input logic s,
			output logic [WIDTH-1:0] y);

	always_comb
		y = s ? d1 : d0;

endmodule

module ALU(input logic [31:0] a, b,
 	 				input logic [1:0] ALUControl,
					output logic [31:0] Result,
					output logic [3:0] ALUFlags);
	
	logic neg, zero, carry, overflow;
	logic [31:0] condinvb;
	logic [32:0] sum;
	
	assign condinvb = ALUControl[0] ? ~b : b;
	assign sum = a + condinvb + ALUControl[0];
	
	always_comb
		casex (ALUControl[1:0])
			2'b0?: Result = sum;
			2'b10: Result = a & b;
			2'b11: Result = a | b;
		endcase
		
	assign neg = Result[31];
	assign zero = (Result == 32'b0);
	assign carry = (ALUControl[1] == 1'b0) & sum[32];
	assign overflow = (ALUControl[1] == 1'b0) & 
										~(a[31] ^ b[31] ^ ALUControl[0]) & 
										(a[31] ^ sum[31]);
	assign ALUFlags = {neg, zero, carry, overflow};
	
endmodule

module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);
	always_comb
		y = s[1] ? d2 : (s[0] ? d1 : d0); 

endmodule

module extend(input logic [23:0] Instr,
				input logic [1:0] ImmSrc,
					output logic [31:0] ExtImm);

	always_comb
		case(ImmSrc)
			// 8-bit unsigned immediate
			2'b00: ExtImm = {24'b0, Instr[7:0]};
			// 12-bit unsigned immediate
			2'b01: ExtImm = {20'b0, Instr[11:0]};
			// 24-bit two's complement shifted branch
			2'b10: ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
			default: ExtImm = 32'bx; // undefined
		endcase

endmodule

module regfile(input logic clk,
				input logic we3,
					input logic [3:0] ra1, ra2, wa3,
						input logic [31:0] wd3, r15,
							output logic [31:0] rd1, rd2);

	logic [31:0] rf[14:0];

	always_ff @(posedge clk)
		if (we3) rf[wa3] <= wd3;
		
	assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
	assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];

endmodule