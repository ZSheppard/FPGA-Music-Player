// decodeSPKR.sv - converts # bit number into the signals necessary to output desired tone on speaker of DEO-Nano-SoC
//Has a hardcoded full length song
//
// ELEX 7660 Group Project

//2023 Test commit

module decodeSPKR (input logic [3:0] num, 
						 input logic FPGA_CLK1_50,start,
						 input logic [3:0] randNum,
						 input logic [11:0] rand_stored,
						 input logic [31:0] rand_send0_Frequency,
												  rand_send1_Frequency,
												  rand_send2_Frequency,
												  rand_send3_Frequency,
						 output logic [31:0] desiredFrequency);
						 
					logic flag,flag2;
					reg[31:0] count1 = 0;
					reg[31:0] count2 = 0;

					//int notes[15:0] = '{415,392,370,349,330,311,294,277,261,466,277,349,330,349,294,466};
					//int notelength[15:0] = '{1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,0};
					int notes[7:0];
					int notelength[7:0] = '{4,4,4,4,4,4,4,4};
					
					//SeaShanty song
					
					int seaShanty[304:0] = '{880,659,587,554,0,554,587,659,739,830,659,
												   0,739,659,587,554,554,494,554,587,
													0,880,659,587,554,0,554,587,659,739,587,0,
													739,659,587,554,494,554,587,739,659,587,554,494,440,0,
													//bar5
													554,494,554,0,554,0,554,494,554,0,494,0,554,0,
													440,494,554,587,554,0,494,0,554,0,
													554,494,554,0,554,0,587,554,494,0,659,0,554,0,
													554,494,554,587,554,0,440,0,554,0,
													659,587,659,0,659,0,659,587,659,0,739,0,659,0,
													//bar10
													830,0,830,739,659,0,587,0,659,0,
													554,494,554,0,554,0,494,554,587,0,494,0,554,0,
													//bar13
													554,494,554,587,554,0,440,0,554,0,220,0,
													110,330,82,330,110,330,55,330,
													110,330,82,330,110,330,55,0,
													//bar18
													3520,0,1760,0,880,0,1108,1174,1108,1174,1108,0,1108,
													1174,0,1318,0,1661,1479,1661,1318,0,
													//bar20
													1108,1174,1318,1760,1661,1479,1318,1174,0,1318,1174,1108,0,1318,1174,1108,880,0,
													880,988,1108,1174,1318,1174,1108,988,1108,0,830,0,880,0,
													880,659,739,783,659,0,880,659,739,783,659,0,
													880,659,739,783,880,0,988,880,988,0,659,0,
													//bar28
													440,330,370,392,330,0,440,330,370,392,330,0,
													440,330,370,392,440,0,494,440,0,
													//outro
													880,659,587,554,0,554,587,659,739,830,659,
													0,739,659,587,554,554,494,554,587,
													0,880,659,587,554,0,554,587,659,739,587,0,
													739,659,587,554,494,554,587,739,659,587,554,494,440,0};
													
					int seaShantylength[304:0] = '{1,1,1,2,2,1,1,1,1,1,2,
														   2,1,1,1,1,1,1,1,1,2,
															1,1,1,2,2,1,1,1,1,1,2,1,
															1,1,1,1,1,1,1,1,1,1,1,2,2,
															//bar5
															1,1,1,1,1,1,1,1,1,1,1,1,1,2,
															1,1,1,1,1,1,1,1,1,3,
															1,1,1,1,1,1,1,1,1,1,1,1,1,2,
															1,1,1,1,1,1,1,1,4,2,
															1,1,1,1,1,1,1,1,1,1,1,1,1,2,
															//bar10
															1,1,1,1,1,1,1,1,1,2,
															1,1,1,1,1,1,1,1,1,1,1,1,1,2,
															//bar13
															1,1,1,1,1,1,1,1,1,1,1,3,
															3,1,3,1,3,1,2,1,
															3,1,3,1,3,1,3,3,
															//bar18
															1,1,1,1,1,1,1,1,1,1,2,1,1,
															1,1,1,1,1,1,1,3,1,
															//bar20
															1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,
															1,1,1,1,1,1,1,1,1,1,1,1,1,1,
															2,1,1,1,1,1,2,1,1,1,1,1,
															2,1,1,1,1,1,1,1,1,1,1,1,
															//bar28
															1,1,1,1,1,1,1,1,1,1,1,1,
															1,1,1,1,1,1,1,1,2,
															//outro
															1,1,1,2,2,1,1,1,1,1,2,
														   2,1,1,1,1,1,1,1,1,2,
															1,1,1,2,2,1,1,1,1,1,2,1,
															1,1,1,1,1,1,1,1,1,1,1,2,2};
															
															
					shortint i = $size(notes);	//for random tune size
					shortint j;	//for seaShanty size

  always_ff @(posedge FPGA_CLK1_50)
			begin
/////////////////////////////////////////////////////////
/////////////////RANDOM TUNE GENERATOR///////////////////
/////////////////////////////////////////////////////////
			
				if(start == 1) begin
					flag <= 'd1;
				end
				
				
				if(flag) begin
				
					//The decoded Frequencies are placed in the notes array
					notes[7:0] = '{rand_send0_Frequency,0,rand_send1_Frequency,0,rand_send2_Frequency,0,rand_send3_Frequency,0};
					//parameter i is set to the size of the notes array
					
					if(count1 <= 10000000*notelength[i])begin
						desiredFrequency <= notes[i];
						count1++;
					end
						
					else begin
							count1 <= 0;
							i--;
						if(i < 0) begin
							flag <= 0;
							i <= $size(notes);
						end
					end
						
				end
				
					
/////////////////////////////////////////////////////////
/////////////SEASHANTY (press button 12 (LOCK))//////////
/////////////////////////////////////////////////////////
				
				if(num == 12) begin
						flag2 <= 'd1;
					end
					
					else if(flag2) begin
					
							if(count2 <= 10000000*seaShantylength[j])begin
								desiredFrequency <= seaShanty[j];
								count2++;
							end
						
							else begin
								count2 <= 0;
								j--;
								if(j < 0) begin
									flag2 <= 0;
									j <= $size(seaShanty);
									end
							end
						
					end
					
/////////////////////////////////////////////////////////
//////////////////KEYBOARD FREEMODE//////////////////////
/////////////////////////////////////////////////////////		
				else begin
				
					
					case(num)	//cases for the input 'num'
						 //values 0-9,14,15 represent notes
						 0 : begin  desiredFrequency <= 'd466; end //A#
						 1 : begin  desiredFrequency <= 'd261; end //C
						 2 : begin 	desiredFrequency <= 'd277; end //C#
						 3 : begin 	desiredFrequency <= 'd294; end //D
						 4 : begin 	desiredFrequency <= 'd311; end //D#
						 5 : begin 	desiredFrequency <= 'd330; end //E
						 6 : begin 	desiredFrequency <= 'd349; end //F
						 7 : begin	desiredFrequency <= 'd370; end //F#
						 8 : begin	desiredFrequency <= 'd392; end //G
						 9 : begin	desiredFrequency <= 'd415; end //G#
						 14 : begin	desiredFrequency <= 'd440; end //A
						 15 : begin	desiredFrequency <= 'd494; end //B
						 
						 //values 10-13 represent game operations
						 10 : begin	desiredFrequency <= 'd0; end
						 //11 : begin desiredFrequency <= 'dffff; flag <= 'd1;
						 12 : begin	desiredFrequency <= 'd0; end
						 13 : begin	desiredFrequency <= 'd0; end					 
						 default: begin desiredFrequency <= 'd0; end //default goes to zero yet, constant tone		
					endcase
				end
			end
    
endmodule
