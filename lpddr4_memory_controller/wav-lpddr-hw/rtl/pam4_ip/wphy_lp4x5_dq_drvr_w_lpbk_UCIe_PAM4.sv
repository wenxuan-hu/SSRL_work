// Verilog HDL and netlist files of
// "LPDDR4_T28HPC wphy_lp4x5_dq_drvr_w_lpbk_UCIe_PAM4 schematic"


// alias module. For internal use only.

// Netlisted models

// Library - tsmcN28, Cell - tri_lvt_mac, View - schematic
// NETLIST TIME: Aug 17 20:20:07 2022


module tri_lvt_mac_pcell_0( A ,EN ,ENB ,G ,Gb ,P ,Pb ,Y );
`ifdef ODT_SYSTEMVERILOG_TS
  timeunit 1ps;
  timeprecision 100fs;
`endif
input A;
input EN;
input ENB;
input G;
input Gb;
input P;
input Pb;
output Y;
reg BY_0;
reg out_Y_logic;
initial begin
  end
initial begin
   BY_0=0;
  end
 always @( A   or EN   or ENB  ) begin
         BY_0 = (!A && !ENB);
  out_Y_logic = BY_0;
 end
 assign (supply1, weak0) Y = out_Y_logic;
endmodule



/*


`timescale 1ns / 1ns 

module tri_lvt_mac_pcell_0 ( Y, A, EN, ENB, G, Gb, P, Pb );

output  Y;

input  A, EN, ENB, G, Gb, P, Pb;


specify 
    specparam CDS_LIBNAME  = "tsmcN28";
    specparam CDS_CELLNAME = "tri_lvt_mac";
    specparam CDS_VIEWNAME = "schematic";
endspecify

pch_lvt_mac  M2 ( .B(Pb), .S(Con1), .G(ENB), .D(Y));
pch_lvt_mac  M1 ( .B(Pb), .D(Con1), .G(A), .S(P));
nch_lvt_mac  M4 ( .B(Gb), .D(Con2), .G(A), .S(G));
nch_lvt_mac  M3 ( .B(Gb), .S(Con2), .G(EN), .D(Y));

endmodule
*/



// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va, View - schematic
// LAST TIME SAVED: May 12 20:56:24 2022
// NETLIST TIME: Aug 17 20:20:07 2022
/*
`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va ( out, outb,
     vdda, vddq, vss, d_ena, freeze_n, in_vq );

output  out, outb;

inout  vdda, vddq, vss;

input  d_ena, freeze_n, in_vq;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va";
    specparam CDS_VIEWNAME = "schematic";
endspecify

LVLLHD4BWP30P140  I4 ( .VDD(vdda), .I(net2), .VSS(vss), .Z(out),
     .VDDL(vddq));
INVD4BWP30P140  I12 ( .I(enb), .ZN(ena), .VDD(vdda), .VSS(vss));
INVD4BWP30P140  I11 ( .I(d_ena), .ZN(enb), .VDD(vdda), .VSS(vss));
INVD4BWP30P140  I2 ( .I(out), .ZN(outb), .VDD(vdda), .VSS(vss));
ND2D4BWP30P140LVT  I9 ( .A2(net1), .A1(freeze_n), .VDD(vddq),
     .VSS(vss), .ZN(net2));
tri_lvt_mac_pcell_0 I62 ( net1, in_vq, ena, enb, vss, vss, vddq, vddq);
pch_lvt_mac  M0 ( .D(net1), .G(ena), .B(vddq), .S(vddq));

endmodule
*/

// Library - LPDDR4_T28HPC, Cell - wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm,
//View - schematic
// LAST TIME SAVED: Jul 31 04:23:45 2022
// NETLIST TIME: Aug 17 20:20:07 2022
/*
`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm ( out, vdd, vss, pad );

output  out;

inout  vdd, vss;

input  pad;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME = "wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm";
    specparam CDS_VIEWNAME = "schematic";
endspecify

rupolym  R2 ( .PLUS(net1), .MINUS(vss));
rupolym  R3 ( .PLUS(out), .MINUS(pad));
rupolym  R0 ( .PLUS(out), .MINUS(pad));
nch_18_mac  M1 ( .G(net1), .D(out), .S(vss), .B(vss));

endmodule
// Library - tsmcN28, Cell - tri_mac, View - schematic
// NETLIST TIME: Aug 17 20:20:07 2022
*/
/*
`timescale 1ns / 1ns 

module tri_mac_pcell_1 ( Y, A, EN, ENB, G, Gb, P, Pb );

output  Y;

input  A, EN, ENB, G, Gb, P, Pb;


specify 
    specparam CDS_LIBNAME  = "tsmcN28";
    specparam CDS_CELLNAME = "tri_mac";
    specparam CDS_VIEWNAME = "schematic";
endspecify

pch_mac  M2 ( .B(Pb), .S(Con1), .G(ENB), .D(Y));
pch_mac  M1 ( .B(Pb), .D(Con1), .G(A), .S(P));
nch_mac  M4 ( .B(Gb), .D(Con2), .G(A), .S(G));
nch_mac  M3 ( .B(Gb), .S(Con2), .G(EN), .D(Y));

endmodule
*/

module tri_mac_pcell_1( A ,EN ,ENB ,G ,Gb ,P ,Pb ,Y );
`ifdef ODT_SYSTEMVERILOG_TS
  timeunit 1ps;
  timeprecision 100fs;
`endif
input A;
input EN;
input ENB;
input G;
input Gb;
input P;
input Pb;
output Y;
reg BY_0;
reg out_Y_logic;
initial begin
  end
initial begin
   BY_0=0;
  end
 always @( A   or EN   or ENB  ) begin
         BY_0 = (!A && !ENB);
  out_Y_logic = BY_0;
 end
 assign (supply1, weak0) Y = out_Y_logic;
endmodule


// Library - tsmcN28, Cell - trans_mac, View - schematic
// NETLIST TIME: Aug 17 20:20:07 2022
/*`timescale 1ns / 1ns 

module trans_mac_pcell_2 ( Y, A, C, CB, Gb, Pb );

output  Y;

input  A, C, CB, Gb, Pb;


specify 
    specparam CDS_LIBNAME  = "tsmcN28";
    specparam CDS_CELLNAME = "trans_mac";
    specparam CDS_VIEWNAME = "schematic";
endspecify

pch_mac  M1 ( .B(Pb), .G(CB), .D(A), .S(Y));
nch_mac  M2 ( .B(Gb), .G(C), .D(A), .S(Y));

endmodule*/
// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT, View - schematic
// LAST TIME SAVED: Dec  6 23:45:47 2021
// NETLIST TIME: Aug 17 20:20:07 2022
/*
`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT ( outn, outp, vdd,
     vss, in, tiehi, tielo );

output  outn, outp;

inout  vdd, vss;

input  in, tiehi, tielo;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT";
    specparam CDS_VIEWNAME = "schematic";
endspecify

tri_mac_pcell_1 I15 ( outn, outp, tiehi, tielo, vss, vss, vdd, vdd);
tri_mac_pcell_1 I16 ( n1, p1, tiehi, tielo, vss, vss, vdd, vdd);
tri_mac_pcell_1 I17 ( outp, outn, tiehi, tielo, vss, vss, vdd, vdd);
tri_mac_pcell_1 I14 ( p1, n1, tiehi, tielo, vss, vss, vdd, vdd);
trans_mac_pcell_2 I18[4:0] ( n1, inb, tiehi, tielo, vss, vdd);
INVD2BWP30P140  I12 ( .I(inb), .ZN(p1), .VDD(vdd), .VSS(vss));
INVD2BWP30P140  I9[1:0] ( .ZN(outn), .VDD(vdd), .VSS(vss), .I(p1));
INVD2BWP30P140  I10[1:0] ( .ZN(outp), .VDD(vdd), .VSS(vss), .I(n1));
INVD2BWP30P140  I11[1:0] ( .ZN(inb), .VDD(vdd), .VSS(vss), .I(in));
nch_mac  M4 ( .G(tielo), .D(inb), .S(vss), .B(vss));
nch_mac  M0 ( .G(tielo), .D(n1), .S(vss), .B(vss));
pch_mac  M5 ( .D(inb), .G(tiehi), .B(vdd), .S(vdd));
pch_mac  M1 ( .D(n1), .G(tiehi), .B(vdd), .S(vdd));

endmodule
*/
// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_predrv, View - schematic
// LAST TIME SAVED: Dec  7 18:49:07 2021
// NETLIST TIME: Aug 17 20:20:07 2022
/*`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_predrv ( out, vdd, vss, en,
     enb, in, pd, pu );

output  out;

inout  vdd, vss;

input  en, enb, in, pd, pu;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_predrv";
    specparam CDS_VIEWNAME = "schematic";
endspecify

INVD2BWP30P140LVT  I11 ( .I(in), .ZN(net1), .VDD(vdd), .VSS(vss));
pch_lvt_mac  M2 ( .D(out), .G(pu), .B(vdd), .S(vdd));
nch_lvt_mac  M3 ( .G(pd), .D(out), .S(vss), .B(vss));
BUFTD4BWP30P140LVT  I12 ( .OE(en), .I(net1), .Z(out), .VDD(vdd),
     .VSS(vss));

endmodule*/


// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240n,
//View - schematic
// LAST TIME SAVED: Dec 10 01:08:02 2021
// NETLIST TIME: Aug 17 20:20:07 2022

/*`timescale 1ns / 1ns 

module cdsModule_0 ( out, vss, dn_code[4], dn_code[3], dn_code[2],
     dn_code[1], dn_code[0], dn_fix );

output  out;

inout  vss;

input  dn_fix;

input [0:4]  dn_code;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240n";
    specparam CDS_VIEWNAME = "schematic";
endspecify

nch_mac  M4 ( .G(dn_code[3]), .D(net38), .S(vss), .B(vss));
nch_mac  M2 ( .G(dn_code[1]), .D(net40), .S(vss), .B(vss));
nch_mac  M0 ( .G(dn_fix), .D(net42), .S(vss), .B(vss));
nch_mac  M3 ( .G(dn_code[2]), .D(net39), .S(vss), .B(vss));
nch_mac  M1 ( .G(dn_code[0]), .D(net41), .S(vss), .B(vss));
nch_mac  M5 ( .G(dn_code[4]), .D(net37), .S(vss), .B(vss));
rupolym  R5 ( .PLUS(out), .MINUS(net42));
rupolym  R7 ( .PLUS(out), .MINUS(net40));
rupolym  R9 ( .PLUS(out), .MINUS(net38));
rupolym  R10 ( .PLUS(out), .MINUS(net37));
rupolym  R6 ( .PLUS(out), .MINUS(net41));
rupolym  R8 ( .PLUS(out), .MINUS(net39));

endmodule
// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240p,
//View - schematic
// LAST TIME SAVED: Dec 14 04:55:55 2021
// NETLIST TIME: Aug 17 20:20:07 2022
`timescale 1ns / 1ns 

module cdsModule_1 ( out, vddq, vss, up_code[5], up_code[4],
     up_code[3], up_code[2], up_code[1], up_code[0], up_fix );

output  out;

inout  vddq, vss;

input  up_fix;

input [0:5]  up_code;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240p";
    specparam CDS_VIEWNAME = "schematic";
endspecify

rupolym  R7 ( .PLUS(net44), .MINUS(out));
rupolym  R2 ( .PLUS(net49), .MINUS(out));
rupolym  R5 ( .PLUS(net46), .MINUS(out));
rupolym  R6 ( .PLUS(net45), .MINUS(out));
rupolym  R3 ( .PLUS(net48), .MINUS(out));
rupolym  R1 ( .PLUS(net50), .MINUS(out));
rupolym  R4 ( .PLUS(net47), .MINUS(out));
pch_mac  M29 ( .D(net44), .G(up_code[5]), .B(vddq), .S(vddq));
pch_mac  M28 ( .D(net45), .G(up_code[4]), .B(vddq), .S(vddq));
pch_mac  M24 ( .D(net49), .G(up_code[0]), .B(vddq), .S(vddq));
pch_mac  M23 ( .D(net50), .G(up_fix), .B(vddq), .S(vddq));
pch_mac  M27 ( .D(net46), .G(up_code[3]), .B(vddq), .S(vddq));
pch_mac  M25 ( .D(net48), .G(up_code[1]), .B(vddq), .S(vddq));
pch_mac  M26 ( .D(net47), .G(up_code[2]), .B(vddq), .S(vddq));

endmodule
// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240, View - schematic
// LAST TIME SAVED: Aug  4 21:51:41 2022
// NETLIST TIME: Aug 17 20:20:07 2022
*/








`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240 ( drv_out, vddq,
     vss, en_dn, en_up, inb_n, inb_p, ncal, pcal );

output  drv_out;

inout  vddq, vss;

input  en_dn, en_up, inb_n, inb_p;

input [4:0]  ncal;
input [5:0]  pcal;

// Buses in the design

wire  [6:0]  p;

wire  [6:0]  p1;

wire  [4:0]  net022;

wire  [4:0]  caln;

wire  [5:0]  net023;

wire  [5:0]  nbb;

wire  [5:0]  n1;

wire  [5:0]  n;

wire  [5:0]  calp;

wire  [6:0]  pb;

wire  [5:0]  up_code;

wire  [4:0]  dn_code;

wire drv_out;
specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240";
    specparam CDS_VIEWNAME = "schematic";
endspecify

INVD4BWP30P140LVT  I45[5:0] ( .ZN({n_fix, dn_code[4], dn_code[3],
     dn_code[2], dn_code[1], dn_code[0]}), .VDD(vddq), .VSS(vss),
     .I(n[5:0]));
INVD4BWP30P140LVT  I41[6:0] ( .ZN({p_fix, up_code[5], up_code[4],
     up_code[3], up_code[2], up_code[1], up_code[0]}), .VDD(vddq),
     .VSS(vss), .I(p[6:0]));
ND2D1BWP30P140LVT  I29[4:0] ( .ZN(net022[4:0]), .VDD(vddq), .VSS(vss),
     .A1(ncal[4:0]), .A2(en_dn));
ND2D2BWP30P140LVT  I31[4:0] ( .ZN(nbb[4:0]), .VDD(vddq), .VSS(vss),
     .A1(caln[4:0]), .A2(inb_n));
ND2D2BWP30P140LVT  I30 ( .A2(en_dn), .A1(inb_n), .VDD(vddq), .VSS(vss),
     .ZN(nbb[5]));

wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240p I15 (.out(drv_out), .up_code(up_code), .up_fix(p_fix), .vddq(vddq), .vss(vss));
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240n I16 (.dn_code(dn_code), .dn_fix(n_fix), .out(drv_out), .vss(vss));
INVD2BWP30P140LVT  I25[4:0] ( .ZN(caln[4:0]), .VDD(vddq), .VSS(vss),
     .I(net022[4:0]));
INVD2BWP30P140LVT  I44[5:0] ( .ZN(n[5:0]), .VDD(vddq), .VSS(vss),
     .I(n1[5:0]));
INVD2BWP30P140LVT  I23 ( .I(en_up), .ZN(enup_b), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140LVT  I40[6:0] ( .ZN(p[6:0]), .VDD(vddq), .VSS(vss),
     .I(p1[6:0]));
INVD2BWP30P140LVT  I24[5:0] ( .ZN(calp[5:0]), .VDD(vddq), .VSS(vss),
     .I(net023[5:0]));
NR2D2BWP30P140LVT  I26 ( .A2(inb_p), .A1(enup_b), .VDD(vddq),
     .ZN(pb[6]), .VSS(vss));
NR2D2BWP30P140LVT  I27[5:0] ( .ZN(pb[5:0]), .VDD(vddq), .VSS(vss),
     .A1(inb_p), .A2(calp[5:0]));
NR2D1BWP30P140LVT  I28[5:0] ( .ZN(net023[5:0]), .VDD(vddq), .VSS(vss),
     .A1(enup_b), .A2(pcal[5:0]));
INVD1BWP30P140LVT  I43[5:0] ( .ZN(n1[5:0]), .VDD(vddq), .VSS(vss),
     .I(nbb[5:0]));
INVD1BWP30P140LVT  I39[6:0] ( .ZN(p1[6:0]), .VDD(vddq), .VSS(vss),
     .I(pb[6:0]));

endmodule
// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice,
//View - schematic
// LAST TIME SAVED: Dec  6 23:04:56 2021
// NETLIST TIME: Aug 17 20:20:07 2022
/*
 * `timescale 1ns / 1ns 

module cdsModule_2 ( out_t, vddq, vss, impd, in_t, ncal, ovrd, ovrd_b,
     ovrd_n_b, ovrd_p_b, pcal );

output  out_t;

inout  vddq, vss;

input  impd, in_t, ovrd, ovrd_b, ovrd_n_b, ovrd_p_b;

input [4:0]  ncal;
input [5:0]  pcal;


specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME =
     "wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice";
    specparam CDS_VIEWNAME = "schematic";
endspecify

wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_predrv I1 ( data_b, vddq, vss,
     ovrd_b, ovrd, in_t, ovrd_n_b, ovrd_p_b);
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240 I0 ( out_t, vddq, vss,
     impd, impd, data_b, data_b, ncal[4:0], pcal[5:0]);

endmodule
*/



module wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice (out_t, vddq, vss, impd, in_t, ncal,
    ovrd, ovrd_b, ovrd_n_b, ovrd_p_b, pcal);

output  out_t;

inout  vddq, vss;

input  impd, in_t, ovrd, ovrd_b, ovrd_n_b, ovrd_p_b;

input [4:0]  ncal;
input [5:0]  pcal;

wire out_t;
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_240 I0 ( .pcal(pcal[5:0]), .vddq(vddq), .vss(vss),
    .drv_out(out_t), .inb_n(data_b), .inb_p(data_b), .ncal(ncal[4:0]),
    .en_dn(impd), .en_up(impd));

wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_predrv INVT0 ( .pd(ovrd_n_b), .pu(ovrd_p_b), .out(data_b),
    .en(ovrd_b), .enb(ovrd), .vss(vss), .in(in_t), .vdd(vddq));

endmodule


// Library - LPDDR4_T28HPC, Cell -
//wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_UCIe_PAM4, View -
//schematic
// LAST TIME SAVED: Aug  9 23:39:05 2022
// NETLIST TIME: Aug 17 20:20:07 2022
`timescale 1ns / 1ns 

module wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_UCIe_PAM4 ( out_t, PAM4_en, UCIe_ODT_en[1], UCIe_ODT_en[0],
     UCIen, impd[2], impd[1], impd[0], impd_b[2:0], in_t_pam4,
     in_td_b_pam4, ncal[4:0], ovrd[2:0], ovrd_b[2:0], ovrd_n_b[2:0],
     ovrd_p_b[2:0], ovrd_val, pcal[5:0], vddq, vss );

output  out_t;

input  PAM4_en, UCIen, in_t_pam4, in_td_b_pam4, ovrd_val, vddq, vss;

input [0:1]  UCIe_ODT_en;
input [2:0]  impd_b;
input [2:0]  ovrd_n_b;
input [2:0]  ovrd_p_b;
input [2:0]  ovrd_b;
input [2:0]  ovrd;
input [4:0]  ncal;
input [5:0]  pcal;
input [2:0]  impd;

// Buses in the design

wire  [0:1]  net14;

wire  [0:3]  impdi;

wire  [0:3]  in_t;
//real out_t;

reg [3:0] out_t;
wire [3:0] out_s;
NR2D1BWP30P140  I26 ( .A2(UCIe_ODT_en[0]), .A1(ovrd_val), .VDD(vddq),
     .ZN(net8), .VSS(vss));
NR2D1BWP30P140  I24 ( .A2(net8), .A1(net9), .VDD(vddq), .ZN(impdi[3]),
     .VSS(vss));
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice I4 ( out_s[0], vddq, vss, impdi[3], in_t[0], ncal[4:0],
     ovrd[2], ovrd_b[2], ovrd_n_b[2], ovrd_p_b[2], pcal[5:0]);
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice I2[3:0] ( out_s[1], vddq, vss, impdi[2], in_t[3], ncal[4:0],
     ovrd[2], ovrd_b[2], ovrd_n_b[2], ovrd_p_b[2], pcal[5:0]);
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice I1[1:0] ( out_s[2], vddq, vss, impdi[1], in_t[2], ncal[4:0],
     ovrd[1], ovrd_b[1], ovrd_n_b[1], ovrd_p_b[1], pcal[5:0]);
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_slice I0 ( out_s[3], vddq, vss, impdi[0], in_t[1], ncal[4:0],
     ovrd[0], ovrd_b[0], ovrd_n_b[0], ovrd_p_b[0], pcal[5:0]);
INVD2BWP30P140  I30 ( .I(UCIen), .ZN(net9), .VDD(vddq), .VSS(vss));
INVD2BWP30P140  I25 ( .I(net8), .ZN(net10), .VDD(vddq), .VSS(vss));
ND2D1BWP30P140  I33[1:0] ( .ZN(net14[0:1]), .VDD(vddq), .VSS(vss),
     .A1(impd[1:0]), .A2(net9));
ND2D1BWP30P140  I32[1:0] ( .ZN({impdi[1], impdi[0]}), .VDD(vddq),
     .VSS(vss), .A1(net14[0:1]), .A2(net13));
ND2D1BWP30P140  I31 ( .A2(UCIen), .A1(net15), .VDD(vddq), .VSS(vss),
     .ZN(net13));
ND2D1BWP30P140  I29 ( .A2(impd[2]), .A1(net9), .VDD(vddq), .VSS(vss),
     .ZN(net12));
ND2D1BWP30P140  I28 ( .A2(net11), .A1(net12), .VDD(vddq), .VSS(vss),
     .ZN(impdi[2]));
ND2D1BWP30P140  I27 ( .A2(net10), .A1(UCIen), .VDD(vddq), .VSS(vss),
     .ZN(net11));
MUX2D1BWP30P140  I5 ( .S(PAM4_en), .I1(vddq), .I0(in_t_pam4),
     .Z(in_t[1]), .VDD(vddq), .VSS(vss));
MUX2D1BWP30P140  I6[1:0] ( .Z(in_t[2]), .VDD(vddq), .VSS(vss),
     .I0(in_t_pam4), .I1(in_t_pam4), .S(PAM4_en));
MUX2D1BWP30P140  I7[3:0] ( .Z(in_t[3]), .VDD(vddq), .VSS(vss),
     .I0(in_t_pam4), .I1(in_td_b_pam4), .S(PAM4_en));
MUX2D1BWP30P140  I8 ( .S(PAM4_en), .I1(vss), .I0(in_td_b_pam4),
     .Z(in_t[0]), .VDD(vddq), .VSS(vss));
OR2D1BWP30P140  I34 ( .Z(net15), .A2(ovrd_val), .A1(UCIe_ODT_en[1]),
     .VDD(vddq), .VSS(vss));

/*
always @(*) begin
case(out_s[3:0])
        4'b1111: out_t = 3'b011; //ucie_phase1
        4'b1110: out_t = 3'b010; //ucie_phase2 pam4_11
	4'b1100: out_t = 3'b110; // pam4_10
	4'b1010: out_t = 3'b101; //pam4_01
	4'b1000: out_t = 3'b100; //pam4_00
        4'b0000: out_t = 3'b000; //ucie_phase3
        4'b0001: out_t = 3'b001; //ucie_phase4
endcase
end
*/
assign out_t = out_s;

endmodule
// Library - LPDDR4_T28HPC, Cell - wphy_lp4x5_dq_drvr_w_lpbk_UCIe_PAM4,
//View - schematic
// LAST TIME SAVED: Aug 10 22:23:52 2022
// NETLIST TIME: Aug 17 20:20:07 2022
`timescale 1ns / 1ns 
//_UCIe_PAM4
module wphy_lp4x5_dq_drvr_w_lpbk (vdd_aon, d_lpbk_out, rx_in, pad,
     vdda, vddq, vss, PAM4_en, UCIe_ODT_en, UCIe_dem_en, UCIen,
     d_bs_din, d_bs_ena,  d_drv_impd, d_in_c,
     d_in_c_PAM4, d_in_c_db, d_lpbk_ena, d_ncal, d_ovrd, d_ovrd_val, d_pcal, freeze_n, highz_n );

output  d_lpbk_out, rx_in;
inout vdd_aon;
input vdda, vddq, vss;
output pad;
//real pad;
wire [3:0] pad;
input  PAM4_en, UCIe_dem_en, UCIen, d_bs_din, d_bs_ena, d_in_c,
     d_in_c_PAM4, d_in_c_db, d_lpbk_ena, d_ovrd_val, freeze_n, highz_n;

input [5:0]  d_pcal;
input [4:0]  d_ncal;
input [2:0]  d_drv_impd;
input [2:0]  d_ovrd;
input [1:0]  UCIe_ODT_en;

// Buses in the design

wire  [1:0]  ODT_en;

wire  [2:0]  ovrd_buf;

wire  [2:0]  impd;

wire  [2:0]  net045;

wire  [2:0]  impd_b;

wire  [2:0]  ovrd_n_b;

wire  [2:0]  ovrd_p_b;

wire  [2:0]  net046;

wire  [2:0]  impd_b_frz;

wire  [2:0]  ovrd_b_frz;

wire  [2:0]  ovrd_b;

wire  [0:1]  net4;

assign vssq = 1'b0;
assign vddq = 1'b1;
specify 
    specparam CDS_LIBNAME  = "LPDDR4_T28HPC";
    specparam CDS_CELLNAME = "wphy_lp4x5_dq_drvr_w_lpbk_UCIe_PAM4";
    specparam CDS_VIEWNAME = "schematic";
endspecify

wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_lvlsht_vq2va I3 ( .vddq(vddq), .vdda(vdda), .d_ena(d_lpbk_ena), .freeze_n(net6),
.in_vq(rx_in), .vss(vss), .out(d_lpbk_out));
MUX3D2BWP30P140LVT  I83 ( .S1(UCIe_dem_en), .S0(PAM4_en),
     .I2(d_in_c_db), .I1(d_in_c_PAM4), .I0(d_in_c), .Z(net3),
     .VSS(vss), .VDD(vdda));
MUX3D2BWP30P140LVT  I9 ( .S1(vss), .S0(vss), .I2(vss), .I1(vss),
     .I0(d_in_c), .Z(net2), .VSS(vss), .VDD(vdda));
INVD1BWP30P140  I74[1:0] ( .ZN(net4[0:1]), .VDD(vddq), .VSS(vss),
     .I(UCIe_ODT_en[1:0]));
INVD1BWP30P140  I60 ( .I(net1), .ZN(UCIE_en), .VDD(vddq), .VSS(vss));
INVD1BWP30P140  I73[1:0] ( .ZN(ODT_en[1:0]), .VDD(vddq), .VSS(vss),
     .I(net4[0:1]));
wphy_lp4x5_dq_drvr_w_lpbk_cdm_50ohm I1 ( .out(rx_in), .vdd(vddq), .vss(vss), .pad(pad));
LVLHLD2BWP30P140  I65 ( .I(in_td), .Z(in_tdb_lvl), .VDD(vddq),
     .VSS(vss));
LVLHLD2BWP30P140  I8 ( .I(in_t), .Z(in_t_lvl), .VDD(vddq), .VSS(vss));
ND2D1BWP30P140  I75 ( .A2(freeze_n_vq), .A1(UCIen), .VDD(vddq),
     .VSS(vss), .ZN(net1));
ND2D1BWP30P140  I48 ( .A2(net6), .A1(d_bs_ena), .VDD(vddq), .VSS(vss),
     .ZN(bs_enb_vq));
ND2D1BWP30P140  I54[1:0] ( .ZN(ovrd_b_frz[2:1]), .VDD(vddq), .VSS(vss),
     .A1(freeze_n_vq), .A2(d_ovrd[2:1]));
ND2D1BWP30P140  I53 ( .A2(d_ovrd_val), .A1(freeze_n_vq), .VDD(vddq),
     .VSS(vss), .ZN(val_b_frz));
ND2D1BWP30P140  I49 ( .A2(d_bs_din), .A1(net6), .VDD(vddq), .VSS(vss),
     .ZN(bs_data_b));
ND2D1BWP30P140  I52[1:0] ( .ZN(impd_b_frz[2:1]), .VDD(vddq), .VSS(vss),
     .A1(freeze_n_vq), .A2(d_drv_impd[2:1]));
ND2D1BWP30P140  I77 ( .A2(highz_n), .A1(freeze_n), .VDD(vddq),
     .VSS(vss), .ZN(net7));
ND2D1BWP30P140  I46[2:0] ( .ZN(ovrd_p_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_val_b), .A2(ovrd_buf[2:0]));
//BUFTD4BWP30P140  I55 ( .OE(bs_ena_vq), .I(net44), .Z(pad), .VDD(vddq),
//     .VSS(vss));
//PDB3AC_H_G  I4 ( .TACVDD(vddq), .TACVSS(vss), .VSS(vss), .AIO(pad));
wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT I63 ( .outn(in_td), .outp(in_cd), .vdd(vdda),
     .vss(vss), .in(net3), .tiehi(vdda), .tielo(vss));
wphy_lp4x5_dq_drvr_w_lpbk_SE2DIHS_D2_GL16_RVT I2 ( .outn(in_t), .outp(in_c), .vdd(vdda),
     .vss(vss), .in(net2), .tiehi(vdda), .tielo(vss));
INVD4BWP30P140  I82 ( .I(highz_n), .ZN(net9), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I78 ( .I(net7), .ZN(net6), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I34 ( .I(freeze_vq), .ZN(freeze_n_vq), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I44 ( .I(net6), .ZN(freeze_vq), .VDD(vddq), .VSS(vss));
INVD4BWP30P140  I56 ( .I(bs_data_b), .ZN(net44), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I35 ( .I(net042), .ZN(ovrd_val_b), .VDD(vddq),
     .VSS(vss));
INVD4BWP30P140  I39[2:0] ( .ZN(ovrd_buf[2:0]), .VDD(vddq), .VSS(vss),
     .I(ovrd_b[2:0]));
INVD4BWP30P140  I38[2:0] ( .ZN(ovrd_b[2:0]), .VDD(vddq), .VSS(vss),
     .I(net045[2:0]));
INVD4BWP30P140  I41[2:0] ( .ZN(impd_b[2:0]), .VDD(vddq), .VSS(vss),
     .I(net046[2:0]));
INVD4BWP30P140  I45 ( .I(bs_enb_vq), .ZN(bs_ena_vq), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140  I80 ( .I(net10), .ZN(impd_b_frz[0]), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140  I36 ( .I(val_b_frz), .ZN(net042), .VDD(vddq),
     .VSS(vss));
INVD2BWP30P140  I37[2:0] ( .ZN(net045[2:0]), .VDD(vddq), .VSS(vss),
     .I(ovrd_b_frz[2:0]));
INVD2BWP30P140  I40[2:0] ( .ZN(net046[2:0]), .VDD(vddq), .VSS(vss),
     .I(impd_b_frz[2:0]));
INVD8BWP30P140  I42[2:0] ( .ZN(impd[2:0]), .VDD(vddq), .VSS(vss),
     .I(impd_b[2:0]));
NR2D1BWP30P140  I47[2:0] ( .ZN(ovrd_n_b[2:0]), .VDD(vddq), .VSS(vss),
     .A1(ovrd_val_b), .A2(ovrd_b[2:0]));
NR2D1BWP30P140  I57 ( .A2(d_drv_impd[0]), .A1(freeze_vq), .VDD(vddq),
     .ZN(net8), .VSS(vss));
NR2D1BWP30P140  I51 ( .A2(d_ovrd[0]), .A1(freeze_vq), .VDD(vddq),
     .ZN(ovrd_b_frz[0]), .VSS(vss));
NR2D1BWP30P140  I79 ( .A2(net9), .A1(net8), .VDD(vddq), .ZN(net10),
     .VSS(vss));
wphy_lp4x5_dq_drvr_w_lpbk_wphy_lp4x5_drv_core_UCIe_PAM4 I0 ( pad, PAM4_en, ODT_en[1], ODT_en[0], UCIE_en, impd[2],
     impd[1], impd[0], impd_b[2:0], in_t_lvl, in_tdb_lvl, d_ncal[4:0],
     ovrd_buf[2:0], ovrd_b[2:0], ovrd_n_b[2:0], ovrd_p_b[2:0], net042,
     d_pcal[5:0], vddq, vss);

endmodule


// End HDL models
