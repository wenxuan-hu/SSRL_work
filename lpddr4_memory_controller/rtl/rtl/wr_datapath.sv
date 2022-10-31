//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-23 20:47
//  Email             : huwe0427@uw.edu
//  Filename          : wr_datapath.sv
//  Description       : write datapath, from fifo to rdi
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************
module  wr_datapath(
  input clk,
  input rst_n,
  input enable,

  input tx_cmd_i, 
  input rx_resp_cmd_i,
  input rx_crd_i,

  input [DLA_DATA_W-1:0]  fifo_data_i,


  input       lp_irdy_i,
  
 // ---------------------------------------------------- 
 // rdi io
  input           pl_trdy,

  output  logic   [NBYTES*8-1:0]  lp_data,
  output  logic   lp_irdy,
  output  logic   lp_valid,
// ----------------------------------------------------


output logic   tx_cmd_ready,
output logic   rx_resp_ready,
output logic   rx_crd_ready



);
  



// ----------------------------------------------------
//signal define


logic   tx_cmd_q;
logic   rx_resp_cmd_q;
logic   rx_crd_q;


logic [1:0] buf_full_tx;
logic [1:0] buf_full_crd;

logic lp_valid_tx;
logic lp_valid_crd;
logic lp_valid_resp;


logic  [NBYTES*8-1:0]  lp_data_tx;
logic  [NBYTES*8-1:0]  lp_data_crd;
logic  [NBYTES*8-1:0]  lp_data_resp;









// ----------------------------------------------------

assign  tx_cmd_ready  = pl_trdy | ~buf_full_tx[1] | ~buf_full_tx[0];

always_ff  @(posedge clk or negedge rst_n) begin
  if( ~rst_n) begin
    buf_full_tx[1]  <=  1'b0;
    tx_cmd_q  <=  1'b0;
  end
  else if(tx_cmd_i  & (pl_trdy | ~buf_full_tx[1] | ~buf_full_tx[0] )) begin
    tx_cmd_q  <=  tx_cmd_i;
    buf_full_tx[1] <=  1'b1;
  end
  else if(~tx_cmd_i  & (pl_trdy | ~buf_full_tx[0]) ) begin    //TODO
    tx_cmd_q  <=  1'b0;
    buf_full_tx[1] <=  1'b0;
  end
end



  assign  lp_irdy = lp_irdy_i | lp_valid;

always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)begin

    lp_valid_tx  <=  1'b0;
    lp_data_tx <=  'd0;
    buf_full_tx[0] <=  1'b0;
  end
  else  if(tx_cmd_q & (pl_trdy  | (~buf_full_tx[0])))  begin
    lp_data_tx <=  {{fifo_data_i,  5'b00000},  {15{8'b00000000}}};
    lp_valid_tx  <=  1'b1;
    buf_full_tx[0] <=  1'b1;
  end
  else  if( (~tx_cmd_q)  & pl_trdy)  begin
    lp_data_tx <=  'd0;
    lp_valid_tx <=  1'b0;
    buf_full_tx[0]  <=  1'b0;
  end

end


// ----------------------------------------------------
assign  rx_crd_ready  =   pl_trdy  |  ~buf_full_crd[1] | ~buf_full_crd[0]; 
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
    buf_full_crd[1]  <=  1'b0;
    rx_crd_q  <=  1'b0;
  end
  else  if(rx_crd_i  &  (pl_trdy  |  ~buf_full_crd[1] | ~buf_full_crd[0]) )  begin
    buf_full_crd[1] <=  1'b1;
    rx_crd_q  <=  1'b1;
  end
  else if(~rx_crd_i & pl_trdy| ~buf_full_crd[0]) begin
    rx_crd_q  <=  1'b0;
    buf_full_crd[1] <=  1'b0;
    end
end


always_ff @(posedge clk or negedge  rst_n)  begin
  if(~rst_n)  begin
    lp_valid_crd  <=  1'b0;
    lp_data_crd <=  'd0;
    buf_full_crd[0] <=  1'b0;
    end
    else if (rx_crd_q & (pl_trdy  | ~buf_full_crd[0]))  begin
      lp_valid_crd  <=  1'b1;
      lp_data_crd <=  CRD_BIT_MASK;
      buf_full_crd[0] <=  1'b1;
      end
    else  if(~rx_crd_q  & pl_trdy)  begin
      lp_valid_crd  <=  1'b0;
      lp_data_crd <=  'd0;
      buf_full_crd[0] <=  1'b0;
      end
end
// ----------------------------------------------------

assign  = rx_resp_ready = ~lp_valid_resp; 


always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    lp_valid_resp  <=  1'b0;
    lp_data_resp <=  'd0;
    end
  else  if(rx_resp_cmd_i)begin
    lp_valid_resp <=  1'b1;
    lp_data_resp  <=  ALCT_BIT_MASK;
  end
  else  if( lp_valid_resp & pl_trdy) begin
    lp_valid_resp <=  1'b0;
    lp_data_resp  <=  'd0;

    end
end

// ----------------------------------------------------
assign  lp_valid  = lp_valid_resp | lp_valid_crd  | lp_valid_rx;
assign  lp_data = lp_data_resp   |lp_data_crd|  lp_data_rx; 


endmodule
