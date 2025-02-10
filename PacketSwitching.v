
module PacketSwitching #(
    parameter DEPTH=4,
    parameter DATASIZE=40  //src:4bit, dst:4bit, timestamp:8bit, data:22bit, type:2bit
  )(
    input   wire [3:0] ID,
    input 	wire	clk_L, // PE Clk
    input   wire  clk, // All Router Clk
    // input   wire  clk_N, 
    // input   wire  clk_S,
    // input   wire  clk_E,
    // input   wire  clk_W,
    input 	wire	rst_n,

    input	wire	[DATASIZE-1:0]	N_data_in,
    input	wire	[DATASIZE-1:0]	S_data_in,
    input	wire	[DATASIZE-1:0]	E_data_in,
    input	wire	[DATASIZE-1:0]	W_data_in,
    input	wire	[DATASIZE-1:0]	L_data_in,

    output	wire	[DATASIZE-1:0]	N_data_out,
    output	wire	[DATASIZE-1:0]	S_data_out,
    output	wire	[DATASIZE-1:0]	E_data_out,
    output	wire	[DATASIZE-1:0]	W_data_out,
    output	wire	[DATASIZE-1:0]	L_data_out,
    
    input	wire	N_valid_in,
    input	wire	S_valid_in,
    input	wire	E_valid_in,
    input	wire	W_valid_in,
    input	wire	L_valid_in,
    
    output	wire	N_valid_out,
    output	wire	S_valid_out,
    output	wire	E_valid_out,
    output	wire	W_valid_out,
    output	wire	L_valid_out,


    output  wire [3:0] L_label,
    output  wire [3:0] N_label,
    output  wire [3:0] E_label,
    output  wire [3:0] S_label,
    output  wire [3:0] W_label,

    output wire L_infifo_winc,
    output wire N_infifo_winc,
    output wire E_infifo_winc,
    output wire S_infifo_winc,
    output wire W_infifo_winc,

    output wire [4:0] L_arb_res,
    output wire [4:0] N_arb_res,
    output wire [4:0] E_arb_res,
    output wire [4:0] S_arb_res,
    output wire [4:0] W_arb_res,

    output wire L_outfifo_winc,
    output wire E_outfifo_winc,
    output wire S_outfifo_winc,
    output wire W_outfifo_winc,
    output wire N_outfifo_winc,

    input wire L_infifo_wfull,
    input wire E_infifo_wfull,
    input wire S_infifo_wfull,
    input wire W_infifo_wfull,
    input wire N_infifo_wfull,

    input wire L_outfifo_wfull,
    input wire E_outfifo_wfull,
    input wire S_outfifo_wfull,
    input wire W_outfifo_wfull,
    input wire N_outfifo_wfull,


    input	wire	N_full_in,
    input	wire	S_full_in,
    input	wire	E_full_in,
    input	wire	W_full_in,
    input wire  L_full_in,

    output	wire	N_full_out,
    output	wire	S_full_out,
    output	wire	E_full_out,
    output	wire	W_full_out,
    output  wire  full,

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


  wire	[DATASIZE-1:0]  L_data_out_fifo;
  wire	[DATASIZE-1:0]  W_data_out_fifo;
  wire	[DATASIZE-1:0]  N_data_out_fifo;
  wire	[DATASIZE-1:0]  E_data_out_fifo;
  wire	[DATASIZE-1:0]  S_data_out_fifo;

  wire	L_valid_out_fifo;
  wire	W_valid_out_fifo;
  wire	N_valid_out_fifo;
  wire	E_valid_out_fifo;
  wire	S_valid_out_fifo;

  wire	L_valid_out_rc;
  wire	W_valid_out_rc;
  wire	N_valid_out_rc;
  wire	E_valid_out_rc;
  wire	S_valid_out_rc;

  wire  L_ready;
  wire  W_ready;
  wire  N_ready;
  wire  E_ready;
  wire  S_ready;

  wire fifo_ready_L;
  wire fifo_ready_W;
  wire fifo_ready_N;
  wire fifo_ready_E;
  wire fifo_ready_S;


  fifo	#(
      .DEPTH(DEPTH),
      .DATASIZE(DATASIZE)
      ) fifo(
  		.N_data_out(N_data_out_fifo),
  		.N_valid_out(N_valid_out_fifo),
  		.N_full_out(N_full_out),
  		.N_data_in(N_data_in),
  		.N_valid_in(N_valid_in),
  		.fifo_ready_N(fifo_ready_N),

      .E_data_out(E_data_out_fifo),
      .E_valid_out(E_valid_out_fifo),
      .E_full_out(E_full_out),
      .E_data_in(E_data_in),
      .E_valid_in(E_valid_in),
      .fifo_ready_E(fifo_ready_E),

      .S_data_out(S_data_out_fifo),
      .S_valid_out(S_valid_out_fifo),
      .S_full_out(S_full_out),
      .S_data_in(S_data_in),
      .S_valid_in(S_valid_in),
      .fifo_ready_S(fifo_ready_S),

      .W_data_out(W_data_out_fifo),
      .W_valid_out(W_valid_out_fifo),
      .W_full_out(W_full_out),
      .W_data_in(W_data_in),
      .W_valid_in(W_valid_in),
      .fifo_ready_W(fifo_ready_W),

      .L_data_out(L_data_out_fifo),
      .L_valid_out(L_valid_out_fifo),
      .L_full_out(full),
      .L_data_in(L_data_in),
      .L_valid_in(L_valid_in),
      .fifo_ready_L(fifo_ready_L),
  
      .clk(clk),
      .clk_L(clk_L),
      // .clk_N(clk_N),
      // .clk_S(clk_S),
      // .clk_E(clk_E),
      // .clk_W(clk_W),
      .rst_n(rst_n)
  );


    // wire[3:0] L_label;
    // wire[3:0] N_label;
    // wire[3:0] E_label;
    // wire[3:0] S_label;
    // wire[3:0] W_label;

    wire  [DATASIZE-1:0]  L_data_out_rc;
    wire  [DATASIZE-1:0]  W_data_out_rc;
    wire  [DATASIZE-1:0]  N_data_out_rc;
    wire  [DATASIZE-1:0]  E_data_out_rc;
    wire  [DATASIZE-1:0]  S_data_out_rc;

   rc#(
      .DATASIZE(DATASIZE)
      ) RC(
      .ID(ID),
      
      .data_out_1(N_data_out_rc),
      .direction_out_1(N_label),
      .N_infifo_winc(N_infifo_winc),
      .N_data_in(N_data_out_fifo),
      .N_valid_in(N_valid_out_fifo),
      .N_valid_out(N_valid_out_rc),
      .rc_ready_N(N_ready),
      .N_infifo_wfull(N_infifo_wfull),
      .fifo_ready_N(fifo_ready_N),
  
      .data_out_2(E_data_out_rc),
      .direction_out_2(E_label),
      .E_infifo_winc(E_infifo_winc),
      .E_data_in(E_data_out_fifo),
      .E_valid_in(E_valid_out_fifo),
      .E_valid_out(E_valid_out_rc),
      .rc_ready_E(E_ready),
      .E_infifo_wfull(E_infifo_wfull),
      .fifo_ready_E(fifo_ready_E),
      
      .data_out_3(W_data_out_rc),
      .direction_out_3(W_label),
      .W_infifo_winc(W_infifo_winc),
      .W_data_in(W_data_out_fifo),
      .W_valid_in(W_valid_out_fifo),
      .W_valid_out(W_valid_out_rc),
      .rc_ready_W(W_ready),
      .W_infifo_wfull(W_infifo_wfull),
      .fifo_ready_W(fifo_ready_W),

      .data_out_4(S_data_out_rc),
      .direction_out_4(S_label),
      .S_infifo_winc(S_infifo_winc),
      .S_data_in(S_data_out_fifo),
      .S_valid_in(S_valid_out_fifo),
      .S_valid_out(S_valid_out_rc),
      .rc_ready_S(S_ready),
      .S_infifo_wfull(S_infifo_wfull),
      .fifo_ready_S(fifo_ready_S),

      .data_out_5(L_data_out_rc),
      .direction_out_5(L_label),
      .L_infifo_winc(L_infifo_winc),
      .L_data_in(L_data_out_fifo),
      .L_valid_in(L_valid_out_fifo),
      .L_valid_out(L_valid_out_rc),
      .rc_ready_L(L_ready),
      .L_infifo_wfull(L_infifo_wfull),
      .fifo_ready_L(fifo_ready_L),

      .rc_clk(clk),
      .rst_n(rst_n)
  );



   SA#(
      .DATASIZE(DATASIZE)
  ) SA(
    .clk(clk),
    .rst_n(rst_n),

    .L_label(L_label),
    .W_label(W_label),
    .N_label(N_label),
    .E_label(E_label),
    .S_label(S_label),

    .L_data_in(L_data_out_rc),
    .W_data_in(W_data_out_rc),
    .N_data_in(N_data_out_rc),
    .E_data_in(E_data_out_rc),
    .S_data_in(S_data_out_rc),

    .L_valid_in(L_valid_out_rc),
    .W_valid_in(W_valid_out_rc),
    .N_valid_in(N_valid_out_rc),
    .E_valid_in(E_valid_out_rc),
    .S_valid_in(S_valid_out_rc),


    .N_full(N_full_in),
    .S_full(S_full_in),
    .E_full(E_full_in),
    .W_full(W_full_in),
    .L_full(L_full_in),

    .N_ready(N_ready),
    .W_ready(W_ready),
    .E_ready(E_ready),
    .S_ready(S_ready),
    .L_ready(L_ready),


    .L_data_valid(L_valid_out),
    .W_data_valid(W_valid_out),
    .N_data_valid(N_valid_out),
    .E_data_valid(E_valid_out),
    .S_data_valid(S_valid_out),

    .L_data_out(L_data_out),
    .E_data_out(E_data_out),
    .S_data_out(S_data_out),
    .W_data_out(W_data_out),
    .N_data_out(N_data_out),

    .L_arb_res(L_arb_res),
    .E_arb_res(E_arb_res),
    .S_arb_res(S_arb_res),
    .W_arb_res(W_arb_res),
    .N_arb_res(N_arb_res),

    .L_outfifo_winc(L_outfifo_winc),
    .E_outfifo_winc(E_outfifo_winc),
    .S_outfifo_winc(S_outfifo_winc),
    .W_outfifo_winc(W_outfifo_winc),
    .N_outfifo_winc(N_outfifo_winc),

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