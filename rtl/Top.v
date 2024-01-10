`include "Core.v"
`include "ICache.v"
module Top(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			jal,
	input wire			jalr_jcond,
	input wire [31:0]	jal_addr,
	input wire [31:0] 	jalr_jcond_addr,
	input wire			busy,
	// Output signals	
	output wire [63:0] fetch_instr_pc
);

	wire [31:0] araddr, rdata;
	wire rready, arready, rlast;
	wire [1:0] arburst;
	wire [2:0] arsize;
	wire [7:0] arlen;

	Core Core_instance(clk, rst_n, rvalid, rlast, rdata, arready, jal, jalr_jcond, jal_addr, jalr_jcond_addr, busy, rready, araddr, arburst, arsize, arlen, fetch_instr_pc);
	ICache ICache_instance(clk, rst_n, arvalid, araddr, arburst, arsize, arlen, arready, rready, rvalid, rdata, rlast);
endmodule: Top





