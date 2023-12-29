`timescale 1ns/1ps

`include "../rtl/PC_Control.v"

module tb_PC_Control;

	// Input signals
	logic clk;
	logic rst_n;
	logic jump;
	logic [31:0] jump_addr;
	logic buffer_free;
	logic arready;	

	// Output signals
	logic arvalid;
	logic [31:0] araddr;


	initial begin
		$dumpfile("wave_file/tb_PC_Control.vcd");
		$dumpvars(0, tb_PC_Control);
	end

	always #(10) clk = ~clk;

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(20)
		rst_n = 1'b1;
		jump = 1'b0;
		buffer_free = 1'b1;
		arready = 1'b1;
		#(1000)
		$finish;
	end


	PC_Control PC_Control_instance(clk, rst_n, jump, jump_addr, buffer_free, arvalid, araddr, arready);
endmodule
