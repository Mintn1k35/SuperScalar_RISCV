
module DCache(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	
	// Write address channel
	input wire			awvalid,
	input wire [31:0]	awaddr,
	input wire [2:0]	awsize,
	input wire [7:0]	awlen,
	output wire			awready,	

	// Write data channel
	input wire			wvalid,
	input wire [31:0]	wdata,

	// Output signals	
	output wire 			awready,
	output wire				wready
);
endmodule: DCache





