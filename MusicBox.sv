//JukeBox prototype project
//Author - Zachary Sheppard, March 17, 2022

module MusicBox (input logic FPGA_CLK1_50,
					  input logic [31:0] desiredFrequency,
					  output logic spkr);
					  
					  reg[31:0] counter;
					  reg[31:0] desiredCounter;
					  
					  always_ff @(posedge FPGA_CLK1_50) begin		
						
							if(desiredFrequency > 0)
								desiredCounter = (50000000/desiredFrequency/2);
							else
								desiredCounter = 0;
							
						end
					  
					  always_ff @(posedge FPGA_CLK1_50) begin
					  
					  
					  if(counter >= desiredCounter) 
						counter<=0; 
					  else 
						counter <= counter+1;
						
					  end
					  
					  always_ff @(posedge FPGA_CLK1_50) begin
					  
					  if (desiredCounter == 0)
								spkr <= 0;
					  else if(counter==desiredCounter) 
								spkr <= ~spkr;

					  end
						
endmodule