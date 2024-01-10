
module Select_Data_WB(
	// Input signals
	input wire [31:0]	au_result,
	input wire [31:0]	mul_result,
	input wire [31:0]	lsu_result,
	input wire [2:0]	select,
	// Output signals	
	output reg [31:0]	result
);

	always @(*) begin
		case(select)
			3'b100: result = au_result; // au_select
			3'b010: result = mul_result; // mul select
			3'b001: result = lsu_result; // lsu select
			default: result = 32'd0;
		endcase
	end
endmodule: Select_Data_WB





