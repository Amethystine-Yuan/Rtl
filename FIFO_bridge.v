
module FIFO_bridge_inport #(parameter DATASIZE = 8, parameter ADDRSIZE = 4) (
    output reg [DATASIZE-1:0]   rdata,
    output reg                  wfull,
    output reg                  rempty,
    input  [DATASIZE-2:0]       wdata,
    input                       winc, wclk, 
    input                       rclk,
    input                       rst_n);

    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-2:0] mem [0:DEPTH-1];
    reg [ADDRSIZE:0] wgray, wgraynext, rgraynext;
    wire [ADDRSIZE:0] rbin, rgray;
    reg [ADDRSIZE:0] wbin, wbinnext, rbinnext;
    wire wfull_val;
    wire [ADDRSIZE-1:0] raddr, waddr;
    reg [DATASIZE-2:0] rdata_pre;

    // write pointer
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) wgray <= 0;
        else if(~wfull) wgray <= wgraynext;
        else wgray <= wgray;
    end
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) wbin <= 0;
        else if(~wfull) wbin <= wbinnext;
        else wbin <= wbin;
    end
    always@(*) begin
        if(!rst_n) wbinnext = 0;
        else wbinnext = wbin + (winc & ~wfull);
    end
    always@(*) begin
        if(!rst_n) wgraynext = 0;
        else wgraynext = (wbinnext>>1) ^ wbinnext;
    end

    // read pointer
    // always@(negedge rclk or negedge rst_n) begin
    //     if(!rst_n) rgray <= 0;
    //     else if(~rempty) rgray <= rgraynext;
    //     else rgray <= rgray;
    // end
    // always@(negedge rclk or negedge rst_n) begin
    //     if(!rst_n) rbin <= 0;
    //     else if(~rempty) rbin <= rbinnext;
    //     else rbin <= rbin;
    // end
    genvar j;
    generate 
        for(j=0;j<=ADDRSIZE;j=j+1) begin: DEFF_rgray
            DEFFE DEFFE_rgray(.clk(rclk), .EN(~rempty), .D(rgraynext[j]), .rst_n(rst_n), .Q(rgray[j]));
            DEFFE DEFFE_rbin (.clk(rclk), .EN(~rempty), .D(rbinnext[j]),  .rst_n(rst_n), .Q(rbin[j]));
        end
    endgenerate
    always@(*) begin
        if(!rst_n) rbinnext = 0;
        else rbinnext = rbin + (1'b1 & ~rempty);
    end
    always@(*) begin
        if(!rst_n) rgraynext = 0;
        else rgraynext = (rbinnext>>1) ^ rbinnext;
    end

    // r2w sync
    reg [ADDRSIZE:0] wq1_rptr, wq2_rptr;
    always @(posedge wclk or negedge rst_n) begin
        if (!rst_n) {wq2_rptr,wq1_rptr} <= 0;
        else        {wq2_rptr,wq1_rptr} <= {wq1_rptr,rgray};
    end

    // wfull & rempty
    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
                                     wq2_rptr[ADDRSIZE-2:0]});
    always @(posedge wclk or negedge rst_n) begin
        if (!rst_n) wfull <= 1'b0;
        else        wfull <= wfull_val;
    end
    assign rempty_val = (rgray == wgray);
    always@(*) begin
        if (!rst_n) rempty = 1'b1;
        else        rempty = rempty_val;
    end

    // mem
    assign waddr = wbin[ADDRSIZE-1:0];
    assign raddr = rbin[ADDRSIZE-1:0];
    always@(*) begin
        if(!rst_n) rdata_pre = 4'b1111;
        else if(!rempty) rdata_pre = mem[raddr];
        else rdata_pre = 4'b1111;
    end
    always@(*) begin
        case(rdata_pre)
            4'b0000: rdata = 5'b10000;
            4'b1000: rdata = 5'b01000;
            4'b0100: rdata = 5'b00100;
            4'b0010: rdata = 5'b00010;
            4'b0001: rdata = 5'b00001;
            4'b1111: rdata = 5'b00000;
            default: rdata = 5'b00000;
        endcase
    end
    
    
    // always@(posedge wclk)
    //     if ((!wfull)&&winc) mem[waddr] <= wdata;

    always@(posedge wclk) begin
        if(!rst_n) begin
            mem[0]  <= 4'b1111;
            mem[1]  <= 4'b1111;
            mem[2]  <= 4'b1111;
            mem[3]  <= 4'b1111;
            mem[4]  <= 4'b1111;
            mem[5]  <= 4'b1111;
            mem[6]  <= 4'b1111;
            mem[7]  <= 4'b1111;
            mem[8]  <= 4'b1111;
            mem[9]  <= 4'b1111;
            mem[10] <= 4'b1111;
            mem[11] <= 4'b1111;
            mem[12] <= 4'b1111;
            mem[13] <= 4'b1111;
            mem[14] <= 4'b1111;
            mem[15] <= 4'b1111;
        end
        else if ((!wfull)&&winc) mem[waddr] <= wdata;
    end

endmodule


module FIFO_bridge_outport #(parameter DATASIZE = 8, parameter ADDRSIZE = 4) (
    output reg [DATASIZE-1:0]   rdata,
    output reg                  wfull,
    output reg                  rempty,
    input  [DATASIZE-1:0]       wdata,
    input                       winc, wclk, 
    input                       rclk,
    input                       rst_n,
    output reg                  rclk_sync,
    output reg [4:0]            rdata_sync);

    reg [DATASIZE-1:0] rdata_reg1, rdata_reg2;
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) begin
            rclk_sync <= 1'b0;
        end else begin
            rclk_sync <= rclk;
        end
    end
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) begin
            rdata_sync <= 0;
        end else begin
            rdata_sync <= rdata;
        end
    end

    localparam DEPTH = 1<<ADDRSIZE;
    reg [DATASIZE-1:0] mem [0:DEPTH-1];
    reg [ADDRSIZE:0] wgray, wgraynext, rgraynext;
    wire [ADDRSIZE:0] rbin, rgray;
    reg [ADDRSIZE:0] wbin, wbinnext, rbinnext;
    wire wfull_val;
    wire [ADDRSIZE-1:0] raddr, waddr;

    // write pointer
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) wgray <= 0;
        else if(~wfull) wgray <= wgraynext;
        else wgray <= wgray;
    end
    always@(posedge wclk or negedge rst_n) begin
        if(!rst_n) wbin <= 0;
        else if(~wfull) wbin <= wbinnext;
        else wbin <= wbin;
    end
    always@(*) begin
        if(!rst_n) wbinnext = 0;
        else wbinnext = wbin + (winc & ~wfull);
    end
    always@(*) begin
        if(!rst_n) wgraynext = 0;
        else wgraynext = (wbinnext>>1) ^ wbinnext;
    end

    // read pointer
    // always@(negedge rclk or negedge rst_n) begin
    //     if(!rst_n) rgray <= 0;
    //     else if(~rempty) rgray <= rgraynext;
    //     else rgray <= rgray;
    // end
    // always@(negedge rclk or negedge rst_n) begin
    //     if(!rst_n) rbin <= 0;
    //     else if(~rempty) rbin <= rbinnext;
    //     else rbin <= rbin;
    // end
    genvar j;
    generate 
        for(j=0;j<=ADDRSIZE;j=j+1) begin: DEFF_rgray
            DEFFE DEFFE_rgray(.clk(rclk), .EN(~rempty), .D(rgraynext[j]), .rst_n(rst_n), .Q(rgray[j]));
            DEFFE DEFFE_rbin (.clk(rclk), .EN(~rempty), .D(rbinnext[j]),  .rst_n(rst_n), .Q(rbin[j]));
        end
    endgenerate
    always@(*) begin
        if(!rst_n) rbinnext = 0;
        else rbinnext = rbin + (1'b1 & ~rempty);
    end
    always@(*) begin
        if(!rst_n) rgraynext = 0;
        else rgraynext = (rbinnext>>1) ^ rbinnext;
    end

    // r2w sync
    reg [ADDRSIZE:0] wq1_rptr, wq2_rptr;
    always @(posedge wclk or negedge rst_n) begin
        if (!rst_n) {wq2_rptr,wq1_rptr} <= 0;
        else        {wq2_rptr,wq1_rptr} <= {wq1_rptr,rgray};
    end

    // wfull & rempty
    assign wfull_val = (wgraynext=={~wq2_rptr[ADDRSIZE:ADDRSIZE-1],
                                     wq2_rptr[ADDRSIZE-2:0]});
    always @(posedge wclk or negedge rst_n) begin
        if (!rst_n) wfull <= 1'b0;
        else        wfull <= wfull_val;
    end
    assign rempty_val = (rgray == wgray);
    always@(*) begin
        if (!rst_n) rempty = 1'b1;
        else        rempty = rempty_val;
    end

    // mem
    assign waddr = wbin[ADDRSIZE-1:0];
    assign raddr = rbin[ADDRSIZE-1:0];
    always@(*) begin
        if(!rst_n) rdata = 0;
        else if(!rempty) rdata = mem[raddr];
        else rdata = 5'b0;
    end
    
    
    // always@(posedge wclk)
    //     if ((!wfull)&&winc) mem[waddr] <= wdata;

    always@(posedge wclk) begin
        if(!rst_n) begin
            mem[0]  <= 5'b0;
            mem[1]  <= 5'b0;
            mem[2]  <= 5'b0;
            mem[3]  <= 5'b0;
            mem[4]  <= 5'b0;
            mem[5]  <= 5'b0;
            mem[6]  <= 5'b0;
            mem[7]  <= 5'b0;
            mem[8]  <= 5'b0;
            mem[9]  <= 5'b0;
            mem[10] <= 5'b0;
            mem[11] <= 5'b0;
            mem[12] <= 5'b0;
            mem[13] <= 5'b0;
            mem[14] <= 5'b0;
            mem[15] <= 5'b0;
        end
        else if ((!wfull)&&winc) mem[waddr] <= wdata;
    end

endmodule