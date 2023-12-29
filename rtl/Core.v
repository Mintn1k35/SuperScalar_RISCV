
`include "define_module.v"
`include "PC_Control.v"
`include "Ibits.v"
`include "Instr_Decode.v"
module Core(
	// Input signals
	input wire		clk,
	input wire		rst_n,
	input wire		arready,
	input wire [63:0]	rdata,
	input wire		rvalid,
	input wire 		rlast,
	input wire 		rs1_valid,
	input wire 		rs2_valid,
	input wire [31:0]	rs1_data,
	input wire [31:0]	rs2_data,
	input wire [2:0]	au_free,
	input wire [2:0]	mul_free,
	input wire 		lsu_free,

	// Output signals	
	output wire		arvalid, 
	output wire [31:0]	araddr, 
	output wire [1:0]	arburst,
	output wire [2:0]	arsize,
	output wire [7:0]	arlen,
	output wire [16:0]	rd_rs1_rs2,
	output wire [7:0]	execute_type,
	output wire [31:0]	imm_extend

);

	wire jump, jump_wait, jump_accept;
	wire [31:0] jump_addr;
	wire [31:0] fetch_pc;
	wire [63:0] fetch_instr_pc;
	wire buf_full, buf_empty;
	wire [4:0] rs1, rs2;
	
	PC_Control PC_Control_Instance(clk, rst_n, jump, jump_wait, jump_accept, jump_addr, !buf_full, arvalid, araddr, arburst, arsize, arlen, arready, fetch_pc);
	Ibits Ibits_Instance(clk, rst_n, rvalid, rlast, rdata, fetch_pc, jump, jump_wait, jump_accept, busy, rready, fetch_instr_pc, buf_empty, buf_full);
	Instr_Decode Instr_Decode_Instance(clk, rst_n, fetch_instr_pc, rs1_valid, rs2_valid, rs1_data, rs2_data, au_free, mul_free, lsu_free, busy, rs1, rs2, jump, jump_wait, jump_accept, jump_addr, rd_rs1_rs2, execute_type, imm_extend);
endmodule





