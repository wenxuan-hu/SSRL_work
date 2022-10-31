//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-05 22:50
//  Email             : huwe0427@uw.edu
//  Filename          : mosi_native.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



module mosi_native(
  input clk_i,
  input rst_n,
  input enable,


  input clr_i,            //clear exception status, this signal is from top control
  //output  logic irq,      // require for interrupt. only one exception: invalid burst length
  output  logic [1:0] irq,      // require for interrupt. irq[0]: invalid burst length;  irq[1]: invalid address

  mosi_interface.dut  mosi,
  dma_native_interface.dut   native

);
//parameter
parameter IDLE        = 'd0; 
parameter COMMAND     = 'd1; 
parameter WRITE       = 'd2; 
parameter READ        = 'd3; 
parameter RESP        = 'd4; 
parameter EXCP        = 'd5; 

// ----------------------------------------------------
// interface




// ----------------------------------------------------
//signal defines

logic   clk;

logic   [2:0] cur_state;
logic   [2:0] nxt_state;



//conctrl
logic  cmd_detc; 
logic   mosi_ready;
logic   miso_valid;

logic   fifo_ready_r;
logic   fifo_ready_w;
logic   fifo_r;
logic   fifo_w;



//data
logic [`DLA_CMD_FIELD]  dla_cmd;

logic [MOSI_DATA_W-1:0] miso_data;


logic [7:0]        cmd_counter;
logic [1:0]     dla_drt;
logic [`DLA_ADDR_FIELD]     dla_addr;
logic [8:0]     dla_len;
logic [8:0]        cur_len;
logic [`DDR_ADDR_FIELD]        cur_addr;


logic     [DDR_DATA_W-1:0]        wdata_payload_data; 
logic     [DDR_MASK_W-1:0]        wdata_payload_we; 
logic     [DDR_ADDR_W-1:0]        ncmd_payload_addr; 
logic           ncmd_valid  ;
logic           ncmd_payload_we  ;
logic           ncmd_payload_mw  ;

logic           wdata_valid ;
logic           rdata_ready ;


logic           native_cmd_get;
logic           native_data_get;
logic           native_data_put;





logic [MOSI_DATA_W-1:0] mosi_data;
logic [MOSI_DATA_W-1:0] wdata_data;
logic [MOSI_DATA_W-1:0] rdata_data;
logic [MOSI_DATA_W-1:0] fifo_data_r;
logic [MOSI_DATA_W-1:0] fifo_data_w;

logic mosi_w;
logic miso_r;

logic wdata_r;
logic wdata_r_q;
logic rdata_w;


logic [MOSI_DATA_W*2-1:0] wr_buffer;
logic [MOSI_DATA_W*2-1:0] rd_buffer;
logic [1:0]  wr_buffer_pipe;
logic [1:0]  rd_buffer_pipe;



//write done logic
// miso signal must be asserted after a write burst as done signal
logic write_done;



// ----------------------------------------------------
//clock gate
clk_gate  clk_gate_inst(

  .cp(clk_i),
  .te(1'b0),
  .enable(enable),
  .q(clk)

);

// ----------------------------------------------------
// sync FIFO based SRAM: single port 1w1r 
// for DLA, the burst length is 256 bit x 64; 
// the FIFO should be bigger than 256 bits x 64;
// reshape the FIFO to be 512 bit x 32 to make sure each beat can transfer 64 bytes
// SRAM ping-pang operation:   w_period -> r -> w -> r -> ...->

// ping-pang op: pre_buffer_addr_q[0]== 1'b1 -> write
// ping-pang op: pre_buffer_addr_q[0]== 1'b0 -> read

// ----------------------------------------------------
// 2 exceptions: 
//    1.  invalid burst length, this will force fsm into excp status and assert irq
//    2.  during transfer, timeout error.  this need to be deteced and cleared by top control and will not
//    assert irq.
//TODO   length are not consistant.   length=len+1


// template for 3rd clock gating
always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin

  end
  else  if (enable) begin
  
  end

end


// ----------------------------------------------------
//sync_fifo
sync_fifo fifo_inst(
    .clk_i          (clk),
    .rst_n          (rst_n  & ~clr_i),
    .enable         (enable),
    .data_i         (fifo_data_w),
    .wr_i           (fifo_w),
    .rd_i           (fifo_r),
    
    .data_o         (fifo_data_r),
    .wr_ready_o     (fifo_ready_w),
    .rd_ready_o     (fifo_ready_r),
    .buf_bal_o      (),
    .empty_o        (),
    .full_o         ()

);

// ----------------------------------------------------
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
      if(cmd_detc)
        nxt_state = COMMAND;
      else
        nxt_state = cur_state;
    end
    COMMAND : begin
      if(dla_len[0] || (&dla_addr[5:0]))      //TODO
        nxt_state = EXCP;
      else if(dla_drt ==  DLA_WRITE)
        nxt_state = WRITE;
      else if(dla_drt ==  DLA_READ)
        nxt_state = READ;
        else
          nxt_state = cur_state;
    end
    READ : begin
      if(cur_len==dla_len)
        nxt_state = IDLE;
        else
          nxt_state = cur_state;
    end
    WRITE : begin
      if(cur_len==dla_len)
      nxt_state = IDLE;
      else
        nxt_state = cur_state;

    end
    EXCP : begin
      if(clr_i)
      nxt_state = IDLE;
      else
        nxt_state = cur_state;

    end
    default:  begin
    nxt_state = cur_state;
    end
  endcase
end

// ----------------------------------------------------
assign  cmd_detc  = mosi.mosi_valid_i  & mosi_ready; 
always_ff @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
    dla_drt   <=  'd0;
    dla_addr  <=  'd0;
    dla_len   <=  'd0;
    end
    else if(cur_state ==  IDLE &&   cmd_detc )  begin
    dla_drt   <=  mosi.mosi_data_i[`DRT_FIELD];
    dla_addr  <=  mosi.mosi_data_i[`DLA_ADDR_FIELD];
    dla_len   <=  mosi.mosi_data_i[`BURST_LEN_FIELD]+'d1;
    end
end

//always_ff @(posedge clk or negedge rst_n)  begin
//  if(~rst_n)  begin
//      mosi_data <= 'd0;
//  end
//  else  if (cur_state ==  COMMAND || cur_state  ==  WRITE ) begin
//      mosi_data <= mosi.mosi_data_i;
//  end
//end


always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
      mosi_data <= 'd0;
  end
  else  if ((cur_state ==  COMMAND || cur_state  ==  WRITE ) &&(mosi.mosi_valid_i  & mosi_ready))begin
      mosi_data <= mosi.mosi_data_i;
  end
end


always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
      mosi_w <= 'd0;
  end
  else  if ((cur_state ==  COMMAND || cur_state  ==  WRITE ) &&(mosi.mosi_valid_i  & mosi_ready))begin
      mosi_w <= 'd1;
  end
  else
      mosi_w <= 'd0;
end

// write burst done logic
always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n)
      write_done  <=  1'b0;
    else if((cur_state == WRITE)  &&(cur_len  ==  dla_len))
      write_done  <=  1'b1;
    else  if (write_done)
      write_done  <=  1'b0;
end

always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
   cur_len  <=  'd0;   
  end
  else  if ((cur_state ==  COMMAND || cur_state  ==  READ ) &&(mosi.miso_ready_i  & miso_valid))begin
   cur_len  <=  cur_len + 'd1;   
   end
  else  if ((cur_state ==  COMMAND || cur_state  ==  WRITE ) &&(native.wdata_ready_i  & wdata_valid))begin
   cur_len  <=  cur_len + 'd1;   
  end 
  else  if (cur_state ==  IDLE )
   cur_len  <=  'd0;   
end

// NOTE:  dla address: Bytes ,    ddr address: burst

// each beat -> 256 btis -> 32 Bytes
// each burst -> 2 words 512 bits -> 64Bytes
always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    cur_addr  <=  'd0;
  end
  else if(cur_state == COMMAND) begin
    //cur_addr  <=  dla_addr[DDR_ADDR_W-1:0];
    cur_addr  <=  {2'b00, dla_addr[DLA_ADDR_W-1:6]};
  end
  else  if ((cur_state  ==  WRITE ) &&(native.ncmd_ready_i  & ncmd_valid)) begin
    //cur_addr  <=  cur_addr  + 'd64;
    cur_addr  <=  cur_addr  + 'd1;
  end
  else  if ((cur_state  ==  READ ) &&(native.ncmd_ready_i  & ncmd_valid)) begin
    //cur_addr  <=  cur_addr  + 'd64;
    cur_addr  <=  cur_addr  + 'd1;
  end
  else if(cur_state == IDLE) begin
    cur_addr  <=  'd0;
  end
end



always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    ncmd_payload_mw  <=  'd0;
    ncmd_payload_we  <=  'd0;
  end
  else if(cur_state == COMMAND  && dla_drt  ==  DLA_WRITE) begin
    ncmd_payload_mw  <=  'd0;
    ncmd_payload_we  <=  'd1;
  end
  else if(cur_state == COMMAND  && dla_drt  ==  DLA_READ) begin
    ncmd_payload_mw  <=  'd0;
    ncmd_payload_we  <=  'd0;
  end
  else if(cur_state == IDLE) begin
    ncmd_payload_mw  <=  'd0;
    ncmd_payload_we  <=  'd0;
  end
end

// send ddr command/ valid
always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    ncmd_valid  <=  'd0;
    cmd_counter <=  'd0;
  end
  else if(cur_state == COMMAND) begin
    ncmd_valid  <=  'd1;
    cmd_counter <=  'd1;
  end
  else  if ((cur_state  ==  WRITE ) &&(cmd_counter  < dla_len[8:1]) &&  (native.ncmd_ready_i)) begin
    ncmd_valid  <=  'd1;
    cmd_counter <=  cmd_counter + 'd1;
  end
  else  if ((cur_state  ==  READ ) &&(cmd_counter  < dla_len[8:1])  &&(native.ncmd_ready_i)) begin
    ncmd_valid  <=  'd1;
    cmd_counter <=  cmd_counter + 'd1;
  end
  else if(cur_state == IDLE) begin
    ncmd_valid  <=  'd0;
    cmd_counter <=  'd0;
  end
  else if (cmd_counter ==  dla_len[8:1]  &&  (native.ncmd_ready_i)) begin
    ncmd_valid  <=  'd0;
    end
end


//always_ff @(posedge clk or negedge rst_n)  begin
//  if(~rst_n)  begin
//    wdata_r <=  1'b0;
//  end
//  else  if ((cur_state ==  WRITE) && fifo_ready_r   && ( ~&wr_buffer_pipe  ))begin
//    wdata_r <=  1'b1;
//  end
//  else
//    wdata_r <=  1'b0;
//end
always_comb  begin
    if(~rst_n)
      wdata_r = 1'b0;
  else  if ((cur_state ==  WRITE) && fifo_ready_r   && (( ~&wr_buffer_pipe  )|| native.wdata_ready_i ))
    wdata_r =  1'b1;
  else
    wdata_r =  1'b0;
end

//always_ff @(posedge clk or negedge rst_n)  begin
//  if(~rst_n)  begin
//    wr_buffer <=  'd0;
//  end
//  else  if (wdata_r && fifo_ready_r &&  ~wr_buffer_pipe[0])begin
//    wr_buffer[MOSI_DATA_W-1:0] <=  fifo_data_r;
//  end
//  else  if (wdata_r && fifo_ready_r &&  ~wr_buffer_pipe[1])begin
//    wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W] <=  fifo_data_r;
//  end
//  else  if (wdata_r && fifo_ready_r && native.wdata_ready_i)begin
//    wr_buffer[MOSI_DATA_W-1:0] <=  fifo_data_r;
//  end
//end
always_ff @ (posedge clk or negedge rst_n)  begin
  if  (~rst_n)
    wdata_r_q <=  1'b0;
  else
    wdata_r_q <=  wdata_r;
end

always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    wr_buffer <=  'd0;
  end
  else  if (wdata_r)begin
    wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W] <=  fifo_data_r;
      if(~wr_buffer_pipe[0])
     wr_buffer[MOSI_DATA_W-1:0] <=  wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W];
      else if(native.wdata_ready_i)
     wr_buffer[MOSI_DATA_W-1:0] <=  wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W];
  end
  else if (~wr_buffer_pipe[0] || native.wdata_ready_i) 
     wr_buffer[MOSI_DATA_W-1:0] <=  wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W];
end


//always_ff @(posedge clk or negedge rst_n)  begin
//  if(~rst_n)  begin
//    wr_buffer_pipe <=  2'b00;
//  end
//  else  if (wdata_r && fifo_ready_r &&  ~wr_buffer_pipe[0])begin
//    wr_buffer_pipe[0] <=  1'b1;
//    if(native.wdata_ready_i)
//    wr_buffer_pipe[1] <=  1'b0;
//  end
//  else  if (wdata_r && fifo_ready_r &&  ~wr_buffer_pipe[1])begin
//    wr_buffer_pipe[1] <=  1'b1;
//  end
//  else  if (wdata_r && fifo_ready_r && native.wdata_ready_i)begin
//    wr_buffer_pipe[0] <=  1'b0;
//  end
//  else  if ( native.wdata_ready_i && wr_buffer_pipe[0] )begin
//    wr_buffer_pipe[0] <=  1'b0;
//  end
//  else  if ( native.wdata_ready_i && wr_buffer_pipe[1] )begin
//    wr_buffer_pipe[1] <=  1'b0;
//  end
//  else  if(cur_state==IDLE)begin
//    wr_buffer_pipe <=  2'b00;
//  end
//end

always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    wr_buffer_pipe <=  2'b00;
  end
  else  if (wdata_r)begin
    wr_buffer_pipe[1] <=  1'b1;
    if(native.wdata_ready_i || ~wr_buffer_pipe[0])
    wr_buffer_pipe[0] <=  wr_buffer_pipe[1];
  end
  else  if (native.wdata_ready_i ||  ~wr_buffer_pipe[0])begin
    wr_buffer_pipe[0] <=  wr_buffer_pipe[1];
  end
  else  if(cur_state==IDLE)begin
    wr_buffer_pipe <=  2'b00;
  end
end


// ----------------------------------------------------
always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    miso_data <=  'd0;
  end
  else  if (cur_state ==  READ  &&    fifo_ready_r  &&  miso_r) begin
    miso_data <=  fifo_data_r;
  end
  else  if (cur_state ==  IDLE) begin
    miso_data <=  'd0;
  end

end


always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    miso_valid <=  1'b0;
  end
  else  if (cur_state ==  READ  &&    fifo_ready_r  &&  miso_r) begin
    miso_valid <=  1'b1;
  end
  else   begin
    miso_valid <=  1'b0;
  end

end



always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    miso_r <=  1'b0;
  end
  else  if (cur_state ==  READ  &&    fifo_ready_r ) begin
    miso_r <=  1'b1;
  end
  else   begin
    miso_r <=  1'b0;
  end

end


// ----------------------------------------------------
// irq[0]: invalid brust length; irq[1]: invalid  andress
always_ff @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    irq <=  2'b0;
  end
  else  if (cur_state== EXCP) begin
      if(dla_len[0])
        irq[0] <=  1'b1;
      if(&dla_addr[5:0])
        irq[1] <=  1'b1;
  end
  else  if(clr_i)
    irq <=  2'b0;
end


// ----------------------------------------------------
//signal connection
assign  mosi.mosi_ready_o  = mosi_ready;
//assign  mosi.miso_valid_o  = miso_valid;
assign  mosi.miso_valid_o  = miso_valid | write_done;   //add done signal
assign  mosi.miso_data_o   = miso_data;



assign       native.wdata_payload_data_o       =                   wdata_payload_data;      
assign       native.wdata_payload_we_o         =                   wdata_payload_we  ;    
assign       native.ncmd_payload_addr_o        =                   ncmd_payload_addr ;    
assign       native.ncmd_valid_o               =                   ncmd_valid        ;  
assign       native.ncmd_payload_we_o          =                   ncmd_payload_we   ;    
assign       native.ncmd_payload_mw_o          =                   ncmd_payload_mw   ; 
assign       native.wdata_valid_o              =                   wdata_valid       ;  
assign       native.rdata_ready_o              =                   rdata_ready       ;    

assign      fifo_data_w = (dla_drt  ==  DLA_WRITE)    ?     mosi_data :   rdata_data; 
assign      fifo_w  = mosi_w  | rdata_w; 
assign      fifo_r  = (wdata_r  &&  (~&wr_buffer_pipe   || native.wdata_ready_i)) | miso_r;


assign  mosi_ready  =  fifo_ready_w;


assign  native_data_put = wdata_valid & native.wdata_ready_i;
assign  native_data_get = rdata_ready & native.rdata_valid_i;
assign  native_cmd_get =  ncmd_valid  & native.ncmd_ready_i;

assign  ncmd_payload_addr = cur_addr;

//assign  wdata_valid = wr_buffer_pipe[1];
assign  wdata_valid = wr_buffer_pipe[0];
assign  rdata_ready = fifo_ready_w;


assign  rdata_w = native.rdata_valid_i;


//assign  wdata_payload_data  = wr_buffer_pipe[0] ? wr_buffer[MOSI_DATA_W-1:0]  : wr_buffer[MOSI_DATA_W*2-1:MOSI_DATA_W] ;
assign  wdata_payload_data  = wr_buffer[MOSI_DATA_W-1:0];
assign  wdata_payload_we  = {32{1'b1}};

assign  rdata_data  = native.rdata_payload_data_i;

endmodule
