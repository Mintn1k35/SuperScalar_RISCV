
module Control(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			fifo_full,
	input wire			buffer_full,
	input wire			jal_schedule,
	input wire [31:0]	jal_addr,
	input wire			instr1_jump,
	input wire			instr1_jump_accept,
	input wire [31:0]	instr1_jump_addr,
	input wire			instr2_jump,
	input wire			instr2_jump_accept,
	input wire [31:0]	instr2_jump_addr,
	input wire [4:0]	instr1_rs1_decode,
	input wire [4:0]	instr1_rs2_decode,
	input wire [4:0]	instr2_rs1_decode,
	input wire [4:0]	instr2_rs2_decode,
	input wire [4:0]	rd1_execute,
	input wire [4:0]	rd2_execute,
	input wire [4:0]	rd1_wb,
	input wire [4:0]	rd2_wb,
	input wire [2:0]	au_mul_lsu1,
	input wire [2:0]	au_mul_lsu2,
	input wire			lsu_work, 
	input wire			lsu_done,
	// Output signals	
	output reg			stop_fetch,
	output reg			jump,
	output reg			jump_accept,
	output reg [31:0]	jump_addr,
	output reg			fifo_rst,
	output reg			fifo_stall,
	output reg			buffer_rst,
	output reg 			buffer_stall,
	output reg			transfer_decode1_rst,
	output reg			transfer_decode2_rst,
	output reg			transfer_execute_rst,
	output reg [2:0]	decode1_hazard_select1,
	output reg [2:0]	decode1_hazard_select2,
	output reg [2:0]	decode2_hazard_select1,
	output reg [2:0]	decode2_hazard_select2
);


	// Signal for Cache_Controller
	reg [31:0] jump_addr_tmp;
	wire jump_tmp = jal_schedule | instr1_jump | instr2_jump;
	wire jump_accept_tmp = jal_schedule | instr1_jump_accept | instr2_jump_accept;
	always @(*) begin
		if(fifo_full) begin
			stop_fetch = 1'b1;
		end
		else stop_fetch = 1'b0;

		if(jump_tmp) begin
			if(instr1_jump) begin
				if(instr1_jump_accept) begin
					jump_addr_tmp = instr1_jump_addr;
				end
				else begin
					jump_addr_tmp = 32'd0;
				end 
			end
			else if(instr2_jump) begin
				if(instr2_jump_accept) jump_addr_tmp = instr2_jump_addr;
				else jump_addr_tmp = 32'd0;
			end
			else if(jal_schedule) begin
				jump_addr_tmp = jal_addr;
			end
		end
	end

	/// Signal for Fifo
	reg fifo_rst_tmp, fifo_stall_tmp;
	always @(*) begin
		if(!rst_n) fifo_rst_tmp = 1'b0;
		else begin
			if(instr1_jump & instr1_jump_accept) fifo_rst_tmp = 1'b0;
			else if(instr2_jump & instr2_jump_accept) fifo_rst_tmp = 1'b0;
			else if(jal_schedule) fifo_rst_tmp = 1'b0;
			else fifo_rst_tmp = 1'b1;
		end

		if(buffer_full) begin
			fifo_stall_tmp = 1'b1;
		end
		else fifo_stall_tmp = 1'b0;
	end


	// Signal for Buffer_Execute
	reg buffer_rst_tmp, buffer_stall_tmp;
	always @(*) begin
		if(!rst_n) buffer_rst_tmp = 1'b0;
		else begin
			if(instr1_jump & instr1_jump_accept) buffer_rst_tmp = 1'b0;
			else if(instr2_jump & instr2_jump_accept) buffer_rst_tmp = 1'b0;
			else buffer_rst_tmp = 1'b1;
		end

		if(lsu_work) begin
			if(!lsu_done) buffer_stall = 1'b1;
			else buffer_stall_tmp = 1'b0;
		end
		else buffer_stall_tmp = 1'b0;
	end

	// Signal for Transfer_Decode_Execute
	reg transfer_decode1_rst_tmp, transfer_decode2_rst_tmp;
	always @(*) begin
		if(!rst_n) begin
			transfer_decode1_rst_tmp = 1'b0;
			transfer_decode2_rst_tmp = 1'b0;
		end
		else begin
			if(lsu_work && !lsu_done) begin
				transfer_decode1_rst_tmp = 1'b0;
				transfer_decode2_rst_tmp = 1'b0;
			end
			else begin
				if(instr1_jump) transfer_decode1_rst_tmp = 1'b0;
				else transfer_decode1_rst_tmp = 1'b1;

				if(instr2_jump) transfer_decode2_rst_tmp = 1'b0;
				else transfer_decode2_rst_tmp = 1'b1;
			end
		end
	end

	// Signal for Transfer_Execute_WB
	reg transfer_execute_rst_tmp;
	always @(*) begin
		if(!rst_n) begin
			transfer_execute_rst_tmp = 1'b0;
		end
		else begin
			if(lsu_work & !lsu_done) transfer_execute_rst_tmp = 1'b0;
			else transfer_execute_rst_tmp = 1'b1;
		end
	end


	// Detect Data Hazard for Instr_Decode1
	always @(*) begin
		// Detact Hazard_select1
		if(instr1_rs1_decode == rd1_wb) begin
			decode1_hazard_select1 = 3'd6;
		end
		else if(instr1_rs1_decode == rd2_wb) begin
			decode1_hazard_select1 = 3'd7;
		end
		else if(instr1_rs1_decode == rd1_execute) begin
			if(au_mul_lsu1[0]) begin
				decode1_hazard_select1 = 3'd5;
			end
			else if(au_mul_lsu1[1]) begin
				decode1_hazard_select1 = 3'd3;
			end
			else if(au_mul_lsu1[2]) begin
				decode1_hazard_select1 = 3'd1;
			end
			else decode1_hazard_select1 = 3'd0;
		end
		else if(instr1_rs1_decode == rd2_execute) begin
			if(au_mul_lsu2[0]) begin
				decode1_hazard_select1 = 3'd5;
			end
			else if(au_mul_lsu2[1]) begin
				decode1_hazard_select1 = 3'd4;
			end
			else if(au_mul_lsu2[2]) begin
				decode1_hazard_select1 = 3'd2;
			end
			else decode1_hazard_select1 = 3'd0;
		end
		else decode1_hazard_select1 = 3'd0;
	
	// Detect hazard_select2
		if(instr1_rs2_decode == rd1_wb) begin
			decode1_hazard_select2 = 3'd6;
		end
		else if(instr1_rs2_decode == rd2_wb) begin
			decode1_hazard_select2 = 3'd7;
		end
		else if(instr1_rs2_decode == rd1_execute) begin
			if(au_mul_lsu1[0]) begin
				decode1_hazard_select2 = 3'd5;
			end
			else if(au_mul_lsu1[1]) begin
				decode1_hazard_select2 = 3'd3;
			end
			else if(au_mul_lsu1[2]) begin
				decode1_hazard_select2 = 3'd1;
			end
			else decode1_hazard_select2 = 3'd0;
		end
		else if(instr1_rs2_decode == rd2_execute) begin
			if(au_mul_lsu2[0]) begin
				decode1_hazard_select2 = 3'd5;
			end
			else if(au_mul_lsu2[1]) begin
				decode1_hazard_select2 = 3'd4;
			end
			else if(au_mul_lsu2[2]) begin
				decode1_hazard_select2 = 3'd2;
			end
			else decode1_hazard_select2 = 3'd0;
		end
		else decode1_hazard_select2 = 3'd0;
	end

	// Detect For Instr_Decode2
	always @(*) begin
		// Detact Hazard_select1
		if(instr2_rs1_decode == rd1_wb) begin
			decode2_hazard_select1 = 3'd6;
		end
		else if(instr2_rs1_decode == rd2_wb) begin
			decode2_hazard_select1 = 3'd7;
		end
		else if(instr2_rs1_decode == rd1_execute) begin
			if(au_mul_lsu1[0]) begin
				decode2_hazard_select1 = 3'd5;
			end
			else if(au_mul_lsu1[1]) begin
				decode2_hazard_select1 = 3'd3;
			end
			else if(au_mul_lsu1[2]) begin
				decode2_hazard_select1 = 3'd1;
			end
			else decode2_hazard_select1 = 3'd0;
		end
		else if(instr2_rs1_decode == rd2_execute) begin
			if(au_mul_lsu2[0]) begin
				decode2_hazard_select1 = 3'd5;
			end
			else if(au_mul_lsu2[1]) begin
				decode2_hazard_select1 = 3'd4;
			end
			else if(au_mul_lsu2[2]) begin
				decode2_hazard_select1 = 3'd2;
			end
			else decode2_hazard_select1 = 3'd0;
		end
		else decode2_hazard_select1 = 3'd0;
	
	// Detect hazard_select2
		if(instr2_rs2_decode == rd1_wb) begin
			decode2_hazard_select2 = 3'd6;
		end
		else if(instr2_rs2_decode == rd2_wb) begin
			decode2_hazard_select2 = 3'd7;
		end
		else if(instr2_rs2_decode == rd1_execute) begin
			if(au_mul_lsu1[0]) begin
				decode2_hazard_select2 = 3'd5;
			end
			else if(au_mul_lsu1[1]) begin
				decode2_hazard_select2 = 3'd3;
			end
			else if(au_mul_lsu1[2]) begin
				decode2_hazard_select2 = 3'd1;
			end
			else decode2_hazard_select2 = 3'd0;
		end
		else if(instr2_rs2_decode == rd2_execute) begin
			if(au_mul_lsu2[0]) begin
				decode2_hazard_select2 = 3'd5;
			end
			else if(au_mul_lsu2[1]) begin
				decode2_hazard_select2 = 3'd4;
			end
			else if(au_mul_lsu2[2]) begin
				decode2_hazard_select2 = 3'd2;
			end
			else decode2_hazard_select2 = 3'd0;
		end
		else decode2_hazard_select2 = 3'd0;
	end


	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			jump <= 1'b0;
			jump_accept <= 1'b0;
			jump_addr <= 32'd0;
			fifo_rst <= 1'b0;
			fifo_stall <= 1'b0;
			buffer_rst <= 1'b0;
			buffer_stall <= 1'b0;
			transfer_decode1_rst <= 1'b0;
			transfer_decode2_rst <= 1'b0;
			transfer_execute_rst <= 1'b0;
		end
		else begin
			jump <= jump_tmp;
			jump_accept <= jump_accept_tmp;
			jump_addr <= jump_addr_tmp;
			fifo_rst <= fifo_rst_tmp;
			fifo_stall <= fifo_stall_tmp;
			buffer_rst <= buffer_rst_tmp;
			buffer_stall <= buffer_stall_tmp;
			transfer_decode1_rst <= transfer_decode1_rst_tmp;
			transfer_decode2_rst <= transfer_decode2_rst_tmp;
			transfer_execute_rst <= transfer_execute_rst_tmp;
		end
	end

endmodule: Control





