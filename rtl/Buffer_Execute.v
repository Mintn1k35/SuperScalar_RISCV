
module Buffer_Execute(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire			stall,
	input wire			write1,
	input wire			write2,
	input wire [127:0]	data1_in,
	input wire [127:0]	data2_in,
	// Output signals	
	output reg			buf_full,
	output reg [127:0]	data_out
);
	reg [4:0] counter;
	reg [4:0] read_pointer, write_pointer;
	reg [127:0] mem_buf[31:0];
	reg buf_empty;

	always @(*) begin
		buf_empty = (counter == 5'd0);
		buf_full = (counter == 5'd31);
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			counter <= 5'd0;
		end
		else begin
			if(!buf_empty) begin
				if(write1) begin
					counter <= counter;
				end
				else if(write2) begin
					counter <= counter + 5'd1;
				end
				else counter <= counter - 5'd1;
			end
			else begin
				if(write1) begin
					counter <= counter + 5'd1;
				end
				else if(write2) begin
					counter <= counter + 5'd2;
				end
				else counter <= counter;
			end
		end
	end


	always @(posedge clk) begin
		if(!buf_full) begin
			if(write1) begin
				mem_buf[write_pointer] <= data1_in;
			end
			else if(write2) begin
				mem_buf[write_pointer] <= data1_in;
				mem_buf[write_pointer + 5'd1] <= data2_in;
			end
			else mem_buf[write_pointer] <= mem_buf[write_pointer];
		end
		else mem_buf[write_pointer] <= mem_buf[write_pointer];
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			data_out <= 127'd0;
		end
		else begin
			if(!buf_empty) begin
				data_out <= mem_buf[read_pointer];
			end
			else data_out <= 128'd0;
		end
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			read_pointer <= 5'd0;
			write_pointer <= 5'd0;
		end
		else begin
			if(!buf_empty & !stall) read_pointer <= read_pointer + 5'd1;
			else read_pointer <= read_pointer;
			if(!buf_full) begin
				if(write1) write_pointer <= write_pointer + 5'd1;
				else if (write2) write_pointer <= write_pointer + 5'd2;
				else write_pointer <= write_pointer;
			end
			else write_pointer <= write_pointer;
		end
	end

endmodule: Buffer_Execute





