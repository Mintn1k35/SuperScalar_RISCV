`timescale 1ns/1ps

`include "../rtl/Transfer_Execute_WB.v"

module tb_Transfer_Execute_WB;

	logic			clk;
	logic			rst_n;
	logic			stall;
	logic			reg_write1_execute;
	logic			reg_write2_execute;
	logic [4:0]	rd1_execute;
	logic [4:0]	rd2_execute;
	logic [2:0]	au_mul_lsu1;
	logic [2:0]	au_mul_lsu2;
	logic [31:0]	au1_result;
	logic [31:0]	au2_result;
	logic [31:0]	mul1_result;
	logic [31:0]	mul2_result;
	logic [31:0]	lsu_result;


	logic 			reg_write1_wb;
	logic			reg_write2_wb;
	logic [4:0]	rd1_wb;
	logic [4:0]	rd2_wb;
	logic [2:0]	au_mul_lsu1_wb;
	logic [2:0]	au_mul_lsu2_wb;
	logic [31:0]	au1_wb;
	logic [31:0]	au2_wb;
	logic [31:0]	mul1_wb;
	logic [31:0]	mul2_wb;
	logic [31:0]	lsu_wb;
	


	initial begin
		$dumpfile("wave_file/tb_Transfer_Execute_WB.vcd");
		$dumpvars(0, tb_Transfer_Execute_WB);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Transfer_Execute_WB Transfer_Execute_WB_instance(clk, rst_n, stall, reg_write1_execute, reg_write2_execute, rd1_execute, rd2_execute, au_mul_lsu1, au_mul_lsu2, au1_result, au2_result, mul1_result, mul2_result, lsu_result, reg_write1_wb, reg_write2_wb, rd1_wb, rd2_wb, au_mul_lsu1_wb, au_mul_lsu2_wb, au1_wb, au2_wb, mul1_wb, mul2_wb, lsu_wb);
endmodule
