`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:20:33 11/26/2021 
// Design Name: 
// Module Name:    mips 
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
module mips(
	input clk,
	input reset,
	output [31:0] i_inst_addr,
	input [31:0] i_inst_rdata,
	output [31:0] m_data_addr,
	output [31:0] m_data_wdata,
	output [31:0] m_inst_addr,
	output [3:0] m_data_byteen,
	input [31:0] m_data_rdata,
	output  w_grf_we,
	output [4:0] w_grf_addr,
	output [31:0] w_grf_wdata,
	output [31:0] w_inst_addr
	);

assign i_inst_addr = PC_reg_o;
assign m_data_addr = M_AO_o;
assign m_data_wdata = s_fix_data;
assign m_inst_addr = M_PC8_o - 8;
assign m_data_byteen = MCU_DM;

assign w_grf_we = RWE;
assign w_grf_addr = W_Anew_o;
assign w_grf_wdata = RWD_o;
assign w_inst_addr = GRFPC;

//PC_reg
wire [31:0] PC_reg_i;
wire [31:0] PC_reg_o;
PC_reg PC_reg (
    .PC_clk_i(PC_clk_i), 
    .PC_reset_i(PC_reset_i), 
    .PC_reg_i(PC_reg_i), 
    .PC_reg_o(PC_reg_o), 
    .PCDshall(PCDshall)
    );
assign PC_reg_i = PC_next_o;
assign PC_clk_i = clk;
assign PC_reset_i = reset;
assign PCDshall = Dshall_o;

//IM
/*
wire [31:0]	IM_PC_i;
wire [31:0]	IM_Instr_o;
IM IM (
    .IM_PC_i(IM_PC_i), 
    .IM_Instr_o(IM_Instr_o)
    );
assign IM_PC_i = PC_reg_o;
*/
	 
//Plus4
wire [31:0] PC0;
wire [31:0] PC4_o;
Plus4 Plus4(
    .PC0(PC0), 
    .PC4_o(PC4_o)
    );
assign PC0 = PC_reg_o;

//MFPCR
/*wire [31:0]	PCR_RD2;
wire [31:0]	PCR_MAO;
wire [31:0]	PCR_WDR;
wire [31:0]	PCR_PC8;
wire [1:0]	ECU_MFPCR_i;
wire [31:0]	PCR_o;
MFPCR MFPCR (
    .PCR_RD2(PCR_RD2), 
    .PCR_MAO(PCR_MAO), 
    .PCR_WDR(PCR_WDR), 
    .PCR_PC8(PCR_PC8), 
    .ECU_MFPCR_i(ECU_MFPCR_i), 
    .PCR_o(PCR_o)
    );
assign PC_reg_o = CMPB_o;
assign PCR_MAO = M_AO_i;
*/
//PCMUX
wire [31:0]	PCj_i;
wire [31:0]	PCr_i;
wire [31:0]	PCb_i;
wire [31:0]	PC4_i;
wire [31:0]	PCx_i;
wire [2:0]	PCop;
wire [31:0]	PC_next_o;
PCMUX PCMUX (
    .PCj_i(PCj_i), 
    .PCr_i(PCr_i), 
    .PCb_i(PCb_i), 
    .PC4_i(PC4_i), 
    .PCop(PCop), 
    .PC_next_o(PC_next_o),
	 .PCx_i(PCx_i)
    );
assign PCj_i = Extimm_o;
assign PCr_i = CMPA_o;
assign PCb_i = {{14{D_instr_o[15]}},{D_instr_o[15:0]},{2'b00}} + D_PC4_o;
assign PC4_i = PC4_o;
assign PCop = PC_Src;
//------------------------------------DDDDDDDDDDDD------------------
//D_PLN_Reg
wire [31:0] D_instr_i;
wire [31:0] D_PC4_i;
wire [31:0]	D_instr_o;
wire [31:0]	D_PC4_o;
wire [4:0]	D_rs_o;
wire [4:0]	D_rt_o;
D_PLN_Reg D_PLN_Reg (
    .D_PLN_clk(D_PLN_clk), 
    .D_PLN_reset(D_PLN_reset), 
    .D_instr_i(D_instr_i), 
    .D_PC4_i(D_PC4_i), 
    .D_instr_o(D_instr_o), 
    .D_PC4_o(D_PC4_o), 
    .D_Dshall_i(D_Dshall_i), 
    .D_rs_o(D_rs_o), 
    .D_rt_o(D_rt_o)
    );
assign D_instr_i = i_inst_rdata;
assign D_PC4_i = PC4_o;
assign D_PLN_clk = clk;
assign D_PLN_reset = reset;
assign D_Dshall_i = Dshall_o;


//DCU
wire [31:0]	DCU_instr_i;
wire [2:0]	CMPA_Src;
wire [2:0]	CMPB_Src;
wire [2:0]	PC_Src;
wire [4:0]	DCU_MAnew_i;
wire [4:0]	DCU_WAnew_i;
wire [5:0]	DCU_Mop;
wire [5:0]	DCU_Mfunc;
CU DCU (
    .instr_i(DCU_instr_i), 
    .RWE(), 
//    .MWE(), 
    .aluOp(), 
    .DV1_Src(CMPA_Src), 
    .DV2_Src(CMPB_Src), 
    .PC_Src(PC_Src), 
    .Eoff_sign(), 
    .Eimm_sign(), 
    .Reg_Dst(), 
    .alu_Src(), 
    .MWD_Src(), 
    .RWD_Src(), 
    .MAnew_i(DCU_MAnew_i), 
    .WAnew_i(DCU_WAnew_i), 
    .zero(zero), 
    .Mop(DCU_Mop),
	 .lez_i(lez_i),
	 .ltz_i(ltz_i),
	 .Mfunc(DCU_Mfunc)
    );
assign DCU_instr_i = D_instr_o;
assign DCU_MAnew_i = M_Anew_o;
assign DCU_WAnew_i = W_Anew_o;
assign zero = zero_o;
assign DCU_Mop = M_op;
assign lez_i = lez;
assign ltz_i = ltz;
assign DCU_Mfunc = M_instr_o[5:0];

//DSU
wire [31:0] Dinstr_i;
wire [4:0]	DSU_EAnew;
wire [4:0]	DSU_MAnew;
wire [1:0]	DSU_ETnew;
wire [1:0]	DSU_MTnew;
DSU DSU (
    .Dinstr_i(Dinstr_i), 
    .EAnew(DSU_EAnew), 
    .ETnew(DSU_ETnew), 
    .MAnew(DSU_MAnew), 
    .MTnew(DSU_MTnew), 
    .Dshall_o(Dshall_o),
	 .busy_i(busy_i),
	 .start_i(start_i)
//	 .DSU_check()
    );
assign Dinstr_i = D_instr_o;
assign DSU_EAnew = EAnew_o;
assign DSU_ETnew = ETnew_o;
assign DSU_MAnew = M_Anew_o;
assign DSU_MTnew = M_Tnew_o;
assign busy_i = busy_o;
assign start_i = start_o;

//GRF
wire [4:0]	RA1;
wire [4:0]	RA2;
wire [4:0]	RA3;
wire [31:0]	R_WD_i;
wire [31:0]	GRF_RD1;
wire [31:0]	GRF_RD2;
wire [31:0]	GRFPC;
wire [31:0] instr_before;
wire [31:0] instr_bbefore;
wire [31:0] instr_wrong;
GRF GRF (
    .RA1(RA1), 
    .RA2(RA2), 
    .RA3(RA3), 
    .R_WD_i(R_WD_i), 
    .Rclk(Rclk), 
    .Rreset(Rreset), 
    .GRFPC(GRFPC), 
    .instr_bbefore(instr_bbefore), 
    .instr_wrong(instr_wrong), 
    .instr_before(instr_before), 
    .RD1(GRF_RD1), 
    .RD2(GRF_RD2), 
    .WE(RWE_i)
    );

assign RA1 = D_rs_o;
assign RA2 = D_rt_o;
assign RA3 = W_Anew_o;
assign R_WD_i = RWD_o;
assign RWE_i = RWE;
assign Rreset = reset;
assign Rclk = clk;
assign GRFPC = W_PC8_o - 8;
assign instr_wrong = E_instr_o;
assign instr_before = M_instr_o;
assign instr_bbefore = W_instr_o;
//CMP
wire [31:0] CMPA;
wire [31:0] CMPB;
CMP CMP (
    .CMPA(CMPA), 
    .CMPB(CMPB), 
    .zero(zero_o), 
    .great(great_o), 
    .less(less_o),
	 .lez(lez),
	 .ltz(ltz)
    );
assign CMPA = CMPA_o;
assign CMPB = CMPB_o;

	 
//MFCMPA
wire [31:0]	CMPA_RD1;
wire [31:0]	CMPA_MAO;
wire [31:0]	CMPA_WDR;
wire [31:0]	CMPA_PC8;
wire [31:0] CMPA_HL;
wire [2:0]	DCU_MFCMA_i;
wire [31:0]	CMPA_o;
MFCMPA MFCMPA (
    .CMPA_RD1(CMPA_RD1), 
    .CMPA_MAO(CMPA_MAO), 
    .CMPA_WDR(CMPA_WDR), 
    .CMPA_PC8(CMPA_PC8), 
	 .CMPA_HL(CMPA_HL),
    .DCU_MFCMA_i(DCU_MFCMA_i), 
    .CMPA_o(CMPA_o)
    );
assign CMPA_RD1 = GRF_RD1;
assign CMPA_MAO = M_AO_o;
assign CMPA_PC8 = M_PC8_o;
assign DCU_MFCMA_i = CMPA_Src;
assign CMPA_WDR = GRF_RD1;
assign CMPA_HL = M_HL_o;

//MFCMPB
wire [31:0]	CMPB_RD2;
wire [31:0]	CMPB_MAO;
wire [31:0]	CMPB_WDR;
wire [31:0]	CMPB_PC8;
wire [31:0] CMPB_HL;
wire [2:0]	DCU_MFCMB_i;
wire [31:0]	CMPB_o;
MFCMPB MFCMPB (
    .CMPB_RD2(CMPB_RD2), 
    .CMPB_MAO(CMPB_MAO), 
    .CMPB_WDR(CMPB_WDR), 
    .CMPB_PC8(CMPB_PC8), 
	 .CMPB_HL(CMPB_HL),
    .DCU_MFCMB_i(DCU_MFCMB_i), 
    .CMPB_o(CMPB_o)
    );
assign CMPB_RD2 = GRF_RD2;
assign CMPB_MAO = M_AO_o;
assign CMPB_PC8 = M_PC8_o;
assign DCU_MFCMB_i = CMPB_Src;
assign CMPB_WDR = GRF_RD2;
assign CMPB_HL = M_HL_o;

//Eimm26
wire [25:0] Ext_imm26;
wire [31:0]	Extimm_o;
Eimm26 Eimm26 (
    .Ext_imm26(Ext_imm26), 
    .Eimm_sign_i(), 
    .Extimm_o(Extimm_o)
    );
assign Ext_imm26 = D_instr_o[25:0];


//----------------------------------------EEEEEEEEE------------------------------
//E_PLN_Reg 
wire [31:0] E_instr_i;
wire [31:0] E_PC4_i;
wire [31:0]	E_instr_o;
wire [31:0]	E_PC8_o;
wire [31:0] E_V1_i;
wire [31:0] E_V2_i;
wire [31:0]	E_V1_o;
wire [31:0]	E_V2_o;
wire [4:0]	E_rs_o;
wire [4:0]	E_rt_o;
E_PLN_Reg E_PLN_Reg (
    .E_PLN_clk(E_PLN_clk), 
    .E_PLN_reset(E_PLN_reset), 
    .E_instr_i(E_instr_i), 
    .E_PC4_i(E_PC4_i), 
    .E_Dshall_i(E_Dshall_i), 
    .E_instr_o(E_instr_o), 
    .E_PC8_o(E_PC8_o), 
    .E_V1_i(E_V1_i), 
    .E_V2_i(E_V2_i), 
//    .E_Eimm_i(), 
    .E_V1_o(E_V1_o), 
    .E_V2_o(E_V2_o)
//	 .E_check_i(),
//	 .E_check_o()
    );
assign E_instr_i = D_instr_o;
assign E_PC4_i = D_PC4_o;
assign E_V1_i = CMPA_o;
assign E_V2_i = CMPB_o;
assign E_PLN_clk = clk;
assign E_PLN_reset = reset;
assign E_Dshall_i = Dshall_o;
//ECU
wire [31:0]	ECU_instr_i;
wire [2:0]	ALUB_Src;
wire [2:0]  ALUA_Src;
wire [2:0]	aluop;
wire [4:0]	ECU_MAnew_i;
wire [4:0]	ECU_WAnew_i;
wire [5:0]	ECU_Mop;
wire [2:0]	Reg_Dst;
wire [3:0]	aluOp;
wire [1:0]	Eoff_sign;
wire [2:0] 	MULDIVOP;
wire [5:0]	ECU_Mfunc;
CU ECU (
    .instr_i(ECU_instr_i), 
    .aluOp(aluOp), 
    .DV1_Src(ALUA_Src), 
    .DV2_Src(ALUB_Src), 
    .Eoff_sign(Eoff_sign), 
    .Reg_Dst(Reg_Dst), 
    .alu_Src(alu_Src),
	 .alu_Src1(alu_Src1),
    .MAnew_i(ECU_MAnew_i), 
    .WAnew_i(ECU_WAnew_i), 
    .Mop(ECU_Mop),
	 .HLWE_o(HLWE_o),
	 .start_o(start_o),
	 .HL_src_o(HL_src_o),
	 .MULDIVOP(MULDIVOP),
	 .Mfunc(ECU_Mfunc)
    );
assign ECU_instr_i = E_instr_o;
assign ECU_MAnew_i =  M_Anew_o;
assign ECU_WAnew_i =  W_Anew_o;
assign ECU_Mop = M_op;
assign ECU_Mfunc = M_instr_o[5:0];

//ESU
wire [31:0] Einstr_i;
wire [4:0]	EAnew_o;
wire [1:0]	ETnew_o;
ESU ESU (
    .Einstr_i(Einstr_i), 
    .ETnew(ETnew_o), 
    .EAnew(EAnew_o)
//	 .ESU_check()
    );
assign Einstr_i = E_instr_o;
	 
//MFALUA
wire [31:0]	ALUA_RD1;
wire [31:0]	ALUA_MAO;
wire [31:0]	ALUA_WDR;
wire [31:0]	ALUA_PC8;
wire [31:0] ALUA_HL;
wire [2:0]	ECU_MFALUA_i;
wire [31:0]	MFALUA_o;
MFALUA MFALUA (
    .ALUA_RD1(ALUA_RD1), 
    .ALUA_MAO(ALUA_MAO), 
    .ALUA_WDR(ALUA_WDR), 
    .ALUA_PC8(ALUA_PC8), 
	 .ALUA_HL(ALUA_HL),
    .ECU_MFALUA_i(ECU_MFALUA_i), 
    .ALUA_o(MFALUA_o)
    );
assign ALUA_RD1 = E_V1_o;
assign ALUA_MAO = M_AO_o;
assign ALUA_WDR = RWD_o;
assign ALUA_PC8 = M_PC8_o;
assign ECU_MFALUA_i = ALUA_Src;
assign ALUA_HL = M_HL_o;
	 
//MFALUB
wire [31:0]	ALUB_RD2;
wire [31:0]	ALUB_MAO;
wire [31:0]	ALUB_WDR;
wire [31:0]	ALUB_PC8;
wire [31:0] ALUB_HL;
wire [2:0]	ECU_MFALUB_i;
wire [31:0]	MFALUB_o;
MFALUB MFALUB (
    .ALUB_RD2(ALUB_RD2), 
    .ALUB_MAO(ALUB_MAO), 
    .ALUB_WDR(ALUB_WDR), 
    .ALUB_PC8(ALUB_PC8), 
	 .ALUB_HL(ALUB_HL),
    .ECU_MFALUB_i(ECU_MFALUB_i), 
    .ALUB_o(MFALUB_o)
    );
assign ALUB_RD2 = E_V2_o;
assign ALUB_MAO = M_AO_o;
assign ALUB_WDR = RWD_o;
assign ALUB_PC8 = M_PC8_o;
assign ALUB_HL = M_HL_o;
assign ECU_MFALUB_i = ALUB_Src;	 

//ALUB
wire [31:0]	ALUB_RD;
wire [31:0]	ALU_imm;
wire ALU_Src;
wire [31:0]	ALUB_o;
ALUB ALUB (
    .ALUB_RD(ALUB_RD), 
    .ALU_imm(ALU_imm), 
    .ALU_Src(ALU_Src), 
    .ALUB_o(ALUB_o)
    );
assign ALUB_RD = MFALUB_o;
assign ALU_imm = Ext_offset_o;
assign ALU_Src = alu_Src;

//ALUA
wire [31:0] ALUA_RD;
wire [4:0] ALUA_shamt;
wire [31:0] ALUA_o;
ALUA ALUA (
    .ALUA_RD(ALUA_RD), 
    .ALUA_shamt(ALUA_shamt), 
    .ALU_Src1(ALU_Src1), 
    .ALUA_o(ALUA_o)
    );
assign ALUA_RD = MFALUA_o;
assign ALUA_shamt = E_instr_o[10:6];
assign ALU_Src1 = alu_Src1;


//ALU
wire [31:0]	A;
wire [31:0]	B;
wire [31:0]	AO;
wire [3:0]	ALUOP_i;
ALU ALU (
    .A(A), 
    .B(B), 
    .ALUOP_i(ALUOP_i), 
    .AO(AO)
    );
assign A = ALUA_o;
assign B = ALUB_o;
assign ALUOP_i = aluOp;

wire [31:0] MULDIVA;
wire [31:0] MULDIVB;
wire [31:0] HLRD;
wire [2:0] MULDIVOP_i;
MulDiv MulDiv (
    .MULDIVA(MULDIVA), 
    .MULDIVB(MULDIVB), 
    .MULDIVOP_i(MULDIVOP_i), 
    .busy_o(busy_o), 
    .HLRD(HLRD), 
    .start(start), 
    .MULDIV_clk(MULDIV_clk), 
    .MULDIV_reset(MULDIV_reset), 
    .HL_src(HL_src), 
    .HLWE(HLWE)
    );
assign MULDIVOP_i = MULDIVOP;
assign MULDIVA = ALUA_o;
assign MULDIVB = ALUB_o;
assign start = start_o;
assign MULDIV_clk = clk;
assign MULDIV_reset = reset;
assign HL_src = HL_src_o;
assign HLWE = HLWE_o;

//Eoff
wire [15:0]	Ext_offset_i;
wire [31:0]	Ext_offset_o;
wire [1:0]	Eoff_sign_i;
Eoff Eoff (
    .Ext_offset_i(Ext_offset_i), 
    .Ext_offset_o(Ext_offset_o), 
    .Eoff_sign_i(Eoff_sign_i)
    );
assign Ext_offset_i = E_instr_o[15:0];
assign Eoff_sign_i = Eoff_sign;
//Reg_Mux
wire [4:0] RM_rt;
wire [4:0] RM_rd;
wire [4:0] WRA_o;
wire [1:0] Reg_Dst_i;
Reg_Mux Reg_Mux (
    .RM_rt(RM_rt), 
    .RM_rd(RM_rd), 
    .Reg_Dst_i(Reg_Dst_i), 
    .WRA_o(WRA_o)
    );
assign RM_rt = E_instr_o[20:16];
assign RM_rd = E_instr_o[15:11];
assign Reg_Dst_i = Reg_Dst;

//-----------------------------MMMMMMMMMMMMMMMMMMMMMM-------------
//M_PLN_Reg
wire [4:0]	M_Anew_i;
wire [31:0] M_instr_i;
wire [31:0] M_PC8_i;
wire [31:0]	M_instr_o;
wire [31:0]	M_PC8_o;
wire [31:0] M_V2_i;
wire [4:0]	M_Anew_o;
wire [31:0]	M_AO_i;
wire [4:0]	M_Ause_o;
wire [1:0]	M_Tnew_o;
wire [31:0]	M_AO_o;
wire [31:0]	M_WD_o;
wire [5:0]	M_op;
wire [31:0] M_HL_i;
wire [31:0] M_HL_o;
M_PLN_Reg M_PLN_Reg (
    .M_Anew_i(M_Anew_i), 
    .M_PLN_clk(M_PLN_clk), 
    .M_PLN_reset(M_PLN_reset), 
    .M_instr_i(M_instr_i), 
    .M_PC8_i(M_PC8_i), 
    .M_V2_i(M_V2_i), 
    .M_instr_o(M_instr_o), 
    .M_PC8_o(M_PC8_o), 
    .M_Anew_o(M_Anew_o), 
    .M_AO_i(M_AO_i), 
    .M_Ause_o(M_Ause_o), 
    .M_Tnew_o(M_Tnew_o), 
    .M_AO_o(M_AO_o), 
    .M_WD_o(M_WD_o), 
    .M_op(M_op),
	 .M_HL_i(M_HL_i),
	 .M_HL_o(M_HL_o)
//	 .M_check_i(),
//	 .M_check_o()
    );
assign M_Anew_i = WRA_o;
assign M_instr_i = E_instr_o;
assign M_PC8_i = E_PC8_o;
assign M_V2_i = MFALUB_o;
assign M_AO_i = AO;
assign M_HL_i = HLRD;
assign M_PLN_clk = clk;
assign M_PLN_reset = reset;

//MFMWD
wire [31:0]	MWD_RD2;
wire [31:0]	MWD_WDR;
wire [31:0]	MWD_o;
wire [2:0]	ECU_MFMWD_i;
MFMWD MFMWD (
    .MWD_RD2(MWD_RD2), 
    .MWD_WDR(MWD_WDR), 
    .ECU_MFMWD_i(ECU_MFMWD_i), 
    .MWD_o(MWD_o)
    );
assign MWD_RD2 = M_WD_o;
assign MWD_WDR = RWD_o;
assign ECU_MFMWD_i = MWD_Src;
//DM
/*
wire [31:0]	DMA;
wire [31:0]	DMRD;
wire [31:0]	DMWD;
wire [31:0]	DMPC;
//wire [1:0] type_i;
DM DM (
    .DMA(DMA), 
    .DMWD(DMWD), 
    .DMRD(DMRD), 
    .DMclk(DMclk), 
    .DMreset(DMreset), 
    .DMWE(DMWE),
//	 .type_i(type_i)
	 .DMPC(DMPC)
    );
assign DMA = M_AO_o;
assign DMclk = clk;
assign DMreset = reset;
assign DMWE = MWE;
assign DMWD = MWD_o;
assign DMPC = M_PC8_o - 8;
*/
//assign type_i = type;

//store
wire [3:0] s_type;
wire [31:0]	s_ini_data;
wire [31:0]	s_fix_data;
store store (
    .s_type(s_type), 
    .s_ini_data(s_ini_data), 
    .s_fix_data(s_fix_data)
    );
assign s_type = MCU_DM;
assign s_ini_data = MWD_o;



//LF_DM
wire [2:0] l_type_i;
wire [31:0] DM_RD;
wire [31:0] LF_D;
wire [1:0] LF_A;
LF_DM IF_DM (
    .l_type(l_type_i), 
    .DM_RD(DM_RD), 
    .LF_D(LF_D), 
    .A(LF_A)
    );
assign DM_RD = m_data_rdata;
assign LF_A = M_AO_o[1:0];
assign l_type_i = l_type;

//MCU
wire [31:0]	MCU_instr_i;
wire [4:0]	WAnew_i;
wire [2:0]	MWD_Src;
wire [31:0] MCU_DM;
wire [31:0] MCU_MA;
wire [2:0] l_type;
CU MCU (
    .instr_i(MCU_instr_i), 
    .RWE(), 
//  .MWE(MWE), 
    .aluOp(), 
    .DV1_Src(), 
    .DV2_Src(), 
    .PC_Src(), 
    .Eoff_sign(), 
    .Eimm_sign(), 
    .Reg_Dst(), 
    .alu_Src(), 
    .MWD_Src(MWD_Src), 
    .RWD_Src(), 
    .MAnew_i(), 
    .WAnew_i(WAnew_i), 
    .zero(), 
//	 .type(type)
    .Mop(),
	 .MCU_DM(MCU_DM),
	 .CU_MA(MCU_MA),
	 .l_type(l_type)
    );
assign MCU_instr_i = M_instr_o;
assign WAnew_i = W_Anew_o;
assign MCU_MA = M_AO_o;
//------------------------Wwwwwwwwww---------------------------
//W_PLN_Reg
wire [31:0]	W_instr_i;
wire [31:0]	W_PC8_i;
wire [31:0]	W_AO_i;
wire [31:0]	W_MRD_i;
wire [31:0]	W_PC8_o;
wire [31:0]	W_AO_o;
wire [31:0]	W_MRD_o;
wire [4:0]	W_Anew_o;
wire [31:0]	W_instr_o;
wire [31:0] W_HL_i;
wire [31:0] W_HL_o;
wire [4:0]	W_Anew_i;
W_PLN_Reg W_PLN_Reg (
    .W_PLN_clk(W_PLN_clk), 
    .W_PLN_reset(W_PLN_reset), 
    .W_instr_i(W_instr_i), 
    .W_PC8_i(W_PC8_i), 
    .W_AO_i(W_AO_i), 
    .W_MRD_i(W_MRD_i), 
    .W_Anew_o(W_Anew_o), 
    .W_PC8_o(W_PC8_o), 
    .W_AO_o(W_AO_o), 
    .W_MRD_o(W_MRD_o),
	 .W_instr_o(W_instr_o),
//	 .W_check_i(),
//	 .W_check_o(),
	 .W_Anew_i(W_Anew_i),
	 .W_HL_i(W_HL_i),
	 .W_HL_o(W_HL_o)
    );
assign W_instr_i = M_instr_o;
assign W_PC8_i = M_PC8_o;
assign W_AO_i = M_AO_o;
assign W_MRD_i = LF_D;
assign W_PLN_clk = clk;
assign W_PLN_reset = reset;
assign W_Anew_i = M_Anew_o;
assign W_HL_i = M_HL_o;
	 
//WCU
wire [31:0]	WCU_instr_i;
wire [2:0]	RWD_Src;
CU WCU (
    .instr_i(WCU_instr_i), 
    .RWE(RWE), 
//  .MWE(), 
    .aluOp(), 
    .DV1_Src(), 
    .DV2_Src(), 
    .PC_Src(), 
    .Eoff_sign(), 
    .Eimm_sign(), 
    .Reg_Dst(), 
    .alu_Src(), 
    .MWD_Src(), 
    .RWD_Src(RWD_Src), 
    .MAnew_i(), 
    .WAnew_i(), 
    .zero(), 
    .Mop()
    );
assign WCU_instr_i = W_instr_o;

//RWD_MUX
wire [31:0]	RWD_PC;
wire [31:0]	RWD_MD;
wire [31:0]	RWD_AO;
wire [31:0]	RWD_o;
wire [2:0]	RWD_Src_i;
wire [31:0] RWD_HL;
RWD_MUX RWD_MUX (
    .RWD_PC(RWD_PC), 
    .RWD_MD(RWD_MD), 
    .RWD_AO(RWD_AO), 
    .RWD_Src_i(RWD_Src_i), 
    .RWD_o(RWD_o),
	 .RWD_HL(RWD_HL)
    );
assign RWD_PC = W_PC8_o;
assign RWD_MD = W_MRD_o;
assign RWD_AO = W_AO_o;
assign RWD_Src_i = RWD_Src;
assign RWD_HL = W_HL_o;
	 
endmodule
