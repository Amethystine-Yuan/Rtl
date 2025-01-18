
// module TFF (input wire clk,
//             input wire rst_n,
//             input wire EN,
//             output wire Q);

//     // wire clkN, D, DQ, S, DN;

//     // INVD0BWP lib_invclk(.I(clk), .ZN(clkN));

//     // LHD1BWP lib_dlatch0(.E(clkN), .D(D), .Q(DQ));
//     // AN2D0BWP lib_and0(.A1(clk), .A2(EN), .Z(S));

//     // MUX2D0BWP lib_mux0(.I0(DN), .I1(DQ), .S(S), .Z(Q));
//     // INVD0BWP lib_inv0(.I(D), .ZN(DN));
//     // INVD0BWP lib_inv1(.I(Q), .ZN(D));

//     reg S, DN;
//     wire clkN, DQ, D;
//     INVD0BWP30P140ULVT lib_invclk(.I(clk), .ZN(clkN));
//     LHCNDQD1BWP30P140ULVT lib_dlatch0(.E(clkN), .CDN(rst_n), .D(D), .Q(DQ));
//     always@(*) begin
//         if(!rst_n) S = 1'b0;
//         else S = clk & EN;
//     end
//     MUX2D0BWP30P140ULVT lib_mux0(.I0(DN), .I1(DQ), .S(S), .Z(Q));
    
//     always@(*) begin
//         if(!rst_n) DN = 1'b0;
//         else DN = ~D;
//     end
//     // always@(*) begin
//     //     if(!rst_n) D = 1'b0;
//     //     else D = ~Q;
//     // end
//     INVD0BWP30P140ULVT lib_inv1(.I(Q), .ZN(D));
    
// endmodule

module TFF (input wire clk,
            input wire rst_n,
            input wire EN,
            output reg Q);

        always @(posedge clk or negedge rst_n) begin
            if(!rst_n)
                Q <= 1'b0;
            else if(EN)
                Q <= ~Q;
            else Q <= Q;
        end

endmodule