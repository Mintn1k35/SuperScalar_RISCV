`timescale 1ns/1ps

`include "../rtl/Instr_Decode.v"

module tb_Instr_Decode;

	// Input signals
	logic 		clk;
	logic 		rst_n;
	logic [63:0]	fetch_instr_pc;
	logic 		instr_valid;
	logic 		rs1_valid;
	logic 		rs2_valid;
	logic [31:0]	rs1_data;
	logic [31:0]	rs2_data;
	logic [2:0]	au_free;
	logic [2:0]	mul_free;
	logic 		lsu_free;
	// Output signals
	logic 		busy;
	logic [4:0]	rs1;
	logic [4:0]	rs2;
	logic 		jump;
	logic 		jump_wait;
	logic 		jump_accept;
	logic [31:0]	jump_addr;
	logic [16:0]	rd_rs1_rs2;
	logic [7:0]	execute_type;
	logic [31:0]	imm_extend;


	initial begin
		$dumpfile("wave_file/tb_Instr_Decode.vcd");
		$dumpvars(0, tb_Instr_Decode);
	end

	
	always #(10) clk = ~clk;

	initial begin	
		clk = 1'b0;
		rst_n = 1'b0;
		#(60)
		rst_n = 1'b1;
		fetch_instr_pc = 64'h0020866300000000;
		instr_valid = 1'b1;
		rs1_valid = 1'b1;
		rs2_valid = 1'b1;
		rs1_data = 32'd10;
		rs2_data = 32'd10;
		au_free = 3'd0;
		mul_free = 3'b1;
		lsu_free = 1'b1;
		#(100)
		$finish;
	end


	Instr_Decode Instr_Decode_instance(clk, rst_n, fetch_instr_pc, instr_valid, rs1_valid, rs2_valid, rs1_data, rs2_data, au_free, mul_free, lsu_free, busy, rs1, rs2, jump, jump_wait, jump_accept, jump_addr, rd_rs1_rs2, execute_type, imm_extend);
endmodule
