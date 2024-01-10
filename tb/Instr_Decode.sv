`timescale 1ns/1ps

`include "../rtl/Instr_Decode.v"

module tb_Instr_Decode;

	logic [63:0]	fetch_instr_pc;
	logic [31:0]	data1_regfile;
	logic [31:0]	data2_regfile;
	logic [31:0]	data1_au;
	logic [31:0]	data2_au;
	logic [31:0]	data1_mul;
	logic [31:0]	data2_mul;
	logic [31:0]	data_lsu;
	logic [31:0]	data1_wb;
	logic [31:0]	data2_wb;
	logic [2:0]		hazard_select1;
	logic [2:0]		hazard_select2;


	logic [31:0]	instr_pc;
	logic [31:0]	operand1_data;
	logic [31:0]	operand2_data;
	logic			reg_write;
	logic [4:0]		execute_type;
	logic			au_type;
	logic			mul_type;
	logic			lsu_type;
	logic			jump;
	logic			jaccept;
	logic [31:0]	jaddr;
	

	logic clk;
	initial begin
		$dumpfile("wave_file/tb_Instr_Decode.vcd");
		$dumpvars(0, tb_Instr_Decode);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)
		fetch_instr_pc = 64'h0001413700000004;
		data1_regfile = 32'd1;
		data2_regfile = 32'd2;
		data1_regfile = 32'd3;
		data2_regfile = 32'd4;
		data1_au = 32'd5;
		data2_au = 32'd6;
		data1_mul = 32'd7;
		data2_mul = 32'd8;
		data_lsu = 32'd9;
		data1_wb = 32'd10;
		data2_wb = 32'd11;
		hazard_select1 = 5'd0;
		#(100)
		$finish;
	end


	Instr_Decode Instr_Decode_instance(fetch_instr_pc, data1_regfile, data2_regfile, data1_au, data2_au, data1_mul, data2_mul, data_lsu, data1_wb, data2_wb, hazard_select1, hazard_select2, instr_pc, operand1_data, operand2_data, reg_write, execute_type, au_type, mul_type, lsu_type, jump, jaccept, jaddr);
endmodule
