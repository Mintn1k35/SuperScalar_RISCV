`timescale 1ns/1ps

`include "../rtl/Control.v"

module tb_Control;

	logic			rst_n;
	logic			fifo_full;
	logic			buffer_full;
	logic			jal_schedule;
	logic [31:0]	jal_addr;
	logic			instr1_jump;
	logic			instr1_jump_accept;
	logic [31:0]	instr1_jump_addr;
	logic			instr2_jump;
	logic			instr2_jump_accept;
	logic [31:0]	instr2_jump_addr;
	logic [4:0]	instr1_rs1_decode;
	logic [4:0]	instr1_rs2_decode;
	logic [4:0]	instr2_rs1_decode;
	logic [4:0]	rd1_execute;
	logic [4:0]	rd2_execute;
	logic [4:0]	rd1_wb;
	logic [4:0]	rd2_wb;
	logic [2:0]	au_mul_lsu1;
	logic [2:0]	au_mul_lsu2;
	logic			lsu_work;
	logic			lsu_done;


	logic			stop_fetch;
	logic			jump;
	logic [31:0]	jump_addr;
	logic			fifo_rst;
	logic			fifo_stall;
	logic			buffer_rst;
	logic 			buffer_stall;
	logic			transfer_decode1_rst;
	logic			transfer_decode2_rst;
	logic			transfer_execute_rst;
	logic [2:0]	hazard_select1;
	logic [2:0]	hazard_select2;
	


	initial begin
		$dumpfile("wave_file/tb_Control.vcd");
		$dumpvars(0, tb_Control);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Control Control_instance(rst_n, fifo_full, buffer_full, jal_schedule, jal_addr, instr1_jump, instr1_jump_accept, instr1_jump_addr, instr2_jump, instr2_jump_accept, instr2_jump_addr, instr1_rs1_decode, instr1_rs2_decode, instr2_rs1_decode, rd1_execute, rd2_execute, rd1_wb, rd2_wb, au_mul_lsu1, au_mul_lsu2, lsu_work, lsu_done, stop_fetch, jump, jump_addr, fifo_rst, fifo_stall, buffer_rst, buffer_stall, transfer_decode1_rst, transfer_decode2_rst, transfer_execute_rst, hazard_select1, hazard_select2);
endmodule
