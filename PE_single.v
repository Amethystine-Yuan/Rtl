//===================================================================== 
// Description: 
//     1. Provides data transfer through PS and CS
//     2. Verify the correctness of the data, measure its latency based on global timestamps
//     3. GRLS Interface: Proposed 4-Reg Interface
//
// Designer : Shao lin, Jin zeyuan
// Revision History: 
// 2024.12.4 Fix bug: Strobe distortion during CS
// 2024.12.5 Add more dbg signals
// ====================================================================


`include "./noc_define.v"

/*
 
    PDATA Format:  TX_ADDR + RX_ADDR + TIMESTAMP + PDATA_WIDTH + SIDE TRANSFER FLAG
                      4    +    4    +     16    +      12     +          1            = 37 bits
    Available bits:   4    +               16    +      12                             = 32 bits   
    
    CDATA Format:  FLAG + TX_ADDR + RX_ADDR + TIMESTAMP + CDATA_WIDTH
                      2 +    4    +    4    +     16    +     22        = 48 bits
    Available bits:   2 +    4    +    4    +     16    +     22        = 48 bits
*/

module PE_single (
        input   wire [3:0]                      ID,
        input   wire                            clk,
        input   wire                            rst_n,

        input   wire                            enable_wire,
        input   wire [4:0]                      mode_wire,
        input   wire [10:0]                     interval_wire,
        input   wire [3:0]                      hotpot_target,
        input   wire [3:0]                      DATA_WIDTH_DBG,

        input   wire                            packet_side_en,
        output  reg  [`PDATASIZE-1:0]           packet_data_p2r,
        output  reg                             packet_valid_p2r,

        input   wire [`PDATASIZE-1:0]           packet_data_r2p,
        input   wire                            packet_valid_r2p,
        input   wire                            packet_fifo_wfull,

        input   wire                            Ack_r2p,
        output  reg                             Ack_p2r,
        input   wire [`CDATASIZE-1:0]           CData_r2p,
        output  reg [`CDATASIZE-1:0]            CData_p2r,
        input   wire                            Strobe_r2p,
        output  reg                             Strobe_p2r,
        input   wire                            State_r2p,
        output  reg                             State_p2r,
        input   wire                            Clock_r2p,
        output  reg                             Clock_p2r,
        output  wire                            Feedback_p2r,
        input   wire                            Feedback_r2p,

        input   wire [79:0]                     dvfs_config,    // frequency ratio
        input   wire [`stream_cnt_width-1:0]    Stream_Length,
        output  reg                             receive_finish_flag,
        input   wire [`TIME_WIDTH-1:0]          time_stamp_global,

        // for test
        output  reg  [`TIME_WIDTH-1:0]          cdata_stream_latency,
        output  reg  [10:0]                     receive_patch_num,

        output  reg  [10:0]                     receive_packet_patch_num,
        output  reg                             receive_packet_finish_flag,

        output reg                              error_packet,
        output reg                              error_circuit,

        output  wire [`SUM_WIDTH-1:0]           latency_sum_circuit,
        output  wire [`MIN_WIDTH-1:0]           latency_min_circuit,
        output  wire [`MAX_WIDTH-1:0]           latency_max_circuit,

        // Meta. added 
        input wire [3:0] win_sel,
        input wire [3:0] var_clk_sel_origin,
        input wire [3:0] var_clk_sel_leading,
        input wire medac_mode, // 1 for medac on; 0 for medac off

        output wire state_meta_error,
        output wire strobe1_meta_error,
        output wire strobe2_meta_error,
        output wire strobe3_meta_error,

        // for dbg 20241205

        output reg  [10:0]                      send_packet_patch_num,
        output reg  [10:0]                      send_patch_num,
        output reg  [10:0]                      req_p2r_cnt,
        output reg  [10:0]                      req_r2p_cnt,
        output reg  [10:0]                      ack_p2r_cnt,
        output reg  [10:0]                      ack_r2p_cnt
    );

    // 20241204 Strobe fix
    reg Strobe_r2p_tmp;
    always @(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n)
            Strobe_r2p_tmp <= 1'b0;
        else if(State_r2p&&(CData_r2p[`CDATA_WIDTH-1:0]==Stream_Length+1))
            Strobe_r2p_tmp <= Strobe_r2p;
        else Strobe_r2p_tmp <= Strobe_r2p_tmp;
    end

    wire Strobe_r2p_fixed = State_r2p ? Strobe_r2p : Strobe_r2p_tmp;
    //

        reg                             packet_valid_p2r1;   //req
        reg                             packet_side_valid;

    wire [`CDATASIZE-1:0] circuit_data_r2p_reg;
    reg data_valid_reg;
    reg mask_four_stage_data_valid;
    wire [`CDATASIZE-1:0] sel_data;
    wire data_valid;
    reg RX_Head, RX_Tail;
    

    ////////////////////// control signal ////////////////////////
    reg enable;
    reg [4:0] mode;
    reg [10:0] interval;
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable <= 0;
            mode <= 0;
            interval <= 0;
        end else begin
            enable <= enable_wire;
            mode <= mode_wire;
            interval <= interval_wire;
        end
    end 

    /* inject rate control */
    reg inject_enable;
    reg [10:0] inject_ctrl_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) inject_ctrl_cnt <= 0;
        else if(packet_valid_p2r1 && !packet_fifo_wfull) inject_ctrl_cnt <= 0;
        else inject_ctrl_cnt <= inject_ctrl_cnt + 1'b1;
    end
    always @(*) begin
        if((packet_valid_p2r1)&&(interval==0)&& !packet_fifo_wfull) inject_enable = 1'b1;
        else begin
            if((inject_ctrl_cnt>=interval)&&(!(packet_valid_p2r1&& !packet_fifo_wfull))) inject_enable = 1'b1;
            else inject_enable = 1'b0;
        end
    end

    /////////////////// time stamp & latency /////////////////////
    // timestamp sync. & gray2bin
    reg [`TIME_WIDTH-1:0] time_stamp;
    reg [`TIME_WIDTH-1:0] time_stamp1;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            time_stamp1 <= 0;
            time_stamp <= 0;
        end
        else begin
            time_stamp1 <= time_stamp_global;
            time_stamp <= time_stamp1;
        end
    end
    wire [`TIME_WIDTH-1:0] time_stamp_bin;
    assign  time_stamp_bin[`TIME_WIDTH-1] = time_stamp[`TIME_WIDTH-1];
    genvar p;
    generate
	for(p = 0; p <= `TIME_WIDTH-2; p = p + 1) 
		begin: gray										
            assign time_stamp_bin[p] = time_stamp_bin[p + 1] ^ time_stamp[p];
        end
    endgenerate


    // Frequency Ratio Generation, fTx:fRx = TRx:TTx = M:N = RX_Index_comp : TX_Index
    reg [4:0] RX_Index, TX_Index;
    reg [4:0] RX_Index_comp; // Period of the TX PE
        always@(*) begin
        case(sel_data[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH])
            4'b0000: RX_Index_comp = dvfs_config[4:0];
            4'b0001: RX_Index_comp = dvfs_config[9:5];
            4'b0010: RX_Index_comp = dvfs_config[14:10];
            4'b0011: RX_Index_comp = dvfs_config[19:15];
            4'b0100: RX_Index_comp = dvfs_config[24:20];
            4'b0101: RX_Index_comp = dvfs_config[29:25];
            4'b0110: RX_Index_comp = dvfs_config[34:30];
            4'b0111: RX_Index_comp = dvfs_config[39:35];
            4'b1000: RX_Index_comp = dvfs_config[44:40];
            4'b1001: RX_Index_comp = dvfs_config[49:45];
            4'b1010: RX_Index_comp = dvfs_config[54:50];
            4'b1011: RX_Index_comp = dvfs_config[59:55];
            4'b1100: RX_Index_comp = dvfs_config[64:60];
            4'b1101: RX_Index_comp = dvfs_config[69:65];
            4'b1110: RX_Index_comp = dvfs_config[74:70];
            4'b1111: RX_Index_comp = dvfs_config[79:75];
            default: RX_Index_comp = 5'b0;
        endcase
    end

    reg receive_finish_flag_tmp;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            receive_finish_flag_tmp <= 0;
        else
            receive_finish_flag_tmp <= receive_finish_flag;     
    end

    latency_comp latency_comp(
        .clk(clk),
        .TX_Index(RX_Index_comp),
        .RX_Index(TX_Index),
        .rst_n(rst_n),
        .time_stamp(time_stamp),
        .CData(sel_data),
        // .EN(data_valid&&(sel_data[`CDATASIZE-2]==1'b0)),
        .EN((RX_Head||mask_four_stage_data_valid)&&data_valid),
        .receive_finish_flag(receive_finish_flag_tmp), // Delay 1 cycle 
        .latency_sum_circuit(latency_sum_circuit),
        .latency_min_circuit(latency_min_circuit),
        .latency_max_circuit(latency_max_circuit)
    );


    wire [3:0] RX_ID, TX_ID;
    reg issue_flag;

    //////////////////////////////// PacketSwitching ////////////////////////////////
    // TX
    reg [`PDATA_WIDTH-2:0] packet_cnt; // 1 bit for flag
    reg [3:0] packet_dst;
    // Traffic Pattern Generation
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_dst <= ID;
        else if(issue_flag&&enable) begin
            if(mode[4]==1'b1) //Test, 1 set hotspot
                begin
                    if(ID==mode[3:0]) packet_dst <= hotpot_target;
                    else packet_dst <= ID;
                end
            else if(mode[3:0]==4'b0000) // Test, PE00 hotspot
                begin
                    if(ID==4'b0000) packet_dst <= hotpot_target;
                    else packet_dst <= ID;
                end
            else if(mode[3:0]==4'b0001) // Bit-reverse
                begin
                    packet_dst[3] <= ID[0];
                    packet_dst[2] <= ID[1];
                    packet_dst[1] <= ID[2];
                    packet_dst[0] <= ID[3];
                end
            else if(mode[3:0]==4'b0010) // Bit-rotation
                begin
                    packet_dst[3] <= ID[0];
                    packet_dst[2] <= ID[3];
                    packet_dst[1] <= ID[2];
                    packet_dst[0] <= ID[1];
                end
            else if(mode[3:0]==4'b0011) // Shuffle
                begin
                    packet_dst[3] <= ID[2];
                    packet_dst[2] <= ID[1];
                    packet_dst[1] <= ID[0];
                    packet_dst[0] <= ID[3];
                end
            else if(mode[3:0]==4'b0100) // Transpose
                begin
                    packet_dst[3] <= ID[1];
                    packet_dst[2] <= ID[0];
                    packet_dst[1] <= ID[3];
                    packet_dst[0] <= ID[2];
                end
            else if(mode[3:0]==4'b0101) // Tornado
                begin
                    packet_dst <= (ID + 7) % `k;
                end
            else if(mode[3:0]==4'b0110) // Neighbor
                begin
                    packet_dst <= ID + 1'b1;
                end
            else if(mode[3:0]==4'b1000) // Max Throughput
                begin
                    packet_dst[1:0] <= ID[1:0];
                    packet_dst[2] <= ~ID[2];
                    packet_dst[3] <= ID[3];
                end
            else if(mode[3:0]==4'b1001) // Various hops
                begin
                    case(ID)
                    4'b0000: packet_dst <= 4'b1011; // Hop=5
                    4'b0001: packet_dst <= ID;
                    4'b0010: packet_dst <= ID;
                    4'b0011: packet_dst <= ID;
                    4'b0100: packet_dst <= ID;
                    4'b0101: packet_dst <= ID;
                    4'b0110: packet_dst <= 4'b0010; // Hop=1
                    4'b0111: packet_dst <= ID;
                    4'b1000: packet_dst <= 4'b1111; // Hop=4
                    4'b1001: packet_dst <= ID;
                    4'b1010: packet_dst <= ID;
                    4'b1011: packet_dst <= ID;
                    4'b1100: packet_dst <= ID;
                    4'b1101: packet_dst <= 4'b0001; // Hop=3
                    4'b1110: packet_dst <= 4'b0110; // Hop=2
                    4'b1111: packet_dst <= 4'b0000; // Hop=6
                    endcase
                end
            else if(mode[3:0]==4'b1010) // Tornado2
                begin
                    packet_dst <= (ID + 8) % `k;
                end
            else if(mode[3:0]==4'b1011) // Complement
                begin
                    packet_dst[3] <= ~ID[3];
                    packet_dst[2] <= ~ID[2];
                    packet_dst[1] <= ~ID[1];
                    packet_dst[0] <= ~ID[0];
                end
            else if(mode[3:0]==4'b1100) // Max Throughput2
                begin
                    packet_dst[0] <= ~ID[0];
                    packet_dst[1] <= ID[1];
                    packet_dst[2] <= ID[2];
                    packet_dst[3] <= ID[3];
                end
            else // Hot-pot
                begin
                    packet_dst <= hotpot_target;
                end
        end 
        else if(!issue_flag&&enable) packet_dst <= packet_dst;
        else if(!enable) packet_dst <= ID;
        else packet_dst <= ID;
    end

    // Req Counter, records the number of CS Req 
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            packet_cnt <= 0;
        else if(packet_fifo_wfull)
            packet_cnt <= packet_cnt;
        else if(packet_valid_p2r1) 
            packet_cnt <= packet_cnt + 1'b1;
        else packet_cnt <= packet_cnt;
    end

    reg  [`PDATASIZE-1:0] packet_data_p2r_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            packet_data_p2r_reg <= 0;
        else
            packet_data_p2r_reg <=  packet_data_p2r;
    end

    reg [`PDATA_WIDTH-2:0] packet_counter;

    // PData Generation
    always@(*) begin
        if(packet_fifo_wfull)
            packet_data_p2r = packet_data_p2r_reg;
        else if(packet_valid_p2r1) 
            packet_data_p2r = {ID, packet_dst, time_stamp, packet_cnt, 1'b1};
        else if(packet_side_valid) 
            packet_data_p2r = {ID, packet_dst, time_stamp, packet_counter, 1'b0}; // Side Transfer
        else 
            packet_data_p2r = packet_data_p2r_reg;
    end

    // Valid signal for PData 
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            packet_valid_p2r1 <= 1'b0;
        else if(packet_fifo_wfull)
            packet_valid_p2r1 <= packet_valid_p2r1; 
        else if(packet_cnt[DATA_WIDTH_DBG]==1'b1)
            packet_valid_p2r1 <= 1'b0;
        else if(issue_flag&&enable&&(mode[4]==1'b1)) begin
            if(ID==mode[3:0]) packet_valid_p2r1 <= 1'b1;
            else packet_valid_p2r1 <= 1'b0;
        end
        else if(issue_flag&&enable&&(mode[3:0]==4'b0000)) begin
            if(ID==4'b0000) packet_valid_p2r1 <= 1'b1;
            else packet_valid_p2r1 <= 1'b0;
        end
        else if(issue_flag&&enable&&(mode[3:0]==4'b1001)) begin
            if((ID==4'b0000)|(ID==4'b0110)|(ID==4'b1000)|(ID==4'b1101)|(ID==4'b1110)|(ID==4'b1111)) packet_valid_p2r1 <= 1'b1;
            else packet_valid_p2r1 <= 1'b0;
        end
        else if(issue_flag&&enable) 
            packet_valid_p2r1 <= 1'b1;
        else 
            packet_valid_p2r1 <= 1'b0;
    end

    // RX Receive_finish_flag Signal Generation
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) receive_patch_num <= 0;
        else if(receive_finish_flag) receive_patch_num <= receive_patch_num;
        else if((RX_Head||mask_four_stage_data_valid)&&data_valid&&(sel_data[`CDATA_WIDTH-1:0]==Stream_Length+1)) receive_patch_num <= receive_patch_num + 1'b1;
        else receive_patch_num <= receive_patch_num;
    end
    always@(*)begin
        if(receive_patch_num[DATA_WIDTH_DBG]==1'b1) receive_finish_flag = 1'b1;
        else receive_finish_flag = 1'b0;
    end



    ///////////////////////////      Pattern  Generation    ///////////////////////////
    wire [15:0] pattern;
    reg [4:0] index;
    reg flag;
    reg clock_p2r_valid;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            RX_Index <= 0;
        else begin
        case(RX_ID)
            4'b0000: RX_Index <= dvfs_config[4:0];
            4'b0001: RX_Index <= dvfs_config[9:5];
            4'b0010: RX_Index <= dvfs_config[14:10];
            4'b0011: RX_Index <= dvfs_config[19:15];
            4'b0100: RX_Index <= dvfs_config[24:20];
            4'b0101: RX_Index <= dvfs_config[29:25];
            4'b0110: RX_Index <= dvfs_config[34:30];
            4'b0111: RX_Index <= dvfs_config[39:35];
            4'b1000: RX_Index <= dvfs_config[44:40];
            4'b1001: RX_Index <= dvfs_config[49:45];
            4'b1010: RX_Index <= dvfs_config[54:50];
            4'b1011: RX_Index <= dvfs_config[59:55];
            4'b1100: RX_Index <= dvfs_config[64:60];
            4'b1101: RX_Index <= dvfs_config[69:65];
            4'b1110: RX_Index <= dvfs_config[74:70];
            4'b1111: RX_Index <= dvfs_config[79:75];
            default: RX_Index <= 0;
        endcase
        end
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            TX_Index <= 0;
        else begin
        case(TX_ID)
            4'b0000: TX_Index <= dvfs_config[4:0];
            4'b0001: TX_Index <= dvfs_config[9:5];
            4'b0010: TX_Index <= dvfs_config[14:10];
            4'b0011: TX_Index <= dvfs_config[19:15];
            4'b0100: TX_Index <= dvfs_config[24:20];
            4'b0101: TX_Index <= dvfs_config[29:25];
            4'b0110: TX_Index <= dvfs_config[34:30];
            4'b0111: TX_Index <= dvfs_config[39:35];
            4'b1000: TX_Index <= dvfs_config[44:40];
            4'b1001: TX_Index <= dvfs_config[49:45];
            4'b1010: TX_Index <= dvfs_config[54:50];
            4'b1011: TX_Index <= dvfs_config[59:55];
            4'b1100: TX_Index <= dvfs_config[64:60];
            4'b1101: TX_Index <= dvfs_config[69:65];
            4'b1110: TX_Index <= dvfs_config[74:70];
            4'b1111: TX_Index <= dvfs_config[79:75];
            default: TX_Index <= 0;
        endcase
        end
    end
    pattern_gen pattern_gen(
        .clk(clk), .rst_n(rst_n),
        .enable(clock_p2r_valid),
        .M(RX_Index), .N(TX_Index),
        .pattern(pattern));
    
    // Pattern Selection
    reg State_p2r_test;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) index <= 5'b0;
        else if(!clock_p2r_valid) index <= 5'b0;
        else if((index<RX_Index)&&State_p2r_test) index <= index + 1'b1;
        else if((index==RX_Index)&&State_p2r_test) index <= 5'd1;
        else index <= index;
    end

    reg flag_test;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) flag_test <= 1'b0;
        else if(RX_Index>=TX_Index) begin
            if((index>0)&&(index<=RX_Index)) flag_test <= pattern[5'd16-index];
            else flag_test <= 1'b0;
        end else begin
            if((index>0)&&(index<=RX_Index)) flag_test <= 1'b1;
            else flag_test <= 1'b0;
        end
    end

    always@(*) begin
        flag = flag_test && clock_p2r_valid;
    end

    reg PC_head_TX;
    always@(*) begin
        if(index==5'd1) PC_head_TX = 1'b1;
        else PC_head_TX = 1'b0;
    end

    reg flag_filter;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) flag_filter <= 1'b0;
        else if(PC_head_TX) begin
            if(Feedback_r2p) flag_filter <= 1'b1;
            else flag_filter <= 1'b0;
        end else flag_filter <= flag_filter;
    end

    wire flag_post;
    assign flag_post = flag && (!flag_filter);

    
    /////////////////////////////// Packet Side Transfer /////////////////////////////
    reg [10:0] packet_inject_ctrl_cnt;
    reg packet_trans_begin;
    reg packet_trans_end;
    reg enable_d;
    always@(posedge clk) begin
        enable_d <= enable;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_inject_ctrl_cnt <= 0;
        else if(!enable) packet_inject_ctrl_cnt <= 0;
        else if(packet_trans_begin) packet_inject_ctrl_cnt <= 0;
        else if(!enable_d && enable) packet_inject_ctrl_cnt <= 1'b1;
        else if(packet_trans_end) packet_inject_ctrl_cnt <= 1'b1;
        else if(packet_inject_ctrl_cnt!=0) packet_inject_ctrl_cnt <= packet_inject_ctrl_cnt + 1'b1;
        else packet_inject_ctrl_cnt <= packet_inject_ctrl_cnt;
    end

    always @(*) begin
        packet_trans_begin = (packet_counter == 1'b1);
    end

    always @(*) begin
        packet_trans_end = (packet_counter == (Stream_Length+1));
    end

    // Counter for single PS side transfer
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_counter <= 0;
        else if(!enable) packet_counter <= 0;
        else if((packet_inject_ctrl_cnt >= interval)&&(packet_counter==0)) packet_counter <= 1'b1;
        else if(packet_side_valid && (packet_counter==(Stream_Length+1))) packet_counter <= 0;
        else if(packet_side_valid) packet_counter <= packet_counter + 1'b1;
        else packet_counter <= packet_counter;
    end

    reg [`PDATA_WIDTH-2:0] packet_side_cnt;

    always @(*) begin
        packet_side_valid = (!packet_side_cnt[DATA_WIDTH_DBG]) && (packet_counter!=0) && (!packet_valid_p2r1) && (!packet_fifo_wfull) && packet_side_en;
    end

    // Counter for the number of PS side transfer
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_side_cnt <= 0;
        else if(packet_side_cnt[DATA_WIDTH_DBG])
            packet_side_cnt <= packet_side_cnt;     
        else if((packet_side_valid && (packet_counter==(Stream_Length+1))))
            packet_side_cnt <= packet_side_cnt+1'b1;
        else packet_side_cnt <= packet_side_cnt;
    end

    // Total valid
    always @(*) begin
        packet_valid_p2r = enable && (packet_side_valid || packet_valid_p2r1);
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) receive_packet_patch_num <= 0;
        else if(receive_packet_finish_flag) receive_packet_patch_num <= receive_packet_patch_num;
        else if(packet_valid_r2p&&(packet_data_r2p[`PDATA_WIDTH-1:1]==Stream_Length+1)&&(packet_data_r2p[0]==1'b0)) receive_packet_patch_num <= receive_packet_patch_num + 1'b1;
        else receive_packet_patch_num <= receive_packet_patch_num;
    end

    always@(*)begin
        if(receive_packet_patch_num[DATA_WIDTH_DBG]==1'b1) receive_packet_finish_flag = 1'b1;
        else receive_packet_finish_flag = 1'b0;
    end

    //////////////////////////////// CircuitSwitching ////////////////////////////////
    //////////////// TX ////////////////
            // Counter for single CS transfer
            reg [`CDATA_WIDTH-1:0] counter;
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) counter <= 0;
                else if((!State_p2r)&&(counter!=0)) counter <= 0;
                else if(flag_post) counter <= counter + 1'b1;
                else counter <= counter;
            end

            // Strobe_p2r
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) Strobe_p2r <= 1'b0;
                // else if(flag_post&&(counter<=Stream_Length)) Strobe_p2r <= 1'b1;
                // else Strobe_p2r <= 1'b0;
                else if(flag_post&&(counter<=Stream_Length)) Strobe_p2r <= ~Strobe_p2r;
                else Strobe_p2r <= Strobe_p2r;
            end        
            reg Strobe_p2r_cfg;
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) Strobe_p2r_cfg <= 1'b0;
                else if(flag_post&&(counter<=Stream_Length)) Strobe_p2r_cfg <= 1'b1;
                else Strobe_p2r_cfg <= 1'b0;
                // else if(flag_post&&(counter<=Stream_Length)) Strobe_p2r_cfg <= ~Strobe_p2r_cfg;
                // else Strobe_p2r_cfg <= Strobe_p2r_cfg;
            end  
            // CData_p2r
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n)
                    CData_p2r <= 0;
                else if(RX_Index>=TX_Index) begin
                    if(flag_post) begin
                        if(counter == 0) CData_p2r <= {1'b0, 1'b1, ID, RX_ID, time_stamp, counter+1'b1};
                        else if(counter == Stream_Length) CData_p2r <= {1'b1, 1'b0, ID, RX_ID, time_stamp, counter+1'b1};       //tail
                        else if(counter > Stream_Length) CData_p2r <= 0;
                        else CData_p2r <= {1'b0, 1'b0, ID, RX_ID, time_stamp, counter+1'b1};
                    end
                    else CData_p2r <= 0;
                end else begin
                    if(flag_post) begin
                        if(counter == 0) CData_p2r <= {1'b0, 1'b1, ID, RX_ID, time_stamp, counter+1'b1};
                        else if(counter == Stream_Length) CData_p2r <= {1'b1, 1'b0, ID, RX_ID, time_stamp, counter+1'b1};       //tail
                        else if(counter > Stream_Length) CData_p2r <= 0;
                        else CData_p2r <= {1'b0, 1'b0, ID, RX_ID, time_stamp, counter+1'b1};
                    end 
                    else CData_p2r <= 0;
                end
            end
        
            // State_test
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) State_p2r_test <= 1'b0;
                else if((counter==(Stream_Length+1))&&clock_p2r_valid) State_p2r_test <= 1'b0;
                else if(clock_p2r_valid) State_p2r_test <= 1'b1;
                else State_p2r_test <= State_p2r_test;
            end

           reg State_p2r_reg, State_p2r_reg2, State_p2r_reg3;
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) begin
                    State_p2r_reg <= 1'b0;
                    State_p2r_reg2 <= 1'b0;
                    State_p2r_reg3 <= 1'b0;
                end
                else begin
                    State_p2r_reg <= State_p2r_test;
                    State_p2r_reg2 <= State_p2r_reg;
                    State_p2r_reg3 <= State_p2r_reg2;
                end
            end
            // State, delay 3 cycles
            always @(*) begin 
                State_p2r = State_p2r_test && State_p2r_reg3;
            end

            // Ack_p2r sync.
            // 20250211 Do not Synchronization
            // reg Ack_r2p_sync1, Ack_r2p_sync2, Ack_r2p_reg;
            reg Ack_r2p_reg;
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) Ack_r2p_reg <= 1'b0;
                // else if(State_p2r) Ack_r2p_reg <= Ack_r2p_sync2;
                else if(State_p2r) Ack_r2p_reg <= Ack_r2p;
                else Ack_r2p_reg <= Ack_r2p_reg;
            end

            // always@(posedge clk or negedge rst_n) begin
            //     if(!rst_n) begin
            //         Ack_r2p_sync1 <= 1'b0;
            //         Ack_r2p_sync2 <= 1'b0;
            //     end else begin
            //         Ack_r2p_sync1 <= Ack_r2p;
            //         Ack_r2p_sync2 <= Ack_r2p_sync1;
            //     end
            // end
            always@(posedge clk or negedge rst_n) begin
                if(!rst_n) clock_p2r_valid <= 1'b0;
                else if((Ack_r2p_reg!=Ack_r2p)&&(!clock_p2r_valid)) clock_p2r_valid <= 1'b1;
                else if((counter==(Stream_Length+1))) clock_p2r_valid <= 1'b0;
                else clock_p2r_valid <= clock_p2r_valid;
            end
            always@(*) begin
                // if(clock_p2r_valid) Clock_p2r = clk;
                // else Clock_p2r = 1'b0;
                Clock_p2r = 1'b0;
            end
        
        // Circuit Stream Total Latency
        reg [`TIME_WIDTH-1:0] cdata_head_time_stamp; //exclude channel setup time
        always@(posedge clk or negedge rst_n) begin
            if(!rst_n) cdata_head_time_stamp <= 0;
            else if((counter==0)&&flag_post) cdata_head_time_stamp <= time_stamp_bin;
            else cdata_head_time_stamp <= cdata_head_time_stamp;
        end
        always@(posedge clk or negedge rst_n) begin
            if(!rst_n) cdata_stream_latency <= 0;
            else if(receive_finish_flag) cdata_stream_latency <= cdata_stream_latency;
            else if((counter==Stream_Length+1)&&Strobe_p2r_cfg) cdata_stream_latency <= time_stamp_bin - cdata_head_time_stamp;
            else cdata_stream_latency <= cdata_stream_latency;
        end

        //////////////// RX ////////////////
        reg Ack_p2r_flip_flag, Ack_p2r_flip_flag_reg;
        reg State_r2p_reg;
        // State_r2p_sync
        reg State_r2p_sync1, State_r2p_sync2;
        always@(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                State_r2p_sync1 <= 1'b0;
                State_r2p_sync2 <= 1'b0;
                State_r2p_reg <= 1'b0;
            end else begin
                State_r2p_sync1 <= State_r2p;
                State_r2p_sync2 <= State_r2p_sync1;
                State_r2p_reg <= State_r2p_sync2;
            end
        end

        reg Ack_p2r_reg;
        always@(posedge clk or negedge rst_n) begin
            if(!rst_n) Ack_p2r_reg <= 1'b0;
            else Ack_p2r_reg <= Ack_p2r;
        end

        always@(posedge clk or negedge rst_n) 
            if(!rst_n)
                Ack_p2r_flip_flag_reg <= 1'b1;
            else Ack_p2r_flip_flag_reg <= Ack_p2r_flip_flag;

        always@(*) begin
            if(Ack_p2r_reg!=Ack_p2r) Ack_p2r_flip_flag = 1'b0;
            else if(State_r2p_sync2) Ack_p2r_flip_flag = 1'b0;
            else if(State_r2p_reg&&(!State_r2p_sync2)) Ack_p2r_flip_flag = 1'b1;
            else Ack_p2r_flip_flag = Ack_p2r_flip_flag_reg;
        end
        // Ack
        reg [9:0] Req_r2p_cnt;
        always@(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                Ack_p2r <= 1'b0;
                Req_r2p_cnt <= 10'b0;
                ack_p2r_cnt <= 11'b0;
            end else if(((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID)) && ((Req_r2p_cnt>=0)&&(!State_r2p_sync2)&&Ack_p2r_flip_flag)) begin
                Ack_p2r <= ~Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt;
                ack_p2r_cnt <= ack_p2r_cnt + 1'b1;
            end else if(((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID)) && (!Ack_p2r_flip_flag)) begin
                Ack_p2r <= Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt + 1'b1;
                ack_p2r_cnt <= ack_p2r_cnt;
            end else if(((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID))) begin
                Ack_p2r <= Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt + 1'b1;
                ack_p2r_cnt <= ack_p2r_cnt;
            end else if((Req_r2p_cnt>0)&&(!State_r2p_sync2)&&Ack_p2r_flip_flag) begin
                Ack_p2r <= ~Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt - 1'b1;
                ack_p2r_cnt <= ack_p2r_cnt + 1'b1;
            end else if(State_r2p_sync2&&(!Ack_p2r_flip_flag)) begin
                Ack_p2r <= Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt;
                ack_p2r_cnt <= ack_p2r_cnt;
            end else begin
                Ack_p2r <= Ack_p2r;
                Req_r2p_cnt <= Req_r2p_cnt;
                ack_p2r_cnt <= ack_p2r_cnt;
            end
        end

        wire [3:0] TX_ID_rec; 
        wire alert_wire = 1'b0;
        reg [3:0] TX_ID_rec_test;
        // wire PC_head_wire;
        // interface_single interface(
        //     .ID(ID),
        //     .clk(clk),
        //     .rst_n(rst_n),
        //     .CData_r2p(CData_r2p),
        //     .Strobe_r2p(Strobe_r2p),
        //     .State_r2p(State_r2p),
        //     .Clock_r2p(Clock_r2p),

        //     .TX_ID_rec(TX_ID_rec),
        //     .sel_data(sel_data),
        //     .data_valid(data_valid),

        //     .PC_head(PC_head_wire),
        //     .alert(alert_wire),
        //     .Feedback_p2r(Feedback_p2r),
        //     .trans_number(Stream_Length),
        //     .dvfs_config(dvfs_config)
        // );

        reg [4:0] RX_Index_interface; // Period of the TX PE
        always@(*) begin
            if(State_r2p)
            case(CData_r2p[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH])
                4'b0000: RX_Index_interface = dvfs_config[4:0];
                4'b0001: RX_Index_interface = dvfs_config[9:5];
                4'b0010: RX_Index_interface = dvfs_config[14:10];
                4'b0011: RX_Index_interface = dvfs_config[19:15];
                4'b0100: RX_Index_interface = dvfs_config[24:20];
                4'b0101: RX_Index_interface = dvfs_config[29:25];
                4'b0110: RX_Index_interface = dvfs_config[34:30];
                4'b0111: RX_Index_interface = dvfs_config[39:35];
                4'b1000: RX_Index_interface = dvfs_config[44:40];
                4'b1001: RX_Index_interface = dvfs_config[49:45];
                4'b1010: RX_Index_interface = dvfs_config[54:50];
                4'b1011: RX_Index_interface = dvfs_config[59:55];
                4'b1100: RX_Index_interface = dvfs_config[64:60];
                4'b1101: RX_Index_interface = dvfs_config[69:65];
                4'b1110: RX_Index_interface = dvfs_config[74:70];
                4'b1111: RX_Index_interface = dvfs_config[79:75];
                default: RX_Index_interface = 0;
            endcase
            else
            RX_Index_interface = 0;
        end

        // Fixed Index
        reg [4:0] TX_Index_fixed, RX_Index_interface_fixed;
        always @(posedge clk or negedge rst_n) begin
            if(!rst_n)
                TX_Index_fixed <= 5'b0;
            else if(TX_Index_fixed == 5'b0)
                TX_Index_fixed <= TX_Index;
            else TX_Index_fixed <= TX_Index_fixed;
        end

        always @(posedge Clock_r2p or negedge rst_n) begin
            if(!rst_n)
                RX_Index_interface_fixed <= 5'b0;
            else if(RX_Index_interface_fixed == 5'b0)
                RX_Index_interface_fixed <= RX_Index_interface;
            else RX_Index_interface_fixed <= RX_Index_interface_fixed;
        end

        wire [3:0] N = (RX_Index_interface_fixed == 0) ? RX_Index_interface : RX_Index_interface_fixed[3:0];
        wire [3:0] M = (TX_Index_fixed == 0) ? TX_Index : TX_Index_fixed[3:0];
        
        // Learning Phase Compensation
        // wire [4:0] four_stage_learning_data_number;
        // assign four_stage_learning_data_number = (N==1) ? 2 :(M > N ? N : M);


        // Meta. Solution: Clock Switching
        // M >= N, Use State, posedge RX sampling 
        //  M < N, Use Strobe, negedge RX sampling
        
        wire clkin_div, clkin_divb;
        wire Clock_r2p_inv, Clock_r2p_in;

        INVD1BWP30P140 clkinv2 (.I(Clock_r2p), .ZN(Clock_r2p_inv));
        assign Clock_r2p_in = (M>=N) ? Clock_r2p_inv : Clock_r2p;

        INVD1BWP30P140 clkinv (.I(clkin_div), .ZN(clkin_divb));
        DFCNQD4BWP30P140LVT clkdiv (.D(clkin_divb), .CP(Clock_r2p_in), .CDN(rst_n), .Q(clkin_div));
        //DFQD4BWP30P140 clkdiv (.D(clkin_divb), .CP(clkin), .Q(clkin_div));
        

        wire clk_grls_origin, clk_grls_leading;
        wire error_origin, error_leading;

        wire clk_grls_origin_inv, clk_grls_origin_in;
        wire clk_grls_leading_inv, clk_grls_leading_in;
       
        /* metastabiity detectors */

        INVD1BWP30P140 clkinv3 (.I(clk_grls_origin), .ZN(clk_grls_origin_inv));
        assign clk_grls_origin_in = (M>=N) ? clk_grls_origin : clk_grls_origin_inv;

        meta_detector grls_md_origin (
            .clkin(clkin_div),
            .clk(clk_grls_origin_in),
            .rst_n(rst_n),
            .win_sel(win_sel),
            .error(error_origin));

        INVD1BWP30P140 clkinv4 (.I(clk_grls_leading), .ZN(clk_grls_leading_inv));
        assign clk_grls_leading_in = (M>=N) ? clk_grls_leading : clk_grls_leading_inv;
    
        meta_detector grls_md_leading (
            .clkin(clkin_div),
            .clk(clk_grls_leading_in),
            .rst_n(rst_n),
            .win_sel(win_sel),
            .error(error_leading));

        var_delay grls_d1 (
            .din(clk),
            .delay_sel(var_clk_sel_leading),
            .dout(clk_grls_leading)
            //.dout(clk_leading_tobuf)
        );
        var_delay grls_d2 (
            .din(clk_grls_leading),
            .delay_sel(var_clk_sel_origin),
            .dout(clk_grls_origin)
            //.dout(clk_origin_tobuf)
        );
        /* ctrl */
	    // BUFFD4BWP30P140LVT clk_lagging_buffer (.I(clk_lagging), .Z(clk_lagging_buf));
        BUFFD4BWP30P140LVT clk_grls_origin_buffer (.I(clk_grls_origin), .Z(clk_grls_origin_buf));
        wire clk_sel, clkout;
        ctrl ctrl (
            // .clk(clk),
            // .clk(clk_lagging_buf),
            .clk(clk_grls_origin_buf),
            .rst_n(rst_n),
            .error_origin(error_origin),
            .error_leading(error_leading),
            // .error_lagging(error_lagging),
            .clk_sel(clk_sel)
        );

        var_delay_clk dclk (
            .din(clk_grls_leading),
            .mode(medac_mode),
            .delay_sel(clk_sel),
            .var_clk_sel_origin(var_clk_sel_origin),
            .var_clk_sel_leading(var_clk_sel_leading),
            // .var_clk_sel_lagging(var_clk_sel_lagging),
            .dout(clkout)
        );  

        // Control the selection phase

        reg [4:0] interface_en_cnt;
        reg interface_en;

        always @(posedge Clock_r2p or negedge rst_n) begin
            if(!rst_n)
                interface_en_cnt <= 5'b0;
            else if(interface_en)
                interface_en_cnt <= interface_en_cnt;
            else if(State_r2p)
                interface_en_cnt <= interface_en_cnt + 1;
            else interface_en_cnt <= interface_en_cnt;
            
        end

        always @(posedge Clock_r2p or negedge rst_n) begin
            if(!rst_n)
                interface_en <= 1'b0;
            else if(interface_en_cnt==M-1 && M!=0)
                interface_en <= 1'b1;
            else interface_en <= interface_en;
        end


        // four_stage interface or three_stage interface
        three_stage inst_three_stage (
            .clk(clk),
        // .clk(clkout),
        .rst_n(rst_n),
        .M(M), 
        .N(N), 
        .interface_en(interface_en),
        .CData_r2p(CData_r2p),
        .Strobe_r2p(Strobe_r2p_fixed),
        .State_r2p(State_r2p),
        .Clock_r2p(Clock_r2p),

        .sel_data(sel_data),
        .data_valid(data_valid),

        .alert(alert_wire),
        .Feedback_p2r(Feedback_p2r),
        .sync_sel(3'b011),
        .state_meta_error(state_meta_error),
        .strobe1_meta_error(strobe1_meta_error),
        .strobe2_meta_error(strobe2_meta_error),
        .strobe3_meta_error(strobe3_meta_error)
    );

    // There are few datas 
    // reg mask_four_stage_data_valid;

    always @(*) begin
        RX_Head = ((sel_data[`CDATA_WIDTH-1:0] == 1)||(sel_data[`CDATA_WIDTH-1:0] == 1+N))&&(data_valid);
        RX_Tail = (sel_data[`CDATASIZE-1] == 1)&&(data_valid);
    end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         mask_four_stage_data_valid <= 1;
    //     else if(mask_four_stage_data_valid && data_valid && ((sel_data[`CDATA_WIDTH-1:0]==Stream_Length+1)))
    //         mask_four_stage_data_valid <= 0;
    //     else if((!mask_four_stage_data_valid) && (!data_valid))
    //         mask_four_stage_data_valid <= 1;
    //     else mask_four_stage_data_valid <= mask_four_stage_data_valid;

    // end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            mask_four_stage_data_valid <= 0;
        else if(RX_Head)
            mask_four_stage_data_valid <= 1;
        else if(RX_Tail)
            mask_four_stage_data_valid <= 0;
        else mask_four_stage_data_valid <= mask_four_stage_data_valid;
    end



    reg [3:0] queue [0:15];  // 4-bit x 16-entry
    reg [4:0] queue_wptr, queue_rptr;  // MSB for control, LSB 5-bit for addr
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue[0]  <= ID;
            queue[1]  <= ID;
            queue[2]  <= ID;
            queue[3]  <= ID;
            queue[4]  <= ID;
            queue[5]  <= ID;
            queue[6]  <= ID;
            queue[7]  <= ID;
            queue[8]  <= ID;
            queue[9]  <= ID;
            queue[10] <= ID;
            queue[11] <= ID;
            queue[12] <= ID;
            queue[13] <= ID;
            queue[14] <= ID;
            queue[15] <= ID;
        end else if((!packet_fifo_wfull)&&(packet_dst!=ID))begin
            queue[queue_wptr[3:0]] <= packet_dst;
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_wptr <= 5'b0;
        end else if((issue_flag)&&(packet_dst!=ID)&&(packet_fifo_wfull)) begin
            queue_wptr <= queue_wptr;
        end else if((issue_flag)&&(packet_dst!=ID)) begin
            queue_wptr <= queue_wptr + 1'b1;
        end else queue_wptr <= queue_wptr;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_rptr <= 5'b0;
        end else if((counter==Stream_Length+1)&&(Strobe_p2r_cfg)) begin
            queue_rptr <= queue_rptr + 1'b1;
        end else queue_rptr <= queue_rptr;
    end

    assign RX_ID = queue[queue_rptr[3:0]];
    assign TX_ID = ID;
    reg issue_permit;
    wire [4:0] queue_wptr_next;
    assign queue_wptr_next = queue_wptr + 1'b1;
    always@(*) begin
        if(packet_fifo_wfull) issue_permit = 1'b0;
        else if((queue_wptr_next[4]!=queue_rptr[4])&&(queue_wptr_next[3:0]==queue_rptr[3:0])) issue_permit = 1'b0;
        else issue_permit = 1'b1;
    end
    always@(*) begin
        issue_flag = enable && issue_permit && inject_enable;
    end

    //////////////////////////////// queue for RX ////////////////////////////////
    reg [3:0] queue_for_RX [0:15];  // 4-bit x 16-entry
    reg [3:0] queue_for_RX_wptr, queue_for_RX_rptr;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_for_RX[0]  <= ID;
            queue_for_RX[1]  <= ID;
            queue_for_RX[2]  <= ID;
            queue_for_RX[3]  <= ID;
            queue_for_RX[4]  <= ID;
            queue_for_RX[5]  <= ID;
            queue_for_RX[6]  <= ID;
            queue_for_RX[7]  <= ID;
            queue_for_RX[8]  <= ID;
            queue_for_RX[9]  <= ID;
            queue_for_RX[10] <= ID;
            queue_for_RX[11] <= ID;
            queue_for_RX[12] <= ID;
            queue_for_RX[13] <= ID;
            queue_for_RX[14] <= ID;
            queue_for_RX[15] <= ID;
        end else if((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID)) begin
            queue_for_RX[queue_for_RX_wptr+1'b1] <= packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4];
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_for_RX_wptr <= 4'b0;
        end else if((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID)) begin
            queue_for_RX_wptr <= queue_for_RX_wptr + 1'b1;
        end
        else queue_for_RX_wptr <= queue_for_RX_wptr;
    end
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_for_RX_rptr <= 4'b0;
        end else if((Req_r2p_cnt>0)&&(!State_r2p_sync2)&&Ack_p2r_flip_flag) begin
            queue_for_RX_rptr <= queue_for_RX_rptr + 1'b1;
        end
        else queue_for_RX_rptr <= queue_for_RX_rptr;
    end

    assign TX_ID_rec = queue_for_RX[queue_for_RX_rptr+1'b1];
    

    // Correct Check
    // reg error_circuit;
    reg first_pc_flag;// learning phase compensation
    reg [`stream_cnt_width-1:0] error_circuit_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            error_circuit <= 1'b0;
        else if(error_circuit==1'b1)
            error_circuit <= 1'b1;
        else if(data_valid&&(RX_Head||mask_four_stage_data_valid)&&!first_pc_flag)
            error_circuit <= 1'b0;
        else if((RX_Head||mask_four_stage_data_valid) && data_valid)
            error_circuit <= sel_data[`stream_cnt_width-1:0]!=(error_circuit_cnt);
        else
            error_circuit <= error_circuit;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            error_circuit_cnt <= 1'b1 ;
        //else if((error_circuit_cnt==Stream_Length+1)&&((RX_Head||mask_four_stage_data_valid))&&(data_valid)&&(sel_data[`CDATASIZE-2]==1'b0))
        else if(data_valid&&(RX_Head||mask_four_stage_data_valid)&&!first_pc_flag)
            error_circuit_cnt <= 1'b1 + sel_data[`CDATA_WIDTH-1:0];
        else if(((RX_Head||mask_four_stage_data_valid)&&data_valid&&(sel_data[`CDATA_WIDTH-1:0]==Stream_Length+1)))
            error_circuit_cnt <= 1'b1 ;
        else if(data_valid&&(RX_Head||mask_four_stage_data_valid))
            error_circuit_cnt <= 1'b1 + error_circuit_cnt;
        else error_circuit_cnt <= error_circuit_cnt;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            first_pc_flag <= 1'b0 ;
        else if((RX_Head||mask_four_stage_data_valid)&&data_valid)
            first_pc_flag <= 1'b1;
        else first_pc_flag <= first_pc_flag;
    end

    // reg error_packet;
    reg [`stream_cnt_width-1:0] error_packet_cnt;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            error_packet <= 1'b0;
        else if(error_packet==1'b1)
            error_packet <= 1'b1;
        else if(packet_valid_r2p&&(packet_data_r2p[0]==1'b0))
            error_packet <= packet_data_r2p[`stream_cnt_width:1]!=error_packet_cnt;
        else
            error_packet <= error_packet;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            error_packet_cnt <= 1;
        else if((error_packet_cnt==Stream_Length+1)&&(packet_valid_r2p)&&(packet_data_r2p[0]==1'b0))
            error_packet_cnt <= 1;
        else if(packet_valid_r2p&&(packet_data_r2p[0]==1'b0))
            error_packet_cnt <= 1'b1 + error_packet_cnt;
        else error_packet_cnt <= error_packet_cnt;
    end

    // 20241205 Add dbg signal
    // ack_p2r_cnt defines with ack_p2r
        // reg  [10:0]                      send_packet_patch_num,
        // reg  [10:0]                      send_patch_num,
        // reg  [10:0]                      req_p2r_cnt,
        // reg  [10:0]                      req_r2p_cnt,
        // reg  [10:0]                      ack_p2r_cnt,
        // reg  [10:0]                      ack_r2p_cnt
    
    always @(*) begin
        req_p2r_cnt = packet_cnt[10:0]; 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            req_r2p_cnt <= 0;
        else if((packet_valid_r2p)&&(packet_data_r2p[0]==1'b1)&&(packet_data_r2p[`PDATASIZE-1: `PDATASIZE-4]!=ID))
            req_r2p_cnt <= req_r2p_cnt + 1'b1;
        else req_r2p_cnt <= req_r2p_cnt;
    end

    reg Ack_r2p_reg_dbg;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Ack_r2p_reg_dbg <= 1'b0;
        else Ack_r2p_reg_dbg <= Ack_r2p;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            ack_r2p_cnt <= 0;
        else if((Ack_r2p_reg_dbg!=Ack_r2p))
            ack_r2p_cnt <= ack_r2p_cnt + 1'b1;
        else ack_r2p_cnt <= ack_r2p_cnt;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) send_packet_patch_num <= 0;
        // else if(receive_packet_finish_flag) send_packet_patch_num <= send_packet_patch_num;
        else if(packet_valid_p2r&&(packet_data_p2r[`PDATA_WIDTH-1:1]==Stream_Length+1)&&(packet_data_p2r[0]==1'b0)) send_packet_patch_num <= send_packet_patch_num + 1'b1;
        else send_packet_patch_num <= send_packet_patch_num;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) send_patch_num <= 0;
        // else if(receive_finish_flag) send_patch_num <= send_patch_num;
        else if(flag_post&&(counter==Stream_Length)) send_patch_num <= send_patch_num + 1'b1;
        else send_patch_num <= send_patch_num;
    end

endmodule
