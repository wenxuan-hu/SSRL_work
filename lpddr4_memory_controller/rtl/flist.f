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
+incdir+/home/huwe0427/work/dma/mosi2native/rtl 


// ----------------------------------------------------
//  design


/home/huwe0427/work/dma/mosi2native/rtl/mosi_interface.sv 
/home/huwe0427/work/dma/mosi2native/rtl/native_interface.sv 


/home/huwe0427/work/dma/mosi2native/rtl/defines.v
/home/huwe0427/work/dma/mosi2native/rtl/sram_model.v
/home/huwe0427/work/dma/mosi2native/rtl/sync_fifo.v
/home/huwe0427/work/dma/mosi2native/rtl/clk_gate.v
/home/huwe0427/work/dma/mosi2native/rtl/mosi2native.sv



// ----------------------------------------------------
//lib module
-y /home/lab.apps/vlsiapps_new/syn/T-2022.03-SP3/dw/sim_ver

// ----------------------------------------------------
// pre-process
+libext+.v
//+define+VCS_DUMPON=1
