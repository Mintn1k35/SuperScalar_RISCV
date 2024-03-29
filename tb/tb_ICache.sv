`timescale 1ns/1ps

`include "../rtl/ICache.v"

module tb_ICache;

	logic clk;
	logic rst_n;
	logic arvalid;
	logic [31:0] araddr;
	logic [1:0] arburst;
	logic [2:0] arsize;
	logic [7:0] arlen;
	logic arready;
	logic rready;
	logic rvalid;
	logic [31:0] rdata;
	logic rlast;

	initial begin
		$dumpfile("wave_file/tb_ICache.vcd");
		$dumpvars(0, tb_ICache);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(60)
		rst_n = 1'b1;
	end


	ICache ICache_instance(clk, rst_n, arvalid, araddr, arburst, arsize, arlen, arready, rready, rvalid, rdata, rlast);
endmodule
