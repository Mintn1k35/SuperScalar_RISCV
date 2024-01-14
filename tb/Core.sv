`timescale 1ns/1ps

`include "../rtl/Core.v"

module tb_Core;

	logic			clk;
	logic			rst_n;
	logic			Irvalid;
	logic			Irlast;
	logic [63:0]	Irdata;
	logic			Dawready;
	logic 			Dawready;
	logic [1:0]	Dbresp;
	logic 			Dbvalid;
	logic			Dwready;
	logic 			Darready;
	logic [31:0]	Drdata;
	logic 			Drlast;
	logic 			Drvalid;


	logic 		Irready;
	logic [31:0]	Iaraddr;
	logic			Iarvalid;
	logic [1:0]	Iarburst;
	logic [2:0]	Iarsize;
	logic [7:0]	Iarlen;
	logic [3:0]	Iarcache;
	logic [31:0]	Dawaddr;
	logic [1:0]	Dawburst;
	logic [3:0]	Dawcache;
	logic [7:0]	Dawlen;
	logic [2:0]	Dawsize;
	logic 			Dawvalid;
	logic 			Dbready;
	logic [31:0]	Dwdata;
	logic 			Dwlast;
	logic [3:0]	Dwstrb;
	logic 			Dwvalid;
	logic [31:0]	Daraddr;
	logic [1:0]	Darburst;
	logic [3:0]	Darcache;
	logic [7:0]	Darlen;
	logic [2:0]	Darsize;
	logic 			Darvalid;
	logic 			Drready;
	


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


	Core Core_instance(clk, rst_n, Irvalid, Irlast, Irdata, Dawready, Dawready, Dbresp, Dbvalid, Dwready, Darready, Drdata, Drlast, Drvalid, Irready, Iaraddr, Iarvalid, Iarburst, Iarsize, Iarlen, Iarcache Dawaddr, Dawburst, Dawcache, Dawlen, Dawsize, Dawvalid, Dbready, Dwdata, Dwlast, Dwstrb, Dwvalid, Daraddr, Darburst, Darcache, Darlen, Darsize, Darvalid, Drready);
endmodule
