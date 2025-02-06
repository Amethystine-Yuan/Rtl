`timescale 1ns/1ps

module FIFO_async2_medac #(parameter DSIZE = 40,
parameter ASIZE = 4)
(
	output [DSIZE-1:0] rdata,
	output wfull,
	output rempty_n,
	output error_w,
	output error_r,
	input [2:0] sync_sel,
	input [DSIZE-1:0] wdata,
	input [3:0] win_sel_r2w,
	input [3:0] win_sel_w2r,
	input winc, wclk, wclk_sync,
	input rinc, rclk, rclk_sync, 
	input rst_n
);

wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

meta_detector_bits #(ASIZE) sync_r2w (
		.sync_sel(sync_sel),
		.clk(wclk),
		.clks(wclk_sync),
		.win_sel(win_sel_r2w),
		.rst_n(rst_n),
		.ptr_in(rptr),
		.ptr_out(wq2_rptr),
		.error(error_w));
meta_detector_bits #(ASIZE) sync_w2r (
		.sync_sel(sync_sel),
		.clk(rclk),
		.clks(rclk_sync),
		.win_sel(win_sel_w2r),
		.rst_n(rst_n),
		.ptr_in(wptr),
		.ptr_out(rq2_wptr),
		.error(error_r));


fifomem_medac #(DSIZE, ASIZE) fifomem_medac (
	.rdata(rdata), .wdata(wdata),
	.waddr(waddr), .raddr(raddr),
	.wclken(winc), .wfull(wfull),
	.wclk(wclk));

rptr_empty_medac #(ASIZE) rptr_empty_medac (
	.rempty_n(rempty_n),
	.raddr(raddr),
	.rptr(rptr), .rq2_wptr(rq2_wptr),
	.rinc(rinc), .rclk(rclk),
	.rrst_n(rst_n));
wptr_full_medac #(ASIZE) wptr_full_medac (
	.wfull(wfull), .waddr(waddr),
	.wptr(wptr), .wq2_rptr(wq2_rptr),
	.winc(winc), .wclk(wclk),
	.wrst_n(rst_n));
endmodule

module fifomem_medac #(parameter DATASIZE = 8, // Memory data word width
parameter ADDRSIZE = 3) // Number of mem address bits
(output [DATASIZE-1:0] rdata,
input [DATASIZE-1:0] wdata,
input [ADDRSIZE-1:0] waddr, raddr,
input wclken, wfull, wclk);
`ifdef VENDORRAM
// instantiation of a vendor's dual-port RAM
vendor_ram mem (.dout(rdata), .din(wdata),
.waddr(waddr), .raddr(raddr),
.wclken(wclken),
.wclken_n(wfull), .clk(wclk));
`else
// RTL Verilog memory model
localparam DEPTH = 1<<ADDRSIZE;
reg [DATASIZE-1:0] mem [0:DEPTH-1];
assign rdata = mem[raddr];
always @(posedge wclk)
if (wclken && !wfull) mem[waddr] <= wdata;
`endif
endmodule
/*
module sync_r2w #(parameter ADDRSIZE = 3)
(output reg [ADDRSIZE:0] wq2_rptr,
input [ADDRSIZE:0] rptr,
input wclk, wrst_n);
reg [ADDRSIZE:0] wq1_rptr;
always @(posedge wclk or negedge wrst_n)
//if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
//else
 {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule

module sync_w2r #(parameter ADDRSIZE = 3)
(output reg [ADDRSIZE:0] rq2_wptr,
input [ADDRSIZE:0] wptr,
input rclk, rrst_n);
reg [ADDRSIZE:0] rq1_wptr;
always @(posedge rclk or negedge rrst_n)
//if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
//else 
{rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule*/


module synchronizer #(parameter ADDRSIZE = 3) (
	input clk, clks, rst_n,
	input [2:0] sync_sel,
	input [ADDRSIZE:0] ptr_in,
	output reg [ADDRSIZE:0] ptr_out
);
reg [ADDRSIZE:0] ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2, ptr1;

//always @(posedge clks or negedge rst_n) begin
always @(posedge clks or negedge rst_n) begin
	if (!rst_n) 
		ptr1 <= 0;
	else
		ptr1 <= ptr_in;
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		{ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2} <= 0;
	end else begin
		{ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2} <= {ptr7, ptr6, ptr5, ptr4, ptr3, ptr2, ptr1};
	end
end

always @(*) begin
	case(sync_sel)
		3'd0: ptr_out = ptr1;
		3'd1: ptr_out = ptr2;
		3'd2: ptr_out = ptr3;
		3'd3: ptr_out = ptr4;
		3'd4: ptr_out = ptr5;
		3'd5: ptr_out = ptr6;
		3'd6: ptr_out = ptr7;
		3'd7: ptr_out = ptr8;
		default: ptr_out = ptr2;
	endcase
end
//always @(posedge clk or negedge rst_n)
//	if (!rst_n) 
//		{ptr_out, ptr_tmp} <= 0;
//	else 
//		{ptr_out, ptr_tmp} <= {ptr_tmp, ptr_in};

endmodule

module synchronizer_shadow #(parameter ADDRSIZE = 3) (
	input clk, clkd, rst_n,
	input [2:0] sync_sel,
	input [ADDRSIZE:0] ptr_in,
	output reg [ADDRSIZE:0] ptr_out
);

reg [ADDRSIZE:0] ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2, ptr1;

always @(posedge clkd or negedge rst_n) begin
    if (!rst_n) begin
        {ptr1} <= 0;
    end else begin
        {ptr1} <= {ptr_in};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2} <= 0;
    end else begin
        {ptr8, ptr7, ptr6, ptr5, ptr4, ptr3, ptr2} <= {ptr7, ptr6, ptr5, ptr4, ptr3, ptr2, ptr1};
    end
end

always @(*) begin
    case(sync_sel)
        3'd0: ptr_out = ptr1;
        3'd1: ptr_out = ptr2;
        3'd2: ptr_out = ptr3;
        3'd3: ptr_out = ptr4;
        3'd4: ptr_out = ptr5;
        3'd5: ptr_out = ptr6;
        3'd6: ptr_out = ptr7;
        3'd7: ptr_out = ptr8;
        default: ptr_out = ptr2;
    endcase
end


//reg [ADDRSIZE:0] ptr_tmp;
//always @(posedge clkd or negedge rst_n)
//	if (!rst_n) 
//		ptr_tmp <= 0;
//	else 
//		ptr_tmp <= ptr_in;
//always @(posedge clk or negedge rst_n)
//	if (!rst_n) 
//		ptr_out <= 0;
//	else 
//		ptr_out <= ptr_tmp;
endmodule

module meta_detector_bits #(parameter ADDRSIZE = 3) (
	input clk, clks, rst_n,
	input [3:0] win_sel,
	input [2:0] sync_sel,
	input [ADDRSIZE:0] ptr_in,
	output [ADDRSIZE:0] ptr_out,
	output error
);
	wire [ADDRSIZE:0] ptr_out_shadow;
	wire [ADDRSIZE:0] ptr_out_shadow_d;
	wire [ADDRSIZE:0] ptr_xor;

	// /* below for simulation */
    // assign clkd = clk; // to be modified
    reg clkd;
    always @(clks) begin
        #0.05 clkd = clks;
		// #0.1 clkd = clks;
    end

	//New
	reg [ADDRSIZE:0] ptr_d;
	always @(clk) begin
		#0.025 ptr_d = ptr_in;
	end
    // /* above for simulation */

    /* below for synthesis */
	// var_delay_cell_lvt var_delay_win (
	// 	.S0(win_sel[0]),
	// 	.S1(win_sel[1]),
	// 	.S2(win_sel[2]),
	// 	.S3(win_sel[3]),
	// 	.din(clks),
	// 	.dout(clkd)

	// );
	// above for synthesis
    // reg [2:0] win_selb;
    // wire dinb;

    // always @(*)
    //     win_selb = ~ win_sel;

    // var_delay_cell var_delay_cell0 (
    //     // .VDD(), .VSS(),
    //     .S0(win_sel[0]), .S1(win_sel[1]), .S2(win_sel[2]),
    //     .S0b(win_selb[0]), .S1b(win_selb[1]), .S2b(win_selb[2]),
    //     .din(clks), .dout(dinb)
    // );
    // var_delay_cell var_delay_cell1 (
    //     // .VDD(), .VSS(),
    //     .S0(win_sel[0]), .S1(win_sel[1]), .S2(win_sel[2]),
    //     .S0b(win_selb[0]), .S1b(win_selb[1]), .S2b(win_selb[2]),
    //     .din(dinb), .dout(clkd)
    // );
    /* above for synthesis */



	synchronizer #(ADDRSIZE) sync_main (
		.clk(clk),
		.clks(clks),
		.rst_n(rst_n),
		.sync_sel(sync_sel),
		.ptr_in(ptr_in),
		.ptr_out(ptr_out)
	);
	synchronizer #(ADDRSIZE) sync_shadow2 (
		.clk(clk),
		.clks(clks),
		.rst_n(rst_n),
		.sync_sel(sync_sel),
		.ptr_in(ptr_d),
		.ptr_out(ptr_out_shadow_d)
	);
	//synchronizer_shadow #(ADDRSIZE) sync_shadow (
	synchronizer #(ADDRSIZE) sync_shadow (
		.clk(clk),
		.clks(clkd),
		.rst_n(rst_n),
		.sync_sel(sync_sel),
		.ptr_in(ptr_d),
		.ptr_out(ptr_out_shadow)
	);

	assign ptr_xor = (ptr_out_shadow_d ^ ptr_out_shadow);
	assign error = | ptr_xor;

endmodule

// module sync_r2w #(parameter ADDRSIZE = 3)
// (output reg [ADDRSIZE:0] wq2_rptr,
// input [ADDRSIZE:0] rptr,
// input wclk, wrst_n);
// reg [ADDRSIZE:0] wq1_rptr;
// always @(posedge wclk or negedge wrst_n)
// if (!wrst_n) {wq2_rptr,wq1_rptr} <= 0;
// else {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
// endmodule

// module sync_w2r #(parameter ADDRSIZE = 3)
// (output reg [ADDRSIZE:0] rq2_wptr,
// input [ADDRSIZE:0] wptr,
// input rclk, rrst_n);
// reg [ADDRSIZE:0] rq1_wptr;
// always @(posedge rclk or negedge rrst_n)
// if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
// else 
// {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
// endmodule

/*module rptr_empty #(parameter ADDRSIZE = 4)
(output reg rempty,
output [ADDRSIZE-1:0] raddr,
output reg [ADDRSIZE :0] rptr,
input [ADDRSIZE :0] rq2_wptr,
input rinc, rclk, rrst_n);
reg [ADDRSIZE:0] rbin;
wire [ADDRSIZE:0] rgraynext, rbinnext;
//-------------------
// GRAYSTYLE2 pointer
//-------------------
always @(posedge rclk or negedge rrst_n)
if (!rrst_n) {rbin, rptr} <= 0;
else {rbin, rptr} <= {rbinnext, rgraynext};
// Memory read-address pointer (okay to use binary to address memory)
assign raddr = rbin[ADDRSIZE-1:0];
assign rbinnext = rbin + (rinc & ~rempty);
assign rgraynext = (rbinnext>>1) ^ rbinnext;
//---------------------------------------------------------------
// FIFO empty when the next rptr == synchronized wptr or on reset
//---------------------------------------------------------------
assign rempty_val = (rgraynext == rq2_wptr);
always @(posedge rclk or negedge rrst_n)
if (!rrst_n) rempty <= 1'b1;
else rempty <= rempty_val;
endmodule*/

module rptr_empty_medac #(parameter ADDRSIZE = 3)
(output rempty_n,
output [ADDRSIZE-1:0] raddr,
output  [ADDRSIZE :0] rptr,
input [ADDRSIZE :0] rq2_wptr,
input rinc, rclk, rrst_n);
//reg [ADDRSIZE:0] rbin;
wire [ADDRSIZE:0] rbin;
wire [ADDRSIZE:0] rbinnext;
wire [ADDRSIZE:0] rgraynext;
wire [ADDRSIZE:0] rbin_bak;
wire rempty_bak;
//wire [ADDRSIZE:0] rbin_dummy;
//wire rempty_dummy;
//wire [ADDRSIZE :0] rq2_wptr_dummy_N;
wire rempty;
genvar i;
generate 
	for(i=0;i<ADDRSIZE+1;i=i+1)
	begin: RPTR_EMPTY
		REG REG_RBIN(rclk,rrst_n,rbinnext[i],rbin[i]);

		//REG REG_RPTR(rclk,rrst_n,rgraynext[i],rptr[i]);
		DFQD1BWP30P140 REG_RPTR(.D(rgraynext[i] & rrst_n), .CP(rclk), .Q(rptr[i]));

		//REG REG_RBIN_BAK(rclk,rrst_n,rbin[i],rbin_bak[i]);
		//PLATCH PLATCH_RPTR(rclk,rrst_n,rbinnext[i],rptr[i]);
		//NLATCH NLATCH_RBIN_DUMMY(rclk,rrst_n,rbin[i],rbin_dummy[i]);
		//NLATCH NLATCH_rq2_wptr(rclk,rrst_n,rq2_wptr[i],rq2_wptr_dummy_N[i]);
	end
endgenerate
REG_SET REG_EMPTY(rclk,rrst_n,rempty_val,rempty);
//REG_SET REG_EMPTY_BAK(rclk,rrst_n,rempty,rempty_bak);
//NLATCH_SET NLATCH_EMPTY_DUMMY(rclk,rrst_n,rempty,rempty_dummy);
/*always @(posedge rclk or negedge rrst_n)
if (!rrst_n) {rbin, rptr} <= 0;
else {rbin, rptr} <= {rbinnext, rbinnext};*/
// Memory read-address pointer (okay to use binary to address memory)
assign raddr = rbin[ADDRSIZE-1:0];
// assign rptr  = rbin;
//assign rbinnext = (rdec == 1'b1) ?(rbin - 1'd1):(rbin + (rinc & ~rempty));
//assign rbinnext = (rdec4 == 1'b1) ?(rbin - 3'd4):(rdec3 == 1'b1)?(rbin - 2'd3):(rbin + (rinc & ~rempty));
assign rbinnext = (rbin + (rinc & ~rempty));
assign rgraynext = (rbinnext>>1) ^ rbinnext;


reg     [ADDRSIZE:0]    rgraynext_reg;
always @(posedge rclk) rgraynext_reg <= rgraynext;

//assign rempty_val = (rbinnext == rq2_wptr);
assign rempty_val = (rgraynext == rq2_wptr);
wire rempty_val2 = (rgraynext == rq2_wptr)||(rgraynext_reg == rq2_wptr);

//assign rbinnext = (rbin_dummy + (rinc & ~rempty_dummy));
//assign rempty_val = (rbinnext == rq2_wptr_dummy_N);
//assign rbinnext = (edac == 1'b1) ? rbin_bak : (rbin + (rinc & ~rempty));
//assign rempty_val = (edac == 1'b1) ? rempty_bak : (rbinnext == rq2_wptr);
/*always @(posedge rclk or negedge rrst_n)
if (!rrst_n) rempty <= 1'b1;
else rempty <= rempty_val;*/
    reg rinc_d;
    always @(posedge rclk ) begin
        rinc_d <= rinc;
    end

    assign rempty_n = ~rempty && rinc;
endmodule

/*module wptr_full #(parameter ADDRSIZE = 4)
(output reg wfull,
output [ADDRSIZE-1:0] waddr,
output reg [ADDRSIZE :0] wptr,
input [ADDRSIZE :0] wq2_rptr,
input winc, wclk, wrst_n);
reg [ADDRSIZE:0] wbin;
wire [ADDRSIZE:0] wgraynext, wbinnext;
// GRAYSTYLE2 pointer
always @(posedge wclk or negedge wrst_n)
if (!wrst_n) {wbin, wptr} <= 0;
else {wbin, wptr} <= {wbinnext, wgraynext};
// Memory write-address pointer (okay to use binary to address memory)
assign waddr = wbin[ADDRSIZE-1:0];
assign wbinnext = wbin + (winc & ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;
//------------------------------------------------------------------
// Simplified version of the three necessary full-tests:
// assign wfull_val=((wgnext[ADDRSIZE] !=wq2_rptr[ADDRSIZE] ) &&
// (wgnext[ADDRSIZE-1] !=wq2_rptr[ADDRSIZE-1]) &&
// (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
//------------------------------------------------------------------
assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
wq2_rptr[ADDRSIZE-2:0]});
always @(posedge wclk or negedge wrst_n)
if (!wrst_n) wfull <= 1'b0;
else wfull <= wfull_val;
endmodule*/


module wptr_full_medac #(parameter ADDRSIZE = 3)
(output reg wfull,
//output wfull_pre,
output [ADDRSIZE-1:0] waddr,
output reg [ADDRSIZE :0] wptr,
input [ADDRSIZE :0] wq2_rptr,
input winc, wclk, wrst_n);
reg [ADDRSIZE:0] wbin;
wire [ADDRSIZE:0]  wbinnext, wgraynext;

//always @(posedge wclk or negedge wrst_n)
//if (!wrst_n) {wbin, wptr} <= 0;
//else {wbin, wptr} <= {wbinnext, wgraynext};

always @(posedge wclk or negedge wrst_n)
if (!wrst_n) {wbin} <= 0;
else {wbin} <= {wbinnext};

always @(posedge wclk or negedge wrst_n)
	if  (!wrst_n) {wptr} <= 0;
	else {wptr} <= wgraynext;

// Memory write-address pointer (okay to use binary to address memory)
assign waddr = wbin[ADDRSIZE-1:0];
assign wbinnext = wbin + (winc & ~wfull);
assign wgraynext = (wbinnext>>1) ^ wbinnext;

//assign wfull_val = (wbinnext=={~wq2_rptr[ADDRSIZE],wq2_rptr[ADDRSIZE-1:0]}) ;
wire[ADDRSIZE-1:0] /*wbinnext_add8,wbinnext_add7,wbinnext_add6,wbinnext_add5,wbinnext_add4,wbinnext_add3,*/wbinnext_add2,wbinnext_add1;
//assign wbinnext_add8 = wbinnext[ADDRSIZE-1:0]+4'd8;
//assign wbinnext_add7 = wbinnext[ADDRSIZE-1:0]+4'd7;
//assign wbinnext_add6 = wbinnext[ADDRSIZE-1:0]+4'd6;
//assign wbinnext_add5 = wbinnext[ADDRSIZE-1:0]+4'd5;
//assign wbinnext_add4 = wbinnext[ADDRSIZE-1:0]+4'd4;
//assign wbinnext_add3 = wbinnext[ADDRSIZE-1:0]+4'd3;
//assign wbinnext_add2 = wbinnext[ADDRSIZE-1:0]+4'd2;
//assign wbinnext_add1 = wbinnext[ADDRSIZE-1:0]+4'd1;
assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1], wq2_rptr[ADDRSIZE-2:0]});
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add8}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add7}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add6}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add5}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add4}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add3}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add2}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext_add1}) ||
//(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext[ADDRSIZE-1:0]});
//assign wfull_val =(wq2_rptr == {~wbinnext[ADDRSIZE],wbinnext[ADDRSIZE-1:0]});
//
always @(posedge wclk or negedge wrst_n)
if (!wrst_n) wfull <= 1'b0;
else wfull <= wfull_val;
endmodule
