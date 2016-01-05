`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:19 11/18/2015 
// Design Name: 
// Module Name:    LEDmux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LEDmux(bin,select,A,B);
	
	input 		[1:0] select;
	input		[3:0] bin;
	output	 	[6:0] A;
	output reg	[3:0] B;
	

	
binary_to_segment_decimal mod0(bin,A);

always @ (*)
	case(select)
		0:	B = 4'b1110;
		1:	B = 4'b1101;
		2:	B = 4'b1011;
		3:	B = 4'b0111;
	endcase


endmodule

