module PC_Control(
	// Input signals
	input wire 		clk,
	input wire 		rst_n,
	input wire		jump,
	input wire 		jump_wait,
	input wire		jump_accept,
	input wire [31:0]	jump_addr,
	input wire 		buffer_free,
	
	// Interface for AXI
	// Read address channel
	output reg 		arvalid,
	output reg [31:0]	araddr,
	output wire [1:0]	arburst,
	output wire [2:0]	arsize,
	output wire [7:0]	arlen,
	input wire 		arready,

	output reg [31:0]	fetch_pc


);

	wire [31:0] reset_pc;
	wire [31:0] next_pc;
	reg reset_state;
	wire [31:0] pc;


	assign arburst = 2'b00; // Fix mode
	assign arsize = 3'd2; // 2^2 the number of bytes transfer
	assign arlen = 7'd0; // the number of address transfer
	assign reset_pc = 32'd0;
	assign next_pc = (jump & jump_accept) ? jump_addr : (buffer_free) ? araddr + 32'd8 : araddr; 
	assign pc = (!rst_n) ? 32'd0 : araddr;	

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			reset_state <= 1'b1;
		end
		else reset_state <= 1'b0;
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			arvalid <= 1'b0;			
			fetch_pc <= reset_pc;
			araddr <= 32'd0;
		end
		else begin
			arvalid <= 1'b1;
			araddr <= (jump & jump_wait) ? araddr : (buffer_free & !reset_state) ? next_pc : araddr;
			fetch_pc <= pc;
		end
	end

endmodule





