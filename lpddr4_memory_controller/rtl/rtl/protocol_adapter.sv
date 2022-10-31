//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-09-11 21:40
//  Email             : huwe0427@uw.edu
//  Filename          : protocol_adapter.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************
module  protocol_adapter(

input    clk_i,
input    rst_n,
input    enable,

rdi_interface.dut rdi,
dla_interface.dut dla

);



// ----------------------------------------------------
//signal defines:
logic [DLA_DATA_W-1:0]  dla_data_i;
logic [DLA_DATA_W-1:0]  dla_data_o;

logic dla_valid_i;
logic dla_valid_o;

logic dla_ready_i;
logic dla_ready_o;

logic dla_allocatable_i;
logic dla_allocatable_o;

logic clk;


logic [DLA_DATA_W-1:0]  wr_fifo_data_i;


logic   tx_cmd_o;
logic   rx_cmd_o;
logic   tx_resp_cmd_o;
logic   rx_resp_cmd_o;
logic   rx_crd_o;


logic   tx_detc_i;
logic   rx_detc_i;
logic   tx_resp_detc_i;
logic   rx_resp_detc_i;

logic   tx_crd_i;
logic   tx_fifo_empty;
logic   rx_fifo_empty;



logic   wr_fifo_empty;
logic   wr_fifo_full;
logic [FIFO_ADDR_W*2:0]  wr_fifo_buf_bal;
logic   rd_fifo_empty;
logic   rd_fifo_full;
logic [FIFO_ADDR_W*2:0]  rd_fifo_buf_bal;



logic   lp_idry_o;

// ----------------------------------------------------
//clock gate
clk_gate  clk_gate_inst(

  .cp(clk_i),
  .te(1'b0),
  .enable(enable),
  .q(clk)

);



// ----------------------------------------------------
// control module
adapter_core  adapter_core_inst(
  .clk  (clk),
  .enable(enable),
  .rst_n(rst_n),

  .tx_detc_i(tx_detc_i),
  .rx_detc_i(rx_detc_i),
  .tx_resp_detc_i(tx_resp_detc_i),
  .rx_resp_detc_i(rx_resp_detc_i),

  .tx_crd_i(tx_crd_i),

  .tx_fifo_empty(tx_fifo_empty),
  .rx_fifo_empty(rx_fifo_empty),

  .wr_fifo_wr_ready(),  
  .wr_fifo_rd_ready(),
  .rd_fifo_wr_ready(),
  .rd_fifo_rd_ready(),

  .tx_cmd_ready(),
  .rx_resp_cmd_ready(),
  .rx_crd_ready(),

  .rx_cmd_ready(),
  .tx_resp_cmd_ready(),
  .tx_crd_ready(),

  .tx_cmd_o(tx_cmd_o),
  .rx_cmd_o(rx_cmd_o),
  .tx_resp_cmd_o(tx_resp_cmd_o),
  .rx_resp_cmd_o(rx_resp_cmd_o),

  .rx_crd_o(rx_crd_o),

  .lp_irdy_o(),
  .cur_state_o()

);

// ----------------------------------------------------
// write interface 

  wr_datapath wr_datapath_inst(
   .clk(clk),
   .rst_n(rst_n),
   .enable(enable),

   .tx_cmd_i(tx_cmd_i), 
   .rx_resp_cmd_i(rx_resp_cmd_i),
   .rx_crd_i(rx_crd_i),

   .fifo_data_i(wr_fifo_data_i),





     .lp_idry_i(lp_idry_o),
     .pl_trdy(rdi.pl_trdy),
  
     .lp_data(rdi.lp_data),
     .lp_irdy(rdi.lp_irdy),
     .lp_valid(rdi.lp_valid),


     .tx_cmd_ready(),
     .rx_resp_ready(),
     .rx_crd_ready()
  );

always_comb begin
  dla_data_i  = dla.data_in;
  dla_valid_i = dla.is_valid_in;
  dla.is_on_off_out  = dla_ready_o;
  dla.is_allocatable_out  = dla_allocatable_o;
end



assign  tx_detc_i = ~wr_fifo_empty;
assign  rx_detc_i = ~rd_fifo_empty;
assign tx_resp_detc_i = 1'b1;
assign rx_resp_detc_i = 1'b1;

// ----------------------------------------------------
// write data datapath

sync_fifo wr_fifo_inst(
    .clk_i          (clk),
    .rst_n          (rst_n),
    .enable         (enable),
    .data_i         (dla_data_i),
    .wr_i           (dla_valid_i),
    .rd_i           (tx_cmd_i),
    
    .data_o         (wr_fifo_data_i),
    .wr_ready_o     (dla_ready_o),
    .rd_ready_o     (tx_stall),
    .buf_bal_o      (wr_fifo_buf_bal),
    .empty_o        (wr_fifo_empty),
    .full_o         (wr_fifo_full)

);

// ----------------------------------------------------

always_comb begin
  dla.data_out  = dla_data_o;
  dla.is_valid_out  = dla_valid_o;
  dla_ready_i = dla.is_on_off_in;
  dla_allocatable_i = dla.is_allocatable_in;

end



// ----------------------------------------------------
// read data datapath

sync_fifo rd_fifo_inst(
    .clk_i          (clk),
    .rst_n          (rst_n),
    .enable         (enable),
    .data_i         (rdi.pl_data[DLA_DATA_W-1:0]),
    .wr_i           (rdi.pl_valid),
    .rd_i           (rx_cmd_o),
    
    .data_o         (dla_data_o),
    .wr_ready_o     (),
    .rd_ready_o     (rx_stall),
    .buf_bal_o      (rd_fifo_buf_bal),
    .empty_o        (rd_fifo_empty),
    .full_o         (rd_fifo_full)
);

rd_datapath rd_datapath_inst(
    .clk            (clk),
    .rst_n          (rst_n),
    .enable         (enable),
    .cur_state_i    (),
    .pl_data        (),
    .pl_valid       (),

    .fifo_data_o    (),
    .fifo_wr_vld_o  (),

    .rx_detc_o      (),
    .tx_crd_o       (),
    .tx_resp_detc_o ()
);





endmodule

