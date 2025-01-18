
module CircuitSwitching_handshake#(
    parameter DATASIZE=80
  )(                    
    input wire rst_n,
    input wire Tail4,//Local
    input wire Tail3,//West
    input wire Tail2,//North
    input wire Tail1,//East
    input wire Tail0,//South
    input wire Stream4,
    input wire Stream3,
    input wire Stream2,
    input wire Stream1,
    input wire Stream0,
    input wire [DATASIZE-1:0] CData4,
    input wire [DATASIZE-1:0] CData3,
    input wire [DATASIZE-1:0] CData2,
    input wire [DATASIZE-1:0] CData1,
    input wire [DATASIZE-1:0] CData0,
    input wire Ack4,
    input wire Ack3,
    input wire Ack2,
    input wire Ack1,
    input wire Ack0,
    // input wire Clock4,
    // input wire Clock3,
    // input wire Clock2,
    // input wire Clock1,
    // input wire Clock0,


    output wire [DATASIZE-1:0] CData_Out4,
    output wire [DATASIZE-1:0] CData_Out3,
    output wire [DATASIZE-1:0] CData_Out2,
    output wire [DATASIZE-1:0] CData_Out1,
    output wire [DATASIZE-1:0] CData_Out0,
    output wire Tail_Out4,
    output wire Tail_Out3,
    output wire Tail_Out2,
    output wire Tail_Out1,
    output wire Tail_Out0,
    output wire Stream_Out4,
    output wire Stream_Out3,
    output wire Stream_Out2,
    output wire Stream_Out1,
    output wire Stream_Out0,
    output wire Ack_Out4,
    output wire Ack_Out3,
    output wire Ack_Out2,
    output wire Ack_Out1,
    output wire Ack_Out0,
    // output wire Clock_Out4,
    // output wire Clock_Out3,
    // output wire Clock_Out2,
    // output wire Clock_Out1,
    // output wire Clock_Out0,


    // fifo intf
    output wire RD_in4,
    output wire RD_in3,
    output wire RD_in2,
    output wire RD_in1,
    output wire RD_in0,
    output wire RD_out4,
    output wire RD_out3,
    output wire RD_out2,
    output wire RD_out1,
    output wire RD_out0,
    input wire [4:0] DirectionIn_in4,
    input wire [4:0] DirectionIn_in3,
    input wire [4:0] DirectionIn_in2,
    input wire [4:0] DirectionIn_in1,
    input wire [4:0] DirectionIn_in0,
    input wire [4:0] DirectionIn_out4,
    input wire [4:0] DirectionIn_out3,
    input wire [4:0] DirectionIn_out2,
    input wire [4:0] DirectionIn_out1,
    input wire [4:0] DirectionIn_out0
  );

  wire TailAck4;
  wire TailAck3;
  wire TailAck2;
  wire TailAck1;
  wire TailAck0;
  wire Tail4_pulse;
  wire Tail3_pulse;
  wire Tail2_pulse;
  wire Tail1_pulse;
  wire Tail0_pulse;
  wire StreamAck4;
  wire StreamAck3;
  wire StreamAck2;
  wire StreamAck1;
  wire StreamAck0;
  wire Stream4_pulse;
  wire Stream3_pulse;
  wire Stream2_pulse;
  wire Stream1_pulse;
  wire Stream0_pulse;

  wire Tail0_pulse_4;
  wire Tail0_pulse_3;
  wire Tail0_pulse_2;
  wire Tail0_pulse_1;
  wire Tail0_pulse_0;
  wire Tail1_pulse_4;
  wire Tail1_pulse_3;
  wire Tail1_pulse_2;
  wire Tail1_pulse_1;
  wire Tail1_pulse_0;
  wire Tail2_pulse_4;
  wire Tail2_pulse_3;
  wire Tail2_pulse_2;
  wire Tail2_pulse_1;
  wire Tail2_pulse_0;
  wire Tail3_pulse_4;
  wire Tail3_pulse_3;
  wire Tail3_pulse_2;
  wire Tail3_pulse_1;
  wire Tail3_pulse_0;
  wire Tail4_pulse_4;
  wire Tail4_pulse_3;
  wire Tail4_pulse_2;
  wire Tail4_pulse_1;
  wire Tail4_pulse_0;

  wire Stream0_pulse_4;
  wire Stream0_pulse_3;
  wire Stream0_pulse_2;
  wire Stream0_pulse_1;
  wire Stream0_pulse_0;
  wire Stream1_pulse_4;
  wire Stream1_pulse_3;
  wire Stream1_pulse_2;
  wire Stream1_pulse_1;
  wire Stream1_pulse_0;
  wire Stream2_pulse_4;
  wire Stream2_pulse_3;
  wire Stream2_pulse_2;
  wire Stream2_pulse_1;
  wire Stream2_pulse_0;
  wire Stream3_pulse_4;
  wire Stream3_pulse_3;
  wire Stream3_pulse_2;
  wire Stream3_pulse_1;
  wire Stream3_pulse_0;
  wire Stream4_pulse_4;
  wire Stream4_pulse_3;
  wire Stream4_pulse_2;
  wire Stream4_pulse_1;
  wire Stream4_pulse_0;

  wire Tail0_pulse_4_TFF;
  wire Tail0_pulse_3_TFF;
  wire Tail0_pulse_2_TFF;
  wire Tail0_pulse_1_TFF;
  wire Tail1_pulse_4_TFF;
  wire Tail1_pulse_3_TFF;
  wire Tail1_pulse_2_TFF;
  wire Tail1_pulse_0_TFF;
  wire Tail2_pulse_4_TFF;
  wire Tail2_pulse_3_TFF;
  wire Tail2_pulse_1_TFF;
  wire Tail2_pulse_0_TFF;
  wire Tail3_pulse_4_TFF;
  wire Tail3_pulse_2_TFF;
  wire Tail3_pulse_1_TFF;
  wire Tail3_pulse_0_TFF;
  wire Tail4_pulse_3_TFF;
  wire Tail4_pulse_2_TFF;
  wire Tail4_pulse_1_TFF;
  wire Tail4_pulse_0_TFF;

  wire Tail0_pulse_4_TFF_DEFF;
  wire Tail0_pulse_3_TFF_DEFF;
  wire Tail0_pulse_2_TFF_DEFF;
  wire Tail0_pulse_1_TFF_DEFF;
  wire Tail1_pulse_4_TFF_DEFF;
  wire Tail1_pulse_3_TFF_DEFF;
  wire Tail1_pulse_2_TFF_DEFF;
  wire Tail1_pulse_0_TFF_DEFF;
  wire Tail2_pulse_4_TFF_DEFF;
  wire Tail2_pulse_3_TFF_DEFF;
  wire Tail2_pulse_1_TFF_DEFF;
  wire Tail2_pulse_0_TFF_DEFF;
  wire Tail3_pulse_4_TFF_DEFF;
  wire Tail3_pulse_2_TFF_DEFF;
  wire Tail3_pulse_1_TFF_DEFF;
  wire Tail3_pulse_0_TFF_DEFF;
  wire Tail4_pulse_3_TFF_DEFF;
  wire Tail4_pulse_2_TFF_DEFF;
  wire Tail4_pulse_1_TFF_DEFF;
  wire Tail4_pulse_0_TFF_DEFF;

  wire Stream0_pulse_4_TFF;
  wire Stream0_pulse_3_TFF;
  wire Stream0_pulse_2_TFF;
  wire Stream0_pulse_1_TFF;
  wire Stream1_pulse_4_TFF;
  wire Stream1_pulse_3_TFF;
  wire Stream1_pulse_2_TFF;
  wire Stream1_pulse_0_TFF;
  wire Stream2_pulse_4_TFF;
  wire Stream2_pulse_3_TFF;
  wire Stream2_pulse_1_TFF;
  wire Stream2_pulse_0_TFF;
  wire Stream3_pulse_4_TFF;
  wire Stream3_pulse_2_TFF;
  wire Stream3_pulse_1_TFF;
  wire Stream3_pulse_0_TFF;
  wire Stream4_pulse_3_TFF;
  wire Stream4_pulse_2_TFF;
  wire Stream4_pulse_1_TFF;
  wire Stream4_pulse_0_TFF;

  wire Stream0_pulse_4_TFF_DEFF;
  wire Stream0_pulse_3_TFF_DEFF;
  wire Stream0_pulse_2_TFF_DEFF;
  wire Stream0_pulse_1_TFF_DEFF;
  wire Stream1_pulse_4_TFF_DEFF;
  wire Stream1_pulse_3_TFF_DEFF;
  wire Stream1_pulse_2_TFF_DEFF;
  wire Stream1_pulse_0_TFF_DEFF;
  wire Stream2_pulse_4_TFF_DEFF;
  wire Stream2_pulse_3_TFF_DEFF;
  wire Stream2_pulse_1_TFF_DEFF;
  wire Stream2_pulse_0_TFF_DEFF;
  wire Stream3_pulse_4_TFF_DEFF;
  wire Stream3_pulse_2_TFF_DEFF;
  wire Stream3_pulse_1_TFF_DEFF;
  wire Stream3_pulse_0_TFF_DEFF;
  wire Stream4_pulse_3_TFF_DEFF;
  wire Stream4_pulse_2_TFF_DEFF;
  wire Stream4_pulse_1_TFF_DEFF;
  wire Stream4_pulse_0_TFF_DEFF;

  wire Ack_Out4_pre;
  wire Ack_Out3_pre;
  wire Ack_Out2_pre;
  wire Ack_Out1_pre;
  wire Ack_Out0_pre;


  genvar i;

  //Local
  // XOR2D0BWP30P140ULVT lib_xor4_1(.A1(Tail4), .A2(TailAck4), .Z(Tail4_pulse));

  xor(Tail4_pulse, Tail4, TailAck4);
  // XOR2D0BWP30P140ULVT lib_xor4_2(.A1(Stream4), .A2(StreamAck4), .Z(Stream4_pulse));
  xor(Stream4_pulse, Stream4, StreamAck4);

  demux demux4_1(
    .rst_n(rst_n),
    .input_wire(Tail4_pulse), .RoutingDirection(DirectionIn_in4), 
    .output0(Tail4_pulse_0), .output1(Tail4_pulse_1), 
    .output2(Tail4_pulse_2), .output3(Tail4_pulse_3), .output4(Tail4_pulse_4));
  demux demux4_2(
    .rst_n(rst_n),
    .input_wire(Stream4_pulse), .RoutingDirection(DirectionIn_in4), 
    .output0(Stream4_pulse_0), .output1(Stream4_pulse_1), 
    .output2(Stream4_pulse_2), .output3(Stream4_pulse_3), .output4(Stream4_pulse_4));
  // XOR4D0BWP30P140ULVT lib_xor4_3(
  //   .A1(Tail4_pulse_0_TFF_DEFF), .A2(Tail4_pulse_1_TFF_DEFF), 
  //   .A3(Tail4_pulse_2_TFF_DEFF), .A4(Tail4_pulse_3_TFF_DEFF), 
  //   .Z(TailAck4));

  xor(TailAck4, Tail4_pulse_0_TFF_DEFF, Tail4_pulse_1_TFF_DEFF, Tail4_pulse_2_TFF_DEFF, Tail4_pulse_3_TFF_DEFF);

  // XOR4D0BWP30P140ULVT lib_xor4_4(
  //   .A1(Stream4_pulse_0_TFF_DEFF), .A2(Stream4_pulse_1_TFF_DEFF), 
  //   .A3(Stream4_pulse_2_TFF_DEFF), .A4(Stream4_pulse_3_TFF_DEFF), 
  //   .Z(StreamAck4));

  xor(StreamAck4, Stream4_pulse_0_TFF_DEFF, Stream4_pulse_1_TFF_DEFF, Stream4_pulse_2_TFF_DEFF, Stream4_pulse_3_TFF_DEFF);

  // XOR2D0BWP30P140ULVT lib_xor4_5(.A1(TailAck4), .A2(StreamAck4), .Z(Ack_Out4));
  
  xor(Ack_Out4, TailAck4, StreamAck4);

  TFF TFF4_1_0(.rst_n(rst_n), .clk(Tail0_pulse_4), .EN(DirectionIn_out4[0]), .Q(Tail0_pulse_4_TFF));
  TFF TFF4_1_1(.rst_n(rst_n), .clk(Tail1_pulse_4), .EN(DirectionIn_out4[1]), .Q(Tail1_pulse_4_TFF));
  TFF TFF4_1_2(.rst_n(rst_n), .clk(Tail2_pulse_4), .EN(DirectionIn_out4[2]), .Q(Tail2_pulse_4_TFF));
  TFF TFF4_1_3(.rst_n(rst_n), .clk(Tail3_pulse_4), .EN(DirectionIn_out4[3]), .Q(Tail3_pulse_4_TFF));
  TFF TFF4_2_0(.rst_n(rst_n), .clk(Stream0_pulse_4), .EN(DirectionIn_out4[0]), .Q(Stream0_pulse_4_TFF));
  TFF TFF4_2_1(.rst_n(rst_n), .clk(Stream1_pulse_4), .EN(DirectionIn_out4[1]), .Q(Stream1_pulse_4_TFF));
  TFF TFF4_2_2(.rst_n(rst_n), .clk(Stream2_pulse_4), .EN(DirectionIn_out4[2]), .Q(Stream2_pulse_4_TFF));
  TFF TFF4_2_3(.rst_n(rst_n), .clk(Stream3_pulse_4), .EN(DirectionIn_out4[3]), .Q(Stream3_pulse_4_TFF));
  // XOR4D0BWP30P140ULVT lib_xor4_6(
  //   .A1(Tail0_pulse_4_TFF), .A2(Tail1_pulse_4_TFF), 
  //   .A3(Tail2_pulse_4_TFF), .A4(Tail3_pulse_4_TFF), 
  //   .Z(Tail_Out4));

  xor(Tail_Out4, Tail0_pulse_4_TFF, Tail1_pulse_4_TFF, Tail2_pulse_4_TFF, Tail3_pulse_4_TFF);

  // XOR4D0BWP30P140ULVT lib_xor4_7(
  //   .A1(Stream0_pulse_4_TFF), .A2(Stream1_pulse_4_TFF), 
  //   .A3(Stream2_pulse_4_TFF), .A4(Stream3_pulse_4_TFF), 
  //   .Z(Stream_Out4));
  
  xor(Stream_Out4, Stream0_pulse_4_TFF, Stream1_pulse_4_TFF, Stream2_pulse_4_TFF, Stream3_pulse_4_TFF);

  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CData4_mux
      mux mux4(
        .rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]),
        .RoutingDirection(DirectionIn_out4), .output_wire(CData_Out4[i]));
    end
  endgenerate
  DEFF DEFF4_1_0(.clk(Ack4), .D(Tail0_pulse_4_TFF), .Q(Tail0_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_1_1(.clk(Ack4), .D(Tail1_pulse_4_TFF), .Q(Tail1_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_1_2(.clk(Ack4), .D(Tail2_pulse_4_TFF), .Q(Tail2_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_1_3(.clk(Ack4), .D(Tail3_pulse_4_TFF), .Q(Tail3_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_2_0(.clk(Ack4), .D(Stream0_pulse_4_TFF), .Q(Stream0_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_2_1(.clk(Ack4), .D(Stream1_pulse_4_TFF), .Q(Stream1_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_2_2(.clk(Ack4), .D(Stream2_pulse_4_TFF), .Q(Stream2_pulse_4_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF4_2_3(.clk(Ack4), .D(Stream3_pulse_4_TFF), .Q(Stream3_pulse_4_TFF_DEFF), .rst_n(rst_n));
  // mux_clk mux4_clock(
  //   .rst_n(rst_n),
  //       .input0(Clock0), .input1(Clock1), .input2(Clock2), .input3(Clock3), .input4(Clock4),
  //       .RoutingDirection(DirectionIn_out4), .output_wire(Clock_Out4));



  //West
  // XOR2D0BWP30P140ULVT lib_xor3_1(.A1(Tail3), .A2(TailAck3), .Z(Tail3_pulse));

  xor(Tail3_pulse, Tail3, TailAck3);

  // XOR2D0BWP30P140ULVT lib_xor3_2(.A1(Stream3), .A2(StreamAck3), .Z(Stream3_pulse));

  xor(Stream3_pulse, Stream3, StreamAck3);

  demux demux3_1(
    .rst_n(rst_n),
    .input_wire(Tail3_pulse), .RoutingDirection(DirectionIn_in3), 
    .output0(Tail3_pulse_0), .output1(Tail3_pulse_1), 
    .output2(Tail3_pulse_2), .output3(Tail3_pulse_3), .output4(Tail3_pulse_4));
  demux demux3_2(
    .rst_n(rst_n),
    .input_wire(Stream3_pulse), .RoutingDirection(DirectionIn_in3), 
    .output0(Stream3_pulse_0), .output1(Stream3_pulse_1), 
    .output2(Stream3_pulse_2), .output3(Stream3_pulse_3), .output4(Stream3_pulse_4));
  // XOR4D0BWP30P140ULVT lib_xor3_3(
  //   .A1(Tail3_pulse_0_TFF_DEFF), .A2(Tail3_pulse_1_TFF_DEFF), 
  //   .A3(Tail3_pulse_2_TFF_DEFF), .A4(Tail3_pulse_4_TFF_DEFF), 
  //   .Z(TailAck3));

  xor(TailAck3, Tail3_pulse_0_TFF_DEFF, Tail3_pulse_1_TFF_DEFF, Tail3_pulse_2_TFF_DEFF, Tail3_pulse_4_TFF_DEFF);

  // XOR4D0BWP30P140ULVT lib_xor3_4(
  //   .A1(Stream3_pulse_0_TFF_DEFF), .A2(Stream3_pulse_1_TFF_DEFF), 
  //   .A3(Stream3_pulse_2_TFF_DEFF), .A4(Stream3_pulse_4_TFF_DEFF), 
  //   .Z(StreamAck3));

  xor(StreamAck3, Stream3_pulse_0_TFF_DEFF, Stream3_pulse_1_TFF_DEFF, Stream3_pulse_2_TFF_DEFF, Stream3_pulse_4_TFF_DEFF);

  // XOR2D0BWP30P140ULVT lib_xor3_5(.A1(TailAck3), .A2(StreamAck3), .Z(Ack_Out3));

  xor(Ack_Out3, TailAck3, StreamAck3);

  TFF TFF3_1_0(.rst_n(rst_n), .clk(Tail0_pulse_3), .EN(DirectionIn_out3[0]), .Q(Tail0_pulse_3_TFF));
  TFF TFF3_1_1(.rst_n(rst_n), .clk(Tail1_pulse_3), .EN(DirectionIn_out3[1]), .Q(Tail1_pulse_3_TFF));
  TFF TFF3_1_2(.rst_n(rst_n), .clk(Tail2_pulse_3), .EN(DirectionIn_out3[2]), .Q(Tail2_pulse_3_TFF));
  TFF TFF3_1_4(.rst_n(rst_n), .clk(Tail4_pulse_3), .EN(DirectionIn_out3[4]), .Q(Tail4_pulse_3_TFF));
  TFF TFF3_2_0(.rst_n(rst_n), .clk(Stream0_pulse_3), .EN(DirectionIn_out3[0]), .Q(Stream0_pulse_3_TFF));
  TFF TFF3_2_1(.rst_n(rst_n), .clk(Stream1_pulse_3), .EN(DirectionIn_out3[1]), .Q(Stream1_pulse_3_TFF));
  TFF TFF3_2_2(.rst_n(rst_n), .clk(Stream2_pulse_3), .EN(DirectionIn_out3[2]), .Q(Stream2_pulse_3_TFF));
  TFF TFF3_2_4(.rst_n(rst_n), .clk(Stream4_pulse_3), .EN(DirectionIn_out3[4]), .Q(Stream4_pulse_3_TFF));
  // XOR4D0BWP30P140ULVT lib_xor3_6(
  //   .A1(Tail0_pulse_3_TFF), .A2(Tail1_pulse_3_TFF), 
  //   .A3(Tail2_pulse_3_TFF), .A4(Tail4_pulse_3_TFF), 
  //   .Z(Tail_Out3));

  xor(Tail_Out3, Tail0_pulse_3_TFF, Tail1_pulse_3_TFF, Tail2_pulse_3_TFF, Tail4_pulse_3_TFF);


  // XOR4D0BWP30P140ULVT lib_xor3_7(
  //   .A1(Stream0_pulse_3_TFF), .A2(Stream1_pulse_3_TFF), 
  //   .A3(Stream2_pulse_3_TFF), .A4(Stream4_pulse_3_TFF), 
  //   .Z(Stream_Out3));
  xor(Stream_Out3, Stream0_pulse_3_TFF, Stream1_pulse_3_TFF, Stream2_pulse_3_TFF, Stream4_pulse_3_TFF);


  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CData3_mux
      mux mux3(
        .rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]),
        .RoutingDirection(DirectionIn_out3), .output_wire(CData_Out3[i]));
    end
  endgenerate
  DEFF DEFF3_1_0(.clk(Ack3), .D(Tail0_pulse_3_TFF), .Q(Tail0_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_1_1(.clk(Ack3), .D(Tail1_pulse_3_TFF), .Q(Tail1_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_1_2(.clk(Ack3), .D(Tail2_pulse_3_TFF), .Q(Tail2_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_1_4(.clk(Ack3), .D(Tail4_pulse_3_TFF), .Q(Tail4_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_2_0(.clk(Ack3), .D(Stream0_pulse_3_TFF), .Q(Stream0_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_2_1(.clk(Ack3), .D(Stream1_pulse_3_TFF), .Q(Stream1_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_2_2(.clk(Ack3), .D(Stream2_pulse_3_TFF), .Q(Stream2_pulse_3_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF3_2_4(.clk(Ack3), .D(Stream4_pulse_3_TFF), .Q(Stream4_pulse_3_TFF_DEFF), .rst_n(rst_n));
  // mux_clk mux3_clock(
  //   .rst_n(rst_n),
  //       .input0(Clock0), .input1(Clock1), .input2(Clock2), .input3(Clock3), .input4(Clock4),
  //       .RoutingDirection(DirectionIn_out3), .output_wire(Clock_Out3));



  //North
  // XOR2D0BWP30P140ULVT lib_xor2_1(.A1(Tail2), .A2(TailAck2), .Z(Tail2_pulse));
  xor(Tail2_pulse, Tail2, TailAck2);

  // XOR2D0BWP30P140ULVT lib_xor2_2(.A1(Stream2), .A2(StreamAck2), .Z(Stream2_pulse));
  xor(Stream2_pulse, Stream2, StreamAck2);

  demux demux2_1(
    .rst_n(rst_n),
    .input_wire(Tail2_pulse), .RoutingDirection(DirectionIn_in2), 
    .output0(Tail2_pulse_0), .output1(Tail2_pulse_1), 
    .output2(Tail2_pulse_2), .output3(Tail2_pulse_3), .output4(Tail2_pulse_4));
  demux demux2_2(
    .rst_n(rst_n),
    .input_wire(Stream2_pulse), .RoutingDirection(DirectionIn_in2), 
    .output0(Stream2_pulse_0), .output1(Stream2_pulse_1), 
    .output2(Stream2_pulse_2), .output3(Stream2_pulse_3), .output4(Stream2_pulse_4));
  // XOR4D0BWP30P140ULVT lib_xor2_3(
  //   .A1(Tail2_pulse_0_TFF_DEFF), .A2(Tail2_pulse_1_TFF_DEFF), 
  //   .A3(Tail2_pulse_3_TFF_DEFF), .A4(Tail2_pulse_4_TFF_DEFF), 
  //   .Z(TailAck2));
  xor(TailAck2, Tail2_pulse_0_TFF_DEFF, Tail2_pulse_1_TFF_DEFF, Tail2_pulse_3_TFF_DEFF, Tail2_pulse_4_TFF_DEFF);

  // XOR4D0BWP30P140ULVT lib_xor2_4(
  //   .A1(Stream2_pulse_0_TFF_DEFF), .A2(Stream2_pulse_1_TFF_DEFF), 
  //   .A3(Stream2_pulse_3_TFF_DEFF), .A4(Stream2_pulse_4_TFF_DEFF), 
  //   .Z(StreamAck2));
  xor(StreamAck2, Stream2_pulse_0_TFF_DEFF, Stream2_pulse_1_TFF_DEFF, Stream2_pulse_3_TFF_DEFF, Stream2_pulse_4_TFF_DEFF);

  // XOR2D0BWP30P140ULVT lib_xor2_5(.A1(TailAck2), .A2(StreamAck2), .Z(Ack_Out2));
  xor(Ack_Out2, TailAck2, StreamAck2);

  TFF TFF2_1_0(.rst_n(rst_n), .clk(Tail0_pulse_2), .EN(DirectionIn_out2[0]), .Q(Tail0_pulse_2_TFF));
  TFF TFF2_1_1(.rst_n(rst_n), .clk(Tail1_pulse_2), .EN(DirectionIn_out2[1]), .Q(Tail1_pulse_2_TFF));
  TFF TFF2_1_3(.rst_n(rst_n), .clk(Tail3_pulse_2), .EN(DirectionIn_out2[3]), .Q(Tail3_pulse_2_TFF));
  TFF TFF2_1_4(.rst_n(rst_n), .clk(Tail4_pulse_2), .EN(DirectionIn_out2[4]), .Q(Tail4_pulse_2_TFF));
  TFF TFF2_2_0(.rst_n(rst_n), .clk(Stream0_pulse_2), .EN(DirectionIn_out2[0]), .Q(Stream0_pulse_2_TFF));
  TFF TFF2_2_1(.rst_n(rst_n), .clk(Stream1_pulse_2), .EN(DirectionIn_out2[1]), .Q(Stream1_pulse_2_TFF));
  TFF TFF2_2_3(.rst_n(rst_n), .clk(Stream3_pulse_2), .EN(DirectionIn_out2[3]), .Q(Stream3_pulse_2_TFF));
  TFF TFF2_2_4(.rst_n(rst_n), .clk(Stream4_pulse_2), .EN(DirectionIn_out2[4]), .Q(Stream4_pulse_2_TFF));
  // XOR4D0BWP30P140ULVT lib_xor2_6(
  //   .A1(Tail0_pulse_2_TFF), .A2(Tail1_pulse_2_TFF), 
  //   .A3(Tail3_pulse_2_TFF), .A4(Tail4_pulse_2_TFF), 
  //   .Z(Tail_Out2));
  xor(Tail_Out2, Tail0_pulse_2_TFF, Tail1_pulse_2_TFF, Tail3_pulse_2_TFF, Tail4_pulse_2_TFF);

  // XOR4D0BWP30P140ULVT lib_xor2_7(
  //   .A1(Stream0_pulse_2_TFF), .A2(Stream1_pulse_2_TFF), 
  //   .A3(Stream3_pulse_2_TFF), .A4(Stream4_pulse_2_TFF), 
  //   .Z(Stream_Out2));
  xor(Stream_Out2, Stream0_pulse_2_TFF, Stream1_pulse_2_TFF, Stream3_pulse_2_TFF, Stream4_pulse_2_TFF);

  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CData2_mux
      mux mux2(
        .rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]),
        .RoutingDirection(DirectionIn_out2), .output_wire(CData_Out2[i]));
    end
  endgenerate
  DEFF DEFF2_1_0(.clk(Ack2), .D(Tail0_pulse_2_TFF), .Q(Tail0_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_1_1(.clk(Ack2), .D(Tail1_pulse_2_TFF), .Q(Tail1_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_1_3(.clk(Ack2), .D(Tail3_pulse_2_TFF), .Q(Tail3_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_1_4(.clk(Ack2), .D(Tail4_pulse_2_TFF), .Q(Tail4_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_2_0(.clk(Ack2), .D(Stream0_pulse_2_TFF), .Q(Stream0_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_2_1(.clk(Ack2), .D(Stream1_pulse_2_TFF), .Q(Stream1_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_2_3(.clk(Ack2), .D(Stream3_pulse_2_TFF), .Q(Stream3_pulse_2_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF2_2_4(.clk(Ack2), .D(Stream4_pulse_2_TFF), .Q(Stream4_pulse_2_TFF_DEFF), .rst_n(rst_n));
  // mux_clk mux2_clock(
  //   .rst_n(rst_n),
  //       .input0(Clock0), .input1(Clock1), .input2(Clock2), .input3(Clock3), .input4(Clock4),
  //       .RoutingDirection(DirectionIn_out2), .output_wire(Clock_Out2));



  //East
  // XOR2D0BWP30P140ULVT lib_xor1_1(.A1(Tail1), .A2(TailAck1), .Z(Tail1_pulse));
  xor(Tail1_pulse, Tail1, TailAck1);

  // XOR2D0BWP30P140ULVT lib_xor1_2(.A1(Stream1), .A2(StreamAck1), .Z(Stream1_pulse));
  xor(Stream1_pulse, Stream1, StreamAck1);

  demux demux1_1(
    .rst_n(rst_n),
    .input_wire(Tail1_pulse), .RoutingDirection(DirectionIn_in1), 
    .output0(Tail1_pulse_0), .output1(Tail1_pulse_1), 
    .output2(Tail1_pulse_2), .output3(Tail1_pulse_3), .output4(Tail1_pulse_4));
  demux demux1_2(
    .rst_n(rst_n),
    .input_wire(Stream1_pulse), .RoutingDirection(DirectionIn_in1), 
    .output0(Stream1_pulse_0), .output1(Stream1_pulse_1), 
    .output2(Stream1_pulse_2), .output3(Stream1_pulse_3), .output4(Stream1_pulse_4));
  // XOR4D0BWP30P140ULVT lib_xor1_3(
  //   .A1(Tail1_pulse_0_TFF_DEFF), .A2(Tail1_pulse_2_TFF_DEFF), 
  //   .A3(Tail1_pulse_3_TFF_DEFF), .A4(Tail1_pulse_4_TFF_DEFF), 
  //   .Z(TailAck1));
  xor(TailAck1, Tail1_pulse_0_TFF_DEFF, Tail1_pulse_2_TFF_DEFF, Tail1_pulse_3_TFF_DEFF, Tail1_pulse_4_TFF_DEFF);

  // XOR4D0BWP30P140ULVT lib_xor1_4(
  //   .A1(Stream1_pulse_0_TFF_DEFF), .A2(Stream1_pulse_2_TFF_DEFF), 
  //   .A3(Stream1_pulse_3_TFF_DEFF), .A4(Stream1_pulse_4_TFF_DEFF), 
  //   .Z(StreamAck1));
  xor(StreamAck1, Stream1_pulse_0_TFF_DEFF, Stream1_pulse_2_TFF_DEFF, Stream1_pulse_3_TFF_DEFF, Stream1_pulse_4_TFF_DEFF);

  // XOR2D0BWP30P140ULVT lib_xor1_5(.A1(TailAck1), .A2(StreamAck1), .Z(Ack_Out1));
  xor(Ack_Out1, TailAck1, StreamAck1);

  TFF TFF1_1_0(.rst_n(rst_n), .clk(Tail0_pulse_1), .EN(DirectionIn_out1[0]), .Q(Tail0_pulse_1_TFF));
  TFF TFF1_1_2(.rst_n(rst_n), .clk(Tail2_pulse_1), .EN(DirectionIn_out1[2]), .Q(Tail2_pulse_1_TFF));
  TFF TFF1_1_3(.rst_n(rst_n), .clk(Tail3_pulse_1), .EN(DirectionIn_out1[3]), .Q(Tail3_pulse_1_TFF));
  TFF TFF1_1_4(.rst_n(rst_n), .clk(Tail4_pulse_1), .EN(DirectionIn_out1[4]), .Q(Tail4_pulse_1_TFF));
  TFF TFF1_2_0(.rst_n(rst_n), .clk(Stream0_pulse_1), .EN(DirectionIn_out1[0]), .Q(Stream0_pulse_1_TFF));
  TFF TFF1_2_2(.rst_n(rst_n), .clk(Stream2_pulse_1), .EN(DirectionIn_out1[2]), .Q(Stream2_pulse_1_TFF));
  TFF TFF1_2_3(.rst_n(rst_n), .clk(Stream3_pulse_1), .EN(DirectionIn_out1[3]), .Q(Stream3_pulse_1_TFF));
  TFF TFF1_2_4(.rst_n(rst_n), .clk(Stream4_pulse_1), .EN(DirectionIn_out1[4]), .Q(Stream4_pulse_1_TFF));
  // XOR4D0BWP30P140ULVT lib_xor1_6(
  //   .A1(Tail0_pulse_1_TFF), .A2(Tail2_pulse_1_TFF), 
  //   .A3(Tail3_pulse_1_TFF), .A4(Tail4_pulse_1_TFF), 
  //   .Z(Tail_Out1));
  xor(Tail_Out1, Tail0_pulse_1_TFF, Tail2_pulse_1_TFF, Tail3_pulse_1_TFF, Tail4_pulse_1_TFF);

  // XOR4D0BWP30P140ULVT lib_xor1_7(
  //   .A1(Stream0_pulse_1_TFF), .A2(Stream2_pulse_1_TFF), 
  //   .A3(Stream3_pulse_1_TFF), .A4(Stream4_pulse_1_TFF), 
  //   .Z(Stream_Out1));
  xor(Stream_Out1, Stream0_pulse_1_TFF, Stream2_pulse_1_TFF, Stream3_pulse_1_TFF, Stream4_pulse_1_TFF);

  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CData1_mux
      mux mux1(
        .rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]),
        .RoutingDirection(DirectionIn_out1), .output_wire(CData_Out1[i]));
    end
  endgenerate
  DEFF DEFF1_1_0(.clk(Ack1), .D(Tail0_pulse_1_TFF), .Q(Tail0_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_1_2(.clk(Ack1), .D(Tail2_pulse_1_TFF), .Q(Tail2_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_1_3(.clk(Ack1), .D(Tail3_pulse_1_TFF), .Q(Tail3_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_1_4(.clk(Ack1), .D(Tail4_pulse_1_TFF), .Q(Tail4_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_2_0(.clk(Ack1), .D(Stream0_pulse_1_TFF), .Q(Stream0_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_2_2(.clk(Ack1), .D(Stream2_pulse_1_TFF), .Q(Stream2_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_2_3(.clk(Ack1), .D(Stream3_pulse_1_TFF), .Q(Stream3_pulse_1_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF1_2_4(.clk(Ack1), .D(Stream4_pulse_1_TFF), .Q(Stream4_pulse_1_TFF_DEFF), .rst_n(rst_n));
  // mux_clk mux1_clock(
  //   .rst_n(rst_n),
  //       .input0(Clock0), .input1(Clock1), .input2(Clock2), .input3(Clock3), .input4(Clock4),
  //       .RoutingDirection(DirectionIn_out1), .output_wire(Clock_Out1));



  //South
  // XOR2D0BWP30P140ULVT lib_xor0_1(.A1(Tail0), .A2(TailAck0), .Z(Tail0_pulse));
  xor(Tail0_pulse, Tail0, TailAck0);

  // XOR2D0BWP30P140ULVT lib_xor0_2(.A1(Stream0), .A2(StreamAck0), .Z(Stream0_pulse));
  xor(Stream0_pulse, Stream0, StreamAck0);

  demux demux0_1(
    .rst_n(rst_n),
    .input_wire(Tail0_pulse), .RoutingDirection(DirectionIn_in0), 
    .output0(Tail0_pulse_0), .output1(Tail0_pulse_1), 
    .output2(Tail0_pulse_2), .output3(Tail0_pulse_3), .output4(Tail0_pulse_4));
  demux demux0_2(
    .rst_n(rst_n),
    .input_wire(Stream0_pulse), .RoutingDirection(DirectionIn_in0), 
    .output0(Stream0_pulse_0), .output1(Stream0_pulse_1), 
    .output2(Stream0_pulse_2), .output3(Stream0_pulse_3), .output4(Stream0_pulse_4));
  // XOR4D0BWP30P140ULVT lib_xor0_3(
  //   .A1(Tail0_pulse_1_TFF_DEFF), .A2(Tail0_pulse_2_TFF_DEFF), 
  //   .A3(Tail0_pulse_3_TFF_DEFF), .A4(Tail0_pulse_4_TFF_DEFF), 
  //   .Z(TailAck0));
  xor(TailAck0, Tail0_pulse_1_TFF_DEFF, Tail0_pulse_2_TFF_DEFF, Tail0_pulse_3_TFF_DEFF, Tail0_pulse_4_TFF_DEFF);

  // XOR4D0BWP30P140ULVT lib_xor0_4(
  //   .A1(Stream0_pulse_1_TFF_DEFF), .A2(Stream0_pulse_2_TFF_DEFF), 
  //   .A3(Stream0_pulse_3_TFF_DEFF), .A4(Stream0_pulse_4_TFF_DEFF), 
  //   .Z(StreamAck0));
  xor(StreamAck0, Stream0_pulse_1_TFF_DEFF, Stream0_pulse_2_TFF_DEFF, Stream0_pulse_3_TFF_DEFF, Stream0_pulse_4_TFF_DEFF);

  // XOR2D0BWP30P140ULVT lib_xor0_5(.A1(TailAck0), .A2(StreamAck0), .Z(Ack_Out0));
  xor(Ack_Out0, TailAck0, StreamAck0);

  TFF TFF0_1_1(.rst_n(rst_n), .clk(Tail1_pulse_0), .EN(DirectionIn_out0[1]), .Q(Tail1_pulse_0_TFF));
  TFF TFF0_1_2(.rst_n(rst_n), .clk(Tail2_pulse_0), .EN(DirectionIn_out0[2]), .Q(Tail2_pulse_0_TFF));
  TFF TFF0_1_3(.rst_n(rst_n), .clk(Tail3_pulse_0), .EN(DirectionIn_out0[3]), .Q(Tail3_pulse_0_TFF));
  TFF TFF0_1_4(.rst_n(rst_n), .clk(Tail4_pulse_0), .EN(DirectionIn_out0[4]), .Q(Tail4_pulse_0_TFF));
  TFF TFF0_2_1(.rst_n(rst_n), .clk(Stream1_pulse_0), .EN(DirectionIn_out0[1]), .Q(Stream1_pulse_0_TFF));
  TFF TFF0_2_2(.rst_n(rst_n), .clk(Stream2_pulse_0), .EN(DirectionIn_out0[2]), .Q(Stream2_pulse_0_TFF));
  TFF TFF0_2_3(.rst_n(rst_n), .clk(Stream3_pulse_0), .EN(DirectionIn_out0[3]), .Q(Stream3_pulse_0_TFF));
  TFF TFF0_2_4(.rst_n(rst_n), .clk(Stream4_pulse_0), .EN(DirectionIn_out0[4]), .Q(Stream4_pulse_0_TFF));
  // XOR4D0BWP30P140ULVT lib_xor0_6(
  //   .A1(Tail1_pulse_0_TFF), .A2(Tail2_pulse_0_TFF), 
  //   .A3(Tail3_pulse_0_TFF), .A4(Tail4_pulse_0_TFF), 
  //   .Z(Tail_Out0));
  xor(Tail_Out0, Tail1_pulse_0_TFF, Tail2_pulse_0_TFF, Tail3_pulse_0_TFF, Tail4_pulse_0_TFF);

  // XOR4D0BWP30P140ULVT lib_xor0_7(
  //   .A1(Stream1_pulse_0_TFF), .A2(Stream2_pulse_0_TFF), 
  //   .A3(Stream3_pulse_0_TFF), .A4(Stream4_pulse_0_TFF), 
  //   .Z(Stream_Out0));
  xor(Stream_Out0, Stream1_pulse_0_TFF, Stream2_pulse_0_TFF, Stream3_pulse_0_TFF, Stream4_pulse_0_TFF);

  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CData0_mux
      mux mux0(
        .rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]),
        .RoutingDirection(DirectionIn_out0), .output_wire(CData_Out0[i]));
    end
  endgenerate
  DEFF DEFF0_1_1(.clk(Ack0), .D(Tail1_pulse_0_TFF), .Q(Tail1_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_1_2(.clk(Ack0), .D(Tail2_pulse_0_TFF), .Q(Tail2_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_1_3(.clk(Ack0), .D(Tail3_pulse_0_TFF), .Q(Tail3_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_1_4(.clk(Ack0), .D(Tail4_pulse_0_TFF), .Q(Tail4_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_2_1(.clk(Ack0), .D(Stream1_pulse_0_TFF), .Q(Stream1_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_2_2(.clk(Ack0), .D(Stream2_pulse_0_TFF), .Q(Stream2_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_2_3(.clk(Ack0), .D(Stream3_pulse_0_TFF), .Q(Stream3_pulse_0_TFF_DEFF), .rst_n(rst_n));
  DEFF DEFF0_2_4(.clk(Ack0), .D(Stream4_pulse_0_TFF), .Q(Stream4_pulse_0_TFF_DEFF), .rst_n(rst_n));
  // mux_clk mux0_clock(
  //   .rst_n(rst_n),
  //       .input0(Clock0), .input1(Clock1), .input2(Clock2), .input3(Clock3), .input4(Clock4),
  //       .RoutingDirection(DirectionIn_out0), .output_wire(Clock_Out0));


  

  //fifo intf
  assign RD_in4 = TailAck4;
  assign RD_in3 = TailAck3;
  assign RD_in2 = TailAck2;
  assign RD_in1 = TailAck1;
  assign RD_in0 = TailAck0;

  // XOR4D0BWP30P140ULVT lib_xor4_outport4(
  //   .A1(Tail0_pulse_4_TFF_DEFF), .A2(Tail1_pulse_4_TFF_DEFF), 
  //   .A3(Tail2_pulse_4_TFF_DEFF), .A4(Tail3_pulse_4_TFF_DEFF), 
  //   .Z(RD_out4));
  // XOR4D0BWP30P140ULVT lib_xor4_outport3(
  //   .A1(Tail0_pulse_3_TFF_DEFF), .A2(Tail1_pulse_3_TFF_DEFF), 
  //   .A3(Tail2_pulse_3_TFF_DEFF), .A4(Tail4_pulse_3_TFF_DEFF), 
  //   .Z(RD_out3));
  // XOR4D0BWP30P140ULVT lib_xor4_outport2(
  //   .A1(Tail0_pulse_2_TFF_DEFF), .A2(Tail1_pulse_2_TFF_DEFF), 
  //   .A3(Tail3_pulse_2_TFF_DEFF), .A4(Tail4_pulse_2_TFF_DEFF), 
  //   .Z(RD_out2));
  // XOR4D0BWP30P140ULVT lib_xor4_outport1(
  //   .A1(Tail0_pulse_1_TFF_DEFF), .A2(Tail2_pulse_1_TFF_DEFF), 
  //   .A3(Tail3_pulse_1_TFF_DEFF), .A4(Tail4_pulse_1_TFF_DEFF), 
  //   .Z(RD_out1));
  // XOR4D0BWP30P140ULVT lib_xor4_outport0(
  //   .A1(Tail1_pulse_0_TFF_DEFF), .A2(Tail2_pulse_0_TFF_DEFF), 
  //   .A3(Tail3_pulse_0_TFF_DEFF), .A4(Tail4_pulse_0_TFF_DEFF), 
  //   .Z(RD_out0));

  xor(RD_out4, Tail0_pulse_4_TFF_DEFF, Tail1_pulse_4_TFF_DEFF, Tail2_pulse_4_TFF_DEFF, Tail3_pulse_4_TFF_DEFF);
  xor(RD_out3, Tail0_pulse_3_TFF_DEFF, Tail1_pulse_3_TFF_DEFF, Tail2_pulse_3_TFF_DEFF, Tail4_pulse_3_TFF_DEFF);
  xor(RD_out2, Tail0_pulse_2_TFF_DEFF, Tail1_pulse_2_TFF_DEFF, Tail3_pulse_2_TFF_DEFF, Tail4_pulse_2_TFF_DEFF);
  xor(RD_out1, Tail0_pulse_1_TFF_DEFF, Tail2_pulse_1_TFF_DEFF, Tail3_pulse_1_TFF_DEFF, Tail4_pulse_1_TFF_DEFF);
  xor(RD_out0, Tail1_pulse_0_TFF_DEFF, Tail2_pulse_0_TFF_DEFF, Tail3_pulse_0_TFF_DEFF, Tail4_pulse_0_TFF_DEFF);

endmodule
