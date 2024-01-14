
module LSU(
	// Input signals
	input wire			clk,
	input wire			rst_n,
	input wire [31:0]	operand1,
	input wire [31:0]	operand2,
	input wire			write_mem,
	input wire [31:0]	write_data,
	input wire			lsu_start,
	input wire [4:0]	execute_type,
	input wire 			awready,
	input wire [1:0]	bresp,
	input wire 			bvalid,
	input wire			wready,
	input wire 			arready,
	input wire [31:0]	rdata,
	input wire 			rlast,
	input wire 			rvalid,
	// Output signals
	output wire			lsu_work,
	output reg			lsu_done,
	output wire [31:0]	result,
	output wire [31:0]	awaddr,
	output wire [1:0]	awburst,
	output wire [3:0]	awcache,
	output wire [7:0]	awlen,
	output wire [2:0]	awsize,
	output reg 			awvalid,
	output reg 			bready,
	output wire [31:0]	wdata,
	output reg 			wlast,
	output reg [3:0]	wstrb,
	output reg 			wvalid,
	output wire [31:0]	araddr,
	output wire [1:0]	arburst,
	output wire [3:0]	arcache,
	output wire [7:0]	arlen,
	output wire [2:0]	arsize,
	output reg 			arvalid,
	output reg 			rready
);

    reg [1:0] write_state = 2'b00; 
    reg [1:0] pre_state, pre_state1;
    reg [1:0] read_state = 2'b00;

	assign lsu_work = lsu_start & !lsu_done;
	assign awaddr = operand1 + operand2;
	assign wdata = write_data;
	assign araddr = operand1 + operand2;
	assign result = rdata;
	assign awburst = (lsu_start & rst_n & write_mem) ? 2'b00 : 2'bz;
	assign awlen = (lsu_start &rst_n & write_mem) ? 8'd0 : 8'bz;
	assign awcache = (lsu_start & rst_n & write_mem) ? 4'd3 : 4'bz;
	assign awsize = (lsu_start & rst_n & write_mem) ? 3'd2 : 3'bz;
	//assign awvalid = (rst_n & write_mem & !awready) ? 1'b1 : 1'b0;
	assign arburst = (lsu_start & rst_n & !write_mem) ? 2'b00 : 2'bz;
	assign arlen = (lsu_start & rst_n & !write_mem) ? 8'd0 : 8'bz;
	assign arcache = (lsu_start & rst_n & !write_mem) ? 4'd3 : 4'bz;
	assign arsize = (lsu_start & rst_n & !write_mem) ? 3'd2 : 3'bz;
	//assign arvalid = (rst_n & !write_mem & !arready) ? 1'b1 : 1'b0;
	//assign wvalid = (rst_n & write_mem & awready) ? 1'b1 : 1'b0;
	//assign lsu_done = ((rlast)||(bvalid & !bresp)) ? 1'b1 : 1'b0;
	
	always @(posedge clk)
	begin
		if (!rst_n)
		begin
		      arvalid = 1'b0;
		      awvalid = 1'b0;
		      rready = 1'b0;
		      wvalid = 1'b0;
		end
		else
		begin
		if (lsu_start) begin
			if (write_mem)
			begin
			    case(write_state)
			    2'b00: begin
			         if (pre_state == 2'b11) awvalid = 1'b0;
			         else awvalid = 1'b1;
			         pre_state=2'b00;
			         if (awready) begin awvalid = 1'b0; write_state = 2'b01; end
			    end
			    2'b01: begin
			         wvalid = 1'b1;
			         wlast = 1'b1;
			         wstrb = 4'b1111;
			         pre_state = 2'b01;
			         if (wready) begin 
			             write_state = 2'b10;
			         end
			    end
			    2'b10: begin
			         wlast = 1'b0;
			         wstrb = 4'b0000;
			         wvalid = 1'b0;
			         bready = 1'b1;
			         pre_state = 2'b10;
			         if (bvalid) begin bready = 1'b0; write_state = 2'b11; end
			    end 
			    2'b11: begin
			         pre_state = 2'b11;
			         if (lsu_done) write_state = 2'b00; 
			    end
			    endcase         
			end
			else if (write_mem == 0)
			begin
			    case(read_state)
			    2'b00: begin
			         if (pre_state1 == 2'b10) arvalid = 1'b0;
			         else arvalid = 1'b1;
			         pre_state1 = 2'b00;
			         if (arready) begin arvalid = 1'b0; read_state = 2'b01; end
			    end
			    2'b01: begin
			         rready = 1'b1;
			         if (rvalid) read_state = 2'b10;
			    end
			    2'b10: begin
			         pre_state1 = 2'b10;
			         rready = 1'b0;
			         if (lsu_done) read_state = 2'b00;
			    end  
			    endcase
			end
		if ((rlast == 1) || (bvalid == 1 & bresp == 2'b00))
		    lsu_done = 1'b1;
		else lsu_done = 1'b0;
		end	
		end
	end
///// Mấy tín hiệu AXI ông tự thêm vào 
 //// địa chỉ ghi và đ�?c ông lấy operand1 + operand2
 //// lsu_done ông cho lên 1 khi mà dữ liệu đ�?c valid hoặc DCache hoàn thành việc ghi
 //// result là kết quả khi đ�?c từ DCache
endmodule: LSU





