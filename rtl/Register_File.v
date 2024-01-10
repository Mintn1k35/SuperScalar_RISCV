
module Register_File(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire [4:0]	instr1_rs1,
	input wire [4:0]	instr1_rs2,
	input wire [4:0]	instr2_rs1,
	input wire [4:0]	instr2_rs2,
	input wire			write1,
	input wire 			write2,
	input wire [4:0]	rd1,
	input wire [4:0]	rd2,
	input wire [31:0]	write1_data,
	input wire [31:0]	write2_data,
	// Output signals	
	output reg [31:0]	instr1_rs1_data,
	output reg [31:0]	instr1_rs2_data,
	output reg [31:0]	instr2_rs1_data,
	output reg [31:0]	instr2_rs2_data
);
	reg [31:0] reg_data[31:0];


	always @(clk or negedge rst_n) begin
		if(!rst_n) begin
			reg_data[0] <= 32'd0;
			reg_data[1] <= 32'd0;
			reg_data[2] <= 32'd0;
			reg_data[3] <= 32'd0;
			reg_data[4] <= 32'd0;
			reg_data[5] <= 32'd0;
			reg_data[6] <= 32'd0;
			reg_data[7] <= 32'd0;
			reg_data[8] <= 32'd0;
			reg_data[9] <= 32'd0;
			reg_data[10] <= 32'd0;
			reg_data[11] <= 32'd0;
			reg_data[12] <= 32'd0;
			reg_data[13] <= 32'd0;
			reg_data[14] <= 32'd0;
			reg_data[15] <= 32'd0;
			reg_data[16] <= 32'd0;
			reg_data[17] <= 32'd0;
			reg_data[18] <= 32'd0;
			reg_data[19] <= 32'd0;
			reg_data[20] <= 32'd0;
			reg_data[21] <= 32'd0;
			reg_data[22] <= 32'd0;
			reg_data[23] <= 32'd0;
			reg_data[24] <= 32'd0;
			reg_data[25] <= 32'd0;
			reg_data[26] <= 32'd0;
			reg_data[27] <= 32'd0;
			reg_data[28] <= 32'd0;
			reg_data[29] <= 32'd0;
			reg_data[30] <= 32'd0;
			reg_data[31] <= 32'd0;
		end
		else begin
			if(write1) begin
				reg_data[rd1] <= write1_data;
			end
			if(write2) begin
				reg_data[rd2] <= write2_data;
			end
		end
	end

	assign instr1_rs1_data = (instr1_rs1 == 5'd0) ? 32'd0 : reg_data[instr1_rs1];
	assign instr1_rs2_data = (instr1_rs2 == 5'd0) ? 32'd0 : reg_data[instr1_rs2];
	assign instr2_rs1_data = (instr2_rs1 == 5'd0) ? 32'd0 : reg_data[instr2_rs1];
	assign instr2_rs2_data = (instr2_rs2 == 5'd0) ? 32'd0 : reg_data[instr2_rs2];
endmodule: Register_File





