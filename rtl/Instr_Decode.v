`include "Imm_Extend.v"
`include "Branch_Detect.v"
module Instr_Decode(
	// Input signals
	input wire [63:0]	fetch_instr_pc,
	input wire [31:0]	data1_regfile,
	input wire [31:0]	data2_regfile,
	input wire [31:0]	data1_au,
	input wire [31:0]	data2_au,
	input wire [31:0]	data1_mul,
	input wire [31:0]	data2_mul,
	input wire [31:0]	data_lsu,
	input wire [31:0]	data1_wb,
	input wire [31:0]	data2_wb,
	input wire [2:0]	hazard_select1,
	input wire [2:0]	hazard_select2,
	// Output signals	
	output reg [31:0]	operand1_data,
	output reg [31:0]	operand2_data,
	output reg			reg_write,
	output reg [4:0]	execute_type,
	output reg			au_type,
	output reg			mul_type,
	output reg			lsu_type,
	output wire			jump,
	output wire			jaccept,
	output wire [31:0]	jaddr
);
	wire [31:0] instr = fetch_instr_pc >> 32;
	wire [6:0]	opcode = instr[6:0];
	wire [6:0]	funct7 = instr[31:25];
	wire [2:0]	funct3 = instr[14:12];
	wire [31:0] imm_extend;
	wire [31:0]	instr_pc = fetch_instr_pc;

	Branch_Detect Branch_Detect_Instance(instr, imm_extend, instr_pc, operand1_data, operand2_data, jump, jaccept, jaddr);
	Imm_Extend Imm_Extend_Instance(instr, imm_extend);

	always @(*) begin
		case(opcode)
			7'b0110011: begin // R-type
				reg_write = 1'b1;
				au_type = 1'b1;
				mul_type = 1'b0;
				lsu_type = 1'b0;
				case(hazard_select1)
					3'd0: begin // rs1 = regfile
						operand1_data = data1_regfile;
					end
					3'd1: begin // rs1 = rd1_au_excute
						operand1_data = data1_au;
					end
					3'd2: begin // rs1 = rd2_au_execute
						operand1_data = data2_au;
					end
					3'd3: begin // rs1 = rd1_mul_execute
						operand1_data = data1_mul;
					end
					3'd4: begin // rs1 = rd2_mul_execute
						operand1_data = data2_mul;
					end
					3'd5: begin // rs1 = rd_lsu_excute
						operand1_data = data_lsu;
					end
					3'd6: begin // rs1 = rd1_wb
						operand1_data = data1_wb;
					end
					3'd7: begin // rs1 = rd2_wb
						operand1_data = data2_wb;
					end
				endcase
				case(hazard_select2)
					3'd0: begin // rs2 = regfile
						operand2_data = data1_regfile;
					end
					3'd1: begin // rs2 = rd1_au_excute
						operand2_data = data1_au;
					end
					3'd2: begin // rs2 = rd2_au_execute
						operand2_data = data2_au;
					end
					3'd3: begin // rs2 = rd1_mul_execute
						operand2_data = data1_mul;
					end
					3'd4: begin // rs2 = rd2_mul_execute
						operand2_data = data2_mul;
					end
					3'd5: begin // rs2 = rd_lsu_excute
						operand2_data = data_lsu;
					end
					3'd6: begin // rs2 = rd1_wb
						operand2_data = data1_wb;
					end
					3'd7: begin // rs2 = rd2_wb
						operand2_data = data2_wb;
					end
				endcase
				case(funct7)
					7'b0000000: begin
						case(funct3)
							3'b000: execute_type = 5'd0; // add
							3'b001: execute_type = 5'd9; // sll
							3'b010: execute_type = 5'd15; // slt
							3'b011: execute_type = 5'd17; // sltu
							3'b100: execute_type = 5'd7; // xor
							3'b101: execute_type = 5'd11; // srl
							3'b110: execute_type = 5'd5; // or
							3'b111: execute_type = 5'd3; // and
							default: execute_type = 5'd0;
						endcase
					end
					7'b0100000: begin // sra/sub
						case(funct3)
							3'b000: execute_type = 5'd2; // sub
							3'b101: execute_type = 5'd13; // sra
							default: execute_type = 5'd0;
						endcase
					end
				endcase
			end
			7'b0010011: begin // I-type
				reg_write = 1'b1;
				au_type = 1'b1;
				mul_type = 1'b0;
				lsu_type = 1'b0;
				case(hazard_select1)
					3'd0: begin // rs1 = regfile
						operand1_data = data1_regfile;
					end
					3'd1: begin // rs1 = rd1_au_excute
						operand1_data = data1_au;
					end
					3'd2: begin // rs1 = rd2_au_execute
						operand1_data = data2_au;
					end
					3'd3: begin // rs1 = rd1_mul_execute
						operand1_data = data1_mul;
					end
					3'd4: begin // rs1 = rd2_mul_execute
						operand1_data = data2_mul;
					end
					3'd5: begin // rs1 = rd_lsu_excute
						operand1_data = data_lsu;
					end
					3'd6: begin // rs1 = rd1_wb
						operand1_data = data1_wb;
					end
					3'd7: begin // rs1 = rd2_wb
						operand1_data = data2_wb;
					end
				endcase
				operand2_data = imm_extend;
				case(funct3)
					3'b000: execute_type = 5'd1; // addi
					3'b010: execute_type = 5'd16; // slti
					3'b011: execute_type = 5'd18; // sltiu
					3'b100: execute_type = 5'd8; // xori
					3'b110: execute_type = 5'd6; // ori
					3'b111: execute_type = 5'd4; // andi
					3'b001: execute_type = 5'd10; // slli
					3'b101: begin
						case(funct7)
							7'b0000000: execute_type = 5'd12; // srli
							7'b0100000: execute_type = 5'd14;
							default: execute_type = 5'd0;
						endcase
					end
					default: execute_type = 5'd0;
				endcase
			end
			7'b0000011: begin // Load-type
				reg_write = 1'b1;
				au_type = 1'b0;
				mul_type = 1'b0;
				lsu_type = 1'b1;
				case(hazard_select1)
					3'd0: begin // rs1 = regfile
						operand1_data = data1_regfile;
					end
					3'd1: begin // rs1 = rd1_au_excute
						operand1_data = data1_au;
					end
					3'd2: begin // rs1 = rd2_au_execute
						operand1_data = data2_au;
					end
					3'd3: begin // rs1 = rd1_mul_execute
						operand1_data = data1_mul;
					end
					3'd4: begin // rs1 = rd2_mul_execute
						operand1_data = data2_mul;
					end
					3'd5: begin // rs1 = rd_lsu_excute
						operand1_data = data_lsu;
					end
					3'd6: begin // rs1 = rd1_wb
						operand1_data = data1_wb;
					end
					3'd7: begin // rs1 = rd2_wb
						operand1_data = data2_wb;
					end
				endcase
				operand2_data = imm_extend;
				case(funct3)
					3'b000: execute_type = 5'd0; // lb
					3'b001: execute_type = 5'd1; // lh
					3'b010: execute_type = 5'd2; // lw
					3'b100: execute_type = 5'd3; // lbu
					3'b101: execute_type = 5'd4; // lhu
				endcase
			end
			7'b0100011: begin //Store-Type
				reg_write = 1'b0;
				au_type = 1'b0;
				mul_type = 1'b0;
				lsu_type = 1'b1;
				case(hazard_select1)
					3'd0: begin // rs1 = regfile
						operand1_data = data1_regfile;
					end
					3'd1: begin // rs1 = rd1_au_excute
						operand1_data = data1_au;
					end
					3'd2: begin // rs1 = rd2_au_execute
						operand1_data = data2_au;
					end
					3'd3: begin // rs1 = rd1_mul_execute
						operand1_data = data1_mul;
					end
					3'd4: begin // rs1 = rd2_mul_execute
						operand1_data = data2_mul;
					end
					3'd5: begin // rs1 = rd_lsu_excute
						operand1_data = data_lsu;
					end
					3'd6: begin // rs1 = rd1_wb
						operand1_data = data1_wb;
					end
					3'd7: begin // rs1 = rd2_wb
						operand1_data = data2_wb;
					end
				endcase
				operand2_data = imm_extend;
				case(funct3)
					3'b000: execute_type = 5'd5; // sb
					3'b001: execute_type = 5'd6; // sh
					default: execute_type = 5'd7; // sw
				endcase
			end
			7'b0110111: begin // lui
				reg_write = 1'b1;
				au_type = 1'b1;
				mul_type = 1'b0;
				lsu_type = 1'b0;
				execute_type = 5'd19;
				operand1_data = imm_extend;
				operand2_data = 32'd0;
			end
			7'b0010111: begin // auipc
				reg_write = 1'b1;
				au_type = 1'b1;
				mul_type = 1'b0;
				lsu_type = 1'b0;
				execute_type = 5'd20;
				operand1_data = instr_pc;
				operand2_data = imm_extend;
			end
			default: begin
				reg_write = 1'b0;
				au_type = 1'b0;
				mul_type = 1'b0;
				lsu_type = 1'b0;
				execute_type = 5'd0;
				operand1_data = 32'd0;
				operand2_data = 32'd0;
			end
		endcase
	end

endmodule: Instr_Decode





