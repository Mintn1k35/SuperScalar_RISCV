`timescale 1ns/1ps

`include "../rtl/Top.v"

module tb_Top;

	logic			clk;
	logic			rst_n;
	logic			jal;
	logic			jalr_jcond;
	logic [31:0]	jal_addr;
	logic [31:0] 	jalr_jcond_addr;
	logic			busy;


	logic [63:0] 	fetch_instr_pc;
	


	initial begin
		$dumpfile("wave_file/tb_Top.vcd");
		$dumpvars(0, tb_Top);
	end

	always #(10) clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		#(20)
		rst_n = 1'b1;
		jal = 1'b0;
		jalr_jcond = 1'b0;
		jal_addr = 32'd10;
		jalr_jcond_addr = 32'd20;
		#(40)
		jal = 1'b1;
		#(40)
		jal = 1'b0;
		jalr_jcond = 1'b1;
		#(40)
		jalr_jcond = 1'b0;
		#(1000)
		$finish;
	end


	Top Top_instance(clk, rst_n, jal, jalr_jcond, jal_addr, jalr_jcond_addr, busy, fetch_instr_pc);
endmodule
