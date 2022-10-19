`timescale 1ns/10ps

module core_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    logic clk,rst;
    native_interface native_if_0(clk,rst);
    native_interface native_if_1(clk,rst);
	dfi_lpddr4_interface dfi_lpddr4_if(clk,rst);

	logic [7:0] mul_tRRD_cfg=8'd7;
	logic [7:0] mul_tFAW_cfg=8'd16;
	logic [7:0] mul_tCCD_cfg=8'd2;
	logic [7:0] mul_WTR_LATENCY_cfg=8'd13;
	logic [7:0] mul_RTW_LATENCY_cfg=8'd10;
	logic [7:0] mul_READ_TIME_cfg=8'd64;
	logic [7:0] mul_WRITE_TIME_cfg=8'd32;
	logic [1:0] mul_rd_phase_cfg=2'd0;
	logic [1:0] mul_wr_phase_cfg=2'd2;
	logic [1:0] mul_rdcmd_phase_cfg=2'd0;
	logic [1:0] mul_wrcmd_phase_cfg=2'd0;

    logic [7:0] ref_tRP_cfg=8'd12;
	logic [7:0] ref_tRFC_cfg=8'd97;
	logic [11:0] ref_tREFI_cfg=12'd1830;
	logic [3:0] ref_POSTPONE_cfg=4'd8;

    logic [7:0] bm_tRTP_cfg=4;
    logic [7:0] bm_tWTP_cfg=17;
	logic [7:0] bm_tRC_cfg=35;
	logic [7:0] bm_tRAS_cfg=24;
	logic [7:0] bm_tRP_cfg=12;
	logic [7:0] bm_tRCD_cfg=11;
	logic [7:0] bm_tCCDMW_cfg=8;

	logic [7:0] crb_READ_LATENCY_cfg=12;
	logic [7:0] crb_WRITE_LATENCY_cfg=10;

    logic [7:0] dfi_rddata_en_latency_cfg=10;
    logic [7:0] dfi_wrdata_en_latency_cfg=9;
    logic [7:0] dfi_wdqs_preamble_cfg=8'b11110000;

    mc_core u_mc_core (
    .native_if_0              (native_if_0),
    .native_if_1              (native_if_1),
    .dfi_lpddr4_if            (dfi_lpddr4_if),
    //system clock/reset
	.clk                      (clk),
    .rst                      (rst),
    //CSR
    .mul_rd_phase_cfg         (mul_rd_phase_cfg),
    .mul_wr_phase_cfg         (mul_wr_phase_cfg),
    .mul_rdcmd_phase_cfg      (mul_rdcmd_phase_cfg),
    .mul_wrcmd_phase_cfg      (mul_wrcmd_phase_cfg),
    .mul_tRRD_cfg             (mul_tRRD_cfg),
    .mul_tFAW_cfg             (mul_tFAW_cfg),
    .mul_tCCD_cfg             (mul_tCCD_cfg),
    .mul_WTR_LATENCY_cfg      (mul_WTR_LATENCY_cfg),
    .mul_RTW_LATENCY_cfg      (mul_RTW_LATENCY_cfg),
    .mul_READ_TIME_cfg        (mul_READ_TIME_cfg),
    .mul_WRITE_TIME_cfg       (mul_WRITE_TIME_cfg),
    .ref_tREFI_cfg            (ref_tREFI_cfg),
    .ref_POSTPONE_cfg         (ref_POSTPONE_cfg),
    .ref_tRP_cfg              (ref_tRP_cfg),
    .ref_tRFC_cfg             (ref_tRFC_cfg),
    .bm_tWTP_cfg              (bm_tWTP_cfg),
    .bm_tRTP_cfg              (bm_tRTP_cfg),
    .bm_tRAS_cfg              (bm_tRAS_cfg),
    .bm_tRC_cfg               (bm_tRC_cfg),
    .bm_tRP_cfg               (bm_tRP_cfg),
    .bm_tRCD_cfg              (bm_tRCD_cfg),
    .bm_tCCDMW_cfg            (bm_tCCDMW_cfg),
    .crb_READ_LATENCY_cfg     (crb_READ_LATENCY_cfg),
    .crb_WRITE_LATENCY_cfg    (crb_WRITE_LATENCY_cfg),
    .dfi_rddata_en_latency_cfg(dfi_rddata_en_latency_cfg),
    .dfi_wrdata_en_latency_cfg(dfi_wrdata_en_latency_cfg),
    .dfi_wdqs_preamble_cfg    (dfi_wdqs_preamble_cfg)
);

`ifdef ADD_PHY_MODEL
    localparam DFIRDCLKEN_PEXTWIDTH = 4;


   logic [71:0]            ch0_tx_dq0_sdr;
   logic [71:0]           ch0_tx_dqs0_sdr;
   logic [71:0]            ch0_tx_dq1_sdr;
   logic [71:0]           ch0_tx_dqs1_sdr;

   logic [79:0]            ch0_tx_ca_sdr;
   logic [71:0]            ch0_tx_ck_sdr;

   logic [71:0]            ch1_tx_dq0_sdr;
   logic [71:0]           ch1_tx_dqs0_sdr;
   logic [71:0]            ch1_tx_dq1_sdr;
   logic [71:0]           ch1_tx_dqs1_sdr;

   logic [79:0]            ch1_tx_ca_sdr;
   logic [71:0]            ch1_tx_ck_sdr;

   logic [7:0] ch0_tx_ck_pattern;
   logic [7:0] ch1_tx_ck_pattern;

   assign ch0_tx_ck_pattern=ch0_tx_ck_sdr[7:0];
   assign ch1_tx_ck_pattern=ch1_tx_ck_sdr[7:0];

   logic [7:0] ch0_dq0_dfi_wrdata_oe;
   logic [7:0] ch0_dq0_dfi_parity_in;
   logic [7:0] ch0_dq1_dfi_wrdata_oe;
   logic [7:0] ch0_dq1_dfi_parity_in;

   logic [7:0] ch0_dq0_dfi_wrdata_oe;
   logic [7:0] ch0_dq0_dfi_parity_in;
   logic [7:0] ch0_dq1_dfi_wrdata_oe;
   logic [7:0] ch0_dq1_dfi_parity_in;

   assign ch0_dq0_dfi_wrdata_oe=ch0_tx_dqs0_sdr[31:24];
   assign ch0_dq0_dfi_parity_in=ch0_tx_dqs0_sdr[15:8];
   assign ch0_dq1_dfi_wrdata_oe=ch0_tx_dqs1_sdr[31:24];
   assign ch0_dq1_dfi_parity_in=ch0_tx_dqs1_sdr[15:8];

   assign ch1_dq0_dfi_wrdata_oe=ch0_tx_dqs0_sdr[31:24];
   assign ch1_dq0_dfi_parity_in=ch0_tx_dqs0_sdr[15:8];
   assign ch1_dq1_dfi_wrdata_oe=ch0_tx_dqs1_sdr[31:24];
   assign ch1_dq1_dfi_parity_in=ch0_tx_dqs1_sdr[15:8];

    ddr_dfi #(
        .CA_WIDTH(10),
        .AWIDTH(6)
    )
    u_dfi (
      // Scan
      .i_scan_mode                   ('d0),
      .i_scan_rst_ctrl               ('d0),
      .i_scan_cgc_ctrl               ('d0),

      // Clock and reset
      .i_rst                         (rst),
      .i_ch0_phy_clk                 (clk),
      .i_ch0_dfiwr_clk_1             (clk),
      .i_ch0_dfiwr_clk_2             (clk),
      .i_ch0_dfird_clk_1             (clk),
      .i_ch0_dfird_clk_2             (clk),
      .i_ch1_phy_clk                 (clk),
      .i_ch1_dfiwr_clk_1             (clk),
      .i_ch1_dfiwr_clk_2             (clk),
      .i_ch1_dfird_clk_1             (clk),
      .i_ch1_dfird_clk_2             (clk),
      .o_dfi_clk                     (),

      .i_ahb_clk                     (clk),
      .i_ahb_rst                     (rst),

      .i_ahb_haddr                   ('d0),
      .i_ahb_hwrite                  ('d0),
      .i_ahb_hsel                    ('d0),
      .i_ahb_hwdata                  ('d0),
      .i_ahb_htrans                  ('d0),
      .i_ahb_hsize                   ('d0),
      .i_ahb_hburst                  ('d0),
      .i_ahb_hreadyin                ('d0),
      .o_ahb_hready                  ('d0),
      .o_ahb_hrdata                  ('d0),
      .o_ahb_hresp                   ('d0),

      .o_ch0_dfidqs_wrtraffic        (),
      .o_ch0_dfidq_wrtraffic         (),
      .o_ch0_dfick_traffic           (),
      .o_ch0_dfica_traffic           (),
      .o_ch0_dfiwrgb_mode            (),
      .o_ch0_dfirdgb_mode            (),
      .o_ch0_dfirdclk_en_pulse_ext   (),
      .o_ch0_dfirdclk_en_ovr_sel     (),
      .o_ch0_dfirdclk_en_ovr         (),
      .o_ch1_dfidqs_wrtraffic        (),
      .o_ch1_dfidq_wrtraffic         (),
      .o_ch1_dfick_traffic           (),
      .o_ch1_dfica_traffic           (),
      .o_ch1_dfiwrgb_mode            (),
      .o_ch1_dfirdgb_mode            (),
      .o_ch1_dfirdclk_en_pulse_ext   (),
      .o_ch1_dfirdclk_en_ovr_sel     (),
      .o_ch1_dfirdclk_en_ovr         (),

      .o_ch0_dfi_ibuf_empty_irq      (),
      .o_ch0_dfi_ibuf_full_irq       (),
      .o_ch0_dfi_ibuf_overflow_irq   (),
      .o_ch0_dfi_ebuf_empty_irq      (),
      .o_ch0_dfi_ebuf_full_irq       (),
      .o_ch0_dfi_ebuf_overflow_irq   (),
      .o_ch1_dfi_ibuf_empty_irq      (),
      .o_ch1_dfi_ibuf_full_irq       (),
      .o_ch1_dfi_ibuf_overflow_irq   (),
      .o_ch1_dfi_ebuf_empty_irq      (),
      .o_ch1_dfi_ebuf_full_irq       (),
      .o_ch1_dfi_ebuf_overflow_irq   (),

      .i_msr                         ('d0),
      .i_init_complete               (1'b1),

      // Update
      .o_dfi_ctrlupd_ack             (),
      .o_dfi_ctrlupd_req             (),
      .i_dfi_ctrlupd_req             ('d0),
      .o_dfi_phyupd_ack              (),
      .i_dfi_phyupd_ack              ('d0),
      .o_dfi_phyupd_req              (),
      .o_dfi_phyupd_type             (),

      // Status
      .i_dfi_freq_fsp                ('d0),
      .i_dfi_freq_ratio              ('d0),
      .i_dfi_frequency               ('d0),
      .o_dfi_init_complete           (),
      .o_irq_dfi_init_complete       (),
      .o_dfi_init_start              (),
      .i_dfi_init_start              ('d0),

      // PHY Master
      .o_dfi_phymstr_ack             (),
      .i_dfi_phymstr_ack             ('d0),
      .o_dfi_phymstr_cs_state        (),
      .o_dfi_phymstr_req             (),
      .o_dfi_phymstr_state_sel       (),
      .o_dfi_phymstr_type            (),



      // Low Power Control
      .o_dfi_lp_ctrl_ack             (),
      .o_dfi_lp_ctrl_req             (),
      .i_dfi_lp_ctrl_req             ('d0),
      .i_dfi_lp_ctrl_wakeup          ('d0),
      .o_dfi_lp_data_ack             (),
      .o_dfi_lp_data_req             (),
      .i_dfi_lp_data_req             ('d0),
      .i_dfi_lp_data_wakeup          ('d0),


      // Write Command Address Data
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
      .i_dfi_dram_clk_disable_p0     ('d0),
      .i_dfi_dram_clk_disable_p1     ('d0),
      .i_dfi_dram_clk_disable_p2     ('d0),
      .i_dfi_dram_clk_disable_p3     ('d0),
      .i_dfi_dram_clk_disable_p4     ('d0),
      .i_dfi_dram_clk_disable_p5     ('d0),
      .i_dfi_dram_clk_disable_p6     ('d0),
      .i_dfi_dram_clk_disable_p7     ('d0),

      // Write Data
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

      .i_dfi_wck_cs_p0               ('d0),
      .i_dfi_wck_cs_p1               ('d0),
      .i_dfi_wck_cs_p2               ('d0),
      .i_dfi_wck_cs_p3               ('d0),
      .i_dfi_wck_cs_p4               ('d0),
      .i_dfi_wck_cs_p5               ('d0),
      .i_dfi_wck_cs_p6               ('d0),
      .i_dfi_wck_cs_p7               ('d0),

      .i_dfi_wck_en_p0               ('d0),
      .i_dfi_wck_en_p1               ('d0),
      .i_dfi_wck_en_p2               ('d0),
      .i_dfi_wck_en_p3               ('d0),
      .i_dfi_wck_en_p4               ('d0),
      .i_dfi_wck_en_p5               ('d0),
      .i_dfi_wck_en_p6               ('d0),
      .i_dfi_wck_en_p7               ('d0),

      .i_dfi_wck_toggle_p0           ('d0),
      .i_dfi_wck_toggle_p1           ('d0),
      .i_dfi_wck_toggle_p2           ('d0),
      .i_dfi_wck_toggle_p3           ('d0),
      .i_dfi_wck_toggle_p4           ('d0),
      .i_dfi_wck_toggle_p5           ('d0),
      .i_dfi_wck_toggle_p6           ('d0),
      .i_dfi_wck_toggle_p7           ('d0),

      .i_dfi_wrdata_en_p0            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p1            (dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p2            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p3            (dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p4            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p5            (dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p6            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_en),
      .i_dfi_wrdata_en_p7            (dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_en),

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

/*
      .o_dfi_rddata_w0               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w1               (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w2               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w3               (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w4               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w5               (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata[63:32]),
      .o_dfi_rddata_w6               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata[31:0]),
      .o_dfi_rddata_w7               (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata[63:32]),
*/
      .o_dfi_rddata_w0               (),
      .o_dfi_rddata_w1               (),
      .o_dfi_rddata_w2               (),
      .o_dfi_rddata_w3               (),
      .o_dfi_rddata_w4               (),
      .o_dfi_rddata_w5               (),
      .o_dfi_rddata_w6               (),
      .o_dfi_rddata_w7               (),

      .o_dfi_rddata_dbi_w0           (),
      .o_dfi_rddata_dbi_w1           (),
      .o_dfi_rddata_dbi_w2           (),
      .o_dfi_rddata_dbi_w3           (),
      .o_dfi_rddata_dbi_w4           (),
      .o_dfi_rddata_dbi_w5           (),
      .o_dfi_rddata_dbi_w6           (),
      .o_dfi_rddata_dbi_w7           (),
      .o_dfi_rddata_valid_w0         (dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w1         (),
      .o_dfi_rddata_valid_w2         (dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w3         (),
      .o_dfi_rddata_valid_w4         (dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w5         (),
      .o_dfi_rddata_valid_w6         (dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_valid),
      .o_dfi_rddata_valid_w7         (),


      .i_txrx_mode                   ('d0),

      .o_ch0_dq0_sdr                 (ch0_tx_dq0_sdr),
      .i_ch0_dq0_sdr                 ('d0),
      .i_ch0_dq0_sdr_vld             ('d0),
      .o_ch0_dqs0_sdr                (ch0_tx_dqs0_sdr),
      .o_ch0_dq1_sdr                 (ch0_tx_dq1_sdr),
      .i_ch0_dq1_sdr                 ('d0),
      .i_ch0_dq1_sdr_vld             ('d0),
      .o_ch0_dqs1_sdr                (ch0_tx_dqs1_sdr),
      .i_ch0_tx0_sdr                 ('d0),
      .i_ch0_tx_ck0_sdr              ('d0),
      .o_ch0_rx0_sdr                 (),
      .o_ch0_rx0_sdr_vld             (),
      .i_ch0_tx1_sdr                 ('d0),
      .i_ch0_tx_ck1_sdr              ('d0),
      .o_ch0_rx1_sdr                 (),
      .o_ch0_rx1_sdr_vld             (),
      .o_ch0_ca_sdr                  (ch0_tx_ca_sdr),
      .i_ch0_ca_sdr                  ('d0),
      .i_ch0_ca_sdr_vld              ('d0),
      .o_ch0_ck_sdr                  (ch0_tx_ck_sdr),
      .o_ch1_dq0_sdr                 (ch1_tx_dq0_sdr),
      .i_ch1_dq0_sdr                 ('d0),
      .i_ch1_dq0_sdr_vld             ('d0),
      .o_ch1_dqs0_sdr                (ch1_tx_dqs0_sdr),
      .o_ch1_dq1_sdr                 (ch1_tx_dq1_sdr),
      .i_ch1_dq1_sdr                 ('d0),
      .i_ch1_dq1_sdr_vld             ('d0),
      .o_ch1_dqs1_sdr                (ch1_tx_dqs1_sdr),
      .i_ch1_tx0_sdr                 ('d0),
      .i_ch1_tx_ck0_sdr              ('d0),
      .o_ch1_rx0_sdr                 (),
      .o_ch1_rx0_sdr_vld             (),
      .i_ch1_tx1_sdr                 ('d0),
      .i_ch1_tx_ck1_sdr              ('d0),
      .o_ch1_rx1_sdr                 (),
      .o_ch1_rx1_sdr_vld             (),
      .o_ch1_ca_sdr                  (ch1_tx_ca_sdr),
      .i_ch1_ca_sdr                  ('d0),
      .i_ch1_ca_sdr_vld              ('d0),
      .o_ch1_ck_sdr                  (ch1_tx_ck_sdr),
      .o_debug                       ()
   );

`endif

    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end

    initial begin 
        rst <= 1;
        repeat(5) @(posedge clk);
        @(negedge clk);
        rst <= 0;
    end

    initial begin 
        $vcdpluson(0,core_tb);
        uvm_config_db #(virtual native_interface)::set(uvm_root::get(), "uvm_test_top", "nat_vif_0", native_if_0);
		uvm_config_db #(virtual native_interface)::set(uvm_root::get(), "uvm_test_top", "nat_vif_1", native_if_1);
        uvm_config_db #(virtual dfi_lpddr4_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_lpddr4_vif", dfi_lpddr4_if);
`ifdef TIMING_CHECK
        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", u_mc_core.dfi_if);
`endif
        run_test("core_basic_test");
        $finish;
    end
endmodule