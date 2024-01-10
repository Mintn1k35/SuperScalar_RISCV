`timescale 1ns/1ps

`include "../rtl/Register_File.v"

module tb_Register_File;

	logic			clk;
	logic			rst_n;
	logic [4:0]	instr1_rs1;
	logic [4:0]	instr1_rs2;
	logic [4:0]	instr2_rs1;
	logic [4:0]	instr2_rs2;
	logic			write1;
	logic 			write2;
	logic [4:0]	rd1;
	logic [4:0]	rd2;
	logic [31:0]	write1_data;
	logic [31:0]	write2_data;


	logic [31:0]	instr1_rs1_data;
	logic [31:0]	instr1_rs2_data;
	logic [31:0]	instr2_rs1_data;
	logic [31:0]	instr2_rs2_data;
	


	initial begin
		$dumpfile("wave_file/tb_Register_File.vcd");
		$dumpvars(0, tb_Register_File);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Register_File Register_File_instance(clk, rst_n, instr1_rs1, instr1_rs2, instr2_rs1, instr2_rs2, write1, write2, rd1, rd2, write1_data, write2_data, instr1_rs1_data, instr1_rs2_data, instr2_rs1_data, instr2_rs2_data);
endmodule
