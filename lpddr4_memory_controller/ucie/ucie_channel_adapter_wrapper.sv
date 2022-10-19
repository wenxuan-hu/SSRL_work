module ucie_channel_adapter_wrapper  (
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
    //ucie_txrx_mode
    output logic                 o_ucie_rxfifo_write,
    output logic                 o_ucie_mode_en,
    output logic [3:0]           o_ucie_txrx_mode,
    output logic                 o_pam4_en,
    output logic [7:0]           o_pam4_cfg,
    //AHB 
    input   logic                i_hclk,
   input   logic                i_hreset,
   input   logic [31:0]         i_haddr,
   input   logic                i_hwrite,
   input   logic                i_hsel,
   input   logic [31:0]         i_hwdata,
   input   logic [1:0]          i_htrans,
   input   logic [2:0]          i_hsize,
   input   logic [2:0]          i_hburst,
   input   logic                i_hreadyin,
   output  logic                o_hready,
   output  logic [31:0]         o_hrdata,
   output  logic [1:0]          o_hresp
);

//CSR
  logic rxfifo_clr;
     logic [3:0] txrx_mode; // bit(3_2) for channel 1;  bit(1_0) for channel 0. 2'b00: disable all(hiz); 2'b01: rx_mode; 2'b10: tx_mode; 2'b11 reserved(hiz)
      logic                     buf_mode;
     logic                     buf_clk_en;
     logic                     intf_pipe_en;
     logic                     ts_enable;
     logic                     ts_reset;
     logic                     ts_brkpt_en;
     logic [15:0]              ts_brkpt_val;

     logic                     ig_loop_mode;
     logic [3:0]               ig_num_loops;
     logic                     ig_load_ptr;
     logic [4:0]               ig_stop_ptr;
     logic [4:0]               ig_start_ptr;
     logic                     ig_wdata_clr;
     logic                     ig_wdata_hold;
     logic                     ig_wdata_en;
     logic                     ig_wdata_upd;
     logic [31:0]              ig_wdata;
    logic                     ig_empty;
    logic                     ig_write_done;
    logic                     ig_full;
    logic                     ig_overflow;

     logic                     eg_rdata_clr;
     logic                     eg_rdata_en;
     logic                     eg_rdata_upd;
    logic [31:0]              eg_rdata;
    logic                     eg_empty;
    logic                     eg_read_done;
    logic                     eg_full;
    logic                     eg_overflow;
    logic [31:0]              debug;

    logic ucie_rxfifo_write;
    logic ucie_mode_en;
    logic [3:0] txrx_mode_sync;
    logic [7:0] pam4_cfg;
    logic [7:0] pam4_cfg_sync;

// Synchronize CSR controls
   ddr_demet_r u_demet_0 (.i_clk(clk), .i_rst(rst), .i_d(ucie_mode_en),        .o_q(o_ucie_mode_en));
   ddr_demet_r u_demet_11 (.i_clk(clk), .i_rst(rst), .i_d(txrx_mode[0] ),        .o_q(txrx_mode_sync[0] ));
   ddr_demet_r u_demet_12 (.i_clk(clk), .i_rst(rst), .i_d(txrx_mode[1] ),        .o_q(txrx_mode_sync[1] ));
   ddr_demet_r u_demet_13 (.i_clk(clk), .i_rst(rst), .i_d(txrx_mode[2] ),        .o_q(txrx_mode_sync[2] ));
   ddr_demet_r u_demet_14 (.i_clk(clk), .i_rst(rst), .i_d(txrx_mode[3] ),        .o_q(txrx_mode_sync[3] ));
   assign o_ucie_txrx_mode=txrx_mode_sync;
   ddr_demet_r u_demet_2 (.i_clk(clk), .i_rst(rst), .i_d(ucie_rxfifo_write),      .o_q(o_ucie_rxfifo_write));
   ddr_demet_r u_demet_3 (.i_clk(clk), .i_rst(rst), .i_d(pam4_en),      .o_q(o_pam4_en));

   ddr_demet_r u_demet_21 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[0] ),        .o_q(o_pam4_cfg[0] ));
   ddr_demet_r u_demet_22 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[1] ),        .o_q(o_pam4_cfg[1] ));
   ddr_demet_r u_demet_23 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[2] ),        .o_q(o_pam4_cfg[2] ));
   ddr_demet_r u_demet_24 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[3] ),        .o_q(o_pam4_cfg[3] ));
   
   ddr_demet_r u_demet_25 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[4] ),        .o_q(o_pam4_cfg[4] ));
   ddr_demet_r u_demet_26 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[5] ),        .o_q(o_pam4_cfg[5] ));
   ddr_demet_r u_demet_27 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[6] ),        .o_q(o_pam4_cfg[6] ));
   ddr_demet_r u_demet_28 (.i_clk(clk), .i_rst(rst), .i_d(pam4_cfg[7] ),        .o_q(o_pam4_cfg[7] ));


ucie_ahb_csr #(
    .AWIDTH             (32),
    .DWIDTH             (32)
) u_ucie_ahb_csr (
    .i_hclk             (i_hclk),
    .i_hreset           (i_hreset),
    .i_haddr            (i_haddr),
    .i_hwrite           (i_hwrite),
    .i_hsel             (i_hsel),
    .i_hwdata           (i_hwdata),
    .i_htrans           (i_htrans),
    .i_hsize            (i_hsize),
    .i_hburst           (i_hburst),
    .i_hreadyin         (i_hreadyin),
    .o_hready           (o_hready),
    .o_hrdata           (o_hrdata),
    .o_hresp            (o_hresp),
    //CSR
    .o_ucie_rxfifo_write(ucie_rxfifo_write),
    .o_ucie_mode_en     (ucie_mode_en),
    .o_pam4_en          (pam4_en),
    .o_pam4_cfg         (pam4_cfg),
    .o_txrx_mode        (txrx_mode),
    .o_rxfifo_clr       (rxfifo_clr),
    .o_buf_mode         (buf_mode),
    .o_buf_clk_en       (buf_clk_en),
    .o_intf_pipe_en     (intf_pipe_en),
    .o_ts_enable        (ts_enable),
    .o_ts_reset         (ts_reset),
    .o_ts_brkpt_en      (ts_brkpt_en),
    .o_ts_brkpt_val     (ts_brkpt_val),
    .o_ig_loop_mode     (ig_loop_mode),
    .o_ig_num_loops     (ig_num_loops),
    .o_ig_load_ptr      (ig_load_ptr),
    .o_ig_stop_ptr      (ig_stop_ptr),
    .o_ig_start_ptr     (ig_start_ptr),
    .o_ig_wdata_clr     (ig_wdata_clr),
    .o_ig_wdata_hold    (ig_wdata_hold),
    .o_ig_wdata_en      (ig_wdata_en),
    .o_ig_wdata_upd     (ig_wdata_upd),
    .o_ig_wdata         (ig_wdata),
    .i_ig_empty         (ig_empty),
    .i_ig_write_done    (ig_write_done),
    .i_ig_full          (ig_full),
    .i_ig_overflow      (ig_overflow),
    .o_eg_rdata_clr     (eg_rdata_clr),
    .o_eg_rdata_en      (eg_rdata_en),
    .o_eg_rdata_upd     (eg_rdata_upd),
    .i_eg_rdata         (eg_rdata),
    .i_eg_empty         (eg_empty),
    .i_eg_read_done     (eg_read_done),
    .i_eg_full          (eg_full),
    .i_eg_overflow      (eg_overflow),
    .i_debug            (debug)
);

ucie_channel_adapter u_ucie_channel_adapter (
    //clk,rst
    .fwd_clk               (fwd_clk),
    .clk                   (clk),
    .rst                   (rst),
    //RDI mainband
    .lp_data               (lp_data),
    .lp_valid              (lp_valid),
    .lp_irdy               (lp_irdy),
    .pl_trdy               (pl_trdy),
    .pl_data               (pl_data),
    .pl_valid              (pl_valid),
    //RDI sideband
    .lp_cfg                (lp_cfg),
    .lp_cfg_vld            (lp_cfg_vld),
    .lp_cfg_crd            (lp_cfg_crd),
    .pl_cfg                (pl_cfg),
    .pl_cfg_vld            (pl_cfg_vld),
    .pl_cfg_crd            (pl_cfg_crd),
    //SDR interface channel-0
    .ch0_tx_dq0_sdr        (ch0_tx_dq0_sdr),
    .ch0_tx_dq0_pam4_sdr        (ch0_tx_dq0_pam4_sdr),
    .ch0_rx_dq0_sdr        (ch0_rx_dq0_sdr),
    .ch0_rx_dq0_pam4_sdr        (ch0_rx_dq0_pam4_sdr),
    .ch0_rx_dq0_sdr_vld    (ch0_rx_dq0_sdr_vld),
    .ch0_tx_dqs0_sdr       (ch0_tx_dqs0_sdr),
    .ch0_tx_dq1_sdr        (ch0_tx_dq1_sdr),
    .ch0_tx_dq1_pam4_sdr        (ch0_tx_dq1_pam4_sdr),
    .ch0_rx_dq1_sdr        (ch0_rx_dq1_sdr),
    .ch0_rx_dq1_pam4_sdr        (ch0_rx_dq1_pam4_sdr),
    .ch0_rx_dq1_sdr_vld    (ch0_rx_dq1_sdr_vld),
    .ch0_tx_dqs1_sdr       (ch0_tx_dqs1_sdr),
    .ch0_tx_ca_sdr         (ch0_tx_ca_sdr),
    .ch0_tx_ca_pam4_sdr         (ch0_tx_ca_pam4_sdr),
    .ch0_rx_ca_sdr         (ch0_rx_ca_sdr),
    .ch0_rx_ca_pam4_sdr         (ch0_rx_ca_pam4_sdr),
    .ch0_rx_ca_sdr_vld     (ch0_rx_ca_sdr_vld),
    .ch0_tx_ck_sdr         (ch0_tx_ck_sdr),
    //SDR interface channel-1
    .ch1_tx_dq0_sdr        (ch1_tx_dq0_sdr),
    .ch1_tx_dq0_pam4_sdr        (ch1_tx_dq0_pam4_sdr),
    .ch1_rx_dq0_sdr        (ch1_rx_dq0_sdr),
    .ch1_rx_dq0_pam4_sdr        (ch1_rx_dq0_pam4_sdr),
    .ch1_rx_dq0_sdr_vld    (ch1_rx_dq0_sdr_vld),
    .ch1_tx_dqs0_sdr       (ch1_tx_dqs0_sdr),
    .ch1_tx_dq1_sdr        (ch1_tx_dq1_sdr),
    .ch1_tx_dq1_pam4_sdr        (ch1_tx_dq1_pam4_sdr),
    .ch1_rx_dq1_sdr        (ch1_rx_dq1_sdr),
    .ch1_rx_dq1_pam4_sdr        (ch1_rx_dq1_pam4_sdr),
    .ch1_rx_dq1_sdr_vld    (ch1_rx_dq1_sdr_vld),
    .ch1_tx_dqs1_sdr       (ch1_tx_dqs1_sdr),
    .ch1_tx_ca_sdr         (ch1_tx_ca_sdr),
    .ch1_tx_ca_pam4_sdr         (ch1_tx_ca_pam4_sdr),
    .ch1_rx_ca_sdr         (ch1_rx_ca_sdr),
    .ch1_rx_ca_pam4_sdr         (ch1_rx_ca_pam4_sdr),
    .ch1_rx_ca_sdr_vld     (ch1_rx_ca_sdr_vld),
    .ch1_tx_ck_sdr         (ch1_tx_ck_sdr),
    //CSR
    .i_txrx_mode           (txrx_mode),
    .i_rxfifo_clr          (rxfifo_clr),
    .i_buf_mode            (buf_mode),
    .i_pam4_en             (pam4_en),
    .i_buf_clk_en          (buf_clk_en),
    .i_intf_pipe_en        (intf_pipe_en),
    .i_ts_enable           (ts_enable),
    .i_ts_reset            (ts_reset),
    .i_ts_brkpt_en         (ts_brkpt_en),
    .i_ts_brkpt_val        (ts_brkpt_val),
    .i_ig_loop_mode        (ig_loop_mode),
    .i_ig_num_loops        (ig_num_loops),
    .i_ig_load_ptr         (ig_load_ptr),
    .i_ig_stop_ptr         (ig_stop_ptr),
    .i_ig_start_ptr        (ig_start_ptr),
    .i_ig_wdata_clr        (ig_wdata_clr),
    .i_ig_wdata_hold       (ig_wdata_hold),
    .i_ig_wdata_en         (ig_wdata_en),
    .i_ig_wdata_upd        (ig_wdata_upd),
    .i_ig_wdata            (ig_wdata),
    .o_ig_empty            (ig_empty),
    .o_ig_write_done       (ig_write_done),
    .o_ig_full             (ig_full),
    .o_ig_overflow         (ig_overflow),
    .i_eg_rdata_clr        (eg_rdata_clr),
    .i_eg_rdata_en         (eg_rdata_en),
    .i_eg_rdata_upd        (eg_rdata_upd),
    .o_eg_rdata            (eg_rdata),
    .o_eg_empty            (eg_empty),
    .o_eg_read_done        (eg_read_done),
    .o_eg_full             (eg_full),
    .o_eg_overflow         (eg_overflow),
    .o_debug               (debug)
);

endmodule