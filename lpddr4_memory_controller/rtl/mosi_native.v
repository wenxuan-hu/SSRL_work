//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-07-12 20:07
//  Email             : huwe0427@uw.edu
//  Filename          : mosi_native.v
//  Description       : adaptor from mosi slave to native
//    port master, inside SRAM buffer for burstlength.
//    doesn't support interlaveing transfer.
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

// replace this by real memory model
`include "/home/lab.apps/vlsiapps_new/syn/R-2020.09-SP5/dw/sim_ver/DW_ram_rw_s_lat.v" 

module mosi_native(



  // ----------------------------------------------------
  // from top
  input                 rst_n,
  input                 clk,
  
  input                 clr_i,   //clear the FSM; stop transfer

  input                 enable,  //enable for this sub-module


  //input to from crossbar
	input                 cmd_ready,
	input                 cmd_first,        //dummy
	input                 wdata_ready,
	input                 rdata_valid,
	input                 rdata_first,      //dummy
	input                 rdata_last,       //dummy
	input     [255:0]     rdata_payload_data,

  //input from dla
  input     [255:0]     mosi,
  input                 mosi_valid,
  output                 mosi_ready,

  //output to dla
  output    [255:0]     miso,
  output                miso_valid,
  input                 miso_ready,

// ----------------------------------------------------
// native port slave
  //out to crossbar
	output                cmd_valid,
	output                cmd_last,       //dummy
	output                cmd_payload_we,
	output      [26:0]    cmd_payload_addr,
	output                wdata_valid,
	output                wdata_first,    //dummy
	output                wdata_last,     //dummy
	output     [255:0]    wdata_payload_data,
	output     [31:0]     wdata_payload_we,
	output                rdata_ready,
  output                mw_enable,


  // ----------------------------------------------------
  // interrupt
  output     [1:0]      irq

);

// ----------------------------------------------------
// disable the dummy signal
assign wdata_first  = 1'b1; 
assign wdata_last   = 1'b1; 
assign  mw_enable   = 1'b0;
assign  wdata_payload = 32'hffffffff; // DLA doesn't support mask write;
assign cmd_last     = 1'b0;
wire    tmn_rdata_first;
wire    tmn_rdata_last;
wire    tmn_cmd_first;
assign  tmn_rdata_first = rdata_first;
assign  tmn_rdata_last  = rdata_last;
assign  tmn_cmd_first   = cmd_first;



// template for 3rd clock gating
always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin

  end
  else  if (enable) begin
  
  end

end

// ----------------------------------------------------
// parameter define
//
parameter IDLE        = 'd0; 
parameter COMMAND     = 'd1; 
parameter WRITE       = 'd2; 
parameter READ        = 'd3; 
parameter RESP        = 'd4; 
parameter EXCP        = 'd5; 

parameter WR          = 'b10;
parameter RD          = 'b01;
parameter NONE        = 'd0;



// ----------------------------------------------------
// interface signal


// ----------------------------------------------------
// signal define  reg

reg         [255:0]   pre_buffer_data_hi;
reg         [255:0]   pre_buffer_data_lo;
reg         [255:0]   post_buffer_data_hi;
reg         [255:0]   post_buffer_data_lo;

reg         [5:0]     pre_buffer_addr_q;
reg         [5:0]     pre_buffer_addr;
reg         [5:0]     post_buffer_addr_q;
reg         [5:0]     post_buffer_addr;



reg         [1:0]     dma_drct_q;


//fsm signal
reg         [2:0]     cur_state;
reg         [2:0]     nxt_state;
reg         [5:0]     burst_len_q;
reg         [29:0]    mosi_addr_q;


//native port signal
reg         [26:0]    native_addr;

reg                   o_addr_valid;
reg                   addr_valid_toggle;   //ctrl for native port issue.
reg                   o_addr_drct;

reg                   native_command_active_q;
reg                   native_wr_active_q;
reg                   native_rd_active_q;
reg                   native_command_active;
reg                   native_wr_active;
reg                   native_rd_active;

reg                   native_rd_memory;




// ----------------------------------------------------
// signal define  wire
wire              mem_en;
wire              wr_en;
wire              rd_en;


wire         [5:0]     pre_buffer_addr_nxt;
wire         [5:0]     post_buffer_addr_nxt;

wire         [4:0]      mem_addr;


wire              fsm_update;
wire         [1:0]     dma_drct;
wire         [5:0]     burst_len;
wire         [29:0]    mosi_addr;
wire         [26:0]    native_addr_nxt;



wire              empty_flag;
wire              full_flag;


wire              i_addr_ready;
wire              native_addr_enable;
wire              native_en;
wire              native_data_ch_free;


// ----------------------------------------------------
// input data:
assign  mosi_addr = mosi[29:0];
assign  burst_len = mosi[61:56];
assign  dma_drct = mosi[63:62];


// ----------------------------------------------------
// sync FIFO based SRAM: single port 1w1r 
// for DLA, the burst length is 256 bit x 64; 
// the FIFO should be bigger than 256 bits x 64;
// reshape the FIFO to be 512 bit x 32 to make sure each beat can transfer 64 bytes
// SRAM ping-pang operation:   w_period -> r -> w -> r -> ...->



assign        men_en    =   wr_en || rd_en;
assign        mem_addr  =   wr_en ? pre_buffer_addr_q[5:1]  : post_buffer_addr_q[5:1];

DW_ram_rw_s_lat 
  #( .data_width(256),   
     .depth(64)    
  )
  mem_hi_half_word(
    .clk          ( clk         ),
    .cs_n         ( ~mem_en            ),
    .wr_n         ( ~wr_en            ),
    .rw_addr      ( mem_addr            ),
    .data_in      ( pre_buffer_data_hi            ),
    .data_out     (             )
  ); 



DW_ram_rw_s_lat 
  #( .data_width(256),   
     .depth(64)    
  )
  mem_lo_half_word(
    .clk          ( clk         ),
    .cs_n         ( ~mem_en            ),
    .wr_n         ( ~wr_en            ),
    .rw_addr      ( mem_addr            ),
    .data_in      ( pre_buffer_data_lo            ),
    .data_out     (             )
  ); 


// ----------------------------------------------------
// main FSM
// clr_i signal take charge for clear the status.
always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    cur_state <=  IDLE;
  end
  else if(clr_i)  begin
    cur_state <=  IDLE;
  end
  else  if (fsm_update) begin
    cur_state <=  nxt_state;
  end
end

assign  fsm_update  = enable && (cur_state  !=  nxt_state);


always @(*) begin : ctrl_ns_comb

  nxt_state = cur_state;
  case(cur_state)
    IDLE:   begin
      if (mosi_valid) begin
        nxt_state = COMMAND;
      end
    end
    COMMAND:  begin
      if(dma_drct_q==WR) begin
        nxt_state = WRITE;
      end
      else if(dma_drct_q==RD) begin
        nxt_state = READ;
      end
    end
    WRITE:  begin
      if(burst_len_q==pre_buffer_addr)  begin
        nxt_state = RESP;
      end
    end
    READ:  begin
      if(burst_len_q==pre_buffer_addr)  begin
        nxt_state = RESP;
      end
    end
    RESP:  begin
      if(burst_len_q==post_buffer_addr)  begin
        nxt_state = IDLE;
      end
    end
    default:  nxt_state = cur_state;
  endcase

end

// ----------------------------------------------------
// control logic

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    dma_drct_q  <=  NONE;
  end
  else  if (nxt_state==COMMAND) begin
    dma_drct_q  <=  dma_drct; 
  end
  else  if (nxt_state==IDLE) begin
    dma_drct_q  <=  NONE; 
  end
end

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    burst_len_q  <=  NONE;
  end
  else  if (nxt_state==COMMAND) begin
    burst_len_q  <=  burst_len; 
  end
  else  if (nxt_state==IDLE) begin
    burst_len_q  <=  NONE; 
  end
end

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    mosi_addr_q  <=  NONE;
  end
  else  if (nxt_state==COMMAND) begin
    mosi_addr_q  <=  mosi_addr; 
  end
  else  if (nxt_state==IDLE) begin
    mosi_addr_q  <=  NONE; 
  end
end


// ----------------------------------------------------
// write op

assign pre_buffer_addr_nxt  = pre_buffer_addr + 1'b1;
assign post_buffer_addr_nxt  = post_buffer_addr + 1'b1;

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    pre_buffer_addr <=  'd0;
  end
  else  if (nxt_state == COMMAND) begin
    pre_buffer_addr <=  'd0;
  end
  else if (nxt_state  ==  WRITE)  begin
    pre_buffer_addr <=  pre_buffer_addr_nxt;
  end
  else if (nxt_state  ==  RESP) begin
    pre_buffer_addr <=  'd0;
  end
end

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    pre_buffer_addr_q <=  'd0;
  end
  else  if (nxt_state ==  WRITE  || nxt_state  ==  RESP) begin
    pre_buffer_addr_q <=  pre_buffer_addr; 
  end

end

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    pre_buffer_data_hi  <=  'd0;
    pre_buffer_data_lo  <=  'd0;
  end
  else  if (nxt_state ==  WRITE && mosi_valid) begin
    if(pre_buffer_addr[0]) begin
      pre_buffer_data_hi  <=  mosi;
    end
    else begin
      pre_buffer_data_lo  <=  mosi;
    end
  end
end


assign  wr_en = (cur_state ==  WRITE) && (pre_buffer_addr_q[0]);

// ----------------------------------------------------
// to native port

assign  native_addr_nxt = native_addr + 'd64;



always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    native_addr <=  'd0;
  end
  else  if (cur_state ==  COMMAND) begin
    native_addr <=  mosi_addr_q;
  end
  else  if(( cur_state ==  WRITE || cur_state  ==  READ  ||  cur_state ==  RESP)  &&  (native_addr_enable)) begin
    native_addr <=  native_addr_nxt;
  end

end

assign  cmd_payload_addr  = native_addr;
assign  cmd_payload_we    = o_addr_drct;

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    o_addr_drct <=  1'b0;
  end
  else  if (dma_drct_q  ==  WR) begin
    o_addr_drct <=  1'b1;
  end
  else  if (dma_drct_q  ==  RD) begin
    o_addr_drct <=  1'b0;
  end
end

always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    o_addr_valid  <=  1'b0;
  end
  else  if (addr_valid_toggle) begin
    o_addr_valid  <=  1'b1; 
  end
  else if(cmd_ready)  begin
    o_addr_valid  <=  1'b0;
  end

end


// toggle controls valid signal
assign  native_en = (cur_state  ==  COMMAND)  ||  (cur_state  ==  WRITE)  ||  (cur_state  ==  READ)  ||  (cur_state  ==  RESP);
assign  native_data_ch_free = ;
always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    addr_valid_toggle <=  1'b0;
  end
  else  if (native_en &&  native_data_ch_free &&  (~addr_valid_toggle)  &&  (burst_len_q != post_buffer_addr)) begin
    addr_valid_toggle <=  1'b1;
  end
  else
    addr_valid_toggle <=  1'b0;
end






always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    native_wr_active  <=  1'b0;
  end
  else  if (native_command_active &&  i_addr_ready) begin
    native_wr_active  <=  1'b1; 
  end
  else if(native_data_count ==  'd2  &&  i_wdata_ready)  begin
    native_wr_active  <=  1'b0;
  end

end



assign  rd_en = native_rd_memory;
always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin

  end
  else  if (enable) begin
  
  end

end


// ----------------------------------------------------
// count for native transfer period



// ----------------------------------------------------
// native port backward pressure

assign  native_addr_enable  =  i_addr_ready  & o_addr_valid;


endmodule
