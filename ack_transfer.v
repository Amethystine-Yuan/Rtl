module Ack_transfer_e2l(
    input wire Ack_in,
    output wire Ack_out,
    input wire clk,
    input wire rst_n
);

    reg [3:0] cnt;
    reg Ack_in_d;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Ack_in_d <= 1'b0;
        else Ack_in_d <= Ack_in;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 4'b0;
        else if(cnt == 4'd10)
            cnt <= 4'b0;
        else if(cnt != 4'b0)
            cnt <= cnt + 1'b1;
        else if(Ack_in_d != Ack_in)
            cnt <= 4'd1;
    end

    assign Ack_out = (cnt!=4'b0);
endmodule








module Ack_transfer_l2e(
    input wire Ack_in, // Src PE Clock Domain, needs synchronization
    output reg Ack_out,
    input wire clk,
    input wire rst_n
);

    reg Ack_in_sync, Ack_in_sync2;
    reg Ack_in_d;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Ack_in_sync <= 1'b0;
        else Ack_in_sync <= Ack_in;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Ack_in_sync2 <= 1'b0;
        else Ack_in_sync2 <= Ack_in_sync;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Ack_in_d <= 1'b0;
        else Ack_in_d <= Ack_in_sync2;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            Ack_out <= 1'b0;
        else if(Ack_in_d!=Ack_in_sync2)
            Ack_out <= ~Ack_out;
        else Ack_out <= Ack_out;
    end

endmodule