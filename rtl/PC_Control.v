
module PC_Control(
	// Input signals
	input wire 			clk,
	input wire 			rst_n,
	input wire   		jal,
	input wire 			jalr_jcond,
	input wire [31:0]	jal_addr,
	input wire [31:0] 	jalr_jcond_addr,
	input wire 			rlast,
	// Output signal	
	output reg	[31:0]	pc_addr
);
	wire [31:0] next_pc = jal ? jal_addr : jalr_jcond ? jalr_jcond_addr : pc_addr + 32'd4;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			pc_addr <= 32'd0;
		end
		else if (!rlast) begin
			pc_addr <= pc_addr;
		end
		else pc_addr <= next_pc;
	end

endmodule: PC_Control





