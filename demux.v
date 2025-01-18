
module demux(input wire rst_n,
            input wire input_wire,
            input wire [4:0] RoutingDirection,
            output reg output4,//Local
            output reg output3,//West
            output reg output2,//North
            output reg output1,//East
            output reg output0 //South
            );

    always @(*) begin
      if(!rst_n) begin
        output4 = 1'b0;
        output3 = 1'b0;
        output2 = 1'b0;
        output1 = 1'b0;
        output0 = 1'b0;
      end else begin
        case(RoutingDirection)
            5'b10000: begin
              output4 = input_wire;
              output3 = 1'b0;
              output2 = 1'b0;
              output1 = 1'b0;
              output0 = 1'b0;
            end
            5'b01000: begin
              output4 = 1'b0;
              output3 = input_wire;
              output2 = 1'b0;
              output1 = 1'b0;
              output0 = 1'b0;
            end
            5'b00100: begin
              output4 = 1'b0;
              output3 = 1'b0;
              output2 = input_wire;
              output1 = 1'b0;
              output0 = 1'b0;
            end
            5'b00010: begin
              output4 = 1'b0;
              output3 = 1'b0;
              output2 = 1'b0;
              output1 = input_wire;
              output0 = 1'b0;
            end
           5'b00001: begin
              output4 = 1'b0;
              output3 = 1'b0;
              output2 = 1'b0;
              output1 = 1'b0;
              output0 = input_wire;
            end
            default: begin
              output4 = 1'b0;
              output3 = 1'b0;
              output2 = 1'b0;
              output1 = 1'b0;
              output0 = 1'b0;
            end
        endcase
      end
    end

endmodule
