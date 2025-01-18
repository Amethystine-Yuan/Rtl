
module FIFO_sync2_PE #(parameter DSIZE = 80, parameter ASIZE = 5) (
    output      [DSIZE-1:0] rdata,
    output                  wfull,
    output                  rempty_n,
    input       [DSIZE-1:0] wdata,
    input                   winc, clk, 
    input                   rinc, rst_n,
    output                  alert,
    input                   PC_head,
    input [4:0]             N,
    input [4:0]             PC);

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    wire rempty;

    assign rempty_n = ~rempty;

    alert_ctrl #(ASIZE) alert_ctrl (
        .clk(clk), .rst_n(rst_n),
        .PC_head(PC_head),
        .alert(alert),
        .N(N), .PC(PC),
        .winc(winc), .rinc(rinc),
        .rempty(rempty), .wfull(wfull));

    sync_r2w_PE #(ASIZE) sync_r2w
            (.wq2_rptr(wq2_rptr), .rptr(rptr),
            .wclk(clk), .wrst_n(rst_n));

    sync_w2r_PE #(ASIZE) sync_w2r
            (.rq2_wptr(rq2_wptr), .wptr(wptr),
            .rclk(clk), .rrst_n(rst_n));

    fifomem_PE #(DSIZE, ASIZE) fifomem
            (.rdata(rdata), .wdata(wdata),
            .waddr(waddr), .raddr(raddr),
            .wclken(winc), .wfull(wfull),
            .wclk(clk),
            .rempty(rempty),
            .rclk(clk),
            .rrst_n(rst_n));

    rptr_empty_PE #(ASIZE) rptr_empty
            (.rempty(rempty),
            .raddr(raddr),
            .rptr(rptr), .rq2_wptr(rq2_wptr),
            .rinc(rinc), .rclk(clk),
            .rrst_n(rst_n));

    wptr_full_PE #(ASIZE) wptr_full
            (.wfull(wfull), .waddr(waddr),
            .wptr(wptr), .wq2_rptr(wq2_rptr),
            .winc(winc), .wclk(clk),
            .wrst_n(rst_n));
endmodule


module alert_ctrl #(parameter ADDRSIZE = 4)(
    input wire clk,
    input wire rst_n,
    input wire PC_head,
    output wire alert,
    input wire [4:0] N,
    input wire [4:0] PC,
    input wire winc,
    input wire rinc,
    input wire rempty,
    input wire wfull);

    assign alert = 1'b0;

    // localparam DEPTH = 1<<ADDRSIZE;
    // reg [9:0] counter;
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) counter <= 10'b0;
    //     else begin
    //         case({winc, rinc})
    //             2'b10: begin
    //                 if(!wfull) counter <= counter + 1;
    //                 else counter <= counter;
    //             end
    //             2'b01: begin
    //                 if(!rempty) counter <= counter - 1;
    //                 else counter <= counter;
    //             end
    //             2'b11: begin
    //                 if((!wfull)&&(!rempty)) counter <= counter;
    //                 else if(!wfull) counter <= counter + 1;
    //                 else if(!rempty) counter <= counter - 1;
    //                 else counter <= counter;
    //             end
    //             default: begin
    //                 counter <= counter;
    //             end
    //             endcase
    //     end
    // end
    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n) alert <= 1'b0;
    //     else if(PC_head) begin
    //         if(counter + N >= DEPTH - N) alert <= 1'b1;
    //         else alert <= 1'b0;
    //     end
    //     else alert <= alert;
    // end
endmodule


module fifomem_PE #(parameter DATASIZE = 8, // Memory data word width
                 parameter ADDRSIZE = 4) // Number of mem address bits
    (output reg [DATASIZE-1:0]  rdata,
    input  [DATASIZE-1:0]  wdata,
    input  [ADDRSIZE-1:0]  waddr, raddr,
    input                  wclken, wfull, wclk,
    input                  rempty,
    input                  rclk,
    input                  rrst_n);

    // RTL Verilog memory model
    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];

    // always @(*) rdata = mem[raddr];

    always @(*) begin
        if(!rempty) rdata = mem[raddr];
        else rdata = 0;
    end
    
    always @(posedge wclk)
        if (wclken && !wfull) mem[waddr] <= wdata;
endmodule


module sync_r2w_PE #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    wq2_rptr,
    input       [ADDRSIZE:0]    rptr,
    input                       wclk, wrst_n);

    reg [ADDRSIZE:0] wq1_rptr;

    // always @(posedge wclk or negedge wrst_n)
    //     if (!wrst_n)    {wq2_rptr,wq1_rptr} <= 0;
    //     else            {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
    always@(*) begin
        wq2_rptr = rptr;
    end
endmodule


module sync_w2r_PE #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    rq2_wptr,
    input       [ADDRSIZE:0]    wptr,
    input                       rclk, rrst_n);

    reg [ADDRSIZE:0] rq1_wptr;

    // always @(posedge rclk or negedge rrst_n)
    //     if (!rrst_n)    {rq2_wptr,rq1_wptr} <= 0;
    //     else            {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
    always@(*) begin
        rq2_wptr = wptr;
    end
endmodule


module rptr_empty_PE #(parameter ADDRSIZE = 4)(
    output reg                 rempty,
    output     [ADDRSIZE-1:0]  raddr,
    output reg [ADDRSIZE  :0]  rptr,
    input      [ADDRSIZE  :0]  rq2_wptr,
    input                      rinc, rclk, rrst_n);

    reg     [ADDRSIZE:0]    rbin;
    wire    [ADDRSIZE:0]    rgraynext, rbinnext;
    reg     [ADDRSIZE:0]    rgraynext_reg;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)    {rbin, rptr} <= 0;
        else            {rbin, rptr} <= {rbinnext, rgraynext};
    end
    always @(posedge rclk) rgraynext_reg <= rgraynext;

    assign raddr = rbin[ADDRSIZE-1:0];

    assign rbinnext = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext>>1) ^ rbinnext;

    // FIFO empty when the next rptr == synchronized wptr or on reset
    assign rempty_val = (rgraynext == rq2_wptr)||(rgraynext_reg == rq2_wptr);

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n)    rempty <= 1'b1;
        else            rempty <= rempty_val;
endmodule


module wptr_full_PE #(parameter ADDRSIZE = 4) (
    output reg                 wfull,
    output     [ADDRSIZE-1:0]  waddr,
    output reg [ADDRSIZE  :0]  wptr,
    input      [ADDRSIZE  :0]  wq2_rptr,
    input                      winc, wclk, wrst_n);

    reg     [ADDRSIZE:0] wbin;
    wire    [ADDRSIZE:0] wgraynext, wbinnext;

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    {wbin, wptr} <= 0;
        else            {wbin, wptr} <= {wbinnext, wgraynext};

    assign waddr = wbin[ADDRSIZE-1:0];
    
    assign wbinnext = wbin + (winc & ~wfull);
    assign wgraynext = (wbinnext>>1) ^ wbinnext;

    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
                                     wq2_rptr[ADDRSIZE-2:0]});

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    wfull <= 1'b0;
        else            wfull <= wfull_val;
endmodule