`timescale 1ns/1ps

module sync (
    input clk,
    input rst_n,
    input din,
    output dout
);
    wire d1;

    DFCNQD1BWP30P140 dff1 (.D(din),    .CP(clk),    .CDN(rst_n),    .Q(d1));
    DFCNQD1BWP30P140 dff2 (.D(d1),    .CP(clk),    .CDN(rst_n),    .Q(dout));

endmodule

module sync_shadow (
    input clk,
    input clkd,
    input rst_n,
    input din,
    output dout
);
    wire d1;
    wire dm1, dm2, dm3, dm4;
    
    DFCNQD1BWP30P140 dff1 (.D(din),    .CP(clkd),    .CDN(rst_n),    .Q(d1));
    DFCNQD1BWP30P140 dff2 (.D(d1),    .CP(clk),    .CDN(rst_n),    .Q(dout));
    DFCNQD1BWP30P140 dff_dm1 (.D(1'b0),    .CP(clkd),    .CDN(rst_n),    .Q(dm1));
    DFCNQD1BWP30P140 dff_dm2 (.D(1'b0),    .CP(clkd),    .CDN(rst_n),    .Q(dm2));
    DFCNQD1BWP30P140 dff_dm3 (.D(1'b0),    .CP(clkd),    .CDN(rst_n),    .Q(dm3));
    DFCNQD1BWP30P140 dff_dm4 (.D(1'b0),    .CP(clkd),    .CDN(rst_n),    .Q(dm4));

endmodule


module meta_detector (
    input clkin,
    input clk,
    input rst_n,
    input [3:0] win_sel,
    output error
);
    // /* below for simulation */
    // assign clkd = clk; // to be modified
    reg clkd;
    always @(clk) begin
        #0.05 clkd = clk;
        // #0.1 clkd = clk;
    end

    //New 
    reg clkin_d;
    always @(clkin) begin
        #0.025 clkin_d = clkin;
        // #0.05 clkd = clk;
    end
    // /* above for simulation */

    /* below for synthesis */
    // reg [2:0] win_selb;
	// wire dinb;

	// always @(*)
	// 	win_selb = ! win_sel;

    // var_delay_cell var_delay_cell0 (
    //     // .VDD(), .VSS(),
    //     .S0(win_sel[0]), .S1(win_sel[1]), .S2(win_sel[2]),
    //     .S0b(win_selb[0]), .S1b(win_selb[1]), .S2b(win_selb[2]),
    //     .din(clk), .dout(dinb)
    // );
    // var_delay_cell var_delay_cell1 (
    //     // .VDD(), .VSS(),
    //     .S0(win_sel[0]), .S1(win_sel[1]), .S2(win_sel[2]),
    //     .S0b(win_selb[0]), .S1b(win_selb[1]), .S2b(win_selb[2]),
    //     .din(dinb), .dout(clkd)
    // );
    /* above for synthesis */

    

    sync sync1 (.clk(clk),  .rst_n(rst_n), .din(clkin_d), .dout(dout1));
    sync_shadow sync2 (.clk(clk),  .clkd(clkd), .rst_n(rst_n), .din(clkin_d), .dout(dout2));
    XOR2D0BWP30P140 xor1 (.A1(dout1), .A2(dout2), .Z(error));

endmodule
