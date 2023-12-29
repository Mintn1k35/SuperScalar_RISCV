`timescale 1ns/1ps

`include "../rtl/Top.v"

module tb_Top;

	// Input signals
	logic clk;
	logic rst_n;
	logic rs1_valid;
	logic rs2_valid;
	logic [31:0] rs1_data;
	logic [31:0] rs2_data;
	logic [2:0] au_free;
	logic [2:0] mul_free;
	logic lsu_free;	

	// Output signals
	


	initial begin
		$dumpfile("wave_file/tb_Top.vcd");
		$dumpvars(0, tb_Top);
	end

	always #(10) clk = ~clk;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(60)
		rst_n = 1'b1;
		rs1_valid = 1'b0;
		rs2_valid = 1'b1;
		rs1_data = 32'd10;
		rs2_data = 32'd10;
		au_free = 3'b111;
		mul_free = 3'b111;
		lsu_free = 1'b1;
		#(1000)
		$finish;
	end


	Top Top_instance(clk, rst_n, rs1_valid, rs2_valid, rs1_data, rs2_data, au_free, mul_free, lsu_free);
endmodule
