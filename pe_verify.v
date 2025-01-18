`include "./noc_define.v"

module pe_verify(
    input wire [3:0] pe_verify_sel,

    // PE_00
    input   wire                            PE_00_clk_test,
    input   wire                            PE_00_clk_global_test,
    input   wire [3:0]                      PE_00_rst_n_test,
    input   wire [15:0]                     PE_00_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_00_signal_test,

    // PE_01
    input   wire                            PE_01_clk_test,
    input   wire                            PE_01_clk_global_test,
    input   wire [3:0]                      PE_01_rst_n_test,
    input   wire [15:0]                     PE_01_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_01_signal_test,

    // PE_02
    input   wire                            PE_02_clk_test,
    input   wire                            PE_02_clk_global_test,
    input   wire [3:0]                      PE_02_rst_n_test,
    input   wire [15:0]                     PE_02_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_02_signal_test,

    // PE_03
    input   wire                            PE_03_clk_test,
    input   wire                            PE_03_clk_global_test,
    input   wire [3:0]                      PE_03_rst_n_test,
    input   wire [15:0]                     PE_03_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_03_signal_test,


    // PE_10
    input   wire                            PE_10_clk_test,
    input   wire                            PE_10_clk_global_test,
    input   wire [3:0]                      PE_10_rst_n_test,
    input   wire [15:0]                     PE_10_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_10_signal_test,

    // PE_11
    input   wire                            PE_11_clk_test,
    input   wire                            PE_11_clk_global_test,
    input   wire [3:0]                      PE_11_rst_n_test,
    input   wire [15:0]                     PE_11_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_11_signal_test,

    // PE_12
    input   wire                            PE_12_clk_test,
    input   wire                            PE_12_clk_global_test,
    input   wire [3:0]                      PE_12_rst_n_test,
    input   wire [15:0]                     PE_12_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_12_signal_test,

    // PE_13
    input   wire                            PE_13_clk_test,
    input   wire                            PE_13_clk_global_test,
    input   wire [3:0]                      PE_13_rst_n_test,
    input   wire [15:0]                     PE_13_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_13_signal_test,

    // PE_20
    input   wire                            PE_20_clk_test,
    input   wire                            PE_20_clk_global_test,
    input   wire [3:0]                      PE_20_rst_n_test,
    input   wire [15:0]                     PE_20_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_20_signal_test,

    // PE_21
    input   wire                            PE_21_clk_test,
    input   wire                            PE_21_clk_global_test,
    input   wire [3:0]                      PE_21_rst_n_test,
    input   wire [15:0]                     PE_21_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_21_signal_test,

    // PE_22
    input   wire                            PE_22_clk_test,
    input   wire                            PE_22_clk_global_test,
    input   wire [3:0]                      PE_22_rst_n_test,
    input   wire [15:0]                     PE_22_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_22_signal_test,

    // PE_23
    input   wire                            PE_23_clk_test,
    input   wire                            PE_23_clk_global_test,
    input   wire [3:0]                      PE_23_rst_n_test,
    input   wire [15:0]                     PE_23_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_23_signal_test,

    // PE_30
    input   wire                            PE_30_clk_test,
    input   wire                            PE_30_clk_global_test,
    input   wire [3:0]                      PE_30_rst_n_test,
    input   wire [15:0]                     PE_30_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_30_signal_test,

    // PE_31
    input   wire                            PE_31_clk_test,
    input   wire                            PE_31_clk_global_test,
    input   wire [3:0]                      PE_31_rst_n_test,
    input   wire [15:0]                     PE_31_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_31_signal_test,

    // PE_32
    input   wire                            PE_32_clk_test,
    input   wire                            PE_32_clk_global_test,
    input   wire [3:0]                      PE_32_rst_n_test,
    input   wire [15:0]                     PE_32_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_32_signal_test,
    // PE_33
    input   wire                            PE_33_clk_test,
    input   wire                            PE_33_clk_global_test,
    input   wire [3:0]                      PE_33_rst_n_test,
    input   wire [15:0]                     PE_33_scan_in_test,
    input   wire [`PDATASIZE + `CDATASIZE + 8 : 0] PE_33_signal_test,

    
    output   reg                                   clk_test,
    output   reg                                   clk_global_test,

    output   reg [3:0]                             rst_n_test,
    output   reg [15:0]                            scan_in_test,
    output   reg [`PDATASIZE + `CDATASIZE + 8 : 0] signal_test
);



    // test
    always @(*) begin
        case(pe_verify_sel[3:0])
            4'b0000: clk_test = PE_00_clk_test;
            4'b0001: clk_test = PE_01_clk_test;
            4'b0010: clk_test = PE_02_clk_test;
            4'b0011: clk_test = PE_03_clk_test;
            4'b0100: clk_test = PE_10_clk_test;
            4'b0101: clk_test = PE_11_clk_test;
            4'b0110: clk_test = PE_12_clk_test;
            4'b0111: clk_test = PE_13_clk_test;
            4'b1000: clk_test = PE_20_clk_test;
            4'b1001: clk_test = PE_21_clk_test;
            4'b1010: clk_test = PE_22_clk_test;
            4'b1011: clk_test = PE_23_clk_test;
            4'b1100: clk_test = PE_30_clk_test;
            4'b1101: clk_test = PE_31_clk_test;
            4'b1110: clk_test = PE_32_clk_test;
            4'b1111: clk_test = PE_33_clk_test;
        endcase
    end

    always @(*) begin
        case(pe_verify_sel[3:0])
            4'b0000: clk_global_test = PE_00_clk_global_test;
            4'b0001: clk_global_test = PE_01_clk_global_test;
            4'b0010: clk_global_test = PE_02_clk_global_test;
            4'b0011: clk_global_test = PE_03_clk_global_test;
            4'b0100: clk_global_test = PE_10_clk_global_test;
            4'b0101: clk_global_test = PE_11_clk_global_test;
            4'b0110: clk_global_test = PE_12_clk_global_test;
            4'b0111: clk_global_test = PE_13_clk_global_test;
            4'b1000: clk_global_test = PE_20_clk_global_test;
            4'b1001: clk_global_test = PE_21_clk_global_test;
            4'b1010: clk_global_test = PE_22_clk_global_test;
            4'b1011: clk_global_test = PE_23_clk_global_test;
            4'b1100: clk_global_test = PE_30_clk_global_test;
            4'b1101: clk_global_test = PE_31_clk_global_test;
            4'b1110: clk_global_test = PE_32_clk_global_test;
            4'b1111: clk_global_test = PE_33_clk_global_test;
        endcase
    end

    always @(*) begin
        case(pe_verify_sel[3:0])
            4'b0000: rst_n_test = PE_00_rst_n_test;
            4'b0001: rst_n_test = PE_01_rst_n_test;
            4'b0010: rst_n_test = PE_02_rst_n_test;
            4'b0011: rst_n_test = PE_03_rst_n_test;
            4'b0100: rst_n_test = PE_10_rst_n_test;
            4'b0101: rst_n_test = PE_11_rst_n_test;
            4'b0110: rst_n_test = PE_12_rst_n_test;
            4'b0111: rst_n_test = PE_13_rst_n_test;
            4'b1000: rst_n_test = PE_20_rst_n_test;
            4'b1001: rst_n_test = PE_21_rst_n_test;
            4'b1010: rst_n_test = PE_22_rst_n_test;
            4'b1011: rst_n_test = PE_23_rst_n_test;
            4'b1100: rst_n_test = PE_30_rst_n_test;
            4'b1101: rst_n_test = PE_31_rst_n_test;
            4'b1110: rst_n_test = PE_32_rst_n_test;
            4'b1111: rst_n_test = PE_33_rst_n_test;
        endcase
    end

    always @(*) begin
        case(pe_verify_sel[3:0])
            4'b0000: scan_in_test = PE_00_scan_in_test;
            4'b0001: scan_in_test = PE_01_scan_in_test;
            4'b0010: scan_in_test = PE_02_scan_in_test;
            4'b0011: scan_in_test = PE_03_scan_in_test;
            4'b0100: scan_in_test = PE_10_scan_in_test;
            4'b0101: scan_in_test = PE_11_scan_in_test;
            4'b0110: scan_in_test = PE_12_scan_in_test;
            4'b0111: scan_in_test = PE_13_scan_in_test;
            4'b1000: scan_in_test = PE_20_scan_in_test;
            4'b1001: scan_in_test = PE_21_scan_in_test;
            4'b1010: scan_in_test = PE_22_scan_in_test;
            4'b1011: scan_in_test = PE_23_scan_in_test;
            4'b1100: scan_in_test = PE_30_scan_in_test;
            4'b1101: scan_in_test = PE_31_scan_in_test;
            4'b1110: scan_in_test = PE_32_scan_in_test;
            4'b1111: scan_in_test = PE_33_scan_in_test;
        endcase
    end

    always @(*) begin
        case(pe_verify_sel[3:0])
            4'b0000: signal_test = PE_00_signal_test;
            4'b0001: signal_test = PE_01_signal_test;
            4'b0010: signal_test = PE_02_signal_test;
            4'b0011: signal_test = PE_03_signal_test;
            4'b0100: signal_test = PE_10_signal_test;
            4'b0101: signal_test = PE_11_signal_test;
            4'b0110: signal_test = PE_12_signal_test;
            4'b0111: signal_test = PE_13_signal_test;
            4'b1000: signal_test = PE_20_signal_test;
            4'b1001: signal_test = PE_21_signal_test;
            4'b1010: signal_test = PE_22_signal_test;
            4'b1011: signal_test = PE_23_signal_test;
            4'b1100: signal_test = PE_30_signal_test;
            4'b1101: signal_test = PE_31_signal_test;
            4'b1110: signal_test = PE_32_signal_test;
            4'b1111: signal_test = PE_33_signal_test;
        endcase
    end

endmodule