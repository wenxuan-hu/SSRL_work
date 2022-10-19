module dfi_core (

   // Scan
   input  logic                      i_scan_mode,
   input  logic                      i_scan_rst_ctrl,
   input  logic                      i_scan_cgc_ctrl,

   // Clock and reset
   input  logic                      i_rst,

   input  logic                      i_phy_clk,
   input  logic                      i_dfiwr_clk_1,
   input  logic                      i_dfiwr_clk_2,
   input  logic                      i_dfird_clk_1,
   input  logic                      i_dfird_clk_2,

   //DFI signals

   input  logic                     i_dbi_en,
   input  logic                     i_dbi_ones,
   input  logic                     i_dbi_pipe_en, 
   input  logic                     i_dbi_mask,

   input  logic                     i_buf_mode,
   input  logic                     i_buf_clk_en,
   input  logic                     i_intf_pipe_en,
   input  logic                     i_ts_enable,
   input  logic                     i_ts_reset,
   input  logic                     i_ts_brkpt_en,
   input  logic [15:0]              i_ts_brkpt_val,

   input  logic                     i_ig_loop_mode,
   input  logic [3:0]               i_ig_num_loops,
   input  logic                     i_ig_load_ptr,
   input  logic [6:0]               i_ig_stop_ptr,
   input  logic [6:0]               i_ig_start_ptr,
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

   input  logic                     i_dfi_rdout_en,

   input  logic                     i_txrx_mode,

   input logic                      i_ck_en,
   input logic                      i_ck_pattern,

   input logic [7:0] i_preamble,
   input logic [7:0] i_postamble,
   input logic [7:0] i_wlevel_en,
   input logic [7:0] i_wlevel_strobe,
   input logic [7:0] i_dqs_default_seq,

   input logic [4:0] i_dfiwr_latency, 
   input logic [1:0] i_dqs_mode,

   // Command
   input  logic                      i_dfi_reset_n_p0,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p1,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p2,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p3,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p4,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p5,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p6,              // DDR/3/4/5 and LPDDR4/5
   input  logic                      i_dfi_reset_n_p7,              // DDR/3/4/5 and LPDDR4/5

   input  logic [5:0]                i_dfi_ca_p0,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p1,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p2,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p3,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p4,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p5,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p6,              // For DDR4 bits[16:14] are not used
   input  logic [5:0]                i_dfi_ca_p7,              // For DDR4 bits[16:14] are not used
   input  logic                      i_dfi_cke_p0,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p1,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p2,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p3,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p4,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p5,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p6,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cke_p7,                  // DDR1/2/3/4 and LPDDR3/4
   input  logic                      i_dfi_cs_p0,
   input  logic                      i_dfi_cs_p1,
   input  logic                      i_dfi_cs_p2,
   input  logic                      i_dfi_cs_p3,
   input  logic                      i_dfi_cs_p4,
   input  logic                      i_dfi_cs_p5,
   input  logic                      i_dfi_cs_p6,
   input  logic                      i_dfi_cs_p7,

   // Write Data
   input  logic                      i_dfi_wrdata_en_p0,
   input  logic                      i_dfi_wrdata_en_p1,
   input  logic                      i_dfi_wrdata_en_p2,
   input  logic                      i_dfi_wrdata_en_p3,
   input  logic                      i_dfi_wrdata_en_p4,
   input  logic                      i_dfi_wrdata_en_p5,
   input  logic                      i_dfi_wrdata_en_p6,
   input  logic                      i_dfi_wrdata_en_p7,
   input  logic [31:0]              i_dfi_wrdata_p0,
   input  logic [31:0]              i_dfi_wrdata_p1,
   input  logic [31:0]              i_dfi_wrdata_p2,
   input  logic [31:0]              i_dfi_wrdata_p3,
   input  logic [31:0]              i_dfi_wrdata_p4,
   input  logic [31:0]              i_dfi_wrdata_p5,
   input  logic [31:0]              i_dfi_wrdata_p6,
   input  logic [31:0]              i_dfi_wrdata_p7,
   input  logic [3:0]               i_dfi_wrdata_mask_p0,
   input  logic [3:0]               i_dfi_wrdata_mask_p1,
   input  logic [3:0]               i_dfi_wrdata_mask_p2,
   input  logic [3:0]               i_dfi_wrdata_mask_p3,
   input  logic [3:0]               i_dfi_wrdata_mask_p4,
   input  logic [3:0]               i_dfi_wrdata_mask_p5,
   input  logic [3:0]               i_dfi_wrdata_mask_p6,
   input  logic [3:0]               i_dfi_wrdata_mask_p7,

   // Read Data
   input  logic                      i_dfi_rddata_en_p0,
   input  logic                      i_dfi_rddata_en_p1,
   input  logic                      i_dfi_rddata_en_p2,
   input  logic                      i_dfi_rddata_en_p3,
   input  logic                      i_dfi_rddata_en_p4,
   input  logic                      i_dfi_rddata_en_p5,
   input  logic                      i_dfi_rddata_en_p6,
   input  logic                      i_dfi_rddata_en_p7,

   output logic [63:0]              o_dfi_rddata_p0,
   output logic [63:0]              o_dfi_rddata_p1,
   output logic [63:0]              o_dfi_rddata_p2,
   output logic [63:0]              o_dfi_rddata_p3,
   output logic                      o_dfi_rddata_valid_p0,
   output logic                      o_dfi_rddata_valid_p1,
   output logic                      o_dfi_rddata_valid_p2,
   output logic                      o_dfi_rddata_valid_p3,

   output logic [71:0]              o_ch0_dq0_sdr,
   output logic [7:0]               o_ch0_dqs0_sdr,
   input  logic [71:0]              i_ch0_dq0_sdr,
   input  logic [8:0]               i_ch0_dq0_sdr_vld,
   output logic [71:0]              o_ch0_dq1_sdr,
   output logic [7:0]               o_ch0_dqs1_sdr,
   input  logic [71:0]              i_ch0_dq1_sdr,
   input  logic [8:0]               i_ch0_dq1_sdr_vld,
   
   output logic [63:0]              o_ch0_ca_sdr,
   output logic [7:0]               o_ch0_ck_sdr,


   output logic [71:0]              o_ch1_dq0_sdr,
   output logic [7:0]               o_ch1_dqs0_sdr,
   input  logic [71:0]              i_ch1_dq0_sdr,
   input  logic [8:0]               i_ch1_dq0_sdr_vld,
   output logic [71:0]              o_ch1_dq1_sdr,
   output logic [7:0]               o_ch1_dqs1_sdr,
   input  logic [71:0]              i_ch1_dq1_sdr,
   input  logic [8:0]               i_ch1_dq1_sdr_vld,
   
   output logic [63:0]              o_ch1_ca_sdr,
   output logic [7:0]               o_ch1_ck_sdr,


   //external interface
   input  logic [71:0]              i_ch0_tx0_sdr,
   input  logic [7:0]               i_ch0_tx_ck0_sdr,
   output logic [71:0]              o_ch0_rx0_sdr,
   output logic [8:0]               o_ch0_rx0_sdr_vld,
   input  logic [71:0]              i_ch0_tx1_sdr,
   input  logic [7:0]               i_ch0_tx_ck1_sdr,
   output logic [71:0]              o_ch0_rx1_sdr,
   output logic [8:0]               o_ch0_rx1_sdr_vld,

   input  logic [71:0]              i_ch1_tx0_sdr,
   input  logic [7:0]               i_ch1_tx_ck0_sdr,
   output logic [71:0]              o_ch1_rx0_sdr,
   output logic [8:0]               o_ch1_rx0_sdr_vld,
   input  logic [71:0]              i_ch1_tx1_sdr,
   input  logic [7:0]               i_ch1_tx_ck1_sdr,
   output logic [71:0]              o_ch1_rx1_sdr,
   output logic [8:0]               o_ch1_rx1_sdr_vld,

   output logic [31:0]              o_debug
);

   logic [5:0]                    ch0_dfi_ca_p0;
   logic                          ch0_dfi_cke_p0;
   logic                          ch0_dfi_cs_p0;

   logic [5:0]                    ch0_dfi_ca_p1;
   logic                          ch0_dfi_cke_p1;
   logic                          ch0_dfi_cs_p1;

   logic [5:0]                    ch0_dfi_ca_p2;
   logic                          ch0_dfi_cke_p2;
   logic                          ch0_dfi_cs_p2;

   logic [5:0]                    ch0_dfi_ca_p3;
   logic                          ch0_dfi_cke_p3;
   logic                          ch0_dfi_cs_p3;

   logic [5:0]                    ch0_dfi_ca_p4;
   logic                          ch0_dfi_cke_p4;
   logic                          ch0_dfi_cs_p4;

   logic [5:0]                    ch0_dfi_ca_p5;
   logic                          ch0_dfi_cke_p5;
   logic                          ch0_dfi_cs_p5;

   logic [5:0]                    ch0_dfi_ca_p6;
   logic                          ch0_dfi_cke_p6;
   logic                          ch0_dfi_cs_p6;          

   logic [5:0]                    ch0_dfi_ca_p7;
   logic                          ch0_dfi_cke_p7;
   logic                          ch0_dfi_cs_p7;

   logic [5:0]                    ch1_dfi_ca_p0;
   logic                          ch1_dfi_cke_p0;
   logic                          ch1_dfi_cs_p0;

   logic [5:0]                    ch1_dfi_ca_p1;
   logic                          ch1_dfi_cke_p1;
   logic                          ch1_dfi_cs_p1;

   logic [5:0]                    ch1_dfi_ca_p2;
   logic                          ch1_dfi_cke_p2;
   logic                          ch1_dfi_cs_p2;

   logic [5:0]                    ch1_dfi_ca_p3;
   logic                          ch1_dfi_cke_p3;
   logic                          ch1_dfi_cs_p3;

   logic [5:0]                    ch1_dfi_ca_p4;
   logic                          ch1_dfi_cke_p4;
   logic                          ch1_dfi_cs_p4;

   logic [5:0]                    ch1_dfi_ca_p5;
   logic                          ch1_dfi_cke_p5;
   logic                          ch1_dfi_cs_p5;

   logic [5:0]                    ch1_dfi_ca_p6;
   logic                          ch1_dfi_cke_p6;
   logic                          ch1_dfi_cs_p6;

   logic [5:0]                    ch1_dfi_ca_p7;
   logic                          ch1_dfi_cke_p7;
   logic                          ch1_dfi_cs_p7;

   logic [7:0]        ch0_dq0_dfi_wrdata_p0;
   logic [7:0]        ch0_dq0_dfi_wrdata_p1;
   logic [7:0]        ch0_dq0_dfi_wrdata_p2;
   logic [7:0]        ch0_dq0_dfi_wrdata_p3;
   logic [7:0]        ch0_dq0_dfi_wrdata_p4;
   logic [7:0]        ch0_dq0_dfi_wrdata_p5;
   logic [7:0]        ch0_dq0_dfi_wrdata_p6;
   logic [7:0]        ch0_dq0_dfi_wrdata_p7;

   logic              ch0_dq0_dfi_wrdata_mask_p0;
   logic              ch0_dq0_dfi_wrdata_mask_p1;
   logic              ch0_dq0_dfi_wrdata_mask_p2;
   logic              ch0_dq0_dfi_wrdata_mask_p3;
   logic              ch0_dq0_dfi_wrdata_mask_p4;
   logic              ch0_dq0_dfi_wrdata_mask_p5;
   logic              ch0_dq0_dfi_wrdata_mask_p6;
   logic              ch0_dq0_dfi_wrdata_mask_p7;

   logic [7:0]        ch0_dq1_dfi_wrdata_p0;
   logic [7:0]        ch0_dq1_dfi_wrdata_p1;
   logic [7:0]        ch0_dq1_dfi_wrdata_p2;
   logic [7:0]        ch0_dq1_dfi_wrdata_p3;
   logic [7:0]        ch0_dq1_dfi_wrdata_p4;
   logic [7:0]        ch0_dq1_dfi_wrdata_p5;
   logic [7:0]        ch0_dq1_dfi_wrdata_p6;
   logic [7:0]        ch0_dq1_dfi_wrdata_p7;

   logic              ch0_dq1_dfi_wrdata_mask_p0;
   logic              ch0_dq1_dfi_wrdata_mask_p1;
   logic              ch0_dq1_dfi_wrdata_mask_p2;
   logic              ch0_dq1_dfi_wrdata_mask_p3;
   logic              ch0_dq1_dfi_wrdata_mask_p4;
   logic              ch0_dq1_dfi_wrdata_mask_p5;
   logic              ch0_dq1_dfi_wrdata_mask_p6;
   logic              ch0_dq1_dfi_wrdata_mask_p7;

   logic [7:0]        ch1_dq0_dfi_wrdata_p0;
   logic [7:0]        ch1_dq0_dfi_wrdata_p1;
   logic [7:0]        ch1_dq0_dfi_wrdata_p2;
   logic [7:0]        ch1_dq0_dfi_wrdata_p3;
   logic [7:0]        ch1_dq0_dfi_wrdata_p4;
   logic [7:0]        ch1_dq0_dfi_wrdata_p5;
   logic [7:0]        ch1_dq0_dfi_wrdata_p6;
   logic [7:0]        ch1_dq0_dfi_wrdata_p7;

   logic              ch1_dq0_dfi_wrdata_mask_p0;
   logic              ch1_dq0_dfi_wrdata_mask_p1;
   logic              ch1_dq0_dfi_wrdata_mask_p2;
   logic              ch1_dq0_dfi_wrdata_mask_p3;
   logic              ch1_dq0_dfi_wrdata_mask_p4;
   logic              ch1_dq0_dfi_wrdata_mask_p5;
   logic              ch1_dq0_dfi_wrdata_mask_p6;
   logic              ch1_dq0_dfi_wrdata_mask_p7;

   logic [7:0]        ch1_dq1_dfi_wrdata_p0;
   logic [7:0]        ch1_dq1_dfi_wrdata_p1;
   logic [7:0]        ch1_dq1_dfi_wrdata_p2;
   logic [7:0]        ch1_dq1_dfi_wrdata_p3;
   logic [7:0]        ch1_dq1_dfi_wrdata_p4;
   logic [7:0]        ch1_dq1_dfi_wrdata_p5;
   logic [7:0]        ch1_dq1_dfi_wrdata_p6;
   logic [7:0]        ch1_dq1_dfi_wrdata_p7;

   logic              ch1_dq1_dfi_wrdata_mask_p0;
   logic              ch1_dq1_dfi_wrdata_mask_p1;
   logic              ch1_dq1_dfi_wrdata_mask_p2;
   logic              ch1_dq1_dfi_wrdata_mask_p3;
   logic              ch1_dq1_dfi_wrdata_mask_p4;
   logic              ch1_dq1_dfi_wrdata_mask_p5;
   logic              ch1_dq1_dfi_wrdata_mask_p6;
   logic              ch1_dq1_dfi_wrdata_mask_p7;

   logic                          ch0_dq0_dfi_wrdata_en_p0;
   logic                          ch0_dq0_dfi_wrdata_en_p1;
   logic                          ch0_dq0_dfi_wrdata_en_p2;
   logic                          ch0_dq0_dfi_wrdata_en_p3;
   logic                          ch0_dq0_dfi_wrdata_en_p4;
   logic                          ch0_dq0_dfi_wrdata_en_p5;
   logic                          ch0_dq0_dfi_wrdata_en_p6;
   logic                          ch0_dq0_dfi_wrdata_en_p7;

   logic                          ch0_dq1_dfi_wrdata_en_p0;
   logic                          ch0_dq1_dfi_wrdata_en_p1;
   logic                          ch0_dq1_dfi_wrdata_en_p2;
   logic                          ch0_dq1_dfi_wrdata_en_p3;
   logic                          ch0_dq1_dfi_wrdata_en_p4;
   logic                          ch0_dq1_dfi_wrdata_en_p5;
   logic                          ch0_dq1_dfi_wrdata_en_p6;
   logic                          ch0_dq1_dfi_wrdata_en_p7;

   logic                          ch1_dq0_dfi_wrdata_en_p0;
   logic                          ch1_dq0_dfi_wrdata_en_p1;
   logic                          ch1_dq0_dfi_wrdata_en_p2;
   logic                          ch1_dq0_dfi_wrdata_en_p3;
   logic                          ch1_dq0_dfi_wrdata_en_p4;
   logic                          ch1_dq0_dfi_wrdata_en_p5;
   logic                          ch1_dq0_dfi_wrdata_en_p6;
   logic                          ch1_dq0_dfi_wrdata_en_p7;

   logic                          ch1_dq1_dfi_wrdata_en_p0;
   logic                          ch1_dq1_dfi_wrdata_en_p1;
   logic                          ch1_dq1_dfi_wrdata_en_p2;
   logic                          ch1_dq1_dfi_wrdata_en_p3;
   logic                          ch1_dq1_dfi_wrdata_en_p4;
   logic                          ch1_dq1_dfi_wrdata_en_p5;
   logic                          ch1_dq1_dfi_wrdata_en_p6;
   logic                          ch1_dq1_dfi_wrdata_en_p7;

   logic                          ch0_dq0_dfi_rddata_en_p0;
   logic                          ch0_dq0_dfi_rddata_en_p1;
   logic                          ch0_dq0_dfi_rddata_en_p2;
   logic                          ch0_dq0_dfi_rddata_en_p3;
   logic                          ch0_dq0_dfi_rddata_en_p4;
   logic                          ch0_dq0_dfi_rddata_en_p5;
   logic                          ch0_dq0_dfi_rddata_en_p6;
   logic                          ch0_dq0_dfi_rddata_en_p7;

   logic                          ch0_dq1_dfi_rddata_en_p0;
   logic                          ch0_dq1_dfi_rddata_en_p1;
   logic                          ch0_dq1_dfi_rddata_en_p2;
   logic                          ch0_dq1_dfi_rddata_en_p3;
   logic                          ch0_dq1_dfi_rddata_en_p4;
   logic                          ch0_dq1_dfi_rddata_en_p5;
   logic                          ch0_dq1_dfi_rddata_en_p6;
   logic                          ch0_dq1_dfi_rddata_en_p7;

   logic                          ch1_dq0_dfi_rddata_en_p0;
   logic                          ch1_dq0_dfi_rddata_en_p1;
   logic                          ch1_dq0_dfi_rddata_en_p2;
   logic                          ch1_dq0_dfi_rddata_en_p3;
   logic                          ch1_dq0_dfi_rddata_en_p4;
   logic                          ch1_dq0_dfi_rddata_en_p5;
   logic                          ch1_dq0_dfi_rddata_en_p6;
   logic                          ch1_dq0_dfi_rddata_en_p7;

   logic                          ch1_dq1_dfi_rddata_en_p0;
   logic                          ch1_dq1_dfi_rddata_en_p1;
   logic                          ch1_dq1_dfi_rddata_en_p2;
   logic                          ch1_dq1_dfi_rddata_en_p3;
   logic                          ch1_dq1_dfi_rddata_en_p4;
   logic                          ch1_dq1_dfi_rddata_en_p5;
   logic                          ch1_dq1_dfi_rddata_en_p6;
   logic                          ch1_dq1_dfi_rddata_en_p7;

   logic [7:0]        dq0_dfi_rddata_w0;
   logic [7:0]        dq0_dfi_rddata_w1;
   logic [7:0]        dq0_dfi_rddata_w2;
   logic [7:0]        dq0_dfi_rddata_w3;
   logic [7:0]        dq0_dfi_rddata_w4;
   logic [7:0]        dq0_dfi_rddata_w5;
   logic [7:0]        dq0_dfi_rddata_w6;
   logic [7:0]        dq0_dfi_rddata_w7;
   logic [7:0]        dq1_dfi_rddata_w0;
   logic [7:0]        dq1_dfi_rddata_w1;
   logic [7:0]        dq1_dfi_rddata_w2;
   logic [7:0]        dq1_dfi_rddata_w3;
   logic [7:0]        dq1_dfi_rddata_w4;
   logic [7:0]        dq1_dfi_rddata_w5;
   logic [7:0]        dq1_dfi_rddata_w6;
   logic [7:0]        dq1_dfi_rddata_w7;
   logic [7:0]        dq2_dfi_rddata_w0;
   logic [7:0]        dq2_dfi_rddata_w1;
   logic [7:0]        dq2_dfi_rddata_w2;
   logic [7:0]        dq2_dfi_rddata_w3;
   logic [7:0]        dq2_dfi_rddata_w4;
   logic [7:0]        dq2_dfi_rddata_w5;
   logic [7:0]        dq2_dfi_rddata_w6;
   logic [7:0]        dq2_dfi_rddata_w7;
   logic [7:0]        dq3_dfi_rddata_w0;
   logic [7:0]        dq3_dfi_rddata_w1;
   logic [7:0]        dq3_dfi_rddata_w2;
   logic [7:0]        dq3_dfi_rddata_w3;
   logic [7:0]        dq3_dfi_rddata_w4;
   logic [7:0]        dq3_dfi_rddata_w5;
   logic [7:0]        dq3_dfi_rddata_w6;
   logic [7:0]        dq3_dfi_rddata_w7;

   logic         dq0_dfi_rddata_dbi_w0;
   logic         dq0_dfi_rddata_dbi_w1;
   logic         dq0_dfi_rddata_dbi_w2;
   logic         dq0_dfi_rddata_dbi_w3;
   logic         dq0_dfi_rddata_dbi_w4;
   logic         dq0_dfi_rddata_dbi_w5;
   logic         dq0_dfi_rddata_dbi_w6;
   logic         dq0_dfi_rddata_dbi_w7;
   logic         dq1_dfi_rddata_dbi_w0;
   logic         dq1_dfi_rddata_dbi_w1;
   logic         dq1_dfi_rddata_dbi_w2;
   logic         dq1_dfi_rddata_dbi_w3;
   logic         dq1_dfi_rddata_dbi_w4;
   logic         dq1_dfi_rddata_dbi_w5;
   logic         dq1_dfi_rddata_dbi_w6;
   logic         dq1_dfi_rddata_dbi_w7;
   logic         dq2_dfi_rddata_dbi_w0;
   logic         dq2_dfi_rddata_dbi_w1;
   logic         dq2_dfi_rddata_dbi_w2;
   logic         dq2_dfi_rddata_dbi_w3;
   logic         dq2_dfi_rddata_dbi_w4;
   logic         dq2_dfi_rddata_dbi_w5;
   logic         dq2_dfi_rddata_dbi_w6;
   logic         dq2_dfi_rddata_dbi_w7;
   logic         dq3_dfi_rddata_dbi_w0;
   logic         dq3_dfi_rddata_dbi_w1;
   logic         dq3_dfi_rddata_dbi_w2;
   logic         dq3_dfi_rddata_dbi_w3;
   logic         dq3_dfi_rddata_dbi_w4;
   logic         dq3_dfi_rddata_dbi_w5;
   logic         dq3_dfi_rddata_dbi_w6;
   logic         dq3_dfi_rddata_dbi_w7;

   //rddata valid
   logic [7:0]               dq0_dfi_rddata_valid;
   //for egress
   logic [7:0]               dq1_dfi_rddata_valid;
   logic [7:0]               dq2_dfi_rddata_valid;
   logic [7:0]               dq3_dfi_rddata_valid;


dfi_injector u_dfi_injector (
    .i_scan_mode                     (i_scan_mode),
    .i_scan_rst_ctrl                 (i_scan_rst_ctrl),
    .i_scan_cgc_ctrl                 (i_scan_cgc_ctrl),
    .i_clk                           (i_phy_clk),
    .i_rst                           (i_rst),
    //csr
    .i_dbi_en                        (i_dbi_en),
    .i_dbi_ones                      (i_dbi_ones),
    .i_dbi_pipe_en                   (i_dbi_pipe_en),
    .i_dbi_mask                      (i_dbi_mask),
    .i_buf_mode                      (i_buf_mode),
    .i_buf_clk_en                    (i_buf_clk_en),
    .i_intf_pipe_en                  (i_intf_pipe_en),
    .i_ts_enable                     (i_ts_enable),
    .i_ts_reset                      (i_ts_reset),
    .i_ts_brkpt_en                   (i_ts_brkpt_en),
    .i_ts_brkpt_val                  (i_ts_brkpt_val),
    .i_ig_loop_mode                  (i_ig_loop_mode),
    .i_ig_num_loops                  (i_ig_num_loops),
    .i_ig_load_ptr                   (i_ig_load_ptr),
    .i_ig_stop_ptr                   (i_ig_stop_ptr),
    .i_ig_start_ptr                  (i_ig_start_ptr),
    .i_ig_wdata_clr                  (i_ig_wdata_clr),
    .i_ig_wdata_hold                 (i_ig_wdata_hold),
    .i_ig_wdata_en                   (i_ig_wdata_en),
    .i_ig_wdata_upd                  (i_ig_wdata_upd),
    .i_ig_wdata                      (i_ig_wdata),
    .o_ig_empty                      (o_ig_empty),
    .o_ig_write_done                 (o_ig_write_done),
    .o_ig_full                       (o_ig_full),
    .o_ig_overflow                   (o_ig_overflow),
    .i_eg_rdata_clr                  (i_eg_rdata_clr),
    .i_eg_rdata_en                   (i_eg_rdata_en),
    .i_eg_rdata_upd                  (i_eg_rdata_upd),
    .o_eg_rdata                      (o_eg_rdata),
    .o_eg_empty                      (o_eg_empty),
    .o_eg_read_done                  (o_eg_read_done),
    .o_eg_full                       (o_eg_full),
    .o_eg_overflow                   (o_eg_overflow),
    // Write Command ca Data
    .i_dfi_ca_p0                     (i_dfi_ca_p0),
    .i_dfi_ca_p1                     (i_dfi_ca_p1),
    .i_dfi_ca_p2                     (i_dfi_ca_p2),
    .i_dfi_ca_p3                     (i_dfi_ca_p3),
    .i_dfi_ca_p4                     (i_dfi_ca_p4),
    .i_dfi_ca_p5                     (i_dfi_ca_p5),
    .i_dfi_ca_p6                     (i_dfi_ca_p6),
    .i_dfi_ca_p7                     (i_dfi_ca_p7),
    .i_dfi_cke_p0                    (i_dfi_cke_p0),
    .i_dfi_cke_p1                    (i_dfi_cke_p1),
    .i_dfi_cke_p2                    (i_dfi_cke_p2),
    .i_dfi_cke_p3                    (i_dfi_cke_p3),
    .i_dfi_cke_p4                    (i_dfi_cke_p4),
    .i_dfi_cke_p5                    (i_dfi_cke_p5),
    .i_dfi_cke_p6                    (i_dfi_cke_p6),
    .i_dfi_cke_p7                    (i_dfi_cke_p7),
    .i_dfi_cs_p0                     (i_dfi_cs_p0),
    .i_dfi_cs_p1                     (i_dfi_cs_p1),
    .i_dfi_cs_p2                     (i_dfi_cs_p2),
    .i_dfi_cs_p3                     (i_dfi_cs_p3),
    .i_dfi_cs_p4                     (i_dfi_cs_p4),
    .i_dfi_cs_p5                     (i_dfi_cs_p5),
    .i_dfi_cs_p6                     (i_dfi_cs_p6),
    .i_dfi_cs_p7                     (i_dfi_cs_p7),
    .o_ch0_dfi_ca_p0                 (ch0_dfi_ca_p0),
    .o_ch0_dfi_ca_p1                 (ch0_dfi_ca_p1),
    .o_ch0_dfi_ca_p2                 (ch0_dfi_ca_p2),
    .o_ch0_dfi_ca_p3                 (ch0_dfi_ca_p3),
    .o_ch0_dfi_ca_p4                 (ch0_dfi_ca_p4),
    .o_ch0_dfi_ca_p5                 (ch0_dfi_ca_p5),
    .o_ch0_dfi_ca_p6                 (ch0_dfi_ca_p6),
    .o_ch0_dfi_ca_p7                 (ch0_dfi_ca_p7),
    .o_ch0_dfi_cke_p0                (ch0_dfi_cke_p0),
    .o_ch0_dfi_cke_p1                (ch0_dfi_cke_p1),
    .o_ch0_dfi_cke_p2                (ch0_dfi_cke_p2),
    .o_ch0_dfi_cke_p3                (ch0_dfi_cke_p3),
    .o_ch0_dfi_cke_p4                (ch0_dfi_cke_p4),
    .o_ch0_dfi_cke_p5                (ch0_dfi_cke_p5),
    .o_ch0_dfi_cke_p6                (ch0_dfi_cke_p6),
    .o_ch0_dfi_cke_p7                (ch0_dfi_cke_p7),
    .o_ch0_dfi_cs_p0                 (ch0_dfi_cs_p0),
    .o_ch0_dfi_cs_p1                 (ch0_dfi_cs_p1),
    .o_ch0_dfi_cs_p2                 (ch0_dfi_cs_p2),
    .o_ch0_dfi_cs_p3                 (ch0_dfi_cs_p3),
    .o_ch0_dfi_cs_p4                 (ch0_dfi_cs_p4),
    .o_ch0_dfi_cs_p5                 (ch0_dfi_cs_p5),
    .o_ch0_dfi_cs_p6                 (ch0_dfi_cs_p6),
    .o_ch0_dfi_cs_p7                 (ch0_dfi_cs_p7),
    .o_ch1_dfi_ca_p0                 (ch1_dfi_ca_p0),
    .o_ch1_dfi_ca_p1                 (ch1_dfi_ca_p1),
    .o_ch1_dfi_ca_p2                 (ch1_dfi_ca_p2),
    .o_ch1_dfi_ca_p3                 (ch1_dfi_ca_p3),
    .o_ch1_dfi_ca_p4                 (ch1_dfi_ca_p4),
    .o_ch1_dfi_ca_p5                 (ch1_dfi_ca_p5),
    .o_ch1_dfi_ca_p6                 (ch1_dfi_ca_p6),
    .o_ch1_dfi_ca_p7                 (ch1_dfi_ca_p7),
    .o_ch1_dfi_cke_p0                (ch1_dfi_cke_p0),
    .o_ch1_dfi_cke_p1                (ch1_dfi_cke_p1),
    .o_ch1_dfi_cke_p2                (ch1_dfi_cke_p2),
    .o_ch1_dfi_cke_p3                (ch1_dfi_cke_p3),
    .o_ch1_dfi_cke_p4                (ch1_dfi_cke_p4),
    .o_ch1_dfi_cke_p5                (ch1_dfi_cke_p5),
    .o_ch1_dfi_cke_p6                (ch1_dfi_cke_p6),
    .o_ch1_dfi_cke_p7                (ch1_dfi_cke_p7),
    .o_ch1_dfi_cs_p0                 (ch1_dfi_cs_p0),
    .o_ch1_dfi_cs_p1                 (ch1_dfi_cs_p1),
    .o_ch1_dfi_cs_p2                 (ch1_dfi_cs_p2),
    .o_ch1_dfi_cs_p3                 (ch1_dfi_cs_p3),
    .o_ch1_dfi_cs_p4                 (ch1_dfi_cs_p4),
    .o_ch1_dfi_cs_p5                 (ch1_dfi_cs_p5),
    .o_ch1_dfi_cs_p6                 (ch1_dfi_cs_p6),
    .o_ch1_dfi_cs_p7                 (ch1_dfi_cs_p7),
    // Write Data
    .i_dfi_wrdata_p0                 (i_dfi_wrdata_p0),
    .i_dfi_wrdata_p1                 (i_dfi_wrdata_p1),
    .i_dfi_wrdata_p2                 (i_dfi_wrdata_p2),
    .i_dfi_wrdata_p3                 (i_dfi_wrdata_p3),
    .i_dfi_wrdata_p4                 (i_dfi_wrdata_p4),
    .i_dfi_wrdata_p5                 (i_dfi_wrdata_p5),
    .i_dfi_wrdata_p6                 (i_dfi_wrdata_p6),
    .i_dfi_wrdata_p7                 (i_dfi_wrdata_p7),
    .i_dfi_wrdata_mask_p0            (i_dfi_wrdata_mask_p0),
    .i_dfi_wrdata_mask_p1            (i_dfi_wrdata_mask_p1),
    .i_dfi_wrdata_mask_p2            (i_dfi_wrdata_mask_p2),
    .i_dfi_wrdata_mask_p3            (i_dfi_wrdata_mask_p3),
    .i_dfi_wrdata_mask_p4            (i_dfi_wrdata_mask_p4),
    .i_dfi_wrdata_mask_p5            (i_dfi_wrdata_mask_p5),
    .i_dfi_wrdata_mask_p6            (i_dfi_wrdata_mask_p6),
    .i_dfi_wrdata_mask_p7            (i_dfi_wrdata_mask_p7),
    .o_ch0_dq0_dfi_wrdata_p0         (ch0_dq0_dfi_wrdata_p0),
    .o_ch0_dq0_dfi_wrdata_p1         (ch0_dq0_dfi_wrdata_p1),
    .o_ch0_dq0_dfi_wrdata_p2         (ch0_dq0_dfi_wrdata_p2),
    .o_ch0_dq0_dfi_wrdata_p3         (ch0_dq0_dfi_wrdata_p3),
    .o_ch0_dq0_dfi_wrdata_p4         (ch0_dq0_dfi_wrdata_p4),
    .o_ch0_dq0_dfi_wrdata_p5         (ch0_dq0_dfi_wrdata_p5),
    .o_ch0_dq0_dfi_wrdata_p6         (ch0_dq0_dfi_wrdata_p6),
    .o_ch0_dq0_dfi_wrdata_p7         (ch0_dq0_dfi_wrdata_p7),
    .o_ch0_dq0_dfi_wrdata_mask_p0    (ch0_dq0_dfi_wrdata_mask_p0),
    .o_ch0_dq0_dfi_wrdata_mask_p1    (ch0_dq0_dfi_wrdata_mask_p1),
    .o_ch0_dq0_dfi_wrdata_mask_p2    (ch0_dq0_dfi_wrdata_mask_p2),
    .o_ch0_dq0_dfi_wrdata_mask_p3    (ch0_dq0_dfi_wrdata_mask_p3),
    .o_ch0_dq0_dfi_wrdata_mask_p4    (ch0_dq0_dfi_wrdata_mask_p4),
    .o_ch0_dq0_dfi_wrdata_mask_p5    (ch0_dq0_dfi_wrdata_mask_p5),
    .o_ch0_dq0_dfi_wrdata_mask_p6    (ch0_dq0_dfi_wrdata_mask_p6),
    .o_ch0_dq0_dfi_wrdata_mask_p7    (ch0_dq0_dfi_wrdata_mask_p7),
    .o_ch0_dq1_dfi_wrdata_p0         (ch0_dq1_dfi_wrdata_p0),
    .o_ch0_dq1_dfi_wrdata_p1         (ch0_dq1_dfi_wrdata_p1),
    .o_ch0_dq1_dfi_wrdata_p2         (ch0_dq1_dfi_wrdata_p2),
    .o_ch0_dq1_dfi_wrdata_p3         (ch0_dq1_dfi_wrdata_p3),
    .o_ch0_dq1_dfi_wrdata_p4         (ch0_dq1_dfi_wrdata_p4),
    .o_ch0_dq1_dfi_wrdata_p5         (ch0_dq1_dfi_wrdata_p5),
    .o_ch0_dq1_dfi_wrdata_p6         (ch0_dq1_dfi_wrdata_p6),
    .o_ch0_dq1_dfi_wrdata_p7         (ch0_dq1_dfi_wrdata_p7),
    .o_ch0_dq1_dfi_wrdata_mask_p0    (ch0_dq1_dfi_wrdata_mask_p0),
    .o_ch0_dq1_dfi_wrdata_mask_p1    (ch0_dq1_dfi_wrdata_mask_p1),
    .o_ch0_dq1_dfi_wrdata_mask_p2    (ch0_dq1_dfi_wrdata_mask_p2),
    .o_ch0_dq1_dfi_wrdata_mask_p3    (ch0_dq1_dfi_wrdata_mask_p3),
    .o_ch0_dq1_dfi_wrdata_mask_p4    (ch0_dq1_dfi_wrdata_mask_p4),
    .o_ch0_dq1_dfi_wrdata_mask_p5    (ch0_dq1_dfi_wrdata_mask_p5),
    .o_ch0_dq1_dfi_wrdata_mask_p6    (ch0_dq1_dfi_wrdata_mask_p6),
    .o_ch0_dq1_dfi_wrdata_mask_p7    (ch0_dq1_dfi_wrdata_mask_p7),
    .o_ch1_dq0_dfi_wrdata_p0         (ch1_dq0_dfi_wrdata_p0),
    .o_ch1_dq0_dfi_wrdata_p1         (ch1_dq0_dfi_wrdata_p1),
    .o_ch1_dq0_dfi_wrdata_p2         (ch1_dq0_dfi_wrdata_p2),
    .o_ch1_dq0_dfi_wrdata_p3         (ch1_dq0_dfi_wrdata_p3),
    .o_ch1_dq0_dfi_wrdata_p4         (ch1_dq0_dfi_wrdata_p4),
    .o_ch1_dq0_dfi_wrdata_p5         (ch1_dq0_dfi_wrdata_p5),
    .o_ch1_dq0_dfi_wrdata_p6         (ch1_dq0_dfi_wrdata_p6),
    .o_ch1_dq0_dfi_wrdata_p7         (ch1_dq0_dfi_wrdata_p7),
    .o_ch1_dq0_dfi_wrdata_mask_p0    (ch1_dq0_dfi_wrdata_mask_p0),
    .o_ch1_dq0_dfi_wrdata_mask_p1    (ch1_dq0_dfi_wrdata_mask_p1),
    .o_ch1_dq0_dfi_wrdata_mask_p2    (ch1_dq0_dfi_wrdata_mask_p2),
    .o_ch1_dq0_dfi_wrdata_mask_p3    (ch1_dq0_dfi_wrdata_mask_p3),
    .o_ch1_dq0_dfi_wrdata_mask_p4    (ch1_dq0_dfi_wrdata_mask_p4),
    .o_ch1_dq0_dfi_wrdata_mask_p5    (ch1_dq0_dfi_wrdata_mask_p5),
    .o_ch1_dq0_dfi_wrdata_mask_p6    (ch1_dq0_dfi_wrdata_mask_p6),
    .o_ch1_dq0_dfi_wrdata_mask_p7    (ch1_dq0_dfi_wrdata_mask_p7),
    .o_ch1_dq1_dfi_wrdata_p0         (ch1_dq1_dfi_wrdata_p0),
    .o_ch1_dq1_dfi_wrdata_p1         (ch1_dq1_dfi_wrdata_p1),
    .o_ch1_dq1_dfi_wrdata_p2         (ch1_dq1_dfi_wrdata_p2),
    .o_ch1_dq1_dfi_wrdata_p3         (ch1_dq1_dfi_wrdata_p3),
    .o_ch1_dq1_dfi_wrdata_p4         (ch1_dq1_dfi_wrdata_p4),
    .o_ch1_dq1_dfi_wrdata_p5         (ch1_dq1_dfi_wrdata_p5),
    .o_ch1_dq1_dfi_wrdata_p6         (ch1_dq1_dfi_wrdata_p6),
    .o_ch1_dq1_dfi_wrdata_p7         (ch1_dq1_dfi_wrdata_p7),
    .o_ch1_dq1_dfi_wrdata_mask_p0    (ch1_dq1_dfi_wrdata_mask_p0),
    .o_ch1_dq1_dfi_wrdata_mask_p1    (ch1_dq1_dfi_wrdata_mask_p1),
    .o_ch1_dq1_dfi_wrdata_mask_p2    (ch1_dq1_dfi_wrdata_mask_p2),
    .o_ch1_dq1_dfi_wrdata_mask_p3    (ch1_dq1_dfi_wrdata_mask_p3),
    .o_ch1_dq1_dfi_wrdata_mask_p4    (ch1_dq1_dfi_wrdata_mask_p4),
    .o_ch1_dq1_dfi_wrdata_mask_p5    (ch1_dq1_dfi_wrdata_mask_p5),
    .o_ch1_dq1_dfi_wrdata_mask_p6    (ch1_dq1_dfi_wrdata_mask_p6),
    .o_ch1_dq1_dfi_wrdata_mask_p7    (ch1_dq1_dfi_wrdata_mask_p7),
    // Write Enable
    .i_dfi_wrdata_en_p0              (i_dfi_wrdata_en_p0),
    .i_dfi_wrdata_en_p1              (i_dfi_wrdata_en_p1),
    .i_dfi_wrdata_en_p2              (i_dfi_wrdata_en_p2),
    .i_dfi_wrdata_en_p3              (i_dfi_wrdata_en_p3),
    .i_dfi_wrdata_en_p4              (i_dfi_wrdata_en_p4),
    .i_dfi_wrdata_en_p5              (i_dfi_wrdata_en_p5),
    .i_dfi_wrdata_en_p6              (i_dfi_wrdata_en_p6),
    .i_dfi_wrdata_en_p7              (i_dfi_wrdata_en_p7),
    .o_ch0_dq0_dfi_wrdata_en_p0      (ch0_dq0_dfi_wrdata_en_p0),
    .o_ch0_dq0_dfi_wrdata_en_p1      (ch0_dq0_dfi_wrdata_en_p1),
    .o_ch0_dq0_dfi_wrdata_en_p2      (ch0_dq0_dfi_wrdata_en_p2),
    .o_ch0_dq0_dfi_wrdata_en_p3      (ch0_dq0_dfi_wrdata_en_p3),
    .o_ch0_dq0_dfi_wrdata_en_p4      (ch0_dq0_dfi_wrdata_en_p4),
    .o_ch0_dq0_dfi_wrdata_en_p5      (ch0_dq0_dfi_wrdata_en_p5),
    .o_ch0_dq0_dfi_wrdata_en_p6      (ch0_dq0_dfi_wrdata_en_p6),
    .o_ch0_dq0_dfi_wrdata_en_p7      (ch0_dq0_dfi_wrdata_en_p7),
    .o_ch0_dq1_dfi_wrdata_en_p0      (ch0_dq1_dfi_wrdata_en_p0),
    .o_ch0_dq1_dfi_wrdata_en_p1      (ch0_dq1_dfi_wrdata_en_p1),
    .o_ch0_dq1_dfi_wrdata_en_p2      (ch0_dq1_dfi_wrdata_en_p2),
    .o_ch0_dq1_dfi_wrdata_en_p3      (ch0_dq1_dfi_wrdata_en_p3),
    .o_ch0_dq1_dfi_wrdata_en_p4      (ch0_dq1_dfi_wrdata_en_p4),
    .o_ch0_dq1_dfi_wrdata_en_p5      (ch0_dq1_dfi_wrdata_en_p5),
    .o_ch0_dq1_dfi_wrdata_en_p6      (ch0_dq1_dfi_wrdata_en_p6),
    .o_ch0_dq1_dfi_wrdata_en_p7      (ch0_dq1_dfi_wrdata_en_p7),
    .o_ch1_dq0_dfi_wrdata_en_p0      (ch1_dq0_dfi_wrdata_en_p0),
    .o_ch1_dq0_dfi_wrdata_en_p1      (ch1_dq0_dfi_wrdata_en_p1),
    .o_ch1_dq0_dfi_wrdata_en_p2      (ch1_dq0_dfi_wrdata_en_p2),
    .o_ch1_dq0_dfi_wrdata_en_p3      (ch1_dq0_dfi_wrdata_en_p3),
    .o_ch1_dq0_dfi_wrdata_en_p4      (ch1_dq0_dfi_wrdata_en_p4),
    .o_ch1_dq0_dfi_wrdata_en_p5      (ch1_dq0_dfi_wrdata_en_p5),
    .o_ch1_dq0_dfi_wrdata_en_p6      (ch1_dq0_dfi_wrdata_en_p6),
    .o_ch1_dq0_dfi_wrdata_en_p7      (ch1_dq0_dfi_wrdata_en_p7),
    .o_ch1_dq1_dfi_wrdata_en_p0      (ch1_dq1_dfi_wrdata_en_p0),
    .o_ch1_dq1_dfi_wrdata_en_p1      (ch1_dq1_dfi_wrdata_en_p1),
    .o_ch1_dq1_dfi_wrdata_en_p2      (ch1_dq1_dfi_wrdata_en_p2),
    .o_ch1_dq1_dfi_wrdata_en_p3      (ch1_dq1_dfi_wrdata_en_p3),
    .o_ch1_dq1_dfi_wrdata_en_p4      (ch1_dq1_dfi_wrdata_en_p4),
    .o_ch1_dq1_dfi_wrdata_en_p5      (ch1_dq1_dfi_wrdata_en_p5),
    .o_ch1_dq1_dfi_wrdata_en_p6      (ch1_dq1_dfi_wrdata_en_p6),
    .o_ch1_dq1_dfi_wrdata_en_p7      (ch1_dq1_dfi_wrdata_en_p7),
    // read Enable
    .i_dfi_rddata_en_p0              (i_dfi_rddata_en_p0),
    .i_dfi_rddata_en_p1              (i_dfi_rddata_en_p1),
    .i_dfi_rddata_en_p2              (i_dfi_rddata_en_p2),
    .i_dfi_rddata_en_p3              (i_dfi_rddata_en_p3),
    .i_dfi_rddata_en_p4              (i_dfi_rddata_en_p4),
    .i_dfi_rddata_en_p5              (i_dfi_rddata_en_p5),
    .i_dfi_rddata_en_p6              (i_dfi_rddata_en_p6),
    .i_dfi_rddata_en_p7              (i_dfi_rddata_en_p7),
    .o_ch0_dq0_dfi_rddata_en_p0      (ch0_dq0_dfi_rddata_en_p0),
    .o_ch0_dq0_dfi_rddata_en_p1      (ch0_dq0_dfi_rddata_en_p1),
    .o_ch0_dq0_dfi_rddata_en_p2      (ch0_dq0_dfi_rddata_en_p2),
    .o_ch0_dq0_dfi_rddata_en_p3      (ch0_dq0_dfi_rddata_en_p3),
    .o_ch0_dq0_dfi_rddata_en_p4      (ch0_dq0_dfi_rddata_en_p4),
    .o_ch0_dq0_dfi_rddata_en_p5      (ch0_dq0_dfi_rddata_en_p5),
    .o_ch0_dq0_dfi_rddata_en_p6      (ch0_dq0_dfi_rddata_en_p6),
    .o_ch0_dq0_dfi_rddata_en_p7      (ch0_dq0_dfi_rddata_en_p7),
    .o_ch0_dq1_dfi_rddata_en_p0      (ch0_dq1_dfi_rddata_en_p0),
    .o_ch0_dq1_dfi_rddata_en_p1      (ch0_dq1_dfi_rddata_en_p1),
    .o_ch0_dq1_dfi_rddata_en_p2      (ch0_dq1_dfi_rddata_en_p2),
    .o_ch0_dq1_dfi_rddata_en_p3      (ch0_dq1_dfi_rddata_en_p3),
    .o_ch0_dq1_dfi_rddata_en_p4      (ch0_dq1_dfi_rddata_en_p4),
    .o_ch0_dq1_dfi_rddata_en_p5      (ch0_dq1_dfi_rddata_en_p5),
    .o_ch0_dq1_dfi_rddata_en_p6      (ch0_dq1_dfi_rddata_en_p6),
    .o_ch0_dq1_dfi_rddata_en_p7      (ch0_dq1_dfi_rddata_en_p7),
    .o_ch1_dq0_dfi_rddata_en_p0      (ch1_dq0_dfi_rddata_en_p0),
    .o_ch1_dq0_dfi_rddata_en_p1      (ch1_dq0_dfi_rddata_en_p1),
    .o_ch1_dq0_dfi_rddata_en_p2      (ch1_dq0_dfi_rddata_en_p2),
    .o_ch1_dq0_dfi_rddata_en_p3      (ch1_dq0_dfi_rddata_en_p3),
    .o_ch1_dq0_dfi_rddata_en_p4      (ch1_dq0_dfi_rddata_en_p4),
    .o_ch1_dq0_dfi_rddata_en_p5      (ch1_dq0_dfi_rddata_en_p5),
    .o_ch1_dq0_dfi_rddata_en_p6      (ch1_dq0_dfi_rddata_en_p6),
    .o_ch1_dq0_dfi_rddata_en_p7      (ch1_dq0_dfi_rddata_en_p7),
    .o_ch1_dq1_dfi_rddata_en_p0      (ch1_dq1_dfi_rddata_en_p0),
    .o_ch1_dq1_dfi_rddata_en_p1      (ch1_dq1_dfi_rddata_en_p1),
    .o_ch1_dq1_dfi_rddata_en_p2      (ch1_dq1_dfi_rddata_en_p2),
    .o_ch1_dq1_dfi_rddata_en_p3      (ch1_dq1_dfi_rddata_en_p3),
    .o_ch1_dq1_dfi_rddata_en_p4      (ch1_dq1_dfi_rddata_en_p4),
    .o_ch1_dq1_dfi_rddata_en_p5      (ch1_dq1_dfi_rddata_en_p5),
    .o_ch1_dq1_dfi_rddata_en_p6      (ch1_dq1_dfi_rddata_en_p6),
    .o_ch1_dq1_dfi_rddata_en_p7      (ch1_dq1_dfi_rddata_en_p7),
    //rddata/dbi
    .i_dq0_dfi_rddata_w0             (dq0_dfi_rddata_w0),
    .i_dq0_dfi_rddata_w1             (dq0_dfi_rddata_w1),
    .i_dq0_dfi_rddata_w2             (dq0_dfi_rddata_w2),
    .i_dq0_dfi_rddata_w3             (dq0_dfi_rddata_w3),
    .i_dq0_dfi_rddata_w4             (dq0_dfi_rddata_w4),
    .i_dq0_dfi_rddata_w5             (dq0_dfi_rddata_w5),
    .i_dq0_dfi_rddata_w6             (dq0_dfi_rddata_w6),
    .i_dq0_dfi_rddata_w7             (dq0_dfi_rddata_w7),
    .i_dq1_dfi_rddata_w0             (dq1_dfi_rddata_w0),
    .i_dq1_dfi_rddata_w1             (dq1_dfi_rddata_w1),
    .i_dq1_dfi_rddata_w2             (dq1_dfi_rddata_w2),
    .i_dq1_dfi_rddata_w3             (dq1_dfi_rddata_w3),
    .i_dq1_dfi_rddata_w4             (dq1_dfi_rddata_w4),
    .i_dq1_dfi_rddata_w5             (dq1_dfi_rddata_w5),
    .i_dq1_dfi_rddata_w6             (dq1_dfi_rddata_w6),
    .i_dq1_dfi_rddata_w7             (dq1_dfi_rddata_w7),
    .i_dq2_dfi_rddata_w0             (dq2_dfi_rddata_w0),
    .i_dq2_dfi_rddata_w1             (dq2_dfi_rddata_w1),
    .i_dq2_dfi_rddata_w2             (dq2_dfi_rddata_w2),
    .i_dq2_dfi_rddata_w3             (dq2_dfi_rddata_w3),
    .i_dq2_dfi_rddata_w4             (dq2_dfi_rddata_w4),
    .i_dq2_dfi_rddata_w5             (dq2_dfi_rddata_w5),
    .i_dq2_dfi_rddata_w6             (dq2_dfi_rddata_w6),
    .i_dq2_dfi_rddata_w7             (dq2_dfi_rddata_w7),
    .i_dq3_dfi_rddata_w0             (dq3_dfi_rddata_w0),
    .i_dq3_dfi_rddata_w1             (dq3_dfi_rddata_w1),
    .i_dq3_dfi_rddata_w2             (dq3_dfi_rddata_w2),
    .i_dq3_dfi_rddata_w3             (dq3_dfi_rddata_w3),
    .i_dq3_dfi_rddata_w4             (dq3_dfi_rddata_w4),
    .i_dq3_dfi_rddata_w5             (dq3_dfi_rddata_w5),
    .i_dq3_dfi_rddata_w6             (dq3_dfi_rddata_w6),
    .i_dq3_dfi_rddata_w7             (dq3_dfi_rddata_w7),
    .i_dq0_dfi_rddata_dbi_w0         (dq0_dfi_rddata_dbi_w0),
    .i_dq0_dfi_rddata_dbi_w1         (dq0_dfi_rddata_dbi_w1),
    .i_dq0_dfi_rddata_dbi_w2         (dq0_dfi_rddata_dbi_w2),
    .i_dq0_dfi_rddata_dbi_w3         (dq0_dfi_rddata_dbi_w3),
    .i_dq0_dfi_rddata_dbi_w4         (dq0_dfi_rddata_dbi_w4),
    .i_dq0_dfi_rddata_dbi_w5         (dq0_dfi_rddata_dbi_w5),
    .i_dq0_dfi_rddata_dbi_w6         (dq0_dfi_rddata_dbi_w6),
    .i_dq0_dfi_rddata_dbi_w7         (dq0_dfi_rddata_dbi_w7),
    .i_dq1_dfi_rddata_dbi_w0         (dq1_dfi_rddata_dbi_w0),
    .i_dq1_dfi_rddata_dbi_w1         (dq1_dfi_rddata_dbi_w1),
    .i_dq1_dfi_rddata_dbi_w2         (dq1_dfi_rddata_dbi_w2),
    .i_dq1_dfi_rddata_dbi_w3         (dq1_dfi_rddata_dbi_w3),
    .i_dq1_dfi_rddata_dbi_w4         (dq1_dfi_rddata_dbi_w4),
    .i_dq1_dfi_rddata_dbi_w5         (dq1_dfi_rddata_dbi_w5),
    .i_dq1_dfi_rddata_dbi_w6         (dq1_dfi_rddata_dbi_w6),
    .i_dq1_dfi_rddata_dbi_w7         (dq1_dfi_rddata_dbi_w7),
    .i_dq2_dfi_rddata_dbi_w0         (dq2_dfi_rddata_dbi_w0),
    .i_dq2_dfi_rddata_dbi_w1         (dq2_dfi_rddata_dbi_w1),
    .i_dq2_dfi_rddata_dbi_w2         (dq2_dfi_rddata_dbi_w2),
    .i_dq2_dfi_rddata_dbi_w3         (dq2_dfi_rddata_dbi_w3),
    .i_dq2_dfi_rddata_dbi_w4         (dq2_dfi_rddata_dbi_w4),
    .i_dq2_dfi_rddata_dbi_w5         (dq2_dfi_rddata_dbi_w5),
    .i_dq2_dfi_rddata_dbi_w6         (dq2_dfi_rddata_dbi_w6),
    .i_dq2_dfi_rddata_dbi_w7         (dq2_dfi_rddata_dbi_w7),
    .i_dq3_dfi_rddata_dbi_w0         (dq3_dfi_rddata_dbi_w0),
    .i_dq3_dfi_rddata_dbi_w1         (dq3_dfi_rddata_dbi_w1),
    .i_dq3_dfi_rddata_dbi_w2         (dq3_dfi_rddata_dbi_w2),
    .i_dq3_dfi_rddata_dbi_w3         (dq3_dfi_rddata_dbi_w3),
    .i_dq3_dfi_rddata_dbi_w4         (dq3_dfi_rddata_dbi_w4),
    .i_dq3_dfi_rddata_dbi_w5         (dq3_dfi_rddata_dbi_w5),
    .i_dq3_dfi_rddata_dbi_w6         (dq3_dfi_rddata_dbi_w6),
    .i_dq3_dfi_rddata_dbi_w7         (dq3_dfi_rddata_dbi_w7),
    .o_dfi_rddata_p0                 (o_dfi_rddata_p0),
    .o_dfi_rddata_p1                 (o_dfi_rddata_p1),
    .o_dfi_rddata_p2                 (o_dfi_rddata_p2),
    .o_dfi_rddata_p3                 (o_dfi_rddata_p3),
    //rddata valid
    .i_dq0_dfi_rddata_valid_w0       (dq0_dfi_rddata_valid[0]),
    .i_dq0_dfi_rddata_valid_w1       (dq0_dfi_rddata_valid[1]),
    .i_dq0_dfi_rddata_valid_w2       (dq0_dfi_rddata_valid[2]),
    .i_dq0_dfi_rddata_valid_w3       (dq0_dfi_rddata_valid[3]),
    .i_dq0_dfi_rddata_valid_w4       (dq0_dfi_rddata_valid[4]),
    .i_dq0_dfi_rddata_valid_w5       (dq0_dfi_rddata_valid[5]),
    .i_dq0_dfi_rddata_valid_w6       (dq0_dfi_rddata_valid[6]),
    .i_dq0_dfi_rddata_valid_w7       (dq0_dfi_rddata_valid[7]),
    //for egress
    .i_dq1_dfi_rddata_valid_w0       (dq1_dfi_rddata_valid[0]),
    .i_dq1_dfi_rddata_valid_w1       (dq1_dfi_rddata_valid[1]),
    .i_dq1_dfi_rddata_valid_w2       (dq1_dfi_rddata_valid[2]),
    .i_dq1_dfi_rddata_valid_w3       (dq1_dfi_rddata_valid[3]),
    .i_dq1_dfi_rddata_valid_w4       (dq1_dfi_rddata_valid[4]),
    .i_dq1_dfi_rddata_valid_w5       (dq1_dfi_rddata_valid[5]),
    .i_dq1_dfi_rddata_valid_w6       (dq1_dfi_rddata_valid[6]),
    .i_dq1_dfi_rddata_valid_w7       (dq1_dfi_rddata_valid[7]),
    .i_dq2_dfi_rddata_valid_w0       (dq2_dfi_rddata_valid[0]),
    .i_dq2_dfi_rddata_valid_w1       (dq2_dfi_rddata_valid[1]),
    .i_dq2_dfi_rddata_valid_w2       (dq2_dfi_rddata_valid[2]),
    .i_dq2_dfi_rddata_valid_w3       (dq2_dfi_rddata_valid[3]),
    .i_dq2_dfi_rddata_valid_w4       (dq2_dfi_rddata_valid[4]),
    .i_dq2_dfi_rddata_valid_w5       (dq2_dfi_rddata_valid[5]),
    .i_dq2_dfi_rddata_valid_w6       (dq2_dfi_rddata_valid[6]),
    .i_dq2_dfi_rddata_valid_w7       (dq2_dfi_rddata_valid[7]),
    .i_dq3_dfi_rddata_valid_w0       (dq3_dfi_rddata_valid[0]),
    .i_dq3_dfi_rddata_valid_w1       (dq3_dfi_rddata_valid[1]),
    .i_dq3_dfi_rddata_valid_w2       (dq3_dfi_rddata_valid[2]),
    .i_dq3_dfi_rddata_valid_w3       (dq3_dfi_rddata_valid[3]),
    .i_dq3_dfi_rddata_valid_w4       (dq3_dfi_rddata_valid[4]),
    .i_dq3_dfi_rddata_valid_w5       (dq3_dfi_rddata_valid[5]),
    .i_dq3_dfi_rddata_valid_w6       (dq3_dfi_rddata_valid[6]),
    .i_dq3_dfi_rddata_valid_w7       (dq3_dfi_rddata_valid[7]),
    .o_dfi_rddata_valid_p0           (o_dfi_rddata_valid_p0),
    .o_dfi_rddata_valid_p1           (o_dfi_rddata_valid_p1),
    .o_dfi_rddata_valid_p2           (o_dfi_rddata_valid_p2),
    .o_dfi_rddata_valid_p3           (o_dfi_rddata_valid_p3),
    .i_dfi_rdout_en                  (i_dfi_rdout_en),
    .o_debug                         (o_debug)
);



   //DQS pattern
   logic [7:0]                tx_dqs_sdr;

   //CK pattern
   logic [7:0]               tx_ck_sdr;

ck_pattern u_ck_pattern (
    .i_clk           (i_phy_clk),
    .i_rst           (i_rst),
    .i_ck_en         (i_ck_en),
    .i_ck_pattern    (i_ck_pattern),
    .o_tx_ck_sdr     (tx_ck_sdr)
);

logic [2:0] dqs_mode; //0:default 1: transmit in progress 2:preamble 3: postamble 4:wlevel_en 5:wlevel_strobe
dqs_pattern u_dqs_pattern (
    .i_clk                (i_clk),
    .i_rst                (i_rst),
    .i_mode               (dqs_mode),
    //0:default 1: transmit in progress 2:preamble 3: postamble 4:wlevel_en 5:wlevel_strobe
    .i_preamble           (i_preamble),
    .i_postamble          (i_postamble),
    .i_wlevel_en          (i_wlevel_en),
    .i_wlevel_strobe      (i_wlevel_strobe),
    .i_dqs_default_seq    (i_dqs_default_seq),
    .o_tx_dqs_sdr         (tx_dqs_sdr)
);
   logic dqs_wrclk_en;
   logic [33:0] dqs_wrclk_en_dly;
   assign dqs_wrclk_en =  1'b0
                      | (|ch0_dq0_dfi_rddata_en_p0)
                      | (|ch0_dq0_dfi_rddata_en_p1)
                      | (|ch0_dq0_dfi_rddata_en_p2)
                      | (|ch0_dq0_dfi_rddata_en_p3)
                      | (|ch0_dq0_dfi_rddata_en_p4)
                      | (|ch0_dq0_dfi_rddata_en_p5)
                      | (|ch0_dq0_dfi_rddata_en_p6)
                      | (|ch0_dq0_dfi_rddata_en_p7)
                      | (|ch1_dq0_dfi_rddata_en_p1)
                      | (|ch1_dq0_dfi_rddata_en_p2)
                      | (|ch1_dq0_dfi_rddata_en_p3)
                      | (|ch1_dq0_dfi_rddata_en_p4)
                      | (|ch1_dq0_dfi_rddata_en_p5)
                      | (|ch1_dq0_dfi_rddata_en_p6)
                      | (|ch1_dq0_dfi_rddata_en_p7)
                      ;
tapped_delay_line32 u_tapped_delay_line32 (
    .clk        (i_phy_clk),
    .rst        (i_rst),
    .i_d        (dqs_wrclk_en),
    .o_d_dly    (dqs_wrclk_en_dly)
);

logic wr_ip;
logic preamble;
logic postamble;
assign wr_ip=dqs_wrclk_en_dly[i_dfiwr_latency];

always_comb begin
   preamble=(~dqs_wrclk_en_dly[i_dfiwr_latency]) & (dqs_wrclk_en_dly[i_dfiwr_latency-1]);
   postamble=dqs_wrclk_en_dly[i_dfiwr_latency] & (~dqs_wrclk_en_dly[i_dfiwr_latency-1]);
   case({preamble,postamble,wr_ip})
      3'b100: dqs_mode=2;
      3'b011: dqs_mode=3;
      3'b001: dqs_mode=1;
      3'b000: case(i_dqs_mode)
               2'b01:dqs_mode=4;
               2'b10:dqs_mode=5;
               default:dqs_mode=0;
            endcase
      default: dqs_mode=0;
   endcase
end


dfi2dp u_dfi2dp_ch0 (
    .i_dfi_cke_p0                (ch0_dfi_cke_p0),
    .i_dfi_cke_p1                (ch0_dfi_cke_p1),
    .i_dfi_cke_p2                (ch0_dfi_cke_p2),
    .i_dfi_cke_p3                (ch0_dfi_cke_p3),
    .i_dfi_cke_p4                (ch0_dfi_cke_p4),
    .i_dfi_cke_p5                (ch0_dfi_cke_p5),
    .i_dfi_cke_p6                (ch0_dfi_cke_p6),
    .i_dfi_cke_p7                (ch0_dfi_cke_p7),
    .i_dfi_cs_p0                 (ch0_dfi_cs_p0),
    .i_dfi_cs_p1                 (ch0_dfi_cs_p1),
    .i_dfi_cs_p2                 (ch0_dfi_cs_p2),
    .i_dfi_cs_p3                 (ch0_dfi_cs_p3),
    .i_dfi_cs_p4                 (ch0_dfi_cs_p4),
    .i_dfi_cs_p5                 (ch0_dfi_cs_p5),
    .i_dfi_cs_p6                 (ch0_dfi_cs_p6),
    .i_dfi_cs_p7                 (ch0_dfi_cs_p7),
    .i_dfi_ca_p0                 (ch0_dfi_ca_p0),
    .i_dfi_ca_p1                 (ch0_dfi_ca_p1),
    .i_dfi_ca_p2                 (ch0_dfi_ca_p2),
    .i_dfi_ca_p3                 (ch0_dfi_ca_p3),
    .i_dfi_ca_p4                 (ch0_dfi_ca_p4),
    .i_dfi_ca_p5                 (ch0_dfi_ca_p5),
    .i_dfi_ca_p6                 (ch0_dfi_ca_p6),
    .i_dfi_ca_p7                 (ch0_dfi_ca_p7),
    .i_dq0_dfi_wrdata_p0         (ch0_dq0_dfi_wrdata_p0),
    .i_dq0_dfi_wrdata_p1         (ch0_dq0_dfi_wrdata_p1),
    .i_dq0_dfi_wrdata_p2         (ch0_dq0_dfi_wrdata_p2),
    .i_dq0_dfi_wrdata_p3         (ch0_dq0_dfi_wrdata_p3),
    .i_dq0_dfi_wrdata_p4         (ch0_dq0_dfi_wrdata_p4),
    .i_dq0_dfi_wrdata_p5         (ch0_dq0_dfi_wrdata_p5),
    .i_dq0_dfi_wrdata_p6         (ch0_dq0_dfi_wrdata_p6),
    .i_dq0_dfi_wrdata_p7         (ch0_dq0_dfi_wrdata_p7),
    .i_dq0_dfi_wrdata_mask_p0    (ch0_dq0_dfi_wrdata_mask_p0),
    .i_dq0_dfi_wrdata_mask_p1    (ch0_dq0_dfi_wrdata_mask_p1),
    .i_dq0_dfi_wrdata_mask_p2    (ch0_dq0_dfi_wrdata_mask_p2),
    .i_dq0_dfi_wrdata_mask_p3    (ch0_dq0_dfi_wrdata_mask_p3),
    .i_dq0_dfi_wrdata_mask_p4    (ch0_dq0_dfi_wrdata_mask_p4),
    .i_dq0_dfi_wrdata_mask_p5    (ch0_dq0_dfi_wrdata_mask_p5),
    .i_dq0_dfi_wrdata_mask_p6    (ch0_dq0_dfi_wrdata_mask_p6),
    .i_dq0_dfi_wrdata_mask_p7    (ch0_dq0_dfi_wrdata_mask_p7),
    .i_dq0_dfi_rddata_en_p0      (ch0_dq0_dfi_rddata_en_p0),
    .i_dq0_dfi_rddata_en_p1      (ch0_dq0_dfi_rddata_en_p1),
    .i_dq0_dfi_rddata_en_p2      (ch0_dq0_dfi_rddata_en_p2),
    .i_dq0_dfi_rddata_en_p3      (ch0_dq0_dfi_rddata_en_p3),
    .i_dq0_dfi_rddata_en_p4      (ch0_dq0_dfi_rddata_en_p4),
    .i_dq0_dfi_rddata_en_p5      (ch0_dq0_dfi_rddata_en_p5),
    .i_dq0_dfi_rddata_en_p6      (ch0_dq0_dfi_rddata_en_p6),
    .i_dq0_dfi_rddata_en_p7      (ch0_dq0_dfi_rddata_en_p7),
    .o_dq0_dfi_rddata_w0         (dq0_dfi_rddata_w0),
    .o_dq0_dfi_rddata_w1         (dq0_dfi_rddata_w1),
    .o_dq0_dfi_rddata_w2         (dq0_dfi_rddata_w2),
    .o_dq0_dfi_rddata_w3         (dq0_dfi_rddata_w3),
    .o_dq0_dfi_rddata_w4         (dq0_dfi_rddata_w4),
    .o_dq0_dfi_rddata_w5         (dq0_dfi_rddata_w5),
    .o_dq0_dfi_rddata_w6         (dq0_dfi_rddata_w6),
    .o_dq0_dfi_rddata_w7         (dq0_dfi_rddata_w7),
    .o_dq0_dfi_rddata_dbi_w0     (dq0_dfi_rddata_dbi_w0),
    .o_dq0_dfi_rddata_dbi_w1     (dq0_dfi_rddata_dbi_w1),
    .o_dq0_dfi_rddata_dbi_w2     (dq0_dfi_rddata_dbi_w2),
    .o_dq0_dfi_rddata_dbi_w3     (dq0_dfi_rddata_dbi_w3),
    .o_dq0_dfi_rddata_dbi_w4     (dq0_dfi_rddata_dbi_w4),
    .o_dq0_dfi_rddata_dbi_w5     (dq0_dfi_rddata_dbi_w5),
    .o_dq0_dfi_rddata_dbi_w6     (dq0_dfi_rddata_dbi_w6),
    .o_dq0_dfi_rddata_dbi_w7     (dq0_dfi_rddata_dbi_w7),
    .o_dq0_dfi_rddata_valid      (dq0_dfi_rddata_valid),
    .i_dq1_dfi_wrdata_p0         (ch0_dq1_dfi_wrdata_p0),
    .i_dq1_dfi_wrdata_p1         (ch0_dq1_dfi_wrdata_p1),
    .i_dq1_dfi_wrdata_p2         (ch0_dq1_dfi_wrdata_p2),
    .i_dq1_dfi_wrdata_p3         (ch0_dq1_dfi_wrdata_p3),
    .i_dq1_dfi_wrdata_p4         (ch0_dq1_dfi_wrdata_p4),
    .i_dq1_dfi_wrdata_p5         (ch0_dq1_dfi_wrdata_p5),
    .i_dq1_dfi_wrdata_p6         (ch0_dq1_dfi_wrdata_p6),
    .i_dq1_dfi_wrdata_p7         (ch0_dq1_dfi_wrdata_p7),
    .i_dq1_dfi_wrdata_mask_p0    (ch0_dq1_dfi_wrdata_mask_p0),
    .i_dq1_dfi_wrdata_mask_p1    (ch0_dq1_dfi_wrdata_mask_p1),
    .i_dq1_dfi_wrdata_mask_p2    (ch0_dq1_dfi_wrdata_mask_p2),
    .i_dq1_dfi_wrdata_mask_p3    (ch0_dq1_dfi_wrdata_mask_p3),
    .i_dq1_dfi_wrdata_mask_p4    (ch0_dq1_dfi_wrdata_mask_p4),
    .i_dq1_dfi_wrdata_mask_p5    (ch0_dq1_dfi_wrdata_mask_p5),
    .i_dq1_dfi_wrdata_mask_p6    (ch0_dq1_dfi_wrdata_mask_p6),
    .i_dq1_dfi_wrdata_mask_p7    (ch0_dq1_dfi_wrdata_mask_p7),
    .i_dq1_dfi_rddata_en_p0      (ch0_dq1_dfi_rddata_en_p0),
    .i_dq1_dfi_rddata_en_p1      (ch0_dq1_dfi_rddata_en_p1),
    .i_dq1_dfi_rddata_en_p2      (ch0_dq1_dfi_rddata_en_p2),
    .i_dq1_dfi_rddata_en_p3      (ch0_dq1_dfi_rddata_en_p3),
    .i_dq1_dfi_rddata_en_p4      (ch0_dq1_dfi_rddata_en_p4),
    .i_dq1_dfi_rddata_en_p5      (ch0_dq1_dfi_rddata_en_p5),
    .i_dq1_dfi_rddata_en_p6      (ch0_dq1_dfi_rddata_en_p6),
    .i_dq1_dfi_rddata_en_p7      (ch0_dq1_dfi_rddata_en_p7),
    .o_dq1_dfi_rddata_w0         (dq1_dfi_rddata_w0),
    .o_dq1_dfi_rddata_w1         (dq1_dfi_rddata_w1),
    .o_dq1_dfi_rddata_w2         (dq1_dfi_rddata_w2),
    .o_dq1_dfi_rddata_w3         (dq1_dfi_rddata_w3),
    .o_dq1_dfi_rddata_w4         (dq1_dfi_rddata_w4),
    .o_dq1_dfi_rddata_w5         (dq1_dfi_rddata_w5),
    .o_dq1_dfi_rddata_w6         (dq1_dfi_rddata_w6),
    .o_dq1_dfi_rddata_w7         (dq1_dfi_rddata_w7),
    .o_dq1_dfi_rddata_dbi_w0     (dq1_dfi_rddata_dbi_w0),
    .o_dq1_dfi_rddata_dbi_w1     (dq1_dfi_rddata_dbi_w1),
    .o_dq1_dfi_rddata_dbi_w2     (dq1_dfi_rddata_dbi_w2),
    .o_dq1_dfi_rddata_dbi_w3     (dq1_dfi_rddata_dbi_w3),
    .o_dq1_dfi_rddata_dbi_w4     (dq1_dfi_rddata_dbi_w4),
    .o_dq1_dfi_rddata_dbi_w5     (dq1_dfi_rddata_dbi_w5),
    .o_dq1_dfi_rddata_dbi_w6     (dq1_dfi_rddata_dbi_w6),
    .o_dq1_dfi_rddata_dbi_w7     (dq1_dfi_rddata_dbi_w7),
    .o_dq1_dfi_rddata_valid      (dq1_dfi_rddata_valid),
    //DQS pattern
    .i_tx_dqs0_sdr               (tx_dqs_sdr),
    .i_tx_dqs1_sdr               (tx_dqs_sdr),
    //CK pattern
    .i_tx_ck_sdr                 (tx_ck_sdr),
    // Internal (PHY) interface
    .o_dq0_sdr                   (o_ch0_dq0_sdr),
    .i_dq0_sdr                   (i_ch0_dq0_sdr),
    .i_dq0_sdr_vld               (i_ch0_dq0_sdr_vld),
    .o_dqs0_sdr                  (o_ch0_dqs0_sdr),
    .o_dq1_sdr                   (o_ch0_dq1_sdr),
    .i_dq1_sdr                   (i_ch0_dq1_sdr),
    .i_dq1_sdr_vld               (i_ch0_dq1_sdr_vld),
    .o_dqs1_sdr                  (o_ch0_dqs1_sdr),
    // External interface
    .i_txrx_mode                 (i_txrx_mode),
    .i_tx0_sdr                   (i_ch0_tx0_sdr),
    .i_tx_ck0_sdr                (i_ch0_tx_ck0_sdr),
    .o_rx0_sdr                   (o_ch0_rx0_sdr),
    .o_rx0_sdr_vld               (o_ch0_rx0_sdr_vld),
    .i_tx1_sdr                   (i_ch0_tx1_sdr),
    .i_tx_ck1_sdr                (i_ch0_tx_ck1_sdr),
    .o_rx1_sdr                   (o_ch0_rx1_sdr),
    .o_rx1_sdr_vld               (o_ch0_rx1_sdr_vld),
    .o_ca_sdr                    (o_ch0_ca_sdr),
    .o_ck_sdr                    (o_ch0_ck_sdr)
);


dfi2dp u_dfi2dp_ch1 (
    .i_dfi_cke_p0                (ch1_dfi_cke_p0),
    .i_dfi_cke_p1                (ch1_dfi_cke_p1),
    .i_dfi_cke_p2                (ch1_dfi_cke_p2),
    .i_dfi_cke_p3                (ch1_dfi_cke_p3),
    .i_dfi_cke_p4                (ch1_dfi_cke_p4),
    .i_dfi_cke_p5                (ch1_dfi_cke_p5),
    .i_dfi_cke_p6                (ch1_dfi_cke_p6),
    .i_dfi_cke_p7                (ch1_dfi_cke_p7),
    .i_dfi_cs_p0                 (ch1_dfi_cs_p0),
    .i_dfi_cs_p1                 (ch1_dfi_cs_p1),
    .i_dfi_cs_p2                 (ch1_dfi_cs_p2),
    .i_dfi_cs_p3                 (ch1_dfi_cs_p3),
    .i_dfi_cs_p4                 (ch1_dfi_cs_p4),
    .i_dfi_cs_p5                 (ch1_dfi_cs_p5),
    .i_dfi_cs_p6                 (ch1_dfi_cs_p6),
    .i_dfi_cs_p7                 (ch1_dfi_cs_p7),
    .i_dfi_ca_p0                 (ch1_dfi_ca_p0),
    .i_dfi_ca_p1                 (ch1_dfi_ca_p1),
    .i_dfi_ca_p2                 (ch1_dfi_ca_p2),
    .i_dfi_ca_p3                 (ch1_dfi_ca_p3),
    .i_dfi_ca_p4                 (ch1_dfi_ca_p4),
    .i_dfi_ca_p5                 (ch1_dfi_ca_p5),
    .i_dfi_ca_p6                 (ch1_dfi_ca_p6),
    .i_dfi_ca_p7                 (ch1_dfi_ca_p7),
    .i_dq0_dfi_wrdata_p0         (ch1_dq0_dfi_wrdata_p0),
    .i_dq0_dfi_wrdata_p1         (ch1_dq0_dfi_wrdata_p1),
    .i_dq0_dfi_wrdata_p2         (ch1_dq0_dfi_wrdata_p2),
    .i_dq0_dfi_wrdata_p3         (ch1_dq0_dfi_wrdata_p3),
    .i_dq0_dfi_wrdata_p4         (ch1_dq0_dfi_wrdata_p4),
    .i_dq0_dfi_wrdata_p5         (ch1_dq0_dfi_wrdata_p5),
    .i_dq0_dfi_wrdata_p6         (ch1_dq0_dfi_wrdata_p6),
    .i_dq0_dfi_wrdata_p7         (ch1_dq0_dfi_wrdata_p7),
    .i_dq0_dfi_wrdata_mask_p0    (ch1_dq0_dfi_wrdata_mask_p0),
    .i_dq0_dfi_wrdata_mask_p1    (ch1_dq0_dfi_wrdata_mask_p1),
    .i_dq0_dfi_wrdata_mask_p2    (ch1_dq0_dfi_wrdata_mask_p2),
    .i_dq0_dfi_wrdata_mask_p3    (ch1_dq0_dfi_wrdata_mask_p3),
    .i_dq0_dfi_wrdata_mask_p4    (ch1_dq0_dfi_wrdata_mask_p4),
    .i_dq0_dfi_wrdata_mask_p5    (ch1_dq0_dfi_wrdata_mask_p5),
    .i_dq0_dfi_wrdata_mask_p6    (ch1_dq0_dfi_wrdata_mask_p6),
    .i_dq0_dfi_wrdata_mask_p7    (ch1_dq0_dfi_wrdata_mask_p7),
    .i_dq0_dfi_rddata_en_p0      (ch1_dq0_dfi_rddata_en_p0),
    .i_dq0_dfi_rddata_en_p1      (ch1_dq0_dfi_rddata_en_p1),
    .i_dq0_dfi_rddata_en_p2      (ch1_dq0_dfi_rddata_en_p2),
    .i_dq0_dfi_rddata_en_p3      (ch1_dq0_dfi_rddata_en_p3),
    .i_dq0_dfi_rddata_en_p4      (ch1_dq0_dfi_rddata_en_p4),
    .i_dq0_dfi_rddata_en_p5      (ch1_dq0_dfi_rddata_en_p5),
    .i_dq0_dfi_rddata_en_p6      (ch1_dq0_dfi_rddata_en_p6),
    .i_dq0_dfi_rddata_en_p7      (ch1_dq0_dfi_rddata_en_p7),
    .o_dq0_dfi_rddata_w0         (dq2_dfi_rddata_w0),
    .o_dq0_dfi_rddata_w1         (dq2_dfi_rddata_w1),
    .o_dq0_dfi_rddata_w2         (dq2_dfi_rddata_w2),
    .o_dq0_dfi_rddata_w3         (dq2_dfi_rddata_w3),
    .o_dq0_dfi_rddata_w4         (dq2_dfi_rddata_w4),
    .o_dq0_dfi_rddata_w5         (dq2_dfi_rddata_w5),
    .o_dq0_dfi_rddata_w6         (dq2_dfi_rddata_w6),
    .o_dq0_dfi_rddata_w7         (dq2_dfi_rddata_w7),
    .o_dq0_dfi_rddata_dbi_w0     (dq2_dfi_rddata_dbi_w0),
    .o_dq0_dfi_rddata_dbi_w1     (dq2_dfi_rddata_dbi_w1),
    .o_dq0_dfi_rddata_dbi_w2     (dq2_dfi_rddata_dbi_w2),
    .o_dq0_dfi_rddata_dbi_w3     (dq2_dfi_rddata_dbi_w3),
    .o_dq0_dfi_rddata_dbi_w4     (dq2_dfi_rddata_dbi_w4),
    .o_dq0_dfi_rddata_dbi_w5     (dq2_dfi_rddata_dbi_w5),
    .o_dq0_dfi_rddata_dbi_w6     (dq2_dfi_rddata_dbi_w6),
    .o_dq0_dfi_rddata_dbi_w7     (dq2_dfi_rddata_dbi_w7),
    .o_dq0_dfi_rddata_valid      (dq2_dfi_rddata_valid),
    .i_dq1_dfi_wrdata_p0         (ch1_dq1_dfi_wrdata_p0),
    .i_dq1_dfi_wrdata_p1         (ch1_dq1_dfi_wrdata_p1),
    .i_dq1_dfi_wrdata_p2         (ch1_dq1_dfi_wrdata_p2),
    .i_dq1_dfi_wrdata_p3         (ch1_dq1_dfi_wrdata_p3),
    .i_dq1_dfi_wrdata_p4         (ch1_dq1_dfi_wrdata_p4),
    .i_dq1_dfi_wrdata_p5         (ch1_dq1_dfi_wrdata_p5),
    .i_dq1_dfi_wrdata_p6         (ch1_dq1_dfi_wrdata_p6),
    .i_dq1_dfi_wrdata_p7         (ch1_dq1_dfi_wrdata_p7),
    .i_dq1_dfi_wrdata_mask_p0    (ch1_dq1_dfi_wrdata_mask_p0),
    .i_dq1_dfi_wrdata_mask_p1    (ch1_dq1_dfi_wrdata_mask_p1),
    .i_dq1_dfi_wrdata_mask_p2    (ch1_dq1_dfi_wrdata_mask_p2),
    .i_dq1_dfi_wrdata_mask_p3    (ch1_dq1_dfi_wrdata_mask_p3),
    .i_dq1_dfi_wrdata_mask_p4    (ch1_dq1_dfi_wrdata_mask_p4),
    .i_dq1_dfi_wrdata_mask_p5    (ch1_dq1_dfi_wrdata_mask_p5),
    .i_dq1_dfi_wrdata_mask_p6    (ch1_dq1_dfi_wrdata_mask_p6),
    .i_dq1_dfi_wrdata_mask_p7    (ch1_dq1_dfi_wrdata_mask_p7),
    .i_dq1_dfi_rddata_en_p0      (ch1_dq1_dfi_rddata_en_p0),
    .i_dq1_dfi_rddata_en_p1      (ch1_dq1_dfi_rddata_en_p1),
    .i_dq1_dfi_rddata_en_p2      (ch1_dq1_dfi_rddata_en_p2),
    .i_dq1_dfi_rddata_en_p3      (ch1_dq1_dfi_rddata_en_p3),
    .i_dq1_dfi_rddata_en_p4      (ch1_dq1_dfi_rddata_en_p4),
    .i_dq1_dfi_rddata_en_p5      (ch1_dq1_dfi_rddata_en_p5),
    .i_dq1_dfi_rddata_en_p6      (ch1_dq1_dfi_rddata_en_p6),
    .i_dq1_dfi_rddata_en_p7      (ch1_dq1_dfi_rddata_en_p7),
    .o_dq1_dfi_rddata_w0         (dq3_dfi_rddata_w0),
    .o_dq1_dfi_rddata_w1         (dq3_dfi_rddata_w1),
    .o_dq1_dfi_rddata_w2         (dq3_dfi_rddata_w2),
    .o_dq1_dfi_rddata_w3         (dq3_dfi_rddata_w3),
    .o_dq1_dfi_rddata_w4         (dq3_dfi_rddata_w4),
    .o_dq1_dfi_rddata_w5         (dq3_dfi_rddata_w5),
    .o_dq1_dfi_rddata_w6         (dq3_dfi_rddata_w6),
    .o_dq1_dfi_rddata_w7         (dq3_dfi_rddata_w7),
    .o_dq1_dfi_rddata_dbi_w0     (dq3_dfi_rddata_dbi_w0),
    .o_dq1_dfi_rddata_dbi_w1     (dq3_dfi_rddata_dbi_w1),
    .o_dq1_dfi_rddata_dbi_w2     (dq3_dfi_rddata_dbi_w2),
    .o_dq1_dfi_rddata_dbi_w3     (dq3_dfi_rddata_dbi_w3),
    .o_dq1_dfi_rddata_dbi_w4     (dq3_dfi_rddata_dbi_w4),
    .o_dq1_dfi_rddata_dbi_w5     (dq3_dfi_rddata_dbi_w5),
    .o_dq1_dfi_rddata_dbi_w6     (dq3_dfi_rddata_dbi_w6),
    .o_dq1_dfi_rddata_dbi_w7     (dq3_dfi_rddata_dbi_w7),
    .o_dq1_dfi_rddata_valid      (dq3_dfi_rddata_valid),
    //DQS pattern
    .i_tx_dqs0_sdr               (tx_dqs_sdr),
    .i_tx_dqs1_sdr               (tx_dqs_sdr),
    //CK pattern
    .i_tx_ck_sdr                 (tx_ck_sdr),
    // Internal (PHY) interface
    .o_dq0_sdr                   (o_ch1_dq0_sdr),
    .i_dq0_sdr                   (i_ch1_dq0_sdr),
    .i_dq0_sdr_vld               (i_ch1_dq0_sdr_vld),
    .o_dqs0_sdr                  (o_ch1_dqs0_sdr),
    .o_dq1_sdr                   (o_ch1_dq1_sdr),
    .i_dq1_sdr                   (i_ch1_dq1_sdr),
    .i_dq1_sdr_vld               (i_ch1_dq1_sdr_vld),
    .o_dqs1_sdr                  (o_ch1_dqs1_sdr),
    // External interface
    .i_txrx_mode                 (i_txrx_mode),
    .i_tx0_sdr                   (i_ch1_tx0_sdr),
    .i_tx_ck0_sdr                (i_ch1_tx_ck0_sdr),
    .o_rx0_sdr                   (o_ch1_rx0_sdr),
    .o_rx0_sdr_vld               (o_ch1_rx0_sdr_vld),
    .i_tx1_sdr                   (i_ch1_tx1_sdr),
    .i_tx_ck1_sdr                (i_ch1_tx_ck1_sdr),
    .o_rx1_sdr                   (o_ch1_rx1_sdr),
    .o_rx1_sdr_vld               (o_ch1_rx1_sdr_vld),
    .o_ca_sdr                    (o_ch1_ca_sdr),
    .o_ck_sdr                    (o_ch1_ck_sdr)
);

endmodule