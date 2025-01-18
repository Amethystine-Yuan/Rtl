`include "./noc_define.v"

module interface_single (
        input   wire [3:0]              ID,
        input   wire                    clk,
        input   wire                    rst_n,
        input   wire [`CDATASIZE-1:0]   CData_r2p,
        input   wire                    Strobe_r2p,
        input   wire                    State_r2p,
        input   wire                    Clock_r2p,

        input   wire [3:0]              TX_ID_rec,
        output  reg  [`CDATASIZE-1:0]   sel_data,
        output  reg                     data_valid,

        output  reg                     PC_head,
        input   wire                    alert,
        output  wire                    Feedback_p2r,
        input   wire [`stream_cnt_width-1:0]    trans_number,
        input   wire [79:0]             dvfs_config


        // for test
        // output reg Strobe1, 
        // output reg Strobe2, 
        // output reg Strobe3,

        // output reg [`CDATASIZE-1:0] data1, 
        // output reg [`CDATASIZE-1:0] data2, 
        // output reg [`CDATASIZE-1:0] data3,

        // output wire [1:0] sel_final,

        // output reg [`CDATASIZE-1:0] CData_r2p_reg,

        // output reg EN1, 
        // output reg EN2, 
        // output reg EN3

        // input   wire
    );

        reg Strobe1; 
        reg Strobe2; 
        reg Strobe3;
        reg Strobe4;


        reg [`CDATASIZE-1:0] data1; 
        reg [`CDATASIZE-1:0] data2; 
        reg [`CDATASIZE-1:0] data3;
        reg [`CDATASIZE-1:0] data4;

        wire [2:0] sel_final;

        reg [`CDATASIZE-1:0] CData_r2p_reg;

        reg EN1; 
        reg EN2; 
        reg EN3;
        reg EN4;

    reg [4:0] TX_Index_rec;
    reg [4:0] My_Index;
    // always@(*) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            TX_Index_rec <= 0;
        else
            case(TX_ID_rec)
                4'b0000: TX_Index_rec <= dvfs_config[4:0];
                4'b0001: TX_Index_rec <= dvfs_config[9:5];
                4'b0010: TX_Index_rec <= dvfs_config[14:10];
                4'b0011: TX_Index_rec <= dvfs_config[19:15];
                4'b0100: TX_Index_rec <= dvfs_config[24:20];
                4'b0101: TX_Index_rec <= dvfs_config[29:25];
                4'b0110: TX_Index_rec <= dvfs_config[34:30];
                4'b0111: TX_Index_rec <= dvfs_config[39:35];
                4'b1000: TX_Index_rec <= dvfs_config[44:40];
                4'b1001: TX_Index_rec <= dvfs_config[49:45];
                4'b1010: TX_Index_rec <= dvfs_config[54:50];
                4'b1011: TX_Index_rec <= dvfs_config[59:55];
                4'b1100: TX_Index_rec <= dvfs_config[64:60];
                4'b1101: TX_Index_rec <= dvfs_config[69:65];
                4'b1110: TX_Index_rec <= dvfs_config[74:70];
                4'b1111: TX_Index_rec <= dvfs_config[79:75];
            endcase
    end

    // always@(*) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            My_Index <= 0;
        else
            case(ID)
                4'b0000: My_Index <= dvfs_config[4:0];
                4'b0001: My_Index <= dvfs_config[9:5];
                4'b0010: My_Index <= dvfs_config[14:10];
                4'b0011: My_Index <= dvfs_config[19:15];
                4'b0100: My_Index <= dvfs_config[24:20];
                4'b0101: My_Index <= dvfs_config[29:25];
                4'b0110: My_Index <= dvfs_config[34:30];
                4'b0111: My_Index <= dvfs_config[39:35];
                4'b1000: My_Index <= dvfs_config[44:40];
                4'b1001: My_Index <= dvfs_config[49:45];
                4'b1010: My_Index <= dvfs_config[54:50];
                4'b1011: My_Index <= dvfs_config[59:55];
                4'b1100: My_Index <= dvfs_config[64:60];
                4'b1101: My_Index <= dvfs_config[69:65];
                4'b1110: My_Index <= dvfs_config[74:70];
                4'b1111: My_Index <= dvfs_config[79:75];
            endcase
        end

    assign Feedback_p2r = alert;

    /////////////////////////////// TX Domain -- 4-reg spliter
    // reg Strobe_r2p_reg;
    reg [1:0] EN_state, EN_state_reg;
    // reg EN1, EN2, EN3;
    // reg [`CDATASIZE-1:0] data1, data2, data3;
    // reg Strobe1, Strobe2, Strobe3;
    // always@(posedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) Strobe_r2p_reg <= 1'b0;
    //     else Strobe_r2p_reg <= Strobe_r2p;
    // end
    

    reg State_r2p_reg;
    reg State_r2p_reg_tmp;
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) State_r2p_reg_tmp <= 1'b0;
        else State_r2p_reg_tmp <= State_r2p;
    end
    always@(*) begin
        State_r2p_reg = State_r2p & State_r2p_reg_tmp;
    end

    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) EN_state <= 2'b00;
        else if(Strobe_r2p!=1'b0) begin
                case (EN_state)
                    2'b00: EN_state <= 2'b01;
                    2'b01: EN_state <= 2'b10;
                    2'b10: EN_state <= 2'b11;
                    2'b11: EN_state <= 2'b00;
                    default: EN_state <= 2'b00;
                endcase
        end else if(!State_r2p) EN_state <= 2'b00;
        else EN_state <= EN_state;
    end

    reg [5:0] counter_TX;
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) counter_TX <= 6'b0;
        else if(!State_r2p) counter_TX <= 6'b0;
        else if((State_r2p)&&(counter_TX==0)) counter_TX <= 6'd2;
        else if((State_r2p)&&(counter_TX==My_Index)) counter_TX <= 6'd1;
        else if(State_r2p) counter_TX <= counter_TX + 1'b1;
    end
    reg PC_head_TX;
    always@(*) begin
        if((counter_TX==5'd1)&&State_r2p) PC_head_TX = 1'b1;
        else PC_head_TX = 1'b0;
    end
    // reg PC_tail_TX;
    // always@(*) begin
    //     if((counter_TX==My_Index)&&State_r2p) PC_tail_TX = 1'b1;
    //     else PC_tail_TX = 1'b0;
    // end



    reg pass_enable;
    reg pass_enable_reg;
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) pass_enable_reg <= 1'b1;
        else pass_enable_reg <= pass_enable;
    end
    always@(*) begin
        if(!rst_n) pass_enable = 1'b1;
        else if((PC_head_TX)&&Feedback_p2r) pass_enable = 1'b0;
        else if((PC_head_TX)&&(!Feedback_p2r)) pass_enable = 1'b1;
        else pass_enable = pass_enable_reg;
    end

    // reg Feedback_p2r_reg;
    // reg pass_enable_RX;
    // reg pass_enable_RX_reg;
    // always@(posedge clk) Feedback_p2r_reg <= Feedback_p2r;
    // always@(posedge clk) pass_enable_RX_reg <= pass_enable_RX;
    // reg PC_tail;
    // always@(*) begin
    //     if(!rst_n) pass_enable_RX = 1'b1;
    //     else if((PC_head)&&Feedback_p2r_reg) pass_enable_RX = 1'b0;
    //     else if((PC_tail)&&(!Feedback_p2r_reg)) pass_enable_RX = 1'b1;
    //     else pass_enable_RX = pass_enable_RX_reg;
    // end


    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            data1 <= 0;
            data2 <= 0;
            data3 <= 0;
            data4 <= 0;
        end else if(pass_enable_reg&&(Strobe_r2p)) begin
            if(EN_state == 2'd0) data1 <= CData_r2p;
            else data1 <= data1;
            if(EN_state == 2'd1) data2 <= CData_r2p;
            else data2 <= data2;
            if(EN_state == 2'd2) data3 <= CData_r2p;
            else data3 <= data3;
            if(EN_state == 2'd3) data4 <= CData_r2p;
            else data4 <= data4;
        end else begin
            data1 <= data1;
            data2 <= data2;
            data3 <= data3;
            data4 <= data4;
        end
    end
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            Strobe1 <= 1'b0;
            Strobe2 <= 1'b0;
            Strobe3 <= 1'b0;
            Strobe4 <= 1'b0;
        end else if(pass_enable_reg&&(Strobe_r2p)) begin
            if(EN_state == 2'd0) Strobe1 <= ~Strobe1;
            else Strobe1 <= Strobe1;
            if(EN_state == 2'd1) Strobe2 <= ~Strobe2;
            else Strobe2 <= Strobe2;
            if(EN_state == 2'd2) Strobe3 <= ~Strobe3;
            else Strobe3 <= Strobe3;
            if(EN_state == 2'd3) Strobe4 <= ~Strobe4;
            else Strobe4 <= Strobe4;
        end else begin
            Strobe1 <= Strobe1;
            Strobe2 <= Strobe2;
            Strobe3 <= Strobe3;
            Strobe4 <= Strobe4;        
        end
    end


    /////////////////////////////// RX Domain -- selector
    reg [`stream_cnt_width-1:0] num_cnt;
    reg State_r2p_reg2, State_r2p_reg3, State_r2p_tail;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            num_cnt <= 0;
        else if(My_Index>=TX_Index_rec) begin
            if((!State_r2p_reg3)&&(State_r2p_reg2)&&((num_cnt==0)||(num_cnt==12'hfff)))
                num_cnt <= 1;
            else if(num_cnt==(trans_number))
                num_cnt <= 12'hfff;
            else if((num_cnt != 0)&&(num_cnt != 12'hfff))
                num_cnt <= num_cnt + 1'b1;
            else num_cnt <= num_cnt;
        end
        else num_cnt <= 0;
    end

    reg [5:0] counter;


    always @(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            State_r2p_reg2 <= 1'b0;
        end
        else begin
            State_r2p_reg2 <= State_r2p_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            State_r2p_reg3 <= 1'b0;
        end
        else begin
            State_r2p_reg3 <= State_r2p_reg2;
        end
    end

    reg tail_flag;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            State_r2p_tail <= 1'b0;
        else if(State_r2p_reg2)
            State_r2p_tail <= 1'b1;
        else if(tail_flag)
            State_r2p_tail <= 1'b0;
        else State_r2p_tail <= State_r2p_tail;
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) counter <= 6'b0;
        else if(!(State_r2p_tail||State_r2p_reg2)) counter <= 6'b0;
        else if(num_cnt==12'hfff) counter <= State_r2p_reg2 ? 6'b1 : 6'b0;
        else if(counter<TX_Index_rec) counter <= counter + 1'b1;
        else if(counter==TX_Index_rec) counter <= 6'd1;
        else counter <= counter;
    end
    always@(*) begin
        if(counter==6'd1) PC_head = 1'b1;
        else PC_head = 1'b0;
    end
    // always@(*) begin
    //     if(counter==TX_Index_rec) PC_tail = 1'b1;
    //     else PC_tail = 1'b0;
    // end

    reg [2:0] sel;
    reg data_change;
    // reg sample_valid;
    reg Strobe1_history, Strobe2_history, Strobe3_history, Strobe4_history;
    reg Strobe1_history2, Strobe2_history2, Strobe3_history2, Strobe4_history2;
    always@(posedge clk) begin
        Strobe1_history <= Strobe1;
        Strobe2_history <= Strobe2;
        Strobe3_history <= Strobe3;
        Strobe4_history <= Strobe4;
    end

    always@(posedge clk) begin
        Strobe1_history2 <= Strobe1_history;
        Strobe2_history2 <= Strobe2_history;
        Strobe3_history2 <= Strobe3_history;
        Strobe4_history2 <= Strobe4_history;
    end

    reg [2:0] sel_reg;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_reg <= 3'b0;
        else sel_reg <= sel;
    end

    always@(*) begin
        if(!rst_n) begin
            sel = 3'b0;
        end else if(My_Index>=TX_Index_rec) begin
            if(counter==0) sel = 3'b0;
            else begin
                case (sel_reg)
                    3'b000: sel = 3'b001;
                    3'b001: sel = 3'b010;
                    3'b010: sel = 3'b011;
                    3'b011: sel = 3'b000;
                    // 3'b100: sel = 3'b001;
                    default: sel = 3'b000;
                endcase
            end
        end else begin
            // if(!State_r2p) sel = 2'b0;
            case (sel_reg)
                3'b000: begin
                    if(Strobe1_history2!=Strobe1_history) sel = 3'b001;
                    else sel = (!State_r2p_reg_tmp) ? 3'b0 : sel_reg;
                end
                3'b001: begin
                    if(Strobe2_history2!=Strobe2_history) sel = 3'b010;
                    else sel = (!State_r2p_reg_tmp) ? 3'b0 : sel_reg;
                end
                3'b010: begin
                    if(Strobe3_history2!=Strobe3_history) sel = 3'b011;
                    else sel = (!State_r2p_reg_tmp) ? 3'b0 : sel_reg;
                end
                3'b011: begin
                    if(Strobe4_history2!=Strobe4_history) sel = 3'b000;
                    else sel = (!State_r2p_reg_tmp) ? 3'b0 : sel_reg;
                end
                // 3'b100: begin
                //     if(Strobe1_history2!=Strobe1_history) sel = 3'b001;
                //     else sel = (!State_r2p) ? 3'b0 : sel_reg;
                // end
                default: sel = sel_reg;
            endcase
        end
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) data_change <= 1'b0;
        else if(sel != sel_reg) data_change <= 1'b1;
        else data_change <= 1'b0;
    end


    reg sample_valid;


    // wire [1:0] sel_final;
    assign sel_final = (My_Index>=TX_Index_rec) ? sel : sel_reg;

    
    reg  [`CDATASIZE-1:0]   sel_data1, sel_data2;
    always@(*) begin
        // if(!rst_n)
        //     sel_data <= 0;
        // else begin
        case (sel_final)
            3'b000: sel_data1 = data1;
            3'b001: sel_data1 = data2;
            3'b010: sel_data1 = data3;
            3'b011: sel_data1 = data4;
            // 3'b100: sel_data = data4;
            default: sel_data1 = 0;
        endcase
        // end
    end
    
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         sel_data2 <= 0;
    //     else begin
    //     case (sel_final)
    //         3'b000: sel_data2 <= data1;
    //         3'b001: sel_data2 <= data2;
    //         3'b010: sel_data2 <= data3;
    //         3'b011: sel_data2 <= data4;
    //         // 3'b100: sel_data <= data4;
    //         default: sel_data2 <= 0;
    //     endcase
    //     end
    // end
    
    always @(*) begin
        sel_data = (My_Index>=TX_Index_rec) ? sel_data1 : sel_data1;
    end

    // reg tail_flag;
    reg head_flag;

    reg head_flag2;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            head_flag2 <= 1'b0;
        else if(State_r2p_reg2)
            head_flag2 <= 1'b1;
        else head_flag2 <= 1'b0;
    end
    always@(posedge clk) tail_flag <= sel_data[`CDATASIZE-1];
    // always@(posedge clk) head_flag <= (State_r2p_reg2)&&(!head_flag2);
    always@(*) head_flag = sel_data[`CDATASIZE-2];

    reg sample_valid_reg;
    always@(posedge clk) sample_valid_reg <= sample_valid;
    always@(*) begin
        if(!rst_n) sample_valid = 1'b0;
        else if(head_flag) sample_valid = 1'b1;
        else if(!tail_flag) sample_valid = sample_valid_reg;
        else sample_valid = 1'b0;
    end

   reg my_data_valid2, my_data_valid2_reg;
    always@(*) begin
        // if(My_Index>=TX_Index_rec) data_valid = sample_valid && data_change_3 && pass_enable_RX && pass_enable_RX_reg;
        // if(My_Index>=TX_Index_rec) data_valid = sample_valid && pass_enable_RX && pass_enable_RX_reg;
        if(My_Index>=TX_Index_rec) data_valid = sample_valid;
        // else data_valid = sample_valid && data_change;
        else data_valid = my_data_valid2;
    end

 
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            my_data_valid2_reg <= 0;
        else my_data_valid2_reg <= my_data_valid2;
    end

    always@(*) begin
        if(!rst_n) begin
            my_data_valid2 = 0;
        end else begin
            // if(!State_r2p) sel = 2'b0;
            case (sel_reg)
                3'b000: begin
                    if(Strobe1_history2!=Strobe1_history) my_data_valid2 = 1;
                    else my_data_valid2 = 0;
                end
                3'b001: begin
                    if(Strobe2_history2!=Strobe2_history) my_data_valid2 = 1;
                    else my_data_valid2 = 0;
                end
                3'b010: begin
                    if(Strobe3_history2!=Strobe3_history) my_data_valid2 = 1;
                    else my_data_valid2 = 0;
                end
                3'b011: begin
                    if(Strobe4_history2!=Strobe4_history) my_data_valid2 = 1;
                    else my_data_valid2 = 0;
                end
                default: my_data_valid2 = 0;
            endcase
        end
    end
endmodule