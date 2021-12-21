`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:41:45 11/26/2021 
// Design Name: 
// Module Name:    SU 
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
module DSU(
	input [31:0] Dinstr_i,
	input [4:0]	EAnew,
	input [1:0]	ETnew,
	input [4:0] MAnew,
	input [1:0]	MTnew,
	output Dshall_o,
	input DSU_check,
	input start_i,
	input busy_i
    );

wire [5:0]op = Dinstr_i[31:26];
wire [5:0]func = Dinstr_i[5:0];
wire [1:0] D_Tuse1;
wire [1:0] D_Tuse2;
wire [4:0] D_Ause1;
wire [4:0] D_Ause2;
wire [4:0] rt;
assign rt = Dinstr_i[20:16];
assign D_Ause1 = Dinstr_i[25:21];		//rs
assign D_Ause2 = Dinstr_i[20:16];		//rt
wire shallrs;
wire shallrt;

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
assign mtlo = (func == `mtlo && op == `R);	assign jalr = (R && func == `jalr);	assign bne = (op == `bne); assign bgtz = (op == `bgtz);
assign bltz = (op == `bltz && rt == 5'b00000);	assign bgez = (op == `bgez && rt == 5'b00001);
assign andi = (op == `andi);	assign xori = (op == `xori);

wire l;	assign l = lh|lw|lb|lhu|lbu; 
wire s;	assign s = sw|sb|sh;
wire cal_i; assign cal_i = lui|ori|addiu|addi|slti|sltiu|andi|xori;
wire cal_v; assign cal_v = sllv|srav|srlv;
wire cal_r; assign cal_r = add|addu|sub|subu|Or|Xor|Nor|And;
wire mt;	assign mt = mtlo | mthi;
wire mf;	assign mf = mflo | mfhi;
wire b;	assign b = bgez|bltz|bgtz|bne|beq|blez;
wire md; assign md = mt|mf|div|divu|mult|multu;

assign D_Tuse1 = 	(b|jr|jalr)		?	0	:
						(R|cal_i|l|s|mt)	?	1	:
						3;
assign D_Tuse2 = (bne|beq)	?	0	:
						(R)		?	1	:
						3;
assign shallrs = (D_Ause1 && ( (D_Ause1 == EAnew && ETnew > D_Tuse1) || (D_Ause1 == MAnew && MTnew > D_Tuse1) ) )	?	1	:	0;
assign shallrt = (D_Ause2 && ( (D_Ause2 == EAnew && ETnew > D_Tuse2) || (D_Ause2 == MAnew && MTnew > D_Tuse2) ) )	?	1	:	0;
assign shallmd = ((busy_i && md) || (start_i && md))	?	1 : 0;

assign Dshall_o = shallrs | shallrt | shallmd;

endmodule

module ESU(
	input [31:0] Einstr_i,
	output [1:0] ETnew,
	output [4:0] EAnew
    );
wire [5:0]op = Einstr_i[31:26];
wire [5:0]func = Einstr_i[5:0];



wire [4:0] E_rt;
wire [4:0] E_rd;
assign E_rt = Einstr_i[20:16];
assign E_rd = Einstr_i[15:11];


wire lui; wire lw; wire ori; wire jr; wire R; wire sw; wire j; wire jal; wire beq; wire subu; wire addu;wire nop;wire lb;wire lh;
wire lhu;wire lbu;wire sb; wire sh;wire add;wire sub;wire sll;wire srl;wire sra;wire sllv;wire srlv; wire srav;wire And;wire Or;
wire Xor;wire Nor;wire addi;wire addiu;wire slt;wire sltu;wire slti;wire sltiu;wire mult;wire multu;wire div;wire divu;
wire jalr;wire bne;wire blez;wire bgtz;wire bltz;wire bgez;wire xori;wire andi;
assign lui = (op == `lui);	assign lw = (op == `lw);	assign ori = (op == `ori);	assign jr = (op == `R && func == `jr);
assign R = ((op == `R) && (func != `jr) && (func != `mtlo) && (func != `mthi))	?	1	:	0;		
assign sw = (op == `sw);	assign j = (op == `j);		assign jal = (op == `jal);	
assign beq = (op == `beq);	assign subu = (func == `subu && R);	assign addu = (func == `addu && R);	assign jr = (func == `jr && op == `R);
assign lb = (op == `lb);	assign lbu = (op == `lbu);	assign lh = (op == `lh);	assign lhu = (op == `lhu);
assign sb = (op == `sb);	assign sh = (op == `sh);	assign add = (func == `add && R);	assign sub = (func == `sub && R);	
assign sll = (func == `sll && R);	assign srl = (func == `srl && R);	assign sra = (func == `sra && R);	assign sllv = (func == `sllv && R);
assign srlv = (func == `srlv && R); assign srav = (func == `srav && R);	assign And = (func == `And && R);	assign Or = (func == `Or && R);
assign Xor = (func == `Xor && R);	assign Nor = (func == `Nor && R);	assign addi = (op == `addi);	assign addiu = (op == `addiu);
assign slt = (func == `slt && R);	assign sltu = (func == `sltu && R);	assign slti = (op == `slti);	assign sltiu = (op == `sltiu);
assign mult = (func == `mult && R);	assign multu = (func == `multu && R);	assign div = (func == `div && R);	assign divu = (func == `divu && R);
assign mfhi = (func == `mfhi && R); assign mflo = (func == `mflo && R); assign mthi = (func == `mthi && op == `R); assign blez = (op == `blez);
assign mtlo = (func == `mtlo && op == `R);	assign jalr = (R && func == `jalr);	assign bne = (op == `bne); assign bgtz = (op == `bgtz);
assign bltz = (op == `bltz && E_rt == 5'b00000);	assign bgez = (op == `bgez && E_rt == 5'b00001);
assign andi = (op == `andi);	assign xori = (op == `xori);

wire l;	assign l = lh|lw|lb|lhu|lbu; 
wire s;	assign s = sw|sb|sh;
wire cal_i; assign cal_i = lui|ori|addiu|addi|slti|sltiu|andi|xori;
wire cal_v; assign cal_v = sllv|srav|srlv;
wire cal_r; assign cal_r = add|addu|sub|subu|Or|Xor|Nor|And;
wire mt;	assign mt = mtlo | mthi;
wire mf;	assign mf = mflo | mfhi;
wire b;	assign b = bgez|bltz|bgtz|bne|beq|blez;
wire link; assign link = jalr | jal;

assign EAnew = 	(jal)			?	5'b11111	:
						(R)			?		E_rd	:
						(cal_i|l) 		?	E_rt	:
						0;
						

assign ETnew = 	(R|cal_i|link)			?	1	:
						(l)						?	2	:
						0;	

endmodule

