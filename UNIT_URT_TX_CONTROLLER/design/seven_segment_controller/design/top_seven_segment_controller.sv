




module top_seven_segment_controller(
    input system_clock, //
    input clock_enable,
    input cpu_rst_n,//
    input [31:0] value2disp,//
    output [6:0] cathodes_out, //
    output [7:0] anode_out
//    ,output clk_32 //// for simulation only!
);

wire [2:0] anode_sel;
wire [3:0] mux_to_dec;


// ---------------------------------
rotate_register rot_reg_inst(
    .clk(system_clock),
    .CE(clock_enable),
    .reset_n(cpu_rst_n),
    .parallel_out(anode_out)
);

// ---------------hexa 
anode_decoder anode_dec_inst(
    .anode_in(anode_out),
    .anode_sel(anode_sel)
);

mux4x1 mux_inst(
    .in0(value2disp[31:28]),
    .in1(value2disp[27:24]),
    .in2(value2disp[23:20]),
    .in3(value2disp[19:16]),
    .in4(value2disp[15:12]),
    .in5(value2disp[11:8]),
    .in6(value2disp[7:4]),
    .in7(value2disp[3:0]),
    .sel(anode_sel),
    .mux_out(mux_to_dec)
);

decoder_bin2hex dec_inst(
    .bin_in_hex(mux_to_dec),
    .decoded(cathodes_out)
);


endmodule