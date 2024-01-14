`timescale 1ns/1ps

`include "../rtl/LSU.v"

module tb_LSU;

	logic			clk;
	logic			rst_n;
	logic [31:0]	operand1;
	logic [31:0]	operand2;
	logic			write_mem;
	logic			lsu_start;
	logic [4:0]	execute_type;
	logic 			awready;
	logic [1:0]	bresp;
	logic 			bvalid;
	logic			wready;
	logic 			arready;
	logic [31:0]	rdata;
	logic 			rlast;
	logic 			rvalid;


	logic			lsu_work;
	logic			lsu_done;
	logic [31:0]	result;
	logic [31:0]	awaddr;
	logic [1:0]	awburst;
	logic [3:0]	awcache;
	logic [7:0]	awlen;
	logic [2:0]	awsize;
	logic 			awvalid;
	logic 			bready;
	logic [31:0]	wdata;
	logic 			wlast;
	logic [3:0]	wstrb;
	logic 			wvalid;
	logic [31:0]	araddr;
	logic [1:0]	arburst;
	logic [3:0]	arcache;
	logic [7:0]	arlen;
	logic [2:0]	arsize;
	logic 			arvalid;
	logic 			rready;
	


	initial begin
		$dumpfile("wave_file/tb_LSU.vcd");
		$dumpvars(0, tb_LSU);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	LSU LSU_instance(clk, rst_n, operand1, operand2 write_mem, lsu_start, execute_type, awready, bresp, bvalid, wready, arready, rdata, rlast, rvalid, lsu_work, lsu_done, result, awaddr, awburst, awcache, awlen, awsize, awvalid, bready, wdata, wlast, wstrb, wvalid, araddr, arburst, arcache, arlen, arsize, arvalid, rready);
endmodule
