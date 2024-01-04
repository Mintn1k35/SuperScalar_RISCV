`timescale 1ns/1ps

`include "../rtl/name.v"

module tb_name;

	Input


	Output
	


	initial begin
		$dumpfile("wave_file/tb_name.vcd");
		$dumpvars(0, tb_name);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Instance;
endmodule
