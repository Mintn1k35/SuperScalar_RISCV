
module ICache(
	input wire			clk,
	input wire			rst_n,

	// Address channel
	input wire			arvalid,
	input wire [31:0] 	araddr,
	input wire [1:0] 	arburst,
	input wire [2:0]	arsize,
	input wire [7:0]	arlen,
	output reg 			arready,

	// Read data channel
	input wire 			rready,
	output reg 			rvalid,
	output reg	[63:0]	rdata,
	output reg 			rlast
);
	reg [31:0] rom[100:0];

	initial begin
		$readmemh("test_file/test_program.mem", rom);
	end

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			arready <= 1'b1;
			rvalid <= 1'b0;
			rdata <= 32'dx;
			rlast <= 1'b0;
		end
		else begin
			// Read data: acked
			if(rvalid & rready) begin
				arready <= 1'b1;
				rvalid <= 1'b0;
			end 
			else if (rvalid & !rready) begin
				arready <= 1'b0;
			end
		end

		if (arvalid & arready & ~(rvalid & !rready)) begin
			rvalid <= 1'b1;
			rlast <= 1'b1;
			rdata <= { rom[(araddr[31:0]+1)/4] , rom[araddr[31:0]/4] };
		end
	end

endmodule: ICache





