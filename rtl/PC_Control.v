`include "defines.v"
module PC_Control(
	// Input signals	
	input wire 		clk,
	input wire 		rst_n,
	input wire 		jump,
	input wire 		jump_cond,
	input wire [WIDTH-1:0]	jump_addr,
	input wire 		buffer_free,

	// Output signals
	output wire [WIDTH-1:0] imem_addr,
	
);
endmodule





