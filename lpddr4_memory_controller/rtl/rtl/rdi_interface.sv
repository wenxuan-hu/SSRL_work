interface rdi_interface;
// ----------------------------------------------------
//input
    //logic             lclk  ;
    //TODO   clock and reset signal need to be separated;



    logic             lp_irdy   ; 
    logic             lp_valid  ;
    logic   [NBYTES*8-1:0]          lp_data   ;     //N Bytes means N lanes;
    logic             lp_retimer_crd;
    logic             pl_trdy;
    logic             pl_valid;
    logic    [NBYTES*8-1:0]         pl_data;
    logic             pl_retimer_crd;



    logic   [3:0]     lp_state_req;
    logic             lp_linkerror;
    logic   [3:0]     pl_state_sts;
    logic             pl_inband_pass;
    logic             pl_error;
    logic             pl_cerror;
    logic             pl_nferror;
    logic             pl_trainerror;
    logic             pl_phyinrecenter;


    logic             pl_stallreq;
    logic             lp_stallack;
    
    logic    [2:0]         pl_speedmode;
    logic    [2:0]         pl_lnk_cfg;


    logic             pl_clk_req;
    logic             lp_clk_ack;

    logic             lp_wake_req;
    logic             pl_wake_ack;

    logic   [NC-1:0]  pl_cfg;
    logic             pl_cfg_vld;
    logic             pl_cfg_crd;
    logic   [NC-1:0]  lp_cfg;
    logic             lp_cfg_vld;
    logic             lp_cfg_crd;



      
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
      
modport  dut (input  pl_trdy,pl_valid, pl_data, 
output   lp_irdy, lp_valid, lp_data);




endinterface
