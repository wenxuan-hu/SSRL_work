//+define+ADD_PHY_MODEL
+define+RW_ONLY
+define+DATA_PATH
+define+TIMING_CHECK
+incdir+./
+incdir+../rtl
+incdir+./core
+incdir+./dfi_lpddr4_agent
+incdir+./native_agent
+incdir+./dfi_agent
+incdir+/home/lab.apps/vlsiapps_new/vcs/R-2020.12-SP1/etc/uvm-1.2
./core/core_tb.sv
../rtl/interface.sv
./core/core_test_pkg.sv
../rtl/refresher_pos_8.v
../rtl/bankmachine_0.v
../rtl/bankmachine_1.v
../rtl/bankmachine_2.v
../rtl/bankmachine_3.v
../rtl/bankmachine_4.v
../rtl/bankmachine_5.v
../rtl/bankmachine_6.v
../rtl/bankmachine_7.v
../rtl/crossbar_2ports.v
../rtl/DFIAdapter.v
../rtl/crossbar_2ports_wrapper.sv
../rtl/multiplexer_b8_wrapper.sv
../rtl/refresher_pos_8_wrapper.sv
../rtl/bankmachine_wrapper.sv
../rtl/mc_core.sv
../rtl/multiplexer_b8.v
../rtl/tapped_delay_line.sv

-f ../wav-lpddr-hw/verif/flist/ddr_phy.f
-f ../wav-lpddr-hw/verif/flist/ddr_phy.behav.f