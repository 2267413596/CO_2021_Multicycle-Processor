`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:01 11/20/2021 
// Design Name: 
// Module Name:    constants 
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
/*
wire lui; wire lw; wire ori; wire jr; wire R; wire sw; wire j; wire jal; wire beq; wire subu; wire addu;wire nop;wire lb;wire lh;
wire lhu;wire lbu;wire sb; wire sh;wire add;wire sub;wire sll;wire srl;wire sra;wire sllv;wire srlv; wire srav;wire And;wire Or;
wire Xor;wire Nor;wire addi;wire addiu;wire slt;wire sltu;wire slti;wire sltiu;wire mult;wire multu;wire div;wire divu;
wire jalr;wire bne;wire blez;wire bgtz;wire bltz;wire bgez;
assign lui = (op == `lui);	assign lw = (op == `lw);	assign ori = (op == `ori);	assign jr = (op == `R && func == `jr);
assign R = (op == `R && func != `jr && func != mtlo && func != mthi && func != jalr);		
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
assign bltz = (op == `bltz && rt == 5'b00000);	assign bgez = (op == bgez && rt == 5'b00001);

wire l;	assign l = lh|lw|lb|lhu|lbu; 
wire s;	assign s = sw|sb|sh;
wire cal_i; assign cal_i = lui|ori|addiu|addi|slti|sltiu;
wire cal_v; assign cal_v = sllv|srav|srlv;
wire cal_r; assign cal_r = add|addu|sub|subu|Or|Xor|Nor|And;
wire mt;	assign mt = mtlo | mthi;
wire mf;	assign mf = mflo | mfhi;
wire b;	assign b = bgez|bltz|bgtz|bne|beq|blez;
*/
//alu_src

//ALU
`define	aluOr		4'd2
`define	aluAnd	4'd3
`define	aluXor	4'd4
`define	aluNor	4'd5
`define	aluAdd	4'd6
`define	aluSub	4'd7
`define	aluSll	4'd8
`define	aluSrl	4'd9
`define	aluSra	4'd10
`define	aluSlt	4'd11
`define	aluSltu	4'd12
`define	imm		4'd0
//OP
`define	R			6'b000000
`define	lw			6'b100011
`define	lui		6'b001111
`define	sw			6'b101011
`define	ori		6'b001101
`define	j			6'b000010
`define	jal		6'b000011
`define	beq		6'b000100
`define	lb			6'b100000
`define	lbu		6'b100100
`define	lh			6'b100001
`define	lhu		6'b100101
`define	sb			6'b101000
`define	sh			6'b101001
`define	addi		6'b001000
`define	addiu		6'b001001
`define	andi		6'b001100
`define	xori		6'b001110
`define	slti		6'b001010
`define	sltiu		6'b001011
`define	bne		6'b000101
`define	bltz		6'b000001
`define	blez		6'b000110
`define	bgtz		6'b000111
`define	bgez		6'b000001
`define	andi		6'b001100
`define	xori		6'b001110
//Ext
`define	Ezero		2'b00
`define	Esign		2'b01
`define	upper		2'b10
//NPC
`define	PCj		3'b011
`define	PCr		3'b010
`define	PCb		3'b001
`define	PC4		3'b000
`define	PCx		3'b111
//Reg_Dst
`define	ra		2'b10
`define	rd		2'b01
`define	rt		2'b00
//func
`define	jr			6'b001000
`define	addu		6'b100001
`define	subu		6'b100011
`define	add		6'b100000
`define	sub		6'b100010
`define	Nor		6'b100111
`define	Or			6'b100101
`define	Xor		6'b100110
`define	sll		6'b000000
`define	sllv		6'b000100
`define	srl		6'b000010
`define	srlv		6'b000110
`define	sra		6'b000011
`define	srav		6'b000111
`define	And		6'b100100
`define	slt		6'b101010
`define	sltu		6'b101011
`define	multu		6'b011001
`define	mult		6'b011000
`define	div		6'b011010
`define	divu		6'b011011
`define 	mflo		6'b010010
`define	mfhi		6'b010000
`define	mtlo		6'b010011
`define	mthi		6'b010001
`define	jalr		6'b001001
//transmit
/*`define MAO		3'b111
`define WWD		3'b110
`define RD1		3'b101
`define RD2		3'b100
`define PC8		3'b011*/

//Extoffset
`define Eoffz		3'b000
`define Eoffs		3'b001
`define Eoffu		3'b010	
//FMUX
`define AO		3'b010
`define PC		3'b011
`define WD		3'b001
`define V		3'b000
//WD_MUX
//`define PC		2'b11
//`define AO		2'b10
`define MD		3'b100
`define HL		3'b101	
//RWD_Src
//`define MD		2'b01	
//`define AO		2'b10
//`define PC		2'b11
//DM

`define	sword		4'b1111
`define	shl		4'b0011
`define	shu		4'b1100
`define	sbl		4'b0001
`define	sbm		4'b0010
`define	sbh		4'b0100
`define	sbu		4'b1000

`define	lword		3'b000
`define	lhalf		3'b001
`define	lhalfu	3'b010
`define	lbyte		3'b011
`define	lbyteu	3'b100

//MULDIV
`define	c_ini		4'b0001
`define  MDMUL		3'b001
`define	MDDIV		3'b010
`define	MDMULU	3'b011
`define	MDDIVU	3'b100
	
