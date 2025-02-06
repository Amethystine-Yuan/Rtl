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

    // TX Domain -- 3-reg spliter

    // Meta Modified, Delay line for base=8;
    // reg State_r2p_d1, State_r2p_d2, State_r2p_d3, State_r2p_d4;
    // reg State_r2p_d5, State_r2p_d6, State_r2p_d7, State_r2p_d8;
    // reg State_r2p_d9, State_r2p_d10, State_r2p_d11, State_r2p_d12;
    // reg State_r2p_d13, State_r2p_d14, State_r2p_d15, State_r2p_d16;
    // always@(posedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) begin
    //         {State_r2p_d1, State_r2p_d2, State_r2p_d3, State_r2p_d4} <= 'b0;
    //         {State_r2p_d5, State_r2p_d6, State_r2p_d7, State_r2p_d8} <= 'b0; 
    //         {State_r2p_d9, State_r2p_d10, State_r2p_d11, State_r2p_d12} <= 'b0;
    //         {State_r2p_d13, State_r2p_d14, State_r2p_d15, State_r2p_d16} <= 'b0;
    //     end
    //     else begin
    //         {State_r2p_d1, State_r2p_d2, State_r2p_d3, State_r2p_d4} <= {State_r2p,    State_r2p_d1, State_r2p_d2, State_r2p_d3};
    //         {State_r2p_d5, State_r2p_d6, State_r2p_d7, State_r2p_d8} <= {State_r2p_d4, State_r2p_d5, State_r2p_d6, State_r2p_d7}; 
    //         {State_r2p_d9, State_r2p_d10, State_r2p_d11, State_r2p_d12} <= {State_r2p_d8, State_r2p_d9, State_r2p_d10, State_r2p_d11};
    //         {State_r2p_d13, State_r2p_d14, State_r2p_d15, State_r2p_d16} <= {State_r2p_d12, State_r2p_d13, State_r2p_d14, State_r2p_d15};
    //     end
    // end

    // reg State_delay;
    // // ldn =(N==1) ?2:min{M,N}
    // always @(*) begin
    //     if(flag==1) begin
    //         case (M)
    //             4'b0001:  State_delay = (N==1) ? State_r2p_d2: State_r2p_d1; 
    //             4'b0010:  State_delay = (N==1) ? State_r2p_d4: State_r2p_d2; 
    //             4'b0011:  State_delay = (N==1) ? State_r2p_d6: State_r2p_d3; 
    //             4'b0100:  State_delay = (N==1) ? State_r2p_d8: State_r2p_d4; 
    //             4'b0101:  State_delay = (N==1) ? State_r2p_d10: State_r2p_d5; 
    //             4'b0110:  State_delay = (N==1) ? State_r2p_d12: State_r2p_d6; 
    //             4'b0111:  State_delay = (N==1) ? State_r2p_d14: State_r2p_d7; 
    //             4'b1000:  State_delay = (N==1) ? State_r2p_d16: State_r2p_d8; 
    //             default: State_delay = State_r2p;
    //         endcase
    //     end
    //     else State_delay = State_r2p;
    // end


    reg Strobe_r2p_reg;
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) Strobe_r2p_reg <= 1'b0;
        else Strobe_r2p_reg <= Strobe_r2p;
    end

    // reg Strobe_r2p_d1, Strobe_r2p_d2, Strobe_r2p_d3, Strobe_r2p_d4;
    // reg Strobe_r2p_d5, Strobe_r2p_d6, Strobe_r2p_d7, Strobe_r2p_d8;
    // reg Strobe_r2p_d9, Strobe_r2p_d10, Strobe_r2p_d11, Strobe_r2p_d12;
    // reg Strobe_r2p_d13, Strobe_r2p_d14, Strobe_r2p_d15, Strobe_r2p_d16;
    // always@(posedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) begin
    //         {Strobe_r2p_d1, Strobe_r2p_d2, Strobe_r2p_d3, Strobe_r2p_d4} <= 'b0;
    //         {Strobe_r2p_d5, Strobe_r2p_d6, Strobe_r2p_d7, Strobe_r2p_d8} <= 'b0; 
    //         {Strobe_r2p_d9, Strobe_r2p_d10, Strobe_r2p_d11, Strobe_r2p_d12} <= 'b0;
    //         {Strobe_r2p_d13, Strobe_r2p_d14, Strobe_r2p_d15, Strobe_r2p_d16} <= 'b0;
    //     end
    //     else begin
    //         {Strobe_r2p_d1, Strobe_r2p_d2, Strobe_r2p_d3, Strobe_r2p_d4} <= {Strobe_r2p,    Strobe_r2p_d1, Strobe_r2p_d2, Strobe_r2p_d3};
    //         {Strobe_r2p_d5, Strobe_r2p_d6, Strobe_r2p_d7, Strobe_r2p_d8} <= {Strobe_r2p_d4, Strobe_r2p_d5, Strobe_r2p_d6, Strobe_r2p_d7}; 
    //         {Strobe_r2p_d9, Strobe_r2p_d10, Strobe_r2p_d11, Strobe_r2p_d12} <= {Strobe_r2p_d8, Strobe_r2p_d9, Strobe_r2p_d10, Strobe_r2p_d11};
    //         {Strobe_r2p_d13, Strobe_r2p_d14, Strobe_r2p_d15, Strobe_r2p_d16} <= {Strobe_r2p_d12, Strobe_r2p_d13, Strobe_r2p_d14, Strobe_r2p_d15};
    //     end
    // end
    // reg Strobe_r2p_delay, Strobe_r2p_delay_reg;
    // always@(posedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) Strobe_r2p_delay_reg <= 1'b0;
    //     else Strobe_r2p_delay_reg <= Strobe_r2p_delay;
    // end

    // // ldn =(N==1) ?2:min{M,N}
    // always @(*) begin
    //     // if(flag==0) begin
    //         case (M)
    //             4'b0001:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d2: Strobe_r2p_d1; 
    //             4'b0010:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d4: Strobe_r2p_d2; 
    //             4'b0011:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d6: Strobe_r2p_d3; 
    //             4'b0100:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d8: Strobe_r2p_d4; 
    //             4'b0101:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d10: Strobe_r2p_d5; 
    //             4'b0110:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d12: Strobe_r2p_d6; 
    //             4'b0111:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d14: Strobe_r2p_d7; 
    //             4'b1000:  Strobe_r2p_delay = (N==1) ? Strobe_r2p_d16: Strobe_r2p_d8; 
    //             default: Strobe_r2p_delay = Strobe_r2p;
    //         endcase
    //     // end
    //     // else Strobe_r2p_delay = Strobe_r2p;
    // end


    reg [1:0] EN_state; // Data-Reg enable
    always@(posedge Clock_r2p or negedge rst_n) begin
        if(!rst_n) EN_state <= 2'b00;
        else if(!State_r2p) EN_state <= 2'b00;
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

    // reg [1:0] EN_state_strobe; // Strobe-Reg enable
    // always@(posedge Clock_r2p or negedge rst_n) begin
    //     if(!rst_n) EN_state_strobe <= 2'b00;
    //     else if(!(State_r2p)) EN_state_strobe <= 2'b00;
    //     else if(Strobe_r2p_reg!=Strobe_r2p) begin
    //             case (EN_state_strobe)
    //                 2'b00: EN_state_strobe <= 2'b01;
    //                 2'b01: EN_state_strobe <= 2'b10;
    //                 2'b10: EN_state_strobe <= 2'b00;
    //                 default: EN_state_strobe <= 2'b00;
    //             endcase
    //     end 
    //     else EN_state_strobe <= EN_state_strobe;
    // end


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

    // // 2-stage sync.
    // reg State_r2p_reg2_d1, State_r2p_reg2_d2;
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) {State_r2p_reg2_d1, State_r2p_reg2_d2} <= 2'b0;
    //     else {State_r2p_reg2_d1, State_r2p_reg2_d2} <= {State_r2p_reg2, State_r2p_reg2_d1};
    // end

    // // delay line, N-2 stage
    // reg State_r2p_reg2_d3, State_r2p_reg2_d4, State_r2p_reg2_d5, State_r2p_reg2_d6, State_r2p_reg2_d7, State_r2p_reg2_d8;
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) {State_r2p_reg2_d3, State_r2p_reg2_d4, State_r2p_reg2_d5, State_r2p_reg2_d6, State_r2p_reg2_d7, State_r2p_reg2_d8} <= 6'b0;
    //     else {State_r2p_reg2_d3, State_r2p_reg2_d4, State_r2p_reg2_d5, State_r2p_reg2_d6, State_r2p_reg2_d7, State_r2p_reg2_d8} <= {State_r2p_reg2_d2, State_r2p_reg2_d3, State_r2p_reg2_d4, State_r2p_reg2_d5, State_r2p_reg2_d6, State_r2p_reg2_d7};
    // end

    // reg State_delay_rx;
    // always @(*) begin
    //     case (N)
    //         4'b0011: State_delay_rx = State_r2p_reg2_d3;
    //         4'b0100: State_delay_rx = State_r2p_reg2_d4;
    //         4'b0101: State_delay_rx = State_r2p_reg2_d5;
    //         4'b0110: State_delay_rx = State_r2p_reg2_d6;
    //         4'b0111: State_delay_rx = State_r2p_reg2_d7;
    //         4'b1000: State_delay_rx = State_r2p_reg2_d8;
    //         default: State_delay_rx = State_r2p_reg2_d2;
    //     endcase
    // end


    reg [1:0] sel_state, sel_strobe;
    wire [1:0] sel =  flag ? sel_state : sel_strobe;
    

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_state <= 2'b00;
        else if(State_r2p_reg2) begin
                case (sel_state)
                    2'b00: sel_state <= 2'b01;
                    2'b01: sel_state <= 2'b10;
                    2'b10: sel_state <= 2'b00;
                    default: sel_state <= 2'b00;
                endcase
        end 
        else sel_state <= 0;
    end

    reg [1:0] sel_state_reg;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_state_reg <= 2'b00;
        else sel_state_reg <= sel_state;
    end
 
    // // Strobe sync.
    // reg Strobe1_sync1, Strobe1_sync2;
    // reg Strobe2_sync1, Strobe2_sync2;
    // reg Strobe3_sync1, Strobe3_sync2;

    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         {Strobe1_sync1, Strobe1_sync2} <= 2'b0;
    //         {Strobe2_sync1, Strobe2_sync2} <= 2'b0;
    //         {Strobe3_sync1, Strobe3_sync2} <= 2'b0;
    //     end
    //     else begin
    //         {Strobe1_sync1, Strobe1_sync2} <= {Strobe1, Strobe1_sync1};
    //         {Strobe2_sync1, Strobe2_sync2} <= {Strobe2, Strobe2_sync1};
    //         {Strobe3_sync1, Strobe3_sync2} <= {Strobe3, Strobe3_sync1};
    //     end
    // end

    reg Strobe1_history, Strobe2_history, Strobe3_history;
    // reg Strobe1_history2, Strobe2_history2, Strobe3_history2;
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

    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) begin
    //         Strobe1_history2 <= 1'b0;
    //         Strobe2_history2 <= 1'b0;
    //         Strobe3_history2 <= 1'b0;
    //     end
    //     else begin
    //         Strobe1_history2 <= Strobe1_history;
    //         Strobe2_history2 <= Strobe2_history;
    //         Strobe3_history2 <= Strobe3_history;
    //     end
    // end

    wire Strobe1_flip, Strobe2_flip, Strobe3_flip;
    assign Strobe1_flip = Strobe1_history != Strobe1;
    assign Strobe2_flip = Strobe2_history != Strobe2;
    assign Strobe3_flip = Strobe3_history != Strobe3;

    // reg Strobe1_flip_d3, Strobe1_flip_d4, Strobe1_flip_d5, Strobe1_flip_d6, Strobe1_flip_d7, Strobe1_flip_d8;
    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) {Strobe1_flip_d3, Strobe1_flip_d4, Strobe1_flip_d5, Strobe1_flip_d6, Strobe1_flip_d7, Strobe1_flip_d8} <= 6'b0;
    //     else {Strobe1_flip_d3, Strobe1_flip_d4, Strobe1_flip_d5, Strobe1_flip_d6, Strobe1_flip_d7, Strobe1_flip_d8} <= {Strobe1_flip, Strobe1_flip_d3, Strobe1_flip_d4, Strobe1_flip_d5, Strobe1_flip_d6, Strobe1_flip_d7};
    // end
    // reg Strobe2_flip_d3, Strobe2_flip_d4, Strobe2_flip_d5, Strobe2_flip_d6, Strobe2_flip_d7, Strobe2_flip_d8;
    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) {Strobe2_flip_d3, Strobe2_flip_d4, Strobe2_flip_d5, Strobe2_flip_d6, Strobe2_flip_d7, Strobe2_flip_d8} <= 6'b0;
    //     else {Strobe2_flip_d3, Strobe2_flip_d4, Strobe2_flip_d5, Strobe2_flip_d6, Strobe2_flip_d7, Strobe2_flip_d8} <= {Strobe2_flip, Strobe2_flip_d3, Strobe2_flip_d4, Strobe2_flip_d5, Strobe2_flip_d6, Strobe2_flip_d7};
    // end
    // reg Strobe3_flip_d3, Strobe3_flip_d4, Strobe3_flip_d5, Strobe3_flip_d6, Strobe3_flip_d7, Strobe3_flip_d8;
    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) {Strobe3_flip_d3, Strobe3_flip_d4, Strobe3_flip_d5, Strobe3_flip_d6, Strobe3_flip_d7, Strobe3_flip_d8} <= 6'b0;
    //     else {Strobe3_flip_d3, Strobe3_flip_d4, Strobe3_flip_d5, Strobe3_flip_d6, Strobe3_flip_d7, Strobe3_flip_d8} <= {Strobe3_flip, Strobe3_flip_d3, Strobe3_flip_d4, Strobe3_flip_d5, Strobe3_flip_d6, Strobe3_flip_d7};
    // end

    // reg Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay;
    // always @(*) begin
    //     case (N)
    //         4'b0011: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d3, Strobe2_flip_d3, Strobe3_flip_d3};
    //         4'b0100: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d4, Strobe2_flip_d4, Strobe3_flip_d4};
    //         4'b0101: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d5, Strobe2_flip_d5, Strobe3_flip_d5};
    //         4'b0110: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d6, Strobe2_flip_d6, Strobe3_flip_d6};
    //         4'b0111: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d7, Strobe2_flip_d7, Strobe3_flip_d7};
    //         4'b1000: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip_d8, Strobe2_flip_d8, Strobe3_flip_d8};
    //         default: {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay} = {Strobe1_flip   , Strobe2_flip   , Strobe3_flip   };
    //     endcase
    // end

    // reg Strobe1_flip_delay2, Strobe2_flip_delay2, Strobe3_flip_delay2;
    // always @(negedge clk or negedge rst_n) begin
    //     if(!rst_n) {Strobe1_flip_delay2, Strobe2_flip_delay2, Strobe3_flip_delay2} <= 3'b0;
    //     else
    //         {Strobe1_flip_delay2, Strobe2_flip_delay2, Strobe3_flip_delay2} <= {Strobe1_flip_delay, Strobe2_flip_delay, Strobe3_flip_delay};
    // end

    // reg State_delay_rx_d;
    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         State_delay_rx_d <= 0;
    //     else State_delay_rx_d <= State_delay_rx;
    // end

    // wire stream_reset = (!State_delay_rx) && State_delay_rx_d;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) sel_strobe <= 2'b00;
        // else if(stream_reset) 
        //     sel_strobe <= 0;
        else begin
            case (sel_strobe)
                2'b00: begin
                    if(Strobe1_flip) sel_strobe <= 2'b01;
                    else sel_strobe <= sel_strobe;
                end
                2'b01: begin
                    if(Strobe2_flip) sel_strobe <= 2'b10;
                    else sel_strobe <= sel_strobe;
                end
                2'b10: begin
                    if(Strobe3_flip) sel_strobe <= 2'b00;
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

    reg valid_state, valid_strobe;

    always @(*) begin
        data_valid =  flag ? valid_state : valid_strobe;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            valid_state <= 1'b0;
        else if(sel_state_reg!=sel_state)
            valid_state <= 1'b1;
        // else if(State_delay_rx)
        //     valid_state <= 1'b1;
        else 
            valid_state <= 1'b0;
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
        else if((Strobe1_flip || Strobe2_flip || Strobe3_flip))
            valid_strobe <= 1'b1;
        else 
            valid_strobe <= 1'b0;
    end

endmodule