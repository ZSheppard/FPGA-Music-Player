module randNumberGenerator (input logic FPGA_CLK1_50,
									 output logic [3:0] randNum);
									 
					logic [3:0] count;
	always_ff @(posedge FPGA_CLK1_50) begin
		
			count <= count + 1;
			
			if(count >= 12) begin
				count <= 0;
			end
			randNum <= (11*count) /15; //(11 - 0)/(15- 0) * (count - 0)-0; scaling formula
			
	end
endmodule