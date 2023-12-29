module Mux2to1(
	input wire [31:0] 	in1,
	input wire [31:0] 	in2,
	input wire 	       	select,
	output wire [31:0] out
);

	assign out = (select) ? in2 : in1;
endmodule

module Mux3to1(
	input wire [31:0] 	in1,
	input wire [31:0] 	in2,
	input wire [31:0]	in3,
	input wire [1:0]	select,
	output reg [31:0]	out
);

	always @(*) begin
		case(select)
			2'b00: out <= in1;
			2'b01: out <= in2;
			2'b10: out <= in3;
			default: out <= 32'dz;
		endcase
	end
endmodule

module Mux4to1(
	input wire [31:0] 	in1,
	input wire [31:0]	in2,
	input wire [31:0]	in3,
	inout wire [31:0]	in4,
	input wire [1:0]	select,
	output reg [31:0]	out
);

	always @(*) begin
		case(select)
			2'b00: out <= in1;
			2'b01: out <= in2;
			2'b10: out <= in3;
			2'b11: out <= in4;
			default: out <= 32'dz;
		endcase
	end
endmodule





