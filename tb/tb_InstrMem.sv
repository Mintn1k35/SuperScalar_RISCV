`timescale 1ns/1ps

`include "../rtl/InstrMem.v"


module tb_InstrMem;

	// Input signals
	logic 			clk;
	logic 			rst_n;
	logic 			arvalid;
	logic [31:0]	araddr;
	logic [1:0] 		arburst;
	logic [2:0] 		arsize;
	logic [7:0]		arlen;
	logic 			rready;
	// Output signals
	logic 			arready;
	logic 			rvalid;
	logic [31:0]	rdata;
	logic 			rlast;
	logic 			rresp;

	initial begin
		$dumpfile("wave_file/tb_InstrMem.vcd");
		$dumpvars(0, tb_InstrMem);
	end

	always #(10) clk = ~clk;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(30)
		rst_n = 1'b1;
		#(20)
		araddr = 32'd0;
		arvalid = 1'b1;
		rready = 1'b0;
		#(20)
		araddr = 32'd4;
		arvalid = 1'b1;
		rready = 1'b1;
		#(20)
		araddr = 32'd8;
		#(20)
		araddr = 32'd12;
		#(20)
		araddr = 32'd24;
		#(1000)
		$finish;
	end


	InstrMem InstrMem_instance(clk, rst_n, arvalid, araddr, arburst, arsize, arlen, arready, rready, rvalid, rdata, rlast, rresp);
endmodule
