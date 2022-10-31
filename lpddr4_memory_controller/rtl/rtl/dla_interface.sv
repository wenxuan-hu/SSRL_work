interface dla_interface;
// ----------------------------------------------------
//input
    //logic             lclk  ;
    //TODO   clock and reset signal need to be separated;



    logic     [DLA_DATA_W-1:0]        data_out   ; 
    logic     [DLA_DATA_W-1:0]        data_in   ; 
    logic            is_valid_out  ;
    logic            is_valid_in  ;
    logic             is_on_off_in;
    logic             is_on_off_out;
    logic             is_allocatable_out;
    logic             is_allocatable_in;



      
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
      
modport dut (input  data_in,  is_valid_in,  is_on_off_in, is_allocatable_in, 
output data_out,  is_valid_out, is_on_off_out,  is_allocatable_out);




endinterface
