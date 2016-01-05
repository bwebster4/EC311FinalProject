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

module binary_to_segment_decimal(bin,seven);	
input [3:0] bin;
output reg [6:0] seven; //Assume Most Significant Bit is A, and LSB is G

initial	//Initial block, used for correct simulations	
	seven=0;

always @ (*)
	case(bin)	
		0:	seven = 7'b0000001; //Display 0
		1:	seven = 7'b1001111; //Display 1
		2:	seven = 7'b0010010; //Display 2
		3: seven = 7'b0000110; //Display 3
		4: seven = 7'b1001100; //Display 4
		5: seven = 7'b0100100; //Display 5
		6: seven = 7'b0100000; //Display 6
		7: seven = 7'b0001111; //Display 7
		8: seven = 7'b0000000; //Display 8
		9: seven = 7'b0000100; //Display 9
		10: seven = 7'b1111110; //Display _
		11: seven = 7'b1111110; //Display _
		12: seven = 7'b1111110; //Display _
		13: seven = 7'b1111110; //Display _
		14: seven = 7'b1111110; //Display _
		15: seven = 7'b1111110; //Display _
		//remember 0 means 'light-up'
		default: seven = 7'b1110111; //Display _
	endcase
endmodule	