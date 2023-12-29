
module Fifo(
	// Input signals
	input wire 		clk, 
	input wire 		rst_n,
	input wire [127:0] 	data_in,
	input wire 		write,
	input wire 		read,

	// Output signals	
	output reg [63:0]	data_out,
	output reg 		buf_empty,
	output reg 		buf_full
);
	reg [4:0] counter;
	reg [4:0] read_pointer;
	reg [4:0] write_pointer;
	reg [63:0] buf_mem[31:0];

	always @(counter) begin
		buf_empty = (counter == 5'd0);
		buf_full = (counter == 5'd31);
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			counter <= 5'd0;
		end
		else if((!buf_full && write) && (!buf_empty && read)) begin
			counter <= counter + 5'd1;
		end
		else if (!buf_full && write) begin
			counter <= counter + 5'd2;
		end
		else if (!buf_empty && read) begin
			counter <= counter - 5'd1;
		end
		else counter <= counter;
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data_out <= 32'h0000001300000000;
		end
		else begin
			if(!buf_empty && read) begin
				data_out <= buf_mem[read_pointer];
			end
			else data_out <= data_out;
		end
	end

	always @(posedge clk) begin
		if(write && !buf_full) begin
			buf_mem[write_pointer] <= data_in;
			buf_mem[write_pointer + 5'd1] <= data_in >> 64;
		end
		else begin
			buf_mem[write_pointer] <= buf_mem[write_pointer];
		end
	end


	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			write_pointer <= 5'd0;
			read_pointer <= 5'd0;
		end
		else begin
			if(!buf_full && write) write_pointer <= write_pointer + 5'd2;
			else write_pointer <= write_pointer;
			
			if(!buf_empty && read) read_pointer <= read_pointer + 5'd1;
			else read_pointer <= read_pointer;
		end
	end
endmodule 





