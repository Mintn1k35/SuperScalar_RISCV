`timescale 1ns/1ps

`include "../rtl/AU.v"

module tb_AU;

	logic			clk;
	logic			rst_n;
	logic [31:0]	operand1;
	logic [31:0]	operand2;
	logic [4:0]	execute_type;


	logic [31:0]	result;
	


	initial begin
		$dumpfile("wave_file/tb_AU.vcd");
		$dumpvars(0, tb_AU);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	AU AU_instance(clk, rst_n, operand1, operand2, execute_type, result);
endmodule
