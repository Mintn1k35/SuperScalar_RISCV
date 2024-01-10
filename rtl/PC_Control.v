
module PC_Control(
	// Input signals
	input wire 			clk,
	input wire 			rst_n,
	input wire			stall,
	input wire			jump,
	input wire			jump_accept,
	input wire [31:0]	jump_addr,
	// Output signal	
	output reg	[31:0]	pc_addr
);
	wire [31:0] next_pc = jump ? jump_addr : pc_addr + 32'd8;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pc_addr <= 32'd0;
		end
		else if(stall) begin
			pc_addr <= pc_addr;
		end
		else pc_addr <= next_pc;
	end

endmodule: PC_Control





