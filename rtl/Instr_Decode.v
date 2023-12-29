
`include "define_module.v"
module Instr_Decode(
	// Input signals
	input wire 		clk,
	input wire 		rst_n,
	input wire [63:0]	fetch_instr_pc,
	input wire 		rs1_valid,
	input wire		rs2_valid,
	input wire [31:0]	rs1_data,
	input wire [31:0]	rs2_data,
	input wire [2:0]	au_free,
	input wire [2:0]	mul_free,
	input wire 		lsu_free,
	// Output signals	
	output wire 		busy,
	output wire [4:0]	rs1,
	output wire [4:0]	rs2,
	output reg 		jump,
	output reg		jump_wait,
	output reg 		jump_accept,
	output reg [31:0]	jump_addr,
	output reg [16:0]	rd_rs1_rs2,
	output reg [7:0]	execute_type,
	output reg [31:0]	imm_extend
);

	

	wire [31:0] instr = fetch_instr_pc >> 32;
	wire [31:0] pc = fetch_instr_pc;
	wire [6:0] opcode = instr[6:0];
	wire [4:0] rd = instr[11:7];
	wire [6:0] funct7 = instr[31:25];
	wire [2:0] funct3 = instr[14:12];
	reg [31:0] imm;
	reg au_instr, mul_instr, lsu_instr;
	reg [4:0] execute_op;
	reg [31:0] before_pc;
	// signal for jump no condition
	wire jal = (opcode == 7'b1101111) ? 1'b1 : 1'b0;
	wire jalr = (opcode == 7'b1100111) ? 1'b1 : 1'b0;
	wire jal_addr = pc + { {12{instr[31]}} , instr[19:12] , instr[20] , instr[30:21] , 1'b0 };
	wire jalr_addr = (rs1_valid) ? rs1_data + { {20{instr[31]}} , instr[31:20] } : 32'dz;
       	wire jncond_wait = jalr & !rs1_valid;	

	// signal for jump condition
	wire jcond = (opcode == 7'b1100011) ? 1'b1 : 1'b0;
	wire [31:0] jcond_addr = (rs1_valid & rs2_valid) ? pc + { {20{instr[31]}} , instr[7] , instr[30:25] , instr[11:8] , {1{1'b0}} } : 32'dz;
	wire jcond_wait = jcond & ( !rs1_valid | !rs2_valid );
	reg jcond_accept;

	

	always @(opcode) begin
		case(opcode) 
			7'b0000011: imm <= { {20{instr[31]}} , instr[31:20] }; // imm for LW
			7'b0100011: imm <= { {20{instr[31]}} , instr[31:25] , instr[11:7] }; // imm for SW
			7'b0110111: imm <= { instr[31:12], {12'b000000000000} }; // imm for LUI
			7'b0010011:
				begin
					if((instr[14:12] == 3'b001) | (instr[14:12] == 3'b101)) 
						imm <= { {27'b0} , instr[24:20] }; // imm for SLLI/SRLI/SRLAI
					else 
						imm <= { {20{instr[31]}} , instr[31:20] }; // imm for ADDI/ANDI/ORI
				end
			7'b0010111: imm <= {instr[31:12], 12'd0}; // imm for AUIPC
			default: imm <= 32'bx;
		endcase
	end


	always @(instr) begin
		case(opcode)
			7'b0110011: begin // R-type
				lsu_instr = 1'b0;
				case(funct7)
					7'b0000000: begin
						au_instr = 1'b1;
						mul_instr = 1'b0;
						case(funct3) 
							3'b000: execute_op = 5'd0; // add
							3'b001: execute_op = 5'd9; // sll
							3'b010: execute_op = 5'd15;// slt
							3'b011: execute_op = 5'd17;// sltu
							3'b100: execute_op = 5'd7; // xor
							3'b101: execute_op = 5'd11;// srl
							3'b110: execute_op = 5'd5; // or
							3'b111: execute_op = 5'd3; // and
						endcase
					end
					7'b0100000: begin
						au_instr = 1'b1;
						mul_instr = 1'b0;
						case(funct3)
							3'b000: execute_op = 5'd2; // sub
							3'b101: execute_op = 5'd13;// sra
						endcase
					end
					7'b0000001: begin // M extention
						au_instr = 1'b0;
						mul_instr = 1'b1;
						execute_op = { 2'b00, funct3 };
						// 0: mul
						// 1: mulh
						// 2: mulsu
						// 3: mulu
						// 4: div
						// 5: divu
						// 6: rem
						// 7: remu
					end
				endcase
			end
			7'b0010011: begin // I-type
				au_instr = 1'b1;
				mul_instr = 1'b0;
				lsu_instr = 1'b0;
				case(funct3)
					3'b000: execute_op = 5'd1; // addi
					3'b010: execute_op = 5'd16;// slti
					3'b011: execute_op = 5'd18;// sltiu
					3'b100: execute_op = 5'd8; // xori
					3'b110: execute_op = 5'd6; // ori
					3'b111: execute_op = 5'd4; // andi
					3'b001: execute_op = 5'd10;// slli
					3'b101:
						case(funct7)
							7'b0000000: execute_op = 5'd12;// srli
							7'b0100000: execute_op = 5'd14;// srai
							default: execute_op = 5'dz;
						endcase
				endcase
			end
			7'b0000011: begin // Load-type
				au_instr = 1'b0;
				mul_instr = 1'b0;
				lsu_instr = 1'b1;
				case(funct3)
					3'b000: execute_op = 5'd0;// lb
					3'b001: execute_op = 5'd1;// lh
					3'b010: execute_op = 5'd2;// lw
					3'b100: execute_op = 5'd3;// lbu
					3'b101: execute_op = 5'd4;// lhu
				endcase
			end
			7'b0100011: begin // Store-type
				au_instr = 1'b0;
				mul_instr = 1'b0;
				lsu_instr = 1'b1;
				case(funct3)
					3'b000: execute_op = 5'd5;// sb
					3'b001: execute_op = 5'd6;// sh
					default: execute_op = 5'd7;// sw
				endcase
			end
			7'b0110111: begin // Lui
				au_instr = 1'b1;
				mul_instr = 1'b0;
				lsu_instr = 1'b0;
				execute_op = 5'd19;
			end
			7'b0010111: begin // auipc
				au_instr = 1'b1;
				mul_instr = 1'b0;
				lsu_instr = 1'b0;
				execute_op = 5'd20;
			end
			7'b1100011: begin // branch
				au_instr = 1'b0;
				mul_instr = 1'b0;
				lsu_instr = 1'b0;
				case(funct3) 
					3'b000: jcond_accept = (jcond_wait) & (rs1_data == rs2_data); // beq
					3'b001: jcond_accept = (jcond_wait) & (rs1_data != rs2_data); // bne
					3'b100: jcond_accept = (jcond_wait) & (rs1_data < rs2_data); // blt
					3'b101: jcond_accept = (jcond_wait) & (rs1_data >= rs2_data); // bge
					3'b110: jcond_accept = (jcond_wait) & (rs1_data < rs2_data); // bltu
					3'b111: jcond_accept = (jcond_wait) & (rs1_data >= rs2_data); // bgeu
					default: jcond_accept = 1'b0;
				endcase
			end
			default: begin
				au_instr = 1'b0;
				mul_instr = 1'b0;
				lsu_instr = 1'b0;
			end
		endcase

	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			rd_rs1_rs2 <= 17'd0;
			execute_type <= 8'dx;
			imm_extend <= 32'd0;
			jump <= 1'b0;
			jump_wait <= 1'b0;
			jump_accept <= 1'b0;
			jump_addr <= 32'd0;
			before_pc <= 32'd0;
		end
		else if(busy) begin
			rd_rs1_rs2 <= rd_rs1_rs2;
			execute_type <= execute_type;
			imm_extend <= imm_extend;
			jump <= jump;
			jump_accept <= jump_accept;
			jump_wait <= jump_wait;
			jump_addr <= jump_addr;
			before_pc <= before_pc;
		end
		else begin
			rd_rs1_rs2 <= { rd, rs1_valid, rs1, rs2_valid, rs2 };
			execute_type <= {au_instr, mul_instr, lsu_instr, execute_op};
			imm_extend <= imm;
			jump <= rst_n & (jal | jalr | jcond);
			jump_wait <= jncond_wait | jcond_wait;
			jump_accept <= !jncond_wait | jcond_accept;
			jump_addr <= jcond ? jcond_addr : (jal) ? jal_addr : jalr_addr;
			before_pc <= jcond ? jcond_addr : (jal) ? jal_addr : jalr ? jalr_addr : before_pc;
		end
	end

	wire instr_valid = pc >= before_pc;
	assign rs1 = (instr_valid) ?  instr[19:15] : 5'dz;
	assign rs2 = (instr_valid) ? instr[24:20] : 5'dz;
	assign busy = (au_instr & (au_free == 3'd0)) | (mul_instr & (mul_free == 3'd0)) | (lsu_instr & (lsu_free == 1'b0));
	//assign jump = rst_n & (jal | jalr | jcond);
	//assign jump_wait = jncond_wait | jcond_wait;
	//assign jump_accept = !jncond_wait | jcond_accept;
	//assign jump_addr = jcond ? jcond_addr : (jal) ? jal_addr : jalr_addr;
endmodule



