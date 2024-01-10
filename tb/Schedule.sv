`timescale 1ns/1ps

`include "../rtl/Schedule.v"

module tb_Schedule;
	logic clk;
	logic [127:0]	fetch_data;


	logic [127:0]	instr1;
	logic [127:0]	instr2;
	logic			write1;
	logic 			write2;
	logic			jal;
	logic	[31:0]	jal_addr;
	
	always #(10) clk = ~clk;

	initial begin
		$dumpfile("wave_file/tb_Schedule.vcd");
		$dumpvars(0, tb_Schedule);
	end

	
	initial begin
		clk = 1'b0;
		fetch_data = 128'h0001E237000000040001413700000000;
		#(100)
		$finish;
	end


	Schedule Schedule_instance(fetch_data, instr1, instr2, write1, write2, jal, jal_addr);
endmodule
