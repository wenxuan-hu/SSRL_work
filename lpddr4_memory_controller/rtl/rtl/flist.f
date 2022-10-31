//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-30 02:09
//  Email             : huwe0427@uw.edu
//  Filename          : flist.f
//  Description       : 
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************


// ----------------------------------------------------
//design path
+incdir+/home/huwe0427/work/ucie/de/src/rtl 

// ----------------------------------------------------
//  design


/home/huwe0427/work/ucie/de/src/rtl/rdi_interface.sv
/home/huwe0427/work/ucie/de/src/rtl/dla_interface.sv


/home/huwe0427/work/ucie/de/src/rtl/defines.v
/home/huwe0427/work/ucie/de/src/rtl/sram259x64.v
/home/huwe0427/work/ucie/de/src/rtl/sram_model.v
/home/huwe0427/work/ucie/de/src/rtl/sync_fifo.v
/home/huwe0427/work/ucie/de/src/rtl/clk_gate.v

//native2protocol.v

/home/huwe0427/work/ucie/de/src/rtl/top.v

// ----------------------------------------------------
//lib module
-y /home/lab.apps/vlsiapps_new/syn/T-2022.03-SP3/dw/sim_ver

// ----------------------------------------------------
// pre-process
+libext+.v
//+define+VCS_DUMPON=1
