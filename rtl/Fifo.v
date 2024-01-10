
module Fifo(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire [127:0]	data_in,
	input wire 			write,
	input wire			stall,
	// Output signals	
	output reg	[127:0]	data_out,
	output reg			buf_full
);

	reg buf_empty;
	reg [4:0] counter, read_pointer , write_pointer;
	reg [127:0] buf_mem[31:0];

	always @(*) begin
		buf_empty = (counter == 5'd0);
		buf_full = (counter == 5'd31);
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			counter <= 5'd0;
		end
		else if ((!buf_empty) && (!buf_full && write)) begin
			counter <= counter;
		end
		else if (!buf_full && write) begin
			counter <= counter + 5'd1;
		end
		else if (!buf_empty) begin
			counter <= counter - 5'd1;
		end
		else counter <= counter;
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data_out <= 128'd0;
		end
		else if (!buf_empty) begin
			data_out <= buf_mem[read_pointer];
		end
		else data_out <= 128'd0;
	end

	always @(posedge clk) begin
		if(write && !buf_full) begin
			buf_mem[write_pointer] <= data_in;
		end
		else buf_mem[write_pointer] <= buf_mem[write_pointer];
	end


	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			write_pointer <= 5'd0;
			read_pointer <= 5'd0;
		end
		else begin
			if(!buf_full && write) begin
				write_pointer <= write_pointer + 5'd1;	
			end
			else write_pointer <= write_pointer;

			if(!buf_empty) begin
				if(stall) begin
					read_pointer <= read_pointer;
				end
				else read_pointer <= read_pointer + 5'd1;
			end
			else begin
				read_pointer <= read_pointer;
			end
		end
	end


endmodule: Fifo





