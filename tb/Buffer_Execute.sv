`timescale 1ns/1ps

`include "../rtl/Buffer_Execute.v"

module tb_Buffer_Execute;

	logic			clk;
	logic			rst_n;
	logic			write1;
	logic			write2;
	logic [127:0]	data1_in;
	logic [127:0]	data2_in;


	logic			buf_full;
	logic [127:0]	data_out;
	


	initial begin
		$dumpfile("wave_file/tb_Buffer_Execute.vcd");
		$dumpvars(0, tb_Buffer_Execute);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(40)
		rst_n = 1'b1;
		data1_in = 128'd100;
		data2_in = 128'd200;
		write1 = 1'b0;
		write2 = 1'b1;
		#(100)
		$finish;
	end


	Buffer_Execute Buffer_Execute_instance(clk, rst_n, write1, write2, data1_in, data2_in, buf_full, data_out);
endmodule
