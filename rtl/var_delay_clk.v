`timescale 1ns/1ps

module var_delay_clk (
    input din,
    input mode,
    input delay_sel, // from ctrl, select proper configuration ('0'=leading/'1'=origin/'2'=lagging)
    input [3:0] var_clk_sel_origin,  // from scan in, configuration for origin phase
    input [3:0] var_clk_sel_leading, // from scan in, configuration for leading phase
    // input [3:0] var_clk_sel_lagging, // from scan in, configuration for lagging phase
    output reg dout
);

    // /* below for simualtion */
    reg din1;
    reg din2;
    // reg din3;
    reg dout_sel;

    always @(din) begin
        // $display("din is changing at %d ns, din is %b", $time, din);
        din1 = din;
        #0.1 din2 = din;
        // #0.1 din3 = din;
    end
    
    always @(*) begin
        case (delay_sel)
            1'd0 : dout_sel = din1;
            1'd1 : dout_sel = din2;
            //2'd2 : dout_sel = din3;
            default: dout_sel = din2;
        endcase
    end

    always @(*) begin
        if (mode)
            dout = dout_sel;
        else
            dout = din2;
    end
    // /* above for simulation */


    /* below for synthesis */
    // reg [2:0] var_delay_sel;
    // reg [2:0] var_delay_selb;
	// wire dinb;

    // always @(*) begin
    //     case ({mode, delay_sel})
	// 		3'b000 : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //         3'b001 : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //         3'b010 : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //         3'b011 : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //         3'b100 : begin
    //             var_delay_sel = var_clk_sel_leading;
    //             var_delay_selb = ! var_clk_sel_leading;
    //         end
    //         3'b101 : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //         3'b110 : begin
    //             var_delay_sel = var_clk_sel_lagging;
    //             var_delay_selb = ! var_clk_sel_lagging;
    //         end
    //         default : begin
    //             var_delay_sel = var_clk_sel_origin;
    //             var_delay_selb = ! var_clk_sel_origin;
    //         end
    //     endcase
    // end

    // var_delay_cell var_delay_cell0 (
    //     // .VDD(), .VSS(),
    //     .S0(var_delay_sel[0]), .S1(var_delay_sel[1]), .S2(var_delay_sel[2]),
    //     .S0b(var_delay_selb[0]), .S1b(var_delay_selb[1]), .S2b(var_delay_selb[2]),
    //     .din(din), .dout(dinb)
    // );
    // var_delay_cell var_delay_cell1 (
    //     // .VDD(), .VSS(),
    //     .S0(var_delay_sel[0]), .S1(var_delay_sel[1]), .S2(var_delay_sel[2]),
    //     .S0b(var_delay_selb[0]), .S1b(var_delay_selb[1]), .S2b(var_delay_selb[2]),
    //     .din(dinb), .dout(dout)
    // );
    /* above for synthesis */

    
endmodule
