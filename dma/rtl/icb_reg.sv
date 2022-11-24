//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-06 22:28
//  Email             : huwe0427@uw.edu
//  Filename          : icb_reg.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************




module icb_reg(
input clk_icb,
input clk_axi,
input clk_pxl,
input rst_n,


input dma_trigger_done_i,
input pixel_trigger_done_i,


input memory_width_update_done_i;
output logic  memory_width_update_o;

output logic   dma_trigger_o,
output logic   pixel_trigger_o,


output logic  [11:0] image_width_clk_axi_o,
output logic  [11:0] image_width_clk_pxl_o,
output logic  [`AXI_ADDR_WIDTH-1:0]  axi_addr_o


icb_interface.dut icb
);






logic [`ICB_WIDTH-1:0]  wdata;
logic [`ICB_WIDTH-1:0]  rdata;
logic [`ICB_WIDTH-1:0]  addr;
logic [`ICB_WIDTH-1:0]  addr_q;
logic   cmd_ready;
logic   rsp_valid;
logic   rsp_err



logic dma_trigger;
logic pixel_trigger;
logic dma_trigger_done;
logic pixel_trigger_done;



logic [11:0]  image_width;
logic [`AXI_ADDR_WIDTH-1:0]  memory_addr;
logic image_width_update_axi;
logic image_width_update_pxl;
logic image_width_update;
logic memory_width_update;
logic image_width_update_axi_done;
logic image_width_update_pxl_done;
logic memory_width_update_done;




logic   cmd_get;
logic   cmd_get_q;
logic   rsp_get;

// ----------------------------------------------------
// icb logic
assign cmd_ready  = 1'b1;    // always receive the cmd & data

assign  cmd_get = icb.icb_cmd_valid_i & cmd_ready;
assign  rsp_get = rsp_valid & icb.icb_rsp_ready_i;

assign  addr  = icb.icb_cmd_addr_i;

always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)  
    rsp_err <=  1'b0;
  else  if (cmd_get  && (addr  < reg_addr_dma_trigger   ||  addr  > reg_addr_image_width))
    rsp_err <=  1'b1;
  else  if(rsp_get)
    rsp_err <=  1'b0;
end


always_ff@(posedge or negedge rst_n)  begin
  if( rst_n)
    rsp_valid <=  1'b0;
  else if(cmd_get)
    rsp_valid <=  1'b1;
  else if(rsp_get)
    rsp_valid <=  1'b0;
end
// ----------------------------------------------------
//read

always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)  
   icb.icb_rsp_rdata  <=  'd0; 
  else  if (cmd_get  && (addr  >= reg_addr_dma_trigger   &&  addr  <= reg_addr_image_width))
      begin
        if(addr ==  reg_addr_dma_trigger)
          icb.icb_rsp_rdata  <=  `DMA_TRIGGER_MASK  & dma_trigger; 
        else if(addr ==  reg_addr_pixel_trigger)
          icb.icb_rsp_rdata  <=  `PIXEL_TRIGGER_MASK  & pixel_trigger; 
        else if(addr ==  reg_addr_mem_addr)
          icb.icb_rsp_rdata  <=  memory_addr; 
        else if(addr ==  reg_addr_image_width)
          icb.icb_rsp_rdata  <=  `IMAGE_WIDTH_MASK  & image_width; 

      end
  else  if(rsp_get)
   icb.icb_rsp_rdata  <=  'd0; 
end
// ----------------------------------------------------
//write
always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)
    dma_trigger <=  1'b0;
  else if(cmd_get && (addr ==  reg_addr_dma_trigger))
    dma_trigger <=  icb.icb_cmd_wdata[0];
  else if(dma_trigger_done)
    dma_trigger <=  1'b0;
end

always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)
    pixel_trigger <=  1'b0;
  else if(cmd_get && (addr ==  reg_addr_pixel_trigger))
    pixel_trigger <=  icb.icb_cmd_wdata[0];
  else if(dma_trigger_done)
    pixel_trigger <=  1'b0;
end


always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)  begin
    memory_width_update <=  1'b0;
    memory_addr <=  'd0;
    end
  else if(cmd_get && (addr ==  reg_addr_memory_addr))
    begin
    memory_width_update <=  1'b1;
    memory_addr <=  icb.icb_cmd_wdata;
    end
  else if(memory_width_update_done)
    memory_width_update <=  1'b0;
end

always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)
    begin
    image_width <=  'd0;
    end
  else if(cmd_get && (addr ==  reg_addr_image_width))
    begin
    image_width <=  icb.icb_cmd_wdata[11:0];
    end
end

// handshake
always_ff@(posedge clk_icb or negedge rst_n)  begin
  if(~rst_n)
    begin
    image_width_update <=  1'b0;
    end
  else if(cmd_get && (addr ==  reg_addr_image_width))
    begin
    image_width_update_axi <=  1'b1;
    end
  else if(image_width_update_axi_done &&  image_width_update_pxl_done)
    image_width_update <=  1'b0;
end

//always_ff@(posedge clk_icb or negedge rst_n)  begin
//  if(~rst_n)
//    begin
//    image_width_update_pxl <=  1'b0;
//    end
//  else if(cmd_get && (addr ==  reg_addr_image_width))
//    begin
//    image_width_update_pxl <=  1'b1;
//    end
//  else if(image_width_update_pxl_done)
//    image_width_update_pxl <=  1'b0;
//end
// ----------------------------------------------------
//CDC and control logic
always_ff@(posedge clk_axi or negedge rst_n)  begin
  if(~rst_n)
   axi_addr_o <=  'd0;
   else if(memory_width_update)
   axi_addr_o <=  memory_addr;
end

always_ff@(posedge clk_axi or negedge rst_n)  begin
  if(~rst_n)
   image_width_clk_axi_o <=  'd0;
   else if(image_width_update_axi)
   image_width_clk_axi_o <=  image_width;
end

always_ff@(posedge clk_pxl or negedge rst_n)  begin
  if(~rst_n)
   image_width_clk_pxl_o <=  'd0;
   else if(image_width_update_pxl)
   image_width_clk_pxl_o <=  image_width;
end


sync_2dff sync_dma_trigger_u0(
  .clk_1(clk_icb),
  .sig_1(dma_trigger),
  
  .rst_n(rst_n),
  .clk_2(clk_axi),
  .sig_2(dma_trigger_o)
);

sync_2dff sync_dma_trigger_u1(
  .clk_1(clk_axi),
  .sig_1(dma_trigger_done_i),
  
  .rst_n(rst_n),
  .clk_2(clk_icb),
  .sig_2(dma_trigger_done)
);



sync_2dff sync_pixel_trigger_u0(
  .clk_1(clk_icb),
  .sig_1(pixel_trigger),
  
  .rst_n(rst_n),
  .clk_2(clk_pxl),
  .sig_2(pixel_trigger_o)
);

sync_2dff sync_pixel_trigger_u1(
  .clk_1(clk_pxl),
  .sig_1(pixel_trigger_done_i),
  
  .rst_n(rst_n),
  .clk_2(clk_icb),
  .sig_2(pixel_trigger_done)
);




sync_2dff sync_memory_width_u0(
  .clk_1(clk_icb),
  .sig_1(memory_width_update),
  
  .rst_n(rst_n),
  .clk_2(clk_axi),
  .sig_2(memory_width_updata_o)
);

sync_2dff sync_memory_width_u1(
  .clk_1(clk_axi),
  .sig_1(memory_width_update_done_i),
  
  .rst_n(rst_n),
  .clk_2(clk_icb),
  .sig_2(memory_width_update_done)
);

// image size
sync_2dff sync_memory_width_u0(
  .clk_1(clk_icb),
  .sig_1(image_width_update),
  
  .rst_n(rst_n),
  .clk_2(clk_axi),
  .sig_2(image_width_update_axi)
);

sync_2dff sync_memory_width_u1(
  .clk_1(clk_axi),
  .sig_1(image_width_update_axi),
  
  .rst_n(rst_n),
  .clk_2(clk_icb),
  .sig_2(image_width_update_axi_done)
);




sync_2dff sync_memory_width_u2(
  .clk_1(clk_icb),
  .sig_1(image_width_update),
  
  .rst_n(rst_n),
  .clk_2(clk_pxl),
  .sig_2(image_width_update_pxl)
);

sync_2dff sync_memory_width_u3(
  .clk_1(clk_pxl),
  .sig_1(image_width_update_pxl),
  
  .rst_n(rst_n),
  .clk_2(clk_icb),
  .sig_2(image_width_update_pxl_done)
);



endmodule
