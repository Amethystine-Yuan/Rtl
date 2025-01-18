`include "./noc_define.v"

module latency_comp (
    input wire                      clk,
    // input wire                      clk_global,
    input wire [4:0]                TX_Index,
    input wire [4:0]                RX_Index,
    input wire                      rst_n,
    input wire [`TIME_WIDTH-1:0]    time_stamp,
    input wire [`CDATASIZE-1:0]     CData,
    input wire                      EN,
    input wire                      receive_finish_flag,
    output reg [`SUM_WIDTH-1:0]    latency_sum_circuit,
    output reg [`MIN_WIDTH-1:0]    latency_min_circuit,
    output reg [`MAX_WIDTH-1:0]    latency_max_circuit

);
    
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
    reg [`TIME_WIDTH-1:0]     CData_reg;
    reg en_reg, en_reg2;
    reg receive_finish_flag_reg, receive_finish_flag_reg2;
    reg [`TIME_WIDTH-1:0] time_stamp_reg;
    reg [`SUM_WIDTH-1:0] cnt_tmp1 ;
    reg [`SUM_WIDTH-1:0] cnt_tmp2 ;

    reg [4:0]                TX_Index_reg, TX_Index_reg2;
    reg [4:0]                RX_Index_reg, RX_Index_reg2;

    wire [`TIME_WIDTH-1:0] time_stamp_bin;
	always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            time_stamp_reg <= 0;
        end
        else begin
            time_stamp_reg <= time_stamp_bin;
		end
    end
    
    assign  time_stamp_bin[`TIME_WIDTH-1] = time_stamp[`TIME_WIDTH-1];
 
    genvar j;
    generate
	for(j = 0; j <= `TIME_WIDTH-2; j = j + 1) 
		begin: gray2								
            assign time_stamp_bin[j] = time_stamp_bin[j + 1] ^ time_stamp[j];
        end
    endgenerate


    wire [`TIME_WIDTH-1:0] CData_bin;
	always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            CData_reg <= 0;
        end
        else begin
            CData_reg <= CData_bin;
		end
    end
    
    assign  CData_bin[`TIME_WIDTH-1] = CData[`TIME_WIDTH+`CDATA_WIDTH-1];
 
    genvar i;
    generate
	for(i = 0; i <= `TIME_WIDTH-2; i = i + 1) 
		begin: gray										
            assign CData_bin[i] = CData_bin[i + 1] ^ CData[i+`CDATA_WIDTH];
        end
    endgenerate


    

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            RX_Index_reg <= 0;
            RX_Index_reg2 <= 0;
        end
        else begin
            RX_Index_reg <= RX_Index;
            RX_Index_reg2 <= RX_Index_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            TX_Index_reg <= 0;
            TX_Index_reg2 <= 0;
        end
        else begin
            TX_Index_reg <= TX_Index;
            TX_Index_reg2 <= TX_Index_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            en_reg <= 0;
            en_reg2 <= 0;
        end
        else begin
            en_reg <= EN;
            en_reg2 <= en_reg;
        end
    end
  
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            receive_finish_flag_reg <= 0;
            receive_finish_flag_reg2 <= 0;
        end
        else begin
            receive_finish_flag_reg <= receive_finish_flag;
            receive_finish_flag_reg2 <= receive_finish_flag_reg;
        end
    end
      
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_tmp1 <= 0;
        else if(!en_reg)
            cnt_tmp1 <= 0;
        else if(receive_finish_flag)
            cnt_tmp1 <= 0;
        // 20241113 Modified
        // Actually it is  time_stamp_bin + (Rx, 2Rx)
        // else cnt_tmp1 <= time_stamp_reg+RX_Index_reg+RX_Index_reg;
        else cnt_tmp1 <= time_stamp_reg+RX_Index_reg;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_tmp2 <= 0;
        else if(!en_reg)
            cnt_tmp2 <= 0;
        else if(receive_finish_flag)
            cnt_tmp2 <= 0;
        // Actually it is (Tx, 2Tx)
        else cnt_tmp2 <= CData_reg+TX_Index_reg+TX_Index_reg;
    end

    reg [15:0] latency_tmp_circuit;
    reg [15:0] latency_tmp_circuit_reg;
    // wire [`SUM_WIDTH+6:0] cnt_tmp1 = time_stamp+RX_Index+RX_Index;
    // wire [`SUM_WIDTH+6:0] cnt_tmp2 = CData[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH]+TX_Index+TX_Index;
    // wire [`SUM_WIDTH+6:0] cnt_tmp1 = time_stamp;
    // wire [`SUM_WIDTH+6:0] cnt_tmp2 = CData[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH]+RX_Index+RX_Index;
    
    // always@(posedge clk_global) latency_tmp_circuit_reg <= latency_tmp_circuit;

    // new
    // wire [`SUM_WIDTH-1:0] cnt_tmp = cnt_tmp1 - cnt_tmp2;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) latency_tmp_circuit <= {`TIME_WIDTH{1'b1}};
        else if(((cnt_tmp1)>=(cnt_tmp2)) && en_reg2)
            latency_tmp_circuit <= cnt_tmp1 - cnt_tmp2;
        else if(en_reg2)
            latency_tmp_circuit <= cnt_tmp1 + 17'b1_0000_0000_0000_0000 - cnt_tmp2;
        else 
            //latency_tmp_circuit <= latency_tmp_circuit_reg;
            latency_tmp_circuit <= latency_tmp_circuit;
    end
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) latency_max_circuit <= 0;
        else begin
            if((latency_tmp_circuit > latency_max_circuit)&&(latency_tmp_circuit!={`TIME_WIDTH{1'b1}})&&(!receive_finish_flag_reg2)) latency_max_circuit <= latency_tmp_circuit[`MAX_WIDTH-1:0];
            else latency_max_circuit <= latency_max_circuit;
        end
    end
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) latency_min_circuit <= {(`MIN_WIDTH){1'b1}};
        else begin
            if((latency_tmp_circuit < latency_min_circuit)&&(!receive_finish_flag_reg2)) latency_min_circuit <= latency_tmp_circuit[`MIN_WIDTH-1:0];
            else latency_min_circuit <= latency_min_circuit;
        end
    end

    reg EN_d, EN_d2;
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            EN_d <= 0;
            EN_d2 <= 0;
        end
        else begin 
            EN_d <= en_reg;
            EN_d2 <= EN_d;
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) latency_sum_circuit <= 0;
        else begin
            if((EN_d2)&&(!receive_finish_flag_reg2)) latency_sum_circuit <= latency_sum_circuit + latency_tmp_circuit;
            else latency_sum_circuit <= latency_sum_circuit;
        end
    end


    // old
    // wire [`SUM_WIDTH+6:0] cnt_tmp1_test = time_stamp+RX_Index+RX_Index;
    // wire [`SUM_WIDTH+6:0] cnt_tmp2_test = CData[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH]+TX_Index+TX_Index;
    // reg [`SUM_WIDTH-1:0]    latency_sum_circuit_test;
    // reg [`MIN_WIDTH-1:0]    latency_min_circuit_test;
    // reg [`MAX_WIDTH-1:0]    latency_max_circuit_test;

    // reg [`SUM_WIDTH+6:0] latency_tmp_circuit_test;
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) latency_tmp_circuit_test <= {`TIME_WIDTH{1'b1}};
    //     else if(((cnt_tmp1_test)>=(cnt_tmp2_test)) && EN)
    //         latency_tmp_circuit_test <= cnt_tmp1_test - cnt_tmp2_test;
    //     else if(EN)
    //         latency_tmp_circuit_test <= cnt_tmp1_test + 17'b1_0000_0000_0000_0000 - cnt_tmp2_test;
    //     else 
    //         latency_tmp_circuit_test <= latency_tmp_circuit_test;
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_max_circuit_test <= 0;
    //     else begin
    //         if((latency_tmp_circuit_test > latency_max_circuit_test)&&(latency_tmp_circuit_test!={`TIME_WIDTH{1'b1}})&&(!receive_finish_flag)) latency_max_circuit_test <= latency_tmp_circuit_test[`MAX_WIDTH-1:0];
    //         else latency_max_circuit_test <= latency_max_circuit_test;
    //     end
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_min_circuit_test <= {(`MIN_WIDTH){1'b1}};
    //     else begin
    //         if((latency_tmp_circuit_test < latency_min_circuit_test)&&(!receive_finish_flag)) latency_min_circuit_test <= latency_tmp_circuit_test[`MIN_WIDTH-1:0];
    //         else latency_min_circuit_test <= latency_min_circuit_test;
    //     end
    // end

    // reg EN_d_test;
    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) EN_d_test <= 0;
    //     else 
    //         EN_d_test <= EN;
    // end

    // always@(posedge clk or negedge rst_n) begin
    //     if (!rst_n) latency_sum_circuit_test <= 0;
    //     else begin
    //         if((EN_d_test)&&(!receive_finish_flag_reg)) latency_sum_circuit_test <= latency_sum_circuit_test + latency_tmp_circuit_test;
    //         else latency_sum_circuit_test <= latency_sum_circuit_test;
    //     end
    // end
  
    // test
    // reg [`TIME_WIDTH-1:0] data_time_stamp;
    // always @(*) begin
    //     data_time_stamp = CData[`TIME_WIDTH+`CDATA_WIDTH-1:`CDATA_WIDTH];
    // end
endmodule
