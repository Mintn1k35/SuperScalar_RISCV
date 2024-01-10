`timescale 1ns/1ps

`include "../rtl/Cache_Controller.v"

module tb_Cache_Controller;

	logic  		clk;
	logic  		rst_n;
	logic  		rvalid;
	logic   		rlast;
	logic [31:0]	rdata;
	logic 			arready;
	logic  		jump;
	logic 			jump_accept;
	logic [31:0]	jump_addr;
	logic 			stop_fetch;


	logic			write_fifo;
	logic 		rready;
	logic [31:0] 	araddr;
	logic 		arvalid;
	logic [1:0]  	arburst;
	logic [2:0]  	arsize;
	logic [7:0]  	arlen;
	logic [63:0]  fetch_instr_pc;
	


	initial begin
		$dumpfile("wave_file/tb_Cache_Controller.vcd");
		$dumpvars(0, tb_Cache_Controller);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Cache_Controller Cache_Controller_instance(clk, rst_n, rvalid, rlast, rdata, arready, jump, jump_accept, jump_addr, stop_fetch, write_fifo, rready, araddr, arvalid, arburst, arsize, arlen, output wire [63:0]  fetch_instr_pc);
endmodule
