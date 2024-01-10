
module AU(
	// Input signals
	input wire [31:0]	operand1,
	input wire [31:0]	operand2,
	input wire [4:0]	execute_type,
	// Output signals	
	output reg [31:0]	result
);


	always @(*) begin
		case(execute_type)
			5'd0: begin // add
				result <= operand1 + operand2;
			end
			5'd1: begin // addi
				result <= operand1 + operand2;
			end
			5'd2: begin // sub
				result <= operand1 - operand2;
			end
			5'd3: begin // and
				result <= operand1 & operand2;
			end
			5'd4: begin // andi
				result <= operand1 & operand2;
			end
			5'd5: begin // or
				result <= operand1 | operand2;
			end
			5'd6: begin // ori
				result <= operand1 | operand2;
			end
			5'd7: begin // xor
				result <= operand1 ^ operand2;
			end
			5'd8: begin // xori
				result <= operand1 ^ operand2;
			end
			5'd9: begin // sll
				result <= operand1 << operand2;
			end
			5'd10: begin // slli
				result <= operand1 << operand2;
			end
			5'd11: begin // srl
				result <= operand1 >> operand2;
			end
			5'd12: begin //srli
				
				result <= operand1 >> operand2;
			end
			5'd13: begin //sra
				result <= $signed(operand1) >>> operand2;
			end
			5'd14: begin // srai
				
				result <= $signed(operand1) >>> operand2;
			end
			5'd15: begin // slt
				result <= ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
			end
			5'd16: begin // slti
				
				result <= (operand1 < operand2) ? 32'd1 : 32'd0;
			end
			5'd17: begin // sltu
				result <= (operand1 < operand2) ? 32'd1 : 32'd0;
			end
			5'd18: begin // sltiu
				
				result <= (operand1 < operand2) ? 32'd1 : 32'd0;
			end
			5'd19: begin // lui
				result <= operand1;
			end
			5'd20: begin // auipc
				result <= operand1 + operand2;
			end
			default: begin
				result <= 32'd0;
			end
		endcase
	end
endmodule: AU
