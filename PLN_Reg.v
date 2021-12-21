`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:09 11/26/2021 
// Design Name: 
// Module Name:    PLN_Reg 
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

module D_PLN_Reg(
	input D_PLN_clk,
	input D_PLN_reset,
	input [31:0] D_instr_i,
	input [31:0] D_PC4_i,
	output [31:0] D_instr_o,
	output [31:0] D_PC4_o,
	
//D
	input D_Dshall_i,
	output [4:0] D_rs_o,
	output [4:0] D_rt_o
    );
	reg [31:0] instr;
	reg [31:0] PC4;

initial begin
	instr = 0;
	PC4 = 0;
end
always@(posedge D_PLN_clk) begin
	if(D_PLN_reset) begin
		instr <= 0;
		PC4 <= 0;
	end
	else if(D_Dshall_i) begin
		instr <= instr;
		PC4 <= PC4;
	end
	else begin
		instr <= D_instr_i;
		PC4 <= D_PC4_i;
	end
end
assign D_instr_o = instr;

assign D_rs_o = instr[25:21];
assign D_rt_o = instr[20:16];
assign D_PC4_o = PC4;


endmodule
module E_PLN_Reg(
	input E_PLN_clk,
	input E_PLN_reset,
	input [31:0] E_instr_i,
	input [31:0] E_PC4_i,
	input E_Dshall_i,
	output [31:0] E_instr_o,
	output [31:0] E_PC8_o,
	
//E
	input [31:0] E_V1_i,
	input [31:0] E_V2_i,
	output [31:0] E_V1_o,
	output [31:0] E_V2_o
//	input E_check_i,
//	output E_check_o
    );
	reg [31:0] instr;
	reg [31:0] PC4;
	reg [31:0] V1;
	reg [31:0] V2;
//	reg check;

initial begin
	instr = 0;
	PC4 = 0;
	V1 = 0;
	V2 = 0;
end
always@(posedge E_PLN_clk) begin
	if(E_PLN_reset) begin
		instr <= 0;
		PC4 <= 0;
		V1 <= 0;
		V2 <= 0;
//		check <= 0;
	end

	else if(E_Dshall_i) begin
		instr <= 0;
		PC4 <= 0;
		V1 <= 0;
		V2 <= 0;
//		check <= 0;
	end
	else begin
		instr <= E_instr_i;
		PC4 <= E_PC4_i;
		V1 <= E_V1_i;
		V2 <= E_V2_i;
//		check <= E_check_i;
	end
end

assign E_V1_o = V1;
assign E_V2_o = V2;
assign E_instr_o = instr;
assign E_PC8_o = PC4 + 4;
//assign E_check_o = check;

endmodule

//M
module M_PLN_Reg(
	input [4:0] M_Anew_i,
	input M_PLN_clk,
	input M_PLN_reset,
	input [31:0] M_instr_i,
	input [31:0] M_PC8_i,
	input [31:0] M_V2_i,
	output [31:0] M_instr_o,
	output [31:0] M_PC8_o,
	
	output [4:0] M_Anew_o,
//M
	input [31:0] M_AO_i,
	
	output [4:0] M_Ause_o,
	output [1:0] M_Tnew_o,
	output [31:0] M_AO_o,
	output [31:0] M_WD_o,
	output [5:0] M_op,
	input [31:0] M_HL_i,
	output [31:0] M_HL_o
//	input M_check_i,
//	output M_check_o
    );
	reg [31:0] instr;
	reg [31:0] PC8;
	reg [31:0] V2;
	reg [31:0] AO;
	reg [4:0]  Anew;
	reg check;
	reg [31:0] HL;
	wire [5:0] op;
	wire [5:0] func;
initial begin
	instr = 0;
	PC8 = 0;
	V2 = 0;
	AO = 0;
	Anew = 0;
	HL = 0;
end
always@(posedge M_PLN_clk) begin
	if(M_PLN_reset) begin
		instr <= 0;
		PC8 <= 0;
		V2 <= 0;
		AO <= 0;
		Anew <= 0;
		HL <= 0;
//		check <= 0;
	end
	else begin
		instr <= M_instr_i;
		PC8 <= M_PC8_i;
		V2 <= M_V2_i;
		AO <= M_AO_i;
		Anew <= M_Anew_i;
		HL <= M_HL_i;
//		check <= M_check_i;
	end
end
assign op = instr[31:26];
assign func = instr[5:0];

wire lui; wire lw; wire ori; wire jr; wire R; wire sw; wire j; wire jal; wire beq; wire subu; wire addu;wire nop;wire lb;wire lh;
wire lhu;wire lbu;wire sb; wire sh;wire add;wire sub;wire sll;wire srl;wire sra;wire sllv;wire srlv; wire srav;wire And;wire Or;
wire Xor;wire Nor;wire addi;wire addiu;wire slt;wire sltu;wire slti;wire sltiu;wire mult;wire multu;wire div;wire divu;
wire jalr;wire bne;wire blez;wire bgtz;wire bltz;wire bgez;wire xori;wire andi;
assign lui = (op == `lui);	assign lw = (op == `lw);	assign ori = (op == `ori);	assign jr = (op == `R && func == `jr);
assign R = ((op == `R) && (func != `jr) && (func != `mtlo) && (func != `mthi))	?	1	:	0;		
assign sw = (op == `sw);	assign j = (op == `j);		assign jal = (op == `jal);	
assign beq = (op == `beq);	assign subu = (func == `subu && R);	assign addu = (func == `addu && R);	assign jr = (func == `jr && op == `R);
assign lb = (op == `lb);	assign lbu = (op == `lbu);	assign lh = (op == `lh);	assign lhu = (op == `lhu);	assign lh = (op == `lh); 
assign sb = (op == `sb);	assign sh = (op == `sh);	assign add = (func == `add && R);	assign sub = (func == `sub && R);	
assign sll = (func == `sll && R);	assign srl = (func == `srl && R);	assign sra = (func == `sra && R);	assign sllv = (func == `sllv && R);
assign srlv = (func == `srlv && R); assign srav = (func == `srav && R);	assign And = (func == `And && R);	assign Or = (func == `Or && R);
assign Xor = (func == `Xor && R);	assign Nor = (func == `Nor && R);	assign addi = (op == `addi);	assign addiu = (op == `addiu);
assign slt = (func == `slt && R);	assign sltu = (func == `sltu && R);	assign slti = (op == `slti);	assign sltiu = (op == `sltiu);
assign mult = (func == `mult && R);	assign multu = (func == `multu && R);	assign div = (func == `div && R);	assign divu = (func == `divu && R);
assign mfhi = (func == `mfhi && R); assign mflo = (func == `mflo && R); assign mthi = (func == `mthi && op == `R); assign blez = (op == `blez);
assign mtlo = (func == `mtlo && op == `R);	assign jalr = (op == `R && func == `jalr);	assign bne = (op == `bne); assign bgtz = (op == `bgtz);
assign bltz = (op == `bltz && M_rt == 5'b00000);	assign bgez = (op == `bgez && M_rt == 5'b00001);
assign andi = (op == `andi);	assign xori = (op == `xori);

wire l;	assign l = lh|lw|lb|lhu|lbu; 
wire s;	assign s = sw|sb|sh;
wire cal_i; assign cal_i = lui|ori|addiu|addi|slti|sltiu|andi|xori;
wire cal_v; assign cal_v = sllv|srav|srlv;
wire cal_r; assign cal_r = add|addu|sub|subu|Or|Xor|Nor|And;
wire mt;	assign mt = mtlo | mthi;
wire mf;	assign mf = mflo | mfhi;
wire b;	assign b = bgez|bltz|bgtz|bne|beq|blez;


wire [4:0] M_rt;
wire [4:0] M_rd;
assign M_op = instr[31:26];
assign M_rt = instr[20:16];
assign M_rd = instr[15:11];

assign M_Ause = 	M_rt;
assign M_Anew_o = Anew;
assign M_Tnew_o = (l)	?	1	:
						0;

assign M_AO_o = AO;
assign M_WD_o = V2;
assign M_instr_o = instr;
assign M_PC8_o = PC8;
assign M_HL_o = HL;
//assign M_check_o = check;
endmodule
//W
module W_PLN_Reg(
	input W_PLN_clk,
	input W_PLN_reset,
	input [4:0] W_Anew_i,
	input [31:0] W_instr_i,
	input [31:0] W_PC8_i,
	input [31:0] W_AO_i,
	input [31:0] W_MRD_i,
	input [31:0] W_HL_i,
	output [31:0] W_HL_o,
//	input W_check_i,
//	input W_check_o
	
//W
	
	output [4:0] W_Anew_o,
	output [31:0] W_PC8_o,
	output [31:0] W_AO_o,
	output [31:0] W_MRD_o,
	output [31:0]	W_instr_o
    );
	reg [31:0] instr;
	reg [31:0] PC8;
	reg [31:0] MRD;
	reg [31:0] AO;
	reg [4:0] Anew;
	reg [31:0] HL;

initial begin
	instr = 0;
	PC8 = 0;
	MRD = 0;
	AO = 0;
	Anew = 0;
	HL = 0;
end
always@(posedge W_PLN_clk) begin
	if(W_PLN_reset) begin
		instr <= 0;
		PC8 <= 0;
		MRD <= 0;
		AO <= 0;
		Anew <= 0;
		HL <= 0;
	end
	else begin
		instr <= W_instr_i;
		PC8 <= W_PC8_i;
		MRD <= W_MRD_i;
		AO <= W_AO_i;
		Anew <= W_Anew_i;
		HL <= W_HL_i;
	end
end

assign W_instr_o = instr;
assign W_rt = instr[20:16];
assign W_rd = instr[15:11];

assign W_Anew_o = Anew;

assign W_AO_o = AO;
assign W_MRD_o = MRD;
assign W_instr_o = instr;
assign W_PC8_o = PC8;
assign W_HL_o = HL;
endmodule


