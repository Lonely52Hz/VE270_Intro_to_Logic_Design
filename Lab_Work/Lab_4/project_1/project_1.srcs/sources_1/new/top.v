`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/22 00:40:30
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top (clock,reset,updown,Q,ssd);
	parameter N = 4;
	input clock, reset, updown;
	output reg [N-1:0] Q;
	output reg [6:0] ssd;
	
	always @ (posedge reset or posedge clock)
		if (reset == 1'b1) Q <= 0;
		else if (updown == 1'b1) Q <= Q+1;
		else if (updown == 1'b0) Q <= Q-1;

	always @ (Q)
	begin
		case (Q)
			4'b0000: ssd = 7'b0000001;
			4'b0001: ssd = 7'b1001111;
			4'b0010: ssd = 7'b0010010;
			4'b0011: ssd = 7'b0000110;
			4'b0100: ssd = 7'b1001100;
			4'b0101: ssd = 7'b0100100;
			4'b0110: ssd = 7'b0100000;
			4'b0111: ssd = 7'b0001111;
			4'b1000: ssd = 7'b0000000;
			4'b1001: ssd = 7'b0000100;
			4'b1010: ssd = 7'b0001000;
			4'b1011: ssd = 7'b1100000;
			4'b1100: ssd = 7'b0110001;
			4'b1101: ssd = 7'b1000010;
			4'b1110: ssd = 7'b0110000;
			4'b1111: ssd = 7'b0111000;
		endcase
	end
endmodule

