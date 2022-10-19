`timescale 1ns/1ps
module ucie_channel_adapter_tb();
    parameter half_clk_cycle=0.25;

    logic rst,csp_rst_n;
    logic pll_clk;
    logic pll_clk_90;
    logic pll_clk_180;
    logic pll_clk_270;
    logic clk;

    assign #(half_clk_cycle/2) pll_clk_90=pll_clk;
    assign pll_clk_180=~pll_clk;
    assign pll_clk_270=~pll_clk_90;

    //D0 Channel Interface
   logic [71:0]            D0_ch0_tx_dq0_sdr;
   logic [71:0]            D0_ch0_rx_dq0_sdr;
   logic [8:0]             D0_ch0_rx_dq0_sdr_vld;
   logic [71:0]           D0_ch0_tx_dqs0_sdr;
   logic [71:0]            D0_ch0_tx_dq1_sdr;
   logic [71:0]            D0_ch0_rx_dq1_sdr;
   logic [8:0]             D0_ch0_rx_dq1_sdr_vld;
   logic [71:0]           D0_ch0_tx_dqs1_sdr;

   logic [63:0]            D0_ch0_tx_ca_sdr;
   logic [63:0]            D0_ch0_rx_ca_sdr;
   logic [7:0]             D0_ch0_rx_ca_sdr_vld;
   logic [71:0]            D0_ch0_tx_ck_sdr;

    //D1 Channel Interface
   logic [71:0]            D1_ch0_tx_dq0_sdr;
   logic [71:0]            D1_ch0_rx_dq0_sdr;
   logic [8:0]             D1_ch0_rx_dq0_sdr_vld;
   logic [71:0]           D1_ch0_tx_dqs0_sdr;
   logic [71:0]            D1_ch0_tx_dq1_sdr;
   logic [71:0]            D1_ch0_rx_dq1_sdr;
   logic [8:0]             D1_ch0_rx_dq1_sdr_vld;
   logic [71:0]           D1_ch0_tx_dqs1_sdr;

   logic [63:0]            D1_ch0_tx_ca_sdr;
   logic [63:0]            D1_ch0_rx_ca_sdr;
   logic [7:0]             D1_ch0_rx_ca_sdr_vld;
   logic [71:0]            D1_ch0_tx_ck_sdr;


//virtual channel
    wire [17:0]  pad_D0_dq;
    wire [7:0]  pad_D0_ca;
    wire  pad_D0_ck_c;
    wire  pad_D0_ck_t;
    wire [1:0] pad_D0_dqs_c;
    wire [1:0] pad_D0_dqs_t;

    wire [17:0]  pad_D1_dq;
    wire [7:0]  pad_D1_ca;
    wire  pad_D1_ck_c;
    wire  pad_D1_ck_t;
    wire [1:0] pad_D1_dqs_c;
    wire [1:0] pad_D1_dqs_t;

//AHB
   logic [31:0]                  ahb_if_haddr;
   logic                         ahb_if_hwrite;
   logic                         ahb_if_hbusreq;
   logic [31:0]                  ahb_if_hwdata;
   logic [1:0]                   ahb_if_htrans;
   logic [2:0]                   ahb_if_hsize;
   logic                         ahb_if_hsel;
   logic [2:0]                   ahb_if_hburst;
   logic                         ahb_if_hreadyin;
   logic                         ahb_if_hready;
   logic [31:0]                  ahb_if_hrdata;
   logic [1:0]                   ahb_if_hresp;
   logic                         ahb_if_hgrant;


//D0----->D1
    parameter channel_delay=0.25;
    assign #channel_delay pad_D1_dq=pad_D0_dq;
    assign #channel_delay pad_D1_dqs_c=pad_D0_dqs_c;
    assign #channel_delay pad_D1_dqs_t=pad_D0_dqs_t;
    assign #channel_delay pad_D1_ca=pad_D0_ca;
    assign #channel_delay pad_D1_ck_c=pad_D0_ck_c;
    assign #channel_delay pad_D1_ck_t=pad_D0_ck_t;

    logic [383:0] xmit_q [$];
    int err_count;
    int run_for_n_pkts;

//ahb clk
   logic ahb_clk;

   // ------------------------------------------------------------------------
   // AHB Interconnect
   // ------------------------------------------------------------------------

   logic [31:0]                  mcu_ahbm_haddr;
   logic                         mcu_ahbm_hwrite;
   logic                         mcu_ahbm_hbusreq;
   logic [31:0]                  mcu_ahbm_hwdata;
   logic [1:0]                   mcu_ahbm_htrans;
   logic [2:0]                   mcu_ahbm_hsize;
   logic [2:0]                   mcu_ahbm_hburst;
   logic                         mcu_ahbm_hreadyin;
   logic                         mcu_ahbm_hready;
   logic [31:0]        mcu_ahbm_hrdata;
   logic [1:0]                   mcu_ahbm_hresp;
   logic                         mcu_ahbm_hgrant;

   logic [31:0]                  mcutop_csr_ahbs_haddr;
   logic                         mcutop_csr_ahbs_hwrite;
   logic                         mcutop_csr_ahbs_hsel;
   logic [31:0]                  mcutop_csr_ahbs_hwdata;
   logic [1:0]                   mcutop_csr_ahbs_htrans;
   logic [2:0]                   mcutop_csr_ahbs_hsize;
   logic [2:0]                   mcutop_csr_ahbs_hburst;
   logic                         mcutop_csr_ahbs_hready;
   logic                         mcutop_csr_ahbs_hreadyin;
   logic [31:0]        mcutop_csr_ahbs_hrdata;
   logic [1:0]                   mcutop_csr_ahbs_hresp;

   logic [31:0]                  mcu_ahbs_haddr;
   logic                         mcu_ahbs_hwrite;
   logic                         mcu_ahbs_hsel;
   logic [31:0]                  mcu_ahbs_hwdata;
   logic [1:0]                   mcu_ahbs_htrans;
   logic [2:0]                   mcu_ahbs_hsize;
   logic [2:0]                   mcu_ahbs_hburst;
   logic                         mcu_ahbs_hready;
   logic                         mcu_ahbs_hreadyin;
   logic [31:0]        mcu_ahbs_hrdata;
   logic [1:0]                   mcu_ahbs_hresp;
   logic                         mcu_ahbs_hgrant;

   logic [31:0]                  mcu_cfg_ahbs_haddr;
   logic                         mcu_cfg_ahbs_hwrite;
   logic                         mcu_cfg_ahbs_hsel;
   logic [31:0]                  mcu_cfg_ahbs_hwdata;
   logic [1:0]                   mcu_cfg_ahbs_htrans;
   logic [2:0]                   mcu_cfg_ahbs_hsize;
   logic [2:0]                   mcu_cfg_ahbs_hburst;
   logic                         mcu_cfg_ahbs_hready;
   logic                         mcu_cfg_ahbs_hreadyin;
   logic [31:0]        mcu_cfg_ahbs_hrdata;
   logic [1:0]                   mcu_cfg_ahbs_hresp;

   logic [31:0]                  cmn_ahbs_haddr;
   logic                         cmn_ahbs_hwrite;
   logic                         cmn_ahbs_hsel;
   logic [31:0]                  cmn_ahbs_hwdata;
   logic [1:0]                   cmn_ahbs_htrans;
   logic [2:0]                   cmn_ahbs_hsize;
   logic [2:0]                   cmn_ahbs_hburst;
   logic                         cmn_ahbs_hready;
   logic                         cmn_ahbs_hreadyin;
   logic [31:0]        cmn_ahbs_hrdata;
   logic [1:0]                   cmn_ahbs_hresp;

   logic [31:0]                  dfi_ahbs_haddr;
   logic                         dfi_ahbs_hwrite;
   logic                         dfi_ahbs_hsel;
   logic [31:0]                  dfi_ahbs_hwdata;
   logic [1:0]                   dfi_ahbs_htrans;
   logic [2:0]                   dfi_ahbs_hsize;
   logic [2:0]                   dfi_ahbs_hburst;
   logic                         dfi_ahbs_hready;
   logic                         dfi_ahbs_hreadyin;
   logic [31:0]        dfi_ahbs_hrdata;
   logic [1:0]                   dfi_ahbs_hresp;

   logic [31:0]                  ch0_dq0_ahbs_haddr;
   logic                         ch0_dq0_ahbs_hwrite;
   logic                         ch0_dq0_ahbs_hsel;
   logic [31:0]                  ch0_dq0_ahbs_hwdata;
   logic [1:0]                   ch0_dq0_ahbs_htrans;
   logic [2:0]                   ch0_dq0_ahbs_hsize;
   logic [2:0]                   ch0_dq0_ahbs_hburst;
   logic                         ch0_dq0_ahbs_hready;
   logic                         ch0_dq0_ahbs_hreadyin;
   logic [31:0]        ch0_dq0_ahbs_hrdata;
   logic [1:0]                   ch0_dq0_ahbs_hresp;

   logic [31:0]                  ch0_dq1_ahbs_haddr;
   logic                         ch0_dq1_ahbs_hwrite;
   logic                         ch0_dq1_ahbs_hsel;
   logic [31:0]                  ch0_dq1_ahbs_hwdata;
   logic [1:0]                   ch0_dq1_ahbs_htrans;
   logic [2:0]                   ch0_dq1_ahbs_hsize;
   logic [2:0]                   ch0_dq1_ahbs_hburst;
   logic                         ch0_dq1_ahbs_hready;
   logic                         ch0_dq1_ahbs_hreadyin;
   logic [31:0]        ch0_dq1_ahbs_hrdata;
   logic [1:0]                   ch0_dq1_ahbs_hresp;

   logic [31:0]                  ch0_ca_ahbs_haddr;
   logic                         ch0_ca_ahbs_hwrite;
   logic                         ch0_ca_ahbs_hsel;
   logic [31:0]                  ch0_ca_ahbs_hwdata;
   logic [1:0]                   ch0_ca_ahbs_htrans;
   logic [2:0]                   ch0_ca_ahbs_hsize;
   logic [2:0]                   ch0_ca_ahbs_hburst;
   logic                         ch0_ca_ahbs_hready;
   logic                         ch0_ca_ahbs_hreadyin;
   logic [31:0]        ch0_ca_ahbs_hrdata;
   logic [1:0]                   ch0_ca_ahbs_hresp;
   logic [31:0]                  ch1_dq0_ahbs_haddr;
   logic                         ch1_dq0_ahbs_hwrite;
   logic                         ch1_dq0_ahbs_hsel;
   logic [31:0]                  ch1_dq0_ahbs_hwdata;
   logic [1:0]                   ch1_dq0_ahbs_htrans;
   logic [2:0]                   ch1_dq0_ahbs_hsize;
   logic [2:0]                   ch1_dq0_ahbs_hburst;
   logic                         ch1_dq0_ahbs_hready;
   logic                         ch1_dq0_ahbs_hreadyin;
   logic [31:0]        ch1_dq0_ahbs_hrdata;
   logic [1:0]                   ch1_dq0_ahbs_hresp;

   logic [31:0]                  ch1_dq1_ahbs_haddr;
   logic                         ch1_dq1_ahbs_hwrite;
   logic                         ch1_dq1_ahbs_hsel;
   logic [31:0]                  ch1_dq1_ahbs_hwdata;
   logic [1:0]                   ch1_dq1_ahbs_htrans;
   logic [2:0]                   ch1_dq1_ahbs_hsize;
   logic [2:0]                   ch1_dq1_ahbs_hburst;
   logic                         ch1_dq1_ahbs_hready;
   logic                         ch1_dq1_ahbs_hreadyin;
   logic [31:0]        ch1_dq1_ahbs_hrdata;
   logic [1:0]                   ch1_dq1_ahbs_hresp;

   logic [31:0]                  ch1_ca_ahbs_haddr;
   logic                         ch1_ca_ahbs_hwrite;
   logic                         ch1_ca_ahbs_hsel;
   logic [31:0]                  ch1_ca_ahbs_hwdata;
   logic [1:0]                   ch1_ca_ahbs_htrans;
   logic [2:0]                   ch1_ca_ahbs_hsize;
   logic [2:0]                   ch1_ca_ahbs_hburst;
   logic                         ch1_ca_ahbs_hready;
   logic                         ch1_ca_ahbs_hreadyin;
   logic [31:0]        ch1_ca_ahbs_hrdata;
   logic [1:0]                   ch1_ca_ahbs_hresp;

   logic [31:0]                  ctrl_ahbs_haddr;
   logic                         ctrl_ahbs_hwrite;
   logic                         ctrl_ahbs_hsel;
   logic [31:0]                  ctrl_ahbs_hwdata;
   logic [1:0]                   ctrl_ahbs_htrans;
   logic [2:0]                   ctrl_ahbs_hsize;
   logic [2:0]                   ctrl_ahbs_hburst;
   logic                         ctrl_ahbs_hready;
   logic                         ctrl_ahbs_hreadyin;
   logic [31:0]        ctrl_ahbs_hrdata;
   logic [1:0]                   ctrl_ahbs_hresp;

   ddr_ahb_ic #(
      .AWIDTH                        (32),
      .DWIDTH                        (32)
   ) u_ahb_ic (

      .i_scan_cgc_ctrl               (0),
      .i_scan_mode                   (0),
      .i_scan_rst_ctrl               (0),

      .i_mcu_clk                     (ahb_clk),
      .i_mcu_rst                     (rst),
      .i_hclk                        (ahb_clk),
      .i_hrst                        (rst),

      .i_ahb_extclk                  (ahb_clk),
      .i_ahb_extrst                  (rst),

      .i_intf_ahbs_haddr             (ahb_if_haddr),
      .i_intf_ahbs_hwrite            (ahb_if_hwrite),
      .i_intf_ahbs_hsel              (ahb_if_hsel),
      .i_intf_ahbs_hwdata            (ahb_if_hwdata),
      .i_intf_ahbs_htrans            (ahb_if_htrans),
      .i_intf_ahbs_hsize             (ahb_if_hsize),
      .i_intf_ahbs_hburst            (ahb_if_hburst),
      .i_intf_ahbs_hreadyin          (ahb_if_hreadyin),
      .o_intf_ahbs_hready            (ahb_if_hready),
      .o_intf_ahbs_hrdata            (ahb_if_hrdata),
      .o_intf_ahbs_hresp             (ahb_if_hresp),

      .o_ext_ahbm_haddr              (),
      .o_ext_ahbm_hwrite             (),
      .o_ext_ahbm_hbusreq            (),
      .o_ext_ahbm_hwdata             (),
      .o_ext_ahbm_htrans             (),
      .o_ext_ahbm_hsize              (),
      .o_ext_ahbm_hburst             (),
      .i_ext_ahbm_hready             ('0),
      .i_ext_ahbm_hrdata             ('0),
      .i_ext_ahbm_hresp              ('0),
      .i_ext_ahbm_hgrant             ('0),

      .i_mcu_ahbm_haddr              ('0),
      .i_mcu_ahbm_hwrite             ('0),
      .i_mcu_ahbm_hbusreq            ('0),
      .i_mcu_ahbm_hwdata             ('0),
      .i_mcu_ahbm_htrans             ('0),
      .i_mcu_ahbm_hsize              ('0),
      .i_mcu_ahbm_hburst             ('0),
      .i_mcu_ahbm_hreadyin           ('0),
      .o_mcu_ahbm_hready             (mcu_ahbm_hready),
      .o_mcu_ahbm_hrdata             (mcu_ahbm_hrdata),
      .o_mcu_ahbm_hresp              (mcu_ahbm_hresp),
      .o_mcu_ahbm_hgrant             (mcu_ahbm_hgrant),

      .o_mcutop_ahbs_haddr           (mcutop_csr_ahbs_haddr),
      .o_mcutop_ahbs_hwrite          (mcutop_csr_ahbs_hwrite),
      .o_mcutop_ahbs_hsel            (mcutop_csr_ahbs_hsel),
      .o_mcutop_ahbs_hwdata          (mcutop_csr_ahbs_hwdata),
      .o_mcutop_ahbs_htrans          (mcutop_csr_ahbs_htrans),
      .o_mcutop_ahbs_hsize           (mcutop_csr_ahbs_hsize),
      .o_mcutop_ahbs_hburst          (mcutop_csr_ahbs_hburst),
      .o_mcutop_ahbs_hreadyin        (mcutop_csr_ahbs_hreadyin),
      .i_mcutop_ahbs_hready          ('0),
      .i_mcutop_ahbs_hrdata          ('0),
      .i_mcutop_ahbs_hresp           ('0),

      .o_mcu_ahbs_haddr              (mcu_ahbs_haddr),
      .o_mcu_ahbs_hwrite             (mcu_ahbs_hwrite),
      .o_mcu_ahbs_hsel               (mcu_ahbs_hsel),
      .o_mcu_ahbs_hwdata             (mcu_ahbs_hwdata),
      .o_mcu_ahbs_htrans             (mcu_ahbs_htrans),
      .o_mcu_ahbs_hsize              (mcu_ahbs_hsize),
      .o_mcu_ahbs_hburst             (mcu_ahbs_hburst),
      .o_mcu_ahbs_hreadyin           (mcu_ahbs_hreadyin),
      .i_mcu_ahbs_hready             ('0),
      .i_mcu_ahbs_hrdata             ('0),
      .i_mcu_ahbs_hresp              ('0),
      .i_mcu_ahbs_hgrant             ('0),

      .o_mcu_cfg_ahbs_haddr          (mcu_cfg_ahbs_haddr),
      .o_mcu_cfg_ahbs_hwrite         (mcu_cfg_ahbs_hwrite),
      .o_mcu_cfg_ahbs_hsel           (mcu_cfg_ahbs_hsel),
      .o_mcu_cfg_ahbs_hwdata         (mcu_cfg_ahbs_hwdata),
      .o_mcu_cfg_ahbs_htrans         (mcu_cfg_ahbs_htrans),
      .o_mcu_cfg_ahbs_hsize          (mcu_cfg_ahbs_hsize),
      .o_mcu_cfg_ahbs_hburst         (mcu_cfg_ahbs_hburst),
      .o_mcu_cfg_ahbs_hreadyin       (mcu_cfg_ahbs_hreadyin),
      .i_mcu_cfg_ahbs_hready         ('0),
      .i_mcu_cfg_ahbs_hrdata         ('0),
      .i_mcu_cfg_ahbs_hresp          ('0),

      .o_cmn_ahbs_haddr              (cmn_ahbs_haddr),
      .o_cmn_ahbs_hwrite             (cmn_ahbs_hwrite),
      .o_cmn_ahbs_hsel               (cmn_ahbs_hsel),
      .o_cmn_ahbs_hwdata             (cmn_ahbs_hwdata),
      .o_cmn_ahbs_htrans             (cmn_ahbs_htrans),
      .o_cmn_ahbs_hsize              (cmn_ahbs_hsize),
      .o_cmn_ahbs_hburst             (cmn_ahbs_hburst),
      .o_cmn_ahbs_hreadyin           (cmn_ahbs_hreadyin),
      .i_cmn_ahbs_hready             ('0),
      .i_cmn_ahbs_hrdata             ('0),
      .i_cmn_ahbs_hresp              ('0),

      .o_dfi_ahbs_haddr              (dfi_ahbs_haddr),
      .o_dfi_ahbs_hwrite             (dfi_ahbs_hwrite),
      .o_dfi_ahbs_hsel               (dfi_ahbs_hsel),
      .o_dfi_ahbs_hwdata             (dfi_ahbs_hwdata),
      .o_dfi_ahbs_htrans             (dfi_ahbs_htrans),
      .o_dfi_ahbs_hsize              (dfi_ahbs_hsize),
      .o_dfi_ahbs_hburst             (dfi_ahbs_hburst),
      .o_dfi_ahbs_hreadyin           (dfi_ahbs_hreadyin),
      .i_dfi_ahbs_hready             ('0),
      .i_dfi_ahbs_hrdata             ('0),
      .i_dfi_ahbs_hresp              ('0),

      .o_ch0_dq0_ahbs_haddr          (ch0_dq0_ahbs_haddr),
      .o_ch0_dq0_ahbs_hwrite         (ch0_dq0_ahbs_hwrite),
      .o_ch0_dq0_ahbs_hsel           (ch0_dq0_ahbs_hsel),
      .o_ch0_dq0_ahbs_hwdata         (ch0_dq0_ahbs_hwdata),
      .o_ch0_dq0_ahbs_htrans         (ch0_dq0_ahbs_htrans),
      .o_ch0_dq0_ahbs_hsize          (ch0_dq0_ahbs_hsize),
      .o_ch0_dq0_ahbs_hburst         (ch0_dq0_ahbs_hburst),
      .o_ch0_dq0_ahbs_hreadyin       (ch0_dq0_ahbs_hreadyin),
      .i_ch0_dq0_ahbs_hready         (ch0_dq0_ahbs_hready),
      .i_ch0_dq0_ahbs_hrdata         (ch0_dq0_ahbs_hrdata),
      .i_ch0_dq0_ahbs_hresp          (ch0_dq0_ahbs_hresp),

      .o_ch0_dq1_ahbs_haddr          (ch0_dq1_ahbs_haddr),
      .o_ch0_dq1_ahbs_hwrite         (ch0_dq1_ahbs_hwrite),
      .o_ch0_dq1_ahbs_hsel           (ch0_dq1_ahbs_hsel),
      .o_ch0_dq1_ahbs_hwdata         (ch0_dq1_ahbs_hwdata),
      .o_ch0_dq1_ahbs_htrans         (ch0_dq1_ahbs_htrans),
      .o_ch0_dq1_ahbs_hsize          (ch0_dq1_ahbs_hsize),
      .o_ch0_dq1_ahbs_hburst         (ch0_dq1_ahbs_hburst),
      .o_ch0_dq1_ahbs_hreadyin       (ch0_dq1_ahbs_hreadyin),
      .i_ch0_dq1_ahbs_hready         (ch0_dq1_ahbs_hready),
      .i_ch0_dq1_ahbs_hrdata         (ch0_dq1_ahbs_hrdata),
      .i_ch0_dq1_ahbs_hresp          (ch0_dq1_ahbs_hresp),

      .o_ch0_ca_ahbs_haddr           (ch0_ca_ahbs_haddr),
      .o_ch0_ca_ahbs_hwrite          (ch0_ca_ahbs_hwrite),
      .o_ch0_ca_ahbs_hsel            (ch0_ca_ahbs_hsel),
      .o_ch0_ca_ahbs_hwdata          (ch0_ca_ahbs_hwdata),
      .o_ch0_ca_ahbs_htrans          (ch0_ca_ahbs_htrans),
      .o_ch0_ca_ahbs_hsize           (ch0_ca_ahbs_hsize),
      .o_ch0_ca_ahbs_hburst          (ch0_ca_ahbs_hburst),
      .o_ch0_ca_ahbs_hreadyin        (ch0_ca_ahbs_hreadyin),
      .i_ch0_ca_ahbs_hready          (ch0_ca_ahbs_hready),
      .i_ch0_ca_ahbs_hrdata          (ch0_ca_ahbs_hrdata),
      .i_ch0_ca_ahbs_hresp           (ch0_ca_ahbs_hresp),

      .o_ch1_dq0_ahbs_haddr          (ch1_dq0_ahbs_haddr),
      .o_ch1_dq0_ahbs_hwrite         (ch1_dq0_ahbs_hwrite),
      .o_ch1_dq0_ahbs_hsel           (ch1_dq0_ahbs_hsel),
      .o_ch1_dq0_ahbs_hwdata         (ch1_dq0_ahbs_hwdata),
      .o_ch1_dq0_ahbs_htrans         (ch1_dq0_ahbs_htrans),
      .o_ch1_dq0_ahbs_hsize          (ch1_dq0_ahbs_hsize),
      .o_ch1_dq0_ahbs_hburst         (ch1_dq0_ahbs_hburst),
      .o_ch1_dq0_ahbs_hreadyin       (ch1_dq0_ahbs_hreadyin),
      .i_ch1_dq0_ahbs_hready         (ch1_dq0_ahbs_hready),
      .i_ch1_dq0_ahbs_hrdata         (ch1_dq0_ahbs_hrdata),
      .i_ch1_dq0_ahbs_hresp          (ch1_dq0_ahbs_hresp),

      .o_ch1_dq1_ahbs_haddr          (ch1_dq1_ahbs_haddr),
      .o_ch1_dq1_ahbs_hwrite         (ch1_dq1_ahbs_hwrite),
      .o_ch1_dq1_ahbs_hsel           (ch1_dq1_ahbs_hsel),
      .o_ch1_dq1_ahbs_hwdata         (ch1_dq1_ahbs_hwdata),
      .o_ch1_dq1_ahbs_htrans         (ch1_dq1_ahbs_htrans),
      .o_ch1_dq1_ahbs_hsize          (ch1_dq1_ahbs_hsize),
      .o_ch1_dq1_ahbs_hburst         (ch1_dq1_ahbs_hburst),
      .o_ch1_dq1_ahbs_hreadyin       (ch1_dq1_ahbs_hreadyin),
      .i_ch1_dq1_ahbs_hready         (ch1_dq1_ahbs_hready),
      .i_ch1_dq1_ahbs_hrdata         (ch1_dq1_ahbs_hrdata),
      .i_ch1_dq1_ahbs_hresp          (ch1_dq1_ahbs_hresp),
      .o_ch1_ca_ahbs_haddr           (ch1_ca_ahbs_haddr),
      .o_ch1_ca_ahbs_hwrite          (ch1_ca_ahbs_hwrite),
      .o_ch1_ca_ahbs_hsel            (ch1_ca_ahbs_hsel),
      .o_ch1_ca_ahbs_hwdata          (ch1_ca_ahbs_hwdata),
      .o_ch1_ca_ahbs_htrans          (ch1_ca_ahbs_htrans),
      .o_ch1_ca_ahbs_hsize           (ch1_ca_ahbs_hsize),
      .o_ch1_ca_ahbs_hburst          (ch1_ca_ahbs_hburst),
      .o_ch1_ca_ahbs_hreadyin        (ch1_ca_ahbs_hreadyin),
      .i_ch1_ca_ahbs_hready          (ch1_ca_ahbs_hready),
      .i_ch1_ca_ahbs_hrdata          (ch1_ca_ahbs_hrdata),
      .i_ch1_ca_ahbs_hresp           (ch1_ca_ahbs_hresp),

      .o_ctrl_ahbs_haddr             (),
      .o_ctrl_ahbs_hwrite            (),
      .o_ctrl_ahbs_hsel              (),
      .o_ctrl_ahbs_hwdata            (),
      .o_ctrl_ahbs_htrans            (),
      .o_ctrl_ahbs_hsize             (),
      .o_ctrl_ahbs_hburst            (),
      .o_ctrl_ahbs_hreadyin          (),
      .i_ctrl_ahbs_hready            ('0),
      .i_ctrl_ahbs_hrdata            ('0),
      .i_ctrl_ahbs_hresp             ('0)
   );

logic rx_fifo_write;

//tx channel   
    ddr_phy_ch #(
      .AHB_AWIDTH                    (32),
      .NUM_DQ                        (2),
      .NUM_RDPH                      (4),
      .NUM_RPH                       (8),
      .NUM_WDPH                      (4),
      .NUM_WPH                       (8),
      .DQ_WIDTH                      (9),
      .DQS_WIDTH                     (9),
      .CA_WIDTH                      (8),
      .CK_WIDTH                      (9),
      .FEEDTHR_DQS_WIDTH             (0),
      .FEEDTHR_CK_WIDTH              (8),
      .TXRX_DQS_WIDTH                (2),
      .TXRX_CK_WIDTH                 (1),
      .DFIRDCLKEN_PEXTWIDTH          (4)
   ) u_phy_ch0_tx_D0 (

      .i_rst                         (rst),
      .i_pll_clk_0                   (pll_clk),
      .i_pll_clk_90                  (pll_clk_90),
      .i_pll_clk_180                 (pll_clk_180),
      .i_pll_clk_270                 (pll_clk_270),

      .o_phy_clk                     (clk),
      .o_dfiwr_clk_1                 (),
      .o_dfiwr_clk_2                 (),
      .o_dfird_clk_1                 (),
      .o_dfird_clk_2                 (),
      .i_sdr_valid_sel               (1'b1),
      .i_rclk_sel                    (1'b1),
      .i_ucie_rdqs_sel               (1'b1),
      .i_rxfifo_write                ('d0),
      .i_dqs_dfi_wrtraffic           ('d1),
      .i_dq_dfi_wrtraffic            ('d1),
      .i_ck_dfi_traffic              ('d1),
      .i_ca_dfi_traffic              ('d1),
      .i_dfiwrgb_mode                (9'b000100000),
      .i_dfirdgb_mode                (9'b000100000),
      .i_dfirdclk_en_pulse_ext       ('d0),
      .i_dfirdclk_en_ovr_sel         ('d0),
      .i_dfirdclk_en_ovr             ('d0),
      .i_csp_div_rst_n               (csp_rst_n),
      .i_csp_pi_en                   (csp_rst_n),

      // Mode Select
      .i_msr                         ('d0),

      // Analog
      .ana_vref_in                   (0),

      // TEST
      .i_scan_clk                    ('d0),
      .i_scan_mode                   ('d0),
      .i_scan_en                     ('d0),
      .i_scan_freq_en                ('d0),
      .i_scan_cgc_ctrl               ('d0),
      .i_scan_rst_ctrl               ('d0),
      .i_freeze_n                    ('1),
      .i_freeze_n_hv                 ('1),
      .i_hiz_n                       ('1),
      .o_tst_clk                     (),

      // JTAG Interface
      .i_jtag_tck                    ('d0),
      .i_jtag_trst_n                 ('d0),
      .i_jtag_bsr_mode               ('d0),
      .i_jtag_shift                  ('d0),
      .i_jtag_capture                ('d0),
      .i_jtag_update                 ('d0),
      .i_jtag_tdi                    ('d0),
      .o_jtag_tdo                    (),

      // AHB Interface
      .i_ahb_clk                     (ahb_clk),
      .i_ahb_rst                     (rst),
      .i_dq0_ahb_haddr               (ch0_dq0_ahbs_haddr),
      .i_dq0_ahb_hwrite              (ch0_dq0_ahbs_hwrite),
      .i_dq0_ahb_hsel                (ch0_dq0_ahbs_hsel),
      .i_dq0_ahb_hwdata              (ch0_dq0_ahbs_hwdata),
      .i_dq0_ahb_htrans              (ch0_dq0_ahbs_htrans),
      .i_dq0_ahb_hsize               (ch0_dq0_ahbs_hsize),
      .i_dq0_ahb_hburst              (ch0_dq0_ahbs_hburst),
      .i_dq0_ahb_hreadyin            (ch0_dq0_ahbs_hreadyin),
      .o_dq0_ahb_hready              (ch0_dq0_ahbs_hready),
      .o_dq0_ahb_hrdata              (ch0_dq0_ahbs_hrdata),
      .o_dq0_ahb_hresp               (ch0_dq0_ahbs_hresp),
      .i_dq1_ahb_haddr               (ch0_dq1_ahbs_haddr),
      .i_dq1_ahb_hwrite              (ch0_dq1_ahbs_hwrite),
      .i_dq1_ahb_hsel                (ch0_dq1_ahbs_hsel),
      .i_dq1_ahb_hwdata              (ch0_dq1_ahbs_hwdata),
      .i_dq1_ahb_htrans              (ch0_dq1_ahbs_htrans),
      .i_dq1_ahb_hsize               (ch0_dq1_ahbs_hsize),
      .i_dq1_ahb_hburst              (ch0_dq1_ahbs_hburst),
      .i_dq1_ahb_hreadyin            (ch0_dq1_ahbs_hreadyin),
      .o_dq1_ahb_hready              (ch0_dq1_ahbs_hready),
      .o_dq1_ahb_hrdata              (ch0_dq1_ahbs_hrdata),
      .o_dq1_ahb_hresp               (ch0_dq1_ahbs_hresp),

      .i_ca_ahb_haddr                (ch0_ca_ahbs_haddr),
      .i_ca_ahb_hwrite               (ch0_ca_ahbs_hwrite),
      .i_ca_ahb_hsel                 (ch0_ca_ahbs_hsel),
      .i_ca_ahb_hwdata               (ch0_ca_ahbs_hwdata),
      .i_ca_ahb_htrans               (ch0_ca_ahbs_htrans),
      .i_ca_ahb_hsize                (ch0_ca_ahbs_hsize),
      .i_ca_ahb_hburst               (ch0_ca_ahbs_hburst),
      .i_ca_ahb_hreadyin             (ch0_ca_ahbs_hreadyin),
      .o_ca_ahb_hready               (ch0_ca_ahbs_hready),
      .o_ca_ahb_hrdata               (ch0_ca_ahbs_hrdata),
      .o_ca_ahb_hresp                (ch0_ca_ahbs_hresp),

      .o_dq_rxfifo_empty_n           (),
      .i_dq_rxfifo_empty_n           ('1),

      .i_dq0_sdr                     (D0_ch0_tx_dq0_sdr),
      .o_dq0_sdr                     (D0_ch0_rx_dq0_sdr),
      .o_dq0_sdr_vld                 (D0_ch0_rx_dq0_sdr_vld),
      .i_dqs0_sdr                    (D0_ch0_tx_dqs0_sdr),
      .i_dq1_sdr                     (D0_ch0_tx_dq1_sdr),
      .o_dq1_sdr                     (D0_ch0_rx_dq1_sdr),
      .o_dq1_sdr_vld                 (D0_ch0_rx_dq1_sdr_vld),
      .i_dqs1_sdr                    (D0_ch0_tx_dqs1_sdr),

      .i_ca_sdr                      (D0_ch0_tx_ca_sdr),
      .o_ca_sdr                      (D0_ch0_rx_ca_sdr),
      .o_ca_sdr_vld                  (D0_ch0_rx_ca_sdr_vld),
      .i_ck_sdr                      (D0_ch0_tx_ck_sdr),

      .pad_ck_t                      (pad_D0_ck_t),
      .pad_ck_c                      (pad_D0_ck_c),
      .pad_ca                        (pad_D0_ca),
      .pad_wck_t                     (),
      .pad_wck_c                     (),
      .pad_dqs_t                     (pad_D0_dqs_t),
      .pad_dqs_c                     (pad_D0_dqs_c),
      .pad_dq                        (pad_D0_dq)

   );
   

//rx channel
     
    ddr_phy_ch #(
      .AHB_AWIDTH                    (32),
      .NUM_DQ                        (2),
      .NUM_RDPH                      (4),
      .NUM_RPH                       (8),
      .NUM_WDPH                      (4),
      .NUM_WPH                       (8),
      .DQ_WIDTH                      (9),
      .DQS_WIDTH                     (9),
      .CA_WIDTH                      (8),
      .CK_WIDTH                      (9),
      .FEEDTHR_DQS_WIDTH             (0),
      .FEEDTHR_CK_WIDTH              (8),
      .TXRX_DQS_WIDTH                (2),
      .TXRX_CK_WIDTH                 (1),
      .DFIRDCLKEN_PEXTWIDTH          (4)
    ) u_phy_ch0_rx_D1 (

      .i_rst                         (rst),
      .i_pll_clk_0                   (pll_clk),
      .i_pll_clk_90                  (pll_clk_90),
      .i_pll_clk_180                 (pll_clk_180),
      .i_pll_clk_270                 (pll_clk_270),

      .o_phy_clk                     (),
      .o_dfiwr_clk_1                 (),
      .o_dfiwr_clk_2                 (),
      .o_dfird_clk_1                 (),
      .o_dfird_clk_2                 (),
      .i_sdr_valid_sel               (1'b1),
      .i_rclk_sel                    (1'b1),
      .i_ucie_rdqs_sel               (1'b1),
      .i_rxfifo_write                 (rx_fifo_write),
      .i_dqs_dfi_wrtraffic           ('d1),
      .i_dq_dfi_wrtraffic            ('d1),
      .i_ck_dfi_traffic              ('d1),
      .i_ca_dfi_traffic              ('d1),
      .i_dfiwrgb_mode                (9'b000100000),
      .i_dfirdgb_mode                (9'b000100000),
      .i_dfirdclk_en_pulse_ext       ('d0),
      .i_dfirdclk_en_ovr_sel         ('d0),
      .i_dfirdclk_en_ovr             ('d0),
      .i_csp_div_rst_n               (csp_rst_n),
      .i_csp_pi_en                   (csp_rst_n),

      // Mode Select
      .i_msr                         ('d0),

      // Analog
      .ana_vref_in                   (0),

      // TEST
      .i_scan_clk                    ('d0),
      .i_scan_mode                   ('d0),
      .i_scan_en                     ('d0),
      .i_scan_freq_en                ('d0),
      .i_scan_cgc_ctrl               ('d0),
      .i_scan_rst_ctrl               ('d0),
      .i_freeze_n                    ('1),
      .i_freeze_n_hv                 ('1),
      .i_hiz_n                       ('1),
      .o_tst_clk                     (),

      // JTAG Interface
      .i_jtag_tck                    ('d0),
      .i_jtag_trst_n                 ('d0),
      .i_jtag_bsr_mode               ('d0),
      .i_jtag_shift                  ('d0),
      .i_jtag_capture                ('d0),
      .i_jtag_update                 ('d0),
      .i_jtag_tdi                    ('d0),
      .o_jtag_tdo                    (),

      // AHB Interface
      .i_ahb_clk                     (ahb_clk),
      .i_ahb_rst                     (rst),
      .i_dq0_ahb_haddr               (ch1_dq0_ahbs_haddr),
      .i_dq0_ahb_hwrite              (ch1_dq0_ahbs_hwrite),
      .i_dq0_ahb_hsel                (ch1_dq0_ahbs_hsel),
      .i_dq0_ahb_hwdata              (ch1_dq0_ahbs_hwdata),
      .i_dq0_ahb_htrans              (ch1_dq0_ahbs_htrans),
      .i_dq0_ahb_hsize               (ch1_dq0_ahbs_hsize),
      .i_dq0_ahb_hburst              (ch1_dq0_ahbs_hburst),
      .i_dq0_ahb_hreadyin            (ch1_dq0_ahbs_hreadyin),
      .o_dq0_ahb_hready              (ch1_dq0_ahbs_hready),
      .o_dq0_ahb_hrdata              (ch1_dq0_ahbs_hrdata),
      .o_dq0_ahb_hresp               (ch1_dq0_ahbs_hresp),
      .i_dq1_ahb_haddr               (ch1_dq1_ahbs_haddr),
      .i_dq1_ahb_hwrite              (ch1_dq1_ahbs_hwrite),
      .i_dq1_ahb_hsel                (ch1_dq1_ahbs_hsel),
      .i_dq1_ahb_hwdata              (ch1_dq1_ahbs_hwdata),
      .i_dq1_ahb_htrans              (ch1_dq1_ahbs_htrans),
      .i_dq1_ahb_hsize               (ch1_dq1_ahbs_hsize),
      .i_dq1_ahb_hburst              (ch1_dq1_ahbs_hburst),
      .i_dq1_ahb_hreadyin            (ch1_dq1_ahbs_hreadyin),
      .o_dq1_ahb_hready              (ch1_dq1_ahbs_hready),
      .o_dq1_ahb_hrdata              (ch1_dq1_ahbs_hrdata),
      .o_dq1_ahb_hresp               (ch1_dq1_ahbs_hresp),

      .i_ca_ahb_haddr                (ch1_ca_ahbs_haddr),
      .i_ca_ahb_hwrite               (ch1_ca_ahbs_hwrite),
      .i_ca_ahb_hsel                 (ch1_ca_ahbs_hsel),
      .i_ca_ahb_hwdata               (ch1_ca_ahbs_hwdata),
      .i_ca_ahb_htrans               (ch1_ca_ahbs_htrans),
      .i_ca_ahb_hsize                (ch1_ca_ahbs_hsize),
      .i_ca_ahb_hburst               (ch1_ca_ahbs_hburst),
      .i_ca_ahb_hreadyin             (ch1_ca_ahbs_hreadyin),
      .o_ca_ahb_hready               (ch1_ca_ahbs_hready),
      .o_ca_ahb_hrdata               (ch1_ca_ahbs_hrdata),
      .o_ca_ahb_hresp                (ch1_ca_ahbs_hresp),

      .o_dq_rxfifo_empty_n           (),
      .i_dq_rxfifo_empty_n           ('1),

      .i_dq0_sdr                     (D1_ch0_tx_dq0_sdr),
      .o_dq0_sdr                     (D1_ch0_rx_dq0_sdr),
      .o_dq0_sdr_vld                 (D1_ch0_rx_dq0_sdr_vld),
      .i_dqs0_sdr                    (D1_ch0_tx_dqs0_sdr),
      .i_dq1_sdr                     (D1_ch0_tx_dq1_sdr),
      .o_dq1_sdr                     (D1_ch0_rx_dq1_sdr),
      .o_dq1_sdr_vld                 (D1_ch0_rx_dq1_sdr_vld),
      .i_dqs1_sdr                    (D1_ch0_tx_dqs1_sdr),

      .i_ca_sdr                      (D1_ch0_tx_ca_sdr),
      .o_ca_sdr                      (D1_ch0_rx_ca_sdr),
      .o_ca_sdr_vld                  (D1_ch0_rx_ca_sdr_vld),
      .i_ck_sdr                      (D1_ch0_tx_ck_sdr),
        
      .pad_ck_t                      (pad_D1_ck_t),
      .pad_ck_c                      (pad_D1_ck_c),
      .pad_ca                        (pad_D1_ca),
      .pad_wck_t                     (),
      .pad_wck_c                     (),
      .pad_dqs_t                     (pad_D1_dqs_t),
      .pad_dqs_c                     (pad_D1_dqs_c),
      .pad_dq                        (pad_D1_dq)
        
   );
   
    
    logic [2:0] lt_mode;
    // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    logic [3:0] txrx_mode;
    logic ucie_fifo_clr;
rdi_mb_interface rdi_mb_if(clk,rst);

ucie_channel_adapter u_ucie_channel_adapter (
    //clk,rst
    .fwd_clk               (clk),
    .clk                   (clk),
    .rst                   (rst),
    //RDI mainband
    .lp_data               (rdi_mb_if.lp_data),
    .lp_valid              (rdi_mb_if.lp_valid),
    .lp_irdy               (rdi_mb_if.lp_irdy),
    .pl_trdy               (rdi_mb_if.pl_trdy),
    .pl_data               (rdi_mb_if.pl_data),
    .pl_valid              (rdi_mb_if.pl_valid),
    //RDI sideband
    .lp_cfg                (),
    .lp_cfg_vld            (),
    .lp_cfg_crd            (),
    .pl_cfg                (),
    .pl_cfg_vld            (),
    .pl_cfg_crd            (),
    //SDR interface channel-0
    .ch0_tx_dq0_sdr        (D0_ch0_tx_dq0_sdr),
    .ch0_rx_dq0_sdr        (D0_ch0_rx_dq0_sdr),
    .ch0_rx_dq0_sdr_vld    (D0_ch0_rx_dq0_sdr_vld),
    .ch0_tx_dqs0_sdr       (D0_ch0_tx_dqs0_sdr),
    .ch0_tx_dq1_sdr        (D0_ch0_tx_dq1_sdr),
    .ch0_rx_dq1_sdr        (D0_ch0_rx_dq1_sdr),
    .ch0_rx_dq1_sdr_vld    (D0_ch0_rx_dq1_sdr_vld),
    .ch0_tx_dqs1_sdr       (D0_ch0_tx_dqs1_sdr),
    .ch0_tx_ca_sdr         (D0_ch0_tx_ca_sdr),
    .ch0_rx_ca_sdr         (D0_ch0_rx_ca_sdr),
    .ch0_rx_ca_sdr_vld     (D0_ch0_rx_ca_sdr_vld),
    .ch0_tx_ck_sdr         (D0_ch0_tx_ck_sdr),
    //SDR interface channel-1
    .ch1_tx_dq0_sdr        (D1_ch0_tx_dq0_sdr),
    .ch1_rx_dq0_sdr        (D1_ch0_rx_dq0_sdr),
    .ch1_rx_dq0_sdr_vld    (D1_ch0_rx_dq0_sdr_vld),
    .ch1_tx_dqs0_sdr       (D1_ch0_tx_dqs0_sdr),
    .ch1_tx_dq1_sdr        (D1_ch0_tx_dq1_sdr),
    .ch1_rx_dq1_sdr        (D1_ch0_rx_dq1_sdr),
    .ch1_rx_dq1_sdr_vld    (D1_ch0_rx_dq1_sdr_vld),
    .ch1_tx_dqs1_sdr       (D1_ch0_tx_dqs1_sdr),
    .ch1_tx_ca_sdr         (D1_ch0_tx_ca_sdr),
    .ch1_rx_ca_sdr         (D1_ch0_rx_ca_sdr),
    .ch1_rx_ca_sdr_vld     (D1_ch0_rx_ca_sdr_vld),
    .ch1_tx_ck_sdr         (D1_ch0_tx_ck_sdr),
    //CSR
    .i_rxfifo_clr          (ucie_fifo_clr),
    .lt_mode               (lt_mode),
    // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    .txrx_mode             (txrx_mode)
);



    /*
    logic tx_on;
    always_comb begin
        if(tx_on) begin
            D0_ch0_tx_dq0_sdr=72'h123456789987654321;
            D0_ch0_tx_dq1_sdr=72'h123456789987654321;
            D0_ch0_tx_ca_sdr=64'h1234567887654321;
        end else begin
            D0_ch0_tx_dq0_sdr='d0;
            D0_ch0_tx_dq1_sdr='d0;
            D0_ch0_tx_ca_sdr='d0;
        end
    end
    */
    logic training_done;

    always #half_clk_cycle pll_clk=~pll_clk;
    always #2 ahb_clk=~ahb_clk;

    initial begin 
        $vcdpluson(0,ucie_channel_adapter_tb);
        run_for_n_pkts=100;
        ucie_fifo_clr<=1'b1;
        rdi_mb_if.lp_data  <= '0;
        rdi_mb_if.lp_valid  <= '0;
        rdi_mb_if.lp_irdy  <= '0;
        rx_fifo_write<='0;
        training_done<='0;
        ahb_if_hsel <='0;
        ahb_if_hreadyin <='0;
        ahb_if_hwdata  <= '0;
        ahb_if_haddr  <= '0;
        ahb_if_hwrite  <='0;
        ahb_if_htrans  <='0;
        ahb_if_hsize   <='0;
        ahb_if_hburst  <='0;
        ahb_clk<=1'b0;
        lt_mode<=1'b0;
        pll_clk<=1'b0;
        rst<=1'b1;
        csp_rst_n<=1'b0;
        txrx_mode<='d0;
        #20;
        rst<=1'b0;
        #100;
        txrx_mode<=4'b0110;
        #100;
        csp_rst_n<=1'b1;
        #100;
        link_initialize();
        #10;
        csp_rst_n<=1'b0;
        #102.5;
        csp_rst_n<=1'b1;
        #10;
        link_training();
        #10;
        training_done<=1'b1;
        ucie_fifo_clr<=1'b0;
        //begin txrx test
        wait_xfer_ready();
        $display ("[%t] #########  All Training Done #############", $time);
        fork
	        data_xmit();
	        data_rcv();
	    join
        $display ("[%t] #########  All Tasks are finished normally #############", $time);
        //end txrx test
        #100;
        Finish();
    end



//ahb write
    logic [31:0]         queue_ahb_haddr  [$] ;
    logic [31:0]         queue_ahb_hwdata  [$] ;

    always @(posedge ahb_clk)
        if (queue_ahb_haddr.size())
            begin
                ahb_if_hwdata  <= '0;
                ahb_if_haddr  <= queue_ahb_haddr.pop_front();
                ahb_if_hwrite  <= 1'b1;
                ahb_if_hsel  <= 1'b1;
                ahb_if_htrans  <= 2'b10;
                ahb_if_hsize   <= 3'b001;
                ahb_if_hburst  <= 3'b000;
                @(negedge ahb_clk);
                while ((ahb_if_hready|ahb_if_hreadyin)== 1'b0) @(negedge ahb_clk);
                @(posedge ahb_clk);
                ahb_if_hwdata  <= queue_ahb_hwdata.pop_front();
                ahb_if_haddr  <= '0;
                ahb_if_hwrite  <='0;
                ahb_if_hsel  <= 1'b1;
                ahb_if_htrans  <='0;
                ahb_if_hsize   <='0;
                ahb_if_hburst  <='0;
                @(negedge ahb_clk);
                while ((ahb_if_hready|ahb_if_hreadyin)== 1'b0) @(negedge ahb_clk);
                @(posedge ahb_clk);
                ahb_if_hwdata  <= '0;
                ahb_if_haddr  <= '0;
                ahb_if_hwrite  <='0;
                ahb_if_hsel  <= '0;
                ahb_if_htrans  <='0;
                ahb_if_hsize   <='0;
                ahb_if_hburst  <='0;
            end
        else
            begin
                ahb_if_hwdata  <= '0;
                ahb_if_haddr  <= '0;
                ahb_if_hwrite  <='0;
                ahb_if_hsel  <= '0;
                ahb_if_htrans  <='0;
                ahb_if_hsize   <='0;
                ahb_if_hburst  <='0;
            end
task ahb_write;
    input [31:0] address;
    input [31:0] data;
    queue_ahb_haddr.push_back(address);
    queue_ahb_hwdata.push_back(data);
endtask

task ahb_write_all_lane;
    input [31:0] address;
    input [31:0] data;
    queue_ahb_haddr.push_back(address);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+4);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+8);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+12);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+16);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+20);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+24);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+28);
    queue_ahb_hwdata.push_back(data);
    queue_ahb_haddr.push_back(address+32);
    queue_ahb_hwdata.push_back(data);
endtask

task wait_until_empty;

integer wait_timeout;

begin
  wait_timeout = 5_000;

  fork
    begin
      wait (
             // Initiators
             (queue_ahb_haddr.size  () == 0) &&
             (queue_ahb_hwdata.size   () == 0) );

    end

    begin
      @(posedge ahb_clk);
      while (wait_timeout > 0)
      begin
        wait_timeout = wait_timeout - 1;
        @(posedge ahb_clk);
      end
    end
  join_any

  if (wait_timeout <= 0)
  begin
    $display ("ERROR Timeout waiting for quiescence at time %t", $time);
    $display ("   queue_ahb_haddr.size  () = %d", queue_ahb_haddr.size  () );
    $display ("   queue_ahb_hwdata.size  () = %d", queue_ahb_hwdata.size  () );
    $finish();
  end

end
endtask

task wait_xfer_ready();
    wait (ucie_channel_adapter_tb.training_done);
endtask

task data_xmit ();
	static int pkts_gen = 0;
	bit [383:0] data = 0;
    int n_idles=0;
	
    while (pkts_gen < run_for_n_pkts) begin
        n_idles=$random%4;
        for(int i=1;i<48;i++) begin
	        data[i*8+:8] = $random;
        end
        data[7:0]=8'b11110000;
	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);       
	    @(negedge ucie_channel_adapter_tb.clk);
	    ucie_channel_adapter_tb.rdi_mb_if.lp_data  <= data;
        ucie_channel_adapter_tb.rdi_mb_if.lp_valid  <= 1'b1;
        ucie_channel_adapter_tb.rdi_mb_if.lp_irdy  <= 1'b1;
        @(posedge ucie_channel_adapter_tb.clk);
        while (ucie_channel_adapter_tb.rdi_mb_if.pl_trdy != 1'b1) @(posedge ucie_channel_adapter_tb.clk);
        repeat(n_idles) rdi_mb_idle();
        xmit_q.push_back(data);
        pkts_gen++;
    end
    rdi_mb_idle();
endtask

task rdi_mb_idle();
    @(negedge ucie_channel_adapter_tb.clk);
    ucie_channel_adapter_tb.rdi_mb_if.lp_data  <= '0;
    ucie_channel_adapter_tb.rdi_mb_if.lp_valid  <= '0;
    ucie_channel_adapter_tb.rdi_mb_if.lp_irdy  <= '0;
endtask

//*************************************************
// task to check data received on TX side
//*************************************************
task data_rcv ();
    bit [383:0] data_exp = 0;
    static int pkts_rcvd = 0;
    integer wait_timeout=5_000;
    begin
    fork
        begin
        @(posedge ucie_channel_adapter_tb.clk);
        while (wait_timeout > 0)
            begin
                wait_timeout = wait_timeout - 1;
                @(posedge ucie_channel_adapter_tb.clk);
            end
        end

        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge ucie_channel_adapter_tb.clk);
                if (ucie_channel_adapter_tb.rdi_mb_if.pl_valid===1'b1) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, ucie_channel_adapter_tb.rdi_mb_if.pl_data);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if (ucie_channel_adapter_tb.rdi_mb_if.pl_data != data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, ucie_channel_adapter_tb.rdi_mb_if.pl_data, data_exp);
                    end   
                end
            end
            if (xmit_q.size() != 0) //check if all the data are received
            $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q.size());    
        end
    join_any

    if (wait_timeout <= 0)
    begin
        $display ("ERROR Timeout waiting for rdi data at time %t", $time);
        $display (" size of data waiting to be received = %d", xmit_q.size  () );
        $finish();
    end

    end
endtask // mstr_req_rcv

//---------------------------------------------------------------
    // Finish

task Finish ();
begin
	$display("%0t: %m: finishing simulation..", $time);
	repeat (100) @(posedge ucie_channel_adapter_tb.clk);
	$display("\n////////////////////////////////////////////////////////////////////////////");
	$display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	$display("////////////////////////////////////////////////////////////////////////////\n");
    if (err_count == 0) begin
        $display("+++++++++++++++++++++++++++++++++\n");
        $display("TEST PASSED!!!!!!!!!!!\n");
        $display("+++++++++++++++++++++++++++++++++\n");
    end
	$finish;
end
endtask

task link_initialize();
    begin
        //enable all TX PI__CH0_DQ0
        ahb_write(32'h000F0290,32'h00004040);
        ahb_write(32'h000F02B0,32'h00004040);
        ahb_write(32'h000F02D0,32'h00004040);
        ahb_write(32'h000F0920,32'h00004040);
        ahb_write(32'h000F0940,32'h00004040);
        ahb_write(32'h000F0960,32'h00004040);
        ahb_write(32'h000F0970,32'h00004040);
        ahb_write(32'h000F0980,32'h00004040);

        ahb_write(32'h000F0294,32'h00004040);
        ahb_write(32'h000F02B4,32'h00004040);
        ahb_write(32'h000F02D4,32'h00004040);
        ahb_write(32'h000F0924,32'h00004040);
        ahb_write(32'h000F0944,32'h00004040);
        ahb_write(32'h000F0964,32'h00004040);
        ahb_write(32'h000F0974,32'h00004040);
        ahb_write(32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        ahb_write(32'h00100290,32'h00004040);
        ahb_write(32'h001002B0,32'h00004040);
        ahb_write(32'h001002D0,32'h00004040);
        ahb_write(32'h00100920,32'h00004040);
        ahb_write(32'h00100940,32'h00004040);
        ahb_write(32'h00100960,32'h00004040);
        ahb_write(32'h00100970,32'h00004040);
        ahb_write(32'h00100980,32'h00004040);

        ahb_write(32'h00100294,32'h00004040);
        ahb_write(32'h001002B4,32'h00004040);
        ahb_write(32'h001002D4,32'h00004040);
        ahb_write(32'h00100924,32'h00004040);
        ahb_write(32'h00100944,32'h00004040);
        ahb_write(32'h00100964,32'h00004040);
        ahb_write(32'h00100974,32'h00004040);
        ahb_write(32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        ahb_write(32'h00110318,32'h00004040);
        ahb_write(32'h00110338,32'h00004040);
        ahb_write(32'h00110358,32'h00004040);
        ahb_write(32'h00110A18,32'h00004040);
        ahb_write(32'h00110A38,32'h00004040);
        ahb_write(32'h00110A58,32'h00004040); 
        ahb_write(32'h00110A68,32'h00004040);
        ahb_write(32'h00110A78,32'h00004040);

        ahb_write(32'h0011031C,32'h00004040);
        ahb_write(32'h0011033C,32'h00004040);
        ahb_write(32'h0011035C,32'h00004040);
        ahb_write(32'h00110A1C,32'h00004040);
        ahb_write(32'h00110A3C,32'h00004040);
        ahb_write(32'h00110A5C,32'h00004040); 
        ahb_write(32'h00110A6C,32'h00004040);
        ahb_write(32'h00110A7C,32'h00004040);
        wait_until_empty();
        #10;

        //enable all TX PI__CH1_DQ0
        ahb_write(32'h00120920,32'h00004040);
        ahb_write(32'h00120940,32'h00004040);
        ahb_write(32'h00120960,32'h00004040);
        ahb_write(32'h00120970,32'h00004040);
        ahb_write(32'h00120980,32'h00004040);

        ahb_write(32'h00120924,32'h00004040);
        ahb_write(32'h00120944,32'h00004040);
        ahb_write(32'h00120964,32'h00004040);
        ahb_write(32'h00120974,32'h00004040);
        ahb_write(32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        ahb_write(32'h00130920,32'h00004040);
        ahb_write(32'h00130940,32'h00004040);
        ahb_write(32'h00130960,32'h00004040);
        ahb_write(32'h00130970,32'h00004040);
        ahb_write(32'h00130980,32'h00004040);

        ahb_write(32'h00130924,32'h00004040);
        ahb_write(32'h00130944,32'h00004040);
        ahb_write(32'h00130964,32'h00004040);
        ahb_write(32'h00130974,32'h00004040);
        ahb_write(32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        ahb_write(32'h00140A18,32'h00004040);
        ahb_write(32'h00140A38,32'h00004040);
        ahb_write(32'h00140A58,32'h00004040); 
        ahb_write(32'h00140A68,32'h00004040);
        ahb_write(32'h00140A78,32'h00004040);

        ahb_write(32'h00140A1C,32'h00004040);
        ahb_write(32'h00140A3C,32'h00004040);
        ahb_write(32'h00140A5C,32'h00004040); 
        ahb_write(32'h00110A6C,32'h00004040);
        ahb_write(32'h00110A7C,32'h00004040);

        //enable all RX PI__CH1_DQ0
        ahb_write(32'h001207F4,32'h00004040);
        ahb_write(32'h001207D4,32'h00004040);
        ahb_write(32'h001207E4,32'h00004040);

        ahb_write(32'h001207F8,32'h00004040);
        ahb_write(32'h001207D8,32'h00004040);
        ahb_write(32'h001207E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        ahb_write(32'h001307F4,32'h00004040);
        ahb_write(32'h001307D4,32'h00004040);
        ahb_write(32'h001307E4,32'h00004040);

        ahb_write(32'h001307F8,32'h00004040);
        ahb_write(32'h001307D8,32'h00004040);
        ahb_write(32'h001307E8,32'h00004040);

        //enable all RX PI__CH1_CA
        ahb_write(32'h0014098C,32'h00004040);
        ahb_write(32'h0014096C,32'h00004040);
        ahb_write(32'h0014097C,32'h00004040);

        ahb_write(32'h00140990,32'h00004040);
        ahb_write(32'h00140970,32'h00004040);
        ahb_write(32'h00140980,32'h00004040);
        wait_until_empty();
    end
endtask

task link_training();
    begin
        //set TX QDR mode
        ahb_write_all_lane(32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        ahb_write_all_lane(32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        ahb_write_all_lane(32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        ahb_write_all_lane(32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        ahb_write_all_lane(32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        ahb_write(32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        ahb_write_all_lane(32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        ahb_write_all_lane(32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        ahb_write(32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        ahb_write_all_lane(32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        ahb_write_all_lane(32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        ahb_write_all_lane(32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        ahb_write(32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        ahb_write(32'h0012083C,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        ahb_write(32'h0013083C,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        ahb_write(32'h001409C4,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        ahb_write(32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        ahb_write(32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        ahb_write(32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        wait_until_empty();
        #10;
        //clr fifo
        ahb_write(32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        ahb_write(32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        ahb_write(32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        #10;
        //enable fifo
        ahb_write(32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        ahb_write(32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        ahb_write(32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        wait_until_empty();
        #100;
        rx_fifo_write<='1;
        #100;
        lt_mode<=3'b001; //send 01010101
        #100;
        //dq0/dq1/ca get 40404040
        //begin link rdqs training, rdqs delay tuning
        
        ahb_write(32'h00120820,32'h00005050); //Ch1_DQ0_DQS_RX_IO_M0_R1
        ahb_write(32'h00130820,32'h00005050); //Ch1_DQ1_DQS_RX_IO_M0_R1
        ahb_write(32'h00120824,32'h00005050); //Ch1_DQ0_DQS_RX_IO_M0_R1
        ahb_write(32'h00130824,32'h00005050); //Ch1_DQ1_DQS_RX_IO_M0_R1
        
        #100;
        //end rdqs training, still dq1 get 10101010   dq0/ca get 40404040
        //begin dq alignment training, 1 ddr fc delay 1 qdr cycle, qdr_pipe_en
        //DQ0 FC DLY (no need, just to show the influence)
        ahb_write_all_lane(32'h000F0434,32'h11111111); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        ahb_write_all_lane(32'h00100434,32'h11111111); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
         //CA FC DLY
        ahb_write_all_lane(32'h00110504,32'h11111111); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        wait_until_empty();
        #100;
        //now dq1/dq0/ca get 04040404
        //DQ0_DDR Pipe
        ahb_write_all_lane(32'h000F04C4,32'h0); //CH0_DQ0_DQ_TX_DDR_M0_R1_CFG_0-8
        //DQ1_DDR Pipe
        ahb_write_all_lane(32'h001004C4,32'h3); //CH0_DQ1_DQ_TX_DDR_M0_R1_CFG_0-8
        //CA_DDR Pipe
        ahb_write_all_lane(32'h001105B4,32'h3); //CH0_CA_DQ_TX_DDR_M0_R1_CFG_0-8
        //valid DDR Pipe
        ahb_write(32'h00110AC8,32'h3); //CH0_CA_DQS_TX_DDR_M0_R0_CFG_0
        ahb_write(32'h00110ACC,32'h3); //CH0_CA_DQS_TX_DDR_M0_R1_CFG_0
        //get 10101010
        wait_until_empty();
        #100;
        //DQ0 FC DLY (set to default)
        ahb_write_all_lane(32'h000F0434,32'h0); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //DQ1 FC_DLY
        ahb_write_all_lane(32'h00100434,32'h0); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

         //CA FC DLY
        ahb_write_all_lane(32'h00110504,32'h0); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        wait_until_empty();
        // output 01010101 end dq alignment training
        // begin dq0/dq1/ca channel alignment training
        #100;
        lt_mode<=3'b010;
        //ahb_write(32'h001207C8,32'h00000300); //Ch1_DQ0_DQS_RX_SDR_LPDE_M0_RO_CFG/ Prog Dly Cfg
        //ahb_write(32'h001307C8,32'h00000300); 
        //ahb_write(32'h001407C8,32'h00000300);
        #200;
        lt_mode<=3'b000;
        #200;
    end
endtask

endmodule