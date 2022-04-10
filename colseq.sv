module colseq ( output logic [3:0] kpc,
					 input logic  [3:0] kpr, 
					 input logic  reset_n, clk);
					 
		logic [1:0] count;		
		
	always_ff @(posedge clk, negedge reset_n)
			
		if(~reset_n)	//default value when reset is pressed
			count <= 0;
			
		else if(kpr != 4'b1111)	//if a button is pressed kpr will no longer be 1111 causing the current state to loop
			count <= count;	
			
			
		else if(count == 3)
			count <= 0;
		
		else	
			count <= count + 1;
			
	
	always_comb
		
		case (count)	//cases for the input 'count'
			0 : kpc = 4'b0111;	//count value 0 sets the first column to 0
			1 : kpc = 4'b1011;
			2 : kpc = 4'b1101;
			3 : kpc = 4'b1110;
		endcase
			
endmodule