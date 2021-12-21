`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:53 12/08/2021 
// Design Name: 
// Module Name:    MulDiv 
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
module MulDiv(
    input [31:0] MULDIVA,
    input [31:0] MULDIVB,
    input [2:0] MULDIVOP_i,
    output busy_o,
    output [31:0] HLRD,
    input start,
	 input MULDIV_clk,
	 input MULDIV_reset,
	 input HL_src,
	 input HLWE
    );
reg busy;
reg [31:0] hi;
reg [31:0] lo;
reg [31:0] A;
reg [31:0] B;
reg [3:0] counter;
reg [3:0] state;
assign busy_o = busy;
assign HLRD = (HL_src)	?	hi : lo;

initial begin
	hi = 0;
	lo = 0;
	counter = `c_ini;
	state = 0;
	busy = 0;
	A = 0;
	B = 0;
end
assign busy_o = busy;
always@(posedge MULDIV_clk) begin
	if(MULDIV_reset) begin
		hi <= 0;
		lo <= 0;
		counter <= `c_ini;
		state <= 0;
		A <= 0;
		B <= 0;
	end
	else if(HLWE) begin
		if(HL_src)
			hi <= MULDIVA;
		else
			lo <= MULDIVA;
	end
	else begin
	case(state)
		0: begin
			if(start) begin
				counter <= `c_ini;
				busy <= 1;
				A <= MULDIVA;
				B <= MULDIVB;
				if(MULDIVOP_i == `MDMUL) begin
					state <= 1;
				end
				else if(MULDIVOP_i == `MDDIV) begin
					state <= 2;
				end
				else if(MULDIVOP_i == `MDMULU) begin
					state <= 3;
				end
				else if(MULDIVOP_i == `MDDIVU) begin
					state <= 4;
				end
			end
		end
		1: begin
			counter <= counter + 1;
			if(counter == 4)
				state <= 5;
		end
		2: begin
			counter <= counter + 1;
			if(counter == 9)
				state <= 6;
		end
		3: begin
			counter <= counter + 1;
			if(counter == 4)
				state <= 7;
		end
		4: begin
			counter <= counter + 1;
			if(counter == 9)
				state <= 8;
		end
		5: begin
			{hi,lo} <= $signed(A) * $signed(B);
			busy <= 0;
			state <= 0;
		end
		6: begin
			hi <= $signed($signed(A) % $signed(B));
			lo <= $signed($signed(A) / $signed(B));
			busy <= 0;
			state <= 0;
		end
		7: begin
			{hi,lo} <= A * B;
			busy <= 0;
			state <= 0;
		end
		8: begin
			hi <= A % B;
			lo <= A / B;
			busy <= 0;
			state <= 0;
		end
		default: state <= 9;
	endcase
	end
end
endmodule


