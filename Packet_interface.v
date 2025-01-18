module Packet_interface#(parameter DSIZE = 8, parameter ASIZE = 4) (
    output      [DSIZE-1:0] rdata,
    output                  wfull,
    output                  rempty_n,
    input       [DSIZE-1:0] wdata,
    input                   winc, wclk, 
    input                   rinc, rclk, rst_n);


    

endmodule