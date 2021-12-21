`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:24 11/26/2021 
// Design Name: 
// Module Name:    Eoff 
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
`include "constants.v"
module Eoff(
    input [15:0] Ext_offset_i,
    output [31:0] Ext_offset_o,
    input [1:0] Eoff_sign_i
    );
assign Ext_offset_o = 	(Eoff_sign_i == `Eoffz)	?	{{16'h0000},{Ext_offset_i}}	:
								(Eoff_sign_i == `Eoffu)	?	{{Ext_offset_i},{16'h0000}}	:
								(Eoff_sign_i == `Eoffs)	?	{{16{Ext_offset_i[15]}},{Ext_offset_i}}	:
								0;

endmodule
