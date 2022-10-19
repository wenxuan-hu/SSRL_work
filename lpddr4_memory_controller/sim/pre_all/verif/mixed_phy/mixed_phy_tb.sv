`timescale 1ns/1ps
module mixed_phy_tb();
    parameter half_clk_cycle=13;

    logic rst,csp_rst_n;
    logic ref_clk;
    rdi_mb_interface rdi_mb_if(clk,rst);

//virtual channel

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
    parameter channel_delay=0;
    
    assign #channel_delay pad_ch1_dq=pad_ch0_dq;
    assign #channel_delay pad_ch1_dqs_c=pad_ch0_dqs_c;
    assign #channel_delay pad_ch1_dqs_t=pad_ch0_dqs_t;
    assign #channel_delay pad_ch1_ca=pad_ch0_ca;
    assign #channel_delay pad_ch1_ck_c=pad_ch0_ck_c;
    assign #channel_delay pad_ch1_ck_t=pad_ch0_ck_t;
    
    logic [383:0] xmit_q [$];
    int err_count;
    int run_for_n_pkts;

//ahb clk
   logic ahb_clk;

    always #half_clk_cycle ref_clk=~ref_clk;
    always #half_clk_cycle ahb_clk=~ahb_clk;

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
) u_mixed_phy (
    // Reset
    .i_phy_rst                    (rst),
    // Clocks
    .i_dfi_clk_on                 (1'b1),
    .o_dfi_clk                    (clk),
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
    .i_ahb_rst                    (rst),
    .i_ahb_csr_rst                (rst),
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
    .i_dfi_reset_n_p0             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p1             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p2             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p3             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p4             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p5             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p6             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p7             ('0),
    // DDR/3/4/5 and LPDDR4/5
    // Command
    .i_dfi_address_p0             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p1             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p2             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p3             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p4             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p5             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p6             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p7             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_cke_p0                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p1                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p2                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p3                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p4                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p5                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p6                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p7                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cs_p0                  ('0),
    .i_dfi_cs_p1                  ('0),
    .i_dfi_cs_p2                  ('0),
    .i_dfi_cs_p3                  ('0),
    .i_dfi_cs_p4                  ('0),
    .i_dfi_cs_p5                  ('0),
    .i_dfi_cs_p6                  ('0),
    .i_dfi_cs_p7                  ('0),
    .i_dfi_dram_clk_disable_p0    ('0),
    .i_dfi_dram_clk_disable_p1    ('0),
    .i_dfi_dram_clk_disable_p2    ('0),
    .i_dfi_dram_clk_disable_p3    ('0),
    .i_dfi_dram_clk_disable_p4    ('0),
    .i_dfi_dram_clk_disable_p5    ('0),
    .i_dfi_dram_clk_disable_p6    ('0),
    .i_dfi_dram_clk_disable_p7    ('0),
    // Write
    .i_dfi_wrdata_p0              ('0),
    .i_dfi_wrdata_p1              ('0),
    .i_dfi_wrdata_p2              ('0),
    .i_dfi_wrdata_p3              ('0),
    .i_dfi_wrdata_p4              ('0),
    .i_dfi_wrdata_p5              ('0),
    .i_dfi_wrdata_p6              ('0),
    .i_dfi_wrdata_p7              ('0),
    .i_dfi_parity_in_p0           ('0),
    .i_dfi_parity_in_p1           ('0),
    .i_dfi_parity_in_p2           ('0),
    .i_dfi_parity_in_p3           ('0),
    .i_dfi_parity_in_p4           ('0),
    .i_dfi_parity_in_p5           ('0),
    .i_dfi_parity_in_p6           ('0),
    .i_dfi_parity_in_p7           ('0),
    .i_dfi_wrdata_cs_p0           ('0),
    .i_dfi_wrdata_cs_p1           ('0),
    .i_dfi_wrdata_cs_p2           ('0),
    .i_dfi_wrdata_cs_p3           ('0),
    .i_dfi_wrdata_cs_p4           ('0),
    .i_dfi_wrdata_cs_p5           ('0),
    .i_dfi_wrdata_cs_p6           ('0),
    .i_dfi_wrdata_cs_p7           ('0),
    .i_dfi_wck_cs_p0              ('0),
    .i_dfi_wck_cs_p1              ('0),
    .i_dfi_wck_cs_p2              ('0),
    .i_dfi_wck_cs_p3              ('0),
    .i_dfi_wck_cs_p4              ('0),
    .i_dfi_wck_cs_p5              ('0),
    .i_dfi_wck_cs_p6              ('0),
    .i_dfi_wck_cs_p7              ('0),
    .i_dfi_wrdata_mask_p0         ('0),
    .i_dfi_wrdata_mask_p1         ('0),
    .i_dfi_wrdata_mask_p2         ('0),
    .i_dfi_wrdata_mask_p3         ('0),
    .i_dfi_wrdata_mask_p4         ('0),
    .i_dfi_wrdata_mask_p5         ('0),
    .i_dfi_wrdata_mask_p6         ('0),
    .i_dfi_wrdata_mask_p7         ('0),
    .i_dfi_wrdata_en_p0           ('0),
    .i_dfi_wrdata_en_p1           ('0),
    .i_dfi_wrdata_en_p2           ('0),
    .i_dfi_wrdata_en_p3           ('0),
    .i_dfi_wrdata_en_p4           ('0),
    .i_dfi_wrdata_en_p5           ('0),
    .i_dfi_wrdata_en_p6           ('0),
    .i_dfi_wrdata_en_p7           ('0),
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
    .i_dfi_rddata_cs_p0           ('0),
    .i_dfi_rddata_cs_p1           ('0),
    .i_dfi_rddata_cs_p2           ('0),
    .i_dfi_rddata_cs_p3           ('0),
    .i_dfi_rddata_cs_p4           ('0),
    .i_dfi_rddata_cs_p5           ('0),
    .i_dfi_rddata_cs_p6           ('0),
    .i_dfi_rddata_cs_p7           ('0),
    .i_dfi_rddata_en_p0           ('0),
    .i_dfi_rddata_en_p1           ('0),
    .i_dfi_rddata_en_p2           ('0),
    .i_dfi_rddata_en_p3           ('0),
    .i_dfi_rddata_en_p4           ('0),
    .i_dfi_rddata_en_p5           ('0),
    .i_dfi_rddata_en_p6           ('0),
    .i_dfi_rddata_en_p7           ('0),
    .o_dfi_rddata_w0              (),
    .o_dfi_rddata_w1              (),
    .o_dfi_rddata_w2              (),
    .o_dfi_rddata_w3              (),
    .o_dfi_rddata_w4              (),
    .o_dfi_rddata_w5              (),
    .o_dfi_rddata_w6              (),
    .o_dfi_rddata_w7              (),
    .o_dfi_rddata_dbi_w0          (),
    .o_dfi_rddata_dbi_w1          (),
    .o_dfi_rddata_dbi_w2          (),
    .o_dfi_rddata_dbi_w3          (),
    .o_dfi_rddata_dbi_w4          (),
    .o_dfi_rddata_dbi_w5          (),
    .o_dfi_rddata_dbi_w6          (),
    .o_dfi_rddata_dbi_w7          (),
    .o_dfi_rddata_valid_w0        (),
    .o_dfi_rddata_valid_w1        (),
    .o_dfi_rddata_valid_w2        (),
    .o_dfi_rddata_valid_w3        (),
    .o_dfi_rddata_valid_w4        (),
    .o_dfi_rddata_valid_w5        (),
    .o_dfi_rddata_valid_w6        (),
    .o_dfi_rddata_valid_w7        (),
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
    // Pads
    .pad_reset_n                  ('1),
    // Reset pad
    .pad_rext                     (),
    .pad_test                     (),
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

    logic rx_fifo_write;


        bit [31:0] dq0_fc_dly;
        bit [31:0] dq1_fc_dly;
        bit [31:0] ca_fc_dly;

        bit [31:0] dq0_pipe_en;
        bit [31:0] dq1_pipe_en;
        bit [31:0] ca_pipe_en;

        bit [31:0] ahb_rdata;

    initial begin 
        $vcdpluson(0,mixed_phy_tb);
        itcm_dtcm_init();
        run_for_n_pkts=100;
        rdi_mb_if.lp_data  <= '0;
        rdi_mb_if.lp_valid  <= '0;
        rdi_mb_if.lp_irdy  <= '0;
        ahb_clk<=1'b0;
        ref_clk<=1'b0;
        rst<=1'b1;
        repeat (10) @(posedge mixed_phy_tb.ref_clk);
        rst<=1'b0;
        $display ("[%t] #########  Exit Reset #############", $time);
        $display ("[%t] #########  Start PHY data loopback test #########",$time);
`ifdef MCU_CTRL
        $display ("[%t] #########  Begin loading SRAM #############", $time);
        u_sram_loader.begin_transfer();
        repeat (100) @(posedge mixed_phy_tb.ref_clk);
        u_sram_loader.ahb_write(32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(32'h00090024,32'h00000100);
        u_sram_loader.ahb_write(32'h00000004, 32'h1);
        repeat (100000) @(posedge mixed_phy_tb.ref_clk);
`else
        link_initialize();
        #10;
        ucie_cfg();
        #10;
        $display ("[%t] #########  Initialization Done #############", $time);
        #10;
        link_training();
        #10;
        //begin txrx test
        wait_training_done();
        $display ("[%t] #########  All Training Done #############", $time);

        fork
	        data_xmit();
	        data_rcv();
	    join
`endif
        $display ("[%t] #########  All Tasks are finished normally #############", $time);
        //end txrx test
        #100;
        Finish();
    end



//ahb write

    logic [31:0]         queue_ahb_haddr  [$] ;
    logic [31:0]         queue_ahb_hwdata  [$] ;

task itcm_dtcm_init;
    //load memory
`ifdef RAMFILE
    u_sram_loader.loadmem_00("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b0_byte03_byte00.ram");
    u_sram_loader.loadmem_01("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b1_byte03_byte00.ram");
    u_sram_loader.loadmem_02("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b2_byte03_byte00.ram");
    u_sram_loader.loadmem_03("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b3_byte03_byte00.ram");
    u_sram_loader.loadmem_04("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b4_byte03_byte00.ram");
    u_sram_loader.loadmem_05("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b5_byte03_byte00.ram");
    u_sram_loader.loadmem_06("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b6_byte03_byte00.ram");
    u_sram_loader.loadmem_07("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b7_byte03_byte00.ram");
    
    u_sram_loader.loadmem_10("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b0_byte03_byte00.ram");
    u_sram_loader.loadmem_11("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b1_byte03_byte00.ram");
    u_sram_loader.loadmem_12("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b2_byte03_byte00.ram");
    u_sram_loader.loadmem_13("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b3_byte03_byte00.ram");
    u_sram_loader.loadmem_14("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b4_byte03_byte00.ram");
    u_sram_loader.loadmem_15("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b5_byte03_byte00.ram");
    u_sram_loader.loadmem_16("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b6_byte03_byte00.ram");
    u_sram_loader.loadmem_17("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b7_byte03_byte00.ram");
`else
    u_sram_loader.loadmem_00("../wav-lpddr-hw/sw/wddr_boot_itcm_00.ram");
    u_sram_loader.loadmem_01("../wav-lpddr-hw/sw/wddr_boot_itcm_01.ram");
    u_sram_loader.loadmem_02("../wav-lpddr-hw/sw/wddr_boot_itcm_02.ram");

    u_sram_loader.loadmem_10("../wav-lpddr-hw/sw/wddr_boot_dtcm_00.ram");
    u_sram_loader.loadmem_11("../wav-lpddr-hw/sw/wddr_boot_dtcm_01.ram");
    u_sram_loader.loadmem_12("../wav-lpddr-hw/sw/wddr_boot_dtcm_02.ram");
`endif

endtask


task wait_training_done();
    wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.buf_mode_sync==1'b0);
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
	    @(negedge mixed_phy_tb.clk);
	    mixed_phy_tb.rdi_mb_if.lp_data  <= data;
        mixed_phy_tb.rdi_mb_if.lp_valid  <= 1'b1;
        mixed_phy_tb.rdi_mb_if.lp_irdy  <= 1'b1;
        @(posedge mixed_phy_tb.clk);
        while (mixed_phy_tb.rdi_mb_if.pl_trdy != 1'b1) @(posedge mixed_phy_tb.clk);
        repeat(n_idles) rdi_mb_idle();
        xmit_q.push_back(data);
        pkts_gen++;
    end
    rdi_mb_idle();
endtask

task rdi_mb_idle();
    @(negedge mixed_phy_tb.clk);
    mixed_phy_tb.rdi_mb_if.lp_data  <= '0;
    mixed_phy_tb.rdi_mb_if.lp_valid  <= '0;
    mixed_phy_tb.rdi_mb_if.lp_irdy  <= '0;
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
        @(posedge mixed_phy_tb.clk);
        while (wait_timeout > 0)
            begin
                wait_timeout = wait_timeout - 1;
                @(posedge mixed_phy_tb.clk);
            end
        end

        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge mixed_phy_tb.clk);
                if (mixed_phy_tb.rdi_mb_if.pl_valid===1'b1) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, mixed_phy_tb.rdi_mb_if.pl_data);
                    data_exp = xmit_q.pop_front();
                    pkts_rcvd++;
                    if (mixed_phy_tb.rdi_mb_if.pl_data != data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, mixed_phy_tb.rdi_mb_if.pl_data, data_exp);
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
	repeat (10) @(posedge mixed_phy_tb.ref_clk);
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


task ucie_cfg();
    begin
        $display ("[%t] #########  UCIe Pad Initializing   #########",$time);
        //pam4_en=0, ucie_en=1, ucie_dem_en=0, ucie_odt_en=2'b01
        u_sram_loader.ahb_write(32'h00150024,32'h00000900);
    end
endtask

bit [4:0] ZQ_NCAL_index;
bit [5:0] ZQ_PCAL_index;
bit [31:0] ZQ_index;

task link_initialize();
    begin
        $display ("[%t] #########  Initializing   #########",$time);

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
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:tx ch1:rx
        u_sram_loader.ahb_write(32'h00150000,32'h00111016);
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
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);

        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A7C,32'h00004040);

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
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        u_sram_loader.ahb_write(32'h0012083C,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h0013083C,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h001409C4,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
    end
endtask

 bit [447:0] egress_data;
 integer dq0_dly=0;
 integer dq1_dly=0;
  integer ca_dly=0;
task link_training();
    begin
        $display ("[%t] #########  Begin Link Training   #########",$time);
        rx_fifo_write<='1;
        repeat (50) @(posedge mixed_phy_tb.ahb_clk);
        //reset clock divider
        u_sram_loader.ahb_write(32'h000A0030,32'h00000080); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        u_sram_loader.ahb_read(32'h000A0030,ahb_rdata); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        while(ahb_rdata[7]!=1) begin
            u_sram_loader.ahb_read(32'h000A0030,ahb_rdata);
        end
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000); //FSW_CSP_1_CFG  div_rst_ovr_value=0
        //lt_mode<=3'b001; //send 01010101
        //buf_mode=1
        u_sram_loader.ahb_write(32'h00150000,32'h00111106);
        // ts enable
        u_sram_loader.ahb_write(32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        u_sram_loader.ahb_write(32'h0015000C,32'h20000000); //ig_hold=1
        u_sram_loader.ahb_read(32'h0015000C,ahb_rdata); //ig_hold=1
        while(ahb_rdata[29]!=1) begin
            u_sram_loader.ahb_read(32'h0015000C,ahb_rdata);
        end
        repeat (5) @(posedge mixed_phy_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid disable
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //read egress data
        $display ("[%t] #########  Before Training     #########",$time);
        read_ucie_egress_data(egress_data);
        //clr
        u_sram_loader.ahb_write(32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //begin link rdqs training, rdqs delay tuning
        u_sram_loader.ahb_write(32'h00120820,32'h00004949); //Ch1_DQ0_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(32'h00130820,32'h00004949); //Ch1_DQ1_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(32'h00120824,32'h00004949); //Ch1_DQ0_DQS_RX_IO_M0_R1
        u_sram_loader.ahb_write(32'h00130824,32'h00004949); //Ch1_DQ1_DQS_RX_IO_M0_R1
        repeat (50) @(posedge mixed_phy_tb.ahb_clk);
        /*
        should further check if egress fifo is empty. If not, means valid signal is not aligned correctly.
        */
        //clr
        u_sram_loader.ahb_write(32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  RDQS Calibration Done     #########",$time);
        // ts enable
        u_sram_loader.ahb_write(32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid enable
        send_ucie_ingress_data(864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        read_ucie_egress_data(egress_data);
        //end rdqs training, still  dq0 get 40404040 dq1 get 01010101 ca get 10101010
        //begin dq alignment training, 1 ddr fc delay 1 qdr cycle, qdr_pipe_en

        if (egress_data[143:136]==8'h01) begin
            dq0_fc_dly=0;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h04) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=3;
        end else if (egress_data[143:136]==8'h10) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h40) begin
            dq0_fc_dly=32'h0;
            dq0_pipe_en=3;
        end

        if (egress_data[71:64]==8'h01) begin
            dq1_fc_dly=0;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h04) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=3;
        end else if (egress_data[71:64]==8'h10) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h40) begin
            dq1_fc_dly=32'h0;
            dq1_pipe_en=3;
        end

        if (egress_data[7:0]==8'h01) begin
            ca_fc_dly=0;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h04) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=3;
        end else if (egress_data[7:0]==8'h10) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h40) begin
            ca_fc_dly=32'h0;
            ca_pipe_en=3;
        end
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0434,dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100434,dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
         //CA FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00110504,ca_fc_dly); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //valid FC DLY (follow CA)
        u_sram_loader.ahb_write(32'h00110AB8,ca_fc_dly); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00110ABC,ca_fc_dly); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
        //now dq1/dq0/ca get 04040404
        //DQ0_DDR Pipe
        u_sram_loader.ahb_write_all_lane(32'h000F04C4,dq0_pipe_en); //CH0_DQ0_DQ_TX_DDR_M0_R1_CFG_0-8
        //DQ1_DDR Pipe
        u_sram_loader.ahb_write_all_lane(32'h001004C4,dq1_pipe_en); //CH0_DQ1_DQ_TX_DDR_M0_R1_CFG_0-8
        //CA_DDR Pipe
        u_sram_loader.ahb_write_all_lane(32'h001105B4,ca_pipe_en); //CH0_CA_DQ_TX_DDR_M0_R1_CFG_0-8
        //valid DDR Pipe
        u_sram_loader.ahb_write(32'h00110AC8,ca_pipe_en); //CH0_CA_DQS_TX_DDR_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00110ACC,ca_pipe_en); //CH0_CA_DQS_TX_DDR_M0_R1_CFG_0
        //get 10101010
        u_sram_loader.wait_until_empty();
        //clr
        u_sram_loader.ahb_write(32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  DQ Alignment Calibration Done #########",$time);
        // ts enable
        u_sram_loader.ahb_write(32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid enable
        send_ucie_ingress_data(864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        read_ucie_egress_data(egress_data);
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Begin Channel Alignment Training #########",$time);
        /*
        //loop mode bugs found, loop count not useful
        u_sram_loader.ahb_write(32'h0015000C,32'hf0000000); //ingress fifo clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h0015000C,32'he0003101); //loop mode disable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h0015000C,32'he0003001); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        send_ucie_ingress_data(864'h04000101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04010202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,0,0,30'h20003001,0);
        send_ucie_ingress_data(864'h04020303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04030404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,0,0,30'h20003001,0);
        u_sram_loader.ahb_write(32'h0015000C,32'he00031f1); //loop mode enable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.ahb_write(32'h0015000C,32'he00030f1); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        #1000;
        */
        //use ts instead
        //clr
        u_sram_loader.ahb_write(32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(32'h00150008,32'h000A0101); //release reset
        dq0_dly=0;
        dq1_dly=0;
        ca_dly=0;
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        if(egress_data[143:136]==8'h02) begin
            dq0_dly=1;
        end else if (egress_data[143:136]==8'h03) begin
            dq0_dly=2;
        end

        if(egress_data[71:64]==8'h02) begin
            dq1_dly=1;
        end else if (egress_data[71:64]==8'h03) begin
            dq1_dly=2;
        end
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        if(egress_data[143:136]==8'h02) begin
            ca_dly=1;
        end else if (egress_data[143:136]==8'h01) begin
            ca_dly=2;
        end

        if(egress_data[71:64]==8'h02) begin
            if(ca_dly==2) dq1_dly+=1; // ca_dly 1 more than needed, then deley one more cycle
            else if(ca_dly==0) begin 
                dq0_dly+=1; //if dq0 dont require ca_dly, conpensate one cycle delay for dq0 here
                ca_dly=1;
            end else ca_dly=1;
        end else if (egress_data[71:64]==8'h01) begin
            if(ca_dly==0) dq0_dly+=2; //if dq0 dont require ca_dly, conpensate two cycle delay for dq0 here
            else if(ca_dly==1) begin 
                dq0_dly+=1; //if dq0 only require 1 ca_dly, conpensate one cycle delay for dq0 here
                ca_dly=2;
            end else ca_dly=2;
        end else begin //if dq1 dont require ca_dly but ca_dly is not 0, we need to compensate this
            dq1_dly+=ca_dly;
        end

        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        
         //DQ0 FC DLY
        case (dq0_dly)
            1:u_sram_loader.ahb_write_all_lane(32'h000F0434,{8{dq0_fc_dly[3:0]+4'd2}}); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
            2:begin
                if (dq0_fc_dly[3:0]==0) begin
                    u_sram_loader.ahb_write_all_lane(32'h000F0434,{8{4'd3}}); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
                    u_sram_loader.ahb_write(32'h000F02E4,32'h000001FF); // CH0_DQ0__DQ_TX_RT_M0_R1_CFG
                end else $display ("[%t] #########  DQ0 Unable to Delay over 2 cycles  #########",$time);
            end
            default:begin
            end
        endcase
        //DQ1 FC_DLY
        case (dq1_dly)
            1:u_sram_loader.ahb_write_all_lane(32'h00100434,{8{dq1_fc_dly[3:0]+4'd2}}); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
            2:begin
                if (dq1_fc_dly[3:0]==0) begin
                    u_sram_loader.ahb_write_all_lane(32'h00100434,{8{4'd3}}); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
                    u_sram_loader.ahb_write(32'h001002E4,32'h000001FF); // CH0_DQ1__DQ_TX_RT_M0_R1_CFG
                end else $display ("[%t] #########  DQ1 Unable to Delay over 2 cycles  #########",$time);
            end
            default:begin
            end
        endcase

         //CA FC DLY
        case (ca_dly)
            1:begin 
                u_sram_loader.ahb_write_all_lane(32'h00110504,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
                u_sram_loader.ahb_write(32'h00110AB8,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
                u_sram_loader.ahb_write(32'h00110ABC,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
            end
            2:begin
                if (ca_fc_dly[3:0]==0) begin
                    u_sram_loader.ahb_write_all_lane(32'h00110504,{8{4'd3}}); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
                    u_sram_loader.ahb_write(32'h00110AB8,{8{4'd3}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
                    u_sram_loader.ahb_write(32'h00110ABC,{8{4'd3}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0

                    u_sram_loader.ahb_write(32'h0011036C,32'h000003FF); // CH0_CA__DQ_TX_RT_M0_R1_CFG
                    u_sram_loader.ahb_write(32'h00110A88,32'h00000001); // CH0_CA__DQS_TX_RT_M0_R0_CFG
                    u_sram_loader.ahb_write(32'h00110A8C,32'h00000001); // CH0_CA__DQS_TX_RT_M0_R1_CFG

                end else $display ("[%t] #########  CA Unable to Delay over 2 cycles  #########",$time);
            end
            default:begin
            end
        endcase
        
        $display ("[%t] ######  Channel Alignment Testing After Tuning ######",$time);
        u_sram_loader.ahb_write(32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        repeat (10) @(posedge mixed_phy_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time);
        read_ucie_egress_data(egress_data);
        $display ("[%t] ####  Channel Alignment Calibration Done, Exit Training Mode ####",$time);
        //buf_mode=1
        u_sram_loader.ahb_write(32'h00150000,32'h00111006);
    end
endtask

task send_ucie_ingress_data;
    input [863:0] ingress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit [29:0] other_csr;
    bit ig_en;
    bit init_done_sta;
    u_sram_loader.ahb_read(32'h0015000C,ahb_rdata);
    init_en_sta=ahb_rdata[30];
    init_upd_sta=ahb_rdata[31];
    other_csr=ahb_rdata[29:0];
    ig_en=init_en_sta;
    for(int i=26;i>=0;i--) begin
        ig_en=~ig_en;
        u_sram_loader.ahb_write(32'h00150010,ingress_data[i*32+:32]);
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h0015000C,{init_upd_sta,ig_en,other_csr}); //wdata_en=toggle wdata_hold=1
        u_sram_loader.wait_until_empty();
    end
    //upd
    u_sram_loader.ahb_write(32'h0015000C,{~init_upd_sta,ig_en,other_csr}); //wdata_upd=toggle
    u_sram_loader.wait_until_empty();
    u_sram_loader.ahb_read(32'h00150014,ahb_rdata);
    //while(ahb_rdata[4]!=(~init_done_sta)) u_sram_loader.ahb_read(32'h00150014,ahb_rdata);
    //wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_ig_write_done==(~init_done_sta));
endtask

task read_ucie_egress_data;
    output [447:0] egress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit eg_en;
    bit read_done;
    u_sram_loader.ahb_read(32'h00150018,ahb_rdata);
    init_en_sta=ahb_rdata[4];
    init_upd_sta=ahb_rdata[8];
    eg_en=init_en_sta;
    u_sram_loader.ahb_read(32'h0015001C,ahb_rdata);
    while(ahb_rdata[0]==1'b1) begin
        u_sram_loader.ahb_read(32'h0015001C,ahb_rdata);
    end
    read_done=ahb_rdata[4];
    //wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_empty==1'b0);
    u_sram_loader.ahb_write(32'h00150018,{23'd0,~init_upd_sta,3'd0,eg_en,4'd0}); //rdata_upd=toggle
    u_sram_loader.ahb_read(32'h0015001C,ahb_rdata);
    while(ahb_rdata[4]==read_done) begin
        u_sram_loader.ahb_read(32'h0015001C,ahb_rdata);
    end
    //wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_read_done==1'b1);
    for(int i=0;i<=13;i++) begin
        eg_en=~eg_en;
        u_sram_loader.ahb_read(32'h00150020,egress_data[i*32+:32]);
        //egress_data[i*32+:32]=mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_rdata;
        u_sram_loader.ahb_write(32'h00150018,{23'd0,~init_upd_sta,3'd0,eg_en,4'd0}); //rdata_en=toggle
        u_sram_loader.wait_until_empty();
        //wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b1);
        //wait(mixed_phy_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b0);
    end
    $display ("[%t] Read Egress Data ch1 dq0 %h.",$time,egress_data[207:136]);
    $display ("[%t] Read Egress Data ch1 dq1 %h.",$time,egress_data[135:64]);
    $display ("[%t] Read Egress Data ch1 ca %h.",$time,egress_data[63:0]);
endtask
endmodule