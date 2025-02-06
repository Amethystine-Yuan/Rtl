`timescale 1ns/1ps

module medac (
    input clkin,
    input clk,
	input clk_cnt,
    input rst_n,
    input start,
    input error_ptr,
    input mode, // 1 for medac on; 0 for medac off
    input [3:0] win_sel,
    // input [2:0] delay_sel_d1,
    // input [2:0] delay_sel_d2,
    input [3:0] var_clk_sel_origin,
    input [3:0] var_clk_sel_leading,
    // input [3:0] var_clk_sel_lagging,
    output clkout,
    output [31:0] error_origin_cnt,
    output [31:0] error_ptr_cnt
    //output [31:0] cycle_cnt
);

	// wire clk_origin, clk_leading, clk_lagging;
    wire clk_origin, clk_leading;
    // wire error_origin, error_leading, error_lagging;
    wire error_origin, error_leading;
    // wire [1:0] clk_sel;
    wire clk_sel;

    /* clock division  */
    wire clkin_div, clkin_divb;
    INVD1BWP30P140 clkinv (.I(clkin_div), .ZN(clkin_divb));
    DFCNQD4BWP30P140LVT clkdiv (.D(clkin_divb), .CP(clkin), .CDN(rst_n), .Q(clkin_div));
    //DFQD4BWP30P140 clkdiv (.D(clkin_divb), .CP(clkin), .Q(clkin_div));

    /* metastabiity detectors */
    meta_detector md_origin (
        .clkin(clkin_div),
        .clk(clk_origin),
        .rst_n(rst_n),
        .win_sel(win_sel),
        .error(error_origin));
    meta_detector md_leading (
        .clkin(clkin_div),
        .clk(clk_leading),
        .rst_n(rst_n),
        .win_sel(win_sel),
        .error(error_leading));
    // meta_detector md_lagging (
    //     .clkin(clkin_div),
    //     .clk(clk_lagging),
    //     .rst_n(rst_n),
    //     .win_sel(win_sel),
    //     .error(error_lagging));

    var_delay d1 (
        .din(clk),
        .delay_sel(var_clk_sel_leading),
        .dout(clk_leading)
        //.dout(clk_leading_tobuf)
    );
    var_delay d2 (
        .din(clk_leading),
        .delay_sel(var_clk_sel_origin),
        .dout(clk_origin)
        //.dout(clk_origin_tobuf)
    );
    // var_delay d3 (
    //     .din(clk_origin),
    //     .delay_sel(var_clk_sel_lagging),
    //     .dout(clk_lagging)
    //     //.dout(clk_lagging_tobuf)
    // );
	
    // /* d1 for leading phase detection */
    // var_delay d1 (
    //     .din(clkin_div),
    //     .delay_sel(delay_sel_d1),
    //     .dout(clkin_div_delay)
    // );

    // /* d2 for lagging phase detection */
    // var_delay d2 (
    //     .din(clk),
    //     .delay_sel(delay_sel_d2),
    //     .dout(clk_delay)
    // );
    // var_delay d3 (
    //     .din(clk_delay),
    //     .delay_sel(delay_sel_d2),
    //     .dout(clk_delay2)
    // );

    /* ctrl */
	// BUFFD4BWP30P140LVT clk_lagging_buffer (.I(clk_lagging), .Z(clk_lagging_buf));
    BUFFD4BWP30P140LVT clk_origin_buffer (.I(clk_origin), .Z(clk_origin_buf));
    ctrl ctrl (
        // .clk(clk),
        // .clk(clk_lagging_buf),
        .clk(clk_origin_buf),
        .rst_n(rst_n),
        .error_origin(error_origin),
        .error_leading(error_leading),
        // .error_lagging(error_lagging),
        .clk_sel(clk_sel)
    );

    var_delay_clk dclk (
        .din(clk_leading),
        .mode(mode),
        .delay_sel(clk_sel),
        .var_clk_sel_origin(var_clk_sel_origin),
        .var_clk_sel_leading(var_clk_sel_leading),
        // .var_clk_sel_lagging(var_clk_sel_lagging),
        .dout(clkout)
    );

    /* statistics */
    counter err_cnt (
        .din(error_origin),
        .start(start),
        .clk(clk_cnt),
        .rst_n(rst_n),
        .cnt(error_origin_cnt),
		.cnt_full()
    );

    // counter clk_cnt (
    //     .din(1'b1),
    //     .start(start),
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .cnt(cycle_cnt)
    // );

    counter err_ptr_cnt (
        .din(error_ptr),
        .start(start),
        .clk(clk_cnt),
        .rst_n(rst_n),
        .cnt(error_ptr_cnt),
		.cnt_full()
    );



endmodule
