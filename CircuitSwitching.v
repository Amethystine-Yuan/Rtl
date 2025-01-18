
module CircuitSwitching #(
    parameter DATASIZE=80
)(
  input wire rst_n,
  input wire Ack4,//local
  input wire Ack3,//west
  input wire Ack2,//north
  input wire Ack1,//east
  input wire Ack0,//south
  output wire Ack_Out4,
  output wire Ack_Out3,
  output wire Ack_Out2,
  output wire Ack_Out1,
  output wire Ack_Out0,
  input wire [DATASIZE-1:0] CData4,
  input wire [DATASIZE-1:0] CData3,
  input wire [DATASIZE-1:0] CData2,
  input wire [DATASIZE-1:0] CData1,
  input wire [DATASIZE-1:0] CData0,
  output wire [DATASIZE-1:0] CData_Out4,
  output wire [DATASIZE-1:0] CData_Out3,
  output wire [DATASIZE-1:0] CData_Out2,
  output wire [DATASIZE-1:0] CData_Out1,
  output wire [DATASIZE-1:0] CData_Out0,
  input wire Strobe4,
  input wire Strobe3,
  input wire Strobe2,
  input wire Strobe1,
  input wire Strobe0,
  output wire Strobe_Out4,
  output wire Strobe_Out3,
  output wire Strobe_Out2,
  output wire Strobe_Out1,
  output wire Strobe_Out0,
  input wire State4,
  input wire State3,
  input wire State2,
  input wire State1,
  input wire State0,
  output wire State_Out4,
  output wire State_Out3,
  output wire State_Out2,
  output wire State_Out1,
  output wire State_Out0,
  // input wire Clock4,
  // input wire Clock3,
  // input wire Clock2,
  // input wire Clock1,
  // input wire Clock0,
  // output wire Clock_Out4,
  // output wire Clock_Out3,
  // output wire Clock_Out2,
  // output wire Clock_Out1,
  // output wire Clock_Out0,
  
  input wire Feedback4,
  input wire Feedback3,
  input wire Feedback2,
  input wire Feedback1,
  input wire Feedback0,
  output wire Feedback_Out4,
  output wire Feedback_Out3,
  output wire Feedback_Out2,
  output wire Feedback_Out1,
  output wire Feedback_Out0,



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

  wire Ack0_pulse;
  wire Ack1_pulse;
  wire Ack2_pulse;
  wire Ack3_pulse;
  wire Ack4_pulse;
  wire Ack0_pulse_0;
  wire Ack0_pulse_1;
  wire Ack0_pulse_2;
  wire Ack0_pulse_3;
  wire Ack0_pulse_4;
  wire Ack1_pulse_0;
  wire Ack1_pulse_1;
  wire Ack1_pulse_2;
  wire Ack1_pulse_3;
  wire Ack1_pulse_4;
  wire Ack2_pulse_0;
  wire Ack2_pulse_1;
  wire Ack2_pulse_2;
  wire Ack2_pulse_3;
  wire Ack2_pulse_4;
  wire Ack3_pulse_0;
  wire Ack3_pulse_1;
  wire Ack3_pulse_2;
  wire Ack3_pulse_3;
  wire Ack3_pulse_4;
  wire Ack4_pulse_0;
  wire Ack4_pulse_1;
  wire Ack4_pulse_2;
  wire Ack4_pulse_3;
  wire Ack4_pulse_4;
  wire Ack0_pulse_0_TFF;
  wire Ack0_pulse_1_TFF;
  wire Ack0_pulse_2_TFF;
  wire Ack0_pulse_3_TFF;
  wire Ack0_pulse_4_TFF;
  wire Ack1_pulse_0_TFF;
  wire Ack1_pulse_1_TFF;
  wire Ack1_pulse_2_TFF;
  wire Ack1_pulse_3_TFF;
  wire Ack1_pulse_4_TFF;
  wire Ack2_pulse_0_TFF;
  wire Ack2_pulse_1_TFF;
  wire Ack2_pulse_2_TFF;
  wire Ack2_pulse_3_TFF;
  wire Ack2_pulse_4_TFF;
  wire Ack3_pulse_0_TFF;
  wire Ack3_pulse_1_TFF;
  wire Ack3_pulse_2_TFF;
  wire Ack3_pulse_3_TFF;
  wire Ack3_pulse_4_TFF;
  wire Ack4_pulse_0_TFF;
  wire Ack4_pulse_1_TFF;
  wire Ack4_pulse_2_TFF;
  wire Ack4_pulse_3_TFF;
  wire Ack4_pulse_4_TFF;
  wire Ack0_pulse_0_TFF_NEFF;
  wire Ack0_pulse_1_TFF_NEFF;
  wire Ack0_pulse_2_TFF_NEFF;
  wire Ack0_pulse_3_TFF_NEFF;
  wire Ack0_pulse_4_TFF_NEFF;
  wire Ack1_pulse_0_TFF_NEFF;
  wire Ack1_pulse_1_TFF_NEFF;
  wire Ack1_pulse_2_TFF_NEFF;
  wire Ack1_pulse_3_TFF_NEFF;
  wire Ack1_pulse_4_TFF_NEFF;
  wire Ack2_pulse_0_TFF_NEFF;
  wire Ack2_pulse_1_TFF_NEFF;
  wire Ack2_pulse_2_TFF_NEFF;
  wire Ack2_pulse_3_TFF_NEFF;
  wire Ack2_pulse_4_TFF_NEFF;
  wire Ack3_pulse_0_TFF_NEFF;
  wire Ack3_pulse_1_TFF_NEFF;
  wire Ack3_pulse_2_TFF_NEFF;
  wire Ack3_pulse_3_TFF_NEFF;
  wire Ack3_pulse_4_TFF_NEFF;
  wire Ack4_pulse_0_TFF_NEFF;
  wire Ack4_pulse_1_TFF_NEFF;
  wire Ack4_pulse_2_TFF_NEFF;
  wire Ack4_pulse_3_TFF_NEFF;
  wire Ack4_pulse_4_TFF_NEFF;

  wire Strobe0_0;
  wire Strobe0_1;
  wire Strobe0_2;
  wire Strobe0_3;
  wire Strobe0_4;
  wire Strobe1_0;
  wire Strobe1_1;
  wire Strobe1_2;
  wire Strobe1_3;
  wire Strobe1_4;
  wire Strobe2_0;
  wire Strobe2_1;
  wire Strobe2_2;
  wire Strobe2_3;
  wire Strobe2_4;
  wire Strobe3_0;
  wire Strobe3_1;
  wire Strobe3_2;
  wire Strobe3_3;
  wire Strobe3_4;
  wire Strobe4_0;
  wire Strobe4_1;
  wire Strobe4_2;
  wire Strobe4_3;
  wire Strobe4_4;

  wire State0_0;
  wire State0_1;
  wire State0_2;
  wire State0_3;
  wire State0_4;
  wire State1_0;
  wire State1_1;
  wire State1_2;
  wire State1_3;
  wire State1_4;
  wire State2_0;
  wire State2_1;
  wire State2_2;
  wire State2_3;
  wire State2_4;
  wire State3_0;
  wire State3_1;
  wire State3_2;
  wire State3_3;
  wire State3_4;
  wire State4_0;
  wire State4_1;
  wire State4_2;
  wire State4_3;
  wire State4_4;

  // wire Clock0_0;
  // wire Clock0_1;
  // wire Clock0_2;
  // wire Clock0_3;
  // wire Clock0_4;
  // wire Clock1_0;
  // wire Clock1_1;
  // wire Clock1_2;
  // wire Clock1_3;
  // wire Clock1_4;
  // wire Clock2_0;
  // wire Clock2_1;
  // wire Clock2_2;
  // wire Clock2_3;
  // wire Clock2_4;
  // wire Clock3_0;
  // wire Clock3_1;
  // wire Clock3_2;
  // wire Clock3_3;
  // wire Clock3_4;
  // wire Clock4_0;
  // wire Clock4_1;
  // wire Clock4_2;
  // wire Clock4_3;
  // wire Clock4_4;

  genvar i;

  wire [DATASIZE-1:0] CData_Out4_pre2;
  wire [DATASIZE-1:0] CData_Out3_pre2;
  wire [DATASIZE-1:0] CData_Out2_pre2;
  wire [DATASIZE-1:0] CData_Out1_pre2;
  wire [DATASIZE-1:0] CData_Out0_pre2;
  wire [DATASIZE-1:0] CData_Out4_pre1;
  wire [DATASIZE-1:0] CData_Out3_pre1;
  wire [DATASIZE-1:0] CData_Out2_pre1;
  wire [DATASIZE-1:0] CData_Out1_pre1;
  wire [DATASIZE-1:0] CData_Out0_pre1;

  wire Strobe_Out4_pre;
  wire Strobe_Out3_pre;
  wire Strobe_Out2_pre;
  wire Strobe_Out1_pre;
  wire Strobe_Out0_pre;

  wire State_Out4_pre;
  wire State_Out3_pre;
  wire State_Out2_pre;
  wire State_Out1_pre;
  wire State_Out0_pre;

  // wire Clock_Out4_pre;
  // wire Clock_Out3_pre;
  // wire Clock_Out2_pre;
  // wire Clock_Out1_pre;
  // wire Clock_Out0_pre;


  wire Feedback4_4;
  wire Feedback4_3;
  wire Feedback4_2;
  wire Feedback4_1;
  wire Feedback4_0;
  wire Feedback3_4;
  wire Feedback3_3;
  wire Feedback3_2;
  wire Feedback3_1;
  wire Feedback3_0;
  wire Feedback2_4;
  wire Feedback2_3;
  wire Feedback2_2;
  wire Feedback2_1;
  wire Feedback2_0;
  wire Feedback1_4;
  wire Feedback1_3;
  wire Feedback1_2;
  wire Feedback1_1;
  wire Feedback1_0;
  wire Feedback0_4;
  wire Feedback0_3;
  wire Feedback0_2;
  wire Feedback0_1;
  wire Feedback0_0;


  //Local
  // XOR2D0BWP30P140ULVT lib_xor_ack4(.A1(Ack4), .A2(RD_out4), .Z(Ack4_pulse));
  xor(Ack4_pulse, Ack4, RD_out4);

  demux demux_ack4(.rst_n(rst_n),
    .input_wire(Ack4_pulse), .RoutingDirection(DirectionIn_out4), 
    .output0(Ack4_pulse_0), .output1(Ack4_pulse_1), 
    .output2(Ack4_pulse_2), .output3(Ack4_pulse_3), .output4(Ack4_pulse_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout4_mux
      mux mux_cdataout4(.rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]), 
        .RoutingDirection(DirectionIn_out4), .output_wire(CData_Out4[i]));
      // DEL050MD1BWP lib_del_cdataout4_pre(.I(CData_Out4_pre2[i]), .Z(CData_Out4_pre1[i]));
      // DEL250MD1BWP lib_del_cdataout4(.I(CData_Out4_pre1[i]), .Z(CData_Out4[i]));
    end
  endgenerate
  mux mux_strobeout4(.rst_n(rst_n), .input0(Strobe0_4), .input1(Strobe1_4), .input2(Strobe2_4), .input3(Strobe3_4), .input4(Strobe4_4),
            .RoutingDirection(DirectionIn_out4), .output_wire(Strobe_Out4));
  mux mux_stateout4(.rst_n(rst_n), .input0(State0_4), .input1(State1_4), .input2(State2_4), .input3(State3_4), .input4(State4_4),
            .RoutingDirection(DirectionIn_out4), .output_wire(State_Out4));
  // mux_clk mux_clockout4(.rst_n(rst_n), .input0(Clock0_4), .input1(Clock1_4), .input2(Clock2_4), .input3(Clock3_4), .input4(Clock4_4),
  //           .RoutingDirection(DirectionIn_out4), .output_wire(Clock_Out4));
  // DEL250MD1BWP lib_del_strobeout4(.I(Strobe_Out4_pre), .Z(Strobe_Out4));
  // DEL250MD1BWP lib_del_stateout4(.I(State_Out4_pre), .Z(State_Out4));
  // DEL250MD1BWP lib_del_clockout4(.I(Clock_Out4_pre), .Z(Clock_Out4));
  

  TFF TFF4_0(.rst_n(rst_n), .clk(Ack0_pulse_4), .EN(DirectionIn_in4[0]), .Q(Ack0_pulse_4_TFF));
  TFF TFF4_1(.rst_n(rst_n), .clk(Ack1_pulse_4), .EN(DirectionIn_in4[1]), .Q(Ack1_pulse_4_TFF));
  TFF TFF4_2(.rst_n(rst_n), .clk(Ack2_pulse_4), .EN(DirectionIn_in4[2]), .Q(Ack2_pulse_4_TFF));
  TFF TFF4_3(.rst_n(rst_n), .clk(Ack3_pulse_4), .EN(DirectionIn_in4[3]), .Q(Ack3_pulse_4_TFF));
  // XOR4D0BWP30P140ULVT lib_xor_ackout4(.A1(Ack0_pulse_4_TFF), .A2(Ack1_pulse_4_TFF), 
  //                           .A3(Ack2_pulse_4_TFF), .A4(Ack3_pulse_4_TFF), 
  //                           .Z(Ack_Out4));

  xor(Ack_Out4, Ack0_pulse_4_TFF, Ack1_pulse_4_TFF, Ack2_pulse_4_TFF, Ack3_pulse_4_TFF);
  NEFF NEFF4_0(.clk(State4), .D(Ack0_pulse_4_TFF), .Q(Ack0_pulse_4_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF4_1(.clk(State4), .D(Ack1_pulse_4_TFF), .Q(Ack1_pulse_4_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF4_2(.clk(State4), .D(Ack2_pulse_4_TFF), .Q(Ack2_pulse_4_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF4_3(.clk(State4), .D(Ack3_pulse_4_TFF), .Q(Ack3_pulse_4_TFF_NEFF), .rst_n(rst_n));
  demux demux_strobe4(.rst_n(rst_n),.input_wire(Strobe4), .RoutingDirection(DirectionIn_in4), 
                          .output0(Strobe4_0), .output1(Strobe4_1), 
                          .output2(Strobe4_2), .output3(Strobe4_3), .output4(Strobe4_4));
  demux demux_state4(.rst_n(rst_n), .input_wire(State4), .RoutingDirection(DirectionIn_in4), 
                          .output0(State4_0), .output1(State4_1), 
                          .output2(State4_2), .output3(State4_3), .output4(State4_4));
  // demux demux_clock4(.rst_n(rst_n), .input_wire(Clock4), .RoutingDirection(DirectionIn_in4), 
  //                         .output0(Clock4_0), .output1(Clock4_1), 
  //                         .output2(Clock4_2), .output3(Clock4_3), .output4(Clock4_4));

  demux demux_feedback4(.rst_n(rst_n),.input_wire(Feedback4), .RoutingDirection(DirectionIn_out4), 
                        .output0(Feedback4_0), .output1(Feedback4_1), 
                        .output2(Feedback4_2), .output3(Feedback4_3), .output4(Feedback4_4));
  mux mux_feedback4(.rst_n(rst_n),  .input0(Feedback0_4), .input1(Feedback1_4), .input2(Feedback2_4), .input3(Feedback3_4), .input4(Feedback4_4),
                      .RoutingDirection(DirectionIn_in4), .output_wire(Feedback_Out4));

  
  //West
  // XOR2D0BWP30P140ULVT lib_xor_ack3(.A1(Ack3), .A2(RD_out3), .Z(Ack3_pulse));
  xor(Ack3_pulse, Ack3, RD_out3);

  demux demux_ack3(.rst_n(rst_n),
    .input_wire(Ack3_pulse), .RoutingDirection(DirectionIn_out3), 
    .output0(Ack3_pulse_0), .output1(Ack3_pulse_1), 
    .output2(Ack3_pulse_2), .output3(Ack3_pulse_3), .output4(Ack3_pulse_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout3_mux
      mux mux_cdataout3(.rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]), 
        .RoutingDirection(DirectionIn_out3), .output_wire(CData_Out3[i]));
      // DEL050MD1BWP lib_del_cdataout3_pre(.I(CData_Out3_pre2[i]), .Z(CData_Out3_pre1[i]));
      // DEL250MD1BWP lib_del_cdataout3(.I(CData_Out3_pre1[i]), .Z(CData_Out3[i]));
    end
  endgenerate
  mux mux_strobeout3(.rst_n(rst_n), .input0(Strobe0_3), .input1(Strobe1_3), .input2(Strobe2_3), .input3(Strobe3_3), .input4(Strobe4_3), 
            .RoutingDirection(DirectionIn_out3), .output_wire(Strobe_Out3));
  mux mux_stateout3(.rst_n(rst_n), .input0(State0_3), .input1(State1_3), .input2(State2_3), .input3(State3_3), .input4(State4_3),
            .RoutingDirection(DirectionIn_out3), .output_wire(State_Out3));
  // mux_clk mux_clockout3(.rst_n(rst_n), .input0(Clock0_3), .input1(Clock1_3), .input2(Clock2_3), .input3(Clock3_3), .input4(Clock4_3),
  //           .RoutingDirection(DirectionIn_out3), .output_wire(Clock_Out3));
  // DEL250MD1BWP lib_del_strobeout3(.I(Strobe_Out3_pre), .Z(Strobe_Out3));
  // DEL250MD1BWP lib_del_stateout3(.I(State_Out3_pre), .Z(State_Out3));
  // DEL250MD1BWP lib_del_clockout3(.I(Clock_Out3_pre), .Z(Clock_Out3));

  TFF TFF3_0(.rst_n(rst_n), .clk(Ack0_pulse_3), .EN(DirectionIn_in3[0]), .Q(Ack0_pulse_3_TFF));
  TFF TFF3_1(.rst_n(rst_n), .clk(Ack1_pulse_3), .EN(DirectionIn_in3[1]), .Q(Ack1_pulse_3_TFF));
  TFF TFF3_2(.rst_n(rst_n), .clk(Ack2_pulse_3), .EN(DirectionIn_in3[2]), .Q(Ack2_pulse_3_TFF));
  TFF TFF3_4(.rst_n(rst_n), .clk(Ack4_pulse_3), .EN(DirectionIn_in3[4]), .Q(Ack4_pulse_3_TFF));
  // XOR4D0BWP30P140ULVT lib_xor_ackout3(.A1(Ack0_pulse_3_TFF), .A2(Ack1_pulse_3_TFF), 
  //                           .A3(Ack2_pulse_3_TFF), .A4(Ack4_pulse_3_TFF), 
  //                           .Z(Ack_Out3));
  xor(Ack_Out3, Ack0_pulse_3_TFF, Ack1_pulse_3_TFF, Ack2_pulse_3_TFF, Ack4_pulse_3_TFF);

  NEFF NEFF3_0(.clk(State3), .D(Ack0_pulse_3_TFF), .Q(Ack0_pulse_3_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF3_1(.clk(State3), .D(Ack1_pulse_3_TFF), .Q(Ack1_pulse_3_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF3_2(.clk(State3), .D(Ack2_pulse_3_TFF), .Q(Ack2_pulse_3_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF3_4(.clk(State3), .D(Ack4_pulse_3_TFF), .Q(Ack4_pulse_3_TFF_NEFF), .rst_n(rst_n));
  demux demux_strobe3(.rst_n(rst_n),.input_wire(Strobe3), .RoutingDirection(DirectionIn_in3), 
                          .output0(Strobe3_0), .output1(Strobe3_1), 
                          .output2(Strobe3_2), .output3(Strobe3_3), .output4(Strobe3_4));
  demux demux_state3(.rst_n(rst_n), .input_wire(State3), .RoutingDirection(DirectionIn_in3), 
                          .output0(State3_0), .output1(State3_1), 
                          .output2(State3_2), .output3(State3_3), .output4(State3_4));
  // demux demux_clock3(.rst_n(rst_n), .input_wire(Clock3), .RoutingDirection(DirectionIn_in3), 
  //                         .output0(Clock3_0), .output1(Clock3_1), 
  //                         .output2(Clock3_2), .output3(Clock3_3), .output4(Clock3_4));

  demux demux_feedback3(.rst_n(rst_n),.input_wire(Feedback3), .RoutingDirection(DirectionIn_out3), 
                        .output0(Feedback3_0), .output1(Feedback3_1), 
                        .output2(Feedback3_2), .output3(Feedback3_3), .output4(Feedback3_4));
  mux mux_feedback3(.rst_n(rst_n),  .input0(Feedback0_3), .input1(Feedback1_3), .input2(Feedback2_3), .input3(Feedback3_3), .input4(Feedback4_3),
                      .RoutingDirection(DirectionIn_in3), .output_wire(Feedback_Out3));

  
  //North
  // XOR2D0BWP30P140ULVT lib_xor_ack2(.A1(Ack2), .A2(RD_out2), .Z(Ack2_pulse));
  xor(Ack2_pulse, Ack2, RD_out2);

  demux demux_ack2(.rst_n(rst_n),
    .input_wire(Ack2_pulse), .RoutingDirection(DirectionIn_out2), 
    .output0(Ack2_pulse_0), .output1(Ack2_pulse_1), 
    .output2(Ack2_pulse_2), .output3(Ack2_pulse_3), .output4(Ack2_pulse_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout2_mux
      mux mux_cdataout2(.rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]), 
        .RoutingDirection(DirectionIn_out2), .output_wire(CData_Out2[i]));
      // DEL050MD1BWP lib_del_cdataout2_pre(.I(CData_Out2_pre2[i]), .Z(CData_Out2_pre1[i]));
      // DEL250MD1BWP lib_del_cdataout2(.I(CData_Out2_pre1[i]), .Z(CData_Out2[i]));
    end
  endgenerate
  mux mux_strobeout2(.rst_n(rst_n), .input0(Strobe0_2), .input1(Strobe1_2), .input2(Strobe2_2), .input3(Strobe3_2), .input4(Strobe4_2),
            .RoutingDirection(DirectionIn_out2), .output_wire(Strobe_Out2));
  mux mux_stateout2(.rst_n(rst_n), .input0(State0_2), .input1(State1_2), .input2(State2_2), .input3(State3_2), .input4(State4_2),
            .RoutingDirection(DirectionIn_out2), .output_wire(State_Out2));
  // mux_clk mux_clockout2(.rst_n(rst_n), .input0(Clock0_2), .input1(Clock1_2), .input2(Clock2_2), .input3(Clock3_2), .input4(Clock4_2),
  //           .RoutingDirection(DirectionIn_out2), .output_wire(Clock_Out2));
  // DEL250MD1BWP lib_del_strobeout2(.I(Strobe_Out2_pre), .Z(Strobe_Out2));
  // DEL250MD1BWP lib_del_stateout2(.I(State_Out2_pre), .Z(State_Out2));
  // DEL250MD1BWP lib_del_clockout2(.I(Clock_Out2_pre), .Z(Clock_Out2));

  TFF TFF2_0(.rst_n(rst_n), .clk(Ack0_pulse_2), .EN(DirectionIn_in2[0]), .Q(Ack0_pulse_2_TFF));
  TFF TFF2_1(.rst_n(rst_n), .clk(Ack1_pulse_2), .EN(DirectionIn_in2[1]), .Q(Ack1_pulse_2_TFF));
  TFF TFF2_3(.rst_n(rst_n), .clk(Ack3_pulse_2), .EN(DirectionIn_in2[3]), .Q(Ack3_pulse_2_TFF));
  TFF TFF2_4(.rst_n(rst_n), .clk(Ack4_pulse_2), .EN(DirectionIn_in2[4]), .Q(Ack4_pulse_2_TFF));
  // XOR4D0BWP30P140ULVT lib_xor_ackout2(.A1(Ack0_pulse_2_TFF), .A2(Ack1_pulse_2_TFF), 
  //                           .A3(Ack3_pulse_2_TFF), .A4(Ack4_pulse_2_TFF), 
  //                           .Z(Ack_Out2));
  xor(Ack_Out2, Ack0_pulse_2_TFF, Ack1_pulse_2_TFF, Ack3_pulse_2_TFF, Ack4_pulse_2_TFF);

  NEFF NEFF2_0(.clk(State2), .D(Ack0_pulse_2_TFF), .Q(Ack0_pulse_2_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF2_1(.clk(State2), .D(Ack1_pulse_2_TFF), .Q(Ack1_pulse_2_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF2_3(.clk(State2), .D(Ack3_pulse_2_TFF), .Q(Ack3_pulse_2_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF2_4(.clk(State2), .D(Ack4_pulse_2_TFF), .Q(Ack4_pulse_2_TFF_NEFF), .rst_n(rst_n));
  demux demux_strobe2(.rst_n(rst_n),.input_wire(Strobe2), .RoutingDirection(DirectionIn_in2), 
                          .output0(Strobe2_0), .output1(Strobe2_1), 
                          .output2(Strobe2_2), .output3(Strobe2_3), .output4(Strobe2_4));
  demux demux_state2(.rst_n(rst_n), .input_wire(State2), .RoutingDirection(DirectionIn_in2), 
                          .output0(State2_0), .output1(State2_1), 
                          .output2(State2_2), .output3(State2_3), .output4(State2_4));
  // demux demux_clock2(.rst_n(rst_n), .input_wire(Clock2), .RoutingDirection(DirectionIn_in2), 
  //                         .output0(Clock2_0), .output1(Clock2_1), 
  //                         .output2(Clock2_2), .output3(Clock2_3), .output4(Clock2_4));

  demux demux_feedback2(.rst_n(rst_n),.input_wire(Feedback2), .RoutingDirection(DirectionIn_out2), 
                        .output0(Feedback2_0), .output1(Feedback2_1), 
                        .output2(Feedback2_2), .output3(Feedback2_3), .output4(Feedback2_4));
  mux mux_feedback2(.rst_n(rst_n),  .input0(Feedback0_2), .input1(Feedback1_2), .input2(Feedback2_2), .input3(Feedback3_2), .input4(Feedback4_2),
                      .RoutingDirection(DirectionIn_in2), .output_wire(Feedback_Out2));


  //East
  // XOR2D0BWP30P140ULVT lib_xor_ack1(.A1(Ack1), .A2(RD_out1), .Z(Ack1_pulse));
  xor(Ack1_pulse, Ack1, RD_out1);

  demux demux_ack1(.rst_n(rst_n),
    .input_wire(Ack1_pulse), .RoutingDirection(DirectionIn_out1), 
    .output0(Ack1_pulse_0), .output1(Ack1_pulse_1), 
    .output2(Ack1_pulse_2), .output3(Ack1_pulse_3), .output4(Ack1_pulse_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout1_mux
      mux mux_cdataout1(.rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]), 
        .RoutingDirection(DirectionIn_out1), .output_wire(CData_Out1[i]));
      // DEL050MD1BWP lib_del_cdataout1_pre(.I(CData_Out1_pre2[i]), .Z(CData_Out1_pre1[i]));
      // DEL250MD1BWP lib_del_cdataout1(.I(CData_Out1_pre1[i]), .Z(CData_Out1[i]));
    end
  endgenerate
  mux mux_strobeout1(.rst_n(rst_n), .input0(Strobe0_1), .input1(Strobe1_1), .input2(Strobe2_1), .input3(Strobe3_1), .input4(Strobe4_1),
            .RoutingDirection(DirectionIn_out1), .output_wire(Strobe_Out1));
  mux mux_stateout1(.rst_n(rst_n), .input0(State0_1), .input1(State1_1), .input2(State2_1), .input3(State3_1), .input4(State4_1),
            .RoutingDirection(DirectionIn_out1), .output_wire(State_Out1));
  // mux_clk mux_clockout1(.rst_n(rst_n), .input0(Clock0_1), .input1(Clock1_1), .input2(Clock2_1), .input3(Clock3_1), .input4(Clock4_1),
  //           .RoutingDirection(DirectionIn_out1), .output_wire(Clock_Out1));
  // DEL250MD1BWP lib_del_strobeout1(.I(Strobe_Out1_pre), .Z(Strobe_Out1));
  // DEL250MD1BWP lib_del_stateout1(.I(State_Out1_pre), .Z(State_Out1));
  // DEL250MD1BWP lib_del_clockout1(.I(Clock_Out1_pre), .Z(Clock_Out1));

  TFF TFF1_0(.rst_n(rst_n), .clk(Ack0_pulse_1), .EN(DirectionIn_in1[0]), .Q(Ack0_pulse_1_TFF));
  TFF TFF1_2(.rst_n(rst_n), .clk(Ack2_pulse_1), .EN(DirectionIn_in1[2]), .Q(Ack2_pulse_1_TFF));
  TFF TFF1_3(.rst_n(rst_n), .clk(Ack3_pulse_1), .EN(DirectionIn_in1[3]), .Q(Ack3_pulse_1_TFF));
  TFF TFF1_4(.rst_n(rst_n), .clk(Ack4_pulse_1), .EN(DirectionIn_in1[4]), .Q(Ack4_pulse_1_TFF));
  // XOR4D0BWP30P140ULVT lib_xor_ackout1(.A1(Ack0_pulse_1_TFF), .A2(Ack2_pulse_1_TFF), 
  //                           .A3(Ack3_pulse_1_TFF), .A4(Ack4_pulse_1_TFF), 
  //                           .Z(Ack_Out1));
  xor(Ack_Out1, Ack0_pulse_1_TFF, Ack2_pulse_1_TFF, Ack3_pulse_1_TFF, Ack4_pulse_1_TFF);

  NEFF NEFF1_0(.clk(State1), .D(Ack0_pulse_1_TFF), .Q(Ack0_pulse_1_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF1_2(.clk(State1), .D(Ack2_pulse_1_TFF), .Q(Ack2_pulse_1_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF1_3(.clk(State1), .D(Ack3_pulse_1_TFF), .Q(Ack3_pulse_1_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF1_4(.clk(State1), .D(Ack4_pulse_1_TFF), .Q(Ack4_pulse_1_TFF_NEFF), .rst_n(rst_n));
  demux demux_strobe1(.rst_n(rst_n),.input_wire(Strobe1), .RoutingDirection(DirectionIn_in1), 
                          .output0(Strobe1_0), .output1(Strobe1_1), 
                          .output2(Strobe1_2), .output3(Strobe1_3), .output4(Strobe1_4));
  demux demux_state1(.rst_n(rst_n), .input_wire(State1), .RoutingDirection(DirectionIn_in1), 
                          .output0(State1_0), .output1(State1_1), 
                          .output2(State1_2), .output3(State1_3), .output4(State1_4));
  // demux demux_clock1(.rst_n(rst_n), .input_wire(Clock1), .RoutingDirection(DirectionIn_in1), 
  //                         .output0(Clock1_0), .output1(Clock1_1), 
  //                         .output2(Clock1_2), .output3(Clock1_3), .output4(Clock1_4));

  demux demux_feedback1(.rst_n(rst_n),.input_wire(Feedback1), .RoutingDirection(DirectionIn_out1), 
                        .output0(Feedback1_0), .output1(Feedback1_1), 
                        .output2(Feedback1_2), .output3(Feedback1_3), .output4(Feedback1_4));
  mux mux_feedback1(.rst_n(rst_n),  .input0(Feedback0_1), .input1(Feedback1_1), .input2(Feedback2_1), .input3(Feedback3_1), .input4(Feedback4_1),
                      .RoutingDirection(DirectionIn_in1), .output_wire(Feedback_Out1));


  //South
  // XOR2D0BWP30P140ULVT lib_xor_ack0(.A1(Ack0), .A2(RD_out0), .Z(Ack0_pulse));
  xor(Ack0_pulse, Ack0, RD_out0);

  demux demux_ack0(.rst_n(rst_n),
    .input_wire(Ack0_pulse), .RoutingDirection(DirectionIn_out0), 
    .output0(Ack0_pulse_0), .output1(Ack0_pulse_1), 
    .output2(Ack0_pulse_2), .output3(Ack0_pulse_3), .output4(Ack0_pulse_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout0_mux
      mux mux_cdataout0(.rst_n(rst_n),
        .input0(CData0[i]), .input1(CData1[i]), .input2(CData2[i]), .input3(CData3[i]), .input4(CData4[i]), 
        .RoutingDirection(DirectionIn_out0), .output_wire(CData_Out0[i]));
      // DEL050MD1BWP lib_del_cdataout0_pre(.I(CData_Out0_pre2[i]), .Z(CData_Out0_pre1[i]));
      // DEL250MD1BWP lib_del_cdataout0(.I(CData_Out0_pre1[i]), .Z(CData_Out0[i]));
    end
  endgenerate
  mux mux_strobeout0(.rst_n(rst_n), .input0(Strobe0_0), .input1(Strobe1_0), .input2(Strobe2_0), .input3(Strobe3_0), .input4(Strobe4_0),
            .RoutingDirection(DirectionIn_out0), .output_wire(Strobe_Out0));
  mux mux_stateout0(.rst_n(rst_n), .input0(State0_0), .input1(State1_0), .input2(State2_0), .input3(State3_0), .input4(State4_0),
            .RoutingDirection(DirectionIn_out0), .output_wire(State_Out0));
  // mux_clk mux_clockout0(.rst_n(rst_n), .input0(Clock0_0), .input1(Clock1_0), .input2(Clock2_0), .input3(Clock3_0), .input4(Clock4_0),
  //           .RoutingDirection(DirectionIn_out0), .output_wire(Clock_Out0));
  // DEL250MD1BWP lib_del_strobeout0(.I(Strobe_Out0_pre), .Z(Strobe_Out0));
  // DEL250MD1BWP lib_del_stateout0(.I(State_Out0_pre), .Z(State_Out0));
  // DEL250MD1BWP lib_del_clockout0(.I(Clock_Out0_pre), .Z(Clock_Out0));

  TFF TFF0_1(.rst_n(rst_n), .clk(Ack1_pulse_0), .EN(DirectionIn_in0[1]), .Q(Ack1_pulse_0_TFF));
  TFF TFF0_2(.rst_n(rst_n), .clk(Ack2_pulse_0), .EN(DirectionIn_in0[2]), .Q(Ack2_pulse_0_TFF));
  TFF TFF0_3(.rst_n(rst_n), .clk(Ack3_pulse_0), .EN(DirectionIn_in0[3]), .Q(Ack3_pulse_0_TFF));
  TFF TFF0_4(.rst_n(rst_n), .clk(Ack4_pulse_0), .EN(DirectionIn_in0[4]), .Q(Ack4_pulse_0_TFF));
  // XOR4D0BWP30P140ULVT lib_xor_ackout0(.A1(Ack1_pulse_0_TFF), .A2(Ack2_pulse_0_TFF), 
  //                           .A3(Ack3_pulse_0_TFF), .A4(Ack4_pulse_0_TFF), 
  //                           .Z(Ack_Out0));
  xor(Ack_Out0, Ack1_pulse_0_TFF, Ack2_pulse_0_TFF, Ack3_pulse_0_TFF, Ack4_pulse_0_TFF);

  NEFF NEFF0_1(.clk(State0), .D(Ack1_pulse_0_TFF), .Q(Ack1_pulse_0_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF0_2(.clk(State0), .D(Ack2_pulse_0_TFF), .Q(Ack2_pulse_0_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF0_3(.clk(State0), .D(Ack3_pulse_0_TFF), .Q(Ack3_pulse_0_TFF_NEFF), .rst_n(rst_n));
  NEFF NEFF0_4(.clk(State0), .D(Ack4_pulse_0_TFF), .Q(Ack4_pulse_0_TFF_NEFF), .rst_n(rst_n));
  demux demux_strobe0(.rst_n(rst_n),.input_wire(Strobe0), .RoutingDirection(DirectionIn_in0), 
                          .output0(Strobe0_0), .output1(Strobe0_1), 
                          .output2(Strobe0_2), .output3(Strobe0_3), .output4(Strobe0_4));
  demux demux_state0(.rst_n(rst_n), .input_wire(State0), .RoutingDirection(DirectionIn_in0), 
                          .output0(State0_0), .output1(State0_1), 
                          .output2(State0_2), .output3(State0_3), .output4(State0_4));
  // demux demux_clock0(.rst_n(rst_n), .input_wire(Clock0), .RoutingDirection(DirectionIn_in0), 
  //                         .output0(Clock0_0), .output1(Clock0_1), 
  //                         .output2(Clock0_2), .output3(Clock0_3), .output4(Clock0_4));

  demux demux_feedback0(.rst_n(rst_n),.input_wire(Feedback0), .RoutingDirection(DirectionIn_out0), 
                        .output0(Feedback0_0), .output1(Feedback0_1), 
                        .output2(Feedback0_2), .output3(Feedback0_3), .output4(Feedback0_4));
  mux mux_feedback0(.rst_n(rst_n),  .input0(Feedback0_0), .input1(Feedback1_0), .input2(Feedback2_0), .input3(Feedback3_0), .input4(Feedback4_0),
                      .RoutingDirection(DirectionIn_in0), .output_wire(Feedback_Out0));


  
  //fifo intf
  // XOR4D0BWP30P140ULVT lib_xor4_inport0( .A1(Ack1_pulse_0_TFF_NEFF), .A2(Ack2_pulse_0_TFF_NEFF), 
  //                             .A3(Ack3_pulse_0_TFF_NEFF), .A4(Ack4_pulse_0_TFF_NEFF), 
  //                             .Z(RD_in0));
  // XOR4D0BWP30P140ULVT lib_xor4_inport1( .A1(Ack0_pulse_1_TFF_NEFF), .A2(Ack2_pulse_1_TFF_NEFF), 
  //                             .A3(Ack3_pulse_1_TFF_NEFF), .A4(Ack4_pulse_1_TFF_NEFF), 
  //                             .Z(RD_in1));
  // XOR4D0BWP30P140ULVT lib_xor4_inport2( .A1(Ack0_pulse_2_TFF_NEFF), .A2(Ack1_pulse_2_TFF_NEFF), 
  //                             .A3(Ack3_pulse_2_TFF_NEFF), .A4(Ack4_pulse_2_TFF_NEFF), 
  //                             .Z(RD_in2));
  // XOR4D0BWP30P140ULVT lib_xor4_inport3( .A1(Ack0_pulse_3_TFF_NEFF), .A2(Ack1_pulse_3_TFF_NEFF), 
  //                             .A3(Ack2_pulse_3_TFF_NEFF), .A4(Ack4_pulse_3_TFF_NEFF), 
  //                             .Z(RD_in3));
  // XOR4D0BWP30P140ULVT lib_xor4_inport4( .A1(Ack0_pulse_4_TFF_NEFF), .A2(Ack1_pulse_4_TFF_NEFF), 
  //                             .A3(Ack2_pulse_4_TFF_NEFF), .A4(Ack3_pulse_4_TFF_NEFF), 
  //                             .Z(RD_in4));

  // XOR4D0BWP30P140ULVT lib_xor_rdout0( .A1(Ack0_pulse_1_TFF_NEFF), .A2(Ack0_pulse_2_TFF_NEFF), 
  //                           .A3(Ack0_pulse_3_TFF_NEFF), .A4(Ack0_pulse_4_TFF_NEFF), 
  //                           .Z(RD_out0));
  // XOR4D0BWP30P140ULVT lib_xor_rdout1( .A1(Ack1_pulse_0_TFF_NEFF), .A2(Ack1_pulse_2_TFF_NEFF), 
  //                           .A3(Ack1_pulse_3_TFF_NEFF), .A4(Ack1_pulse_4_TFF_NEFF), 
  //                           .Z(RD_out1));
  // XOR4D0BWP30P140ULVT lib_xor_rdout2( .A1(Ack2_pulse_0_TFF_NEFF), .A2(Ack2_pulse_1_TFF_NEFF), 
  //                           .A3(Ack2_pulse_3_TFF_NEFF), .A4(Ack2_pulse_4_TFF_NEFF), 
  //                           .Z(RD_out2));
  // XOR4D0BWP30P140ULVT lib_xor_rdout3( .A1(Ack3_pulse_0_TFF_NEFF), .A2(Ack3_pulse_1_TFF_NEFF), 
  //                           .A3(Ack3_pulse_2_TFF_NEFF), .A4(Ack3_pulse_4_TFF_NEFF), 
  //                           .Z(RD_out3));
  // XOR4D0BWP30P140ULVT lib_xor_rdout4( .A1(Ack4_pulse_0_TFF_NEFF), .A2(Ack4_pulse_1_TFF_NEFF), 
  //                           .A3(Ack4_pulse_2_TFF_NEFF), .A4(Ack4_pulse_3_TFF_NEFF), 
  //                           .Z(RD_out4));

  xor(RD_in0, Ack1_pulse_0_TFF_NEFF, Ack2_pulse_0_TFF_NEFF, Ack3_pulse_0_TFF_NEFF, Ack4_pulse_0_TFF_NEFF);
  xor(RD_in1, Ack0_pulse_1_TFF_NEFF, Ack2_pulse_1_TFF_NEFF, Ack3_pulse_1_TFF_NEFF, Ack4_pulse_1_TFF_NEFF);
  xor(RD_in2, Ack0_pulse_2_TFF_NEFF, Ack1_pulse_2_TFF_NEFF, Ack3_pulse_2_TFF_NEFF, Ack4_pulse_2_TFF_NEFF);
  xor(RD_in3, Ack0_pulse_3_TFF_NEFF, Ack1_pulse_3_TFF_NEFF, Ack2_pulse_3_TFF_NEFF, Ack4_pulse_3_TFF_NEFF);
  xor(RD_in4, Ack0_pulse_4_TFF_NEFF, Ack1_pulse_4_TFF_NEFF, Ack2_pulse_4_TFF_NEFF, Ack3_pulse_4_TFF_NEFF);

  xor(RD_out0, Ack0_pulse_1_TFF_NEFF, Ack0_pulse_2_TFF_NEFF, Ack0_pulse_3_TFF_NEFF, Ack0_pulse_4_TFF_NEFF);
  xor(RD_out1, Ack1_pulse_0_TFF_NEFF, Ack1_pulse_2_TFF_NEFF, Ack1_pulse_3_TFF_NEFF, Ack1_pulse_4_TFF_NEFF);
  xor(RD_out2, Ack2_pulse_0_TFF_NEFF, Ack2_pulse_1_TFF_NEFF, Ack2_pulse_3_TFF_NEFF, Ack2_pulse_4_TFF_NEFF);
  xor(RD_out3, Ack3_pulse_0_TFF_NEFF, Ack3_pulse_1_TFF_NEFF, Ack3_pulse_2_TFF_NEFF, Ack3_pulse_4_TFF_NEFF);
  xor(RD_out4, Ack4_pulse_0_TFF_NEFF, Ack4_pulse_1_TFF_NEFF, Ack4_pulse_2_TFF_NEFF, Ack4_pulse_3_TFF_NEFF);

endmodule
