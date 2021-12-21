`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:37 12/12/2021 
// Design Name: 
// Module Name:    store 
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
module store(
    input [3:0] s_type,
    input [31:0] s_ini_data,
    output [31:0] s_fix_data
    );
assign s_fix_data =	(s_type == `sword)	?	s_ini_data												:
							(s_type == `shl)		?	{{16{1'b0}},{s_ini_data[15:0]}}					:
							(s_type == `shu)		?	{{s_ini_data[15:0]},{16{1'b0}}}					:
							(s_type == `sbl)		?	{{24{1'b0}},{s_ini_data[7:0]}}					:
							(s_type == `sbm)		?	{{16{1'b0}},{s_ini_data[7:0]},{8{1'b0}}}		:
							(s_type == `sbh)		?	{{8{1'b0}},{s_ini_data[7:0]},{16{1'b0}}}	:
							(s_type == `sbu)		?	{{s_ini_data[7:0]},{24{1'b0}}}					:
							0;

endmodule
