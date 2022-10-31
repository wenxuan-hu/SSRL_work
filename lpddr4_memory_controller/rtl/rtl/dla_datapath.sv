//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-09-10 23:22
//  Email             : huwe0427@uw.edu
//  Filename          : dla_datapath.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************




module  dla_datapath(
input   clk,
input   rst_n,
input   enable,

// ----------------------------------------------------
//dla
input [DLA_DATA_W-1:0]  dla_data_i,
input   dla_valid_i,
input   dla_ready_i,
input   dla_allocatable_i,





// ----------------------------------------------------
input [2:0] cur_state_i,

input       tx_resp_cmd_i,
input       rx_cmd_i,
// ----------------------------------------------------
// fifo
input   [DLA_DATA_W-1:0]  rd_fifo_data_i,
input     wr_fifo_wr_ready_i,
input     rd_fifo_rd_ready_i,




// ----------------------------------------------------
//dla
output  logic [DLA_DATA_W-1:0]  dla_data_o,
output  logic       dla_valid_o,
output  logic       dla_ready_o,
output  logic       dla_allocatable_o,

// ----------------------------------------------------
output  logic tx_detc_o,
output  logic rx_resp_detc_o,

output  logic rx_cmd_ready_o,

// ----------------------------------------------------
//fifo
output  logic [DLA_DAT_W-1:0]   wr_fifo_data_o,

output  logic   wr_fifo_wr_o,
output  logic   rd_fifo_rd_o,


);

// ----------------------------------------------------
//signal 
parameter IDLE      = 'd0;
parameter WRITE     = 'd1;
parameter READ      = 'd2;
parameter WRITE_RESP      = 'd3;
parameter READ_RESP      = 'd4;

logic rd_buf[1:0];      // bit 1 for fifo output, bit 0 for dla_data

// ----------------------------------------------------
//read
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
    rx_resp_detc_o  <=  1'b0;
  end
  else if (dla_allocatable_i)begin
    rx_resp_detc_o  <=  1'b1;
    end
  else begin
    rx_resp_detc_o  <=  1'b1;
    end
end


always_ff@  (posedge clk or negedge rst_n)  begin
  if(~rst_n) begin
    dla_data_o  <=  'd0;
    end
  else if(dla_ready_i &&  ( )  )begin
    dla_data_o  <=  rd_fifo_data_i;
    end
end


always_ff@  (posedge clk or negedge rst_n)  begin
  if(~rst_n) begin
    dla_valid_o  <=  'd0;
    end

end

always_comb begin
  
end

// ----------------------------------------------------
//write

always_comb begin
dla_ready_o = wr_fifo_wr_ready_i;
end


always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    wr_fifo_wr_o  <=  1'b0;
    end
  else if(dla_valid_i & wr_fifo_wr_ready_i)  begin
    wr_fifo_wr_o  <=  1'b1;
    end
  else begin
    wr_fifo_wr_o  <=  1'b0;
    end
end


always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    wr_fifo_data_o  <=  'd0;
    end
  else if(dla_valid_i & wr_fifo_wr_ready_i)  begin
    wr_fifo_data_o  <=  'd0;
    end
end

always_ff@(posedge clk or negedge rst_n)  begin
  if(rst_n) begin
    tx_detc_o <=  1'b0;
    end
  else if(cur_state_i == IDLE && dla_valid_i ) begin
    tx_dect_o <=  1'b1;
  end
  else begin
    tx_detc_o <=  1'b0;
  end
end


// response
always_ff@(posedge clk or negedge rst_n)  begin
  if(rst_n) begin
    dla_allocatable_o <=  1'b0;
    end
  else if(rx_resp_cmd_i)begin
    dla_allocatable_o <=  1'b1;
    end
  else begin
    dla_allocatable_o <=  1'b0;
    end
end



endmodule
