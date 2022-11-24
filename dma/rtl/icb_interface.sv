//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-01 11:03
//  Email             : huwe0427@uw.edu
//  Filename          : icb_interface.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



interface icb_interface;
// ----------------------------------------------------


logic   icb_cmd_valid_i;
logic   icb_cmd_ready_o;
logic   [`ICB_WIDTH-1:0]  icb_cmd_addr_i;
logic   icb_cmd_read_i;
logic   [`ICB_WIDTH-1:0]  icb_cmd_wdata_i;
logic   [`ICB_WIDTH/8-1:0]  icb_cmd_wmask_i;



logic   icb_rsp_valid_o;
logic   icb_rsp_ready_i;
logic   [`ICB_WIDTH-1:0] icb_rsp_rdata_o;
logic   icb_rsp_err_o;


      
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
      
modport dut (input icb_cmd_valid_i, icb_cmd_addr_i, icb_cmd_read_i, icb_cmd_wdata_i,
icb_cmd_wmask_i, icb_rsp_ready_i, 
output icb_cmd_ready_o, icb_rsp_valid_o, icb_rsp_rdata_o, icb_rsp_err_o);




endinterface

