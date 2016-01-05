//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	binary_to_segment
// Project Name: 	Lab4 / Project
// Description:
//					This module receives a 4-bit input and converts it to 7-segment
//					LED (HEX)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: INCOMPLETE CODE
//
//////////////////////////////////////////////////////////////////////////////////

module binary_to_segment(bin,seven);	
input [3:0] bin;
output reg [6:0] seven; //Assume MSB is A, and LSB is G	

initial	//Initial block, used for correct simulations	
	seven=0;

always @ (*)
	case(bin)	
		0:	//	Some code here
		1:	//	and here	
			//	.........
		15: seven = 7'b0111000; // This will show F	
		//remember 0 means 'light-up'
		default: //Something here	
	endcase
endmodule	