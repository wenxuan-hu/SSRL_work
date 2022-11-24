//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-05 05:26
//  Email             : huwe0427@uw.edu
//  Filename          : dmac.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************


//this is a dma controler, move the pixel data from sram to AXI stream master.
// we also have a dma channel from axi stream to axi4 master.
// thie module work under axi clock domain 


module dmac(
  input clk,
  input rst_n,


  input dma_trigger_i,
  input [11:0]  image_width_i,

  input dma_ready_i,

// mem
  input [`SRAM_WIDTH-1:0] mem_data_i,

// ----------------------------------------------------
// dma command
  input dma_addr_update_i,
  input [`AXI_ADDR_WIDTH-1:0] dma_addr_i,
  input dma_addr_ready_i, 
  
  output logic   dma_addr_valid_o,
  output logic   dma_addr_update_done_o
  output logic  [19:0] dma_len_o,
  output logic  [`AXI_ADDR_WIDTH-1:0] dma_addr_o,

// ----------------------------------------------------
  output logic  mem_rd_o,
  output logic   [8:0] mem_addr_o,

  output logic  dma_trigger_done_o,


  output logic [`SRAM_WIDTH-1:0]  dma_data_o,
  output logic   dma_valid_o,
  output logic   dma_last_o

);


logic [8:0] memory_depth;
logic [8:0] counter;


logic valid;
logic dma_get;
logic mem_rd;
logic mem_rd_get;



assign  dma_valid_o = valid;
assign  memory_depth  = image_width_i[11:3];


assign  mem_rd_get  = mem_rd;
assign  mem_addr_o  = counter;
assign  dma_get = valid & dma_ready_i;




// ----------------------------------------------------
always_ff@(posedge clk or negedge rst_n)begin
  if(~rst_n)
    counter <=  'd0;
  else if(~dma_trigger_i)
    counter <=  'd0;
  else if (mem_rd_get &&  counter<memory_depth)
    counter <=  counter + 1'b1;
end

always_ff@(posedge clk or negedge rst_n)  begin
  if  (~rst_n)
    dma_trigger_done_o  <=  1'b0;
  else if (~dma_trigger_i)
    dma_trigger_done_o  <=  1'b0;
  else if (dma_trigger_i  &&  counter==memory_depth)
    dma_trigger_done_o  <=  1'b1;
end

// ----------------------------------------------------

assign  mem_rd  = (dma_trigger_i  &&  counter ==  'd0)  || (counter < memory_depth  && dma_trigger_i &&     dma_ready_i ); 
assign  dma_data_o  = mem_data_i;



always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)
    valid <=  1'b0;
  else
    valid <=  mem_rd; //TODO
end

// ----------------------------------------------------
//command
always_ff @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    dma_len_o <=  'd0;
    dma_addr_o  <=  'd0;
    end
  else if (dma_addr_update_i) begin
    dma_len_o <=  image_width_i[11:3];
    dma_addr_o  <=  dma_addr_i;
    end
  else if (~dma_addr_update_i) begin
    dma_len_o <=  'd0;
    dma_addr_o  <=  'd0;
    end

end

always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    dma_addr_valid_o  <=  1'b0;
  else if(dma_addr_updata_i && ~dma_addr_update_done_o)
    dma_addr_valid_o  <=  1'b1;
  else if(dma_addr_ready_i)
    dma_addr_valid_o  <=  1'b0;
end


always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    dma_addr_update_done_o  <=  1'b0;
  else if(dma_addr_updata_i)
    dma_addr_update_done_o  <=  1'b1;
  else if(~dma_addr_update_i)
    dma_addr_update_done_o  <=  1'b0;
end



endmodule


