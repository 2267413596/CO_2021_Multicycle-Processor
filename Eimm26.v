`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:04 11/26/2021 
// Design Name: 
// Module Name:    Eimm26 
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
//·ÅÔÚD¼¶
`include "constants.v"
module Eimm26(
    input [25:0] Ext_imm26,
    input [1:0] Eimm_sign_i,
    output [31:0] Extimm_o
    );
assign Extimm_o = {{4'b0000},{Ext_imm26},{2'b00}};

endmodule
