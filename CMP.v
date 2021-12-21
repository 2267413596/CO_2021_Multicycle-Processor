`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:09 11/20/2021 
// Design Name: 
// Module Name:    stage_D 
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
module CMP(
    input [31:0] CMPA,
    input [31:0] CMPB,
    output zero,
    output great,
    output less,
	 output lez,
	 output ltz
    );
wire [31:0] z;
assign z = 32'h0;
assign great = ($signed(CMPA) > $signed(CMPB))	?	1	:	0;
assign zero = 	($signed(CMPA) == $signed(CMPB))	?	1	:	0;
assign less = 	($signed(CMPA) < $signed(CMPB))	?	1	:	0;
assign lez = 	($signed(CMPA) <= $signed(z))		?	1	:	0;
assign ltz = 	($signed(CMPA) < $signed(z))		?	1	:	0;
endmodule
