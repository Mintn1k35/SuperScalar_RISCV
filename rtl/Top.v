
`include "Core.v"
`include "InstrMem.v"
module Top(
	// Input signals
	input wire 	clk,
	input wire 	rst_n,
	input wire	rs1_valid,
	input wire 	rs2_valid,
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	input wire [2:0]	au_free,
	input wire [2:0]	mul_free,
	input wire	lsu_free	

	// Output signals	
);

	
	wire  arvalid, arready, rvalid, rlast; 
	wire [2:0] arsize;
	wire [1:0] arburst, rresp;
	wire [7:0] arlen, execute_type;
	wire [31:0] araddr, imm_extend;
	wire [63:0] rdata;
	wire [16:0] rd_rs1_rs2;


	InstrMem InstrMem_Instance(clk, rst_n, arvalid, araddr, arburst, arsize, arlen, arready, rready, rvalid, rdata, rlast, rresp);

	Core Core_Instance(clk, rst_n, arready, rdata, rvalid, rlast, rs1_valid, rs2_valid, rs1_data, rs2_data, au_free, mul_free, lsu_free, arvalid, araddr, arburst, arsize, arlen, rd_rs1_rs2, execute_type, imm_extend);

endmodule





