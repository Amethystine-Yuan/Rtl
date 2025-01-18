//===================================================================== 
// Description: 
//     1. Generate Enable signal for each core
//     2. Generate timestamp to each core, in order to measure the latency metrics
//
// Designer : Shao lin, Jin zeyuan
// Revision History: 
// 
//
// ====================================================================

`include "./noc_define.v"

module global_cnt (
    input wire clk_global,
    input wire rst_n,
    input wire enable_wire,
    output reg enable_global,

	output reg [`TIME_WIDTH-1:0] counter_num,
    output reg [31:0] counter_out,

    input wire packet_side_en,


    input wire receive_packet_finish_flag00,
    input wire receive_packet_finish_flag01,
    input wire receive_packet_finish_flag02,
    input wire receive_packet_finish_flag03,
    input wire receive_packet_finish_flag10,
    input wire receive_packet_finish_flag11,
    input wire receive_packet_finish_flag12,
    input wire receive_packet_finish_flag13,
    input wire receive_packet_finish_flag20,
    input wire receive_packet_finish_flag21,
    input wire receive_packet_finish_flag22,
    input wire receive_packet_finish_flag23,
    input wire receive_packet_finish_flag30,
    input wire receive_packet_finish_flag31,
    input wire receive_packet_finish_flag32,
    input wire receive_packet_finish_flag33,


    input wire receive_finish_flag00,
    input wire receive_finish_flag01,
    input wire receive_finish_flag02,
    input wire receive_finish_flag03,
    input wire receive_finish_flag10,
    input wire receive_finish_flag11,
    input wire receive_finish_flag12,
    input wire receive_finish_flag13,
    input wire receive_finish_flag20,
    input wire receive_finish_flag21,
    input wire receive_finish_flag22,
    input wire receive_finish_flag23,
    input wire receive_finish_flag30,
    input wire receive_finish_flag31,
    input wire receive_finish_flag32,
    input wire receive_finish_flag33
);

    always@(posedge clk_global or negedge rst_n) begin
        if (!rst_n) begin
            enable_global <= 0;
        end else if(packet_side_en)begin
            if(receive_packet_finish_flag00 & receive_packet_finish_flag01 & receive_packet_finish_flag02 & receive_packet_finish_flag03
             & receive_packet_finish_flag10 & receive_packet_finish_flag11 & receive_packet_finish_flag12 & receive_packet_finish_flag13
             & receive_packet_finish_flag20 & receive_packet_finish_flag21 & receive_packet_finish_flag22 & receive_packet_finish_flag23
             & receive_packet_finish_flag30 & receive_packet_finish_flag31 & receive_packet_finish_flag32 & receive_packet_finish_flag33) begin
                enable_global <= 0;
            end else begin
                enable_global <= enable_wire;
            end   
        end   
        else begin
            if(receive_finish_flag00 & receive_finish_flag01 & receive_finish_flag02 & receive_finish_flag03
             & receive_finish_flag10 & receive_finish_flag11 & receive_finish_flag12 & receive_finish_flag13
             & receive_finish_flag20 & receive_finish_flag21 & receive_finish_flag22 & receive_finish_flag23
             & receive_finish_flag30 & receive_finish_flag31 & receive_finish_flag32 & receive_finish_flag33) begin
                enable_global <= 0;
            end else begin
                enable_global <= enable_wire;
            end
        end
        // else  enable_global <= enable_wire;
    end 

    reg [15:0] counter;

    always @(posedge clk_global or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 16'b1;
        end else begin
            if (enable_global) begin
                counter <= counter + 1;
            end else  begin
                counter <= counter;
			end
        end
    end

    always @(posedge clk_global or negedge rst_n) begin
        if (!rst_n) begin
            counter_out <= 32'b0;
        end else begin
            if (enable_global) begin
                counter_out <= counter_out + 1;
            end else  begin
                counter_out <= counter_out;
			end
        end
    end

    always @(posedge clk_global or negedge rst_n) begin
        if (!rst_n)
            counter_num <= 0;
        else
            counter_num <= (counter>>1)^counter;
    end

endmodule
