`timescale 1ns/1ps

`include "../rtl/Transfer_Decode_Execute.v"

module tb_Transfer_Decode_Execute;

	logic			clk;
	logic			rst_n;
	logic			stall;
	logic [31:0]	operand1_decode;
	logic [31:0]	operand2_decode;
	logic			reg_write_decode;
	logic [4:0]	rd_decode;
	logic [4:0]	execute_type_decode;
	logic 			au_decode;
	logic 			mul_decode;
	logic			lsu_decode;


	logic [31:0]	operand1_execute;
	logic [31:0]	operand2_execute;
	logic			reg_write_execute;
	logic [4:0]	rd_execute;
	logic [4:0]	execute_type_execute;
	logic			au_execute;
	logic			mul_execute;
	logic			lsu_execute;
	


	initial begin
		$dumpfile("wave_file/tb_Transfer_Decode_Execute.vcd");
		$dumpvars(0, tb_Transfer_Decode_Execute);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		#(20)


		#(100)
		$finish;
	end


	Transfer_Decode_Execute Transfer_Decode_Execute_instance(clk, rst_n, stall, operand1_decode, operand2_decode, reg_write_decode, rd_decode, execute_type_decode, au_decode, mul_decode, lsu_decode, operand1_execute, operand2_execute, reg_write_execute, rd_execute, execute_type_execute, au_execute, mul_execute, lsu_execute);
endmodule
