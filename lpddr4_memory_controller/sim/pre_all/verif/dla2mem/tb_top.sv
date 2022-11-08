`timescale 1ns/10ps

module mc_top_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

// ----------------------------------------------------
//top signal define: clock and reset
// ref_clk is 20MHz from crystal Osc,  Phy_clk is 2GHz from PLL 



    logic ahb_clk;
    logic phy_clk;
    logic ref_clk;

    logic phy_rst;
    logic mc_rst;


    //clks
    parameter half_clk_cycle=13;
    always #half_clk_cycle ref_clk=~ref_clk;
    assign ahb_clk=ref_clk;

event begin_write;
event begin_read;

// ----------------------------------------------------
//ahb signal define
//ahb for memory control
   logic [31:0]                  ahb_haddr;
   logic                         ahb_hwrite;
   logic                         ahb_hbusreq;
   logic [31:0]                  ahb_hwdata;
   logic [1:0]                   ahb_htrans;
   logic [2:0]                   ahb_hsize;
   logic                         ahb_hsel;
   logic [2:0]                   ahb_hburst;
   logic                         ahb_hreadyin;
   logic                         ahb_hready;
   logic [31:0]                  ahb_hrdata;
   logic [1:0]                   ahb_hresp;
   logic                         ahb_hgrant;

// ----------------------------------------------------
// ahb signal for ddr phy
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

// ----------------------------------------------------
// phy signal 
    wire [17:0]  pad_ch0_dq;
    wire [7:0]  pad_ch0_ca;
    wire  pad_ch0_ck_c;
    wire  pad_ch0_ck_t;
    wire [1:0] pad_ch0_dqs_c;
    wire [1:0] pad_ch0_dqs_t;

    wire [17:0]  pad_ch1_dq;
    wire [7:0]  pad_ch1_ca;
    wire  pad_ch1_ck_c;
    wire  pad_ch1_ck_t;
    wire [1:0] pad_ch1_dqs_c;
    wire [1:0] pad_ch1_dqs_t;

    wire pad_rext;
    wire pad_test;
    wire pad_reset_n;


// ----------------------------------------------------
//signal define for memory controller.
    logic clk,rst;
	logic ahb_extrst,ahb_extclk;
    native_interface native_if_0(clk,rst);
    native_interface native_if_1(clk,rst);

    mosi_interface  my_mosi_0();
    mosi_interface  my_mosi_1();
    dma_native_interface  my_native_0();
    dma_native_interface  my_native_1();

	dfi_lpddr4_interface dfi_lpddr4_if(clk,rst);
// ----------------------------------------------------

mc_top u_mc_top (
    .clk               (phy_clk),
    .rst               (mc_rst),
    .native_if_0       (native_if_0),
    .native_if_1       (native_if_1),
    .dfi_lpddr4_if     (dfi_lpddr4_if),
    .ahb_extclk        (ahb_clk),
    .ahb_extrst        (phy_rst),
    .i_ahb_haddr       (ahb_haddr),
    .i_ahb_hwrite      (ahb_hwrite),
    .i_ahb_hwdata      (ahb_hwdata),
    .i_ahb_htrans      (ahb_htrans),
    .i_ahb_hsize       (ahb_hsize),
    .i_ahb_hsel        (ahb_hsel),
    .i_ahb_hburst      (ahb_hburst),
    .i_ahb_hreadyin    (ahb_hreadyin),
    .o_ahb_hready      (ahb_hready),
    .o_ahb_hgrant     (ahb_hgrant),
    .o_ahb_hrdata     (ahb_hrdata),
    .o_ahb_hresp      (ahb_hresp)
);


// ----------------------------------------------------
//sram_loader
// this loader for  memory controller
sram_loader u_mc_sram_loader (
    //AHB
    .ahb_if_haddr       (ahb_haddr),
    .ahb_if_hwrite      (ahb_hwrite),
    .ahb_if_hwdata      (ahb_hwdata),
    .ahb_if_htrans      (ahb_htrans),
    .ahb_if_hsize       (ahb_hsize),
    .ahb_if_hsel        (ahb_hsel),
    .ahb_if_hburst      (ahb_hburst),
    .ahb_if_hreadyin    (ahb_hreadyin),
    .ahb_if_hready      (ahb_hready),
    .ahb_if_hrdata      (ahb_hrdata),
    .ahb_if_hresp       (ahb_hresp),
    .clk                (ahb_clk)
);

// ----------------------------------------------------
//sram loader for ddr_phy
sram_loader u_sram_loader (
    //AHB
    .ahb_if_haddr       (ahb_if_haddr),
    .ahb_if_hwrite      (ahb_if_hwrite),
    .ahb_if_hwdata      (ahb_if_hwdata),
    .ahb_if_htrans      (ahb_if_htrans),
    .ahb_if_hsize       (ahb_if_hsize),
    .ahb_if_hsel        (ahb_if_hsel),
    .ahb_if_hburst      (ahb_if_hburst),
    .ahb_if_hreadyin    (ahb_if_hreadyin),
    .ahb_if_hready      (ahb_if_hready),
    .ahb_if_hrdata      (ahb_if_hrdata),
    .ahb_if_hresp       (ahb_if_hresp),
    .clk                (ahb_clk)
);

// ----------------------------------------------------
//ddr phy
    localparam DFIRDCLKEN_PEXTWIDTH = 4;
mixed_phy #(
    .SECONDARY_PHY                ('0),
    // Secondary PHY configuration (no CMN, no MCU)
    .NUM_CH                       (2),
    // Number of PHY channels.
    .NUM_DQ                       (2),
    // Number of DQ lanes per PHY channel.
    .NUM_DFI_CH                   (1),
    // Number of DFI channels
    .NUM_DFI_DQ                   (4),
    // Number of DQ lanes per DFI channel.
    .AHB_AWIDTH                   (32),
    // AHB Address width
    .AHB_DWIDTH                   (32),
    // AHB Data width
    .SWIDTH                       (8),
    // PHY Slice Width
    .AWIDTH                       (6),
    // Cmd/Address bus width
    .NUM_RDPH                     (4),
    // Read datapath data phases (includes R/F)
    .NUM_RPH                      (8),
    // Read fifo data phases (includes R/F)
    .NUM_WDPH                     (4),
    // Write datapath data phases (includes R/F)
    .NUM_WPH                      (8),
    // Write gearbox data phases (includes R/F)
    .DQ_WIDTH                     (9),
    // DQ bus width
    .DQS_WIDTH                    (9+0),
    // DQS bus width
    .CA_WIDTH                     (8),
    // DQ bus width
    .CK_WIDTH                     (1+8),
    // DQS bus width
    .NUM_IRQ                      (`DDR_NUM_IRQ),
    // Max number of IRQ supported = 32
    .TSWIDTH                      (16),
    // Timestamp Width
    .DFI_BUF_IG_DEPTH             (32),
    // DFI ingress buffer depth
    // DFI egress buffer depth
    .DFI_BUF_EG_DEPTH             (32)
) u_lpddr4_phy (
    // Reset
    .i_phy_rst                    (phy_rst),
    // Clocks
    .i_dfi_clk_on                 (1'b1),
    .o_dfi_clk                    (phy_clk),
    .i_ana_refclk                 (ref_clk),
    .i_refclk                     (ref_clk),
    .o_refclk_on                  (),
    .i_refclk_alt                 (ref_clk),
    // Interrupts
    .i_irq                        ('0),
    .o_irq                        (),
    // General Purpose Bus
    .i_gpb                        ('0),
    .o_gpb                        (),
    // Channel clocks (from primary channel)
    .i_pll_clk_0                  ('0),
    .i_pll_clk_90                 ('0),
    .i_pll_clk_180                ('0),
    .i_pll_clk_270                ('0),
    .i_vco0_clk                   ('0),
    // Channel clocks (to secondary channel)
    .o_pll_clk_0                  (),
    .o_pll_clk_90                 (),
    .o_pll_clk_180                (),
    .o_pll_clk_270                (),
    .o_vco0_clk                   (),
    // TEST
    .i_scan_mode                  ('0),
    .i_scan_clk                   ('0),
    .i_scan_en                    ('0),
    .i_scan_freq_en               ('0),
    .i_scan_cgc_ctrl              ('0),
    .i_scan_rst_ctrl              ('0),
    .i_scan                       ('0),
    .o_scan                       (),
    .i_freeze_n                   (1'b1),
    .i_hiz_n                      (1'b1),
    .i_iddq_mode                  ('0),
    .o_dtst                       (),
    // Power Collapse
    .i_ret_en                     ('0),
    // IFR_FIXME - Connect to support power collapse.
    .i_hs_en                      ('0),
    // IFR_FIXME - Connect to support power collapse.

    // JTAG Interface
    .i_jtag_tck                   ('0),
    .i_jtag_trst_n                ('0),
    .i_jtag_tms                   ('0),
    .i_jtag_tdi                   ('0),
    .o_jtag_tdo                   (),
    // AHB Interface
    .i_ahb_clk                    (ahb_clk),
    .o_ahb_clk_on                 (),
    .i_ahb_rst                    (phy_rst),
    .i_ahb_csr_rst                (phy_rst),
    // AHB Slave
    .i_ahb_haddr                  (ahb_if_haddr),
    .i_ahb_hwrite                 (ahb_if_hwrite),
    .i_ahb_hsel                   (ahb_if_hsel),
    .i_ahb_hreadyin               (ahb_if_hreadyin),
    .i_ahb_hwdata                 (ahb_if_hwdata),
    .i_ahb_htrans                 (ahb_if_htrans),
    .i_ahb_hsize                  (ahb_if_hsize),
    .i_ahb_hburst                 (ahb_if_hburst),
    .o_ahb_hready                 (ahb_if_hready),
    .o_ahb_hrdata                 (ahb_if_hrdata),
    .o_ahb_hresp                  (ahb_if_hresp),
    // AHB Master (to external Slave)
    .o_ahb_haddr                  (),
    .o_ahb_hwrite                 (),
    .o_ahb_hwdata                 (),
    .o_ahb_htrans                 (),
    .o_ahb_hsize                  (),
    .o_ahb_hburst                 (),
    .o_ahb_hbusreq                (),
    .i_ahb_hgrant                 ('0),
    .i_ahb_hready                 ('0),
    .i_ahb_hrdata                 ('0),
    .i_ahb_hresp                  ('0),
    // Update
    .o_dfi_ctrlupd_ack            (),
    .i_dfi_ctrlupd_req            ('0),
    .i_dfi_phyupd_ack             ('0),
    .o_dfi_phyupd_req             (),
    .o_dfi_phyupd_type            (),
    // Status
    .i_dfi_freq_fsp               ('0),
    .i_dfi_freq_ratio             ('0),
    .i_dfi_frequency              ('0),
    .o_dfi_init_complete          (),
    .i_dfi_init_start             ('0),
    // PHY Master
    .i_dfi_phymstr_ack            ('0),
    .o_dfi_phymstr_cs_state       (),
    .o_dfi_phymstr_req            (),
    .o_dfi_phymstr_state_sel      (),
    .o_dfi_phymstr_type           (),
    // Low Power Control
    .o_dfi_lp_ctrl_ack            (),
    .i_dfi_lp_ctrl_req            ('0),
    .i_dfi_lp_ctrl_wakeup         ('0),
    .o_dfi_lp_data_ack            (),
    .i_dfi_lp_data_req            ('0),
    .i_dfi_lp_data_wakeup         ('0),
    .i_dfi_reset_n_p0              (dfi_lpddr4_if.dfi_phase0_lpddr4_if.reset_n),
      .i_dfi_reset_n_p1              (dfi_lpddr4_if.dfi_phase0_lpddr4_if.reset_n),
      .i_dfi_reset_n_p2              (dfi_lpddr4_if.dfi_phase1_lpddr4_if.reset_n),
      .i_dfi_reset_n_p3              (dfi_lpddr4_if.dfi_phase1_lpddr4_if.reset_n),
      .i_dfi_reset_n_p4              (dfi_lpddr4_if.dfi_phase2_lpddr4_if.reset_n),
      .i_dfi_reset_n_p5              (dfi_lpddr4_if.dfi_phase2_lpddr4_if.reset_n),
      .i_dfi_reset_n_p6              (dfi_lpddr4_if.dfi_phase3_lpddr4_if.reset_n),
      .i_dfi_reset_n_p7              (dfi_lpddr4_if.dfi_phase3_lpddr4_if.reset_n),
      .i_dfi_address_p0              (dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca),
      .i_dfi_address_p1              (dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca),
      .i_dfi_address_p2              (dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca),
      .i_dfi_address_p3              (dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca),
      .i_dfi_address_p4              (dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca),
      .i_dfi_address_p5              (dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca),
      .i_dfi_address_p6              (dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca),
      .i_dfi_address_p7              (dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca),
      .i_dfi_cke_p0                  ({dfi_lpddr4_if.dfi_phase0_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase0_lpddr4_if.cke}),
      .i_dfi_cke_p1                  ({dfi_lpddr4_if.dfi_phase0_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase0_lpddr4_if.cke}),
      .i_dfi_cke_p2                  ({dfi_lpddr4_if.dfi_phase1_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase1_lpddr4_if.cke}),
      .i_dfi_cke_p3                  ({dfi_lpddr4_if.dfi_phase1_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase1_lpddr4_if.cke}),
      .i_dfi_cke_p4                  ({dfi_lpddr4_if.dfi_phase2_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase2_lpddr4_if.cke}),
      .i_dfi_cke_p5                  ({dfi_lpddr4_if.dfi_phase2_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase2_lpddr4_if.cke}),
      .i_dfi_cke_p6                  ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase3_lpddr4_if.cke}),
      .i_dfi_cke_p7                  ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.cke,dfi_lpddr4_if.dfi_phase3_lpddr4_if.cke}),
      .i_dfi_cs_p0                   ({dfi_lpddr4_if.dfi_phase0_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase0_lpddr4_if.cs}),
      .i_dfi_cs_p1                   ({dfi_lpddr4_if.dfi_phase0_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase0_lpddr4_if.cs}),
      .i_dfi_cs_p2                   ({dfi_lpddr4_if.dfi_phase1_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase1_lpddr4_if.cs}),
      .i_dfi_cs_p3                   ({dfi_lpddr4_if.dfi_phase1_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase1_lpddr4_if.cs}),
      .i_dfi_cs_p4                   ({dfi_lpddr4_if.dfi_phase2_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase2_lpddr4_if.cs}),
      .i_dfi_cs_p5                   ({dfi_lpddr4_if.dfi_phase2_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase2_lpddr4_if.cs}),
      .i_dfi_cs_p6                   ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase3_lpddr4_if.cs}),
      .i_dfi_cs_p7                   ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase3_lpddr4_if.cs}),

    .i_dfi_dram_clk_disable_p0    ('0),
    .i_dfi_dram_clk_disable_p1    ('0),
    .i_dfi_dram_clk_disable_p2    ('0),
    .i_dfi_dram_clk_disable_p3    ('0),
    .i_dfi_dram_clk_disable_p4    ('0),
    .i_dfi_dram_clk_disable_p5    ('0),
    .i_dfi_dram_clk_disable_p6    ('0),
    .i_dfi_dram_clk_disable_p7    ('0),

    // Write

      .i_dfi_parity_in_p0            ('d0),
      .i_dfi_parity_in_p1            ('d0),
      .i_dfi_parity_in_p2            ('d0),
      .i_dfi_parity_in_p3            ('d0),
      .i_dfi_parity_in_p4            ('d0),
      .i_dfi_parity_in_p5            ('d0),
      .i_dfi_parity_in_p6            ('d0),
      .i_dfi_parity_in_p7            ('d0),

      .i_dfi_wrdata_cs_p0            (1'b1),
      .i_dfi_wrdata_cs_p1            (1'b1),
      .i_dfi_wrdata_cs_p2            (1'b1),
      .i_dfi_wrdata_cs_p3            (1'b1),
      .i_dfi_wrdata_cs_p4            (1'b1),
      .i_dfi_wrdata_cs_p5            (1'b1),
      .i_dfi_wrdata_cs_p6            (1'b1),
      .i_dfi_wrdata_cs_p7            (1'b1),

    .i_dfi_wck_cs_p0              ('0),
    .i_dfi_wck_cs_p1              ('0),
    .i_dfi_wck_cs_p2              ('0),
    .i_dfi_wck_cs_p3              ('0),
    .i_dfi_wck_cs_p4              ('0),
    .i_dfi_wck_cs_p5              ('0),
    .i_dfi_wck_cs_p6              ('0),
    .i_dfi_wck_cs_p7              ('0),

      .i_dfi_wrdata_mask_p0          (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_mask[3:0]),
      .i_dfi_wrdata_mask_p1          (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_mask[7:4]),
      .i_dfi_wrdata_mask_p2          (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_mask[3:0]),
      .i_dfi_wrdata_mask_p3          (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_mask[7:4]),
      .i_dfi_wrdata_mask_p4          (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_mask[3:0]),
      .i_dfi_wrdata_mask_p5          (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_mask[7:4]),
      .i_dfi_wrdata_mask_p6          (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_mask[3:0]),
      .i_dfi_wrdata_mask_p7          (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_mask[7:4]),

      .i_dfi_wrdata_p0               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata[31:0]),
      .i_dfi_wrdata_p1               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata[63:32]),
      .i_dfi_wrdata_p2               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata[31:0]),
      .i_dfi_wrdata_p3               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata[63:32]),
      .i_dfi_wrdata_p4               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata[31:0]),
      .i_dfi_wrdata_p5               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata[63:32]),
      .i_dfi_wrdata_p6               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata[31:0]),
      .i_dfi_wrdata_p7               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata[63:32]),

      .i_dfi_wrdata_en_p0            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p1            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p2            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p3            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p4            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p5            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p6            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p7            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_en),

    .i_dfi_wck_en_p0              ('0),
    .i_dfi_wck_en_p1              ('0),
    .i_dfi_wck_en_p2              ('0),
    .i_dfi_wck_en_p3              ('0),
    .i_dfi_wck_en_p4              ('0),
    .i_dfi_wck_en_p5              ('0),
    .i_dfi_wck_en_p6              ('0),
    .i_dfi_wck_en_p7              ('0),

    .i_dfi_wck_toggle_p0          ('0),
    .i_dfi_wck_toggle_p1          ('0),
    .i_dfi_wck_toggle_p2          ('0),
    .i_dfi_wck_toggle_p3          ('0),
    .i_dfi_wck_toggle_p4          ('0),
    .i_dfi_wck_toggle_p5          ('0),
    .i_dfi_wck_toggle_p6          ('0),
    .i_dfi_wck_toggle_p7          ('0),
    // Read Data
      .i_dfi_rddata_cs_p0            (1'b1),
      .i_dfi_rddata_cs_p1            (1'b1),
      .i_dfi_rddata_cs_p2            (1'b1),
      .i_dfi_rddata_cs_p3            (1'b1),
      .i_dfi_rddata_cs_p4            (1'b1),
      .i_dfi_rddata_cs_p5            (1'b1),
      .i_dfi_rddata_cs_p6            (1'b1),
      .i_dfi_rddata_cs_p7            (1'b1),

      .i_dfi_rddata_en_p0            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p1            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p2            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p3            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p4            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p5            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p6            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_en),
      .i_dfi_rddata_en_p7            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_en),
      .o_dfi_rddata_w0               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w1               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w2               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w3               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w4               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w5               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w6               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w7               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata[63:32]),
    .o_dfi_rddata_dbi_w0          (),
    .o_dfi_rddata_dbi_w1          (),
    .o_dfi_rddata_dbi_w2          (),
    .o_dfi_rddata_dbi_w3          (),
    .o_dfi_rddata_dbi_w4          (),
    .o_dfi_rddata_dbi_w5          (),
    .o_dfi_rddata_dbi_w6          (),
    .o_dfi_rddata_dbi_w7          (),
      .o_dfi_rddata_valid_w0         (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w1         (),
      .o_dfi_rddata_valid_w2         (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w3         (),
      .o_dfi_rddata_valid_w4         (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w5         (),
      .o_dfi_rddata_valid_w6         (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w7         (),
    //RDI mainband
    .lp_data               ('0),
    .lp_valid              ('0),
    .lp_irdy               ('0),
    .pl_trdy               (),
    .pl_data               (),
    .pl_valid              (),
    //RDI sideband
    .lp_cfg                ('0),
    .lp_cfg_vld            ('0),
    .lp_cfg_crd            ('0),
    .pl_cfg                (),
    .pl_cfg_vld            (),
    .pl_cfg_crd            (),
    // Pads
    .pad_reset_n                  (pad_reset_n),
    // Reset pad
    .pad_rext                     (pad_rext),
    .pad_test                     (pad_test),
    // TEST pad
    .pad_ch0_ck_t                 (pad_ch0_ck_t),
    // CK
    .pad_ch0_ck_c                 (pad_ch0_ck_c),
    // CK
    .pad_ch0_ca                   (pad_ch0_ca),
    // CA/CS/CKE
    .pad_ch0_wck_t                (),
    // WCK
    .pad_ch0_wck_c                (),
    // WCK
    .pad_ch0_dqs_t                (pad_ch0_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch0_dqs_c                (pad_ch0_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch0_dq                   (pad_ch0_dq),
    // DQ/DBI/DM/PARITY
    .pad_ch1_ck_t                 (pad_ch1_ck_t),
    // CK
    .pad_ch1_ck_c                 (pad_ch1_ck_c),
    // CK
    .pad_ch1_ca                   (pad_ch1_ca),
    // CA/CS/CKE
    .pad_ch1_wck_t                (),
    // WCK
    .pad_ch1_wck_c                (),
    // WCK
    .pad_ch1_dqs_t                (pad_ch1_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch1_dqs_c                (pad_ch1_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch1_dq                   (pad_ch1_dq),
    // DQ/DBI/DM/PARITY
    //Debug
    .o_debug                      ()
);

// ----------------------------------------------------
// memory model
wire CH0_CK_t;
wire CH0_CK_c;

assign CH0_CK_t=pad_ch0_ck_t;
assign CH0_CK_c=pad_ch0_ck_c;

wire CH1_CK_t;
wire CH1_CK_c;

assign CH1_CK_t=pad_ch1_ck_t;
assign CH1_CK_c=pad_ch1_ck_c;

L4_Model u_L4_Model_ch0 (
    .CA_A        (pad_ch0_ca[5:0]),
    .CKE_A       (pad_ch0_ca[7]),
    .CK_c_A      (CH0_CK_c),
    .CK_t_A      (CH0_CK_t),
    .CS_A        (pad_ch0_ca[6]),
    .DMI_A       ({pad_ch0_dq[17],pad_ch0_dq[8]}),
    .DQ_A        ({pad_ch0_dq[16:9],pad_ch0_dq[7:0]}),
    .DQS_t_A     (pad_ch0_dqs_t),
    .DQS_c_A     (pad_ch0_dqs_c),
    .ODT_CA_A    (pad_rext),
    .RESET       (pad_reset_n)
); 

L4_Model u_L4_Model_ch1 (
    .CA_A        (pad_ch1_ca[5:0]),
    .CKE_A       (pad_ch1_ca[7]),
    .CK_c_A      (CH1_CK_c),
    .CK_t_A      (CH1_CK_t),
    .CS_A        (pad_ch1_ca[6]),
    .DMI_A       ({pad_ch1_dq[17],pad_ch1_dq[8]}),
    .DQ_A        ({pad_ch1_dq[16:9],pad_ch1_dq[7:0]}),
    .DQS_t_A     (pad_ch1_dqs_t),
    .DQS_c_A     (pad_ch1_dqs_c),
    .ODT_CA_A    (pad_rext),
    .RESET       (pad_reset_n)
); 





// ----------------------------------------------------



// ----------------------------------------------------
//dma


mosi_native mosi_native_inst0(
  .clk_i      (phy_clk),
  .rst_n      (~mc_rst),
  .enable     (1'b1),
  
  .clr_i      (1'b0),
  .irq      (),
  .mosi     (my_mosi_0),
  .native   (my_native_0)
);

assign  my_native_0.rdata_payload_data_i = native_if_0.rdata_payload_data;
assign  my_native_0.ncmd_ready_i = native_if_0.native_cmd_ready; 
assign  my_native_0.wdata_ready_i = native_if_0.wdata_ready; 
assign  my_native_0.rdata_valid_i = native_if_0.rdata_valid; 

assign  native_if_0.native_cmd_valid  =   my_native_0.ncmd_valid_o ;
assign  native_if_0.native_cmd_first  =      1'b0;
assign  native_if_0.native_cmd_last   =     1'b0 ;
assign  native_if_0.native_cmd_payload_we  =    my_native_0.ncmd_payload_we_o   ;
assign  native_if_0.native_cmd_payload_mw  =    my_native_0.ncmd_payload_mw_o    ;
assign  native_if_0.native_cmd_payload_addr  =  my_native_0.ncmd_payload_addr_o  ;
assign  native_if_0.wdata_valid  =   my_native_0.wdata_valid_o  ;
assign  native_if_0.wdata_first  =   1'b0       ;
assign  native_if_0.wdata_last  =     1'b0  ;
assign  native_if_0.rdata_ready  =     my_native_0.rdata_ready_o     ;
assign  native_if_0.wdata_payload_data  = my_native_0.wdata_payload_data_o   ;
assign  native_if_0.wdata_payload_we  =    my_native_0.wdata_payload_we_o ;




assign  my_mosi_0.rst = mc_rst; 
assign  my_mosi_0.clk = phy_clk; 
// ----------------------------------------------------

mosi_native mosi_native_inst1(
  .clk_i      (phy_clk),
  .rst_n      (~mc_rst),
  .enable     (1'b1),
  
  .clr_i      (1'b0),
  .irq      (),
  .mosi     (my_mosi_1),
  .native   (my_native_1)
);

assign  my_native_1.rdata_payload_data_i = native_if_1.rdata_payload_data;
assign  my_native_1.ncmd_ready_i = native_if_1.native_cmd_ready; 
assign  my_native_1.wdata_ready_i = native_if_1.wdata_ready; 
assign  my_native_1.rdata_valid_i = native_if_1.rdata_valid; 
assign  my_mosi_1.rst = mc_rst; 
assign  my_mosi_1.clk = phy_clk; 


assign  native_if_1.native_cmd_valid  =   my_native_1.ncmd_valid_o ;
assign  native_if_1.native_cmd_first  =      1'b0;
assign  native_if_1.native_cmd_last   =     1'b0 ;
assign  native_if_1.native_cmd_payload_we  =    my_native_1.ncmd_payload_we_o   ;
assign  native_if_1.native_cmd_payload_mw  =    my_native_1.ncmd_payload_mw_o    ;
assign  native_if_1.native_cmd_payload_addr  =  my_native_1.ncmd_payload_addr_o  ;
assign  native_if_1.wdata_valid  =   my_native_1.wdata_valid_o  ;
assign  native_if_1.wdata_first  =   1'b0       ;
assign  native_if_1.wdata_last  =     1'b0  ;
assign  native_if_1.rdata_ready  =     my_native_1.rdata_ready_o     ;
assign  native_if_1.wdata_payload_data  = my_native_1.wdata_payload_data_o   ;
assign  native_if_1.wdata_payload_we  =    my_native_1.wdata_payload_we_o ;



// ----------------------------------------------------
//initial
logic [31:0] xmit_address_q [$];
logic [511:0] xmit_data_q [$];

int run_for_n_pkts;

    initial begin
        ref_clk<=0;
    end

// ----------------------------------------------------
    initial begin 
        $vcdpluson(0,mc_top_tb);
        run_for_n_pkts=1;
        mc_rst<=1;
        phy_rst <= 1;
        repeat(5) @(negedge ref_clk);
        phy_rst <= 0;
        $display ("[%t] #########  Exit Reset #############", $time);
        $display ("[%t] #########  Start PHY LPDDR4 Mode Test #########",$time);
`ifdef MCU_CTRL
        $display ("[%t] #########  Begin loading SRAM #############", $time);
        u_sram_loader.begin_transfer();
        repeat (100) @(posedge mc_top_tb.ref_clk);
        u_sram_loader.ahb_write(32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(32'h00090024,32'h00000100);
        u_sram_loader.ahb_write(32'h00000004, 32'h1);
        repeat (100000) @(posedge mc_top_tb.ref_clk);
`else
        //set reset_n=0;
        u_sram_loader.ahb_write(32'h00090054,32'h00000001);
        ibias_ldo_initialize();
        #10;
        ZQ_calibration();
        #10;
        pll_initialize_0p8();
        //pll_initialize_2p1();
        #10;
        link_initialize();
        #10;
        delay_calibration();
        #10;
        rxfifo_clr();
        #10;
        dram_initialize();
        #10;
        rxfifo_clr();
        @(posedge phy_clk);
        mc_initialize();
        @(negedge phy_clk);
        mc_rst<=0;
        $display ("[%t] #########  Initialization Done #############", $time);
        repeat (100) @(posedge mc_top_tb.phy_clk);
        $display ("[%t] #########  Begin DRAM Data Write #############", $time);
        //data_write_0();
        ->begin_write;
        repeat (10) @(posedge mc_top_tb.phy_clk);
        $display ("[%t] #########  Finish DRAM Data Write #############", $time);
        $display ("[%t] #########  Begin DRAM Data Read #############", $time);
        //data_read_0();
        ->begin_read;
        repeat (10) @(posedge mc_top_tb.phy_clk);
        $display ("[%t] #########  Finish DRAM Data Read #############", $time);
        repeat (100) @(posedge mc_top_tb.phy_clk);
`endif
        Finish ();
    end

int err_count;

// ----------------------------------------------------
//stop sim
task Finish ();
begin
	$display("%0t: %m: finishing simulation..", $time);
	repeat (10) @(posedge mc_top_tb.ref_clk);
	$display("\n////////////////////////////////////////////////////////////////////////////");
	$display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	$display("////////////////////////////////////////////////////////////////////////////\n");
    if (err_count == 0) begin
        $display("+++++++++++++++++++++++++++++++++\n");
        $display("TEST PASSED!!!!!!!!!!!\n");
        $display("+++++++++++++++++++++++++++++++++\n");
    end
//$finish;
end
endtask
// ----------------------------------------------------
//ahb
bit [31:0] ahb_rdata;

task rxfifo_clr();
    begin
        u_sram_loader.ahb_write(32'h00110000,32'h00000100); //CH0_CA__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h000F0000,32'h00000100); //CH0_DQ0__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00100000,32'h00000100); //CH0_DQ1__TOP_CFG  (set FIFO_CLR=1)

        u_sram_loader.ahb_write(32'h00110000,32'h00000000); //CH0_CA__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h000F0000,32'h00000000); //CH0_DQ0__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00100000,32'h00000000); //CH0_DQ1__TOP_CFG  (set FIFO_CLR=0)

        u_sram_loader.ahb_write(32'h00140000,32'h00000100); //CH1_CA__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00120000,32'h00000100); //CH1_DQ0__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00130000,32'h00000100); //CH1_DQ1__TOP_CFG  (set FIFO_CLR=1)

        u_sram_loader.ahb_write(32'h00140000,32'h00000000); //CH1_CA__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00120000,32'h00000000); //CH1_DQ0__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00130000,32'h00000000); //CH1_DQ1__TOP_CFG  (set FIFO_CLR=0)
    end
endtask



task delay_calibration();
    begin
        bit [31:0] ch0_dq0_fc_dly;
        bit [31:0] ch0_dq1_fc_dly;
        bit [31:0] ch1_dq0_fc_dly;
        bit [31:0] ch1_dq1_fc_dly;

        bit [31:0] ch0_dqs0_fc_dly;
        bit [31:0] ch0_dqs1_fc_dly;
        bit [31:0] ch1_dqs0_fc_dly;
        bit [31:0] ch1_dqs1_fc_dly;

        bit [31:0] ch0_ca_fc_dly;
        bit [31:0] ch1_ca_fc_dly;

        ch0_dq0_fc_dly={8{4'd2}};
        ch0_dq1_fc_dly={8{4'd2}};
        ch1_dq0_fc_dly={8{4'd2}};
        ch1_dq1_fc_dly={8{4'd2}};


        ch0_dqs0_fc_dly={8{4'd1}};
        ch0_dqs1_fc_dly={8{4'd1}};//11111111
        ch1_dqs0_fc_dly={8{4'd1}};
        ch1_dqs1_fc_dly={8{4'd1}};

        ch0_ca_fc_dly={8{4'd1}};
        ch1_ca_fc_dly={8{4'd1}};

        //reset clock divider
        u_sram_loader.ahb_write(32'h000A0030,32'h00000080); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        u_sram_loader.ahb_read(32'h000A0030,ahb_rdata); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        while(ahb_rdata[7]!=1) begin
            u_sram_loader.ahb_read(32'h000A0030,ahb_rdata);
        end
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000); //FSW_CSP_1_CFG  div_rst_ovr_value=0

        //REN/RCS phase extension
        u_sram_loader.ahb_write(32'h000D0090,32'h02020202); //DFICH0__CTRL5_M0_CFG
        u_sram_loader.ahb_write(32'h000D0094,32'h02020202); //DFICH0__CTRL5_M1_CFG

        //WCS/WEN/WOE phase extension
        u_sram_loader.ahb_write(32'h000D0080,32'h000D0D00); //_DFICH0__CTRL3_M0_CFG
        u_sram_loader.ahb_write(32'h000D0084,32'h000D0D00); //_DFICH0__CTRL3_M1_CFG

        //CH0
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0410,ch0_dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0434,ch0_dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100410,ch0_dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100434,ch0_dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120410,ch1_dq0_fc_dly); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120434,ch1_dq0_fc_dly); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130410,ch1_dq1_fc_dly); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130434,ch1_dq1_fc_dly); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH0 DQS FC delay
        //DQS0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0AC0,ch0_dqs0_fc_dly); //CH0_DQ0_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0AE4,ch0_dqs0_fc_dly); //CH0_DQ0_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100AC0,ch0_dqs1_fc_dly); //CH0_DQ1_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100AE4,ch0_dqs1_fc_dly); //CH0_DQ1_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1 DQS FC delay
        //DQS0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120AC0,ch1_dqs0_fc_dly); //CH1_DQ0_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120AE4,ch1_dqs0_fc_dly); //CH1_DQ0_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130AC0,ch1_dqs1_fc_dly); //CH1_DQ1_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130AE4,ch1_dqs1_fc_dly); //CH1_DQ1_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8


        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0B50,32'hf); //f //CH0_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0B74,32'hf); //CH0_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00100B50,32'hf); //CH0_DD1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100B74,32'hf); //CH0_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00120B50,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120B74,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00130B50,32'hf); //CH1_DQ1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130B74,32'hf); //3 //CH1_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8

        //CH0 CA FC_DLY
        //CH0 CK FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h001104D8,ch0_ca_fc_dly); //CH0_CA__DQ_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write_all_lane(32'h001105D4,ch0_ca_fc_dly); //CH0_CA__DQ_TX_SDR_FC_DLY_M0_R1_CFG_0

        u_sram_loader.ahb_write(32'h00110AB8,ch0_ca_fc_dly); //CH0_CA__DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00110ABC,ch0_ca_fc_dly); //CH0_CA__DQS_TX_SDR_FC_DLY_M0_R1_CFG_0

        //CH1 CA/CK FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h001404D8,ch1_ca_fc_dly); //CH1_CA__DQ_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write_all_lane(32'h001405D4,ch1_ca_fc_dly); //CH1_CA__DQ_TX_SDR_FC_DLY_M0_R1_CFG_0

        u_sram_loader.ahb_write(32'h00140AB8,ch1_ca_fc_dly); //CH1_CA__DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00140ABC,ch1_ca_fc_dly); //CH1_CA__DQS_TX_SDR_FC_DLY_M0_R1_CFG_0

        //DQS RX Delay
        u_sram_loader.ahb_write(32'h000F081C,32'h0000AFAF); //Ch0_DQ0_DQS_TX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h0010081C,32'h0000AFAF); //Ch0_DQ1_DQS_TX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0824,32'h0000AFAF); //Ch0_DQ0_DQS_TX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100824,32'h0000AFAF); //Ch0_DQ1_DQS_TX_IO_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h0012081C,32'h0000AFAF); //Ch1_DQ0_DQS_TX_IO_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h0013081C,32'h0000AFAF); //Ch1_DQ1_DQS_TX_IO_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00120824,32'h0000AFAF); //Ch1_DQ0_DQS_TX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00130824,32'h0000AFAF); //Ch1_DQ1_DQS_TX_IO_M0_R1_CFG_1

        //DQ LPDE
        u_sram_loader.ahb_write_all_lane(32'h000F06E0,32'h000001FF); //CH0_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0704,32'h000001FF); //CH0_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001006E0,32'h000001FF); //CH0_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100704,32'h000001FF); //CH0_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001206E0,32'h000001FF); //CH1_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120704,32'h000001FF); //CH1_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001306E0,32'h000001FF); //CH1_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130704,32'h000001FF); //CH1_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        //DQS LPDE
        u_sram_loader.ahb_write(32'h000F0D94,32'h00000100); //Ch0_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00100D94,32'h00000100); //Ch0_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0D9C,32'h00000100); //Ch0_DQ0_DQS_TX_LPDE_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100D9C,32'h00000100); //Ch0_DQ1_DQS_TX_LPDE_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h00120D94,32'h00000100); //Ch1_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00130D94,32'h00000100); //Ch1_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00120D9C,32'h00000100); //Ch1_DQ0_DQS_TX_LPDE_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00130D9C,32'h00000100); //Ch1_DQ1_DQS_TX_LPDE_M0_R1_CFG_1

        //CK LPDE
        u_sram_loader.ahb_write(32'h00110B08,32'h0000013F); //Ch0_CA_DQS_TX_LPDE_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00140B08,32'h0000013F); //Ch1_CA_DQS_TX_LPDE_M0_R0_CFG_0

    end
endtask


bit [447:0]  egress_data_from_dp;


task mc_initialize();
    begin
        $display ("[%t] #########  Memory Controller Initialize   #########",$time);
        u_mc_sram_loader.ahb_write(32'h02000000,32'h02100705); //rdphase_cfg=1 wrphase_cfg=1
        u_mc_sram_loader.ahb_write(32'h02000014,32'h0000030C); //crb_WRITE_LATENCY_cfg=3
        u_mc_sram_loader.ahb_write(32'h02000018,32'h00C00205); //dfi_wdqs_preamble_cfg=0xc0  dfi_wrdata_en_latency_cfg=2 dfi_rddata_en_latency_cfg=5
    end
endtask

task dram_initialize();
    begin
        $display ("[%t] #########  DRAM Initializing   #########",$time);
        //set reset_n=0;
        $display ("[%t] #########  Release DRAM Reset_n   #########",$time);
        u_sram_loader.ahb_write(32'h00090054,32'h00000000);
        $display ("[%t] #########  Enable CK toggling   #########",$time);
        CKE_initialize();
        #100;//should be 2 us
        $display ("[%t] #########  Mode Register Write/Read   #########",$time);
        MRW(1,8'b1010_1100); //RD postample=1.5*tCK nWR=16 RD_PRE=toggle
        repeat(10) @(posedge ref_clk);
        MRW(2,8'b0001_0010); //RL=14 WL=8
        repeat(10) @(posedge ref_clk);
        MRR(0,0);
        read_dfi_egress_data(egress_data_from_dp);
        //MRR(0,0);
        //read_dfi_egress_data(egress_data_from_dp);
        //turn off buff mode
        u_sram_loader.ahb_write(32'h000D0000,32'h000C2020);
    end
endtask


task MRR();
    input [5:0] ma;  // Mode Register address
    input [9:0] addr;
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f0f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,1'b0,5'b01110}  //dfi_address_p01
        ,{1'b0,ma[5:0]}         //dfi_address_p23
        ,{1'b0,addr[8],5'b10010}  //dfi_address_p45
        ,{1'b0,addr[7:2]}         //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h5//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hC0                  //dfi_rddata_en_pN p3
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h6//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h7//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h0f                  //dfi_rddata_en_pN p3 p2 
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h8//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end
endtask


task MRW();
    input [5:0] ma;  // Mode Register address
    input [7:0] op;
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f0f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,op[7],5'b00110}  //dfi_address_p01
        ,{1'b0,ma[5:0]}         //dfi_address_p23
        ,{1'b0,op[6],5'b10110}  //dfi_address_p45
        ,{1'b0,op[5:0]}         //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end
endtask



task CKE_initialize();
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h00002132); //TS_EN=0, TS_RESET=1, WDATA_CLR=1, WDATA_HOLD=1, RDATA_CLR=1, BUF_CLK_EN=1
        u_sram_loader.ahb_write(32'h000D0000,32'h00002020); //TS_EN=0, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h10//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'h0000               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'h0000               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
    end

    u_sram_loader.ahb_write(32'h000D0000,32'h00003021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
endtask




task read_dfi_egress_data;
    output [447:0] egress_data; //423
    bit init_en_sta;
    bit init_upd_sta;
    bit eg_en;
    bit read_done;
    bit [31:0] other_csr;
    u_sram_loader.ahb_read(32'h000D0000,ahb_rdata);
    other_csr=ahb_rdata;
    init_en_sta=ahb_rdata[9];
    init_upd_sta=ahb_rdata[10];
    eg_en=init_en_sta;
    u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    while(ahb_rdata[5:4]==2'b01) begin
        u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    end
    read_done=ahb_rdata[6];
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_empty==1'b0);
    u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:11],~init_upd_sta,other_csr[9:0]}); //rdata_upd=toggle
    u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    while(ahb_rdata[6]==read_done) begin
        u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    end
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_read_done==1'b1);
    for(int i=0;i<=13;i++) begin
        eg_en=~eg_en;
        u_sram_loader.ahb_read(32'h000D0014,egress_data[i*32+:32]);
        //egress_data[i*32+:32]=lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_rdata;
        u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:11],~init_upd_sta,eg_en,other_csr[8:0]}); //rdata_en=toggle
        u_sram_loader.wait_until_empty();
        //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b1);
        //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b0);
    end
    $display ("[%t] Read Egress Data:.",$time);
    $display (" Timestamp %h.",egress_data[423:408]);
    $display (" dfi_cs_p0[1:0]=2'b%b.",egress_data[407:406]);
    $display (" dfi_cs_p1[1:0]=2'b%b.",egress_data[396:395]);
    $display (" dfi_cs_p2[1:0]=2'b%b.",egress_data[385:384]);
    $display (" dfi_cs_p3[1:0]=2'b%b.",egress_data[374:373]);
    $display (" dfi_cs_p4[1:0]=2'b%b.",egress_data[363:362]);
    $display (" dfi_cs_p5[1:0]=2'b%b.",egress_data[352:351]);
    $display (" dfi_cs_p6[1:0]=2'b%b.",egress_data[341:340]);
    $display (" dfi_cs_p7[1:0]=2'b%b.",egress_data[330:329]);

    $display (" dfi_cke_p0[1:0]=2'b%b.",egress_data[405:404]);
    $display (" dfi_cke_p1[1:0]=2'b%b.",egress_data[394:393]);
    $display (" dfi_cke_p2[1:0]=2'b%b.",egress_data[383:382]);
    $display (" dfi_cke_p3[1:0]=2'b%b.",egress_data[372:371]);
    $display (" dfi_cke_p4[1:0]=2'b%b.",egress_data[361:360]);
    $display (" dfi_cke_p5[1:0]=2'b%b.",egress_data[350:349]);
    $display (" dfi_cke_p6[1:0]=2'b%b.",egress_data[339:338]);
    $display (" dfi_cke_p7[1:0]=2'b%b.",egress_data[328:327]);

    $display (" dfi_address_p0[6:0]=7'b%b.",egress_data[403:397]);
    $display (" dfi_address_p1[6:0]=7'b%b.",egress_data[392:386]);
    $display (" dfi_address_p2[6:0]=7'b%b.",egress_data[381:375]);
    $display (" dfi_address_p3[6:0]=7'b%b.",egress_data[370:364]);
    $display (" dfi_address_p4[6:0]=7'b%b.",egress_data[359:353]);
    $display (" dfi_address_p5[6:0]=7'b%b.",egress_data[348:342]);
    $display (" dfi_address_p6[6:0]=7'b%b.",egress_data[337:331]);
    $display (" dfi_address_p7[6:0]=7'b%b.",egress_data[326:320]);

    $display (" dq0_rdata_valid_p7-0[7:0]=8'b%b.",{egress_data[319],egress_data[309],egress_data[299],egress_data[289],
                                                    egress_data[279],egress_data[269],egress_data[259],egress_data[249]});
    $display (" dq0_rdata_dbi_p7-0[7:0]=8'b%b.",{egress_data[318],egress_data[308],egress_data[298],egress_data[288]
                                                    ,egress_data[278],egress_data[268],egress_data[258],egress_data[248]});
    $display (" dq0_rdata_p7-0[63:0]=0x%h.",{egress_data[317:310],egress_data[307:300]
                                            ,egress_data[297:290],egress_data[287:280]
                                            ,egress_data[277:270],egress_data[267:260]
                                            ,egress_data[257:250],egress_data[247:240]});
    
    $display (" dq1_rdata_valid_p7-0[7:0]=8'b%b.",{egress_data[239],egress_data[229],egress_data[219],egress_data[209],
                                                    egress_data[199],egress_data[189],egress_data[179],egress_data[169]});
    $display (" dq1_rdata_dbi_p7-0[7:0]=8'b%b.",{egress_data[238],egress_data[228],egress_data[218],egress_data[208]
                                                    ,egress_data[198],egress_data[188],egress_data[178],egress_data[168]});
    $display (" dq1_rdata_p7-0[63:0]=0x%h.",{egress_data[237:230],egress_data[227:220]
                                            ,egress_data[217:210],egress_data[207:200]
                                            ,egress_data[197:190],egress_data[187:180]
                                            ,egress_data[177:170],egress_data[167:160]});

    $display (" dq2_rdata_valid_p7-0[7:0]=8'b%b.",{egress_data[159],egress_data[149],egress_data[139],egress_data[129],
                                                    egress_data[119],egress_data[109],egress_data[99],egress_data[89]});
    $display (" dq2_rdata_dbi_p7-0[7:0]=8'b%b.",{egress_data[158],egress_data[148],egress_data[138],egress_data[128]
                                                    ,egress_data[118],egress_data[108],egress_data[98],egress_data[88]});
    $display (" dq2_rdata_p7-0[63:0]=0x%h.",{egress_data[157:150],egress_data[147:140]
                                            ,egress_data[137:130],egress_data[127:120]
                                            ,egress_data[117:110],egress_data[107:100]
                                            ,egress_data[97:90],egress_data[87:80]});

    $display (" dq3_rdata_valid_p7-0[7:0]=8'b%b.",{egress_data[79],egress_data[69],egress_data[59],egress_data[49],
                                                    egress_data[39],egress_data[29],egress_data[19],egress_data[9]});
    $display (" dq3_rdata_dbi_p7-0[7:0]=8'b%b.",{egress_data[78],egress_data[68],egress_data[58],egress_data[48]
                                                    ,egress_data[38],egress_data[28],egress_data[18],egress_data[8]});
    $display (" dq3_rdata_p7-0[63:0]=0x%h.",{egress_data[77:70],egress_data[67:60]
                                            ,egress_data[57:50],egress_data[47:40]
                                            ,egress_data[37:30],egress_data[27:20]
                                            ,egress_data[17:10],egress_data[7:0]});
endtask

task send_dfi_ingress_data;
    input [15:0] timestamp;
    input [7:0] dfi_dce_pN;
    input [15:0] dfi_cs_pN;
    input [15:0] dfi_cke_pN;
    input [6:0] dfi_address_p01;
    input [6:0] dfi_address_p23;
    input [6:0] dfi_address_p45;
    input [6:0] dfi_address_p67;
    input [7:0] dfi_rddata_en_pN;
    input [15:0] dfi_rddata_cs_pN;
    input [7:0] dfi_wrdata_en_pN;
    input [7:0] dfi_parity_in_pN;
    input [15:0] dfi_wrdata_cs_pN;
    input [31:0] dfi_wrdata_mask_pN;
    input [255:0] dfi_wrdata_pN;
    bit [511:0] ingress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit [31:0] other_csr;
    bit ig_en;
    bit init_done_sta;
    ingress_data={16'd0,timestamp,
                dfi_dce_pN[0],
                dfi_cs_pN[1:0],
                dfi_cke_pN[1:0],
                dfi_address_p01,
                dfi_dce_pN[1],
                dfi_cs_pN[3:2],
                dfi_cke_pN[3:2],
                dfi_address_p01,
                dfi_dce_pN[2],
                dfi_cs_pN[5:4],
                dfi_cke_pN[5:4],
                dfi_address_p23,
                dfi_dce_pN[3],
                dfi_cs_pN[7:6],
                dfi_cke_pN[7:6],
                dfi_address_p23,
                dfi_dce_pN[4],
                dfi_cs_pN[9:8],
                dfi_cke_pN[9:8],
                dfi_address_p45,
                dfi_dce_pN[5],
                dfi_cs_pN[11:10],
                dfi_cke_pN[11:10],
                dfi_address_p45,
                dfi_dce_pN[6],
                dfi_cs_pN[13:12],
                dfi_cke_pN[13:12],
                dfi_address_p67,
                dfi_dce_pN[7],
                dfi_cs_pN[15:14],
                dfi_cke_pN[15:14],
                dfi_address_p67
      //p0
      ,dfi_rddata_en_pN[0]
      ,dfi_rddata_cs_pN[1:0]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[0]
      ,dfi_parity_in_pN[0]
      ,dfi_wrdata_cs_pN[1:0]
      ,dfi_wrdata_mask_pN[0]
      ,dfi_wrdata_pN[7:0]
      ,dfi_wrdata_mask_pN[1]
      ,dfi_wrdata_pN[15:8]
      ,dfi_wrdata_mask_pN[2]
      ,dfi_wrdata_pN[23:16]
      ,dfi_wrdata_mask_pN[3]
      ,dfi_wrdata_pN[31:24]
      //p1
      ,dfi_rddata_en_pN[1]
      ,dfi_rddata_cs_pN[3:2]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[1]
      ,dfi_parity_in_pN[1]
      ,dfi_wrdata_cs_pN[3:2]
      ,dfi_wrdata_mask_pN[4]
      ,dfi_wrdata_pN[39:32]
      ,dfi_wrdata_mask_pN[5]
      ,dfi_wrdata_pN[47:40]
      ,dfi_wrdata_mask_pN[6]
      ,dfi_wrdata_pN[55:48]
      ,dfi_wrdata_mask_pN[7]
      ,dfi_wrdata_pN[63:56]
      //p2
      ,dfi_rddata_en_pN[2]
      ,dfi_rddata_cs_pN[5:4]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[2]
      ,dfi_parity_in_pN[2]
      ,dfi_wrdata_cs_pN[5:4]
      ,dfi_wrdata_mask_pN[8]
      ,dfi_wrdata_pN[71:64]
      ,dfi_wrdata_mask_pN[9]
      ,dfi_wrdata_pN[79:72]
      ,dfi_wrdata_mask_pN[10]
      ,dfi_wrdata_pN[87:80]
      ,dfi_wrdata_mask_pN[11]
      ,dfi_wrdata_pN[95:88]
      //p3
      ,dfi_rddata_en_pN[3]
      ,dfi_rddata_cs_pN[7:6]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[3]
      ,dfi_parity_in_pN[3]
      ,dfi_wrdata_cs_pN[7:6]
      ,dfi_wrdata_mask_pN[12]
      ,dfi_wrdata_pN[103:96]
      ,dfi_wrdata_mask_pN[13]
      ,dfi_wrdata_pN[111:104]
      ,dfi_wrdata_mask_pN[14]
      ,dfi_wrdata_pN[119:112]
      ,dfi_wrdata_mask_pN[15]
      ,dfi_wrdata_pN[127:120]
      //p4
      ,dfi_rddata_en_pN[4]
      ,dfi_rddata_cs_pN[9:8]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[4]
      ,dfi_parity_in_pN[4]
      ,dfi_wrdata_cs_pN[9:8]
      ,dfi_wrdata_mask_pN[16]
      ,dfi_wrdata_pN[135:128]
      ,dfi_wrdata_mask_pN[17]
      ,dfi_wrdata_pN[143:136]
      ,dfi_wrdata_mask_pN[18]
      ,dfi_wrdata_pN[151:144]
      ,dfi_wrdata_mask_pN[19]
      ,dfi_wrdata_pN[159:152]
      //p5
      ,dfi_rddata_en_pN[5]
      ,dfi_rddata_cs_pN[11:10]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[5]
      ,dfi_parity_in_pN[5]
      ,dfi_wrdata_cs_pN[11:10]
      ,dfi_wrdata_mask_pN[20]
      ,dfi_wrdata_pN[167:160]
      ,dfi_wrdata_mask_pN[21]
      ,dfi_wrdata_pN[175:168]
      ,dfi_wrdata_mask_pN[22]
      ,dfi_wrdata_pN[183:176]
      ,dfi_wrdata_mask_pN[23]
      ,dfi_wrdata_pN[191:184]
      //p6
      ,dfi_rddata_en_pN[6]
      ,dfi_rddata_cs_pN[13:12]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[6]
      ,dfi_parity_in_pN[6]
      ,dfi_wrdata_cs_pN[13:12]
      ,dfi_wrdata_mask_pN[24]
      ,dfi_wrdata_pN[199:192]
      ,dfi_wrdata_mask_pN[25]
      ,dfi_wrdata_pN[207:200]
      ,dfi_wrdata_mask_pN[26]
      ,dfi_wrdata_pN[215:208]
      ,dfi_wrdata_mask_pN[27]
      ,dfi_wrdata_pN[223:216]
      //p7
      ,dfi_rddata_en_pN[7]
      ,dfi_rddata_cs_pN[15:14]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[7]
      ,dfi_parity_in_pN[7]
      ,dfi_wrdata_cs_pN[15:14]
      ,dfi_wrdata_mask_pN[28]
      ,dfi_wrdata_pN[231:224]
      ,dfi_wrdata_mask_pN[29]
      ,dfi_wrdata_pN[239:232]
      ,dfi_wrdata_mask_pN[30]
      ,dfi_wrdata_pN[247:240]
      ,dfi_wrdata_mask_pN[31]
      ,dfi_wrdata_pN[255:248]
    };

    u_sram_loader.ahb_read(32'h000D0000,ahb_rdata);
    init_en_sta=ahb_rdata[6];
    init_upd_sta=ahb_rdata[7];
    other_csr=ahb_rdata;
    ig_en=init_en_sta;
    for(int i=15;i>=0;i--) begin
        ig_en=~ig_en;
        u_sram_loader.ahb_write(32'h000D0010,ingress_data[i*32+:32]);
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:8],init_upd_sta,ig_en,other_csr[5:0]}); 
        u_sram_loader.wait_until_empty();
    end
    //upd
    u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:8],~init_upd_sta,ig_en,other_csr[5:0]}); //wdata_upd=toggle
    u_sram_loader.wait_until_empty();
    u_sram_loader.ahb_read(32'h00D0000,ahb_rdata);
    //while(ahb_rdata[4]!=(~init_done_sta)) u_sram_loader.ahb_read(32'h00150014,ahb_rdata);
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_ig_write_done==(~init_done_sta));
endtask

bit [4:0] ZQ_NCAL_index;
bit [5:0] ZQ_PCAL_index;
bit [31:0] ZQ_index;

task ibias_ldo_initialize();
    begin
        $display ("[%t] #########  IBIAS/LDO Initializing   #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(32'h0009000C,32'h000002FA);
    end
endtask

task ZQ_calibration();
    begin
        $display ("[%t] #########  ZQ Calibration   #########",$time);
        //ZQCAL process
        u_sram_loader.ahb_write(32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        end
    end
endtask

task pll_initialize_0p8();
    begin     
        $display ("[%t] #########  PLL 800MHz Initializing   #########",$time);   
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        end
        //VCO1
        //2GHz 
        //u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        //u_sram_loader.ahb_write(32'h00098044,32'h08249F01);

        //850MHz
        u_sram_loader.ahb_write(32'h00098048,32'h0202C03F);
        u_sram_loader.ahb_write(32'h00098044,32'h0814910D);
        //VCO2
        //u_sram_loader.ahb_write(32'h00098070,32'h040DC080);
        //u_sram_loader.ahb_write(32'h0009806C,32'h08249F01);
        u_sram_loader.ahb_write(32'h00098070,32'h0202C03F);
        u_sram_loader.ahb_write(32'h0009806C,32'h0814910D);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        //u_sram_loader.ahb_write(32'h00098058,32'h04000037);
        //u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098058,32'h04000016);
        u_sram_loader.ahb_write(32'h0009803C,32'h00006741);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //VCO2 PLL
        //u_sram_loader.ahb_write(32'h00098080,32'h04000037);
        //u_sram_loader.ahb_write(32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098080,32'h04000015);
        u_sram_loader.ahb_write(32'h00098064,32'h00006741);
        u_sram_loader.ahb_write(32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL 800MHz Initialize Done   #########",$time);
    end
endtask

task pll_initialize_2p1();
    begin        

        $display ("[%t] #########  PLL 2133MHz Initializing   #########",$time); 
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        end
        //VCO1
        //2GHz 
        u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL 2133MHz Initialize Done   #########",$time);
    end
endtask

task link_initialize();
    begin
        $display ("[%t] #########  Link Initializing   #########",$time);
        //ucie disable
        u_sram_loader.ahb_write(32'h00150000,32'h00100000);
        //ucien
        u_sram_loader.ahb_write(32'h00150024,32'h00000800);
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mc_top_tb.ahb_clk);

        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(32'h00120290,32'h00004040);
        u_sram_loader.ahb_write(32'h001202B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001202D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(32'h00120294,32'h00004040);
        u_sram_loader.ahb_write(32'h001202B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001202D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(32'h00130290,32'h00004040);
        u_sram_loader.ahb_write(32'h001302B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001302D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(32'h00130294,32'h00004040);
        u_sram_loader.ahb_write(32'h001302B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001302D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(32'h00140318,32'h00004040);
        u_sram_loader.ahb_write(32'h00140338,32'h00004040);
        u_sram_loader.ahb_write(32'h00140358,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(32'h0014031C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014033C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014035C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mc_top_tb.ahb_clk);
        //enable all RX PI__CH0_DQ0
        u_sram_loader.ahb_write(32'h000F07F4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07D4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07E4,32'h00004040);

        u_sram_loader.ahb_write(32'h000F07F8,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07D8,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07E8,32'h00004040);

        //enable all RX PI__CH0_DQ1
        u_sram_loader.ahb_write(32'h001007F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001007D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001007E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001007F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001007D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001007E8,32'h00004040);

        //enable all RX PI__CH0_CA
        u_sram_loader.ahb_write(32'h0011098C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011096C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011097C,32'h00004040);

        u_sram_loader.ahb_write(32'h00110990,32'h00004040);
        u_sram_loader.ahb_write(32'h00110970,32'h00004040);
        u_sram_loader.ahb_write(32'h00110980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(32'h001207F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001207D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001207E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001207F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001207D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001207E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(32'h001307F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001307D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001307E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001307F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001307D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001307E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(32'h0014098C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014096C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014097C,32'h00004040);

        u_sram_loader.ahb_write(32'h00140990,32'h00004040);
        u_sram_loader.ahb_write(32'h00140970,32'h00004040);
        u_sram_loader.ahb_write(32'h00140980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001201F0,32'h00000004); //Ch1_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00120880,32'h00000004); //Ch1_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001301F0,32'h00000004); //Ch1_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00130880,32'h00000004); //Ch1_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00140258,32'h00000004); //Ch1_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(32'h001409F8,32'h00000004); //Ch1_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F0380,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100380,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110428,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        
        //DQS
        u_sram_loader.ahb_write_all_lane(32'h000F0A30,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100A30,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AA8,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R0_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h00120380,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130380,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001203A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001303A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140428,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140454,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h00120A30,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130A30,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AA8,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R0_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h00120A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AAC,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F0530,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100530,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110638,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h000F0BE0,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100BE0,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AD8,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R0_CFG

        u_sram_loader.ahb_write_all_lane(32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG

        u_sram_loader.ahb_write_all_lane(32'h00120530,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130530,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140638,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140664,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h00120BE0,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130BE0,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AD8,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R0_CFG

        u_sram_loader.ahb_write_all_lane(32'h00120C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00140ADC,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG


        //set RX AC path mode
        u_sram_loader.ahb_write(32'h000F083C,32'h00427777); //Ch0_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h0010083C,32'h00427777); //Ch0_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h001109C4,32'h00427777); //Ch0_CA_DQS_RX_IO_CMN

        u_sram_loader.ahb_write(32'h0012083C,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h0013083C,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h001409C4,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(32'h000F07B8,32'h00000084); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001007B8,32'h00000084); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00110950,32'h00000084); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4

        u_sram_loader.ahb_write(32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mc_top_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(32'h000F0000,32'h00000100); //Ch0_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(32'h00100000,32'h00000100); //Ch0_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(32'h00110000,32'h00000100); //Ch0_CA_FIFO_CLR

        u_sram_loader.ahb_write(32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge mc_top_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(32'h000F0000,32'h00000000); //Ch0_DQ0_FIFO_EN
        u_sram_loader.ahb_write(32'h00100000,32'h00000000); //Ch0_DQ1_FIFO_EN
        u_sram_loader.ahb_write(32'h00110000,32'h00000000); //Ch0_CA_FIFO_EN

        u_sram_loader.ahb_write(32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();

        $display ("[%t] #########  Link Initialize Done   #########",$time);
    end
endtask




// ----------------------------------------------------
    initial begin 
        $vcdpluson(0,mc_top_tb);
        uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_0",my_mosi_0);
		uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_1", my_mosi_1);
        uvm_config_db #(virtual dfi_lpddr4_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_lpddr4_vif", dfi_lpddr4_if);
`ifdef TIMING_CHECK
        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", u_mc_top.u_mc_core.dfi_if);
`endif
       // @begin_write;
        run_test("mc_top_basic_test");
        $finish;
    end
endmodule
