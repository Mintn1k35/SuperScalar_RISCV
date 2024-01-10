
module Transfer_Decode_Execute(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			stall,
	input wire [31:0]	operand1_decode,
	input wire [31:0]	operand2_decode,
	input wire			reg_write_decode,
	input wire [4:0]	rd_decode,
	input wire [4:0]	execute_type_decode,
	input wire 			au_decode,
	input wire 			mul_decode,
	input wire			lsu_decode,
	// Output signals	
	output reg [31:0]	operand1_execute,
	output reg [31:0]	operand2_execute,
	output reg			reg_write_execute,
	output reg [4:0]	rd_execute,
	output reg [4:0]	execute_type_execute,
	output reg			au_execute,
	output reg			mul_execute,
	output reg			lsu_execute
);

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			operand1_execute <= 32'd0;
			operand2_execute <= 32'd0;
			reg_write_execute <= 1'b0;
			rd_execute <= 5'd0;
			execute_type_execute <= 5'd0;
			au_execute <= 1'b0;
			mul_execute <= 1'b0;
			lsu_execute <= 1'b0;
		end
		else if(stall) begin
			operand1_execute <= operand1_execute;
			operand2_execute <= operand2_execute;
			reg_write_execute <= reg_write_execute;
			rd_execute <= rd_execute;
			execute_type_execute <= execute_type_execute;
			au_execute <= au_execute;
			mul_execute <= mul_execute;
			lsu_execute <= lsu_execute;
		end
		else begin
			operand1_execute <= operand1_decode;
			operand2_execute <= operand2_decode;
			reg_write_execute <= reg_write_decode;
			rd_execute <= rd_decode;
			execute_type_execute <= execute_type_decode;
			au_execute <= au_decode;
			mul_execute <= mul_decode;
			lsu_execute <= lsu_decode;
		end
	end

endmodule: Transfer_Decode_Execute





