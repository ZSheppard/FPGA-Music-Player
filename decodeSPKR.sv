// decodeSPKR.sv - converts # bit number into the signals necessary to output desired tone on speaker of DEO-Nano-SoC
// ELEX 7660 Group Project

module decodeSPKR (input logic [3:0] num, 
						 input logic FPGA_CLK1_50,
						 input logic [3:0] randNum,
						 output logic [31:0] desiredFrequency,
						 output logic play,d,rstn);
						 
					logic flag,flag2;
					reg[31:0] count2 = 0;
					int notes[15:0] = '{415,392,370,349,330,311,294,277,261,466,277,349,330,349,294,466};
					int notelength[15:0] = '{1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,0};
					int seaShanty[45:0] = '{880,659,587,554,0,554,587,659,739,830,659,
												   0,739,659,587,554,554,494,554,587,
													0,880,659,587,554,0,554,587,659,739,587,0,
													739,659,587,554,494,554,587,739,659,587,554,494,466,0};
					int seaShantylength[45:0] = '{1,1,1,2,2,1,1,1,1,1,2,
														   2,1,1,1,1,1,1,1,1,2,
															2,1,1,1,2,2,1,1,1,1,2,2,
															1,1,1,1,1,1,1,1,1,1,1,2,2};
					shortint i;

  always_ff @(posedge FPGA_CLK1_50)
			begin
			
				if(num == 11) begin
					flag <= 'd1;
				end
				
				else if(flag) begin
				
						if(count2 <= 10000000*notelength[i])begin
							desiredFrequency <= notes[i];
							count2++;
						end
					
						else begin
							count2 <= 0;
							i--;
							if(i < 0) begin
								flag <= 0;
								i <= $size(notes);
								end
						end
					
					end
				
				//SEASHANTY
				else if(num == 12) begin
					flag2 <= 'd1;
				end
				
				else if(flag2) begin
				
						if(count2 <= 10000000*seaShantylength[i])begin
							desiredFrequency <= seaShanty[i];
							count2++;
						end
					
						else begin
							count2 <= 0;
							i--;
							if(i < 0) begin
								flag2 <= 0;
								i <= $size(seaShanty);
								end
						end
					
					end
					
				else begin
				
				
					case(num)	//cases for the input 'num'
						 //values 0-9 represent notes
						 0 : begin  desiredFrequency <= 'd466; d = 'd0; end //A#
						 
						 //tune for middle C - 261Hz.
						 1 : begin  desiredFrequency <= 'd261; d = 'd0; end	//C
						 
						 2 : begin 	desiredFrequency <= 'd277; d = 'd0; end //C#
						 3 : begin 	desiredFrequency <= 'd294; d = 'd0; end //D
						 4 : begin 	desiredFrequency <= 'd311; d = 'd0; end //D#
						 5 : begin 	desiredFrequency <= 'd330; d = 'd0; end //E
						 6 : begin 	desiredFrequency <= 'd349; d = 'd0; end //F
						 7 : begin	desiredFrequency <= 'd370; d = 'd0; end //F#
						 8 : begin	desiredFrequency <= 'd392; d = 'd0; end //G
						 9 : begin	desiredFrequency <= 'd415; d = 'd0; end //G#
						 14 : begin	desiredFrequency <= 'd440; d = 'd0; end //A
						 15 : begin	desiredFrequency <= 'd494; d = 'd0; end //B
						 
						 //values 10-13 represent game operations
						 10 : begin	desiredFrequency <= 'd0; d <= 'd0; end
						 
						 //11 : begin desiredFrequency <= 'dffff; flag <= 'd1;
								
								//d <= 'd1; 
								//rstn <= 'd1; 
							//sets play to one, starting tonegen.sv 
										
						 12 : begin	desiredFrequency <= 'd0; d = 'd0; end
						 13 : begin	desiredFrequency <= 'd0; d = 'd0; end
						 //18 : begin desiredFrequency = 'd0; end
						 
						 default: begin
											 desiredFrequency <= 'd0; d = 'd0;	//default goes to zero yet, constant tone
									end
					endcase
				end
			end
    
endmodule