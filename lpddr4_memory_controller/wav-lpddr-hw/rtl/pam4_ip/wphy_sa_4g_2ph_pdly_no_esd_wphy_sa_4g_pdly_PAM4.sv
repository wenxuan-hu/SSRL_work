module wphy_sa_4g_2ph_pdly_no_esd_wphy_sa_4g_pdly_PAM4 ( Dout, Doutb, Biasn, EQ, PAM4_en, cal0, cal1, cal2,
     cal_dir, clk, dly_ctrl, dly_gear, ena,
     inn_0, inn_1, inn_2, inp_0, inp_1, inp_2, vdda, vss );


input  Biasn, PAM4_en, clk, ena, vdda, vss;

output [1:0]  Doutb;
output [1:0]  Dout;

input [3:0]  cal1;
input [1:0]  EQ;
input [3:0]  cal0;
input [3:0]  cal2;
input [5:0]  dly_ctrl;
input [1:0]  dly_gear;
input [0:2]  cal_dir;
input real  inn_0;
input real inn_1;
input real inn_2;
input real  inp_0;
input real inp_1; 
input real inp_2;

// Buses in the design

wire  [0:2]  pd;


wire  [0:2]  cmp_inn;

wire  [0:2]  VON;

wire  [0:2]  q;

wire  [0:2]  qb;

wire  [0:2]  VOP;

wire  [0:2]  clk_int;

//CTLE
//assign cmp_inp = inp;
//assign cmp_inn = inn;


wphy_prog_dly_sa_4g I4 (.vdda(vdda), .in(clk), .gear(dly_gear), .i_ctrl(dly_ctrl), .ena(ena), .vss(vss), .outb(clk_b_int));
INVD2BWP30P140LVT  I33 ( .I(Dout[1]), .ZN(Doutb[1]), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I18 ( .I(VOP[2]), .ZN(net18), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I19 ( .I(VON[1]), .ZN(net22), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I13 ( .I(VON[2]), .ZN(net17), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I61 ( .I(VON[0]), .ZN(net2), .VDD(vdda), .VSS(vss));
INVD2BWP30P140LVT  I59 ( .I(VOP[0]), .ZN(net1), .VDD(vdda), .VSS(vss));
INVD2BWP30P140LVT  I32 ( .I(Doutb[0]), .ZN(Dout[0]), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I25 ( .I(VOP[1]), .ZN(net21), .VDD(vdda),
     .VSS(vss));
INVD2BWP30P140LVT  I35 ( .I(qb[1]), .ZN(Dout[1]), .VDD(vdda),
     .VSS(vss));
NR2D2BWP30P140  I39 ( .A2(clk_b_int), .A1(net7), .VDD(vdda),
     .ZN(clk_int[0]), .VSS(vss));
NR2D2BWP30P140  I38 ( .A2(clk_b_int), .A1(vss), .VDD(vdda),
     .ZN(clk_int[1]), .VSS(vss));
NR2D2BWP30P140  I37 ( .A2(clk_b_int), .A1(net7), .VDD(vdda),
     .ZN(clk_int[2]), .VSS(vss));
INVD0BWP30P140LVT  I41 ( .I(PAM4_en), .ZN(net7), .VDD(vdda),
     .VSS(vss));
CMP_P I15 ( .vdda(vdda), .cal(cal2[3:0]), .cal_dir(cal_dir[2]),
     .vssa(vss), .VON(VON[2]), .VOP(VOP[2]), .CK(clk_int[2]),
     .INN(inn_2), .INP(inp_2));
CMP_P I22 ( .vdda(vdda), .cal(cal1[3:0]), .cal_dir(cal_dir[1]),
     .vssa(vss), .VON(VON[1]), .VOP(VOP[1]), .CK(clk_int[1]),
     .INN(inn_1), .INP(inp_1));
CMP_P I27 ( .vdda(vdda), .cal(cal0[3:0]), .cal_dir(cal_dir[0]),
     .vssa(vss), .VON(VON[0]), .VOP(VOP[0]), .CK(clk_int[0]),
     .INN(inn_0), .INP(inp_0));
ND2D2BWP30P140  I43 ( .A2(ena), .A1(PAM4_en), .VDD(vdda), .VSS(vss),
     .ZN(pd[0]));
ND2D2BWP30P140  I42 ( .A2(ena), .A1(PAM4_en), .VDD(vdda), .VSS(vss),
     .ZN(pd[2]));
ND2D2BWP30P140  I17 ( .A2(qb[2]), .A1(net18), .VDD(vdda), .VSS(vss),
     .ZN(q[2]));
ND2D2BWP30P140  I14 ( .A2(net17), .A1(q[2]), .VDD(vdda), .VSS(vss),
     .ZN(qb[2]));
ND2D2BWP30P140  I20 ( .A2(net22), .A1(q[1]), .VDD(vdda), .VSS(vss),
     .ZN(qb[1]));
ND2D2BWP30P140  I62 ( .A2(net2), .A1(q[0]), .VDD(vdda), .VSS(vss),
     .ZN(qb[0]));
ND2D2BWP30P140  I60 ( .A2(qb[0]), .A1(net1), .VDD(vdda), .VSS(vss),
     .ZN(q[0]));
ND2D2BWP30P140  I24 ( .A2(qb[1]), .A1(net21), .VDD(vdda), .VSS(vss),
     .ZN(q[1]));
ND2D2BWP30P140  I40 ( .A2(ena), .A1(vdda), .VDD(vdda), .VSS(vss),
     .ZN(pd[1]));
ND2D2BWP30P140  I31 ( .A2(q[0]), .A1(net3), .VDD(vdda), .VSS(vss),
     .ZN(Doutb[0]));
//nmos (out, data, control)
//pmos (out, data, control);
//nch_mac  M3[2:0] ( .B(vss), .D(vss), .G(inn[2:0]), .S(vss)); //cap
//nch_mac  M1 ( .G(pd[2]), .D(q[2]), .S(vss), .B(vss));
//nch_mac  M0 ( .G(pd[0]), .D(q[0]), .S(vss), .B(vss));
//nch_mac  M2 ( .G(pd[1]), .D(q[1]), .S(vss), .B(vss));

nmos M1 (q[2], vss, pd[2]);
nmos M0 (q[0], vss, pd[0]);
nmos M2 (q[1], vss, pd[1]);

XNR2D2BWP30P140  I30 ( .A2(q[1]), .A1(q[2]), .ZN(net3), .VSS(vss),
     .VDD(vdda));

endmodule

