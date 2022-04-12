//Generates a random number between 0-11 based on the state "count" will be in every clock cycle
// ELEX 7660 Group Project

module randNumberGenerator (input logic FPGA_CLK1_50, reset_n,
									input logic [2:0] rand_seed,
									 output logic [3:0] randNum);

					logic [2:0] count1;
					//logic [2:0] count2 = 3;
					//logic [2:0] count3 = 7;
					//logic [2:0] count4 = 1;
	always_ff @(posedge FPGA_CLK1_50) begin
			if(~reset_n) begin
				count1 <= rand_seed;
			end
			
			count1 <= count1 + 1;
			//count2 <= count2 + 1;
			//count3 <= count3 + 1;
			//count4 <= count4 + 1;
			
			if(count1 >= 7) begin
				count1 <= 7;
			end
			/*
			if(count2 >= 7) begin
				count2 <= 7;
			end
			
			if(count3 >= 7) begin
				count3 <= 7;
			end
			
			if(count4 >= 7) begin
				count4 <= 7;
			end
			*/
			randNum <= count1; //(11 - 0)/(15- 0) * (count - 0)-0; scaling formula
	
			
	end
endmodule
