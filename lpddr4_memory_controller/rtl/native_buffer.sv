//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-07-17 08:04
//  Email             : huwe0427@uw.edu
//  Filename          : native_buffer.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

// ----------------------------------------------------
// axi -> native_lite ->  pre_buf - buffer-> post_buf-> native

module native_buffer(
    input clk,
    input rst_n,

    native_interface pre_buf_if,
    native_interface post_buf_if
    );
  


// ----------------------------------------------------
parameter IDLE  = 2'b00;
parameter CMD  = 2'b01;
parameter TRANS  = 2'b10;
parameter DONE  = 2'b11;

  // ----------------------------------------------------
  logic  [1:0] wr_pipe; 
  logic  [1:0] rd_pipe; 
  
  logic  [1:0] cmd_pipe; 
  
  logic  [255:0]  wdata_0;
  logic  [255:0]  wdata_1;
  logic  [255:0]  rdata_0;
  logic  [255:0]  rdata_1;

  logic  [31:0]   wdata_mw_0;
  logic  [31:0]   wdata_mw_1;
  logic  [31:0]   rdata_mw_0;
  logic  [31:0]   rdata_mw_1;

  logic   pre_we;
  logic   post_we;
  logic  [1:0] pre_mw;
  logic   post_mw;
  logic  [25:0] addr;  



  logic pre_cmd_get;
  logic post_cmd_get;
  logic pre_rdata_get;
  logic post_rdata_get;
  logic pre_wdata_get;
  logic post_wdata_get;

  logic cmd_first;
  logic wr_first;
  logic rd_first;


assign  pre_cmd_get = pre_buf_if.native_cmd_valid & pre_buf_if.native_cmd_ready;
assign  post_cmd_get = post_buf_if.native_cmd_valid & post_buf_if.native_cmd_ready;

assign  pre_wdata_get = pre_buf_if.wdata_valid & pre_buf_if.wdata_ready;
assign  post_wdata_get = post_buf_if.wdata_valid & post_buf_if.wdata_ready;

assign  pre_rdata_get = pre_buf_if.rdata_valid & pre_buf_if.rdata_ready;
assign  post_rdata_get = post_buf_if.rdata_valid & post_buf_if.rdata_ready;


// ----------------------------------------------------
//pre -> pipe[1] -> pipe[0] -> post
assign pre_buf_if.native_cmd_ready  = ~(&cmd_pipe[1:0]); 
assign  post_buf_if.native_cmd_valid  = (cmd_pipe[0]);
assign  cmd_first =  pre_cmd_get  &(~cmd_pipe[1]);


 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
        addr  <=  'd0;
        pre_we  <=  'd0;
      end
    else if (cmd_first)  begin
        addr  <=  pre_buf_if.native_cmd_payload_addr;
        pre_we  <= pre_buf_if.native_cmd_payload_we; 
    end
 end

 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
       pre_mw <=  2'b00; 
      end
    else if (pre_cmd_get)  begin
      pre_mw[0] <=  pre_mw[1];
      pre_mw[1] <=  pre_buf_if.native_cmd_payload_mw;
    end
    else  if(post_cmd_get)  begin
      pre_mw  <=  2'b00;
      end
 end

 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
       cmd_pipe <=  2'b00; 
      end
    else if (pre_cmd_get)  begin
      cmd_pipe[0] <=  cmd_pipe[1];
      cmd_pipe[1] <=  1'b1;
    end
    else  if(post_cmd_get)  begin
      cmd_pipe  <=  2'b00;
      end
 end

assign post_buf_if.native_cmd_payload_addr = addr;
assign post_buf_if.native_cmd_payload_we = pre_we;
assign post_buf_if.native_cmd_payload_mw = pre_mw;


// ----------------------------------------------------

assign pre_buf_if.wdata_ready = ~(&wr_pipe[1:0]);
assign post_buf_if.wdata_valid = (wr_pipe[0]);


 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
        wdata_0 <=  'd0;
        wdata_1 <=  'd0;
        wdata_mw_0 <=  'd0;
        wdata_mw_1 <=  'd0;
      end
    else if (pre_wdata_get)  begin
        wdata_0 <=  wdata_1;
        wdata_1 <=  pre_buf_if.wdata_payload_data;
        wdata_mw_0 <=  wdata_mw_1;
        wdata_mw_1 <=  pre_buf_if.wdata_payload_we;  //TODO need more accurate control for strobe
        end
    else if (post_wdata_get)  begin
        wdata_0 <=  wdata_1;
        wdata_mw_0 <=  wdata_mw_1;
    end
 end



 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
       wr_pipe <=  2'b00; 
      end
    else if (pre_wdata_get)  begin
      wr_pipe[0] <=  wr_pipe[1];
      wr_pipe[1] <=  1'b1;
    end
    else  if(post_wdata_get)  begin
      wr_pipe[0] <=  wr_pipe[1];
      wr_pipe[1] <=  1'b0;
      end
 end



assign post_buf_if.wdata_payload_data = wdata_0;
assign post_buf_if.wdata_payload_we = wdata_mw_0;

// ----------------------------------------------------
// post-> pipe[1]->pipe[0]->pre
assign post_buf_if.rdata_ready = ~(&rd_pipe[1:0]);
assign pre_buf_if.rdata_valid = (rd_pipe[0]);


 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
        rdata_0 <=  'd0;
        rdata_1 <=  'd0;
      end
    else if (post_rdata_get)  begin
        rdata_0 <=  rdata_1;
        rdata_1 <=  post_buf_if.rdata_payload_data;
    end
    else if (pre_rdata_get)  begin
        rdata_0 <=  rdata_1;
    end
 end



 always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  begin
       rd_pipe <=  2'b00; 
      end
    else if (post_rdata_get)  begin
      rd_pipe[0] <=  rd_pipe[1];
      rd_pipe[1] <=  1'b1;
    end
    else  if(pre_rdata_get)  begin
      rd_pipe[0] <=  rd_pipe[1];
      rd_pipe[1] <=  1'b0;
      end
 end



assign pre_buf_if.rdata_payload_data = rdata_0;


// ----------------------------------------------------
assign  post_buf_if.native_cmd_first  = 1'b0;
assign  post_buf_if.native_cmd_last  = 1'b0;
assign  post_buf_if.wdata_first  = 1'b0;
assign  post_buf_if.wdata_last  = 1'b0;
assign  pre_buf_if.rdata_first  = 1'b0;
assign  pre_buf_if.rdata_last  = 1'b0;


  endmodule
