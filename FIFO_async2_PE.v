
module FIFO_async2_PE #(parameter DATASIZE = 8,
                        parameter ADDRSIZE = 4)(
    output      [DATASIZE-1:0]    rdata,
    output                          wfull,
    output                          ack,
    output                          rempty_n,
    input       [DATASIZE-1:0]    wdata,
    input                           winc, wclk, 
    input                           rinc, rclk, rst_n);

    wire [ADDRSIZE-1:0] waddr, raddr;
    wire [ADDRSIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;

    wire rempty;

    assign rempty_n = ~rempty;

    async2_sync_r2w_PE #(ADDRSIZE) async2_sync_r2w
            (.wq2_rptr(wq2_rptr), .rptr(rptr),
            .wclk(wclk), .wrst_n(rst_n));

    async2_sync_w2r_PE #(ADDRSIZE) async2_sync_w2r
            (.rq2_wptr(rq2_wptr), .wptr(wptr),
            .rclk(rclk), .rrst_n(rst_n));

    async2_fifomem_PE #(DATASIZE, ADDRSIZE) async2_fifomem
            (.rdata(rdata), 
            .wdata(wdata),
            .waddr(waddr), 
            .raddr(raddr),
            .wclken(winc), 
            .wfull(wfull),
            .wclk(wclk),
            .rempty(rempty),
            .rclk(rclk),
            .rrst_n(rst_n),
            .wrst_n(rst_n)
            );

    async2_rptr_empty_PE #(ADDRSIZE) async2_rptr_empty
            (.rempty(rempty),
            .raddr(raddr),
            .rptr(rptr), 
            .rq2_wptr(rq2_wptr),
            .rinc(rinc), 
            .rclk(rclk),
            .rrst_n(rst_n));

    async2_wptr_full_PE #(ADDRSIZE) async2_wptr_full
            (.wfull(wfull), 
            .waddr(waddr),
            .ack(ack),
            .wptr(wptr), 
            .wq2_rptr(wq2_rptr),
            .winc(winc), 
            .wclk(wclk),
            .wrst_n(rst_n)
            );
endmodule


module async2_fifomem_PE #(parameter DATASIZE = 8, // Memory data word width
                 parameter ADDRSIZE = 4) // Number of mem address bits
    (output reg [DATASIZE-1:0]  rdata,
    input  [DATASIZE-1:0]  wdata,
    input  [ADDRSIZE-1:0]  waddr, raddr,
    input                  wclken, wfull, wclk, wrst_n,
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

    reg wfull_reg;
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) wfull_reg <= 0;
        else wfull_reg <= wfull;
    end

    reg flag;
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) flag <= 0;
        else if((wfull_reg!=wfull)&&wfull_reg) flag <= 1;
        else flag <= flag;
    end

    reg flag_plus;
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) flag_plus <= 0;
        else if(flag&&wfull) flag_plus <= 1;
        else flag_plus <= flag_plus;
    end

    
    always @(posedge wclk) begin
        if((wfull_reg!=wfull)&&wfull_reg&&flag_plus&&wfull) mem[waddr] <= wdata;
        else if (wclken && !wfull) mem[waddr] <= wdata;
    end
endmodule


module async2_sync_r2w_PE #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    wq2_rptr,
    input       [ADDRSIZE:0]    rptr,
    input                       wclk, wrst_n);

    reg [ADDRSIZE:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    {wq2_rptr,wq1_rptr} <= 0;
        else            {wq2_rptr,wq1_rptr} <= {wq1_rptr,rptr};
endmodule


module async2_sync_w2r_PE #(parameter ADDRSIZE = 4)
    (output reg [ADDRSIZE:0]    rq2_wptr,
    input       [ADDRSIZE:0]    wptr,
    input                       rclk, rrst_n);

    reg [ADDRSIZE:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n)    {rq2_wptr,rq1_wptr} <= 0;
        else            {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule


module async2_rptr_empty_PE #(parameter ADDRSIZE = 4)(
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


module async2_wptr_full_PE #(parameter ADDRSIZE = 4) (
    output reg                 wfull,
    output     [ADDRSIZE-1:0]  waddr,
    output reg [ADDRSIZE  :0]  wptr,
    output reg                 ack,
    input      [ADDRSIZE  :0]  wq2_rptr,
    input                      winc, wclk, wrst_n,
    output reg    [ADDRSIZE:0] wbin,
    output reg     [ADDRSIZE:0] wbinnext);

    // reg     [ADDRSIZE:0] wbin;
    wire    [ADDRSIZE:0] wgraynext;
    // reg     [ADDRSIZE:0] wbinnext;
    reg wfull_reg;

    reg flag;
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) flag <= 0;
        else if((wfull_reg!=wfull)&&wfull_reg) flag <= 1;
        else flag <= flag;
    end

    reg flag_plus;
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) flag_plus <= 0;
        else if(flag&&wfull) flag_plus <= 1;
        else flag_plus <= flag_plus;
    end

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    {wbin, wptr} <= 0;
        // else if((wfull_reg!=wfull)&&wfull_reg&&flag_plus) {wbin, wptr} <= {wbinnext+1'b1, wgraynext};
        else            {wbin, wptr} <= {wbinnext, wgraynext};

    assign waddr = wbin[ADDRSIZE-1:0];
    
    // assign wbinnext = wbin + (winc & ~wfull);
    always@(*) begin
        // if(!flag) wbinnext = wbin + (winc & ~wfull);
        // else wbinnext = wbin + (winc & ~wfull && flag_plus);
        wbinnext = wbin + (winc & ~wfull);
    end

    // always@(*) begin
    //     if(!wrst_n) wbinnext = 0;
    //     else if(wfull_reg!=wfull) wbinnext = wbin + 1'b1;
    //     else wbinnext = wbin + (winc & ~wfull);
    // end
    assign wgraynext = (wbinnext>>1) ^ wbinnext;

    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
                                     wq2_rptr[ADDRSIZE-2:0]});

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    wfull <= 1'b0;
        else            wfull <= wfull_val;
    


    reg ack_flag;
    reg ack_reg;
    reg winc_buffer;
    
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) wfull_reg <= 0;
        else wfull_reg <= wfull;
    end
    always@(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) ack_reg <= 1'b0;
        else ack_reg <= ack;
    end

    reg ack_flag_reg;
    always @(posedge wclk or negedge wrst_n) begin
        if(!wrst_n) ack_flag_reg <= 1'b0;
        else
            ack_flag_reg <= ack_flag;
    end

    always@(*) begin
        if(!wrst_n) ack_flag = 1'b0;
        else if((ack_reg==ack)&&winc) ack_flag = 1'b1;
        else if((ack_reg!=ack)&&winc) ack_flag = 1'b1;
        else if((ack_reg!=ack)&&!winc) ack_flag = 1'b0;
        else ack_flag = ack_flag_reg;
    end

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n)    ack <= 1'b0;
        else if(wfull_reg!=wfull&(!wfull_val)) ack <= ~ack;
        else if((!wfull_val)&&ack_flag) ack <= ~ack;
        else ack <= ack;

endmodule