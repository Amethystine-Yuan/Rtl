`timescale 1ns/1ps

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

        input   wire                    interface_en,
        input   wire [`CDATASIZE-1:0]    CData_r2p,
        input   wire                    Strobe_r2p,
        input   wire                    State_r2p,
        input   wire                    Clock_r2p,

        output  reg  [`CDATASIZE-1:0]    sel_data,
        output  reg                     data_valid,

        input   wire                    alert,
        output  wire                    Feedback_p2r,

        // Meta detection
        input wire [2:0] sync_sel,
        output wire state_meta_error,
        output wire strobe1_meta_error,
        output wire strobe2_meta_error,
        output wire strobe3_meta_error
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
        else if(!interface_en) EN_state <= EN_state;
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
        else if((Strobe_r2p_reg!=Strobe_r2p)&& State_r2p && interface_en) begin
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
        else if((Strobe_r2p_reg!=Strobe_r2p)&&State_r2p&& interface_en) begin
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
        else {State_r2p_reg, State_r2p_reg2} <= {State_r2p&&interface_en, State_r2p_reg};
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

    /* Meta Detection */ 
    // State_r2p_reg2 might be metastable to posedge rx clk
    reg State8, State7, State6, State5, State4, State3, State2, State1;
    reg State_out;

    reg State_r2p_reg2_d;
    always @(!Clock_r2p) begin //negedge tx clk
		#0.025 State_r2p_reg2_d = State_r2p_reg2;
	end

    reg clkd;
    always @(clk) begin
        #0.05 clkd = clk;
    end

    always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {State8, State7, State6, State5, State4, State3, State2, State1} <= 0;
	    end else begin
		    {State8, State7, State6, State5, State4, State3, State2, State1} <= {State7, State6, State5, State4, State3, State2, State1, State_r2p_reg2_d};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: State_out = State1;
		    3'd1: State_out = State2;
		    3'd2: State_out = State3;
		    3'd3: State_out = State4;
		    3'd4: State_out = State5;
		    3'd5: State_out = State6;
		    3'd6: State_out = State7;
		    3'd7: State_out = State8;
		    default: State_out = State2;
        endcase
    end

    reg State8_2, State7_2, State6_2, State5_2, State4_2, State3_2, State2_2, State1_2;
    reg State_out_2;
    always @(posedge clkd or negedge rst_n) begin
	    if (!rst_n) begin
		    {State1_2} <= 0;
	    end else begin
		    {State1_2} <= {State_r2p_reg2_d};
	    end
    end
    always @(posedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {State8_2, State7_2, State6_2, State5_2, State4_2, State3_2, State2_2} <= 0;
	    end else begin
		    {State8_2, State7_2, State6_2, State5_2, State4_2, State3_2, State2_2} <= {State7_2, State6_2, State5_2, State4_2, State3_2, State2_2, State1_2};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: State_out_2 = State1_2;
		    3'd1: State_out_2 = State2_2;
		    3'd2: State_out_2 = State3_2;
		    3'd3: State_out_2 = State4_2;
		    3'd4: State_out_2 = State5_2;
		    3'd5: State_out_2 = State6_2;
		    3'd6: State_out_2 = State7_2;
		    3'd7: State_out_2 = State8_2;
		    default: State_out_2 = State2_2;
        endcase
    end

    assign state_meta_error = State_out_2 ^ State_out;

    // Strobe1, Strobe2, Strobe3 might be metastable to negedge rx_clk
    reg Strobe1_8, Strobe1_7, Strobe1_6, Strobe1_5, Strobe1_4, Strobe1_3, Strobe1_2, Strobe1_1;
    reg Strobe1_out;

    reg Strobe2_8, Strobe2_7, Strobe2_6, Strobe2_5, Strobe2_4, Strobe2_3, Strobe2_2, Strobe2_1;
    reg Strobe2_out;

    reg Strobe3_8, Strobe3_7, Strobe3_6, Strobe3_5, Strobe3_4, Strobe3_3, Strobe3_2, Strobe3_1;
    reg Strobe3_out;

    reg Strobe1_d, Strobe2_d, Strobe3_d;
    always @(Clock_r2p) begin //posedge tx clk
		#0.025 Strobe1_d = Strobe1;
	end
    always @(Clock_r2p) begin //posedge tx clk
        #0.025 Strobe2_d = Strobe2;
	end
    always @(Clock_r2p) begin //posedge tx clk
        #0.025 Strobe3_d = Strobe3;
	end
    // Strobe1
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe1_8, Strobe1_7, Strobe1_6, Strobe1_5, Strobe1_4, Strobe1_3, Strobe1_2, Strobe1_1} <= 0;
	    end else begin
		    {Strobe1_8, Strobe1_7, Strobe1_6, Strobe1_5, Strobe1_4, Strobe1_3, Strobe1_2, Strobe1_1} <= {Strobe1_7, Strobe1_6, Strobe1_5, Strobe1_4, Strobe1_3, Strobe1_2, Strobe1_1, Strobe1_d};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe1_out = Strobe1_1;
		    3'd1: Strobe1_out = Strobe1_2;
		    3'd2: Strobe1_out = Strobe1_3;
		    3'd3: Strobe1_out = Strobe1_4;
		    3'd4: Strobe1_out = Strobe1_5;
		    3'd5: Strobe1_out = Strobe1_6;
		    3'd6: Strobe1_out = Strobe1_7;
		    3'd7: Strobe1_out = Strobe1_8;
		    default: Strobe1_out = Strobe1_2;
        endcase
    end

    reg Strobe1_8_2, Strobe1_7_2, Strobe1_6_2, Strobe1_5_2, Strobe1_4_2, Strobe1_3_2, Strobe1_2_2, Strobe1_1_2;
    reg Strobe1_out_2;
    always @(negedge clkd or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe1_1_2} <= 0;
	    end else begin
		    {Strobe1_1_2} <= {Strobe1_d};
	    end
    end
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe1_8_2, Strobe1_7_2, Strobe1_6_2, Strobe1_5_2, Strobe1_4_2, Strobe1_3_2, Strobe1_2_2} <= 0;
	    end else begin
		    {Strobe1_8_2, Strobe1_7_2, Strobe1_6_2, Strobe1_5_2, Strobe1_4_2, Strobe1_3_2, Strobe1_2_2} <= {Strobe1_7_2, Strobe1_6_2, Strobe1_5_2, Strobe1_4_2, Strobe1_3_2, Strobe1_2_2, Strobe1_1_2};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe1_out_2 = Strobe1_1_2;
		    3'd1: Strobe1_out_2 = Strobe1_2_2;
		    3'd2: Strobe1_out_2 = Strobe1_3_2;
		    3'd3: Strobe1_out_2 = Strobe1_4_2;
		    3'd4: Strobe1_out_2 = Strobe1_5_2;
		    3'd5: Strobe1_out_2 = Strobe1_6_2;
		    3'd6: Strobe1_out_2 = Strobe1_7_2;
		    3'd7: Strobe1_out_2 = Strobe1_8_2;
		    default: Strobe1_out_2 = Strobe1_2_2;
        endcase
    end

    assign strobe1_meta_error = Strobe1_out_2 ^ Strobe1_out;
    // Strobe2
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe2_8, Strobe2_7, Strobe2_6, Strobe2_5, Strobe2_4, Strobe2_3, Strobe2_2, Strobe2_1} <= 0;
	    end else begin
		    {Strobe2_8, Strobe2_7, Strobe2_6, Strobe2_5, Strobe2_4, Strobe2_3, Strobe2_2, Strobe2_1} <= {Strobe2_7, Strobe2_6, Strobe2_5, Strobe2_4, Strobe2_3, Strobe2_2, Strobe2_1, Strobe2_d};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe2_out = Strobe2_1;
		    3'd1: Strobe2_out = Strobe2_2;
		    3'd2: Strobe2_out = Strobe2_3;
		    3'd3: Strobe2_out = Strobe2_4;
		    3'd4: Strobe2_out = Strobe2_5;
		    3'd5: Strobe2_out = Strobe2_6;
		    3'd6: Strobe2_out = Strobe2_7;
		    3'd7: Strobe2_out = Strobe2_8;
		    default: Strobe2_out = Strobe2_2;
        endcase
    end

    reg Strobe2_8_2, Strobe2_7_2, Strobe2_6_2, Strobe2_5_2, Strobe2_4_2, Strobe2_3_2, Strobe2_2_2, Strobe2_1_2;
    reg Strobe2_out_2;
    always @(negedge clkd or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe2_1_2} <= 0;
	    end else begin
		    {Strobe2_1_2} <= {Strobe2_d};
	    end
    end
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe2_8_2, Strobe2_7_2, Strobe2_6_2, Strobe2_5_2, Strobe2_4_2, Strobe2_3_2, Strobe2_2_2} <= 0;
	    end else begin
		    {Strobe2_8_2, Strobe2_7_2, Strobe2_6_2, Strobe2_5_2, Strobe2_4_2, Strobe2_3_2, Strobe2_2_2} <= {Strobe2_7_2, Strobe2_6_2, Strobe2_5_2, Strobe2_4_2, Strobe2_3_2, Strobe2_2_2, Strobe2_1_2};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe2_out_2 = Strobe2_1_2;
		    3'd1: Strobe2_out_2 = Strobe2_2_2;
		    3'd2: Strobe2_out_2 = Strobe2_3_2;
		    3'd3: Strobe2_out_2 = Strobe2_4_2;
		    3'd4: Strobe2_out_2 = Strobe2_5_2;
		    3'd5: Strobe2_out_2 = Strobe2_6_2;
		    3'd6: Strobe2_out_2 = Strobe2_7_2;
		    3'd7: Strobe2_out_2 = Strobe2_8_2;
		    default: Strobe2_out_2 = Strobe2_2_2;
        endcase
    end

    assign strobe2_meta_error = Strobe2_out_2 ^ Strobe2_out;

    // Strobe3
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe3_8, Strobe3_7, Strobe3_6, Strobe3_5, Strobe3_4, Strobe3_3, Strobe3_2, Strobe3_1} <= 0;
	    end else begin
		    {Strobe3_8, Strobe3_7, Strobe3_6, Strobe3_5, Strobe3_4, Strobe3_3, Strobe3_2, Strobe3_1} <= {Strobe3_7, Strobe3_6, Strobe3_5, Strobe3_4, Strobe3_3, Strobe3_2, Strobe3_1, Strobe3_d};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe3_out = Strobe3_1;
		    3'd1: Strobe3_out = Strobe3_2;
		    3'd2: Strobe3_out = Strobe3_3;
		    3'd3: Strobe3_out = Strobe3_4;
		    3'd4: Strobe3_out = Strobe3_5;
		    3'd5: Strobe3_out = Strobe3_6;
		    3'd6: Strobe3_out = Strobe3_7;
		    3'd7: Strobe3_out = Strobe3_8;
		    default: Strobe3_out = Strobe3_2;
        endcase
    end

    reg Strobe3_8_2, Strobe3_7_2, Strobe3_6_2, Strobe3_5_2, Strobe3_4_2, Strobe3_3_2, Strobe3_2_2, Strobe3_1_2;
    reg Strobe3_out_2;
    always @(negedge clkd or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe3_1_2} <= 0;
	    end else begin
		    {Strobe3_1_2} <= {Strobe3_d};
	    end
    end
    always @(negedge clk or negedge rst_n) begin
	    if (!rst_n) begin
		    {Strobe3_8_2, Strobe3_7_2, Strobe3_6_2, Strobe3_5_2, Strobe3_4_2, Strobe3_3_2, Strobe3_2_2} <= 0;
	    end else begin
		    {Strobe3_8_2, Strobe3_7_2, Strobe3_6_2, Strobe3_5_2, Strobe3_4_2, Strobe3_3_2, Strobe3_2_2} <= {Strobe3_7_2, Strobe3_6_2, Strobe3_5_2, Strobe3_4_2, Strobe3_3_2, Strobe3_2_2, Strobe3_1_2};
	    end
    end
    always @(*) begin
	    case(sync_sel)
		    3'd0: Strobe3_out_2 = Strobe3_1_2;
		    3'd1: Strobe3_out_2 = Strobe3_2_2;
		    3'd2: Strobe3_out_2 = Strobe3_3_2;
		    3'd3: Strobe3_out_2 = Strobe3_4_2;
		    3'd4: Strobe3_out_2 = Strobe3_5_2;
		    3'd5: Strobe3_out_2 = Strobe3_6_2;
		    3'd6: Strobe3_out_2 = Strobe3_7_2;
		    3'd7: Strobe3_out_2 = Strobe3_8_2;
		    default: Strobe3_out_2 = Strobe3_2_2;
        endcase
    end

    assign strobe3_meta_error = Strobe3_out_2 ^ Strobe3_out;

    /* Meta detection ends */


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
        else if(sel_data[`CDATASIZE-1]==1'b1)
            valid_state <= 1'b0;
        else if(State_r2p_reg2)
            valid_state <= 1'b1;
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