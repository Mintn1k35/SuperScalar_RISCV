`timescale 1ns/1ps

`include "../rtl/Fifo.v"

module tb_Fifo;

	// Input signals
	logic clk;
	logic rst_n;
	logic [63:0] data_in;
	logic write;
	logic read;	

	// Output signals
	logic [31:0] data_out;
	logic buf_empty;
	logic buf_full;

	initial begin
		$dumpfile("wave_file/tb_Fifo.vcd");
		$dumpvars(0, tb_Fifo);
	end

	always #(10) clk = ~clk;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(60)
		rst_n = 1'b1;
		data_in = 64'h0000000100000002;
		write = 1'b1;
		read = 1'b1;
		#(1000)
		$finish;
	end


	Fifo Fifo_instance(clk, rst_n, data_in, write, read, data_out, buf_empty, buf_full);
endmodule
