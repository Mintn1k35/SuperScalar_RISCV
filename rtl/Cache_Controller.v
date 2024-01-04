`include "PC_Control.v"
module Cache_Controller(
	// Input signals
	input wire  		clk,
	input wire  		rst_n,
	input wire  		rvalid,
	input wire   		rlast,
	input wire [31:0]	rdata,
	input wire 			arready,
	input wire 			jal,
	input wire  		jalr_jcond,
	input wire [31:0]	jal_addr,
	input wire [31:0]	jalr_jcond_addr,
	input wire 			busy,
	// Output signals	
	output wire 		rready,
	output wire [31:0] 	araddr,
	output reg [1:0]  	arburst,
	output reg [2:0]  	arsize,
	output reg [7:0]  	arlen,
	output reg [63:0]  	fetch_instr_pc
);

	assign rready = !busy;

	always @(posedge clk or negedge rst_n) begin
		arburst <= 2'b00;
		arsize <= 3'd2;
		arlen <= 8'd0;
		if(!rst_n) begin
			fetch_instr_pc <= 64'd0;
		end
		else if (!rvalid) begin
			fetch_instr_pc <= 64'd0;
		end
		else begin
			fetch_instr_pc <= {rdata, araddr};
		end
	end

	PC_Control PC_Control_instance(clk, rst_n, jal, jalr_jcond, jal_addr, jalr_jcond_addr, rlast, araddr);

endmodule: Cache_Controller





