//+define+DDR_LPDE_BEHAV
+define+UCIE_CA_RX
//+define+RDQS_TEST
//+define+FGB_TEST_4TO8
//+define+RCVR_DC_DISABLE
+define+SA_BEHAV
//+define+EGRESS_MODE_QDR
//+define+IGNORE_MUX
//+define+PI_TEST_ENABLE
//+incdir+/home/lab.apps/vlsiapps_new/vcs/R-2020.12-SP1/etc/uvm-1.2
+incdir+./
+incdir+../rtl
+incdir+../ucie
+incdir+../wav-lpddr-hw
+incdir+./ucie_buffer
//+incdir+./rdi_mb_agent
../ucie/ucie_ahb_csr.sv
../ucie/ucie_buf.sv
../ucie/ucie_channel_adapter_wrapper.sv
../ucie/ucie_csr.sv
../ucie/ucie_channel_adapter.sv
./ucie_buffer/ucie_buffer_tb.sv
//./ucie_channel_adapter/ucie_channel_test_pkg.sv
../rtl/interface.sv
-f ../wav-lpddr-hw/verif/flist/ddr_phy.f
-f ../wav-lpddr-hw/verif/flist/ddr_phy.behav.f
-f ../common/common.f