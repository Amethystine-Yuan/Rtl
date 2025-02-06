`timescale 1ns/1ps

module tb ();
    
    reg clkin;
    reg clk;
    reg rst_n;
    reg start;
    reg [2:0] win_sel;
    reg [2:0] delay_sel_d1;
    reg [2:0] delay_sel_d2;
    wire clkout;
    wire [31:0] error_origin_cnt;
    wire [31:0] cycle_cnt;
    reg mode;

    medac medac (
        .clkin(clkin),
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .mode(mode),
        .win_sel(win_sel),
        .delay_sel_d1(delay_sel_d1),
        .delay_sel_d2(delay_sel_d2),
        .clkout(clkout),
        .error_origin_cnt(error_origin_cnt),
        .cycle_cnt(cycle_cnt)
    );

    parameter period1 = 10;
    parameter period2 = 19.99;


    always #(period1/2.0) clkin = ~clkin;
    always #(period2/2.0) clk = ~clk;

    initial begin
        clkin = 0;
        clk = 0;
        win_sel = 3'b0;
        delay_sel_d1 = 3'b0;
        delay_sel_d2 = 3'b0;
        rst_n = 0;
        start = 0;
        mode = 1; // medac on

        #(10*period2) rst_n = 1;
        #(10*period2) start = 1;
    end


endmodule