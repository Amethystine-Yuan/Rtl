
module sync_fifo#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire					wfull	,
	output reg					rempty_n	,
	output wire [WIDTH-1:0]	rdata
);

	parameter ADDR_WIDTH = $clog2(DEPTH);
/**********************************Part-I: Next Pointer Logic************************************/
	reg [ADDR_WIDTH:0] wptr_bin;
	reg [ADDR_WIDTH:0] rptr_bin;
	wire [ADDR_WIDTH:0] wptr_bin_next;
	wire [ADDR_WIDTH:0] rptr_bin_next;
	wire rempty;
	wire rempty_val;
	
	assign wptr_bin_next = wptr_bin + (winc & !wfull);
	assign rptr_bin_next = rptr_bin + (rinc & !rempty);
	
	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wptr_bin <= 'd0;
			rptr_bin <= 'd0;
		end
		else begin
			wptr_bin <= wptr_bin_next;
			rptr_bin <= rptr_bin_next;
		end
	end
/**********************************Part-II:Empty&Full Logic************************************/
	assign wfull = (wptr_bin == {~rptr_bin[ADDR_WIDTH],rptr_bin[ADDR_WIDTH-1 : 0]}) ? 1'b1 : 1'b0;
	assign rempty = (wptr_bin == rptr_bin) ? 1'b1 : 1'b0;
	assign rempty_val = rinc && (!rempty);

    always @(posedge clk or negedge rst_n)
        if (!rst_n)    rempty_n <= 1'b0;
        else           rempty_n <= rempty_val;


/**********************************Part-III:RAM************************************/
    wire wenc, renc;
    wire [ADDR_WIDTH-1:0] raddr, waddr;

    assign wenc = winc & !wfull;
    assign renc = rinc & !rempty;

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) 
                u_dual_port_RAM (
                .wclk(clk), 
                .rclk(clk), 
                .wenc(wenc), 
                .renc(renc),
                .raddr(raddr),
                .waddr(waddr),
                .wdata(wdata),
                .rdata(rdata)
                );
endmodule



/**********************************RAM************************************/
module dual_port_RAM #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  
	,input [WIDTH-1:0] wdata      	
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  
	,output reg [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
    else
        RAM_MEM[waddr] <= RAM_MEM[waddr];
end 

always @(posedge rclk) begin
	if(renc)
		rdata <= RAM_MEM[raddr];
    else
        rdata <= rdata;
end 

endmodule




module sync_fifo_bridge#(
	parameter	WIDTH = 8,
	parameter 	DEPTH = 16
)(
	input 					clk		, 
	input 					rst_n	,
	input 					winc	,
	input 			 		rinc	,
	input 		[WIDTH-1:0]	wdata	,

	output wire					wfull	,
	output reg					rempty_n	,
	output wire [WIDTH-1:0]	rdata
);

	parameter ADDR_WIDTH = $clog2(DEPTH);
/**********************************Part-I: Next Pointer Logic************************************/
	reg [ADDR_WIDTH:0] wptr_bin;
	reg [ADDR_WIDTH:0] rptr_bin;
	wire [ADDR_WIDTH:0] wptr_bin_next;
	wire [ADDR_WIDTH:0] rptr_bin_next;
	wire rempty;
	wire rempty_val;
	
	assign wptr_bin_next = wptr_bin + (winc & !wfull);
	assign rptr_bin_next = rptr_bin + (rinc & !rempty);
	
	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			wptr_bin <= 'd0;
			rptr_bin <= 'd0;
		end
		else begin
			wptr_bin <= wptr_bin_next;
			rptr_bin <= rptr_bin_next;
		end
	end
/**********************************Part-II:Empty&Full Logic************************************/
	assign wfull = (wptr_bin == {~rptr_bin[ADDR_WIDTH],rptr_bin[ADDR_WIDTH-1 : 0]}) ? 1'b1 : 1'b0;
	assign rempty = (wptr_bin == rptr_bin) ? 1'b1 : 1'b0;
	assign rempty_val = rinc && (!rempty);

    always @(*)
		 rempty_n <= rempty_val;


/**********************************Part-III:RAM************************************/
    wire wenc, renc;
    wire [ADDR_WIDTH-1:0] raddr, waddr;

    assign wenc = winc & !wfull;
    assign renc = rinc & !rempty;

    assign raddr = rptr_bin[ADDR_WIDTH-1:0];
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    dual_port_RAM_bridge #(.DEPTH(DEPTH), .WIDTH(WIDTH)) 
                u_dual_port_RAM (
                .wclk(clk), 
                .rclk(clk), 
                .wenc(wenc), 
                .renc(renc),
                .raddr(raddr),
                .waddr(waddr),
                .wdata(wdata),
                .rdata(rdata)
                );
endmodule



/**********************************RAM************************************/
module dual_port_RAM_bridge #(parameter DEPTH = 16,
					   parameter WIDTH = 8)(
	 input wclk
	,input wenc
	,input [$clog2(DEPTH)-1:0] waddr  
	,input [WIDTH-1:0] wdata      	
	,input rclk
	,input renc
	,input [$clog2(DEPTH)-1:0] raddr  
	,output reg [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
	if(wenc)
		RAM_MEM[waddr] <= wdata;
    else
        RAM_MEM[waddr] <= RAM_MEM[waddr];
end 

always @(*) begin
		rdata <= RAM_MEM[raddr];
end 

endmodule