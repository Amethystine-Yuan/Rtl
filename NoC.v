//===================================================================== 
// Description: 
//     Hybrid CS/PS NoC, 4x4 Mesh Structure
//     Source-Synchronous Data Transfer
//
// Designer : Shao lin, Jin zeyuan
// Revision History: 
// 
//
// ====================================================================

`include "./noc_define.v"

module NoC (
    input wire clk_global,
    input wire clk0,
    input wire clk1,
    input wire clk2,
    input wire clk3,
    input wire clk4,
    input wire clk5,
    input wire clk6,
    input wire clk7,
    input wire clk8,
    input wire clk9,
    input wire clk10,
    input wire clk11,
    input wire clk12,
    input wire clk13,
    input wire clk14,
    input wire clk15,
    input wire rst_n, // global
    // input wire rst_n1,
    // input wire rst_n2,
    // input wire rst_n3,
    input wire enable_wire,
    input wire [79:0] dvfs_config,
    input wire [4:0] mode_wire,
    input wire [3:0] hotpot_target,
    input wire [10:0] interval_wire,
    input wire [`stream_cnt_width-1:0] Stream_Length,
    input wire [3:0] DATA_WIDTH_DBG,
    input wire [1:0] test_mode, 
        //test_mode[1]: packet side transfer enable, active high
        //test_mode[0]: global cnt use side finish flag, active_high
        // 2'b00, 2'b11, 2'b10 is allowed
    // input wire [4:0] pe_verify_sel,

    output wire  receive_finish_flag00,
    output wire  receive_finish_flag01,
    output wire  receive_finish_flag02,
    output wire  receive_finish_flag03,
    output wire  receive_finish_flag10,
    output wire  receive_finish_flag11,
    output wire  receive_finish_flag12,
    output wire  receive_finish_flag13,
    output wire  receive_finish_flag20,
    output wire  receive_finish_flag21,
    output wire  receive_finish_flag22,
    output wire  receive_finish_flag23,
    output wire  receive_finish_flag30,
    output wire  receive_finish_flag31,
    output wire  receive_finish_flag32,
    output wire  receive_finish_flag33,

    output wire  receive_packet_finish_flag00,
    output wire  receive_packet_finish_flag01,
    output wire  receive_packet_finish_flag02,
    output wire  receive_packet_finish_flag03,
    output wire  receive_packet_finish_flag10,
    output wire  receive_packet_finish_flag11,
    output wire  receive_packet_finish_flag12,
    output wire  receive_packet_finish_flag13,
    output wire  receive_packet_finish_flag20,
    output wire  receive_packet_finish_flag21,
    output wire  receive_packet_finish_flag22,
    output wire  receive_packet_finish_flag23,
    output wire  receive_packet_finish_flag30,
    output wire  receive_packet_finish_flag31,
    output wire  receive_packet_finish_flag32,
    output wire  receive_packet_finish_flag33,

    output wire [31:0]             time_stamp_global,

    output  wire [15:0]          cdata_stream_latency00,
    output  wire [15:0]          cdata_stream_latency01,
    output  wire [15:0]          cdata_stream_latency02,
    output  wire [15:0]          cdata_stream_latency03,
    output  wire [15:0]          cdata_stream_latency10,
    output  wire [15:0]          cdata_stream_latency11,
    output  wire [15:0]          cdata_stream_latency12,
    output  wire [15:0]          cdata_stream_latency13,
    output  wire [15:0]          cdata_stream_latency20,
    output  wire [15:0]          cdata_stream_latency21,
    output  wire [15:0]          cdata_stream_latency22,
    output  wire [15:0]          cdata_stream_latency23,
    output  wire [15:0]          cdata_stream_latency30,
    output  wire [15:0]          cdata_stream_latency31,
    output  wire [15:0]          cdata_stream_latency32,
    output  wire [15:0]          cdata_stream_latency33,   

    output  wire  [10:0]                     receive_patch_num00,
    output  wire  [10:0]                     receive_patch_num01,
    output  wire  [10:0]                     receive_patch_num02,
    output  wire  [10:0]                     receive_patch_num03,
    output  wire  [10:0]                     receive_patch_num10,
    output  wire  [10:0]                     receive_patch_num11,
    output  wire  [10:0]                     receive_patch_num12,
    output  wire  [10:0]                     receive_patch_num13,
    output  wire  [10:0]                     receive_patch_num20,
    output  wire  [10:0]                     receive_patch_num21,
    output  wire  [10:0]                     receive_patch_num22,
    output  wire  [10:0]                     receive_patch_num23,
    output  wire  [10:0]                     receive_patch_num30,
    output  wire  [10:0]                     receive_patch_num31,
    output  wire  [10:0]                     receive_patch_num32,
    output  wire  [10:0]                     receive_patch_num33,


    output  wire  [10:0]                     receive_packet_patch_num00,
    output  wire  [10:0]                     receive_packet_patch_num01,
    output  wire  [10:0]                     receive_packet_patch_num02,
    output  wire  [10:0]                     receive_packet_patch_num03,
    output  wire  [10:0]                     receive_packet_patch_num10,
    output  wire  [10:0]                     receive_packet_patch_num11,
    output  wire  [10:0]                     receive_packet_patch_num12,
    output  wire  [10:0]                     receive_packet_patch_num13,
    output  wire  [10:0]                     receive_packet_patch_num20,
    output  wire  [10:0]                     receive_packet_patch_num21,
    output  wire  [10:0]                     receive_packet_patch_num22,
    output  wire  [10:0]                     receive_packet_patch_num23,
    output  wire  [10:0]                     receive_packet_patch_num30,
    output  wire  [10:0]                     receive_packet_patch_num31,
    output  wire  [10:0]                     receive_packet_patch_num32,
    output  wire  [10:0]                     receive_packet_patch_num33,


    // 20241205 Add dbg signals
    output wire  [10:0]                      send_packet_patch_num00,
    output wire  [10:0]                      send_packet_patch_num01,
    output wire  [10:0]                      send_packet_patch_num02,
    output wire  [10:0]                      send_packet_patch_num03,
    output wire  [10:0]                      send_packet_patch_num10,
    output wire  [10:0]                      send_packet_patch_num11,
    output wire  [10:0]                      send_packet_patch_num12,
    output wire  [10:0]                      send_packet_patch_num13,
    output wire  [10:0]                      send_packet_patch_num20,
    output wire  [10:0]                      send_packet_patch_num21,
    output wire  [10:0]                      send_packet_patch_num22,
    output wire  [10:0]                      send_packet_patch_num23,
    output wire  [10:0]                      send_packet_patch_num30,
    output wire  [10:0]                      send_packet_patch_num31,
    output wire  [10:0]                      send_packet_patch_num32,
    output wire  [10:0]                      send_packet_patch_num33,

    output wire  [10:0]                      send_patch_num00,
    output wire  [10:0]                      send_patch_num01,
    output wire  [10:0]                      send_patch_num02,
    output wire  [10:0]                      send_patch_num03,
    output wire  [10:0]                      send_patch_num10,
    output wire  [10:0]                      send_patch_num11,
    output wire  [10:0]                      send_patch_num12,
    output wire  [10:0]                      send_patch_num13,
    output wire  [10:0]                      send_patch_num20,
    output wire  [10:0]                      send_patch_num21,
    output wire  [10:0]                      send_patch_num22,
    output wire  [10:0]                      send_patch_num23,
    output wire  [10:0]                      send_patch_num30,
    output wire  [10:0]                      send_patch_num31,
    output wire  [10:0]                      send_patch_num32,
    output wire  [10:0]                      send_patch_num33,

    output wire  [10:0]                      req_p2r_cnt00,
    output wire  [10:0]                      req_p2r_cnt01,
    output wire  [10:0]                      req_p2r_cnt02,
    output wire  [10:0]                      req_p2r_cnt03,
    output wire  [10:0]                      req_p2r_cnt10,
    output wire  [10:0]                      req_p2r_cnt11,
    output wire  [10:0]                      req_p2r_cnt12,
    output wire  [10:0]                      req_p2r_cnt13,
    output wire  [10:0]                      req_p2r_cnt20,
    output wire  [10:0]                      req_p2r_cnt21,
    output wire  [10:0]                      req_p2r_cnt22,
    output wire  [10:0]                      req_p2r_cnt23,
    output wire  [10:0]                      req_p2r_cnt30,
    output wire  [10:0]                      req_p2r_cnt31,
    output wire  [10:0]                      req_p2r_cnt32,
    output wire  [10:0]                      req_p2r_cnt33,

    output wire  [10:0]                      req_r2p_cnt00,
    output wire  [10:0]                      req_r2p_cnt01,
    output wire  [10:0]                      req_r2p_cnt02,
    output wire  [10:0]                      req_r2p_cnt03,
    output wire  [10:0]                      req_r2p_cnt10,
    output wire  [10:0]                      req_r2p_cnt11,
    output wire  [10:0]                      req_r2p_cnt12,
    output wire  [10:0]                      req_r2p_cnt13,
    output wire  [10:0]                      req_r2p_cnt20,
    output wire  [10:0]                      req_r2p_cnt21,
    output wire  [10:0]                      req_r2p_cnt22,
    output wire  [10:0]                      req_r2p_cnt23,
    output wire  [10:0]                      req_r2p_cnt30,
    output wire  [10:0]                      req_r2p_cnt31,
    output wire  [10:0]                      req_r2p_cnt32,
    output wire  [10:0]                      req_r2p_cnt33,

    output wire  [10:0]                      ack_p2r_cnt00,
    output wire  [10:0]                      ack_p2r_cnt01,
    output wire  [10:0]                      ack_p2r_cnt02,
    output wire  [10:0]                      ack_p2r_cnt03,
    output wire  [10:0]                      ack_p2r_cnt10,
    output wire  [10:0]                      ack_p2r_cnt11,
    output wire  [10:0]                      ack_p2r_cnt12,
    output wire  [10:0]                      ack_p2r_cnt13,
    output wire  [10:0]                      ack_p2r_cnt20,
    output wire  [10:0]                      ack_p2r_cnt21,
    output wire  [10:0]                      ack_p2r_cnt22,
    output wire  [10:0]                      ack_p2r_cnt23,
    output wire  [10:0]                      ack_p2r_cnt30,
    output wire  [10:0]                      ack_p2r_cnt31,
    output wire  [10:0]                      ack_p2r_cnt32,
    output wire  [10:0]                      ack_p2r_cnt33,

    output wire  [10:0]                      ack_r2p_cnt00,
    output wire  [10:0]                      ack_r2p_cnt01,
    output wire  [10:0]                      ack_r2p_cnt02,
    output wire  [10:0]                      ack_r2p_cnt03,
    output wire  [10:0]                      ack_r2p_cnt10,
    output wire  [10:0]                      ack_r2p_cnt11,
    output wire  [10:0]                      ack_r2p_cnt12,
    output wire  [10:0]                      ack_r2p_cnt13,
    output wire  [10:0]                      ack_r2p_cnt20,
    output wire  [10:0]                      ack_r2p_cnt21,
    output wire  [10:0]                      ack_r2p_cnt22,
    output wire  [10:0]                      ack_r2p_cnt23,
    output wire  [10:0]                      ack_r2p_cnt30,
    output wire  [10:0]                      ack_r2p_cnt31,
    output wire  [10:0]                      ack_r2p_cnt32,
    output wire  [10:0]                      ack_r2p_cnt33,

    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit00,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit01,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit02,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit03,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit10,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit11,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit12,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit13,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit20,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit21,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit22,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit23,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit30,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit31,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit32,
    output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit33,

    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit00,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit01,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit02,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit03,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit10,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit11,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit12,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit13,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit20,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit21,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit22,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit23,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit30,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit31,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit32,
    output  wire [`MIN_WIDTH-1:0]    latency_min_circuit33,

    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit00,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit01,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit02,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit03,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit10,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit11,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit12,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit13,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit20,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit21,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit22,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit23,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit30,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit31,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit32,
    output  wire [`MAX_WIDTH-1:0]    latency_max_circuit33,

    output wire  error_circuit00,
    output wire  error_circuit01,
    output wire  error_circuit02,
    output wire  error_circuit03,
    output wire  error_circuit10,
    output wire  error_circuit11,
    output wire  error_circuit12,
    output wire  error_circuit13,
    output wire  error_circuit20,
    output wire  error_circuit21,
    output wire  error_circuit22,
    output wire  error_circuit23,
    output wire  error_circuit30,
    output wire  error_circuit31,
    output wire  error_circuit32,
    output wire  error_circuit33,

    output wire  error_packet00,
    output wire  error_packet01,
    output wire  error_packet02,
    output wire  error_packet03,
    output wire  error_packet10,
    output wire  error_packet11,
    output wire  error_packet12,
    output wire  error_packet13,
    output wire  error_packet20,
    output wire  error_packet21,
    output wire  error_packet22,
    output wire  error_packet23,
    output wire  error_packet30,
    output wire  error_packet31,
    output wire  error_packet32,
    output wire  error_packet33
    // Test

    // output   wire                                   clk_test,
    // output   wire                                   clk_global_test,

    // output   wire [3:0]                             rst_n_test,
    // output   wire [15:0]                            scan_in_test,
    // output   wire [`PDATASIZE + `CDATASIZE + 8 : 0] signal_test

    // output   wire                            clk_test,
    // output   wire                            clk_global_test,
    // output   wire                            rst_n_test,
    // output   wire                            rst_n1_test,
    // output   wire                            rst_n2_test,
    // output   wire                            rst_n3_test,

    // output wire                            enable_wire_test,
    // output wire [4:0]                      mode_wire_test,
    // output wire [3:0]                      hotpot_target_test,
    // output wire [3:0]                      DATA_WIDTH_DBG_test,
    // output wire [1:0]                      test_mode_test,

    // output wire [`PDATASIZE-1:0]           packet_data_test,
    // output wire                            packet_valid_test,
    // output wire                            packet_fifo_wfull_test,

    // output wire [`CDATASIZE-1:0]           CData_test,

    // output wire                            Ack_test,
    // output wire                            Strobe_test,
    // output wire                            State_test,
    // output wire                            Clock_test,
    // output wire                            Feedback_test,
    // output wire                            Tail_test,
    // output wire                            Stream_test
 
    );


    // wire  receive_packet_finish_flag00;
    // wire  receive_packet_finish_flag01;
    // wire  receive_packet_finish_flag02;
    // wire  receive_packet_finish_flag03;
    // wire  receive_packet_finish_flag10;
    // wire  receive_packet_finish_flag11;
    // wire  receive_packet_finish_flag12;
    // wire  receive_packet_finish_flag13;
    // wire  receive_packet_finish_flag20;
    // wire  receive_packet_finish_flag21;
    // wire  receive_packet_finish_flag22;
    // wire  receive_packet_finish_flag23;
    // wire  receive_packet_finish_flag30;
    // wire  receive_packet_finish_flag31;
    // wire  receive_packet_finish_flag32;
    // wire  receive_packet_finish_flag33;


    //  wire  [10:0]                     receive_packet_patch_num00;
    //  wire  [10:0]                     receive_packet_patch_num01;
    //  wire  [10:0]                     receive_packet_patch_num02;
    //  wire  [10:0]                     receive_packet_patch_num03;
    //  wire  [10:0]                     receive_packet_patch_num10;
    //  wire  [10:0]                     receive_packet_patch_num11;
    //  wire  [10:0]                     receive_packet_patch_num12;
    //  wire  [10:0]                     receive_packet_patch_num13;
    //  wire  [10:0]                     receive_packet_patch_num20;
    //  wire  [10:0]                     receive_packet_patch_num21;
    //  wire  [10:0]                     receive_packet_patch_num22;
    //  wire  [10:0]                     receive_packet_patch_num23;
    //  wire  [10:0]                     receive_packet_patch_num30;
    //  wire  [10:0]                     receive_packet_patch_num31;
    //  wire  [10:0]                     receive_packet_patch_num32;
    //  wire  [10:0]                     receive_packet_patch_num33;


    wire [15:0] time_stamp_local;
    // wire [31:0]             time_stamp_global;
    // wire                    receive_finish_flag00;
    // wire                    receive_finish_flag01;
    // wire                    receive_finish_flag02;
    // wire                    receive_finish_flag03;
    // wire                    receive_finish_flag10;
    // wire                    receive_finish_flag11;
    // wire                    receive_finish_flag12;
    // wire                    receive_finish_flag13;
    // wire                    receive_finish_flag20;
    // wire                    receive_finish_flag21;
    // wire                    receive_finish_flag22;
    // wire                    receive_finish_flag23;
    // wire                    receive_finish_flag30;
    // wire                    receive_finish_flag31;
    // wire                    receive_finish_flag32;
    // wire                    receive_finish_flag33;

    wire [`PDATASIZE-1:0]    packet_data_p2r00, packet_data_r2p00;
    wire [`PDATASIZE-1:0]    packet_data_p2r01, packet_data_r2p01;
    wire [`PDATASIZE-1:0]    packet_data_p2r02, packet_data_r2p02;
    wire [`PDATASIZE-1:0]    packet_data_p2r03, packet_data_r2p03;
    wire [`PDATASIZE-1:0]    packet_data_p2r10, packet_data_r2p10;
    wire [`PDATASIZE-1:0]    packet_data_p2r11, packet_data_r2p11;
    wire [`PDATASIZE-1:0]    packet_data_p2r12, packet_data_r2p12;
    wire [`PDATASIZE-1:0]    packet_data_p2r13, packet_data_r2p13;
    wire [`PDATASIZE-1:0]    packet_data_p2r20, packet_data_r2p20;
    wire [`PDATASIZE-1:0]    packet_data_p2r21, packet_data_r2p21;
    wire [`PDATASIZE-1:0]    packet_data_p2r22, packet_data_r2p22;
    wire [`PDATASIZE-1:0]    packet_data_p2r23, packet_data_r2p23;
    wire [`PDATASIZE-1:0]    packet_data_p2r30, packet_data_r2p30;
    wire [`PDATASIZE-1:0]    packet_data_p2r31, packet_data_r2p31;
    wire [`PDATASIZE-1:0]    packet_data_p2r32, packet_data_r2p32;
    wire [`PDATASIZE-1:0]    packet_data_p2r33, packet_data_r2p33;

    wire                    packet_valid_p2r00, packet_valid_r2p00;
    wire                    packet_valid_p2r01, packet_valid_r2p01;
    wire                    packet_valid_p2r02, packet_valid_r2p02;
    wire                    packet_valid_p2r03, packet_valid_r2p03;
    wire                    packet_valid_p2r10, packet_valid_r2p10;
    wire                    packet_valid_p2r11, packet_valid_r2p11;
    wire                    packet_valid_p2r12, packet_valid_r2p12;
    wire                    packet_valid_p2r13, packet_valid_r2p13;
    wire                    packet_valid_p2r20, packet_valid_r2p20;
    wire                    packet_valid_p2r21, packet_valid_r2p21;
    wire                    packet_valid_p2r22, packet_valid_r2p22;
    wire                    packet_valid_p2r23, packet_valid_r2p23;
    wire                    packet_valid_p2r30, packet_valid_r2p30;
    wire                    packet_valid_p2r31, packet_valid_r2p31;
    wire                    packet_valid_p2r32, packet_valid_r2p32;
    wire                    packet_valid_p2r33, packet_valid_r2p33;

    wire                    packet_fifo_wfull00;
    wire                    packet_fifo_wfull01;
    wire                    packet_fifo_wfull02;
    wire                    packet_fifo_wfull03;
    wire                    packet_fifo_wfull10;
    wire                    packet_fifo_wfull11;
    wire                    packet_fifo_wfull12;
    wire                    packet_fifo_wfull13;
    wire                    packet_fifo_wfull20;
    wire                    packet_fifo_wfull21;
    wire                    packet_fifo_wfull22;
    wire                    packet_fifo_wfull23;
    wire                    packet_fifo_wfull30;
    wire                    packet_fifo_wfull31;
    wire                    packet_fifo_wfull32;
    wire                    packet_fifo_wfull33;

    // handshake
    wire                    Tail_p2r00, Stream_p2r00;
    wire                    Tail_p2r01, Stream_p2r01;
    wire                    Tail_p2r02, Stream_p2r02;
    wire                    Tail_p2r03, Stream_p2r03;
    wire                    Tail_p2r10, Stream_p2r10;
    wire                    Tail_p2r11, Stream_p2r11;
    wire                    Tail_p2r12, Stream_p2r12;
    wire                    Tail_p2r13, Stream_p2r13;
    wire                    Tail_p2r20, Stream_p2r20;
    wire                    Tail_p2r21, Stream_p2r21;
    wire                    Tail_p2r22, Stream_p2r22;
    wire                    Tail_p2r23, Stream_p2r23;
    wire                    Tail_p2r30, Stream_p2r30;
    wire                    Tail_p2r31, Stream_p2r31;
    wire                    Tail_p2r32, Stream_p2r32;
    wire                    Tail_p2r33, Stream_p2r33;

    wire                    Tail_r2p00, Stream_r2p00;
    wire                    Tail_r2p01, Stream_r2p01;
    wire                    Tail_r2p02, Stream_r2p02;
    wire                    Tail_r2p03, Stream_r2p03;
    wire                    Tail_r2p10, Stream_r2p10;
    wire                    Tail_r2p11, Stream_r2p11;
    wire                    Tail_r2p12, Stream_r2p12;
    wire                    Tail_r2p13, Stream_r2p13;
    wire                    Tail_r2p20, Stream_r2p20;
    wire                    Tail_r2p21, Stream_r2p21;
    wire                    Tail_r2p22, Stream_r2p22;
    wire                    Tail_r2p23, Stream_r2p23;
    wire                    Tail_r2p30, Stream_r2p30;
    wire                    Tail_r2p31, Stream_r2p31;
    wire                    Tail_r2p32, Stream_r2p32;
    wire                    Tail_r2p33, Stream_r2p33;

    wire                    Ack_p2r00, Strobe_p2r00, State_p2r00, Clock_p2r00, Feedback_p2r00;
    wire                    Ack_p2r01, Strobe_p2r01, State_p2r01, Clock_p2r01, Feedback_p2r01;
    wire                    Ack_p2r02, Strobe_p2r02, State_p2r02, Clock_p2r02, Feedback_p2r02;
    wire                    Ack_p2r03, Strobe_p2r03, State_p2r03, Clock_p2r03, Feedback_p2r03;
    wire                    Ack_p2r10, Strobe_p2r10, State_p2r10, Clock_p2r10, Feedback_p2r10;
    wire                    Ack_p2r11, Strobe_p2r11, State_p2r11, Clock_p2r11, Feedback_p2r11;
    wire                    Ack_p2r12, Strobe_p2r12, State_p2r12, Clock_p2r12, Feedback_p2r12;
    wire                    Ack_p2r13, Strobe_p2r13, State_p2r13, Clock_p2r13, Feedback_p2r13;
    wire                    Ack_p2r20, Strobe_p2r20, State_p2r20, Clock_p2r20, Feedback_p2r20;
    wire                    Ack_p2r21, Strobe_p2r21, State_p2r21, Clock_p2r21, Feedback_p2r21;
    wire                    Ack_p2r22, Strobe_p2r22, State_p2r22, Clock_p2r22, Feedback_p2r22;
    wire                    Ack_p2r23, Strobe_p2r23, State_p2r23, Clock_p2r23, Feedback_p2r23;
    wire                    Ack_p2r30, Strobe_p2r30, State_p2r30, Clock_p2r30, Feedback_p2r30;
    wire                    Ack_p2r31, Strobe_p2r31, State_p2r31, Clock_p2r31, Feedback_p2r31;
    wire                    Ack_p2r32, Strobe_p2r32, State_p2r32, Clock_p2r32, Feedback_p2r32;
    wire                    Ack_p2r33, Strobe_p2r33, State_p2r33, Clock_p2r33, Feedback_p2r33;

    wire                    Ack_r2p00, Strobe_r2p00, State_r2p00, Clock_r2p00, Feedback_r2p00;
    wire                    Ack_r2p01, Strobe_r2p01, State_r2p01, Clock_r2p01, Feedback_r2p01;
    wire                    Ack_r2p02, Strobe_r2p02, State_r2p02, Clock_r2p02, Feedback_r2p02;
    wire                    Ack_r2p03, Strobe_r2p03, State_r2p03, Clock_r2p03, Feedback_r2p03;
    wire                    Ack_r2p10, Strobe_r2p10, State_r2p10, Clock_r2p10, Feedback_r2p10;
    wire                    Ack_r2p11, Strobe_r2p11, State_r2p11, Clock_r2p11, Feedback_r2p11;
    wire                    Ack_r2p12, Strobe_r2p12, State_r2p12, Clock_r2p12, Feedback_r2p12;
    wire                    Ack_r2p13, Strobe_r2p13, State_r2p13, Clock_r2p13, Feedback_r2p13;
    wire                    Ack_r2p20, Strobe_r2p20, State_r2p20, Clock_r2p20, Feedback_r2p20;
    wire                    Ack_r2p21, Strobe_r2p21, State_r2p21, Clock_r2p21, Feedback_r2p21;
    wire                    Ack_r2p22, Strobe_r2p22, State_r2p22, Clock_r2p22, Feedback_r2p22;
    wire                    Ack_r2p23, Strobe_r2p23, State_r2p23, Clock_r2p23, Feedback_r2p23;
    wire                    Ack_r2p30, Strobe_r2p30, State_r2p30, Clock_r2p30, Feedback_r2p30;
    wire                    Ack_r2p31, Strobe_r2p31, State_r2p31, Clock_r2p31, Feedback_r2p31;
    wire                    Ack_r2p32, Strobe_r2p32, State_r2p32, Clock_r2p32, Feedback_r2p32;
    wire                    Ack_r2p33, Strobe_r2p33, State_r2p33, Clock_r2p33, Feedback_r2p33;             

    wire [`CDATASIZE-1:0]    CData_p2r00, CData_r2p00;
    wire [`CDATASIZE-1:0]    CData_p2r01, CData_r2p01;
    wire [`CDATASIZE-1:0]    CData_p2r02, CData_r2p02;
    wire [`CDATASIZE-1:0]    CData_p2r03, CData_r2p03;
    wire [`CDATASIZE-1:0]    CData_p2r10, CData_r2p10;
    wire [`CDATASIZE-1:0]    CData_p2r11, CData_r2p11;
    wire [`CDATASIZE-1:0]    CData_p2r12, CData_r2p12;
    wire [`CDATASIZE-1:0]    CData_p2r13, CData_r2p13;
    wire [`CDATASIZE-1:0]    CData_p2r20, CData_r2p20;
    wire [`CDATASIZE-1:0]    CData_p2r21, CData_r2p21;
    wire [`CDATASIZE-1:0]    CData_p2r22, CData_r2p22;
    wire [`CDATASIZE-1:0]    CData_p2r23, CData_r2p23;
    wire [`CDATASIZE-1:0]    CData_p2r30, CData_r2p30;
    wire [`CDATASIZE-1:0]    CData_p2r31, CData_r2p31;
    wire [`CDATASIZE-1:0]    CData_p2r32, CData_r2p32;
    wire [`CDATASIZE-1:0]    CData_p2r33, CData_r2p33;

    wire [`PDATASIZE-1:0]    W_packet_data_out00, N_packet_data_out00, E_packet_data_out00, S_packet_data_out00;
    wire [`PDATASIZE-1:0]    W_packet_data_out01, N_packet_data_out01, E_packet_data_out01, S_packet_data_out01;
    wire [`PDATASIZE-1:0]    W_packet_data_out02, N_packet_data_out02, E_packet_data_out02, S_packet_data_out02;
    wire [`PDATASIZE-1:0]    W_packet_data_out03, N_packet_data_out03, E_packet_data_out03, S_packet_data_out03;
    wire [`PDATASIZE-1:0]    W_packet_data_out10, N_packet_data_out10, E_packet_data_out10, S_packet_data_out10;
    wire [`PDATASIZE-1:0]    W_packet_data_out11, N_packet_data_out11, E_packet_data_out11, S_packet_data_out11;
    wire [`PDATASIZE-1:0]    W_packet_data_out12, N_packet_data_out12, E_packet_data_out12, S_packet_data_out12;
    wire [`PDATASIZE-1:0]    W_packet_data_out13, N_packet_data_out13, E_packet_data_out13, S_packet_data_out13;
    wire [`PDATASIZE-1:0]    W_packet_data_out20, N_packet_data_out20, E_packet_data_out20, S_packet_data_out20;
    wire [`PDATASIZE-1:0]    W_packet_data_out21, N_packet_data_out21, E_packet_data_out21, S_packet_data_out21;
    wire [`PDATASIZE-1:0]    W_packet_data_out22, N_packet_data_out22, E_packet_data_out22, S_packet_data_out22;
    wire [`PDATASIZE-1:0]    W_packet_data_out23, N_packet_data_out23, E_packet_data_out23, S_packet_data_out23;
    wire [`PDATASIZE-1:0]    W_packet_data_out30, N_packet_data_out30, E_packet_data_out30, S_packet_data_out30;
    wire [`PDATASIZE-1:0]    W_packet_data_out31, N_packet_data_out31, E_packet_data_out31, S_packet_data_out31;
    wire [`PDATASIZE-1:0]    W_packet_data_out32, N_packet_data_out32, E_packet_data_out32, S_packet_data_out32;
    wire [`PDATASIZE-1:0]    W_packet_data_out33, N_packet_data_out33, E_packet_data_out33, S_packet_data_out33;

    wire                    W_packet_valid_out00, N_packet_valid_out00, E_packet_valid_out00, S_packet_valid_out00;
    wire                    W_packet_valid_out01, N_packet_valid_out01, E_packet_valid_out01, S_packet_valid_out01;
    wire                    W_packet_valid_out02, N_packet_valid_out02, E_packet_valid_out02, S_packet_valid_out02;
    wire                    W_packet_valid_out03, N_packet_valid_out03, E_packet_valid_out03, S_packet_valid_out03;
    wire                    W_packet_valid_out10, N_packet_valid_out10, E_packet_valid_out10, S_packet_valid_out10;
    wire                    W_packet_valid_out11, N_packet_valid_out11, E_packet_valid_out11, S_packet_valid_out11;
    wire                    W_packet_valid_out12, N_packet_valid_out12, E_packet_valid_out12, S_packet_valid_out12;
    wire                    W_packet_valid_out13, N_packet_valid_out13, E_packet_valid_out13, S_packet_valid_out13;
    wire                    W_packet_valid_out20, N_packet_valid_out20, E_packet_valid_out20, S_packet_valid_out20;
    wire                    W_packet_valid_out21, N_packet_valid_out21, E_packet_valid_out21, S_packet_valid_out21;
    wire                    W_packet_valid_out22, N_packet_valid_out22, E_packet_valid_out22, S_packet_valid_out22;
    wire                    W_packet_valid_out23, N_packet_valid_out23, E_packet_valid_out23, S_packet_valid_out23;
    wire                    W_packet_valid_out30, N_packet_valid_out30, E_packet_valid_out30, S_packet_valid_out30;
    wire                    W_packet_valid_out31, N_packet_valid_out31, E_packet_valid_out31, S_packet_valid_out31;
    wire                    W_packet_valid_out32, N_packet_valid_out32, E_packet_valid_out32, S_packet_valid_out32;
    wire                    W_packet_valid_out33, N_packet_valid_out33, E_packet_valid_out33, S_packet_valid_out33;

    wire                    W_packet_full_out00, N_packet_full_out00, E_packet_full_out00, S_packet_full_out00;
    wire                    W_packet_full_out01, N_packet_full_out01, E_packet_full_out01, S_packet_full_out01;
    wire                    W_packet_full_out02, N_packet_full_out02, E_packet_full_out02, S_packet_full_out02;
    wire                    W_packet_full_out03, N_packet_full_out03, E_packet_full_out03, S_packet_full_out03;
    wire                    W_packet_full_out10, N_packet_full_out10, E_packet_full_out10, S_packet_full_out10;
    wire                    W_packet_full_out11, N_packet_full_out11, E_packet_full_out11, S_packet_full_out11;
    wire                    W_packet_full_out12, N_packet_full_out12, E_packet_full_out12, S_packet_full_out12;
    wire                    W_packet_full_out13, N_packet_full_out13, E_packet_full_out13, S_packet_full_out13;
    wire                    W_packet_full_out20, N_packet_full_out20, E_packet_full_out20, S_packet_full_out20;
    wire                    W_packet_full_out21, N_packet_full_out21, E_packet_full_out21, S_packet_full_out21;
    wire                    W_packet_full_out22, N_packet_full_out22, E_packet_full_out22, S_packet_full_out22;
    wire                    W_packet_full_out23, N_packet_full_out23, E_packet_full_out23, S_packet_full_out23;
    wire                    W_packet_full_out30, N_packet_full_out30, E_packet_full_out30, S_packet_full_out30;
    wire                    W_packet_full_out31, N_packet_full_out31, E_packet_full_out31, S_packet_full_out31;
    wire                    W_packet_full_out32, N_packet_full_out32, E_packet_full_out32, S_packet_full_out32;
    wire                    W_packet_full_out33, N_packet_full_out33, E_packet_full_out33, S_packet_full_out33;


    wire                    W_Tail_out00, N_Tail_out00, E_Tail_out00, S_Tail_out00;
    wire                    W_Tail_out01, N_Tail_out01, E_Tail_out01, S_Tail_out01;
    wire                    W_Tail_out02, N_Tail_out02, E_Tail_out02, S_Tail_out02;
    wire                    W_Tail_out03, N_Tail_out03, E_Tail_out03, S_Tail_out03;
    wire                    W_Tail_out10, N_Tail_out10, E_Tail_out10, S_Tail_out10;
    wire                    W_Tail_out11, N_Tail_out11, E_Tail_out11, S_Tail_out11;
    wire                    W_Tail_out12, N_Tail_out12, E_Tail_out12, S_Tail_out12;
    wire                    W_Tail_out13, N_Tail_out13, E_Tail_out13, S_Tail_out13;
    wire                    W_Tail_out20, N_Tail_out20, E_Tail_out20, S_Tail_out20;
    wire                    W_Tail_out21, N_Tail_out21, E_Tail_out21, S_Tail_out21;
    wire                    W_Tail_out22, N_Tail_out22, E_Tail_out22, S_Tail_out22;
    wire                    W_Tail_out23, N_Tail_out23, E_Tail_out23, S_Tail_out23;
    wire                    W_Tail_out30, N_Tail_out30, E_Tail_out30, S_Tail_out30;
    wire                    W_Tail_out31, N_Tail_out31, E_Tail_out31, S_Tail_out31;
    wire                    W_Tail_out32, N_Tail_out32, E_Tail_out32, S_Tail_out32;
    wire                    W_Tail_out33, N_Tail_out33, E_Tail_out33, S_Tail_out33;

    wire                    W_Stream_out00, N_Stream_out00, E_Stream_out00, S_Stream_out00;
    wire                    W_Stream_out01, N_Stream_out01, E_Stream_out01, S_Stream_out01;
    wire                    W_Stream_out02, N_Stream_out02, E_Stream_out02, S_Stream_out02;
    wire                    W_Stream_out03, N_Stream_out03, E_Stream_out03, S_Stream_out03;
    wire                    W_Stream_out10, N_Stream_out10, E_Stream_out10, S_Stream_out10;
    wire                    W_Stream_out11, N_Stream_out11, E_Stream_out11, S_Stream_out11;
    wire                    W_Stream_out12, N_Stream_out12, E_Stream_out12, S_Stream_out12;
    wire                    W_Stream_out13, N_Stream_out13, E_Stream_out13, S_Stream_out13;
    wire                    W_Stream_out20, N_Stream_out20, E_Stream_out20, S_Stream_out20;
    wire                    W_Stream_out21, N_Stream_out21, E_Stream_out21, S_Stream_out21;
    wire                    W_Stream_out22, N_Stream_out22, E_Stream_out22, S_Stream_out22;
    wire                    W_Stream_out23, N_Stream_out23, E_Stream_out23, S_Stream_out23;
    wire                    W_Stream_out30, N_Stream_out30, E_Stream_out30, S_Stream_out30;
    wire                    W_Stream_out31, N_Stream_out31, E_Stream_out31, S_Stream_out31;
    wire                    W_Stream_out32, N_Stream_out32, E_Stream_out32, S_Stream_out32;
    wire                    W_Stream_out33, N_Stream_out33, E_Stream_out33, S_Stream_out33;

    wire [`CDATASIZE-1:0]    W_CData_Out_00, N_CData_Out_00, E_CData_Out_00, S_CData_Out_00;
    wire [`CDATASIZE-1:0]    W_CData_Out_01, N_CData_Out_01, E_CData_Out_01, S_CData_Out_01;
    wire [`CDATASIZE-1:0]    W_CData_Out_02, N_CData_Out_02, E_CData_Out_02, S_CData_Out_02;
    wire [`CDATASIZE-1:0]    W_CData_Out_03, N_CData_Out_03, E_CData_Out_03, S_CData_Out_03;
    wire [`CDATASIZE-1:0]    W_CData_Out_10, N_CData_Out_10, E_CData_Out_10, S_CData_Out_10;
    wire [`CDATASIZE-1:0]    W_CData_Out_11, N_CData_Out_11, E_CData_Out_11, S_CData_Out_11;
    wire [`CDATASIZE-1:0]    W_CData_Out_12, N_CData_Out_12, E_CData_Out_12, S_CData_Out_12;
    wire [`CDATASIZE-1:0]    W_CData_Out_13, N_CData_Out_13, E_CData_Out_13, S_CData_Out_13;
    wire [`CDATASIZE-1:0]    W_CData_Out_20, N_CData_Out_20, E_CData_Out_20, S_CData_Out_20;
    wire [`CDATASIZE-1:0]    W_CData_Out_21, N_CData_Out_21, E_CData_Out_21, S_CData_Out_21;
    wire [`CDATASIZE-1:0]    W_CData_Out_22, N_CData_Out_22, E_CData_Out_22, S_CData_Out_22;
    wire [`CDATASIZE-1:0]    W_CData_Out_23, N_CData_Out_23, E_CData_Out_23, S_CData_Out_23;
    wire [`CDATASIZE-1:0]    W_CData_Out_30, N_CData_Out_30, E_CData_Out_30, S_CData_Out_30;
    wire [`CDATASIZE-1:0]    W_CData_Out_31, N_CData_Out_31, E_CData_Out_31, S_CData_Out_31;
    wire [`CDATASIZE-1:0]    W_CData_Out_32, N_CData_Out_32, E_CData_Out_32, S_CData_Out_32;
    wire [`CDATASIZE-1:0]    W_CData_Out_33, N_CData_Out_33, E_CData_Out_33, S_CData_Out_33;

    wire                    W_Ack_Out_00, N_Ack_Out_00, E_Ack_Out_00, S_Ack_Out_00;
    wire                    W_Ack_Out_01, N_Ack_Out_01, E_Ack_Out_01, S_Ack_Out_01;
    wire                    W_Ack_Out_02, N_Ack_Out_02, E_Ack_Out_02, S_Ack_Out_02;
    wire                    W_Ack_Out_03, N_Ack_Out_03, E_Ack_Out_03, S_Ack_Out_03;
    wire                    W_Ack_Out_10, N_Ack_Out_10, E_Ack_Out_10, S_Ack_Out_10;
    wire                    W_Ack_Out_11, N_Ack_Out_11, E_Ack_Out_11, S_Ack_Out_11;
    wire                    W_Ack_Out_12, N_Ack_Out_12, E_Ack_Out_12, S_Ack_Out_12;
    wire                    W_Ack_Out_13, N_Ack_Out_13, E_Ack_Out_13, S_Ack_Out_13;
    wire                    W_Ack_Out_20, N_Ack_Out_20, E_Ack_Out_20, S_Ack_Out_20;
    wire                    W_Ack_Out_21, N_Ack_Out_21, E_Ack_Out_21, S_Ack_Out_21;
    wire                    W_Ack_Out_22, N_Ack_Out_22, E_Ack_Out_22, S_Ack_Out_22;
    wire                    W_Ack_Out_23, N_Ack_Out_23, E_Ack_Out_23, S_Ack_Out_23;
    wire                    W_Ack_Out_30, N_Ack_Out_30, E_Ack_Out_30, S_Ack_Out_30;
    wire                    W_Ack_Out_31, N_Ack_Out_31, E_Ack_Out_31, S_Ack_Out_31;
    wire                    W_Ack_Out_32, N_Ack_Out_32, E_Ack_Out_32, S_Ack_Out_32;
    wire                    W_Ack_Out_33, N_Ack_Out_33, E_Ack_Out_33, S_Ack_Out_33;

    wire                    W_Strobe_Out_00, N_Strobe_Out_00, E_Strobe_Out_00, S_Strobe_Out_00;
    wire                    W_Strobe_Out_01, N_Strobe_Out_01, E_Strobe_Out_01, S_Strobe_Out_01;
    wire                    W_Strobe_Out_02, N_Strobe_Out_02, E_Strobe_Out_02, S_Strobe_Out_02;
    wire                    W_Strobe_Out_03, N_Strobe_Out_03, E_Strobe_Out_03, S_Strobe_Out_03;
    wire                    W_Strobe_Out_10, N_Strobe_Out_10, E_Strobe_Out_10, S_Strobe_Out_10;
    wire                    W_Strobe_Out_11, N_Strobe_Out_11, E_Strobe_Out_11, S_Strobe_Out_11;
    wire                    W_Strobe_Out_12, N_Strobe_Out_12, E_Strobe_Out_12, S_Strobe_Out_12;
    wire                    W_Strobe_Out_13, N_Strobe_Out_13, E_Strobe_Out_13, S_Strobe_Out_13;
    wire                    W_Strobe_Out_20, N_Strobe_Out_20, E_Strobe_Out_20, S_Strobe_Out_20;
    wire                    W_Strobe_Out_21, N_Strobe_Out_21, E_Strobe_Out_21, S_Strobe_Out_21;
    wire                    W_Strobe_Out_22, N_Strobe_Out_22, E_Strobe_Out_22, S_Strobe_Out_22;
    wire                    W_Strobe_Out_23, N_Strobe_Out_23, E_Strobe_Out_23, S_Strobe_Out_23;
    wire                    W_Strobe_Out_30, N_Strobe_Out_30, E_Strobe_Out_30, S_Strobe_Out_30;
    wire                    W_Strobe_Out_31, N_Strobe_Out_31, E_Strobe_Out_31, S_Strobe_Out_31;
    wire                    W_Strobe_Out_32, N_Strobe_Out_32, E_Strobe_Out_32, S_Strobe_Out_32;
    wire                    W_Strobe_Out_33, N_Strobe_Out_33, E_Strobe_Out_33, S_Strobe_Out_33;

    wire                    W_State_Out_00, N_State_Out_00, E_State_Out_00, S_State_Out_00;
    wire                    W_State_Out_01, N_State_Out_01, E_State_Out_01, S_State_Out_01;
    wire                    W_State_Out_02, N_State_Out_02, E_State_Out_02, S_State_Out_02;
    wire                    W_State_Out_03, N_State_Out_03, E_State_Out_03, S_State_Out_03;
    wire                    W_State_Out_10, N_State_Out_10, E_State_Out_10, S_State_Out_10;
    wire                    W_State_Out_11, N_State_Out_11, E_State_Out_11, S_State_Out_11;
    wire                    W_State_Out_12, N_State_Out_12, E_State_Out_12, S_State_Out_12;
    wire                    W_State_Out_13, N_State_Out_13, E_State_Out_13, S_State_Out_13;
    wire                    W_State_Out_20, N_State_Out_20, E_State_Out_20, S_State_Out_20;
    wire                    W_State_Out_21, N_State_Out_21, E_State_Out_21, S_State_Out_21;
    wire                    W_State_Out_22, N_State_Out_22, E_State_Out_22, S_State_Out_22;
    wire                    W_State_Out_23, N_State_Out_23, E_State_Out_23, S_State_Out_23;
    wire                    W_State_Out_30, N_State_Out_30, E_State_Out_30, S_State_Out_30;
    wire                    W_State_Out_31, N_State_Out_31, E_State_Out_31, S_State_Out_31;
    wire                    W_State_Out_32, N_State_Out_32, E_State_Out_32, S_State_Out_32;
    wire                    W_State_Out_33, N_State_Out_33, E_State_Out_33, S_State_Out_33;

    wire                    W_Clock_Out_00, N_Clock_Out_00, E_Clock_Out_00, S_Clock_Out_00;
    wire                    W_Clock_Out_01, N_Clock_Out_01, E_Clock_Out_01, S_Clock_Out_01;
    wire                    W_Clock_Out_02, N_Clock_Out_02, E_Clock_Out_02, S_Clock_Out_02;
    wire                    W_Clock_Out_03, N_Clock_Out_03, E_Clock_Out_03, S_Clock_Out_03;
    wire                    W_Clock_Out_10, N_Clock_Out_10, E_Clock_Out_10, S_Clock_Out_10;
    wire                    W_Clock_Out_11, N_Clock_Out_11, E_Clock_Out_11, S_Clock_Out_11;
    wire                    W_Clock_Out_12, N_Clock_Out_12, E_Clock_Out_12, S_Clock_Out_12;
    wire                    W_Clock_Out_13, N_Clock_Out_13, E_Clock_Out_13, S_Clock_Out_13;
    wire                    W_Clock_Out_20, N_Clock_Out_20, E_Clock_Out_20, S_Clock_Out_20;
    wire                    W_Clock_Out_21, N_Clock_Out_21, E_Clock_Out_21, S_Clock_Out_21;
    wire                    W_Clock_Out_22, N_Clock_Out_22, E_Clock_Out_22, S_Clock_Out_22;
    wire                    W_Clock_Out_23, N_Clock_Out_23, E_Clock_Out_23, S_Clock_Out_23;
    wire                    W_Clock_Out_30, N_Clock_Out_30, E_Clock_Out_30, S_Clock_Out_30;
    wire                    W_Clock_Out_31, N_Clock_Out_31, E_Clock_Out_31, S_Clock_Out_31;
    wire                    W_Clock_Out_32, N_Clock_Out_32, E_Clock_Out_32, S_Clock_Out_32;
    wire                    W_Clock_Out_33, N_Clock_Out_33, E_Clock_Out_33, S_Clock_Out_33;

    // TEST

//     wire                    PE_00_clk_test, PE_01_clk_test, PE_02_clk_test, PE_03_clk_test;
//     wire                    PE_10_clk_test, PE_11_clk_test, PE_12_clk_test, PE_13_clk_test;
//     wire                    PE_20_clk_test, PE_21_clk_test, PE_22_clk_test, PE_23_clk_test;
//     wire                    PE_30_clk_test, PE_31_clk_test, PE_32_clk_test, PE_33_clk_test;

//     wire                    PE_00_clk_global_test, PE_01_clk_global_test, PE_02_clk_global_test, PE_03_clk_global_test;
//     wire                    PE_10_clk_global_test, PE_11_clk_global_test, PE_12_clk_global_test, PE_13_clk_global_test;
//     wire                    PE_20_clk_global_test, PE_21_clk_global_test, PE_22_clk_global_test, PE_23_clk_global_test;
//     wire                    PE_30_clk_global_test, PE_31_clk_global_test, PE_32_clk_global_test, PE_33_clk_global_test;

//     wire [3:0]              PE_00_rst_n_test, PE_01_rst_n_test, PE_02_rst_n_test, PE_03_rst_n_test;
//     wire [3:0]              PE_10_rst_n_test, PE_11_rst_n_test, PE_12_rst_n_test, PE_13_rst_n_test;
//     wire [3:0]              PE_20_rst_n_test, PE_21_rst_n_test, PE_22_rst_n_test, PE_23_rst_n_test;
//     wire [3:0]              PE_30_rst_n_test, PE_31_rst_n_test, PE_32_rst_n_test, PE_33_rst_n_test;


//     wire [15:0]             PE_00_scan_in_test, PE_01_scan_in_test, PE_02_scan_in_test, PE_03_scan_in_test;
//     wire [15:0]             PE_10_scan_in_test, PE_11_scan_in_test, PE_12_scan_in_test, PE_13_scan_in_test;
//     wire [15:0]             PE_20_scan_in_test, PE_21_scan_in_test, PE_22_scan_in_test, PE_23_scan_in_test;
//     wire [15:0]             PE_30_scan_in_test, PE_31_scan_in_test, PE_32_scan_in_test, PE_33_scan_in_test;

//     wire [`PDATASIZE + `CDATASIZE + 8 : 0]  PE_00_signal_test, PE_01_signal_test, PE_02_signal_test, PE_03_signal_test;
//     wire [`PDATASIZE + `CDATASIZE + 8 : 0]  PE_10_signal_test, PE_11_signal_test, PE_12_signal_test, PE_13_signal_test;
//     wire [`PDATASIZE + `CDATASIZE + 8 : 0]  PE_20_signal_test, PE_21_signal_test, PE_22_signal_test, PE_23_signal_test;
//     wire [`PDATASIZE + `CDATASIZE + 8 : 0]  PE_30_signal_test, PE_31_signal_test, PE_32_signal_test, PE_33_signal_test;

//     pe_verify pe_verify(
//         .pe_verify_sel(pe_verify_sel[3:0]),
//         // PE_00
//         .PE_00_clk_test(PE_00_clk_test),
//         .PE_00_clk_global_test(PE_00_clk_global_test),
//         .PE_00_rst_n_test(PE_00_rst_n_test),
//         .PE_00_scan_in_test(PE_00_scan_in_test),
//         .PE_00_signal_test(PE_00_signal_test),
//         // PE_01
//         .PE_01_clk_test(PE_01_clk_test),
//         .PE_01_clk_global_test(PE_01_clk_global_test),
//         .PE_01_rst_n_test(PE_01_rst_n_test),
//         .PE_01_scan_in_test(PE_01_scan_in_test),
//         .PE_01_signal_test(PE_01_signal_test),
//         // PE_02
//         .PE_02_clk_test(PE_02_clk_test),
//         .PE_02_clk_global_test(PE_02_clk_global_test),
//         .PE_02_rst_n_test(PE_02_rst_n_test),
//         .PE_02_scan_in_test(PE_02_scan_in_test),
//         .PE_02_signal_test(PE_02_signal_test),
//         // PE_03
//         .PE_03_clk_test(PE_03_clk_test),
//         .PE_03_clk_global_test(PE_03_clk_global_test),
//         .PE_03_rst_n_test(PE_03_rst_n_test),
//         .PE_03_scan_in_test(PE_03_scan_in_test),
//         .PE_03_signal_test(PE_03_signal_test),
//         // PE_10
//         .PE_10_clk_test(PE_10_clk_test),
//         .PE_10_clk_global_test(PE_10_clk_global_test),
//         .PE_10_rst_n_test(PE_10_rst_n_test),
//         .PE_10_scan_in_test(PE_10_scan_in_test),
//         .PE_10_signal_test(PE_10_signal_test),
//         // PE_11
//         .PE_11_clk_test(PE_11_clk_test),
//         .PE_11_clk_global_test(PE_11_clk_global_test),
//         .PE_11_rst_n_test(PE_11_rst_n_test),
//         .PE_11_scan_in_test(PE_11_scan_in_test),
//         .PE_11_signal_test(PE_11_signal_test),
//         // PE_12
//         .PE_12_clk_test(PE_12_clk_test),
//         .PE_12_clk_global_test(PE_12_clk_global_test),
//         .PE_12_rst_n_test(PE_12_rst_n_test),
//         .PE_12_scan_in_test(PE_12_scan_in_test),
//         .PE_12_signal_test(PE_12_signal_test),
//         // PE_13
//         .PE_13_clk_test(PE_13_clk_test),
//         .PE_13_clk_global_test(PE_13_clk_global_test),
//         .PE_13_rst_n_test(PE_13_rst_n_test),
//         .PE_13_scan_in_test(PE_13_scan_in_test),
//         .PE_13_signal_test(PE_13_signal_test),
//         // PE_20
//         .PE_20_clk_test(PE_20_clk_test),
//         .PE_20_clk_global_test(PE_20_clk_global_test),
//         .PE_20_rst_n_test(PE_20_rst_n_test),
//         .PE_20_scan_in_test(PE_20_scan_in_test),
//         .PE_20_signal_test(PE_20_signal_test),
//         // PE_21
//         .PE_21_clk_test(PE_21_clk_test),
//         .PE_21_clk_global_test(PE_21_clk_global_test),
//         .PE_21_rst_n_test(PE_21_rst_n_test),
//         .PE_21_scan_in_test(PE_21_scan_in_test),
//         .PE_21_signal_test(PE_21_signal_test),
//         // PE_22
//         .PE_22_clk_test(PE_22_clk_test),
//         .PE_22_clk_global_test(PE_22_clk_global_test),
//         .PE_22_rst_n_test(PE_22_rst_n_test),
//         .PE_22_scan_in_test(PE_22_scan_in_test),
//         .PE_22_signal_test(PE_22_signal_test),
//         // PE_23
//         .PE_23_clk_test(PE_23_clk_test),
//         .PE_23_clk_global_test(PE_23_clk_global_test),
//         .PE_23_rst_n_test(PE_23_rst_n_test),
//         .PE_23_scan_in_test(PE_23_scan_in_test),
//         .PE_23_signal_test(PE_23_signal_test),
//         // PE_30
//         .PE_30_clk_test(PE_30_clk_test),
//         .PE_30_clk_global_test(PE_30_clk_global_test),
//         .PE_30_rst_n_test(PE_30_rst_n_test),
//         .PE_30_scan_in_test(PE_30_scan_in_test),
//         .PE_30_signal_test(PE_30_signal_test),
//         // PE_31
//         .PE_31_clk_test(PE_31_clk_test),
//         .PE_31_clk_global_test(PE_31_clk_global_test),
//         .PE_31_rst_n_test(PE_31_rst_n_test),
//         .PE_31_scan_in_test(PE_31_scan_in_test),
//         .PE_31_signal_test(PE_31_signal_test),
//         // PE_32
//         .PE_32_clk_test(PE_32_clk_test),
//         .PE_32_clk_global_test(PE_32_clk_global_test),
//         .PE_32_rst_n_test(PE_32_rst_n_test),
//         .PE_32_scan_in_test(PE_32_scan_in_test),
//         .PE_32_signal_test(PE_32_signal_test),
//         // PE_33
//         .PE_33_clk_test(PE_33_clk_test),
//         .PE_33_clk_global_test(PE_33_clk_global_test),
//         .PE_33_rst_n_test(PE_33_rst_n_test),
//         .PE_33_scan_in_test(PE_33_scan_in_test),
//         .PE_33_signal_test(PE_33_signal_test),
    
//         // Output
//         .clk_test(clk_test),
//         .clk_global_test(clk_global_test),
//         .rst_n_test(rst_n_test),
//         .scan_in_test(scan_in_test),
//         .signal_test(signal_test)
 
// );



    PE_all PE00(
        .ID(4'b0000),
        .clk(clk0),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r00),
        .packet_valid_p2r(packet_valid_p2r00),
        .packet_data_r2p(packet_data_r2p00),
        .packet_valid_r2p(packet_valid_r2p00),
        .packet_fifo_wfull(packet_fifo_wfull00),

    // handshake
        .Tail_p2r(Tail_p2r00),
        .Stream_p2r(Stream_p2r00),
        .Tail_r2p(Tail_r2p00),
        .Stream_r2p(Stream_r2p00),

        .Ack_p2r(Ack_p2r00),
        .CData_p2r(CData_p2r00),
        .Strobe_p2r(Strobe_p2r00),
        .State_p2r(State_p2r00),
        .Clock_p2r(Clock_p2r00),
        .Ack_r2p(Ack_r2p00),
        .CData_r2p(CData_r2p00),
        .Strobe_r2p(Strobe_r2p00),
        .State_r2p(State_r2p00),
        .Clock_r2p(clk4), 

        .Feedback_p2r(Feedback_p2r00),
        .Feedback_r2p(Feedback_r2p00),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag00),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc0)

        .cdata_stream_latency(cdata_stream_latency00),
        .receive_patch_num(receive_patch_num00),
        .latency_sum_circuit(latency_sum_circuit00),
        .latency_min_circuit(latency_min_circuit00),
        .latency_max_circuit(latency_max_circuit00),

        .receive_packet_patch_num(receive_packet_patch_num00),
        .receive_packet_finish_flag(receive_packet_finish_flag00),

        .error_circuit(error_circuit00),
        .error_packet(error_packet00),

        .send_packet_patch_num(send_packet_patch_num00),
        .send_patch_num(send_patch_num00),
        .req_p2r_cnt(req_p2r_cnt00),
        .req_r2p_cnt(req_r2p_cnt00),
        .ack_p2r_cnt(ack_p2r_cnt00),
        .ack_r2p_cnt(ack_r2p_cnt00)

        // .clk_test(PE_00_clk_test),
        // .clk_global_test(PE_00_clk_global_test),
        // .rst_n_test(PE_00_rst_n_test),
        // .scan_in_test(PE_00_scan_in_test),
        // .signal_test(PE_00_signal_test)
    );

    PE_all PE01(
        .ID(4'b0001),
        .clk(clk1),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r01),
        .packet_valid_p2r(packet_valid_p2r01),
        .packet_data_r2p(packet_data_r2p01),
        .packet_valid_r2p(packet_valid_r2p01),
        .packet_fifo_wfull(packet_fifo_wfull01),

    // handshake
        .Tail_p2r(Tail_p2r01),
        .Stream_p2r(Stream_p2r01),
        .Tail_r2p(Tail_r2p01),
        .Stream_r2p(Stream_r2p01),

        .Ack_p2r(Ack_p2r01),
        .CData_p2r(CData_p2r01),
        .Strobe_p2r(Strobe_p2r01),
        .State_p2r(State_p2r01),
        .Clock_p2r(Clock_p2r01),
        .Ack_r2p(Ack_r2p01),
        .CData_r2p(CData_r2p01),
        .Strobe_r2p(Strobe_r2p01),
        .State_r2p(State_r2p01),
        .Clock_r2p(clk5), 

        .Feedback_p2r(Feedback_p2r01),
        .Feedback_r2p(Feedback_r2p01),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag01),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc1)

        .cdata_stream_latency(cdata_stream_latency01),
        .receive_patch_num(receive_patch_num01),
        .latency_sum_circuit(latency_sum_circuit01),
        .latency_min_circuit(latency_min_circuit01),
        .latency_max_circuit(latency_max_circuit01),

        .receive_packet_patch_num(receive_packet_patch_num01),
        .receive_packet_finish_flag(receive_packet_finish_flag01),

        .error_circuit(error_circuit01),
        .error_packet(error_packet01),

        .send_packet_patch_num(send_packet_patch_num01),
        .send_patch_num(send_patch_num01),
        .req_p2r_cnt(req_p2r_cnt01),
        .req_r2p_cnt(req_r2p_cnt01),
        .ack_p2r_cnt(ack_p2r_cnt01),
        .ack_r2p_cnt(ack_r2p_cnt01)

        // .clk_test(PE_01_clk_test),
        // .clk_global_test(PE_01_clk_global_test),
        // .rst_n_test(PE_01_rst_n_test),
        // .scan_in_test(PE_01_scan_in_test),
        // .signal_test(PE_01_signal_test)
    );

    PE_all PE02(
        .ID(4'b0010),
        .clk(clk2),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r02),
        .packet_valid_p2r(packet_valid_p2r02),
        .packet_data_r2p(packet_data_r2p02),
        .packet_valid_r2p(packet_valid_r2p02),
        .packet_fifo_wfull(packet_fifo_wfull02),

    // handshake
        .Tail_p2r(Tail_p2r02),
        .Stream_p2r(Stream_p2r02),
        .Tail_r2p(Tail_r2p02),
        .Stream_r2p(Stream_r2p02),

        .Ack_p2r(Ack_p2r02),
        .CData_p2r(CData_p2r02),
        .Strobe_p2r(Strobe_p2r02),
        .State_p2r(State_p2r02),
        .Clock_p2r(Clock_p2r02),
        .Ack_r2p(Ack_r2p02),
        .CData_r2p(CData_r2p02),
        .Strobe_r2p(Strobe_r2p02),
        .State_r2p(State_r2p02),
        .Clock_r2p(clk6), 

        .Feedback_p2r(Feedback_p2r02),
        .Feedback_r2p(Feedback_r2p02),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag02),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc2)
    
        .cdata_stream_latency(cdata_stream_latency02),
        .receive_patch_num(receive_patch_num02),
        .latency_sum_circuit(latency_sum_circuit02),
        .latency_min_circuit(latency_min_circuit02),
        .latency_max_circuit(latency_max_circuit02),

        .receive_packet_patch_num(receive_packet_patch_num02),
        .receive_packet_finish_flag(receive_packet_finish_flag02),

        .error_circuit(error_circuit02),
        .error_packet(error_packet02),

        .send_packet_patch_num(send_packet_patch_num02),
        .send_patch_num(send_patch_num02),
        .req_p2r_cnt(req_p2r_cnt02),
        .req_r2p_cnt(req_r2p_cnt02),
        .ack_p2r_cnt(ack_p2r_cnt02),
        .ack_r2p_cnt(ack_r2p_cnt02)

        // .clk_test(PE_02_clk_test),
        // .clk_global_test(PE_02_clk_global_test),
        // .rst_n_test(PE_02_rst_n_test),
        // .scan_in_test(PE_02_scan_in_test),
        // .signal_test(PE_02_signal_test)
    );

    PE_all PE03(
        .ID(4'b0011),
        .clk(clk3),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r03),
        .packet_valid_p2r(packet_valid_p2r03),
        .packet_data_r2p(packet_data_r2p03),
        .packet_valid_r2p(packet_valid_r2p03),
        .packet_fifo_wfull(packet_fifo_wfull03),

    // handshake
        .Tail_p2r(Tail_p2r03),
        .Stream_p2r(Stream_p2r03),
        .Tail_r2p(Tail_r2p03),
        .Stream_r2p(Stream_r2p03),

        .Ack_p2r(Ack_p2r03),
        .CData_p2r(CData_p2r03),
        .Strobe_p2r(Strobe_p2r03),
        .State_p2r(State_p2r03),
        .Clock_p2r(Clock_p2r03),
        .Ack_r2p(Ack_r2p03),
        .CData_r2p(CData_r2p03),
        .Strobe_r2p(Strobe_r2p03),
        .State_r2p(State_r2p03),
        .Clock_r2p(clk7), 

        .Feedback_p2r(Feedback_p2r03),
        .Feedback_r2p(Feedback_r2p03),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag03),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc3)
    
        .cdata_stream_latency(cdata_stream_latency03),
        .receive_patch_num(receive_patch_num03),
        .latency_sum_circuit(latency_sum_circuit03),
        .latency_min_circuit(latency_min_circuit03),
        .latency_max_circuit(latency_max_circuit03),

        .receive_packet_patch_num(receive_packet_patch_num03),
        .receive_packet_finish_flag(receive_packet_finish_flag03),
        .error_circuit(error_circuit03),
        .error_packet(error_packet03),

        .send_packet_patch_num(send_packet_patch_num03),
        .send_patch_num(send_patch_num03),
        .req_p2r_cnt(req_p2r_cnt03),
        .req_r2p_cnt(req_r2p_cnt03),
        .ack_p2r_cnt(ack_p2r_cnt03),
        .ack_r2p_cnt(ack_r2p_cnt03)


        // .clk_test(PE_03_clk_test),
        // .clk_global_test(PE_03_clk_global_test),
        // .rst_n_test(PE_03_rst_n_test),
        // .scan_in_test(PE_03_scan_in_test),
        // .signal_test(PE_03_signal_test)
    );

    PE_all PE10(
        .ID(4'b0100),
        .clk(clk4),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r10),
        .packet_valid_p2r(packet_valid_p2r10),
        .packet_data_r2p(packet_data_r2p10),
        .packet_valid_r2p(packet_valid_r2p10),
        .packet_fifo_wfull(packet_fifo_wfull10),

    // handshake
        .Tail_p2r(Tail_p2r10),
        .Stream_p2r(Stream_p2r10),
        .Tail_r2p(Tail_r2p10),
        .Stream_r2p(Stream_r2p10),

        .Ack_p2r(Ack_p2r10),
        .CData_p2r(CData_p2r10),
        .Strobe_p2r(Strobe_p2r10),
        .State_p2r(State_p2r10),
        .Clock_p2r(Clock_p2r10),
        .Ack_r2p(Ack_r2p10),
        .CData_r2p(CData_r2p10),
        .Strobe_r2p(Strobe_r2p10),
        .State_r2p(State_r2p10),
        .Clock_r2p(clk0), 

        .Feedback_p2r(Feedback_p2r10),
        .Feedback_r2p(Feedback_r2p10),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag10),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc4)

        .cdata_stream_latency(cdata_stream_latency10),
        .receive_patch_num(receive_patch_num10),
        .latency_sum_circuit(latency_sum_circuit10),
        .latency_min_circuit(latency_min_circuit10),
        .latency_max_circuit(latency_max_circuit10),

        .receive_packet_patch_num(receive_packet_patch_num10),
        .receive_packet_finish_flag(receive_packet_finish_flag10),

        .error_circuit(error_circuit10),
        .error_packet(error_packet10),

        .send_packet_patch_num(send_packet_patch_num10),
        .send_patch_num(send_patch_num10),
        .req_p2r_cnt(req_p2r_cnt10),
        .req_r2p_cnt(req_r2p_cnt10),
        .ack_p2r_cnt(ack_p2r_cnt10),
        .ack_r2p_cnt(ack_r2p_cnt10)


        // .clk_test(PE_10_clk_test),
        // .clk_global_test(PE_10_clk_global_test),
        // .rst_n_test(PE_10_rst_n_test),
        // .scan_in_test(PE_10_scan_in_test),
        // .signal_test(PE_10_signal_test)
    );

    PE_all PE11(
        .ID(4'b0101),
        .clk(clk5),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r11),
        .packet_valid_p2r(packet_valid_p2r11),
        .packet_data_r2p(packet_data_r2p11),
        .packet_valid_r2p(packet_valid_r2p11),
        .packet_fifo_wfull(packet_fifo_wfull11),
    
    // handshake
        .Tail_p2r(Tail_p2r11),
        .Stream_p2r(Stream_p2r11),
        .Tail_r2p(Tail_r2p11),
        .Stream_r2p(Stream_r2p11),

        .Ack_p2r(Ack_p2r11),
        .CData_p2r(CData_p2r11),
        .Strobe_p2r(Strobe_p2r11),
        .State_p2r(State_p2r11),
        .Clock_p2r(Clock_p2r11),
        .Ack_r2p(Ack_r2p11),
        .CData_r2p(CData_r2p11),
        .Strobe_r2p(Strobe_r2p11),
        .State_r2p(State_r2p11),
        .Clock_r2p(clk1), 

        .Feedback_p2r(Feedback_p2r11),
        .Feedback_r2p(Feedback_r2p11),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag11),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc5)
    
        .cdata_stream_latency(cdata_stream_latency11),
        .receive_patch_num(receive_patch_num11),
        .latency_sum_circuit(latency_sum_circuit11),
        .latency_min_circuit(latency_min_circuit11),
        .latency_max_circuit(latency_max_circuit11),

        .receive_packet_patch_num(receive_packet_patch_num11),
        .receive_packet_finish_flag(receive_packet_finish_flag11),

        .error_circuit(error_circuit11),
        .error_packet(error_packet11),

        .send_packet_patch_num(send_packet_patch_num11),
        .send_patch_num(send_patch_num11),
        .req_p2r_cnt(req_p2r_cnt11),
        .req_r2p_cnt(req_r2p_cnt11),
        .ack_p2r_cnt(ack_p2r_cnt11),
        .ack_r2p_cnt(ack_r2p_cnt11)


        // .clk_test(PE_11_clk_test),
        // .clk_global_test(PE_11_clk_global_test),
        // .rst_n_test(PE_11_rst_n_test),
        // .scan_in_test(PE_11_scan_in_test),
        // .signal_test(PE_11_signal_test)
    );

    PE_all PE12(
        .ID(4'b0110),
        .clk(clk6),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r12),
        .packet_valid_p2r(packet_valid_p2r12),
        .packet_data_r2p(packet_data_r2p12),
        .packet_valid_r2p(packet_valid_r2p12),
        .packet_fifo_wfull(packet_fifo_wfull12),

        // handshake
        .Tail_p2r(Tail_p2r12),
        .Stream_p2r(Stream_p2r12),
        .Tail_r2p(Tail_r2p12),
        .Stream_r2p(Stream_r2p12),

        .Ack_p2r(Ack_p2r12),
        .CData_p2r(CData_p2r12),
        .Strobe_p2r(Strobe_p2r12),
        .State_p2r(State_p2r12),
        .Clock_p2r(Clock_p2r12),
        .Ack_r2p(Ack_r2p12),
        .CData_r2p(CData_r2p12),
        .Strobe_r2p(Strobe_r2p12),
        .State_r2p(State_r2p12),
        .Clock_r2p(clk2), 

        .Feedback_p2r(Feedback_p2r12),
        .Feedback_r2p(Feedback_r2p12),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag12),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc6)
    
        .cdata_stream_latency(cdata_stream_latency12),
        .receive_patch_num(receive_patch_num12),
        .latency_sum_circuit(latency_sum_circuit12),
        .latency_min_circuit(latency_min_circuit12),
        .latency_max_circuit(latency_max_circuit12),

        .receive_packet_patch_num(receive_packet_patch_num12),
        .receive_packet_finish_flag(receive_packet_finish_flag12),

        .error_circuit(error_circuit12),
        .error_packet(error_packet12),

        .send_packet_patch_num(send_packet_patch_num12),
        .send_patch_num(send_patch_num12),
        .req_p2r_cnt(req_p2r_cnt12),
        .req_r2p_cnt(req_r2p_cnt12),
        .ack_p2r_cnt(ack_p2r_cnt12),
        .ack_r2p_cnt(ack_r2p_cnt12)


        // .clk_test(PE_12_clk_test),
        // .clk_global_test(PE_12_clk_global_test),
        // .rst_n_test(PE_12_rst_n_test),
        // .scan_in_test(PE_12_scan_in_test),
        // .signal_test(PE_12_signal_test)
    );

    PE_all PE13(
        .ID(4'b0111),
        .clk(clk7),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r13),
        .packet_valid_p2r(packet_valid_p2r13),
        .packet_data_r2p(packet_data_r2p13),
        .packet_valid_r2p(packet_valid_r2p13),
        .packet_fifo_wfull(packet_fifo_wfull13),

        // handshake
        .Tail_p2r(Tail_p2r13),
        .Stream_p2r(Stream_p2r13),
        .Tail_r2p(Tail_r2p13),
        .Stream_r2p(Stream_r2p13),

        .Ack_p2r(Ack_p2r13),
        .CData_p2r(CData_p2r13),
        .Strobe_p2r(Strobe_p2r13),
        .State_p2r(State_p2r13),
        .Clock_p2r(Clock_p2r13),
        .Ack_r2p(Ack_r2p13),
        .CData_r2p(CData_r2p13),
        .Strobe_r2p(Strobe_r2p13),
        .State_r2p(State_r2p13),
        .Clock_r2p(clk3), 

        .Feedback_p2r(Feedback_p2r13),
        .Feedback_r2p(Feedback_r2p13),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag13),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc7)
    
        .cdata_stream_latency(cdata_stream_latency13),
        .receive_patch_num(receive_patch_num13),
        .latency_sum_circuit(latency_sum_circuit13),
        .latency_min_circuit(latency_min_circuit13),
        .latency_max_circuit(latency_max_circuit13),


        .receive_packet_patch_num(receive_packet_patch_num13),
        .receive_packet_finish_flag(receive_packet_finish_flag13),

        .error_circuit(error_circuit13),
        .error_packet(error_packet13),

        .send_packet_patch_num(send_packet_patch_num13),
        .send_patch_num(send_patch_num13),
        .req_p2r_cnt(req_p2r_cnt13),
        .req_r2p_cnt(req_r2p_cnt13),
        .ack_p2r_cnt(ack_p2r_cnt13),
        .ack_r2p_cnt(ack_r2p_cnt13)


        // .clk_test(PE_13_clk_test),
        // .clk_global_test(PE_13_clk_global_test),
        // .rst_n_test(PE_13_rst_n_test),
        // .scan_in_test(PE_13_scan_in_test),
        // .signal_test(PE_13_signal_test)
    );

    PE_all PE20(
        .ID(4'b1000),
        .clk(clk8),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r20),
        .packet_valid_p2r(packet_valid_p2r20),
        .packet_data_r2p(packet_data_r2p20),
        .packet_valid_r2p(packet_valid_r2p20),
        .packet_fifo_wfull(packet_fifo_wfull20),

        // handshake
        .Tail_p2r(Tail_p2r20),
        .Stream_p2r(Stream_p2r20),
        .Tail_r2p(Tail_r2p20),
        .Stream_r2p(Stream_r2p20),

        .Ack_p2r(Ack_p2r20),
        .CData_p2r(CData_p2r20),
        .Strobe_p2r(Strobe_p2r20),
        .State_p2r(State_p2r20),
        .Clock_p2r(Clock_p2r20),
        .Ack_r2p(Ack_r2p20),
        .CData_r2p(CData_r2p20),
        .Strobe_r2p(Strobe_r2p20),
        .State_r2p(State_r2p20),
        .Clock_r2p(clk12), 

        .Feedback_p2r(Feedback_p2r20),
        .Feedback_r2p(Feedback_r2p20),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag20),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc8)
    
        .cdata_stream_latency(cdata_stream_latency20),
        .receive_patch_num(receive_patch_num20),
        .latency_sum_circuit(latency_sum_circuit20),
        .latency_min_circuit(latency_min_circuit20),
        .latency_max_circuit(latency_max_circuit20),


        .receive_packet_patch_num(receive_packet_patch_num20),
        .receive_packet_finish_flag(receive_packet_finish_flag20),

        .error_circuit(error_circuit20),
        .error_packet(error_packet20),

        .send_packet_patch_num(send_packet_patch_num20),
        .send_patch_num(send_patch_num20),
        .req_p2r_cnt(req_p2r_cnt20),
        .req_r2p_cnt(req_r2p_cnt20),
        .ack_p2r_cnt(ack_p2r_cnt20),
        .ack_r2p_cnt(ack_r2p_cnt20)


        // .clk_test(PE_20_clk_test),
        // .clk_global_test(PE_20_clk_global_test),
        // .rst_n_test(PE_20_rst_n_test),
        // .scan_in_test(PE_20_scan_in_test),
        // .signal_test(PE_20_signal_test)
    );

    PE_all PE21(
        .ID(4'b1001),
        .clk(clk9),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r21),
        .packet_valid_p2r(packet_valid_p2r21),
        .packet_data_r2p(packet_data_r2p21),
        .packet_valid_r2p(packet_valid_r2p21),
        .packet_fifo_wfull(packet_fifo_wfull21),

    // handshake
        .Tail_p2r(Tail_p2r21),
        .Stream_p2r(Stream_p2r21),
        .Tail_r2p(Tail_r2p21),
        .Stream_r2p(Stream_r2p21),

        .Ack_p2r(Ack_p2r21),
        .CData_p2r(CData_p2r21),
        .Strobe_p2r(Strobe_p2r21),
        .State_p2r(State_p2r21),
        .Clock_p2r(Clock_p2r21),
        .Ack_r2p(Ack_r2p21),
        .CData_r2p(CData_r2p21),
        .Strobe_r2p(Strobe_r2p21),
        .State_r2p(State_r2p21),
        .Clock_r2p(clk13), 

        .Feedback_p2r(Feedback_p2r21),
        .Feedback_r2p(Feedback_r2p21),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag21),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc9)
    
        .cdata_stream_latency(cdata_stream_latency21),
        .receive_patch_num(receive_patch_num21),
        .latency_sum_circuit(latency_sum_circuit21),
        .latency_min_circuit(latency_min_circuit21),
        .latency_max_circuit(latency_max_circuit21),

        .receive_packet_patch_num(receive_packet_patch_num21),
        .receive_packet_finish_flag(receive_packet_finish_flag21),

        .error_circuit(error_circuit21),
        .error_packet(error_packet21),

        .send_packet_patch_num(send_packet_patch_num21),
        .send_patch_num(send_patch_num21),
        .req_p2r_cnt(req_p2r_cnt21),
        .req_r2p_cnt(req_r2p_cnt21),
        .ack_p2r_cnt(ack_p2r_cnt21),
        .ack_r2p_cnt(ack_r2p_cnt21)


        // .clk_test(PE_21_clk_test),
        // .clk_global_test(PE_21_clk_global_test),
        // .rst_n_test(PE_21_rst_n_test),
        // .scan_in_test(PE_21_scan_in_test),
        // .signal_test(PE_21_signal_test)
    );

    PE_all PE22(
        .ID(4'b1010),
        .clk(clk10),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r22),
        .packet_valid_p2r(packet_valid_p2r22),
        .packet_data_r2p(packet_data_r2p22),
        .packet_valid_r2p(packet_valid_r2p22),
        .packet_fifo_wfull(packet_fifo_wfull22),

    // handshake
        .Tail_p2r(Tail_p2r22),
        .Stream_p2r(Stream_p2r22),
        .Tail_r2p(Tail_r2p22),
        .Stream_r2p(Stream_r2p22),

        .Ack_p2r(Ack_p2r22),
        .CData_p2r(CData_p2r22),
        .Strobe_p2r(Strobe_p2r22),
        .State_p2r(State_p2r22),
        .Clock_p2r(Clock_p2r22),
        .Ack_r2p(Ack_r2p22),
        .CData_r2p(CData_r2p22),
        .Strobe_r2p(Strobe_r2p22),
        .State_r2p(State_r2p22),
        .Clock_r2p(clk14), 

        .Feedback_p2r(Feedback_p2r22),
        .Feedback_r2p(Feedback_r2p22),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag22),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc10)
    
        .cdata_stream_latency(cdata_stream_latency22),
        .receive_patch_num(receive_patch_num22),
        .latency_sum_circuit(latency_sum_circuit22),
        .latency_min_circuit(latency_min_circuit22),
        .latency_max_circuit(latency_max_circuit22),


        .receive_packet_patch_num(receive_packet_patch_num22),
        .receive_packet_finish_flag(receive_packet_finish_flag22),

        .error_circuit(error_circuit22),
        .error_packet(error_packet22),

        .send_packet_patch_num(send_packet_patch_num22),
        .send_patch_num(send_patch_num22),
        .req_p2r_cnt(req_p2r_cnt22),
        .req_r2p_cnt(req_r2p_cnt22),
        .ack_p2r_cnt(ack_p2r_cnt22),
        .ack_r2p_cnt(ack_r2p_cnt22)


        // .clk_test(PE_22_clk_test),
        // .clk_global_test(PE_22_clk_global_test),
        // .rst_n_test(PE_22_rst_n_test),
        // .scan_in_test(PE_22_scan_in_test),
        // .signal_test(PE_22_signal_test)
    );

    PE_all PE23(
        .ID(4'b1011),
        .clk(clk11),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r23),
        .packet_valid_p2r(packet_valid_p2r23),
        .packet_data_r2p(packet_data_r2p23),
        .packet_valid_r2p(packet_valid_r2p23),
        .packet_fifo_wfull(packet_fifo_wfull23),

    // handshake
        .Tail_p2r(Tail_p2r23),
        .Stream_p2r(Stream_p2r23),
        .Tail_r2p(Tail_r2p23),
        .Stream_r2p(Stream_r2p23),

        .Ack_p2r(Ack_p2r23),
        .CData_p2r(CData_p2r23),
        .Strobe_p2r(Strobe_p2r23),
        .State_p2r(State_p2r23),
        .Clock_p2r(Clock_p2r23),
        .Ack_r2p(Ack_r2p23),
        .CData_r2p(CData_r2p23),
        .Strobe_r2p(Strobe_r2p23),
        .State_r2p(State_r2p23),
        .Clock_r2p(clk15), 

        .Feedback_p2r(Feedback_p2r23),
        .Feedback_r2p(Feedback_r2p23),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag23),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc11)
    
        .cdata_stream_latency(cdata_stream_latency23),
        .receive_patch_num(receive_patch_num23),
        .latency_sum_circuit(latency_sum_circuit23),
        .latency_min_circuit(latency_min_circuit23),
        .latency_max_circuit(latency_max_circuit23),

        .receive_packet_patch_num(receive_packet_patch_num23),
        .receive_packet_finish_flag(receive_packet_finish_flag23),

        .error_circuit(error_circuit23),
        .error_packet(error_packet23),

        .send_packet_patch_num(send_packet_patch_num23),
        .send_patch_num(send_patch_num23),
        .req_p2r_cnt(req_p2r_cnt23),
        .req_r2p_cnt(req_r2p_cnt23),
        .ack_p2r_cnt(ack_p2r_cnt23),
        .ack_r2p_cnt(ack_r2p_cnt23)


        // .clk_test(PE_23_clk_test),
        // .clk_global_test(PE_23_clk_global_test),
        // .rst_n_test(PE_23_rst_n_test),
        // .scan_in_test(PE_23_scan_in_test),
        // .signal_test(PE_23_signal_test)
    );

    PE_all PE30(
        .ID(4'b1100),
        .clk(clk12),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r30),
        .packet_valid_p2r(packet_valid_p2r30),
        .packet_data_r2p(packet_data_r2p30),
        .packet_valid_r2p(packet_valid_r2p30),
        .packet_fifo_wfull(packet_fifo_wfull30),

    // handshake
        .Tail_p2r(Tail_p2r30),
        .Stream_p2r(Stream_p2r30),
        .Tail_r2p(Tail_r2p30),
        .Stream_r2p(Stream_r2p30),

        .Ack_p2r(Ack_p2r30),
        .CData_p2r(CData_p2r30),
        .Strobe_p2r(Strobe_p2r30),
        .State_p2r(State_p2r30),
        .Clock_p2r(Clock_p2r30),
        .Ack_r2p(Ack_r2p30),
        .CData_r2p(CData_r2p30),
        .Strobe_r2p(Strobe_r2p30),
        .State_r2p(State_r2p30),
        .Clock_r2p(clk8), 

        .Feedback_p2r(Feedback_p2r30),
        .Feedback_r2p(Feedback_r2p30),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag30),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc12)
    
        .cdata_stream_latency(cdata_stream_latency30),
        .receive_patch_num(receive_patch_num30),
        .latency_sum_circuit(latency_sum_circuit30),
        .latency_min_circuit(latency_min_circuit30),
        .latency_max_circuit(latency_max_circuit30),

        .receive_packet_patch_num(receive_packet_patch_num30),
        .receive_packet_finish_flag(receive_packet_finish_flag30),

        .error_circuit(error_circuit30),
        .error_packet(error_packet30),

        .send_packet_patch_num(send_packet_patch_num30),
        .send_patch_num(send_patch_num30),
        .req_p2r_cnt(req_p2r_cnt30),
        .req_r2p_cnt(req_r2p_cnt30),
        .ack_p2r_cnt(ack_p2r_cnt30),
        .ack_r2p_cnt(ack_r2p_cnt30)


        // .clk_test(PE_30_clk_test),
        // .clk_global_test(PE_30_clk_global_test),
        // .rst_n_test(PE_30_rst_n_test),
        // .scan_in_test(PE_30_scan_in_test),
        // .signal_test(PE_30_signal_test)
    );

    PE_all PE31(
        .ID(4'b1101),
        .clk(clk13),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r31),
        .packet_valid_p2r(packet_valid_p2r31),
        .packet_data_r2p(packet_data_r2p31),
        .packet_valid_r2p(packet_valid_r2p31),
        .packet_fifo_wfull(packet_fifo_wfull31),

        // handshake
        .Tail_p2r(Tail_p2r31),
        .Stream_p2r(Stream_p2r31),
        .Tail_r2p(Tail_r2p31),
        .Stream_r2p(Stream_r2p31),

        .Ack_p2r(Ack_p2r31),
        .CData_p2r(CData_p2r31),
        .Strobe_p2r(Strobe_p2r31),
        .State_p2r(State_p2r31),
        .Clock_p2r(Clock_p2r31),
        .Ack_r2p(Ack_r2p31),
        .CData_r2p(CData_r2p31),
        .Strobe_r2p(Strobe_r2p31),
        .State_r2p(State_r2p31),
        .Clock_r2p(clk9), 

        .Feedback_p2r(Feedback_p2r31),
        .Feedback_r2p(Feedback_r2p31),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag31),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc13)
    
        .cdata_stream_latency(cdata_stream_latency31),
        .receive_patch_num(receive_patch_num31),
        .latency_sum_circuit(latency_sum_circuit31),
        .latency_min_circuit(latency_min_circuit31),
        .latency_max_circuit(latency_max_circuit31),

        .receive_packet_patch_num(receive_packet_patch_num31),
        .receive_packet_finish_flag(receive_packet_finish_flag31),

        .error_circuit(error_circuit31),
        .error_packet(error_packet31),

        .send_packet_patch_num(send_packet_patch_num31),
        .send_patch_num(send_patch_num31),
        .req_p2r_cnt(req_p2r_cnt31),
        .req_r2p_cnt(req_r2p_cnt31),
        .ack_p2r_cnt(ack_p2r_cnt31),
        .ack_r2p_cnt(ack_r2p_cnt31)


        // .clk_test(PE_31_clk_test),
        // .clk_global_test(PE_31_clk_global_test),
        // .rst_n_test(PE_31_rst_n_test),
        // .scan_in_test(PE_31_scan_in_test),
        // .signal_test(PE_31_signal_test)
    );

    PE_all PE32(
        .ID(4'b1110),
        .clk(clk14),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r32),
        .packet_valid_p2r(packet_valid_p2r32),
        .packet_data_r2p(packet_data_r2p32),
        .packet_valid_r2p(packet_valid_r2p32),
        .packet_fifo_wfull(packet_fifo_wfull32),

        // handshake
        .Tail_p2r(Tail_p2r32),
        .Stream_p2r(Stream_p2r32),
        .Tail_r2p(Tail_r2p32),
        .Stream_r2p(Stream_r2p32),

        .Ack_p2r(Ack_p2r32),
        .CData_p2r(CData_p2r32),
        .Strobe_p2r(Strobe_p2r32),
        .State_p2r(State_p2r32),
        .Clock_p2r(Clock_p2r32),
        .Ack_r2p(Ack_r2p32),
        .CData_r2p(CData_r2p32),
        .Strobe_r2p(Strobe_r2p32),
        .State_r2p(State_r2p32),
        .Clock_r2p(clk10), 

        .Feedback_p2r(Feedback_p2r32),
        .Feedback_r2p(Feedback_r2p32),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag32),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc14)
    
        .cdata_stream_latency(cdata_stream_latency32),
        .receive_patch_num(receive_patch_num32),
        .latency_sum_circuit(latency_sum_circuit32),
        .latency_min_circuit(latency_min_circuit32),
        .latency_max_circuit(latency_max_circuit32),

        .receive_packet_patch_num(receive_packet_patch_num32),
        .receive_packet_finish_flag(receive_packet_finish_flag32),

        .error_circuit(error_circuit32),
        .error_packet(error_packet32),

        .send_packet_patch_num(send_packet_patch_num32),
        .send_patch_num(send_patch_num32),
        .req_p2r_cnt(req_p2r_cnt32),
        .req_r2p_cnt(req_r2p_cnt32),
        .ack_p2r_cnt(ack_p2r_cnt32),
        .ack_r2p_cnt(ack_r2p_cnt32)


        // .clk_test(PE_32_clk_test),
        // .clk_global_test(PE_32_clk_global_test),
        // .rst_n_test(PE_32_rst_n_test),
        // .scan_in_test(PE_32_scan_in_test),
        // .signal_test(PE_32_signal_test)
    );

    PE_all PE33(
        .ID(4'b1111),
        .clk(clk15),
         //.clk_global(clk_global),
        .rst_n(rst_n),
        // .rst_n1(rst_n1),
        // .rst_n2(rst_n2),
        // .rst_n3(rst_n3),
        // .pe_verify(pe_verify_sel[4]),

        .enable_wire(enable_global),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(hotpot_target),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),

        .packet_data_p2r(packet_data_p2r33),
        .packet_valid_p2r(packet_valid_p2r33),
        .packet_data_r2p(packet_data_r2p33),
        .packet_valid_r2p(packet_valid_r2p33),
        .packet_fifo_wfull(packet_fifo_wfull33),

        // handshake
        .Tail_p2r(Tail_p2r33),
        .Stream_p2r(Stream_p2r33),
        .Tail_r2p(Tail_r2p33),
        .Stream_r2p(Stream_r2p33),

        .Ack_p2r(Ack_p2r33),
        .CData_p2r(CData_p2r33),
        .Strobe_p2r(Strobe_p2r33),
        .State_p2r(State_p2r33),
        .Clock_p2r(Clock_p2r33),
        .Ack_r2p(Ack_r2p33),
        .CData_r2p(CData_r2p33),
        .Strobe_r2p(Strobe_r2p33),
        .State_r2p(State_r2p33),
        .Clock_r2p(clk11), 

        .Feedback_p2r(Feedback_p2r33),
        .Feedback_r2p(Feedback_r2p33),

        .dvfs_config(dvfs_config),
        .Stream_Length(Stream_Length),
        .receive_finish_flag(receive_finish_flag33),
        .time_stamp_global(time_stamp_local[15:0]),
        // .rinc(rinc15)
    
        .cdata_stream_latency(cdata_stream_latency33),
        .receive_patch_num(receive_patch_num33),
        .latency_sum_circuit(latency_sum_circuit33),
        .latency_min_circuit(latency_min_circuit33),
        .latency_max_circuit(latency_max_circuit33),

        .receive_packet_patch_num(receive_packet_patch_num33),
        .receive_packet_finish_flag(receive_packet_finish_flag33),

        .error_circuit(error_circuit33),
        .error_packet(error_packet33),

        .send_packet_patch_num(send_packet_patch_num33),
        .send_patch_num(send_patch_num33),
        .req_p2r_cnt(req_p2r_cnt33),
        .req_r2p_cnt(req_r2p_cnt33),
        .ack_p2r_cnt(ack_p2r_cnt33),
        .ack_r2p_cnt(ack_r2p_cnt33)


        // .clk_test(PE_33_clk_test),
        // .clk_global_test(PE_33_clk_global_test),
        // .rst_n_test(PE_33_rst_n_test),
        // .scan_in_test(PE_33_scan_in_test),
        // .signal_test(PE_33_signal_test)
    );



    Router Router11(
        .ID(4'b0101),
        .rst_n(rst_n),
        
        
        .clk(clk5),
        .clk_W(clk4),
        .clk_N(clk1),
        .clk_E(clk6),
        .clk_S(clk9),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r11),
        .W_packet_data_in(E_packet_data_out10),
        .N_packet_data_in(S_packet_data_out01),
        .E_packet_data_in(W_packet_data_out12),
        .S_packet_data_in(N_packet_data_out21),
        .L_packet_valid_in(packet_valid_p2r11),
        .W_packet_valid_in(E_packet_valid_out10),
        .N_packet_valid_in(S_packet_valid_out01),
        .E_packet_valid_in(W_packet_valid_out12),
        .S_packet_valid_in(N_packet_valid_out21),
        .W_packet_full_in(E_packet_full_out10),
        .N_packet_full_in(S_packet_full_out01),
        .E_packet_full_in(W_packet_full_out12),
        .S_packet_full_in(N_packet_full_out21),

        .L_packet_data_out(packet_data_r2p11),
        .W_packet_data_out(W_packet_data_out11),
        .N_packet_data_out(N_packet_data_out11),
        .E_packet_data_out(E_packet_data_out11),
        .S_packet_data_out(S_packet_data_out11),
        .L_packet_valid_out(packet_valid_r2p11),
        .W_packet_valid_out(W_packet_valid_out11),
        .N_packet_valid_out(N_packet_valid_out11),
        .E_packet_valid_out(E_packet_valid_out11),
        .S_packet_valid_out(S_packet_valid_out11),
        .L_packet_full_out(packet_fifo_wfull11),
        .W_packet_full_out(W_packet_full_out11),
        .N_packet_full_out(N_packet_full_out11),
        .E_packet_full_out(E_packet_full_out11),
        .S_packet_full_out(S_packet_full_out11),

        .Tail4(Tail_p2r11),
        .Tail3(E_Tail_out10),
        .Tail2(S_Tail_out01),
        .Tail1(W_Tail_out12),
        .Tail0(N_Tail_out21),
        .Stream4(Stream_p2r11),
        .Stream3(E_Stream_out10),
        .Stream2(S_Stream_out01),
        .Stream1(W_Stream_out12),
        .Stream0(N_Stream_out21),
        .Ack4(Ack_p2r11),
        .Ack3(E_Ack_Out_10),
        .Ack2(S_Ack_Out_01),
        .Ack1(W_Ack_Out_12),
        .Ack0(N_Ack_Out_21),
        .CData4(CData_p2r11),
        .CData3(E_CData_Out_10),
        .CData2(S_CData_Out_01),
        .CData1(W_CData_Out_12),
        .CData0(N_CData_Out_21),
        .Strobe4(Strobe_p2r11),
        .Strobe3(E_Strobe_Out_10),
        .Strobe2(S_Strobe_Out_01),
        .Strobe1(W_Strobe_Out_12),
        .Strobe0(N_Strobe_Out_21),
        .State4(State_p2r11),
        .State3(E_State_Out_10),
        .State2(S_State_Out_01),
        .State1(W_State_Out_12),
        .State0(N_State_Out_21),
        // .Clock4(Clock_p2r11),
        // .Clock3(E_Clock_Out_10),
        // .Clock2(S_Clock_Out_01),
        // .Clock1(W_Clock_Out_12),
        // .Clock0(N_Clock_Out_21),
        .Feedback4(Feedback_p2r11),
        .Feedback3(E_Feedback_Out_10),
        .Feedback2(S_Feedback_Out_01),
        .Feedback1(W_Feedback_Out_12),
        .Feedback0(N_Feedback_Out_21),
        .Tail_Out4(Tail_r2p11),
        .Tail_Out3(W_Tail_out11),
        .Tail_Out2(N_Tail_out11),
        .Tail_Out1(E_Tail_out11),
        .Tail_Out0(S_Tail_out11),
        .Stream_Out4(Stream_r2p11),
        .Stream_Out3(W_Stream_out11),
        .Stream_Out2(N_Stream_out11),
        .Stream_Out1(E_Stream_out11),
        .Stream_Out0(S_Stream_out11),
        .Ack_Out4(Ack_r2p11),    
        .Ack_Out3(W_Ack_Out_11),    
        .Ack_Out2(N_Ack_Out_11),    
        .Ack_Out1(E_Ack_Out_11),   
        .Ack_Out0(S_Ack_Out_11),    
        .CData_Out4(CData_r2p11),
        .CData_Out3(W_CData_Out_11),
        .CData_Out2(N_CData_Out_11),
        .CData_Out1(E_CData_Out_11),
        .CData_Out0(S_CData_Out_11),
        .Strobe_Out4(Strobe_r2p11),
        .Strobe_Out3(W_Strobe_Out_11),
        .Strobe_Out2(N_Strobe_Out_11),
        .Strobe_Out1(E_Strobe_Out_11), 
        .Strobe_Out0(S_Strobe_Out_11),
        .State_Out4(State_r2p11),
        .State_Out3(W_State_Out_11),
        .State_Out2(N_State_Out_11),
        .State_Out1(E_State_Out_11),
        .State_Out0(S_State_Out_11),
        // .Clock_Out4(Clock_r2p11),
        // .Clock_Out3(W_Clock_Out_11),
        // .Clock_Out2(N_Clock_Out_11),
        // .Clock_Out1(E_Clock_Out_11),
        // .Clock_Out0(S_Clock_Out_11),
        .Feedback_Out4(Feedback_r2p11),
        .Feedback_Out3(W_Feedback_Out_11),
        .Feedback_Out2(N_Feedback_Out_11),
        .Feedback_Out1(E_Feedback_Out_11),
        .Feedback_Out0(S_Feedback_Out_11)
    );

    Router Router12(
        .ID(4'b0110),
        .rst_n(rst_n),
        
        
        .clk(clk6),
        .clk_W(clk5),
        .clk_N(clk2),
        .clk_E(clk7),
        .clk_S(clk10),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r12),
        .W_packet_data_in(E_packet_data_out11),
        .N_packet_data_in(S_packet_data_out02),
        .E_packet_data_in(W_packet_data_out13),
        .S_packet_data_in(N_packet_data_out22),

        .L_packet_valid_in(packet_valid_p2r12),
        .W_packet_valid_in(E_packet_valid_out11),
        .N_packet_valid_in(S_packet_valid_out02),
        .E_packet_valid_in(W_packet_valid_out13),
        .S_packet_valid_in(N_packet_valid_out22),

        .W_packet_full_in(E_packet_full_out11),
        .N_packet_full_in(S_packet_full_out02),
        .E_packet_full_in(W_packet_full_out13),
        .S_packet_full_in(N_packet_full_out22),

        .L_packet_data_out(packet_data_r2p12),
        .W_packet_data_out(W_packet_data_out12),
        .N_packet_data_out(N_packet_data_out12),
        .E_packet_data_out(E_packet_data_out12),
        .S_packet_data_out(S_packet_data_out12),

        .L_packet_valid_out(packet_valid_r2p12),
        .W_packet_valid_out(W_packet_valid_out12),
        .N_packet_valid_out(N_packet_valid_out12),
        .E_packet_valid_out(E_packet_valid_out12),
        .S_packet_valid_out(S_packet_valid_out12),
        
        .L_packet_full_out(packet_fifo_wfull12),
        .W_packet_full_out(W_packet_full_out12),
        .N_packet_full_out(N_packet_full_out12),
        .E_packet_full_out(E_packet_full_out12),
        .S_packet_full_out(S_packet_full_out12),

        .Tail4(Tail_p2r12),
        .Tail3(E_Tail_out11),
        .Tail2(S_Tail_out02),
        .Tail1(W_Tail_out13),
        .Tail0(N_Tail_out22),
        .Stream4(Stream_p2r12),
        .Stream3(E_Stream_out11),
        .Stream2(S_Stream_out02),
        .Stream1(W_Stream_out13),
        .Stream0(N_Stream_out22),
        .Ack4(Ack_p2r12),
        .Ack3(E_Ack_Out_11),
        .Ack2(S_Ack_Out_02),
        .Ack1(W_Ack_Out_13),
        .Ack0(N_Ack_Out_22),
        .CData4(CData_p2r12),
        .CData3(E_CData_Out_11),
        .CData2(S_CData_Out_02),
        .CData1(W_CData_Out_13),
        .CData0(N_CData_Out_22),
        .Strobe4(Strobe_p2r12),
        .Strobe3(E_Strobe_Out_11),
        .Strobe2(S_Strobe_Out_02),
        .Strobe1(W_Strobe_Out_13),
        .Strobe0(N_Strobe_Out_22),
        .State4(State_p2r12),
        .State3(E_State_Out_11),
        .State2(S_State_Out_02),
        .State1(W_State_Out_13),
        .State0(N_State_Out_22),
        // .Clock4(Clock_p2r12),
        // .Clock3(E_Clock_Out_11),
        // .Clock2(S_Clock_Out_02),
        // .Clock1(W_Clock_Out_13),
        // .Clock0(N_Clock_Out_22),
        .Feedback4(Feedback_p2r12),
        .Feedback3(E_Feedback_Out_11),
        .Feedback2(S_Feedback_Out_02),
        .Feedback1(W_Feedback_Out_13),
        .Feedback0(N_Feedback_Out_22),
        .Tail_Out4(Tail_r2p12),
        .Tail_Out3(W_Tail_out12),
        .Tail_Out2(N_Tail_out12),
        .Tail_Out1(E_Tail_out12),
        .Tail_Out0(S_Tail_out12),
        .Stream_Out4(Stream_r2p12),
        .Stream_Out3(W_Stream_out12),
        .Stream_Out2(N_Stream_out12),
        .Stream_Out1(E_Stream_out12),
        .Stream_Out0(S_Stream_out12),
        .Ack_Out4(Ack_r2p12),    
        .Ack_Out3(W_Ack_Out_12),    
        .Ack_Out2(N_Ack_Out_12),    
        .Ack_Out1(E_Ack_Out_12),   
        .Ack_Out0(S_Ack_Out_12),    
        .CData_Out4(CData_r2p12),
        .CData_Out3(W_CData_Out_12),
        .CData_Out2(N_CData_Out_12),
        .CData_Out1(E_CData_Out_12),
        .CData_Out0(S_CData_Out_12),
        .Strobe_Out4(Strobe_r2p12),
        .Strobe_Out3(W_Strobe_Out_12),
        .Strobe_Out2(N_Strobe_Out_12),
        .Strobe_Out1(E_Strobe_Out_12), 
        .Strobe_Out0(S_Strobe_Out_12),
        .State_Out4(State_r2p12),
        .State_Out3(W_State_Out_12),
        .State_Out2(N_State_Out_12),
        .State_Out1(E_State_Out_12),
        .State_Out0(S_State_Out_12),
        // .Clock_Out4(Clock_r2p12),
        // .Clock_Out3(W_Clock_Out_12),
        // .Clock_Out2(N_Clock_Out_12),
        // .Clock_Out1(E_Clock_Out_12),
        // .Clock_Out0(S_Clock_Out_12),
        .Feedback_Out4(Feedback_r2p12),
        .Feedback_Out3(W_Feedback_Out_12),
        .Feedback_Out2(N_Feedback_Out_12),
        .Feedback_Out1(E_Feedback_Out_12),
        .Feedback_Out0(S_Feedback_Out_12)
    );

    Router Router21(
        .ID(4'b1001),
        .rst_n(rst_n),
        
        
        .clk(clk9),
        .clk_W(clk8),
        .clk_N(clk5),
        .clk_E(clk10),
        .clk_S(clk13),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r21),
        .W_packet_data_in(E_packet_data_out20),
        .N_packet_data_in(S_packet_data_out11),
        .E_packet_data_in(W_packet_data_out22),
        .S_packet_data_in(N_packet_data_out31),

        .L_packet_valid_in(packet_valid_p2r21),
        .W_packet_valid_in(E_packet_valid_out20),
        .N_packet_valid_in(S_packet_valid_out11),
        .E_packet_valid_in(W_packet_valid_out22),
        .S_packet_valid_in(N_packet_valid_out31),

        .W_packet_full_in(E_packet_full_out20),
        .N_packet_full_in(S_packet_full_out11),
        .E_packet_full_in(W_packet_full_out22),
        .S_packet_full_in(N_packet_full_out31),

        .L_packet_data_out(packet_data_r2p21),
        .W_packet_data_out(W_packet_data_out21),
        .N_packet_data_out(N_packet_data_out21),
        .E_packet_data_out(E_packet_data_out21),
        .S_packet_data_out(S_packet_data_out21),

        .L_packet_valid_out(packet_valid_r2p21),
        .W_packet_valid_out(W_packet_valid_out21),
        .N_packet_valid_out(N_packet_valid_out21),
        .E_packet_valid_out(E_packet_valid_out21),
        .S_packet_valid_out(S_packet_valid_out21),
        
        .L_packet_full_out(packet_fifo_wfull21),
        .W_packet_full_out(W_packet_full_out21),
        .N_packet_full_out(N_packet_full_out21),
        .E_packet_full_out(E_packet_full_out21),
        .S_packet_full_out(S_packet_full_out21),
        .Tail4(Tail_p2r21),
        .Tail3(E_Tail_out20),
        .Tail2(S_Tail_out11),
        .Tail1(W_Tail_out22),
        .Tail0(N_Tail_out31),
        .Stream4(Stream_p2r21),
        .Stream3(E_Stream_out20),
        .Stream2(S_Stream_out11),
        .Stream1(W_Stream_out22),
        .Stream0(N_Stream_out31),
        .Ack4(Ack_p2r21),
        .Ack3(E_Ack_Out_20),
        .Ack2(S_Ack_Out_11),
        .Ack1(W_Ack_Out_22),
        .Ack0(N_Ack_Out_31),
        .CData4(CData_p2r21),
        .CData3(E_CData_Out_20),
        .CData2(S_CData_Out_11),
        .CData1(W_CData_Out_22),
        .CData0(N_CData_Out_31),
        .Strobe4(Strobe_p2r21),
        .Strobe3(E_Strobe_Out_20),
        .Strobe2(S_Strobe_Out_11),
        .Strobe1(W_Strobe_Out_22),
        .Strobe0(N_Strobe_Out_31),
        .State4(State_p2r21),
        .State3(E_State_Out_20),
        .State2(S_State_Out_11),
        .State1(W_State_Out_22),
        .State0(N_State_Out_31),
        // .Clock4(Clock_p2r21),
        // .Clock3(E_Clock_Out_20),
        // .Clock2(S_Clock_Out_11),
        // .Clock1(W_Clock_Out_22),
        // .Clock0(N_Clock_Out_31),
        .Feedback4(Feedback_p2r21),
        .Feedback3(E_Feedback_Out_20),
        .Feedback2(S_Feedback_Out_11),
        .Feedback1(W_Feedback_Out_22),
        .Feedback0(N_Feedback_Out_31),
        .Tail_Out4(Tail_r2p21),
        .Tail_Out3(W_Tail_out21),
        .Tail_Out2(N_Tail_out21),
        .Tail_Out1(E_Tail_out21),
        .Tail_Out0(S_Tail_out21),
        .Stream_Out4(Stream_r2p21),
        .Stream_Out3(W_Stream_out21),
        .Stream_Out2(N_Stream_out21),
        .Stream_Out1(E_Stream_out21),
        .Stream_Out0(S_Stream_out21),
        .Ack_Out4(Ack_r2p21),    
        .Ack_Out3(W_Ack_Out_21),    
        .Ack_Out2(N_Ack_Out_21),    
        .Ack_Out1(E_Ack_Out_21),   
        .Ack_Out0(S_Ack_Out_21),    
        .CData_Out4(CData_r2p21),
        .CData_Out3(W_CData_Out_21),
        .CData_Out2(N_CData_Out_21),
        .CData_Out1(E_CData_Out_21),
        .CData_Out0(S_CData_Out_21),
        .Strobe_Out4(Strobe_r2p21),
        .Strobe_Out3(W_Strobe_Out_21),
        .Strobe_Out2(N_Strobe_Out_21),
        .Strobe_Out1(E_Strobe_Out_21), 
        .Strobe_Out0(S_Strobe_Out_21),
        .State_Out4(State_r2p21),
        .State_Out3(W_State_Out_21),
        .State_Out2(N_State_Out_21),
        .State_Out1(E_State_Out_21),
        .State_Out0(S_State_Out_21),
        //.Clock_Out4(Clock_r2p21),
        //.Clock_Out3(W_Clock_Out_21),
        //.Clock_Out2(N_Clock_Out_21),
        //.Clock_Out1(E_Clock_Out_21),
        //.Clock_Out0(S_Clock_Out_21),
        .Feedback_Out4(Feedback_r2p21),
        .Feedback_Out3(W_Feedback_Out_21),
        .Feedback_Out2(N_Feedback_Out_21),
        .Feedback_Out1(E_Feedback_Out_21),
        .Feedback_Out0(S_Feedback_Out_21)
    );

    Router Router22(
        .ID(4'b1010),
        .rst_n(rst_n),
        
        
        .clk(clk10),
        .clk_W(clk9),
        .clk_N(clk6),
        .clk_E(clk11),
        .clk_S(clk14),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r22),
        .W_packet_data_in(E_packet_data_out21),
        .N_packet_data_in(S_packet_data_out12),
        .E_packet_data_in(W_packet_data_out23),
        .S_packet_data_in(N_packet_data_out32),

        .L_packet_valid_in(packet_valid_p2r22),
        .W_packet_valid_in(E_packet_valid_out21),
        .N_packet_valid_in(S_packet_valid_out12),
        .E_packet_valid_in(W_packet_valid_out23),
        .S_packet_valid_in(N_packet_valid_out32),

        .W_packet_full_in(E_packet_full_out21),
        .N_packet_full_in(S_packet_full_out12),
        .E_packet_full_in(W_packet_full_out23),
        .S_packet_full_in(N_packet_full_out32),

        .L_packet_data_out(packet_data_r2p22),
        .W_packet_data_out(W_packet_data_out22),
        .N_packet_data_out(N_packet_data_out22),
        .E_packet_data_out(E_packet_data_out22),
        .S_packet_data_out(S_packet_data_out22),

        .L_packet_valid_out(packet_valid_r2p22),
        .W_packet_valid_out(W_packet_valid_out22),
        .N_packet_valid_out(N_packet_valid_out22),
        .E_packet_valid_out(E_packet_valid_out22),
        .S_packet_valid_out(S_packet_valid_out22),
        
        .L_packet_full_out(packet_fifo_wfull22),
        .W_packet_full_out(W_packet_full_out22),
        .N_packet_full_out(N_packet_full_out22),
        .E_packet_full_out(E_packet_full_out22),
        .S_packet_full_out(S_packet_full_out22),

        .Tail4(Tail_p2r22),
        .Tail3(E_Tail_out21),
        .Tail2(S_Tail_out12),
        .Tail1(W_Tail_out23),
        .Tail0(N_Tail_out32),
        .Stream4(Stream_p2r22),
        .Stream3(E_Stream_out21),
        .Stream2(S_Stream_out12),
        .Stream1(W_Stream_out23),
        .Stream0(N_Stream_out32),
        .Ack4(Ack_p2r22),
        .Ack3(E_Ack_Out_21),
        .Ack2(S_Ack_Out_12),
        .Ack1(W_Ack_Out_23),
        .Ack0(N_Ack_Out_32),
        .CData4(CData_p2r22),
        .CData3(E_CData_Out_21),
        .CData2(S_CData_Out_12),
        .CData1(W_CData_Out_23),
        .CData0(N_CData_Out_32),
        .Strobe4(Strobe_p2r22),
        .Strobe3(E_Strobe_Out_21),
        .Strobe2(S_Strobe_Out_12),
        .Strobe1(W_Strobe_Out_23),
        .Strobe0(N_Strobe_Out_32),
        .State4(State_p2r22),
        .State3(E_State_Out_21),
        .State2(S_State_Out_12),
        .State1(W_State_Out_23),
        .State0(N_State_Out_32),
        //.Clock4(Clock_p2r22),
        //.Clock3(E_Clock_Out_21),
        //.Clock2(S_Clock_Out_12),
        //.Clock1(W_Clock_Out_23),
        //.Clock0(N_Clock_Out_32),
        .Feedback4(Feedback_p2r22),
        .Feedback3(E_Feedback_Out_21),
        .Feedback2(S_Feedback_Out_12),
        .Feedback1(W_Feedback_Out_23),
        .Feedback0(N_Feedback_Out_32),

        .Ack_Out4(Ack_r2p22),    
        .Ack_Out3(W_Ack_Out_22),    
        .Ack_Out2(N_Ack_Out_22),    
        .Ack_Out1(E_Ack_Out_22),   
        .Ack_Out0(S_Ack_Out_22),    
        .CData_Out4(CData_r2p22),
        .CData_Out3(W_CData_Out_22),
        .CData_Out2(N_CData_Out_22),
        .CData_Out1(E_CData_Out_22),
        .CData_Out0(S_CData_Out_22),
       .Tail_Out4(Tail_r2p22),
        .Tail_Out3(W_Tail_out22),
        .Tail_Out2(N_Tail_out22),
        .Tail_Out1(E_Tail_out22),
        .Tail_Out0(S_Tail_out22),
        .Stream_Out4(Stream_r2p22),
        .Stream_Out3(W_Stream_out22),
        .Stream_Out2(N_Stream_out22),
        .Stream_Out1(E_Stream_out22),
        .Stream_Out0(S_Stream_out22),
        .Strobe_Out4(Strobe_r2p22),
        .Strobe_Out3(W_Strobe_Out_22),
        .Strobe_Out2(N_Strobe_Out_22),
        .Strobe_Out1(E_Strobe_Out_22), 
        .Strobe_Out0(S_Strobe_Out_22),
        .State_Out4(State_r2p22),
        .State_Out3(W_State_Out_22),
        .State_Out2(N_State_Out_22),
        .State_Out1(E_State_Out_22),
        .State_Out0(S_State_Out_22),
        //.Clock_Out4(Clock_r2p22),
        //.Clock_Out3(W_Clock_Out_22),
        //.Clock_Out2(N_Clock_Out_22),
        //.Clock_Out1(E_Clock_Out_22),
        //.Clock_Out0(S_Clock_Out_22),
        .Feedback_Out4(Feedback_r2p22),
        .Feedback_Out3(W_Feedback_Out_22),
        .Feedback_Out2(N_Feedback_Out_22),
        .Feedback_Out1(E_Feedback_Out_22),
        .Feedback_Out0(S_Feedback_Out_22)
    );

    Router Router10(
        .ID(4'b0100),
        .rst_n(rst_n),
        
        
        .clk(clk4),
        .clk_W(1'b0),
        .clk_N(clk0),
        .clk_E(clk5),
        .clk_S(clk8),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r10),
        .W_packet_data_in(),
        .N_packet_data_in(S_packet_data_out00),
        .E_packet_data_in(W_packet_data_out11),
        .S_packet_data_in(N_packet_data_out20),

        .L_packet_valid_in(packet_valid_p2r10),
        .W_packet_valid_in(1'b0),
        .N_packet_valid_in(S_packet_valid_out00),
        .E_packet_valid_in(W_packet_valid_out11),
        .S_packet_valid_in(N_packet_valid_out20),

        .W_packet_full_in(1'b0),
        .N_packet_full_in(S_packet_full_out00),
        .E_packet_full_in(W_packet_full_out11),
        .S_packet_full_in(N_packet_full_out20),

        .L_packet_data_out(packet_data_r2p10),
        .W_packet_data_out(),
        .N_packet_data_out(N_packet_data_out10),
        .E_packet_data_out(E_packet_data_out10),
        .S_packet_data_out(S_packet_data_out10),

        .L_packet_valid_out(packet_valid_r2p10),
        .W_packet_valid_out(),
        .N_packet_valid_out(N_packet_valid_out10),
        .E_packet_valid_out(E_packet_valid_out10),
        .S_packet_valid_out(S_packet_valid_out10),
        
        .L_packet_full_out(packet_fifo_wfull10),
        .W_packet_full_out(),
        .N_packet_full_out(N_packet_full_out10),
        .E_packet_full_out(E_packet_full_out10),
        .S_packet_full_out(S_packet_full_out10),

        .Tail4(Tail_p2r10),
        .Tail3(1'b0),
        .Tail2(S_Tail_out00),
        .Tail1(W_Tail_out11),
        .Tail0(N_Tail_out20),
        .Stream4(Stream_p2r10),
        .Stream3(1'b0),
        .Stream2(S_Stream_out00),
        .Stream1(W_Stream_out11),
        .Stream0(N_Stream_out20),

        .Ack4(Ack_p2r10),
        .Ack3(1'b0),
        .Ack2(S_Ack_Out_00),
        .Ack1(W_Ack_Out_11),
        .Ack0(N_Ack_Out_20),
        .CData4(CData_p2r10),
        .CData3(),
        .CData2(S_CData_Out_00),
        .CData1(W_CData_Out_11),
        .CData0(N_CData_Out_20),
        .Strobe4(Strobe_p2r10),
        .Strobe3(1'b0),
        .Strobe2(S_Strobe_Out_00),
        .Strobe1(W_Strobe_Out_11),
        .Strobe0(N_Strobe_Out_20),
        .State4(State_p2r10),
        .State3(1'b0),
        .State2(S_State_Out_00),
        .State1(W_State_Out_11),
        .State0(N_State_Out_20),
        //.Clock4(Clock_p2r10),
        //.Clock3(1'b0),
        //.Clock2(S_Clock_Out_00),
        //.Clock1(W_Clock_Out_11),
        //.Clock0(N_Clock_Out_20),
        .Feedback4(Feedback_p2r10),
        .Feedback3(1'b0),
        .Feedback2(S_Feedback_Out_00),
        .Feedback1(W_Feedback_Out_11),
        .Feedback0(N_Feedback_Out_20),

        .Ack_Out4(Ack_r2p10),    
        .Ack_Out3(),    
        .Ack_Out2(N_Ack_Out_10),    
        .Ack_Out1(E_Ack_Out_10),   
        .Ack_Out0(S_Ack_Out_10),    
        .CData_Out4(CData_r2p10),
        .CData_Out3(),
        .CData_Out2(N_CData_Out_10),
        .CData_Out1(E_CData_Out_10),
        .CData_Out0(S_CData_Out_10),
        .Tail_Out4(Tail_r2p10),
        .Tail_Out3(),
        .Tail_Out2(N_Tail_out10),
        .Tail_Out1(E_Tail_out10),
        .Tail_Out0(S_Tail_out10),
        .Stream_Out4(Stream_r2p10),
        .Stream_Out3(),
        .Stream_Out2(N_Stream_out10),
        .Stream_Out1(E_Stream_out10),
        .Stream_Out0(S_Stream_out10),
        .Strobe_Out4(Strobe_r2p10),
        .Strobe_Out3(),
        .Strobe_Out2(N_Strobe_Out_10),
        .Strobe_Out1(E_Strobe_Out_10), 
        .Strobe_Out0(S_Strobe_Out_10),
        .State_Out4(State_r2p10),
        .State_Out3(),
        .State_Out2(N_State_Out_10),
        .State_Out1(E_State_Out_10),
        .State_Out0(S_State_Out_10),
        //.Clock_Out4(Clock_r2p10),
        //.Clock_Out3(),
        //.Clock_Out2(N_Clock_Out_10),
        //.Clock_Out1(E_Clock_Out_10),
        //.Clock_Out0(S_Clock_Out_10),
        .Feedback_Out4(Feedback_r2p10),
        .Feedback_Out3(),
        .Feedback_Out2(N_Feedback_Out_10),
        .Feedback_Out1(E_Feedback_Out_10),
        .Feedback_Out0(S_Feedback_Out_10)
    );

    Router Router20(
        .ID(4'b1000),
        .rst_n(rst_n),
        
        
        .clk(clk8),
        .clk_W(1'b0),
        .clk_N(clk4),
        .clk_E(clk9),
        .clk_S(clk12),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r20),
        .W_packet_data_in(),
        .N_packet_data_in(S_packet_data_out10),
        .E_packet_data_in(W_packet_data_out21),
        .S_packet_data_in(N_packet_data_out30),

        .L_packet_valid_in(packet_valid_p2r20),
        .W_packet_valid_in(1'b0),
        .N_packet_valid_in(S_packet_valid_out10),
        .E_packet_valid_in(W_packet_valid_out21),
        .S_packet_valid_in(N_packet_valid_out30),

        .W_packet_full_in(1'b0),
        .N_packet_full_in(S_packet_full_out10),
        .E_packet_full_in(W_packet_full_out21),
        .S_packet_full_in(N_packet_full_out30),

        .L_packet_data_out(packet_data_r2p20),
        .W_packet_data_out(),
        .N_packet_data_out(N_packet_data_out20),
        .E_packet_data_out(E_packet_data_out20),
        .S_packet_data_out(S_packet_data_out20),

        .L_packet_valid_out(packet_valid_r2p20),
        .W_packet_valid_out(),
        .N_packet_valid_out(N_packet_valid_out20),
        .E_packet_valid_out(E_packet_valid_out20),
        .S_packet_valid_out(S_packet_valid_out20),
        
        .L_packet_full_out(packet_fifo_wfull20),
        .W_packet_full_out(),
        .N_packet_full_out(N_packet_full_out20),
        .E_packet_full_out(E_packet_full_out20),
        .S_packet_full_out(S_packet_full_out20),

        .Tail4(Tail_p2r20),
        .Tail3(1'b0),
        .Tail2(S_Tail_out10),
        .Tail1(W_Tail_out21),
        .Tail0(N_Tail_out30),
        .Stream4(Stream_p2r20),
        .Stream3(1'b0),
        .Stream2(S_Stream_out10),
        .Stream1(W_Stream_out21),
        .Stream0(N_Stream_out30),
        .Ack4(Ack_p2r20),
        .Ack3(1'b0),
        .Ack2(S_Ack_Out_10),
        .Ack1(W_Ack_Out_21),
        .Ack0(N_Ack_Out_30),
        .CData4(CData_p2r20),
        .CData3(),
        .CData2(S_CData_Out_10),
        .CData1(W_CData_Out_21),
        .CData0(N_CData_Out_30),
        .Strobe4(Strobe_p2r20),
        .Strobe3(1'b0),
        .Strobe2(S_Strobe_Out_10),
        .Strobe1(W_Strobe_Out_21),
        .Strobe0(N_Strobe_Out_30),
        .State4(State_p2r20),
        .State3(1'b0),
        .State2(S_State_Out_10),
        .State1(W_State_Out_21),
        .State0(N_State_Out_30),
        //.Clock4(Clock_p2r20),
        //.Clock3(1'b0),
        //.Clock2(S_Clock_Out_10),
        //.Clock1(W_Clock_Out_21),
        //.Clock0(N_Clock_Out_30),
        .Feedback4(Feedback_p2r20),
        .Feedback3(1'b0),
        .Feedback2(S_Feedback_Out_10),
        .Feedback1(W_Feedback_Out_21),
        .Feedback0(N_Feedback_Out_30),

        .Ack_Out4(Ack_r2p20),    
        .Ack_Out3(),    
        .Ack_Out2(N_Ack_Out_20),    
        .Ack_Out1(E_Ack_Out_20),   
        .Ack_Out0(S_Ack_Out_20),    
        .CData_Out4(CData_r2p20),
        .CData_Out3(),
        .CData_Out2(N_CData_Out_20),
        .CData_Out1(E_CData_Out_20),
        .CData_Out0(S_CData_Out_20),
        .Tail_Out4(Tail_r2p20),
        .Tail_Out3(),
        .Tail_Out2(N_Tail_out20),
        .Tail_Out1(E_Tail_out20),
        .Tail_Out0(S_Tail_out20),
        .Stream_Out4(Stream_r2p20),
        .Stream_Out3(),
        .Stream_Out2(N_Stream_out20),
        .Stream_Out1(E_Stream_out20),
        .Stream_Out0(S_Stream_out20),
        .Strobe_Out4(Strobe_r2p20),
        .Strobe_Out3(),
        .Strobe_Out2(N_Strobe_Out_20),
        .Strobe_Out1(E_Strobe_Out_20), 
        .Strobe_Out0(S_Strobe_Out_20),
        .State_Out4(State_r2p20),
        .State_Out3(),
        .State_Out2(N_State_Out_20),
        .State_Out1(E_State_Out_20),
        .State_Out0(S_State_Out_20),
        //.Clock_Out4(Clock_r2p20),
        //.Clock_Out3(),
        //.Clock_Out2(N_Clock_Out_20),
        //.Clock_Out1(E_Clock_Out_20),
        //.Clock_Out0(S_Clock_Out_20),
        .Feedback_Out4(Feedback_r2p20),
        .Feedback_Out3(),
        .Feedback_Out2(N_Feedback_Out_20),
        .Feedback_Out1(E_Feedback_Out_20),
        .Feedback_Out0(S_Feedback_Out_20)
    );

    Router Router01(
        .ID(4'b0001),
        .rst_n(rst_n),
        
        
        .clk(clk1),
        .clk_W(clk0),
        .clk_N(1'b0),
        .clk_E(clk2),
        .clk_S(clk5),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r01),
        .W_packet_data_in(E_packet_data_out00),
        .N_packet_data_in(),
        .E_packet_data_in(W_packet_data_out02),
        .S_packet_data_in(N_packet_data_out11),

        .L_packet_valid_in(packet_valid_p2r01),
        .W_packet_valid_in(E_packet_valid_out00),
        .N_packet_valid_in(1'b0),
        .E_packet_valid_in(W_packet_valid_out02),
        .S_packet_valid_in(N_packet_valid_out11),

        .W_packet_full_in(E_packet_full_out00),
        .N_packet_full_in(1'b0),
        .E_packet_full_in(W_packet_full_out02),
        .S_packet_full_in(N_packet_full_out11),

        .L_packet_data_out(packet_data_r2p01),
        .W_packet_data_out(W_packet_data_out01),
        .N_packet_data_out(),
        .E_packet_data_out(E_packet_data_out01),
        .S_packet_data_out(S_packet_data_out01),

        .L_packet_valid_out(packet_valid_r2p01),
        .W_packet_valid_out(W_packet_valid_out01),
        .N_packet_valid_out(),
        .E_packet_valid_out(E_packet_valid_out01),
        .S_packet_valid_out(S_packet_valid_out01),
        
        .L_packet_full_out(packet_fifo_wfull01),
        .W_packet_full_out(W_packet_full_out01),
        .N_packet_full_out(),
        .E_packet_full_out(E_packet_full_out01),
        .S_packet_full_out(S_packet_full_out01),
        .Tail4(Tail_p2r01),
        .Tail3(E_Tail_out00),
        .Tail2(1'b0),
        .Tail1(W_Tail_out02),
        .Tail0(N_Tail_out11),
        .Stream4(Stream_p2r01),
        .Stream3(E_Stream_out00),
        .Stream2(1'b0),
        .Stream1(W_Stream_out02),
        .Stream0(N_Stream_out11),

        .Ack4(Ack_p2r01),
        .Ack3(E_Ack_Out_00),
        .Ack2(1'b0),
        .Ack1(W_Ack_Out_02),
        .Ack0(N_Ack_Out_11),
        .CData4(CData_p2r01),
        .CData3(E_CData_Out_00),
        .CData2(),
        .CData1(W_CData_Out_02),
        .CData0(N_CData_Out_11),
        .Strobe4(Strobe_p2r01),
        .Strobe3(E_Strobe_Out_00),
        .Strobe2(1'b0),
        .Strobe1(W_Strobe_Out_02),
        .Strobe0(N_Strobe_Out_11),
        .State4(State_p2r01),
        .State3(E_State_Out_00),
        .State2(1'b0),
        .State1(W_State_Out_02),
        .State0(N_State_Out_11),
        //.Clock4(Clock_p2r01),
        //.Clock3(E_Clock_Out_00),
        //.Clock2(1'b0),
        //.Clock1(W_Clock_Out_02),
        //.Clock0(N_Clock_Out_11),
        .Feedback4(Feedback_p2r01),
        .Feedback3(E_Feedback_Out_00),
        .Feedback2(1'b0),
        .Feedback1(W_Feedback_Out_02),
        .Feedback0(N_Feedback_Out_11),

        .Ack_Out4(Ack_r2p01),    
        .Ack_Out3(W_Ack_Out_01),    
        .Ack_Out2(),    
        .Ack_Out1(E_Ack_Out_01),   
        .Ack_Out0(S_Ack_Out_01),    
        .CData_Out4(CData_r2p01),
        .CData_Out3(W_CData_Out_01),
        .CData_Out2(),
        .CData_Out1(E_CData_Out_01),
        .CData_Out0(S_CData_Out_01),
        .Tail_Out4(Tail_r2p01),
        .Tail_Out3(W_Tail_out01),
        .Tail_Out2(),
        .Tail_Out1(E_Tail_out01),
        .Tail_Out0(S_Tail_out01),
        .Stream_Out4(Stream_r2p01),
        .Stream_Out3(W_Stream_out01),
        .Stream_Out2(),
        .Stream_Out1(E_Stream_out01),
        .Stream_Out0(S_Stream_out01),
        .Strobe_Out4(Strobe_r2p01),
        .Strobe_Out3(W_Strobe_Out_01),
        .Strobe_Out2(),
        .Strobe_Out1(E_Strobe_Out_01), 
        .Strobe_Out0(S_Strobe_Out_01),
        .State_Out4(State_r2p01),
        .State_Out3(W_State_Out_01),
        .State_Out2(),
        .State_Out1(E_State_Out_01),
        .State_Out0(S_State_Out_01),
        //.Clock_Out4(Clock_r2p01),
        //.Clock_Out3(W_Clock_Out_01),
        //.Clock_Out2(),
        //.Clock_Out1(E_Clock_Out_01),
        //.Clock_Out0(S_Clock_Out_01),
        .Feedback_Out4(Feedback_r2p01),
        .Feedback_Out3(W_Feedback_Out_01),
        .Feedback_Out2(),
        .Feedback_Out1(E_Feedback_Out_01),
        .Feedback_Out0(S_Feedback_Out_01)
    );

    Router Router02(
        .ID(4'b0010),
        .rst_n(rst_n),
        
        
        .clk(clk2),
        .clk_W(clk1),
        .clk_N(1'b0),
        .clk_E(clk3),
        .clk_S(clk6),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r02),
        .W_packet_data_in(E_packet_data_out01),
        .N_packet_data_in(),
        .E_packet_data_in(W_packet_data_out03),
        .S_packet_data_in(N_packet_data_out12),

        .L_packet_valid_in(packet_valid_p2r02),
        .W_packet_valid_in(E_packet_valid_out01),
        .N_packet_valid_in(1'b0),
        .E_packet_valid_in(W_packet_valid_out03),
        .S_packet_valid_in(N_packet_valid_out12),

        .W_packet_full_in(E_packet_full_out01),
        .N_packet_full_in(1'b0),
        .E_packet_full_in(W_packet_full_out03),
        .S_packet_full_in(N_packet_full_out12),

        .L_packet_data_out(packet_data_r2p02),
        .W_packet_data_out(W_packet_data_out02),
        .N_packet_data_out(),
        .E_packet_data_out(E_packet_data_out02),
        .S_packet_data_out(S_packet_data_out02),

        .L_packet_valid_out(packet_valid_r2p02),
        .W_packet_valid_out(W_packet_valid_out02),
        .N_packet_valid_out(),
        .E_packet_valid_out(E_packet_valid_out02),
        .S_packet_valid_out(S_packet_valid_out02),
        
        .L_packet_full_out(packet_fifo_wfull02),
        .W_packet_full_out(W_packet_full_out02),
        .N_packet_full_out(),
        .E_packet_full_out(E_packet_full_out02),
        .S_packet_full_out(S_packet_full_out02),

        .Tail4(Tail_p2r02),
        .Tail3(E_Tail_out01),
        .Tail2(1'b0),
        .Tail1(W_Tail_out03),
        .Tail0(N_Tail_out12),
        .Stream4(Stream_p2r02),
        .Stream3(E_Stream_out01),
        .Stream2(1'b0),
        .Stream1(W_Stream_out03),
        .Stream0(N_Stream_out12),

        .Ack4(Ack_p2r02),
        .Ack3(E_Ack_Out_01),
        .Ack2(1'b0),
        .Ack1(W_Ack_Out_03),
        .Ack0(N_Ack_Out_12),
        .CData4(CData_p2r02),
        .CData3(E_CData_Out_01),
        .CData2(),
        .CData1(W_CData_Out_03),
        .CData0(N_CData_Out_12),
        .Strobe4(Strobe_p2r02),
        .Strobe3(E_Strobe_Out_01),
        .Strobe2(1'b0),
        .Strobe1(W_Strobe_Out_03),
        .Strobe0(N_Strobe_Out_12),
        .State4(State_p2r02),
        .State3(E_State_Out_01),
        .State2(1'b0),
        .State1(W_State_Out_03),
        .State0(N_State_Out_12),
        //.Clock4(Clock_p2r02),
        //.Clock3(E_Clock_Out_01),
        //.Clock2(1'b0),
        //.Clock1(W_Clock_Out_03),
        //.Clock0(N_Clock_Out_12),
        .Feedback4(Feedback_p2r02),
        .Feedback3(E_Feedback_Out_01),
        .Feedback2(1'b0),
        .Feedback1(W_Feedback_Out_03),
        .Feedback0(N_Feedback_Out_12),

        .Ack_Out4(Ack_r2p02),    
        .Ack_Out3(W_Ack_Out_02),    
        .Ack_Out2(),    
        .Ack_Out1(E_Ack_Out_02),   
        .Ack_Out0(S_Ack_Out_02),    
        .CData_Out4(CData_r2p02),
        .CData_Out3(W_CData_Out_02),
        .CData_Out2(),
        .CData_Out1(E_CData_Out_02),
        .CData_Out0(S_CData_Out_02),
        .Tail_Out4(Tail_r2p02),
        .Tail_Out3(W_Tail_out02),
        .Tail_Out2(),
        .Tail_Out1(E_Tail_out02),
        .Tail_Out0(S_Tail_out02),
        .Stream_Out4(Stream_r2p02),
        .Stream_Out3(W_Stream_out02),
        .Stream_Out2(),
        .Stream_Out1(E_Stream_out02),
        .Stream_Out0(S_Stream_out02),
        .Strobe_Out4(Strobe_r2p02),
        .Strobe_Out3(W_Strobe_Out_02),
        .Strobe_Out2(),
        .Strobe_Out1(E_Strobe_Out_02), 
        .Strobe_Out0(S_Strobe_Out_02),
        .State_Out4(State_r2p02),
        .State_Out3(W_State_Out_02),
        .State_Out2(),
        .State_Out1(E_State_Out_02),
        .State_Out0(S_State_Out_02),
        //.Clock_Out4(Clock_r2p02),
        //.Clock_Out3(W_Clock_Out_02),
        //.Clock_Out2(),
        //.Clock_Out1(E_Clock_Out_02),
        //.Clock_Out0(S_Clock_Out_02),
        .Feedback_Out4(Feedback_r2p02),
        .Feedback_Out3(W_Feedback_Out_02),
        .Feedback_Out2(),
        .Feedback_Out1(E_Feedback_Out_02),
        .Feedback_Out0(S_Feedback_Out_02)
    );

    Router Router13(
        .ID(4'b0111),
        .rst_n(rst_n),
        
        
        .clk(clk7),
        .clk_W(clk6),
        .clk_N(clk3),
        .clk_E(1'b0),
        .clk_S(clk11),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r13),
        .W_packet_data_in(E_packet_data_out12),
        .N_packet_data_in(S_packet_data_out03),
        .E_packet_data_in(),
        .S_packet_data_in(N_packet_data_out23),

        .L_packet_valid_in(packet_valid_p2r13),
        .W_packet_valid_in(E_packet_valid_out12),
        .N_packet_valid_in(S_packet_valid_out03),
        .E_packet_valid_in(1'b0),
        .S_packet_valid_in(N_packet_valid_out23),

        .W_packet_full_in(E_packet_full_out12),
        .N_packet_full_in(S_packet_full_out03),
        .E_packet_full_in(1'b0),
        .S_packet_full_in(N_packet_full_out23),

        .L_packet_data_out(packet_data_r2p13),
        .W_packet_data_out(W_packet_data_out13),
        .N_packet_data_out(N_packet_data_out13),
        .E_packet_data_out(),
        .S_packet_data_out(S_packet_data_out13),

        .L_packet_valid_out(packet_valid_r2p13),
        .W_packet_valid_out(W_packet_valid_out13),
        .N_packet_valid_out(N_packet_valid_out13),
        .E_packet_valid_out(),
        .S_packet_valid_out(S_packet_valid_out13),
        
        .L_packet_full_out(packet_fifo_wfull13),
        .W_packet_full_out(W_packet_full_out13),
        .N_packet_full_out(N_packet_full_out13),
        .E_packet_full_out(),
        .S_packet_full_out(S_packet_full_out13),

        .Tail4(Tail_p2r13),
        .Tail3(E_Tail_out12),
        .Tail2(S_Tail_out03),
        .Tail1(1'b0),
        .Tail0(N_Tail_out23),
        .Stream4(Stream_p2r13),
        .Stream3(E_Stream_out12),
        .Stream2(S_Stream_out03),
        .Stream1(1'b0),
        .Stream0(N_Stream_out23),

        .Ack4(Ack_p2r13),
        .Ack3(E_Ack_Out_12),
        .Ack2(S_Ack_Out_03),
        .Ack1(1'b0),
        .Ack0(N_Ack_Out_23),
        .CData4(CData_p2r13),
        .CData3(E_CData_Out_12),
        .CData2(S_CData_Out_03),
        .CData1(),
        .CData0(N_CData_Out_23),
        .Strobe4(Strobe_p2r13),
        .Strobe3(E_Strobe_Out_12),
        .Strobe2(S_Strobe_Out_03),
        .Strobe1(1'b0),
        .Strobe0(N_Strobe_Out_23),
        .State4(State_p2r13),
        .State3(E_State_Out_12),
        .State2(S_State_Out_03),
        .State1(1'b0),
        .State0(N_State_Out_23),
        //.Clock4(Clock_p2r13),
        //.Clock3(E_Clock_Out_12),
        //.Clock2(S_Clock_Out_03),
        //.Clock1(1'b0),
        //.Clock0(N_Clock_Out_23),
        .Feedback4(Feedback_p2r13),
        .Feedback3(E_Feedback_Out_12),
        .Feedback2(S_Feedback_Out_03),
        .Feedback1(1'b0),
        .Feedback0(N_Feedback_Out_23),

        .Ack_Out4(Ack_r2p13),    
        .Ack_Out3(W_Ack_Out_13),    
        .Ack_Out2(N_Ack_Out_13),    
        .Ack_Out1(),   
        .Ack_Out0(S_Ack_Out_13),    
        .CData_Out4(CData_r2p13),
        .CData_Out3(W_CData_Out_13),
        .CData_Out2(N_CData_Out_13),
        .CData_Out1(),
        .CData_Out0(S_CData_Out_13),
        .Tail_Out4(Tail_r2p13),
        .Tail_Out3(W_Tail_out13),
        .Tail_Out2(N_Tail_out13),
        .Tail_Out1(),
        .Tail_Out0(S_Tail_out13),
        .Stream_Out4(Stream_r2p13),
        .Stream_Out3(W_Stream_out13),
        .Stream_Out2(N_Stream_out13),
        .Stream_Out1(),
        .Stream_Out0(S_Stream_out13),
        .Strobe_Out4(Strobe_r2p13),
        .Strobe_Out3(W_Strobe_Out_13),
        .Strobe_Out2(N_Strobe_Out_13),
        .Strobe_Out1(), 
        .Strobe_Out0(S_Strobe_Out_13),
        .State_Out4(State_r2p13),
        .State_Out3(W_State_Out_13),
        .State_Out2(N_State_Out_13),
        .State_Out1(),
        .State_Out0(S_State_Out_13),
        //.Clock_Out4(Clock_r2p13),
        //.Clock_Out3(W_Clock_Out_13),
        //.Clock_Out2(N_Clock_Out_13),
        //.Clock_Out1(),
        //.Clock_Out0(S_Clock_Out_13),
        .Feedback_Out4(Feedback_r2p13),
        .Feedback_Out3(W_Feedback_Out_13),
        .Feedback_Out2(N_Feedback_Out_13),
        .Feedback_Out1(),
        .Feedback_Out0(S_Feedback_Out_13)
    );

    Router Router23(
        .ID(4'b1011),
        .rst_n(rst_n),
        
        
        .clk(clk11),
        .clk_W(clk10),
        .clk_N(clk7),
        .clk_E(1'b0),
        .clk_S(clk15),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r23),
        .W_packet_data_in(E_packet_data_out22),
        .N_packet_data_in(S_packet_data_out13),
        .E_packet_data_in(),
        .S_packet_data_in(N_packet_data_out33),

        .L_packet_valid_in(packet_valid_p2r23),
        .W_packet_valid_in(E_packet_valid_out22),
        .N_packet_valid_in(S_packet_valid_out13),
        .E_packet_valid_in(1'b0),
        .S_packet_valid_in(N_packet_valid_out33),

        .W_packet_full_in(E_packet_full_out22),
        .N_packet_full_in(S_packet_full_out13),
        .E_packet_full_in(1'b0),
        .S_packet_full_in(N_packet_full_out33),

        .L_packet_data_out(packet_data_r2p23),
        .W_packet_data_out(W_packet_data_out23),
        .N_packet_data_out(N_packet_data_out23),
        .E_packet_data_out(),
        .S_packet_data_out(S_packet_data_out23),

        .L_packet_valid_out(packet_valid_r2p23),
        .W_packet_valid_out(W_packet_valid_out23),
        .N_packet_valid_out(N_packet_valid_out23),
        .E_packet_valid_out(),
        .S_packet_valid_out(S_packet_valid_out23),
        
        .L_packet_full_out(packet_fifo_wfull23),
        .W_packet_full_out(W_packet_full_out23),
        .N_packet_full_out(N_packet_full_out23),
        .E_packet_full_out(),
        .S_packet_full_out(S_packet_full_out23),

        .Tail4(Tail_p2r23),
        .Tail3(E_Tail_out22),
        .Tail2(S_Tail_out13),
        .Tail1(1'b0),
        .Tail0(N_Tail_out33),
        .Stream4(Stream_p2r23),
        .Stream3(E_Stream_out22),
        .Stream2(S_Stream_out13),
        .Stream1(1'b0),
        .Stream0(N_Stream_out33),

        .Ack4(Ack_p2r23),
        .Ack3(E_Ack_Out_22),
        .Ack2(S_Ack_Out_13),
        .Ack1(1'b0),
        .Ack0(N_Ack_Out_33),
        .CData4(CData_p2r23),
        .CData3(E_CData_Out_22),
        .CData2(S_CData_Out_13),
        .CData1(),
        .CData0(N_CData_Out_33),
        .Strobe4(Strobe_p2r23),
        .Strobe3(E_Strobe_Out_22),
        .Strobe2(S_Strobe_Out_13),
        .Strobe1(1'b0),
        .Strobe0(N_Strobe_Out_33),
        .State4(State_p2r23),
        .State3(E_State_Out_22),
        .State2(S_State_Out_13),
        .State1(1'b0),
        .State0(N_State_Out_33),
        //.Clock4(Clock_p2r23),
        //.Clock3(E_Clock_Out_22),
        //.Clock2(S_Clock_Out_13),
        //.Clock1(1'b0),
        //.Clock0(N_Clock_Out_33),
        .Feedback4(Feedback_p2r23),
        .Feedback3(E_Feedback_Out_22),
        .Feedback2(S_Feedback_Out_13),
        .Feedback1(1'b0),
        .Feedback0(N_Feedback_Out_33),

        .Ack_Out4(Ack_r2p23),    
        .Ack_Out3(W_Ack_Out_23),    
        .Ack_Out2(N_Ack_Out_23),    
        .Ack_Out1(),   
        .Ack_Out0(S_Ack_Out_23),    
        .CData_Out4(CData_r2p23),
        .CData_Out3(W_CData_Out_23),
        .CData_Out2(N_CData_Out_23),
        .CData_Out1(),
        .CData_Out0(S_CData_Out_23),
        .Tail_Out4(Tail_r2p23),
        .Tail_Out3(W_Tail_out23),
        .Tail_Out2(N_Tail_out23),
        .Tail_Out1(),
        .Tail_Out0(S_Tail_out23),
        .Stream_Out4(Stream_r2p23),
        .Stream_Out3(W_Stream_out23),
        .Stream_Out2(N_Stream_out23),
        .Stream_Out1(),
        .Stream_Out0(S_Stream_out23),
        .Strobe_Out4(Strobe_r2p23),
        .Strobe_Out3(W_Strobe_Out_23),
        .Strobe_Out2(N_Strobe_Out_23),
        .Strobe_Out1(), 
        .Strobe_Out0(S_Strobe_Out_23),
        .State_Out4(State_r2p23),
        .State_Out3(W_State_Out_23),
        .State_Out2(N_State_Out_23),
        .State_Out1(),
        .State_Out0(S_State_Out_23),
        //.Clock_Out4(Clock_r2p23),
        //.Clock_Out3(W_Clock_Out_23),
        //.Clock_Out2(N_Clock_Out_23),
        //.Clock_Out1(),
        //.Clock_Out0(S_Clock_Out_23),
        .Feedback_Out4(Feedback_r2p23),
        .Feedback_Out3(W_Feedback_Out_23),
        .Feedback_Out2(N_Feedback_Out_23),
        .Feedback_Out1(),
        .Feedback_Out0(S_Feedback_Out_23)
    );

    Router Router31(
        .ID(4'b1101),
        .rst_n(rst_n),
        
        
        .clk(clk13),
        .clk_W(clk12),
        .clk_N(clk9),
        .clk_E(clk14),
        .clk_S(1'b0),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r31),
        .W_packet_data_in(E_packet_data_out30),
        .N_packet_data_in(S_packet_data_out21),
        .E_packet_data_in(W_packet_data_out32),
        .S_packet_data_in(),

        .L_packet_valid_in(packet_valid_p2r31),
        .W_packet_valid_in(E_packet_valid_out30),
        .N_packet_valid_in(S_packet_valid_out21),
        .E_packet_valid_in(W_packet_valid_out32),
        .S_packet_valid_in(1'b0),

        .W_packet_full_in(E_packet_full_out30),
        .N_packet_full_in(S_packet_full_out21),
        .E_packet_full_in(W_packet_full_out32),
        .S_packet_full_in(1'b0),

        .L_packet_data_out(packet_data_r2p31),
        .W_packet_data_out(W_packet_data_out31),
        .N_packet_data_out(N_packet_data_out31),
        .E_packet_data_out(E_packet_data_out31),
        .S_packet_data_out(),

        .L_packet_valid_out(packet_valid_r2p31),
        .W_packet_valid_out(W_packet_valid_out31),
        .N_packet_valid_out(N_packet_valid_out31),
        .E_packet_valid_out(E_packet_valid_out31),
        .S_packet_valid_out(),
        
        .L_packet_full_out(packet_fifo_wfull31),
        .W_packet_full_out(W_packet_full_out31),
        .N_packet_full_out(N_packet_full_out31),
        .E_packet_full_out(E_packet_full_out31),
        .S_packet_full_out(),

        .Tail4(Tail_p2r31),
        .Tail3(E_Tail_out30),
        .Tail2(S_Tail_out21),
        .Tail1(W_Tail_out32),
        .Tail0(1'b0),
        .Stream4(Stream_p2r31),
        .Stream3(E_Stream_out30),
        .Stream2(S_Stream_out21),
        .Stream1(W_Stream_out32),
        .Stream0(1'b0),
        .Ack4(Ack_p2r31),
        .Ack3(E_Ack_Out_30),
        .Ack2(S_Ack_Out_21),
        .Ack1(W_Ack_Out_32),
        .Ack0(1'b0),
        .CData4(CData_p2r31),
        .CData3(E_CData_Out_30),
        .CData2(S_CData_Out_21),
        .CData1(W_CData_Out_32),
        .CData0(),
        .Strobe4(Strobe_p2r31),
        .Strobe3(E_Strobe_Out_30),
        .Strobe2(S_Strobe_Out_21),
        .Strobe1(W_Strobe_Out_32),
        .Strobe0(1'b0),
        .State4(State_p2r31),
        .State3(E_State_Out_30),
        .State2(S_State_Out_21),
        .State1(W_State_Out_32),
        .State0(1'b0),
        //.Clock4(Clock_p2r31),
        //.Clock3(E_Clock_Out_30),
        //.Clock2(S_Clock_Out_21),
        //.Clock1(W_Clock_Out_32),
        //.Clock0(1'b0),
        .Feedback4(Feedback_p2r31),
        .Feedback3(E_Feedback_Out_30),
        .Feedback2(S_Feedback_Out_21),
        .Feedback1(W_Feedback_Out_32),
        .Feedback0(1'b0),

        .Ack_Out4(Ack_r2p31),    
        .Ack_Out3(W_Ack_Out_31),    
        .Ack_Out2(N_Ack_Out_31),    
        .Ack_Out1(E_Ack_Out_31),   
        .Ack_Out0(),    
        .CData_Out4(CData_r2p31),
        .CData_Out3(W_CData_Out_31),
        .CData_Out2(N_CData_Out_31),
        .CData_Out1(E_CData_Out_31),
        .CData_Out0(),
        .Tail_Out4(Tail_r2p31),
        .Tail_Out3(W_Tail_out31),
        .Tail_Out2(N_Tail_out31),
        .Tail_Out1(E_Tail_out31),
        .Tail_Out0(),
        .Stream_Out4(Stream_r2p31),
        .Stream_Out3(W_Stream_out31),
        .Stream_Out2(N_Stream_out31),
        .Stream_Out1(E_Stream_out31),
        .Stream_Out0(),
        .Strobe_Out4(Strobe_r2p31),
        .Strobe_Out3(W_Strobe_Out_31),
        .Strobe_Out2(N_Strobe_Out_31),
        .Strobe_Out1(E_Strobe_Out_31), 
        .Strobe_Out0(),
        .State_Out4(State_r2p31),
        .State_Out3(W_State_Out_31),
        .State_Out2(N_State_Out_31),
        .State_Out1(E_State_Out_31),
        .State_Out0(),
        //.Clock_Out4(Clock_r2p31),
        //.Clock_Out3(W_Clock_Out_31),
        //.Clock_Out2(N_Clock_Out_31),
        //.Clock_Out1(E_Clock_Out_31),
        //.Clock_Out0(),
        .Feedback_Out4(Feedback_r2p31),
        .Feedback_Out3(W_Feedback_Out_31),
        .Feedback_Out2(N_Feedback_Out_31),
        .Feedback_Out1(E_Feedback_Out_31),
        .Feedback_Out0()
    );

    Router Router32(
        .ID(4'b1110),
        .rst_n(rst_n),
        
        
        .clk(clk14),
        .clk_W(clk13),
        .clk_N(clk10),
        .clk_E(clk15),
        .clk_S(1'b0),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r32),
        .W_packet_data_in(E_packet_data_out31),
        .N_packet_data_in(S_packet_data_out22),
        .E_packet_data_in(W_packet_data_out33),
        .S_packet_data_in(),

        .L_packet_valid_in(packet_valid_p2r32),
        .W_packet_valid_in(E_packet_valid_out31),
        .N_packet_valid_in(S_packet_valid_out22),
        .E_packet_valid_in(W_packet_valid_out33),
        .S_packet_valid_in(1'b0),

        .W_packet_full_in(E_packet_full_out31),
        .N_packet_full_in(S_packet_full_out22),
        .E_packet_full_in(W_packet_full_out33),
        .S_packet_full_in(1'b0),

        .L_packet_data_out(packet_data_r2p32),
        .W_packet_data_out(W_packet_data_out32),
        .N_packet_data_out(N_packet_data_out32),
        .E_packet_data_out(E_packet_data_out32),
        .S_packet_data_out(),

        .L_packet_valid_out(packet_valid_r2p32),
        .W_packet_valid_out(W_packet_valid_out32),
        .N_packet_valid_out(N_packet_valid_out32),
        .E_packet_valid_out(E_packet_valid_out32),
        .S_packet_valid_out(),
        
        .L_packet_full_out(packet_fifo_wfull32),
        .W_packet_full_out(W_packet_full_out32),
        .N_packet_full_out(N_packet_full_out32),
        .E_packet_full_out(E_packet_full_out32),
        .S_packet_full_out(),

        .Tail4(Tail_p2r32),
        .Tail3(E_Tail_out31),
        .Tail2(S_Tail_out22),
        .Tail1(W_Tail_out33),
        .Tail0(1'b0),
        .Stream4(Stream_p2r32),
        .Stream3(E_Stream_out31),
        .Stream2(S_Stream_out22),
        .Stream1(W_Stream_out33),
        .Stream0(1'b0),
        .Ack4(Ack_p2r32),
        .Ack3(E_Ack_Out_31),
        .Ack2(S_Ack_Out_22),
        .Ack1(W_Ack_Out_33),
        .Ack0(1'b0),
        .CData4(CData_p2r32),
        .CData3(E_CData_Out_31),
        .CData2(S_CData_Out_22),
        .CData1(W_CData_Out_33),
        .CData0(),
        .Strobe4(Strobe_p2r32),
        .Strobe3(E_Strobe_Out_31),
        .Strobe2(S_Strobe_Out_22),
        .Strobe1(W_Strobe_Out_33),
        .Strobe0(1'b0),
        .State4(State_p2r32),
        .State3(E_State_Out_31),
        .State2(S_State_Out_22),
        .State1(W_State_Out_33),
        .State0(1'b0),
        //.Clock4(Clock_p2r32),
        //.Clock3(E_Clock_Out_31),
        //.Clock2(S_Clock_Out_22),
        //.Clock1(W_Clock_Out_33),
        //.Clock0(1'b0),
        .Feedback4(Feedback_p2r32),
        .Feedback3(E_Feedback_Out_31),
        .Feedback2(S_Feedback_Out_22),
        .Feedback1(W_Feedback_Out_33),
        .Feedback0(1'b0),

        .Ack_Out4(Ack_r2p32),    
        .Ack_Out3(W_Ack_Out_32),    
        .Ack_Out2(N_Ack_Out_32),    
        .Ack_Out1(E_Ack_Out_32),   
        .Ack_Out0(),    
        .CData_Out4(CData_r2p32),
        .CData_Out3(W_CData_Out_32),
        .CData_Out2(N_CData_Out_32),
        .CData_Out1(E_CData_Out_32),
        .CData_Out0(),
        .Tail_Out4(Tail_r2p32),
        .Tail_Out3(W_Tail_out32),
        .Tail_Out2(N_Tail_out32),
        .Tail_Out1(E_Tail_out32),
        .Tail_Out0(),
        .Stream_Out4(Stream_r2p32),
        .Stream_Out3(W_Stream_out32),
        .Stream_Out2(N_Stream_out32),
        .Stream_Out1(E_Stream_out32),
        .Stream_Out0(),
        .Strobe_Out4(Strobe_r2p32),
        .Strobe_Out3(W_Strobe_Out_32),
        .Strobe_Out2(N_Strobe_Out_32),
        .Strobe_Out1(E_Strobe_Out_32), 
        .Strobe_Out0(),
        .State_Out4(State_r2p32),
        .State_Out3(W_State_Out_32),
        .State_Out2(N_State_Out_32),
        .State_Out1(E_State_Out_32),
        .State_Out0(),
        //.Clock_Out4(Clock_r2p32),
        //.Clock_Out3(W_Clock_Out_32),
        //.Clock_Out2(N_Clock_Out_32),
        //.Clock_Out1(E_Clock_Out_32),
        //.Clock_Out0(),
        .Feedback_Out4(Feedback_r2p32),
        .Feedback_Out3(W_Feedback_Out_32),
        .Feedback_Out2(N_Feedback_Out_32),
        .Feedback_Out1(E_Feedback_Out_32),
        .Feedback_Out0()
    );

    Router Router00(
        .ID(4'b0000),
        .rst_n(rst_n),
        
        
        .clk(clk0),
        .clk_W(1'b0),
        .clk_N(1'b0),
        .clk_E(clk1),
        .clk_S(clk4),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r00),
        .W_packet_data_in(),
        .N_packet_data_in(),
        .E_packet_data_in(W_packet_data_out01),
        .S_packet_data_in(N_packet_data_out10),

        .L_packet_valid_in(packet_valid_p2r00),
        .W_packet_valid_in(1'b0),
        .N_packet_valid_in(1'b0),
        .E_packet_valid_in(W_packet_valid_out01),
        .S_packet_valid_in(N_packet_valid_out10),

        .W_packet_full_in(1'b0),
        .N_packet_full_in(1'b0),
        .E_packet_full_in(W_packet_full_out01),
        .S_packet_full_in(N_packet_full_out10),

        .L_packet_data_out(packet_data_r2p00),
        .W_packet_data_out(),
        .N_packet_data_out(),
        .E_packet_data_out(E_packet_data_out00),
        .S_packet_data_out(S_packet_data_out00),

        .L_packet_valid_out(packet_valid_r2p00),
        .W_packet_valid_out(),
        .N_packet_valid_out(),
        .E_packet_valid_out(E_packet_valid_out00),
        .S_packet_valid_out(S_packet_valid_out00),
        
        .L_packet_full_out(packet_fifo_wfull00),
        .W_packet_full_out(),
        .N_packet_full_out(),
        .E_packet_full_out(E_packet_full_out00),
        .S_packet_full_out(S_packet_full_out00),

        .Tail4(Tail_p2r00),
        .Tail3(1'b0),
        .Tail2(1'b0),
        .Tail1(W_Tail_out01),
        .Tail0(N_Tail_out10),
        .Stream4(Stream_p2r00),
        .Stream3(1'b0),
        .Stream2(1'b0),
        .Stream1(W_Stream_out01),
        .Stream0(N_Stream_out10),
        .Ack4(Ack_p2r00),
        .Ack3(1'b0),
        .Ack2(1'b0),
        .Ack1(W_Ack_Out_01),
        .Ack0(N_Ack_Out_10),
        .CData4(CData_p2r00),
        .CData3(),
        .CData2(),
        .CData1(W_CData_Out_01),
        .CData0(N_CData_Out_10),
        .Strobe4(Strobe_p2r00),
        .Strobe3(1'b0),
        .Strobe2(1'b0),
        .Strobe1(W_Strobe_Out_01),
        .Strobe0(N_Strobe_Out_10),
        .State4(State_p2r00),
        .State3(1'b0),
        .State2(1'b0),
        .State1(W_State_Out_01),
        .State0(N_State_Out_10),
        //.Clock4(Clock_p2r00),
        //.Clock3(1'b0),
        //.Clock2(1'b0),
        //.Clock1(W_Clock_Out_01),
        //.Clock0(N_Clock_Out_10),
        .Feedback4(Feedback_p2r00),
        .Feedback3(1'b0),
        .Feedback2(1'b0),
        .Feedback1(W_Feedback_Out_01),
        .Feedback0(N_Feedback_Out_10),

        .Ack_Out4(Ack_r2p00),    
        .Ack_Out3(),    
        .Ack_Out2(),    
        .Ack_Out1(E_Ack_Out_00),   
        .Ack_Out0(S_Ack_Out_00),    
        .CData_Out4(CData_r2p00),
        .CData_Out3(),
        .CData_Out2(),
        .CData_Out1(E_CData_Out_00),
        .CData_Out0(S_CData_Out_00),
        .Tail_Out4(Tail_r2p00),
        .Tail_Out3(),
        .Tail_Out2(),
        .Tail_Out1(E_Tail_out00),
        .Tail_Out0(S_Tail_out00),
        .Stream_Out4(Stream_r2p00),
        .Stream_Out3(),
        .Stream_Out2(),
        .Stream_Out1(E_Stream_out00),
        .Stream_Out0(S_Stream_out00),
        .Strobe_Out4(Strobe_r2p00),
        .Strobe_Out3(),
        .Strobe_Out2(),
        .Strobe_Out1(E_Strobe_Out_00), 
        .Strobe_Out0(S_Strobe_Out_00),
        .State_Out4(State_r2p00),
        .State_Out3(),
        .State_Out2(),
        .State_Out1(E_State_Out_00),
        .State_Out0(S_State_Out_00),
        //.Clock_Out4(Clock_r2p00),
        //.Clock_Out3(),
        //.Clock_Out2(),
        //.Clock_Out1(E_Clock_Out_00),
        //.Clock_Out0(S_Clock_Out_00),
        .Feedback_Out4(Feedback_r2p00),
        .Feedback_Out3(),
        .Feedback_Out2(),
        .Feedback_Out1(E_Feedback_Out_00),
        .Feedback_Out0(S_Feedback_Out_00)
    );

    Router Router03(
        .ID(4'b0011),
        .rst_n(rst_n),
        
        
        .clk(clk3),
        .clk_W(clk2),
        .clk_N(1'b0),
        .clk_E(1'b0),
        .clk_S(clk7),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r03),
        .W_packet_data_in(E_packet_data_out02),
        .N_packet_data_in(),
        .E_packet_data_in(),
        .S_packet_data_in(N_packet_data_out13),

        .L_packet_valid_in(packet_valid_p2r03),
        .W_packet_valid_in(E_packet_valid_out02),
        .N_packet_valid_in(1'b0),
        .E_packet_valid_in(1'b0),
        .S_packet_valid_in(N_packet_valid_out13),

        .W_packet_full_in(E_packet_full_out02),
        .N_packet_full_in(1'b0),
        .E_packet_full_in(1'b0),
        .S_packet_full_in(N_packet_full_out13),

        .L_packet_data_out(packet_data_r2p03),
        .W_packet_data_out(W_packet_data_out03),
        .N_packet_data_out(),
        .E_packet_data_out(),
        .S_packet_data_out(S_packet_data_out03),

        .L_packet_valid_out(packet_valid_r2p03),
        .W_packet_valid_out(W_packet_valid_out03),
        .N_packet_valid_out(),
        .E_packet_valid_out(),
        .S_packet_valid_out(S_packet_valid_out03),
        
        .L_packet_full_out(packet_fifo_wfull03),
        .W_packet_full_out(W_packet_full_out03),
        .N_packet_full_out(),
        .E_packet_full_out(),
        .S_packet_full_out(S_packet_full_out03),

        .Tail4(Tail_p2r03),
        .Tail3(E_Tail_out02),
        .Tail2(1'b0),
        .Tail1(1'b0),
        .Tail0(N_Tail_out13),
        .Stream4(Stream_p2r03),
        .Stream3(E_Stream_out02),
        .Stream2(1'b0),
        .Stream1(1'b0),
        .Stream0(N_Stream_out13),
        .Ack4(Ack_p2r03),
        .Ack3(E_Ack_Out_02),
        .Ack2(1'b0),
        .Ack1(1'b0),
        .Ack0(N_Ack_Out_13),
        .CData4(CData_p2r03),
        .CData3(E_CData_Out_02),
        .CData2(),
        .CData1(),
        .CData0(N_CData_Out_13),
        .Strobe4(Strobe_p2r03),
        .Strobe3(E_Strobe_Out_02),
        .Strobe2(1'b0),
        .Strobe1(1'b0),
        .Strobe0(N_Strobe_Out_13),
        .State4(State_p2r03),
        .State3(E_State_Out_02),
        .State2(1'b0),
        .State1(1'b0),
        .State0(N_State_Out_13),
        //.Clock4(Clock_p2r03),
        //.Clock3(E_Clock_Out_02),
        //.Clock2(1'b0),
        //.Clock1(1'b0),
        //.Clock0(N_Clock_Out_13),
        .Feedback4(Feedback_p2r03),
        .Feedback3(E_Feedback_Out_02),
        .Feedback2(1'b0),
        .Feedback1(1'b0),
        .Feedback0(N_Feedback_Out_13),

        .Ack_Out4(Ack_r2p03),    
        .Ack_Out3(W_Ack_Out_03),    
        .Ack_Out2(),    
        .Ack_Out1(),   
        .Ack_Out0(S_Ack_Out_03),    
        .CData_Out4(CData_r2p03),
        .CData_Out3(W_CData_Out_03),
        .CData_Out2(),
        .CData_Out1(),
        .CData_Out0(S_CData_Out_03),
        .Tail_Out4(Tail_r2p03),
        .Tail_Out3(W_Tail_out03),
        .Tail_Out2(),
        .Tail_Out1(),
        .Tail_Out0(S_Tail_out03),
        .Stream_Out4(Stream_r2p03),
        .Stream_Out3(W_Stream_out03),
        .Stream_Out2(),
        .Stream_Out1(),
        .Stream_Out0(S_Stream_out03),
        .Strobe_Out4(Strobe_r2p03),
        .Strobe_Out3(W_Strobe_Out_03),
        .Strobe_Out2(),
        .Strobe_Out1(), 
        .Strobe_Out0(S_Strobe_Out_03),
        .State_Out4(State_r2p03),
        .State_Out3(W_State_Out_03),
        .State_Out2(),
        .State_Out1(),
        .State_Out0(S_State_Out_03),
        //.Clock_Out4(Clock_r2p03),
        //.Clock_Out3(W_Clock_Out_03),
        //.Clock_Out2(),
        //.Clock_Out1(),
        //.Clock_Out0(S_Clock_Out_03),
        .Feedback_Out4(Feedback_r2p03),
        .Feedback_Out3(W_Feedback_Out_03),
        .Feedback_Out2(),
        .Feedback_Out1(),
        .Feedback_Out0(S_Feedback_Out_03)
    );

    Router Router30(
        .ID(4'b1100),
        .rst_n(rst_n),
        
        
        .clk(clk12),
        .clk_W(1'b0),
        .clk_N(clk8),
        .clk_E(clk13),
        .clk_S(1'b0),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r30),
        .W_packet_data_in(),
        .N_packet_data_in(S_packet_data_out20),
        .E_packet_data_in(W_packet_data_out31),
        .S_packet_data_in(),

        .L_packet_valid_in(packet_valid_p2r30),
        .W_packet_valid_in(1'b0),
        .N_packet_valid_in(S_packet_valid_out20),
        .E_packet_valid_in(W_packet_valid_out31),
        .S_packet_valid_in(1'b0),

        .W_packet_full_in(1'b0),
        .N_packet_full_in(S_packet_full_out20),
        .E_packet_full_in(W_packet_full_out31),
        .S_packet_full_in(1'b0),

        .L_packet_data_out(packet_data_r2p30),
        .W_packet_data_out(),
        .N_packet_data_out(N_packet_data_out30),
        .E_packet_data_out(E_packet_data_out30),
        .S_packet_data_out(),

        .L_packet_valid_out(packet_valid_r2p30),
        .W_packet_valid_out(),
        .N_packet_valid_out(N_packet_valid_out30),
        .E_packet_valid_out(E_packet_valid_out30),
        .S_packet_valid_out(),
        
        .L_packet_full_out(packet_fifo_wfull30),
        .W_packet_full_out(),
        .N_packet_full_out(N_packet_full_out30),
        .E_packet_full_out(E_packet_full_out30),
        .S_packet_full_out(),

        .Tail4(Tail_p2r30),
        .Tail3(1'b0),
        .Tail2(S_Tail_out20),
        .Tail1(W_Tail_out31),
        .Tail0(1'b0),
        .Stream4(Stream_p2r30),
        .Stream3(1'b0),
        .Stream2(S_Stream_out20),
        .Stream1(W_Stream_out31),
        .Stream0(1'b0),
        .Ack4(Ack_p2r30),
        .Ack3(1'b0),
        .Ack2(S_Ack_Out_20),
        .Ack1(W_Ack_Out_31),
        .Ack0(1'b0),
        .CData4(CData_p2r30),
        .CData3(),
        .CData2(S_CData_Out_20),
        .CData1(W_CData_Out_31),
        .CData0(),
        .Strobe4(Strobe_p2r30),
        .Strobe3(1'b0),
        .Strobe2(S_Strobe_Out_20),
        .Strobe1(W_Strobe_Out_31),
        .Strobe0(1'b0),
        .State4(State_p2r30),
        .State3(1'b0),
        .State2(S_State_Out_20),
        .State1(W_State_Out_31),
        .State0(1'b0),
        //.Clock4(Clock_p2r30),
        //.Clock3(1'b0),
        //.Clock2(S_Clock_Out_20),
        //.Clock1(W_Clock_Out_31),
        //.Clock0(1'b0),
        .Feedback4(Feedback_p2r30),
        .Feedback3(1'b0),
        .Feedback2(S_Feedback_Out_20),
        .Feedback1(W_Feedback_Out_31),
        .Feedback0(1'b0),

        .Ack_Out4(Ack_r2p30),    
        .Ack_Out3(),    
        .Ack_Out2(N_Ack_Out_30),    
        .Ack_Out1(E_Ack_Out_30),   
        .Ack_Out0(),    
        .CData_Out4(CData_r2p30),
        .CData_Out3(),
        .CData_Out2(N_CData_Out_30),
        .CData_Out1(E_CData_Out_30),
        .CData_Out0(),
        .Tail_Out4(Tail_r2p30),
        .Tail_Out3(),
        .Tail_Out2(N_Tail_out30),
        .Tail_Out1(E_Tail_out30),
        .Tail_Out0(),
        .Stream_Out4(Stream_r2p30),
        .Stream_Out3(),
        .Stream_Out2(N_Stream_out30),
        .Stream_Out1(E_Stream_out30),
        .Stream_Out0(),
        .Strobe_Out4(Strobe_r2p30),
        .Strobe_Out3(),
        .Strobe_Out2(N_Strobe_Out_30),
        .Strobe_Out1(E_Strobe_Out_30), 
        .Strobe_Out0(),
        .State_Out4(State_r2p30),
        .State_Out3(),
        .State_Out2(N_State_Out_30),
        .State_Out1(E_State_Out_30),
        .State_Out0(),
        //.Clock_Out4(Clock_r2p30),
        //.Clock_Out3(),
        //.Clock_Out2(N_Clock_Out_30),
        //.Clock_Out1(E_Clock_Out_30),
        //.Clock_Out0(),
        .Feedback_Out4(Feedback_r2p30),
        .Feedback_Out3(),
        .Feedback_Out2(N_Feedback_Out_30),
        .Feedback_Out1(E_Feedback_Out_30),
        .Feedback_Out0()
    );

    Router Router33(
        .ID(4'b1111),
        .rst_n(rst_n),
        
        .clk(clk15),
        .clk_W(clk14),
        .clk_N(clk11),
        .clk_E(1'b0),
        .clk_S(1'b0),
        .test_mode(test_mode),

        .L_packet_data_in(packet_data_p2r33),
        .W_packet_data_in(E_packet_data_out32),
        .N_packet_data_in(S_packet_data_out23),
        .E_packet_data_in(),
        .S_packet_data_in(),

        .L_packet_valid_in(packet_valid_p2r33),
        .W_packet_valid_in(E_packet_valid_out32),
        .N_packet_valid_in(S_packet_valid_out23),
        .E_packet_valid_in(1'b0),
        .S_packet_valid_in(1'b0),

        .W_packet_full_in(E_packet_full_out32),
        .N_packet_full_in(S_packet_full_out23),
        .E_packet_full_in(1'b0),
        .S_packet_full_in(1'b0),

        .L_packet_data_out(packet_data_r2p33),
        .W_packet_data_out(W_packet_data_out33),
        .N_packet_data_out(N_packet_data_out33),
        .E_packet_data_out(),
        .S_packet_data_out(),

        .L_packet_valid_out(packet_valid_r2p33),
        .W_packet_valid_out(W_packet_valid_out33),
        .N_packet_valid_out(N_packet_valid_out33),
        .E_packet_valid_out(),
        .S_packet_valid_out(),
        
        .L_packet_full_out(packet_fifo_wfull33),
        .W_packet_full_out(W_packet_full_out33),
        .N_packet_full_out(N_packet_full_out33),
        .E_packet_full_out(),
        .S_packet_full_out(),

        .Tail4(Tail_p2r33),
        .Tail3(E_Tail_out32),
        .Tail2(S_Tail_out23),
        .Tail1(1'b0),
        .Tail0(1'b0),
        .Stream4(Stream_p2r33),
        .Stream3(E_Stream_out32),
        .Stream2(S_Stream_out23),
        .Stream1(1'b0),
        .Stream0(1'b0),
        .Ack4(Ack_p2r33),
        .Ack3(E_Ack_Out_32),
        .Ack2(S_Ack_Out_23),
        .Ack1(1'b0),
        .Ack0(1'b0),
        .CData4(CData_p2r33),
        .CData3(E_CData_Out_32),
        .CData2(S_CData_Out_23),
        .CData1(),
        .CData0(),
        .Strobe4(Strobe_p2r33),
        .Strobe3(E_Strobe_Out_32),
        .Strobe2(S_Strobe_Out_23),
        .Strobe1(1'b0),
        .Strobe0(1'b0),
        .State4(State_p2r33),
        .State3(E_State_Out_32),
        .State2(S_State_Out_23),
        .State1(1'b0),
        .State0(1'b0),
        //.Clock4(Clock_p2r33),
        //.Clock3(E_Clock_Out_32),
        //.Clock2(S_Clock_Out_23),
        //.Clock1(1'b0),
        //.Clock0(1'b0),
        .Feedback4(Feedback_p2r33),
        .Feedback3(E_Feedback_Out_32),
        .Feedback2(S_Feedback_Out_23),
        .Feedback1(1'b0),
        .Feedback0(1'b0),

        .Ack_Out4(Ack_r2p33),    
        .Ack_Out3(W_Ack_Out_33),    
        .Ack_Out2(N_Ack_Out_33),    
        .Ack_Out1(),   
        .Ack_Out0(),    
        .CData_Out4(CData_r2p33),
        .CData_Out3(W_CData_Out_33),
        .CData_Out2(N_CData_Out_33),
        .CData_Out1(),
        .CData_Out0(),
        .Tail_Out4(Tail_r2p33),
        .Tail_Out3(W_Tail_out33),
        .Tail_Out2(N_Tail_out33),
        .Tail_Out1(),
        .Tail_Out0(),
        .Stream_Out4(Stream_r2p33),
        .Stream_Out3(W_Stream_out33),
        .Stream_Out2(N_Stream_out33),
        .Stream_Out1(),
        .Stream_Out0(),
        .Strobe_Out4(Strobe_r2p33),
        .Strobe_Out3(W_Strobe_Out_33),
        .Strobe_Out2(N_Strobe_Out_33),
        .Strobe_Out1(), 
        .Strobe_Out0(),
        .State_Out4(State_r2p33),
        .State_Out3(W_State_Out_33),
        .State_Out2(N_State_Out_33),
        .State_Out1(),
        .State_Out0(),
        //.Clock_Out4(Clock_r2p33),
        //.Clock_Out3(W_Clock_Out_33),
        //.Clock_Out2(N_Clock_Out_33),
        //.Clock_Out1(),
        //.Clock_Out0(),
        .Feedback_Out4(Feedback_r2p33),
        .Feedback_Out3(W_Feedback_Out_33),
        .Feedback_Out2(N_Feedback_Out_33),
        .Feedback_Out1(),
        .Feedback_Out0()
    );

    global_cnt global_cnt(
        .clk_global(clk_global),
        .rst_n(rst_n),
        .enable_wire(enable_wire),
        .enable_global(enable_global),

        .counter_num(time_stamp_local),
        .counter_out(time_stamp_global),
        // .cnt_full(),

        .packet_side_en(test_mode[0]),

        .receive_packet_finish_flag00(receive_packet_finish_flag00),
        .receive_packet_finish_flag01(receive_packet_finish_flag01),
        .receive_packet_finish_flag02(receive_packet_finish_flag02),
        .receive_packet_finish_flag03(receive_packet_finish_flag03),
        .receive_packet_finish_flag10(receive_packet_finish_flag10),
        .receive_packet_finish_flag11(receive_packet_finish_flag11),
        .receive_packet_finish_flag12(receive_packet_finish_flag12),
        .receive_packet_finish_flag13(receive_packet_finish_flag13),
        .receive_packet_finish_flag20(receive_packet_finish_flag20),
        .receive_packet_finish_flag21(receive_packet_finish_flag21),
        .receive_packet_finish_flag22(receive_packet_finish_flag22),
        .receive_packet_finish_flag23(receive_packet_finish_flag23),
        .receive_packet_finish_flag30(receive_packet_finish_flag30),
        .receive_packet_finish_flag31(receive_packet_finish_flag31),
        .receive_packet_finish_flag32(receive_packet_finish_flag32),
        .receive_packet_finish_flag33(receive_packet_finish_flag33),


        .receive_finish_flag00(receive_finish_flag00),
        .receive_finish_flag01(receive_finish_flag01),
        .receive_finish_flag02(receive_finish_flag02),
        .receive_finish_flag03(receive_finish_flag03),
        .receive_finish_flag10(receive_finish_flag10),
        .receive_finish_flag11(receive_finish_flag11),
        .receive_finish_flag12(receive_finish_flag12),
        .receive_finish_flag13(receive_finish_flag13),
        .receive_finish_flag20(receive_finish_flag20),
        .receive_finish_flag21(receive_finish_flag21),
        .receive_finish_flag22(receive_finish_flag22),
        .receive_finish_flag23(receive_finish_flag23),
        .receive_finish_flag30(receive_finish_flag30),
        .receive_finish_flag31(receive_finish_flag31),
        .receive_finish_flag32(receive_finish_flag32),
        .receive_finish_flag33(receive_finish_flag33)
    );


endmodule
