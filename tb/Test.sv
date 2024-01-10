`timescale 1ns/1ps

`include "../rtl/Test.v"

module tb_Test;

	logic			clk;
	logic			rst_n;
	logic			jump;
	logic			jump_accept;
	logic [31:0]	jump_addr;
	logic			stop_fetch;


	logic	[127:0]	fetch_instr_pc;
	logic			write_fifo;
	


	initial begin
		$dumpfile("wave_file/tb_Test.vcd");
		$dumpvars(0, tb_Test);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(20)
		rst_n = 1'b1;
		jump = 1'b0;
		jump_accept = 1'b0;
		jump_addr = 32'b0;
		stop_fetch = 1'b0;
		#(100)
		$finish;
	end


	Test Test_instance(clk, rst_n, jump, jump_accept, jump_addr, stop_fetch, fetch_instr_pc, write_fifo);
endmodule
