`include "rtl/PC_Control.v"
module Cache_Controller(
	// Input signals
	input wire  		clk,
	input wire  		rst_n,
	input wire  		rvalid,
	input wire   		rlast,
	input wire [63:0]	rdata,
	input wire 			arready,
	input wire  		jump,
	input wire 			jump_accept,
	input wire [31:0]	jump_addr,
	input wire 			stop_fetch,
	// Output signals	
	output wire			write_fifo,
	output wire 		rready,
	output wire [31:0] 	araddr,
	output reg 			arvalid,
	output wire [1:0]  	arburst,
	output wire [2:0]  	arsize,
	output wire [7:0]  	arlen,
	output wire [127:0] fetch_instr_pc
);
	assign arburst = 2'b00;
	assign arsize = 3'd2;
	assign arlen = 8'd0;
	assign arcache = 3'b011;
	assign rready = (stop_fetch)? 1'b0:1'b1;
	assign write_fifo = (rvalid & rlast & !jump) ? 1'b1 : 1'b0;
	assign fetch_instr_pc = (rvalid & arvalid) ? {rdata[63:32], araddr - 4, rdata[31:0], araddr - 8} :128'd0;
	// assign arvalid = (!rst_n) ? 1'b0 : 1'b1;

	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			arvalid = 1'b0;
		end
		else if (araddr !== 32'bz) begin
			arvalid = 1'b1;
			if (arready == 1'b1) arvalid = 1'b1;
		end
		else arvalid = 1'b0;
	end

	PC_Control PC_Control_instance(clk, rst_n, stall, jump, jump_accept, jump_addr, araddr);

endmodule: Cache_Controller





