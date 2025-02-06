`timescale 1ns/1ps

module counter (
    input din,
    input start,
    input clk,
    input rst_n,
    output reg [31:0] cnt,
	output reg cnt_full
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 32'b0;
			cnt_full <= 1'b0;
        end else begin
            if (start & din & (!cnt_full)) begin
                cnt <= cnt + 1;
            end else  begin
                cnt <= cnt;
			end
			
			cnt_full <= (cnt>=32'hfffffffe) ? 1'b1 : 1'b0;
        end
    end
    
endmodule
