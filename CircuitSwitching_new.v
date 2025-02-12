
module CircuitSwitching_new #(
    parameter DATASIZE=80
)(
  input wire clk, // Router clk
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
  input wire Clock4,
  input wire Clock3,
  input wire Clock2,
  input wire Clock1,
  input wire Clock0,
  output wire Clock_Out4,
  output wire Clock_Out3,
  output wire Clock_Out2,
  output wire Clock_Out1,
  output wire Clock_Out0,
  
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

    wire Strobe0_0, Strobe0_1, Strobe0_2, Strobe0_3, Strobe0_4;
    wire Strobe1_0, Strobe1_1, Strobe1_2, Strobe1_3, Strobe1_4;
    wire Strobe2_0, Strobe2_1, Strobe2_2, Strobe2_3, Strobe2_4;
    wire Strobe3_0, Strobe3_1, Strobe3_2, Strobe3_3, Strobe3_4;
    wire Strobe4_0, Strobe4_1, Strobe4_2, Strobe4_3, Strobe4_4;
  
    wire State0_0, State0_1, State0_2, State0_3, State0_4;
    wire State1_0, State1_1, State1_2, State1_3, State1_4;
    wire State2_0, State2_1, State2_2, State2_3, State2_4;
    wire State3_0, State3_1, State3_2, State3_3, State3_4;
    wire State4_0, State4_1, State4_2, State4_3, State4_4;

    wire Ack0_0, Ack0_1, Ack0_2, Ack0_3, Ack0_4;
    wire Ack1_0, Ack1_1, Ack1_2, Ack1_3, Ack1_4;
    wire Ack2_0, Ack2_1, Ack2_2, Ack2_3, Ack2_4;
    wire Ack3_0, Ack3_1, Ack3_2, Ack3_3, Ack3_4;
    wire Ack4_0, Ack4_1, Ack4_2, Ack4_3, Ack4_4;

    wire Clock0_0, Clock0_1, Clock0_2, Clock0_3, Clock0_4;
    wire Clock1_0, Clock1_1, Clock1_2, Clock1_3, Clock1_4;
    wire Clock2_0, Clock2_1, Clock2_2, Clock2_3, Clock2_4;
    wire Clock3_0, Clock3_1, Clock3_2, Clock3_3, Clock3_4;
    wire Clock4_0, Clock4_1, Clock4_2, Clock4_3, Clock4_4;

    wire Feedback0_0, Feedback0_1, Feedback0_2, Feedback0_3, Feedback0_4;
    wire Feedback1_0, Feedback1_1, Feedback1_2, Feedback1_3, Feedback1_4;
    wire Feedback2_0, Feedback2_1, Feedback2_2, Feedback2_3, Feedback2_4;
    wire Feedback3_0, Feedback3_1, Feedback3_2, Feedback3_3, Feedback3_4;
    wire Feedback4_0, Feedback4_1, Feedback4_2, Feedback4_3, Feedback4_4;

    wire [DATASIZE-1:0] CData0_0, CData0_1, CData0_2, CData0_3, CData0_4;
    wire [DATASIZE-1:0] CData1_0, CData1_1, CData1_2, CData1_3, CData1_4;
    wire [DATASIZE-1:0] CData2_0, CData2_1, CData2_2, CData2_3, CData2_4;
    wire [DATASIZE-1:0] CData3_0, CData3_1, CData3_2, CData3_3, CData3_4;
    wire [DATASIZE-1:0] CData4_0, CData4_1, CData4_2, CData4_3, CData4_4;

    genvar i;
    // Local-4
    demux demux_ack4(.rst_n(rst_n),
    .input_wire(Ack4), .RoutingDirection(DirectionIn_out4), 
    .output0(Ack4_0), .output1(Ack4_1), 
    .output2(Ack4_2), .output3(Ack4_3), .output4(Ack4_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout4_mux
      mux mux_cdataout4(.rst_n(rst_n),
        .input0(CData0_4[i]), .input1(CData1_4[i]), .input2(CData2_4[i]), .input3(CData3_4[i]), .input4(CData4_4[i]), 
        .RoutingDirection(DirectionIn_out4), .output_wire(CData_Out4[i]));
    end
  endgenerate
  mux mux_strobeout4(.rst_n(rst_n), .input0(Strobe0_4), .input1(Strobe1_4), .input2(Strobe2_4), .input3(Strobe3_4), .input4(Strobe4_4),
            .RoutingDirection(DirectionIn_out4), .output_wire(Strobe_Out4));
  mux mux_stateout4(.rst_n(rst_n), .input0(State0_4), .input1(State1_4), .input2(State2_4), .input3(State3_4), .input4(State4_4),
            .RoutingDirection(DirectionIn_out4), .output_wire(State_Out4));
  mux_clk mux_clockout4(.rst_n(rst_n), .input0(Clock0_4), .input1(Clock1_4), .input2(Clock2_4), .input3(Clock3_4), .input4(Clock4_4),
            .RoutingDirection(DirectionIn_out4), .output_wire(Clock_Out4));
    //
  mux mux_ack4(.rst_n(rst_n), .input0(Ack0_4), .input1(Ack1_4), .input2(Ack2_4), .input3(Ack3_4), .input4(Ack4_4),
            .RoutingDirection(DirectionIn_in4), .output_wire(Ack_Out4));
  demux demux_strobe4(.rst_n(rst_n),.input_wire(Strobe4), .RoutingDirection(DirectionIn_in4), 
                          .output0(Strobe4_0), .output1(Strobe4_1), 
                          .output2(Strobe4_2), .output3(Strobe4_3), .output4(Strobe4_4));
  demux demux_state4(.rst_n(rst_n), .input_wire(State4), .RoutingDirection(DirectionIn_in4), 
                          .output0(State4_0), .output1(State4_1), 
                          .output2(State4_2), .output3(State4_3), .output4(State4_4));
  demux demux_clock4(.rst_n(rst_n), .input_wire(Clock4), .RoutingDirection(DirectionIn_in4), 
                          .output0(Clock4_0), .output1(Clock4_1), 
                          .output2(Clock4_2), .output3(Clock4_3), .output4(Clock4_4));

  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout4_demux
      demux demux_cdataout4(.rst_n(rst_n), .input_wire(CData4[i]), .RoutingDirection(DirectionIn_in4), 
                          .output0(CData4_0[i]), .output1(CData4_1[i]), 
                          .output2(CData4_2[i]), .output3(CData4_3[i]), .output4(CData4_4[i]));
    end
  endgenerate

  demux demux_feedback4(.rst_n(rst_n),.input_wire(Feedback4), .RoutingDirection(DirectionIn_out4), 
                        .output0(Feedback4_0), .output1(Feedback4_1), 
                        .output2(Feedback4_2), .output3(Feedback4_3), .output4(Feedback4_4));
  mux mux_feedback4(.rst_n(rst_n),  .input0(Feedback0_4), .input1(Feedback1_4), .input2(Feedback2_4), .input3(Feedback3_4), .input4(Feedback4_4),
                      .RoutingDirection(DirectionIn_in4), .output_wire(Feedback_Out4));

    // West-3
    demux demux_ack3(.rst_n(rst_n),
    .input_wire(Ack3), .RoutingDirection(DirectionIn_out3), 
    .output0(Ack3_0), .output1(Ack3_1), 
    .output2(Ack3_2), .output3(Ack3_3), .output4(Ack3_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout3_mux
      mux mux_cdataout3(.rst_n(rst_n),
        .input0(CData0_3[i]), .input1(CData1_3[i]), .input2(CData2_3[i]), .input3(CData3_3[i]), .input4(CData4_3[i]), 
        .RoutingDirection(DirectionIn_out3), .output_wire(CData_Out3[i]));
    end
  endgenerate
  mux mux_strobeout3(.rst_n(rst_n), .input0(Strobe0_3), .input1(Strobe1_3), .input2(Strobe2_3), .input3(Strobe3_3), .input4(Strobe4_3),
            .RoutingDirection(DirectionIn_out3), .output_wire(Strobe_Out3));
  mux mux_stateout3(.rst_n(rst_n), .input0(State0_3), .input1(State1_3), .input2(State2_3), .input3(State3_3), .input4(State4_3),
            .RoutingDirection(DirectionIn_out3), .output_wire(State_Out3));
  mux_clk mux_clockout3(.rst_n(rst_n), .input0(Clock0_3), .input1(Clock1_3), .input2(Clock2_3), .input3(Clock3_3), .input4(Clock4_3),
            .RoutingDirection(DirectionIn_out3), .output_wire(Clock_Out3));
    //
  mux mux_ack3(.rst_n(rst_n), .input0(Ack0_3), .input1(Ack1_3), .input2(Ack2_3), .input3(Ack3_3), .input4(Ack4_3),
            .RoutingDirection(DirectionIn_in3), .output_wire(Ack_Out3));
  demux demux_strobe3(.rst_n(rst_n),.input_wire(Strobe3), .RoutingDirection(DirectionIn_in3), 
                          .output0(Strobe3_0), .output1(Strobe3_1), 
                          .output2(Strobe3_2), .output3(Strobe3_3), .output4(Strobe3_4));
  demux demux_state3(.rst_n(rst_n), .input_wire(State3), .RoutingDirection(DirectionIn_in3), 
                          .output0(State3_0), .output1(State3_1), 
                          .output2(State3_2), .output3(State3_3), .output4(State3_4));
  demux demux_clock3(.rst_n(rst_n), .input_wire(Clock3), .RoutingDirection(DirectionIn_in3), 
                          .output0(Clock3_0), .output1(Clock3_1), 
                          .output2(Clock3_2), .output3(Clock3_3), .output4(Clock3_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout3_demux
      demux demux_cdataout3(.rst_n(rst_n), .input_wire(CData3[i]), .RoutingDirection(DirectionIn_in3), 
                          .output0(CData3_0[i]), .output1(CData3_1[i]), 
                          .output2(CData3_2[i]), .output3(CData3_3[i]), .output4(CData3_4[i]));
    end
  endgenerate

  demux demux_feedback3(.rst_n(rst_n),.input_wire(Feedback3), .RoutingDirection(DirectionIn_out3), 
                        .output0(Feedback3_0), .output1(Feedback3_1), 
                        .output2(Feedback3_2), .output3(Feedback3_3), .output4(Feedback3_4));
  mux mux_feedback3(.rst_n(rst_n),  .input0(Feedback0_3), .input1(Feedback1_3), .input2(Feedback2_3), .input3(Feedback3_3), .input4(Feedback4_3),
                      .RoutingDirection(DirectionIn_in3), .output_wire(Feedback_Out3));
  
  //North-2
 demux demux_ack2(.rst_n(rst_n),
    .input_wire(Ack2), .RoutingDirection(DirectionIn_out2), 
    .output0(Ack2_0), .output1(Ack2_1), 
    .output2(Ack2_2), .output3(Ack2_3), .output4(Ack2_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout2_mux
      mux mux_cdataout2(.rst_n(rst_n),
        .input0(CData0_2[i]), .input1(CData1_2[i]), .input2(CData2_2[i]), .input3(CData3_2[i]), .input4(CData4_2[i]), 
        .RoutingDirection(DirectionIn_out2), .output_wire(CData_Out2[i]));
    end
  endgenerate
  mux mux_strobeout2(.rst_n(rst_n), .input0(Strobe0_2), .input1(Strobe1_2), .input2(Strobe2_2), .input3(Strobe3_2), .input4(Strobe4_2),
            .RoutingDirection(DirectionIn_out2), .output_wire(Strobe_Out2));
  mux mux_stateout2(.rst_n(rst_n), .input0(State0_2), .input1(State1_2), .input2(State2_2), .input3(State3_2), .input4(State4_2),
            .RoutingDirection(DirectionIn_out2), .output_wire(State_Out2));
  mux_clk mux_clockout2(.rst_n(rst_n), .input0(Clock0_2), .input1(Clock1_2), .input2(Clock2_2), .input3(Clock3_2), .input4(Clock4_2),
            .RoutingDirection(DirectionIn_out2), .output_wire(Clock_Out2));
    //
  mux mux_ack2(.rst_n(rst_n), .input0(Ack0_2), .input1(Ack1_2), .input2(Ack2_2), .input3(Ack3_2), .input4(Ack4_2),
            .RoutingDirection(DirectionIn_in2), .output_wire(Ack_Out2));
  demux demux_strobe2(.rst_n(rst_n),.input_wire(Strobe2), .RoutingDirection(DirectionIn_in2), 
                          .output0(Strobe2_0), .output1(Strobe2_1), 
                          .output2(Strobe2_2), .output3(Strobe2_3), .output4(Strobe2_4));
  demux demux_state2(.rst_n(rst_n), .input_wire(State2), .RoutingDirection(DirectionIn_in2), 
                          .output0(State2_0), .output1(State2_1), 
                          .output2(State2_2), .output3(State2_3), .output4(State2_4));
  demux demux_clock2(.rst_n(rst_n), .input_wire(Clock2), .RoutingDirection(DirectionIn_in2), 
                          .output0(Clock2_0), .output1(Clock2_1), 
                          .output2(Clock2_2), .output3(Clock2_3), .output4(Clock2_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout2_demux
      demux demux_cdataout2(.rst_n(rst_n), .input_wire(CData2[i]), .RoutingDirection(DirectionIn_in2), 
                          .output0(CData2_0[i]), .output1(CData2_1[i]), 
                          .output2(CData2_2[i]), .output3(CData2_3[i]), .output4(CData2_4[i]));
    end
  endgenerate

  demux demux_feedback2(.rst_n(rst_n),.input_wire(Feedback2), .RoutingDirection(DirectionIn_out2), 
                        .output0(Feedback2_0), .output1(Feedback2_1), 
                        .output2(Feedback2_2), .output3(Feedback2_3), .output4(Feedback2_4));
  mux mux_feedback2(.rst_n(rst_n),  .input0(Feedback0_2), .input1(Feedback1_2), .input2(Feedback2_2), .input3(Feedback3_2), .input4(Feedback4_2),
                      .RoutingDirection(DirectionIn_in2), .output_wire(Feedback_Out2));
  

  //East-1
   demux demux_ack1(.rst_n(rst_n),
    .input_wire(Ack1), .RoutingDirection(DirectionIn_out1), 
    .output0(Ack1_0), .output1(Ack1_1), 
    .output2(Ack1_2), .output3(Ack1_3), .output4(Ack1_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout1_mux
      mux mux_cdataout1(.rst_n(rst_n),
        .input0(CData0_1[i]), .input1(CData1_1[i]), .input2(CData2_1[i]), .input3(CData3_1[i]), .input4(CData4_1[i]), 
        .RoutingDirection(DirectionIn_out1), .output_wire(CData_Out1[i]));
    end
  endgenerate
  mux mux_strobeout1(.rst_n(rst_n), .input0(Strobe0_1), .input1(Strobe1_1), .input2(Strobe2_1), .input3(Strobe3_1), .input4(Strobe4_1),
            .RoutingDirection(DirectionIn_out1), .output_wire(Strobe_Out1));
  mux mux_stateout1(.rst_n(rst_n), .input0(State0_1), .input1(State1_1), .input2(State2_1), .input3(State3_1), .input4(State4_1),
            .RoutingDirection(DirectionIn_out1), .output_wire(State_Out1));
  mux_clk mux_clockout1(.rst_n(rst_n), .input0(Clock0_1), .input1(Clock1_1), .input2(Clock2_1), .input3(Clock3_1), .input4(Clock4_1),
            .RoutingDirection(DirectionIn_out1), .output_wire(Clock_Out1));
    //
  mux mux_ack1(.rst_n(rst_n), .input0(Ack0_1), .input1(Ack1_1), .input2(Ack2_1), .input3(Ack3_1), .input4(Ack4_1),
            .RoutingDirection(DirectionIn_in1), .output_wire(Ack_Out1));
  demux demux_strobe1(.rst_n(rst_n),.input_wire(Strobe1), .RoutingDirection(DirectionIn_in1), 
                          .output0(Strobe1_0), .output1(Strobe1_1), 
                          .output2(Strobe1_2), .output3(Strobe1_3), .output4(Strobe1_4));
  demux demux_state1(.rst_n(rst_n), .input_wire(State1), .RoutingDirection(DirectionIn_in1), 
                          .output0(State1_0), .output1(State1_1), 
                          .output2(State1_2), .output3(State1_3), .output4(State1_4));
  demux demux_clock1(.rst_n(rst_n), .input_wire(Clock1), .RoutingDirection(DirectionIn_in1), 
                          .output0(Clock1_0), .output1(Clock1_1), 
                          .output2(Clock1_2), .output3(Clock1_3), .output4(Clock1_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout1_demux
      demux demux_cdataout1(.rst_n(rst_n), .input_wire(CData1[i]), .RoutingDirection(DirectionIn_in1), 
                          .output0(CData1_0[i]), .output1(CData1_1[i]), 
                          .output2(CData1_2[i]), .output3(CData1_3[i]), .output4(CData1_4[i]));
    end
  endgenerate

  demux demux_feedback1(.rst_n(rst_n),.input_wire(Feedback1), .RoutingDirection(DirectionIn_out1), 
                        .output0(Feedback1_0), .output1(Feedback1_1), 
                        .output2(Feedback1_2), .output3(Feedback1_3), .output4(Feedback1_4));
  mux mux_feedback1(.rst_n(rst_n),  .input0(Feedback0_1), .input1(Feedback1_1), .input2(Feedback2_1), .input3(Feedback3_1), .input4(Feedback4_1),
                      .RoutingDirection(DirectionIn_in1), .output_wire(Feedback_Out1));

  //South-0
   demux demux_ack0(.rst_n(rst_n),
    .input_wire(Ack0), .RoutingDirection(DirectionIn_out0), 
    .output0(Ack0_0), .output1(Ack0_1), 
    .output2(Ack0_2), .output3(Ack0_3), .output4(Ack0_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout0_mux
      mux mux_cdataout0(.rst_n(rst_n),
        .input0(CData0_0[i]), .input1(CData1_0[i]), .input2(CData2_0[i]), .input3(CData3_0[i]), .input4(CData4_0[i]), 
        .RoutingDirection(DirectionIn_out0), .output_wire(CData_Out0[i]));
    end
  endgenerate
  mux mux_strobeout0(.rst_n(rst_n), .input0(Strobe0_0), .input1(Strobe1_0), .input2(Strobe2_0), .input3(Strobe3_0), .input4(Strobe4_0),
            .RoutingDirection(DirectionIn_out0), .output_wire(Strobe_Out0));
  mux mux_stateout0(.rst_n(rst_n), .input0(State0_0), .input1(State1_0), .input2(State2_0), .input3(State3_0), .input4(State4_0),
            .RoutingDirection(DirectionIn_out0), .output_wire(State_Out0));
  mux_clk mux_clockout0(.rst_n(rst_n), .input0(Clock0_0), .input1(Clock1_0), .input2(Clock2_0), .input3(Clock3_0), .input4(Clock4_0),
            .RoutingDirection(DirectionIn_out0), .output_wire(Clock_Out0));
    //
  mux mux_ack0(.rst_n(rst_n), .input0(Ack0_0), .input1(Ack1_0), .input2(Ack2_0), .input3(Ack3_0), .input4(Ack4_0),
            .RoutingDirection(DirectionIn_in0), .output_wire(Ack_Out0));
  demux demux_strobe0(.rst_n(rst_n),.input_wire(Strobe0), .RoutingDirection(DirectionIn_in0), 
                          .output0(Strobe0_0), .output1(Strobe0_1), 
                          .output2(Strobe0_2), .output3(Strobe0_3), .output4(Strobe0_4));
  demux demux_state0(.rst_n(rst_n), .input_wire(State0), .RoutingDirection(DirectionIn_in0), 
                          .output0(State0_0), .output1(State0_1), 
                          .output2(State0_2), .output3(State0_3), .output4(State0_4));
  generate 
    for(i=0;i<DATASIZE;i=i+1) begin: CDataout0_demux
      demux demux_cdataout0(.rst_n(rst_n), .input_wire(CData0[i]), .RoutingDirection(DirectionIn_in0), 
                          .output0(CData0_0[i]), .output1(CData0_1[i]), 
                          .output2(CData0_2[i]), .output3(CData0_3[i]), .output4(CData0_4[i]));
    end
  endgenerate
  demux demux_clock0(.rst_n(rst_n), .input_wire(Clock0), .RoutingDirection(DirectionIn_in0), 
                          .output0(Clock0_0), .output1(Clock0_1), 
                          .output2(Clock0_2), .output3(Clock0_3), .output4(Clock0_4));
  demux demux_feedback0(.rst_n(rst_n),.input_wire(Feedback0), .RoutingDirection(DirectionIn_out0), 
                        .output0(Feedback0_0), .output1(Feedback0_1), 
                        .output2(Feedback0_2), .output3(Feedback0_3), .output4(Feedback0_4));
  mux mux_feedback0(.rst_n(rst_n),  .input0(Feedback0_0), .input1(Feedback1_0), .input2(Feedback2_0), .input3(Feedback3_0), .input4(Feedback4_0),
                      .RoutingDirection(DirectionIn_in0), .output_wire(Feedback_Out0));

  
  //fifo intf
  reg State_Out0_sync, State_Out0_sync2, State_Out0_d;
  reg State_Out1_sync, State_Out1_sync2, State_Out1_d;
  reg State_Out2_sync, State_Out2_sync2, State_Out2_d;
  reg State_Out3_sync, State_Out3_sync2, State_Out3_d;
  reg State_Out4_sync, State_Out4_sync2, State_Out4_d;
  reg State0_sync, State0_sync2, State0_d;
  reg State1_sync, State1_sync2, State1_d;
  reg State2_sync, State2_sync2, State2_d;
  reg State3_sync, State3_sync2, State3_d;
  reg State4_sync, State4_sync2, State4_d;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State0_sync <= 0;
      State0_sync2 <= 0;
      State0_d <= 0;
    end
    else begin
      State0_sync <= State0;
      State0_sync2 <= State0_sync;
      State0_d <= State0_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State1_sync <= 0;
      State1_sync2 <= 0;
      State1_d <= 0;
    end
    else begin
      State1_sync <= State1;
      State1_sync2 <= State1_sync;
      State1_d <= State1_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State2_sync <= 0;
      State2_sync2 <= 0;
      State2_d <= 0;
    end
    else begin
      State2_sync <= State2;
      State2_sync2 <= State2_sync;
      State2_d <= State2_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State3_sync <= 0;
      State3_sync2 <= 0;
      State3_d <= 0;
    end
    else begin
      State3_sync <= State3;
      State3_sync2 <= State3_sync;
      State3_d <= State3_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State4_sync <= 0;
      State4_sync2 <= 0;
      State4_d <= 0;
    end
    else begin
      State4_sync <= State4;
      State4_sync2 <= State4_sync;
      State4_d <= State4_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State_Out0_sync <= 0;
      State_Out0_sync2 <= 0;
      State_Out0_d <= 0;
    end
    else begin
      State_Out0_sync <= State_Out0;
      State_Out0_sync2 <= State_Out0_sync;
      State_Out0_d <= State_Out0_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State_Out1_sync <= 0;
      State_Out1_sync2 <= 0;
      State_Out1_d <= 0;
    end
    else begin
      State_Out1_sync <= State_Out1;
      State_Out1_sync2 <= State_Out1_sync;
      State_Out1_d <= State_Out1_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State_Out2_sync <= 0;
      State_Out2_sync2 <= 0;
      State_Out2_d <= 0;
    end
    else begin
      State_Out2_sync <= State_Out2;
      State_Out2_sync2 <= State_Out2_sync;
      State_Out2_d <= State_Out2_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State_Out3_sync <= 0;
      State_Out3_sync2 <= 0;
      State_Out3_d <= 0;
    end
    else begin
      State_Out3_sync <= State_Out3;
      State_Out3_sync2 <= State_Out3_sync;
      State_Out3_d <= State_Out3_sync2;
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      State_Out4_sync <= 0;
      State_Out4_sync2 <= 0;
      State_Out4_d <= 0;
    end
    else begin
      State_Out4_sync <= State_Out4;
      State_Out4_sync2 <= State_Out4_sync;
      State_Out4_d <= State_Out4_sync2;
    end
  end

  assign RD_in4 = State4_d && (!State4_sync2);
  assign RD_in3 = State3_d && (!State3_sync2);
  assign RD_in2 = State2_d && (!State2_sync2);
  assign RD_in1 = State1_d && (!State1_sync2);
  assign RD_in0 = State0_d && (!State0_sync2);

  assign RD_out4 = State_Out4_d && (!State_Out4_sync2);
  assign RD_out3 = State_Out3_d && (!State_Out3_sync2);
  assign RD_out2 = State_Out2_d && (!State_Out2_sync2);
  assign RD_out1 = State_Out1_d && (!State_Out1_sync2);
  assign RD_out0 = State_Out0_d && (!State_Out0_sync2);

endmodule
