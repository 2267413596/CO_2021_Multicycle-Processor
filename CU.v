`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:06 11/26/2021 
// Design Name: 
// Module Name:    CU 
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
module CU(
    input [31:0] instr_i,
    output RWE,
//  output MWE,
    output [3:0] aluOp,
    output [2:0] DV1_Src,
    output [2:0] DV2_Src,
    output [2:0] PC_Src,
    output [1:0] Eoff_sign,
    output [1:0] Eimm_sign,
    output [2:0] Reg_Dst,
	 output alu_Src,
	 output alu_Src1,
    output [2:0] MWD_Src,
    output [2:0] RWD_Src,
    input [4:0] MAnew_i,
    input [4:0] WAnew_i,
	 input zero,
	 input [5:0] Mop,
	 input [31:0] CU_MA,
//	 input check,
	 output [2:0]l_type,
	 output [2:0]MULDIVOP,
	 output start_o,
	 output HLWE_o,
	 output HL_src_o,
	 output [31:0] MCU_DM,
	 input ltz_i,
	 input lez_i,
	 input [5:0] Mfunc
    );
wire [5:0] op;
wire [5:0] func;
wire [4:0] rs;
wire [4:0] rt;
assign  op = instr_i [31:26];
assign  func = instr_i [5:0];
assign  rs = instr_i[25:21];
assign  rt = instr_i[20:16];


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

assign RWE = jal|R|cal_i|l;
//assign MWE = s;
assign aluOp = (subu|sub)							?	`aluSub	:
					(addu|l|s|addi|addiu|add)		?	`aluAdd	:
					(ori|Or)								?	`aluOr	:
					(lui)									?	`imm		:
					(And|andi)							?	`aluAnd	:
					(sll|sllv)							?	`aluSll	:
					(srl|srlv)							?	`aluSrl	:
					(sra|srav)							?	`aluSra	:
					(Xor|xori)							?	`aluXor	:
					(Nor)									?	`aluNor	:
					(slt|slti)							?	`aluSlt	:
					(sltu|sltiu)						?	`aluSltu	:
					0;
wire M_jalr; assign M_jalr = (Mop == `R && Mfunc == `jalr);
wire M_mflo; assign M_mflo = (Mop == `R && Mfunc == `mflo);
wire M_mfhi; assign M_mfhi = (Mop == `R && Mfunc == `mfhi);
assign DV1_Src = 	(rs == MAnew_i && (Mop == `jal|| M_jalr) && rs)		?	`PC	:
						(rs == MAnew_i && (M_mfhi || M_mflo) && rs)	?	`HL	:
						(rs == MAnew_i && rs)	?	`AO	:
						(rs == WAnew_i && rs)	?	`WD	:
						`V;
assign DV2_Src = 	(rt == MAnew_i && (Mop == `jal|| M_jalr) && rt)		?	`PC	:
						(rt == MAnew_i && (M_mfhi || M_mflo) && rt)	?	`HL	:
						(rt == MAnew_i && rt)	?	`AO	:
						(rt == WAnew_i && rt)	?	`WD	:
						`V;
assign PC_Src =	(j|jal)																																?	`PCj	:
						(jr|jalr)																															?	`PCr	:
						((beq&&(zero))||(bne&&(~zero))||(bltz&&(ltz_i))||(bgez&&(~ltz_i))||(blez&&(lez_i))||(bgtz&&(~lez_i)))	?	`PCb	:
						`PC4;
assign Eoff_sign =	(ori|xori|andi)								?	`Eoffz	:
							(lui)												?	`Eoffu	:
							(l|s|addiu|addi|slti|sltiu)				?	`Eoffs	:
							0;
assign Eimm_sign = 	(j|jal)	?	`Ezero	:
							0;
assign Reg_Dst =	(jal)					?	`ra	:
						(R)					?	`rd	:
						(l|cal_i)			?	`rt	:
						2'b11;
assign alu_Src = 	(l|s|cal_i)	?	1	:	0;
assign alu_Src1 = (sll|srl|sra)					?	1	:	0;
assign MWD_Src = 	(rt == WAnew_i && rt)	?	`WD	:	`V;
assign RWD_Src = 	(jal|jalr)	?	`PC	:
						(l)			?	`MD	:
						(mf)			?	`HL	:
						`AO;
assign l_type = 	(lbu)	?	`lbyteu	:
						(lb)	?	`lbyte	:
						(lh)	?	`lhalf	:
						(lhu)	?	`lhalfu	:
						(lw)	?	`lword	:
						0;

assign start_o = 	(mult|multu|div|divu) ? 1	:	0;
assign MULDIVOP = (mult)	?	`MDMUL	:
						(multu)	?	`MDMULU	:
						(div)		?	`MDDIV	:
						(divu)	?	`MDDIVU	:
						0;
assign HLWE_o = mt;
assign HL_src_o = mthi | mfhi;
assign MCU_DM = 	(sw)									?	`sword	:
						(sh && CU_MA[1] == 1)			?	`shu		:
						(sh && CU_MA[1] == 0)			?	`shl		:
						(sb && CU_MA[1:0] == 2'b00)	?	`sbl		:
						(sb && CU_MA[1:0] == 2'b01)	?	`sbm		:
						(sb && CU_MA[1:0] == 2'b10)	?	`sbh		:
						(sb && CU_MA[1:0] == 2'b11)	?	`sbu		:
						0;

endmodule
