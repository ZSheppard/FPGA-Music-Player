//Keypad decode module
//reads inputs from keypad row and keypad columm and cocatenates them into "button"
//button is used to determine a value to set num
// ELEX 7660 Group Project

module kpdecode ( output logic [3:0] num,
						output logic kphit,
						input logic  [3:0] kpc,
						input logic  [3:0] kpr);
		
	
		logic [7:0] button;
		
	always_comb begin
		
					
						button = {kpr , kpc};
						case(button)
						
							
							8'b11101011 : begin num = 4'h0; kphit = 1; end
							8'b01110111 : begin num = 4'h1; kphit = 1; end
							8'b01111011 : begin num = 4'h2; kphit = 1; end
							8'b01111101 : begin num = 4'h3; kphit = 1; end
							8'b10110111 : begin num = 4'h4; kphit = 1; end
							8'b10111011 : begin num = 4'h5; kphit = 1; end
							8'b10111101 : begin num = 4'h6; kphit = 1; end
							8'b11010111 : begin num = 4'h7; kphit = 1; end
							8'b11011011 : begin num = 4'h8; kphit = 1; end
							8'b11011101 : begin num = 4'h9; kphit = 1; end
							8'b01111110 : begin num = 4'ha; kphit = 1; end
							8'b10111110 : begin num = 4'hb; kphit = 1; end
							8'b11011110 : begin num = 4'hc; kphit = 1; end
							8'b11101110 : begin num = 4'hd; kphit = 1; end
							8'b11100111 : begin num = 4'he; kphit = 1; end
							8'b11101101 : begin num = 4'hf; kphit = 1; end
							default: begin num = 13; kphit = 0; end
							
						endcase

					end
				
			
endmodule
