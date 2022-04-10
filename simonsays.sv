module simonsays ( output logic [3:0] ct,
						input logic kphit,
						input logic  [3:0] num,
						input logic  clk);
						
						
						always_ff @(posedge clk) begin
						
						if(num == 4'hb)
							ct[3] <= 1;
						else if (num == 4'ha)
							ct[3] <= 0;
						else
							ct[3] <= 0;
							
						end
endmodule
							
						