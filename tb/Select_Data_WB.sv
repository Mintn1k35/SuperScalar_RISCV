`timescale 1ns/1ps

`include "../rtl/Select_Data_WB.v"

module tb_Select_Data_WB;

	logic [31:0]	au_result;
	logic [31:0]	mul_result;
	logic [31:0]	lsu_result;
	logic [2:0]	select;


	logic [31:0]	result;
	


	initial begin
		$dumpfile("wave_file/tb_Select_Data_WB.vcd");
		$dumpvars(0, tb_Select_Data_WB);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Select_Data_WB Select_Data_WB_instance(au_result, mul_result, lsu_result, select, result);
endmodule
