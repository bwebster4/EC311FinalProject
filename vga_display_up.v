`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Zafar M. Takhirov
// 
// Create Date:    12:59:40 04/12/2011 
// Design Name: EC311 Support Files
// Module Name:    vga_display 
// Project Name: Lab5 / Lab6 / Project
// Target Devices: xc6slx16-3csg324
// Tool versions: XILINX ISE 13.3
// Description: 
//
// Dependencies: vga_controller_640_60
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_display(clk, boxes, R, G, B, HS, VS, LED_Seg, LED_Val);
	//end game 
	reg [1:0] state;
	reg [12:0] game_over_counter;
	reg [10:0] round_over_counter;
	 
	 wire rst = state[1] & state[0];  // global reset
    input clk;  // 100MHz clk
    
    // color inputs for a given pixel	 
	 reg [7:0] white = 8'b11111111;
	
    // color outputs to show on display (current pixel)
    output reg [2:0] R, G;
    output reg [1:0] B;
    
	 //box input
	 input [4:0] boxes;
	 
    // Synchronization signals
    output HS;
    output VS;
    
    // controls:
    wire [10:0] hcount, vcount; // coordinates for the current pixel
    wire blank; // signal to indicate the current coordinate is blank
	 
	// memory interface:
	reg [14:0] addra;
	wire [7:0] douta;
	wire [10:0] x0, y0, x1, y1;
	assign x0 = (0+100); 
	assign y0 = (0+100);
	assign x1 = (343+100);
	assign y1 = (47+100);
	reg [9:0] x, y;
	// define spaces
	//integer [8:0] spaces;
	 
	// LEDmux
	output	 	[6:0] LED_Seg;
	output		[3:0] LED_Val;
	reg [1:0] select;
	reg [3:0] bin, pos_1, dash, pos_4;
	LEDmux led(bin, select, LED_Seg, LED_Val);
	 
    /////////////////////////////////////////////////////
    // Begin clock division
   parameter N = 2;// parameter for clock division
	parameter M = 17;
	reg clk_25Mhz;
	reg clk_1KHz;
   reg [N-1:0] count;
	reg [M-1:0] count2;
   always @ (posedge clk) begin
      count <= count + 1'b1;
		count2 <= count2 + 1'b1;
      clk_25Mhz <= count[N-1];
		clk_1KHz <= count2[M-1];
    end
    // End clock division
    /////////////////////////////////////////////////////
    
	//debouncer
	wire [4:0] db_boxes;
	debouncer db0(clk_1KHz, boxes[0], db_boxes[0]);
	debouncer db1(clk_1KHz, boxes[1], db_boxes[1]); 
	debouncer db2(clk_1KHz, boxes[2], db_boxes[2]); 
	debouncer db3(clk_1KHz, boxes[3], db_boxes[3]); 
	debouncer db4(clk_1KHz, boxes[4], db_boxes[4]); 	 
	 
	 
    // Call driver
   vga_controller_640_60 vc(
	  .rst(rst), 
	  .pixel_clk(clk_25Mhz), 
	  .HS(HS), 
	  .VS(VS), 
	  .hcounter(hcount), 
	  .vcounter(vcount), 
	  .blank(blank));
	
	game_over_mem memory_1 (
		.clka(clk_25Mhz), // input clka
		.addra(addra), // input [14 : 0] addra
		.douta(douta) // output [7 : 0] douta
	);
    
   // create a lines:
	wire left_vert; 
	assign left_vert = ~blank & (hcount >= 208 & hcount <= 218); // & vcount >= 167 & vcount <= 367);
	wire right_vert; 
	assign right_vert = ~blank & (hcount >= 421 & hcount <= 431); 
	wire top_hor; 
	assign top_hor = ~blank & (vcount >= 155 & vcount <= 165); 
	wire bot_hor; 
	assign bot_hor = ~blank & (vcount >= 315 & vcount <= 325); 
	
//	define x and o
//	wire x, o;
//	assign x = ~blank & ((hcount >= 102 & hcount <= 112 & vcount >= 20 & vcount <= 140) | (hcount >= 20 & hcount <= 188 & vcount >= 75 & vcount <= 85));
//	assign o = ~blank & (hcount >= 20 & hcount <= 188 & vcount >= 20 & vcount <= 140) & ~(hcount >= 30 & hcount <= 178 & vcount >= 30 & vcount <= 130);
	
	// boxes
	reg xocount;
	wire box_1x, box_2x, box_3x, box_4x, box_5x, box_6x, box_7x, box_8x, box_9x;
	wire box_1o, box_2o, box_3o, box_4o, box_5o, box_6o, box_7o, box_8o, box_9o;
	reg [8:0] box_assigned, box_val;
	assign box_1x = ~blank & ((hcount >= 102 & hcount <= 112 & vcount >= 20 & vcount <= 140) | (hcount >= 20 & hcount <= 188 & vcount >= 75 & vcount <= 85));
	assign box_1o = ~blank & (hcount >= 20 & hcount <= 188 & vcount >= 20 & vcount <= 140) & ~(hcount >= 30 & hcount <= 178 & vcount >= 30 & vcount <= 130);
	assign box_2x = ~blank & ((hcount >= 314 & hcount <= 324 & vcount >= 10 & vcount <= 145) | (hcount >= 228 & hcount <= 411 & vcount >= 62 & vcount <= 72));
	assign box_3x = ~blank & ((hcount >= 530 & hcount <= 540 & vcount >= 10 & vcount <= 145) | (hcount >= 441 & hcount <= 629 & vcount >= 62 & vcount <= 72));
	assign box_4x = ~blank & ((hcount >= 99 & hcount <= 109 & vcount >= 175 & vcount <= 305) | (hcount >= 10 & hcount <= 198 & vcount >= 235 & vcount <= 245));
	assign box_5x = ~blank & ((hcount >= 314 & hcount <= 324 & vcount >= 175 & vcount <= 305) | (hcount >= 228 & hcount <= 411 & vcount >= 235 & vcount <= 245));
	assign box_6x = ~blank & ((hcount >= 530 & hcount <= 540 & vcount >= 175 & vcount <= 305) | (hcount >= 441 & hcount <= 629 & vcount >= 234 & vcount <= 245));
	assign box_7x = ~blank & ((hcount >= 99 & hcount <= 109 & vcount >= 335 & vcount <= 470) | (hcount >= 10 & hcount <= 198 & vcount >= 397 & vcount <= 407));
	assign box_8x = ~blank & ((hcount >= 314 & hcount <= 324 & vcount >= 335 & vcount <= 470) | (hcount >= 228 & hcount <= 411 & vcount >= 397 & vcount <= 407));
	assign box_9x = ~blank & ((hcount >= 530 & hcount <= 540 & vcount >= 335 & vcount <= 470) | (hcount >= 441 & hcount <= 629 & vcount >= 397 & vcount <= 407));
	assign box_2o = ~blank & (hcount >= 238 & hcount <= 402 & vcount >= 20 & vcount <= 140) & ~(hcount >= 248 & hcount <= 392 & vcount >= 30 & vcount <= 130);
	assign box_3o = ~blank & (hcount >= 452 & hcount <= 620 & vcount >= 20 & vcount <= 140) & ~(hcount >= 462 & hcount <= 610 & vcount >= 30 & vcount <= 130);
	assign box_4o = ~blank & (hcount >= 20 & hcount <= 188 & vcount >= 185 & vcount <= 295) & ~(hcount >= 30 & hcount <= 178 & vcount >= 195 & vcount <= 285);
	assign box_5o = ~blank & (hcount >= 238 & hcount <= 402 & vcount >= 185 & vcount <= 295) & ~(hcount >= 248 & hcount <= 392 & vcount >= 195 & vcount <= 285);
	assign box_6o = ~blank & (hcount >= 452 & hcount <= 620 & vcount >= 185 & vcount <= 295) & ~(hcount >= 462 & hcount <= 610 & vcount >= 195 & vcount <= 285);
	assign box_7o = ~blank & (hcount >= 20 & hcount <= 188 & vcount >= 345 & vcount <= 460) & ~(hcount >= 30 & hcount <= 178 & vcount >= 355 & vcount <= 450);
	assign box_8o = ~blank & (hcount >= 238 & hcount <= 402 & vcount >= 345 & vcount <= 460) & ~(hcount >= 248 & hcount <= 392 & vcount >= 355 & vcount <= 450);
	assign box_9o = ~blank & (hcount >= 452 & hcount <= 620 & vcount >= 345 & vcount <= 460) & ~(hcount >= 462 & hcount <= 610 & vcount >= 355 & vcount <= 450);


	
	// initialization
	initial begin
		pos_1 = 0;
		pos_4 = 0;
		dash = 15;
		xocount = 0;
		box_assigned = 0;
		box_val = 0;
		state = 0;
		game_over_counter = 0;
		round_over_counter = 0;
	end
	
    // update
   always @ (posedge clk_1KHz) begin
	
		select = select + 2'b1;
		case(select)
			2'b00:	bin = pos_1;
			2'b01:	bin = dash;
			2'b10:	bin = dash;
			2'b11:	bin = pos_4;
		endcase
	
		case(state)
			2'b00: begin

				
				case(db_boxes)
					5'b00011:	begin
										if(~box_assigned[0]) begin 
											box_val[0] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[0] = 1;
										end
									end
					5'b00001:	begin
										if(~box_assigned[1]) begin 
											box_val[1] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[1] = 1;
										end
									end
					5'b01001:	begin
										if(~box_assigned[2]) begin 
											box_val[2] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[2] = 1;
										end
									end
					5'b00010:	begin
										if(~box_assigned[3]) begin 
											box_val[3] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[3] = 1;
										end
									end
					5'b00100:	begin
										if(~box_assigned[4]) begin 
											box_val[4] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[4] = 1;
										end
									end
					5'b01000:	begin
										if(~box_assigned[5]) begin 
											box_val[5] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[5] = 1;
										end
									end
					5'b10010:	begin
										if(~box_assigned[6]) begin 
											box_val[6] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[6] = 1;
										end
									end
					5'b10000:	begin
										if(~box_assigned[7]) begin 
											box_val[7] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[7] = 1;
										end
									end
					5'b11000:	begin
										if(~box_assigned[8]) begin 
											box_val[8] = xocount;
											xocount = xocount + 1'b1;
											
											box_assigned[8] = 1;
										end
									end

				endcase	
				
				if(box_assigned[0] & box_val[0] & box_assigned[1] & box_val[1] & box_assigned[2] & box_val[2] |
					box_assigned[3] & box_val[3] & box_assigned[4] & box_val[4] & box_assigned[5] & box_val[5] |
					box_assigned[6] & box_val[6] & box_assigned[7] & box_val[7] & box_assigned[8] & box_val[8] |
					box_assigned[0] & box_val[0] & box_assigned[3] & box_val[3] & box_assigned[6] & box_val[6] |
					box_assigned[1] & box_val[1] & box_assigned[4] & box_val[4] & box_assigned[7] & box_val[7] |
					box_assigned[2] & box_val[2] & box_assigned[5] & box_val[5] & box_assigned[8] & box_val[8] |
					box_assigned[0] & box_val[0] & box_assigned[4] & box_val[4] & box_assigned[8] & box_val[8] |
					box_assigned[2] & box_val[2] & box_assigned[4] & box_val[4] & box_assigned[6] & box_val[6] 
					) begin
					pos_4 = pos_4 + 1'b1;
					state = 2'b01;
				end
				if(box_assigned[0] & ~box_val[0] & box_assigned[1] & ~box_val[1] & box_assigned[2] & ~box_val[2] |
					box_assigned[3] & ~box_val[3] & box_assigned[4] & ~box_val[4] & box_assigned[5] & ~box_val[5] |
					box_assigned[6] & ~box_val[6] & box_assigned[7] & ~box_val[7] & box_assigned[8] & ~box_val[8] |
					box_assigned[0] & ~box_val[0] & box_assigned[3] & ~box_val[3] & box_assigned[6] & ~box_val[6] |
					box_assigned[1] & ~box_val[1] & box_assigned[4] & ~box_val[4] & box_assigned[7] & ~box_val[7] |
					box_assigned[2] & ~box_val[2] & box_assigned[5] & ~box_val[5] & box_assigned[8] & ~box_val[8] |
					box_assigned[0] & ~box_val[0] & box_assigned[4] & ~box_val[4] & box_assigned[8] & ~box_val[8] |
					box_assigned[2] & ~box_val[2] & box_assigned[4] & ~box_val[4] & box_assigned[6] & ~box_val[6]
					) begin
					pos_1 = pos_1 + 1'b1;
					state = 2'b01;
				end
				if(box_assigned == 9'b111111111) begin
					state = 2'b01;
				end
			end
			2'b01: begin
				round_over_counter = round_over_counter + 1'b1;
				if(round_over_counter == 11'b11111111111) begin
					round_over_counter = 0;
					if(pos_1 == 3 | pos_4 == 3) begin
						state = 2'b10;
					end
					else begin
						box_assigned = 0;
						state = 2'b00;
					end
				end
			end
			2'b10: begin
				game_over_counter = game_over_counter + 1'b1;
				if(game_over_counter == 13'b1111111111111) begin
					state = 2'b11;
				end
			end
			2'b11: begin
				pos_1 = 0;
				pos_4 = 0;
				dash = 15;
				xocount = 0;
				box_assigned = 0;
				box_val = 0;
				state = 0;
				game_over_counter = 0;
				round_over_counter = 0;
			end
		endcase
	end
		
	always @ (posedge clk) begin
		if(state == 2'b10) begin
			if (hcount >= x0 & hcount < x1)		// make sure thath x1-x0 = image_width
				x = hcount-x0;	// offset the coordinates
			else
				x = 0;
				
			if (vcount >= y0 & vcount < y1)		// make sure that y1-y0 = image_height
				y = vcount - y0;	//offset the coordinates
			else
				y = 0;
				
			addra = y * 344 + x; // calculate the address
			// rom_addr = y*image_width + x
			
			if (x==0 & y==0)		// set the color output
				{R,G,B} = 8'd255;
			else
				{R,G,B} = douta;
		end
		else begin
			if (left_vert | right_vert | top_hor | bot_hor |
				(box_assigned[0] & box_val[0] & box_1x) | 
				(box_assigned[1] & box_val[1] & box_2x) |
				(box_assigned[2] & box_val[2] & box_3x) |
				(box_assigned[3] & box_val[3] & box_4x) |
				(box_assigned[4] & box_val[4] & box_5x) |
				(box_assigned[5] & box_val[5] & box_6x) |
				(box_assigned[6] & box_val[6] & box_7x) |
				(box_assigned[7] & box_val[7] & box_8x) |
				(box_assigned[8] & box_val[8] & box_9x) |
				(box_assigned[0] & ~box_val[0] & box_1o) |
				(box_assigned[1] & ~box_val[1] & box_2o) |
				(box_assigned[2] & ~box_val[2] & box_3o) |
				(box_assigned[3] & ~box_val[3] & box_4o) |
				(box_assigned[4] & ~box_val[4] & box_5o) |
				(box_assigned[5] & ~box_val[5] & box_6o) |
				(box_assigned[6] & ~box_val[6] & box_7o) |
				(box_assigned[7] & ~box_val[7] & box_8o) |
				(box_assigned[8] & ~box_val[8] & box_9o)
			) begin   // if you are within the valid region
				R = white[7:5];
				G = white[4:2];
				B = white[1:0];
			end
			else begin  // if you are outside the valid region
				R = 0;
				G = 0;
				B = 0;
			end
		end
	end

endmodule
