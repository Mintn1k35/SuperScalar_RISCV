`timescale 1ns/1ps

`include "../rtl/Mul_Div.v"

module tb_Mul_Div;

	logic [31:0]	operand1;
	logic [31:0]	operand2;
	logic [4:0]	execute_type;


	logic [31:0]	result;
	


	initial begin
		$dumpfile("wave_file/tb_Mul_Div.vcd");
		$dumpvars(0, tb_Mul_Div);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Mul_Div Mul_Div_instance(operand1, operand2, execute_type, result);
endmodule
