module decode2 (input logic [3:0] num,
						input logic kphit,
						output logic [3:0] ct);
						
always_comb
/*
	case (num)	//cases for the input 'digit'
		0 : ct = 4'b0001;	//clock at value 0 will select the right most 7 segment display (ct[0], count bit-0)
		1 : ct = 4'b0010;
		2 : ct = 4'b0100;
		3 : ct = 4'b1000;
	endcase		
*/

		if(num == 11)
			ct = 4'b1000;
		else
			ct = { {3{1'b0}}, kphit };

endmodule