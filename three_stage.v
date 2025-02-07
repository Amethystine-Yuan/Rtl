// `define DATASIZE 48 
`define base 8
`define base_log2 3
`include "noc_define.v"

module three_stage (
        input   wire                    clk,
        input   wire                    rst_n,
        input   wire [3:0]              M, 
        input   wire [3:0]              N, 
        // input   wire [`base_log2:0]     M, 
        // input   wire [`base_log2:0]     N, 
        input   wire [`CDATASIZE-1:0]    CData_r2p,
        input   wire                    Strobe_r2p,
        input   wire                    State_r2p,
        input   wire                    Clock_r2p,

        output  reg  [`CDATASIZE-1:0]    sel_data,
        output  reg                     data_valid,

        input   wire                    alert,
        output  wire                    Feedback_p2r
    );

        assign Feedback_p2r = alert;

        reg Strobe1; 
        reg Strobe2; 
        reg Strobe3;

        reg [`CDATASIZE-1:0] data1; 
        reg [`CDATASIZE-1:0] data2; 
        reg [`CDATASIZE-1:0] data3;

    wire flag = M>=N; //flag=1:State, flag=0:Strobe

    reg Strobe_r2p_reg;
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) Strobe_r2p_reg <= 1'b0;
        else Strobe_r2p_reg <= Strobe_r2p;
    end

    reg [1:0] EN_state; // Data-Reg enable
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) EN_state <= 2'b00;
        // else if(!State_r2p) EN_state <= 2'b00;
        else if(Strobe_r2p_reg!=Strobe_r2p)begin
                case (EN_state)
                    2'b00: EN_state <= 2'b01;
                    2'b01: EN_state <= 2'b10;
                    2'b10: EN_state <= 2'b00;
                    default: EN_state <= 2'b00;
                endcase
        end 
        else EN_state <= EN_state;
    end

    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            data1 <= 0;
            data2 <= 0;
            data3 <= 0;
        end 
        else if((Strobe_r2p_reg!=Strobe_r2p)&& State_r2p) begin
            case (EN_state)
                2'b00: begin
                    data1 <= CData_r2p;
                    data2 <= data2;
                    data3 <= data3;
                end
                2'b01: begin
                    data1 <= data1;
                    data2 <= CData_r2p;
                    data3 <= data3;
                end
                2'b10: begin
                    data1 <= data1;
                    data2 <= data2;
                    data3 <= CData_r2p;
                end
                default: begin
                    data1 <= data1;
                    data2 <= data2;
                    data3 <= data3;
                end
            endcase
        end 
        else begin
            data1 <= data1;
            data2 <= data2;
            data3 <= data3;
        end
    end

    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) begin
            Strobe1 <= 0;
            Strobe2 <= 0;
            Strobe3 <= 0;
        end 
        else if((Strobe_r2p_reg!=Strobe_r2p)&&State_r2p) begin
            case (EN_state)
                2'b00: begin
                    Strobe1 <= ~Strobe1;
                    Strobe2 <= Strobe2;
                    Strobe3 <= Strobe3;
                end
                2'b01: begin
                    Strobe1 <= Strobe1;
                    Strobe2 <= ~Strobe2;
                    Strobe3 <= Strobe3;
                end
                2'b10: begin
                    Strobe1 <= Strobe1;
                    Strobe2 <= Strobe2;
                    Strobe3 <= ~Strobe3;
                end
                default: begin
                    Strobe1 <= Strobe1;
                    Strobe2 <= Strobe2;
                    Strobe3 <= Strobe3;
                end
            endcase
        end 
        else begin
            Strobe1 <= Strobe1;
            Strobe2 <= Strobe2;
            Strobe3 <= Strobe3;
        end
    end

    reg State_r2p_reg, State_r2p_reg2;
    always@(negedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) {State_r2p_reg, State_r2p_reg2} <= 2'b0;
        else {State_r2p_reg, State_r2p_reg2} <= {State_r2p, State_r2p_reg};
    end

    /////////////////////////////// RX Domain -- selector

    reg [1:0] sel_state, sel_strobe;
    wire [1:0] sel =  flag ? sel_state : sel_strobe;
    
    reg valid_state, valid_strobe;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_state <= 2'b00;
        else if((valid_state&&sel_data[`CDATASIZE-1])) sel_state<=sel_state;
        else if(State_r2p_reg2||valid_state) begin
                case (sel_state)
                    2'b00: sel_state <= 2'b01;
                    2'b01: sel_state <= 2'b10;
                    2'b10: sel_state <= 2'b00;
                    default: sel_state <= 2'b00;
                endcase
        end 
        else sel_state <= sel_state;
    end

    reg Strobe1_history, Strobe2_history, Strobe3_history;
    reg Strobe1_history2, Strobe2_history2, Strobe3_history2;
    always@(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            Strobe1_history <= 1'b0;
            Strobe2_history <= 1'b0;
            Strobe3_history <= 1'b0;
        end
        else begin
            Strobe1_history <= Strobe1;
            Strobe2_history <= Strobe2;
            Strobe3_history <= Strobe3;
        end
    end

    always@(negedge clk or negedge rst_n) begin
        if(!rst_n) begin
            Strobe1_history2 <= 1'b0;
            Strobe2_history2 <= 1'b0;
            Strobe3_history2 <= 1'b0;
        end
        else begin
            Strobe1_history2 <= Strobe1_history;
            Strobe2_history2 <= Strobe2_history;
            Strobe3_history2 <= Strobe3_history;
        end
    end


    // wire stream_reset = (!State_delay_rx) && State_delay_rx_d;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_strobe <= 2'b00;
        // else if(stream_reset) 
        //     sel_strobe <= 0;
        else begin
            case (sel_strobe)
                2'b00: begin
                    if(Strobe1_history!=Strobe1_history2) sel_strobe <= 2'b01;
                    else sel_strobe <= sel_strobe;
                end
                2'b01: begin
                    if(Strobe2_history!=Strobe2_history2) sel_strobe <= 2'b10;
                    else sel_strobe <= sel_strobe;
                end
                2'b10: begin
                    if(Strobe3_history!=Strobe3_history2) sel_strobe <= 2'b00;
                    else sel_strobe <= sel_strobe;
                end
                default: begin
                    sel_strobe <= sel_strobe;
                end
            endcase
        end 
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            sel_data <= 'b0;
        else begin
        case (sel)
            2'b00: sel_data <= data1;
            2'b01: sel_data <= data2;
            2'b10: sel_data <= data3;
            default: sel_data <= 'hdeadface;
        endcase
        end
    end

    always @(*) begin
        data_valid =  flag ? valid_state : valid_strobe;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            valid_state <= 1'b0;
        else if(State_r2p_reg2)
            valid_state <= 1'b1;
        else if(sel_data[`CDATASIZE-1]==1'b1)
            valid_state <= 1'b0;
        else 
            valid_state <= valid_state;
    end

    // Notice: State_r2p in TX Domain
    // reg valid_flag;
    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         valid_flag <= 1'b1;
    //     else if((Strobe1_flip_delay2 || Strobe2_flip_delay2 || Strobe3_flip_delay2) && (!State_r2p))
    //         valid_flag <= 1'b0;
    //     else if((Strobe1_flip_delay2 || Strobe2_flip_delay2 || Strobe3_flip_delay2))
    //         valid_flag <= 1'b1;
    //     else
    //         valid_flag <= valid_flag;
    // end

    always @(posedge clk or negedge rst_n) begin
       if(!rst_n)
            valid_strobe <= 1'b0;
        // else if((Strobe1_flip_delay2 || Strobe2_flip_delay2 || Strobe3_flip_delay2) && valid_flag)
        else if(((Strobe1_history2!=Strobe1_history) ||(Strobe2_history2!=Strobe2_history) ||(Strobe3_history2!=Strobe3_history)))
            valid_strobe <= 1'b1;
        else 
            valid_strobe <= 1'b0;
    end

endmodule