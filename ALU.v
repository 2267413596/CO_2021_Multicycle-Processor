`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:07 11/21/2021 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOP_i,
    output [31:0] AO
    );
/*integer i;
reg [31:0] x;
always@(*) begin
	x = B;
	if(B[0] == 0) begin
		for(i = 0; i < B; i = i+1) begin
			x = {{x[0]},{x[31:1]}};
		end
	end
	else begin
		for(i = 0; i < B; i = i+1) begin
			x = {{x[30:0]},{x[31]}};
		end
	end
end*/
wire less = ($signed(A) < $signed(B))	?	1	:	0;
wire lessu = (A < B)	?	1	:	0;
assign AO =	(ALUOP_i == `aluOr)	?	A | B	:
				(ALUOP_i == `aluAnd)	?	A & B	:
				(ALUOP_i == `aluAdd)	?	A + B	:
				(ALUOP_i == `aluSub)	?	A - B	:
				(ALUOP_i == `imm)		?	B		:
				(ALUOP_i == `aluXor)	?	A ^ B	:
				(ALUOP_i == `aluNor)	?	~(A|B):
				(ALUOP_i == `aluSll)	?	(B << A[4:0]):
				(ALUOP_i == `aluSrl)	?	(B >> A[4:0]):
				(ALUOP_i == `aluSra)	?	$signed($signed(B) >>> A[4:0]):
				(ALUOP_i == `aluSlt)	?	less	:
				(ALUOP_i == `aluSltu)?	lessu	:
				0;

endmodule
