module InstrMem (
	input wire 		clk,
	input wire 		rst_n,
	
	// Read address channel
	input wire 		arvalid,
	input wire [31:0] 	araddr,
	input wire [1:0] 	arburst, // arburst = 00
	input wire [2:0]	arsize, // arsize = 2 -> 2^2, a transaction is 4 byte
	input wire [7:0]	arlen, // the number of transaction
	output reg 		arready,	

	// Read data channel
	input wire 		rready,
	output reg 		rvalid,
	output reg [63:0] 	rdata,
	output reg 		rlast,
	output reg [1:0]	rresp
);
	
	reg [31:0] rom [0:100];

	initial begin
		$readmemh("test_file/test_program.mem", rom);
	end		

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			arready = 1'b1;
			rvalid = 1'b0;
			rlast = 1'b0;
			rresp = 2'd3;
		end
		else begin
			if (rvalid & rready) begin // data is valid and slave is ready to get data -> Complete to tranfer data to slave so it's ready to get araddr
				arready = 1'b1;
				rvalid = 1'b0;	
			end
			else if (rvalid & !rready) begin // data is valid but slave isn't ready to get data -> Not complete tranfering data so it's no ready to get araddr
				arready = 1'b0;
			end

			if (arvalid & arready) begin // it's ready to receive araddr and araddr is valid -> Execute receiving address
				rvalid = 1'b1;
				rdata = { rom[araddr[31:2] + 1] , rom[araddr[31:2]] };
				rresp = 2'd0;
				rlast = 1'b1;
			end
		end
	end

endmodule





