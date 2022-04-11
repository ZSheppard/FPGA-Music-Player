module decode7 (input logic [3:0] num,
		output logic [7:0] leds);			
	always_comb
		begin
			case(num)	//cases for the input 'num'
				 0 : leds = 8'b11000000; // 0	
				 1 : leds = 8'b11111001; // 1
				 2 : leds = 8'b10100100; // 2
				 3 : leds = 8'b10110000; // 3
				 4 : leds = 8'b10011001; // 4
				 5 : leds = 8'b10010010; // 5
				 6 : leds = 8'b10000010; // 6
				 7 : leds = 8'b11111000; // 7
				 8 : leds = 8'b10000000; // 8
				 9 : leds = 8'b10010000; // 9
				10 : leds = 8'b00000000; // 8.				
				11 : leds = 8'b10111110; // -	
				12 : leds = 8'b10111110; // -	
				13 : leds = 8'b10111110; // -	
				14 : leds = 8'b10111110; // -	
				15 : leds = 8'b10111110; // -	
			default: leds = 8'b11111111; // off
			endcase				
		end			
endmodule
