`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:19:52 11/20/2021 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input [4:0] RA1,
    input [4:0] RA2,
    input [4:0] RA3,
    input [31:0] R_WD_i,
    input Rclk,
    input Rreset,
	 input [31:0] GRFPC,
    output [31:0] RD1,
    output [31:0] RD2,
	 input WE,
	 input [31:0] instr_before,
	 input [31:0] instr_bbefore,
	 input [31:0] instr_wrong
    );
reg [31:0]	Reg [31:0];
integer i;
assign RD1 = (RA1 == RA3 && WE == 1 &&  RA1 != 0)	?	R_WD_i	:	Reg[RA1];	//内部转发
assign RD2 = (RA2 == RA3 && WE == 1 &&  RA2 != 0)	?	R_WD_i	:	Reg[RA2];
initial begin
	for(i=0; i<32; i = i+1) begin
		Reg[i] = 0;
	end
end
always@(posedge Rclk) begin
	if(Rreset) begin
		for(i=0; i<32; i = i+1) begin
			Reg[i] <= 0;
		end
	end
	else if(RA3 == 0)
		Reg[0] <= 0;
	else if(WE == 1) begin
//		$display("%d@%h: $%d <= %h", $time, GRFPC, RA3,R_WD_i);
		Reg[RA3] <= R_WD_i;
	end
end
endmodule
