`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:37:50 11/20/2021 
// Design Name: 
// Module Name:    MUX 
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
module MFCMPA(
	input [31:0]	CMPA_RD1,
	input	[31:0]	CMPA_MAO,
	input [31:0]	CMPA_WDR,
	input [31:0]	CMPA_PC8,
	input [31:0]	CMPA_HL,
	input [2:0]		DCU_MFCMA_i,
	output[31:0]	CMPA_o
    );
assign CMPA_o = 	(DCU_MFCMA_i == `PC)	?	CMPA_PC8	:
						(DCU_MFCMA_i == `AO)	?	CMPA_MAO	:
						(DCU_MFCMA_i == `WD)	?	CMPA_WDR	:
						(DCU_MFCMA_i == `V)	?	CMPA_RD1	:
						(DCU_MFCMA_i == `HL)	?	CMPA_HL	:
						0;

endmodule
module MFCMPB(
	input [31:0]	CMPB_RD2,
	input	[31:0]	CMPB_MAO,
	input [31:0]	CMPB_WDR,
	input [31:0]	CMPB_PC8,
	input [31:0]	CMPB_HL,
	input [2:0]		DCU_MFCMB_i,
	output[31:0]	CMPB_o
    );
assign CMPB_o = 	(DCU_MFCMB_i == `PC)	?	CMPB_PC8	:
						(DCU_MFCMB_i == `AO)	?	CMPB_MAO	:
						(DCU_MFCMB_i == `WD)	?	CMPB_WDR	:
						(DCU_MFCMB_i == `V)	?	CMPB_RD2	:
						(DCU_MFCMB_i == `HL)	?	CMPB_HL	:
						0;

endmodule
module MFALUA(
	input [31:0]	ALUA_RD1,
	input	[31:0]	ALUA_MAO,
	input [31:0]	ALUA_WDR,
	input [31:0]	ALUA_PC8,
	input [2:0]		ECU_MFALUA_i,
	input [31:0]	ALUA_HL,
	output[31:0]	ALUA_o
    );
assign ALUA_o = 	(ECU_MFALUA_i == `PC)	?	ALUA_PC8	:
						(ECU_MFALUA_i == `AO)	?	ALUA_MAO	:
						(ECU_MFALUA_i == `WD)	?	ALUA_WDR	:
						(ECU_MFALUA_i == `V)		?	ALUA_RD1	:
						(ECU_MFALUA_i == `HL)	?	ALUA_HL	:
						0;

endmodule
module MFALUB(
	input [31:0]	ALUB_RD2,
	input	[31:0]	ALUB_MAO,
	input [31:0]	ALUB_WDR,
	input [31:0]	ALUB_PC8,
	input [2:0]		ECU_MFALUB_i,
	input [31:0]	ALUB_HL,
	output[31:0]	ALUB_o
    );
assign ALUB_o = 	(ECU_MFALUB_i == `PC)	?	ALUB_PC8	:
						(ECU_MFALUB_i == `AO)	?	ALUB_MAO	:
						(ECU_MFALUB_i == `WD)	?	ALUB_WDR	:
						(ECU_MFALUB_i == `V)		?	ALUB_RD2	:
						(ECU_MFALUB_i == `HL)	?	ALUB_HL	:
						0;

endmodule
//选择jr来源
/*
module MFPCR(				
	input [31:0]	PCR_RD2,
	input	[31:0]	PCR_MAO,
	input [31:0]	PCR_WDR,
	input [31:0]	PCR_PC8,
	input [2:0]		ECU_MFPCR_i,
	output[31:0]	PCR_o
    );
assign PCR_o = 	(ECU_MFPCR_i == `PC)	?	PCR_PC8	:
						(ECU_MFPCR_i == `AO)	?	PCR_MAO	:
						(ECU_MFPCR_i == `WD)	?	PCR_WDR	:
						(ECU_MFPCR_i == `V)	?	PCR_RD2	:
						0;

endmodule
*/
module MFMWD(
	input [31:0]	MWD_RD2,
	input [31:0]	MWD_WDR,
	input [2:0]		ECU_MFMWD_i,
	output[31:0]	MWD_o
    );
assign MWD_o = 	(ECU_MFMWD_i == `WD)	?	MWD_WDR	:	//DWR	: 即将写入寄存器的值
						(ECU_MFMWD_i == `V)	?	MWD_RD2	:
						0;
endmodule

module PCMUX(
	input [31:0] PCj_i,
	input [31:0] PCr_i,
	input [31:0] PCb_i,
	input [31:0] PC4_i,
	input [31:0] PCx_i,
	input [2:0] PCop,
	output [31:0] PC_next_o
	);
assign PC_next_o = 	(PCop == `PCj)	?	PCj_i	:
							(PCop == `PCr)	?	PCr_i	:
							(PCop == `PCb)	?	PCb_i	:
							(PCop == `PCx)	?	PCx_i	:
							PC4_i;
	
endmodule

module ALUB(
	input	[31:0] ALUB_RD,
	input [31:0] ALU_imm,
	input	ALU_Src,
	output [31:0] ALUB_o
	);
assign ALUB_o = (ALU_Src == 1)	?	ALU_imm	:	ALUB_RD;

endmodule


module ALUA(
    input [31:0] ALUA_RD,
    input [4:0] ALUA_shamt,
	 input ALU_Src1,
    output [31:0] ALUA_o
    );
assign ALUA_o = (ALU_Src1 == 1)	?	{{27{1'b0}},{ALUA_shamt}} 	:	ALUA_RD;

endmodule


module RWD_MUX(
	input [31:0] RWD_PC,
	input [31:0] RWD_MD,
	input [31:0] RWD_AO,
	input [2:0]	RWD_Src_i,
	input [31:0] RWD_HL,
	output [31:0]	RWD_o
	);
assign RWD_o = (RWD_Src_i == `PC)	?	RWD_PC	:
					(RWD_Src_i == `MD)	?	RWD_MD	:
					(RWD_Src_i == `HL)	?	RWD_HL	:
					RWD_AO;
endmodule

module Reg_Mux(
    input [4:0] RM_rt,
    input [4:0] RM_rd,
    input [1:0] Reg_Dst_i,
	 output[4:0] WRA_o
    );
assign WRA_o = (Reg_Dst_i == `ra)	?	5'b11111	:
					(Reg_Dst_i == `rt)	?	RM_rt	:
					(Reg_Dst_i == `rd)	?	RM_rd	:
					0;

endmodule
			