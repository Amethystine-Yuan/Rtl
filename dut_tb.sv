`include "./noc_define.v"
`timescale 1ns/1ps

module dut_tb ();

    reg [10:0] T0, T1, T2, T3;
    reg [10:0] T4, T5, T6, T7;
    reg [10:0] T8, T9, T10, T11;
    reg [10:0] T12, T13, T14, T15;
    reg [10:0] T_global;
    reg clk_global;
    reg clk0, clk1, clk2, clk3;
    reg clk4, clk5, clk6, clk7;
    reg clk8, clk9, clk10, clk11;
    reg clk12, clk13, clk14, clk15;
    reg clk_global_ori;
    reg clk0_ori, clk1_ori, clk2_ori, clk3_ori;
    reg clk4_ori, clk5_ori, clk6_ori, clk7_ori;
    reg clk8_ori, clk9_ori, clk10_ori, clk11_ori;
    reg clk12_ori, clk13_ori, clk14_ori, clk15_ori;
    reg rst_n, rst_n1, rst_n2, rst_n3;
    reg enable_wire;
    reg [79:0] dvfs_config;
    reg [4:0] mode_wire;
    reg [10:0] interval_wire;
    reg [3:0] hotpot_target;
    reg [`stream_cnt_width-1:0] Stream_Length;
    reg [3:0] DATA_WIDTH_DBG;
    // wire [5:0] DATA_WIDTH_DBG;
    wire  receive_finish_flag00;
    wire  receive_finish_flag01;
    wire  receive_finish_flag02;
    wire  receive_finish_flag03;
    wire  receive_finish_flag10;
    wire  receive_finish_flag11;
    wire  receive_finish_flag12;
    wire  receive_finish_flag13;
    wire  receive_finish_flag20;
    wire  receive_finish_flag21;
    wire  receive_finish_flag22;
    wire  receive_finish_flag23;
    wire  receive_finish_flag30;
    wire  receive_finish_flag31;
    wire  receive_finish_flag32;
    wire  receive_finish_flag33;

    wire  receive_packet_finish_flag00;
    wire  receive_packet_finish_flag01;
    wire  receive_packet_finish_flag02;
    wire  receive_packet_finish_flag03;
    wire  receive_packet_finish_flag10;
    wire  receive_packet_finish_flag11;
    wire  receive_packet_finish_flag12;
    wire  receive_packet_finish_flag13;
    wire  receive_packet_finish_flag20;
    wire  receive_packet_finish_flag21;
    wire  receive_packet_finish_flag22;
    wire  receive_packet_finish_flag23;
    wire  receive_packet_finish_flag30;
    wire  receive_packet_finish_flag31;
    wire  receive_packet_finish_flag32;
    wire  receive_packet_finish_flag33;

    wire [31:0]             time_stamp_global;

    wire [`TIME_WIDTH-1:0]          cdata_stream_latency00;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency01;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency02;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency03;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency10;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency11;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency12;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency13;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency20;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency21;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency22;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency23;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency30;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency31;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency32;
    wire [`TIME_WIDTH-1:0]          cdata_stream_latency33;   

    wire  [10:0]                     receive_patch_num00;
    wire  [10:0]                     receive_patch_num01;
    wire  [10:0]                     receive_patch_num02;
    wire  [10:0]                     receive_patch_num03;
    wire  [10:0]                     receive_patch_num10;
    wire  [10:0]                     receive_patch_num11;
    wire  [10:0]                     receive_patch_num12;
    wire  [10:0]                     receive_patch_num13;
    wire  [10:0]                     receive_patch_num20;
    wire  [10:0]                     receive_patch_num21;
    wire  [10:0]                     receive_patch_num22;
    wire  [10:0]                     receive_patch_num23;
    wire  [10:0]                     receive_patch_num30;
    wire  [10:0]                     receive_patch_num31;
    wire  [10:0]                     receive_patch_num32;
    wire  [10:0]                     receive_patch_num33;

    wire  [10:0]                     receive_packet_patch_num00;
    wire  [10:0]                     receive_packet_patch_num01;
    wire  [10:0]                     receive_packet_patch_num02;
    wire  [10:0]                     receive_packet_patch_num03;
    wire  [10:0]                     receive_packet_patch_num10;
    wire  [10:0]                     receive_packet_patch_num11;
    wire  [10:0]                     receive_packet_patch_num12;
    wire  [10:0]                     receive_packet_patch_num13;
    wire  [10:0]                     receive_packet_patch_num20;
    wire  [10:0]                     receive_packet_patch_num21;
    wire  [10:0]                     receive_packet_patch_num22;
    wire  [10:0]                     receive_packet_patch_num23;
    wire  [10:0]                     receive_packet_patch_num30;
    wire  [10:0]                     receive_packet_patch_num31;
    wire  [10:0]                     receive_packet_patch_num32;
    wire  [10:0]                     receive_packet_patch_num33;



    // 20241205 Add dbg signals
    wire  [10:0]                      send_packet_patch_num00;
    wire  [10:0]                      send_packet_patch_num01;
    wire  [10:0]                      send_packet_patch_num02;
    wire  [10:0]                      send_packet_patch_num03;
    wire  [10:0]                      send_packet_patch_num10;
    wire  [10:0]                      send_packet_patch_num11;
    wire  [10:0]                      send_packet_patch_num12;
    wire  [10:0]                      send_packet_patch_num13;
    wire  [10:0]                      send_packet_patch_num20;
    wire  [10:0]                      send_packet_patch_num21;
    wire  [10:0]                      send_packet_patch_num22;
    wire  [10:0]                      send_packet_patch_num23;
    wire  [10:0]                      send_packet_patch_num30;
    wire  [10:0]                      send_packet_patch_num31;
    wire  [10:0]                      send_packet_patch_num32;
    wire  [10:0]                      send_packet_patch_num33;

    wire  [10:0]                      send_patch_num00;
    wire  [10:0]                      send_patch_num01;
    wire  [10:0]                      send_patch_num02;
    wire  [10:0]                      send_patch_num03;
    wire  [10:0]                      send_patch_num10;
    wire  [10:0]                      send_patch_num11;
    wire  [10:0]                      send_patch_num12;
    wire  [10:0]                      send_patch_num13;
    wire  [10:0]                      send_patch_num20;
    wire  [10:0]                      send_patch_num21;
    wire  [10:0]                      send_patch_num22;
    wire  [10:0]                      send_patch_num23;
    wire  [10:0]                      send_patch_num30;
    wire  [10:0]                      send_patch_num31;
    wire  [10:0]                      send_patch_num32;
    wire  [10:0]                      send_patch_num33;

    wire  [10:0]                      req_p2r_cnt00;
    wire  [10:0]                      req_p2r_cnt01;
    wire  [10:0]                      req_p2r_cnt02;
    wire  [10:0]                      req_p2r_cnt03;
    wire  [10:0]                      req_p2r_cnt10;
    wire  [10:0]                      req_p2r_cnt11;
    wire  [10:0]                      req_p2r_cnt12;
    wire  [10:0]                      req_p2r_cnt13;
    wire  [10:0]                      req_p2r_cnt20;
    wire  [10:0]                      req_p2r_cnt21;
    wire  [10:0]                      req_p2r_cnt22;
    wire  [10:0]                      req_p2r_cnt23;
    wire  [10:0]                      req_p2r_cnt30;
    wire  [10:0]                      req_p2r_cnt31;
    wire  [10:0]                      req_p2r_cnt32;
    wire  [10:0]                      req_p2r_cnt33;

    wire  [10:0]                      req_r2p_cnt00;
    wire  [10:0]                      req_r2p_cnt01;
    wire  [10:0]                      req_r2p_cnt02;
    wire  [10:0]                      req_r2p_cnt03;
    wire  [10:0]                      req_r2p_cnt10;
    wire  [10:0]                      req_r2p_cnt11;
    wire  [10:0]                      req_r2p_cnt12;
    wire  [10:0]                      req_r2p_cnt13;
    wire  [10:0]                      req_r2p_cnt20;
    wire  [10:0]                      req_r2p_cnt21;
    wire  [10:0]                      req_r2p_cnt22;
    wire  [10:0]                      req_r2p_cnt23;
    wire  [10:0]                      req_r2p_cnt30;
    wire  [10:0]                      req_r2p_cnt31;
    wire  [10:0]                      req_r2p_cnt32;
    wire  [10:0]                      req_r2p_cnt33;

    wire  [10:0]                      ack_p2r_cnt00;
    wire  [10:0]                      ack_p2r_cnt01;
    wire  [10:0]                      ack_p2r_cnt02;
    wire  [10:0]                      ack_p2r_cnt03;
    wire  [10:0]                      ack_p2r_cnt10;
    wire  [10:0]                      ack_p2r_cnt11;
    wire  [10:0]                      ack_p2r_cnt12;
    wire  [10:0]                      ack_p2r_cnt13;
    wire  [10:0]                      ack_p2r_cnt20;
    wire  [10:0]                      ack_p2r_cnt21;
    wire  [10:0]                      ack_p2r_cnt22;
    wire  [10:0]                      ack_p2r_cnt23;
    wire  [10:0]                      ack_p2r_cnt30;
    wire  [10:0]                      ack_p2r_cnt31;
    wire  [10:0]                      ack_p2r_cnt32;
    wire  [10:0]                      ack_p2r_cnt33;

    wire  [10:0]                      ack_r2p_cnt00;
    wire  [10:0]                      ack_r2p_cnt01;
    wire  [10:0]                      ack_r2p_cnt02;
    wire  [10:0]                      ack_r2p_cnt03;
    wire  [10:0]                      ack_r2p_cnt10;
    wire  [10:0]                      ack_r2p_cnt11;
    wire  [10:0]                      ack_r2p_cnt12;
    wire  [10:0]                      ack_r2p_cnt13;
    wire  [10:0]                      ack_r2p_cnt20;
    wire  [10:0]                      ack_r2p_cnt21;
    wire  [10:0]                      ack_r2p_cnt22;
    wire  [10:0]                      ack_r2p_cnt23;
    wire  [10:0]                      ack_r2p_cnt30;
    wire  [10:0]                      ack_r2p_cnt31;
    wire  [10:0]                      ack_r2p_cnt32;
    wire  [10:0]                      ack_r2p_cnt33;


    wire [`SUM_WIDTH-1:0]    latency_sum_circuit00;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit01;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit02;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit03;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit10;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit11;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit12;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit13;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit20;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit21;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit22;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit23;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit30;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit31;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit32;
    wire [`SUM_WIDTH-1:0]    latency_sum_circuit33;
    
    wire [`MIN_WIDTH-1:0]    latency_min_circuit00;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit01;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit02;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit03;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit10;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit11;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit12;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit13;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit20;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit21;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit22;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit23;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit30;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit31;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit32;
    wire [`MIN_WIDTH-1:0]    latency_min_circuit33;

    wire [`MAX_WIDTH-1:0]    latency_max_circuit00;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit01;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit02;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit03;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit10;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit11;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit12;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit13;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit20;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit21;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit22;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit23;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit30;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit31;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit32;
    wire [`MAX_WIDTH-1:0]    latency_max_circuit33;

    reg [1:0] test_mode;
    reg [4:0] pe_verify_sel;

    wire clk_test;
    wire clk_global_test;
    wire [3:0] rst_n_test;
    wire [15:0] scan_in_test;
    wire [93:0] signal_test;



    wire  error_circuit00;
    wire  error_circuit01;
    wire  error_circuit02;
    wire  error_circuit03;
    wire  error_circuit10;
    wire  error_circuit11;
    wire  error_circuit12;
    wire  error_circuit13;
    wire  error_circuit20;
    wire  error_circuit21;
    wire  error_circuit22;
    wire  error_circuit23;
    wire  error_circuit30;
    wire  error_circuit31;
    wire  error_circuit32;
    wire  error_circuit33;

    wire  error_packet00;
    wire  error_packet01;
    wire  error_packet02;
    wire  error_packet03;
    wire  error_packet10;
    wire  error_packet11;
    wire  error_packet12;
    wire  error_packet13;
    wire  error_packet20;
    wire  error_packet21;
    wire  error_packet22;
    wire  error_packet23;
    wire  error_packet30;
    wire  error_packet31;
    wire  error_packet32;
    wire  error_packet33;

// initial begin
//     $dumpfile("test_0822.vcd");
//     $dumpvars(0,dut);
// end

// initial begin
//     $dumpfile("test_0905.vcd");
//     $dumpvars(0,dut);
// end


// initial begin
//     $dumpfile("test_0822_2.vcd");
//     $dumpvars(2,dut);
// end


    NoC dut(
        .clk_global(clk_global),
        .clk0(clk0), .clk1(clk1), .clk2(clk2), .clk3(clk3),
        .clk4(clk4), .clk5(clk5), .clk6(clk6), .clk7(clk7),
        .clk8(clk8), .clk9(clk9), .clk10(clk10), .clk11(clk11),
        .clk12(clk12), .clk13(clk13), .clk14(clk14), .clk15(clk15),
        .rst_n(rst_n), 
        // .rst_n1(rst_n1), .rst_n2(rst_n2), .rst_n3(rst_n3),
        .enable_wire(enable_wire),
        .dvfs_config(dvfs_config),
        .mode_wire(mode_wire),
        .interval_wire(interval_wire),
        .hotpot_target(4'b0011),
        .Stream_Length(Stream_Length),
        .DATA_WIDTH_DBG(DATA_WIDTH_DBG),
        .test_mode(test_mode),
        // .pe_verify_sel(pe_verify_sel),
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
        .receive_finish_flag33(receive_finish_flag33),
        .time_stamp_global(time_stamp_global),

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

        .error_circuit00(error_circuit00),
        .error_circuit01(error_circuit01),
        .error_circuit02(error_circuit02),
        .error_circuit03(error_circuit03),
        .error_circuit10(error_circuit10),
        .error_circuit11(error_circuit11),
        .error_circuit12(error_circuit12),
        .error_circuit13(error_circuit13),
        .error_circuit20(error_circuit20),
        .error_circuit21(error_circuit21),
        .error_circuit22(error_circuit22),
        .error_circuit23(error_circuit23),
        .error_circuit30(error_circuit30),
        .error_circuit31(error_circuit31),
        .error_circuit32(error_circuit32),
        .error_circuit33(error_circuit33),

        .error_packet00(error_packet00),
        .error_packet01(error_packet01),
        .error_packet02(error_packet02),
        .error_packet03(error_packet03),
        .error_packet10(error_packet10),
        .error_packet11(error_packet11),
        .error_packet12(error_packet12),
        .error_packet13(error_packet13),
        .error_packet20(error_packet20),
        .error_packet21(error_packet21),
        .error_packet22(error_packet22),
        .error_packet23(error_packet23),
        .error_packet30(error_packet30),
        .error_packet31(error_packet31),
        .error_packet32(error_packet32),
        .error_packet33(error_packet33),

        .cdata_stream_latency00(cdata_stream_latency00),
        .cdata_stream_latency01(cdata_stream_latency01),
        .cdata_stream_latency02(cdata_stream_latency02),
        .cdata_stream_latency03(cdata_stream_latency03),
        .cdata_stream_latency10(cdata_stream_latency10),
        .cdata_stream_latency11(cdata_stream_latency11),
        .cdata_stream_latency12(cdata_stream_latency12),
        .cdata_stream_latency13(cdata_stream_latency13),
        .cdata_stream_latency20(cdata_stream_latency20),
        .cdata_stream_latency21(cdata_stream_latency21),
        .cdata_stream_latency22(cdata_stream_latency22),
        .cdata_stream_latency23(cdata_stream_latency23),
        .cdata_stream_latency30(cdata_stream_latency30),
        .cdata_stream_latency31(cdata_stream_latency31),
        .cdata_stream_latency32(cdata_stream_latency32),
        .cdata_stream_latency33(cdata_stream_latency33),   

        .receive_patch_num00(receive_patch_num00),
        .receive_patch_num01(receive_patch_num01),
        .receive_patch_num02(receive_patch_num02),
        .receive_patch_num03(receive_patch_num03),
        .receive_patch_num10(receive_patch_num10),
        .receive_patch_num11(receive_patch_num11),
        .receive_patch_num12(receive_patch_num12),
        .receive_patch_num13(receive_patch_num13),
        .receive_patch_num20(receive_patch_num20),
        .receive_patch_num21(receive_patch_num21),
        .receive_patch_num22(receive_patch_num22),
        .receive_patch_num23(receive_patch_num23),
        .receive_patch_num30(receive_patch_num30),
        .receive_patch_num31(receive_patch_num31),
        .receive_patch_num32(receive_patch_num32),
        .receive_patch_num33(receive_patch_num33),

        .receive_packet_patch_num00(receive_packet_patch_num00),
        .receive_packet_patch_num01(receive_packet_patch_num01),
        .receive_packet_patch_num02(receive_packet_patch_num02),
        .receive_packet_patch_num03(receive_packet_patch_num03),
        .receive_packet_patch_num10(receive_packet_patch_num10),
        .receive_packet_patch_num11(receive_packet_patch_num11),
        .receive_packet_patch_num12(receive_packet_patch_num12),
        .receive_packet_patch_num13(receive_packet_patch_num13),
        .receive_packet_patch_num20(receive_packet_patch_num20),
        .receive_packet_patch_num21(receive_packet_patch_num21),
        .receive_packet_patch_num22(receive_packet_patch_num22),
        .receive_packet_patch_num23(receive_packet_patch_num23),
        .receive_packet_patch_num30(receive_packet_patch_num30),
        .receive_packet_patch_num31(receive_packet_patch_num31),
        .receive_packet_patch_num32(receive_packet_patch_num32),
        .receive_packet_patch_num33(receive_packet_patch_num33),

        .latency_sum_circuit00(latency_sum_circuit00),
        .latency_sum_circuit01(latency_sum_circuit01),
        .latency_sum_circuit02(latency_sum_circuit02),
        .latency_sum_circuit03(latency_sum_circuit03),
        .latency_sum_circuit10(latency_sum_circuit10),
        .latency_sum_circuit11(latency_sum_circuit11),
        .latency_sum_circuit12(latency_sum_circuit12),
        .latency_sum_circuit13(latency_sum_circuit13),
        .latency_sum_circuit20(latency_sum_circuit20),
        .latency_sum_circuit21(latency_sum_circuit21),
        .latency_sum_circuit22(latency_sum_circuit22),
        .latency_sum_circuit23(latency_sum_circuit23),
        .latency_sum_circuit30(latency_sum_circuit30),
        .latency_sum_circuit31(latency_sum_circuit31),
        .latency_sum_circuit32(latency_sum_circuit32),
        .latency_sum_circuit33(latency_sum_circuit33),

        .latency_min_circuit00(latency_min_circuit00),
        .latency_min_circuit01(latency_min_circuit01),
        .latency_min_circuit02(latency_min_circuit02),
        .latency_min_circuit03(latency_min_circuit03),
        .latency_min_circuit10(latency_min_circuit10),
        .latency_min_circuit11(latency_min_circuit11),
        .latency_min_circuit12(latency_min_circuit12),
        .latency_min_circuit13(latency_min_circuit13),
        .latency_min_circuit20(latency_min_circuit20),
        .latency_min_circuit21(latency_min_circuit21),
        .latency_min_circuit22(latency_min_circuit22),
        .latency_min_circuit23(latency_min_circuit23),
        .latency_min_circuit30(latency_min_circuit30),
        .latency_min_circuit31(latency_min_circuit31),
        .latency_min_circuit32(latency_min_circuit32),
        .latency_min_circuit33(latency_min_circuit33),

        .latency_max_circuit00(latency_max_circuit00),
        .latency_max_circuit01(latency_max_circuit01),
        .latency_max_circuit02(latency_max_circuit02),
        .latency_max_circuit03(latency_max_circuit03),
        .latency_max_circuit10(latency_max_circuit10),
        .latency_max_circuit11(latency_max_circuit11),
        .latency_max_circuit12(latency_max_circuit12),
        .latency_max_circuit13(latency_max_circuit13),
        .latency_max_circuit20(latency_max_circuit20),
        .latency_max_circuit21(latency_max_circuit21),
        .latency_max_circuit22(latency_max_circuit22),
        .latency_max_circuit23(latency_max_circuit23),
        .latency_max_circuit30(latency_max_circuit30),
        .latency_max_circuit31(latency_max_circuit31),
        .latency_max_circuit32(latency_max_circuit32),
        .latency_max_circuit33(latency_max_circuit33),


        .send_packet_patch_num00(send_packet_patch_num00),
        .send_packet_patch_num01(send_packet_patch_num01),
        .send_packet_patch_num02(send_packet_patch_num02),
        .send_packet_patch_num03(send_packet_patch_num03),
        .send_packet_patch_num10(send_packet_patch_num10),
        .send_packet_patch_num11(send_packet_patch_num11),
        .send_packet_patch_num12(send_packet_patch_num12),
        .send_packet_patch_num13(send_packet_patch_num13),
        .send_packet_patch_num20(send_packet_patch_num20),
        .send_packet_patch_num21(send_packet_patch_num21),
        .send_packet_patch_num22(send_packet_patch_num22),
        .send_packet_patch_num23(send_packet_patch_num23),
        .send_packet_patch_num30(send_packet_patch_num30),
        .send_packet_patch_num31(send_packet_patch_num31),
        .send_packet_patch_num32(send_packet_patch_num32),
        .send_packet_patch_num33(send_packet_patch_num33),

        .send_patch_num00(send_patch_num00),
        .send_patch_num01(send_patch_num01),
        .send_patch_num02(send_patch_num02),
        .send_patch_num03(send_patch_num03),
        .send_patch_num10(send_patch_num10),
        .send_patch_num11(send_patch_num11),
        .send_patch_num12(send_patch_num12),
        .send_patch_num13(send_patch_num13),
        .send_patch_num20(send_patch_num20),
        .send_patch_num21(send_patch_num21),
        .send_patch_num22(send_patch_num22),
        .send_patch_num23(send_patch_num23),
        .send_patch_num30(send_patch_num30),
        .send_patch_num31(send_patch_num31),
        .send_patch_num32(send_patch_num32),
        .send_patch_num33(send_patch_num33),

        .req_p2r_cnt00(req_p2r_cnt00),
        .req_p2r_cnt01(req_p2r_cnt01),
        .req_p2r_cnt02(req_p2r_cnt02),
        .req_p2r_cnt03(req_p2r_cnt03),
        .req_p2r_cnt10(req_p2r_cnt10),
        .req_p2r_cnt11(req_p2r_cnt11),
        .req_p2r_cnt12(req_p2r_cnt12),
        .req_p2r_cnt13(req_p2r_cnt13),
        .req_p2r_cnt20(req_p2r_cnt20),
        .req_p2r_cnt21(req_p2r_cnt21),
        .req_p2r_cnt22(req_p2r_cnt22),
        .req_p2r_cnt23(req_p2r_cnt23),
        .req_p2r_cnt30(req_p2r_cnt30),
        .req_p2r_cnt31(req_p2r_cnt31),
        .req_p2r_cnt32(req_p2r_cnt32),
        .req_p2r_cnt33(req_p2r_cnt33),

        .req_r2p_cnt00(req_r2p_cnt00),
        .req_r2p_cnt01(req_r2p_cnt01),
        .req_r2p_cnt02(req_r2p_cnt02),
        .req_r2p_cnt03(req_r2p_cnt03),
        .req_r2p_cnt10(req_r2p_cnt10),
        .req_r2p_cnt11(req_r2p_cnt11),
        .req_r2p_cnt12(req_r2p_cnt12),
        .req_r2p_cnt13(req_r2p_cnt13),
        .req_r2p_cnt20(req_r2p_cnt20),
        .req_r2p_cnt21(req_r2p_cnt21),
        .req_r2p_cnt22(req_r2p_cnt22),
        .req_r2p_cnt23(req_r2p_cnt23),
        .req_r2p_cnt30(req_r2p_cnt30),
        .req_r2p_cnt31(req_r2p_cnt31),
        .req_r2p_cnt32(req_r2p_cnt32),
        .req_r2p_cnt33(req_r2p_cnt33),

        .ack_p2r_cnt00(ack_p2r_cnt00),
        .ack_p2r_cnt01(ack_p2r_cnt01),
        .ack_p2r_cnt02(ack_p2r_cnt02),
        .ack_p2r_cnt03(ack_p2r_cnt03),
        .ack_p2r_cnt10(ack_p2r_cnt10),
        .ack_p2r_cnt11(ack_p2r_cnt11),
        .ack_p2r_cnt12(ack_p2r_cnt12),
        .ack_p2r_cnt13(ack_p2r_cnt13),
        .ack_p2r_cnt20(ack_p2r_cnt20),
        .ack_p2r_cnt21(ack_p2r_cnt21),
        .ack_p2r_cnt22(ack_p2r_cnt22),
        .ack_p2r_cnt23(ack_p2r_cnt23),
        .ack_p2r_cnt30(ack_p2r_cnt30),
        .ack_p2r_cnt31(ack_p2r_cnt31),
        .ack_p2r_cnt32(ack_p2r_cnt32),
        .ack_p2r_cnt33(ack_p2r_cnt33),

        .ack_r2p_cnt00(ack_r2p_cnt00),
        .ack_r2p_cnt01(ack_r2p_cnt01),
        .ack_r2p_cnt02(ack_r2p_cnt02),
        .ack_r2p_cnt03(ack_r2p_cnt03),
        .ack_r2p_cnt10(ack_r2p_cnt10),
        .ack_r2p_cnt11(ack_r2p_cnt11),
        .ack_r2p_cnt12(ack_r2p_cnt12),
        .ack_r2p_cnt13(ack_r2p_cnt13),
        .ack_r2p_cnt20(ack_r2p_cnt20),
        .ack_r2p_cnt21(ack_r2p_cnt21),
        .ack_r2p_cnt22(ack_r2p_cnt22),
        .ack_r2p_cnt23(ack_r2p_cnt23),
        .ack_r2p_cnt30(ack_r2p_cnt30),
        .ack_r2p_cnt31(ack_r2p_cnt31),
        .ack_r2p_cnt32(ack_r2p_cnt32),
        .ack_r2p_cnt33(ack_r2p_cnt33)


	// .clk_test(clk_test),
	// .clk_global_test(clk_global_test),
	// .rst_n_test(rst_n_test),
	// .scan_in_test(scan_in_test),
	// .signal_test(signal_test)


        );

wire [15:0] scan_check = {enable_wire ,mode_wire , 4'b0011, 4'd2  ,test_mode};

    task save_results;
        begin
            $fwrite(file_result, "========================================================================\n");
            $fwrite(file_result, "T0=%f, T1=%f, T2=%f, T3=%f\n", T0, T1, T2, T3);
            $fwrite(file_result, "T4=%f, T5=%f, T6=%f, T7=%f\n", T4, T5, T6, T7);
            $fwrite(file_result, "T8=%f, T9=%f, T10=%f, T11=%f\n", T8, T9, T10, T11);
            $fwrite(file_result, "T12=%f, T13=%f, T14=%f, T15=%f\n", T12, T13, T14, T15);

            $fwrite(file_result, "mode=%b, interval=%d, stream length=%d, PE_recv_flag=%b\n", mode_wire, interval_wire, Stream_Length, 
               {receive_finish_flag00, receive_finish_flag01, receive_finish_flag02, receive_finish_flag03,
                receive_finish_flag10, receive_finish_flag11, receive_finish_flag12, receive_finish_flag13,
                receive_finish_flag20, receive_finish_flag21, receive_finish_flag22, receive_finish_flag23,
                receive_finish_flag30, receive_finish_flag31, receive_finish_flag32, receive_finish_flag33 });
            $fwrite(file_result, "cdata stream interval ref = %d\n", 16*(Stream_Length+1));
            $fwrite(file_result, "time_stamp_global = %d\n", time_stamp_global);
          //  $fwrite(file_result, "throughput = %.6f Gb/s\n", 16*80*(Stream_Length+1)*(1<<DATA_WIDTH_DBG)/time_stamp_global/0.8);

            $fwrite(file_result, "=================================PE 00==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency00);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency00/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit00, 32*Stream_Length*(2*T4)/100, 32*Stream_Length*(3*T4+T0)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit00/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit00, (3*T4+T0)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit00, (2*T4)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num00);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num00));

            $fwrite(file_result, "=================================PE 01==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency01);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency01/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit01, 32*Stream_Length*(2*T5)/100, 32*Stream_Length*(3*T5+T1)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit01/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit01, (3*T5+T1)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit01, (2*T5)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num01);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num01));

            $fwrite(file_result, "=================================PE 02==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency02);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency02/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit02, 32*Stream_Length*(2*T6)/100, 32*Stream_Length*(3*T6+T2)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit02/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit02, (3*T6+T2)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit02, (2*T6)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num02);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num02));

            $fwrite(file_result, "=================================PE 03==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency03);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency03/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit03, 32*Stream_Length*(2*T7)/100, 32*Stream_Length*(3*T7+T3)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit03/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit03, (3*T7+T3)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit03, (2*T7)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num03);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num03));

            $fwrite(file_result, "=================================PE 10==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency10);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency10/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit10, 32*Stream_Length*(T4+T0)/100, 32*Stream_Length*(2*T4+T0)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit10/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit10, (2*T4+T0)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit10, (T4+T0)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num10);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num10));

            $fwrite(file_result, "=================================PE 11==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency11);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency11/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit11, 32*Stream_Length*(T5+T1)/100, 32*Stream_Length*(2*T6+T2)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit11/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit11, (2*T5+T1)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit11, (T5+T1)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num11);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num11));

            $fwrite(file_result, "=================================PE 12==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency12);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency12/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit12, 32*Stream_Length*(T6+T2)/100, 32*Stream_Length*(2*T7+T3)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit12/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit12, (2*T6+T2)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit12, (T6+T2)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num12);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num12));

            $fwrite(file_result, "=================================PE 13==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency13);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency13/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit13, 32*Stream_Length*(T7+T3)/100, 32*Stream_Length*(2*T8+T4)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit13/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit13, (2*T7+T3)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit13, (T7+T3)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num13);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num13));

            $fwrite(file_result, "=================================PE 20==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency20);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency20/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit20, 32*Stream_Length*(2*T12)/100, 32*Stream_Length*(3*T12+T8)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit20/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit20, (3*T12+T8)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit20, (2*T12)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num20);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num20));

            $fwrite(file_result, "=================================PE 21==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency21);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency21/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit21, 32*Stream_Length*(2*T13)/100, 32*Stream_Length*(3*T13+T9)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit21/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit21, (3*T13+T9)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit21, (2*T13)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num21);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num21));

            $fwrite(file_result, "=================================PE 22==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency22);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency22/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit22, 32*Stream_Length*(2*T14)/100, 32*Stream_Length*(3*T14+T10)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit22/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit22, (3*T14+T10)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit22, (2*T14)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num22);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num22));

            $fwrite(file_result, "=================================PE 23==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency23);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency23/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit23, 32*Stream_Length*(2*T15)/100, 32*Stream_Length*(3*T15+T11)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit23/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit23, (3*T15+T11)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit23, (2*T15)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num23);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num23));
            
            $fwrite(file_result, "=================================PE 30==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency30);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency30/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit30, 32*Stream_Length*(T12+T8)/100, 32*Stream_Length*(2*T12+T8)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit30/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit30, (2*T12+T8)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit30, (T12+T8)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num30);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num30));

            $fwrite(file_result, "=================================PE 31==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency31);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency31/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit31, 32*Stream_Length*(T13+T9)/100, 32*Stream_Length*(2*T5+T1)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit31/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit31, (2*T13+T9)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit31, (T13+T9)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num31);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num31));

            $fwrite(file_result, "=================================PE 32==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency32);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency32/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit32, 32*Stream_Length*(T14+T10)/100, 32*Stream_Length*(2*T5+T1)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit32/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit32, (2*T14+T10)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit32, (T14+T10)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num32);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num32));

            $fwrite(file_result, "=================================PE 33==================================\n");
            // $fwrite(file_result, "========================data min interval for TX========================\n");
            $fwrite(file_result, "cdata stream interval = %d\n", cdata_stream_latency33);
            $fwrite(file_result, "cdata stream number   = %d\n", Stream_Length+1);
            // $fwrite(file_result, "cdata min interval    = %d\n", (cdata_stream_latency33/(Stream_Length+1)));
            // $fwrite(file_result, "==========================data latency for RX===========================\n");
            $fwrite(file_result, "cdata sum latency = %d, Ref = %d ~ %d\n", latency_sum_circuit33, 32*Stream_Length*(T15+T11)/100, 32*Stream_Length*(2*T5+T1)/100);
            $fwrite(file_result, "cdata avg latency = %.3f\n", latency_sum_circuit33/32.0/(Stream_Length));
            $fwrite(file_result, "cdata max latency = %d, Ref = %d\n", latency_max_circuit33, (2*T15+T11)/100 );
            $fwrite(file_result, "cdata min latency = %d, Ref = %d\n", latency_min_circuit33, (T15+T11)/100);
            // $fwrite(file_result, "==============================Throughput================================\n");
            // $fwrite(file_result, "total time                        = %d\n", time_stamp_global);
            // $fwrite(file_result, "total epoch of CData              = %d\n", receive_patch_num33);
            // $fwrite(file_result, "CData num in every epoch          = %d\n", Stream_Length+1);
            // $fwrite(file_result, "Total num of CData during runtime = %d\n", (16*(Stream_Length+1)*receive_patch_num33));

            
            // $fwrite(file_result, "\n");
            // $fwrite(file_result, "interval=%d, total_time=%d, Total_num_of_CData_during_runtime=%d\n", interval_wire, time_stamp_global, (16*(Stream_Length+1)*receive_patch_num00));
        
        end
    endtask

    task run_test;
        input [10:0] tb_global;
        input [10:0] tb_T0;
        input [10:0] tb_T1;
        input [10:0] tb_T2;
        input [10:0] tb_T3;
        input [10:0] tb_T4;
        input [10:0] tb_T5;
        input [10:0] tb_T6;
        input [10:0] tb_T7;
        input [10:0] tb_T8;
        input [10:0] tb_T9;
        input [10:0] tb_T10;
        input [10:0] tb_T11;
        input [10:0] tb_T12;
        input [10:0] tb_T13;
        input [10:0] tb_T14;
        input [10:0] tb_T15;
        input [4:0] tb_mode;
        input [10:0] tb_interval;
        input [`stream_cnt_width-1:0] tb_stream_length;
        input [4:0] tb_DATA_WIDTH_DBG;
        input [1:0] tb_test_mode;
        input [79:0] tb_dvfs_config;
        // input [4:0] tb_pe_verify_sel;
        begin
            T_global = tb_global;
            T0  = tb_T0;
            T1  = tb_T1;
            T2  = tb_T2;
            T3  = tb_T3;
            T4  = tb_T4;
            T5  = tb_T5;
            T6  = tb_T6;
            T7  = tb_T7;
            T8  = tb_T8;
            T9  = tb_T9;
            T10 = tb_T10;
            T11 = tb_T11;
            T12 = tb_T12;
            T13 = tb_T13;
            T14 = tb_T14;
            T15 = tb_T15;
            mode_wire = tb_mode;
            interval_wire = tb_interval;
            Stream_Length = tb_stream_length;
            test_mode = tb_test_mode;
            dvfs_config = tb_dvfs_config;
            // pe_verify_sel = tb_pe_verify_sel;
            DATA_WIDTH_DBG = tb_DATA_WIDTH_DBG;

            enable_wire = 0;
            rst_n = 0;

            #(1*tb_global)
            // #(100*tb_global)
		    rst_n = 0;

            #(3);
            #(1*tb_global) //100
		    rst_n = 1;

            #(3);
            #(1*tb_global) //100


            #(11);
            #(1*tb_global)//50
		    enable_wire = 1;

            while( test_mode[0] 
                 ? ~( receive_packet_finish_flag00 & receive_packet_finish_flag01 & receive_packet_finish_flag02 & receive_packet_finish_flag03
                    & receive_packet_finish_flag10 & receive_packet_finish_flag11 & receive_packet_finish_flag12 & receive_packet_finish_flag13
                    & receive_packet_finish_flag20 & receive_packet_finish_flag21 & receive_packet_finish_flag22 & receive_packet_finish_flag23
                    & receive_packet_finish_flag30 & receive_packet_finish_flag31 & receive_packet_finish_flag32 & receive_packet_finish_flag33       
                 ) 
                 : ~( receive_finish_flag00 & receive_finish_flag01 & receive_finish_flag02 & receive_finish_flag03
                    & receive_finish_flag10 & receive_finish_flag11 & receive_finish_flag12 & receive_finish_flag13
                    & receive_finish_flag20 & receive_finish_flag21 & receive_finish_flag22 & receive_finish_flag23
                    & receive_finish_flag30 & receive_finish_flag31 & receive_finish_flag32 & receive_finish_flag33
                ))begin
                    // #(3000*tb_global);
                    #(2*tb_global);
            end
            save_results;

            assert(
              (~( error_packet00 | error_packet01 | error_packet02 | error_packet03
                | error_packet10 | error_packet11 | error_packet12 | error_packet13
                | error_packet20 | error_packet21 | error_packet22 | error_packet23
                | error_packet30 | error_packet31 | error_packet32 | error_packet33       
                )) &
              (~( error_circuit00 | error_circuit01 | error_circuit02 | error_circuit03
                | error_circuit10 | error_circuit11 | error_circuit12 | error_circuit13
                | error_circuit20 | error_circuit21 | error_circuit22 | error_circuit23
                | error_circuit30 | error_circuit31 | error_circuit32 | error_circuit33       
                ))
            )  
            else
                $error("TRANFER FAILED");
            $display("TRANSFER SUCCESSFULLY");
        end
    endtask

    integer k;


    integer random_interval;
    integer random_stream_length;
    integer random_DATA_WIDTH_DBG;
    integer random_num;
    integer random_clk0;
    integer random_clk1;
    integer random_clk2;
    integer random_clk3;
    integer random_clk4;
    integer random_clk5;
    integer random_clk6;
    integer random_clk7;
    integer random_clk8;
    integer random_clk9;
    integer random_clk10;
    integer random_clk11;
    integer random_clk12;
    integer random_clk13;
    integer random_clk14;
    integer random_clk15;
    reg [79:0] random_dvfs_config;
    integer random_test_mode;

    integer sweep_var;



    integer file_result;
    initial begin
        // $error("TRANFER FAILED");
        file_result = $fopen("result_test_1228.txt");
        clk_global = 0;
        clk0 = 0;
        clk1 = 0;
        clk2 = 0;
        clk3 = 0;
        clk4 = 0;
        clk5 = 0;
        clk6 = 0;
        clk7 = 0;
        clk8 = 0;
        clk9 = 0;
        clk10 = 0;
        clk11 = 0;
        clk12 = 0;
        clk13 = 0;
        clk14 = 0;
        clk15 = 0;
        clk_global_ori = 0;
        clk0_ori = 0;
        clk1_ori = 0;
        clk2_ori = 0;
        clk3_ori = 0;
        clk4_ori = 0;
        clk5_ori = 0;
        clk6_ori = 0;
        clk7_ori = 0;
        clk8_ori = 0;
        clk9_ori = 0;
        clk10_ori = 0;
        clk11_ori = 0;
        clk12_ori = 0;
        clk13_ori = 0;
        clk14_ori = 0;
        clk15_ori = 0;



/*  TEMPLATE
    run_test( global_clk_period,
    core00_clk_period, core01_clk_period, core02_clk_period, core03_clk_period,
    core10_clk_period, core11_clk_period, core12_clk_period, core13_clk_period,
    core20_clk_period, core21_clk_period, core22_clk_period, core23_clk_period,
    core30_clk_period, core31_clk_period, core32_clk_period, core33_clk_period,
    5'b tb_mode, tb_interval, tb_stream_length, tb_DATA_WIDTH_DBG, tb_test_mode,
    80'b tb_dvfs_config;
    );
*/

    // mode_wire = 5'b01100;  // horizontal max throughput
    // mode_wire = 5'b01000;  // vertical   max throughput

    //1108
    // Example Test Case, Sweep DATA_WIDTH_DBG, Stream_length, Interval with 3 test modes        
   // Case1
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 100, 15, 3, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 100, 15, 3, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 100, 15, 3, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );
    
//     // Case2 
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 600, 254, 3, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 600, 254, 3, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 600, 254, 3, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );
    
//     //Case 3
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 200, 31, 4, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 200, 31, 4, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 200, 31, 4, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

        
//     // Case 4
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 500, 89, 4, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 500, 89, 4, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 500, 89, 4, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );


//     // Case 5
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 300, 63, 5, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 300, 63, 5, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 300, 63, 5, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     // Case 6

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 400, 127, 5, 2'b10,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 400, 127, 5, 2'b11,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );

    run_test(100, 
            800, 800, 800, 800,
            800, 700, 600, 500,
            800, 800, 800, 800,
            400, 300, 200, 100,
            5'b01000, 400, 127, 5, 2'b00,
            80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
            );

//     // Max Throughout
    run_test(100, 
            100, 100, 100, 100,
            100, 100, 100, 100,
            100, 100, 100, 100,
            100, 100, 100, 100,
            5'b01000, 20, 127, 5, 2'b11,
            80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
            );

    run_test(100, 
            100, 100, 100, 100,
            100, 100, 100, 100,
            100, 100, 100, 100,
            100, 100, 100, 100,
            5'b01100, 20, 127, 5, 2'b11,
            80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
            );


/*  TEMPLATE
    run_test( global_clk_period,
    core00_clk_period, core01_clk_period, core02_clk_period, core03_clk_period,
    core10_clk_period, core11_clk_period, core12_clk_period, core13_clk_period,
    core20_clk_period, core21_clk_period, core22_clk_period, core23_clk_period,
    core30_clk_period, core31_clk_period, core32_clk_period, core33_clk_period,
    5'b tb_mode, tb_interval, tb_stream_length, tb_DATA_WIDTH_DBG, tb_test_mode,
    80'b tb_dvfs_config;
    );
*/


    //Latency test, 64 frequency ratio
//     run_test(100, 
//             800, 800, 800, 800,
//             800, 700, 600, 500,
//             800, 800, 800, 800,
//             400, 300, 200, 100,
//             5'b01000, 100, 127, 5, 2'b00,
//             80'b00001_00010_00011_00100_01000_01000_01000_01000_00101_00110_00111_01000_01000_01000_01000_01000
//             );


//     run_test(100, 
//             700, 700, 700, 700,
//             700, 600, 500, 400,
//             700, 700, 700, 100,
//             300, 200, 100, 100,
//             5'b01000, 100, 127, 5, 2'b00,
//             80'b00001_00001_00010_00011_00001_00111_00111_00111_00100_00101_00110_00111_00111_00111_00111_00111
//             );

//     run_test(100, 
//             600, 600, 600, 600,
//             600, 500, 400, 300,
//             600, 600, 200, 200,
//             200, 100, 200, 100,
//             5'b01000, 100, 127, 5, 2'b00,
//             80'b00001_00010_00001_00010_00010_00010_00110_00110_00011_00100_00101_00110_00110_00110_00110_00110
//             );

//     run_test(100, 
//             500, 500, 500, 500,
//             500, 400, 300, 200,
//             500, 300, 300, 300,
//             100, 300, 200, 100,
//             5'b01000, 100, 127, 5, 2'b00,
//             80'b00001_00010_00011_00001_00011_00011_00011_00101_00010_00011_00100_00101_00101_00101_00101_00101
//             );

//     run_test(100, 
//             400, 400, 400, 400,
//             400, 300, 200, 100,
//             400, 400, 400, 400,
//             400, 300, 200, 100,
//             5'b01000, 100, 127, 5, 2'b00,
//             80'b00001_00010_00011_00100_00100_00100_00100_00100_00001_00010_00011_00100_00100_00100_00100_00100
//             );

        // vsim work.dut_tb +notimingchecks +pulse_e/80 -sdfnoerror -sdfmax /dut_tb/dut=/home/jinzeyuan/Hybrid_NoC/New_202407/NoC_1101_three_stage/pt/final_1101.sdf -voptargs=+acc

    // Random Test, Sweep DATA_WIDTH_DBG, Stream_length, Interval 
    // vsim work.dut_tb -voptargs=+acc -sv_seed random
    for(random_num = 0; random_num<8; random_num = random_num+1) begin
        random_interval = $urandom_range(40,511);
        random_stream_length = $urandom_range(9,2047);
        // random_DATA_WIDTH_DBG = $urandom_range(1,15);
        random_DATA_WIDTH_DBG = $urandom_range(1,6);

        random_clk0 = $urandom_range(1,8);
        random_clk1 = $urandom_range(1,8);
        random_clk2 = $urandom_range(1,8);
        random_clk3 = $urandom_range(1,8);
        random_clk4 = $urandom_range(1,8);
        random_clk5 = $urandom_range(1,8);
        random_clk6 = $urandom_range(1,8);
        random_clk7 = $urandom_range(1,8);
        random_clk8 = $urandom_range(1,8);
        random_clk9 = $urandom_range(1,8);
        random_clk10 = $urandom_range(1,8);
        random_clk11 = $urandom_range(1,8);
        random_clk12 = $urandom_range(1,8);
        random_clk13 = $urandom_range(1,8);
        random_clk14 = $urandom_range(1,8);
        random_clk15 = $urandom_range(1,8);

        random_dvfs_config[79:75] = random_clk15;
        random_dvfs_config[74:70] = random_clk14;
        random_dvfs_config[69:65] = random_clk13;
        random_dvfs_config[64:60] = random_clk12;
        random_dvfs_config[59:55] = random_clk11;
        random_dvfs_config[54:50] = random_clk10;
        random_dvfs_config[49:45] = random_clk9;
        random_dvfs_config[44:40] = random_clk8;
        random_dvfs_config[39:35] = random_clk7;
        random_dvfs_config[34:30] = random_clk6;
        random_dvfs_config[29:25] = random_clk5;
        random_dvfs_config[24:20] = random_clk4;
        random_dvfs_config[19:15] = random_clk3;
        random_dvfs_config[14:10] = random_clk2;
        random_dvfs_config[9:5] = random_clk1;
        random_dvfs_config[4:0] = random_clk0;

        random_test_mode = $urandom_range(0,2);
        if(random_test_mode==1)
                random_test_mode = 3;
        else random_test_mode = random_test_mode;
    
        $display("Generated random_interval: %0d", random_interval);
        $display("Generated random_stream_length: %0d", random_stream_length);
        $display("Generated random_DATA_WIDTH_DBG: %0d", random_DATA_WIDTH_DBG);
        $display("Generated random_dvfs_config: %80b", random_dvfs_config);
        $display("Generated random_test_mode: %0d", random_test_mode);
        $display("Generated frequency: %0d, %0d, %0d, %0d", random_clk0, random_clk1, random_clk2, random_clk3);
        $display("Generated frequency: %0d, %0d, %0d, %0d", random_clk4, random_clk5, random_clk6, random_clk7);
        $display("Generated frequency: %0d, %0d, %0d, %0d", random_clk8, random_clk9, random_clk10, random_clk11);
        $display("Generated frequency: %0d, %0d, %0d, %0d", random_clk12, random_clk13, random_clk14, random_clk15);
        
        run_test(100, 
            100*random_clk0,  100*random_clk1,  100*random_clk2,  100*random_clk3,
            100*random_clk4,  100*random_clk5,  100*random_clk6,  100*random_clk7,
            100*random_clk8,  100*random_clk9,  100*random_clk10, 100*random_clk11,
            100*random_clk12, 100*random_clk13, 100*random_clk14, 100*random_clk15,
            5'b01000, random_interval, random_stream_length, random_DATA_WIDTH_DBG, random_test_mode,
            random_dvfs_config
            );
    end
    
    // //sim1: max throughput, sweep interval 
    // // test_mode = 2'b11 total/packet 2'b00 CS 
    // for(sweep_var=0; sweep_var<300; sweep_var=sweep_var+10) begin
    //     run_test(100, 
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         5'b01000, sweep_var, 63, 3, 2'b11,
    //         80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
    //         );
    // end

    // //sim1: max throughput, sweep stream length 
    // // test_mode = 2'b11 total/packet 2'b00 CS 
    // for(sweep_var=7; sweep_var<847; sweep_var=sweep_var+40) begin
    //     run_test(100, 
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         5'b01000, 100, sweep_var, 3, 2'b11,
    //         80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
    //         );
    // end

    // //sim4: max throughput
    // // test_mode = 2'b10 total/packet 2'b00 CS 
    //     run_test(100, 
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         5'b01000, 0, 127, 3, 2'b10,
    //         80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
    //         );
    //     run_test(100, 
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         100, 100, 100, 100,
    //         5'b01000, 0, 127, 3, 2'b00,
    //         80'b00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001_00001
    //         );


        #(2);//50
        $stop();
    end


    always #(T_global*0.8/400.00) clk_global_ori = ~clk_global_ori;
    always #(T0*0.8/400.00)  clk0_ori = ~clk0_ori;
    always #(T1*0.8/400.00)  clk1_ori = ~clk1_ori;
    always #(T2*0.8/400.00)  clk2_ori = ~clk2_ori;
    always #(T3*0.8/400.00)  clk3_ori = ~clk3_ori;
    always #(T4*0.8/400.00)  clk4_ori = ~clk4_ori;
    always #(T5*0.8/400.00)  clk5_ori = ~clk5_ori;
    always #(T6*0.8/400.00)  clk6_ori = ~clk6_ori;
    always #(T7*0.8/400.00)  clk7_ori = ~clk7_ori;
    always #(T8*0.8/400.00)  clk8_ori = ~clk8_ori;
    always #(T9*0.8/400.00)  clk9_ori = ~clk9_ori;
    always #(T10*0.8/400.00) clk10_ori = ~clk10_ori;
    always #(T11*0.8/400.00) clk11_ori = ~clk11_ori;
    always #(T12*0.8/400.00) clk12_ori = ~clk12_ori;
    always #(T13*0.8/400.00) clk13_ori = ~clk13_ori;
    always #(T14*0.8/400.00) clk14_ori = ~clk14_ori;
    always #(T15*0.8/400.00) clk15_ori = ~clk15_ori;

//     always @(posedge clk_global_ori) clk_global <= ~clk_global;
//     always @(posedge clk0_ori) clk0 <= ~clk0;
//     always @(posedge clk1_ori) clk1 <= ~clk1;
//     always @(posedge clk2_ori) clk2 <= ~clk2;
//     always @(posedge clk3_ori) clk3 <= ~clk3;
//     always @(posedge clk4_ori) clk4 <= ~clk4;
//     always @(posedge clk5_ori) clk5 <= ~clk5;
//     always @(posedge clk6_ori) clk6 <= ~clk6;
//     always @(posedge clk7_ori) clk7 <= ~clk7;
//     always @(posedge clk8_ori) clk8 <= ~clk8;
//     always @(posedge clk9_ori) clk9 <= ~clk9;
//     always @(posedge clk10_ori) clk10 <= ~clk10;
//     always @(posedge clk11_ori) clk11 <= ~clk11;
//     always @(posedge clk12_ori) clk12 <= ~clk12;
//     always @(posedge clk13_ori) clk13 <= ~clk13;
//     always @(posedge clk14_ori) clk14 <= ~clk14;
//     always @(posedge clk15_ori) clk15 <= ~clk15;

/* clk randomize */
class gdist;
    int seed = 1;
    int mean = 0;
    int std_deviation = 5;
    function int gussian_dist();
        int random_value = $dist_normal(seed, mean, std_deviation);
        int abs_random_value = (random_value>0.0) ? random_value : -random_value;
        int true_value = (abs_random_value>=10) ? 10 : abs_random_value;
        // $display("Random Value= %d", true_value);
        return true_value;
    endfunction
endclass

gdist clk_noise0 = new;
gdist clk_noise1 = new;
gdist clk_noise2 = new;
gdist clk_noise3 = new;
gdist clk_noise4 = new;
gdist clk_noise5 = new;
gdist clk_noise6 = new;
gdist clk_noise7 = new;
gdist clk_noise8 = new;
gdist clk_noise9 = new;
gdist clk_noise10 = new;
gdist clk_noise11 = new;
gdist clk_noise12 = new;
gdist clk_noise13 = new;
gdist clk_noise14 = new;
gdist clk_noise15 = new;

reg clk_test2;
/*
    always @(posedge clk_global_ori) clk_global <= ~clk_global;
    always @(posedge clk0_ori) clk0 <= #(1*0.8/400.00) ~clk0;
    always @(posedge clk1_ori) clk1 <= #(17*0.8/400.00) ~clk1;
    always @(posedge clk2_ori) clk2 <= #(26*0.8/400.00) ~clk2;
    always @(posedge clk3_ori) clk3 <= #(53*0.8/400.00) ~clk3;
//     always @(posedge clk4_ori) clk4 <= #(11*0.8/400.00) ~clk4;
        always @(posedge clk4_ori) clk4 <= #(55*0.8/400.00) ~clk4;
    always @(posedge clk5_ori) clk5 <= #(77*0.8/400.00) ~clk5;
//     always @(posedge clk6_ori) clk6 <= #(62*0.8/400.00) ~clk6;
    always @(posedge clk6_ori) clk6 <= #(77*0.8/400.00) ~clk6;
    always @(posedge clk7_ori) clk7 <= #(42*0.8/400.00) ~clk7;
    always @(posedge clk8_ori) clk8 <= #(93*0.8/400.00) ~clk8;
    always @(posedge clk9_ori) clk9 <= #(75*0.8/400.00) ~clk9;
    always @(posedge clk10_ori) clk10 <= #(17*0.8/400.00) ~clk10;
    always @(posedge clk11_ori) clk11 <= #(89*0.8/400.00) ~clk11;
    always @(posedge clk12_ori) clk12 <= #(41*0.8/400.00) ~clk12;
    always @(posedge clk13_ori) clk13 <= #(82*0.8/400.00) ~clk13;
    always @(posedge clk14_ori) clk14 <= #(61*0.8/400.00) ~clk14;
    always @(posedge clk15_ori) clk15 <= #(71*0.8/400.00) ~clk15;

    */

  // clock randomize

    always @(posedge clk_global_ori) clk_global <= ~clk_global;
    always @(posedge clk0_ori) clk0 <= #((1+clk_noise0.gussian_dist())*0.8/400.00) ~clk0;
    always @(posedge clk1_ori) clk1 <= #((17+clk_noise1.gussian_dist())*0.8/400.00) ~clk1;
    always @(posedge clk2_ori) clk2 <= #((26+clk_noise2.gussian_dist())*0.8/400.00) ~clk2;
    always @(posedge clk3_ori) clk3 <= #((53+clk_noise3.gussian_dist())*0.8/400.00) ~clk3;
//     always @(posedge clk4_ori) clk4 <= #((11+clk_noise4.gussian_dist())*0.8/400.00) ~clk4;
        always @(posedge clk4_ori) clk4 <= #((55+clk_noise4.gussian_dist())*0.8/400.00) ~clk4;
    always @(posedge clk5_ori) clk5 <= #((77+clk_noise5.gussian_dist())*0.8/400.00) ~clk5;
//     always @(posedge clk6_ori) clk6 <= #((62+clk_noise6.gussian_dist())*0.8/400.00) ~clk6;
    always @(posedge clk6_ori) clk6 <= #((77+clk_noise6.gussian_dist())*0.8/400.00) ~clk6;
    always @(posedge clk7_ori) clk7 <= #((42+clk_noise7.gussian_dist())*0.8/400.00) ~clk7;
    always @(posedge clk8_ori) clk8 <= #((93+clk_noise8.gussian_dist())*0.8/400.00) ~clk8;
    always @(posedge clk9_ori) clk9 <= #((75+clk_noise9.gussian_dist())*0.8/400.00) ~clk9;
    always @(posedge clk10_ori) clk10 <= #((17+clk_noise10.gussian_dist())*0.8/400.00) ~clk10;
    always @(posedge clk11_ori) clk11 <= #((89+clk_noise11.gussian_dist())*0.8/400.00) ~clk11;
    always @(posedge clk12_ori) clk12 <= #((41+clk_noise12.gussian_dist())*0.8/400.00) ~clk12;
    always @(posedge clk13_ori) clk13 <= #((82+clk_noise13.gussian_dist())*0.8/400.00) ~clk13;
    always @(posedge clk14_ori) clk14 <= #((61+clk_noise14.gussian_dist())*0.8/400.00) ~clk14;
    always @(posedge clk15_ori) clk15 <= #((71+clk_noise15.gussian_dist())*0.8/400.00) ~clk15;

    integer file00, file01, file02, file03;
    integer file10, file11, file12, file13;
    integer file20, file21, file22, file23;
    integer file30, file31, file32, file33;
    // 使用层级名称直接访问子模块信号
    // always @(posedge clk0) begin
    //     if (dut.PE00.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file00, "%h", dut.PE00.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE01.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file01, "%h", dut.PE01.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE02.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file02, "%h", dut.PE02.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE03.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file03, "%h", dut.PE03.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE10.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file10, "%h", dut.PE10.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE11.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file11, "%h", dut.PE11.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE12.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file12, "%h", dut.PE12.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE13.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file13, "%h", dut.PE13.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE20.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file20, "%h", dut.PE20.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE21.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file21, "%h", dut.PE21.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE22.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file22, "%h", dut.PE22.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE23.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file23, "%h", dut.PE23.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE30.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file30, "%h", dut.PE30.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE31.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file31, "%h", dut.PE31.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE32.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file32, "%h", dut.PE32.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    //     if (dut.PE33.PE_dut.Strobe_p2r) begin
    //         $fdisplay(file33, "%h", dut.PE33.PE_dut.CData_p2r); // 将数据写入文件
    //     end
    // end



    // initial begin
    //     file00 = $fopen("PE00_out.txt", "w"); // 打开文件1.txt用于写入



    //     // 结束仿真后关闭文件
    //     #100000; // 仿真1微秒
    //     $fclose(file1);
    //     $finish;
    // end


endmodule



/*  Simulation scripts */

/*

add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel


add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel

add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/clk_sel

add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/clk_sel
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/clk_sel





add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router00/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router01/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router02/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router03/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state


add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router10/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router11/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router12/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router13/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state

add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router20/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router21/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router22/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_S/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router23/PacketSwitching/fifo/fifo_S/fifo_medac/medac_w/ctrl/state

add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router30/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router31/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router32/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_L/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_L/fifo_medac/medac_w/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_N/fifo_medac/medac_r/ctrl/state
add wave -position insertpoint sim:/dut_tb/dut/Router33/PacketSwitching/fifo/fifo_N/fifo_medac/medac_w/ctrl/state

*/