
module Schedule(
	// Input signals
	input wire [127:0]	fetch_data,
	// Output signals	
	output reg [127:0]	instr1,
	output reg [127:0]	instr2,
	output reg			write1,
	output reg 			write2,
	output reg			jal,
	output reg	[31:0]	jal_addr
);

	wire [31:0]	data1_pc = fetch_data;
	wire [31:0] data1_instr = fetch_data >> 32;
	wire [4:0] data1_rs1 = data1_instr[19:15];
	wire [4:0] data1_rs2 = data1_instr[24:20];
	wire [4:0] data1_rd = data1_instr[11:7];


	wire [31:0]	data2_pc = fetch_data >> 64;
	wire [31:0]	data2_instr = fetch_data >> 96;
	wire [4:0] data2_rs1 = data2_instr[19:15];
	wire [4:0] data2_rs2 = data2_instr[24:20];
	wire [4:0] data2_rd = data2_instr[11:7];

	wire jal1 = (data1_instr[6:0] == 7'b1101111) ? 1'b1 : 1'b0;
	wire [31:0] jal1_addr = data1_pc + { {12{data1_instr[31]}} , data1_instr[19:12] , data1_instr[20] , data1_instr[30:21] , 1'b0 }; 
	wire jal2 = (data2_instr[6:0] == 7'b1101111) ? 1'b1 : 1'b0;  
	wire [31:0] jal2_addr = data2_pc + { {12{data2_instr[31]}} , data2_instr[19:12] , data2_instr[20] , data2_instr[30:21] , 1'b0 };
	

	wire ls1 = ((data1_instr[6:0] == 7'b0000011) | (data1_instr[6:0] == 7'b0100011)) ? 1'b1 : 1'b0;

	wire ls2 = ((data2_instr[6:0] == 7'b0000011) | (data2_instr[6:0] == 7'b0100011)) ? 1'b1 : 1'b0;

	always @(*) begin
		if(jal1 & jal2) begin
			jal_addr = jal1_addr;
			write1 = 1'b0;
			write2 = 1'b0;
			jal = 1'b1;
			instr1 = 128'd0;
			instr2 = 128'd0;
		end
		else if(jal1) begin
			jal_addr = jal1_addr;
			write1 = 1'b0;
			write2 = 1'b0;
			jal = 1'b1;
			instr1 = 128'd0;
			instr2 = 128'd0;
		end
		else if(jal2) begin
			jal_addr = jal2_addr;
			write1 = 1'b1;
			write2 = 1'b0;
			jal = 1'b1;
			instr1 = {64'd0, data1_instr, data1_pc};
			instr2 = 128'd0;
		end
		else if(ls1 & ls2) begin
			jal = 1'b0;
			jal_addr = 32'd0;
			write1 = 1'b0;
			write2 = 1'b1;
			instr1 = {64'd0, data1_instr, data1_pc};
			instr2 = {64'd0, data2_instr, data2_pc};
		end
		else begin
			jal = 1'b0;
			jal_addr = 32'd0;
			if(((data2_rs1 == data1_rd) && (data2_rs1 != 5'd0)) | ((data2_rs2 == data1_rd) && (data2_rs2 != 5'd0))) begin
				write1 = 1'b0;
				write2 = 1'b1;
				instr1 = {64'd0, data1_instr, data1_pc};
				instr2 = {64'd0, data2_instr, data2_pc};
			end
			else begin
				write1 = 1'b1;
				write2 = 1'b0;
				instr1 = {data2_instr, data2_pc, data1_instr, data1_pc};
				instr2 = 127'd0;
			end
		end
	end

endmodule: Schedule 
// Chua detect het cac truong hop toi uu





