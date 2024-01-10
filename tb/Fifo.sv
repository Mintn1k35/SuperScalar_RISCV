`timescale 1ns/1ps

`include "../rtl/Fifo.v"

module tb_Fifo;

	logic			clk;
	logic			rst_n;
	logic [63:0]	data_in;
	logic 			write;
	logic			read;
	logic			stall;

	logic [63:0]	data_out;
	logic			buf_full;
	


	initial begin
		$dumpfile("wave_file/tb_Fifo.vcd");
		$dumpvars(0, tb_Fifo);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(20)
		rst_n = 1'b1;
		stall = 1'b0;
		data_in = 32'd10;
		write = 1'b1;
		read = 1'b1;
		#(20)
		data_in = 32'd20;
		#(20)
		stall = 1'b1;
		data_in = 32'd30;
		#(20)
		data_in = 32'd30;
		#(100)
		$finish;
	end


	Fifo Fifo_instance(clk, rst_n, data_in, write, read, stall, data_out, buf_full);
endmodule
