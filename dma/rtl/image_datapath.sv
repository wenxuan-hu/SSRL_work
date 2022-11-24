//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-10 09:09
//  Email             : huwe0427@uw.edu
//  Filename          : image_datapath.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************




module image_datapath(
  input aclk,
  input pclk,
  input iclk,

  input rst_n,

  input [7:0] pixel_data_i,
  input pixel_valid_i,



  output  pixel_ready_o,

  icb_interface.dut icb,
  axi_interface axi
);
// ----------------------------------------------------
logic dma_trigger;
logic dma_trigger_done;
logic pixel_trigger;
logic pixel_trigger_done;

logic dma_update;
logic dma_update_done;


logic   [`SRAM_WIDTH-1:0] mem_data_pixel;
logic   mem_wr_pixel;
logic  [8:0] mem_addr_pixel;
logic   [`SRAM_WIDTH-1:0] mem_data_axi;
logic   mem_rd_axi;
logic  [8:0] mem_addr_axi;


logic   [`SRAM_WIDTH-1:0] mem_data_axi_u0;
logic   [`SRAM_WIDTH-1:0] mem_data_axi_u1;

logic [11:0]  image_width_pixel;
logic [11:0]  image_width_axi;



logic  [`AXI_ADDR_WIDTH-1:0]  axi_addr;





// dma channel
  logic dma_addr_ready, 
  
   logic   dma_addr_valid;
   logic  [19:0] dma_len;
   logic  [`AXI_ADDR_WIDTH-1:0] dma_addr;



  logic [`SRAM_WIDTH-1:0]  dma_data;
  logic   dma_valid;
  logic   dma_ready;
  logic   dma_last;
// ----------------------------------------------------
// shadow logic
logic axi_toggle;
logic pixel_toggle;

always_ff@(posedge aclk or negedge rst_n)begin
 if(~rst_n)
   axi_toggle <=  1'b0;
  else if (dma_trigger  &&  ~dma_trigger_done)
    axi_toggle  <=  ~axi_toggle;
end


always_ff@(posedge pclk or negedge rst_n)begin
 if(~rst_n)
   pixel_toggle <=  1'b0;
  else if (pixel_trigger  &&  ~pixel_trigger_done)
    pixel_toggle  <=  ~pixel_toggle;
end

assign  mem_data_axi  = axi_toggle  ? mem_data_axi_u1 : mem_data_axi_u0;


// ----------------------------------------------------
pixel_buffer pixel_buffer_u0(
  .clk(pclk),
  .rst_n(rst_n),

  .pixel_data_i(pixel_data_i),
  .pixel_valid_i(pixel_valid_i),
  .pixel_trigger_i(pixel_trigger),
  .image_width_i(image_width_pixel),

  .pixel_trigger_done_o(pixel_trigger_done),
  .pixel_teady_o(pixel_ready_o),
  .mem_data_o(mem_data_pixel),
  .mem_wr_o(mem_wr_pixel),
  .mem_addr_o(mem_addr_pixel)
);

icb_reg icb_reg_u0(
  .clk_icb(iclk),
  .clk_axi(aclk),
  .clk_pxl(pclk),
  .rst_n(rst_n),

  .dma_trigger_done_i(dma_trigger_done),
  .pixel_trigger_done_i(pixel_trigger_done),
  .memory_width_updata_done_i(dma_update),
  .memory_width_update_o(dma_update_done),
  .dma_trigger_o(dma_trigger),
  .pixel_trigger_o(pixel_trigger),

  .image_width_clk_axi_o(image_width_axi),
  .image_width_clk_pxl_o(image_width_pixel),
  .axi_addr_o(axi_addr),
  
  .icb(.icb)
);



memory_ctrl memory_ctrl_u0(
  .clk_a(aclk),
  .clk_p(pclk),
  .rst_n(rst_n),

  .dma_trigger_i(dma_trigger),
  .pixel_trigger_i(pixel_trigger),
  .dma_trigger_done_i(dma_trigger_done),
  .pixel_trigger_done_i(pixel_trigger_done),

  .addr_rd_i(mem_addr_axi &&  ~axi_toggle),
  .addr_wr_i(mem_addr_pixel &&  ~pixel_toggle),
  .wr_i(mem_wr_pixel  &&  ~pixel_toggle),
  .rd_i(mem_rd_axi  &&  ~axi_toggle),

  .dma_data_i(mem_data_pixel),
  .dma_data_o(mem_data_axi_u0)
);


memory_ctrl memory_ctrl_u1(
  .clk_a(aclk),
  .clk_p(pclk),
  .rst_n(rst_n),

  .dma_trigger_i(dma_trigger),
  .pixel_trigger_i(pixel_trigger),
  .dma_trigger_done_i(dma_trigger_done),
  .pixel_trigger_done_i(pixel_trigger_done),

  .addr_rd_i(mem_addr_axi &&  axi_toggle),
  .addr_wr_i(mem_addr_pixel &&  pixel_toggle),
  .wr_i(mem_wr_pixel  &&  pixel_toggle),
  .rd_i(mem_rd_axi  &&  axi_toggle),

  .dma_data_i(mem_data_pixel),
  .dma_data_o(mem_data_axi_u1)
);


dmac dmac_u0(
  .clk(aclk),
  .rst_n(rst_n),
  .dma_trigger_i(dma_trigger),
  .image_width_i(image_width_axi),
  .dma_ready_i(dma_ready),
  .mem_data_i(mem_data_axi),
  .mem_rd_o(mem_rd_axi),
  .mem_addr_o(mem_addr_axi),
  .dma_trigger_done_o(dma_trigger_done),

  .dma_data_o(dma_data),
  .dma_valid_o(dma_valid),
  .dma_last_o(dma_last),

//dma command
  .dma_addr_update_i(dma_update),
  .dma_addr_i(axi_addr),
  .dma_addr_ready_i(dma_addr_ready),
  .dma_addr_valid_o(dma_addr_valid),
  .dma_addr_updata_done_o(dma_update_done),
  .dma_len_o(dma_len),
  .dma_addr_o(dma_addr)

);
// ----------------------------------------------------
// axi master instance
// axi stream slave

axi_dma_wr axi_dma_wr_u0(
    .clk(aclk),
    .rst_n(rst_n),

    .s_axis_write_desc_addr(dma_addr),
    .s_axis_write_desc_len(dma_len),
    .s_axis_write_desc_tag(8'd0),
    .s_axis_write_desc_valid(dma_addr_valid),
    .s_axis_write_desc_ready(dma_addr_ready),

    .m_axis_write_desc_status_len(),
    .m_axis_write_desc_status_tag(),
    .m_axis_write_desc_status_id(),
    .m_axis_write_desc_status_dest(),
    .m_axis_write_desc_status_user(),
    .m_axis_write_desc_status_error(),
    .m_axis_write_desc_status_valid(),



    .s_axis_write_data_tdata(dma_data),
    .s_axis_write_data_tkeep({32{1'b1}}),
    .s_axis_write_data_tvalid(dma_valid),
    .s_axis_write_data_tready(dma_ready),
    .s_axis_write_data_tlast(dma_last),
    .s_axis_write_data_tid('d0),
    .s_axis_write_data_tdest('d0),
    .s_axis_write_data_tuser('d0),


    
    .m_axi_awid(axi.aw_if.id),
    .m_axi_awaddr(axi.aw_if.addr),
    .m_axi_awlen(axi.aw_if.len),
    .m_axi_awsize(axi.aw_if.size),
    .m_axi_awburs(axi.aw_if.burst),
    .m_axi_awlock(axi.aw_if.lock),
    .m_axi_awcach(axi.aw_if.cache),
    .m_axi_awprot(axi.aw_if.prot),
    .m_axi_awvali(axi.aw_if.valid),
    .m_axi_awread(axi.aw_if.ready),
    .m_axi_wdata(axi.w_if.data),
    .m_axi_wstrb(axi.w_if.strb),
    .m_axi_wlast(axi.w_if.last),
    .m_axi_wvalid(axi.w_if.valid),
    .m_axi_wready(axi.w_if.ready),
    .m_axi_bid(axi.b_if.id),
    .m_axi_bresp(axi.b_if.resp),
    .m_axi_bvalid(axi.b_if.valid),
    .m_axi_bready(axi.b_if.ready),

    .enable(1'b1)
);


// ----------------------------------------------------
// clear lint error





endmodule
