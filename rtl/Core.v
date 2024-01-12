`include "Fifo.v"
`include "Instr_Decode.v"
`include "Register_File.v"
`include "Schedule.v"
`include "Buffer_Execute.v"
`include "Transfer_Decode_Execute.v"
`include "AU.v"
`include "Mul_Div.v"
`include "Transfer_Execute_WB.v"
`include "Select_Data_WB.v"
`include "Control.v"
`include "Cache_Controller.v"
module Core(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			rvalid,
	input wire			rlast,
	input wire [63:0]	rdata,

	// Output signals
	output wire 		rready,
	output wire [31:0]	araddr,
	output wire			arvalid,
	output wire [1:0]	arburst,
	output wire [2:0]	arsize,
	output wire [7:0]	arlen,
	output wire [3:0]	arcache

);

/// Internal Signal
	wire [127:0] data_out, instr1, instr2, execute_instr;
	wire write1, write2, reg_write1, reg_write2, au1_type, au2_type, mul1_type, mul2_type, lsu1_type, lsu2_type;
	wire [4:0] execute_type1, execute_type2;
	wire [63:0] execute_instr1 = execute_instr;
	wire [63:0] execute_instr2 = execute_instr >> 64;
	wire [4:0] instr1_rs1 = execute_instr1[51:47];
	wire [4:0] instr1_rs2 = execute_instr1[56:52];
	wire [4:0] rd1 = execute_instr1[43:39];
	wire [4:0] instr2_rs1 = execute_instr2[51:47];
	wire [4:0] instr2_rs2 = execute_instr2[56:52];
	wire [4:0] rd2 = execute_instr2[43:39];
	wire [31:0] instr1_rs1_data, instr1_rs2_data, instr2_rs1_data, instr2_rs2_data, instr1_operand1_data,
	instr1_operand2_data, instr2_operand1_data, instr2_operand2_data;
	wire [31:0] instr1_operand1, instr1_operand2, instr2_operand1, instr2_operand2;
	wire reg_write1_execute, reg_write2_execute, reg_write1_wb, reg_write2_wb;
	wire [4:0] rd1_execute, rd1_wb, rd2_execute, rd2_wb;
	wire [4:0] execute1_type, execute2_type;
	wire [2:0] au_mul_lsu1, au_mul_lsu2, au_mul_lsu1_wb, au_mul_lsu2_wb;
	wire [31:0] data1_wb, data2_wb;
	wire [31:0] au1_result, au2_result, mul1_result, mul2_result, au1_wb, au2_wb, mul1_wb, mul2_wb, lsu_result, 
	lsu_wb;
	wire fifo_full, buffer_full, jal_schedule, instr1_jump, instr1_jump_accept, instr2_jump, instr2_jump_accept;
	wire [31:0] jal_addr, instr1_jump_addr, instr2_jump_addr;
	wire fifo_rst, fifo_stall, buffer_stall, buffer_rst;
	wire transfer_decode1_rst, transfer_decode2_rst, transfer_execute_rst;
	wire [2:0] decode1_hazard_select1, decode1_hazard_select2, decode2_hazard_select1, decode2_hazard_select2;
	wire jump, jump_accept;
	wire [31:0] jump_addr;
	wire write_fifo;
	wire [127:0] fetch_instr_pc;

/// ========================================Fetch1=========================================///
	Cache_Controller Cache_Controller_instance(clk, rst_n, rvalid, rlast, rdata, arready, jump, jump_accept, 
	jump_addr, stop_fetch, write_fifo, rready, araddr, arvalid, arburst, arsize, arlen, fetch_instr_pc);

	Fifo Fifo_instance(clk, fifo_rst, fetch_instr_pc, write_fifo, fifo_stall, data_out, fifo_full);

/// ========================================Fetch2========================================///

	Schedule Schedule_instance(data_out, instr1, instr2, write1, write2, jal_schedule, jal_addr);

	Buffer_Execute Buffer_Execute_instance(clk, buffer_rst, buffer_stall, write1, write2, instr1, instr2, buffer_full, 
	execute_instr);

/// ========================================Instr_Decode=========================================///

	Instr_Decode Instr_Decode_instance1(execute_instr1, instr1_rs1_data, instr1_rs2_data, au1_result, au2_result, 
	mul1_result, mul2_result, lsu_result, data1_wb, data2_wb, decode1_hazard_select1, decode1_hazard_select2, instr1_operand1_data, 
	instr1_operand2_data, reg_write1, execute_type1, au1_type, mul1_type, lsu1_type, instr1_jump, instr1_jump_accept,
	instr1_jump_addr);

	Transfer_Decode_Execute Transfer_Decode_Execute_instance1(clk, transfer_decode1_rst, stall, instr1_operand1_data, 
	instr1_operand2_data, reg_write1, rd1, execute_type1, au1_type, mul1_type, lsu1_type, 
	instr1_operand1, instr1_operand2, reg_write1_execute, rd1_execute, execute1_type, au_mul_lsu1[2], 
	au_mul_lsu1[1], au_mul_lsu1[0]);

	Instr_Decode Instr_Decode_instance2(execute_instr2, instr2_rs1_data, instr2_rs2_data, au1_result, au2_result, 
	mul1_result, mul2_result, lsu_result, data1_wb, data2_wb, decode2_hazard_select1, decode2_hazard_select2, instr2_operand1_data, 
	instr2_operand2_data, reg_write2, execute_type2, au2_type, mul2_type, lsu2_type, instr2_jump, instr2_jump_accept,
	instr2_jump_addr);

	Transfer_Decode_Execute Transfer_Decode_Execute_instance2(clk, transfer_decode2_rst, stall, instr2_operand1_data, 
	instr2_operand2_data, reg_write2, rd2, execute_type2, au2_type, mul2_type, lsu2_type, 
	instr2_operand1, instr2_operand2, reg_write2_execute, rd2_execute, execute2_type, au_mul_lsu2[2], 
	au_mul_lsu2[1], au_mul_lsu2[0]);

	Register_File Register_File_instance(clk, rst_n, instr1_rs1, instr1_rs2, instr2_rs1, instr2_rs2, reg_write1_wb, 
	reg_write2_wb, rd1_wb, rd2_wb, data1_wb, data2_wb, instr1_rs1_data, instr1_rs2_data, instr2_rs1_data, instr2_rs2_data);
	

/// =========================================Execute============================================///

	wire [31:0] au1_operand1 = (au_mul_lsu1[2]) ? instr1_operand1 : 32'hz;
	wire [31:0] au1_operand2 = (au_mul_lsu1[2]) ? instr1_operand2 : 32'hz;
	wire [31:0] au2_operand1 = (au_mul_lsu2[2]) ? instr2_operand1 : 32'hz;
	wire [31:0] au2_operand2 = (au_mul_lsu2[2]) ? instr2_operand2 : 32'hz;
	wire [31:0]	mul1_operand1 = (au_mul_lsu1[1]) ? instr1_operand1 : 32'hz;
	wire [31:0] mul1_operand2 = (au_mul_lsu1[1]) ? instr1_operand2 : 32'hz;
	wire [31:0]	mul2_operand1 = (au_mul_lsu2[1]) ? instr2_operand1 : 32'hz;
	wire [31:0]	mul2_operand2 = (au_mul_lsu2[1]) ? instr2_operand2 : 32'hz;
	wire [4:0] au1_execute = (au_mul_lsu1[2]) ? execute1_type : 5'hz;
	wire [4:0] au2_execute = (au_mul_lsu2[2]) ? execute2_type : 5'hz;
	wire [4:0] mul1_execute = (au_mul_lsu1[1]) ? execute1_type : 5'hz;
	wire [4:0] mul2_execute = (au_mul_lsu2[2]) ? execute2_type : 5'hz;

	

	AU AU_instance1(au1_operand1, au1_operand2, au1_execute, au1_result);

	AU AU_instance2(au2_operand1, au2_operand2, au2_execute, au2_result);

	Mul_Div Mul_Div_instance1(mul1_operand1, mul1_operand2, mul1_execute, mul1_result);

	Mul_Div Mul_Div_instance2(mul2_operand1, mul2_operand2, mul2_execute, mul2_result);

	// LSU module

	Transfer_Execute_WB Transfer_Execute_WB_instance(clk, transfer_execute_rst, stall, reg_write1_execute, reg_write2_execute, 
	rd1_execute, rd2_execute, au_mul_lsu1, au_mul_lsu2, au1_result, au2_result, mul1_result, mul2_result, 
	lsu_result, reg_write1_wb, reg_write2_wb, rd1_wb, rd2_wb, au_mul_lsu1_wb, au_mul_lsu2_wb, au1_wb, au2_wb, 
	mul1_wb, mul2_wb, lsu_wb);

/// =========================================WB=================================================//

	Select_Data_WB Select_Data_WB_instance1(au1_result, mul1_result, lsu_result, au_mul_lsu1_wb, data1_wb);

	Select_Data_WB Select_Data_WB_instance2(au2_result, mul2_result, lsu_result, au_mul_lsu2_wb, data2_wb);

//// ======================================= Hazard_Detect =====================================///
	// Control
	Control Control_instance(clk, rst_n, fifo_full, buffer_full, jal_schedule, jal_addr, instr1_jump, 
	instr1_jump_accept, instr1_jump_addr, instr2_jump, instr2_jump_accept, instr2_jump_addr, 
	instr1_rs1, instr1_rs2, instr2_rs1, instr2_rs2, rd1_execute, rd2_execute, rd1_wb, 
	rd2_wb, au_mul_lsu1, au_mul_lsu2, lsu_work, lsu_done, stop_fetch, jump, jump_accept, jump_addr, fifo_rst, 
	fifo_stall, buffer_rst, buffer_stall, transfer_decode1_rst, transfer_decode2_rst, transfer_execute_rst, 
	decode1_hazard_select1, decode1_hazard_select2, decode2_hazard_select1, decode2_hazard_select2);

endmodule: Core
