`timescale 1ns/1ps

module aa_tb ();
    
    parameter DSIZE = 32;
    reg medac_mode;
    reg [DSIZE-1:0] wdata;
    reg [2:0] win_sel;
    // reg [2:0] win_sel_r2w;
    // reg [2:0] win_sel_w2r;
    reg winc, wclk;
    reg rinc, rclk; 
    reg rst_n;
    reg start;
    reg [2:0] delay_sel_d1;
    reg [2:0] delay_sel_d2;
    wire clkout;
    wire [31:0] error_origin_cnt;
    wire [31:0] cycle_cnt;
    
    wire [DSIZE-1:0] rdata;
    wire wfull;
    wire rempty_n;
    wire error_w;
    wire error_r;
    wire [31:0] error_origin_cnt_w;
    wire [31:0] error_ptr_cnt_w;
    wire [31:0] cycle_cnt_w;
    wire [31:0] error_origin_cnt_r;
    wire [31:0] error_ptr_cnt_r;
    wire [31:0] cycle_cnt_r;

    reg [2:0] sync_sel;

    fifo_medac_top #(32, 4) fifo_medac_top (
        .medac_mode(medac_mode),
        .sync_sel(sync_sel),
        .rdata(rdata),
        .wfull(wfull),
        .rempty_n(rempty_n),
        .error_w(error_w),
        .error_r(error_r),
        .wdata(wdata),
        .win_sel_r2w(win_sel),
        .win_sel_w2r(win_sel),
        .winc(winc), 
        .wclk(wclk),
        .rinc(rinc), 
        .rclk(rclk), 
        .rst_n(rst_n),
        .start(start),
        .delay_sel_d1_r(delay_sel_d1),
        .delay_sel_d2_r(delay_sel_d2),
        .delay_sel_d1_w(delay_sel_d1),
        .delay_sel_d2_w(delay_sel_d2),
        .error_origin_cnt_w(error_origin_cnt_w),
        .error_ptr_cnt_w(error_ptr_cnt_w),
        .cycle_cnt_w(cycle_cnt_w),
        .error_origin_cnt_r(error_origin_cnt_r),
        .error_ptr_cnt_r(error_ptr_cnt_r)
        // .cycle_cnt_r(cycle_cnt_r)
    );


    parameter period1 = 10;
    parameter period2 = 19.99;


    always #(period1/2.0) wclk = ~wclk;
    always #(period2/2.0) rclk = ~rclk;


    always @(posedge wclk) begin
        if (winc && !wfull) wdata = wdata + 1;
    end

    initial begin
        wclk = 0;
        rclk = 0;
        win_sel = 3'b0;
        delay_sel_d1 = 3'b0;
        delay_sel_d2 = 3'b0;
        rst_n = 0;
        start = 0;
        wdata = 0;
        winc = 0;
        rinc = 0;
        medac_mode = 1;
        sync_sel = 3'b011;

        #(10*period2) rst_n = 1;
        #(10*period2) 
        winc = 1;
        rinc = 1;
        start = 1;

        #(10000*period1)
        medac_mode = 0;
    end


endmodule