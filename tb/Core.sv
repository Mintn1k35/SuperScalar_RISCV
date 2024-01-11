`timescale 1ns/1ps

`include "../rtl/Core.v"

module tb_Core;

	logic			clk;
	logic			rst_n;
	logic [127:0]	data_in;
	logic 			write;
	logic			rvalid;
	logic			rlast;
	logic [63:0]	rdata;


	logic 		rready;
	logic [31:0]	araddr;
	logic			arvalid;
	logic [1:0]	arburst;
	logic [2:0]	arsize;
	logic [7:0]	arlen;
	logic [3:0]	arcache;
	


	initial begin
		$dumpfile("wave_file/tb_Core.vcd");
		$dumpvars(0, tb_Core);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Core Core_instance(clk, rst_n, data_in, write, rvalid, rlast, rdata, rready, araddr, arvalid, arburst, arsize, arlen, arcache,);
endmodule
