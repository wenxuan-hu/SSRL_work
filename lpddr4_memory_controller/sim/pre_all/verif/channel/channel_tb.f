//+define+DDR_LPDE_BEHAV
+define+UCIE_CA_RX
//+define+RDQS_TEST
//+define+FGB_TEST_4TO8
//+define+RCVR_DC_DISABLE
+define+SA_BEHAV
//+define+EGRESS_MODE_QDR
//+define+IGNORE_MUX
//+define+PI_TEST_ENABLE
+incdir+./
+incdir+../rtl
+incdir+../ucie
+incdir+../wav-lpddr-hw
+incdir+./channel
./channel/channel_tb.sv
../ucie/ucie_channel_adapter.sv
-f ../wav-lpddr-hw/verif/flist/ddr_phy.f
-f ../wav-lpddr-hw/verif/flist/ddr_phy.behav.f
-f ../common/common.f