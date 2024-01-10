`timescale 1ns/1ps

`include "../rtl/Core.v"

module tb_Core;

	logic			clk;
	logic			rst_n;
	logic [127:0]	data_in;
	logic 			write;


	logic			stop_fetch;
	


	initial begin
		$dumpfile("wave_file/tb_Core.vcd");
		$dumpvars(0, tb_Core);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(20)
		rst_n = 1'b1;
		write = 1'b1;
		data_in = 128'h00014137000000040001E1B700000000;
		#(1000)
		$finish;
	end


	Core Core_instance(clk, rst_n, data_in, write, stop_fetch);
endmodule
