`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:38:02 11/23/2021 
// Design Name: 
// Module Name:    PC_reg 
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
module PC_reg(
	 input PC_clk_i,
	 input PC_reset_i,
	 input [31:0] PC_reg_i,
    output [31:0] PC_reg_o,
	 input PCDshall
    );
reg [31:0]	PC;
initial
	PC = 32'h00003000;
assign PC_reg_o = PC;
always@(posedge PC_clk_i) begin
	if(PC_reset_i == 1)
		PC <= 32'h00003000;
	else if(PCDshall)
		PC <= PC;
	else
		PC <= PC_reg_i;
end
endmodule
