`timescale 1ns/1ps

`include "../rtl/PC_Control.v"

module tb_PC_Control;

	logic 			clk;
	logic 			rst_n;
	logic   		jal;
	logic 			jalr_jcond;
	logic [31:0]	jal_addr;
	logic [31:0] 	jalr_jcond_addr;
	logic 			rlast;


	logic	[31:0]	pc_addr;
	


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
		rlast = 1'b1;
		jal = 1'b0;
		jalr_jcond = 1'b0;
		#(60)
		jal = 1'b1;
		jal_addr = 32'd10;
		#(40)
		jalr_jcond = 1'b1;
		jal = 1'b0;
		jalr_jcond_addr = 32'd20;
		#(40)
		rlast = 1'b0;
		#(100)
		$finish;
	end


	PC_Control PC_Control_instance(clk,rst_n,jal,jalr_jcond,jal_addr,jalr_jcond_addr,rlast,pc_addr);
endmodule
