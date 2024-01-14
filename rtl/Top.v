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

	wire [31:0] Iaraddr;
	wire [63:0] Irdata;
	wire Irready, Iarready, Irlast;
	wire [1:0] Iarburst;
	wire [2:0] Iarsize;
	wire [7:0] Iarlen;

	Core Core_instance(clk, rst_n, Irvalid, Irlast, Irdata, Dawready, Dbresp, Dbvalid, Dwready, 
	Darready, Drdata, Drlast, Drvalid, Irready, Iaraddr, Iarvalid, Iarburst, Iarsize, Iarlen, Iarcache, 
	Dawaddr, Dawburst, Dawcache, Dawlen, Dawsize, Dawvalid, Dbready, Dwdata, Dwlast, Dwstrb, Dwvalid, 
	Daraddr, Darburst, Darcache, Darlen, Darsize, Darvalid, Drready);

	ICache ICache_instance(clk, rst_n, Iarvalid, Iaraddr, Iarburst, Iarsize, Iarlen, Iarready, Irready, Irvalid, Irdata, Irlast);
endmodule: Top





