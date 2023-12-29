`timescale 1ns/1ps

`include "../rtl/Ibits.v"

module tb_Ibits;

	// Input signals
	logic clk;
	logic rst_n;
	logic rvalid;
	logic rlast;
	logic [31:0] rdata;
	logic [31:0] fetch_pc;
	logic jump;
	logic jump_wait;
	logic jump_accept;
	logic busy;
	// Output signals
	logic rready;
	logic [64:0] fetch_instr_pc;
	logic buf_full;
	
	
	always #(10) clk = ~clk;

	initial begin
		$dumpfile("wave_file/tb_Ibits.vcd");
		$dumpvars(0, tb_Ibits);
	end

	
	initial begin
		clk = 1'b1;
		rst_n = 1'b0;
		#(60)
		rst_n = 1'b1;
		rvalid = 1'b1;
		rdata = 32'h0000A0B7;
		fetch_pc = 32'd0;
		jump = 1'b0;
		jump_wait = 1'b0;
		jump_accept = 1'b0;
		busy = 1'b0;
		#(20)
		rdata = 32'h2004000EF;
		fetch_pc = 32'd4;
		#(20)
		rvalid = 1'b0;
		rdata = 32'h0000A137;
		fetch_pc = 32'd8;
		#(1000)
		$finish;
	end


	Ibits Ibits_instance(clk, rst_n, rvalid, rlast, rdata, fetch_pc, jump, jump_wait, jump_accept, busy, rready, fetch_instr_pc, buf_full);
endmodule
