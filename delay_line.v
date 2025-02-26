`timescale 1ns/1ps

// Simulation
module delay_line (
    input wire [31:0] delay,
    input wire in,
    input wire [4:0] max_delay,
    output reg out
);
    always @(*) begin
        if(delay<200*max_delay)
            out <= #(delay*0.8/400) in; 
        else out <= #((delay-(200*max_delay))*0.8/400) ~in; 
        // out <= in;
    end


    // always @(posedge clk0_ori) begin
    //     if(j<max_T) clk0_tmp <= #(j*0.8/400.00) ~clk0_tmp;
    //     else clk0_tmp <= #((j-max_T)*0.8/400.00) ~clk0_tmp;
    // end
endmodule