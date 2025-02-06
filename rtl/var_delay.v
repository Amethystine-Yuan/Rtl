`timescale 1ns/1ps

module var_delay (
    input din,
    input [3:0] delay_sel,
    output reg dout
);
    
    // /* below for simulation */
    always @(din) 
        #0.1 dout = din;
    // assign dout = din;
    // /* above for simulation */


    /* below for synthesis */
    // wire [2:0] delay_selb;
	// assign delay_selb = ! delay_sel;
	// wire dinb;

    // var_delay_cell var_delay_cell0 (
    //     // .VDD(), .VSS(),
    //     .S0(delay_sel[0]), .S1(delay_sel[1]), .S2(delay_sel[2]),
    //     .S0b(delay_selb[0]), .S1b(delay_selb[1]), .S2b(delay_selb[2]),
    //     .din(din), .dout(dinb)
    // );
    // var_delay_cell var_delay_cell1 (
    //     // .VDD(), .VSS(),
    //     .S0(delay_sel[0]), .S1(delay_sel[1]), .S2(delay_sel[2]),
    //     .S0b(delay_selb[0]), .S1b(delay_selb[1]), .S2b(delay_selb[2]),
    //     .din(dinb), .dout(dout)
    // );
    /* above for synthesis */
endmodule
