module gw_gao(
    \color[3] ,
    \color[2] ,
    \color[1] ,
    \color[0] ,
    \cnt_h_next[11] ,
    \cnt_h_next[10] ,
    \cnt_h_next[9] ,
    \cnt_h_next[8] ,
    \cnt_h_next[7] ,
    \cnt_h_next[6] ,
    \cnt_h_next[5] ,
    \cnt_h_next[4] ,
    \cnt_h_next[3] ,
    \cnt_h_next[2] ,
    \cnt_h_next[1] ,
    \cnt_h_next[0] ,
    \cnt_v_next[11] ,
    \cnt_v_next[10] ,
    \cnt_v_next[9] ,
    \cnt_v_next[8] ,
    \cnt_v_next[7] ,
    \cnt_v_next[6] ,
    \cnt_v_next[5] ,
    \cnt_v_next[4] ,
    \cnt_v_next[3] ,
    \cnt_v_next[2] ,
    \cnt_v_next[1] ,
    \cnt_v_next[0] ,
    \rgb_next[23] ,
    \rgb_next[22] ,
    \rgb_next[21] ,
    \rgb_next[20] ,
    \rgb_next[19] ,
    \rgb_next[18] ,
    \rgb_next[17] ,
    \rgb_next[16] ,
    \rgb_next[15] ,
    \rgb_next[14] ,
    \rgb_next[13] ,
    \rgb_next[12] ,
    \rgb_next[11] ,
    \rgb_next[10] ,
    \rgb_next[9] ,
    \rgb_next[8] ,
    \rgb_next[7] ,
    \rgb_next[6] ,
    \rgb_next[5] ,
    \rgb_next[4] ,
    \rgb_next[3] ,
    \rgb_next[2] ,
    \rgb_next[1] ,
    \rgb_next[0] ,
    clk_pixel,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \color[3] ;
input \color[2] ;
input \color[1] ;
input \color[0] ;
input \cnt_h_next[11] ;
input \cnt_h_next[10] ;
input \cnt_h_next[9] ;
input \cnt_h_next[8] ;
input \cnt_h_next[7] ;
input \cnt_h_next[6] ;
input \cnt_h_next[5] ;
input \cnt_h_next[4] ;
input \cnt_h_next[3] ;
input \cnt_h_next[2] ;
input \cnt_h_next[1] ;
input \cnt_h_next[0] ;
input \cnt_v_next[11] ;
input \cnt_v_next[10] ;
input \cnt_v_next[9] ;
input \cnt_v_next[8] ;
input \cnt_v_next[7] ;
input \cnt_v_next[6] ;
input \cnt_v_next[5] ;
input \cnt_v_next[4] ;
input \cnt_v_next[3] ;
input \cnt_v_next[2] ;
input \cnt_v_next[1] ;
input \cnt_v_next[0] ;
input \rgb_next[23] ;
input \rgb_next[22] ;
input \rgb_next[21] ;
input \rgb_next[20] ;
input \rgb_next[19] ;
input \rgb_next[18] ;
input \rgb_next[17] ;
input \rgb_next[16] ;
input \rgb_next[15] ;
input \rgb_next[14] ;
input \rgb_next[13] ;
input \rgb_next[12] ;
input \rgb_next[11] ;
input \rgb_next[10] ;
input \rgb_next[9] ;
input \rgb_next[8] ;
input \rgb_next[7] ;
input \rgb_next[6] ;
input \rgb_next[5] ;
input \rgb_next[4] ;
input \rgb_next[3] ;
input \rgb_next[2] ;
input \rgb_next[1] ;
input \rgb_next[0] ;
input clk_pixel;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \color[3] ;
wire \color[2] ;
wire \color[1] ;
wire \color[0] ;
wire \cnt_h_next[11] ;
wire \cnt_h_next[10] ;
wire \cnt_h_next[9] ;
wire \cnt_h_next[8] ;
wire \cnt_h_next[7] ;
wire \cnt_h_next[6] ;
wire \cnt_h_next[5] ;
wire \cnt_h_next[4] ;
wire \cnt_h_next[3] ;
wire \cnt_h_next[2] ;
wire \cnt_h_next[1] ;
wire \cnt_h_next[0] ;
wire \cnt_v_next[11] ;
wire \cnt_v_next[10] ;
wire \cnt_v_next[9] ;
wire \cnt_v_next[8] ;
wire \cnt_v_next[7] ;
wire \cnt_v_next[6] ;
wire \cnt_v_next[5] ;
wire \cnt_v_next[4] ;
wire \cnt_v_next[3] ;
wire \cnt_v_next[2] ;
wire \cnt_v_next[1] ;
wire \cnt_v_next[0] ;
wire \rgb_next[23] ;
wire \rgb_next[22] ;
wire \rgb_next[21] ;
wire \rgb_next[20] ;
wire \rgb_next[19] ;
wire \rgb_next[18] ;
wire \rgb_next[17] ;
wire \rgb_next[16] ;
wire \rgb_next[15] ;
wire \rgb_next[14] ;
wire \rgb_next[13] ;
wire \rgb_next[12] ;
wire \rgb_next[11] ;
wire \rgb_next[10] ;
wire \rgb_next[9] ;
wire \rgb_next[8] ;
wire \rgb_next[7] ;
wire \rgb_next[6] ;
wire \rgb_next[5] ;
wire \rgb_next[4] ;
wire \rgb_next[3] ;
wire \rgb_next[2] ;
wire \rgb_next[1] ;
wire \rgb_next[0] ;
wire clk_pixel;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i({\color[3] ,\color[2] ,\color[1] ,\color[0] }),
    .data_i({\color[3] ,\color[2] ,\color[1] ,\color[0] ,\cnt_h_next[11] ,\cnt_h_next[10] ,\cnt_h_next[9] ,\cnt_h_next[8] ,\cnt_h_next[7] ,\cnt_h_next[6] ,\cnt_h_next[5] ,\cnt_h_next[4] ,\cnt_h_next[3] ,\cnt_h_next[2] ,\cnt_h_next[1] ,\cnt_h_next[0] ,\cnt_v_next[11] ,\cnt_v_next[10] ,\cnt_v_next[9] ,\cnt_v_next[8] ,\cnt_v_next[7] ,\cnt_v_next[6] ,\cnt_v_next[5] ,\cnt_v_next[4] ,\cnt_v_next[3] ,\cnt_v_next[2] ,\cnt_v_next[1] ,\cnt_v_next[0] ,\rgb_next[23] ,\rgb_next[22] ,\rgb_next[21] ,\rgb_next[20] ,\rgb_next[19] ,\rgb_next[18] ,\rgb_next[17] ,\rgb_next[16] ,\rgb_next[15] ,\rgb_next[14] ,\rgb_next[13] ,\rgb_next[12] ,\rgb_next[11] ,\rgb_next[10] ,\rgb_next[9] ,\rgb_next[8] ,\rgb_next[7] ,\rgb_next[6] ,\rgb_next[5] ,\rgb_next[4] ,\rgb_next[3] ,\rgb_next[2] ,\rgb_next[1] ,\rgb_next[0] }),
    .clk_i(clk_pixel)
);

endmodule
