//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-05 22:27
//  Email             : huwe0427@uw.edu
//  Filename          : mosi_interface.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



interface mosi_interface;
// ----------------------------------------------------
//input
    //logic             lclk  ;
    //TODO   clock and reset signal need to be separated;


    logic     rst;
    logic     clk;

    logic     [MOSI_DATA_W-1:0]        mosi_data_i; 
    logic     [MOSI_DATA_W-1:0]        miso_data_o; 
    logic            mosi_valid_i ;
    logic            miso_valid_o;
    logic            miso_ready_i ; 
    logic            mosi_ready_o ;



      
clocking drv_cb @(posedge clk);
default input #0.1 output #0.05;
    output             mosi_data_i; 
    input             miso_data_o; 
    output            mosi_valid_i ;
    input            miso_valid_o;
    output            miso_ready_i ; 
    input            mosi_ready_o ;
endclocking

clocking mon_cb @(posedge clk);
default input #0.1 output #0.05;
   // output             mosi_data_i; 
   // input             miso_data_o; 
   // output            mosi_valid_i ;
   // input            miso_valid_o;
   // output            miso_ready_i ; 
   // input            mosi_ready_o ;

    input             mosi_data_i; 
    input             miso_data_o; 
    input            mosi_valid_i ;
    input            miso_valid_o;
    input            miso_ready_i ; 
    input            mosi_ready_o ;

endclocking
      
//modport dut (input  mosi_data_i, mosi_valid_i, miso_ready_i, 
modport dut (input  mosi_data_i, mosi_valid_i, miso_ready_i, rst, clk, 
output miso_data_o, miso_valid_o, mosi_ready_o);




endinterface
