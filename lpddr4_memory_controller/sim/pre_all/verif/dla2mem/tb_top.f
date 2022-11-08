+define+RW_ONLY
+define+DATA_PATH
//+define+TIMING_CHECK


+define+X16
+define+LPDDR4_4266
+define+Den_4Gb
+define+_4x
+define+UCIE_CA_RX
+define+SA_BEHAV


//-f ./dla2mem/ddr_phy.f
//-f ./dla2mem/ddr_phy.behav.f
//-f ./dla2mem/common.f

+incdir+./
+incdir+../../../rtl
+incdir+./dla2mem
+incdir+../../../ucie
+incdir+../../../wav-lpddr-hw/rtl/wddr
+incdir+./dfi_lpddr4_agent
+incdir+./native_agent
+incdir+./dla_agent
+incdir+./dfi_agent
+incdir+/home/lab.apps/vlsiapps_new/vcs/R-2020.12-SP1/etc/uvm-1.2
//./dla2mem/tb_top.sv
../../../rtl/interface.sv
./dla2mem/mc_top_test_pkg.sv
./dla2mem/handshake.sv
../../../rtl/refresher_pos_8.v
../../../rtl/bankmachine_0.v
../../../rtl/bankmachine_1.v
../../../rtl/bankmachine_2.v
../../../rtl/bankmachine_3.v
../../../rtl/bankmachine_4.v
../../../rtl/bankmachine_5.v
../../../rtl/bankmachine_6.v
../../../rtl/bankmachine_7.v
../../../rtl/crossbar_2ports.v
../../../rtl/DFIAdapter.v
../../../rtl/crossbar_2ports_wrapper.sv
../../../rtl/multiplexer_b8_wrapper.sv
../../../rtl/refresher_pos_8_wrapper.sv
../../../rtl/bankmachine_wrapper.sv
../../../rtl/mc_core.sv
../../../rtl/mc_top.sv
../../../rtl/multiplexer_b8.v
../../../rtl/tapped_delay_line.sv
../../../rtl/ahb.sv




../../../rtl/defines.v
../../../rtl/mosi_interface.sv 
../../../rtl/native_interface.sv 
../../../rtl/sram_model.v
../../../rtl/sync_fifo.v
../../../rtl/clk_gate.v
../../../rtl/mosi_native.sv


../../../phy/mixed_phy_1x32.sv
../../../ucie/ucie_ahb_csr.sv
../../../ucie/ucie_buf.sv
../../../ucie/ucie_channel_adapter_wrapper.sv
../../../ucie/ucie_csr.sv
../../../ucie/ucie_channel_adapter.sv

//-f ../../../wav-lpddr-hw/verif/flist/ddr_phy.f
//-f ../../../wav-lpddr-hw/verif/flist/ddr_phy.behav.f
//
//-f ../../../common/common.f


-f ./dla2mem/ddr_phy.f
-f ./dla2mem/ddr_phy.behav.f
-f ./dla2mem/common.f



./mixed_phy/sram_loader.sv
./dla2mem/nanya_mobile_model_lpddr4.v



./dla2mem/tb_top.sv


