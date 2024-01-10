`include "ICache.v"
`include "Cache_Controller.v"
module Test(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			jump,
	input wire			jump_accept,
	input wire [31:0]	jump_addr,
	input wire			stop_fetch,
	// Output signals	
	output wire	[127:0]	fetch_instr_pc,
	output wire			write_fifo
);

	wire arvalid, rready, rvalid, arready;
	wire [63:0] rdata;
	wire [1:0] arburst;
	wire [2:0] arsize;
	wire [7:0] arlen;
	wire [31:0] araddr;

	ICache ICache_instance(clk, rst_n, arvalid, araddr, arburst, arsize, arlen, arready, rready, rvalid, rdata, 
	rlast);

	Cache_Controller Cache_Controller_instance(clk, rst_n, rvalid, rlast, rdata, arready, jump, jump_accept, 
	jump_addr, stop_fetch, write_fifo, rready, araddr, arvalid, arburst, arsize, arlen, fetch_instr_pc);
endmodule: Test





