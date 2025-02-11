module direction_decoder(
    input wire [3:0] direction,
    output reg [4:0] direction_new
);

    always@(*) begin
        case(direction)
            4'b0000: direction_new = 5'b10000;
            4'b1000: direction_new = 5'b01000;
            4'b0100: direction_new = 5'b00100;
            4'b0010: direction_new = 5'b00010;
            4'b0001: direction_new = 5'b00001;
            4'b1111: direction_new = 5'b00000;
            default: direction_new = 5'b00000;
        endcase
    end

endmodule