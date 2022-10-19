module ucie_channel_adapter  (
    //clk,rst
    input fwd_clk,
    input clk,rst,

    //RDI mainband
    input logic [383:0] lp_data,
    input logic lp_valid,
    input logic lp_irdy,
    output logic pl_trdy,
    
    output logic [383:0] pl_data,
    output logic pl_valid,

    //RDI sideband
    input logic [31:0] lp_cfg,
    input logic lp_cfg_vld,
    input logic lp_cfg_crd,
    output logic [31:0] pl_cfg,
    output logic pl_cfg_vld,
    output logic pl_cfg_crd,

    //SDR interface channel-0
    output  logic [71:0]            ch0_tx_dq0_sdr,
    output  logic [71:0]            ch0_tx_dq0_pam4_sdr,
    input logic [71:0]              ch0_rx_dq0_sdr,
    input logic [71:0]              ch0_rx_dq0_pam4_sdr,
    input logic [8:0]               ch0_rx_dq0_sdr_vld,
    output  logic [71:0]           ch0_tx_dqs0_sdr,
    output  logic [71:0]            ch0_tx_dq1_sdr,
    output  logic [71:0]            ch0_tx_dq1_pam4_sdr,
    input logic [71:0]              ch0_rx_dq1_sdr,
    input logic [71:0]              ch0_rx_dq1_pam4_sdr,
    input logic [8:0]               ch0_rx_dq1_sdr_vld,
    output  logic [71:0]           ch0_tx_dqs1_sdr,

    output  logic [63:0]            ch0_tx_ca_sdr,
    output  logic [63:0]            ch0_tx_ca_pam4_sdr,
    input logic [63:0]              ch0_rx_ca_sdr,
    input logic [63:0]              ch0_rx_ca_pam4_sdr,
    input logic [7:0]               ch0_rx_ca_sdr_vld,
    output  logic [71:0]            ch0_tx_ck_sdr,

    //SDR interface channel-1
    output  logic [71:0]            ch1_tx_dq0_sdr,
    output  logic [71:0]            ch1_tx_dq0_pam4_sdr,
    input logic [71:0]              ch1_rx_dq0_sdr,
    input logic [71:0]              ch1_rx_dq0_pam4_sdr,
    input logic [8:0]               ch1_rx_dq0_sdr_vld,
    output  logic [71:0]           ch1_tx_dqs0_sdr,
    output  logic [71:0]            ch1_tx_dq1_sdr,
    output  logic [71:0]            ch1_tx_dq1_pam4_sdr,
    input logic [71:0]              ch1_rx_dq1_sdr,
    input logic [71:0]              ch1_rx_dq1_pam4_sdr,
    input logic [8:0]               ch1_rx_dq1_sdr_vld,
    output  logic [71:0]           ch1_tx_dqs1_sdr,

    output  logic [63:0]            ch1_tx_ca_sdr,
    output  logic [63:0]            ch1_tx_ca_pam4_sdr,
    input logic [63:0]              ch1_rx_ca_sdr,
    input logic [63:0]              ch1_rx_ca_pam4_sdr,
    input logic [7:0]               ch1_rx_ca_sdr_vld,
    output  logic [71:0]            ch1_tx_ck_sdr,

    //CSR
    input logic i_rxfifo_clr,
    //input logic [2:0] lt_mode, // 3'b000 normal, 3'b001 stage 1 training sequence, 3'b010 stage 2 training sequence
    input logic [3:0] i_txrx_mode, // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    input  logic                     i_buf_mode,
    input  logic                     i_pam4_en,
   input  logic                     i_buf_clk_en,
   input  logic                     i_intf_pipe_en,
   input  logic                     i_ts_enable,
   input  logic                     i_ts_reset,
   input  logic                     i_ts_brkpt_en,
   input  logic [15:0]              i_ts_brkpt_val,

   input  logic                     i_ig_loop_mode,
   input  logic [3:0]               i_ig_num_loops,
   input  logic                     i_ig_load_ptr,
   input  logic [4:0]               i_ig_stop_ptr,
   input  logic [4:0]               i_ig_start_ptr,
   input  logic                     i_ig_wdata_clr,
   input  logic                     i_ig_wdata_hold,
   input  logic                     i_ig_wdata_en,
   input  logic                     i_ig_wdata_upd,
   input  logic [31:0]              i_ig_wdata,
   output logic                     o_ig_empty,
   output logic                     o_ig_write_done,
   output logic                     o_ig_full,
   output logic                     o_ig_overflow,

   input  logic                     i_eg_rdata_clr,
   input  logic                     i_eg_rdata_en,
   input  logic                     i_eg_rdata_upd,
   output logic [31:0]              o_eg_rdata,
   output logic                     o_eg_empty,
   output logic                     o_eg_read_done,
   output logic                     o_eg_full,
   output logic                     o_eg_overflow,
   output logic [31:0]              o_debug
);
    logic rxfifo_clr_sync;
    logic [3:0] txrx_mode_sync;
    logic pam4_en_sync;
   // Synchronize CSR controls
   ddr_demet_r u_demet_0 (.i_clk(clk), .i_rst(rst), .i_d(i_rxfifo_clr),        .o_q(rxfifo_clr_sync));
   ddr_demet_r u_demet_11 (.i_clk(clk), .i_rst(rst), .i_d(i_txrx_mode[0] ),        .o_q(txrx_mode_sync[0] ));
   ddr_demet_r u_demet_12 (.i_clk(clk), .i_rst(rst), .i_d(i_txrx_mode[1] ),        .o_q(txrx_mode_sync[1] ));
   ddr_demet_r u_demet_13 (.i_clk(clk), .i_rst(rst), .i_d(i_txrx_mode[2] ),        .o_q(txrx_mode_sync[2] ));
   ddr_demet_r u_demet_14 (.i_clk(clk), .i_rst(rst), .i_d(i_txrx_mode[3] ),        .o_q(txrx_mode_sync[3] ));
   ddr_demet_r u_demet_2 (.i_clk(clk), .i_rst(rst), .i_d(i_pam4_en),      .o_q(pam4_en_sync ));

//tx FIFO ctrl
    logic txfifo_i_empty;
    logic txfifo_i_full;
    logic txfifo_i_full_n;
    logic lp_write_push;
    logic txfifo_i_pop;
    logic [383:0] fifo_rddata;

    assign txfifo_i_full_n=~txfifo_i_full;
    assign pl_trdy=txfifo_i_full_n;
    assign lp_write_push=lp_irdy&lp_valid&txfifo_i_full_n;

    syncfifo_reg #(.FIFO_WIDTH_WID(384), .FIFO_DEPTH_WID(8)) syncfifo_ii
     (/*AUTOINST*/
      // Outputs
      .rddata				(fifo_rddata),	 // Templated
      .numfilled			(), // Templated
      .numempty				(),			 // Templated
      .full				    (txfifo_i_full),	 // Templated
      .empty				(txfifo_i_empty),	 // Templated
      .overflow_pulse			(), // Templated
      .underflow_pulse			(), // Templated
      // Inputs
      .clk_core				(clk),		 // Templated
      .rst_core_n			(~rst),		 // Templated
      .soft_reset			(1'b0),	                 // Templated
      .write_push			(lp_write_push),	 // Templated
      .wrdata				(lp_data), // Templated
      .read_pop				(txfifo_i_pop));		 // Templated

//tx ctrl
  logic [71:0] ch0_tx_dq0_sdr_;
  logic [71:0] ch0_tx_dq1_sdr_;
  logic [63:0] ch0_tx_ca_sdr_;
  logic [71:0] ch1_tx_dq0_sdr_;
  logic [71:0] ch1_tx_dq1_sdr_;
  logic [63:0] ch1_tx_ca_sdr_;
  
  logic [71:0] ch0_tx_dq0_pam4_sdr_;
  logic [71:0] ch0_tx_dq1_pam4_sdr_;
  logic [63:0] ch0_tx_ca_pam4_sdr_;
  logic [71:0] ch1_tx_dq0_pam4_sdr_;
  logic [71:0] ch1_tx_dq1_pam4_sdr_;
  logic [63:0] ch1_tx_ca_pam4_sdr_;
  logic [7:0] tx_valid_pattern;

    ucie_tx_ctrl u_ucie_tx_ctrl(
        .clk(clk),
        .rst(rst),
        .tx_valid_pattern(tx_valid_pattern),
        .txrx_mode(txrx_mode_sync),
        .pam4_en(pam4_en_sync),
        .fifo_rd(txfifo_i_pop),
        .fifo_empty(txfifo_i_empty),
        .fifo_rddata(fifo_rddata),
        .ch0_tx_dq0_sdr(ch0_tx_dq0_sdr_),
        .ch0_tx_dq1_sdr(ch0_tx_dq1_sdr_),
        .ch0_tx_ca_sdr(ch0_tx_ca_sdr_),
        .ch1_tx_dq0_sdr(ch1_tx_dq0_sdr_),
        .ch1_tx_dq1_sdr(ch1_tx_dq1_sdr_),
        .ch1_tx_ca_sdr(ch1_tx_ca_sdr_),

        .ch0_tx_dq0_pam4_sdr(ch0_tx_dq0_pam4_sdr_),
        .ch0_tx_dq1_pam4_sdr(ch0_tx_dq1_pam4_sdr_),
        .ch0_tx_ca_pam4_sdr(ch0_tx_ca_pam4_sdr_),
        .ch1_tx_dq0_pam4_sdr(ch1_tx_dq0_pam4_sdr_),
        .ch1_tx_dq1_pam4_sdr(ch1_tx_dq1_pam4_sdr_),
        .ch1_tx_ca_pam4_sdr(ch1_tx_ca_pam4_sdr_)
    );

//io & clk ctrl
  logic [71:0] ch0_tx_dqs0_sdr_;
  logic [71:0] ch0_tx_dqs1_sdr_;
  logic [71:0] ch0_tx_ck_sdr_;
  logic [71:0] ch1_tx_dqs0_sdr_;
  logic [71:0] ch1_tx_dqs1_sdr_;
  logic [71:0] ch1_tx_ck_sdr_;

    ucie_io_ctrl u_ucie_io_ctrl(
        .tx_valid_pattern(tx_valid_pattern),
        .txrx_mode(txrx_mode_sync),
        .ch0_tx_dqs0_sdr(ch0_tx_dqs0_sdr_),
        .ch0_tx_dqs1_sdr(ch0_tx_dqs1_sdr_),
        .ch0_tx_ck_sdr(ch0_tx_ck_sdr_),
        .ch1_tx_dqs0_sdr(ch1_tx_dqs0_sdr_),
        .ch1_tx_dqs1_sdr(ch1_tx_dqs1_sdr_),
        .ch1_tx_ck_sdr(ch1_tx_ck_sdr_)
    );

 logic [71:0] buf_ch0_rx_dq0_sdr;
 logic [71:0] buf_ch0_rx_dq1_sdr;
  logic [63:0] buf_ch0_rx_ca_sdr;

 logic [71:0] buf_ch1_rx_dq0_sdr;
 logic [71:0] buf_ch1_rx_dq1_sdr;
  logic [63:0] buf_ch1_rx_ca_sdr;

   logic [71:0] buf_ch0_rx_dq0_pam4_sdr;
 logic [71:0] buf_ch0_rx_dq1_pam4_sdr;
  logic [63:0] buf_ch0_rx_ca_pam4_sdr;

 logic [71:0] buf_ch1_rx_dq0_pam4_sdr;
 logic [71:0] buf_ch1_rx_dq1_pam4_sdr;
  logic [63:0] buf_ch1_rx_ca_pam4_sdr;
  
  
 logic [8:0] buf_ch0_rx_dq0_sdr_vld;
 logic [8:0] buf_ch0_rx_dq1_sdr_vld;
  logic [7:0] buf_ch0_rx_ca_sdr_vld;

 logic [8:0] buf_ch1_rx_dq0_sdr_vld;
 logic [8:0] buf_ch1_rx_dq1_sdr_vld;
  logic [7:0] buf_ch1_rx_ca_sdr_vld;

  ucie_buf u_ucie_buf (
    .clk                     (clk),
    .rst                     (rst),
    .i_buf_mode              (i_buf_mode),
    .i_buf_clk_en            (i_buf_clk_en),
    .i_intf_pipe_en          (i_intf_pipe_en),
    .i_ts_enable             (i_ts_enable),
    .i_ts_reset              (i_ts_reset),
    .i_ts_brkpt_en           (i_ts_brkpt_en),
    .i_ts_brkpt_val          (i_ts_brkpt_val),
    .i_ig_loop_mode          (i_ig_loop_mode),
    .i_ig_num_loops          (i_ig_num_loops),
    .i_ig_load_ptr           (i_ig_load_ptr),
    .i_ig_stop_ptr           (i_ig_stop_ptr),
    .i_ig_start_ptr          (i_ig_start_ptr),
    .i_ig_wdata_clr          (i_ig_wdata_clr),
    .i_ig_wdata_hold         (i_ig_wdata_hold),
    .i_ig_wdata_en           (i_ig_wdata_en),
    .i_ig_wdata_upd          (i_ig_wdata_upd),
    .i_ig_wdata              (i_ig_wdata),
    .o_ig_empty              (o_ig_empty),
    .o_ig_write_done         (o_ig_write_done),
    .o_ig_full               (o_ig_full),
    .o_ig_overflow           (o_ig_overflow),
    .i_eg_rdata_clr          (i_eg_rdata_clr),
    .i_eg_rdata_en           (i_eg_rdata_en),
    .i_eg_rdata_upd          (i_eg_rdata_upd),
    .o_eg_rdata              (o_eg_rdata),
    .o_eg_empty              (o_eg_empty),
    .o_eg_read_done          (o_eg_read_done),
    .o_eg_full               (o_eg_full),
    .o_eg_overflow           (o_eg_overflow),
    .o_debug                 (o_debug),
    //tx ingress mux
    .i_ch0_tx_dq0_sdr(ch0_tx_dq0_sdr_),
    .i_ch0_tx_dq1_sdr(ch0_tx_dq1_sdr_),
    .i_ch0_tx_ca_sdr(ch0_tx_ca_sdr_),
    .i_ch1_tx_dq0_sdr(ch1_tx_dq0_sdr_),
    .i_ch1_tx_dq1_sdr(ch1_tx_dq1_sdr_),
    .i_ch1_tx_ca_sdr(ch1_tx_ca_sdr_),

    .i_ch0_tx_dq0_pam4_sdr(ch0_tx_dq0_pam4_sdr_),
    .i_ch0_tx_dq1_pam4_sdr(ch0_tx_dq1_pam4_sdr_),
    .i_ch0_tx_ca_pam4_sdr(ch0_tx_ca_pam4_sdr_),
    .i_ch1_tx_dq0_pam4_sdr(ch1_tx_dq0_pam4_sdr_),
    .i_ch1_tx_dq1_pam4_sdr(ch1_tx_dq1_pam4_sdr_),
    .i_ch1_tx_ca_pam4_sdr(ch1_tx_ca_pam4_sdr_),

    .o_ch0_tx_dq0_sdr(ch0_tx_dq0_sdr),
    .o_ch0_tx_dq1_sdr(ch0_tx_dq1_sdr),
    .o_ch0_tx_ca_sdr(ch0_tx_ca_sdr),
    .o_ch1_tx_dq0_sdr(ch1_tx_dq0_sdr),
    .o_ch1_tx_dq1_sdr(ch1_tx_dq1_sdr),
    .o_ch1_tx_ca_sdr(ch1_tx_ca_sdr),

    .o_ch0_tx_dq0_pam4_sdr(ch0_tx_dq0_pam4_sdr),
    .o_ch0_tx_dq1_pam4_sdr(ch0_tx_dq1_pam4_sdr),
    .o_ch0_tx_ca_pam4_sdr(ch0_tx_ca_pam4_sdr),
    .o_ch1_tx_dq0_pam4_sdr(ch1_tx_dq0_pam4_sdr),
    .o_ch1_tx_dq1_pam4_sdr(ch1_tx_dq1_pam4_sdr),
    .o_ch1_tx_ca_pam4_sdr(ch1_tx_ca_pam4_sdr),

    //tx dqs ingress mux
    .i_ch0_tx_dqs0_sdr(ch0_tx_dqs0_sdr_),
    .i_ch0_tx_dqs1_sdr(ch0_tx_dqs1_sdr_),
    .i_ch0_tx_ck_sdr(ch0_tx_ck_sdr_),
    .i_ch1_tx_dqs0_sdr(ch1_tx_dqs0_sdr_),
    .i_ch1_tx_dqs1_sdr(ch1_tx_dqs1_sdr_),
    .i_ch1_tx_ck_sdr(ch1_tx_ck_sdr_),
    .o_ch0_tx_dqs0_sdr(ch0_tx_dqs0_sdr),
    .o_ch0_tx_dqs1_sdr(ch0_tx_dqs1_sdr),
    .o_ch0_tx_ck_sdr(ch0_tx_ck_sdr),
    .o_ch1_tx_dqs0_sdr(ch1_tx_dqs0_sdr),
    .o_ch1_tx_dqs1_sdr(ch1_tx_dqs1_sdr),
    .o_ch1_tx_ck_sdr(ch1_tx_ck_sdr),

    //rx egress
    .i_ch0_rx_dq0_sdr(ch0_rx_dq0_sdr),
    .i_ch0_rx_dq1_sdr(ch0_rx_dq1_sdr),
    .i_ch0_rx_ca_sdr(ch0_rx_ca_sdr),
    .i_ch1_rx_dq0_sdr(ch1_rx_dq0_sdr),
    .i_ch1_rx_dq1_sdr(ch1_rx_dq1_sdr),
    .i_ch1_rx_ca_sdr(ch1_rx_ca_sdr),

    .i_ch0_rx_dq0_pam4_sdr(ch0_rx_dq0_pam4_sdr),
    .i_ch0_rx_dq1_pam4_sdr(ch0_rx_dq1_pam4_sdr),
    .i_ch0_rx_ca_pam4_sdr(ch0_rx_ca_pam4_sdr),
    .i_ch1_rx_dq0_pam4_sdr(ch1_rx_dq0_pam4_sdr),
    .i_ch1_rx_dq1_pam4_sdr(ch1_rx_dq1_pam4_sdr),
    .i_ch1_rx_ca_pam4_sdr(ch1_rx_ca_pam4_sdr),

    .i_ch0_rx_dq0_sdr_vld(ch0_rx_dq0_sdr_vld),
    .i_ch0_rx_dq1_sdr_vld(ch0_rx_dq1_sdr_vld),
    .i_ch0_rx_ca_sdr_vld(ch0_rx_ca_sdr_vld),
    .i_ch1_rx_dq0_sdr_vld(ch1_rx_dq0_sdr_vld),
    .i_ch1_rx_dq1_sdr_vld(ch1_rx_dq1_sdr_vld),
    .i_ch1_rx_ca_sdr_vld(ch1_rx_ca_sdr_vld),
    //rx output to fifo
    .o_ch0_rx_dq0_sdr        (buf_ch0_rx_dq0_sdr),
    .o_ch0_rx_dq1_sdr        (buf_ch0_rx_dq1_sdr),
    .o_ch0_rx_ca_sdr         (buf_ch0_rx_ca_sdr),
    .o_ch1_rx_dq0_sdr        (buf_ch1_rx_dq0_sdr),
    .o_ch1_rx_dq1_sdr        (buf_ch1_rx_dq1_sdr),
    .o_ch1_rx_ca_sdr         (buf_ch1_rx_ca_sdr),

    .o_ch0_rx_dq0_pam4_sdr        (buf_ch0_rx_dq0_pam4_sdr),
    .o_ch0_rx_dq1_pam4_sdr        (buf_ch0_rx_dq1_pam4_sdr),
    .o_ch0_rx_ca_pam4_sdr         (buf_ch0_rx_ca_pam4_sdr),
    .o_ch1_rx_dq0_pam4_sdr        (buf_ch1_rx_dq0_pam4_sdr),
    .o_ch1_rx_dq1_pam4_sdr        (buf_ch1_rx_dq1_pam4_sdr),
    .o_ch1_rx_ca_pam4_sdr         (buf_ch1_rx_ca_pam4_sdr),

    .o_ch0_rx_dq0_sdr_vld    (buf_ch0_rx_dq0_sdr_vld),
    .o_ch0_rx_dq1_sdr_vld    (buf_ch0_rx_dq1_sdr_vld),
    .o_ch0_rx_ca_sdr_vld     (buf_ch0_rx_ca_sdr_vld),
    .o_ch1_rx_dq0_sdr_vld    (buf_ch1_rx_dq0_sdr_vld),
    .o_ch1_rx_dq1_sdr_vld    (buf_ch1_rx_dq1_sdr_vld),
    .o_ch1_rx_ca_sdr_vld     (buf_ch1_rx_ca_sdr_vld)
);

//rx routing
    logic [191:0] ch1_rx;
    logic [191:0] ch0_rx;
    logic [191:0] ch1_rx_pam4;
    logic [191:0] ch0_rx_pam4;
    logic [383:0] rx_input;
    logic [383:0] one_channel_rx;
    logic [383:0] rx_fifo_wrdata;
    logic [383:0] rx_fifo_wrdata_not_pam4;
    logic [383:0] rx_fifo_wrdata_pam4;

    logic rx_valid;
    logic rx_channel_sel;
    logic half_rx_mode;

    assign ch1_rx={buf_ch1_rx_dq1_sdr[71:64],buf_ch1_rx_dq0_sdr[71:64],buf_ch1_rx_ca_sdr[47:0],buf_ch1_rx_dq1_sdr[63:0],buf_ch1_rx_dq0_sdr[63:0]};
    assign ch0_rx={buf_ch0_rx_dq1_sdr[71:64],buf_ch0_rx_dq0_sdr[71:64],buf_ch0_rx_ca_sdr[47:0],buf_ch0_rx_dq1_sdr[63:0],buf_ch0_rx_dq0_sdr[63:0]};
    assign ch1_rx_pam4={buf_ch1_rx_dq1_pam4_sdr[71:64],buf_ch1_rx_dq0_pam4_sdr[71:64],buf_ch1_rx_ca_pam4_sdr[47:0],buf_ch1_rx_dq1_pam4_sdr[63:0],buf_ch1_rx_dq0_pam4_sdr[63:0]};
    assign ch0_rx_pam4={buf_ch0_rx_dq1_pam4_sdr[71:64],buf_ch0_rx_dq0_pam4_sdr[71:64],buf_ch0_rx_ca_pam4_sdr[47:0],buf_ch0_rx_dq1_pam4_sdr[63:0],buf_ch0_rx_dq0_pam4_sdr[63:0]};
    assign rx_input={ch1_rx,ch0_rx};
    assign half_rx_mode=((txrx_mode_sync==4'b0101) || (pam4_en_sync==1'b1))?1'b0:1'b1;
    assign rx_channel_sel=(half_rx_mode==1'b1)?((txrx_mode_sync[3:2]==2'b01)?1'b1:1'b0):1'b0;
    assign one_channel_rx[383:192]='d0;
    assign one_channel_rx[191:0]=rx_channel_sel?ch1_rx:ch0_rx;
    //normal mode sel
    assign rx_fifo_wrdata_not_pam4=half_rx_mode?one_channel_rx:rx_input;
    //pam4 rx channel sel
    assign rx_fifo_wrdata_pam4=txrx_mode_sync[0]?{ch0_rx_pam4,ch0_rx}:{ch1_rx_pam4,ch1_rx};
    //select between pam4 mode and normal mode
    assign rx_fifo_wrdata=pam4_en_sync?rx_fifo_wrdata_pam4:rx_fifo_wrdata_not_pam4;

    assign rx_valid=(|buf_ch0_rx_dq0_sdr_vld)|(|buf_ch0_rx_dq1_sdr_vld)|(|buf_ch1_rx_dq0_sdr_vld)|(|buf_ch1_rx_dq1_sdr_vld)|(|buf_ch0_rx_ca_sdr_vld)|(|buf_ch1_rx_ca_sdr_vld);

    logic empty_n;
    logic [3:0] ucie_rx_fgb_mode;
    assign ucie_rx_fgb_mode=half_rx_mode?4'd8:4'd7;
    //slice fifo
    ddr_rx_fifo #(
            .WWIDTH           (384),
            .RWIDTH           (384),
            .BWIDTH           (1),
            .DEPTH            (8),
            .FREN_WIDTH       (1),
            .SYNC             (1'b1),
            .RAM_MODEL        (1'b0)
         ) u_rx_fifo (
            .i_scan_clk       (1'b0),        // Assumes no scan in custom macro
            .i_scan_en        (1'b0),        // Assumes no scan in custom macro
            .i_scan_mode      (1'b0),        // Assumes no scan in custom macro
            .i_scan           (2'b0),        // Assumes no scan in custom macro
            .o_scan           (/*OPEN*/),    // Assumes no scan in custom macro
            .i_scan_rst_ctrl  (1'b0),        // Assumes no scan in custom macro
            .i_scan_cgc_ctrl  (1'b0),        // Assumes no scan in custom macro
            .i_fgb_mode       (ucie_rx_fgb_mode),
            .i_wclk           (fwd_clk),
            .i_wrst           (rst),
            .i_write          (rx_valid),
            .i_wdata          (rx_fifo_wrdata),
            .o_full           (),
            .i_rclk           (clk),
            .i_csp_div_rst_n  (~rst),
            .i_rrst           (rst),
            .i_read           (empty_n),
            .i_clr            (rxfifo_clr_sync),
            .i_read_mask      ('d0),
            .i_rclk_en_ovr_sel(/*OPEN*/) ,
            .i_rclk_en_ovr    (/*OPEN*/) ,
            .o_rdata          (pl_data),
            .o_rvld           (pl_valid),
            .o_rclk_en        (/*OPEN*/),
            .o_empty_n        (empty_n)
         );

endmodule

module ucie_tx_ctrl(
    input clk,rst,
    output logic [7:0] tx_valid_pattern,
    input logic [3:0] txrx_mode,
    input logic  pam4_en,
    output logic fifo_rd,
    input logic  fifo_empty,
    input logic  [383:0] fifo_rddata,
    output logic [71:0] ch0_tx_dq0_sdr,
    output logic [71:0] ch0_tx_dq1_sdr,
    output logic [63:0] ch0_tx_ca_sdr,
    output logic [71:0] ch1_tx_dq0_sdr,
    output logic [71:0] ch1_tx_dq1_sdr,
    output logic [63:0] ch1_tx_ca_sdr,

    output logic [71:0] ch0_tx_dq0_pam4_sdr,
    output logic [71:0] ch0_tx_dq1_pam4_sdr,
    output logic [63:0] ch0_tx_ca_pam4_sdr,
    output logic [71:0] ch1_tx_dq0_pam4_sdr,
    output logic [71:0] ch1_tx_dq1_pam4_sdr,
    output logic [63:0] ch1_tx_ca_pam4_sdr
);

    logic cnt_vld;
    logic cnt;
    logic [191:0] first_half,second_half;
    logic [191:0] half_output;
    //output ctrl
    logic [383:0] channel_data;
    always_ff@(posedge clk,posedge rst) begin
        if(rst) begin
            channel_data<='d0;
            tx_valid_pattern<='d0;
        end else begin
            if((txrx_mode==4'b1010) || (pam4_en==1'b1)) begin //all tx
                channel_data<='0;
                tx_valid_pattern<='0;
                if(fifo_rd&(~fifo_empty)) begin
                    channel_data<=fifo_rddata;
                    tx_valid_pattern<=8'h0f;
                end
            end else begin //half tx
                if((fifo_rd&(~fifo_empty))) begin
                    channel_data<=fifo_rddata;
                    tx_valid_pattern<=8'h0f;
                end else if(cnt==1) begin
                    channel_data<='0;
                    tx_valid_pattern<=8'h00;
                end
            end
        end
    end

    //mode ctrl
    assign first_half=channel_data[191:0];
    assign second_half=channel_data[383:192];
    assign half_output=cnt?second_half:first_half;

    always_ff@(posedge clk,posedge rst) begin
        if(rst) begin 
            cnt<='d0;
        end else begin
            if(cnt_vld) cnt<=~cnt;
            else cnt<='d0;
        end
    end

    always_comb begin
        ch1_tx_dq1_sdr='d0;
        ch1_tx_dq0_sdr='d0;
        ch1_tx_ca_sdr='d0;
        ch0_tx_dq1_sdr='d0;
        ch0_tx_dq0_sdr='d0;
        ch0_tx_ca_sdr='d0;

        ch1_tx_dq1_pam4_sdr='d0;
        ch1_tx_dq0_pam4_sdr='d0;
        ch1_tx_ca_pam4_sdr='d0;
        ch0_tx_dq1_pam4_sdr='d0;
        ch0_tx_dq0_pam4_sdr='d0;
        ch0_tx_ca_pam4_sdr='d0;
        casez({txrx_mode[3],txrx_mode[1]})
            2'b11: begin //all tx
                cnt_vld=1'b0;
                fifo_rd=~fifo_empty;
                ch1_tx_dq1_sdr={channel_data[383:376],channel_data[319:256]};
                ch1_tx_dq0_sdr={channel_data[375:368],channel_data[255:192]};
                ch1_tx_ca_sdr[47:0]=channel_data[367:320];
                ch0_tx_dq1_sdr={channel_data[191:184],channel_data[127:64]};
                ch0_tx_dq0_sdr={channel_data[183:176],channel_data[63:0]};
                ch0_tx_ca_sdr[47:0]=channel_data[175:128];
            end
            2'b01:begin //ch0_tx
                if(pam4_en==1'b0) begin
                    cnt_vld=1'b1;
                    fifo_rd=(~fifo_empty)&cnt;
                    ch1_tx_dq1_sdr='d0;
                    ch1_tx_dq0_sdr='d0;
                    ch1_tx_ca_sdr='d0;
                    ch0_tx_dq1_sdr={half_output[191:184],half_output[127:64]};
                    ch0_tx_dq0_sdr={half_output[183:176],half_output[63:0]};
                    ch0_tx_ca_sdr[47:0]=half_output[175:128];
                end else begin
                    //pam4 enable
                    cnt_vld=1'b0;
                    fifo_rd=~fifo_empty;
                    ch0_tx_dq1_pam4_sdr={channel_data[383:376],channel_data[319:256]};
                    ch0_tx_dq0_pam4_sdr={channel_data[375:368],channel_data[255:192]};
                    ch0_tx_ca_pam4_sdr[47:0]=channel_data[367:320];
                    ch0_tx_dq1_sdr={channel_data[191:184],channel_data[127:64]};
                    ch0_tx_dq0_sdr={channel_data[183:176],channel_data[63:0]};
                    ch0_tx_ca_sdr[47:0]=channel_data[175:128];
                end
            end
            2'b10:begin //ch1_tx
                if(pam4_en==1'b0) begin
                    cnt_vld=1'b1;
                    fifo_rd=(~fifo_empty)&cnt;
                    ch0_tx_dq1_sdr='d0;
                    ch0_tx_dq0_sdr='d0;
                    ch0_tx_ca_sdr='d0;
                    ch1_tx_dq1_sdr={half_output[191:184],half_output[127:64]};
                    ch1_tx_dq0_sdr={half_output[183:176],half_output[63:0]};
                    ch1_tx_ca_sdr[47:0]=half_output[175:128];
                end else begin
                    //pam4 enable
                    cnt_vld=1'b0;
                    fifo_rd=~fifo_empty;
                    ch1_tx_dq1_pam4_sdr={channel_data[383:376],channel_data[319:256]};
                    ch1_tx_dq0_pam4_sdr={channel_data[375:368],channel_data[255:192]};
                    ch1_tx_ca_pam4_sdr[47:0]=channel_data[367:320];
                    ch1_tx_dq1_sdr={channel_data[191:184],channel_data[127:64]};
                    ch1_tx_dq0_sdr={channel_data[183:176],channel_data[63:0]};
                    ch1_tx_ca_sdr[47:0]=channel_data[175:128];
                end
            end
            2'b00:begin //all disable
                fifo_rd='d0;
                cnt_vld='d0;
                ch1_tx_dq1_sdr='d0;
                ch1_tx_dq0_sdr='d0;
                ch1_tx_ca_sdr='d0;
                ch0_tx_dq1_sdr='d0;
                ch0_tx_dq0_sdr='d0;
                ch0_tx_ca_sdr='d0;

                ch1_tx_dq1_pam4_sdr='d0;
                ch1_tx_dq0_pam4_sdr='d0;
                ch1_tx_ca_pam4_sdr='d0;
                ch0_tx_dq1_pam4_sdr='d0;
                ch0_tx_dq0_pam4_sdr='d0;
                ch0_tx_ca_pam4_sdr='d0;
            end
        endcase
    end


endmodule

module ucie_io_ctrl(
    input logic [7:0] tx_valid_pattern,
    input logic [3:0] txrx_mode,
    output logic [71:0] ch0_tx_dqs0_sdr,
    output logic [71:0] ch0_tx_dqs1_sdr,
    output logic [71:0] ch0_tx_ck_sdr,
    output logic [71:0] ch1_tx_dqs0_sdr,
    output logic [71:0] ch1_tx_dqs1_sdr,
    output logic [71:0] ch1_tx_ck_sdr
);
    /*
    {dfi_rddata_cs_p0;//1
    dfi_wrdata_cs_p0;//1
    dfi_wck_oe_p0;//0
    dfi_rddata_re_p0;
    dfi_rddata_ie_p0;
    dfi_wrdata_oe_p0;
    dfi_rddata_en_p0;
    dfi_parity_in_p0;//dqs 
    dfi_wck_en_p0;//0 }
    */
    always_comb begin
        case (txrx_mode[1:0])
            2'b00: begin
                ch0_tx_dqs1_sdr='d0;
                ch0_tx_dqs0_sdr='d0;
                ch0_tx_ck_sdr='d0;
            end
            2'b01:begin 
    /* rx
    {dfi_rddata_cs_p0;//1
    dfi_wrdata_cs_p0;//0
    dfi_wck_oe_p0;//0
    dfi_rddata_re_p0;//1
    dfi_rddata_ie_p0;//1
    dfi_wrdata_oe_p0;//0
    dfi_rddata_en_p0;//1
    dfi_parity_in_p0;//0 
    dfi_wck_en_p0;//0 }
    */
                ch0_tx_dqs1_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
                ch0_tx_dqs0_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
                ch0_tx_ck_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
            end
            2'b10:begin 
    /* tx dqs
    {dfi_rddata_cs_p0;//0
    dfi_wrdata_cs_p0;//1
    dfi_wck_oe_p0;//0
    dfi_rddata_re_p0;//0
    dfi_rddata_ie_p0;//0
    dfi_wrdata_oe_p0;//1
    dfi_rddata_en_p0;//0
    dfi_parity_in_p0;//iclk 8'b01010101
    dfi_wck_en_p0;//0 }
    */

    /* tx ck
    {dfi_rddata_cs_p0;//0
    dfi_wrdata_cs_p0;//1
    dfi_wck_oe_p0;//1
    dfi_rddata_re_p0;//0
    dfi_rddata_ie_p0;//0
    dfi_wrdata_oe_p0;//1
    dfi_rddata_en_p0;//0
    dfi_parity_in_p0;//0 
    dfi_wck_en_p0;//valid pattern 8'b00001111}
    */
                ch0_tx_dqs1_sdr={8'h00,8'hff,8'h00,8'h00,8'h00,8'hff,8'h00,8'h55,8'h00};
                ch0_tx_dqs0_sdr={8'h00,8'hff,8'h00,8'h00,8'h00,8'hff,8'h00,8'h55,8'h00};
                ch0_tx_ck_sdr={8'h00,8'hff,8'hff,8'h00,8'h00,8'hff,8'h00,8'h00,tx_valid_pattern[7:0]};
            end
            2'b11:begin
                ch0_tx_dqs1_sdr='d0;
                ch0_tx_dqs0_sdr='d0;
                ch0_tx_ck_sdr='d0;
            end
        endcase

    case (txrx_mode[3:2])
            2'b00: begin
                ch1_tx_dqs1_sdr='d0;
                ch1_tx_dqs0_sdr='d0;
                ch1_tx_ck_sdr='d0;
            end
            2'b01:begin 
                ch1_tx_dqs1_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
                ch1_tx_dqs0_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
                ch1_tx_ck_sdr={8'hff,8'h00,8'h00,8'hff,8'hff,8'h00,8'hff,8'h00,8'h00};
            end
            2'b10:begin 
                ch1_tx_dqs1_sdr={8'h00,8'hff,8'h00,8'h00,8'h00,8'hff,8'h00,8'h55,8'h00};
                ch1_tx_dqs0_sdr={8'h00,8'hff,8'h00,8'h00,8'h00,8'hff,8'h00,8'h55,8'h00};
                ch1_tx_ck_sdr={8'h00,8'hff,8'hff,8'h00,8'h00,8'hff,8'h00,8'h00,tx_valid_pattern[7:0]};
            end
            2'b11:begin
                ch1_tx_dqs1_sdr='d0;
                ch1_tx_dqs0_sdr='d0;
                ch1_tx_ck_sdr='d0;
            end
        endcase
    end
endmodule

module link_training_sequence(
  input clk,
  input rst,
  input logic [2:0] lt_mode,
  output logic [71:0] lt_sequence_dq0,
  output logic [71:0] lt_sequence_dq1,
  output logic [63:0] lt_sequence_ca
);
  logic [1:0] cnt;
  always_ff@(posedge clk, posedge rst) begin
    if(rst) cnt<='0;
    else if(cnt==2'b11) cnt<='0;
    else cnt<=cnt+1'b1;
  end

  always_comb begin
    lt_sequence_dq0='0;
    lt_sequence_dq1='0;
    lt_sequence_ca='0;
    case(lt_mode)
      //01010101
      3'b001: begin 
          lt_sequence_dq0=72'h010101010101010101;
          lt_sequence_dq1=72'h010101010101010101;
          lt_sequence_ca=64'h0101010101010101;
        end
      //11111111 22222222 33333333 44444444
      3'b010:case(cnt)
        2'b00: begin 
          lt_sequence_dq0=72'h111111111111111111;
          lt_sequence_dq1=72'h111111111111111111;
          lt_sequence_ca=64'h1111111111111111;
        end
        2'b01: begin 
          lt_sequence_dq0=72'h222222222222222222;
          lt_sequence_dq1=72'h222222222222222222;
          lt_sequence_ca=64'h2222222222222222;
        end
        2'b10: begin 
          lt_sequence_dq0=72'h333333333333333333;
          lt_sequence_dq1=72'h333333333333333333;
          lt_sequence_ca=64'h3333333333333333;
        end
        2'b11: begin 
          lt_sequence_dq0=72'h444444444444444444;
          lt_sequence_dq1=72'h444444444444444444;
          lt_sequence_ca=64'h4444444444444444;
        end
      //software egress/igress
      default:begin
      end
      endcase
    endcase
  end
endmodule



