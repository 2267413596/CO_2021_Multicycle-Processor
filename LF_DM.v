`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:37 12/11/2021 
// Design Name: 
// Module Name:    LF_DM 
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
`include"constants.v"
module LF_DM(
    input [2:0] l_type,
    input [31:0] DM_RD,
    input [31:0] LF_D,
	 input [1:0] A
    );
assign LF_D = 	(l_type == `lword)							?	DM_RD										:
					(l_type == `lhalf && A[1] == 0)			?	{{16{DM_RD[15]}},{DM_RD[15:0]}}	:
					(l_type == `lhalf && A[1] == 1)			?	{{16{DM_RD[31]}},{DM_RD[31:16]}}	:
					(l_type == `lhalfu && A[1] == 0)			?	{{16{1'b0}},{DM_RD[15:0]}}			:
					(l_type == `lhalfu && A[1] == 1)			?	{{16{1'b0}},{DM_RD[31:16]}}		:
					(l_type == `lbyte && A[1:0] == 2'b00)	?	{{24{DM_RD[7]}},{DM_RD[7:0]}}		:
					(l_type == `lbyte && A[1:0] == 2'b01)	?	{{24{DM_RD[15]}},{DM_RD[15:8]}}	:
					(l_type == `lbyte && A[1:0] == 2'b10)	?	{{24{DM_RD[23]}},{DM_RD[23:16]}}	:
					(l_type == `lbyte && A[1:0] == 2'b11)	?	{{24{DM_RD[31]}},{DM_RD[31:24]}}	:
					(l_type == `lbyteu && A[1:0] == 2'b00)	?	{{24{1'b0}},{DM_RD[7:0]}}			:
					(l_type == `lbyteu && A[1:0] == 2'b01)	?	{{24{1'b0}},{DM_RD[15:8]}}			:
					(l_type == `lbyteu && A[1:0] == 2'b10)	?	{{24{1'b0}},{DM_RD[23:16]}}		:
					(l_type == `lbyteu && A[1:0] == 2'b11)	?	{{24{1'b0}},{DM_RD[31:24]}}		:
					0;
endmodule
