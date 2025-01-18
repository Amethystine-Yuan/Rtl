module clkgen(
    input wire rst_n, 
    input wire scan_clk_start,
    input wire [3:0] scan_tap_sel_coarse, 
    input wire [3:0] scan_tap_sel_fine,
    input wire [3:0] scan_div_sel,
    input wire scan_ext_sel, 
    input wire clk_ext,

    input wire [3:0] div1,
    input wire [3:0] div2,
    input wire [3:0] div3,
    input wire [3:0] div4,
    input wire [3:0] div5,
    input wire [3:0] div6,
    input wire [3:0] div7,
    input wire [3:0] div8,
    input wire [3:0] div9,
    input wire [3:0] div10,
    input wire [3:0] div11,
    input wire [3:0] div12,
    input wire [3:0] div13,
    input wire [3:0] div14,
    input wire [3:0] div15,
    input wire [3:0] div16,
    // input wire [3:0] div_global,
    // input wire [7:0] scan_clk_sel,
    input wire [3:0] scan_clk_sel,
    input wire [7:0] scan_phase_test_sel,

    input wire [7:0] phase_sel1,
    input wire [7:0] phase_sel2,
    input wire [7:0] phase_sel3,
    input wire [7:0] phase_sel4,
    input wire [7:0] phase_sel5,
    input wire [7:0] phase_sel6,
    input wire [7:0] phase_sel7,
    input wire [7:0] phase_sel8,
    input wire [7:0] phase_sel9,
    input wire [7:0] phase_sel10,
    input wire [7:0] phase_sel11,
    input wire [7:0] phase_sel12,
    input wire [7:0] phase_sel13,
    input wire [7:0] phase_sel14,
    input wire [7:0] phase_sel15,
    input wire [7:0] phase_sel16,

	output wire clk_out1,
    output wire clk_out2,
    output wire clk_out3,
    output wire clk_out4,
    output wire clk_out5,
    output wire clk_out6,
    output wire clk_out7,
    output wire clk_out8,
    output wire clk_out9,
    output wire clk_out10,
    output wire clk_out11,
    output wire clk_out12,
    output wire clk_out13,
    output wire clk_out14,
    output wire clk_out15,
    output wire clk_out16,
    // output wire clk_out_global,
    output clk_ring_oscillator,
    output wire clk_verify1,
    // output wire clk_verify2,
    // output wire clk_verify_global,
    output wire clk_verify_div,

    output wire [15:0] phase_re1,
    output wire [15:0] phase_re2
);

    // wire clk_ring_oscillator;
    // wire clk_out_global;
    wire clk_tmp_verify1;
    wire clk_phase_verify1;
    wire clk_phase_verify2;

    CG_Normal CG_Normal(
        .resetn(rst_n), 
        .scan_clk_start(scan_clk_start), 
	    .scan_tap_sel_coarse(scan_tap_sel_coarse), 
        .scan_tap_sel_fine(scan_tap_sel_fine), 
	    .scan_div_sel(scan_div_sel),
	    .scan_ext_sel(scan_ext_sel), 
        .clk_ext(clk_ext),	
	    .clk(clk_ring_oscillator), 
        .clk_verify_div(clk_verify_div)
    );

    Freq_div_all Freq_div_all(
        .clk(clk_ring_oscillator),
	    .div1(div1),
        .div2(div2),
        .div3(div3),
        .div4(div4),
        .div5(div5),
        .div6(div6),
        .div7(div7),
        .div8(div8),
        .div9(div9),
        .div10(div10),
        .div11(div11),
        .div12(div12),
        .div13(div13),
        .div14(div14),
        .div15(div15),
        .div16(div16),
        // .div_global(div_global),
        .clk_sel(scan_clk_sel),
        .phase_test_sel(scan_phase_test_sel),
	    .rst_n(rst_n),
        .phase_sel1(phase_sel1),
        .phase_sel2(phase_sel2),
        .phase_sel3(phase_sel3),
        .phase_sel4(phase_sel4),
        .phase_sel5(phase_sel5),
        .phase_sel6(phase_sel6),
        .phase_sel7(phase_sel7),
        .phase_sel8(phase_sel8),
        .phase_sel9(phase_sel9),
        .phase_sel10(phase_sel10),
        .phase_sel11(phase_sel11),
        .phase_sel12(phase_sel12),
        .phase_sel13(phase_sel13),
        .phase_sel14(phase_sel14),
        .phase_sel15(phase_sel15),
        .phase_sel16(phase_sel16),
   
	    .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .clk_out4(clk_out4),
        .clk_out5(clk_out5),
        .clk_out6(clk_out6),
        .clk_out7(clk_out7),
        .clk_out8(clk_out8),
        .clk_out9(clk_out9),
        .clk_out10(clk_out10),
        .clk_out11(clk_out11),
        .clk_out12(clk_out12),
        .clk_out13(clk_out13),
        .clk_out14(clk_out14),
        .clk_out15(clk_out15),
        .clk_out16(clk_out16),
        // .clk_out_global(clk_out_global),
        .clk_verify1(clk_tmp_verify1),
        // .clk_verify2(clk_tmp_verify2)

        .clk_phase_verify1(clk_phase_verify1),
        .clk_phase_verify2(clk_phase_verify2)
    );

    phase_test phase_test(
        .clk_slow1(clk_phase_verify1),
        .clk_slow2(clk_phase_verify2),
        .clk_fast(clk_ring_oscillator),
        .rst_n(rst_n),
        .phase_re1(phase_re1),
        .phase_re2(phase_re2)


    );

    clk_verify clk_verify_out1(
        .clk(clk_tmp_verify1),
        .rst_n(rst_n),
        .clk_verify_div(clk_verify1)
    );

    // clk_verify clk_verify_out2(
    //     .clk(clk_tmp_verify2),
    //     .rst_n(rst_n),
    //     .clk_verify_div(clk_verify2)
    // );

    // clk_verify clk_verify_out_global(
    //     .clk(clk_ring_oscillator),
    //     .rst_n(rst_n),
    //     .clk_verify_div(clk_verify_global)
    // );


    // Phase_Tuning Phase_Tuning1(
    //     .clk(clk_tmp1),
    //     .clk_out(clk_out1),
    //     .phase_sel(phase_sel1)
    // );

    // Phase_Tuning Phase_Tuning2(
    //     .clk(clk_tmp2),
    //     .clk_out(clk_out2),
    //     .phase_sel(phase_sel2)
    // );


    // Phase_Tuning Phase_Tuning3(
    //     .clk(clk_tmp3),
    //     .clk_out(clk_out3),
    //     .phase_sel(phase_sel3)
    // );


    // Phase_Tuning Phase_Tuning4(
    //     .clk(clk_tmp4),
    //     .clk_out(clk_out4),
    //     .phase_sel(phase_sel4)
    // );


    // Phase_Tuning Phase_Tuning5(
    //     .clk(clk_tmp5),
    //     .clk_out(clk_out5),
    //     .phase_sel(phase_sel5)
    // );

    // Phase_Tuning Phase_Tuning6(
    //     .clk(clk_tmp6),
    //     .clk_out(clk_out6),
    //     .phase_sel(phase_sel6)
    // );

    // Phase_Tuning Phase_Tuning7(
    //     .clk(clk_tmp7),
    //     .clk_out(clk_out7),
    //     .phase_sel(phase_sel7)
    // );

    // Phase_Tuning Phase_Tuning8(
    //     .clk(clk_tmp8),
    //     .clk_out(clk_out8),
    //     .phase_sel(phase_sel8)
    // );

    // Phase_Tuning Phase_Tuning9(
    //     .clk(clk_tmp9),
    //     .clk_out(clk_out9),
    //     .phase_sel(phase_sel9)
    // );

    // Phase_Tuning Phase_Tuning10(
    //     .clk(clk_tmp10),
    //     .clk_out(clk_out10),
    //     .phase_sel(phase_sel10)
    // );

    // Phase_Tuning Phase_Tuning11(
    //     .clk(clk_tmp11),
    //     .clk_out(clk_out11),
    //     .phase_sel(phase_sel11)
    // );

    // Phase_Tuning Phase_Tuning12(
    //     .clk(clk_tmp12),
    //     .clk_out(clk_out12),
    //     .phase_sel(phase_sel12)
    // );

    // Phase_Tuning Phase_Tuning13(
    //     .clk(clk_tmp13),
    //     .clk_out(clk_out13),
    //     .phase_sel(phase_sel13)
    // );

    // Phase_Tuning Phase_Tuning14(
    //     .clk(clk_tmp14),
    //     .clk_out(clk_out14),
    //     .phase_sel(phase_sel14)
    // );

    // Phase_Tuning Phase_Tuning15(
    //     .clk(clk_tmp15),
    //     .clk_out(clk_out15),
    //     .phase_sel(phase_sel15)
    // );

    // Phase_Tuning Phase_Tuning16(
    //     .clk(clk_tmp16),
    //     .clk_out(clk_out16),
    //     .phase_sel(phase_sel16)
    // );

endmodule