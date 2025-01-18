
module pattern_gen (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire [4:0] M,
    input wire [4:0] N,
    output reg [15:0] pattern
    );

    // reg enable_d;
    // reg [4:0] M_d, N_d;
    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         enable_d <= 0;
    //     else enable_d <= enable;
    // end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         M_d <= 0;
    //     else M_d <= M;
    // end

    // always @(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         N_d <= 0;
    //     else N_d <= N;
    // end


    reg [6:0] cnt_reg, cnt;
    reg [4:0] i_reg, i;

    wire [9:0] left, left_plus, right;

    // cnt
    // always@(*) begin
    //     if(!rst_n) cnt = 7'b0;
    //     else cnt = cnt_reg;
    // end
    // always@(negedge clk or negedge rst_n) begin
    //     if(!rst_n) cnt_reg <= 7'b0;
    //     else if(!enable) cnt_reg <= 7'b0;
    //     else if(cnt_reg == 7'd64) cnt_reg <= cnt_reg;
    //     else cnt_reg <= cnt_reg + 1'b1;
    // end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) cnt <= 7'b0;
        else if(!enable) cnt <= 7'b0;
        else if(cnt == 7'd64) cnt <= cnt;
        else cnt <= cnt + 1'b1;
    end
    // always@(*) begin
    //     if(!rst_n) cnt = 7'b0;
    //     else if(!enable) cnt = 7'b0;
    //     else if(cnt == 7'd64) cnt <= cnt;
    //     else cnt = cnt_reg + 1'b1;
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) cnt_reg <= 7'b0;
    //     else cnt_reg <= cnt;
    // end





    // i
    always@(*) begin
        if(!rst_n) i = 5'b0;
        else i = i_reg;
    end
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) i_reg <= 5'b0;
        else if(!enable) i_reg <= 5'b0;
        else if((left <= right)&&(left_plus > right)) i_reg <= i_reg + 5'd1;
        else if(i == N) i_reg <= i_reg;
        else i_reg <= i_reg;
    end

    assign left = cnt*N;
    assign right = i*M;
    assign left_plus = (cnt+1'b1)*N;

    
    // pattern
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) pattern <= 16'b0;
    //     else if(!enable) pattern <= 16'b0;
    //     else if(M<N) pattern <= 16'b1111_1111_1111_1111;
    //     else if(cnt >= M) pattern <= pattern;
    //     else if((left <= right)&&(left_plus > right)) pattern[7'd15-cnt] <= 1'b1;
    //     else pattern[7'd15-cnt] <= 1'b0;
    // end
    reg [15:0] pattern_reg;
    always@(posedge clk) begin
        // if(!enable)
        //     pattern_reg <= 16'b1000_0000_0000_0000;
        // else
            pattern_reg <= pattern;
    end

    wire [6:0] result = 7'd15 - cnt;
    always@(*) begin
        if(!rst_n) pattern = 16'b0;
        else if(!enable) pattern = 16'b0;
        else if(M<=N) pattern = 16'b1111_1111_1111_1111;
        else if(cnt >= M) pattern = pattern_reg;
        else if((left <= right)&&(left_plus > right)) begin

            // case (result)
            //     4'b0000: begin pattern[0] = 1'b1; end
            //     default: 
            // endcase
            pattern[0] = (4'd0==result[3:0]) ? 1'b1 : pattern_reg[0];
            pattern[1] = (4'd1==result[3:0]) ? 1'b1 : pattern_reg[1];
            pattern[2] = (4'd2==result[3:0]) ? 1'b1 : pattern_reg[2];
            pattern[3] = (4'd3==result[3:0]) ? 1'b1 : pattern_reg[3];
            pattern[4] = (4'd4==result[3:0]) ? 1'b1 : pattern_reg[4];
            pattern[5] = (4'd5==result[3:0]) ? 1'b1 : pattern_reg[5];
            pattern[6] = (4'd6==result[3:0]) ? 1'b1 : pattern_reg[6];
            pattern[7] = (4'd7==result[3:0]) ? 1'b1 : pattern_reg[7];
            pattern[8] = (4'd8==result[3:0]) ? 1'b1 : pattern_reg[8];
            pattern[9] = (4'd9==result[3:0]) ? 1'b1 : pattern_reg[9];
            pattern[10] = (4'd10==result[3:0]) ? 1'b1 : pattern_reg[10];
            pattern[11] = (4'd11==result[3:0]) ? 1'b1 : pattern_reg[11];
            pattern[12] = (4'd12==result[3:0]) ? 1'b1 : pattern_reg[12];
            pattern[13] = (4'd13==result[3:0]) ? 1'b1 : pattern_reg[13];
            pattern[14] = (4'd14==result[3:0]) ? 1'b1 : pattern_reg[14];
            pattern[15] = (4'd15==result[3:0]) ? 1'b1 : pattern_reg[15];
            // pattern = pattern_reg | (1'b1 << result[3:0]);
            // pattern[result[3:0]] = 1'b1;
        end
        else begin
            pattern[0] = (4'd0==result[3:0]) ? 1'b0 : pattern_reg[0];
            pattern[1] = (4'd1==result[3:0]) ? 1'b0 : pattern_reg[1];
            pattern[2] = (4'd2==result[3:0]) ? 1'b0 : pattern_reg[2];
            pattern[3] = (4'd3==result[3:0]) ? 1'b0 : pattern_reg[3];
            pattern[4] = (4'd4==result[3:0]) ? 1'b0 : pattern_reg[4];
            pattern[5] = (4'd5==result[3:0]) ? 1'b0 : pattern_reg[5];
            pattern[6] = (4'd6==result[3:0]) ? 1'b0 : pattern_reg[6];
            pattern[7] = (4'd7==result[3:0]) ? 1'b0 : pattern_reg[7];
            pattern[8] = (4'd8==result[3:0]) ? 1'b0 : pattern_reg[8];
            pattern[9] = (4'd9==result[3:0]) ? 1'b0 : pattern_reg[9];
            pattern[10] = (4'd10==result[3:0]) ? 1'b0 : pattern_reg[10];
            pattern[11] = (4'd11==result[3:0]) ? 1'b0 : pattern_reg[11];
            pattern[12] = (4'd12==result[3:0]) ? 1'b0 : pattern_reg[12];
            pattern[13] = (4'd13==result[3:0]) ? 1'b0 : pattern_reg[13];
            pattern[14] = (4'd14==result[3:0]) ? 1'b0 : pattern_reg[14];
            pattern[15] = (4'd15==result[3:0]) ? 1'b0 : pattern_reg[15];
            // pattern[result[3:0]] = 1'b0;
            // pattern = pattern_reg & (~(1'b1 << result[3:0]));
        end
    end

    // wire test1 = (left <= right)&&(left_plus > right);
    // wire test2 = (4'd15==result[3:0]);


    // reg [15:0] pattern_test;
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) pattern_test <= 16'b0;
    //     else if(!enable) pattern_test <= 16'b0;
    //     else if(M<=N) pattern_test <= 16'b1111_1111_1111_1111;
    //     else begin
    //         pattern_test[0] <= ()&&();
    //         pattern_test[1] <= ;
    //         pattern_test[2] <= ;
    //         pattern_test[3] <= ;
    //         pattern_test[4] <= ;
    //         pattern_test[5] <= ;
    //         pattern_test[6] <= ;
    //         pattern_test[7] <= ; 
    //         pattern_test[8] <= ;
    //         pattern_test[9] <= ;
    //         pattern_test[10] <= ;
    //         pattern_test[11] <= ;
    //         pattern_test[12] <= ;
    //         pattern_test[13] <= ;
    //         pattern_test[14] <= ;
    //         pattern_test[15] <= ;
    //     end
    // end
endmodule