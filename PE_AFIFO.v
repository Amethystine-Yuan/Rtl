`include "./noc_define.v"

module PE_AFIFO (
        input   wire [3:0]                      ID,
        input   wire                            clk,
        input   wire                            clk_global,
        input   wire                            rst_n,

        input   wire                            enable_wire,
        input   wire [4:0]                      mode_wire,
        input   wire [10:0]                     interval_wire,
        input   wire [3:0]                      hotpot_target,
        input   wire [3:0]                      DATA_WIDTH_DBG,
        input   wire [1:0]                      test_mode,

        // packet
        output  reg  [`PDATASIZE-1:0]           packet_data_p2r,
        output  reg                             packet_valid_p2r,
        input   wire [`PDATASIZE-1:0]           packet_data_r2p,
        input   wire                            packet_valid_r2p,
        input   wire                            packet_fifo_wfull,

        // circuit
        output  reg                             Tail_p2r,
        output  reg                             Stream_p2r,
        output  reg [`CDATASIZE-1:0]            CData_p2r,
        output  wire                            Ack_p2r,
        input   wire                            Tail_r2p,
        input   wire                            Stream_r2p,
        input   wire [`CDATASIZE-1:0]           CData_r2p,
        input   wire                            Ack_r2p,

        input   wire [79:0]                     dvfs_config,    // frequency ratio
        output  reg                            Clock_p2r,
        input   wire                            Clock_r2p,

        output  reg                             receive_finish_flag,


        input   wire [`TIME_WIDTH-1:0]          time_stamp_global,

        input   wire [`stream_cnt_width-1:0]    Stream_Length,


        // for test
        output  reg  [`TIME_WIDTH-1:0]          cdata_stream_latency,
        output  reg  [10:0]                     receive_patch_num,
        // output  wire [3:0]                      pdata_r2p_src, 
        // output  wire [3:0]                      pdata_r2p_dst,
        // output  wire [`PDATA_WIDTH-1:0]         pdata_r2p_cnt,
        // output  wire [`TIME_WIDTH-1:0]          pdata_r2p_time,
        // output  reg  [3:0]                      cdata_src, 
        // output  reg  [3:0]                      cdata_dst,
        // output  reg  [`TIME_WIDTH-1:0]          cdata_time,
        // output  reg  [`CDATA_WIDTH-1:0]         cdata_cnt
        output    reg [10:0] dbg,

        output  wire [`SUM_WIDTH-1:0]    latency_sum_circuit,
        output  wire [`MIN_WIDTH-1:0]    latency_min_circuit,
        output  wire [`MAX_WIDTH-1:0]    latency_max_circuit
    );

        wire [3:0]                      pdata_r2p_src; 
        wire [3:0]                      pdata_r2p_dst;
        wire [`PDATA_WIDTH-1:0]         pdata_r2p_cnt;
        wire [`TIME_WIDTH-1:0]          pdata_r2p_time;
        reg  [3:0]                      cdata_src; 
        reg  [3:0]                      cdata_dst;
        reg  [`TIME_WIDTH-1:0]          cdata_time;
        reg  [`CDATA_WIDTH-1:0]         cdata_cnt;

    reg [`PDATASIZE-1:0] packet_data_r2p_reg;
    reg packet_valid_r2p_reg;
    wire [`CDATASIZE-1:0] AFIFO_rdata;
    wire AFIFO_data_valid;
    

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
        else if(packet_valid_p2r) inject_ctrl_cnt <= 0;
        else inject_ctrl_cnt <= inject_ctrl_cnt + 1'b1;
    end
    always @(*) begin
        if (!rst_n) begin
            inject_enable = 1'b1;
        end else begin
            if((packet_valid_p2r)&&(interval==0)) inject_enable = 1'b1;
            else begin
                if((inject_ctrl_cnt>=interval)&&(!packet_valid_p2r)) inject_enable = 1'b1;
                else inject_enable = 1'b0;
            end
        end
    end



    /////////////////// time stamp & latency /////////////////////
    // reg [`TIME_WIDTH-1:0] time_stamp, time_stamp1; // time stamp of data
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         time_stamp1 <= 0;
    //         time_stamp <= 0;
    //     end else begin
    //         time_stamp1 <= time_stamp_global;
    //         time_stamp  <= time_stamp1;
    //     end
    // end
    // wire [`TIME_WIDTH-1:0] time_stamp;
    // reg  [`TIME_WIDTH-1:0] time_stamp_reg;
    // always@(posedge clk_global) time_stamp_reg <= time_stamp;
    // assign time_stamp = time_stamp_global;

    // reg [`TIME_WIDTH-1:0] latency_tmp_packet;
    // reg [`TIME_WIDTH-1:0] latency_min_packet; // min latency
    // reg [`TIME_WIDTH-1:0] latency_max_packet; // max latency
    // always@(*) begin
    //     if((time_stamp>=packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH-1:`PDATA_WIDTH]) && packet_valid_r2p_reg)
    //         latency_tmp_packet = time_stamp - packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH-1:`PDATA_WIDTH];
    //     else if(packet_valid_r2p_reg)
    //         latency_tmp_packet = 16'b11111111_11111111 - packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH-1:`PDATA_WIDTH] + time_stamp;
    //     else 
    //         latency_tmp_packet = latency_tmp_packet;
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_max_packet <= 0;
    //     else begin
    //         if(latency_tmp_packet > latency_max_packet) latency_max_packet <= latency_tmp_packet;
    //         else latency_max_packet <= latency_max_packet;
    //     end
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_min_packet <= {`TIME_WIDTH{1'b1}};
    //     else begin
    //         if(latency_tmp_packet < latency_min_packet) latency_min_packet <= latency_tmp_packet;
    //         else latency_min_packet <= latency_min_packet;
    //     end
    // end

    // reg [`TIME_WIDTH-1:0] latency_tmp_circuit;
    // reg [`TIME_WIDTH-1:0] latency_min_circuit; // min latency
    // reg [`TIME_WIDTH-1:0] latency_max_circuit; // max latency
    // always@(*) begin
    //     if((time_stamp>=AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH]) && AFIFO_data_valid)
    //         latency_tmp_circuit = time_stamp - AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH];
    //     else if(AFIFO_data_valid)
    //         latency_tmp_circuit = 16'b11111111_11111111- AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH] + time_stamp;
    //     else 
    //         latency_tmp_circuit = latency_tmp_circuit;
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_max_circuit <= 0;
    //     else begin
    //         if(latency_tmp_circuit > latency_max_circuit) latency_max_circuit <= latency_tmp_circuit;
    //         else latency_max_circuit <= latency_max_circuit;
    //     end
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_min_circuit <= {`TIME_WIDTH{1'b1}};
    //     else begin
    //         if(latency_tmp_circuit < latency_min_circuit) latency_min_circuit <= latency_tmp_circuit;
    //         else latency_min_circuit <= latency_min_circuit;
    //     end
    // end
    reg [`TIME_WIDTH-1:0] time_stamp;
    reg [`TIME_WIDTH-1:0] time_stamp1;
    // assign time_stamp = time_stamp_global;

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
    reg  [`TIME_WIDTH-1:0] time_stamp_reg;
    always@(posedge clk) time_stamp_reg <= time_stamp;


    reg receive_finish_flag_tmp;
    reg receive_finish_flag_tmp2;
    reg receive_finish_flag_tmp3;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            receive_finish_flag_tmp <= 0;
            receive_finish_flag_tmp2 <= 0;
            receive_finish_flag_tmp3 <= 0;
        end else begin
            receive_finish_flag_tmp <= receive_finish_flag;
            receive_finish_flag_tmp2 <= receive_finish_flag_tmp; 
            receive_finish_flag_tmp3 <= receive_finish_flag_tmp2;         
        end
    end

    wire [3:0] RX_ID, TX_ID;
    reg [4:0] RX_Index, TX_Index;
    always@(*) begin
        case(AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH])
            4'b0000: RX_Index = dvfs_config[4:0];
            4'b0001: RX_Index = dvfs_config[9:5];
            4'b0010: RX_Index = dvfs_config[14:10];
            4'b0011: RX_Index = dvfs_config[19:15];
            4'b0100: RX_Index = dvfs_config[24:20];
            4'b0101: RX_Index = dvfs_config[29:25];
            4'b0110: RX_Index = dvfs_config[34:30];
            4'b0111: RX_Index = dvfs_config[39:35];
            4'b1000: RX_Index = dvfs_config[44:40];
            4'b1001: RX_Index = dvfs_config[49:45];
            4'b1010: RX_Index = dvfs_config[54:50];
            4'b1011: RX_Index = dvfs_config[59:55];
            4'b1100: RX_Index = dvfs_config[64:60];
            4'b1101: RX_Index = dvfs_config[69:65];
            4'b1110: RX_Index = dvfs_config[74:70];
            4'b1111: RX_Index = dvfs_config[79:75];
        endcase
    end
    always@(*) begin
        case(TX_ID)
            4'b0000: TX_Index = dvfs_config[4:0];
            4'b0001: TX_Index = dvfs_config[9:5];
            4'b0010: TX_Index = dvfs_config[14:10];
            4'b0011: TX_Index = dvfs_config[19:15];
            4'b0100: TX_Index = dvfs_config[24:20];
            4'b0101: TX_Index = dvfs_config[29:25];
            4'b0110: TX_Index = dvfs_config[34:30];
            4'b0111: TX_Index = dvfs_config[39:35];
            4'b1000: TX_Index = dvfs_config[44:40];
            4'b1001: TX_Index = dvfs_config[49:45];
            4'b1010: TX_Index = dvfs_config[54:50];
            4'b1011: TX_Index = dvfs_config[59:55];
            4'b1100: TX_Index = dvfs_config[64:60];
            4'b1101: TX_Index = dvfs_config[69:65];
            4'b1110: TX_Index = dvfs_config[74:70];
            4'b1111: TX_Index = dvfs_config[79:75];
        endcase
    end

    reg en_modify;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            en_modify <= 1'b1;
        else if(en_modify == 1'b0)
            en_modify <= 1'b1;
        else if(AFIFO_data_valid&&(AFIFO_rdata[`CDATA_WIDTH-1:0]==Stream_Length))
            en_modify <= 1'b0;
        else en_modify <= en_modify;
    end

    latency_comp latency_comp(
        .clk(clk),
        //.clk_global(clk_global),
        .TX_Index(RX_Index),
        .RX_Index(TX_Index),
        .rst_n(rst_n),
        .time_stamp(time_stamp),
        .CData(AFIFO_rdata),
        .EN(en_modify&&(AFIFO_data_valid)&&((AFIFO_rdata[`CDATA_WIDTH-1: `PE_FIFO_DEPTH] != 0))&&(AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH]==ID)),
        .receive_finish_flag(receive_finish_flag_tmp3),
        .latency_sum_circuit(latency_sum_circuit),
        .latency_min_circuit(latency_min_circuit),
        .latency_max_circuit(latency_max_circuit)
    );



    // wire [3:0] RX_ID, TX_ID;
    reg issue_flag;

    reg Ack_r2p_reg;
    reg Tail_r2p_reg;
    reg Stream_r2p_reg;
    genvar i, j;

    always@(posedge clk) begin
        Stream_r2p_reg <= Stream_r2p;
        Tail_r2p_reg <= Tail_r2p;
    end

    //////////////////////////////// round-robin deadlock debug ////////////////////////////////
    reg [3:0] packet_dst;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_dst <= ID;
        else if(issue_flag&&enable) begin
            if(mode[4]==1'b1) //TEST
                begin
                    if(ID==mode[3:0]) packet_dst <= hotpot_target;
                    else packet_dst <= ID;
                end
            else if(mode[3:0]==4'b0000) // Test
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
                    4'b0000: packet_dst <= 4'b1011;
                    4'b0001: packet_dst <= ID;
                    4'b0010: packet_dst <= ID;
                    4'b0011: packet_dst <= ID;
                    4'b0100: packet_dst <= ID;
                    4'b0101: packet_dst <= ID;
                    4'b0110: packet_dst <= 4'b0010;
                    4'b0111: packet_dst <= ID;
                    4'b1000: packet_dst <= 4'b1111;
                    4'b1001: packet_dst <= ID;
                    4'b1010: packet_dst <= ID;
                    4'b1011: packet_dst <= ID;
                    4'b1100: packet_dst <= ID;
                    4'b1101: packet_dst <= 4'b0001;
                    4'b1110: packet_dst <= 4'b0110;
                    4'b1111: packet_dst <= 4'b0000;
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
        else packet_dst <= packet_dst;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_valid_p2r = 1'b0;
        else if(issue_flag&&enable&&(mode[4]==1'b1)) begin
            if(ID==mode[3:0]) packet_valid_p2r = 1'b1;
            else packet_valid_p2r = 1'b0;
        end
        else if(issue_flag&&enable&&(mode[3:0]==4'b0000)) begin
            if(ID==4'b0000) packet_valid_p2r = 1'b1;
            else packet_valid_p2r = 1'b0;
        end
        else if(issue_flag&&enable&&(mode[3:0]==4'b1001)) begin
            if((ID==4'b0000)|(ID==4'b0110)|(ID==4'b1000)|(ID==4'b1101)|(ID==4'b1110)|(ID==4'b1111)) packet_valid_p2r = 1'b1;
            else packet_valid_p2r = 1'b0;
        end
        else if(issue_flag&&enable) packet_valid_p2r = 1'b1;
        else packet_valid_p2r = 1'b0;
    end



    //////////////////////////////// PacketSwitching ////////////////////////////////
    // TX
    reg packet_fifo_wfull_reg;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_fifo_wfull_reg <= 1'b0;
        else packet_fifo_wfull_reg <= packet_fifo_wfull;
    end
    reg [`PDATA_WIDTH-1:0] packet_cnt;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) packet_cnt <= 0;
        else if((~packet_fifo_wfull)&&(packet_fifo_wfull_reg)&&issue_flag&&enable) packet_cnt <= packet_cnt;
        else if((~packet_fifo_wfull)&&issue_flag&&enable) packet_cnt <= packet_cnt + 1'b1;
        else packet_cnt <= packet_cnt;
    end

    reg  [`PDATASIZE-1:0]           packet_data_p2r_reg;
    always @(posedge clk or negedge rst_n ) begin
        if(!rst_n)
            packet_data_p2r_reg <= 0;
        else    
        packet_data_p2r_reg <= packet_data_p2r;
    end
    always@(*) begin
        if(!rst_n) packet_data_p2r = 0;
        else if(packet_valid_p2r) packet_data_p2r = {ID, packet_dst, time_stamp, packet_cnt};
        else packet_data_p2r = packet_data_p2r_reg;
    end
    

    //RX
    always@(posedge clk) packet_valid_r2p_reg <= packet_valid_r2p;
    // generate 
    //     for(j=0;j<`PDATASIZE;j=j+1) begin: packet_data_dff
    //         EDFCNQD1BWP30P140ULVT lib_dff_pdata(.D(packet_data_r2p[j]), .E(packet_valid_r2p), .CP(clk), .CDN(rst_n), .Q(packet_data_r2p_reg[j]));
    //     end
    // endgenerate

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            packet_data_r2p_reg <= 0;
        else if(packet_valid_r2p)
            packet_data_r2p_reg <= packet_data_r2p;
        else packet_data_r2p_reg <= packet_data_r2p_reg;
    end

    // wire [3:0] pdata_r2p_src, pdata_r2p_dst;
    // wire [`PDATA_WIDTH-1:0] pdata_r2p_cnt;
    // wire [`TIME_WIDTH-1:0] pdata_r2p_time;
    assign pdata_r2p_src = packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH];
    assign pdata_r2p_dst = packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`PDATA_WIDTH];
    assign pdata_r2p_time = packet_data_r2p_reg[`TIME_WIDTH+`PDATA_WIDTH-1 : `PDATA_WIDTH];
    assign pdata_r2p_cnt = packet_data_r2p_reg[`PDATA_WIDTH-1 : 0];


    // reg [10:0] receive_patch_num;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) receive_patch_num <= 0;
        else if(receive_finish_flag) receive_patch_num <= receive_patch_num;
        else if(AFIFO_data_valid&&(AFIFO_rdata[`CDATA_WIDTH-1:0]==Stream_Length-1)) receive_patch_num <= receive_patch_num + 1'b1;
        else receive_patch_num <= receive_patch_num;
    end
    always@(*)begin
        if(receive_patch_num[DATA_WIDTH_DBG]==1'b1) receive_finish_flag = 1'b1;
        else receive_finish_flag = 1'b0;
    end



    //////////////////////////////// CircuitSwitching ////////////////////////////////

    ///////////////////////////// TX /////////////////////////////
    always@(posedge clk) begin
        Ack_r2p_reg <= Ack_r2p;
    end
    reg Stream_p2r_reg;
    reg Tail_p2r_reg;
    reg [`CDATA_WIDTH-1:0] circuit_cnt;

    reg [`stream_cnt_width-1:0] stream_cnt;
    reg flag_tail_flip;
    reg flag_stream_flip;
    reg flag_stream_flip_reg;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) circuit_cnt <= 0;
        else if(flag_stream_flip) circuit_cnt <= 0;
        else if(Ack_r2p_reg!=Ack_r2p) circuit_cnt <= circuit_cnt + 1'b1;
        else circuit_cnt <= circuit_cnt;
    end

    reg [`CDATASIZE-1:0] CData_p2r_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            CData_p2r_reg <= 0;
        else
            CData_p2r_reg <= CData_p2r;
    end
    always@(*) begin
        if((Stream_p2r_reg!=Stream_p2r)||(Tail_p2r_reg!=Tail_p2r)) CData_p2r = {2'b0, ID, RX_ID, time_stamp_reg, circuit_cnt};
        else CData_p2r = CData_p2r_reg;
    end
    always@(posedge clk) begin
        Stream_p2r_reg <= Stream_p2r;
        Tail_p2r_reg <= Tail_p2r;
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) stream_cnt <= 0;
        else if(flag_stream_flip&&(Ack_r2p_reg!=Ack_r2p)) stream_cnt <= 0;
        else if((Stream_p2r_reg!=Stream_p2r)||(Tail_p2r_reg!=Tail_p2r)) stream_cnt <= stream_cnt + 1'b1;
        else stream_cnt <= stream_cnt;
    end

        reg flag_tail_flip_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            flag_tail_flip_reg <= 0;
        else 
        flag_tail_flip_reg <= flag_tail_flip;
    end
    always@(*) begin
        if(!rst_n) flag_tail_flip = 1'b0;
        else if(Tail_p2r_reg!=Tail_p2r) flag_tail_flip = 1'b0;
        else if((stream_cnt>=Stream_Length)&&(!flag_stream_flip)) flag_tail_flip = 1'b1;
        else flag_tail_flip = flag_tail_flip_reg;
    end


    // Circuit Stream Total Latency
    reg [`TIME_WIDTH-1:0] cdata_head_time_stamp; //exclude channel setup time
    // reg [`TIME_WIDTH-1:0] cdata_stream_latency; //exclude channel setup time
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) cdata_head_time_stamp <= 0;
        else if((stream_cnt == 1)&&(Ack_r2p!=Ack_r2p_reg)) cdata_head_time_stamp <= time_stamp;
        else cdata_head_time_stamp <= cdata_head_time_stamp;
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) cdata_stream_latency <= 0;
        else if(receive_finish_flag) cdata_stream_latency <= cdata_stream_latency;
        else if((stream_cnt==Stream_Length)&&(Ack_r2p!=Ack_r2p_reg)) cdata_stream_latency <= time_stamp - cdata_head_time_stamp;
        else cdata_stream_latency <= cdata_stream_latency;
    end

    wire queue_wptr_xor;
    reg queue_wptr_reg;
    reg [4:0] queue_wptr, queue_rptr; // MSB for control, LSB 4-bit for addr
    assign queue_wptr_xor = queue_wptr ^ queue_wptr_reg;

    reg flag_stream_flip_filt;
    always@(*) begin
        flag_stream_flip_filt = flag_stream_flip && queue_wptr_xor;
    end

    always@(*) begin
        if(!rst_n) flag_stream_flip = 1'b1;
        else if(Tail_p2r_reg!=Tail_p2r) flag_stream_flip = 1'b1;
        else if(Stream_p2r_reg!=Stream_p2r) flag_stream_flip = 1'b0;
        else flag_stream_flip = flag_stream_flip_reg;
    end
    always@(posedge clk) flag_stream_flip_reg <= flag_stream_flip;
    


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Stream_p2r <= 1'b0;
        else if((RX_ID!=ID)&&(stream_cnt==10'b0)&&flag_stream_flip) Stream_p2r <= ~Stream_p2r;
        else if((stream_cnt<Stream_Length)&&(Ack_r2p_reg!=Ack_r2p)) Stream_p2r <= ~Stream_p2r;
        else Stream_p2r <= Stream_p2r;
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Tail_p2r <= 1'b0;
        else if((stream_cnt>=Stream_Length)&&flag_tail_flip&&(Ack_r2p_reg!=Ack_r2p)) Tail_p2r <= ~Tail_p2r;
        else Tail_p2r <= Tail_p2r;
    end


    reg clock_valid;
    always@(*) begin
        if(!rst_n) clock_valid = 1'b0;
        else if((stream_cnt!=0)|(Stream_p2r_reg!=Stream_p2r)) clock_valid = 1'b1;
        else clock_valid = 1'b0;
    end


    // CKLNQD1BWP30P140 lib_cg_0(.TE(1'b0), .E(clock_valid), .CP(clk), .Q(Clock_p2r));

    reg Clock_p2r_reg;
    always @(negedge clk or negedge rst_n) begin
        if(!rst_n)
            Clock_p2r_reg <= 0;
        else     
            Clock_p2r_reg <= clock_valid;
    end

    // // wire Clock_p2r2 = clk & Clock_p2r_reg;

    // // always @(clk, clock_valid) begin
    // //     if(!clk)
    // //         Clock_p2r_reg <= clock_valid;
    // // end

    always@(*) begin
        if(Clock_p2r_reg) Clock_p2r = clk;
        else Clock_p2r = 1'b0;
    end
    // // assign Clock_p2r = clk & Clock_p2r_reg;

    // // wire flag_dbg = (Clock_p2r == Clock_p2r2);

    ///////////////////////////// RX /////////////////////////////

    // Async. FIFO
    wire AFIFO_we_neg;
    reg AFIFO_we;
    reg Stream_r2p_sync, Tail_r2p_sync;


    always@(negedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            Stream_r2p_sync <= 1'b0;
            Tail_r2p_sync <= 1'b0;
        end else begin
            Stream_r2p_sync <= Stream_r2p;
            Tail_r2p_sync <= Tail_r2p;
        end
    end
    assign AFIFO_we_neg = (Stream_r2p_sync^Stream_r2p) || (Tail_r2p_sync^Tail_r2p);
    always@(negedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) AFIFO_we <= 1'b0;
        else AFIFO_we <= AFIFO_we_neg;
    end




    always@(negedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) dbg <= 11'b0;
        else dbg <= dbg+1;
    end

    // always@(negedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) AFIFO_we <= 1'b0;
    //     else if(AFIFO_we) AFIFO_we <= 1'b0;
    //     else if(AFIFO_we_neg) AFIFO_we <= 1'b1;
    //     else AFIFO_we <= AFIFO_we;
    // end


    wire Ack_p2r1, Ack_p2r2;
    wire [`CDATASIZE-1:0] AFIFO_rdata1;
    wire [`CDATASIZE-1:0] AFIFO_rdata2;
    wire AFIFO_data_valid1, AFIFO_data_valid2;
    assign AFIFO_rdata = (test_mode==2'b10) ? AFIFO_rdata1 : AFIFO_rdata2 ;
    assign Ack_p2r = (test_mode==2'b10) ? Ack_p2r1 : Ack_p2r2 ;
    assign AFIFO_data_valid = (test_mode==2'b10) ? AFIFO_data_valid1 : AFIFO_data_valid2 ;

    FIFO_async2_PE #(`CDATASIZE, `PE_FIFO_DEPTH) FIFO_async2_PE(
        .wclk(Clock_r2p), .winc(AFIFO_we),
        .rclk(clk), .rinc(1'b1),
        .rst_n(rst_n),
        .wdata(CData_r2p),
        .rdata(AFIFO_rdata1),
        .wfull(AFIFO_wfull1),
        // .ack(Ack_p2r_AFIFO),
        .ack(Ack_p2r1),
        .rempty_n(AFIFO_data_valid1)
    );

    FIFO_async2_PE #(`CDATASIZE, `PE_FIFO_DEPTH2) FIFO_async2_PE2(
        .wclk(Clock_r2p), .winc(AFIFO_we),
        .rclk(clk), .rinc(1'b1),
        .rst_n(rst_n),
        .wdata(CData_r2p),
        .rdata(AFIFO_rdata2),
        .wfull(AFIFO_wfull2),
        // .ack(Ack_p2r_AFIFO),
        .ack(Ack_p2r2),
        .rempty_n(AFIFO_data_valid2)
    );

    // wire [3:0] cdata_src, cdata_dst;
    // wire [`TIME_WIDTH-1:0] cdata_time;
    // wire [`CDATA_WIDTH-1:0] cdata_cnt;
    // assign cdata_src = AFIFO_data_valid ? AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH] : cdata_src;
    // assign cdata_dst = AFIFO_data_valid ? AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH] : cdata_dst;
    // assign cdata_time = AFIFO_data_valid ? AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH-1 : `CDATA_WIDTH] : cdata_time;
    // assign cdata_cnt = AFIFO_data_valid ? AFIFO_rdata[`CDATA_WIDTH-1 : 0] : cdata_cnt;

    // reg [3:0] cdata_src, cdata_dst;
    // reg [`TIME_WIDTH-1:0] cdata_time;
    // reg [`CDATA_WIDTH-1:0] cdata_cnt;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cdata_src <= 0;
            cdata_dst <= 0;
            cdata_time <= 0;
            cdata_cnt <= 0;
        end else if(AFIFO_data_valid) begin
            cdata_src <= AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH];
            cdata_dst <= AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH+`ADDR_WIDTH-1 : `TIME_WIDTH+`CDATA_WIDTH];
            cdata_time <= AFIFO_rdata[`TIME_WIDTH+`CDATA_WIDTH-1 : `CDATA_WIDTH];
            cdata_cnt <= AFIFO_rdata[`CDATA_WIDTH-1 : 0];
        end else begin
            cdata_src <= cdata_src;
            cdata_dst <= cdata_dst;
            cdata_time <= cdata_time;
            cdata_cnt <= cdata_cnt;
        end
    end




    reg [3:0] queue [0:15];  // 4-bit x 16-entry
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

    // generate
    //     for(i=0;i<=15;i=i+1) begin: queue1
    //         always@(posedge clk or negedge rst_n) begin
    //             if(!rst_n) begin
    //                 queue[i] <= ID;
    //             end else if((!packet_fifo_wfull)&&(packet_dst!=ID)&&(queue_wptr[3:0]==i))begin
    //                 queue[i] <= packet_dst;
    //             end
    //             else 
    //                 queue[i] <= queue[i] ;
    //         end    
    //     end
    // endgenerate


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_wptr <= 5'b0;
        end else if((issue_flag)&&(packet_dst!=ID)&&(packet_fifo_wfull_reg)) begin
            queue_wptr <= queue_wptr;
        end else if((issue_flag)&&(packet_dst!=ID)) begin
            queue_wptr <= queue_wptr + 1'b1;
        end else queue_wptr <= queue_wptr;
    end
    always@(posedge clk) queue_wptr_reg <= queue_wptr;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            queue_rptr <= 5'b0;
        end else if((Ack_r2p_reg!=Ack_r2p)&&flag_stream_flip&&    (((queue_rptr[4]==queue_wptr[4]) && (queue_rptr[3:0]<queue_wptr[3:0])) || ((queue_rptr[4]!=queue_wptr[4])&&(queue_rptr+1'b1!=queue_wptr)))    ) begin
            queue_rptr <= queue_rptr + 1'b1;
        end else queue_rptr <= queue_rptr;
    end
    assign RX_ID = queue[queue_rptr[3:0]];
    assign TX_ID = ID;
    reg issue_permit;

    wire [4:0] queue_wptr_next;
    assign queue_wptr_next = queue_wptr + 1'b1;
    always@(*) begin
        if(!rst_n) issue_permit = 1'b1;
        else if(packet_fifo_wfull) issue_permit = 1'b0;
        else if((queue_wptr_next[4]!=queue_rptr[4])&&(queue_wptr_next[3:0]==queue_rptr[3:0])) issue_permit = 1'b0;
        else issue_permit = 1'b1;
    end
    always@(*) begin
        issue_flag = enable && issue_permit && inject_enable;
    end




endmodule
