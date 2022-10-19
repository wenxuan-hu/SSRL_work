//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-06 00:30
//  Email             : huwe0427@uw.edu
//  Filename          : native_interface.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

interface dma_native_interface;
// ----------------------------------------------------
//input
    //logic             lclk  ;
    //TODO   clock and reset signal need to be separated;



    logic     [DDR_DATA_W-1:0]        wdata_payload_data_o; 
    logic     [DDR_DATA_W-1:0]        rdata_payload_data_i; 
    logic     [DDR_MASK_W-1:0]        wdata_payload_we_o; 
    logic     [DDR_ADDR_W-1:0]        ncmd_payload_addr_o; 
    logic           ncmd_valid_o  ;
    logic           ncmd_ready_i  ;
    logic           ncmd_payload_we_o  ;
    logic           ncmd_payload_mw_o  ;

    logic           wdata_valid_o ;
    logic           wdata_ready_i ;
    logic           rdata_valid_i ;
    logic           rdata_ready_o ;


      
//clocking drv_cb @(posedge clk);
//default input #10ns output #5ns;
//    output             clk,rst   ;
//    input           rd_ready_o;
//endclocking
//
//clocking mon_cb @(posedge clk);
//default input #10ns output #5ns;
//    input           rd_i;
//
//
//endclocking
      
modport dut (input rdata_payload_data_i, ncmd_ready_i, wdata_ready_i, rdata_valid_i,  
output wdata_payload_data_o,  wdata_payload_we_o, ncmd_payload_addr_o, ncmd_valid_o,
ncmd_payload_we_o,  ncmd_payload_mw_o,  wdata_valid_o,  rdata_ready_o);




endinterface




