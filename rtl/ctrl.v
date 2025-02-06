//----------------------------
// Create Date:     2021/02/01
// Project Name:    MEDAC
// Module Name:     ctrl
// Author: s0
// Description: 
// Revision:        2021/02/01  1.0
// Additional Comments: 
//----------------------------
module ctrl(input wire clk,
            input wire rst_n,
            input wire error_lagging,
            input wire error_origin,
            input wire error_leading,
            output reg [1:0] clk_sel);

    reg [2:0] state;
    reg [2:0] next_state;

    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110;

    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) state <= S0;
    //     else state <= next_state;
    // end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else state <= next_state;
    end

    always @(*) begin
		if (!rst_n)
			next_state = S0;
		else
       	    case(state)
       	        3'b000://S0
       	            if(error_lagging) next_state = S1;
       	            else if(error_leading) next_state = S4;
       	            else if (error_origin) next_state = S2; // not sure
                    else next_state = S0;
       	        3'b001://S1
       	            if(error_lagging) next_state = S1;
       	            else if(error_origin) next_state = S2;
       	            else if(error_leading) next_state = S4;
                    else next_state = S1;
       	        3'b010://S2
       	            if(error_lagging) next_state = S6;
       	            else if(error_origin) next_state = S2;
       	            else if(error_leading) next_state = S3;
                    else next_state = S2;
       	        3'b011://S3
       	            if(error_lagging) next_state = S1;
       	            else if(error_origin) next_state = S5;
       	            else if(error_leading) next_state = S3;
                    else next_state = S3;
       	        3'b100://S4
       	            if(error_lagging) next_state = S1;
       	            else if(error_origin) next_state = S5;
       	            else if(error_leading) next_state = S4;
                    else next_state = S4;
       	        3'b101://S5
       	            if(error_lagging) next_state = S6;
       	            else if(error_origin) next_state = S5;
       	            else if(error_leading) next_state = S3;
                    else next_state = S5;
       	        3'b110://S6
       	            if(error_lagging) next_state = S6;
       	            else if(error_origin) next_state = S2;
       	            else if(error_leading) next_state = S4;
                    else next_state = S6;
       	        default: next_state = S0;
       	    endcase
    end

    //always @(*) begin
    //    if (!rst_n) next_state = S0;
    //end

    always @(*) begin
        case(state)
            3'b000:begin//S0
                clk_sel = 2'b01;//origin phase
            end
            3'b001:begin//S1
                clk_sel = 2'b00;//leading phase
            end
            3'b010:begin//S2
                clk_sel = 2'b10;//lagging phase
            end
            3'b011:begin//S3
                clk_sel = 2'b01;//origin phase
            end
            3'b100:begin//S4
                clk_sel = 2'b10;//lagging phase
            end
            3'b101:begin//S5
                clk_sel = 2'b00;//leading phase
            end
            3'b110:begin//S6
                clk_sel = 2'b01;//origin phase
            end
			default: clk_sel = 2'b01;
        endcase
    end
endmodule
