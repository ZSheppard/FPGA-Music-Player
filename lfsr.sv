//A module to create a random number generator
//Using a LFSR or Linear Feedback Shift Register
module lfsr(output reg [(14 - 1):0]out, 
				input FPGA_CLK1_50,rst,
				input [(14 - 1):0] seed);
				
				assign feedback = ~(out[7] ^ out[2]);
				
				always_ff @(posedge FPGA_CLK1_50, posedge rst)
					begin
						if (rst)
							out <= seed;
						else
							out <= {out[(14 - 2):0], feedback};
					end
endmodule