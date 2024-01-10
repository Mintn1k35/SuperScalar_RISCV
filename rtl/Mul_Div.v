
module Mul_Div(
	// Input signals
	input wire [31:0]	operand1,
	input wire [31:0]	operand2,
	input wire [4:0]	execute_type,
	// Output signals	
	output reg [31:0]	result
);

	reg [63:0] result_temp;

	always @(*) begin
		case(execute_type)
			5'd0: begin // mul
				result_temp = operand1 * operand2;
				result = result_temp[31:0];
			end
			5'd1: begin // mulh
				result_temp = operand1 * operand2;
				result = result_temp[63:32];
			end
			5'd2: begin // div
				result = operand1 / operand2;
			end
			5'd3: begin // rem
				result = operand1 % operand2;
			end
		endcase
	end
endmodule: Mul_Div





