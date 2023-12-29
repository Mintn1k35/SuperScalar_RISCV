
`include "Fifo.v"
module Ibits(
	// Input signals
	input wire 		clk,
	input wire 		rst_n,
	input wire 		rvalid, // AXI
	input wire 		rlast, // AXI
	input wire [63:0]	rdata, // AXI
	input wire [31:0]	fetch_pc,
	input wire		jump,
	input wire 		jump_wait,
	input wire		jump_accept,
	input wire 		busy,

	// Output signals	
	output wire 		rready, // AXI
	output wire [63:0]	fetch_instr_pc,
	output wire		buf_empty,
	output wire		buf_full
);

	wire rst_fifo = rst_n & !jump_accept;
	wire [31:0] instr1 = rdata;
	wire [31:0] instr2 = rdata >> 32;
	wire [127:0] data_in = rvalid ? { instr2, fetch_pc + 32'd4, instr1, fetch_pc } : 128'h000000013000000000000001300000000;
	wire write = rvalid & !buf_full;
	wire read = !buf_empty & !busy & !(jump & jump_wait);

	
	Fifo Fifo_Instance(clk, rst_n, data_in, write, read, fetch_instr_pc, buf_empty, buf_full);


endmodule: Ibits





