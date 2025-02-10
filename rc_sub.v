`include "./noc_define.v"

module rc_sub#(
  parameter DATASIZE=40  //src:4bit, dst:4bit, timestamp:8bit, data:22bit, type:2bit
  )(
  input wire [3:0] ID,

  output reg[DATASIZE-1:0] data_out,
  output reg[3:0] direction_out,
  output reg valid_out,
  output reg infifo_winc,

  input wire[DATASIZE-1:0] data_in,
  input wire valid_in,
  input wire rc_ready,
  input wire infifo_wfull,
  output wire fifo_ready,

  input wire rc_clk,
  input wire rst_n
  );

  wire[3:0] dst, src;
  assign src=data_in[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH];
  assign dst=data_in[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH];

  reg[3:0] direction;
  reg[3:0] direction_out_pre;

  reg rc_ready_d;

  // always@(posedge rc_clk or negedge rst_n) begin
  //   if(!rst_n) infifo_winc <= 1'b0;
  //   else if(infifo_wfull) infifo_winc <= infifo_winc;
  //   else if(!rc_ready) infifo_winc <= 1'b0;
  //   else if(src==dst) infifo_winc <= 1'b0;
  //   else if(rc_ready && !rc_ready_d && valid_out==0) infifo_winc <= data_in[0];
  //   else infifo_winc <= (valid_in)&&data_in[0];
  // end
  always@(*) begin
      infifo_winc = data_out[0] && valid_out;

  end


  reg infifo_wfull_d,infifo_wfull_d2;

  always @(posedge rc_clk) begin
    infifo_wfull_d<=infifo_wfull;
    infifo_wfull_d2 <= infifo_wfull_d;
    rc_ready_d <= rc_ready;
  end

  reg fifo_ready_test;
  // assign fifo_ready = infifo_wfull ? 1'b0 : rc_ready;
  // assign fifo_ready = (infifo_wfull)&&(!((valid_in)&&(data_in[0]))) ? 1'b0 : rc_ready;
  // assign fifo_ready = (infifo_wfull) ? ((data_in[0]) ?  (valid_in ?  1'b0 : rc_ready) : (valid_in ? rc_ready : 1'b0)) : rc_ready;
  // assign fifo_ready = (infifo_wfull) ? ((valid_in)&&(data_in[0]) ? 1'b0 : rc_ready) : rc_ready;  
  // assign fifo_ready = rc_ready;
  assign fifo_ready = fifo_ready_test;
  always @(*) begin
     if(!infifo_wfull)
        fifo_ready_test = rc_ready;
      else if((!valid_in)&&(data_in[0]))
        fifo_ready_test = 1'b0;
      else if(!((valid_in)&&(data_in[0])))
        fifo_ready_test = rc_ready;

      else
        fifo_ready_test = 1'b0;
  end

  always@(*) begin
    // if(rc_ready_d && !valid_in) direction = 4'b0000;
    // else 
    
    if(dst[1:0]<ID[1:0]) direction=4'b1000;
    else if(dst[1:0]>ID[1:0]) direction=4'b0010;
    else if(dst[3:2]<ID[3:2]) direction=4'b0100;
    else if(dst[3:2]>ID[3:2]) direction=4'b0001;
    else direction=4'b0000;
  end

  //2024 1220 valid mismatch
  reg signed [3:0] valid_cnt;
  always @(posedge rc_clk or negedge rst_n) begin
    if(!rst_n)  
      valid_cnt <= 0;
    else if(valid_in && valid_out)
      valid_cnt <= valid_cnt;
    else if(valid_in)
      valid_cnt <= valid_cnt + 1'b1;
    else if(valid_out)
      valid_cnt <= valid_cnt - 1'b1;
    else 
      valid_cnt <= valid_cnt;
  end



  always@(posedge rc_clk or negedge rst_n) begin
    if(!rst_n) valid_out <= 1'b0;
    else if(src==dst) valid_out <= 1'b0;
    else if(!rc_ready) valid_out <= 1'b0;
    else if(infifo_wfull  && valid_in && data_in[0]) valid_out <= 1'b0;
    //20241220 modified
    //else if(rc_ready && !rc_ready_d && valid_out==0) valid_out <= 1'b1;
    else if((rc_ready && !rc_ready_d && valid_out==0)&&(valid_cnt>0 || ((valid_cnt==0) && valid_in))) begin
       valid_out <= 1'b1;
      // if(valid_cnt==0 && (!valid_in))
      //   // $display("valid_chr:%d", valid_cnt);
      //   $error("valid failed");
    end
    // else if((infifo_wfull_d ||infifo_wfull_d2)&&(valid_out==1'b0)) valid_out <= 1'b1;
    // else if((!infifo_wfull)&&(infifo_wfull_d)&&(valid_out==1'b0)&&(data_in[0])) valid_out <= 1'b1;
    // 0210
    else if((!infifo_wfull)&&(infifo_wfull_d)&&(valid_out==1'b0)&&(data_in[0])&&(valid_cnt>0)) valid_out <= 1'b1;

    else valid_out <= (valid_in);
  end

  //data_out
  always@(posedge rc_clk, negedge rst_n) begin
    if(!rst_n)
      data_out<=0;
    else if (rc_ready && ((!infifo_wfull)||((valid_in)&&(!data_in[0]))))
      data_out<=data_in;
    else if(rc_ready && !rc_ready_d && valid_out==0)
      data_out<=data_in;
    else
      data_out<=data_out;
  end

  //direction_out_pre
  //   reg[3:0] direction_out_pre_reg;
  // always @(posedge rc_clk or negedge rst_n) begin
  //   if(!rst_n)
  //     direction_out_pre_reg <= 0;
  //   else 
  //     direction_out_pre_reg <= direction_out_pre;
  // end



  // always@(*) begin
  //   if(!rst_n)
  //     direction_out_pre = 4'b1111;
  //   else if(!valid_in && !((rc_ready && !rc_ready_d)))
  //     direction_out_pre = 4'b1111;



  //   else if((!rc_ready)|(infifo_wfull  && valid_in && data_in[0] ))
  //     direction_out_pre = direction_out_pre_reg;

  //   // else if(fifo_empty)
  //   //   direction_out_pre = direction_out_pre_reg;
  //   else
  //     direction_out_pre = direction;
  // end

  //direction_out
  // always@(posedge rc_clk, negedge rst_n) begin
  //   if(!rst_n)
  //     direction_out <= 4'b1111;
  //   // else if(data_in[0]==1'b0)
  //   //   direction_out <= 4'b1111;
  //   else if((!infifo_wfull)&&(infifo_wfull_d)&&(valid_out==1'b0)&&(data_in[0]))
  //     direction_out <= direction;
  //   else if((!rc_ready)|(infifo_wfull && valid_in && data_in[0] ))
  //     direction_out <= direction_out;
  //   else
  //     direction_out <= direction_out_pre;
  // end
  // always@(posedge rc_clk, negedge rst_n) begin
  //   if(!rst_n)
  //     direction_out <= 4'b1111;
  //   else direction_out <= direction;
  // end

  reg fifo_empty, fifo_empty_d;
  always @(posedge rc_clk or negedge rst_n) begin
    if(!rst_n)
      fifo_empty<=0;
    else if(rc_ready_d && !valid_in)
      fifo_empty <= 1;
    else if( valid_in )
      fifo_empty <= 0;
    else fifo_empty <= fifo_empty; 
  end

  always @(posedge rc_clk or negedge rst_n) begin
    if(!rst_n)
      fifo_empty_d<=0;
    else 
      fifo_empty_d <= fifo_empty;
  end


  always@(posedge rc_clk, negedge rst_n) begin
    if(!rst_n)
      direction_out <= 4'b1111;
    else if((!infifo_wfull)&&(infifo_wfull_d)&&(valid_out==1'b0)&&(data_in[0]))
      direction_out <= direction;
    else if((!rc_ready)|(infifo_wfull && valid_in && data_in[0] ))
      direction_out <= direction_out;


    else if((src==dst) && fifo_empty && !valid_in)
      direction_out <= 4'b1111;



    else if(rc_ready && !rc_ready_d && valid_out==0)
      direction_out <= direction;

    else if(!valid_in && !((rc_ready && !rc_ready_d)))
      direction_out <= 4'b1111;

    else
      direction_out <= direction;
  end

  // reg [3:0] direction_d;
  // always @(posedge rc_clk or negedge rst_n) begin
  //   if(!rst_n)
  //     direction_d <= 0;
  //   else direction_d <= direction;
  // end
  // always @(*) begin
  //   direction_out = valid_out ? direction_d : 4'b1111;
  // end
endmodule











// My module 0831

// module rc_sub#(
//   parameter DATASIZE=40  //src:4bit, dst:4bit, timestamp:8bit, data:22bit, type:2bit
//   )(
//   input wire [3:0] ID,

//   output reg[DATASIZE-1:0] data_out,
//   output reg[3:0] direction_out,
//   output reg valid_out,
//   output reg infifo_winc,

//   input wire[DATASIZE-1:0] data_in,
//   input wire valid_in,
//   input wire rc_ready,
//   input wire infifo_wfull,
//   output wire fifo_ready,

//   input wire rc_clk,
//   input wire rst_n
//   );

//   wire[3:0] dst, src;
//   assign src=data_in[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH];
//   assign dst=data_in[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH];

//   reg[3:0] direction;

//   reg rc_ready_d;


//   reg infifo_wfull_d,infifo_wfull_d2;

//   always @(posedge rc_clk) begin
//     infifo_wfull_d<=infifo_wfull;
//     infifo_wfull_d2 <= infifo_wfull_d;
//     rc_ready_d <= rc_ready;
//   end

//   reg fifo_ready_test;

//   assign fifo_ready = fifo_ready_test;

//   // Original Direction
//   always@(*) begin
//     if(dst[1:0]<ID[1:0]) direction=4'b1000;
//     else if(dst[1:0]>ID[1:0]) direction=4'b0010;
//     else if(dst[3:2]<ID[3:2]) direction=4'b0100;
//     else if(dst[3:2]>ID[3:2]) direction=4'b0001;
//     else direction=4'b0000;
//   end



//   //data_out

//   always@(posedge rc_clk, negedge rst_n) begin
//     if(!rst_n) begin
//       data_out        <= 0;
//       valid_out       <= 0;
//       infifo_winc     <= 0;
//       fifo_ready_test <= 1;
//     end
//     else if(!rc_ready) begin  // next stage not ready
//       data_out        <= data_out;
//       valid_out       <= 0;
//       infifo_winc     <= 0;
//       fifo_ready_test <= 0;
//     end
//     else if (rc_ready && ((!infifo_wfull)||((valid_in || !rc_ready_d)&&(!data_in[0])))) begin // next stage ready and infifo not full/data input
//       data_out        <= data_in;
//       valid_out       <= valid_in || !rc_ready_d ;
//       infifo_winc     <= (valid_in || !rc_ready_d) && data_in[0];
//       fifo_ready_test <= 1;
//     end
//     else if (rc_ready && (infifo_wfull && ((valid_in || !rc_ready_d) && (data_in[0])))) begin // next stage ready but infifo full and req input
//       data_out        <= data_in;
//       valid_out       <= 0; 
//       infifo_winc     <= 0;
//       fifo_ready_test <= 1;
//     end
//     else begin  // next stage ready and infifo not full
//       data_out        <= data_in;
//       valid_out       <= valid_in; 
//       infifo_winc     <= valid_in && data_in[0];
//       fifo_ready_test <= 1;
//     end
//   end



//   always@(posedge rc_clk, negedge rst_n) begin
//     if(!rst_n)
//       direction_out <= 4'b1111;
//     else 
//       direction_out <= direction;
//   end

// endmodule