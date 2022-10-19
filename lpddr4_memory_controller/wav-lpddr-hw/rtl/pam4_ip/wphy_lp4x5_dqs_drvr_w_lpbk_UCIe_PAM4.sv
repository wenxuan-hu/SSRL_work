module wphy_lp4x5_dqs_drvr_w_lpbk_UCIe_PAM4 ( dqs_rx_in_c, dqs_rx_in_t,
     lpbk_out_c, lpbk_out_t, pad_c, pad_t, vdda, vddq, vss,
     UCIe_ODT_en, UCIen, d_bs_din_c, d_bs_din_t, d_bs_ena,
     d_drv_impd, d_in_c, d_lpbk_ena,
     d_ncal, d_ovrd, d_ovrd_val_c,
     d_ovrd_val_t, d_pcal, d_se_mode, freeze_n, highz_n );

output  dqs_rx_in_c, dqs_rx_in_t, lpbk_out_c, lpbk_out_t;

inout  pad_c, pad_t, vdda, vddq, vss;

input  UCIen, d_bs_din_c, d_bs_din_t, d_bs_ena, d_in_c, d_lpbk_ena,
     d_ovrd_val_c, d_ovrd_val_t, d_se_mode, freeze_n, highz_n;

input [5:0]  d_pcal;
input [4:0]  d_ncal;
input [2:0]  d_drv_impd;
input [2:0]  d_ovrd;
input [1:0]  UCIe_ODT_en;
wire  [2:0]  ovrd_buf;

wire  [2:0]  ovrd_b;

wire  [0:1]  net8;

wire  [2:0]  ovrd_n_b;

wire  [2:0]  ovrd_p_b;

wire  [2:0]  impd;

wire  [2:0]  net038;

wire  [2:0]  impd_b;

wire  [2:0]  ovrd_c_b;

wire  [1:0]  ODT_en;

wire  [2:0]  ovrd_n_c_b;

wire  [2:0]  net061;

wire  [2:0]  impd_b_frz;

wire  [2:0]  ovrd_b_frz;

wire  [2:0]  ovrd_c;

wire  [2:0]  ovrd_p_c_b;
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_UCIe_PAM4 I46 ( pad_t, vss, ODT_en[1], ODT_en[0], UCIE_en, impd[2],
     impd[1], impd[0], impd_b[2:0], in_t_lvl, in_t_lvl, d_ncal[4:0],
     ovrd_buf[2:0], ovrd_b[2:0], ovrd_n_b[2:0], ovrd_p_b[2:0], net053,
     d_pcal[5:0], vddq, vss);
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_UCIe_PAM4 I0 ( pad_c, vss, ODT_en[1], ODT_en[0], UCIE_en, impd[2],
     impd[1], impd[0], impd_b[2:0], in_c_lvl, in_c_lvl, d_ncal[4:0],
     ovrd_c[2:0], ovrd_c_b[2:0], ovrd_n_c_b[2:0], ovrd_p_c_b[2:0],
     net041, d_pcal[5:0], vddq, vss);
ND2D1BWP30P140  I104 ( .A2(freeze_n_vq), .A1(UCIen), .VDD(vddq),
     .VSS(vss), .ZN(net9));
ND2D1BWP30P140  I99 ( .A2(highz_n), .A1(freeze_n), .VDD(vddq),
     .VSS(vss), .ZN(net6));
ND2D1BWP30P140  I91[2:0] ( .ZN(ovrd_p_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_val_b), .A2(ovrd_buf[2:0]));
ND2D1BWP30P140  I89 ( .A2(d_ovrd_val_t), .A1(freeze_n_vq), .VDD(vddq),
     .VSS(vss), .ZN(net054));
ND2D1BWP30P140  I77 ( .A2(d_bs_din_t), .A1(net2), .VDD(vddq),
     .VSS(vss), .ZN(net029));
ND2D1BWP30P140  I81 ( .A2(d_ovrd_val_c), .A1(freeze_n_vq), .VDD(vddq),
     .VSS(vss), .ZN(net018));
ND2D1BWP30P140  I52[1:0] ( .ZN(impd_b_frz[2:1]), .VDD(vddq), .VSS(vss),
     .A1(freeze_n_vq), .A2(d_drv_impd[2:1]));
ND2D1BWP30P140  I48 ( .A2(net2), .A1(d_bs_ena), .VDD(vddq), .VSS(vss),
     .ZN(bs_enb_vq));
ND2D1BWP30P140  I80[1:0] ( .ZN(ovrd_b_frz[2:1]), .VDD(vddq), .VSS(vss),
     .A1(freeze_n_vq), .A2(d_ovrd[2:1]));
ND2D1BWP30P140  I90[2:0] ( .ZN(ovrd_p_c_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_c_val_b), .A2(ovrd_c[2:0]));
ND2D1BWP30P140  I74 ( .A2(d_bs_din_c), .A1(net2), .VDD(vddq),
     .VSS(vss), .ZN(net028));
LVLHLD2BWP30P140  I8 ( .I(in_t), .Z(in_t_lvl), .VDD(vddq), .VSS(vss));
LVLHLD2BWP30P140  I73 ( .I(in_c), .Z(in_c_lvl), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I84 ( .I(net041), .ZN(ovrd_c_val_b), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I83[2:0] ( .ZN(ovrd_c[2:0]), .VDD(vddq), .VSS(vss),
     .I(ovrd_c_b[2:0]));
INVD4BWP30P140  I85[2:0] ( .ZN(ovrd_b[2:0]), .VDD(vddq), .VSS(vss),
     .I(net038[2:0]));
INVD4BWP30P140  I76 ( .I(net028), .ZN(net1), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I87 ( .I(net053), .ZN(ovrd_val_b), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I78 ( .I(net029), .ZN(net3), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I44 ( .I(net2), .ZN(freeze_vq), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I86[2:0] ( .ZN(ovrd_buf[2:0]), .VDD(vddq), .VSS(vss),
     .I(ovrd_b[2:0]));
INVD4BWP30P140  I98 ( .I(net6), .ZN(net2), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I75 ( .I(bs_enb_vq), .ZN(bs_ena_vq), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I41[2:0] ( .ZN(impd_b[2:0]), .VDD(vddq), .VSS(vss),
     .I(net061[2:0]));
INVD4BWP30P140  I34 ( .I(freeze_vq), .ZN(freeze_n_vq), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I100 ( .I(highz_n), .ZN(net5), .VDD(vddq), .VSS(vss));
NR2D1BWP30P140  I101 ( .A2(net5), .A1(net4), .VDD(vddq), .ZN(net7),
     .VSS(vss));
NR2D1BWP30P140  I94 ( .A2(d_se_mode), .A1(net018), .VDD(vddq),
     .ZN(net041), .VSS(vss));
NR2D1BWP30P140  I95[2:0] ( .ZN(ovrd_n_c_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_c_val_b), .A2(ovrd_c_b[2:0]));
NR2D1BWP30P140  I92[2:0] ( .ZN(ovrd_n_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_val_b), .A2(ovrd_b[2:0]));
NR2D1BWP30P140  I93[2:0] ( .ZN(ovrd_c_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(d_se_mode), .A2(net038[2:0]));
NR2D1BWP30P140  I51 ( .A2(d_ovrd[0]), .A1(freeze_vq), .VDD(vddq),
     .ZN(ovrd_b_frz[0]), .VSS(vss));
NR2D1BWP30P140  I96 ( .A2(d_drv_impd[0]), .A1(freeze_vq), .VDD(vddq),
     .ZN(net4), .VSS(vss));
//PDB3AC_H_G  I106 ( .TACVDD(vddq), .TACVSS(vss), .VSS(vss),
     //.AIO(pad_t));
//PDB3AC_H_G  I107 ( .TACVDD(vddq), .TACVSS(vss), .VSS(vss),
     //.AIO(pad_c));
INVD1BWP30P140  I103[1:0] ( .ZN(net8[0:1]), .VDD(vddq), .VSS(vss),
     .I(UCIe_ODT_en[1:0]));
INVD1BWP30P140  I60 ( .I(net9), .ZN(UCIE_en), .VDD(vddq), .VSS(vss));
INVD1BWP30P140  I105[1:0] ( .ZN(ODT_en[1:0]), .VDD(vddq), .VSS(vss),
     .I(net8[0:1]));
wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT I2 ( .vdd(vdda),
     .vss(vss), .outn(in_t), .outp(in_c), .in(d_in_c), .tiehi(vdda),
     .tielo(vss));
wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm I42 ( .vdd(vddq), .vss(vss),
     .out(dqs_rx_in_t), .pad(pad_t));
wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm I1 ( .vdd(vddq), .vss(vss),
     .out(dqs_rx_in_c), .pad(pad_c));
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va I39 ( .vdda(vdda),
     .vddq(vddq), .vss(vss), .out(lpbk_out_t), .outb(net022),
     .d_ena(d_lpbk_ena), .freeze_n(net2), .in_vq(dqs_rx_in_t));
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va I3 ( .vdda(vdda),
     .vddq(vddq), .vss(vss), .out(lpbk_out_c), .outb(net023),
     .d_ena(d_lpbk_ena), .freeze_n(net2), .in_vq(dqs_rx_in_c));
BUFTD4BWP30P140  I79 ( .OE(bs_ena_vq), .I(net3), .Z(pad_t), .VDD(vddq),
     .VSS(vss));
BUFTD4BWP30P140  I55 ( .OE(bs_ena_vq), .I(net1), .Z(pad_c), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140  I102 ( .I(net7), .ZN(impd_b_frz[0]), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140  I88 ( .I(net054), .ZN(net053), .VDD(vddq), .VSS(vss));
INVD2BWP30P140  I37[2:0] ( .ZN(net038[2:0]), .VDD(vddq), .VSS(vss),
     .I(ovrd_b_frz[2:0]));
INVD2BWP30P140  I40[2:0] ( .ZN(net061[2:0]), .VDD(vddq), .VSS(vss),
     .I(impd_b_frz[2:0]));
INVD8BWP30P140  I82[2:0] ( .ZN(impd[2:0]), .VDD(vddq), .VSS(vss),
     .I(impd_b[2:0]));

endmodule

