`timescale 1ns/1ps

module fifo_medac_top #(parameter DSIZE = 40, parameter ASIZE = 4) (
    output [DSIZE-1:0] rdata,
    output wfull,
    output rempty_n,
    output error_w,
    output error_r,
    input medac_mode,
	input [2:0] sync_sel,
    input [DSIZE-1:0] wdata,
    input [3:0] win_sel_r2w,
    input [3:0] win_sel_w2r,
    input winc, wclk,
    input rinc, rclk, 
	// input rclk_medac, wclk_medac,
	// input clk, rst_n,
    input rst_n,
    input start,
    // input [2:0] delay_sel_d1_r,
    // input [2:0] delay_sel_d2_r,
    // input [2:0] delay_sel_d1_w,
    // input [2:0] delay_sel_d2_w,
    input [3:0] var_clk_sel_origin_r,
    input [3:0] var_clk_sel_leading_r,
    // input [3:0] var_clk_sel_lagging_r,
    input [3:0] var_clk_sel_origin_w,
    input [3:0] var_clk_sel_leading_w,
    // input [3:0] var_clk_sel_lagging_w,
    output [31:0] error_origin_cnt_w,
    output [31:0] error_ptr_cnt_w,
    output [31:0] cycle_cnt_w,
    output [31:0] error_origin_cnt_r,
    output [31:0] error_ptr_cnt_r
    //output [31:0] cycle_cnt_r
);
	// wire error_w, error_r;
	wire wclk_sync, rclk_sync;

	wire cnt_full, start_not_full;
	assign start_not_full = (!cnt_full) & start;

    FIFO_async2_medac #(DSIZE, ASIZE) fifo (
		.sync_sel(sync_sel),
        .rst_n(rst_n),
        .wclk(wclk),
        .wclk_sync(wclk_sync),
		//.wclk_sync(wclk),
        .winc(winc),
        .win_sel_r2w(win_sel_r2w),
        .wdata(wdata),
        .wfull(wfull),
        .error_w(error_w),
        .rclk(rclk),
        .rclk_sync(rclk_sync),
		//.rclk_sync(rclk),
        .rinc(rinc),
        .win_sel_w2r(win_sel_w2r),
        .rdata(rdata),
        .rempty_n(rempty_n),
        .error_r(error_r)
    );

    medac medac_r (
        .clkin(wclk),
        // .clk(rclk_medac),
        .clk(rclk),
		// .clk_cnt(clk),
        .rst_n(rst_n),
        .start(start_not_full),
        .error_ptr(error_r),
        .mode(medac_mode),
        .win_sel(win_sel_w2r),
        // .delay_sel_d1(delay_sel_d1_r),
        // .delay_sel_d2(delay_sel_d2_r),
        .var_clk_sel_origin(var_clk_sel_origin_r),
        .var_clk_sel_leading(var_clk_sel_leading_r),
        // .var_clk_sel_lagging(var_clk_sel_lagging_r),
        .clkout(rclk_sync),
        .error_origin_cnt(error_origin_cnt_r),
        .error_ptr_cnt(error_ptr_cnt_r)
        //.cycle_cnt(cycle_cnt_r)
    );
    medac medac_w (
        .clkin(rclk),
        // .clk(wclk_medac),
		// .clk_cnt(wclk),
        .clk(wclk),
        .rst_n(rst_n),
        .start(start_not_full),
        .error_ptr(error_w),
        .mode(medac_mode),
        .win_sel(win_sel_r2w),
        // .delay_sel_d1(delay_sel_d1_w),
        // .delay_sel_d2(delay_sel_d2_w),
        .var_clk_sel_origin(var_clk_sel_origin_w),
        .var_clk_sel_leading(var_clk_sel_leading_w),
        // .var_clk_sel_lagging(var_clk_sel_lagging_w),
        .clkout(wclk_sync),
        .error_origin_cnt(error_origin_cnt_w),
        .error_ptr_cnt(error_ptr_cnt_w)
        //.cycle_cnt(cycle_cnt_w)
    );

	counter clk_cnt (
		.din(1'b1),
		.start(start),
		.clk(wclk),
		.rst_n(rst_n),
		.cnt(cycle_cnt_w),
		.cnt_full(cnt_full)
	);


endmodule
