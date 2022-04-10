module decode7 (input logic [3:0] num,
						output logic [7:0] leds);
						 
						
		always_comb
			begin
				//if(kphit)
				
					case(num)	//cases for the input 'num'
						 0 : leds = 8'b11000000;	//active high 8'b00111111. active low 8'11000000
						 1 : leds = 8'b11111001;
						 2 : leds = 8'b10100100;
						 3 : leds = 8'b10110000;
						 4 : leds = 8'b10011001;
						 5 : leds = 8'b10010010;
						 6 : leds = 8'b10000010;
						 7 : leds = 8'b11111000;
						 8 : leds = 8'b10000000;
						 9 : leds = 8'b10010000;
						 10 : leds = 8'b10001000;
						 11 : leds = 8'b10000011;
						 12 : leds = 8'b11000110;
						 13 : leds = 8'b10100001;
						 14 : leds = 8'b10000110;
						 15 : leds = 8'b10001110;
						 default: leds = 8'b11111111;
					endcase
				
			end
				
				/*else
					leds = 8'b11111111;
				
			end*/
			
endmodule