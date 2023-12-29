`timescale 1ns/1ps

`include "../rtl/Test.v"

module tb_Test;

	// Input signals
	logic a;
	logic b;	

	// Output signals
	


	initial begin
		$dumpfile("wave_file/tb_Test.vcd");
		$dumpvars(0, tb_Test);
	end

	
	initial begin
		a = 1'bz;
		#(100)
		$finish;
	end


	Test Test_instance(a, b);
endmodule
