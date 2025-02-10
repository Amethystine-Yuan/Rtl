
module	SA#(
  parameter DATASIZE=40  //src:4bit, dst:4bit, timestamp:8bit, data:22bit, type:2bit
  )(
	input	wire	clk,
	input	wire	rst_n,


	input	wire[3:0]	L_label,
	input	wire[3:0]	N_label,
	input	wire[3:0]	E_label,
	input	wire[3:0]	S_label,
	input	wire[3:0]	W_label,


	input	wire[DATASIZE-1:0]	L_data_in,
	input	wire[DATASIZE-1:0]	E_data_in,
	input	wire[DATASIZE-1:0]	S_data_in,
	input	wire[DATASIZE-1:0]	W_data_in,
	input	wire[DATASIZE-1:0]	N_data_in,


	input	wire	L_valid_in,
	input	wire	E_valid_in,
	input	wire	S_valid_in,
	input	wire	W_valid_in,
	input	wire	N_valid_in,

	input	wire	N_full,
	input	wire	S_full,
	input	wire	E_full,
	input	wire	W_full,
	input   wire    L_full,

	output	wire	N_ready,
	output	wire	S_ready,
	output	wire	E_ready,
	output	wire	W_ready,
	output	wire	L_ready,

	output	wire	L_data_valid,
	output	wire	E_data_valid,
	output	wire	S_data_valid,
	output	wire	W_data_valid,
	output	wire	N_data_valid,

	output	wire[DATASIZE-1:0]	L_data_out,
	output	wire[DATASIZE-1:0]	E_data_out,
	output	wire[DATASIZE-1:0]	S_data_out,
	output	wire[DATASIZE-1:0]	W_data_out,
	output	wire[DATASIZE-1:0]	N_data_out,


	output wire [4:0] L_arb_res,
	output wire [4:0] E_arb_res,
	output wire [4:0] S_arb_res,
	output wire [4:0] W_arb_res,
	output wire [4:0] N_arb_res,

	output wire L_outfifo_winc,
	output wire E_outfifo_winc,
	output wire S_outfifo_winc,
	output wire W_outfifo_winc,
	output wire N_outfifo_winc,

	input wire L_outfifo_wfull,
	input wire E_outfifo_wfull,
	input wire S_outfifo_wfull,
	input wire W_outfifo_wfull,
	input wire N_outfifo_wfull,

	input   wire  L_outfifo_rclk_sync,
	input   wire  W_outfifo_rclk_sync,
	input   wire  N_outfifo_rclk_sync,
	input   wire  E_outfifo_rclk_sync,
	input   wire  S_outfifo_rclk_sync,

	input   wire [4:0] L_outfifo_rdata_sync,
	input   wire [4:0] W_outfifo_rdata_sync,
	input   wire [4:0] N_outfifo_rdata_sync,
	input   wire [4:0] E_outfifo_rdata_sync,
	input   wire [4:0] S_outfifo_rdata_sync


  );


  // wire[4:0]		L_arb_res;
	// wire[4:0]		E_arb_res;
	// wire[4:0]		S_arb_res;
	// wire[4:0]		W_arb_res;
	// wire[4:0]		N_arb_res;

	wire[4:0]		grant_L;
	wire[4:0]		grant_N;
	wire[4:0]		grant_S;
	wire[4:0]		grant_W;
	wire[4:0]		grant_E;


  	arbiter5 arbiterL(
		.clk(clk),
		.rst_n(rst_n),
		.grant(grant_L),
		.arbitration(L_arb_res),
		.outfifo_wfull(L_outfifo_wfull)
		);

  	arbiter5 arbiterW(
		.clk(clk),
		.rst_n(rst_n),
		.grant(grant_W),
		.arbitration(W_arb_res),
		.outfifo_wfull(W_outfifo_wfull)
		);

  	arbiter5 arbiterN(
		.clk(clk),
		.rst_n(rst_n),
		.grant(grant_N),
		.arbitration(N_arb_res),
		.outfifo_wfull(N_outfifo_wfull)
		);

  	arbiter5 arbiterE(
		.clk(clk),
		.rst_n(rst_n),
		.grant(grant_E),
		.arbitration(E_arb_res),
		.outfifo_wfull(E_outfifo_wfull)
		);

  	arbiter5 arbiterS(
		.clk(clk),
		.rst_n(rst_n),
		.grant(grant_S),
		.arbitration(S_arb_res),
		.outfifo_wfull(S_outfifo_wfull)
		);



  	switch_alloc	#(
    	.DATASIZE(DATASIZE)
    	) switch_alloc(

		.clk(clk),
		.rst_n(rst_n),
  
		.L_label(L_label),
		.N_label(N_label),
		.E_label(E_label),
		.S_label(S_label),
		.W_label(W_label),


		.L_data_in(L_data_in),
		.W_data_in(W_data_in),
		.N_data_in(N_data_in),
		.E_data_in(E_data_in),
		.S_data_in(S_data_in),

		.L_valid_in(L_valid_in),
		.W_valid_in(W_valid_in),
		.N_valid_in(N_valid_in),
		.E_valid_in(E_valid_in),
		.S_valid_in(S_valid_in),

		.N_full(N_full),
		.S_full(S_full),
		.E_full(E_full),
		.W_full(W_full),
		.L_full(L_full),


		.L_arb_res(L_arb_res),
		.E_arb_res(E_arb_res),
		.S_arb_res(S_arb_res),
		.W_arb_res(W_arb_res),
		.N_arb_res(N_arb_res),

		.L_outfifo_winc(L_outfifo_winc),
		.W_outfifo_winc(W_outfifo_winc),
		.N_outfifo_winc(N_outfifo_winc),
		.E_outfifo_winc(E_outfifo_winc),
		.S_outfifo_winc(S_outfifo_winc),

		.grant_L(grant_L),
		.grant_N(grant_N),
		.grant_S(grant_S),
		.grant_W(grant_W),
		.grant_E(grant_E),

		.N_ready(N_ready),
		.L_ready(L_ready),
		.E_ready(E_ready),
		.S_ready(S_ready),
		.W_ready(W_ready),

		.L_data_valid(L_data_valid),
		.W_data_valid(W_data_valid),
		.N_data_valid(N_data_valid),
		.E_data_valid(E_data_valid),
		.S_data_valid(S_data_valid),


		.L_data_out(L_data_out),
		.W_data_out(W_data_out),
		.N_data_out(N_data_out),
		.E_data_out(E_data_out),
		.S_data_out(S_data_out),

		.L_outfifo_wfull(L_outfifo_wfull),
    .E_outfifo_wfull(E_outfifo_wfull),
    .S_outfifo_wfull(S_outfifo_wfull),
    .W_outfifo_wfull(W_outfifo_wfull),
    .N_outfifo_wfull(N_outfifo_wfull),

		.L_outfifo_rclk_sync(L_outfifo_rclk_sync),
    .E_outfifo_rclk_sync(E_outfifo_rclk_sync),
    .S_outfifo_rclk_sync(S_outfifo_rclk_sync),
    .W_outfifo_rclk_sync(W_outfifo_rclk_sync),
    .N_outfifo_rclk_sync(N_outfifo_rclk_sync),

    .L_outfifo_rdata_sync(L_outfifo_rdata_sync),
    .E_outfifo_rdata_sync(E_outfifo_rdata_sync),
    .S_outfifo_rdata_sync(S_outfifo_rdata_sync),
    .W_outfifo_rdata_sync(W_outfifo_rdata_sync),
    .N_outfifo_rdata_sync(N_outfifo_rdata_sync)
		
    );

endmodule