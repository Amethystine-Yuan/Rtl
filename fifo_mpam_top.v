
module fifo_mpam_top #(parameter DEPTH = 8, parameter DATASIZE=40) (
    output [DATASIZE-1 :0] rdata,
    output wfull,
    output rempty_n,
    input [DATASIZE-1 :0] wdata,
    input winc, wclk,
    input rinc, rclk, rst_n);

    // traditional fifo
    FIFO_async2 #(DATASIZE, DEPTH) fifo (
		.rdata(rdata),
        .wfull(wfull),
        .rempty_n(rempty_n),
        .wdata(wdata),
        .winc(winc), .wclk(wclk),
        .rinc(rinc), .rclk(rclk),
        .rst_n(rst_n));

    // mpam-based fifo
    // wire [DATASIZE-1 :0] rdata_medac;
    // wire wfull_medac;
    // wire rempty_n_medac;
    // fifo_medac_top #(DATASIZE, DEPTH) fifo_medac (
    //     .medac_mode(1'b1),
    //     .sync_sel(3'b000),

		//     .rdata(rdata),
    //     .wfull(wfull),
    //     .rempty_n(rempty_n),
    //     .wdata(wdata),
    //     .winc(winc), .wclk(wclk),
    //     .rinc(rinc), .rclk(rclk),
    //     .rst_n(rst_n));

endmodule
