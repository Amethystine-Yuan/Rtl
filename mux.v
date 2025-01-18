
module mux  (input wire rst_n,
             input wire input4,//Local
             input wire input3,//West
             input wire input2,//North
             input wire input1,//East
             input wire input0,//South
             input wire [4:0] RoutingDirection,
             output reg output_wire
             );

    always @(*) begin
        if(!rst_n) output_wire = 1'b0;
        else begin
            case(RoutingDirection)
                5'b10000: output_wire = input4;
                5'b01000: output_wire = input3;
                5'b00100: output_wire = input2;
                5'b00010: output_wire = input1;
                5'b00001: output_wire = input0;
                default: output_wire = 1'b0;
            endcase
        end
    end

endmodule


module mux_clk  (input wire rst_n,
             input wire input4,//Local
             input wire input3,//West
             input wire input2,//North
             input wire input1,//East
             input wire input0,//South
             input wire [4:0] RoutingDirection,
             output reg output_wire
             );

    // CKMUX2D1BWP30P140 CK_lib_cmux_0 (.I0(1'b0),   .I1(input0),  .S(RoutingDirection[0]), .Z(ck_mix_out_0)  );
    // CKMUX2D1BWP30P140 CK_lib_cmux_1 (.I0(ck_mix_out_0),   .I1(input1),  .S(RoutingDirection[1]), .Z(ck_mix_out_1)  );
    // CKMUX2D1BWP30P140 CK_lib_cmux_2 (.I0(ck_mix_out_1),   .I1(input2),  .S(RoutingDirection[2]), .Z(ck_mix_out_2)  );
    // CKMUX2D1BWP30P140 CK_lib_cmux_3 (.I0(ck_mix_out_2),   .I1(input3),  .S(RoutingDirection[3]), .Z(ck_mix_out_3)  );
    // CKMUX2D1BWP30P140 CK_lib_cmux_4 (.I0(ck_mix_out_3),   .I1(input4),  .S(RoutingDirection[4]), .Z(output_wire)  );


    always @(*) begin
        if(!rst_n) output_wire = 1'b0;
        else begin
            case(RoutingDirection)
                5'b10000: output_wire = input4;
                5'b01000: output_wire = input3;
                5'b00100: output_wire = input2;
                5'b00010: output_wire = input1;
                5'b00001: output_wire = input0;
                default: output_wire = 1'b0;
            endcase
        end
    end

endmodule