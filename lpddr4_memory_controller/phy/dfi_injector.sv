module dfi_injector(

   input  logic                     i_scan_mode,
   input  logic                     i_scan_rst_ctrl,
   input  logic                     i_scan_cgc_ctrl,

   input  logic                     i_clk,
   input  logic                     i_rst,

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
   output logic [31:0]    o_eg_rdata,
   output logic                     o_eg_empty,
   output logic                     o_eg_read_done,
   output logic                     o_eg_full,
   output logic                     o_eg_overflow,

   // Write Command ca Data
   input  logic [5:0]               i_dfi_ca_p0,
   input  logic [5:0]               i_dfi_ca_p1,
   input  logic [5:0]               i_dfi_ca_p2,
   input  logic [5:0]               i_dfi_ca_p3,
   input  logic [5:0]               i_dfi_ca_p4,
   input  logic [5:0]               i_dfi_ca_p5,
   input  logic [5:0]               i_dfi_ca_p6,
   input  logic [5:0]               i_dfi_ca_p7,
   input  logic                     i_dfi_cke_p0,
   input  logic                     i_dfi_cke_p1,
   input  logic                     i_dfi_cke_p2,
   input  logic                     i_dfi_cke_p3,
   input  logic                     i_dfi_cke_p4,
   input  logic                     i_dfi_cke_p5,
   input  logic                     i_dfi_cke_p6,
   input  logic                     i_dfi_cke_p7,
   input  logic                     i_dfi_cs_p0,
   input  logic                     i_dfi_cs_p1,
   input  logic                     i_dfi_cs_p2,
   input  logic                     i_dfi_cs_p3,
   input  logic                     i_dfi_cs_p4,
   input  logic                     i_dfi_cs_p5,
   input  logic                     i_dfi_cs_p6,
   input  logic                     i_dfi_cs_p7,

   output logic [5:0]        o_ch0_dfi_ca_p0,
   output logic [5:0]        o_ch0_dfi_ca_p1,
   output logic [5:0]        o_ch0_dfi_ca_p2,
   output logic [5:0]        o_ch0_dfi_ca_p3,
   output logic [5:0]        o_ch0_dfi_ca_p4,
   output logic [5:0]        o_ch0_dfi_ca_p5,
   output logic [5:0]        o_ch0_dfi_ca_p6,
   output logic [5:0]        o_ch0_dfi_ca_p7,
   output logic              o_ch0_dfi_cke_p0,
   output logic              o_ch0_dfi_cke_p1,
   output logic              o_ch0_dfi_cke_p2,
   output logic              o_ch0_dfi_cke_p3,
   output logic              o_ch0_dfi_cke_p4,
   output logic              o_ch0_dfi_cke_p5,
   output logic              o_ch0_dfi_cke_p6,
   output logic              o_ch0_dfi_cke_p7,
   output logic              o_ch0_dfi_cs_p0,
   output logic              o_ch0_dfi_cs_p1,
   output logic              o_ch0_dfi_cs_p2,
   output logic              o_ch0_dfi_cs_p3,
   output logic              o_ch0_dfi_cs_p4,
   output logic              o_ch0_dfi_cs_p5,
   output logic              o_ch0_dfi_cs_p6,
   output logic              o_ch0_dfi_cs_p7,

   output logic [5:0]        o_ch1_dfi_ca_p0,
   output logic [5:0]        o_ch1_dfi_ca_p1,
   output logic [5:0]        o_ch1_dfi_ca_p2,
   output logic [5:0]        o_ch1_dfi_ca_p3,
   output logic [5:0]        o_ch1_dfi_ca_p4,
   output logic [5:0]        o_ch1_dfi_ca_p5,
   output logic [5:0]        o_ch1_dfi_ca_p6,
   output logic [5:0]        o_ch1_dfi_ca_p7,
   output logic              o_ch1_dfi_cke_p0,
   output logic              o_ch1_dfi_cke_p1,
   output logic              o_ch1_dfi_cke_p2,
   output logic              o_ch1_dfi_cke_p3,
   output logic              o_ch1_dfi_cke_p4,
   output logic              o_ch1_dfi_cke_p5,
   output logic              o_ch1_dfi_cke_p6,
   output logic              o_ch1_dfi_cke_p7,
   output logic              o_ch1_dfi_cs_p0,
   output logic              o_ch1_dfi_cs_p1,
   output logic              o_ch1_dfi_cs_p2,
   output logic              o_ch1_dfi_cs_p3,
   output logic              o_ch1_dfi_cs_p4,
   output logic              o_ch1_dfi_cs_p5,
   output logic              o_ch1_dfi_cs_p6,
   output logic              o_ch1_dfi_cs_p7,

   // Write Data
   input  logic [31:0] i_dfi_wrdata_p0,
   input  logic [31:0] i_dfi_wrdata_p1,
   input  logic [31:0] i_dfi_wrdata_p2,
   input  logic [31:0] i_dfi_wrdata_p3,
   input  logic [31:0] i_dfi_wrdata_p4,
   input  logic [31:0] i_dfi_wrdata_p5,
   input  logic [31:0] i_dfi_wrdata_p6,
   input  logic [31:0] i_dfi_wrdata_p7,
   input  logic [3:0] i_dfi_wrdata_mask_p0,
   input  logic [3:0] i_dfi_wrdata_mask_p1,
   input  logic [3:0] i_dfi_wrdata_mask_p2,
   input  logic [3:0] i_dfi_wrdata_mask_p3,
   input  logic [3:0] i_dfi_wrdata_mask_p4,
   input  logic [3:0] i_dfi_wrdata_mask_p5,
   input  logic [3:0] i_dfi_wrdata_mask_p6,
   input  logic [3:0] i_dfi_wrdata_mask_p7,

   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p0,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p1,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p2,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p3,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p4,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p5,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p6,
   output logic [7:0]        o_ch0_dq0_dfi_wrdata_p7,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p0,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p1,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p2,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p3,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p4,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p5,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p6,
   output logic              o_ch0_dq0_dfi_wrdata_mask_p7,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p0,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p1,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p2,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p3,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p4,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p5,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p6,
   output logic [7:0]        o_ch0_dq1_dfi_wrdata_p7,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p0,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p1,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p2,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p3,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p4,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p5,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p6,
   output logic              o_ch0_dq1_dfi_wrdata_mask_p7,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p0,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p1,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p2,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p3,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p4,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p5,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p6,
   output logic [7:0]        o_ch1_dq0_dfi_wrdata_p7,

   output logic              o_ch1_dq0_dfi_wrdata_mask_p0,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p1,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p2,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p3,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p4,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p5,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p6,
   output logic              o_ch1_dq0_dfi_wrdata_mask_p7,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p0,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p1,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p2,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p3,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p4,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p5,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p6,
   output logic [7:0]        o_ch1_dq1_dfi_wrdata_p7,

   output logic              o_ch1_dq1_dfi_wrdata_mask_p0,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p1,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p2,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p3,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p4,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p5,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p6,
   output logic              o_ch1_dq1_dfi_wrdata_mask_p7,

   // Write Enable
   input  logic                     i_dfi_wrdata_en_p0,
   input  logic                     i_dfi_wrdata_en_p1,
   input  logic                     i_dfi_wrdata_en_p2,
   input  logic                     i_dfi_wrdata_en_p3,
   input  logic                     i_dfi_wrdata_en_p4,
   input  logic                     i_dfi_wrdata_en_p5,
   input  logic                     i_dfi_wrdata_en_p6,
   input  logic                     i_dfi_wrdata_en_p7,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p0,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p1,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p2,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p3,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p4,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p5,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p6,
   output logic                     o_ch0_dq0_dfi_wrdata_en_p7,

   output logic                     o_ch0_dq1_dfi_wrdata_en_p0,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p1,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p2,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p3,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p4,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p5,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p6,
   output logic                     o_ch0_dq1_dfi_wrdata_en_p7,

   output logic                     o_ch1_dq0_dfi_wrdata_en_p0,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p1,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p2,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p3,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p4,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p5,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p6,
   output logic                     o_ch1_dq0_dfi_wrdata_en_p7,

   output logic                     o_ch1_dq1_dfi_wrdata_en_p0,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p1,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p2,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p3,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p4,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p5,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p6,
   output logic                     o_ch1_dq1_dfi_wrdata_en_p7,

   // Read Enable
   input  logic                     i_dfi_rddata_en_p0,
   input  logic                     i_dfi_rddata_en_p1,
   input  logic                     i_dfi_rddata_en_p2,
   input  logic                     i_dfi_rddata_en_p3,
   input  logic                     i_dfi_rddata_en_p4,
   input  logic                     i_dfi_rddata_en_p5,
   input  logic                     i_dfi_rddata_en_p6,
   input  logic                     i_dfi_rddata_en_p7,
   output logic                     o_ch0_dq0_dfi_rddata_en_p0,
   output logic                     o_ch0_dq0_dfi_rddata_en_p1,
   output logic                     o_ch0_dq0_dfi_rddata_en_p2,
   output logic                     o_ch0_dq0_dfi_rddata_en_p3,
   output logic                     o_ch0_dq0_dfi_rddata_en_p4,
   output logic                     o_ch0_dq0_dfi_rddata_en_p5,
   output logic                     o_ch0_dq0_dfi_rddata_en_p6,
   output logic                     o_ch0_dq0_dfi_rddata_en_p7,

   output logic                     o_ch0_dq1_dfi_rddata_en_p0,
   output logic                     o_ch0_dq1_dfi_rddata_en_p1,
   output logic                     o_ch0_dq1_dfi_rddata_en_p2,
   output logic                     o_ch0_dq1_dfi_rddata_en_p3,
   output logic                     o_ch0_dq1_dfi_rddata_en_p4,
   output logic                     o_ch0_dq1_dfi_rddata_en_p5,
   output logic                     o_ch0_dq1_dfi_rddata_en_p6,
   output logic                     o_ch0_dq1_dfi_rddata_en_p7,

   output logic                     o_ch1_dq0_dfi_rddata_en_p0,
   output logic                     o_ch1_dq0_dfi_rddata_en_p1,
   output logic                     o_ch1_dq0_dfi_rddata_en_p2,
   output logic                     o_ch1_dq0_dfi_rddata_en_p3,
   output logic                     o_ch1_dq0_dfi_rddata_en_p4,
   output logic                     o_ch1_dq0_dfi_rddata_en_p5,
   output logic                     o_ch1_dq0_dfi_rddata_en_p6,
   output logic                     o_ch1_dq0_dfi_rddata_en_p7,

   output logic                     o_ch1_dq1_dfi_rddata_en_p0,
   output logic                     o_ch1_dq1_dfi_rddata_en_p1,
   output logic                     o_ch1_dq1_dfi_rddata_en_p2,
   output logic                     o_ch1_dq1_dfi_rddata_en_p3,
   output logic                     o_ch1_dq1_dfi_rddata_en_p4,
   output logic                     o_ch1_dq1_dfi_rddata_en_p5,
   output logic                     o_ch1_dq1_dfi_rddata_en_p6,
   output logic                     o_ch1_dq1_dfi_rddata_en_p7,


   //rddata/dbi
   input  logic [7:0]        i_dq0_dfi_rddata_w0,
   input  logic [7:0]        i_dq0_dfi_rddata_w1,
   input  logic [7:0]        i_dq0_dfi_rddata_w2,
   input  logic [7:0]        i_dq0_dfi_rddata_w3,
   input  logic [7:0]        i_dq0_dfi_rddata_w4,
   input  logic [7:0]        i_dq0_dfi_rddata_w5,
   input  logic [7:0]        i_dq0_dfi_rddata_w6,
   input  logic [7:0]        i_dq0_dfi_rddata_w7,
   input  logic [7:0]        i_dq1_dfi_rddata_w0,
   input  logic [7:0]        i_dq1_dfi_rddata_w1,
   input  logic [7:0]        i_dq1_dfi_rddata_w2,
   input  logic [7:0]        i_dq1_dfi_rddata_w3,
   input  logic [7:0]        i_dq1_dfi_rddata_w4,
   input  logic [7:0]        i_dq1_dfi_rddata_w5,
   input  logic [7:0]        i_dq1_dfi_rddata_w6,
   input  logic [7:0]        i_dq1_dfi_rddata_w7,
   input  logic [7:0]        i_dq2_dfi_rddata_w0,
   input  logic [7:0]        i_dq2_dfi_rddata_w1,
   input  logic [7:0]        i_dq2_dfi_rddata_w2,
   input  logic [7:0]        i_dq2_dfi_rddata_w3,
   input  logic [7:0]        i_dq2_dfi_rddata_w4,
   input  logic [7:0]        i_dq2_dfi_rddata_w5,
   input  logic [7:0]        i_dq2_dfi_rddata_w6,
   input  logic [7:0]        i_dq2_dfi_rddata_w7,
   input  logic [7:0]        i_dq3_dfi_rddata_w0,
   input  logic [7:0]        i_dq3_dfi_rddata_w1,
   input  logic [7:0]        i_dq3_dfi_rddata_w2,
   input  logic [7:0]        i_dq3_dfi_rddata_w3,
   input  logic [7:0]        i_dq3_dfi_rddata_w4,
   input  logic [7:0]        i_dq3_dfi_rddata_w5,
   input  logic [7:0]        i_dq3_dfi_rddata_w6,
   input  logic [7:0]        i_dq3_dfi_rddata_w7,

   input  logic         i_dq0_dfi_rddata_dbi_w0,
   input  logic         i_dq0_dfi_rddata_dbi_w1,
   input  logic         i_dq0_dfi_rddata_dbi_w2,
   input  logic         i_dq0_dfi_rddata_dbi_w3,
   input  logic         i_dq0_dfi_rddata_dbi_w4,
   input  logic         i_dq0_dfi_rddata_dbi_w5,
   input  logic         i_dq0_dfi_rddata_dbi_w6,
   input  logic         i_dq0_dfi_rddata_dbi_w7,
   input  logic         i_dq1_dfi_rddata_dbi_w0,
   input  logic         i_dq1_dfi_rddata_dbi_w1,
   input  logic         i_dq1_dfi_rddata_dbi_w2,
   input  logic         i_dq1_dfi_rddata_dbi_w3,
   input  logic         i_dq1_dfi_rddata_dbi_w4,
   input  logic         i_dq1_dfi_rddata_dbi_w5,
   input  logic         i_dq1_dfi_rddata_dbi_w6,
   input  logic         i_dq1_dfi_rddata_dbi_w7,
   input  logic         i_dq2_dfi_rddata_dbi_w0,
   input  logic         i_dq2_dfi_rddata_dbi_w1,
   input  logic         i_dq2_dfi_rddata_dbi_w2,
   input  logic         i_dq2_dfi_rddata_dbi_w3,
   input  logic         i_dq2_dfi_rddata_dbi_w4,
   input  logic         i_dq2_dfi_rddata_dbi_w5,
   input  logic         i_dq2_dfi_rddata_dbi_w6,
   input  logic         i_dq2_dfi_rddata_dbi_w7,
   input  logic         i_dq3_dfi_rddata_dbi_w0,
   input  logic         i_dq3_dfi_rddata_dbi_w1,
   input  logic         i_dq3_dfi_rddata_dbi_w2,
   input  logic         i_dq3_dfi_rddata_dbi_w3,
   input  logic         i_dq3_dfi_rddata_dbi_w4,
   input  logic         i_dq3_dfi_rddata_dbi_w5,
   input  logic         i_dq3_dfi_rddata_dbi_w6,
   input  logic         i_dq3_dfi_rddata_dbi_w7,

   output logic [63:0]       o_dfi_rddata_p0,
   output logic [63:0]       o_dfi_rddata_p1,
   output logic [63:0]       o_dfi_rddata_p2,
   output logic [63:0]       o_dfi_rddata_p3,

   //rddata valid
   input  logic                     i_dq0_dfi_rddata_valid_w0,
   input  logic                     i_dq0_dfi_rddata_valid_w1,
   input  logic                     i_dq0_dfi_rddata_valid_w2,
   input  logic                     i_dq0_dfi_rddata_valid_w3,
   input  logic                     i_dq0_dfi_rddata_valid_w4,
   input  logic                     i_dq0_dfi_rddata_valid_w5,
   input  logic                     i_dq0_dfi_rddata_valid_w6,
   input  logic                     i_dq0_dfi_rddata_valid_w7,

   //for egress
   input  logic                     i_dq1_dfi_rddata_valid_w0,
   input  logic                     i_dq1_dfi_rddata_valid_w1,
   input  logic                     i_dq1_dfi_rddata_valid_w2,
   input  logic                     i_dq1_dfi_rddata_valid_w3,
   input  logic                     i_dq1_dfi_rddata_valid_w4,
   input  logic                     i_dq1_dfi_rddata_valid_w5,
   input  logic                     i_dq1_dfi_rddata_valid_w6,
   input  logic                     i_dq1_dfi_rddata_valid_w7,
   input  logic                     i_dq2_dfi_rddata_valid_w0,
   input  logic                     i_dq2_dfi_rddata_valid_w1,
   input  logic                     i_dq2_dfi_rddata_valid_w2,
   input  logic                     i_dq2_dfi_rddata_valid_w3,
   input  logic                     i_dq2_dfi_rddata_valid_w4,
   input  logic                     i_dq2_dfi_rddata_valid_w5,
   input  logic                     i_dq2_dfi_rddata_valid_w6,
   input  logic                     i_dq2_dfi_rddata_valid_w7,
   input  logic                     i_dq3_dfi_rddata_valid_w0,
   input  logic                     i_dq3_dfi_rddata_valid_w1,
   input  logic                     i_dq3_dfi_rddata_valid_w2,
   input  logic                     i_dq3_dfi_rddata_valid_w3,
   input  logic                     i_dq3_dfi_rddata_valid_w4,
   input  logic                     i_dq3_dfi_rddata_valid_w5,
   input  logic                     i_dq3_dfi_rddata_valid_w6,
   input  logic                     i_dq3_dfi_rddata_valid_w7,
   output logic                    o_dfi_rddata_valid_p0,
   output logic                    o_dfi_rddata_valid_p1,
   output logic                    o_dfi_rddata_valid_p2,
   output logic                    o_dfi_rddata_valid_p3,

   input  logic                     i_dfi_rdout_en,

   output logic [31:0]              o_debug
);

   // ------------------------------------------------------------------------
   // Local Clock Gating
   // ------------------------------------------------------------------------
   logic clk_g, buf_mode_sync, buf_clk_en_sync, cgc_en;

   ddr_demet_r u_demet_6     (.i_clk(i_clk), .i_rst(i_rst), .i_d(i_buf_mode), .o_q(buf_mode_sync));
   ddr_demet_r u_demet_9     (.i_clk(i_clk), .i_rst(i_rst), .i_d(i_buf_clk_en), .o_q(buf_clk_en_sync));

   assign cgc_en = buf_mode_sync | buf_clk_en_sync ;

   ddr_cgc_rl u_cgc_dfi_clk  (.i_clk(i_clk), .i_clk_en(cgc_en), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(clk_g));

   // ------------------------------------------------------------------------
   // dfi_rddata_valid
   // ------------------------------------------------------------------------

   assign o_dfi_rddata_valid_p0=i_dq0_dfi_rddata_valid_w0|i_dq0_dfi_rddata_valid_w1;
   assign o_dfi_rddata_valid_p1=i_dq0_dfi_rddata_valid_w2|i_dq0_dfi_rddata_valid_w3;
   assign o_dfi_rddata_valid_p2=i_dq0_dfi_rddata_valid_w4|i_dq0_dfi_rddata_valid_w5;
   assign o_dfi_rddata_valid_p3=i_dq0_dfi_rddata_valid_w6|i_dq0_dfi_rddata_valid_w7;


   // ------------------------------------------------------------------------
   // Read DBI
   // ------------------------------------------------------------------------
   logic[63:0] dfi_rddata_w0;
   logic[63:0] dfi_rddata_w1;
   logic[63:0] dfi_rddata_w2;
   logic[63:0] dfi_rddata_w3;

   assign dfi_rddata_w0={i_dq0_dfi_rddata_w0,i_dq1_dfi_rddata_w0,i_dq2_dfi_rddata_w0,i_dq3_dfi_rddata_w0,i_dq0_dfi_rddata_w1,i_dq1_dfi_rddata_w1,i_dq2_dfi_rddata_w1,i_dq3_dfi_rddata_w1};
   assign dfi_rddata_w1={i_dq0_dfi_rddata_w2,i_dq1_dfi_rddata_w2,i_dq2_dfi_rddata_w2,i_dq3_dfi_rddata_w2,i_dq0_dfi_rddata_w3,i_dq1_dfi_rddata_w3,i_dq2_dfi_rddata_w3,i_dq3_dfi_rddata_w3};
   assign dfi_rddata_w2={i_dq0_dfi_rddata_w4,i_dq1_dfi_rddata_w4,i_dq2_dfi_rddata_w4,i_dq3_dfi_rddata_w4,i_dq0_dfi_rddata_w5,i_dq1_dfi_rddata_w5,i_dq2_dfi_rddata_w5,i_dq3_dfi_rddata_w5};
   assign dfi_rddata_w3={i_dq0_dfi_rddata_w6,i_dq1_dfi_rddata_w6,i_dq2_dfi_rddata_w6,i_dq3_dfi_rddata_w6,i_dq0_dfi_rddata_w7,i_dq1_dfi_rddata_w7,i_dq2_dfi_rddata_w7,i_dq3_dfi_rddata_w7};

   logic[7:0] dfi_rddata_dbi_w0;
   logic[7:0] dfi_rddata_dbi_w1;
   logic[7:0] dfi_rddata_dbi_w2;
   logic[7:0] dfi_rddata_dbi_w3;

   assign dfi_rddata_dbi_w0={i_dq0_dfi_rddata_dbi_w0,i_dq1_dfi_rddata_dbi_w0,i_dq2_dfi_rddata_dbi_w0,i_dq3_dfi_rddata_dbi_w0,i_dq0_dfi_rddata_dbi_w1,i_dq1_dfi_rddata_dbi_w1,i_dq2_dfi_rddata_dbi_w1,i_dq3_dfi_rddata_dbi_w1};
   assign dfi_rddata_dbi_w1={i_dq0_dfi_rddata_dbi_w2,i_dq1_dfi_rddata_dbi_w2,i_dq2_dfi_rddata_dbi_w2,i_dq3_dfi_rddata_dbi_w2,i_dq0_dfi_rddata_dbi_w3,i_dq1_dfi_rddata_dbi_w3,i_dq2_dfi_rddata_dbi_w3,i_dq3_dfi_rddata_dbi_w3};
   assign dfi_rddata_dbi_w2={i_dq0_dfi_rddata_dbi_w4,i_dq1_dfi_rddata_dbi_w4,i_dq2_dfi_rddata_dbi_w4,i_dq3_dfi_rddata_dbi_w4,i_dq0_dfi_rddata_dbi_w5,i_dq1_dfi_rddata_dbi_w5,i_dq2_dfi_rddata_dbi_w5,i_dq3_dfi_rddata_dbi_w5};
   assign dfi_rddata_dbi_w3={i_dq0_dfi_rddata_dbi_w6,i_dq1_dfi_rddata_dbi_w6,i_dq2_dfi_rddata_dbi_w6,i_dq3_dfi_rddata_dbi_w6,i_dq0_dfi_rddata_dbi_w7,i_dq1_dfi_rddata_dbi_w7,i_dq2_dfi_rddata_dbi_w7,i_dq3_dfi_rddata_dbi_w7};

   ddr_dp_dbi #(
    .WIDTH            (8),
    // Parallel bus width
    .NUM_PH           (8),
    // Number of data phases
    .EGRESS           (1'b1),
    // 0: Ingress, 1: Egress
    // Read data width
    .DWIDTH           (8)
) u_ddr_dp_dbi_0 (
    .i_clk            (i_clk),
    .i_rst            (i_rst),
    // Receiver
    .i_dbi_en         (i_dbi_en),
    .i_dbi_ones       (i_dbi_ones),
    .i_dbi_pipe_en    (i_dbi_pipe_en),
    .i_dbi_mask       (i_dbi_mask),
    .i_sdr            (dfi_rddata_w0),
    .o_sdr            (o_dfi_rddata_p0),
    .i_sdr_dbi        (dfi_rddata_dbi_w0),
    .o_sdr_dbi        ()
);

   ddr_dp_dbi #(
    .WIDTH            (8),
    // Parallel bus width
    .NUM_PH           (8),
    // Number of data phases
    .EGRESS           (1'b1),
    // 0: Ingress, 1: Egress
    // Read data width
    .DWIDTH           (8)
) u_ddr_dp_dbi_1 (
    .i_clk            (i_clk),
    .i_rst            (i_rst),
    // Receiver
    .i_dbi_en         (i_dbi_en),
    .i_dbi_ones       (i_dbi_ones),
    .i_dbi_pipe_en    (i_dbi_pipe_en),
    .i_dbi_mask       (i_dbi_mask),
    .i_sdr            (dfi_rddata_w1),
    .o_sdr            (o_dfi_rddata_p1),
    .i_sdr_dbi        (dfi_rddata_dbi_w1),
    .o_sdr_dbi        ()
);

   ddr_dp_dbi #(
    .WIDTH            (8),
    // Parallel bus width
    .NUM_PH           (8),
    // Number of data phases
    .EGRESS           (1'b1),
    // 0: Ingress, 1: Egress
    // Read data width
    .DWIDTH           (8)
) u_ddr_dp_dbi_2 (
    .i_clk            (i_clk),
    .i_rst            (i_rst),
    // Receiver
    .i_dbi_en         (i_dbi_en),
    .i_dbi_ones       (i_dbi_ones),
    .i_dbi_pipe_en    (i_dbi_pipe_en),
    .i_dbi_mask       (i_dbi_mask),
    .i_sdr            (dfi_rddata_w2),
    .o_sdr            (o_dfi_rddata_p2),
    .i_sdr_dbi        (dfi_rddata_dbi_w2),
    .o_sdr_dbi        ()
);

   ddr_dp_dbi #(
    .WIDTH            (8),
    // Parallel bus width
    .NUM_PH           (8),
    // Number of data phases
    .EGRESS           (1'b1),
    // 0: Ingress, 1: Egress
    // Read data width
    .DWIDTH           (8)
) u_ddr_dp_dbi_3 (
    .i_clk            (i_clk),
    .i_rst            (i_rst),
    // Receiver
    .i_dbi_en         (i_dbi_en),
    .i_dbi_ones       (i_dbi_ones),
    .i_dbi_pipe_en    (i_dbi_pipe_en),
    .i_dbi_mask       (i_dbi_mask),
    .i_sdr            (dfi_rddata_w3),
    .o_sdr            (o_dfi_rddata_p3),
    .i_sdr_dbi        (dfi_rddata_dbi_w3),
    .o_sdr_dbi        ()
);


  // ------------------------------------------------------------------------
   // Read data enable
   // ------------------------------------------------------------------------
   logic dfi_rddata_en_p0;
   logic dfi_rddata_en_p1;
   logic dfi_rddata_en_p2;
   logic dfi_rddata_en_p3;
   logic dfi_rddata_en_p4;
   logic dfi_rddata_en_p5;
   logic dfi_rddata_en_p6;
   logic dfi_rddata_en_p7;

   logic                     int_dfi_rddata_en_p0;
   logic                     int_dfi_rddata_en_p1;
   logic                     int_dfi_rddata_en_p2;
   logic                     int_dfi_rddata_en_p3;
   logic                     int_dfi_rddata_en_p4;
   logic                     int_dfi_rddata_en_p5;
   logic                     int_dfi_rddata_en_p6;
   logic                     int_dfi_rddata_en_p7;


   ddr_mux #(.DWIDTH(1))  u_dq_mux_p0_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p0 ),                      .i_b(dfi_rddata_en_p0  ),        .o_z(int_dfi_rddata_en_p0  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p1_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p1 ),                      .i_b(dfi_rddata_en_p1  ),        .o_z(int_dfi_rddata_en_p1  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p2_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p2 ),                      .i_b(dfi_rddata_en_p2  ),        .o_z(int_dfi_rddata_en_p2  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p3_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p3 ),                      .i_b(dfi_rddata_en_p3  ),        .o_z(int_dfi_rddata_en_p3  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p4_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p4 ),                      .i_b(dfi_rddata_en_p4  ),        .o_z(int_dfi_rddata_en_p4  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p5_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p5 ),                      .i_b(dfi_rddata_en_p5  ),        .o_z(int_dfi_rddata_en_p5  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p6_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p6 ),                      .i_b(dfi_rddata_en_p6  ),        .o_z(int_dfi_rddata_en_p6  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p7_7              (.i_sel(buf_mode_sync), .i_a(i_dfi_rddata_en_p7 ),                      .i_b(dfi_rddata_en_p7  ),        .o_z(int_dfi_rddata_en_p7  ));
   
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p0_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p0       ), .o_q(o_ch0_dq0_dfi_rddata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p0_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p0       ), .o_q(o_ch0_dq1_dfi_rddata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p1_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p1       ), .o_q(o_ch0_dq0_dfi_rddata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p1_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p1       ), .o_q(o_ch0_dq1_dfi_rddata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p2_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p2       ), .o_q(o_ch0_dq0_dfi_rddata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p2_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p2       ), .o_q(o_ch0_dq1_dfi_rddata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p3_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p3       ), .o_q(o_ch0_dq0_dfi_rddata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p3_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p3       ), .o_q(o_ch0_dq1_dfi_rddata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p4_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p4       ), .o_q(o_ch0_dq0_dfi_rddata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p4_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p4       ), .o_q(o_ch0_dq1_dfi_rddata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p5_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p5       ), .o_q(o_ch0_dq0_dfi_rddata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p5_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p5       ), .o_q(o_ch0_dq1_dfi_rddata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p6_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p6       ), .o_q(o_ch0_dq0_dfi_rddata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p6_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p6       ), .o_q(o_ch0_dq1_dfi_rddata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p7_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p7       ), .o_q(o_ch0_dq0_dfi_rddata_en_p7       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p7_9              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_rddata_en_p7       ), .o_q(o_ch0_dq1_dfi_rddata_en_p7       ));
   
   // ------------------------------------------------------------------------
   // Write data&mask 
   // ------------------------------------------------------------------------
   logic [7:0] dq0_dfi_wrdata_p0;
   logic dq0_dfi_wrdata_mask_p0;
   logic [7:0] dq1_dfi_wrdata_p0;
   logic dq1_dfi_wrdata_mask_p0;
   logic [7:0] dq2_dfi_wrdata_p0;
   logic dq2_dfi_wrdata_mask_p0;
   logic [7:0] dq3_dfi_wrdata_p0;
   logic dq3_dfi_wrdata_mask_p0;
   

   logic [7:0] dq0_dfi_wrdata_p1;
   logic dq0_dfi_wrdata_mask_p1;
   logic [7:0] dq1_dfi_wrdata_p1;
   logic dq1_dfi_wrdata_mask_p1;
   logic [7:0] dq2_dfi_wrdata_p1; 
   logic dq2_dfi_wrdata_mask_p1;
   logic [7:0] dq3_dfi_wrdata_p1;
   logic dq3_dfi_wrdata_mask_p1;
   
   
   logic [7:0] dq0_dfi_wrdata_p2;
   logic dq0_dfi_wrdata_mask_p2;
   logic [7:0] dq1_dfi_wrdata_p2;
   logic dq1_dfi_wrdata_mask_p2;
   logic [7:0] dq2_dfi_wrdata_p2;
   logic dq2_dfi_wrdata_mask_p2;
   logic [7:0] dq3_dfi_wrdata_p2;
   logic dq3_dfi_wrdata_mask_p2;
   

   logic [7:0] dq0_dfi_wrdata_p3;
   logic dq0_dfi_wrdata_mask_p3;
   logic [7:0] dq1_dfi_wrdata_p3;
   logic dq1_dfi_wrdata_mask_p3;
   logic [7:0] dq2_dfi_wrdata_p3;
   logic dq2_dfi_wrdata_mask_p3;
   logic [7:0] dq3_dfi_wrdata_p3;
   logic dq3_dfi_wrdata_mask_p3;

   logic [7:0] dq0_dfi_wrdata_p4;
   logic dq0_dfi_wrdata_mask_p4;
   logic [7:0] dq1_dfi_wrdata_p4;
   logic dq1_dfi_wrdata_mask_p4;
   logic [7:0] dq2_dfi_wrdata_p4;
   logic dq2_dfi_wrdata_mask_p4;
   logic [7:0] dq3_dfi_wrdata_p4;
   logic dq3_dfi_wrdata_mask_p4;
   
   logic [7:0] dq0_dfi_wrdata_p5;
   logic dq0_dfi_wrdata_mask_p5;
   logic [7:0] dq1_dfi_wrdata_p5;
   logic dq1_dfi_wrdata_mask_p5;
   logic [7:0] dq2_dfi_wrdata_p5;
   logic dq2_dfi_wrdata_mask_p5;
   logic [7:0] dq3_dfi_wrdata_p5;
   logic dq3_dfi_wrdata_mask_p5;

   logic [7:0] dq0_dfi_wrdata_p6;
   logic dq0_dfi_wrdata_mask_p6;
   logic [7:0] dq1_dfi_wrdata_p6;
   logic dq1_dfi_wrdata_mask_p6;
   logic [7:0] dq2_dfi_wrdata_p6;
   logic dq2_dfi_wrdata_mask_p6;
   logic [7:0] dq3_dfi_wrdata_p6;
   logic dq3_dfi_wrdata_mask_p6;

   logic [7:0] dq0_dfi_wrdata_p7;
   logic dq0_dfi_wrdata_mask_p7;
   logic [7:0] dq1_dfi_wrdata_p7;
   logic dq1_dfi_wrdata_mask_p7;
   logic [7:0] dq2_dfi_wrdata_p7;
   logic dq2_dfi_wrdata_mask_p7;
   logic [7:0] dq3_dfi_wrdata_p7;
   logic dq3_dfi_wrdata_mask_p7;

      logic [7:0]        int_dq0_dfi_wrdata_p0;
   logic [7:0]        int_dq0_dfi_wrdata_p1;
   logic [7:0]        int_dq0_dfi_wrdata_p2;
   logic [7:0]        int_dq0_dfi_wrdata_p3;
   logic [7:0]        int_dq0_dfi_wrdata_p4;
   logic [7:0]        int_dq0_dfi_wrdata_p5;
   logic [7:0]        int_dq0_dfi_wrdata_p6;
   logic [7:0]        int_dq0_dfi_wrdata_p7;
   logic [7:0]        int_dq1_dfi_wrdata_p0;
   logic [7:0]        int_dq1_dfi_wrdata_p1;
   logic [7:0]        int_dq1_dfi_wrdata_p2;
   logic [7:0]        int_dq1_dfi_wrdata_p3;
   logic [7:0]        int_dq1_dfi_wrdata_p4;
   logic [7:0]        int_dq1_dfi_wrdata_p5;
   logic [7:0]        int_dq1_dfi_wrdata_p6;
   logic [7:0]        int_dq1_dfi_wrdata_p7;
   logic [7:0]        int_dq2_dfi_wrdata_p0;
   logic [7:0]        int_dq2_dfi_wrdata_p1;
   logic [7:0]        int_dq2_dfi_wrdata_p2;
   logic [7:0]        int_dq2_dfi_wrdata_p3;
   logic [7:0]        int_dq2_dfi_wrdata_p4;
   logic [7:0]        int_dq2_dfi_wrdata_p5;
   logic [7:0]        int_dq2_dfi_wrdata_p6;
   logic [7:0]        int_dq2_dfi_wrdata_p7;
   logic [7:0]        int_dq3_dfi_wrdata_p0;
   logic [7:0]        int_dq3_dfi_wrdata_p1;
   logic [7:0]        int_dq3_dfi_wrdata_p2;
   logic [7:0]        int_dq3_dfi_wrdata_p3;
   logic [7:0]        int_dq3_dfi_wrdata_p4;
   logic [7:0]        int_dq3_dfi_wrdata_p5;
   logic [7:0]        int_dq3_dfi_wrdata_p6;
   logic [7:0]        int_dq3_dfi_wrdata_p7;

   logic         int_dq0_dfi_wrdata_mask_p0;
   logic         int_dq0_dfi_wrdata_mask_p1;
   logic         int_dq0_dfi_wrdata_mask_p2;
   logic         int_dq0_dfi_wrdata_mask_p3;
   logic         int_dq0_dfi_wrdata_mask_p4;
   logic         int_dq0_dfi_wrdata_mask_p5;
   logic         int_dq0_dfi_wrdata_mask_p6;
   logic         int_dq0_dfi_wrdata_mask_p7;
   logic         int_dq1_dfi_wrdata_mask_p0;
   logic         int_dq1_dfi_wrdata_mask_p1;
   logic         int_dq1_dfi_wrdata_mask_p2;
   logic         int_dq1_dfi_wrdata_mask_p3;
   logic         int_dq1_dfi_wrdata_mask_p4;
   logic         int_dq1_dfi_wrdata_mask_p5;
   logic         int_dq1_dfi_wrdata_mask_p6;
   logic         int_dq1_dfi_wrdata_mask_p7;
   logic         int_dq2_dfi_wrdata_mask_p0;
   logic         int_dq2_dfi_wrdata_mask_p1;
   logic         int_dq2_dfi_wrdata_mask_p2;
   logic         int_dq2_dfi_wrdata_mask_p3;
   logic         int_dq2_dfi_wrdata_mask_p4;
   logic         int_dq2_dfi_wrdata_mask_p5;
   logic         int_dq2_dfi_wrdata_mask_p6;
   logic         int_dq2_dfi_wrdata_mask_p7;
   logic         int_dq3_dfi_wrdata_mask_p0;
   logic         int_dq3_dfi_wrdata_mask_p1;
   logic         int_dq3_dfi_wrdata_mask_p2;
   logic         int_dq3_dfi_wrdata_mask_p3;
   logic         int_dq3_dfi_wrdata_mask_p4;
   logic         int_dq3_dfi_wrdata_mask_p5;
   logic         int_dq3_dfi_wrdata_mask_p6;
   logic         int_dq3_dfi_wrdata_mask_p7;

   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p0_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p0[0+:8]),       .i_b(dq0_dfi_wrdata_p0     ),    .o_z(int_dq0_dfi_wrdata_p0      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p0_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p0[0]),  .i_b(dq0_dfi_wrdata_mask_p0),    .o_z(int_dq0_dfi_wrdata_mask_p0 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p0_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p0[8+:8]),       .i_b(dq1_dfi_wrdata_p0     ),    .o_z(int_dq1_dfi_wrdata_p0      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p0_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p0[1]),  .i_b(dq1_dfi_wrdata_mask_p0),    .o_z(int_dq1_dfi_wrdata_mask_p0 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p0_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p0[16+:8]),       .i_b(dq2_dfi_wrdata_p0     ),    .o_z(int_dq2_dfi_wrdata_p0      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p0_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p0[2]),  .i_b(dq2_dfi_wrdata_mask_p0),    .o_z(int_dq2_dfi_wrdata_mask_p0 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p0_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p0[24+:8]),       .i_b(dq3_dfi_wrdata_p0     ),    .o_z(int_dq3_dfi_wrdata_p0      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p0_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p0[3]),  .i_b(dq3_dfi_wrdata_mask_p0),    .o_z(int_dq3_dfi_wrdata_mask_p0 ));
    
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p1_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p1[0*8+:8]),       .i_b(dq0_dfi_wrdata_p1     ),    .o_z(int_dq0_dfi_wrdata_p1      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p1_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p1[0]),  .i_b(dq0_dfi_wrdata_mask_p1),    .o_z(int_dq0_dfi_wrdata_mask_p1 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p1_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p1[1*8+:8]),       .i_b(dq1_dfi_wrdata_p1     ),    .o_z(int_dq1_dfi_wrdata_p1      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p1_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p1[1]),  .i_b(dq1_dfi_wrdata_mask_p1),    .o_z(int_dq1_dfi_wrdata_mask_p1 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p1_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p1[16+:8]),       .i_b(dq2_dfi_wrdata_p1     ),    .o_z(int_dq2_dfi_wrdata_p1      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p1_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p1[2]),  .i_b(dq2_dfi_wrdata_mask_p1),    .o_z(int_dq2_dfi_wrdata_mask_p1 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p1_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p1[24+:8]),       .i_b(dq3_dfi_wrdata_p1     ),    .o_z(int_dq3_dfi_wrdata_p1      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p1_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p1[3]),  .i_b(dq3_dfi_wrdata_mask_p1),    .o_z(int_dq3_dfi_wrdata_mask_p1 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p2_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p2[0*8+:8]),       .i_b(dq0_dfi_wrdata_p2     ),    .o_z(int_dq0_dfi_wrdata_p2      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p2_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p2[0]),  .i_b(dq0_dfi_wrdata_mask_p2),    .o_z(int_dq0_dfi_wrdata_mask_p2 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p2_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p2[1*8+:8]),       .i_b(dq1_dfi_wrdata_p2     ),    .o_z(int_dq1_dfi_wrdata_p2      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p2_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p2[1]),  .i_b(dq1_dfi_wrdata_mask_p2),    .o_z(int_dq1_dfi_wrdata_mask_p2 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p2_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p2[16+:8]),       .i_b(dq2_dfi_wrdata_p2     ),    .o_z(int_dq2_dfi_wrdata_p2      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p2_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p2[2]),  .i_b(dq2_dfi_wrdata_mask_p2),    .o_z(int_dq2_dfi_wrdata_mask_p2 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p2_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p2[24+:8]),       .i_b(dq3_dfi_wrdata_p2     ),    .o_z(int_dq3_dfi_wrdata_p2      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p2_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p2[3]),  .i_b(dq3_dfi_wrdata_mask_p2),    .o_z(int_dq3_dfi_wrdata_mask_p2 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p3_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p3[0*8+:8]),       .i_b(dq0_dfi_wrdata_p3     ),    .o_z(int_dq0_dfi_wrdata_p3      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p3_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p3[0]),  .i_b(dq0_dfi_wrdata_mask_p3),    .o_z(int_dq0_dfi_wrdata_mask_p3 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p3_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p3[1*8+:8]),       .i_b(dq1_dfi_wrdata_p3     ),    .o_z(int_dq1_dfi_wrdata_p3      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p3_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p3[1]),  .i_b(dq1_dfi_wrdata_mask_p3),    .o_z(int_dq1_dfi_wrdata_mask_p3 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p3_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p3[16+:8]),       .i_b(dq2_dfi_wrdata_p3     ),    .o_z(int_dq2_dfi_wrdata_p3      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p3_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p3[2]),  .i_b(dq2_dfi_wrdata_mask_p3),    .o_z(int_dq2_dfi_wrdata_mask_p3 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p3_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p3[24+:8]),       .i_b(dq3_dfi_wrdata_p3     ),    .o_z(int_dq3_dfi_wrdata_p3      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p3_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p3[3]),  .i_b(dq3_dfi_wrdata_mask_p3),    .o_z(int_dq3_dfi_wrdata_mask_p3 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p4_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p4[0*8+:8]),       .i_b(dq0_dfi_wrdata_p4     ),    .o_z(int_dq0_dfi_wrdata_p4      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p4_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p4[0]),  .i_b(dq0_dfi_wrdata_mask_p4),    .o_z(int_dq0_dfi_wrdata_mask_p4 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p4_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p4[1*8+:8]),       .i_b(dq1_dfi_wrdata_p4     ),    .o_z(int_dq1_dfi_wrdata_p4      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p4_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p4[1]),  .i_b(dq1_dfi_wrdata_mask_p4),    .o_z(int_dq1_dfi_wrdata_mask_p4 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p4_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p4[16+:8]),       .i_b(dq2_dfi_wrdata_p4     ),    .o_z(int_dq2_dfi_wrdata_p4      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p4_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p4[2]),  .i_b(dq2_dfi_wrdata_mask_p4),    .o_z(int_dq2_dfi_wrdata_mask_p4 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p4_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p4[24+:8]),       .i_b(dq3_dfi_wrdata_p4     ),    .o_z(int_dq3_dfi_wrdata_p4      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p4_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p4[3]),  .i_b(dq3_dfi_wrdata_mask_p4),    .o_z(int_dq3_dfi_wrdata_mask_p4 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p5_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p5[0*8+:8]),       .i_b(dq0_dfi_wrdata_p5     ),    .o_z(int_dq0_dfi_wrdata_p5      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p5_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p5[0]),  .i_b(dq0_dfi_wrdata_mask_p5),    .o_z(int_dq0_dfi_wrdata_mask_p5 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p5_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p5[1*8+:8]),       .i_b(dq1_dfi_wrdata_p5     ),    .o_z(int_dq1_dfi_wrdata_p5      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p5_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p5[1]),  .i_b(dq1_dfi_wrdata_mask_p5),    .o_z(int_dq1_dfi_wrdata_mask_p5 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p5_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p5[16+:8]),       .i_b(dq2_dfi_wrdata_p5     ),    .o_z(int_dq2_dfi_wrdata_p5      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p5_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p5[2]),  .i_b(dq2_dfi_wrdata_mask_p5),    .o_z(int_dq2_dfi_wrdata_mask_p5 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p5_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p5[24+:8]),       .i_b(dq3_dfi_wrdata_p5     ),    .o_z(int_dq3_dfi_wrdata_p5      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p5_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p5[3]),  .i_b(dq3_dfi_wrdata_mask_p5),    .o_z(int_dq3_dfi_wrdata_mask_p5 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p6_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p6[0*8+:8]),       .i_b(dq0_dfi_wrdata_p6     ),    .o_z(int_dq0_dfi_wrdata_p6      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p6_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p6[0]),  .i_b(dq0_dfi_wrdata_mask_p6),    .o_z(int_dq0_dfi_wrdata_mask_p6 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p6_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p6[1*8+:8]),       .i_b(dq1_dfi_wrdata_p6     ),    .o_z(int_dq1_dfi_wrdata_p6      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p6_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p6[1]),  .i_b(dq1_dfi_wrdata_mask_p6),    .o_z(int_dq1_dfi_wrdata_mask_p6 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p6_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p6[16+:8]),       .i_b(dq2_dfi_wrdata_p6     ),    .o_z(int_dq2_dfi_wrdata_p6      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p6_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p6[2]),  .i_b(dq2_dfi_wrdata_mask_p6),    .o_z(int_dq2_dfi_wrdata_mask_p6 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p6_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p6[24+:8]),       .i_b(dq3_dfi_wrdata_p6     ),    .o_z(int_dq3_dfi_wrdata_p6      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p6_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p6[3]),  .i_b(dq3_dfi_wrdata_mask_p6),    .o_z(int_dq3_dfi_wrdata_mask_p6 ));
   
   ddr_mux #(.DWIDTH(8)) u_dq0_mux_p7_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p7[0*8+:8]),       .i_b(dq0_dfi_wrdata_p7     ),    .o_z(int_dq0_dfi_wrdata_p7      ));
   ddr_mux #(.DWIDTH(1)) u_dq0_mux_p7_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p7[0]),  .i_b(dq0_dfi_wrdata_mask_p7),    .o_z(int_dq0_dfi_wrdata_mask_p7 ));
   ddr_mux #(.DWIDTH(8)) u_dq1_mux_p7_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p7[1*8+:8]),       .i_b(dq1_dfi_wrdata_p7     ),    .o_z(int_dq1_dfi_wrdata_p7      ));
   ddr_mux #(.DWIDTH(1)) u_dq1_mux_p7_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p7[1]),  .i_b(dq1_dfi_wrdata_mask_p7),    .o_z(int_dq1_dfi_wrdata_mask_p7 ));
   ddr_mux #(.DWIDTH(8)) u_dq2_mux_p7_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p7[16+:8]),       .i_b(dq2_dfi_wrdata_p7     ),    .o_z(int_dq2_dfi_wrdata_p7      ));
   ddr_mux #(.DWIDTH(1)) u_dq2_mux_p7_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p7[2]),  .i_b(dq2_dfi_wrdata_mask_p7),    .o_z(int_dq2_dfi_wrdata_mask_p7 ));
   ddr_mux #(.DWIDTH(8)) u_dq3_mux_p7_0 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_p7[24+:8]),       .i_b(dq3_dfi_wrdata_p7     ),    .o_z(int_dq3_dfi_wrdata_p7      ));
   ddr_mux #(.DWIDTH(1)) u_dq3_mux_p7_1 (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_mask_p7[3]),  .i_b(dq3_dfi_wrdata_mask_p7),    .o_z(int_dq3_dfi_wrdata_mask_p7 ));


   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p0_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p0      ), .o_q(o_ch0_dq0_dfi_wrdata_p0      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p0_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p0 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p0 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p0_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p0      ), .o_q(o_ch0_dq1_dfi_wrdata_p0      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p0_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p0 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p0 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p1_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p1      ), .o_q(o_ch0_dq0_dfi_wrdata_p1      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p1_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p1 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p1 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p1_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p1      ), .o_q(o_ch0_dq1_dfi_wrdata_p1      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p1_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p1 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p1 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p2_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p2      ), .o_q(o_ch0_dq0_dfi_wrdata_p2      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p2_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p2 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p2 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p2_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p2      ), .o_q(o_ch0_dq1_dfi_wrdata_p2      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p2_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p2 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p2 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p3_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p3      ), .o_q(o_ch0_dq0_dfi_wrdata_p3      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p3_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p3 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p3 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p3_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p3      ), .o_q(o_ch0_dq1_dfi_wrdata_p3      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p3_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p3 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p3 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p4_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p4      ), .o_q(o_ch0_dq0_dfi_wrdata_p4      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p4_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p4 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p4 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p4_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p4      ), .o_q(o_ch0_dq1_dfi_wrdata_p4      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p4_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p4 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p4 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p5_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p5      ), .o_q(o_ch0_dq0_dfi_wrdata_p5      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p5_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p5 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p5 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p5_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p5      ), .o_q(o_ch0_dq1_dfi_wrdata_p5      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p5_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p5 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p5 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p6_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p6      ), .o_q(o_ch0_dq0_dfi_wrdata_p6      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p6_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p6 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p6 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p6_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p6      ), .o_q(o_ch0_dq1_dfi_wrdata_p6      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p6_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p6 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p6 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq0_pipe_p7_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_p7      ), .o_q(o_ch0_dq0_dfi_wrdata_p7      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p7_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq0_dfi_wrdata_mask_p7 ), .o_q(o_ch0_dq0_dfi_wrdata_mask_p7 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch0_dq1_pipe_p7_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_p7      ), .o_q(o_ch0_dq1_dfi_wrdata_p7      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p7_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq1_dfi_wrdata_mask_p7 ), .o_q(o_ch0_dq1_dfi_wrdata_mask_p7 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p0_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p0      ), .o_q(o_ch1_dq0_dfi_wrdata_p0      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p0_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p0 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p0 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p0_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p0      ), .o_q(o_ch1_dq1_dfi_wrdata_p0      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p0_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p0 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p0 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p1_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p1      ), .o_q(o_ch1_dq0_dfi_wrdata_p1      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p1_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p1 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p1 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p1_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p1      ), .o_q(o_ch1_dq1_dfi_wrdata_p1      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p1_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p1 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p1 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p2_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p2      ), .o_q(o_ch1_dq0_dfi_wrdata_p2      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p2_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p2 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p2 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p2_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p2      ), .o_q(o_ch1_dq1_dfi_wrdata_p2      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p2_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p2 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p2 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p3_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p3      ), .o_q(o_ch1_dq0_dfi_wrdata_p3      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p3_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p3 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p3 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p3_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p3      ), .o_q(o_ch1_dq1_dfi_wrdata_p3      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p3_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p3 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p3 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p4_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p4      ), .o_q(o_ch1_dq0_dfi_wrdata_p4      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p4_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p4 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p4 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p4_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p4      ), .o_q(o_ch1_dq1_dfi_wrdata_p4      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p4_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p4 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p4 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p5_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p5      ), .o_q(o_ch1_dq0_dfi_wrdata_p5      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p5_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p5 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p5 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p5_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p5      ), .o_q(o_ch1_dq1_dfi_wrdata_p5      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p5_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p5 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p5 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p6_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p6      ), .o_q(o_ch1_dq0_dfi_wrdata_p6      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p6_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p6 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p6 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p6_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p6      ), .o_q(o_ch1_dq1_dfi_wrdata_p6      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p6_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p6 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p6 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq0_pipe_p7_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_p7      ), .o_q(o_ch1_dq0_dfi_wrdata_p7      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p7_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq2_dfi_wrdata_mask_p7 ), .o_q(o_ch1_dq0_dfi_wrdata_mask_p7 ));
   ddr_pipeline #(.DWIDTH(8)) u_ch1_dq1_pipe_p7_0 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_p7      ), .o_q(o_ch1_dq1_dfi_wrdata_p7      ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p7_1 (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dq3_dfi_wrdata_mask_p7 ), .o_q(o_ch1_dq1_dfi_wrdata_mask_p7 ));
   
   // ------------------------------------------------------------------------
   // Write enable 
   // ------------------------------------------------------------------------

   logic dfi_wrdata_en_p0;
   logic dfi_wrdata_en_p1;
   logic dfi_wrdata_en_p2;
   logic dfi_wrdata_en_p3;
   logic dfi_wrdata_en_p4;
   logic dfi_wrdata_en_p5;
   logic dfi_wrdata_en_p6;
   logic dfi_wrdata_en_p7;

   logic                     int_dfi_wrdata_en_p0;
   logic                     int_dfi_wrdata_en_p1;
   logic                     int_dfi_wrdata_en_p2;
   logic                     int_dfi_wrdata_en_p3;
   logic                     int_dfi_wrdata_en_p4;
   logic                     int_dfi_wrdata_en_p5;
   logic                     int_dfi_wrdata_en_p6;
   logic                     int_dfi_wrdata_en_p7;

   ddr_mux #(.DWIDTH(1))  u_dq_mux_p0_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p0 ),                      .i_b(dfi_wrdata_en_p0  ),        .o_z(int_dfi_wrdata_en_p0  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p1_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p1 ),                      .i_b(dfi_wrdata_en_p1  ),        .o_z(int_dfi_wrdata_en_p1  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p2_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p2 ),                      .i_b(dfi_wrdata_en_p2  ),        .o_z(int_dfi_wrdata_en_p2  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p3_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p3 ),                      .i_b(dfi_wrdata_en_p3  ),        .o_z(int_dfi_wrdata_en_p3  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p4_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p4 ),                      .i_b(dfi_wrdata_en_p4  ),        .o_z(int_dfi_wrdata_en_p4  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p5_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p5 ),                      .i_b(dfi_wrdata_en_p5  ),        .o_z(int_dfi_wrdata_en_p5  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p6_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p6 ),                      .i_b(dfi_wrdata_en_p6  ),        .o_z(int_dfi_wrdata_en_p6  ));
   ddr_mux #(.DWIDTH(1))  u_dq_mux_p7_2              (.i_sel(buf_mode_sync), .i_a(i_dfi_wrdata_en_p7 ),                      .i_b(dfi_wrdata_en_p7  ),        .o_z(int_dfi_wrdata_en_p7  ));
   
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p0_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p0       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p0_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p0       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p1_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p1       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p1_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p1       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p2_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p2       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p2_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p2       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p3_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p3       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p3_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p3       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p4_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p4       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p4_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p4       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p5_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p5       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p5_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p5       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p6_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p6       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p6_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p6       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq0_pipe_p7_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p7       ), .o_q(o_ch0_dq0_dfi_wrdata_en_p7       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch0_dq1_pipe_p7_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p7       ), .o_q(o_ch0_dq1_dfi_wrdata_en_p7       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p0_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p0       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p0_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p0       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p0       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p1_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p1       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p1_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p1       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p1       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p2_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p2       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p2_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p2       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p2       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p3_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p3       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p3_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p3       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p3       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p4_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p4       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p4_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p4       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p4       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p5_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p5       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p5_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p5       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p5       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p6_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p6       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p6_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p6       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p6       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq0_pipe_p7_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p7       ), .o_q(o_ch1_dq0_dfi_wrdata_en_p7       ));
   ddr_pipeline #(.DWIDTH(1)) u_ch1_dq1_pipe_p7_4              (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_wrdata_en_p7       ), .o_q(o_ch1_dq1_dfi_wrdata_en_p7       ));
  

   // ------------------------------------------------------------------------
   // CA/CS/CKE
   // ------------------------------------------------------------------------

   logic [5:0]        dfi_ca_p0;
   logic              dfi_cke_p0;
   logic              dfi_cs_p0;
   logic [5:0]        dfi_ca_p1;
   logic              dfi_cke_p1;
   logic              dfi_cs_p1;
   logic [5:0]        dfi_ca_p2;
   logic              dfi_cke_p2;
   logic              dfi_cs_p2;
   logic [5:0]        dfi_ca_p3;
   logic              dfi_cke_p3;
   logic              dfi_cs_p3;
   logic [5:0]        dfi_ca_p4;
   logic              dfi_cke_p4;
   logic              dfi_cs_p4;
   logic [5:0]        dfi_ca_p5;
   logic              dfi_cke_p5;
   logic              dfi_cs_p5;
   logic [5:0]        dfi_ca_p6;
   logic              dfi_cke_p6;
   logic              dfi_cs_p6;
   logic [5:0]        dfi_ca_p7;
   logic              dfi_cke_p7;
   logic              dfi_cs_p7;

   logic [5:0]        int_dfi_ca_p0;
   logic [5:0]        int_dfi_ca_p1;
   logic [5:0]        int_dfi_ca_p2;
   logic [5:0]        int_dfi_ca_p3;
   logic [5:0]        int_dfi_ca_p4;
   logic [5:0]        int_dfi_ca_p5;
   logic [5:0]        int_dfi_ca_p6;
   logic [5:0]        int_dfi_ca_p7;

   logic                int_dfi_cke_p0;
   logic                int_dfi_cke_p1;
   logic                int_dfi_cke_p2;
   logic                int_dfi_cke_p3;
   logic                int_dfi_cke_p4;
   logic                int_dfi_cke_p5;
   logic                int_dfi_cke_p6;
   logic                int_dfi_cke_p7;

   logic                int_dfi_cs_p0;
   logic                int_dfi_cs_p1;
   logic                int_dfi_cs_p2;
   logic                int_dfi_cs_p3;
   logic                int_dfi_cs_p4;
   logic                int_dfi_cs_p5;
   logic                int_dfi_cs_p6;
   logic                int_dfi_cs_p7;

   ddr_mux #(.DWIDTH(6))  u_ca_mux_p0_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p0   ),                      .i_b(dfi_ca_p0    ),        .o_z(int_dfi_ca_p0    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p0_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p0        ),                      .i_b(dfi_cs_p0         ),        .o_z(int_dfi_cs_p0         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p0_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p0       ),                      .i_b(dfi_cke_p0        ),        .o_z(int_dfi_cke_p0        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p1_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p1   ),                      .i_b(dfi_ca_p1    ),        .o_z(int_dfi_ca_p1    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p1_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p1        ),                      .i_b(dfi_cs_p1         ),        .o_z(int_dfi_cs_p1         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p1_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p1       ),                      .i_b(dfi_cke_p1        ),        .o_z(int_dfi_cke_p1        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p2_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p2   ),                      .i_b(dfi_ca_p2    ),        .o_z(int_dfi_ca_p2    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p2_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p2        ),                      .i_b(dfi_cs_p2         ),        .o_z(int_dfi_cs_p2         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p2_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p2       ),                      .i_b(dfi_cke_p2        ),        .o_z(int_dfi_cke_p2        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p3_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p3   ),                      .i_b(dfi_ca_p3    ),        .o_z(int_dfi_ca_p3    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p3_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p3        ),                      .i_b(dfi_cs_p3         ),        .o_z(int_dfi_cs_p3         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p3_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p3       ),                      .i_b(dfi_cke_p3        ),        .o_z(int_dfi_cke_p3        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p4_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p4   ),                      .i_b(dfi_ca_p4    ),        .o_z(int_dfi_ca_p4    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p4_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p4        ),                      .i_b(dfi_cs_p4         ),        .o_z(int_dfi_cs_p4         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p4_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p4       ),                      .i_b(dfi_cke_p4        ),        .o_z(int_dfi_cke_p4        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p5_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p5   ),                      .i_b(dfi_ca_p5    ),        .o_z(int_dfi_ca_p5    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p5_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p5        ),                      .i_b(dfi_cs_p5         ),        .o_z(int_dfi_cs_p5         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p5_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p5       ),                      .i_b(dfi_cke_p5        ),        .o_z(int_dfi_cke_p5        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p6_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p6   ),                      .i_b(dfi_ca_p6    ),        .o_z(int_dfi_ca_p6    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p6_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p6        ),                      .i_b(dfi_cs_p6         ),        .o_z(int_dfi_cs_p6         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p6_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p6       ),                      .i_b(dfi_cke_p6        ),        .o_z(int_dfi_cke_p6        ));
   ddr_mux #(.DWIDTH(6))  u_ca_mux_p7_0  (.i_sel(buf_mode_sync), .i_a(i_dfi_ca_p7   ),                      .i_b(dfi_ca_p7    ),        .o_z(int_dfi_ca_p7    ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p7_1  (.i_sel(buf_mode_sync), .i_a(i_dfi_cs_p7        ),                      .i_b(dfi_cs_p7         ),        .o_z(int_dfi_cs_p7         ));
   ddr_mux #(.DWIDTH(1))  u_ca_mux_p7_2  (.i_sel(buf_mode_sync), .i_a(i_dfi_cke_p7       ),                      .i_b(dfi_cke_p7        ),        .o_z(int_dfi_cke_p7        ));

   
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p0_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p0         ), .o_q(o_ch0_dfi_ca_p0         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p1_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p1         ), .o_q(o_ch0_dfi_ca_p1         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p2_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p2         ), .o_q(o_ch0_dfi_ca_p2         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p3_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p3         ), .o_q(o_ch0_dfi_ca_p3         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p4_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p4         ), .o_q(o_ch0_dfi_ca_p4         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p5_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p5         ), .o_q(o_ch0_dfi_ca_p5         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p6_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p6         ), .o_q(o_ch0_dfi_ca_p6         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch0_ca_pipe_p7_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p7         ), .o_q(o_ch0_dfi_ca_p7         ));

   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p0_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p0         ), .o_q(o_ch1_dfi_ca_p0         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p1_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p1         ), .o_q(o_ch1_dfi_ca_p1         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p2_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p2         ), .o_q(o_ch1_dfi_ca_p2         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p3_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p3         ), .o_q(o_ch1_dfi_ca_p3         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p4_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p4         ), .o_q(o_ch1_dfi_ca_p4         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p5_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p5         ), .o_q(o_ch1_dfi_ca_p5         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p6_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p6         ), .o_q(o_ch1_dfi_ca_p6         ));
   ddr_pipeline #(.DWIDTH(6))  u_ch1_ca_pipe_p7_0  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_ca_p7         ), .o_q(o_ch1_dfi_ca_p7         ));
   
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p0_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p0         ), .o_q(o_ch0_dfi_cs_p0              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p1_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p1         ), .o_q(o_ch0_dfi_cs_p1              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p2_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p2         ), .o_q(o_ch0_dfi_cs_p2              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p3_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p3         ), .o_q(o_ch0_dfi_cs_p3              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p4_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p4         ), .o_q(o_ch0_dfi_cs_p4              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p5_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p5         ), .o_q(o_ch0_dfi_cs_p5              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p6_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p6         ), .o_q(o_ch0_dfi_cs_p6              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_ca_pipe_p7_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p7         ), .o_q(o_ch0_dfi_cs_p7              ));

   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p0_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p0         ), .o_q(o_ch1_dfi_cs_p0              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p1_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p1         ), .o_q(o_ch1_dfi_cs_p1              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p2_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p2         ), .o_q(o_ch1_dfi_cs_p2              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p3_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p3         ), .o_q(o_ch1_dfi_cs_p3              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p4_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p4         ), .o_q(o_ch1_dfi_cs_p4              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p5_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p5         ), .o_q(o_ch1_dfi_cs_p5              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p6_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p6         ), .o_q(o_ch1_dfi_cs_p6              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_ca_pipe_p7_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cs_p7         ), .o_q(o_ch1_dfi_cs_p7              ));

   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p0_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p0         ), .o_q(o_ch0_dfi_cke_p0              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p1_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p1         ), .o_q(o_ch0_dfi_cke_p1              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p2_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p2         ), .o_q(o_ch0_dfi_cke_p2              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p3_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p3         ), .o_q(o_ch0_dfi_cke_p3              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p4_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p4         ), .o_q(o_ch0_dfi_cke_p4              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p5_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p5         ), .o_q(o_ch0_dfi_cke_p5              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p6_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p6         ), .o_q(o_ch0_dfi_cke_p6              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch0_cke_pipe_p7_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p7         ), .o_q(o_ch0_dfi_cke_p7              ));

   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p0_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p0         ), .o_q(o_ch1_dfi_cke_p0              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p1_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p1         ), .o_q(o_ch1_dfi_cke_p1              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p2_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p2         ), .o_q(o_ch1_dfi_cke_p2              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p3_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p3         ), .o_q(o_ch1_dfi_cke_p3              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p4_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p4         ), .o_q(o_ch1_dfi_cke_p4              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p5_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p5         ), .o_q(o_ch1_dfi_cke_p5              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p6_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p6         ), .o_q(o_ch1_dfi_cke_p6              ));
   ddr_pipeline #(.DWIDTH(1))  u_ch1_cke_pipe_p7_1  (.i_clk(i_clk), .i_pipe_en(i_intf_pipe_en), .i_d(int_dfi_cke_p7         ), .o_q(o_ch1_dfi_cke_p7              ));

   
   // ------------------------------------------------------------------------
   // Timestamp Counter
   // ------------------------------------------------------------------------

   logic [15:0] timestamp_q;
   logic ts_enable_sync;
   logic ts_reset_sync;
   logic ts_brkpt_en_sync;
   logic ts_brkpt ;

   // Synchronize CSR controls
   ddr_demet_r u_demet_0 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ts_enable),        .o_q(ts_enable_sync));
   ddr_demet_r u_demet_1 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ts_reset ),        .o_q(ts_reset_sync ));
   ddr_demet_r u_demet_7 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ts_brkpt_en),      .o_q(ts_brkpt_en_sync ));

   assign ts_brkpt = ts_brkpt_en_sync && (timestamp_q == i_ts_brkpt_val) ;

   // Timestamp counter
   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst)
         timestamp_q <= '0;
      else if (ts_reset_sync)
         timestamp_q <= '0;
      else if (ts_enable_sync)
         timestamp_q <=  ts_brkpt ? timestamp_q : timestamp_q + 'b1;
   end

   // ------------------------------------------------------------------------
   // Buffer Ingress - To DDR Datapath
   // ------------------------------------------------------------------------

   localparam IG_WIDTH = 16+ (8*(4*9+2))+ (8*(1+1+6));

   logic [15:0] ig_timestamp, timestamp_early;
   logic ig_read, ig_write, ig_empty_n, ig_empty_n_q, ig_write_toggle_q ;
   logic [IG_WIDTH-1:0] ig_wdata, ig_rdata, ig_rdata_q, ig_mask_n, ig_mask_n_q;
   logic ig_wdata_en_sync, ig_wdata_en_q;
   logic ig_wdata_upd_sync, ig_wdata_upd_q;
   logic ig_load_ptr_sync ;
   logic wdata_loader_en, wdata_loader_upd;
   logic [IG_WIDTH-1:0] wdata_loader_q;
   logic [3:0] ig_loop_cnt_q ;
   logic [3:0] ig_loop_cnt_d ;



   // Current timestamp at the head of the FIFO
   assign timestamp_early = ig_rdata[IG_WIDTH-1:IG_WIDTH-16];

   // If the FIFO "head" timestamp matches the current runnign timestamp, then pop data
   assign ig_read = (timestamp_early == timestamp_q) & ig_empty_n & ( (ig_loop_cnt_q != 0) || (i_ig_loop_mode == 1'b0) );

   // Remove the timestamp from the read mask. Output data masked when TS does not match
   assign ig_mask_n = {{15{1'b1}},{IG_WIDTH-15{ig_read}}};

   // Ingress Read Data
   assign {
       ig_timestamp
      ,dfi_cs_p0
      ,dfi_cke_p0
      ,dfi_ca_p0
      ,dfi_cs_p1
      ,dfi_cke_p1
      ,dfi_ca_p1
      ,dfi_cs_p2
      ,dfi_cke_p2
      ,dfi_ca_p2
      ,dfi_cs_p3
      ,dfi_cke_p3
      ,dfi_ca_p3
      ,dfi_cs_p4
      ,dfi_cke_p4
      ,dfi_ca_p4
      ,dfi_cs_p5
      ,dfi_cke_p5
      ,dfi_ca_p5
      ,dfi_cs_p6
      ,dfi_cke_p6
      ,dfi_ca_p6
      ,dfi_cs_p7
      ,dfi_cke_p7
      ,dfi_ca_p7
      ,dfi_rddata_en_p0
      ,dfi_wrdata_en_p0
      ,dq0_dfi_wrdata_mask_p0
      ,dq0_dfi_wrdata_p0
      ,dq1_dfi_wrdata_mask_p0
      ,dq1_dfi_wrdata_p0
      ,dq2_dfi_wrdata_mask_p0
      ,dq2_dfi_wrdata_p0
      ,dq3_dfi_wrdata_mask_p0
      ,dq3_dfi_wrdata_p0
      ,dfi_rddata_en_p1
      ,dfi_wrdata_en_p1
      ,dq0_dfi_wrdata_mask_p1
      ,dq0_dfi_wrdata_p1
      ,dq1_dfi_wrdata_mask_p1
      ,dq1_dfi_wrdata_p1
      ,dq2_dfi_wrdata_mask_p1
      ,dq2_dfi_wrdata_p1
      ,dq3_dfi_wrdata_mask_p1
      ,dq3_dfi_wrdata_p1
      ,dfi_rddata_en_p2
      ,dfi_wrdata_en_p2
      ,dq0_dfi_wrdata_mask_p2
      ,dq0_dfi_wrdata_p2
      ,dq1_dfi_wrdata_mask_p2
      ,dq1_dfi_wrdata_p2
      ,dq2_dfi_wrdata_mask_p2
      ,dq2_dfi_wrdata_p2
      ,dq3_dfi_wrdata_mask_p2
      ,dq3_dfi_wrdata_p2
      ,dfi_rddata_en_p3
      ,dfi_wrdata_en_p3
      ,dq0_dfi_wrdata_mask_p3
      ,dq0_dfi_wrdata_p3
      ,dq1_dfi_wrdata_mask_p3
      ,dq1_dfi_wrdata_p3
      ,dq2_dfi_wrdata_mask_p3
      ,dq2_dfi_wrdata_p3
      ,dq3_dfi_wrdata_mask_p3
      ,dq3_dfi_wrdata_p3
      ,dfi_rddata_en_p4
      ,dfi_wrdata_en_p4
      ,dq0_dfi_wrdata_mask_p4
      ,dq0_dfi_wrdata_p4
      ,dq1_dfi_wrdata_mask_p4
      ,dq1_dfi_wrdata_p4
      ,dq2_dfi_wrdata_mask_p4
      ,dq2_dfi_wrdata_p4
      ,dq3_dfi_wrdata_mask_p4
      ,dq3_dfi_wrdata_p4
      ,dfi_rddata_en_p5
      ,dfi_wrdata_en_p5
      ,dq0_dfi_wrdata_mask_p5
      ,dq0_dfi_wrdata_p5
      ,dq1_dfi_wrdata_mask_p5
      ,dq1_dfi_wrdata_p5
      ,dq2_dfi_wrdata_mask_p5
      ,dq2_dfi_wrdata_p5
      ,dq3_dfi_wrdata_mask_p5
      ,dq3_dfi_wrdata_p5
      ,dfi_rddata_en_p6
      ,dfi_wrdata_en_p6
      ,dq0_dfi_wrdata_mask_p6
      ,dq0_dfi_wrdata_p6
      ,dq1_dfi_wrdata_mask_p6
      ,dq1_dfi_wrdata_p6
      ,dq2_dfi_wrdata_mask_p6
      ,dq2_dfi_wrdata_p6
      ,dq3_dfi_wrdata_mask_p6
      ,dq3_dfi_wrdata_p6
      ,dfi_rddata_en_p7
      ,dfi_wrdata_en_p7
      ,dq0_dfi_wrdata_mask_p7
      ,dq0_dfi_wrdata_p7
      ,dq1_dfi_wrdata_mask_p7
      ,dq1_dfi_wrdata_p7
      ,dq2_dfi_wrdata_mask_p7
      ,dq2_dfi_wrdata_p7
      ,dq3_dfi_wrdata_mask_p7
      ,dq3_dfi_wrdata_p7
   } = ig_rdata_q & ig_mask_n_q;

   // Synchronize CSR controls
   ddr_demet_r u_demet_2 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ig_wdata_en ), .o_q(ig_wdata_en_sync ));
   ddr_demet_r u_demet_3 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ig_wdata_upd), .o_q(ig_wdata_upd_sync));
   ddr_demet_r u_demet_8 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_ig_load_ptr),  .o_q(ig_load_ptr_sync));

   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst) begin
         ig_wdata_en_q     <= '0;
         ig_wdata_upd_q    <= '0;
         ig_write_toggle_q <= '0;
      end else begin
         ig_wdata_en_q     <= ig_wdata_en_sync;
         ig_wdata_upd_q    <= ig_wdata_upd_sync;
         ig_write_toggle_q <= ig_write_toggle_q ^ ig_write ;
      end
   end

   // Update the data loader on a CSR toggle
   assign wdata_loader_upd =  ig_wdata_upd_q ^ ig_wdata_upd_sync;

   // Enable the data loader on a CSR toggle
   assign wdata_loader_en = ig_wdata_en_q ^ ig_wdata_en_sync;

   // Ingress Write Data Loader
   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst)
         wdata_loader_q <= '0;
      else if (wdata_loader_en)
         wdata_loader_q <= {wdata_loader_q[IG_WIDTH-1-32:0], i_ig_wdata};
   end

   assign ig_wdata        = wdata_loader_q;
   assign ig_write        = wdata_loader_upd;
   assign o_ig_empty      = ~ig_empty_n_q;
   assign o_ig_overflow   = o_ig_full & ig_write;
   assign o_ig_write_done = ig_write_toggle_q ;

   ddr_fifo #(
      .WWIDTH                       (6),
      .RWIDTH                       (6),
      .DEPTH                        (64),
      .SYNC                         (1'b1),
      .RAM_MODEL                    (0)
   ) u_ig_fifo (
      .i_scan_mode                  (i_scan_mode),
      .i_scan_rst_ctrl              (i_scan_rst_ctrl),
      .i_scan_cgc_ctrl              (i_scan_cgc_ctrl),
      .i_clr                        (i_ig_wdata_clr),
      .i_loop_mode                  (i_ig_loop_mode),
      .i_load_ptr                   (ig_load_ptr_sync),
      .i_stop_ptr                   (i_ig_stop_ptr ),
      .i_start_ptr                  (i_ig_start_ptr),
      .i_wclk                       (clk_g),
      .i_wrst                       (i_rst),
      .i_write                      (ig_write),
      .i_wdata                      (ig_wdata),
      .o_full                       (o_ig_full),
      .o_early_full                 (/*OPEN*/),
      .i_rclk                       (clk_g),
      .i_rrst                       (i_rst),
      .i_read                       (ig_read),
      .o_rdata                      (ig_rdata),
      .o_early_empty_n              (/*OPEN*/),
      .o_empty_n                    (ig_empty_n)
   );

   assign ig_loop_cnt_d = ig_load_ptr_sync             ? i_ig_num_loops :
                          (ig_empty_n_q & ~ig_empty_n) ? ig_loop_cnt_q - 1'b1 :
                          ig_loop_cnt_q ;

   // Hold data so values persist on bus
   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst) begin
         ig_rdata_q    <= '0;
         ig_mask_n_q   <= '0;
         ig_empty_n_q  <= '0;
         ig_loop_cnt_q <= 4'h1;
      end else begin
         if (ig_read || !i_ig_wdata_hold) begin
            ig_rdata_q  <= ig_rdata;
            ig_mask_n_q <= ig_mask_n;
         end
         ig_empty_n_q  <= ig_empty_n;
         if (i_ig_loop_mode)
            ig_loop_cnt_q <= ig_loop_cnt_d;
      end
   end

   // ------------------------------------------------------------------------
   // Buffer Egress - From Datapath
   // ------------------------------------------------------------------------

   localparam EG_WIDTH = 16+ 4*8*(8+1+1);

   logic [EG_WIDTH-1:0] eg_wdata, eg_rdata;
   logic eg_write, eg_read, eg_empty_n, eg_read_toggle_q ;
   logic eg_rdata_en_sync, eg_rdata_en_q;
   logic eg_rdata_upd_sync, eg_rdata_upd_q;
   logic rdata_loader_en, rdata_loader_upd;
   logic [EG_WIDTH-1:0] rdata_loader_q;

   // Read Data
   assign eg_wdata = {
       timestamp_q
       ,i_dq0_dfi_rddata_valid_w0
       ,i_dq0_dfi_rddata_dbi_w0
       ,i_dq0_dfi_rddata_w0
       ,i_dq0_dfi_rddata_valid_w1
       ,i_dq0_dfi_rddata_dbi_w1
       ,i_dq0_dfi_rddata_w1
       ,i_dq0_dfi_rddata_valid_w2
       ,i_dq0_dfi_rddata_dbi_w2
       ,i_dq0_dfi_rddata_w2
       ,i_dq0_dfi_rddata_valid_w3
       ,i_dq0_dfi_rddata_dbi_w3
       ,i_dq0_dfi_rddata_w3
       ,i_dq0_dfi_rddata_valid_w4
       ,i_dq0_dfi_rddata_dbi_w4
       ,i_dq0_dfi_rddata_w4
       ,i_dq0_dfi_rddata_valid_w5
       ,i_dq0_dfi_rddata_dbi_w5
       ,i_dq0_dfi_rddata_w5
       ,i_dq0_dfi_rddata_valid_w6
       ,i_dq0_dfi_rddata_dbi_w6
       ,i_dq0_dfi_rddata_w6
       ,i_dq0_dfi_rddata_valid_w7
       ,i_dq0_dfi_rddata_dbi_w7
       ,i_dq0_dfi_rddata_w7
       ,i_dq1_dfi_rddata_valid_w0
       ,i_dq1_dfi_rddata_dbi_w0
       ,i_dq1_dfi_rddata_w0
       ,i_dq1_dfi_rddata_valid_w1
       ,i_dq1_dfi_rddata_dbi_w1
       ,i_dq1_dfi_rddata_w1
       ,i_dq1_dfi_rddata_valid_w2
       ,i_dq1_dfi_rddata_dbi_w2
       ,i_dq1_dfi_rddata_w2
       ,i_dq1_dfi_rddata_valid_w3
       ,i_dq1_dfi_rddata_dbi_w3
       ,i_dq1_dfi_rddata_w3
       ,i_dq1_dfi_rddata_valid_w4
       ,i_dq1_dfi_rddata_dbi_w4
       ,i_dq1_dfi_rddata_w4
       ,i_dq1_dfi_rddata_valid_w5
       ,i_dq1_dfi_rddata_dbi_w5
       ,i_dq1_dfi_rddata_w5
       ,i_dq1_dfi_rddata_valid_w6
       ,i_dq1_dfi_rddata_dbi_w6
       ,i_dq1_dfi_rddata_w6
       ,i_dq1_dfi_rddata_valid_w7
       ,i_dq1_dfi_rddata_dbi_w7
       ,i_dq1_dfi_rddata_w7
       ,i_dq2_dfi_rddata_valid_w0
       ,i_dq2_dfi_rddata_dbi_w0
       ,i_dq2_dfi_rddata_w0
       ,i_dq2_dfi_rddata_valid_w1
       ,i_dq2_dfi_rddata_dbi_w1
       ,i_dq2_dfi_rddata_w1
       ,i_dq2_dfi_rddata_valid_w2
       ,i_dq2_dfi_rddata_dbi_w2
       ,i_dq2_dfi_rddata_w2
       ,i_dq2_dfi_rddata_valid_w3
       ,i_dq2_dfi_rddata_dbi_w3
       ,i_dq2_dfi_rddata_w3
       ,i_dq2_dfi_rddata_valid_w4
       ,i_dq2_dfi_rddata_dbi_w4
       ,i_dq2_dfi_rddata_w4
       ,i_dq2_dfi_rddata_valid_w5
       ,i_dq2_dfi_rddata_dbi_w5
       ,i_dq2_dfi_rddata_w5
       ,i_dq2_dfi_rddata_valid_w6
       ,i_dq2_dfi_rddata_dbi_w6
       ,i_dq2_dfi_rddata_w6
       ,i_dq2_dfi_rddata_valid_w7
       ,i_dq2_dfi_rddata_dbi_w7
       ,i_dq2_dfi_rddata_w7
       ,i_dq3_dfi_rddata_valid_w0
       ,i_dq3_dfi_rddata_dbi_w0
       ,i_dq3_dfi_rddata_w0
       ,i_dq3_dfi_rddata_valid_w1
       ,i_dq3_dfi_rddata_dbi_w1
       ,i_dq3_dfi_rddata_w1
       ,i_dq3_dfi_rddata_valid_w2
       ,i_dq3_dfi_rddata_dbi_w2
       ,i_dq3_dfi_rddata_w2
       ,i_dq3_dfi_rddata_valid_w3
       ,i_dq3_dfi_rddata_dbi_w3
       ,i_dq3_dfi_rddata_w3
       ,i_dq3_dfi_rddata_valid_w4
       ,i_dq3_dfi_rddata_dbi_w4
       ,i_dq3_dfi_rddata_w4
       ,i_dq3_dfi_rddata_valid_w5
       ,i_dq3_dfi_rddata_dbi_w5
       ,i_dq3_dfi_rddata_w5
       ,i_dq3_dfi_rddata_valid_w6
       ,i_dq3_dfi_rddata_dbi_w6
       ,i_dq3_dfi_rddata_w6
       ,i_dq3_dfi_rddata_valid_w7
       ,i_dq3_dfi_rddata_dbi_w7
       ,i_dq3_dfi_rddata_w7
   };

   assign eg_write   = (
    (|i_dq0_dfi_rddata_valid_w0) |
    (|i_dq0_dfi_rddata_valid_w1) |
    (|i_dq0_dfi_rddata_valid_w2) |
    (|i_dq0_dfi_rddata_valid_w3) |
    (|i_dq0_dfi_rddata_valid_w4) |
    (|i_dq0_dfi_rddata_valid_w5) |
    (|i_dq0_dfi_rddata_valid_w6) |
    (|i_dq0_dfi_rddata_valid_w7) |
    (|i_dq1_dfi_rddata_valid_w0) |
    (|i_dq1_dfi_rddata_valid_w1) |
    (|i_dq1_dfi_rddata_valid_w2) |
    (|i_dq1_dfi_rddata_valid_w3) |
    (|i_dq1_dfi_rddata_valid_w4) |
    (|i_dq1_dfi_rddata_valid_w5) |
    (|i_dq1_dfi_rddata_valid_w6) |
    (|i_dq1_dfi_rddata_valid_w7) |
    (|i_dq2_dfi_rddata_valid_w0) |
    (|i_dq2_dfi_rddata_valid_w1) |
    (|i_dq2_dfi_rddata_valid_w2) |
    (|i_dq2_dfi_rddata_valid_w3) |
    (|i_dq2_dfi_rddata_valid_w4) |
    (|i_dq2_dfi_rddata_valid_w5) |
    (|i_dq2_dfi_rddata_valid_w6) |
    (|i_dq2_dfi_rddata_valid_w7) |
    (|i_dq3_dfi_rddata_valid_w0) |
    (|i_dq3_dfi_rddata_valid_w1) |
    (|i_dq3_dfi_rddata_valid_w2) |
    (|i_dq3_dfi_rddata_valid_w3) |
    (|i_dq3_dfi_rddata_valid_w4) |
    (|i_dq3_dfi_rddata_valid_w5) |
    (|i_dq3_dfi_rddata_valid_w6) |
    (|i_dq3_dfi_rddata_valid_w7) |
      1'b0
   );

   assign o_eg_empty     =  ~eg_empty_n ;
   assign o_eg_overflow  = o_eg_full & eg_write;
   assign o_eg_read_done = eg_read_toggle_q ;

   ddr_fifo #(
      .WWIDTH                       (6),
      .RWIDTH                       (6),
      .DEPTH                        (64),
      .SYNC                         (1'b1),
      .RAM_MODEL                    (0)
   ) u_eg_fifo (
      .i_scan_mode                  (i_scan_mode),
      .i_scan_rst_ctrl              (i_scan_rst_ctrl),
      .i_scan_cgc_ctrl              (i_scan_cgc_ctrl),
      .i_clr                        (i_eg_rdata_clr),
      .i_loop_mode                  ('0),
      .i_load_ptr                   ('0),
      .i_stop_ptr                   ('0),
      .i_start_ptr                  ('0),
      .i_wclk                       (clk_g),
      .i_wrst                       (i_rst),
      .i_write                      (eg_write),
      .i_wdata                      (eg_wdata),
      .o_full                       (o_eg_full),
      .o_early_full                 (/*OPEN*/),
      .i_rclk                       (clk_g),
      .i_rrst                       (i_rst),
      .i_read                       (eg_read),
      .o_rdata                      (eg_rdata),
      .o_early_empty_n              (/*OPEN*/),
      .o_empty_n                    (eg_empty_n)
   );

   // Synchronize CSR controls
   ddr_demet_r u_demet_4 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_eg_rdata_en ), .o_q(eg_rdata_en_sync ));
   ddr_demet_r u_demet_5 (.i_clk(clk_g), .i_rst(i_rst), .i_d(i_eg_rdata_upd), .o_q(eg_rdata_upd_sync));

   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst) begin
         eg_rdata_en_q     <= '0;
         eg_rdata_upd_q    <= '0;
         eg_read_toggle_q  <= '0;
      end else begin
         eg_rdata_en_q     <= eg_rdata_en_sync;
         eg_rdata_upd_q    <= eg_rdata_upd_sync;
         eg_read_toggle_q  <= eg_read_toggle_q ^ eg_read ;
      end
   end

   // Update the data loader on a CSR toggle
   assign rdata_loader_upd =  eg_rdata_upd_q ^ eg_rdata_upd_sync;

   // Enable the data loader on a CSR toggle
   assign rdata_loader_en = eg_rdata_en_q ^ eg_rdata_en_sync;

   // Egress Write Data Loader
   always_ff @ (posedge clk_g, posedge i_rst) begin
      if (i_rst)
         rdata_loader_q <= '0;
      else if (rdata_loader_upd)
         rdata_loader_q <= eg_rdata;
      else if (rdata_loader_en)
         rdata_loader_q <= {{32{1'b0}},rdata_loader_q[EG_WIDTH-1:32]};
   end

   // Pop read data from Egress FIFO
   assign eg_read = rdata_loader_upd;

   // Read data to CSR
   assign o_eg_rdata = rdata_loader_q[31:0];

   //---------------------------------------------------------------------------
   // Debug Bus
   //---------------------------------------------------------------------------
   assign o_debug = { 24'b0,
                      ig_write,
                      ig_read,
                      ig_empty_n,
                      o_ig_overflow,
                      eg_write,
                      eg_read,
                      eg_empty_n,
                      o_eg_overflow
                    } ;
endmodule