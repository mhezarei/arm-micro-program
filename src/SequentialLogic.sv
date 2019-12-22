module SequentialLogic(input logic clk, reset,
				       input logic [1:0] Op,
				       input logic [5:0] Funct,
				   	   input logic [3:0] nextAdr,
				       output logic [3:0] adr);

    always_ff@(posedge clk, posedge reset)
		if(reset) 
			adr <= 4'b0000;
		else
			begin
				case(nextAdr)
					4'b1111:
						if(Op == 2'b01)
							adr <= 4'b0010;
						else if(Op == 2'b10)
							adr <= 4'b1001;
						else if(Op == 2'b00)
							if(Funct[5] == 1'b0)
								adr <= 4'b0110;
							else
								adr <= 4'b0111;
					4'b1110:
						if(Funct[0] == 1'b1)
							adr <= 4'b0011;
						else
							adr <= 4'b0100;
					default:
						adr <= nextAdr;
				endcase
			end
endmodule