
module switch_alloc#(
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


	input 	wire[4:0]		L_arb_res,
	input		wire[4:0]		E_arb_res,
	input		wire[4:0]		S_arb_res,
	input 	wire[4:0]		W_arb_res,
	input 	wire[4:0]		N_arb_res,

	output  reg					L_outfifo_winc,
	output  reg					W_outfifo_winc,
	output  reg					N_outfifo_winc,
	output  reg					E_outfifo_winc,
	output  reg					S_outfifo_winc,


	output	wire	[4:0]	grant_L,
	output	wire	[4:0]	grant_N,
	output	wire	[4:0]	grant_S,
	output	wire	[4:0]	grant_W,
	output	wire	[4:0]	grant_E,

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

	output	reg[DATASIZE-1:0]	L_data_out,
	output	reg[DATASIZE-1:0]	E_data_out,
	output	reg[DATASIZE-1:0]	S_data_out,
	output	reg[DATASIZE-1:0]	W_data_out,
	output	reg[DATASIZE-1:0]	N_data_out,

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

	reg L_outfifo_rclk;
	reg W_outfifo_rclk;
	reg N_outfifo_rclk;
	reg E_outfifo_rclk;
	reg S_outfifo_rclk;

	reg [4:0] L_outfifo_rdata;
	reg [4:0] W_outfifo_rdata;
	reg [4:0] N_outfifo_rdata;
	reg [4:0] E_outfifo_rdata;
	reg [4:0] S_outfifo_rdata;

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			L_outfifo_rclk <= 0;
			W_outfifo_rclk <= 0;
			N_outfifo_rclk <= 0;
			E_outfifo_rclk <= 0;
			S_outfifo_rclk <= 0;
		end else begin
			L_outfifo_rclk <= L_outfifo_rclk_sync;
			W_outfifo_rclk <= W_outfifo_rclk_sync;
			N_outfifo_rclk <= N_outfifo_rclk_sync;
			E_outfifo_rclk <= E_outfifo_rclk_sync;
			S_outfifo_rclk <= S_outfifo_rclk_sync;
		end
	end
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			L_outfifo_rdata <= 0;
			W_outfifo_rdata <= 0;
			N_outfifo_rdata <= 0;
			E_outfifo_rdata <= 0;
			S_outfifo_rdata <= 0;
		end else begin
			L_outfifo_rdata <= L_outfifo_rdata_sync;
			W_outfifo_rdata <= W_outfifo_rdata_sync;
			N_outfifo_rdata <= N_outfifo_rdata_sync;
			E_outfifo_rdata <= E_outfifo_rdata_sync;
			S_outfifo_rdata <= S_outfifo_rdata_sync;
		end
	end

	reg [4:0] Local_reqfor_W_cnt;
	reg [4:0] Local_reqfor_N_cnt;
	reg [4:0] Local_reqfor_E_cnt;
	reg [4:0] Local_reqfor_S_cnt;
	reg Local_reqfor_W;
	reg Local_reqfor_N;
	reg Local_reqfor_E;
	reg Local_reqfor_S;
	// Local_reqfor_W
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			Local_reqfor_W_cnt <= 5'b0;
		end
		else if((W_arb_res[4])&&((W_outfifo_rclk_sync==W_outfifo_rclk)|(W_outfifo_rdata!=5'b10000))) begin
		// else if((W_arb_res[4])&&(1)) begin
			Local_reqfor_W_cnt <= Local_reqfor_W_cnt + 1'b1;
		end
		else if((!W_arb_res[4])&&(W_outfifo_rclk_sync!=W_outfifo_rclk)&&(W_outfifo_rdata==5'b10000)) begin
		// else if((!W_arb_res[4])&&(1)) begin
			Local_reqfor_W_cnt <= Local_reqfor_W_cnt - 1'b1;
		end
		else begin
			Local_reqfor_W_cnt <= Local_reqfor_W_cnt;
		end
	end
		reg Local_reqfor_W_reg;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			Local_reqfor_W_reg <= 0;
		else
		    Local_reqfor_W_reg <= Local_reqfor_W;
	end
	always@(*) begin
		if(!rst_n) begin
			Local_reqfor_W = 1'b0;
		end
		else if(Local_reqfor_W_cnt == 5'd0) begin
			Local_reqfor_W = 1'b0;
		end
		else if(Local_reqfor_W_cnt > 5'd0) begin
			Local_reqfor_W = 1'b1;
		end
		else begin
			Local_reqfor_W = Local_reqfor_W_reg;
		end
	end
	// Local_reqfor_N
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			Local_reqfor_N_cnt <= 5'b0;
		end
		else if((N_arb_res[4])&&((N_outfifo_rclk_sync==N_outfifo_rclk)|(N_outfifo_rdata!=5'b10000))) begin
		// else if((N_arb_res[4])&&(1)) begin
			Local_reqfor_N_cnt <= Local_reqfor_N_cnt + 1'b1;
		end
		else if((!N_arb_res[4])&&(N_outfifo_rclk_sync!=N_outfifo_rclk)&&(N_outfifo_rdata==5'b10000)) begin
		// else if((!N_arb_res[4])&&(1)) begin
			Local_reqfor_N_cnt <= Local_reqfor_N_cnt - 1'b1;
		end
		else begin
			Local_reqfor_N_cnt <= Local_reqfor_N_cnt;
		end
	end
		reg Local_reqfor_N_reg;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			Local_reqfor_N_reg <= 0;
		else
		    Local_reqfor_N_reg <= Local_reqfor_N;
	end
	always@(*) begin
		if(!rst_n) begin
			Local_reqfor_N = 1'b0;
		end
		else if(Local_reqfor_N_cnt == 5'd0) begin
			Local_reqfor_N = 1'b0;
		end
		else if(Local_reqfor_N_cnt > 5'd0) begin
			Local_reqfor_N = 1'b1;
		end
		else begin
			Local_reqfor_N = Local_reqfor_N_reg;
		end
	end
	// Local_reqfor_E
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			Local_reqfor_E_cnt <= 5'b0;
		end
		else if((E_arb_res[4])&&((E_outfifo_rclk_sync==E_outfifo_rclk)|(E_outfifo_rdata!=5'b10000))) begin
		// else if((E_arb_res[4])&&(1)) begin
			Local_reqfor_E_cnt <= Local_reqfor_E_cnt + 1'b1;
		end
		else if((!E_arb_res[4])&&(E_outfifo_rclk_sync!=E_outfifo_rclk)&&(E_outfifo_rdata==5'b10000)) begin
		// else if((!E_arb_res[4])&&(1)) begin
			Local_reqfor_E_cnt <= Local_reqfor_E_cnt - 1'b1;
		end
		else begin
			Local_reqfor_E_cnt <= Local_reqfor_E_cnt;
		end
	end
			reg Local_reqfor_E_reg;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			Local_reqfor_E_reg <= 0;
		else
		    Local_reqfor_E_reg <= Local_reqfor_E;
	end
	always@(*) begin
		if(!rst_n) begin
			Local_reqfor_E = 1'b0;
		end
		else if(Local_reqfor_E_cnt == 5'd0) begin
			Local_reqfor_E = 1'b0;
		end
		else if(Local_reqfor_E_cnt > 5'd0) begin
			Local_reqfor_E = 1'b1;
		end
		else begin
			Local_reqfor_E = Local_reqfor_E_reg;
		end
	end
	// Local_reqfor_S
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			Local_reqfor_S_cnt <= 5'b0;
		end
		else if((S_arb_res[4])&&((S_outfifo_rclk_sync==S_outfifo_rclk)|(S_outfifo_rdata!=5'b10000))) begin
		// else if((S_arb_res[4])&&(1)) begin
			Local_reqfor_S_cnt <= Local_reqfor_S_cnt + 1'b1;
		end
		else if((!S_arb_res[4])&&(S_outfifo_rclk_sync!=S_outfifo_rclk)&&(S_outfifo_rdata==5'b10000)) begin
		// else if((!S_arb_res[4])&&(1)) begin
			Local_reqfor_S_cnt <= Local_reqfor_S_cnt - 1'b1;
		end
		else begin
			Local_reqfor_S_cnt <= Local_reqfor_S_cnt;
		end
	end
		reg Local_reqfor_S_reg;
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			Local_reqfor_S_reg <= 0;
		else
		    Local_reqfor_S_reg <= Local_reqfor_S;
	end
	always@(*) begin
		if(!rst_n) begin
			Local_reqfor_S = 1'b0;
		end
		else if(Local_reqfor_S_cnt == 5'd0) begin
			Local_reqfor_S = 1'b0;
		end
		else if(Local_reqfor_S_cnt > 5'd0) begin
			Local_reqfor_S = 1'b1;
		end
		else begin
			Local_reqfor_S = Local_reqfor_S_reg;
		end
	end

	// 2024/07/26: Annotate the W/N/S/E_reqfor_* signal
	// reg [4:0] West_reqfor_L_cnt;
	// reg [4:0] West_reqfor_N_cnt;
	// reg [4:0] West_reqfor_E_cnt;
	// reg [4:0] West_reqfor_S_cnt;
	// reg West_reqfor_L;
	// reg West_reqfor_N;
	// reg West_reqfor_E;
	// reg West_reqfor_S;
	// // West_reqfor_L
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_L_cnt <= 5'b0;
	// 	end
	// 	else if((L_arb_res[3])&&((L_outfifo_rclk_sync==L_outfifo_rclk)|(L_outfifo_rdata!=5'b01000))) begin
	// 		West_reqfor_L_cnt <= West_reqfor_L_cnt + 1'b1;
	// 	end
	// 	else if((!L_arb_res[3])&&(L_outfifo_rclk_sync!=L_outfifo_rclk)&&(L_outfifo_rdata==5'b01000)) begin
	// 		West_reqfor_L_cnt <= West_reqfor_L_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_L_cnt <= West_reqfor_L_cnt;
	// 	end
	// end
	// 	reg West_reqfor_L_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		West_reqfor_L_reg <= 0;
	// 	else
	// 	    West_reqfor_L_reg <= West_reqfor_L;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_L = 1'b0;
	// 	end
	// 	else if(West_reqfor_L_cnt == 5'd0) begin
	// 		West_reqfor_L = 1'b0;
	// 	end
	// 	else if(West_reqfor_L_cnt > 5'd0) begin
	// 		West_reqfor_L = 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_L = West_reqfor_L_reg;
	// 	end
	// end
	// // West_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_N_cnt <= 5'b0;
	// 	end
	// 	else if((N_arb_res[3])&&((N_outfifo_rclk_sync==N_outfifo_rclk)|(L_outfifo_rdata!=5'b01000))) begin
	// 		West_reqfor_N_cnt <= West_reqfor_N_cnt + 1'b1;
	// 	end
	// 	else if((!N_arb_res[3])&&(N_outfifo_rclk_sync!=N_outfifo_rclk)&&(L_outfifo_rdata==5'b01000)) begin
	// 		West_reqfor_N_cnt <= West_reqfor_N_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_N_cnt <= West_reqfor_N_cnt;
	// 	end
	// end
	// 	reg West_reqfor_N_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		West_reqfor_N_reg <= 0;
	// 	else
	// 	    West_reqfor_N_reg <= West_reqfor_N;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_N = 1'b0;
	// 	end
	// 	else if(West_reqfor_N_cnt == 5'd0) begin
	// 		West_reqfor_N = 1'b0;
	// 	end
	// 	else if(West_reqfor_N_cnt > 5'd0) begin
	// 		West_reqfor_N = 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_N = West_reqfor_N_reg;
	// 	end
	// end
	// // West_reqfor_E
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_E_cnt <= 5'b0;
	// 	end
	// 	else if((E_arb_res[3])&&((E_outfifo_rclk_sync==E_outfifo_rclk)|(E_outfifo_rdata!=5'b01000))) begin
	// 		West_reqfor_E_cnt <= West_reqfor_E_cnt + 1'b1;
	// 	end
	// 	else if((!E_arb_res[3])&&(E_outfifo_rclk_sync!=E_outfifo_rclk)&&(E_outfifo_rdata==5'b01000)) begin
	// 		West_reqfor_E_cnt <= West_reqfor_E_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_E_cnt <= West_reqfor_E_cnt;
	// 	end
	// end
	// 	reg West_reqfor_E_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		West_reqfor_E_reg <= 0;
	// 	else
	// 	    West_reqfor_E_reg <= West_reqfor_E;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_E = 1'b0;
	// 	end
	// 	else if(West_reqfor_E_cnt == 5'd0) begin
	// 		West_reqfor_E = 1'b0;
	// 	end
	// 	else if(West_reqfor_E_cnt > 5'd0) begin
	// 		West_reqfor_E = 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_E = West_reqfor_E_reg;
	// 	end
	// end
	// // West_reqfor_S
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_S_cnt <= 5'b0;
	// 	end
	// 	else if((S_arb_res[3])&&((S_outfifo_rclk_sync==S_outfifo_rclk)|(S_outfifo_rdata!=5'b01000))) begin
	// 		West_reqfor_S_cnt <= West_reqfor_S_cnt + 1'b1;
	// 	end
	// 	else if((!S_arb_res[3])&&(S_outfifo_rclk_sync!=S_outfifo_rclk)&&(S_outfifo_rdata==5'b01000)) begin
	// 		West_reqfor_S_cnt <= West_reqfor_S_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_S_cnt <= West_reqfor_S_cnt;
	// 	end
	// end
	// 	reg West_reqfor_S_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		West_reqfor_S_reg <= 0;
	// 	else
	// 	    West_reqfor_S_reg <= West_reqfor_S;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		West_reqfor_S = 1'b0;
	// 	end
	// 	else if(West_reqfor_S_cnt == 5'd0) begin
	// 		West_reqfor_S = 1'b0;
	// 	end
	// 	else if(West_reqfor_S_cnt > 5'd0) begin
	// 		West_reqfor_S = 1'b1;
	// 	end
	// 	else begin
	// 		West_reqfor_S = West_reqfor_S_reg;
	// 	end
	// end

	// reg [4:0] North_reqfor_L_cnt;
	// reg [4:0] North_reqfor_W_cnt;
	// reg [4:0] North_reqfor_E_cnt;
	// reg [4:0] North_reqfor_S_cnt;
	// reg North_reqfor_L;
	// reg North_reqfor_W;
	// reg North_reqfor_E;
	// reg North_reqfor_S;
	// // North_reqfor_L
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_L_cnt <= 5'b0;
	// 	end
	// 	else if((L_arb_res[2])&&((L_outfifo_rclk_sync==L_outfifo_rclk)|(L_outfifo_rdata!=5'b00100))) begin
	// 		North_reqfor_L_cnt <= North_reqfor_L_cnt + 1'b1;
	// 	end
	// 	else if((!L_arb_res[2])&&(L_outfifo_rclk_sync!=L_outfifo_rclk)&&(L_outfifo_rdata==5'b00100)) begin
	// 		North_reqfor_L_cnt <= North_reqfor_L_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_L_cnt <= North_reqfor_L_cnt;
	// 	end
	// end
	// 	reg North_reqfor_L_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		North_reqfor_L_reg <= 0;
	// 	else
	// 	    North_reqfor_L_reg <= North_reqfor_L;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_L = 1'b0;
	// 	end
	// 	else if(North_reqfor_L_cnt == 5'd0) begin
	// 		North_reqfor_L = 1'b0;
	// 	end
	// 	else if(North_reqfor_L_cnt > 5'd0) begin
	// 		North_reqfor_L = 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_L = North_reqfor_L_reg;
	// 	end
	// end
	// // North_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_W_cnt <= 5'b0;
	// 	end
	// 	else if((W_arb_res[2])&&((W_outfifo_rclk_sync==W_outfifo_rclk)|(W_outfifo_rdata!=5'b00100))) begin
	// 		North_reqfor_W_cnt <= North_reqfor_W_cnt + 1'b1;
	// 	end
	// 	else if((!W_arb_res[2])&&(W_outfifo_rclk_sync!=W_outfifo_rclk)&&(W_outfifo_rdata==5'b00100)) begin
	// 		North_reqfor_W_cnt <= North_reqfor_W_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_W_cnt <= North_reqfor_W_cnt;
	// 	end
	// end
	// 	reg North_reqfor_W_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		North_reqfor_W_reg <= 0;
	// 	else
	// 	    North_reqfor_W_reg <= North_reqfor_W;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_W = 1'b0;
	// 	end
	// 	else if(North_reqfor_W_cnt == 5'd0) begin
	// 		North_reqfor_W = 1'b0;
	// 	end
	// 	else if(North_reqfor_W_cnt > 5'd0) begin
	// 		North_reqfor_W = 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_W = North_reqfor_W_reg;
	// 	end
	// end
	// // North_reqfor_E
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_E_cnt <= 5'b0;
	// 	end
	// 	else if((E_arb_res[2])&&((E_outfifo_rclk_sync==E_outfifo_rclk)|(E_outfifo_rdata!=5'b00100))) begin
	// 		North_reqfor_E_cnt <= North_reqfor_E_cnt + 1'b1;
	// 	end
	// 	else if((!E_arb_res[2])&&(E_outfifo_rclk_sync!=E_outfifo_rclk)&&(E_outfifo_rdata==5'b00100)) begin
	// 		North_reqfor_E_cnt <= North_reqfor_E_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_E_cnt <= North_reqfor_E_cnt;
	// 	end
	// end
	// 	reg North_reqfor_E_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		North_reqfor_E_reg <= 0;
	// 	else
	// 	    North_reqfor_E_reg <= North_reqfor_E;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_E = 1'b0;
	// 	end
	// 	else if(North_reqfor_E_cnt == 5'd0) begin
	// 		North_reqfor_E = 1'b0;
	// 	end
	// 	else if(North_reqfor_E_cnt > 5'd0) begin
	// 		North_reqfor_E = 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_E = North_reqfor_E_reg;
	// 	end
	// end
	// // North_reqfor_S
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_S_cnt <= 5'b0;
	// 	end
	// 	else if((S_arb_res[2])&&((S_outfifo_rclk_sync==S_outfifo_rclk)|(S_outfifo_rdata!=5'b00100))) begin
	// 		North_reqfor_S_cnt <= North_reqfor_S_cnt + 1'b1;
	// 	end
	// 	else if((!S_arb_res[2])&&(S_outfifo_rclk_sync!=S_outfifo_rclk)&&(S_outfifo_rdata==5'b00100)) begin
	// 		North_reqfor_S_cnt <= North_reqfor_S_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_S_cnt <= North_reqfor_S_cnt;
	// 	end
	// end
	// 	reg North_reqfor_S_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		North_reqfor_S_reg <= 0;
	// 	else
	// 	    North_reqfor_S_reg <= North_reqfor_S;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		North_reqfor_S = 1'b0;
	// 	end
	// 	else if(North_reqfor_S_cnt == 5'd0) begin
	// 		North_reqfor_S = 1'b0;
	// 	end
	// 	else if(North_reqfor_S_cnt > 5'd0) begin
	// 		North_reqfor_S = 1'b1;
	// 	end
	// 	else begin
	// 		North_reqfor_S = North_reqfor_S_reg;
	// 	end
	// end

	// reg [4:0] East_reqfor_L_cnt;
	// reg [4:0] East_reqfor_W_cnt;
	// reg [4:0] East_reqfor_N_cnt;
	// reg [4:0] East_reqfor_S_cnt;
	// reg East_reqfor_L;
	// reg East_reqfor_W;
	// reg East_reqfor_N;
	// reg East_reqfor_S;
	// // East_reqfor_L
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_L_cnt <= 5'b0;
	// 	end
	// 	else if((L_arb_res[1])&&((L_outfifo_rclk_sync==L_outfifo_rclk)|(L_outfifo_rdata!=5'b00010))) begin
	// 		East_reqfor_L_cnt <= East_reqfor_L_cnt + 1'b1;
	// 	end
	// 	else if((!L_arb_res[1])&&(L_outfifo_rclk_sync!=L_outfifo_rclk)&&(L_outfifo_rdata==5'b00010)) begin
	// 		East_reqfor_L_cnt <= East_reqfor_L_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_L_cnt <= East_reqfor_L_cnt;
	// 	end
	// end
	// reg East_reqfor_L_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		East_reqfor_L_reg <= 0;
	// 	else
	// 	    East_reqfor_L_reg <= East_reqfor_L;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_L = 1'b0;
	// 	end
	// 	else if(East_reqfor_L_cnt == 5'd0) begin
	// 		East_reqfor_L = 1'b0;
	// 	end
	// 	else if(East_reqfor_L_cnt > 5'd0) begin
	// 		East_reqfor_L = 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_L = East_reqfor_L_reg;
	// 	end
	// end
	// // East_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_W_cnt <= 5'b0;
	// 	end
	// 	else if((W_arb_res[1])&&((W_outfifo_rclk_sync==W_outfifo_rclk)|(W_outfifo_rdata!=5'b00010))) begin
	// 		East_reqfor_W_cnt <= East_reqfor_W_cnt + 1'b1;
	// 	end
	// 	else if((!W_arb_res[1])&&(W_outfifo_rclk_sync!=W_outfifo_rclk)&&(W_outfifo_rdata==5'b00010)) begin
	// 		East_reqfor_W_cnt <= East_reqfor_W_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_W_cnt <= East_reqfor_W_cnt;
	// 	end
	// end
	// 	reg East_reqfor_W_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		East_reqfor_W_reg <= 0;
	// 	else
	// 	    East_reqfor_W_reg <= East_reqfor_W;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_W = 1'b0;
	// 	end
	// 	else if(East_reqfor_W_cnt == 5'd0) begin
	// 		East_reqfor_W = 1'b0;
	// 	end
	// 	else if(East_reqfor_W_cnt > 5'd0) begin
	// 		East_reqfor_W = 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_W = East_reqfor_W_reg;
	// 	end
	// end
	// // East_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_N_cnt <= 5'b0;
	// 	end
	// 	else if((N_arb_res[1])&&((N_outfifo_rclk_sync==N_outfifo_rclk)|(N_outfifo_rdata!=5'b00010))) begin
	// 		East_reqfor_N_cnt <= East_reqfor_N_cnt + 1'b1;
	// 	end
	// 	else if((!N_arb_res[1])&&(N_outfifo_rclk_sync!=N_outfifo_rclk)&&(N_outfifo_rdata==5'b00010)) begin
	// 		East_reqfor_N_cnt <= East_reqfor_N_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_N_cnt <= East_reqfor_N_cnt;
	// 	end
	// end
	// reg East_reqfor_N_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		East_reqfor_N_reg <= 0;
	// 	else
	// 	    East_reqfor_N_reg <= East_reqfor_N;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_N = 1'b0;
	// 	end
	// 	else if(East_reqfor_N_cnt == 5'd0) begin
	// 		East_reqfor_N = 1'b0;
	// 	end
	// 	else if(East_reqfor_N_cnt > 5'd0) begin
	// 		East_reqfor_N = 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_N = East_reqfor_N_reg;
	// 	end
	// end
	// // East_reqfor_S
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_S_cnt <= 5'b0;
	// 	end
	// 	else if((S_arb_res[1])&&((S_outfifo_rclk_sync==S_outfifo_rclk)|(S_outfifo_rdata!=5'b00010))) begin
	// 		East_reqfor_S_cnt <= East_reqfor_S_cnt + 1'b1;
	// 	end
	// 	else if((!S_arb_res[1])&&(S_outfifo_rclk_sync!=S_outfifo_rclk)&&(S_outfifo_rdata==5'b00010)) begin
	// 		East_reqfor_S_cnt <= East_reqfor_S_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_S_cnt <= East_reqfor_S_cnt;
	// 	end
	// end
	// reg East_reqfor_S_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		East_reqfor_S_reg <= 0;
	// 	else
	// 	    East_reqfor_S_reg <= East_reqfor_S;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		East_reqfor_S = 1'b0;
	// 	end
	// 	else if(East_reqfor_S_cnt == 5'd0) begin
	// 		East_reqfor_S = 1'b0;
	// 	end
	// 	else if(East_reqfor_S_cnt > 5'd0) begin
	// 		East_reqfor_S = 1'b1;
	// 	end
	// 	else begin
	// 		East_reqfor_S = East_reqfor_S_reg;
	// 	end
	// end

	// reg [4:0] South_reqfor_L_cnt;
	// reg [4:0] South_reqfor_W_cnt;
	// reg [4:0] South_reqfor_N_cnt;
	// reg [4:0] South_reqfor_E_cnt;
	// reg South_reqfor_L;
	// reg South_reqfor_W;
	// reg South_reqfor_N;
	// reg South_reqfor_E;
	// // South_reqfor_L
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_L_cnt <= 5'b0;
	// 	end
	// 	else if((L_arb_res[0])&&((L_outfifo_rclk_sync==L_outfifo_rclk)|(L_outfifo_rdata!=5'b00001))) begin
	// 		South_reqfor_L_cnt <= South_reqfor_L_cnt + 1'b1;
	// 	end
	// 	else if((!L_arb_res[0])&&(L_outfifo_rclk_sync!=L_outfifo_rclk)&&(L_outfifo_rdata==5'b00001)) begin
	// 		South_reqfor_L_cnt <= South_reqfor_L_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_L_cnt <= South_reqfor_L_cnt;
	// 	end
	// end
	// reg South_reqfor_L_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		South_reqfor_L_reg <= 0;
	// 	else
	// 	    South_reqfor_L_reg <= South_reqfor_L;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_L = 1'b0;
	// 	end
	// 	else if(South_reqfor_L_cnt == 5'd0) begin
	// 		South_reqfor_L = 1'b0;
	// 	end
	// 	else if(South_reqfor_L_cnt > 5'd0) begin
	// 		South_reqfor_L = 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_L = South_reqfor_L_reg;
	// 	end
	// end
	// // South_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_W_cnt <= 5'b0;
	// 	end
	// 	else if((W_arb_res[0])&&((W_outfifo_rclk_sync==W_outfifo_rclk)|(W_outfifo_rdata!=5'b00001))) begin
	// 		South_reqfor_W_cnt <= South_reqfor_W_cnt + 1'b1;
	// 	end
	// 	else if((!W_arb_res[0])&&(W_outfifo_rclk_sync!=W_outfifo_rclk)&&(W_outfifo_rdata==5'b00001)) begin
	// 		South_reqfor_W_cnt <= South_reqfor_W_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_W_cnt <= South_reqfor_W_cnt;
	// 	end
	// end

	// reg South_reqfor_W_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		South_reqfor_L_reg <= 0;
	// 	else
	// 	    South_reqfor_W_reg <= South_reqfor_W;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_W = 1'b0;
	// 	end
	// 	else if(South_reqfor_W_cnt == 5'd0) begin
	// 		South_reqfor_W = 1'b0;
	// 	end
	// 	else if(South_reqfor_W_cnt > 5'd0) begin
	// 		South_reqfor_W = 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_W = South_reqfor_W_reg;
	// 	end
	// end
	// // South_reqfor_N
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_N_cnt <= 5'b0;
	// 	end
	// 	else if((N_arb_res[0])&&((N_outfifo_rclk_sync==N_outfifo_rclk)|(N_outfifo_rdata!=5'b00001))) begin
	// 		South_reqfor_N_cnt <= South_reqfor_N_cnt + 1'b1;
	// 	end
	// 	else if((!N_arb_res[0])&&(N_outfifo_rclk_sync!=N_outfifo_rclk)&&(N_outfifo_rdata==5'b00001)) begin
	// 		South_reqfor_N_cnt <= South_reqfor_N_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_N_cnt <= South_reqfor_N_cnt;
	// 	end
	// end

	// reg South_reqfor_N_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		South_reqfor_L_reg <= 0;
	// 	else
	// 	    South_reqfor_N_reg <= South_reqfor_N;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_N = 1'b0;
	// 	end
	// 	else if(South_reqfor_N_cnt == 5'd0) begin
	// 		South_reqfor_N = 1'b0;
	// 	end
	// 	else if(South_reqfor_N_cnt > 5'd0) begin
	// 		South_reqfor_N = 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_N = South_reqfor_N_reg;
	// 	end
	// end
	// // South_reqfor_E
	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_E_cnt <= 5'b0;
	// 	end
	// 	else if((E_arb_res[0])&&((E_outfifo_rclk_sync==E_outfifo_rclk)|(E_outfifo_rdata!=5'b00001))) begin
	// 		South_reqfor_E_cnt <= South_reqfor_E_cnt + 1'b1;
	// 	end
	// 	else if((!E_arb_res[0])&&(E_outfifo_rclk_sync!=E_outfifo_rclk)&&(E_outfifo_rdata==5'b00001)) begin
	// 		South_reqfor_E_cnt <= South_reqfor_E_cnt - 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_E_cnt <= South_reqfor_E_cnt;
	// 	end
	// end
	// reg South_reqfor_E_reg;
	// always @(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		South_reqfor_L_reg <= 0;
	// 	else
	// 	    South_reqfor_E_reg <= South_reqfor_E;
	// end
	// always@(*) begin
	// 	if(!rst_n) begin
	// 		South_reqfor_E = 1'b0;
	// 	end
	// 	else if(South_reqfor_E_cnt == 5'd0) begin
	// 		South_reqfor_E = 1'b0;
	// 	end
	// 	else if(South_reqfor_E_cnt > 5'd0) begin
	// 		South_reqfor_E = 1'b1;
	// 	end
	// 	else begin
	// 		South_reqfor_E = South_reqfor_E_reg;
	// 	end
	// end






	//grant:D0D1D2D3D4, where D0 = local, D1 = W, D2 = N, D3 = E,D4 = S.

	wire	L_label_valid;
	wire	N_label_valid;
	wire	S_label_valid;
	wire	W_label_valid;
	wire	E_label_valid;

	// assign  L_label_valid	= (~(&L_label)) && L_data_valid;
	// assign  N_label_valid	= (~(&N_label)) && N_data_valid;
	// assign  S_label_valid	= (~(&S_label)) && S_data_valid;
	// assign  W_label_valid	= (~(&W_label)) && W_data_valid;
	// assign  E_label_valid	= (~(&E_label)) && E_data_valid;
	assign  L_label_valid	= (~(&L_label));
	assign  N_label_valid	= (~(&N_label));
	assign  S_label_valid	= (~(&S_label));
	assign  W_label_valid	= (~(&W_label));
	assign  E_label_valid	= (~(&E_label));

	// assign grant_W = {L_label[3]&L_label_valid&(!Local_reqfor_N)&(!Local_reqfor_E)&(!Local_reqfor_S), 
	// 									W_label[3]&W_label_valid, 
	// 									N_label[3]&N_label_valid&(!North_reqfor_L)&(!North_reqfor_E)&(!North_reqfor_S), 
	// 									E_label[3]&E_label_valid&(!East_reqfor_L)&(!East_reqfor_N)&(!East_reqfor_S), 
	// 									S_label[3]&S_label_valid&(!South_reqfor_L)&(!South_reqfor_N)&(!South_reqfor_E)};	//left(west)

	// assign grant_N = {L_label[2]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_E)&(!Local_reqfor_S), 
	// 									W_label[2]&W_label_valid&(!West_reqfor_L)&(!West_reqfor_E)&(!West_reqfor_S), 
	// 									N_label[2]&N_label_valid, 
	// 									E_label[2]&E_label_valid&(!East_reqfor_L)&(!East_reqfor_W)&(!East_reqfor_S), 
	// 									S_label[2]&S_label_valid&(!South_reqfor_L)&(!South_reqfor_W)&(!South_reqfor_E)};	//up
	
	// assign grant_E = {L_label[1]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_N)&(!Local_reqfor_S), 
	// 									W_label[1]&W_label_valid&(!West_reqfor_L)&(!West_reqfor_N)&(!West_reqfor_S), 
	// 									N_label[1]&N_label_valid&(!North_reqfor_L)&(!North_reqfor_W)&(!North_reqfor_S), 
	// 									E_label[1]&E_label_valid, 
	// 									S_label[1]&S_label_valid&(!South_reqfor_L)&(!South_reqfor_W)&(!South_reqfor_N)};	//right
	
	// assign grant_S = {L_label[0]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_N)&(!Local_reqfor_E), 
	// 									W_label[0]&W_label_valid&(!West_reqfor_L)&(!West_reqfor_N)&(!West_reqfor_E), 
	// 									N_label[0]&N_label_valid&(!North_reqfor_L)&(!North_reqfor_W)&(!North_reqfor_E), 
	// 									E_label[0]&E_label_valid&(!East_reqfor_L)&(!East_reqfor_W)&(!East_reqfor_N), 
	// 									S_label[0]&S_label_valid};	//down
	
	// assign grant_L = {~(|L_label),
	// 									~(|W_label)&(!West_reqfor_N)&(!West_reqfor_E)&(!West_reqfor_S), 
	// 									~(|N_label)&(!North_reqfor_W)&(!North_reqfor_E)&(!North_reqfor_S), 
	// 									~(|E_label)&(!East_reqfor_W)&(!East_reqfor_N)&(!East_reqfor_S), 
	// 									~(|S_label)&(!South_reqfor_W)&(!South_reqfor_N)&(!South_reqfor_E)};	//local

	//20240727:Old
	assign grant_W = {L_label[3]&L_label_valid&(!Local_reqfor_E)&(!Local_reqfor_N)&(!Local_reqfor_S), W_label[3]&W_label_valid, N_label[3]&N_label_valid, E_label[3]&E_label_valid, S_label[3]&S_label_valid};	//left(west)
	assign grant_N = {L_label[2]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_E)&(!Local_reqfor_S), W_label[2]&W_label_valid, N_label[2]&N_label_valid, E_label[2]&E_label_valid, S_label[2]&S_label_valid};	//up
	assign grant_E = {L_label[1]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_N)&(!Local_reqfor_S), W_label[1]&W_label_valid, N_label[1]&N_label_valid, E_label[1]&E_label_valid, S_label[1]&S_label_valid};	//right
	assign grant_S = {L_label[0]&L_label_valid&(!Local_reqfor_W)&(!Local_reqfor_N)&(!Local_reqfor_E), W_label[0]&W_label_valid, N_label[0]&N_label_valid, E_label[0]&E_label_valid, S_label[0]&S_label_valid};	//down
	assign grant_L = {~(|L_label),~(|W_label),~(|N_label),~(|E_label),~(|S_label)};	//local


	//20241220 arb_res can changed if normal pdata
	// reg	L_data_src_grant;
	// reg	E_data_src_grant;
	// reg	S_data_src_grant;
	// reg	W_data_src_grant;
	// reg	N_data_src_grant;
	// always @(*) begin
	// 	case(grant_L)
	// 		5'b00001:begin
	// 			L_data_src_grant = S_data_in[0];
	// 		end
	// 		5'b00010:begin
	// 			L_data_src_grant = E_data_in[0];
	// 		end
	// 		5'b00100:begin
	// 			L_data_src_grant = N_data_in[0];
	// 		end
	// 		5'b01000:begin
	// 			L_data_src_grant = W_data_in[0];
	// 		end
	// 		5'b10000:begin
	// 			L_data_src_grant = L_data_in[0];
	// 		end
	// 		default:begin
	// 			L_data_src_grant = 1'b0;
	// 		end
	// 		endcase
	// end


	// always @(*) begin
	// 	case(grant_W)
	// 		5'b00001:begin
	// 			W_data_src_grant = S_data_in[0];
	// 		end
	// 		5'b00010:begin
	// 			W_data_src_grant = E_data_in[0];
	// 		end
	// 		5'b00100:begin
	// 			W_data_src_grant = N_data_in[0];
	// 		end
	// 		5'b01000:begin
	// 			W_data_src_grant = W_data_in[0];
	// 		end
	// 		5'b10000:begin
	// 			W_data_src_grant = L_data_in[0];
	// 		end
	// 		default:begin
	// 			W_data_src_grant = 1'b0;
	// 		end
	// 		endcase
	// end

	// always @(*) begin
	// 	case(grant_N)
	// 		5'b00001:begin
	// 			N_data_src_grant = S_data_in[0];
	// 		end
	// 		5'b00010:begin
	// 			N_data_src_grant = E_data_in[0];
	// 		end
	// 		5'b00100:begin
	// 			N_data_src_grant = N_data_in[0];
	// 		end
	// 		5'b01000:begin
	// 			N_data_src_grant = W_data_in[0];
	// 		end
	// 		5'b10000:begin
	// 			N_data_src_grant = L_data_in[0];
	// 		end
	// 		default:begin
	// 			N_data_src_grant = 1'b0;
	// 		end
	// 		endcase
	// end

	// always @(*) begin
	// 	case(grant_E)
	// 		5'b00001:begin
	// 			E_data_src_grant = S_data_in[0];
	// 		end
	// 		5'b00010:begin
	// 			E_data_src_grant = E_data_in[0];
	// 		end
	// 		5'b00100:begin
	// 			E_data_src_grant = N_data_in[0];
	// 		end
	// 		5'b01000:begin
	// 			E_data_src_grant = W_data_in[0];
	// 		end
	// 		5'b10000:begin
	// 			E_data_src_grant = L_data_in[0];
	// 		end
	// 		default:begin
	// 			E_data_src_grant = 1'b0;
	// 		end
	// 		endcase
	// end

	// always @(*) begin
	// 	case(grant_S)
	// 		5'b00001:begin
	// 			S_data_src_grant = S_data_in[0];
	// 		end
	// 		5'b00010:begin
	// 			S_data_src_grant = E_data_in[0];
	// 		end
	// 		5'b00100:begin
	// 			S_data_src_grant = N_data_in[0];
	// 		end
	// 		5'b01000:begin
	// 			S_data_src_grant = W_data_in[0];
	// 		end
	// 		5'b10000:begin
	// 			S_data_src_grant = L_data_in[0];
	// 		end
	// 		default:begin
	// 			S_data_src_grant = 1'b0;
	// 		end
	// 		endcase
	// end

	//20240727:New
	// assign grant_W = {L_label[3]&L_label_valid, W_label[3]&W_label_valid, N_label[3]&N_label_valid, E_label[3]&E_label_valid, S_label[3]&S_label_valid};	//left(west)
	// assign grant_N = {L_label[2]&L_label_valid, W_label[2]&W_label_valid, N_label[2]&N_label_valid, E_label[2]&E_label_valid, S_label[2]&S_label_valid};	//up
	// assign grant_E = {L_label[1]&L_label_valid, W_label[1]&W_label_valid, N_label[1]&N_label_valid, E_label[1]&E_label_valid, S_label[1]&S_label_valid};	//right
	// assign grant_S = {L_label[0]&L_label_valid, W_label[0]&W_label_valid, N_label[0]&N_label_valid, E_label[0]&E_label_valid, S_label[0]&S_label_valid};	//down
	// assign grant_L = {~(|L_label),~(|W_label),~(|N_label),~(|E_label),~(|S_label)};	//local

	// assign grant_W = {L_label[3]&L_label_valid, W_label[3]&W_label_valid, N_label[3]&N_label_valid, E_label[3]&E_label_valid, S_label[3]&S_label_valid};	//left(west)
	// assign grant_N = {L_label[2]&L_label_valid, W_label[2]&W_label_valid, N_label[2]&N_label_valid, E_label[2]&E_label_valid, S_label[2]&S_label_valid};	//up
	// assign grant_E = {L_label[1]&L_label_valid, W_label[1]&W_label_valid, N_label[1]&N_label_valid, E_label[1]&E_label_valid, S_label[1]&S_label_valid};	//right
	// assign grant_S = {L_label[0]&L_label_valid, W_label[0]&W_label_valid, N_label[0]&N_label_valid, E_label[0]&E_label_valid, S_label[0]&S_label_valid};	//down
	// assign grant_L = {~(|L_label),~(|W_label),~(|N_label),~(|E_label),~(|S_label)};	//local






	// always@(*) begin
	// 	L_outfifo_winc = (grant_L[3] | grant_L[2] | grant_L[1] | grant_L[0])&&(L_arb_res!=5'b10000);
	// end
	// always@(*) begin
	// 	W_outfifo_winc = (grant_W[4] | grant_W[2] | grant_W[1] | grant_W[0]);
	// end
	// always@(*) begin
	// 	N_outfifo_winc = (grant_N[4] | grant_N[3] | grant_N[1] | grant_N[0]);
	// end
	// always@(*) begin
	// 	E_outfifo_winc = (grant_E[4] | grant_E[3] | grant_E[2] | grant_E[0]);
	// end
	// always@(*) begin
	// 	S_outfifo_winc = (grant_S[4] | grant_S[3] | grant_S[2] | grant_S[1]);
	// end


	// always@(*) begin
	// 	if((W_data_in[39:36]==W_data_in[35:32])&&(N_data_in[39:36]==N_data_in[35:32])&&(E_data_in[39:36]==E_data_in[35:32])&&(S_data_in[39:36]==S_data_in[35:32])) L_outfifo_winc = 1'b0;
	// 	else L_outfifo_winc = grant_L[4] | grant_L[3] | grant_L[2] | grant_L[1] | grant_L[0];
	// end
	// always@(*) begin
	// 	if((L_data_in[39:36]==L_data_in[35:32])&&(N_data_in[39:36]==N_data_in[35:32])&&(E_data_in[39:36]==E_data_in[35:32])&&(S_data_in[39:36]==S_data_in[35:32])) W_outfifo_winc = 1'b0;
	// 	else W_outfifo_winc = grant_W[4] | grant_W[3] | grant_W[2] | grant_W[1] | grant_W[0];
	// end
	// always@(*) begin
	// 	if((L_data_in[39:36]==L_data_in[35:32])&&(W_data_in[39:36]==W_data_in[35:32])&&(E_data_in[39:36]==E_data_in[35:32])&&(S_data_in[39:36]==S_data_in[35:32])) N_outfifo_winc = 1'b0;
	// 	else N_outfifo_winc = grant_N[4] | grant_N[3] | grant_N[2] | grant_N[1] | grant_N[0];
	// end
	// always@(*) begin
	// 	if((L_data_in[39:36]==L_data_in[35:32])&&(W_data_in[39:36]==W_data_in[35:32])&&(N_data_in[39:36]==N_data_in[35:32])&&(S_data_in[39:36]==S_data_in[35:32])) E_outfifo_winc = 1'b0;
	// 	else E_outfifo_winc = grant_E[4] | grant_E[3] | grant_E[2] | grant_E[1] | grant_E[0];
	// end
	// always@(*) begin
	// 	if((L_data_in[39:36]==L_data_in[35:32])&&(W_data_in[39:36]==W_data_in[35:32])&&(N_data_in[39:36]==N_data_in[35:32])&&(E_data_in[39:36]==E_data_in[35:32])) S_outfifo_winc = 1'b0;
	// 	else S_outfifo_winc = grant_S[4] | grant_S[3] | grant_S[2] | grant_S[1] | grant_S[0];
	// end
	
	

	reg[DATASIZE-1:0]	L_data_src;
	reg[DATASIZE-1:0]	E_data_src;
	reg[DATASIZE-1:0]	S_data_src;
	reg[DATASIZE-1:0]	W_data_src;
	reg[DATASIZE-1:0]	N_data_src;


	reg	L_port_valid;
	reg	N_port_valid;
	reg	E_port_valid;
	reg	W_port_valid;
	reg	S_port_valid;

	
	always@(*) begin
		L_outfifo_winc = (L_arb_res[3] | L_arb_res[2] | L_arb_res[1] | L_arb_res[0])&&(!L_arb_res[4])&&(L_data_src[0])&&(L_port_valid);
	end
	always@(*) begin
		W_outfifo_winc = (W_arb_res[4] | W_arb_res[2] | W_arb_res[1] | W_arb_res[0])&&(!W_arb_res[3])&&(W_data_src[0])&&(W_port_valid);
	end
	always@(*) begin
		N_outfifo_winc = (N_arb_res[4] | N_arb_res[3] | N_arb_res[1] | N_arb_res[0])&&(!N_arb_res[2])&&(N_data_src[0])&&(N_port_valid);
	end
	always@(*) begin
		E_outfifo_winc = (E_arb_res[4] | E_arb_res[3] | E_arb_res[2] | E_arb_res[0])&&(!E_arb_res[1])&&(E_data_src[0])&&(E_port_valid);
	end
	always@(*) begin
		S_outfifo_winc = (S_arb_res[4] | S_arb_res[3] | S_arb_res[2] | S_arb_res[1])&&(!S_arb_res[0])&&(S_data_src[0])&&(S_port_valid);
	end

	// always@(*) begin
	// 	L_outfifo_winc = (L_arb_res[3] | L_arb_res[2] | L_arb_res[1] | L_arb_res[0])&&(!L_arb_res[4]);
	// end
	// always@(*) begin
	// 	W_outfifo_winc = (W_arb_res[4] | W_arb_res[2] | W_arb_res[1] | W_arb_res[0])&&(!W_arb_res[3]);
	// end
	// always@(*) begin
	// 	N_outfifo_winc = (N_arb_res[4] | N_arb_res[3] | N_arb_res[1] | N_arb_res[0])&&(!N_arb_res[2]);
	// end
	// always@(*) begin
	// 	E_outfifo_winc = (E_arb_res[4] | E_arb_res[3] | E_arb_res[2] | E_arb_res[0])&&(!E_arb_res[1]);
	// end
	// always@(*) begin
	// 	S_outfifo_winc = (S_arb_res[4] | S_arb_res[3] | S_arb_res[2] | S_arb_res[1])&&(!S_arb_res[0]);
	// end

	// reg	L_port_valid;
	// reg	N_port_valid;
	// reg	E_port_valid;
	// reg	W_port_valid;
	// reg	S_port_valid;

	// assign 	 L_ready =  ~L_label_valid | (L_arb_res[4] & ~L_outfifo_wfull) | (W_arb_res[4] & ~W_full & ~W_outfifo_wfull)| (E_arb_res[4] & ~E_full & ~E_outfifo_wfull)| (N_arb_res[4] & ~N_full & ~N_outfifo_wfull)| (S_arb_res[4] & ~S_full & ~S_outfifo_wfull);
	// assign 	 W_ready =  ~W_label_valid | (L_arb_res[3] & ~L_outfifo_wfull) | (W_arb_res[3] & ~W_full & ~W_outfifo_wfull)| (E_arb_res[3] & ~E_full & ~E_outfifo_wfull)| (N_arb_res[3] & ~N_full & ~N_outfifo_wfull)| (S_arb_res[3] & ~S_full & ~S_outfifo_wfull);
	// assign 	 N_ready =  ~N_label_valid | (L_arb_res[2] & ~L_outfifo_wfull) | (W_arb_res[2] & ~W_full & ~W_outfifo_wfull)| (E_arb_res[2] & ~E_full & ~E_outfifo_wfull)| (N_arb_res[2] & ~N_full & ~N_outfifo_wfull)| (S_arb_res[2] & ~S_full & ~S_outfifo_wfull);
	// assign 	 E_ready =  ~E_label_valid | (L_arb_res[1] & ~L_outfifo_wfull) | (W_arb_res[1] & ~W_full & ~W_outfifo_wfull)| (E_arb_res[1] & ~E_full & ~E_outfifo_wfull)| (N_arb_res[1] & ~N_full & ~N_outfifo_wfull)| (S_arb_res[1] & ~S_full & ~S_outfifo_wfull);
	// assign 	 S_ready =  ~S_label_valid | (L_arb_res[0] & ~L_outfifo_wfull) | (W_arb_res[0] & ~W_full & ~W_outfifo_wfull)| (E_arb_res[0] & ~E_full & ~E_outfifo_wfull)| (N_arb_res[0] & ~N_full & ~N_outfifo_wfull)| (S_arb_res[0] & ~S_full & ~S_outfifo_wfull);

	assign 	 L_ready =  ~L_label_valid | (L_arb_res[4] & ~L_full & ~(L_outfifo_wfull & L_data_in[0])) | (W_arb_res[4] & ~W_full & ~(W_outfifo_wfull & L_data_in[0]))| (E_arb_res[4] & ~E_full & ~(E_outfifo_wfull & L_data_in[0]))| (N_arb_res[4] & ~N_full & ~(N_outfifo_wfull & L_data_in[0]))| (S_arb_res[4] & ~S_full & ~(S_outfifo_wfull & L_data_in[0]));
	assign 	 W_ready =  ~W_label_valid | (L_arb_res[3] & ~L_full & ~(L_outfifo_wfull & W_data_in[0])) | (W_arb_res[3] & ~W_full & ~(W_outfifo_wfull & W_data_in[0]))| (E_arb_res[3] & ~E_full & ~(E_outfifo_wfull & W_data_in[0]))| (N_arb_res[3] & ~N_full & ~(N_outfifo_wfull & W_data_in[0]))| (S_arb_res[3] & ~S_full & ~(S_outfifo_wfull & W_data_in[0]));
	assign 	 N_ready =  ~N_label_valid | (L_arb_res[2] & ~L_full & ~(L_outfifo_wfull & N_data_in[0])) | (W_arb_res[2] & ~W_full & ~(W_outfifo_wfull & N_data_in[0]))| (E_arb_res[2] & ~E_full & ~(E_outfifo_wfull & N_data_in[0]))| (N_arb_res[2] & ~N_full & ~(N_outfifo_wfull & N_data_in[0]))| (S_arb_res[2] & ~S_full & ~(S_outfifo_wfull & N_data_in[0]));
	assign 	 E_ready =  ~E_label_valid | (L_arb_res[1] & ~L_full & ~(L_outfifo_wfull & E_data_in[0])) | (W_arb_res[1] & ~W_full & ~(W_outfifo_wfull & E_data_in[0]))| (E_arb_res[1] & ~E_full & ~(E_outfifo_wfull & E_data_in[0]))| (N_arb_res[1] & ~N_full & ~(N_outfifo_wfull & E_data_in[0]))| (S_arb_res[1] & ~S_full & ~(S_outfifo_wfull & E_data_in[0]));
	assign 	 S_ready =  ~S_label_valid | (L_arb_res[0] & ~L_full & ~(L_outfifo_wfull & S_data_in[0])) | (W_arb_res[0] & ~W_full & ~(W_outfifo_wfull & S_data_in[0]))| (E_arb_res[0] & ~E_full & ~(E_outfifo_wfull & S_data_in[0]))| (N_arb_res[0] & ~N_full & ~(N_outfifo_wfull & S_data_in[0]))| (S_arb_res[0] & ~S_full & ~(S_outfifo_wfull & S_data_in[0]));


	always @(*) begin
		case(L_arb_res)
			5'b00001:begin
				L_data_src = S_data_in;
				L_port_valid =  S_valid_in;
			end
			5'b00010:begin
				L_data_src= E_data_in;
				L_port_valid= E_valid_in;
			end
			5'b00100:begin
				L_data_src=N_data_in;
				L_port_valid= N_valid_in;
			end
			5'b01000:begin
				L_data_src=W_data_in;
				L_port_valid= W_valid_in;
			end
			5'b10000:begin
				L_data_src=L_data_in;
				L_port_valid= L_valid_in;
			end
			default:begin
				L_data_src	=	'hdeadface;
				L_port_valid = 0;
			end
			endcase
	end


			always @(*) begin
		case(W_arb_res)
			5'b00001:begin
				W_data_src=S_data_in;
				W_port_valid= S_valid_in;
			end
			5'b00010:begin
				W_data_src=E_data_in;
				W_port_valid= E_valid_in;
			end
			5'b00100:begin
				W_data_src=N_data_in;
				W_port_valid= N_valid_in;
			end
			5'b01000:begin
				W_data_src=W_data_in;
				W_port_valid= W_valid_in;
			end
			5'b10000:begin
				W_data_src=L_data_in;
				W_port_valid= L_valid_in;
			end
			default:begin
				W_data_src	=	'hdeadface;
				W_port_valid = 0;
			end
			endcase
	end

		always @(*) begin
		case(N_arb_res)
			5'b00001:begin
				N_data_src=S_data_in;
				N_port_valid= S_valid_in;
			end
			5'b00010:begin
				N_data_src=E_data_in;
				N_port_valid= E_valid_in;
			end
			5'b00100:begin
				N_data_src=N_data_in;
				N_port_valid= N_valid_in;
			end
			5'b01000:begin
				N_data_src=W_data_in;
				N_port_valid= W_valid_in;
			end
			5'b10000:begin
				N_data_src=L_data_in;
				N_port_valid= L_valid_in;
			end
			default:begin
				N_data_src	=	'hdeadface;
				N_port_valid = 0;
			end
			endcase
	end

		always @(*) begin
		case(E_arb_res)
			5'b00001:begin
				E_data_src=S_data_in;
				E_port_valid= S_valid_in;
			end
			5'b00010:begin
				E_data_src=E_data_in;
				E_port_valid= E_valid_in;
			end
			5'b00100:begin
				E_data_src=N_data_in;
				E_port_valid= N_valid_in;
			end
			5'b01000:begin
				E_data_src=W_data_in;
				E_port_valid= W_valid_in;
			end
			5'b10000:begin
				E_data_src=L_data_in;
				E_port_valid= L_valid_in;
			end
			default:begin
				E_data_src	=	'hdeadface;
				E_port_valid = 0;
			end
			endcase
	end

		always @(*) begin
		case(S_arb_res)
			5'b00001:begin
				S_data_src=S_data_in;
				S_port_valid= S_valid_in;
			end
			5'b00010:begin
				S_data_src=E_data_in;
				S_port_valid= E_valid_in;
			end
			5'b00100:begin
				S_data_src=N_data_in;
				S_port_valid= N_valid_in;
			end
			5'b01000:begin
				S_data_src=W_data_in;
				S_port_valid= W_valid_in;
			end
			5'b10000:begin
				S_data_src=L_data_in;
				S_port_valid= L_valid_in;
			end
			default:begin
				S_data_src	=	'hdeadface;
				S_port_valid = 0;
			end
		endcase
		end

		reg L_data_valid_pre;
		reg W_data_valid_pre;
		reg N_data_valid_pre;
		reg E_data_valid_pre;
		reg S_data_valid_pre;

		assign L_data_valid = L_data_valid_pre;
		assign W_data_valid = W_data_valid_pre;
		assign N_data_valid = N_data_valid_pre;
		assign E_data_valid = E_data_valid_pre;
		assign S_data_valid = S_data_valid_pre;

		reg W_full_d, N_full_d, S_full_d, E_full_d, L_full_d;
		reg W_outfifo_wfull_d, N_outfifo_wfull_d, S_outfifo_wfull_d, E_outfifo_wfull_d, L_outfifo_wfull_d;
		reg W_outfifo_wfull_d2, N_outfifo_wfull_d2, S_outfifo_wfull_d2, E_outfifo_wfull_d2, L_outfifo_wfull_d2;

		always @(posedge clk) begin
			W_full_d <= W_full;
			W_outfifo_wfull_d <= W_outfifo_wfull;
			W_outfifo_wfull_d2 <= W_outfifo_wfull_d;
		end

		always @(posedge clk) begin
			N_full_d <= N_full;
			N_outfifo_wfull_d <= N_outfifo_wfull;
			N_outfifo_wfull_d2 <= N_outfifo_wfull_d;
		end


		always @(posedge clk) begin
			E_full_d <= E_full;
			E_outfifo_wfull_d <= E_outfifo_wfull;
			E_outfifo_wfull_d2 <= E_outfifo_wfull_d;
		end


		always @(posedge clk) begin
			S_full_d <= S_full;
			S_outfifo_wfull_d <= S_outfifo_wfull;
			S_outfifo_wfull_d2 <= S_outfifo_wfull_d;
		end

		always @(posedge clk) begin
			L_full_d <= L_full;
			L_outfifo_wfull_d <= L_outfifo_wfull;
			L_outfifo_wfull_d2 <= L_outfifo_wfull_d;
		end

		//20241220 valid mismatch
		reg [DATASIZE-1:0]	L_data_exp;
		reg [DATASIZE-1:0]	S_data_exp;
		reg [DATASIZE-1:0]	W_data_exp;
		reg [DATASIZE-1:0]	N_data_exp;
		reg [DATASIZE-1:0]	E_data_exp;
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				S_data_exp <= 'hdeadface;
			else if(S_port_valid)
				S_data_exp <= S_data_src;
			//20250210
			else if(S_data_valid&&!S_full&&(S_data_src==S_data_exp))
				S_data_exp <= (S_data_exp[0]&&S_outfifo_wfull) ? S_data_exp :'hdeadface;
			else S_data_exp <= S_data_exp;
		end
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				W_data_exp <= 'hdeadface;
			else if(W_port_valid)
				W_data_exp <= W_data_src;
			//20250210
			else if(W_data_valid&&!W_full&&(W_data_src==W_data_exp))
				W_data_exp <= (W_data_exp[0]&&W_outfifo_wfull) ? W_data_exp :'hdeadface;
			else W_data_exp <= W_data_exp;
		end
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				N_data_exp <= 'hdeadface;
			else if(N_port_valid)
				N_data_exp <= N_data_src;
			//20250210
			else if(N_data_valid&&!N_full&&(N_data_src==N_data_exp))
				N_data_exp <= (N_data_exp[0]&&N_outfifo_wfull) ? N_data_exp :'hdeadface;
			else N_data_exp <= N_data_exp;
		end
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				E_data_exp <= 'hdeadface;
			else if(E_port_valid)
				E_data_exp <= E_data_src;
			//20250210
			else if(E_data_valid&&!E_full&&(E_data_src==E_data_exp))
				E_data_exp <= (E_data_exp[0]&&E_outfifo_wfull) ? E_data_exp :'hdeadface;
			else E_data_exp <= E_data_exp;
		end
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				L_data_exp <= 'hdeadface;
			else if(L_port_valid)
				L_data_exp <= L_data_src;
			//20250210
			else if(L_data_valid&&!L_full&&(L_data_src==L_data_exp))
				L_data_exp <= (L_data_exp[0]&&L_outfifo_wfull) ? L_data_exp : 'hdeadface;
			else if(L_data_valid&&!L_full&&L_data_out[0]&&L_outfifo_wfull)
				L_data_exp <= 'hdeadface;
			else L_data_exp <= L_data_exp;
		end

		// 20241221
		reg L_valid_out_tmp;
		reg W_valid_out_tmp;
		reg N_valid_out_tmp;
		reg E_valid_out_tmp;
		reg S_valid_out_tmp;
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) L_valid_out_tmp <= 0;
			else if(grant_L[4]&&!L_arb_res[4]&&L_valid_in)
				L_valid_out_tmp <= 1;
			else if(grant_L[3]&&!L_arb_res[3]&&W_valid_in)
				L_valid_out_tmp <= 1;
			else if(grant_L[2]&&!L_arb_res[2]&&N_valid_in)
				L_valid_out_tmp <= 1;
			else if(grant_L[1]&&!L_arb_res[1]&&E_valid_in)
				L_valid_out_tmp <= 1;
			else if(grant_L[0]&&!L_arb_res[0]&&S_valid_in)
				L_valid_out_tmp <= 1;
			else if(L_data_valid)
				L_valid_out_tmp <= 0;
			else L_valid_out_tmp <= L_valid_out_tmp;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) W_valid_out_tmp <= 0;
			else if(grant_W[4]&&!W_arb_res[4]&&L_valid_in)
				W_valid_out_tmp <= 1;
			else if(grant_W[3]&&!W_arb_res[3]&&W_valid_in)
				W_valid_out_tmp <= 1;
			else if(grant_W[2]&&!W_arb_res[2]&&N_valid_in)
				W_valid_out_tmp <= 1;
			else if(grant_W[1]&&!W_arb_res[1]&&E_valid_in)
				W_valid_out_tmp <= 1;
			else if(grant_W[0]&&!W_arb_res[0]&&S_valid_in)
				W_valid_out_tmp <= 1;
			else if(W_data_valid)
				W_valid_out_tmp <= 0;
			else W_valid_out_tmp <= W_valid_out_tmp;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) N_valid_out_tmp <= 0;
			else if(grant_N[4]&&!N_arb_res[4]&&L_valid_in)
				N_valid_out_tmp <= 1;
			else if(grant_N[3]&&!N_arb_res[3]&&W_valid_in)
				N_valid_out_tmp <= 1;
			else if(grant_N[2]&&!N_arb_res[2]&&N_valid_in)
				N_valid_out_tmp <= 1;
			else if(grant_N[1]&&!N_arb_res[1]&&E_valid_in)
				N_valid_out_tmp <= 1;
			else if(grant_N[0]&&!N_arb_res[0]&&S_valid_in)
				N_valid_out_tmp <= 1;
			else if(N_data_valid)
				N_valid_out_tmp <= 0;
			else N_valid_out_tmp <= N_valid_out_tmp;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) E_valid_out_tmp <= 0;
			else if(grant_E[4]&&!E_arb_res[4]&&L_valid_in)
				E_valid_out_tmp <= 1;
			else if(grant_E[3]&&!E_arb_res[3]&&W_valid_in)
				E_valid_out_tmp <= 1;
			else if(grant_E[2]&&!E_arb_res[2]&&N_valid_in)
				E_valid_out_tmp <= 1;
			else if(grant_E[1]&&!E_arb_res[1]&&E_valid_in)
				E_valid_out_tmp <= 1;
			else if(grant_E[0]&&!E_arb_res[0]&&S_valid_in)
				E_valid_out_tmp <= 1;
			else if(E_data_valid)
				E_valid_out_tmp <= 0;
			else E_valid_out_tmp <= E_valid_out_tmp;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) S_valid_out_tmp <= 0;
			else if(grant_S[4]&&!S_arb_res[4]&&L_valid_in)
				S_valid_out_tmp <= 1;
			else if(grant_S[3]&&!S_arb_res[3]&&W_valid_in)
				S_valid_out_tmp <= 1;
			else if(grant_S[2]&&!S_arb_res[2]&&N_valid_in)
				S_valid_out_tmp <= 1;
			else if(grant_S[1]&&!S_arb_res[1]&&E_valid_in)
				S_valid_out_tmp <= 1;
			else if(grant_S[0]&&!S_arb_res[0]&&S_valid_in)
				S_valid_out_tmp <= 1;
			else if(S_data_valid)
				S_valid_out_tmp <= 0;
			else S_valid_out_tmp <= S_valid_out_tmp;
		end

		// modified ends

		// always @(posedge clk or negedge rst_n) begin
		// 	if (!rst_n) begin
		// 			L_data_valid_pre	<=		0;
		// 			L_data_out	<=		0;
		// 	end
		// 	else if((L_outfifo_wfull&&L_data_src[0])) begin
		// 			L_data_valid_pre	<=		1'b0;
		// 			L_data_out	<=		L_data_out;
		// 	end
		// 	else if(L_outfifo_wfull && L_data_valid_pre==0 ) begin
		// 		L_data_valid_pre	<=		L_port_valid;
		// 		L_data_out	<=		L_data_src;
		// 	end
		// 	else if(L_outfifo_wfull &&L_data_valid_pre ==1&&(L_data_out==L_data_src)) begin
		// 		L_data_valid_pre	<=		1'b0;
		// 		L_data_out	<=		L_data_src;
		// 	end
		// 	else begin
		// 			// L_data_valid_pre	<=		(L_data_src != 'hdeadface) &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out) ? (L_data_src!= 'hdeadface) : L_port_valid;
		// 			// 20241220
		// 			// L_data_valid_pre		<=	((L_data_src != 'hdeadface)  &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out)) ? (L_data_src == L_data_exp)||L_port_valid :	L_port_valid;
		// 			// 1221
		// 			L_data_valid_pre		<=	((L_data_src != 'hdeadface)  &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out)) ? (L_data_src == L_data_exp)||L_port_valid||(!L_outfifo_wfull_d && L_valid_out_tmp)  :	L_port_valid ;
					
				
		// 			L_data_out	<=		L_data_src;
		// 	end
		// end

		reg [DATASIZE-1:0]	S_data_prev;
		reg [DATASIZE-1:0]	W_data_prev;
		reg [DATASIZE-1:0]	N_data_prev;
		reg [DATASIZE-1:0]	E_data_prev;
		reg [DATASIZE-1:0]	L_data_prev;

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				S_data_prev <= 'hdeadface;
			else if(S_data_valid && (!S_full))
				S_data_prev <= S_data_out;
			else S_data_prev <= S_data_prev;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				W_data_prev <= 'hdeadface;
			else if(W_data_valid && (!W_full))
				W_data_prev <= W_data_out;
			else W_data_prev <= W_data_prev;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				N_data_prev <= 'hdeadface;
			else if(N_data_valid && (!N_full))
				N_data_prev <= N_data_out;
			else N_data_prev <= N_data_prev;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				E_data_prev <= 'hdeadface;
			else if(E_data_valid && (!E_full))
				E_data_prev <= E_data_out;
			else E_data_prev <= E_data_prev;
		end

		always @(posedge clk or negedge rst_n) begin
			if(!rst_n)
				L_data_prev <= 'hdeadface;
			else if(L_data_valid && (!L_full))
				L_data_prev <= L_data_out;
			else L_data_prev <= L_data_prev;
		end

		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
					W_data_valid_pre	<=		0;
					W_data_out	<=		0;
			end
			else if(W_full) begin
					W_data_valid_pre	<=		W_data_valid_pre;
					W_data_out	<=		W_data_out;
			end
			else if(W_outfifo_wfull&&W_data_src[0]) begin
				W_data_valid_pre	<=		1'b0;
				W_data_out	<=		W_data_out;
			end
			else if(W_outfifo_wfull &&W_data_valid_pre ==0) begin
				// W_data_valid_pre	<=		(W_full_d) ? (W_data_src!= 'hdeadface && W_data_src!=W_data_prev) :W_port_valid;
				// 0210
				W_data_valid_pre	<=		(W_full_d) ? ( W_data_src!= 'h0 && W_data_src!= 'hdeadface && W_data_src!=W_data_prev) :W_port_valid;
				W_data_out	<=		W_data_src;
			end
			else if(W_outfifo_wfull &&W_data_valid_pre ==1&&(W_data_out==W_data_src)) begin
				W_data_valid_pre	<=		1'b0;
				W_data_out	<=		W_data_src;
			end
			else begin
					// W_data_valid_pre		<=		((W_data_src != 'hdeadface) &&(W_outfifo_wfull_d||W_outfifo_wfull_d2) &&(W_data_valid_pre==1'b0)&&(W_data_src!=W_data_out)) || (W_full_d) ? (W_data_src!= 'hdeadface && W_data_src!=W_data_prev) : W_port_valid;
					// 20241220
					// W_data_valid_pre		<=	((W_data_src != 'hdeadface)  &&(W_outfifo_wfull_d||W_outfifo_wfull_d2)&&(W_data_valid_pre==1'b0)&&(W_data_src!=W_data_out)) || (W_full_d) ? (W_data_src == W_data_exp)||W_port_valid :	W_port_valid;	
					// 1221
					// W_data_valid_pre		<=	((W_data_src != 'hdeadface)  &&(W_outfifo_wfull_d||W_outfifo_wfull_d2)&&(W_data_valid_pre==1'b0)&&(W_data_src!=W_data_out)) || (W_full_d) ? (W_data_src == W_data_exp)||W_port_valid||(!W_outfifo_wfull_d && W_valid_out_tmp)  :	W_port_valid ;
					// 0210
					W_data_valid_pre		<=	((W_data_src != 'hdeadface)  &&(W_outfifo_wfull_d||W_outfifo_wfull_d2)&&(W_data_valid_pre==1'b0)&&(W_data_src!=W_data_out)) || (W_full_d) ? (W_data_src!= 'hdeadface && (W_data_src == W_data_exp))||W_port_valid||(!W_outfifo_wfull_d && W_valid_out_tmp)  :	W_port_valid ;
					W_data_out			<=		W_data_src;
			end
		end

		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
					S_data_valid_pre	<=		0;
					S_data_out	<=		0;
			end
			else if(S_full) begin
					S_data_valid_pre	<=		S_data_valid_pre;
					S_data_out	<=		S_data_out;
			end
			else if(S_outfifo_wfull&&S_data_src[0]) begin
				S_data_valid_pre	<=		1'b0;
				S_data_out	<=		S_data_out;
			end

			else if(S_outfifo_wfull && S_data_valid_pre==0) begin
				// S_data_valid_pre	<=		(S_full_d) ? (S_data_src!= 'hdeadface && S_data_src!=S_data_prev) :S_port_valid;
				// 0210
				S_data_valid_pre	<=		(S_full_d) ? (S_data_src!= 'h0 && S_data_src!= 'hdeadface && S_data_src!=S_data_prev) :S_port_valid;
				S_data_out	<=		S_data_src;
			end
			else if(S_outfifo_wfull &&S_data_valid_pre ==1&&(S_data_out==S_data_src)) begin
				S_data_valid_pre	<=		1'b0;
				S_data_out	<=		S_data_src;
			end
			else begin
					// S_data_valid_pre		<=		((S_data_src != 'hdeadface) &&(S_outfifo_wfull_d||S_outfifo_wfull_d2)&&(S_data_valid_pre==1'b0)&&(S_data_src!=S_data_out)) || (S_full_d) ? (S_data_src!= 'hdeadface&& S_data_src!=S_data_prev) : S_port_valid;
					// 20241220
					// S_data_valid_pre		<=	((S_data_src != 'hdeadface)  &&(S_outfifo_wfull_d||S_outfifo_wfull_d2)&&(S_data_valid_pre==1'b0)&&(S_data_src!=S_data_out)) || (S_full_d) ? (S_data_src == S_data_exp)||S_port_valid :	S_port_valid ;
					// 1221
					// S_data_valid_pre		<=	((S_data_src != 'hdeadface)  &&(S_outfifo_wfull_d||S_outfifo_wfull_d2)&&(S_data_valid_pre==1'b0)&&(S_data_src!=S_data_out)) || (S_full_d) ? (S_data_src == S_data_exp)||S_port_valid||(!S_outfifo_wfull_d && S_valid_out_tmp)  :	S_port_valid ;
					// 0210
					S_data_valid_pre		<=	((S_data_src != 'hdeadface)  &&(S_outfifo_wfull_d||S_outfifo_wfull_d2)&&(S_data_valid_pre==1'b0)&&(S_data_src!=S_data_out)) || (S_full_d) ? (S_data_src!= 'hdeadface&& (S_data_src == S_data_exp))||S_port_valid||(!S_outfifo_wfull_d && S_valid_out_tmp)  :	S_port_valid ;
					S_data_out			<=		S_data_src;
			end
		end


		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
					N_data_valid_pre	<=		0;
					N_data_out	<=		0;
			end
			else if(N_full) begin
					N_data_valid_pre	<=		N_data_valid_pre;
					N_data_out	<=		N_data_out;
			end
			else if(N_outfifo_wfull&&N_data_src[0]) begin
				N_data_valid_pre	<=		1'b0;
				N_data_out	<=		N_data_out;
			end

			else if(N_outfifo_wfull && N_data_valid_pre==0) begin
				// N_data_valid_pre	<=		(N_full_d) ? (N_data_src!= 'hdeadface && N_data_src!=N_data_prev) : N_port_valid;
				// 0210
				N_data_valid_pre	<=		(N_full_d) ? (N_data_src!= 'h0 && N_data_src!= 'hdeadface && N_data_src!=N_data_prev) : N_port_valid;
				N_data_out	<=		N_data_src;
			end
			else if(N_outfifo_wfull &&N_data_valid_pre ==1&&(N_data_out==N_data_src)) begin
				N_data_valid_pre	<=		1'b0;
				N_data_out	<=		N_data_src;
			end
			else begin
					// N_data_valid_pre		<=	((N_data_src != 'hdeadface)  &&(N_outfifo_wfull_d||N_outfifo_wfull_d2)&&(N_data_valid_pre==1'b0)&&(N_data_src!=N_data_out)) || (N_full_d) ? (N_data_src!= 'hdeadface&& N_data_src!=N_data_prev) :	N_port_valid;
					// 20241220
					//N_data_valid_pre		<=	((N_data_src != 'hdeadface)  &&(N_outfifo_wfull_d||N_outfifo_wfull_d2)&&(N_data_valid_pre==1'b0)&&(N_data_src!=N_data_out)) || (N_full_d) ? (N_data_src == N_data_exp)||N_port_valid  :	N_port_valid ;
					// 1221
					// N_data_valid_pre		<=	((N_data_src != 'hdeadface)  &&(N_outfifo_wfull_d||N_outfifo_wfull_d2)&&(N_data_valid_pre==1'b0)&&(N_data_src!=N_data_out)) || (N_full_d) ? (N_data_src == N_data_exp)||N_port_valid||(!N_outfifo_wfull_d && N_valid_out_tmp)  :	N_port_valid ;
					//0210
					N_data_valid_pre		<=	((N_data_src != 'hdeadface)  &&(N_outfifo_wfull_d||N_outfifo_wfull_d2)&&(N_data_valid_pre==1'b0)&&(N_data_src!=N_data_out)) || (N_full_d) ? ((N_data_src!= 'hdeadface)&&(N_data_src == N_data_exp))||N_port_valid||(!N_outfifo_wfull_d && N_valid_out_tmp)  :	N_port_valid ;
					N_data_out			<=		N_data_src;
			end
		end


		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
					E_data_valid_pre	<=		0;
					E_data_out	<=		0;
			end
			else if(E_full) begin
					E_data_valid_pre	<=		E_data_valid_pre;
					E_data_out	<=		E_data_out;
			end
			else if(E_outfifo_wfull&&E_data_src[0]) begin
				E_data_valid_pre	<=		1'b0;
				E_data_out	<=		E_data_out;
			end

			else if(E_outfifo_wfull && E_data_valid_pre==0) begin
				// E_data_valid_pre	<=		(E_full_d) ? (E_data_src!= 'hdeadface && E_data_src!=E_data_prev) :E_port_valid;
				// 0210
				E_data_valid_pre	<=		(E_full_d) ? ( E_data_src!= 'h0 &&  E_data_src!= 'hdeadface && E_data_src!=E_data_prev) :E_port_valid;
				E_data_out	<=		E_data_src;
			end
			else if(E_outfifo_wfull &&E_data_valid_pre ==1&&(E_data_out==E_data_src)) begin
				E_data_valid_pre	<=		1'b0;
				E_data_out	<=		E_data_src;
			end
			else begin
					// E_data_valid_pre		<=	((E_data_src != 'hdeadface) &&(E_outfifo_wfull_d||E_outfifo_wfull_d2)&&(E_data_valid_pre==1'b0)&&(E_data_src!=E_data_out)) || (E_full_d) ? (E_data_src!= 'hdeadface&& E_data_src!=E_data_prev) :	E_port_valid;
					// 20241220
					// E_data_valid_pre		<=	((E_data_src != 'hdeadface)  &&(E_outfifo_wfull_d||E_outfifo_wfull_d2)&&(E_data_valid_pre==1'b0)&&(E_data_src!=E_data_out)) || (E_full_d) ? (E_data_src == E_data_exp)||E_port_valid :	E_port_valid;// ||(_d && !)
					// 1221
					// E_data_valid_pre		<=	((E_data_src != 'hdeadface)  &&(E_outfifo_wfull_d||E_outfifo_wfull_d2)&&(E_data_valid_pre==1'b0)&&(E_data_src!=E_data_out)) || (E_full_d) ? (E_data_src == E_data_exp)||E_port_valid||(!E_outfifo_wfull_d && E_valid_out_tmp)  :	E_port_valid ;
					// 0210
					E_data_valid_pre		<=	((E_data_src != 'hdeadface)  &&(E_outfifo_wfull_d||E_outfifo_wfull_d2)&&(E_data_valid_pre==1'b0)&&(E_data_src!=E_data_out)) || (E_full_d) ? (E_data_src!= 'hdeadface&& (E_data_src == E_data_exp))||E_port_valid||(!E_outfifo_wfull_d && E_valid_out_tmp)  :	E_port_valid ;
					E_data_out			<=		E_data_src;
			end
		end

		always @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
					L_data_valid_pre	<=		0;
					L_data_out	<=		0;
			end
			else if(L_full) begin
					L_data_valid_pre	<=		L_data_valid_pre;
					L_data_out	<=		L_data_out;
			end
			else if((L_outfifo_wfull&&L_data_src[0])) begin
					L_data_valid_pre	<=		1'b0;
					L_data_out	<=		L_data_out;
			end
			else if(L_outfifo_wfull && L_data_valid_pre==0 ) begin
				// L_data_valid_pre	<=		(L_full_d) ? (L_data_src!= 'hdeadface && L_data_src!=L_data_prev) :L_port_valid;
				// 0210
				L_data_valid_pre	<=		(L_full_d) ? (L_data_src!= 'h0 && L_data_src!= 'hdeadface && L_data_src!=L_data_prev) :L_port_valid;
				L_data_out	<=		L_data_src;
			end
			else if(L_outfifo_wfull &&L_data_valid_pre ==1&&(L_data_out==L_data_src)) begin
				L_data_valid_pre	<=		1'b0;
				L_data_out	<=		L_data_src;
			end
			else begin
					// L_data_valid_pre	<=		(L_data_src != 'hdeadface) &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out) ? (L_data_src!= 'hdeadface) : L_port_valid;
					// 20241220
					// L_data_valid_pre		<=	((L_data_src != 'hdeadface)  &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out)) ? (L_data_src == L_data_exp)||L_port_valid :	L_port_valid;
					// 1221
					// L_data_valid_pre		<=	((L_data_src != 'hdeadface)  &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out)) || (L_full_d) ? (L_data_src == L_data_exp)||L_port_valid||(!L_outfifo_wfull_d && L_valid_out_tmp)  :	L_port_valid ;
					// 0210
					L_data_valid_pre		<=	((L_data_src != 'hdeadface)  &&(L_outfifo_wfull_d||L_outfifo_wfull_d2)&&(L_data_valid_pre==1'b0)&&(L_data_src!=L_data_out)) || (L_full_d) ? (L_data_src!= 'hdeadface && (L_data_src == L_data_exp))||L_port_valid||(!L_outfifo_wfull_d && L_valid_out_tmp)  :	L_port_valid ;
				
					L_data_out	<=		L_data_src;
			end
		end

		// always @(posedge clk or negedge rst_n) begin
		// 	if (!rst_n) begin
		// 			E_data_valid_pre	<=		0;
		// 			E_data_out	<=		0;
		// 	end
		// 	else if((!(E_outfifo_wfull&&E_data_src[0]))&&(!E_full_d)) begin
		// 			E_data_valid_pre	<=		E_port_valid;
		// 			E_data_out	<=		E_data_src;
		// 	end
		// 	else if(E_outfifo_wfull) begin
		// 		E_data_valid_pre	<=		1'b0;
		// 		E_data_out	<=		E_data_out;
		// 	end
		// 	else begin
		// 			E_data_valid_pre		<=		E_data_valid_pre;
		// 			E_data_out			<=		E_data_out;
		// 	end
		// end

		// always @(posedge clk or negedge rst_n) begin
		// 	if (!rst_n) begin
		// 			N_data_valid_pre	<=		0;
		// 			N_data_out	<=		0;
		// 	end
		// 	else if((!(N_outfifo_wfull&&N_data_src[0]))&&(!N_full_d)) begin
		// 			N_data_valid_pre	<=		N_port_valid;
		// 			N_data_out	<=		N_data_src;
		// 	end
		// 	else if(N_outfifo_wfull) begin
		// 		N_data_valid_pre	<=		1'b0;
		// 		N_data_out	<=		N_data_out;
		// 	end
		// 	else begin
		// 			N_data_valid_pre		<=		N_data_valid_pre;
		// 			N_data_out			<=		N_data_out;
		// 	end
		// end


		// always @(posedge clk or negedge rst_n) begin
		// 	if (!rst_n) begin
		// 			S_data_valid_pre	<=		0;
		// 			S_data_out	<=		0;
		// 	end
		// 	else if((!(S_outfifo_wfull&&S_data_src[0]))&&(!S_full_d)) begin
		// 			S_data_valid_pre	<=		S_port_valid;
		// 			S_data_out	<=		S_data_src;
		// 	end
		// 	else if(S_outfifo_wfull) begin
		// 		S_data_valid_pre	<=		1'b0;
		// 		S_data_out	<=		S_data_out;
		// 	end
		// 	else begin
		// 			S_data_valid_pre		<=		S_data_valid_pre;
		// 			S_data_out			<=		S_data_out;
		// 	end
		// end


endmodule