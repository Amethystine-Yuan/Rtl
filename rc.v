
module rc #(
  parameter DATASIZE=40
  )(
  input wire [3:0] ID,

  output wire[DATASIZE-1:0] data_out_1,
  output wire[3:0] direction_out_1,
  output wire N_infifo_winc,
  input wire[DATASIZE-1:0] N_data_in,
  input wire N_valid_in,
  input wire rc_ready_N,
  input wire N_infifo_wfull,
  output wire fifo_ready_N,

  output wire[DATASIZE-1:0] data_out_2,
  output wire[3:0] direction_out_2,
  output wire E_infifo_winc,
  input wire[DATASIZE-1:0] E_data_in,
  input wire E_valid_in,
  input wire rc_ready_E,
  input wire E_infifo_wfull,
  output wire fifo_ready_E,

  output wire[DATASIZE-1:0] data_out_3,
  output wire[3:0] direction_out_3,
  output wire W_infifo_winc,
  input wire[DATASIZE-1:0] W_data_in,
  input wire W_valid_in,
  input wire rc_ready_W,
  input wire W_infifo_wfull,
  output wire fifo_ready_W,

  output wire[DATASIZE-1:0] data_out_4,
  output wire[3:0] direction_out_4,
  output wire S_infifo_winc,
  input wire[DATASIZE-1:0] S_data_in,
  input wire S_valid_in,
  input wire rc_ready_S,
  input wire S_infifo_wfull,
  output wire fifo_ready_S,

  output wire[DATASIZE-1:0] data_out_5,
  output wire[3:0] direction_out_5,
  output wire L_infifo_winc,
  input wire[DATASIZE-1:0] L_data_in,
  input wire L_valid_in,
  input wire rc_ready_L,
  input wire L_infifo_wfull,
  output wire fifo_ready_L,


  output wire L_valid_out,
  output wire W_valid_out,
  output wire S_valid_out,
  output wire N_valid_out,
  output wire E_valid_out,
  

  input wire rc_clk,
  input wire rst_n
  );

  rc_sub #(
    .DATASIZE(DATASIZE)

    ) rc_N (
    .ID(ID),

    .data_out(data_out_1),
    .direction_out(direction_out_1),
    .infifo_winc(N_infifo_winc),
    .data_in(N_data_in),
    .valid_in(N_valid_in),
    .valid_out(N_valid_out),
    .rc_ready(rc_ready_N),
    .infifo_wfull(N_infifo_wfull),
    .fifo_ready(fifo_ready_N),
    
    .rc_clk(rc_clk),
    .rst_n(rst_n)
    );

    rc_sub #(
    .DATASIZE(DATASIZE)

    ) rc_E (
    .ID(ID),
    .data_out(data_out_2),
    .direction_out(direction_out_2),
    .infifo_winc(E_infifo_winc),
    .data_in(E_data_in),
    .valid_in(E_valid_in),
    .valid_out(E_valid_out),
    .rc_ready(rc_ready_E),
    .infifo_wfull(E_infifo_wfull),
    .fifo_ready(fifo_ready_E),
    
    .rc_clk(rc_clk),
    .rst_n(rst_n)
    );

    rc_sub #(
    .DATASIZE(DATASIZE)

    ) rc_W (
    .ID(ID),
    .data_out(data_out_3),
    .direction_out(direction_out_3),
    .infifo_winc(W_infifo_winc),
    .data_in(W_data_in),
    .valid_in(W_valid_in),
    .valid_out(W_valid_out),
    .rc_ready(rc_ready_W),
    .infifo_wfull(W_infifo_wfull),
    .fifo_ready(fifo_ready_W),
    
    .rc_clk(rc_clk),
    .rst_n(rst_n)
    );

    rc_sub #(
    .DATASIZE(DATASIZE)

    ) rc_S (
    .ID(ID),
    .data_out(data_out_4),
    .direction_out(direction_out_4),
    .infifo_winc(S_infifo_winc),
    .data_in(S_data_in),
    .valid_in(S_valid_in),
    .valid_out(S_valid_out),
    .rc_ready(rc_ready_S),
    .infifo_wfull(S_infifo_wfull),
    .fifo_ready(fifo_ready_S),
    
    .rc_clk(rc_clk),
    .rst_n(rst_n)
    );

    rc_sub #(
    .DATASIZE(DATASIZE)

    ) rc_L (
    .ID(ID),
    .data_out(data_out_5),
    .direction_out(direction_out_5),
    .infifo_winc(L_infifo_winc),
    .data_in(L_data_in),
    .valid_in(L_valid_in),
    .valid_out(L_valid_out),
    .rc_ready(rc_ready_L),
    .infifo_wfull(L_infifo_wfull),
    .fifo_ready(fifo_ready_L),
    
    .rc_clk(rc_clk),
    .rst_n(rst_n)
    );

endmodule