`include "./noc_define.v"

module Router (
    input   wire [3:0]              ID,
    input   wire	                  rst_n,
    input   wire	                  clk_L,               // Local PE Clock
    input   wire                    clk,                 // ALL Router Clock
    // input   wire                    clk_W,
    // input   wire                    clk_N,
    // input   wire                    clk_E,
    // input   wire                    clk_S,
    input   wire [1:0]              test_mode,

    // PacketSwitching
    input   wire [`PDATASIZE-1:0]    L_packet_data_in,
    input   wire [`PDATASIZE-1:0]    W_packet_data_in,
    input   wire [`PDATASIZE-1:0]    N_packet_data_in,
    input   wire [`PDATASIZE-1:0]    E_packet_data_in,
    input   wire [`PDATASIZE-1:0]    S_packet_data_in,

    input   wire                    L_packet_valid_in,
    input   wire                    W_packet_valid_in,
    input   wire                    N_packet_valid_in,
    input   wire                    E_packet_valid_in,
    input   wire                    S_packet_valid_in,

    input   wire                    W_packet_full_in,
    input   wire                    N_packet_full_in,
    input   wire                    E_packet_full_in,
    input   wire                    S_packet_full_in,
    //New
    input   wire                    L_packet_full_in,

    output	wire [`PDATASIZE-1:0]    L_packet_data_out,
    output	wire [`PDATASIZE-1:0]    W_packet_data_out,
    output	wire [`PDATASIZE-1:0]    N_packet_data_out,
    output	wire [`PDATASIZE-1:0]    E_packet_data_out,
    output	wire [`PDATASIZE-1:0]    S_packet_data_out,

    output	wire                    L_packet_valid_out,
    output	wire                    W_packet_valid_out,
    output	wire                    N_packet_valid_out,
    output	wire                    E_packet_valid_out,
    output	wire                    S_packet_valid_out,

    output	wire                    L_packet_full_out,
    output	wire                    W_packet_full_out,
    output	wire                    N_packet_full_out,
    output	wire                    E_packet_full_out,
    output  wire                    S_packet_full_out,

    // CircuitSwitching_handshake
    // input   wire                    Tail4,//Local
    // input   wire                    Tail3,//West
    // input   wire                    Tail2,//North
    // input   wire                    Tail1,//East
    // input   wire                    Tail0,//South

    // input   wire                    Stream4,
    // input   wire                    Stream3,
    // input   wire                    Stream2,
    // input   wire                    Stream1,
    // input   wire                    Stream0,

    // output  wire                    Tail_Out4,
    // output  wire                    Tail_Out3,
    // output  wire                    Tail_Out2,
    // output  wire                    Tail_Out1,
    // output  wire                    Tail_Out0,

    // output  wire                    Stream_Out4,
    // output  wire                    Stream_Out3,
    // output  wire                    Stream_Out2,
    // output  wire                    Stream_Out1,
    // output  wire                    Stream_Out0,

    //CircuitSwitching
    input   wire                    Ack4,//local
    input   wire                    Ack3,//west
    input   wire                    Ack2,//north
    input   wire                    Ack1,//east
    input   wire                    Ack0,//south
    output  wire                    Ack_Out4,
    output  wire                    Ack_Out3,
    output  wire                    Ack_Out2,
    output  wire                    Ack_Out1,
    output  wire                    Ack_Out0,
    input   wire [`CDATASIZE-1:0]    CData4,
    input   wire [`CDATASIZE-1:0]    CData3,
    input   wire [`CDATASIZE-1:0]    CData2,
    input   wire [`CDATASIZE-1:0]    CData1,
    input   wire [`CDATASIZE-1:0]    CData0,
    output  wire [`CDATASIZE-1:0]    CData_Out4,
    output  wire [`CDATASIZE-1:0]    CData_Out3,
    output  wire [`CDATASIZE-1:0]    CData_Out2,
    output  wire [`CDATASIZE-1:0]    CData_Out1,
    output  wire [`CDATASIZE-1:0]    CData_Out0,
    input   wire                    Strobe4,
    input   wire                    Strobe3,
    input   wire                    Strobe2,
    input   wire                    Strobe1,
    input   wire                    Strobe0,
    output  wire                    Strobe_Out4,
    output  wire                    Strobe_Out3,
    output  wire                    Strobe_Out2,
    output  wire                    Strobe_Out1,
    output  wire                    Strobe_Out0,
    input   wire                    State4,
    input   wire                    State3,
    input   wire                    State2,
    input   wire                    State1,
    input   wire                    State0,
    output  wire                    State_Out4,
    output  wire                    State_Out3,
    output  wire                    State_Out2,
    output  wire                    State_Out1,
    output  wire                    State_Out0,
    // input   wire                    Clock4,
    // input   wire                    Clock3,
    // input   wire                    Clock2,
    // input   wire                    Clock1,
    // input   wire                    Clock0,
    // output  reg                     Clock_Out4,
    // output  reg                     Clock_Out3,
    // output  reg                     Clock_Out2,
    // output  reg                     Clock_Out1,
    // output  reg                     Clock_Out0,
    input   wire                    Feedback4,
    input   wire                    Feedback3,
    input   wire                    Feedback2,
    input   wire                    Feedback1,
    input   wire                    Feedback0,
    output  wire                    Feedback_Out4,
    output  wire                    Feedback_Out3,
    output  wire                    Feedback_Out2,
    output  wire                    Feedback_Out1,
    output  wire                    Feedback_Out0

  );

  wire        WR_in4;
  wire        WR_in3;
  wire        WR_in2;
  wire        WR_in1;
  wire        WR_in0;
  wire        WR_out4;
  wire        WR_out3;
  wire        WR_out2;
  wire        WR_out1;
  wire        WR_out0;
  wire [3:0]  Packet_DirectionIn_in4;
  wire [3:0]  Packet_DirectionIn_in3;
  wire [3:0]  Packet_DirectionIn_in2;
  wire [3:0]  Packet_DirectionIn_in1;
  wire [3:0]  Packet_DirectionIn_in0;
  wire [4:0]  Packet_DirectionIn_out4;
  wire [4:0]  Packet_DirectionIn_out3;
  wire [4:0]  Packet_DirectionIn_out2;
  wire [4:0]  Packet_DirectionIn_out1;
  wire [4:0]  Packet_DirectionIn_out0;
  wire        full_inport4;
  wire        full_inport3;
  wire        full_inport2;
  wire        full_inport1;
  wire        full_inport0;
  wire        full_outport4;
  wire        full_outport3;
  wire        full_outport2;
  wire        full_outport1;
  wire        full_outport0;

  wire         RD_in0;
  wire         RD_in1;
  wire         RD_in2;
  wire         RD_in3;
  wire         RD_in4;
  wire         RD_out0;
  wire         RD_out1;
  wire         RD_out2;
  wire         RD_out3;
  wire         RD_out4;
  wire [4:0]  Circuit_DirectionIn_in0;
  wire [4:0]  Circuit_DirectionIn_in1;
  wire [4:0]  Circuit_DirectionIn_in2;
  wire [4:0]  Circuit_DirectionIn_in3;
  wire [4:0]  Circuit_DirectionIn_in4;
  wire [4:0]  Circuit_DirectionIn_out0;
  wire [4:0]  Circuit_DirectionIn_out1;
  wire [4:0]  Circuit_DirectionIn_out2;
  wire [4:0]  Circuit_DirectionIn_out3;
  wire [4:0]  Circuit_DirectionIn_out4;

  wire rclk_sync_outfifo_0;
  wire rclk_sync_outfifo_1;
  wire rclk_sync_outfifo_2;
  wire rclk_sync_outfifo_3;
  wire rclk_sync_outfifo_4;
  wire [4:0] rdata_sync_outfifo_0;
  wire [4:0] rdata_sync_outfifo_1;
  wire [4:0] rdata_sync_outfifo_2;
  wire [4:0] rdata_sync_outfifo_3;
  wire [4:0] rdata_sync_outfifo_4;

  PacketSwitching #(`SYNC_FIFO_DEPTH, `Packet_FIFO_DEPTH, `PDATASIZE) PacketSwitching(
    .ID(ID), .rst_n(rst_n),
    .clk_L(clk_L), .clk(clk), 

    .L_data_in(L_packet_data_in),
    .W_data_in(W_packet_data_in),
    .N_data_in(N_packet_data_in),
    .E_data_in(E_packet_data_in),
    .S_data_in(S_packet_data_in),

    .L_valid_in(L_packet_valid_in),
    .W_valid_in(W_packet_valid_in),
    .N_valid_in(N_packet_valid_in),
    .E_valid_in(E_packet_valid_in),
    .S_valid_in(S_packet_valid_in),

    .W_full_in(W_packet_full_in),
    .N_full_in(N_packet_full_in),
    .E_full_in(E_packet_full_in),
    .S_full_in(S_packet_full_in),
    .L_full_in(L_packet_full_in),
    
    .L_data_out(L_packet_data_out),
    .W_data_out(W_packet_data_out),
    .N_data_out(N_packet_data_out),
    .E_data_out(E_packet_data_out),
    .S_data_out(S_packet_data_out),

    .L_valid_out(L_packet_valid_out),
    .W_valid_out(W_packet_valid_out),
    .N_valid_out(N_packet_valid_out),
    .E_valid_out(E_packet_valid_out),
    .S_valid_out(S_packet_valid_out),

    .full(L_packet_full_out),
    .W_full_out(W_packet_full_out),
    .N_full_out(N_packet_full_out),
    .E_full_out(E_packet_full_out),
    .S_full_out(S_packet_full_out),

    .L_label(Packet_DirectionIn_in4),
    .W_label(Packet_DirectionIn_in3),
    .N_label(Packet_DirectionIn_in2),
    .E_label(Packet_DirectionIn_in1),
    .S_label(Packet_DirectionIn_in0),

    .L_infifo_winc(WR_in4),
    .W_infifo_winc(WR_in3),
    .N_infifo_winc(WR_in2),
    .E_infifo_winc(WR_in1),
    .S_infifo_winc(WR_in0),

    .L_arb_res(Packet_DirectionIn_out4),
    .W_arb_res(Packet_DirectionIn_out3),
    .N_arb_res(Packet_DirectionIn_out2),
    .E_arb_res(Packet_DirectionIn_out1),
    .S_arb_res(Packet_DirectionIn_out0),

    .L_outfifo_winc(WR_out4),
    .W_outfifo_winc(WR_out3),
    .N_outfifo_winc(WR_out2),
    .E_outfifo_winc(WR_out1),
    .S_outfifo_winc(WR_out0),

    .L_infifo_wfull(full_inport4),
    .W_infifo_wfull(full_inport3),
    .N_infifo_wfull(full_inport2),
    .E_infifo_wfull(full_inport1),
    .S_infifo_wfull(full_inport0),

    .L_outfifo_wfull(full_outport4),
    .W_outfifo_wfull(full_outport3),
    .N_outfifo_wfull(full_outport2),
    .E_outfifo_wfull(full_outport1),
    .S_outfifo_wfull(full_outport0),

    .L_outfifo_rclk_sync(rclk_sync_outfifo_4),
    .W_outfifo_rclk_sync(rclk_sync_outfifo_3),
    .N_outfifo_rclk_sync(rclk_sync_outfifo_2),
    .E_outfifo_rclk_sync(rclk_sync_outfifo_1),
    .S_outfifo_rclk_sync(rclk_sync_outfifo_0),

    .L_outfifo_rdata_sync(rdata_sync_outfifo_4),
    .W_outfifo_rdata_sync(rdata_sync_outfifo_3),
    .N_outfifo_rdata_sync(rdata_sync_outfifo_2),
    .E_outfifo_rdata_sync(rdata_sync_outfifo_1),
    .S_outfifo_rdata_sync(rdata_sync_outfifo_0)
  );

    wire [`CDATASIZE-1:0]    CData_Out4_dut;
    wire [`CDATASIZE-1:0]    CData_Out3_dut;
    wire [`CDATASIZE-1:0]    CData_Out2_dut;
    wire [`CDATASIZE-1:0]    CData_Out1_dut;
    wire [`CDATASIZE-1:0]    CData_Out0_dut;
    wire [`CDATASIZE-1:0]    CData_Out4_handshake;
    wire [`CDATASIZE-1:0]    CData_Out3_handshake;
    wire [`CDATASIZE-1:0]    CData_Out2_handshake;
    wire [`CDATASIZE-1:0]    CData_Out1_handshake;
    wire [`CDATASIZE-1:0]    CData_Out0_handshake;
    // wire [`CDATASIZE-1:0]    CData_Out4_fifo4;
    // wire [`CDATASIZE-1:0]    CData_Out3_fifo4;
    // wire [`CDATASIZE-1:0]    CData_Out2_fifo4;
    // wire [`CDATASIZE-1:0]    CData_Out1_fifo4;
    // wire [`CDATASIZE-1:0]    CData_Out0_fifo4;
    // wire [`CDATASIZE-1:0]    CData_Out4_fifo16;
    // wire [`CDATASIZE-1:0]    CData_Out3_fifo16;
    // wire [`CDATASIZE-1:0]    CData_Out2_fifo16;
    // wire [`CDATASIZE-1:0]    CData_Out1_fifo16;
    // wire [`CDATASIZE-1:0]    CData_Out0_fifo16;

    wire        RD_in0_dut;
    wire        RD_in1_dut;
    wire        RD_in2_dut;
    wire        RD_in3_dut;
    wire        RD_in4_dut;
    wire        RD_out0_dut;
    wire        RD_out1_dut;
    wire        RD_out2_dut;
    wire        RD_out3_dut;
    wire        RD_out4_dut;

    wire        RD_in0_handshake;
    wire        RD_in1_handshake;
    wire        RD_in2_handshake;
    wire        RD_in3_handshake;
    wire        RD_in4_handshake;
    wire        RD_out0_handshake;
    wire        RD_out1_handshake;
    wire        RD_out2_handshake;
    wire        RD_out3_handshake;
    wire        RD_out4_handshake;

    // wire        RD_in0_fifo4;
    // wire        RD_in1_fifo4;
    // wire        RD_in2_fifo4;
    // wire        RD_in3_fifo4;
    // wire        RD_in4_fifo4;
    // wire        RD_out0_fifo4;
    // wire        RD_out1_fifo4;
    // wire        RD_out2_fifo4;
    // wire        RD_out3_fifo4;
    // wire        RD_out4_fifo4;

    // wire        RD_in0_fifo16;
    // wire        RD_in1_fifo16;
    // wire        RD_in2_fifo16;
    // wire        RD_in3_fifo16;
    // wire        RD_in4_fifo16;
    // wire        RD_out0_fifo16;
    // wire        RD_out1_fifo16;
    // wire        RD_out2_fifo16;
    // wire        RD_out3_fifo16;
    // wire        RD_out4_fifo16;

    wire        Ack_Out4_dut;
    wire        Ack_Out3_dut;
    wire        Ack_Out2_dut;
    wire        Ack_Out1_dut;
    wire        Ack_Out0_dut;
    
    wire        Ack_Out4_handshake;
    wire        Ack_Out3_handshake;
    wire        Ack_Out2_handshake;
    wire        Ack_Out1_handshake;
    wire        Ack_Out0_handshake;
    // wire        Ack_Out4_fifo4;
    // wire        Ack_Out3_fifo4;
    // wire        Ack_Out2_fifo4;
    // wire        Ack_Out1_fifo4;
    // wire        Ack_Out0_fifo4;
    // wire        Ack_Out4_fifo16;
    // wire        Ack_Out3_fifo16;
    // wire        Ack_Out2_fifo16;
    // wire        Ack_Out1_fifo16;
    // wire        Ack_Out0_fifo16;

    // wire         Clock_Out4_dut;
    // wire         Clock_Out3_dut;
    // wire         Clock_Out2_dut;
    // wire         Clock_Out1_dut;
    // wire         Clock_Out0_dut;

    // wire         Clock_Out4_handshake;
    // wire         Clock_Out3_handshake;
    // wire         Clock_Out2_handshake;
    // wire         Clock_Out1_handshake;
    // wire         Clock_Out0_handshake;

    // always @(*) begin
    //   case (test_mode)
    //     2'b00 : {RD_in0,RD_in1,RD_in2,RD_in3,RD_in4} = {RD_in0_dut,RD_in1_dut,RD_in2_dut,RD_in3_dut,RD_in4_dut};
    //     2'b01,2'b10,2'b11 : {RD_in0,RD_in1,RD_in2,RD_in3,RD_in4} = {RD_in0_handshake,RD_in1_handshake,RD_in2_handshake,RD_in3_handshake,RD_in4_handshake};
    //     default: {RD_in0,RD_in1,RD_in2,RD_in3,RD_in4} = {RD_in0_dut,RD_in1_dut,RD_in2_dut,RD_in3_dut,RD_in4_dut};
    //   endcase
    // end

    // always @(*) begin
    //   case (test_mode)
    //     2'b00 : {RD_out0,RD_out1,RD_out2,RD_out3,RD_out4} = {RD_out0_dut,RD_out1_dut,RD_out2_dut,RD_out3_dut,RD_out4_dut};
    //     2'b01,2'b10,2'b11 : {RD_out0,RD_out1,RD_out2,RD_out3,RD_out4} = {RD_out0_handshake,RD_out1_handshake,RD_out2_handshake,RD_out3_handshake,RD_out4_handshake};
    //     default: {RD_out0,RD_out1,RD_out2,RD_out3,RD_out4} = {RD_out0_dut,RD_out1_dut,RD_out2_dut,RD_out3_dut,RD_out4_dut};
    //   endcase
    // end

    // always @(*) begin
    //   case (test_mode)
    //     2'b00 : {CData_Out0,CData_Out1,CData_Out2,CData_Out3,CData_Out4} = {CData_Out0_dut,CData_Out1_dut,CData_Out2_dut,CData_Out3_dut,CData_Out4_dut};
    //     2'b01,2'b10,2'b11 : {CData_Out0,CData_Out1,CData_Out2,CData_Out3,CData_Out4} = {CData_Out0_handshake,CData_Out1_handshake,CData_Out2_handshake,CData_Out3_handshake,CData_Out4_handshake};
    //     default: {CData_Out0,CData_Out1,CData_Out2,CData_Out3,CData_Out4} = {CData_Out0_dut,CData_Out1_dut,CData_Out2_dut,CData_Out3_dut,CData_Out4_dut};
    //   endcase
    // end


    // always @(*) begin
    //   case (test_mode)
    //     2'b00 : {Ack_Out0,Ack_Out1,Ack_Out2,Ack_Out3,Ack_Out4} = {Ack_Out0_dut,Ack_Out1_dut,Ack_Out2_dut,Ack_Out3_dut,Ack_Out4_dut};
    //     2'b01,2'b10,2'b11 : {Ack_Out0,Ack_Out1,Ack_Out2,Ack_Out3,Ack_Out4} = {Ack_Out0_handshake,Ack_Out1_handshake,Ack_Out2_handshake,Ack_Out3_handshake,Ack_Out4_handshake};
    //     default: {Ack_Out0,Ack_Out1,Ack_Out2,Ack_Out3,Ack_Out4} = {Ack_Out0_dut,Ack_Out1_dut,Ack_Out2_dut,Ack_Out3_dut,Ack_Out4_dut};
    //   endcase
    // end

    // always @(*) begin
    //   case (test_mode)
    //     2'b00 : {Clock_Out0,Clock_Out1,Clock_Out2,Clock_Out3,Clock_Out4} = {Clock_Out0_dut,Clock_Out1_dut,Clock_Out2_dut,Clock_Out3_dut,Clock_Out4_dut};
    //     2'b01,2'b10,2'b11 : {Clock_Out0,Clock_Out1,Clock_Out2,Clock_Out3,Clock_Out4} = {Clock_Out0_handshake,Clock_Out1_handshake,Clock_Out2_handshake,Clock_Out3_handshake,Clock_Out4_handshake};
    //     default: {Clock_Out0,Clock_Out1,Clock_Out2,Clock_Out3,Clock_Out4} = {Clock_Out0_dut,Clock_Out1_dut,Clock_Out2_dut,Clock_Out3_dut,Clock_Out4_dut};
    //   endcase
    // end

  CircuitSwitching #(`CDATASIZE) CircuitSwitching(
    .rst_n(rst_n),
    .Ack0(Ack0), 
    .Ack1(Ack1), 
    .Ack2(Ack2), 
    .Ack3(Ack3), 
    .Ack4(Ack4), 
    .CData0(CData0),
    .CData1(CData1),
    .CData2(CData2),
    .CData3(CData3),
    .CData4(CData4),
    .Strobe0(Strobe0),
    .Strobe1(Strobe1),
    .Strobe2(Strobe2),
    .Strobe3(Strobe3),
    .Strobe4(Strobe4),
    .State0(State0),
    .State1(State1),
    .State2(State2),
    .State3(State3),
    .State4(State4),
    // .Clock0(Clock0),
    // .Clock1(Clock1),
    // .Clock2(Clock2),
    // .Clock3(Clock3),
    // .Clock4(Clock4),
    .Ack_Out0(Ack_Out0),
    .Ack_Out1(Ack_Out1),
    .Ack_Out2(Ack_Out2),
    .Ack_Out3(Ack_Out3),
    .Ack_Out4(Ack_Out4),
    .CData_Out0(CData_Out0),
    .CData_Out1(CData_Out1),
    .CData_Out2(CData_Out2),
    .CData_Out3(CData_Out3),
    .CData_Out4(CData_Out4),
    .Strobe_Out0(Strobe_Out0), 
    .Strobe_Out1(Strobe_Out1), 
    .Strobe_Out2(Strobe_Out2), 
    .Strobe_Out3(Strobe_Out3), 
    .Strobe_Out4(Strobe_Out4), 
    .State_Out0(State_Out0), 
    .State_Out1(State_Out1), 
    .State_Out2(State_Out2), 
    .State_Out3(State_Out3), 
    .State_Out4(State_Out4), 
    // .Clock_Out0(Clock_Out0_dut),
    // .Clock_Out1(Clock_Out1_dut),
    // .Clock_Out2(Clock_Out2_dut),
    // .Clock_Out3(Clock_Out3_dut),
    // .Clock_Out4(Clock_Out4_dut),
    .Feedback0(Feedback0),
    .Feedback1(Feedback1),
    .Feedback2(Feedback2),
    .Feedback3(Feedback3),
    .Feedback4(Feedback4),
    .Feedback_Out0(Feedback_Out0),
    .Feedback_Out1(Feedback_Out1),
    .Feedback_Out2(Feedback_Out2),
    .Feedback_Out3(Feedback_Out3),
    .Feedback_Out4(Feedback_Out4),
    
    .RD_in0(RD_in0),
    .RD_in1(RD_in1),
    .RD_in2(RD_in2),
    .RD_in3(RD_in3),
    .RD_in4(RD_in4),
    .RD_out0(RD_out0),
    .RD_out1(RD_out1),
    .RD_out2(RD_out2),
    .RD_out3(RD_out3),
    .RD_out4(RD_out4),
    .DirectionIn_in0(Circuit_DirectionIn_in0), 
    .DirectionIn_in1(Circuit_DirectionIn_in1), 
    .DirectionIn_in2(Circuit_DirectionIn_in2), 
    .DirectionIn_in3(Circuit_DirectionIn_in3), 
    .DirectionIn_in4(Circuit_DirectionIn_in4), 
    .DirectionIn_out0(Circuit_DirectionIn_out0),
    .DirectionIn_out1(Circuit_DirectionIn_out1),
    .DirectionIn_out2(Circuit_DirectionIn_out2),
    .DirectionIn_out3(Circuit_DirectionIn_out3),
    .DirectionIn_out4(Circuit_DirectionIn_out4)
    );


  // CircuitSwitching_handshake #(`CDATASIZE) CircuitSwitching_handshake(
  //   .rst_n(rst_n),
  //   .Tail4(Tail4),
  //   .Tail3(Tail3),
  //   .Tail2(Tail2),
  //   .Tail1(Tail1),
  //   .Tail0(Tail0),
  //   .Stream4(Stream4),
  //   .Stream3(Stream3),
  //   .Stream2(Stream2),
  //   .Stream1(Stream1),
  //   .Stream0(Stream0),
  //   .CData4(CData4),
  //   .CData3(CData3),
  //   .CData2(CData2),
  //   .CData1(CData1),
  //   .CData0(CData0),
  //   .Ack4(Ack4),
  //   .Ack3(Ack3),
  //   .Ack2(Ack2),
  //   .Ack1(Ack1),
  //   .Ack0(Ack0),
  //   .CData_Out4(CData_Out4_handshake),
  //   .CData_Out3(CData_Out3_handshake),
  //   .CData_Out2(CData_Out2_handshake),
  //   .CData_Out1(CData_Out1_handshake),
  //   .CData_Out0(CData_Out0_handshake),
  //   // .Clock0(Clock0),
  //   // .Clock1(Clock1),
  //   // .Clock2(Clock2),
  //   // .Clock3(Clock3),
  //   // .Clock4(Clock4),
  //   .Tail_Out4(Tail_Out4),
  //   .Tail_Out3(Tail_Out3),
  //   .Tail_Out2(Tail_Out2),
  //   .Tail_Out1(Tail_Out1),
  //   .Tail_Out0(Tail_Out0),
  //   .Stream_Out4(Stream_Out4),
  //   .Stream_Out3(Stream_Out3),
  //   .Stream_Out2(Stream_Out2),
  //   .Stream_Out1(Stream_Out1),
  //   .Stream_Out0(Stream_Out0),
  //   .Ack_Out4(Ack_Out4_handshake),
  //   .Ack_Out3(Ack_Out3_handshake),
  //   .Ack_Out2(Ack_Out2_handshake),
  //   .Ack_Out1(Ack_Out1_handshake),
  //   .Ack_Out0(Ack_Out0_handshake),


  //   .RD_in4(RD_in4_handshake),
  //   .RD_in3(RD_in3_handshake),
  //   .RD_in2(RD_in2_handshake),
  //   .RD_in1(RD_in1_handshake),
  //   .RD_in0(RD_in0_handshake),
  //   .RD_out4(RD_out4_handshake),
  //   .RD_out3(RD_out3_handshake),
  //   .RD_out2(RD_out2_handshake),
  //   .RD_out1(RD_out1_handshake),
  //   .RD_out0(RD_out0_handshake),
  //   // .Clock_Out0(Clock_Out0_handshake),
  //   // .Clock_Out1(Clock_Out1_handshake),
  //   // .Clock_Out2(Clock_Out2_handshake),
  //   // .Clock_Out3(Clock_Out3_handshake),
  //   // .Clock_Out4(Clock_Out4_handshake),
  //   .DirectionIn_in4(Circuit_DirectionIn_in4),
  //   .DirectionIn_in3(Circuit_DirectionIn_in3),
  //   .DirectionIn_in2(Circuit_DirectionIn_in2),
  //   .DirectionIn_in1(Circuit_DirectionIn_in1),
  //   .DirectionIn_in0(Circuit_DirectionIn_in0),
  //   .DirectionIn_out4(Circuit_DirectionIn_out4),
  //   .DirectionIn_out3(Circuit_DirectionIn_out3),
  //   .DirectionIn_out2(Circuit_DirectionIn_out2),
  //   .DirectionIn_out1(Circuit_DirectionIn_out1),
  //   .DirectionIn_out0(Circuit_DirectionIn_out0)
  //   );

  // 2024/07/26 Original
  FIFO_bridge_inport #(5, `FIFO_DEPTH) fifo_inport4(
    .wclk(clk), 
    .rclk(RD_in4),
    .rst_n(rst_n),
    // .winc((WR_in4)&&(Packet_DirectionIn_in4!=4'b1111)),
    .winc(WR_in4),
    .wdata(Packet_DirectionIn_in4),
    .rdata(Circuit_DirectionIn_in4),
    .wfull(full_inport4),
    .rempty()
    );
  
  FIFO_bridge_inport #(5, `FIFO_DEPTH) fifo_inport3(
    .wclk(clk), 
    .rclk(RD_in3),
    .rst_n(rst_n),
    // .winc((WR_in3)&&(Packet_DirectionIn_in3!=4'b1111)),
    .winc(WR_in3),
    .wdata(Packet_DirectionIn_in3),
    .rdata(Circuit_DirectionIn_in3),
    .wfull(full_inport3),
    .rempty()
    );

  FIFO_bridge_inport #(5, `FIFO_DEPTH) fifo_inport2(
    .wclk(clk), 
    .rclk(RD_in2),
    .rst_n(rst_n),
    // .winc((WR_in2)&&(Packet_DirectionIn_in2!=4'b1111)),
    .winc(WR_in2),
    .wdata(Packet_DirectionIn_in2),
    .rdata(Circuit_DirectionIn_in2),
    .wfull(full_inport2),
    .rempty()
    );

  FIFO_bridge_inport #(5, `FIFO_DEPTH) fifo_inport1(
    .wclk(clk), 
    .rclk(RD_in1),
    .rst_n(rst_n),
    // .winc((WR_in1)&&(Packet_DirectionIn_in1!=4'b1111)),
    .winc(WR_in1),
    .wdata(Packet_DirectionIn_in1),
    .rdata(Circuit_DirectionIn_in1),
    .wfull(full_inport1),
    .rempty()
    );

  FIFO_bridge_inport #(5, `FIFO_DEPTH) fifo_inport0(
    .wclk(clk), 
    .rclk(RD_in0),
    .rst_n(rst_n),
    // .winc((WR_in0)&&(Packet_DirectionIn_in0!=4'b1111)),
    .winc(WR_in0),
    .wdata(Packet_DirectionIn_in0),
    .rdata(Circuit_DirectionIn_in0),
    .wfull(full_inport0),
    .rempty()
    );

  FIFO_bridge_outport #(5, `FIFO_DEPTH) fifo_outport4(
    .wclk(clk), 
    .rclk(RD_out4),
    .rst_n(rst_n),
    .winc(WR_out4),
    .wdata(Packet_DirectionIn_out4),
    .rdata(Circuit_DirectionIn_out4),
    .wfull(full_outport4),
    .rempty(),
    .rclk_sync(rclk_sync_outfifo_4),
    .rdata_sync(rdata_sync_outfifo_4)
    );

  FIFO_bridge_outport #(5, `FIFO_DEPTH) fifo_outport3(
    .wclk(clk), 
    .rclk(RD_out3),
    .rst_n(rst_n),
    .winc(WR_out3),
    .wdata(Packet_DirectionIn_out3),
    .rdata(Circuit_DirectionIn_out3),
    .wfull(full_outport3),
    .rempty(),
    .rclk_sync(rclk_sync_outfifo_3),
    .rdata_sync(rdata_sync_outfifo_3)
    );

  FIFO_bridge_outport #(5, `FIFO_DEPTH) fifo_outport2(
    .wclk(clk), 
    .rclk(RD_out2),
    .rst_n(rst_n),
    .winc(WR_out2),
    .wdata(Packet_DirectionIn_out2),
    .rdata(Circuit_DirectionIn_out2),
    .wfull(full_outport2),
    .rempty(),
    .rclk_sync(rclk_sync_outfifo_2),
    .rdata_sync(rdata_sync_outfifo_2)
    );

  FIFO_bridge_outport #(5, `FIFO_DEPTH) fifo_outport1(
    .wclk(clk), 
    .rclk(RD_out1),
    .rst_n(rst_n),
    .winc(WR_out1),
    .wdata(Packet_DirectionIn_out1),
    .rdata(Circuit_DirectionIn_out1),
    .wfull(full_outport1),
    .rempty(),
    .rclk_sync(rclk_sync_outfifo_1),
    .rdata_sync(rdata_sync_outfifo_1)
    );

  FIFO_bridge_outport #(5, `FIFO_DEPTH) fifo_outport0(
    .wclk(clk), 
    .rclk(RD_out0),
    .rst_n(rst_n),
    .winc(WR_out0),
    .wdata(Packet_DirectionIn_out0),
    .rdata(Circuit_DirectionIn_out0),
    .wfull(full_outport0),
    .rempty(),
    .rclk_sync(rclk_sync_outfifo_0),
    .rdata_sync(rdata_sync_outfifo_0)
    );
  
  // 20240726 New


//   CircuitSwitching_test #(`CDATASIZE) CircuitSwitching(
//     .rst_n(rst_n),
//     .Ack0(Ack0), 
//     .Ack1(Ack1), 
//     .Ack2(Ack2), 
//     .Ack3(Ack3), 
//     .Ack4(Ack4), 
//     .CData0(CData0),
//     .CData1(CData1),
//     .CData2(CData2),
//     .CData3(CData3),
//     .CData4(CData4),
//     .Strobe0(Strobe0),
//     .Strobe1(Strobe1),
//     .Strobe2(Strobe2),
//     .Strobe3(Strobe3),
//     .Strobe4(Strobe4),
//     .State0(State0),
//     .State1(State1),
//     .State2(State2),
//     .State3(State3),
//     .State4(State4),
//     .Clock0(Clock0),
//     .Clock1(Clock1),
//     .Clock2(Clock2),
//     .Clock3(Clock3),
//     .Clock4(Clock4),
//     .Ack_Out0(Ack_Out0_dut),
//     .Ack_Out1(Ack_Out1_dut),
//     .Ack_Out2(Ack_Out2_dut),
//     .Ack_Out3(Ack_Out3_dut),
//     .Ack_Out4(Ack_Out4_dut),
//     .CData_Out0(CData_Out0_dut),
//     .CData_Out1(CData_Out1_dut),
//     .CData_Out2(CData_Out2_dut),
//     .CData_Out3(CData_Out3_dut),
//     .CData_Out4(CData_Out4_dut),
//     .Strobe_Out0(Strobe_Out0), 
//     .Strobe_Out1(Strobe_Out1), 
//     .Strobe_Out2(Strobe_Out2), 
//     .Strobe_Out3(Strobe_Out3), 
//     .Strobe_Out4(Strobe_Out4), 
//     .State_Out0(State_Out0), 
//     .State_Out1(State_Out1), 
//     .State_Out2(State_Out2), 
//     .State_Out3(State_Out3), 
//     .State_Out4(State_Out4), 
//     .Clock_Out0(Clock_Out0_dut),
//     .Clock_Out1(Clock_Out1_dut),
//     .Clock_Out2(Clock_Out2_dut),
//     .Clock_Out3(Clock_Out3_dut),
//     .Clock_Out4(Clock_Out4_dut),
//     .Feedback0(Feedback0),
//     .Feedback1(Feedback1),
//     .Feedback2(Feedback2),
//     .Feedback3(Feedback3),
//     .Feedback4(Feedback4),
//     .Feedback_Out0(Feedback_Out0),
//     .Feedback_Out1(Feedback_Out1),
//     .Feedback_Out2(Feedback_Out2),
//     .Feedback_Out3(Feedback_Out3),
//     .Feedback_Out4(Feedback_Out4),
    
//     .RD_in0(RD_in0_dut),
//     .RD_in1(RD_in1_dut),
//     .RD_in2(RD_in2_dut),
//     .RD_in3(RD_in3_dut),
//     .RD_in4(RD_in4_dut),
//     .RD_out0(RD_out0_dut),
//     .RD_out1(RD_out1_dut),
//     .RD_out2(RD_out2_dut),
//     .RD_out3(RD_out3_dut),
//     .RD_out4(RD_out4_dut),
//     .DirectionIn_in0(Circuit_DirectionIn_in0), 
//     .DirectionIn_in1(Circuit_DirectionIn_in1), 
//     .DirectionIn_in2(Circuit_DirectionIn_in2), 
//     .DirectionIn_in3(Circuit_DirectionIn_in3), 
//     .DirectionIn_in4(Circuit_DirectionIn_in4), 
//     .DirectionIn_out0(Circuit_DirectionIn_out0),
//     .DirectionIn_out1(Circuit_DirectionIn_out1),
//     .DirectionIn_out2(Circuit_DirectionIn_out2),
//     .DirectionIn_out3(Circuit_DirectionIn_out3),
//     .DirectionIn_out4(Circuit_DirectionIn_out4)
//     );




//   FIFO_bridge_inport_test #(5, `FIFO_DEPTH) fifo_inport4(
//     .wclk(clk), 
//     .rclk(Clock4),
//     .rinc(RD_in4),
//     .rst_n(rst_n),
//     .winc(WR_in4),
//     .wdata(Packet_DirectionIn_in4),
//     .rdata(Circuit_DirectionIn_in4),
//     .wfull(full_inport4),
//     .rempty()
//     );
  
//   FIFO_bridge_inport_test #(5, `FIFO_DEPTH) fifo_inport3(
//     .wclk(clk), 
//     .rclk(Clock3),
//     .rinc(RD_in3),
//     .rst_n(rst_n),
//     .winc(WR_in3),
//     .wdata(Packet_DirectionIn_in3),
//     .rdata(Circuit_DirectionIn_in3),
//     .wfull(full_inport3),
//     .rempty()
//     );

//   FIFO_bridge_inport_test #(5, `FIFO_DEPTH) fifo_inport2(
//     .wclk(clk), 
//     .rclk(Clock2),
//     .rinc(RD_in2),
//     .rst_n(rst_n),
//     .winc(WR_in2),
//     .wdata(Packet_DirectionIn_in2),
//     .rdata(Circuit_DirectionIn_in2),
//     .wfull(full_inport2),
//     .rempty()
//     );

//   FIFO_bridge_inport_test #(5, `FIFO_DEPTH) fifo_inport1(
//     .wclk(clk), 
//     .rclk(Clock1),
//     .rinc(RD_in1),
//     .rst_n(rst_n),
//     .winc(WR_in1),
//     .wdata(Packet_DirectionIn_in1),
//     .rdata(Circuit_DirectionIn_in1),
//     .wfull(full_inport1),
//     .rempty()
//     );

//   FIFO_bridge_inport_test #(5, `FIFO_DEPTH) fifo_inport0(
//     .wclk(clk), 
//     .rclk(Clock0),
//     .rinc(RD_in0),
//     .rst_n(rst_n),
//     .winc(WR_in0),
//     .wdata(Packet_DirectionIn_in0),
//     .rdata(Circuit_DirectionIn_in0),
//     .wfull(full_inport0),
//     .rempty()
//     );

//   FIFO_bridge_outport_test #(5, `FIFO_DEPTH) fifo_outport4(
//     .wclk(clk), 
//     .rclk(Clock_Out4),
//     .rinc(RD_out4),
//     .rst_n(rst_n),
//     .winc(WR_out4),
//     .wdata(Packet_DirectionIn_out4),
//     .rdata(Circuit_DirectionIn_out4),
//     .wfull(full_outport4),
//     .rempty(),
//     .rclk_sync(rclk_sync_outfifo_4),
//     .rdata_sync(rdata_sync_outfifo_4)
//     );

//   FIFO_bridge_outport_test #(5, `FIFO_DEPTH) fifo_outport3(
//     .wclk(clk), 
//     .rclk(Clock_Out3),
//     .rinc(RD_out3),
//     .rst_n(rst_n),
//     .winc(WR_out3),
//     .wdata(Packet_DirectionIn_out3),
//     .rdata(Circuit_DirectionIn_out3),
//     .wfull(full_outport3),
//     .rempty(),
//     .rclk_sync(rclk_sync_outfifo_3),
//     .rdata_sync(rdata_sync_outfifo_3)
//     );

//   FIFO_bridge_outport_test #(5, `FIFO_DEPTH) fifo_outport2(
//     .wclk(clk), 
//     .rclk(Clock_Out2),
//     .rinc(RD_out2),
//     .rst_n(rst_n),
//     .winc(WR_out2),
//     .wdata(Packet_DirectionIn_out2),
//     .rdata(Circuit_DirectionIn_out2),
//     .wfull(full_outport2),
//     .rempty(),
//     .rclk_sync(rclk_sync_outfifo_2),
//     .rdata_sync(rdata_sync_outfifo_2)
//     );

//   FIFO_bridge_outport_test #(5, `FIFO_DEPTH) fifo_outport1(
//     .wclk(clk), 
//     .rclk(Clock_Out1),
//     .rinc(RD_out1),
//     .rst_n(rst_n),
//     .winc(WR_out1),
//     .wdata(Packet_DirectionIn_out1),
//     .rdata(Circuit_DirectionIn_out1),
//     .wfull(full_outport1),
//     .rempty(),
//     .rclk_sync(rclk_sync_outfifo_1),
//     .rdata_sync(rdata_sync_outfifo_1)
//     );

//   FIFO_bridge_outport_test #(5, `FIFO_DEPTH) fifo_outport0(
//     .wclk(clk), 
//     .rclk(Clock_Out0),
//     .rinc(RD_out0),
//     .rst_n(rst_n),
//     .winc(WR_out0),
//     .wdata(Packet_DirectionIn_out0),
//     .rdata(Circuit_DirectionIn_out0),
//     .wfull(full_outport0),
//     .rempty(),
//     .rclk_sync(rclk_sync_outfifo_0),
//     .rdata_sync(rdata_sync_outfifo_0)
//     );
    
// //   reg [4:0] rdata_sync_outfifo_0_val, rdata_sync_outfifo_1_val, rdata_sync_outfifo_2_val, rdata_sync_outfifo_3_val, rdata_sync_outfifo_4_val;
// //   always @(posedge clk or negedge rst_n) begin
// //       if(!rst_n)
// //         {rdata_sync_outfifo_0_val, rdata_sync_outfifo_1_val, rdata_sync_outfifo_2_val, rdata_sync_outfifo_3_val, rdata_sync_outfifo_4_val} = 0;
// //       else 
// //         {rdata_sync_outfifo_0_val, rdata_sync_outfifo_1_val, rdata_sync_outfifo_2_val, rdata_sync_outfifo_3_val, rdata_sync_outfifo_4_val} = {Circuit_DirectionIn_out0, Circuit_DirectionIn_out1, Circuit_DirectionIn_out2, Circuit_DirectionIn_out3, Circuit_DirectionIn_out4};
// //   end

// //   assign {rdata_sync_outfifo_0, rdata_sync_outfifo_1, rdata_sync_outfifo_2, rdata_sync_outfifo_3, rdata_sync_outfifo_4} = {rdata_sync_outfifo_0_val, rdata_sync_outfifo_1_val, rdata_sync_outfifo_2_val, rdata_sync_outfifo_3_val, rdata_sync_outfifo_4_val} ;


endmodule
