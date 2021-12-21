`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:55:29 11/26/2021 
// Design Name: 
// Module Name:    Plus4 
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
module Plus4(
    input [31:0] PC0,
    output [31:0] PC4_o
    );
assign PC4_o = PC0 + 4;

endmodule
