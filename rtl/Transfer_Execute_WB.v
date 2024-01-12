
module Transfer_Execute_WB(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	// input wire			stall,
	input wire			reg_write1_execute,
	input wire			reg_write2_execute,
	input wire [4:0]	rd1_execute,
	input wire [4:0]	rd2_execute,
	input wire [2:0]	au_mul_lsu1,
	input wire [2:0]	au_mul_lsu2,
	input wire [31:0]	au1_result,
	input wire [31:0]	au2_result,
	input wire [31:0]	mul1_result,
	input wire [31:0]	mul2_result,
	input wire [31:0]	lsu_result,	
	// Output signals	
	output reg 			reg_write1_wb,
	output reg			reg_write2_wb,
	output reg [4:0]	rd1_wb,
	output reg [4:0]	rd2_wb,
	output reg [2:0]	au_mul_lsu1_wb,
	output reg [2:0]	au_mul_lsu2_wb,
	output reg [31:0]	au1_wb,
	output reg [31:0]	au2_wb,
	output reg [31:0]	mul1_wb,
	output reg [31:0]	mul2_wb,
	output reg [31:0]	lsu_wb
);	

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			reg_write1_wb <= 1'b0;
			reg_write2_wb <= 1'b0;
			rd1_wb <= 5'd0;
			rd2_wb <= 5'd0;
			au_mul_lsu1_wb <= 3'd0;
			au_mul_lsu2_wb <= 3'd0;
			au1_wb <= 32'd0;
			au2_wb <= 32'd0;
			mul1_wb <= 32'd0;
			mul2_wb <= 32'd0;
			lsu_wb <= 32'd0;
		end
		// else if(stall) begin
		// 	reg_write1_wb <= 1'b0;
		// 	reg_write2_wb <= 1'b0;
		// 	rd1_wb <= 5'd0;
		// 	rd2_wb <= 5'd0;
		// 	au_mul_lsu1_wb <= 3'd0;
		// 	au_mul_lsu2_wb <= 3'd0;
		// 	au1_wb <= 32'd0;
		// 	au2_wb <= 32'd0;
		// 	mul1_wb <= 32'd0;
		// 	mul2_wb <= 32'd0;
		// 	lsu_wb <= 32'd0;
		// end
		else begin
			reg_write1_wb <= reg_write1_execute;
			reg_write2_wb <= reg_write2_execute;
			rd1_wb <= rd1_execute;
			rd2_wb <= rd2_execute;
			au_mul_lsu1_wb <= au_mul_lsu1;
			au_mul_lsu2_wb <= au_mul_lsu2;
			au1_wb <= au1_result;
			au2_wb <= au2_result;
			mul1_wb <= mul1_result;
			mul2_wb <= mul2_result;
			lsu_wb <= lsu_result;
		end
	end

endmodule: Transfer_Execute_WB





