
module fifo#(
  parameter DEPTH=8,
  parameter DATASIZE=40
  )(
  output wire[DATASIZE-1:0] N_data_out,
  output wire N_valid_out,
  output wire N_full_out,

  input wire[DATASIZE-1:0] N_data_in,
  input wire N_valid_in,
  input wire fifo_ready_N,

  output wire[DATASIZE-1:0] E_data_out,
  output wire E_valid_out,
  output wire E_full_out,

  input wire[DATASIZE-1:0] E_data_in,
  input wire E_valid_in,
  input wire fifo_ready_E,

  output wire[DATASIZE-1:0] S_data_out,
  output wire S_valid_out,
  output wire S_full_out,

  input wire[DATASIZE-1:0] S_data_in,
  input wire S_valid_in,
  input wire fifo_ready_S,

  output wire[DATASIZE-1:0] W_data_out,
  output wire W_valid_out,
  output wire W_full_out,

  input wire[DATASIZE-1:0] W_data_in,
  input wire W_valid_in,
  input wire fifo_ready_W,

  output wire[DATASIZE-1:0] L_data_out,
  output wire L_valid_out,
  output wire L_full_out,

  input wire[DATASIZE-1:0] L_data_in,
  input wire L_valid_in,
  input wire fifo_ready_L,
  
  // input wire fifo_clk,
  input wire clk,
  input wire clk_N,
  input wire clk_S,
  input wire clk_E,
  input wire clk_W,
  input wire rst_n
  );

  fifo_mpam_top #(
    .DEPTH(DEPTH),
    .DATASIZE(DATASIZE)
    ) fifo_N (
    .wdata(N_data_in),
    .wfull(N_full_out),
    .winc(N_valid_in),
    .rinc(fifo_ready_N),
    .rempty_n(N_valid_out),
    .rdata(N_data_out),
    .wclk(clk_N),
    .rclk(clk),
    .rst_n(rst_n)
    );

  fifo_mpam_top #(
    .DEPTH(DEPTH),
    .DATASIZE(DATASIZE)
    ) fifo_S (
    .wdata(S_data_in),
    .wfull(S_full_out),
    .winc(S_valid_in),
    .rinc(fifo_ready_S),
    .rempty_n(S_valid_out),
    .rdata(S_data_out),
    .wclk(clk_S),
    .rclk(clk),
    .rst_n(rst_n)
    );
  
  fifo_mpam_top #(
    .DEPTH(DEPTH),
    .DATASIZE(DATASIZE)
    ) fifo_E (
    .wdata(E_data_in),
    .wfull(E_full_out),
    .winc(E_valid_in),
    .rinc(fifo_ready_E),
    .rempty_n(E_valid_out),
    .rdata(E_data_out),
    .wclk(clk_E),
    .rclk(clk),
    .rst_n(rst_n)
    );

  fifo_mpam_top #(
    .DEPTH(DEPTH),
    .DATASIZE(DATASIZE)
    ) fifo_W (
    .wdata(W_data_in),
    .wfull(W_full_out),
    .winc(W_valid_in),
    .rinc(fifo_ready_W),
    .rempty_n(W_valid_out),
    .rdata(W_data_out),
    .wclk(clk_W),
    .rclk(clk),
    .rst_n(rst_n)
    );

  fifo_mpam_top #(
    .DEPTH(DEPTH),
    .DATASIZE(DATASIZE)
    ) fifo_L (
    .wdata(L_data_in),
    .wfull(L_full_out),
    .winc(L_valid_in),
    .rinc(fifo_ready_L),
    .rempty_n(L_valid_out),
    .rdata(L_data_out),
    .wclk(clk),
    .rclk(clk),
    .rst_n(rst_n)
    );
  
endmodule