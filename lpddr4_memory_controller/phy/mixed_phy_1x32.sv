`include "ddr_global_define.vh"
`include "ddr_project_define.vh"
`include "ddr_cmn_csr_defs.vh"
`include "ddr_cmn_wrapper_define.vh"
`include "ddr_ctrl_csr_defs.vh"

module mixed_phy #(
   parameter [0:0]       SECONDARY_PHY     = '0,                                              // Secondary PHY configuration (no CMN, no MCU)
   parameter             NUM_CH            =  2,                                // Number of PHY channels.
   parameter             NUM_DQ            =  2,                             // Number of DQ lanes per PHY channel.
   parameter             NUM_DFI_CH        =  1,                                // Number of DFI channels
   parameter             NUM_DFI_DQ        =  4,                                // Number of DQ lanes per DFI channel.
   parameter             AHB_AWIDTH        =  32,                                             // AHB Address width
   parameter             AHB_DWIDTH        =  32,                                             // AHB Data width
   parameter             SWIDTH            =  8,                                              // PHY Slice Width
   parameter             DWIDTH            =  SWIDTH * 2,                                     // Data Width R+F
   parameter             BWIDTH            =  SWIDTH / 8,                                     // BYTE Width
   parameter             MWIDTH            =  BWIDTH ,                                        // Mask width for single phase.
   parameter             TWIDTH            =  BWIDTH * 2,                                     // WCK Toggle width
   parameter             ERRWIDTH          =  BWIDTH * 4,                                     // Error Info Width
   parameter             AWIDTH            =  6,                            // Cmd/Address bus width
   parameter             NUM_RDPH          =  4,                      // Read datapath data phases (includes R/F)
   parameter             NUM_RPH           =  8,                       // Read fifo data phases (includes R/F)
   parameter             NUM_WDPH          =  4,                       // Write datapath data phases (includes R/F)
   parameter             NUM_WPH           =  8,                       // Write gearbox data phases (includes R/F)
   parameter             DQ_WIDTH          =  9,                             // DQ bus width
   parameter             DQ_WWIDTH         =  NUM_WPH * DQ_WIDTH,                             // DQ read data width
   parameter             DQ_RWIDTH         =  NUM_RPH * DQ_WIDTH,                             // DQ read data width
   parameter             DQS_WIDTH         =  9+0,// DQS bus width
   parameter             DQS_WWIDTH        =  NUM_WPH * DQS_WIDTH,                            // DQS read data width
   parameter             CA_WIDTH          =  8,                             // DQ bus width
   parameter             CA_WWIDTH         =  NUM_WPH * CA_WIDTH,                             // CA read data width
   parameter             CA_RWIDTH         =  NUM_RPH * CA_WIDTH,                             // CA read data width
   parameter             CK_WIDTH          =  1+8,  // DQS bus width
   parameter             CK_WWIDTH         =  NUM_WPH * CK_WIDTH,                             // CK read data width
   parameter             NUM_IRQ           =  `DDR_NUM_IRQ,                      // Max number of IRQ supported = 32
   parameter             TSWIDTH           =  16,                                             // Timestamp Width
   parameter             DFI_BUF_IG_DEPTH  =  32,                                             // DFI ingress buffer depth
   parameter             DFI_BUF_EG_DEPTH  =  32                                              // DFI egress buffer depth
) (

   // Reset
   input  logic                             i_phy_rst,

   // Clocks
   input  logic                             i_dfi_clk_on,
   output logic                             o_dfi_clk,
`ifdef DDR_ECO_ANA_REF_CLK
   input  logic                             i_ana_refclk,
`endif
   input  logic                             i_refclk,
   output logic                             o_refclk_on,
   input  logic                             i_refclk_alt,

   // Interrupts
   input  logic [3:0]                       i_irq,
   output logic [1:0]                       o_irq,


   // General Purpose Bus
   input  logic [7:0]                       i_gpb,
   output logic [7:0]                       o_gpb,

   // Channel clocks (from primary channel)
   input  logic                             i_pll_clk_0,
   input  logic                             i_pll_clk_90,
   input  logic                             i_pll_clk_180,
   input  logic                             i_pll_clk_270,
   input  logic                             i_vco0_clk,

   // Channel clocks (to secondary channel)
   output logic                             o_pll_clk_0,
   output logic                             o_pll_clk_90,
   output logic                             o_pll_clk_180,
   output logic                             o_pll_clk_270,
   output logic                             o_vco0_clk,

   // TEST
   input  logic                             i_scan_mode,
   input  logic                             i_scan_clk,
   input  logic                             i_scan_en,
   input  logic [7:0]                       i_scan_freq_en,
   input  logic                             i_scan_cgc_ctrl,
   input  logic                             i_scan_rst_ctrl,
   input  logic [15:0]                      i_scan,
   output logic [15:0]                      o_scan,

   input  logic                             i_freeze_n,
   input  logic                             i_hiz_n,
   input  logic                             i_iddq_mode,
   output logic                             o_dtst,

   // Power Collapse
   input  logic                             i_ret_en,             // IFR_FIXME - Connect to support power collapse.
   input  logic                             i_hs_en,              // IFR_FIXME - Connect to support power collapse.

   // JTAG Interface
   input  logic                             i_jtag_tck,
   input  logic                             i_jtag_trst_n,
   input  logic                             i_jtag_tms,
   input  logic                             i_jtag_tdi,
   output logic                             o_jtag_tdo,

   // AHB Interface
   input  logic                             i_ahb_clk,
   output logic                             o_ahb_clk_on,
   input  logic                             i_ahb_rst,
   input  logic                             i_ahb_csr_rst,

   // AHB Slave
   input  logic [AHB_AWIDTH-1:0]            i_ahb_haddr,
   input  logic                             i_ahb_hwrite,
   input  logic                             i_ahb_hsel,
   input  logic                             i_ahb_hreadyin,
   input  logic [31:0]                      i_ahb_hwdata,
   input  logic [1:0]                       i_ahb_htrans,
   input  logic [2:0]                       i_ahb_hsize,
   input  logic [2:0]                       i_ahb_hburst,
   output logic                             o_ahb_hready,
   output logic [31:0]                      o_ahb_hrdata,
   output logic [1:0]                       o_ahb_hresp,

   // AHB Master (to external Slave)
   output logic [31:0]                      o_ahb_haddr,
   output logic                             o_ahb_hwrite,
   output logic [31:0]                      o_ahb_hwdata,
   output logic [1:0]                       o_ahb_htrans,
   output logic [2:0]                       o_ahb_hsize,
   output logic [2:0]                       o_ahb_hburst,
   output logic                             o_ahb_hbusreq,
   input  logic                             i_ahb_hgrant,
   input  logic                             i_ahb_hready,
   input  logic [31:0]                      i_ahb_hrdata,
   input  logic [1:0]                       i_ahb_hresp,

   // Update
   output logic                             o_dfi_ctrlupd_ack,
   input  logic                             i_dfi_ctrlupd_req,
   input  logic                             i_dfi_phyupd_ack,
   output logic                             o_dfi_phyupd_req,
   output logic [1:0]                       o_dfi_phyupd_type,

   // Status
   input  logic [1:0]                       i_dfi_freq_fsp,
   input  logic [1:0]                       i_dfi_freq_ratio,
   input  logic [4:0]                       i_dfi_frequency,
   output logic                             o_dfi_init_complete,
   input  logic                             i_dfi_init_start,

   // PHY Master
   input  logic                             i_dfi_phymstr_ack,
   output logic [1:0]                       o_dfi_phymstr_cs_state,
   output logic                             o_dfi_phymstr_req,
   output logic                             o_dfi_phymstr_state_sel,
   output logic [1:0]                       o_dfi_phymstr_type,


   // Low Power Control
   output logic                             o_dfi_lp_ctrl_ack,
   input  logic                             i_dfi_lp_ctrl_req,
   input  logic [5:0]                       i_dfi_lp_ctrl_wakeup,
   output logic                             o_dfi_lp_data_ack,
   input  logic                             i_dfi_lp_data_req,
   input  logic [5:0]                       i_dfi_lp_data_wakeup,


   input  logic                             i_dfi_reset_n_p0,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p1,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p2,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p3,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p4,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p5,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p6,         // DDR/3/4/5 and LPDDR4/5
   input  logic                             i_dfi_reset_n_p7,         // DDR/3/4/5 and LPDDR4/5
  // Command
   input  logic [AWIDTH-1:0]                i_dfi_address_p0,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p1,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p2,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p3,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p4,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p5,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p6,         // For DDR4 bits[16:14] are not used
   input  logic [AWIDTH-1:0]                i_dfi_address_p7,         // For DDR4 bits[16:14] are not used
   input  logic [1:0]                       i_dfi_cke_p0,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p1,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p2,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p3,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p4,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p5,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p6,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cke_p7,             // DDR4 and LPDDR3/4
   input  logic [1:0]                       i_dfi_cs_p0,
   input  logic [1:0]                       i_dfi_cs_p1,
   input  logic [1:0]                       i_dfi_cs_p2,
   input  logic [1:0]                       i_dfi_cs_p3,
   input  logic [1:0]                       i_dfi_cs_p4,
   input  logic [1:0]                       i_dfi_cs_p5,
   input  logic [1:0]                       i_dfi_cs_p6,
   input  logic [1:0]                       i_dfi_cs_p7,
   input  logic                             i_dfi_dram_clk_disable_p0,
   input  logic                             i_dfi_dram_clk_disable_p1,
   input  logic                             i_dfi_dram_clk_disable_p2,
   input  logic                             i_dfi_dram_clk_disable_p3,
   input  logic                             i_dfi_dram_clk_disable_p4,
   input  logic                             i_dfi_dram_clk_disable_p5,
   input  logic                             i_dfi_dram_clk_disable_p6,
   input  logic                             i_dfi_dram_clk_disable_p7,

   // Write
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p0,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p1,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p2,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p3,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p4,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p5,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p6,
   input  logic [NUM_DFI_DQ*SWIDTH-1:0]     i_dfi_wrdata_p7,
   input  logic                             i_dfi_parity_in_p0,
   input  logic                             i_dfi_parity_in_p1,
   input  logic                             i_dfi_parity_in_p2,
   input  logic                             i_dfi_parity_in_p3,
   input  logic                             i_dfi_parity_in_p4,
   input  logic                             i_dfi_parity_in_p5,
   input  logic                             i_dfi_parity_in_p6,
   input  logic                             i_dfi_parity_in_p7,
   input  logic [1:0]                       i_dfi_wrdata_cs_p0,
   input  logic [1:0]                       i_dfi_wrdata_cs_p1,
   input  logic [1:0]                       i_dfi_wrdata_cs_p2,
   input  logic [1:0]                       i_dfi_wrdata_cs_p3,
   input  logic [1:0]                       i_dfi_wrdata_cs_p4,
   input  logic [1:0]                       i_dfi_wrdata_cs_p5,
   input  logic [1:0]                       i_dfi_wrdata_cs_p6,
   input  logic [1:0]                       i_dfi_wrdata_cs_p7,
   input  logic [1:0]                       i_dfi_wck_cs_p0,
   input  logic [1:0]                       i_dfi_wck_cs_p1,
   input  logic [1:0]                       i_dfi_wck_cs_p2,
   input  logic [1:0]                       i_dfi_wck_cs_p3,
   input  logic [1:0]                       i_dfi_wck_cs_p4,
   input  logic [1:0]                       i_dfi_wck_cs_p5,
   input  logic [1:0]                       i_dfi_wck_cs_p6,
   input  logic [1:0]                       i_dfi_wck_cs_p7,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p0,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p1,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p2,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p3,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p4,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p5,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p6,
   input  logic [NUM_DFI_DQ*MWIDTH-1:0]     i_dfi_wrdata_mask_p7,
   input  logic                             i_dfi_wrdata_en_p0,
   input  logic                             i_dfi_wrdata_en_p1,
   input  logic                             i_dfi_wrdata_en_p2,
   input  logic                             i_dfi_wrdata_en_p3,
   input  logic                             i_dfi_wrdata_en_p4,
   input  logic                             i_dfi_wrdata_en_p5,
   input  logic                             i_dfi_wrdata_en_p6,
   input  logic                             i_dfi_wrdata_en_p7,
   input  logic                             i_dfi_wck_en_p0,
   input  logic                             i_dfi_wck_en_p1,
   input  logic                             i_dfi_wck_en_p2,
   input  logic                             i_dfi_wck_en_p3,
   input  logic                             i_dfi_wck_en_p4,
   input  logic                             i_dfi_wck_en_p5,
   input  logic                             i_dfi_wck_en_p6,
   input  logic                             i_dfi_wck_en_p7,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p0,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p1,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p2,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p3,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p4,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p5,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p6,
   input  logic [TWIDTH-1:0]                i_dfi_wck_toggle_p7,

   // Read Data
   input  logic [1:0]                       i_dfi_rddata_cs_p0,
   input  logic [1:0]                       i_dfi_rddata_cs_p1,
   input  logic [1:0]                       i_dfi_rddata_cs_p2,
   input  logic [1:0]                       i_dfi_rddata_cs_p3,
   input  logic [1:0]                       i_dfi_rddata_cs_p4,
   input  logic [1:0]                       i_dfi_rddata_cs_p5,
   input  logic [1:0]                       i_dfi_rddata_cs_p6,
   input  logic [1:0]                       i_dfi_rddata_cs_p7,
   input  logic                             i_dfi_rddata_en_p0,
   input  logic                             i_dfi_rddata_en_p1,
   input  logic                             i_dfi_rddata_en_p2,
   input  logic                             i_dfi_rddata_en_p3,
   input  logic                             i_dfi_rddata_en_p4,
   input  logic                             i_dfi_rddata_en_p5,
   input  logic                             i_dfi_rddata_en_p6,
   input  logic                             i_dfi_rddata_en_p7,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w0,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w1,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w2,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w3,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w4,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w5,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w6,
   output logic [NUM_DFI_DQ*SWIDTH-1:0]     o_dfi_rddata_w7,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w0,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w1,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w2,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w3,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w4,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w5,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w6,
   output logic [NUM_DFI_DQ*MWIDTH-1:0]     o_dfi_rddata_dbi_w7,
   output logic                             o_dfi_rddata_valid_w0,
   output logic                             o_dfi_rddata_valid_w1,
   output logic                             o_dfi_rddata_valid_w2,
   output logic                             o_dfi_rddata_valid_w3,
   output logic                             o_dfi_rddata_valid_w4,
   output logic                             o_dfi_rddata_valid_w5,
   output logic                             o_dfi_rddata_valid_w6,
   output logic                             o_dfi_rddata_valid_w7,

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

   // Pads
   inout  wire                             pad_reset_n,                      // Reset pad
   inout  wire                              pad_rext,
   inout  wire                              pad_test,                         // TEST pad
   inout  wire                              pad_ch0_ck_t,                  // CK
   inout  wire                              pad_ch0_ck_c,                  // CK
   inout  wire [CA_WIDTH-1:0]               pad_ch0_ca,                    // CA/CS/CKE
   inout  wire [NUM_DQ-1:0]                 pad_ch0_wck_t,                 // WCK
   inout  wire [NUM_DQ-1:0]                 pad_ch0_wck_c,                 // WCK
   inout  wire [NUM_DQ-1:0]                 pad_ch0_dqs_t,                 // RDQS/DQS/EDC/PARITY
   inout  wire [NUM_DQ-1:0]                 pad_ch0_dqs_c,                 // RDQS/DQS/EDC
   inout  wire [NUM_DQ*DQ_WIDTH-1:0]        pad_ch0_dq,                    // DQ/DBI/DM/PARITY
   inout  wire                              pad_ch1_ck_t,                  // CK
   inout  wire                              pad_ch1_ck_c,                  // CK
   inout  wire [CA_WIDTH-1:0]               pad_ch1_ca,                    // CA/CS/CKE
   inout  wire [NUM_DQ-1:0]                 pad_ch1_wck_t,                 // WCK
   inout  wire [NUM_DQ-1:0]                 pad_ch1_wck_c,                 // WCK
   inout  wire [NUM_DQ-1:0]                 pad_ch1_dqs_t,                 // RDQS/DQS/EDC/PARITY
   inout  wire [NUM_DQ-1:0]                 pad_ch1_dqs_c,                 // RDQS/DQS/EDC
   inout  wire [NUM_DQ*DQ_WIDTH-1:0]        pad_ch1_dq,                    // DQ/DBI/DM/PARITY
   //Debug
   output logic [31:0]                      o_debug

);

   assign o_refclk_on = '1 ; // IFR_FIXME : Request RECLK always on for now. Add a CSR bit.
   assign o_scan      = '0 ; // DFT: Connect during scan stitch.

   logic ahb_extclk;
   logic ahb_clk;
   logic ahb_rst;
   logic ahb_csr_rst;
   logic mcu_clk;
   logic mcu_rst;
   logic ref_clk;
   logic ref_rst;
   logic phy_rst;

   // ------------------------------------------------------------------------
   // AHB Interconnect
   // ------------------------------------------------------------------------

   logic [AHB_AWIDTH-1:0]        mcu_ahbm_haddr;
   logic                         mcu_ahbm_hwrite;
   logic                         mcu_ahbm_hbusreq;
   logic [31:0]                  mcu_ahbm_hwdata;
   logic [1:0]                   mcu_ahbm_htrans;
   logic [2:0]                   mcu_ahbm_hsize;
   logic [2:0]                   mcu_ahbm_hburst;
   logic                         mcu_ahbm_hreadyin;
   logic                         mcu_ahbm_hready;
   logic [AHB_DWIDTH-1:0]        mcu_ahbm_hrdata;
   logic [1:0]                   mcu_ahbm_hresp;
   logic                         mcu_ahbm_hgrant;

   logic [AHB_AWIDTH-1:0]        mcutop_csr_ahbs_haddr;
   logic                         mcutop_csr_ahbs_hwrite;
   logic                         mcutop_csr_ahbs_hsel;
   logic [31:0]                  mcutop_csr_ahbs_hwdata;
   logic [1:0]                   mcutop_csr_ahbs_htrans;
   logic [2:0]                   mcutop_csr_ahbs_hsize;
   logic [2:0]                   mcutop_csr_ahbs_hburst;
   logic                         mcutop_csr_ahbs_hready;
   logic                         mcutop_csr_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        mcutop_csr_ahbs_hrdata;
   logic [1:0]                   mcutop_csr_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        mcu_ahbs_haddr;
   logic                         mcu_ahbs_hwrite;
   logic                         mcu_ahbs_hsel;
   logic [31:0]                  mcu_ahbs_hwdata;
   logic [1:0]                   mcu_ahbs_htrans;
   logic [2:0]                   mcu_ahbs_hsize;
   logic [2:0]                   mcu_ahbs_hburst;
   logic                         mcu_ahbs_hready;
   logic                         mcu_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        mcu_ahbs_hrdata;
   logic [1:0]                   mcu_ahbs_hresp;
   logic                         mcu_ahbs_hgrant;

   logic [AHB_AWIDTH-1:0]        mcu_cfg_ahbs_haddr;
   logic                         mcu_cfg_ahbs_hwrite;
   logic                         mcu_cfg_ahbs_hsel;
   logic [31:0]                  mcu_cfg_ahbs_hwdata;
   logic [1:0]                   mcu_cfg_ahbs_htrans;
   logic [2:0]                   mcu_cfg_ahbs_hsize;
   logic [2:0]                   mcu_cfg_ahbs_hburst;
   logic                         mcu_cfg_ahbs_hready;
   logic                         mcu_cfg_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        mcu_cfg_ahbs_hrdata;
   logic [1:0]                   mcu_cfg_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        cmn_ahbs_haddr;
   logic                         cmn_ahbs_hwrite;
   logic                         cmn_ahbs_hsel;
   logic [31:0]                  cmn_ahbs_hwdata;
   logic [1:0]                   cmn_ahbs_htrans;
   logic [2:0]                   cmn_ahbs_hsize;
   logic [2:0]                   cmn_ahbs_hburst;
   logic                         cmn_ahbs_hready;
   logic                         cmn_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        cmn_ahbs_hrdata;
   logic [1:0]                   cmn_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        dfi_ahbs_haddr;
   logic                         dfi_ahbs_hwrite;
   logic                         dfi_ahbs_hsel;
   logic [31:0]                  dfi_ahbs_hwdata;
   logic [1:0]                   dfi_ahbs_htrans;
   logic [2:0]                   dfi_ahbs_hsize;
   logic [2:0]                   dfi_ahbs_hburst;
   logic                         dfi_ahbs_hready;
   logic                         dfi_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        dfi_ahbs_hrdata;
   logic [1:0]                   dfi_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ucie_ahbs_haddr;
   logic                         ucie_ahbs_hwrite;
   logic                         ucie_ahbs_hsel;
   logic [31:0]                  ucie_ahbs_hwdata;
   logic [1:0]                   ucie_ahbs_htrans;
   logic [2:0]                   ucie_ahbs_hsize;
   logic [2:0]                   ucie_ahbs_hburst;
   logic                         ucie_ahbs_hready;
   logic                         ucie_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ucie_ahbs_hrdata;
   logic [1:0]                   ucie_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ch0_dq0_ahbs_haddr;
   logic                         ch0_dq0_ahbs_hwrite;
   logic                         ch0_dq0_ahbs_hsel;
   logic [31:0]                  ch0_dq0_ahbs_hwdata;
   logic [1:0]                   ch0_dq0_ahbs_htrans;
   logic [2:0]                   ch0_dq0_ahbs_hsize;
   logic [2:0]                   ch0_dq0_ahbs_hburst;
   logic                         ch0_dq0_ahbs_hready;
   logic                         ch0_dq0_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch0_dq0_ahbs_hrdata;
   logic [1:0]                   ch0_dq0_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ch0_dq1_ahbs_haddr;
   logic                         ch0_dq1_ahbs_hwrite;
   logic                         ch0_dq1_ahbs_hsel;
   logic [31:0]                  ch0_dq1_ahbs_hwdata;
   logic [1:0]                   ch0_dq1_ahbs_htrans;
   logic [2:0]                   ch0_dq1_ahbs_hsize;
   logic [2:0]                   ch0_dq1_ahbs_hburst;
   logic                         ch0_dq1_ahbs_hready;
   logic                         ch0_dq1_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch0_dq1_ahbs_hrdata;
   logic [1:0]                   ch0_dq1_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ch0_ca_ahbs_haddr;
   logic                         ch0_ca_ahbs_hwrite;
   logic                         ch0_ca_ahbs_hsel;
   logic [31:0]                  ch0_ca_ahbs_hwdata;
   logic [1:0]                   ch0_ca_ahbs_htrans;
   logic [2:0]                   ch0_ca_ahbs_hsize;
   logic [2:0]                   ch0_ca_ahbs_hburst;
   logic                         ch0_ca_ahbs_hready;
   logic                         ch0_ca_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch0_ca_ahbs_hrdata;
   logic [1:0]                   ch0_ca_ahbs_hresp;
   logic [AHB_AWIDTH-1:0]        ch1_dq0_ahbs_haddr;
   logic                         ch1_dq0_ahbs_hwrite;
   logic                         ch1_dq0_ahbs_hsel;
   logic [31:0]                  ch1_dq0_ahbs_hwdata;
   logic [1:0]                   ch1_dq0_ahbs_htrans;
   logic [2:0]                   ch1_dq0_ahbs_hsize;
   logic [2:0]                   ch1_dq0_ahbs_hburst;
   logic                         ch1_dq0_ahbs_hready;
   logic                         ch1_dq0_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch1_dq0_ahbs_hrdata;
   logic [1:0]                   ch1_dq0_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ch1_dq1_ahbs_haddr;
   logic                         ch1_dq1_ahbs_hwrite;
   logic                         ch1_dq1_ahbs_hsel;
   logic [31:0]                  ch1_dq1_ahbs_hwdata;
   logic [1:0]                   ch1_dq1_ahbs_htrans;
   logic [2:0]                   ch1_dq1_ahbs_hsize;
   logic [2:0]                   ch1_dq1_ahbs_hburst;
   logic                         ch1_dq1_ahbs_hready;
   logic                         ch1_dq1_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch1_dq1_ahbs_hrdata;
   logic [1:0]                   ch1_dq1_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ch1_ca_ahbs_haddr;
   logic                         ch1_ca_ahbs_hwrite;
   logic                         ch1_ca_ahbs_hsel;
   logic [31:0]                  ch1_ca_ahbs_hwdata;
   logic [1:0]                   ch1_ca_ahbs_htrans;
   logic [2:0]                   ch1_ca_ahbs_hsize;
   logic [2:0]                   ch1_ca_ahbs_hburst;
   logic                         ch1_ca_ahbs_hready;
   logic                         ch1_ca_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ch1_ca_ahbs_hrdata;
   logic [1:0]                   ch1_ca_ahbs_hresp;

   logic [AHB_AWIDTH-1:0]        ctrl_ahbs_haddr;
   logic                         ctrl_ahbs_hwrite;
   logic                         ctrl_ahbs_hsel;
   logic [31:0]                  ctrl_ahbs_hwdata;
   logic [1:0]                   ctrl_ahbs_htrans;
   logic [2:0]                   ctrl_ahbs_hsize;
   logic [2:0]                   ctrl_ahbs_hburst;
   logic                         ctrl_ahbs_hready;
   logic                         ctrl_ahbs_hreadyin;
   logic [AHB_DWIDTH-1:0]        ctrl_ahbs_hrdata;
   logic [1:0]                   ctrl_ahbs_hresp;

   ddr_ahb_ic #(
      .AWIDTH                        (AHB_AWIDTH),
      .DWIDTH                        (AHB_DWIDTH)
   ) u_ahb_ic (

      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),
      .i_scan_mode                   (i_scan_mode),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),

      .i_mcu_clk                     (mcu_clk),
      .i_mcu_rst                     (mcu_rst),
      .i_hclk                        (ahb_clk),
      .i_hrst                        (ahb_rst),

      .i_ahb_extclk                  (ahb_extclk),
      .i_ahb_extrst                  (ahb_rst),

      .i_intf_ahbs_haddr             (i_ahb_haddr),
      .i_intf_ahbs_hwrite            (i_ahb_hwrite),
      .i_intf_ahbs_hsel              (i_ahb_hsel),
      .i_intf_ahbs_hwdata            (i_ahb_hwdata),
      .i_intf_ahbs_htrans            (i_ahb_htrans),
      .i_intf_ahbs_hsize             (i_ahb_hsize),
      .i_intf_ahbs_hburst            (i_ahb_hburst),
      .i_intf_ahbs_hreadyin          (i_ahb_hreadyin),
      .o_intf_ahbs_hready            (o_ahb_hready),
      .o_intf_ahbs_hrdata            (o_ahb_hrdata),
      .o_intf_ahbs_hresp             (o_ahb_hresp),

      .o_ext_ahbm_haddr              (o_ahb_haddr),
      .o_ext_ahbm_hwrite             (o_ahb_hwrite),
      .o_ext_ahbm_hbusreq            (o_ahb_hbusreq),
      .o_ext_ahbm_hwdata             (o_ahb_hwdata),
      .o_ext_ahbm_htrans             (o_ahb_htrans),
      .o_ext_ahbm_hsize              (o_ahb_hsize),
      .o_ext_ahbm_hburst             (o_ahb_hburst),
      .i_ext_ahbm_hready             (i_ahb_hready),
      .i_ext_ahbm_hrdata             (i_ahb_hrdata),
      .i_ext_ahbm_hresp              (i_ahb_hresp),
      .i_ext_ahbm_hgrant             (i_ahb_hgrant),

      .i_mcu_ahbm_haddr              (mcu_ahbm_haddr),
      .i_mcu_ahbm_hwrite             (mcu_ahbm_hwrite),
      .i_mcu_ahbm_hbusreq            (mcu_ahbm_hbusreq),
      .i_mcu_ahbm_hwdata             (mcu_ahbm_hwdata),
      .i_mcu_ahbm_htrans             (mcu_ahbm_htrans),
      .i_mcu_ahbm_hsize              (mcu_ahbm_hsize),
      .i_mcu_ahbm_hburst             (mcu_ahbm_hburst),
      .i_mcu_ahbm_hreadyin           (mcu_ahbm_hreadyin),
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
      .i_mcutop_ahbs_hready          (mcutop_csr_ahbs_hready),
      .i_mcutop_ahbs_hrdata          (mcutop_csr_ahbs_hrdata),
      .i_mcutop_ahbs_hresp           (mcutop_csr_ahbs_hresp),

      .o_mcu_ahbs_haddr              (mcu_ahbs_haddr),
      .o_mcu_ahbs_hwrite             (mcu_ahbs_hwrite),
      .o_mcu_ahbs_hsel               (mcu_ahbs_hsel),
      .o_mcu_ahbs_hwdata             (mcu_ahbs_hwdata),
      .o_mcu_ahbs_htrans             (mcu_ahbs_htrans),
      .o_mcu_ahbs_hsize              (mcu_ahbs_hsize),
      .o_mcu_ahbs_hburst             (mcu_ahbs_hburst),
      .o_mcu_ahbs_hreadyin           (mcu_ahbs_hreadyin),
      .i_mcu_ahbs_hready             (mcu_ahbs_hready),
      .i_mcu_ahbs_hrdata             (mcu_ahbs_hrdata),
      .i_mcu_ahbs_hresp              (mcu_ahbs_hresp),
      .i_mcu_ahbs_hgrant             (mcu_ahbs_hgrant),

      .o_mcu_cfg_ahbs_haddr          (mcu_cfg_ahbs_haddr),
      .o_mcu_cfg_ahbs_hwrite         (mcu_cfg_ahbs_hwrite),
      .o_mcu_cfg_ahbs_hsel           (mcu_cfg_ahbs_hsel),
      .o_mcu_cfg_ahbs_hwdata         (mcu_cfg_ahbs_hwdata),
      .o_mcu_cfg_ahbs_htrans         (mcu_cfg_ahbs_htrans),
      .o_mcu_cfg_ahbs_hsize          (mcu_cfg_ahbs_hsize),
      .o_mcu_cfg_ahbs_hburst         (mcu_cfg_ahbs_hburst),
      .o_mcu_cfg_ahbs_hreadyin       (mcu_cfg_ahbs_hreadyin),
      .i_mcu_cfg_ahbs_hready         (mcu_cfg_ahbs_hready),
      .i_mcu_cfg_ahbs_hrdata         (mcu_cfg_ahbs_hrdata),
      .i_mcu_cfg_ahbs_hresp          (mcu_cfg_ahbs_hresp),

      .o_cmn_ahbs_haddr              (cmn_ahbs_haddr),
      .o_cmn_ahbs_hwrite             (cmn_ahbs_hwrite),
      .o_cmn_ahbs_hsel               (cmn_ahbs_hsel),
      .o_cmn_ahbs_hwdata             (cmn_ahbs_hwdata),
      .o_cmn_ahbs_htrans             (cmn_ahbs_htrans),
      .o_cmn_ahbs_hsize              (cmn_ahbs_hsize),
      .o_cmn_ahbs_hburst             (cmn_ahbs_hburst),
      .o_cmn_ahbs_hreadyin           (cmn_ahbs_hreadyin),
      .i_cmn_ahbs_hready             (cmn_ahbs_hready),
      .i_cmn_ahbs_hrdata             (cmn_ahbs_hrdata),
      .i_cmn_ahbs_hresp              (cmn_ahbs_hresp),

      .o_dfi_ahbs_haddr              (dfi_ahbs_haddr),
      .o_dfi_ahbs_hwrite             (dfi_ahbs_hwrite),
      .o_dfi_ahbs_hsel               (dfi_ahbs_hsel),
      .o_dfi_ahbs_hwdata             (dfi_ahbs_hwdata),
      .o_dfi_ahbs_htrans             (dfi_ahbs_htrans),
      .o_dfi_ahbs_hsize              (dfi_ahbs_hsize),
      .o_dfi_ahbs_hburst             (dfi_ahbs_hburst),
      .o_dfi_ahbs_hreadyin           (dfi_ahbs_hreadyin),
      .i_dfi_ahbs_hready             (dfi_ahbs_hready),
      .i_dfi_ahbs_hrdata             (dfi_ahbs_hrdata),
      .i_dfi_ahbs_hresp              (dfi_ahbs_hresp),

      .o_ucie_ahbs_haddr              (ucie_ahbs_haddr),
      .o_ucie_ahbs_hwrite             (ucie_ahbs_hwrite),
      .o_ucie_ahbs_hsel               (ucie_ahbs_hsel),
      .o_ucie_ahbs_hwdata             (ucie_ahbs_hwdata),
      .o_ucie_ahbs_htrans             (ucie_ahbs_htrans),
      .o_ucie_ahbs_hsize              (ucie_ahbs_hsize),
      .o_ucie_ahbs_hburst             (ucie_ahbs_hburst),
      .o_ucie_ahbs_hreadyin           (ucie_ahbs_hreadyin),
      .i_ucie_ahbs_hready             (ucie_ahbs_hready),
      .i_ucie_ahbs_hrdata             (ucie_ahbs_hrdata),
      .i_ucie_ahbs_hresp              (ucie_ahbs_hresp),

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

      .o_ctrl_ahbs_haddr             (ctrl_ahbs_haddr),
      .o_ctrl_ahbs_hwrite            (ctrl_ahbs_hwrite),
      .o_ctrl_ahbs_hsel              (ctrl_ahbs_hsel),
      .o_ctrl_ahbs_hwdata            (ctrl_ahbs_hwdata),
      .o_ctrl_ahbs_htrans            (ctrl_ahbs_htrans),
      .o_ctrl_ahbs_hsize             (ctrl_ahbs_hsize),
      .o_ctrl_ahbs_hburst            (ctrl_ahbs_hburst),
      .o_ctrl_ahbs_hreadyin          (ctrl_ahbs_hreadyin),
      .i_ctrl_ahbs_hready            (ctrl_ahbs_hready),
      .i_ctrl_ahbs_hrdata            (ctrl_ahbs_hrdata),
      .i_ctrl_ahbs_hresp             (ctrl_ahbs_hresp)
   );

`ifndef SYNTHESIS
   wav_ahb_monitor #(
      .AWIDTH                        (AHB_AWIDTH),
      .DWIDTH                        (32)
   ) u_ahb_monitor (
      .i_hclk                        (i_ahb_clk),
      .i_hreset                      (i_ahb_rst),
      .i_haddr                       (i_ahb_haddr),
      .i_hbusreq                     (i_ahb_hsel),
      .i_hwrite                      (i_ahb_hwrite),
      .i_hwdata                      (i_ahb_hwdata),
      .i_htrans                      (i_ahb_htrans),
      .i_hsize                       (i_ahb_hsize),
      .i_hburst                      (i_ahb_hburst),
      .i_hready                      (o_ahb_hready),
      .i_hrdata                      (o_ahb_hrdata),
      .i_hresp                       (o_ahb_hresp)
   );
`endif // SYNTHESIS

   // ------------------------------------------------------------------------
   // JTAG Chains
   // ------------------------------------------------------------------------

   logic jtag_tdi_cmn;
   logic jtag_tdo_cmn;

   logic jtag_dsr_tdo2core;
   logic jtag_dsr_core2tdo;
   logic jtag_dsr_shift;
   logic jtag_dsr_capture;
   logic jtag_dsr_capture_ck;
   logic jtag_dsr_update;
   logic jtag_dsr_update_ck;
   logic jtag_dsr_mode;

   logic jtag_bsr_tdo2core;
   logic jtag_bsr_core2tdo;
   logic jtag_bsr_shift;
   logic jtag_bsr_capture;
   logic jtag_bsr_update;
   logic jtag_bsr_mode;

   logic jtag_tdo_ddr_rstn;
   logic jtag_tdi_ddr_rstn;
   logic jtag_tdi_ch0;
   logic jtag_tdo_ch0;
   logic jtag_tdi_ch1;
   logic jtag_tdo_ch1;

   // CMN block JTAG
   assign jtag_tdi_cmn  = jtag_dsr_tdo2core;
   assign jtag_dsr_core2tdo = jtag_tdo_cmn;

   // DDR JTAG
   assign jtag_tdi_ddr_rstn  = jtag_bsr_tdo2core;
   assign jtag_tdi_ch0       = jtag_tdo_ddr_rstn;
   assign jtag_tdi_ch1     = jtag_tdo_ch0 ;
   assign jtag_bsr_core2tdo = jtag_tdo_ch1 ;

   // ------------------------------------------------------------------------
   // CMN/PLL and CMN/PLL Register Access
   // ------------------------------------------------------------------------

   wire  ana_vref_out;

   logic csp_div_rst_n;
   logic csp_pi_en;
   logic irq_pll;
   logic dfi_init_start;
   logic dfi_ctrlupd_req;
   logic dfi_phyupd_ack;
   logic dfi_phymstr_ack;
   logic dfi_lp_ctrl_req;
   logic dfi_lp_data_req;

   logic cmn_msr;
   logic cmn_switch_done;
   logic cmn_init_complete;
   logic irq_dfi_init_complete;

   logic freeze_n_aon;
   logic freeze_n_hv;

   logic [31:0] cmn_debug;
   logic [3:0] ch0_tst_clk;
   logic [3:0] ch1_tst_clk;

   ddr_cmn #(
      .AWIDTH                        (AHB_AWIDTH),
      .DWIDTH                        (32),
      .SECONDARY_PHY                 (SECONDARY_PHY)
   ) u_cmn (
      .i_dtst                        (ch0_tst_clk),
      .o_dtst                        (o_dtst),
      .ana_atst_in                   ('0),                 // IFR_FIXME - connect 4-bits

      // DDR Reset
      .i_ddr_rstn                    (i_dfi_reset_n_p0),
      .i_jtag_tck                    (i_jtag_tck),
      .i_jtag_trst_n                 (i_jtag_trst_n),
      .i_jtag_bsr_mode               (jtag_bsr_mode),
      .i_jtag_capture                (jtag_bsr_capture),
      .i_jtag_shift                  (jtag_bsr_shift),
      .i_jtag_update                 (jtag_bsr_update),
      .i_jtag_tdi                    (jtag_tdi_ddr_rstn),
      .o_jtag_tdo                    (jtag_tdo_ddr_rstn),

      .i_freeze_n                    (i_freeze_n),
      .i_freeze_n_aon                (1'b1),
      .i_freeze_n_hv                 (1'b1),
      .o_freeze_n_aon                (freeze_n_aon),
      .o_freeze_n_hv                 (freeze_n_hv),

      .ana_vref_in                   (1'b0),
      .ana_vref_out                  (ana_vref_out),
      .i_rst                         (phy_rst),
`ifdef DDR_ECO_ANA_REF_CLK
      .i_ana_refclk                  (i_ana_refclk),
`endif
      .i_refclk                      (i_refclk),
      .i_refclk_alt                  (i_refclk_alt),

      .i_pll_clk_0                   (i_pll_clk_0),
      .i_pll_clk_1                   (i_pll_clk_90),
      .i_pll_clk_2                   (i_pll_clk_180),
      .i_pll_clk_3                   (i_pll_clk_270),
      .i_vco0_clk                    (i_vco0_clk),

      .o_pll_clk_0                   (o_pll_clk_0),
      .o_pll_clk_1                   (o_pll_clk_90),
      .o_pll_clk_2                   (o_pll_clk_180),
      .o_pll_clk_3                   (o_pll_clk_270),
      .o_vco0_clk                    (o_vco0_clk),
      .o_pll0_div_clk                (/*OPEN*/),

      .o_pll_irq                     (irq_pll),

      // Frequency Switch
      .i_dfi_clk                     (o_dfi_clk),
      .i_dfi_clk_on                  (i_dfi_clk_on),
      .i_dfi_init_start              (dfi_init_start),
      .i_cmn_switch_done             (i_gpb[`DDR_GPB_SWITCH_DONE_IDX]),    // Rip primary channel CSP signals
      .o_cmn_switch_done             (cmn_switch_done),
      .o_cmn_init_complete           (cmn_init_complete),
      .o_cmn_msr                     (cmn_msr),
      .i_csp_pi_en                   (i_gpb[`DDR_GPB_CSP_PI_EN_IDX]),      // Rip primary channel CSP signals
      .i_csp_div_rst_n               (i_gpb[`DDR_GPB_CSP_DIV_RST_N_IDX]),  // Rip primary channel CSP signals
      .o_csp_pi_en                   (csp_pi_en),
      .o_csp_div_rst_n               (csp_div_rst_n),

      // PLL boundary scan ports
      .i_bscan_mode                  (jtag_dsr_mode),
      .i_bscan_tck                   (i_jtag_tck),
      .i_bscan_trst_n                (i_jtag_trst_n),
      .i_bscan_capturedr             (jtag_dsr_capture),
      .i_bscan_shiftdr               (jtag_dsr_shift),
      .i_bscan_updatedr              (jtag_dsr_update),
      .i_bscan_tdi                   (jtag_tdi_cmn),
      .o_bscan_tdo                   (jtag_tdo_cmn),
      .i_iddq_mode                   (i_iddq_mode),

      // PLL digital scan ports
      .i_scan_clk                    (i_scan_clk),
      .i_scan_mode                   (i_scan_mode),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),
      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),
      .i_scan_freq_en                (i_scan_freq_en),
      .i_scan_in                     (1'b0),        //DFT: connect during scan stitch
      .i_scan_shift                  (i_scan_en),
      .o_scan_out                    (/*OPEN*/),    //DFT: connect during scan stitch

      // CMN/PLL digital AHB Slave
      .i_ahb_csr_rst                 (ahb_csr_rst),
      .i_hclk                        (ahb_clk),
      .i_hreset                      (ahb_rst),
      .i_hsel                        (cmn_ahbs_hsel),
      .i_hreadyin                    (cmn_ahbs_hreadyin),
      .i_hwrite                      (cmn_ahbs_hwrite),
      .i_htrans                      (cmn_ahbs_htrans),
      .i_hsize                       (cmn_ahbs_hsize),
      .i_hburst                      (cmn_ahbs_hburst),
      .i_haddr                       (cmn_ahbs_haddr),
      .i_hwdata                      (cmn_ahbs_hwdata),
      .o_hready                      (cmn_ahbs_hready),
      .o_hrdata                      (cmn_ahbs_hrdata),
      .o_hresp                       (cmn_ahbs_hresp),

      // Pads
      .pad_rext                      (pad_rext),
      .pad_atb                       (pad_test),
      .pad_reset_n                   (pad_reset_n),
      // Debug
      .o_debug                       (cmn_debug)
   );


   // Assign secondary channel CSP signals to the GPB bus.
   always_comb begin
      o_gpb = '0;
      o_gpb[`DDR_GPB_CSP_PI_EN_IDX    ] = csp_pi_en;
      o_gpb[`DDR_GPB_CSP_DIV_RST_N_IDX] = csp_div_rst_n;
      o_gpb[`DDR_GPB_SWITCH_DONE_IDX  ] = cmn_switch_done;
   end

   // ------------------------------------------------------------------------
   // Control Plane
   // ------------------------------------------------------------------------

   logic        irq_external;
   logic [14:0] irq_fast;
   logic [NUM_IRQ-1:0] irq_fast_int;
   logic [NUM_IRQ-1:0] irq_fast_int_out;
   logic        irq_nm;

   logic        irq_ch0_ibuf_empty;
   logic        irq_ch0_ibuf_full;
   logic        irq_ch0_ibuf_overflow;
   logic        irq_ch0_ebuf_empty;
   logic        irq_ch0_ebuf_full;
   logic        irq_ch0_ebuf_overflow;
   logic        irq_ch1_ibuf_empty;
   logic        irq_ch1_ibuf_full;
   logic        irq_ch1_ibuf_overflow;
   logic        irq_ch1_ebuf_empty;
   logic        irq_ch1_ebuf_full;
   logic        irq_ch1_ebuf_overflow;
   logic        irq_host2mcu_msg_req;
   logic        irq_mcu2host_msg_ack;

   logic [31:0] dfi_debug;

   ddr_ctrl_plane # (
      .AWIDTH                        (AHB_AWIDTH),
      .DWIDTH                        (AHB_DWIDTH),
      .NUM_IRQ                       (NUM_IRQ)
   ) u_ctrl_plane (

      // Scan
      .i_scan_mode                   (i_scan_mode),
      .i_scan_clk                    (i_scan_clk),
      .i_scan_en                     (i_scan_en),
      .i_scan_freq_en                (i_scan_freq_en),
      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),

      // JTAG Interface
      .i_jtag_tck                    (i_jtag_tck),
      .i_jtag_trst_n                 (i_jtag_trst_n),
      .i_jtag_tms                    (i_jtag_tms),
      .i_jtag_tdi                    (i_jtag_tdi),
      .o_jtag_tdo                    (o_jtag_tdo),

      .o_jtag_dsr_tdo                (jtag_dsr_tdo2core),
      .i_jtag_dsr_tdo                (jtag_dsr_core2tdo),
      .o_jtag_dsr_shift              (jtag_dsr_shift),
      .o_jtag_dsr_capture            (jtag_dsr_capture),
      .o_jtag_dsr_capture_ck         (jtag_dsr_capture_ck),
      .o_jtag_dsr_update             (jtag_dsr_update),
      .o_jtag_dsr_update_ck          (jtag_dsr_update_ck),
      .o_jtag_dsr_mode               (jtag_dsr_mode),

      .o_jtag_bsr_tdo                (jtag_bsr_tdo2core),
      .i_jtag_bsr_tdo                (jtag_bsr_core2tdo),
      .o_jtag_bsr_shift              (jtag_bsr_shift),
      .o_jtag_bsr_capture            (jtag_bsr_capture),
      .o_jtag_bsr_update             (jtag_bsr_update),
      .o_jtag_bsr_mode               (jtag_bsr_mode),

      .i_freeze_n                    (1'b0),
      .i_hiz_n                       (1'b0),
      .i_iddq_mode                   (1'b0),

      .o_freeze_n                    (/*OPEN*/),
      .o_hiz_n                       (/*OPEN*/),
      .o_iddq_mode                   (/*OPEN*/),

      // Clock and reset
      .i_refclk                      (i_refclk),
      .i_refclk_alt                  (i_refclk_alt),
      .i_pll_clk                     (o_vco0_clk),
      .i_ahb_extclk                  (i_ahb_clk),

      .i_phy_rst                     (i_phy_rst),
      .i_ahb_extrst                  (i_ahb_rst),
      .i_ahb_csr_extrst              (i_ahb_csr_rst),

      .o_phy_rst                     (phy_rst),
      .o_ref_rst                     (ref_rst),
      .o_mcu_rst                     (mcu_rst),
      .o_ahb_rst                     (ahb_rst),
      .o_ahb_csr_rst                 (ahb_csr_rst),

      .o_ref_clk                     (ref_clk),
      .o_mcu_clk                     (mcu_clk),
      .o_ahb_clk                     (ahb_clk),
      .o_ahb_extclk                  (ahb_extclk),

      .o_ahb_clk_on                  (o_ahb_clk_on),
      .o_ref_clk_on                  (/*OPEN*/),
      .i_dfi_clk_on                  (i_dfi_clk_on),

      .i_debug_0                     (dfi_debug),
      .i_debug_1                     (cmn_debug),
      .o_debug                       (o_debug),

      .o_irq_external                (irq_external),
      .o_irq_fast                    (irq_fast),
      .i_irq_fast_int                (irq_fast_int_out),
      .o_irq_fast_int                (irq_fast_int),
      .o_irq_nm                      (irq_nm),
      .i_irq_pll                     (irq_pll),
      .i_irq_ch0_ibuf_empty          (irq_ch0_ibuf_empty),
      .i_irq_ch0_ibuf_full           (irq_ch0_ibuf_full),
      .i_irq_ch0_ibuf_overflow       (irq_ch0_ibuf_overflow),
      .i_irq_ch0_ebuf_empty          (irq_ch0_ebuf_empty),
      .i_irq_ch0_ebuf_full           (irq_ch0_ebuf_full),
      .i_irq_ch0_ebuf_overflow       (irq_ch0_ebuf_overflow),
      .i_irq_ch1_ibuf_empty          (irq_ch1_ibuf_empty),
      .i_irq_ch1_ibuf_full           (irq_ch1_ibuf_full),
      .i_irq_ch1_ibuf_overflow       (irq_ch1_ibuf_overflow),
      .i_irq_ch1_ebuf_empty          (irq_ch1_ebuf_empty),
      .i_irq_ch1_ebuf_full           (irq_ch1_ebuf_full),
      .i_irq_ch1_ebuf_overflow       (irq_ch1_ebuf_overflow),
      .i_irq_init_complete           (irq_dfi_init_complete),
      .i_irq_init_start              (dfi_init_start),
      .i_irq_ctrlupd_req             (dfi_ctrlupd_req),
      .i_irq_phyupd_ack              (dfi_phyupd_ack),
      .i_irq_phymstr_ack             (dfi_phymstr_ack),
      .i_irq_lp_ctrl_req             (dfi_lp_ctrl_req),
      .i_irq_lp_data_req             (dfi_lp_data_req),
      .i_irq_ext                     (i_irq),
      .i_irq_host2mcu_msg_req        (irq_host2mcu_msg_req),
      .i_irq_mcu2host_msg_ack        (irq_mcu2host_msg_ack),

      // AHB Slave for Snooper
      .i_intf_ahb_haddr              (i_ahb_haddr),
      .i_intf_ahb_hwrite             (i_ahb_hwrite),
      .i_intf_ahb_hsel               (i_ahb_hsel),
      .i_intf_ahb_hreadyin           (i_ahb_hreadyin),

      // AHB Slave For top CTRL CSRs
      .i_ctrl_ahb_haddr              (ctrl_ahbs_haddr),
      .i_ctrl_ahb_hwrite             (ctrl_ahbs_hwrite),
      .i_ctrl_ahb_hsel               (ctrl_ahbs_hsel),
      .i_ctrl_ahb_hreadyin           (ctrl_ahbs_hreadyin),
      .i_ctrl_ahb_hwdata             (ctrl_ahbs_hwdata),
      .i_ctrl_ahb_htrans             (ctrl_ahbs_htrans),
      .i_ctrl_ahb_hsize              (ctrl_ahbs_hsize),
      .i_ctrl_ahb_hburst             (ctrl_ahbs_hburst),
      .o_ctrl_ahb_hready             (ctrl_ahbs_hready),
      .o_ctrl_ahb_hrdata             (ctrl_ahbs_hrdata),
      .o_ctrl_ahb_hresp              (ctrl_ahbs_hresp)

   );

   // ------------------------------------------------------------------------
   // MicroController Unit
   // ------------------------------------------------------------------------

   wav_mcu_ibex #(
      .AWIDTH                        (32),
      .NUM_INT_IRQ                   (NUM_IRQ)
   ) u_mcu (

      // Clock and reset
      .i_ahb_clk                     (ahb_clk),
      .i_ahb_csr_rst                 (ahb_csr_rst),
      .i_mcu_clk                     (mcu_clk),
      .i_mcu_rst                     (mcu_rst),
      .i_ref_clk                     (ref_clk),
      .i_ref_rst                     (ref_rst),

      // Modes
      .i_scan_mode                   (i_scan_mode),

      // HOST<->MCU Messaging
      .o_irq_host2mcu_msg_req        (irq_host2mcu_msg_req),
      .o_irq_mcu2host_msg_ack        (irq_mcu2host_msg_ack),

      // Ibex Interrupts
      .i_irq_external                (irq_external),
      .i_irq_fast_int                (irq_fast_int),
      .o_irq_fast_int                (irq_fast_int_out),
      .i_irq_fast                    (irq_fast),
      .i_irq_nm                      (irq_nm),
      .o_irq_ext                     (o_irq),

      .o_core_sleep                  (/*OPEN*/),

      // AHB Slave For Memory Load and configuration
      .i_ahbs_haddr                  (mcu_ahbs_haddr),
      .i_ahbs_hwrite                 (mcu_ahbs_hwrite),
      .i_ahbs_hsel                   (mcu_ahbs_hsel),
      .i_ahbs_hreadyin               (mcu_ahbs_hreadyin),
      .i_ahbs_hwdata                 (mcu_ahbs_hwdata),
      .i_ahbs_htrans                 (mcu_ahbs_htrans),
      .i_ahbs_hsize                  (mcu_ahbs_hsize),
      .i_ahbs_hburst                 (mcu_ahbs_hburst),
      .o_ahbs_hready                 (mcu_ahbs_hready),
      .o_ahbs_hrdata                 (mcu_ahbs_hrdata),
      .o_ahbs_hresp                  (mcu_ahbs_hresp),
      .o_ahbs_hgrant                 (mcu_ahbs_hgrant),

      // MCU Mode CSR AHB Slave
      .i_mcutop_ahbs_haddr           (mcutop_csr_ahbs_haddr),
      .i_mcutop_ahbs_hwrite          (mcutop_csr_ahbs_hwrite),
      .i_mcutop_ahbs_hsel            (mcutop_csr_ahbs_hsel),
      .i_mcutop_ahbs_hreadyin        (mcutop_csr_ahbs_hreadyin),
      .i_mcutop_ahbs_hwdata          (mcutop_csr_ahbs_hwdata),
      .i_mcutop_ahbs_htrans          (mcutop_csr_ahbs_htrans),
      .i_mcutop_ahbs_hsize           (mcutop_csr_ahbs_hsize),
      .i_mcutop_ahbs_hburst          (mcutop_csr_ahbs_hburst),
      .o_mcutop_ahbs_hready          (mcutop_csr_ahbs_hready),
      .o_mcutop_ahbs_hrdata          (mcutop_csr_ahbs_hrdata),
      .o_mcutop_ahbs_hresp           (mcutop_csr_ahbs_hresp),

      // MCU Mode CSR AHB Slave
      .i_mcu_cfg_ahbs_haddr          (mcu_cfg_ahbs_haddr),
      .i_mcu_cfg_ahbs_hwrite         (mcu_cfg_ahbs_hwrite),
      .i_mcu_cfg_ahbs_hsel           (mcu_cfg_ahbs_hsel),
      .i_mcu_cfg_ahbs_hreadyin       (mcu_cfg_ahbs_hreadyin),
      .i_mcu_cfg_ahbs_hwdata         (mcu_cfg_ahbs_hwdata),
      .i_mcu_cfg_ahbs_htrans         (mcu_cfg_ahbs_htrans),
      .i_mcu_cfg_ahbs_hsize          (mcu_cfg_ahbs_hsize),
      .i_mcu_cfg_ahbs_hburst         (mcu_cfg_ahbs_hburst),
      .o_mcu_cfg_ahbs_hready         (mcu_cfg_ahbs_hready),
      .o_mcu_cfg_ahbs_hrdata         (mcu_cfg_ahbs_hrdata),
      .o_mcu_cfg_ahbs_hresp          (mcu_cfg_ahbs_hresp),

      // AHB Master Data Output
      .o_ahbm_haddr                  (mcu_ahbm_haddr),
      .o_ahbm_hreadyin               (mcu_ahbm_hreadyin),
      .o_ahbm_hbusreq                (mcu_ahbm_hbusreq),
      .i_ahbm_hgrant                 (mcu_ahbm_hgrant),
      .o_ahbm_hwrite                 (mcu_ahbm_hwrite),
      .o_ahbm_hwdata                 (mcu_ahbm_hwdata),
      .o_ahbm_htrans                 (mcu_ahbm_htrans),
      .o_ahbm_hsize                  (mcu_ahbm_hsize),
      .o_ahbm_hburst                 (mcu_ahbm_hburst),
      .i_ahbm_hready                 (mcu_ahbm_hready),
      .i_ahbm_hrdata                 (mcu_ahbm_hrdata),
      .i_ahbm_hresp                  (mcu_ahbm_hresp)
   );

   // ------------------------------------------------------------------------
   // Datapath - DFI
   // ------------------------------------------------------------------------

   localparam DFIRDCLKEN_PEXTWIDTH = 4;
    localparam DEC_DFIGBWIDTH=9;

   logic                            ch0_phy_clk;
   logic                            ch0_dfiwr_clk_1;
   logic                            ch0_dfiwr_clk_2;
   logic                            ch0_dfird_clk_1;
   logic                            ch0_dfird_clk_2;
   logic                            ch0_dfica_traffic;
   logic                            ch0_dfick_traffic;
   logic                            ch0_dfidqs_wrtraffic;
   logic                            ch0_dfidq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_dfiwrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_dfirdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch0_dfirdclk_en_pulse_ext;
   logic                            ch0_dfirdclk_en_ovr_sel;
   logic                            ch0_dfirdclk_en_ovr;

   logic [DQ_WWIDTH-1:0]            ch0_tx_dq0_sdr;
   logic [DQ_WWIDTH-1:0]            ch0_tx_dq0_pam4_sdr;
   logic [DQ_RWIDTH-1:0]            ch0_rx_dq0_sdr;
   logic [DQ_RWIDTH-1:0]            ch0_rx_dq0_pam4_sdr;
   logic [DQ_WIDTH-1:0]             ch0_rx_dq0_sdr_vld;
   logic [DQS_WWIDTH-1:0]           ch0_tx_dqs0_sdr;
   logic [DQ_WWIDTH-1:0]            ch0_tx_dq1_sdr;
   logic [DQ_WWIDTH-1:0]            ch0_tx_dq1_pam4_sdr;
   logic [DQ_RWIDTH-1:0]            ch0_rx_dq1_sdr;
   logic [DQ_RWIDTH-1:0]            ch0_rx_dq1_pam4_sdr;
   logic [DQ_WIDTH-1:0]             ch0_rx_dq1_sdr_vld;
   logic [DQS_WWIDTH-1:0]           ch0_tx_dqs1_sdr;

   logic [CA_WWIDTH-1:0]            ch0_tx_ca_sdr;
   logic [CA_WWIDTH-1:0]            ch0_tx_ca_pam4_sdr;
   logic [CA_RWIDTH-1:0]            ch0_rx_ca_sdr;
   logic [CA_RWIDTH-1:0]            ch0_rx_ca_pam4_sdr;
   logic [CA_WIDTH-1:0]             ch0_rx_ca_sdr_vld;
   logic [CK_WWIDTH-1:0]            ch0_tx_ck_sdr;
   logic                            ch1_phy_clk;
   logic                            ch1_dfiwr_clk_1;
   logic                            ch1_dfiwr_clk_2;
   logic                            ch1_dfird_clk_1;
   logic                            ch1_dfird_clk_2;
   logic                            ch1_dfica_traffic;
   logic                            ch1_dfick_traffic;
   logic                            ch1_dfidqs_wrtraffic;
   logic                            ch1_dfidq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_dfiwrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_dfirdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch1_dfirdclk_en_pulse_ext;
   logic                            ch1_dfirdclk_en_ovr_sel;
   logic                            ch1_dfirdclk_en_ovr;

   logic [DQ_WWIDTH-1:0]            ch1_tx_dq0_sdr;
   logic [DQ_WWIDTH-1:0]            ch1_tx_dq0_pam4_sdr;
   logic [DQ_RWIDTH-1:0]            ch1_rx_dq0_sdr;
   logic [DQ_RWIDTH-1:0]            ch1_rx_dq0_pam4_sdr;
   logic [DQ_WIDTH-1:0]             ch1_rx_dq0_sdr_vld;
   logic [DQS_WWIDTH-1:0]           ch1_tx_dqs0_sdr;
   logic [DQ_WWIDTH-1:0]            ch1_tx_dq1_sdr;
   logic [DQ_WWIDTH-1:0]            ch1_tx_dq1_pam4_sdr;
   logic [DQ_RWIDTH-1:0]            ch1_rx_dq1_sdr;
   logic [DQ_RWIDTH-1:0]            ch1_rx_dq1_pam4_sdr;
   logic [DQ_WIDTH-1:0]             ch1_rx_dq1_sdr_vld;
   logic [DQS_WWIDTH-1:0]           ch1_tx_dqs1_sdr;

   logic [CA_WWIDTH-1:0]            ch1_tx_ca_sdr;
   logic [CA_WWIDTH-1:0]            ch1_tx_ca_pam4_sdr;
   logic [CA_RWIDTH-1:0]            ch1_rx_ca_sdr;
   logic [CA_RWIDTH-1:0]            ch1_rx_ca_pam4_sdr;
   logic [CA_WIDTH-1:0]             ch1_rx_ca_sdr_vld;
   logic [CK_WWIDTH-1:0]            ch1_tx_ck_sdr;

   logic ucie_dfi_mode;

   logic [71:0]                    ucie_ch0_tx0_sdr;
   logic [71:0]                    ucie_ch0_tx_ck0_sdr;
   logic [71:0]                    ucie_ch0_tx1_sdr;
   logic [71:0]                    ucie_ch0_tx_ck1_sdr;
   logic [63:0]                    ucie_ch0_txca_sdr;
   logic [71:0]                    ucie_ch0_tx_ckca_sdr;

   logic [71:0]                    ucie_ch0_rx0_sdr;
   logic [8:0]                     ucie_ch0_rx0_sdr_vld;
   logic [71:0]                    ucie_ch0_rx1_sdr;
   logic [8:0]                     ucie_ch0_rx1_sdr_vld;
   logic [63:0]                    ucie_ch0_rxca_sdr;
   logic [7:0]                     ucie_ch0_rxca_sdr_vld;

   logic [71:0]                    ucie_ch1_tx0_sdr;
   logic [71:0]                    ucie_ch1_tx_ck0_sdr;
   logic [71:0]                    ucie_ch1_tx1_sdr;
   logic [71:0]                    ucie_ch1_tx_ck1_sdr;
   logic [63:0]                    ucie_ch1_txca_sdr;
   logic [71:0]                    ucie_ch1_tx_ckca_sdr;

   logic [71:0]                    ucie_ch1_rx0_sdr;
   logic [8:0]                     ucie_ch1_rx0_sdr_vld;
   logic [71:0]                    ucie_ch1_rx1_sdr;
   logic [8:0]                     ucie_ch1_rx1_sdr_vld;
   logic [63:0]                    ucie_ch1_rxca_sdr;
   logic [7:0]                     ucie_ch1_rxca_sdr_vld;


   ddr_dfi #(
      .NUM_WPH                       (NUM_WPH),
      .NUM_RPH                       (NUM_RPH),
      .DQ_WIDTH                      (DQ_WIDTH),
      .DQ_RWIDTH                     (DQ_RWIDTH),
      .DQ_WWIDTH                     (DQ_WWIDTH),
      .DQS_WIDTH                     (DQS_WIDTH),
      .DQS_WWIDTH                    (DQS_WWIDTH),
      .CA_WIDTH                      (CA_WIDTH),
      .CA_RWIDTH                     (CA_RWIDTH),
      .CA_WWIDTH                     (CA_WWIDTH),
      .CK_WIDTH                      (CK_WIDTH),
      .CK_WWIDTH                     (CK_WWIDTH),
      .AHB_AWIDTH                    (AHB_AWIDTH),
      .AHB_DWIDTH                    (32),
      .IG_DEPTH                      (DFI_BUF_IG_DEPTH),
      .EG_DEPTH                      (DFI_BUF_EG_DEPTH),
      .NUM_DQ                        (NUM_DQ),
      .NUM_DFI_DQ                    (NUM_DFI_DQ),
      .NUM_PHY_CH                    (NUM_CH),
      .NUM_DFI_CH                    (NUM_DFI_CH),
      .TSWIDTH                       (TSWIDTH),
      .SWIDTH                        (SWIDTH),
      .DWIDTH                        (DWIDTH),
      .BWIDTH                        (BWIDTH),
      .MWIDTH                        (MWIDTH),
      .TWIDTH                        (TWIDTH),
      .ERRWIDTH                      (ERRWIDTH),
      .DFIRDCLKEN_PEXTWIDTH          (DFIRDCLKEN_PEXTWIDTH),
      .AWIDTH                        (AWIDTH)
   ) u_dfi (

      // Scan
      .i_scan_mode                   (i_scan_mode),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),
      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),

      // Clock and reset
      .i_rst                         (phy_rst),
      .i_ch0_phy_clk                 (ch0_phy_clk),
      .i_ch0_dfiwr_clk_1             (ch0_dfiwr_clk_1),
      .i_ch0_dfiwr_clk_2             (ch0_dfiwr_clk_2),
      .i_ch0_dfird_clk_1             (ch0_dfird_clk_1),
      .i_ch0_dfird_clk_2             (ch0_dfird_clk_2),
      .i_ch1_phy_clk                 (ch1_phy_clk),
      .i_ch1_dfiwr_clk_1             (ch1_dfiwr_clk_1),
      .i_ch1_dfiwr_clk_2             (ch1_dfiwr_clk_2),
      .i_ch1_dfird_clk_1             (ch1_dfird_clk_1),
      .i_ch1_dfird_clk_2             (ch1_dfird_clk_2),
      .o_dfi_clk                     (o_dfi_clk),

      .i_ahb_clk                     (ahb_clk),
      .i_ahb_rst                     (ahb_csr_rst),

      .i_ahb_haddr                   (dfi_ahbs_haddr),
      .i_ahb_hwrite                  (dfi_ahbs_hwrite),
      .i_ahb_hsel                    (dfi_ahbs_hsel),
      .i_ahb_hwdata                  (dfi_ahbs_hwdata),
      .i_ahb_htrans                  (dfi_ahbs_htrans),
      .i_ahb_hsize                   (dfi_ahbs_hsize),
      .i_ahb_hburst                  (dfi_ahbs_hburst),
      .i_ahb_hreadyin                (dfi_ahbs_hreadyin),
      .o_ahb_hready                  (dfi_ahbs_hready),
      .o_ahb_hrdata                  (dfi_ahbs_hrdata),
      .o_ahb_hresp                   (dfi_ahbs_hresp),

      .o_ch0_dfidqs_wrtraffic        (ch0_dfidqs_wrtraffic),
      .o_ch0_dfidq_wrtraffic         (ch0_dfidq_wrtraffic),
      .o_ch0_dfick_traffic           (ch0_dfick_traffic),
      .o_ch0_dfica_traffic           (ch0_dfica_traffic),
      .o_ch0_dfiwrgb_mode            (ch0_dfiwrgb_mode),
      .o_ch0_dfirdgb_mode            (ch0_dfirdgb_mode),
      .o_ch0_dfirdclk_en_pulse_ext   (ch0_dfirdclk_en_pulse_ext),
      .o_ch0_dfirdclk_en_ovr_sel     (ch0_dfirdclk_en_ovr_sel),
      .o_ch0_dfirdclk_en_ovr         (ch0_dfirdclk_en_ovr),
      .o_ch1_dfidqs_wrtraffic        (ch1_dfidqs_wrtraffic),
      .o_ch1_dfidq_wrtraffic         (ch1_dfidq_wrtraffic),
      .o_ch1_dfick_traffic           (ch1_dfick_traffic),
      .o_ch1_dfica_traffic           (ch1_dfica_traffic),
      .o_ch1_dfiwrgb_mode            (ch1_dfiwrgb_mode),
      .o_ch1_dfirdgb_mode            (ch1_dfirdgb_mode),
      .o_ch1_dfirdclk_en_pulse_ext   (ch1_dfirdclk_en_pulse_ext),
      .o_ch1_dfirdclk_en_ovr_sel     (ch1_dfirdclk_en_ovr_sel),
      .o_ch1_dfirdclk_en_ovr         (ch1_dfirdclk_en_ovr),

      .o_ch0_dfi_ibuf_empty_irq      (irq_ch0_ibuf_empty),
      .o_ch0_dfi_ibuf_full_irq       (irq_ch0_ibuf_full),
      .o_ch0_dfi_ibuf_overflow_irq   (irq_ch0_ibuf_overflow),
      .o_ch0_dfi_ebuf_empty_irq      (irq_ch0_ebuf_empty),
      .o_ch0_dfi_ebuf_full_irq       (irq_ch0_ebuf_full),
      .o_ch0_dfi_ebuf_overflow_irq   (irq_ch0_ebuf_overflow),
      .o_ch1_dfi_ibuf_empty_irq      (irq_ch1_ibuf_empty),
      .o_ch1_dfi_ibuf_full_irq       (irq_ch1_ibuf_full),
      .o_ch1_dfi_ibuf_overflow_irq   (irq_ch1_ibuf_overflow),
      .o_ch1_dfi_ebuf_empty_irq      (irq_ch1_ebuf_empty),
      .o_ch1_dfi_ebuf_full_irq       (irq_ch1_ebuf_full),
      .o_ch1_dfi_ebuf_overflow_irq   (irq_ch1_ebuf_overflow),

      .i_msr                         (cmn_msr),
      .i_init_complete               (cmn_init_complete),

      // Update
      .o_dfi_ctrlupd_ack             (o_dfi_ctrlupd_ack),
      .o_dfi_ctrlupd_req             (dfi_ctrlupd_req),
      .i_dfi_ctrlupd_req             (i_dfi_ctrlupd_req),
      .o_dfi_phyupd_ack              (dfi_phyupd_ack),
      .i_dfi_phyupd_ack              (i_dfi_phyupd_ack),
      .o_dfi_phyupd_req              (o_dfi_phyupd_req),
      .o_dfi_phyupd_type             (o_dfi_phyupd_type),

      // Status
      .i_dfi_freq_fsp                (i_dfi_freq_fsp),
      .i_dfi_freq_ratio              (i_dfi_freq_ratio),
      .i_dfi_frequency               (i_dfi_frequency),
      .o_dfi_init_complete           (o_dfi_init_complete),
      .o_irq_dfi_init_complete       (irq_dfi_init_complete),
      .o_dfi_init_start              (dfi_init_start),
      .i_dfi_init_start              (i_dfi_init_start),

      // PHY Master
      .o_dfi_phymstr_ack             (dfi_phymstr_ack),
      .i_dfi_phymstr_ack             (i_dfi_phymstr_ack),
      .o_dfi_phymstr_cs_state        (o_dfi_phymstr_cs_state),
      .o_dfi_phymstr_req             (o_dfi_phymstr_req),
      .o_dfi_phymstr_state_sel       (o_dfi_phymstr_state_sel),
      .o_dfi_phymstr_type            (o_dfi_phymstr_type),



      // Low Power Control
      .o_dfi_lp_ctrl_ack             (o_dfi_lp_ctrl_ack),
      .o_dfi_lp_ctrl_req             (dfi_lp_ctrl_req),
      .i_dfi_lp_ctrl_req             (i_dfi_lp_ctrl_req),
      .i_dfi_lp_ctrl_wakeup          (i_dfi_lp_ctrl_wakeup),
      .o_dfi_lp_data_ack             (o_dfi_lp_data_ack),
      .o_dfi_lp_data_req             (dfi_lp_data_req),
      .i_dfi_lp_data_req             (i_dfi_lp_data_req),
      .i_dfi_lp_data_wakeup          (i_dfi_lp_data_wakeup),


      // Write Command Address Data
      .i_dfi_reset_n_p0              (i_dfi_reset_n_p0),
      .i_dfi_reset_n_p1              (i_dfi_reset_n_p1),
      .i_dfi_reset_n_p2              (i_dfi_reset_n_p2),
      .i_dfi_reset_n_p3              (i_dfi_reset_n_p3),
      .i_dfi_reset_n_p4              (i_dfi_reset_n_p4),
      .i_dfi_reset_n_p5              (i_dfi_reset_n_p5),
      .i_dfi_reset_n_p6              (i_dfi_reset_n_p6),
      .i_dfi_reset_n_p7              (i_dfi_reset_n_p7),

      .i_dfi_address_p0              (i_dfi_address_p0),
      .i_dfi_address_p1              (i_dfi_address_p1),
      .i_dfi_address_p2              (i_dfi_address_p2),
      .i_dfi_address_p3              (i_dfi_address_p3),
      .i_dfi_address_p4              (i_dfi_address_p4),
      .i_dfi_address_p5              (i_dfi_address_p5),
      .i_dfi_address_p6              (i_dfi_address_p6),
      .i_dfi_address_p7              (i_dfi_address_p7),
      .i_dfi_cke_p0                  (i_dfi_cke_p0),
      .i_dfi_cke_p1                  (i_dfi_cke_p1),
      .i_dfi_cke_p2                  (i_dfi_cke_p2),
      .i_dfi_cke_p3                  (i_dfi_cke_p3),
      .i_dfi_cke_p4                  (i_dfi_cke_p4),
      .i_dfi_cke_p5                  (i_dfi_cke_p5),
      .i_dfi_cke_p6                  (i_dfi_cke_p6),
      .i_dfi_cke_p7                  (i_dfi_cke_p7),
      .i_dfi_cs_p0                   (i_dfi_cs_p0),
      .i_dfi_cs_p1                   (i_dfi_cs_p1),
      .i_dfi_cs_p2                   (i_dfi_cs_p2),
      .i_dfi_cs_p3                   (i_dfi_cs_p3),
      .i_dfi_cs_p4                   (i_dfi_cs_p4),
      .i_dfi_cs_p5                   (i_dfi_cs_p5),
      .i_dfi_cs_p6                   (i_dfi_cs_p6),
      .i_dfi_cs_p7                   (i_dfi_cs_p7),
      .i_dfi_dram_clk_disable_p0     (i_dfi_dram_clk_disable_p0),
      .i_dfi_dram_clk_disable_p1     (i_dfi_dram_clk_disable_p1),
      .i_dfi_dram_clk_disable_p2     (i_dfi_dram_clk_disable_p2),
      .i_dfi_dram_clk_disable_p3     (i_dfi_dram_clk_disable_p3),
      .i_dfi_dram_clk_disable_p4     (i_dfi_dram_clk_disable_p4),
      .i_dfi_dram_clk_disable_p5     (i_dfi_dram_clk_disable_p5),
      .i_dfi_dram_clk_disable_p6     (i_dfi_dram_clk_disable_p6),
      .i_dfi_dram_clk_disable_p7     (i_dfi_dram_clk_disable_p7),

      // Write Data
      .i_dfi_parity_in_p0            (i_dfi_parity_in_p0),
      .i_dfi_parity_in_p1            (i_dfi_parity_in_p1),
      .i_dfi_parity_in_p2            (i_dfi_parity_in_p2),
      .i_dfi_parity_in_p3            (i_dfi_parity_in_p3),
      .i_dfi_parity_in_p4            (i_dfi_parity_in_p4),
      .i_dfi_parity_in_p5            (i_dfi_parity_in_p5),
      .i_dfi_parity_in_p6            (i_dfi_parity_in_p6),
      .i_dfi_parity_in_p7            (i_dfi_parity_in_p7),
      .i_dfi_wrdata_cs_p0            (i_dfi_wrdata_cs_p0),
      .i_dfi_wrdata_cs_p1            (i_dfi_wrdata_cs_p1),
      .i_dfi_wrdata_cs_p2            (i_dfi_wrdata_cs_p2),
      .i_dfi_wrdata_cs_p3            (i_dfi_wrdata_cs_p3),
      .i_dfi_wrdata_cs_p4            (i_dfi_wrdata_cs_p4),
      .i_dfi_wrdata_cs_p5            (i_dfi_wrdata_cs_p5),
      .i_dfi_wrdata_cs_p6            (i_dfi_wrdata_cs_p6),
      .i_dfi_wrdata_cs_p7            (i_dfi_wrdata_cs_p7),

      .i_dfi_wrdata_mask_p0          (i_dfi_wrdata_mask_p0),
      .i_dfi_wrdata_mask_p1          (i_dfi_wrdata_mask_p1),
      .i_dfi_wrdata_mask_p2          (i_dfi_wrdata_mask_p2),
      .i_dfi_wrdata_mask_p3          (i_dfi_wrdata_mask_p3),
      .i_dfi_wrdata_mask_p4          (i_dfi_wrdata_mask_p4),
      .i_dfi_wrdata_mask_p5          (i_dfi_wrdata_mask_p5),
      .i_dfi_wrdata_mask_p6          (i_dfi_wrdata_mask_p6),
      .i_dfi_wrdata_mask_p7          (i_dfi_wrdata_mask_p7),

      .i_dfi_wrdata_p0               (i_dfi_wrdata_p0),
      .i_dfi_wrdata_p1               (i_dfi_wrdata_p1),
      .i_dfi_wrdata_p2               (i_dfi_wrdata_p2),
      .i_dfi_wrdata_p3               (i_dfi_wrdata_p3),
      .i_dfi_wrdata_p4               (i_dfi_wrdata_p4),
      .i_dfi_wrdata_p5               (i_dfi_wrdata_p5),
      .i_dfi_wrdata_p6               (i_dfi_wrdata_p6),
      .i_dfi_wrdata_p7               (i_dfi_wrdata_p7),

      .i_dfi_wck_cs_p0               (i_dfi_wck_cs_p0),
      .i_dfi_wck_cs_p1               (i_dfi_wck_cs_p1),
      .i_dfi_wck_cs_p2               (i_dfi_wck_cs_p2),
      .i_dfi_wck_cs_p3               (i_dfi_wck_cs_p3),
      .i_dfi_wck_cs_p4               (i_dfi_wck_cs_p4),
      .i_dfi_wck_cs_p5               (i_dfi_wck_cs_p5),
      .i_dfi_wck_cs_p6               (i_dfi_wck_cs_p6),
      .i_dfi_wck_cs_p7               (i_dfi_wck_cs_p7),

      .i_dfi_wck_en_p0               (i_dfi_wck_en_p0),
      .i_dfi_wck_en_p1               (i_dfi_wck_en_p1),
      .i_dfi_wck_en_p2               (i_dfi_wck_en_p2),
      .i_dfi_wck_en_p3               (i_dfi_wck_en_p3),
      .i_dfi_wck_en_p4               (i_dfi_wck_en_p4),
      .i_dfi_wck_en_p5               (i_dfi_wck_en_p5),
      .i_dfi_wck_en_p6               (i_dfi_wck_en_p6),
      .i_dfi_wck_en_p7               (i_dfi_wck_en_p7),

      .i_dfi_wck_toggle_p0           (i_dfi_wck_toggle_p0),
      .i_dfi_wck_toggle_p1           (i_dfi_wck_toggle_p1),
      .i_dfi_wck_toggle_p2           (i_dfi_wck_toggle_p2),
      .i_dfi_wck_toggle_p3           (i_dfi_wck_toggle_p3),
      .i_dfi_wck_toggle_p4           (i_dfi_wck_toggle_p4),
      .i_dfi_wck_toggle_p5           (i_dfi_wck_toggle_p5),
      .i_dfi_wck_toggle_p6           (i_dfi_wck_toggle_p6),
      .i_dfi_wck_toggle_p7           (i_dfi_wck_toggle_p7),

      .i_dfi_wrdata_en_p0            (i_dfi_wrdata_en_p0),
      .i_dfi_wrdata_en_p1            (i_dfi_wrdata_en_p1),
      .i_dfi_wrdata_en_p2            (i_dfi_wrdata_en_p2),
      .i_dfi_wrdata_en_p3            (i_dfi_wrdata_en_p3),
      .i_dfi_wrdata_en_p4            (i_dfi_wrdata_en_p4),
      .i_dfi_wrdata_en_p5            (i_dfi_wrdata_en_p5),
      .i_dfi_wrdata_en_p6            (i_dfi_wrdata_en_p6),
      .i_dfi_wrdata_en_p7            (i_dfi_wrdata_en_p7),

      // Read Data
      .i_dfi_rddata_cs_p0            (i_dfi_rddata_cs_p0),
      .i_dfi_rddata_cs_p1            (i_dfi_rddata_cs_p1),
      .i_dfi_rddata_cs_p2            (i_dfi_rddata_cs_p2),
      .i_dfi_rddata_cs_p3            (i_dfi_rddata_cs_p3),
      .i_dfi_rddata_cs_p4            (i_dfi_rddata_cs_p4),
      .i_dfi_rddata_cs_p5            (i_dfi_rddata_cs_p5),
      .i_dfi_rddata_cs_p6            (i_dfi_rddata_cs_p6),
      .i_dfi_rddata_cs_p7            (i_dfi_rddata_cs_p7),

      .i_dfi_rddata_en_p0            (i_dfi_rddata_en_p0),
      .i_dfi_rddata_en_p1            (i_dfi_rddata_en_p1),
      .i_dfi_rddata_en_p2            (i_dfi_rddata_en_p2),
      .i_dfi_rddata_en_p3            (i_dfi_rddata_en_p3),
      .i_dfi_rddata_en_p4            (i_dfi_rddata_en_p4),
      .i_dfi_rddata_en_p5            (i_dfi_rddata_en_p5),
      .i_dfi_rddata_en_p6            (i_dfi_rddata_en_p6),
      .i_dfi_rddata_en_p7            (i_dfi_rddata_en_p7),

      .o_dfi_rddata_w0               (o_dfi_rddata_w0),
      .o_dfi_rddata_w1               (o_dfi_rddata_w1),
      .o_dfi_rddata_w2               (o_dfi_rddata_w2),
      .o_dfi_rddata_w3               (o_dfi_rddata_w3),
      .o_dfi_rddata_w4               (o_dfi_rddata_w4),
      .o_dfi_rddata_w5               (o_dfi_rddata_w5),
      .o_dfi_rddata_w6               (o_dfi_rddata_w6),
      .o_dfi_rddata_w7               (o_dfi_rddata_w7),
      .o_dfi_rddata_dbi_w0           (o_dfi_rddata_dbi_w0),
      .o_dfi_rddata_dbi_w1           (o_dfi_rddata_dbi_w1),
      .o_dfi_rddata_dbi_w2           (o_dfi_rddata_dbi_w2),
      .o_dfi_rddata_dbi_w3           (o_dfi_rddata_dbi_w3),
      .o_dfi_rddata_dbi_w4           (o_dfi_rddata_dbi_w4),
      .o_dfi_rddata_dbi_w5           (o_dfi_rddata_dbi_w5),
      .o_dfi_rddata_dbi_w6           (o_dfi_rddata_dbi_w6),
      .o_dfi_rddata_dbi_w7           (o_dfi_rddata_dbi_w7),
      .o_dfi_rddata_valid_w0         (o_dfi_rddata_valid_w0),
      .o_dfi_rddata_valid_w1         (o_dfi_rddata_valid_w1),
      .o_dfi_rddata_valid_w2         (o_dfi_rddata_valid_w2),
      .o_dfi_rddata_valid_w3         (o_dfi_rddata_valid_w3),
      .o_dfi_rddata_valid_w4         (o_dfi_rddata_valid_w4),
      .o_dfi_rddata_valid_w5         (o_dfi_rddata_valid_w5),
      .o_dfi_rddata_valid_w6         (o_dfi_rddata_valid_w6),
      .o_dfi_rddata_valid_w7         (o_dfi_rddata_valid_w7),


      .i_txrx_mode                   (ucie_dfi_mode),

      .o_ch0_dq0_sdr                 (ch0_tx_dq0_sdr),
      .i_ch0_dq0_sdr                 (ch0_rx_dq0_sdr),
      .i_ch0_dq0_sdr_vld             (ch0_rx_dq0_sdr_vld),
      .o_ch0_dqs0_sdr                (ch0_tx_dqs0_sdr),
      .o_ch0_dq1_sdr                 (ch0_tx_dq1_sdr),
      .i_ch0_dq1_sdr                 (ch0_rx_dq1_sdr),
      .i_ch0_dq1_sdr_vld             (ch0_rx_dq1_sdr_vld),
      .o_ch0_dqs1_sdr                (ch0_tx_dqs1_sdr),
      .i_ch0_tx0_sdr                 (ucie_ch0_tx0_sdr[71:0]),
      .i_ch0_tx_ck0_sdr              (ucie_ch0_tx_ck0_sdr[71:0]),
      .o_ch0_rx0_sdr                 (ucie_ch0_rx0_sdr[71:0]),
      .o_ch0_rx0_sdr_vld             (ucie_ch0_rx0_sdr_vld[8:0]),
      .i_ch0_tx1_sdr                 (ucie_ch0_tx1_sdr[71:0]),
      .i_ch0_tx_ck1_sdr              (ucie_ch0_tx_ck1_sdr[71:0]),
      .o_ch0_rx1_sdr                 (ucie_ch0_rx1_sdr[71:0]),
      .o_ch0_rx1_sdr_vld             (ucie_ch0_rx1_sdr_vld[8:0]),
      .i_ch0_txca_sdr                (ucie_ch0_txca_sdr[63:0]),
      .i_ch0_tx_ckca_sdr             (ucie_ch0_tx_ckca_sdr[71:0]),
      .o_ch0_rxca_sdr                (ucie_ch0_rxca_sdr[63:0]),
      .o_ch0_rxca_sdr_vld            (ucie_ch0_rxca_sdr_vld[7:0]),
      .o_ch0_ca_sdr                  (ch0_tx_ca_sdr),
      .i_ch0_ca_sdr                  (ch0_rx_ca_sdr),
      .i_ch0_ca_sdr_vld              (ch0_rx_ca_sdr_vld),
      .o_ch0_ck_sdr                  (ch0_tx_ck_sdr),
      .o_ch1_dq0_sdr                 (ch1_tx_dq0_sdr),
      .i_ch1_dq0_sdr                 (ch1_rx_dq0_sdr),
      .i_ch1_dq0_sdr_vld             (ch1_rx_dq0_sdr_vld),
      .o_ch1_dqs0_sdr                (ch1_tx_dqs0_sdr),
      .o_ch1_dq1_sdr                 (ch1_tx_dq1_sdr),
      .i_ch1_dq1_sdr                 (ch1_rx_dq1_sdr),
      .i_ch1_dq1_sdr_vld             (ch1_rx_dq1_sdr_vld),
      .o_ch1_dqs1_sdr                (ch1_tx_dqs1_sdr),
      .i_ch1_tx0_sdr                 (ucie_ch1_tx0_sdr[71:0]),
      .i_ch1_tx_ck0_sdr              (ucie_ch1_tx_ck0_sdr[71:0]),
      .o_ch1_rx0_sdr                 (ucie_ch1_rx0_sdr[71:0]),
      .o_ch1_rx0_sdr_vld             (ucie_ch1_rx0_sdr_vld[8:0]),
      .i_ch1_tx1_sdr                 (ucie_ch1_tx1_sdr[71:0]),
      .i_ch1_tx_ck1_sdr              (ucie_ch1_tx_ck1_sdr[71:0]),
      .o_ch1_rx1_sdr                 (ucie_ch1_rx1_sdr[71:0]),
      .o_ch1_rx1_sdr_vld             (ucie_ch1_rx1_sdr_vld[8:0]),
      .i_ch1_txca_sdr                (ucie_ch1_txca_sdr[63:0]),
      .i_ch1_tx_ckca_sdr             (ucie_ch1_tx_ckca_sdr[71:0]),
      .o_ch1_rxca_sdr                (ucie_ch1_rxca_sdr[63:0]),
      .o_ch1_rxca_sdr_vld            (ucie_ch1_rxca_sdr_vld[7:0]),
      .o_ch1_ca_sdr                  (ch1_tx_ca_sdr),
      .i_ch1_ca_sdr                  (ch1_rx_ca_sdr),
      .i_ch1_ca_sdr_vld              (ch1_rx_ca_sdr_vld),
      .o_ch1_ck_sdr                  (ch1_tx_ck_sdr),
      .o_debug                       (dfi_debug)
   );

logic [3:0] ucie_txrx_mode;
logic ucie_rxfifo_write;
logic  pam4_en;
logic  [7:0] pam4_cfg;

ucie_channel_adapter_wrapper u_ucie_channel_adapter_wrapper (
    //clk,rst
    .fwd_clk               (o_dfi_clk),
    .clk                   (o_dfi_clk),
    .rst                   (phy_rst),
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
    .ch0_tx_dq0_sdr        (ucie_ch0_tx0_sdr),
    .ch0_tx_dq0_pam4_sdr        (ch0_tx_dq0_pam4_sdr),
    .ch0_rx_dq0_sdr        (ucie_ch0_rx0_sdr),
    .ch0_rx_dq0_pam4_sdr        (ch0_rx_dq0_pam4_sdr),
    .ch0_rx_dq0_sdr_vld    (ucie_ch0_rx0_sdr_vld),
    .ch0_tx_dqs0_sdr       (ucie_ch0_tx_ck0_sdr),
    .ch0_tx_dq1_sdr        (ucie_ch0_tx1_sdr),
    .ch0_tx_dq1_pam4_sdr        (ch0_tx_dq1_pam4_sdr),
    .ch0_rx_dq1_sdr        (ucie_ch0_rx1_sdr),
    .ch0_rx_dq1_pam4_sdr        (ch0_rx_dq1_pam4_sdr),
    .ch0_rx_dq1_sdr_vld    (ucie_ch0_rx1_sdr_vld),
    .ch0_tx_dqs1_sdr       (ucie_ch0_tx_ck1_sdr),
    .ch0_tx_ca_sdr        (ucie_ch0_txca_sdr),
    .ch0_tx_ca_pam4_sdr        (ch0_tx_ca_pam4_sdr),
    .ch0_rx_ca_sdr        (ucie_ch0_rxca_sdr),
    .ch0_rx_ca_pam4_sdr        (ch0_rx_ca_pam4_sdr),
    .ch0_rx_ca_sdr_vld    (ucie_ch0_rxca_sdr_vld),
    .ch0_tx_ck_sdr       (ucie_ch0_tx_ckca_sdr),
    //SDR interface channel-1
    .ch1_tx_dq0_sdr        (ucie_ch1_tx0_sdr),
    .ch1_tx_dq0_pam4_sdr        (ch1_tx_dq0_pam4_sdr),
    .ch1_rx_dq0_sdr        (ucie_ch1_rx0_sdr),
    .ch1_rx_dq0_pam4_sdr        (ch1_rx_dq0_pam4_sdr),
    .ch1_rx_dq0_sdr_vld    (ucie_ch1_rx0_sdr_vld),
    .ch1_tx_dqs0_sdr       (ucie_ch1_tx_ck0_sdr),
    .ch1_tx_dq1_sdr        (ucie_ch1_tx1_sdr),
    .ch1_tx_dq1_pam4_sdr        (ch1_tx_dq1_pam4_sdr),
    .ch1_rx_dq1_sdr        (ucie_ch1_rx1_sdr),
    .ch1_rx_dq1_pam4_sdr        (ch1_rx_dq1_pam4_sdr),
    .ch1_rx_dq1_sdr_vld    (ucie_ch1_rx1_sdr_vld),
    .ch1_tx_dqs1_sdr       (ucie_ch1_tx_ck1_sdr),
    .ch1_tx_ca_sdr        (ucie_ch1_txca_sdr),
    .ch1_tx_ca_pam4_sdr        (ch1_tx_ca_pam4_sdr),
    .ch1_rx_ca_sdr        (ucie_ch1_rxca_sdr),
    .ch1_rx_ca_pam4_sdr        (ch1_rx_ca_pam4_sdr),
    .ch1_rx_ca_sdr_vld    (ucie_ch1_rxca_sdr_vld),
    .ch1_tx_ck_sdr       (ucie_ch1_tx_ckca_sdr),
    //ucie_txrx_mode
    .o_ucie_rxfifo_write   (ucie_rxfifo_write),
    .o_ucie_mode_en        (ucie_dfi_mode),
    .o_ucie_txrx_mode      (ucie_txrx_mode),
    .o_pam4_en             (pam4_en),
    .o_pam4_cfg            (pam4_cfg),
    //AHB 
    .i_hclk                (ahb_clk),
    .i_hreset              (ahb_csr_rst),
    .i_haddr               (ucie_ahbs_haddr),
    .i_hwrite              (ucie_ahbs_hwrite),
    .i_hsel                (ucie_ahbs_hsel),
    .i_hwdata              (ucie_ahbs_hwdata),
    .i_htrans              (ucie_ahbs_htrans),
    .i_hsize               (ucie_ahbs_hsize),
    .i_hburst              (ucie_ahbs_hburst),
    .i_hreadyin            (ucie_ahbs_hreadyin),
    .o_hready              (ucie_ahbs_hready),
    .o_hrdata              (ucie_ahbs_hrdata),
    .o_hresp               (ucie_ahbs_hresp)
);

 

   logic                            ch0_ucie_ca_traffic;
   logic                            ch0_ucie_ck_traffic;
   logic                            ch0_ucie_dqs_wrtraffic;
   logic                            ch0_ucie_dq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_ucie_wrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_ucie_rdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch0_ucie_rdclk_en_pulse_ext;
   logic                            ch0_ucie_rdclk_en_ovr_sel;
   logic                            ch0_ucie_rdclk_en_ovr;

   logic                            ch1_ucie_ca_traffic;
   logic                            ch1_ucie_ck_traffic;
   logic                            ch1_ucie_dqs_wrtraffic;
   logic                            ch1_ucie_dq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_ucie_wrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_ucie_rdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch1_ucie_rdclk_en_pulse_ext;
   logic                            ch1_ucie_rdclk_en_ovr_sel;
   logic                            ch1_ucie_rdclk_en_ovr;

   logic                            ch0_ca_traffic;
   logic                            ch0_ck_traffic;
   logic                            ch0_dqs_wrtraffic;
   logic                            ch0_dq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_wrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch0_rdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch0_rdclk_en_pulse_ext;
   logic                            ch0_rdclk_en_ovr_sel;
   logic                            ch0_rdclk_en_ovr;

   logic                            ch1_ca_traffic;
   logic                            ch1_ck_traffic;
   logic                            ch1_dqs_wrtraffic;
   logic                            ch1_dq_wrtraffic;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_wrgb_mode;
   logic [DEC_DFIGBWIDTH-1:0]       ch1_rdgb_mode;
   logic [DFIRDCLKEN_PEXTWIDTH-1:0] ch1_rdclk_en_pulse_ext;
   logic                            ch1_rdclk_en_ovr_sel;
   logic                            ch1_rdclk_en_ovr;

    //ch0/1 ucie traffic setting
    always_comb begin
        ch0_ucie_ca_traffic=1'b1;
        ch0_ucie_ck_traffic=1'b1;
        ch0_ucie_dqs_wrtraffic=1'b1;
        ch0_ucie_dq_wrtraffic=1'b1;
        ch0_ucie_wrgb_mode=9'b000100000;
        ch0_ucie_rdgb_mode=9'b000100000;
        ch0_ucie_rdclk_en_pulse_ext='0;
        ch0_ucie_rdclk_en_ovr_sel='0;
        ch0_ucie_rdclk_en_ovr='0;

        ch1_ucie_ca_traffic=1'b1;
        ch1_ucie_ck_traffic=1'b1;
        ch1_ucie_dqs_wrtraffic=1'b1;
        ch1_ucie_dq_wrtraffic=1'b1;
        ch1_ucie_wrgb_mode=9'b000100000;
        ch1_ucie_rdgb_mode=9'b000100000;
        ch1_ucie_rdclk_en_pulse_ext='0;
        ch1_ucie_rdclk_en_ovr_sel='0;
        ch1_ucie_rdclk_en_ovr='0;
    end

    //dfi signal mux
   assign ch0_ca_traffic=ucie_dfi_mode?ch0_ucie_ca_traffic:ch0_dfica_traffic;
   assign ch0_ck_traffic=ucie_dfi_mode?ch0_ucie_ck_traffic:ch0_dfick_traffic;
   assign ch0_dqs_wrtraffic=ucie_dfi_mode?ch0_ucie_dqs_wrtraffic:ch0_dfidqs_wrtraffic;
   assign ch0_dq_wrtraffic=ucie_dfi_mode?ch0_ucie_dq_wrtraffic:ch0_dfidq_wrtraffic;
   assign ch0_wrgb_mode=ucie_dfi_mode?ch0_ucie_wrgb_mode:ch0_dfiwrgb_mode;
   assign ch0_rdgb_mode=ucie_dfi_mode?ch0_ucie_rdgb_mode:ch0_dfirdgb_mode;
   assign ch0_rdclk_en_pulse_ext=ucie_dfi_mode?ch0_ucie_rdclk_en_pulse_ext:ch0_dfirdclk_en_pulse_ext;
   assign ch0_rdclk_en_ovr_sel=ucie_dfi_mode?ch0_ucie_rdclk_en_ovr_sel:ch0_dfirdclk_en_ovr_sel;
   assign ch0_rdclk_en_ovr=ucie_dfi_mode?ch0_ucie_rdclk_en_ovr:ch0_dfirdclk_en_ovr;

   assign ch1_ca_traffic=ucie_dfi_mode?ch1_ucie_ca_traffic:ch1_dfica_traffic;
   assign ch1_ck_traffic=ucie_dfi_mode?ch1_ucie_ck_traffic:ch1_dfick_traffic;
   assign ch1_dqs_wrtraffic=ucie_dfi_mode?ch1_ucie_dqs_wrtraffic:ch1_dfidqs_wrtraffic;
   assign ch1_dq_wrtraffic=ucie_dfi_mode?ch1_ucie_dq_wrtraffic:ch1_dfidq_wrtraffic;
   assign ch1_wrgb_mode=ucie_dfi_mode?ch1_ucie_wrgb_mode:ch1_dfiwrgb_mode;
   assign ch1_rdgb_mode=ucie_dfi_mode?ch1_ucie_rdgb_mode:ch1_dfirdgb_mode;
   assign ch1_rdclk_en_pulse_ext=ucie_dfi_mode?ch1_ucie_rdclk_en_pulse_ext:ch1_dfirdclk_en_pulse_ext;
   assign ch1_rdclk_en_ovr_sel=ucie_dfi_mode?ch1_ucie_rdclk_en_ovr_sel:ch1_dfirdclk_en_ovr_sel;
   assign ch1_rdclk_en_ovr=ucie_dfi_mode?ch1_ucie_rdclk_en_ovr:ch1_dfirdclk_en_ovr;
   // ------------------------------------------------------------------------
   // DDR PHY Channels
   // ------------------------------------------------------------------------

   logic [1:0] ch0_dq_rxfifo_empty_n_out;
   logic [1:0] ch0_dq_rxfifo_empty_n_in;
   logic [1:0] ch1_dq_rxfifo_empty_n_out;
   logic [1:0] ch1_dq_rxfifo_empty_n_in;
   assign ch0_dq_rxfifo_empty_n_in = ch0_dq_rxfifo_empty_n_out;
   assign ch1_dq_rxfifo_empty_n_in = ch1_dq_rxfifo_empty_n_out;

   logic ch0_sdr_valid_sel;
   logic ch0_rclk_sel;
   logic ch0_ucie_rdqs_sel;
   logic ch0_rxfifo_write;

   logic ch1_sdr_valid_sel;
   logic ch1_rclk_sel;
   logic ch1_ucie_rdqs_sel;
   logic ch1_rxfifo_write;



   assign ch0_sdr_valid_sel=ucie_dfi_mode;
   assign ch0_rclk_sel=ucie_dfi_mode;
   assign ch0_ucie_rdqs_sel=ucie_dfi_mode;
   assign ch0_rxfifo_write=ucie_rxfifo_write;

   assign ch1_sdr_valid_sel=ucie_dfi_mode;
   assign ch1_rclk_sel=ucie_dfi_mode;
   assign ch1_ucie_rdqs_sel=ucie_dfi_mode;
   assign ch1_rxfifo_write=ucie_rxfifo_write;

   ddr_phy_ch #(
      .AHB_AWIDTH                    (AHB_AWIDTH),
      .NUM_DQ                        (NUM_DQ),
      .NUM_RDPH                      (NUM_RDPH),
      .NUM_RPH                       (NUM_RPH),
      .NUM_WDPH                      (NUM_WDPH),
      .NUM_WPH                       (NUM_WPH),
      .DQ_WIDTH                      (DQ_WIDTH),
      .DQS_WIDTH                     (DQS_WIDTH),
      .CA_WIDTH                      (CA_WIDTH),
      .CK_WIDTH                      (CK_WIDTH),
      .FEEDTHR_DQS_WIDTH             (0),
      .FEEDTHR_CK_WIDTH              (8),
      .TXRX_DQS_WIDTH                (2),
      .TXRX_CK_WIDTH                 (1),
      .DFIRDCLKEN_PEXTWIDTH          (DFIRDCLKEN_PEXTWIDTH)
   ) u_phy_ch0 (

      .i_rst                         (phy_rst),
      .i_pll_clk_0                   (o_pll_clk_0),
      .i_pll_clk_90                  (o_pll_clk_90),
      .i_pll_clk_180                 (o_pll_clk_180),
      .i_pll_clk_270                 (o_pll_clk_270),

      .o_phy_clk                     (ch0_phy_clk),
      .o_dfiwr_clk_1                 (ch0_dfiwr_clk_1),
      .o_dfiwr_clk_2                 (ch0_dfiwr_clk_2),
      .o_dfird_clk_1                 (ch0_dfird_clk_1),
      .o_dfird_clk_2                 (ch0_dfird_clk_2),

      .i_sdr_valid_sel               (ch0_sdr_valid_sel),
      .i_rclk_sel                    (ch0_rclk_sel),
      .i_ucie_rdqs_sel               (ch0_ucie_rdqs_sel),
      .i_rxfifo_write                (ch0_rxfifo_write),
      .i_pam4_en                     (pam4_en),
      .i_pam4_cfg                     (pam4_cfg),

      .i_dqs_dfi_wrtraffic           (ch0_dqs_wrtraffic),
      .i_dq_dfi_wrtraffic            (ch0_dq_wrtraffic),
      .i_ck_dfi_traffic              (ch0_ck_traffic),
      .i_ca_dfi_traffic              (ch0_ca_traffic),
      .i_dfiwrgb_mode                (ch0_wrgb_mode),
      .i_dfirdgb_mode                (ch0_rdgb_mode),
      .i_dfirdclk_en_pulse_ext       (ch0_rdclk_en_pulse_ext),
      .i_dfirdclk_en_ovr_sel         (ch0_rdclk_en_ovr_sel),
      .i_dfirdclk_en_ovr             (ch0_rdclk_en_ovr),
      .i_csp_div_rst_n               (csp_div_rst_n),
      .i_csp_pi_en                   (csp_pi_en),

      // Mode Select
      .i_msr                         (cmn_msr),

      // Analog
      .ana_vref_in                   (ana_vref_out),

      // TEST
      .i_scan_clk                    (i_scan_clk),
      .i_scan_mode                   (i_scan_mode),
      .i_scan_en                     (i_scan_en),
      .i_scan_freq_en                (i_scan_freq_en[`DDR_FREQ_EN_DFICH]),
      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),
      .i_freeze_n                    (freeze_n_aon),
      .i_freeze_n_hv                 (freeze_n_hv),
      .i_hiz_n                       (i_hiz_n),
      .o_tst_clk                     (ch0_tst_clk),

      // JTAG Interface
      .i_jtag_tck                    (i_jtag_tck),
      .i_jtag_trst_n                 (i_jtag_trst_n),
      .i_jtag_bsr_mode               (jtag_bsr_mode),
      .i_jtag_shift                  (jtag_bsr_shift),
      .i_jtag_capture                (jtag_bsr_capture),
      .i_jtag_update                 (jtag_bsr_update),
      .i_jtag_tdi                    (jtag_tdi_ch0),
      .o_jtag_tdo                    (jtag_tdo_ch0),

      // AHB Interface
      .i_ahb_clk                     (ahb_clk),
      .i_ahb_rst                     (ahb_csr_rst),
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

      .o_dq_rxfifo_empty_n           (ch0_dq_rxfifo_empty_n_out),
      .i_dq_rxfifo_empty_n           (ch0_dq_rxfifo_empty_n_in),

      .i_dq0_sdr                     (ch0_tx_dq0_sdr),
      .i_dq0_pam4_sdr                     (ch0_tx_dq0_pam4_sdr),
      .o_dq0_sdr                     (ch0_rx_dq0_sdr),
      .o_dq0_pam4_sdr                     (ch0_rx_dq0_pam4_sdr),
      .o_dq0_sdr_vld                 (ch0_rx_dq0_sdr_vld),
      .i_dqs0_sdr                    (ch0_tx_dqs0_sdr),
      .i_dq1_sdr                     (ch0_tx_dq1_sdr),
      .i_dq1_pam4_sdr                     (ch0_tx_dq1_pam4_sdr),
      .o_dq1_sdr                     (ch0_rx_dq1_sdr),
      .o_dq1_pam4_sdr                     (ch0_rx_dq1_pam4_sdr),
      .o_dq1_sdr_vld                 (ch0_rx_dq1_sdr_vld),
      .i_dqs1_sdr                    (ch0_tx_dqs1_sdr),

      .i_ca_sdr                      (ch0_tx_ca_sdr),
      .i_ca_pam4_sdr                      (ch0_tx_ca_pam4_sdr),
      .o_ca_sdr                      (ch0_rx_ca_sdr),
      .o_ca_pam4_sdr                      (ch0_rx_ca_pam4_sdr),
      .o_ca_sdr_vld                  (ch0_rx_ca_sdr_vld),
      .i_ck_sdr                      (ch0_tx_ck_sdr),

      .pad_ck_t                      (pad_ch0_ck_t),
      .pad_ck_c                      (pad_ch0_ck_c),
      .pad_ca                        (pad_ch0_ca),
      .pad_wck_t                     (pad_ch0_wck_t),
      .pad_wck_c                     (pad_ch0_wck_c),
      .pad_dqs_t                     (pad_ch0_dqs_t),
      .pad_dqs_c                     (pad_ch0_dqs_c),
      .pad_dq                        (pad_ch0_dq)

   );
   ddr_phy_ch #(
      .AHB_AWIDTH                    (AHB_AWIDTH),
      .NUM_DQ                        (NUM_DQ),
      .NUM_RDPH                      (NUM_RDPH),
      .NUM_RPH                       (NUM_RPH),
      .NUM_WDPH                      (NUM_WDPH),
      .NUM_WPH                       (NUM_WPH),
      .DQ_WIDTH                      (DQ_WIDTH),
      .DQS_WIDTH                     (DQS_WIDTH),
      .CA_WIDTH                      (CA_WIDTH),
      .CK_WIDTH                      (CK_WIDTH),
      .FEEDTHR_DQS_WIDTH             (0),
      .FEEDTHR_CK_WIDTH              (8),
      .TXRX_DQS_WIDTH                (2),
      .TXRX_CK_WIDTH                 (1),
      .DFIRDCLKEN_PEXTWIDTH          (DFIRDCLKEN_PEXTWIDTH)
   ) u_phy_ch1 (

      .i_rst                         (phy_rst),
      .i_pll_clk_0                   (o_pll_clk_0),
      .i_pll_clk_90                  (o_pll_clk_90),
      .i_pll_clk_180                 (o_pll_clk_180),
      .i_pll_clk_270                 (o_pll_clk_270),

      .o_phy_clk                     (ch1_phy_clk),
      .o_dfiwr_clk_1                 (ch1_dfiwr_clk_1),
      .o_dfiwr_clk_2                 (ch1_dfiwr_clk_2),
      .o_dfird_clk_1                 (ch1_dfird_clk_1),
      .o_dfird_clk_2                 (ch1_dfird_clk_2),

      .i_sdr_valid_sel               (ch1_sdr_valid_sel),
      .i_rclk_sel                    (ch1_rclk_sel),
      .i_ucie_rdqs_sel               (ch1_ucie_rdqs_sel),
      .i_rxfifo_write                (ch1_rxfifo_write),
      .i_pam4_en                     (pam4_en),
      .i_pam4_cfg                     (pam4_cfg),

      .i_dqs_dfi_wrtraffic           (ch1_dqs_wrtraffic),
      .i_dq_dfi_wrtraffic            (ch1_dq_wrtraffic),
      .i_ck_dfi_traffic              (ch1_ck_traffic),
      .i_ca_dfi_traffic              (ch1_ca_traffic),
      .i_dfiwrgb_mode                (ch1_wrgb_mode),
      .i_dfirdgb_mode                (ch1_rdgb_mode),
      .i_dfirdclk_en_pulse_ext       (ch1_rdclk_en_pulse_ext),
      .i_dfirdclk_en_ovr_sel         (ch1_rdclk_en_ovr_sel),
      .i_dfirdclk_en_ovr             (ch1_rdclk_en_ovr),
      .i_csp_div_rst_n               (csp_div_rst_n),
      .i_csp_pi_en                   (csp_pi_en),

      // Mode Select
      .i_msr                         (cmn_msr),

      // Analog
      .ana_vref_in                   (ana_vref_out),

      // TEST
      .i_scan_clk                    (i_scan_clk),
      .i_scan_mode                   (i_scan_mode),
      .i_scan_en                     (i_scan_en),
      .i_scan_freq_en                (i_scan_freq_en[`DDR_FREQ_EN_DFICH]),
      .i_scan_cgc_ctrl               (i_scan_cgc_ctrl),
      .i_scan_rst_ctrl               (i_scan_rst_ctrl),
      .i_freeze_n                    (freeze_n_aon),
      .i_freeze_n_hv                 (freeze_n_hv),
      .i_hiz_n                       (i_hiz_n),
      .o_tst_clk                     (ch1_tst_clk),

      // JTAG Interface
      .i_jtag_tck                    (i_jtag_tck),
      .i_jtag_trst_n                 (i_jtag_trst_n),
      .i_jtag_bsr_mode               (jtag_bsr_mode),
      .i_jtag_shift                  (jtag_bsr_shift),
      .i_jtag_capture                (jtag_bsr_capture),
      .i_jtag_update                 (jtag_bsr_update),
      .i_jtag_tdi                    (jtag_tdi_ch1),
      .o_jtag_tdo                    (jtag_tdo_ch1),

      // AHB Interface
      .i_ahb_clk                     (ahb_clk),
      .i_ahb_rst                     (ahb_csr_rst),
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

      .o_dq_rxfifo_empty_n           (ch1_dq_rxfifo_empty_n_out),
      .i_dq_rxfifo_empty_n           (ch1_dq_rxfifo_empty_n_in),

      .i_dq0_sdr                     (ch1_tx_dq0_sdr),
      .i_dq0_pam4_sdr                     (ch1_tx_dq0_pam4_sdr),
      .o_dq0_sdr                     (ch1_rx_dq0_sdr),
      .o_dq0_pam4_sdr                     (ch1_rx_dq0_pam4_sdr),
      .o_dq0_sdr_vld                 (ch1_rx_dq0_sdr_vld),
      .i_dqs0_sdr                    (ch1_tx_dqs0_sdr),
      .i_dq1_sdr                     (ch1_tx_dq1_sdr),
      .i_dq1_pam4_sdr                     (ch1_tx_dq1_pam4_sdr),
      .o_dq1_sdr                     (ch1_rx_dq1_sdr),
      .o_dq1_pam4_sdr                     (ch1_rx_dq1_pam4_sdr),
      .o_dq1_sdr_vld                 (ch1_rx_dq1_sdr_vld),
      .i_dqs1_sdr                    (ch1_tx_dqs1_sdr),

      .i_ca_sdr                      (ch1_tx_ca_sdr),
      .i_ca_pam4_sdr                      (ch1_tx_ca_pam4_sdr),
      .o_ca_sdr                      (ch1_rx_ca_sdr),
      .o_ca_pam4_sdr                      (ch1_rx_ca_pam4_sdr),
      .o_ca_sdr_vld                  (ch1_rx_ca_sdr_vld),
      .i_ck_sdr                      (ch1_tx_ck_sdr),

      .pad_ck_t                      (pad_ch1_ck_t),
      .pad_ck_c                      (pad_ch1_ck_c),
      .pad_ca                        (pad_ch1_ca),
      .pad_wck_t                     (pad_ch1_wck_t),
      .pad_wck_c                     (pad_ch1_wck_c),
      .pad_dqs_t                     (pad_ch1_dqs_t),
      .pad_dqs_c                     (pad_ch1_dqs_c),
      .pad_dq                        (pad_ch1_dq)

   );

endmodule