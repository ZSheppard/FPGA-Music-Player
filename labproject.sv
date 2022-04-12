// labproject.sv - top-level module for ELEX 7660 labproject
// Zachary Sheppard  March 4, 2021

module labproject ( output logic [3:0] kpc,  // column select, active-low
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *)
              input logic  [3:0] kpr,  // rows, active-low w/ pull-ups
              output logic [7:0] leds, // active-low LED segments 
              output logic [3:0] ct,   // " digit enables
				  output logic [3:0] rand_send0,rand_send1,rand_send2,rand_send3,
				  output logic [31:0] rand_send0_Frequency,
											 rand_send1_Frequency,
											 rand_send2_Frequency,
											 rand_send3_Frequency,
				  output logic spkr,start,
				  //output logic [3:0] num_rand, //where the random number is set and outputted to kpdecode
				  input logic [1:0] digit,
              input logic  reset_n, FPGA_CLK1_50);

   logic clk, kphit;                  		
	logic [3:0] num;
	logic [3:0] randNum;
	logic [3:0] randNum2;	//assigns random value for tones
	logic [11:0] rand_cat,rand_stored;	//constantly changing 12 digit variable; 12 digit variable locked for display state
	logic [31:0] desiredFrequency; 	// desired note frequency (e.g C = 261Hz, A = 440Hz etc.)
	
   //assign ct = { {3{1'b0}}, kphit } ;
	//assign ct = {kphit, 3'b000 } ;
   pll pll0 ( .inclk0(FPGA_CLK1_50), .c0(clk) ) ;
	

   // instantiate your modules here...
	colseq colseq_0 (.*);
	kpdecode kpdecode_0 (.*);
	decode2 decode2_0 (.*);
	decode7 decode7_0 (.*);
	//lfsr lfsr_0 (.*);
	//playLatch playLatch_0 (.*);
	//tonegen tonegen_0 (.*);
	randNumberGenerator randNumberGenerator_0 (FPGA_CLK1_50, reset_n, 3'd2,rand_cat[11:9]);	//produces random number to create a random tune
	randNumberGenerator randNumberGenerator_1 (FPGA_CLK1_50, reset_n, 3'd3,rand_cat[8:6]);
	randNumberGenerator randNumberGenerator_2 (FPGA_CLK1_50, reset_n, 3'd5,rand_cat[5:3]);
	randNumberGenerator randNumberGenerator_3 (FPGA_CLK1_50, reset_n, 3'd7,rand_cat[2:0]);
	decodeSPKR decodeSPKR_0 (.*);	//takes multiple inputs and assigns a desiredFrequency
	MusicBox MusicBox_0 (.*);	//Uses desiredFrequency input to generate an output on spkr
	

	
	enum {menu,init,display} state = menu, statenext;
	
	/*
	always_ff @(posedge FPGA_CLK1_50) begin
	
		if(state == menu)
				rand_stored <= rand_cat;
		else
				rand_stored <= rand_stored;
	
	end
	*/
	
	always_ff @(posedge FPGA_CLK1_50) begin
		
		
		state <= statenext;
		
		case(state)
			
			menu: begin
				rand_stored <= rand_cat;
				start <= 0;
			end
			
			init: begin
				rand_stored <= rand_stored;
			end
			
			display: begin
				rand_send0 <= rand_stored[11:9];
				rand_send1 <= rand_stored[8:6];
				rand_send2 <= rand_stored[5:3];
				rand_send3 <= rand_stored[2:0];
				
				//Each of the four random numbers must first be decoded into a frequency
				case(rand_send0)
						0 : begin  rand_send0_Frequency <= 'd466; end //A#
						1 : begin  rand_send0_Frequency <= 'd261; end //C
						2 : begin  rand_send0_Frequency <= 'd277; end //C#
						3 : begin  rand_send0_Frequency <= 'd294; end //D
					   4 : begin  rand_send0_Frequency<= 'd311; end //D#
						5 : begin  rand_send0_Frequency <= 'd330; end //E
					   6 : begin  rand_send0_Frequency <= 'd349; end //F
						7 : begin  rand_send0_Frequency <= 'd370; end //F#
						default: begin rand_send0_Frequency <= 'd466; end
					endcase
					
					case(rand_send1)
						0 : begin  rand_send1_Frequency <= 'd466; end //A#
						1 : begin  rand_send1_Frequency <= 'd261; end //C
						2 : begin  rand_send1_Frequency <= 'd277; end //C#
						3 : begin  rand_send1_Frequency <= 'd294; end //D
					   4 : begin  rand_send1_Frequency <= 'd311; end //D#
						5 : begin  rand_send1_Frequency <= 'd330; end //E
					   6 : begin  rand_send1_Frequency <= 'd349; end //F
						7 : begin  rand_send1_Frequency <= 'd370; end //F#
						default: begin rand_send1_Frequency <= 'd466; end
					endcase
					
					case(rand_send2)
						0 : begin  rand_send2_Frequency <= 'd466; end //A#
						1 : begin  rand_send2_Frequency <= 'd261; end //C
						2 : begin  rand_send2_Frequency <= 'd277; end //C#
						3 : begin  rand_send2_Frequency <= 'd294; end //D
					   4 : begin  rand_send2_Frequency<= 'd311; end //D#
						5 : begin  rand_send2_Frequency <= 'd330; end //E
					   6 : begin  rand_send2_Frequency <= 'd349; end //F
						7 : begin  rand_send2_Frequency <= 'd370; end //F#
						default: begin rand_send2_Frequency <= 'd466; end
					endcase
					
					case(rand_send3)
						0 : begin  rand_send3_Frequency <= 'd466; end //A#
						1 : begin  rand_send3_Frequency <= 'd261; end //C
						2 : begin  rand_send3_Frequency <= 'd277; end //C#
						3 : begin  rand_send3_Frequency <= 'd294; end //D
					   4 : begin  rand_send3_Frequency<= 'd311; end //D#
						5 : begin  rand_send3_Frequency <= 'd330; end //E
					   6 : begin  rand_send3_Frequency <= 'd349; end //F
						7 : begin  rand_send3_Frequency <= 'd370; end //F#
						default: begin rand_send3_Frequency <= 'd466; end
					endcase
				start<= 1;
				
				
			end
		endcase
	end
	
	
	always_comb begin
	
		case(state)
			menu: begin
					if(num == 11)
							statenext = init;
					else
						statenext = menu;
				end
			//clears counts, resets random tone notes.
			init:	
					statenext = display;
			
			display: begin
						statenext = menu;
				end

		endcase
		
	end
	

endmodule

// megafunction wizard: %ALTPLL%
// ...
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
// ...

module pll ( inclk0, c0);

        input     inclk0;
        output    c0;

        wire [0:0] sub_wire2 = 1'h0;
        wire [4:0] sub_wire3;
        wire  sub_wire0 = inclk0;
        wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
        wire [0:0] sub_wire4 = sub_wire3[0:0];
        wire  c0 = sub_wire4;

        altpll altpll_component ( .inclk (sub_wire1), .clk
          (sub_wire3), .activeclock (), .areset (1'b0), .clkbad
          (), .clkena ({6{1'b1}}), .clkloss (), .clkswitch
          (1'b0), .configupdate (1'b0), .enable0 (), .enable1 (),
          .extclk (), .extclkena ({4{1'b1}}), .fbin (1'b1),
          .fbmimicbidir (), .fbout (), .fref (), .icdrclk (),
          .locked (), .pfdena (1'b1), .phasecounterselect
          ({4{1'b1}}), .phasedone (), .phasestep (1'b1),
          .phaseupdown (1'b1), .pllena (1'b1), .scanaclr (1'b0),
          .scanclk (1'b0), .scanclkena (1'b1), .scandata (1'b0),
          .scandataout (), .scandone (), .scanread (1'b0),
          .scanwrite (1'b0), .sclkout0 (), .sclkout1 (),
          .vcooverrange (), .vcounderrange ());

        defparam
                altpll_component.bandwidth_type = "AUTO",
                altpll_component.clk0_divide_by = 25000,
                altpll_component.clk0_duty_cycle = 50,
                altpll_component.clk0_multiply_by = 1,
                altpll_component.clk0_phase_shift = "0",
                altpll_component.compensate_clock = "CLK0",
                altpll_component.inclk0_input_frequency = 20000,
                altpll_component.intended_device_family = "Cyclone IV E",
                altpll_component.lpm_hint = "CBX_MODULE_PREFIX=lab1clk",
                altpll_component.lpm_type = "altpll",
                altpll_component.operation_mode = "NORMAL",
                altpll_component.pll_type = "AUTO",
                altpll_component.port_activeclock = "PORT_UNUSED",
                altpll_component.port_areset = "PORT_UNUSED",
                altpll_component.port_clkbad0 = "PORT_UNUSED",
                altpll_component.port_clkbad1 = "PORT_UNUSED",
                altpll_component.port_clkloss = "PORT_UNUSED",
                altpll_component.port_clkswitch = "PORT_UNUSED",
                altpll_component.port_configupdate = "PORT_UNUSED",
                altpll_component.port_fbin = "PORT_UNUSED",
                altpll_component.port_inclk0 = "PORT_USED",
                altpll_component.port_inclk1 = "PORT_UNUSED",
                altpll_component.port_locked = "PORT_UNUSED",
                altpll_component.port_pfdena = "PORT_UNUSED",
                altpll_component.port_phasecounterselect = "PORT_UNUSED",
                altpll_component.port_phasedone = "PORT_UNUSED",
                altpll_component.port_phasestep = "PORT_UNUSED",
                altpll_component.port_phaseupdown = "PORT_UNUSED",
                altpll_component.port_pllena = "PORT_UNUSED",
                altpll_component.port_scanaclr = "PORT_UNUSED",
                altpll_component.port_scanclk = "PORT_UNUSED",
                altpll_component.port_scanclkena = "PORT_UNUSED",
                altpll_component.port_scandata = "PORT_UNUSED",
                altpll_component.port_scandataout = "PORT_UNUSED",
                altpll_component.port_scandone = "PORT_UNUSED",
                altpll_component.port_scanread = "PORT_UNUSED",
                altpll_component.port_scanwrite = "PORT_UNUSED",
                altpll_component.port_clk0 = "PORT_USED",
                altpll_component.port_clk1 = "PORT_UNUSED",
                altpll_component.port_clk2 = "PORT_UNUSED",
                altpll_component.port_clk3 = "PORT_UNUSED",
                altpll_component.port_clk4 = "PORT_UNUSED",
                altpll_component.port_clk5 = "PORT_UNUSED",
                altpll_component.port_clkena0 = "PORT_UNUSED",
                altpll_component.port_clkena1 = "PORT_UNUSED",
                altpll_component.port_clkena2 = "PORT_UNUSED",
                altpll_component.port_clkena3 = "PORT_UNUSED",
                altpll_component.port_clkena4 = "PORT_UNUSED",
                altpll_component.port_clkena5 = "PORT_UNUSED",
                altpll_component.port_extclk0 = "PORT_UNUSED",
                altpll_component.port_extclk1 = "PORT_UNUSED",
                altpll_component.port_extclk2 = "PORT_UNUSED",
                altpll_component.port_extclk3 = "PORT_UNUSED",
                altpll_component.width_clock = 5;


endmodule
