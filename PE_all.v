`include "./noc_define.v"

module PE_all (
        input   wire [3:0]                      ID,
        input   wire                            clk,
        input   wire                            clk_global, // All Router clk
        input   wire                            rst_n,
        // input   wire                            rst_n1,
        // input   wire                            rst_n2,
        // input   wire                            rst_n3,
        // input   wire                            pe_verify,

        input   wire                            enable_wire,
        input   wire [4:0]                      mode_wire,
        input   wire [10:0]                     interval_wire,
        input   wire [3:0]                      hotpot_target,
        input   wire [3:0]                      DATA_WIDTH_DBG,
        input   wire [1:0]                      test_mode,


        output  wire  [`PDATASIZE-1:0]           packet_data_p2r,
        output  wire                             packet_valid_p2r,
        // output  reg                             packet_side_valid,  //side transfer
        input   wire [`PDATASIZE-1:0]           packet_data_r2p,
        input   wire                            packet_valid_r2p,
        output  wire                            L_full,

        input   wire                            packet_fifo_wfull,

        input   wire                            Ack_r2p,
        output  wire                             Ack_p2r,
        input   wire [`CDATASIZE-1:0]           CData_r2p,
        output  wire [`CDATASIZE-1:0]            CData_p2r,
        input   wire                            Strobe_r2p,
        output  wire                            Strobe_p2r,
        input   wire                            State_r2p,
        output  wire                            State_p2r,
        input   wire                            Clock_r2p,
        output  reg                            Clock_p2r,

        output  wire                            Feedback_p2r,
        input   wire                            Feedback_r2p,

        input   wire [79:0]                     dvfs_config,    // frequency ratio
        input   wire [`stream_cnt_width-1:0]    Stream_Length,

        output  wire                             receive_finish_flag,

        input   wire [`TIME_WIDTH-1:0]          time_stamp_global,

        // handshake
        // output  wire                             Tail_p2r,
        // output  wire                            Stream_p2r,
        // input   wire                            Tail_r2p,
        // input   wire                            Stream_r2p,


        // for test
        output  wire  [`TIME_WIDTH-1:0]          cdata_stream_latency,
        output  wire  [10:0]                     receive_patch_num,
        output wire  [10:0]                     receive_packet_patch_num,
        output wire                             receive_packet_finish_flag,

        output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit,
        output  wire [`MIN_WIDTH-1:0]    latency_min_circuit,
        output  wire [`MAX_WIDTH-1:0]    latency_max_circuit,

        output  wire                     error_circuit,
        output  wire                     error_packet,

        //Meta Detection
        output wire state_meta_error,
        output wire strobe1_meta_error,
        output wire strobe2_meta_error,
        output wire strobe3_meta_error,

        // 20241205 Add dbg signals
        output wire  [10:0]                      send_packet_patch_num,
        output wire  [10:0]                      send_patch_num,
        output wire  [10:0]                      req_p2r_cnt,
        output wire  [10:0]                      req_r2p_cnt,
        output wire  [10:0]                      ack_p2r_cnt,
        output wire  [10:0]                      ack_r2p_cnt
    );

   
    reg enable_wire_test;
    reg [4:0] mode_wire_test;
    reg [3:0] hotpot_target_test;
    reg [3:0] DATA_WIDTH_DBG_test;
    reg [1:0] test_mode_test;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
          enable_wire_test <= 1'b0;
          mode_wire_test <= 5'b0;
          hotpot_target_test <= 4'b0;
          DATA_WIDTH_DBG_test <= 4'b0;
          test_mode_test <= 2'b0;
        end
        else begin
          enable_wire_test <= enable_wire;
          mode_wire_test <= mode_wire;
          hotpot_target_test <= hotpot_target;
          DATA_WIDTH_DBG_test <= DATA_WIDTH_DBG;
          test_mode_test <= test_mode;
        end
    end

    // assign   scan_in_test = {enable_wire_test, mode_wire_test, hotpot_target_test, DATA_WIDTH_DBG_test, test_mode_test};


    // assign enable_wire_test = enable_wire;
    // assign mode_wire_test = mode_wire;
    // assign hotpot_target_test = hotpot_target;
    // assign DATA_WIDTH_DBG_test = DATA_WIDTH_DBG;
    // assign test_mode_test = test_mode;

    // assign   signal_test = pe_verify ? {packet_data_p2r, packet_valid_p2r, packet_fifo_wfull, CData_p2r, Ack_p2r, Strobe_p2r, State_p2r, Clock_p2r, Feedback_p2r, Tail_p2r, Stream_p2r} 
    //                     : {packet_data_r2p, packet_valid_r2p, packet_fifo_wfull, CData_r2p, Ack_r2p, Strobe_r2p, State_r2p, Clock_r2p, Feedback_r2p, Tail_r2p, Stream_r2p} ;
    // assign   signal_test = pe_verify ? {packet_data_p2r, packet_valid_p2r, packet_fifo_wfull, CData_p2r, Ack_p2r, Strobe_p2r, State_p2r, 1'b0, Feedback_p2r, Tail_p2r, Stream_p2r} 
    //                     : {packet_data_r2p, packet_valid_r2p, packet_fifo_wfull, CData_r2p, Ack_r2p, Strobe_r2p, State_r2p,  1'b0, Feedback_r2p, Tail_r2p, Stream_r2p} ;
    // always @(*) begin
    //    signal_test <= pe_verify ? {packet_data_p2r, packet_valid_p2r, packet_fifo_wfull, CData_p2r, Ack_p2r, Strobe_p2r, State_p2r, 1'b0, Feedback_p2r, Tail_p2r, Stream_p2r} 
    //                     : {packet_data_r2p, packet_valid_r2p, packet_fifo_wfull, CData_r2p, Ack_r2p, Strobe_r2p, State_r2p,  1'b0, Feedback_r2p, Tail_r2p, Stream_r2p} ;
    // end



    // assign packet_data_test = pe_verify ? packet_data_p2r : packet_data_r2p ;
    // assign packet_valid_test = pe_verify ? packet_valid_p2r : packet_valid_r2p ;
    // assign packet_fifo_wfull_test = packet_fifo_wfull_test;

    // assign CData_test = pe_verify ? CData_p2r : CData_r2p ;

    // assign Ack_test = pe_verify ? Ack_p2r : Ack_r2p ;
    // assign Strobe_test = pe_verify ? Strobe_p2r : Strobe_r2p ;
    // assign State_test = pe_verify ? State_p2r : State_r2p ;
    // assign Clock_test = pe_verify ? Clock_p2r : Clock_r2p ;
    // assign Feedback_test = pe_verify ? Feedback_p2r : Feedback_r2p ;
    // assign Tail_test = pe_verify ? Tail_p2r : Tail_r2p ;
    // assign Stream_test = pe_verify ? Stream_p2r : Stream_r2p ;




    // wire [`PDATASIZE-1:0]           packet_data_p2r_dut;
    // wire [`PDATASIZE-1:0]           packet_data_p2r_handshake;
    // wire [`PDATASIZE-1:0]           packet_data_p2r_afifo;

    // wire packet_valid_p2r_dut;
    // wire packet_valid_p2r_handshake;
    // wire packet_valid_p2r_afifo;

    // wire Ack_p2r_dut;
    // wire Ack_p2r_handshake;
    // wire Ack_p2r_afifo;

    // wire [`CDATASIZE-1:0]            CData_p2r_dut;
    // wire [`CDATASIZE-1:0]            CData_p2r_handshake;
    // wire [`CDATASIZE-1:0]            CData_p2r_afifo;

    // wire receive_finish_flag_dut;
    // wire receive_finish_flag_handshake;
    // wire receive_finish_flag_afifo;

    // wire  [`TIME_WIDTH-1:0]  cdata_stream_latency_dut;
    // wire  [10:0]                receive_patch_num_dut;
    // wire [`SUM_WIDTH-1:0]    latency_sum_circuit_dut;
    // wire [`MIN_WIDTH-1:0]    latency_min_circuit_dut;
    // wire [`MAX_WIDTH-1:0]    latency_max_circuit_dut;

    // wire  [`TIME_WIDTH-1:0]  cdata_stream_latency_handshake;
    // wire  [10:0]                receive_patch_num_handshake;
    // wire [`SUM_WIDTH-1:0]    latency_sum_circuit_handshake;
    // wire [`MIN_WIDTH-1:0]    latency_min_circuit_handshake;
    // wire [`MAX_WIDTH-1:0]    latency_max_circuit_handshake;

    // wire  [`TIME_WIDTH-1:0]  cdata_stream_latency_afifo;
    // wire  [10:0]                receive_patch_num_afifo;
    // wire [`SUM_WIDTH-1:0]    latency_sum_circuit_afifo;
    // wire [`MIN_WIDTH-1:0]    latency_min_circuit_afifo;
    // wire [`MAX_WIDTH-1:0]    latency_max_circuit_afifo;

    // always @(*) begin
    //   case (test_mode_test)
    //     2'b00 : {packet_data_p2r, packet_valid_p2r, Ack_p2r, CData_p2r, receive_finish_flag} = {packet_data_p2r_dut, packet_valid_p2r_dut, Ack_p2r_dut, CData_p2r_dut, receive_finish_flag_dut};
    //     2'b01 : {packet_data_p2r, packet_valid_p2r, Ack_p2r, CData_p2r, receive_finish_flag} = {packet_data_p2r_handshake, packet_valid_p2r_handshake, Ack_p2r_handshake, CData_p2r_handshake, receive_finish_flag_handshake};
    //     2'b10,2'b11 : {packet_data_p2r, packet_valid_p2r, Ack_p2r, CData_p2r, receive_finish_flag} = {packet_data_p2r_afifo, packet_valid_p2r_afifo, Ack_p2r_afifo, CData_p2r_afifo, receive_finish_flag_afifo};
    //     default: {packet_data_p2r, packet_valid_p2r, Ack_p2r, CData_p2r, receive_finish_flag} = {packet_data_p2r_dut, packet_valid_p2r_dut, Ack_p2r_dut, CData_p2r_dut, receive_finish_flag_dut};
    //   endcase
    // end

    // always @(*) begin
    //   case (test_mode_test)
    //     2'b00 : {cdata_stream_latency, receive_patch_num, latency_sum_circuit, latency_min_circuit, latency_max_circuit} = {cdata_stream_latency_dut, receive_patch_num_dut, latency_sum_circuit_dut, latency_min_circuit_dut, latency_max_circuit_dut};
    //     2'b01 : {cdata_stream_latency, receive_patch_num, latency_sum_circuit, latency_min_circuit, latency_max_circuit} = {cdata_stream_latency_handshake, receive_patch_num_handshake, latency_sum_circuit_handshake, latency_min_circuit_handshake, latency_max_circuit_handshake};
    //     2'b10,2'b11 : {cdata_stream_latency, receive_patch_num, latency_sum_circuit, latency_min_circuit, latency_max_circuit} = {cdata_stream_latency_afifo, receive_patch_num_afifo, latency_sum_circuit_afifo, latency_min_circuit_afifo, latency_max_circuit_afifo};
    //     default: {cdata_stream_latency, receive_patch_num, latency_sum_circuit, latency_min_circuit, latency_max_circuit} = {cdata_stream_latency_dut, receive_patch_num_dut, latency_sum_circuit_dut, latency_min_circuit_dut, latency_max_circuit_dut};
    //   endcase
    // end

    // wire Tail_p2r_handshake;
    // wire Tail_p2r_afifo;
    // always @(*) begin
    //   case (test_mode_test)
    //     2'b01 : Tail_p2r = Tail_p2r_handshake;
    //     2'b10,2'b11 : Tail_p2r = Tail_p2r_afifo;
    //     default: Tail_p2r = Tail_p2r_afifo;
    //   endcase
    // end

    // wire Stream_p2r_handshake;
    // wire Stream_p2r_afifo;
    // always @(*) begin
    //   case (test_mode_test)
    //     2'b01 : Stream_p2r = Stream_p2r_handshake;
    //     2'b10,2'b11 : Stream_p2r = Stream_p2r_afifo;
    //     default: Stream_p2r = Stream_p2r_afifo;
    //   endcase
    // end

    wire Clock_p2r_dut;
    wire Clock_p2r_afifo;
    // always @(*) begin
    //   case (test_mode_test)
    //     2'b00 : Clock_p2r = Clock_p2r_dut;
    //     2'b10,2'b11 : Clock_p2r = Clock_p2r_afifo;
    //     default: Clock_p2r = Clock_p2r_afifo;
    //   endcase
    // end

    // 20240731 Used for Source Sync. Simplification
  //   reg Tail_r2p_sync1, Tail_r2p_sync2;
  //   reg Stream_r2p_sync1, Stream_r2p_sync2;
  //   reg Ack_r2p_sync1, Ack_r2p_sync2;
  //   reg [`CDATASIZE-1:0] CData_r2p_sync1, CData_r2p_sync2;
  //   reg Strobe_r2p_sync1, Strobe_r2p_sync2;
  //   reg State_r2p_sync1, State_r2p_sync2;
  //   reg Feedback_r2p_sync1, Feedback_r2p_sync2;



  //   always @(posedge Clock_r2p or negedge rst_n) begin
  //     if(!rst_n)
  //       {Tail_r2p_sync1, Stream_r2p_sync1, CData_r2p_sync1, Ack_r2p_sync1, Feedback_r2p_sync1 } <= 0;
  //     else
  //       {Tail_r2p_sync1, Stream_r2p_sync1, CData_r2p_sync1, Ack_r2p_sync1, Feedback_r2p_sync1 } <= {Tail_r2p, Stream_r2p, CData_r2p, Ack_r2p, Feedback_r2p } ;
  //   end


  //   always @(posedge Clock_r2p or negedge rst_n) begin
  //     if(!rst_n)
  //       {Tail_r2p_sync2, Stream_r2p_sync2, CData_r2p_sync2, Ack_r2p_sync2, Feedback_r2p_sync2 } <= 0;
  //     else
  //       {Tail_r2p_sync2, Stream_r2p_sync2, CData_r2p_sync2, Ack_r2p_sync2, Feedback_r2p_sync2 } <={Tail_r2p_sync1, Stream_r2p_sync1, CData_r2p_sync1, Ack_r2p_sync1, Feedback_r2p_sync1 };
  //   end

  //  always @(negedge Clock_r2p or negedge rst_n) begin
  //     if(!rst_n)
  //       {State_r2p_sync1, Strobe_r2p_sync1 } <= 0;
  //     else
  //       {State_r2p_sync1, Strobe_r2p_sync1 } <= {State_r2p, Strobe_r2p} ;
  //   end


  //   always @(negedge Clock_r2p or negedge rst_n) begin
  //     if(!rst_n)
  //       {State_r2p_sync2,  Strobe_r2p_sync2 } <= 0;
  //     else
  //       {State_r2p_sync2,  Strobe_r2p_sync2 } <={ State_r2p_sync1, Strobe_r2p_sync1 };
  //   end

    // reg [`TIME_WIDTH-1:0]          time_stamp_global_sync1, time_stamp_global_sync2;


    // always @(*) begin
    //   {Tail_r2p_sync2, Stream_r2p_sync2, Ack_r2p_sync2, CData_r2p_sync2, Strobe_r2p_sync2, State_r2p_sync2, Feedback_r2p_sync2 } ={Tail_r2p, Stream_r2p, Ack_r2p, CData_r2p, Strobe_r2p, State_r2p, Feedback_r2p };
    // end

    //
    always @(*) begin
        Clock_p2r = 0;
    end


    // wire packet_side_valid_dut;
    // always @(*) begin
    //     packet_side_valid <= packet_side_valid_dut;
    // end

    wire [`PDATASIZE-1:0]           packet_data_r2p_sync;
    wire                            packet_valid_r2p_sync;

    fifo_mpam_top #(
    .DEPTH(8),
    .DATASIZE(`PDATASIZE)
      ) fifo_packet_PE (
    .wdata(packet_data_r2p),
    .wfull(L_full),
    .winc(packet_valid_r2p),
    .rinc(1'b1),
    .rempty_n(packet_valid_r2p_sync),
    .rdata(packet_data_r2p_sync),
    .wclk(clk_global),
    .rclk(clk),
    .rst_n(rst_n)
    );

    wire Ack_p2r_pe;
    wire Ack_r2p_pe;
    Ack_transfer_e2l inst_ack_transfer_e2l(
      .Ack_in(Ack_p2r_pe),
      .Ack_out(Ack_p2r),
      .clk(clk),
      .rst_n(rst_n)
    );
    Ack_transfer_l2e inst_ack_transfer_l2e(
      .Ack_in(Ack_r2p),
      .Ack_out(Ack_r2p_pe),
      .clk(clk),
      .rst_n(rst_n)
    );

    PE_single PE_dut(
        .ID(ID),
        .clk(clk),
        //  .clk_global(clk_global),
        .rst_n(rst_n),
        .enable_wire(enable_wire_test),
        .mode_wire(mode_wire_test),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target_test),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG_test),

        .packet_side_en(test_mode[1]),

        .packet_data_p2r(packet_data_p2r),
        .packet_valid_p2r(packet_valid_p2r),

        // .packet_side_valid(packet_side_valid), //side transfer

        .packet_data_r2p(packet_data_r2p_sync),
        .packet_valid_r2p(packet_valid_r2p_sync),
        .packet_fifo_wfull(packet_fifo_wfull),

        .Ack_p2r(Ack_p2r_pe),
        .CData_p2r(CData_p2r),
        .Strobe_p2r(Strobe_p2r),
        .State_p2r(State_p2r),
        .Clock_p2r(Clock_p2r_dut),
        .Ack_r2p(Ack_r2p_pe),
        .CData_r2p(CData_r2p),
        .Strobe_r2p(Strobe_r2p),
        .State_r2p(State_r2p),
        .Clock_r2p(Clock_r2p), 

        .Feedback_p2r(Feedback_p2r),
        .Feedback_r2p(Feedback_r2p),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag),
        .time_stamp_global(time_stamp_global[`TIME_WIDTH-1:0]),
        // .rinc(rinc0)

        .cdata_stream_latency(cdata_stream_latency),
        .receive_patch_num(receive_patch_num),
        .receive_packet_patch_num(receive_packet_patch_num),
        .receive_packet_finish_flag(receive_packet_finish_flag),

        .error_circuit(error_circuit),
        .error_packet(error_packet),
        
        .latency_sum_circuit(latency_sum_circuit),
        .latency_min_circuit(latency_min_circuit),
        .latency_max_circuit(latency_max_circuit),

        .win_sel(),
        .var_clk_sel_origin(),
        .var_clk_sel_leading(),
        .medac_mode(1'b1), // 1 for medac on; 0 for medac off

        .state_meta_error(state_meta_error),
        .strobe1_meta_error(strobe1_meta_error),
        .strobe2_meta_error(strobe2_meta_error),
        .strobe3_meta_error(strobe3_meta_error),

        .send_packet_patch_num(send_packet_patch_num),
        .send_patch_num(send_patch_num),
        .req_p2r_cnt(req_p2r_cnt),
        .req_r2p_cnt(req_r2p_cnt),
        .ack_p2r_cnt(ack_p2r_cnt),
        .ack_r2p_cnt(ack_r2p_cnt)
    );

    // PE_handshake PE_handshake(
    //     .ID(ID),
    //     .clk(clk),
    //     .clk_global(clk_global),
    //     .rst_n(rst_n2),
    //     .enable_wire(enable_wire_test),
    //     .mode_wire(mode_wire_test),
    //     .hotpot_target(hotpot_target_test),
    //     .interval_wire(interval_wire),
    //     .Stream_Length(Stream_Length),
    //     .DATA_WIDTH_DBG(DATA_WIDTH_DBG_test),

    //     .packet_data_p2r(packet_data_p2r_handshake),
    //     .packet_valid_p2r(packet_valid_p2r_handshake),
    //     .packet_data_r2p(packet_data_r2p),
    //     .packet_valid_r2p(packet_valid_r2p),
    //     .packet_fifo_wfull(packet_fifo_wfull),

    //     .Tail_p2r(Tail_p2r_handshake),
    //     .Stream_p2r(Stream_p2r_handshake),
    //     .CData_p2r(CData_p2r_handshake),
    //     .Ack_p2r(Ack_p2r_handshake),
    //     .Tail_r2p(Tail_r2p),
    //     .Stream_r2p(Stream_r2p),
    //     .CData_r2p(CData_r2p),
    //     .Ack_r2p(Ack_r2p),

    //     .dvfs_config(dvfs_config),
    //     .receive_finish_flag(receive_finish_flag_handshake),
    //     .time_stamp_global(time_stamp_global[`TIME_WIDTH-1:0]),

    //     .cdata_stream_latency(cdata_stream_latency_handshake),
    //     .receive_patch_num(receive_patch_num_handshake),
    //     .latency_sum_circuit(latency_sum_circuit_handshake),
    //     .latency_min_circuit(latency_min_circuit_handshake),
    //     .latency_max_circuit(latency_max_circuit_handshake)
    // );

    // PE_AFIFO PE_AFIFO(
    //     .ID(ID),
    //     .clk(clk),
    //     .clk_global(clk_global),
    //     .rst_n(rst_n3),
    //     .enable_wire(enable_wire_test),
    //     .mode_wire(mode_wire_test),
    //     .hotpot_target(hotpot_target_test),
    //     .interval_wire(interval_wire),
    //     .Stream_Length(Stream_Length),
    //     .DATA_WIDTH_DBG(DATA_WIDTH_DBG_test),
    //     .test_mode(test_mode),

    //     .packet_data_p2r(packet_data_p2r_afifo),
    //     .packet_valid_p2r(packet_valid_p2r_afifo),
    //     .packet_data_r2p(packet_data_r2p),
    //     .packet_valid_r2p(packet_valid_r2p),
    //     .packet_fifo_wfull(packet_fifo_wfull),

    //     .Tail_p2r(Tail_p2r_afifo),
    //     .Stream_p2r(Stream_p2r_afifo),
    //     .CData_p2r(CData_p2r_afifo),
    //     .Ack_p2r(Ack_p2r_afifo),
    //     .Tail_r2p(Tail_r2p),
    //     .Stream_r2p(Stream_r2p),
    //     .CData_r2p(CData_r2p),
    //     .Ack_r2p(Ack_r2p),

    //     .Clock_p2r(Clock_p2r_afifo),
    //     .Clock_r2p(Clock_r2p),

    //     .dvfs_config(dvfs_config),

    //     .receive_finish_flag(receive_finish_flag_afifo),
    //     .time_stamp_global(time_stamp_global[`TIME_WIDTH-1:0]),
    //     .cdata_stream_latency(cdata_stream_latency_afifo),
    //     .receive_patch_num(receive_patch_num_afifo),
    //     .latency_sum_circuit(latency_sum_circuit_afifo),
    //     .latency_min_circuit(latency_min_circuit_afifo),
    //     .latency_max_circuit(latency_max_circuit_afifo)
    // );

endmodule
