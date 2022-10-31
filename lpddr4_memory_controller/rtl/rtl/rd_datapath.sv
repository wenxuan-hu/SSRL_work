//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-09-10 03:49
//  Email             : huwe0427@uw.edu
//  Filename          : rd_datapath.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************
module  rd_datapath(
input   clk,
input   rst_n,
input   enable,



input [2:0] cur_state_i,

// ----------------------------------------------------
//fifo_io
//input   fifo_wr_rdy_i,
//input   rx_resp_detc_i,
//input   rx_done,      //all read op trans done: 1. all credit trans done.






// ----------------------------------------------------
//rdi_io
input   [NBYTES*8-1:0]  pl_data,
input     pl_valid,





// ----------------------------------------------------
// fifo_io
output logic [DLA_DATA_W-1:0]  fifo_data_o,
output logic fifo_wr_vld_o,


output  logic rx_detc_o,
output  logic tx_crd_o,
output  logic tx_resp_detc_o 




);




// ----------------------------------------------------
//signal define
parameter IDLE      = 'd0;
parameter WRITE     = 'd1;
parameter READ      = 'd2;
parameter WRITE_RESP      = 'd3;
parameter READ_RESP      = 'd4;


logic [NBYTES*8-1:0] pl_data_receive;



// ----------------------------------------------------
// data from ucie rdi to fifo
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
      pl_data_receive   <=  'd0;
    end
  else  if(pl_valid )  begin
      pl_data_receive   <=  pl_data;
    end
end




always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
      fifo_wr_vld_o <=  1'b0;
    end
  else if(pl_valid  && (cur_state_i  ==  IDEL ||cur_state_i  ==  READ)) begin
    fifo_wr_vald_o  <=  1'b1;
    end
  else  begin
    fifo_wr_vald_o  <=  1'b0;
    end

end

always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    rx_detc_o   <=  1'b0;
    end
  else if((cur_state_i ==  IDEL) && pl_valid) begin
    rx_detx_o <=  1'b1;
    end
  else begin
    rx_detx_o   <=  1'b0;
    end
end


// ----------------------------------------------------
// master receive the plcredit from ucie rdi and update the control core
always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
      tx_crd_o  <=  1'b0;
    end
  //else if(cur_state_i==WRITE  &&  pl_valid) begin
  else if(pl_valid) begin
      tx_crd_o  <=  (pl_data[`UCIE_CTRL_FIELD]  ==  CRD_BIT_MASK_B);
    end
  else begin
      tx_crd_o  <=  1'b0;
    end
end


// ----------------------------------------------------
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
    tx_resp_detc_o  <=  1'b0;
    end
  //else if(cur_state_i ==  WRITE  &&  pl_valid) begin
  else if(pl_valid) begin
    tx_resp_detc_o  <=  (pl_data[`UCIE_CTRL_FIELD]  ==  ALCT_BIT_MASK_B);
    end
  else  begin
    tx_resp_detc_o  <=  1'b0;
    end

end


assign  fifo_data_o =   pl_data_receive[`UCIE_DATA_FIELD];


endmodule
