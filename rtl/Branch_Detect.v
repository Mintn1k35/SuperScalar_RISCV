
module Branch_Detect(
	// Input signals
	input wire [31:0]	instr,
	input wire [31:0] 	imm_extend,
	input wire [31:0]	fetch_pc,
	input wire [31:0]	rs1_data,
	input wire [31:0]	rs2_data,
	// Output signals	
	output reg			jump,
	output reg			jaccept,
	output reg [31:0]  	jaddr
);

	wire [6:0] opcode = instr[6:0];
	wire [2:0] funct3 = instr[14:12];

	always @(*) begin
		case(opcode)
			7'b1100011: begin
				jump = 1'b1;
				jaddr = fetch_pc + imm_extend;
				case(funct3)
					3'b000: jaccept = rs1_data == rs2_data; // beq
					3'b001: jaccept = rs1_data != rs2_data; // bne
					3'b100: jaccept = rs1_data < rs2_data;// blt
					3'b101: jaccept = rs1_data >= rs2_data; // bge
					3'b110: jaccept = rs1_data < rs2_data; // bltu
					3'b111: jaccept = rs1_data >= rs2_data; // bgeu
				endcase
			end
			7'b1100111: begin // jalr
				jump = 1'b1;
				jaccept = 1'b1;
				jaddr = rs1_data + imm_extend;
			end
			default: begin
				jump = 1'b0;
				jaccept = 1'b0;
				jaddr = 32'd0;
			end
		endcase
	end
endmodule: Branch_Detect





