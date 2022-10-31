//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-27 07:17
//  Email             : huwe0427@uw.edu
//  Filename          : sync_fifo.v
//  Description       :sync_fifo based on 1w1r sram, ping-pong schedule
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************




module  sync_fifo(
// ----------------------------------------------------
// ctrl
  input clk_i,
  input rst_n,
  input enable,


// ----------------------------------------------------
// data/ addr
  input [DDR_DATA_W-1:0]  data_i,
  //input [FIFO_ADDR_W-1:0] wr_addr,
  //input [FIFO_ADDR_W-1:0] rd_addr,
  
  input   wr_i,  
  input   rd_i,  
    
    
    
    
    
  
  output  reg [DDR_DATA_W-1:0]  data_o,
  output  wire  wr_ready_o,
  output  wire  rd_ready_o,

  output  reg [FIFO_ADDR_W*2:0]  buf_bal_o,

  output  reg empty_o,
  output  reg full_o



);
// ----------------------------------------------------
parameter TRUE  = 1'b1;
parameter FALSE = 1'b0;
// -----------------------------------------------------
// signal define
wire  clk;


wire   [DDR_DATA_W*2-1:0]  ram_data_in;
wire   [DDR_DATA_W*2-1:0]  ram_data_out;



reg   [FIFO_ADDR_W:0] wr_addr;
reg   [FIFO_ADDR_W:0] rd_addr;
wire  [FIFO_ADDR_W:0] ram_addr;






reg   [DDR_DATA_W-1:0]  data_i_d1;
reg   [DDR_DATA_W-1:0]  data_i_d2;
//reg   [DLA_DATA_W-1:0]  data_i_d3;

reg   [DDR_DATA_W-1:0]  pre_data_o_d1;
reg   [DDR_DATA_W-1:0]  pre_data_o_d2;
reg   [DDR_DATA_W-1:0]  pre_data_o_d3;

reg   [1:0]             wr_pipe;
reg   [2:0]             rd_pipe;

reg      wr_en_q;
reg      rd_en_q;

wire     wr_en;
wire     rd_en;

reg     wr_ready;
reg     rd_ready;

wire    pre_full;
wire    pre_empty;


wire  except_case;

assign  wr_ready_o  = wr_ready;
assign  rd_ready_o  = rd_ready;

assign  pre_empty = (wr_addr  ==  rd_addr)  &&  (wr_pipe ==  2'b00)  && (rd_pipe  ==  3'b000);
//assign  pre_empty = (wr_addr  ==  rd_addr)  && (rd_pipe  ==  3'b000);
assign  pre_full  = ( wr_addr[FIFO_ADDR_W] !=  rd_addr[FIFO_ADDR_W])  &&  (wr_addr[FIFO_ADDR_W-1:0] ==  rd_addr[FIFO_ADDR_W-1:0]);

assign  except_case = (rd_pipe==3'b000)&&(wr_en_q ||  rd_en_q);



always  @(posedge clk or negedge rst_n) begin
  if(~rst_n)  begin
    wr_ready  <=  TRUE;
  end
  else if(pre_full) begin
    wr_ready  <=  FALSE;
  end
  else begin
    wr_ready  <=  TRUE;
  end
end

// ----------------------------------------------------
//  use combinational logic to generate rd_ready; no delay!!
always  @(*)  begin
  rd_ready  =  FALSE;
  if  (~rst_n)
    rd_ready  = FALSE;
  else  if(~(pre_empty||except_case))
    rd_ready  = TRUE;
  else
    rd_ready  = FALSE;
end


// ----------------------------------------------------
//always  @(posedge clk or negedge rst_n) begin
//  if(~rst_n)  begin
//    rd_ready  <=  FALSE;
//  end
//  else if(~pre_empty) begin
//    rd_ready  <=  TRUE;
//  end
//  else begin
//    rd_ready  <=  FALSE;
//  end
//end



always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    buf_bal_o <=  FIFO_DEPTH+'d5;
  end
  else  if  ((wr_ready & wr_i)  & ~(rd_ready & rd_i ))  begin
    buf_bal_o <=  buf_bal_o - 1'b1;
  end
  else  if  (~(wr_ready & wr_i)  & (rd_ready & rd_i ))  begin
    buf_bal_o <=  buf_bal_o + 1'b1;
  end

end


always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    empty_o <=  TRUE;
  end
  else  if((wr_addr  ==  rd_addr)  &&  (wr_pipe ==  2'b00)  &&(rd_pipe  ==  3'b000))
    empty_o <=  TRUE;
    else
      empty_o <=  FALSE;
end

always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    full_o <=  FALSE;
  end
  else  if(( wr_addr[FIFO_ADDR_W] !=  rd_addr[FIFO_ADDR_W])  &&  (wr_addr[FIFO_ADDR_W-1:0] ==  rd_addr[FIFO_ADDR_W-1:0]))
    full_o  <=  TRUE;
  else
    full_o  <=  FALSE;
end

// ----------------------------------------------------
// data path
// data_i->d1->d2
always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    data_i_d1 <=  'd0;
    data_i_d2 <=  'd0;
    //data_i_d3 <=  'd0;
  end
  else  if  (wr_ready & wr_i)  begin
    data_i_d1 <=  data_i;
    data_i_d2 <=  data_i_d1;
    //data_i_d3 <=  data_i_d2;
  end
  else  if  (rd_ready  && rd_i  &&  (wr_addr ==  rd_addr) )  begin
    data_i_d1 <=  data_i;
    data_i_d2 <=  data_i_d1;
  end

end


// d1->d2->d3==data_o
always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    pre_data_o_d1 <=  'd0;
    pre_data_o_d2 <=  'd0;
    pre_data_o_d3 <=  'd0;
  end
  else  if  (rd_ready & rd_i)  begin
    if(rd_en_q) begin
      if  (~rd_pipe[1])
        {pre_data_o_d2, pre_data_o_d3}  <=  ram_data_out;
      else  begin
        {pre_data_o_d1, pre_data_o_d2}  <=  ram_data_out;
        pre_data_o_d3 <=  pre_data_o_d2;
      end
    end
    else begin
      pre_data_o_d3 <=  pre_data_o_d2;
      pre_data_o_d2 <=  pre_data_o_d1;
    end
  end
  else if (rd_en_q) begin
    if(~rd_pipe[0])
      {pre_data_o_d2, pre_data_o_d3}  <=  ram_data_out;
    else
      {pre_data_o_d1, pre_data_o_d2}  <=  ram_data_out;
  end
end

//assign  data_o  =
always  @(*)  begin
  if  (rd_pipe[0])
    data_o  = pre_data_o_d3;
  else if(rd_pipe[1])
    data_o  = pre_data_o_d2;
  else  if(rd_pipe[2])
    data_o  = pre_data_o_d1;
  else if(wr_pipe[0])
    data_o  = data_i_d2;
  else if(wr_pipe[1])
    data_o  = data_i_d1;
  else
    data_o  = pre_data_o_d3;
end




// wr_addr point to the bufffer entry that next period should be written in;
always  @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
      wr_addr <=  'd0;
  end
  else if(wr_en) begin
          wr_addr <=  wr_addr + 'd1;
  end
end


// rd_addr point to the bufffer entry that next period should be read;
always  @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
      rd_addr <=  'd0;
  end
  else if(rd_en) begin
        rd_addr <=  rd_addr + 'd1;
  end
end



// wr_pipe:   ctrl_bit  -> pipe_1 ->  pipe_0;
// rd_pipe:   ctrl_bit  -> pipe_2 -> pipe_1 ->  pipe_0;
always @(posedge clk or negedge rst_n)  begin
  if(~rst_n)  begin
    wr_pipe <=  2'b00;
  end
  else if(wr_en)begin
    if  (wr_ready & wr_i) begin
      wr_pipe <=  2'b10;
    end
    else  begin
      wr_pipe <=  2'b00;
    end
  end
  else if(wr_ready  & wr_i) begin
    wr_pipe[1] <= 1'b1;
    if  (rd_ready && rd_i &&(wr_addr  ==  rd_addr)) begin
      wr_pipe[0]  <=  wr_pipe[0];   //TODO
      //wr_pipe[0]  <=  1'b0;   //TODO
    end
    else  begin
      wr_pipe[0]  <=  wr_pipe[1];
    end
  end
  else if(rd_ready  && rd_i  &&  (wr_addr ==  rd_addr)  &&(rd_pipe==3'b000)) begin
      if(wr_pipe==2'b11)
        wr_pipe <=  2'b01;
      else if(wr_pipe ==  2'b01)
        wr_pipe <=  2'b00;
      //wr_pipe <=  {1'b0,  wr_pipe[0]};
  end
end

//always @(posedge clk or negedge rst_n)  begin
//  if(~rst_n)  begin
//    wr_pipe <=  2'b00;
//  end
//  else if((wr_ready  & wr_i) &&  (wr_addr !=  rd_addr))begin
//    wr_pipe <=  {wr_pipe[0],  1'b1};
//  end
//  else if((wr_ready  & wr_i) &&  (wr_addr ==  rd_addr))begin
//    wr_pipe <=  2'b01;
//  end
//  else if((wr_addr ==  rd_addr) && (rd_ready &  rd_i))  begin
//    wr_pipe <=  {wr_pipe[0],  1'b0};
//  end
//  
//end

always  @(posedge clk or negedge rst_n) begin
  if  (~rst_n)  begin
    rd_pipe <=  3'b000;
  end
  else if (rd_ready & rd_i)  begin
    if(rd_en_q) begin
      if  (~rd_pipe[1])
        rd_pipe <=  3'b011;
      else  
        rd_pipe <=  3'b111;
    end
    else  begin
      //if  (wr_addr!=rd_addr)
        rd_pipe <=  {1'b0,  rd_pipe[2:1]};
      //else
        //rd_pipe <=  {wr_pipe[0],  rd_pipe[2:1]};
    end
  end
  else if (rd_en_q) begin
    if  (~rd_pipe[0]) 
      rd_pipe <=  3'b011;
    else
      rd_pipe <=  3'b111;
  end
end

// ----------------------------------------------------
// memory control
assign    wr_en = (wr_pipe[0]  & wr_pipe[1]  & ~full_o) &&(~((wr_addr==rd_addr) &&  (rd_pipe  ==  3'b000 )  && (rd_ready & rd_i)));

assign    rd_en = (wr_addr  !=  rd_addr)  &&  (~wr_en)  && ((rd_en_q  ==  1'b0)&&(~(rd_pipe[2]  | rd_pipe[1])) ||(~rd_pipe[2] && ~rd_en_q &&  rd_ready &&  rd_i) );
//assign    rd_en = (wr_addr  !=  rd_addr)  &&  (~wr_en)  && ((rd_en_q  ==  1'b0)&&(~(rd_pipe[2]  | rd_pipe[1])) ||(~rd_pipe[2] && ~rd_en_q &&  rd_ready &&  rd_i) || (~rd_pipe[2]  &&  rd_ready &&  rd_i));


always @(posedge clk  or negedge rst_n) begin
  if(~rst_n)  begin
    wr_en_q <=  1'b0;
    rd_en_q <=  1'b0;
  end
  else  begin
    wr_en_q <=  wr_en;
    rd_en_q <=  rd_en;
  end
end







// ----------------------------------------------------
// clock gate
clk_gate  clk_gate_inst(

  .cp(clk_i),
  .te(1'b0),
  .enable(enable),
  .q(clk)

);


assign  ram_data_in =   {data_i_d1, data_i_d2};
assign  ram_addr  = wr_en ? wr_addr : rd_addr;
// ----------------------------------------------------
// sram 1w1r memory based on latch
//sram256x64   sram_inst (
sram_model   sram_inst (
  .inst_clk(clk),
  .inst_rst_n(rst_n),
  .inst_cs_n(~(wr_en  | rd_en)),
  .inst_wr_n(~wr_en),
  .inst_rw_addr(ram_addr[FIFO_ADDR_W-1:0]),
  .inst_data_in(ram_data_in),
  .data_out_inst(ram_data_out)
);






endmodule
