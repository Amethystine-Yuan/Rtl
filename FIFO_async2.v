
module FIFO_async2 #(parameter DSIZE = 8, parameter ASIZE = 4) (
    output      [DSIZE-1:0] rdata,
    output                  wfull,
    output                  rempty_n,
    input       [DSIZE-1:0] wdata,
    input                   winc, wclk, 
    input                   rinc, rclk, rst_n);

    wire [ASIZE-1:0] waddr, raddr;
    wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    wire rempty;
    reg rinc_d;
    always @(posedge rclk ) begin
        rinc_d <= rinc;
    end
    //20241220 modified
    assign rempty_n = ~rempty && rinc;

    sync_r2w #(ASIZE) sync_r2w
            (.wq2_rptr(wq2_rptr), .rptr(rptr),
            .wclk(wclk), .wrst_n(rst_n));

    sync_w2r #(ASIZE) sync_w2r
            (.rq2_wptr(rq2_wptr), .wptr(wptr),
            .rclk(rclk), .rrst_n(rst_n));

    fifomem #(DSIZE, ASIZE) fifomem
            (.rdata(rdata), .wdata(wdata),
            .waddr(waddr), .raddr(raddr),
            .wclken(winc), .wfull(wfull),
            .wclk(wclk),
            .rempty(rempty),
            .rclk(rclk),
            .rrst_n(rst_n));

    rptr_empty #(ASIZE) rptr_empty
            (.rempty(rempty),
            .raddr(raddr),
            .rptr(rptr), .rq2_wptr(rq2_wptr),
            .rinc(rinc), .rclk(rclk),
            .rrst_n(rst_n));

    wptr_full #(ASIZE) wptr_full
            (.wfull(wfull), .waddr(waddr),
            .wptr(wptr), .wq2_rptr(wq2_rptr),
            .winc(winc), .wclk(wclk),
            .wrst_n(rst_n));
endmodule


module fifomem #(parameter DATASIZE = 8, // Memory data word width
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

    // reg rdata_reg;
    // always @(posedge rclk or negedge rrst_n) begin
    //     if(!rrst_n)
    //         rdata_reg <= 0;
    //     else rdata_reg <= rdata;
    // end
    
    always @(*) begin
        if(!rempty) rdata = mem[raddr];
        else rdata = 0;
    end

    
    
    always @(posedge wclk)
        if (wclken && !wfull) mem[waddr] <= wdata;
endmodule


module sync_r2w #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    wq2_rptr,
    input       [ADDRSIZE:0]    rptr,
    input                       wclk, wrst_n);

    reg [ADDRSIZE:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    {wq2_rptr,wq1_rptr} <= 0;
        else            {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
    // always @(posedge wclk or negedge wrst_n)
    //     if (!wrst_n)    {wq2_rptr} <= 0;
    //     else            {wq2_rptr} <= {rptr};
endmodule


module sync_w2r #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    rq2_wptr,
    input       [ADDRSIZE:0]    wptr,
    input                       rclk, rrst_n);

    reg [ADDRSIZE:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n)    {rq2_wptr,rq1_wptr} <= 0;
        else            {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
    // always @(posedge rclk or negedge rrst_n)
    //     if (!rrst_n)    {rq2_wptr} <= 0;
    //     else            {rq2_wptr} <= {wptr};
endmodule


module rptr_empty #(parameter ADDRSIZE = 4)(
    output reg                 rempty,
    output     [ADDRSIZE-1:0]  raddr,
    output reg [ADDRSIZE  :0]  rptr,
    input      [ADDRSIZE  :0]  rq2_wptr,
    input                      rinc, rclk, rrst_n);

    reg     [ADDRSIZE:0]    rbin;
    wire    [ADDRSIZE:0]    rgraynext, rbinnext;
    // reg     [ADDRSIZE:0]    rgraynext_reg;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)    {rbin, rptr} <= 0;
        else            {rbin, rptr} <= {rbinnext, rgraynext};
    end
    // always @(posedge rclk) rgraynext_reg <= rgraynext;

    assign raddr = rbin[ADDRSIZE-1:0];

    assign rbinnext = rbin + (rinc & ~rempty);
    assign rgraynext = (rbinnext>>1) ^ rbinnext;

    // FIFO empty when the next rptr == synchronized wptr or on reset
    // assign rempty_val = (rgraynext == rq2_wptr)||(rgraynext_reg == rq2_wptr);
    // 20241220 modified
    assign rempty_val = (rgraynext == rq2_wptr);

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n)    rempty <= 1'b1;
        else            rempty <= rempty_val;
endmodule


module wptr_full #(parameter ADDRSIZE = 4) (
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