module  adapter_core(
input   clk,
input   enable,
input   rst_n,



input   tx_detc_i,
input   rx_detc_i,
input   tx_resp_detc_i,
input   rx_resp_detc_i,

input   tx_crd_i,
//input   rx_cmd_i,


input   tx_fifo_empty,
input   rx_fifo_empty,

input wr_fifo_wr_ready,
input wr_fifo_rd_ready,
input rd_fifo_wr_ready,
input rd_fifo_rd_ready,

input   tx_cmd_ready,
input   rx_resp_cmd_ready,
input   rx_crd_ready,



input rx_cmd_ready,
input tx_resp_cmd_ready,
input tx_crd_ready,




output  logic tx_cmd_o,
output  logic rx_cmd_o,
output  logic tx_resp_cmd_o,
output  logic rx_resp_cmd_o,

output  logic rx_crd_o,


output  logic lp_irdy_o,

output  logic [2:0] cur_state_o


);



parameter IDLE      = 'd0;
parameter WRITE     = 'd1;
parameter READ      = 'd2;
parameter WRITE_RESP      = 'd3;
parameter READ_RESP      = 'd4;

// ----------------------------------------------------
logic  [6:0]  credit_tx;
logic  [6:0]  credit_rx;


logic tx_cmd_pre;
logic rx_cmd_pre;


logic tx_crd_pre;
logic rx_crd_pre;


logic tx_cmd_get;
logic rx_cmd_get;

logic tx_crd_get;
logic rx_crd_get;


//logic tx_resp_cmd_get;
//logic rx_resp_cmd_get;

// ----------------------------------------------------
//main  FSM  for protocol layer and adapter layer control
//write: idle ->   write  -> write  respone;
//read: idle ->   read  -> read  respone;

logic  [2:0]  cur_state;
logic  [2:0]  nxt_state;





always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
    end
    else begin
    end
end
// ----------------------------------------------------
// credit


always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      credit_tx <=  'd127;
    end
    else if (cur_state  ==  IDLE)
      credit_tx <=  'd127;
    else if(tx_cmd_get  & tx_crd_get)  begin
      credit_tx <=  credit_tx;
    end
    else if(tx_cmd_get) begin
      credit_tx <=  credit_tx - 'd1;
    end
    else if(tx_crd_get) begin
      credit_tx <=  credit_tx + 'd1;
    end
end


always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      credit_rx <=  'd0;
    end
    else if (cur_state  ==  IDLE)
      credit_rx <=  'd0;
    else if(  & rx_crd_get)  begin
      credit_rx <=  credit_rx;
    end
    else if() begin
      credit_rx <=  credit_rx + 'd1;
    end
    else if(rx_crd_get) begin
      credit_rx <=  credit_rx - 'd1;
    end
end

//assign  tx_stall  = ~(|credit_tx);
//assign  rx_stall  = ~(|credit_rx);


// ----------------------------------------------------
// main fsm
always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      cur_state <=  IDLE;
    end
    else  if(cur_state  !=  nxt_state) begin
      cur_state <=  nxt_state;
    end
end

always_comb begin
  nxt_state = IDLE;
  case(cur_state)
    IDLE: begin
      if(rx_detc_i)
        nxt_state = READ;
      else  if(tx_detc_i)
        nxt_state = WRITE;
      else
        nxt_state = cur_state;
    end
    WRITE : begin
      if(tx_resp_detc_i)
        nxt_state = WRITE_RESP;
        else
          nxt_state = cur_state;
    end
    READ : begin
      if(rx_resp_detc_i)
        nxt_state = READ_RESP;
        else
          nxt_state = cur_state;
    end
    WRITE_RESP : begin
      //if(tx_resp_cmd_get)
      nxt_state = IDLE;
      //else
      //  nxt_state = cur_state;

    end
    READ_RESP : begin
      //if(rx_resp_cmd_get)
      nxt_state = IDLE;
      //else
      //  nxt_state = cur_state;

    end
    default:  begin
    nxt_state = cur_state;
    end
  endcase
end




always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      tx_cmd_pre       <=  1'b0;  
    end
    else if (cur_state  ==  WRITE)  begin
      if(~wr_fifo_rd_ready  | credit_tx=='d0) begin
        tx_cmd_pre <=  1'b0;
      end
      else  if(wr_fifo_rd_ready &&  credit_tx!= 'd0)
        tx_cmd_pre  <=  1'b1;
    end
    else
      tx_cmd_pre  <=  1'b0;
end

always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      rx_cmd_pre       <=  1'b0;  
    end
    else if (cur_state  ==  READ)  begin
      if(~rd_fifo_rd_ready ) begin
        rx_cmd_pre <=  1'b0;
      end
      else  if(rd_fifo_rd_ready)
        rx_cmd_pre  <=  1'b1;
    end
    else  
      rx_cmd_pre  <=  1'b0;
end

always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      tx_resp_cmd_o       <=  1'b0;  
    end
    else if (cur_state  ==  WRITE_RESP)  begin
      tx_resp_cmd_o <=  1'b1;
    end
    else 
      tx_resp_cmd_o  <=  1'b0;
end




always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      rx_resp_cmd_o       <=  1'b0;  
    end
    else if (cur_state  ==  READ_RESP)  begin
      rx_resp_cmd_o  <=  1'b1;
    end
    else 
      rx_resp_cmd_o  <=  1'b0;
end


assign  tx_cmd_get  = tx_cmd_o  &   tx_cmd_ready;
assign  rx_cmd_get  = tx_cmd_o  &   rx_cmd_ready;
assign  rx_crd_get  = rx_crd_o  &   rx_crd_ready;
assign  tx_crd_get  = tx_crd_i  ;

always_comb begin
    tx_cmd_o       =  tx_cmd_pre  & wr_fifo_rd_ready;
    rx_cmd_o       =  rx_cmd_pre  & rd_fifo_rd_ready;
    //tx_crd_o       =  tx_cmd_pre  & wr_fifo_rd_ready;
    rx_crd_o       =  rx_crd_pre  & (|credit_rx);
end


assign  lp_irdy_o = (cur_state  ==  WRITE);
// ----------------------------------------------------
//credit logic
always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
      rx_crd_pre  <=  1'b0;
    end
    else  if(credit_rx  ==  'd0) begin
      rx_crd_pre  <=  1'b0;
    end
    else if(credit_rx > 'd0)  begin
      rx_crd_pre  <=  1'b1;
    end
end
// ----------------------------------------------------





// ----------------------------------------------------
assign  cur_state_o = cur_state;

endmodule
