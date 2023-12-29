
module Register_Status(
	// Input signals
	input wire 		clk,
	input wire		rst_n,
	input wire [4:0]	rs1,
	input wire [4:0]	rs2,
	input wire [4:0]	rd,

	// Output signals	
	output wire		rs1_valid,
	output wire		rs2_valid,
	output wire [31:0]	rs1_data,
	output wire [31:0]	rs2_data,
);

	reg [31:0] register[31:0];
	reg [31:0] reg_status;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			register[0] <= 32'd0;
			register[1] <= 32'd0;
			register[2] <= 32'd0;
			register[3] <= 32'd0;
			register[4] <= 32'd0;
			register[5] <= 32'd0;
			register[6] <= 32'd0;
			register[7] <= 32'd0;
			register[8] <= 32'd0;
			register[9] <= 32'd0;
			register[10] <= 32'd0;
			register[11] <= 32'd0;
			register[12] <= 32'd0;
			register[13] <= 32'd0;
			register[14] <= 32'd0;
			register[15] <= 32'd0;
			register[16] <= 32'd0;
			register[17] <= 32'd0;
			register[18] <= 32'd0;
			register[19] <= 32'd0;
			register[20] <= 32'd0;
			register[21] <= 32'd0;
			register[22] <= 32'd0;
			register[23] <= 32'd0;
			register[24] <= 32'd0;
			register[25] <= 32'd0;
			register[26] <= 32'd0;
			register[27] <= 32'd0;
			register[28] <= 32'd0;
			register[29] <= 32'd0;
			register[30] <= 32'd0;
			register[31] <= 32'd0;
			reg_status <= 32'd1;
		end
	end

endmodule





