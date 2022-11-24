//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-04 03:59
//  Email             : huwe0427@uw.edu
//  Filename          : memory_ctrl.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



module memory_ctrl(
  input clk_a,
  input clk_p,
  input rst_n,

  input   dma_trigger_i,
  input   pixel_trigger_i,
  input   dma_trigger_done_i,
  input   pixel_trigger_done_i,


  input [8:0] addr_rd_i,
  input [8:0] addr_wr_i,

  input wr_i,
  input rd_i,

  input [`SRAM_WIDTH-1:0]  dma_data_i,
  output logic  [`SRAM_WIDTH-1:0]  dma_data_o,


);






logic clk;
logic [8:0] addr;
logic cs_n;
logic wr_n;

logic clk_a_enable;
logic clk_p_enable;


assign  clk_a_enable  = dma_trigger_i ||  dma_trigger_done_i; 
assign  clk_p_enable  = pixel_trigger_i ||  pixel_trigger_done_i; 

assign  cs_n  = ~(wr_i  ||  rd_i);
assign  wr_n  = ~(wr_i);

assign  addr  = wr_n  ? addr_rd_i : addr_wr_i;

// ----------------------------------------------------
//clock switch
clk_switch clk_switch_u0(
    .clk0_rst_n(rst_n),
    .clk1_rst_n(rst_n),
    .clk0(clk_a),
    .clk1(clk_p),
    .clk0_enable(clk_a_enable),
    .clk1_enable(clk_p_enable),

    .clk(clk)
);




sram_model  sram_model_u0(
  .inst_clk(clk),
  .inst_rst_n(rst_n),
  .inst_cs_n(cs_n),
  .inst_wr_n(wr_n),
  .inst_rw_addr(addr),
  .inst_data_in(dma_data_i),
  .data_out_inst(dma_data_o)
);



endmodule

