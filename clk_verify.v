module clk_verify(
    
    input clk,
    input rst_n,
    output wire clk_verify_div
);

//*observing point (11 divider / 2048)
DFCNQD1BWP30P140ULVT XOBS00 (.CP(clk), .D(clk_out_div_0_b), .Q(clk_out_div_0), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS01 (.CP(clk_out_div_0), .D(clk_out_div_1_b), .Q(clk_out_div_1), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS02 (.CP(clk_out_div_1), .D(clk_out_div_2_b), .Q(clk_out_div_2), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS03 (.CP(clk_out_div_2), .D(clk_out_div_3_b), .Q(clk_out_div_3), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS04 (.CP(clk_out_div_3), .D(clk_out_div_4_b), .Q(clk_out_div_4), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS05 (.CP(clk_out_div_4), .D(clk_out_div_5_b), .Q(clk_out_div_5), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS06 (.CP(clk_out_div_5), .D(clk_out_div_6_b), .Q(clk_out_div_6), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS07 (.CP(clk_out_div_6), .D(clk_out_div_7_b), .Q(clk_out_div_7), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS08 (.CP(clk_out_div_7), .D(clk_out_div_8_b), .Q(clk_out_div_8), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS09 (.CP(clk_out_div_8), .D(clk_out_div_9_b), .Q(clk_out_div_9), .CDN(rst_n)  );
DFCNQD1BWP30P140ULVT XOBS10 (.CP(clk_out_div_9), .D(clk_out_div_10_b), .Q(clk_out_div_10), .CDN(rst_n)  );
// DFCNQD1BWP30P140ULVT XOBS11 (.CP(clk_out_div_10), .D(clk_out_div_11_b), .Q(clk_out_div_11), .CDN(rst_n)  );
// DFCNQD1BWP30P140ULVT XOBS12 (.CP(clk_out_div_11), .D(clk_out_div_12_b), .Q(clk_out_div_12), .CDN(rst_n)  );

CKND0BWP30P140ULVT XOBI00 (.I(clk_out_div_0), .ZN(clk_out_div_0_b)  );
CKND0BWP30P140ULVT XOBI01 (.I(clk_out_div_1), .ZN(clk_out_div_1_b)  );
CKND0BWP30P140ULVT XOBI02 (.I(clk_out_div_2), .ZN(clk_out_div_2_b)  );
CKND0BWP30P140ULVT XOBI03 (.I(clk_out_div_3), .ZN(clk_out_div_3_b)  );
CKND0BWP30P140ULVT XOBI04 (.I(clk_out_div_4), .ZN(clk_out_div_4_b)  );
CKND0BWP30P140ULVT XOBI05 (.I(clk_out_div_5), .ZN(clk_out_div_5_b)  );
CKND0BWP30P140ULVT XOBI06 (.I(clk_out_div_6), .ZN(clk_out_div_6_b)  );
CKND0BWP30P140ULVT XOBI07 (.I(clk_out_div_7), .ZN(clk_out_div_7_b)  );
CKND0BWP30P140ULVT XOBI08 (.I(clk_out_div_8), .ZN(clk_out_div_8_b)  );
CKND0BWP30P140ULVT XOBI09 (.I(clk_out_div_9), .ZN(clk_out_div_9_b)  );
CKND0BWP30P140ULVT XOBI10 (.I(clk_out_div_10), .ZN(clk_out_div_10_b)  );
// CKND0BWP30P140ULVT XOBI11 (.I(clk_out_div_11), .ZN(clk_out_div_11_b)  );
// CKND0BWP30P140ULVT XOBI12 (.I(clk_out_div_12), .ZN(clk_out_div_12_b)  );

CKND0BWP30P140ULVT XOBSB0 (.I(clk_out_div_10 ), .ZN(clk_out_div_buf_1)  );
CKND2BWP30P140ULVT XOBSB1 (.I(clk_out_div_buf_1), .ZN(clk_out_div_buf_2)  );
CKND4BWP30P140ULVT XOBSB2 (.I(clk_out_div_buf_2), .ZN(clk_out_div_buf_3)  );
CKND8BWP30P140ULVT XOBSB3 (.I(clk_out_div_buf_3), .ZN(clk_out_div_buf_4)  );
CKND16BWP30P140ULVT XOBSB4 (.I(clk_out_div_buf_4), .ZN(clk_out_div_buf_5)  );
CKND20BWP30P140ULVT XOBSB5 (.I(clk_out_div_buf_5), .ZN(clk_verify_div)  );
// CKND20BWP30P140ULVT XOBSB5 (.I(clk_out_div_buf_5), .ZN(clk_out_div_buf_6)  );
// CKND24BWP30P140ULVT XOBSB6 (.I(clk_out_div_buf_6), .ZN(clk_out_div_buf_7)  );
// CKND24BWP30P140ULVT XOBSB7 (.I(clk_out_div_buf_7), .ZN(clk_verify_div)  );


endmodule