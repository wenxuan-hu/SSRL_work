module mc_core_nointerface(

	//system clock/reset
	input logic clk,
	input logic rst,

    // native_interface
    input logic cmd_valid,
	output reg cmd_ready,
	input logic cmd_first,
	input logic cmd_last,
	input logic cmd_payload_mw,
	input logic cmd_payload_we,
	input logic [25:0] cmd_payload_addr,
	input logic wdata_valid,
	output reg wdata_ready,
	input logic wdata_first,
	input logic wdata_last,
	input [255:0] wdata_payload_data,
	input [31:0] wdata_payload_we,
	output reg rdata_valid,
	input logic rdata_ready,
	input logic rdata_first,
	input logic rdata_last,
	output reg [255:0] rdata_payload_data,

	input cmd_valid_1,
	output reg cmd_ready_1,
	input cmd_first_1,
	input cmd_last_1,
	input cmd_payload_mw_1,
	input cmd_payload_we_1,
	input [25:0] cmd_payload_addr_1,
	input wdata_valid_1,
	output reg wdata_ready_1,
	input wdata_first_1,
	input wdata_last_1,
	input [255:0] wdata_payload_data_1,
	input [31:0] wdata_payload_we_1,
	output reg rdata_valid_1,
	input rdata_ready_1,
	input rdata_first_1,
	input rdata_last_1,
	output reg [255:0] rdata_payload_data_1,

    //dfi_lpddr4_interface
    output logic dfi_lpddr4_if_dfi_cs_0,
    output logic [5:0] dfi_lpddr4_if_dfi_ca_0,
    output logic dfi_lpddr4_if_dfi_cke_0,
    output logic dfi_lpddr4_if_dfi_odt_0,
    output logic dfi_lpddr4_if_dfi_reset_n_0,
    output logic dfi_lpddr4_if_dfi_act_n_0,
    output logic [63:0] dfi_lpddr4_if_dfi_wrdata_0,
    output logic [7:0] dfi_lpddr4_if_dfi_wrdata_mask_0,
    input logic [63:0] dfi_lpddr4_if_dfi_rdata_0,
    input logic dfi_lpddr4_if_dfi_rddata_valid_0,
    output logic dfi_lpddr4_if_dfi_rddata_en_0,
    output logic dfi_lpddr4_if_dfi_wrdata_en_0,


    output logic dfi_lpddr4_if_dfi_cs_1,
    output logic [5:0] dfi_lpddr4_if_dfi_ca_1,
    output logic dfi_lpddr4_if_dfi_cke_1,
    output logic dfi_lpddr4_if_dfi_odt_1,
    output logic dfi_lpddr4_if_dfi_reset_n_1,
    output logic dfi_lpddr4_if_dfi_act_n_1,
    output logic [63:0] dfi_lpddr4_if_dfi_wrdata_1,
    output logic [7:0] dfi_lpddr4_if_dfi_wrdata_mask_1,
    input logic [63:0] dfi_lpddr4_if_dfi_rdata_1,
    input logic dfi_lpddr4_if_dfi_rddata_valid_1,
    output logic dfi_lpddr4_if_dfi_rddata_en_1,
    output logic dfi_lpddr4_if_dfi_wrdata_en_1,


    output logic dfi_lpddr4_if_dfi_cs_2,
    output logic [5:0] dfi_lpddr4_if_dfi_ca_2,
    output logic dfi_lpddr4_if_dfi_cke_2,
    output logic dfi_lpddr4_if_dfi_odt_2,
    output logic dfi_lpddr4_if_dfi_reset_n_2,
    output logic dfi_lpddr4_if_dfi_act_n_2,
    output logic [63:0] dfi_lpddr4_if_dfi_wrdata_2,
    output logic [7:0] dfi_lpddr4_if_dfi_wrdata_mask_2,
    input logic [63:0] dfi_lpddr4_if_dfi_rdata_2,
    input logic dfi_lpddr4_if_dfi_rddata_valid_2,
    output logic dfi_lpddr4_if_dfi_rddata_en_2,
    output logic dfi_lpddr4_if_dfi_wrdata_en_2,

    output logic dfi_lpddr4_if_dfi_cs_3,
    output logic [5:0] dfi_lpddr4_if_dfi_ca_3,
    output logic dfi_lpddr4_if_dfi_cke_3,
    output logic dfi_lpddr4_if_dfi_odt_3,
    output logic dfi_lpddr4_if_dfi_reset_n_3,
    output logic dfi_lpddr4_if_dfi_act_n_3,
    output logic [63:0] dfi_lpddr4_if_dfi_wrdata_3,
    output logic [7:0] dfi_lpddr4_if_dfi_wrdata_mask_3,
    input logic [63:0] dfi_lpddr4_if_dfi_rdata_3,
    input logic dfi_lpddr4_if_dfi_rddata_valid_3,
    output logic dfi_lpddr4_if_dfi_rddata_en_3,
    output logic dfi_lpddr4_if_dfi_wrdata_en_3,

    //CSR
    input [1:0] mul_rd_phase_cfg,
    input [1:0] mul_wr_phase_cfg,
    input [1:0] mul_rdcmd_phase_cfg,
    input [1:0] mul_wrcmd_phase_cfg,
    input [7:0] mul_tRRD_cfg,
    input [7:0] mul_tFAW_cfg,
    input [7:0] mul_tCCD_cfg,
    input [7:0] mul_WTR_LATENCY_cfg,
    input [7:0] mul_RTW_LATENCY_cfg,
    input [7:0] mul_READ_TIME_cfg,
    input [7:0] mul_WRITE_TIME_cfg,

    input [11:0] ref_tREFI_cfg,
    input [3:0] ref_POSTPONE_cfg,
    input [7:0] ref_tRP_cfg,
    input [7:0] ref_tRFC_cfg,

    input [7:0] bm_tWTP_cfg,
    input [7:0] bm_tRTP_cfg,
    input [7:0] bm_tRAS_cfg,
    input [7:0] bm_tRC_cfg,
    input [7:0] bm_tRP_cfg,
    input [7:0] bm_tRCD_cfg,
    input [7:0] bm_tCCDMW_cfg,

    input [7:0] crb_READ_LATENCY_cfg,
    input [7:0] crb_WRITE_LATENCY_cfg,
    input [7:0] dfi_rddata_en_latency_cfg,
    input [7:0] dfi_wrdata_en_latency_cfg,

    input [7:0] dfi_wdqs_preamble_cfg
);
litedram_interface litedram_if(clk,rst);

crossbar_2ports u_crossbar_2ports (
    .sys_clk                      (clk),
    .sys_rst                      (rst),
    .crb_READ_LATENCY_cfg     (crb_READ_LATENCY_cfg),
    .crb_WRITE_LATENCY_cfg    (crb_WRITE_LATENCY_cfg),

    .cmd_valid                 (cmd_valid),
    .cmd_ready                 (cmd_ready),
    .cmd_first                 (cmd_first),
    .cmd_last                  (cmd_last),
    .cmd_payload_mw            (cmd_payload_mw),
    .cmd_payload_we            (cmd_payload_we),
    .cmd_payload_addr          (cmd_payload_addr),
    .wdata_valid               (wdata_valid),
    .wdata_ready               (wdata_ready),
    .wdata_first               (wdata_first),
    .wdata_last                (wdata_last),
    .wdata_payload_data        (wdata_payload_data),
    .wdata_payload_we          (wdata_payload_we),
    .rdata_valid               (rdata_valid),
    .rdata_ready               (rdata_ready),
    .rdata_first               (rdata_first),
    .rdata_last                (rdata_last),
    .rdata_payload_data        (rdata_payload_data),

    .cmd_valid_1                 (cmd_valid_1),
    .cmd_ready_1                 (cmd_ready_1),
    .cmd_first_1                 (cmd_first_1),
    .cmd_last_1                  (cmd_last_1),
    .cmd_payload_mw_1            (cmd_payload_mw_1),
    .cmd_payload_we_1            (cmd_payload_we_1),
    .cmd_payload_addr_1          (cmd_payload_addr_1),
    .wdata_valid_1               (wdata_valid_1),
    .wdata_ready_1               (wdata_ready_1),
    .wdata_first_1               (wdata_first_1),
    .wdata_last_1                (wdata_last_1),
    .wdata_payload_data_1        (wdata_payload_data_1),
    .wdata_payload_we_1          (wdata_payload_we_1),
    .rdata_valid_1               (rdata_valid_1),
    .rdata_ready_1               (rdata_ready_1),
    .rdata_first_1               (rdata_first_1),
    .rdata_last_1                (rdata_last_1),
    .rdata_payload_data_1        (rdata_payload_data_1),

    .interface_bank0_valid          (litedram_if.litedram_cmd_if_0.interface_bank_valid),
    .interface_bank0_ready          (litedram_if.litedram_cmd_if_0.interface_bank_ready),
    .interface_bank0_mw             (litedram_if.litedram_cmd_if_0.interface_bank_mw),
    .interface_bank0_we             (litedram_if.litedram_cmd_if_0.interface_bank_we),
    .interface_bank0_addr           (litedram_if.litedram_cmd_if_0.interface_bank_addr),
    .interface_bank0_lock           (litedram_if.litedram_cmd_if_0.interface_bank_lock),
    .interface_bank0_wdata_ready    (litedram_if.litedram_cmd_if_0.interface_bank_wdata_ready),
    .interface_bank0_rdata_valid    (litedram_if.litedram_cmd_if_0.interface_bank_rdata_valid),
    .interface_bank1_valid          (litedram_if.litedram_cmd_if_1.interface_bank_valid),
    .interface_bank1_ready          (litedram_if.litedram_cmd_if_1.interface_bank_ready),
    .interface_bank1_mw             (litedram_if.litedram_cmd_if_1.interface_bank_mw),
    .interface_bank1_we             (litedram_if.litedram_cmd_if_1.interface_bank_we),
    .interface_bank1_addr           (litedram_if.litedram_cmd_if_1.interface_bank_addr),
    .interface_bank1_lock           (litedram_if.litedram_cmd_if_1.interface_bank_lock),
    .interface_bank1_wdata_ready    (litedram_if.litedram_cmd_if_1.interface_bank_wdata_ready),
    .interface_bank1_rdata_valid    (litedram_if.litedram_cmd_if_1.interface_bank_rdata_valid),
    .interface_bank2_valid          (litedram_if.litedram_cmd_if_2.interface_bank_valid),
    .interface_bank2_ready          (litedram_if.litedram_cmd_if_2.interface_bank_ready),
    .interface_bank2_mw             (litedram_if.litedram_cmd_if_2.interface_bank_mw),
    .interface_bank2_we             (litedram_if.litedram_cmd_if_2.interface_bank_we),
    .interface_bank2_addr           (litedram_if.litedram_cmd_if_2.interface_bank_addr),
    .interface_bank2_lock           (litedram_if.litedram_cmd_if_2.interface_bank_lock),
    .interface_bank2_wdata_ready    (litedram_if.litedram_cmd_if_2.interface_bank_wdata_ready),
    .interface_bank2_rdata_valid    (litedram_if.litedram_cmd_if_2.interface_bank_rdata_valid),
    .interface_bank3_valid          (litedram_if.litedram_cmd_if_3.interface_bank_valid),
    .interface_bank3_ready          (litedram_if.litedram_cmd_if_3.interface_bank_ready),
    .interface_bank3_mw             (litedram_if.litedram_cmd_if_3.interface_bank_mw),
    .interface_bank3_we             (litedram_if.litedram_cmd_if_3.interface_bank_we),
    .interface_bank3_addr           (litedram_if.litedram_cmd_if_3.interface_bank_addr),
    .interface_bank3_lock           (litedram_if.litedram_cmd_if_3.interface_bank_lock),
    .interface_bank3_wdata_ready    (litedram_if.litedram_cmd_if_3.interface_bank_wdata_ready),
    .interface_bank3_rdata_valid    (litedram_if.litedram_cmd_if_3.interface_bank_rdata_valid),
    .interface_bank4_valid          (litedram_if.litedram_cmd_if_4.interface_bank_valid),
    .interface_bank4_ready          (litedram_if.litedram_cmd_if_4.interface_bank_ready),
    .interface_bank4_mw             (litedram_if.litedram_cmd_if_4.interface_bank_mw),
    .interface_bank4_we             (litedram_if.litedram_cmd_if_4.interface_bank_we),
    .interface_bank4_addr           (litedram_if.litedram_cmd_if_4.interface_bank_addr),
    .interface_bank4_lock           (litedram_if.litedram_cmd_if_4.interface_bank_lock),
    .interface_bank4_wdata_ready    (litedram_if.litedram_cmd_if_4.interface_bank_wdata_ready),
    .interface_bank4_rdata_valid    (litedram_if.litedram_cmd_if_4.interface_bank_rdata_valid),
    .interface_bank5_valid          (litedram_if.litedram_cmd_if_5.interface_bank_valid),
    .interface_bank5_ready          (litedram_if.litedram_cmd_if_5.interface_bank_ready),
    .interface_bank5_mw             (litedram_if.litedram_cmd_if_5.interface_bank_mw),
    .interface_bank5_we             (litedram_if.litedram_cmd_if_5.interface_bank_we),
    .interface_bank5_addr           (litedram_if.litedram_cmd_if_5.interface_bank_addr),
    .interface_bank5_lock           (litedram_if.litedram_cmd_if_5.interface_bank_lock),
    .interface_bank5_wdata_ready    (litedram_if.litedram_cmd_if_5.interface_bank_wdata_ready),
    .interface_bank5_rdata_valid    (litedram_if.litedram_cmd_if_5.interface_bank_rdata_valid),
    .interface_bank6_valid          (litedram_if.litedram_cmd_if_6.interface_bank_valid),
    .interface_bank6_ready          (litedram_if.litedram_cmd_if_6.interface_bank_ready),
    .interface_bank6_mw             (litedram_if.litedram_cmd_if_6.interface_bank_mw),
    .interface_bank6_we             (litedram_if.litedram_cmd_if_6.interface_bank_we),
    .interface_bank6_addr           (litedram_if.litedram_cmd_if_6.interface_bank_addr),
    .interface_bank6_lock           (litedram_if.litedram_cmd_if_6.interface_bank_lock),
    .interface_bank6_wdata_ready    (litedram_if.litedram_cmd_if_6.interface_bank_wdata_ready),
    .interface_bank6_rdata_valid    (litedram_if.litedram_cmd_if_6.interface_bank_rdata_valid),
    .interface_bank7_valid          (litedram_if.litedram_cmd_if_7.interface_bank_valid),
    .interface_bank7_ready          (litedram_if.litedram_cmd_if_7.interface_bank_ready),
    .interface_bank7_mw             (litedram_if.litedram_cmd_if_7.interface_bank_mw),
    .interface_bank7_we             (litedram_if.litedram_cmd_if_7.interface_bank_we),
    .interface_bank7_addr           (litedram_if.litedram_cmd_if_7.interface_bank_addr),
    .interface_bank7_lock           (litedram_if.litedram_cmd_if_7.interface_bank_lock),
    .interface_bank7_wdata_ready    (litedram_if.litedram_cmd_if_7.interface_bank_wdata_ready),
    .interface_bank7_rdata_valid    (litedram_if.litedram_cmd_if_7.interface_bank_rdata_valid),
    .interface_wdata                (litedram_if.litedram_data_if.interface_wdata),
    .interface_wdata_we             (litedram_if.litedram_data_if.interface_wdata_we),
    .interface_rdata                (litedram_if.litedram_data_if.interface_rdata)

);

cmd_rw_interface cmd_rw_if_0(clk,rst);
cmd_rw_interface cmd_rw_if_1(clk,rst);
cmd_rw_interface cmd_rw_if_2(clk,rst);
cmd_rw_interface cmd_rw_if_3(clk,rst);
cmd_rw_interface cmd_rw_if_4(clk,rst);
cmd_rw_interface cmd_rw_if_5(clk,rst);
cmd_rw_interface cmd_rw_if_6(clk,rst);
cmd_rw_interface cmd_rw_if_7(clk,rst);

bankmachine_wrapper u_bankmachine_wrapper (
    .clk              (clk),
    .rst              (rst),
    .litedram_if      (litedram_if),
    .cmd_rw_if_0      (cmd_rw_if_0),
    .cmd_rw_if_1      (cmd_rw_if_1),
    .cmd_rw_if_2      (cmd_rw_if_2),
    .cmd_rw_if_3      (cmd_rw_if_3),
    .cmd_rw_if_4      (cmd_rw_if_4),
    .cmd_rw_if_5      (cmd_rw_if_5),
    .cmd_rw_if_6      (cmd_rw_if_6),
    .cmd_rw_if_7      (cmd_rw_if_7),
    .bm_tRTP_cfg      (bm_tRTP_cfg),
    .bm_tWTP_cfg      (bm_tWTP_cfg),
    .bm_tRC_cfg       (bm_tRC_cfg),
    .bm_tRAS_cfg      (bm_tRAS_cfg),
    .bm_tRP_cfg       (bm_tRP_cfg),
    .bm_tRCD_cfg      (bm_tRCD_cfg),
    .bm_tCCDMW_cfg    (bm_tCCDMW_cfg)
);

cmd_rw_interface cmd_rw_if_refresher(clk,rst);

refresher_pos_8_wrapper u_refresher_pos_8_wrapper (
    .cmd_rw_if_refresher    (cmd_rw_if_refresher),
    .ref_tRP_cfg            (ref_tRP_cfg),
    .ref_tRFC_cfg           (ref_tRFC_cfg),
    .ref_tREFI_cfg          (ref_tREFI_cfg),
    .ref_POSTPONE_cfg       (ref_POSTPONE_cfg),
    .clk                    (clk),
    .rst                    (rst)
);

dfi_interface dfi_if(clk,rst);

multiplexer_b8_wrapper u_multiplexer_b8_wrapper (
    .clk                    (clk),
    .rst                    (rst),
    .cmd_rw_if_0            (cmd_rw_if_0),
    .cmd_rw_if_1            (cmd_rw_if_1),
    .cmd_rw_if_2            (cmd_rw_if_2),
    .cmd_rw_if_3            (cmd_rw_if_3),
    .cmd_rw_if_4            (cmd_rw_if_4),
    .cmd_rw_if_5            (cmd_rw_if_5),
    .cmd_rw_if_6            (cmd_rw_if_6),
    .cmd_rw_if_7            (cmd_rw_if_7),
    .litedram_if            (litedram_if),
    .dfi_if                 (dfi_if),
    .cmd_rw_if_refresher    (cmd_rw_if_refresher),
    .mul_tRRD_cfg           (mul_tRRD_cfg),
    .mul_tFAW_cfg           (mul_tFAW_cfg),
    .mul_tCCD_cfg           (mul_tCCD_cfg),
    .mul_WTR_LATENCY_cfg    (mul_WTR_LATENCY_cfg),
    .mul_RTW_LATENCY_cfg    (mul_RTW_LATENCY_cfg),
    .mul_READ_TIME_cfg      (mul_READ_TIME_cfg),
    .mul_WRITE_TIME_cfg     (mul_WRITE_TIME_cfg),
    .mul_rd_phase_cfg       (mul_rd_phase_cfg),
    .mul_wr_phase_cfg       (mul_wr_phase_cfg),
    .mul_rdcmd_phase_cfg    (mul_rdcmd_phase_cfg),
    .mul_wrcmd_phase_cfg    (mul_wrcmd_phase_cfg)
);


DFIAdapter u_DFIAdapter (
    .dfi_p0_address    (dfi_if.dfi_phase0_interface_if.address),
    .dfi_p0_bank       ({3'd0,dfi_if.dfi_phase0_interface_if.bank}),
    .dfi_p0_cas_n      (dfi_if.dfi_phase0_interface_if.cas_n),
    .dfi_p0_cs_n       (dfi_if.dfi_phase0_interface_if.cs_n),
    .dfi_p0_ras_n      (dfi_if.dfi_phase0_interface_if.ras_n),
    .dfi_p0_we_n       (dfi_if.dfi_phase0_interface_if.we_n),
    .dfi_p0_mw         (dfi_if.dfi_phase0_interface_if.mw),
    .dfi_p1_address    (dfi_if.dfi_phase1_interface_if.address),
    .dfi_p1_bank       ({3'd0,dfi_if.dfi_phase1_interface_if.bank}),
    .dfi_p1_cas_n      (dfi_if.dfi_phase1_interface_if.cas_n),
    .dfi_p1_cs_n       (dfi_if.dfi_phase1_interface_if.cs_n),
    .dfi_p1_ras_n      (dfi_if.dfi_phase1_interface_if.ras_n),
    .dfi_p1_we_n       (dfi_if.dfi_phase1_interface_if.we_n),
    .dfi_p1_mw         (dfi_if.dfi_phase1_interface_if.mw),
    .dfi_p2_address    (dfi_if.dfi_phase2_interface_if.address),
    .dfi_p2_bank       ({3'd0,dfi_if.dfi_phase2_interface_if.bank}),
    .dfi_p2_cas_n      (dfi_if.dfi_phase2_interface_if.cas_n),
    .dfi_p2_cs_n       (dfi_if.dfi_phase2_interface_if.cs_n),
    .dfi_p2_ras_n      (dfi_if.dfi_phase2_interface_if.ras_n),
    .dfi_p2_we_n       (dfi_if.dfi_phase2_interface_if.we_n),
    .dfi_p2_mw         (dfi_if.dfi_phase2_interface_if.mw),
    .dfi_p3_address    (dfi_if.dfi_phase3_interface_if.address),
    .dfi_p3_bank       ({3'd0,dfi_if.dfi_phase3_interface_if.bank}),
    .dfi_p3_cas_n      (dfi_if.dfi_phase3_interface_if.cas_n),
    .dfi_p3_cs_n       (dfi_if.dfi_phase3_interface_if.cs_n),
    .dfi_p3_ras_n      (dfi_if.dfi_phase3_interface_if.ras_n),
    .dfi_p3_we_n       (dfi_if.dfi_phase3_interface_if.we_n),
    .dfi_p3_mw         (dfi_if.dfi_phase3_interface_if.mw),
    .cs                ({dfi_lpddr4_if_dfi_cs_3,dfi_lpddr4_if_dfi_cs_2,dfi_lpddr4_if_dfi_cs_1,dfi_lpddr4_if_dfi_cs_0}),
    .ca                ({dfi_lpddr4_if_dfi_ca_3[0],dfi_lpddr4_if_dfi_ca_2[0],dfi_lpddr4_if_dfi_ca_1[0],dfi_lpddr4_if_dfi_ca_0[0]}),
    .ca_1              ({dfi_lpddr4_if_dfi_ca_3[1],dfi_lpddr4_if_dfi_ca_2[1],dfi_lpddr4_if_dfi_ca_1[1],dfi_lpddr4_if_dfi_ca_0[1]}),
    .ca_2              ({dfi_lpddr4_if_dfi_ca_3[2],dfi_lpddr4_if_dfi_ca_2[2],dfi_lpddr4_if_dfi_ca_1[2],dfi_lpddr4_if_dfi_ca_0[2]}),
    .ca_3              ({dfi_lpddr4_if_dfi_ca_3[3],dfi_lpddr4_if_dfi_ca_2[3],dfi_lpddr4_if_dfi_ca_1[3],dfi_lpddr4_if_dfi_ca_0[3]}),
    .ca_4              ({dfi_lpddr4_if_dfi_ca_3[4],dfi_lpddr4_if_dfi_ca_2[4],dfi_lpddr4_if_dfi_ca_1[4],dfi_lpddr4_if_dfi_ca_0[4]}),
    .ca_5              ({dfi_lpddr4_if_dfi_ca_3[5],dfi_lpddr4_if_dfi_ca_2[5],dfi_lpddr4_if_dfi_ca_1[5],dfi_lpddr4_if_dfi_ca_0[5]}),
    .sys_clk           (clk),
    .sys_rst           (rst)
);

    always_comb begin

        dfi_lpddr4_if_dfi_cke_0 = dfi_if.dfi_phase0_interface_if.cke;
        dfi_lpddr4_if_dfi_cke_1 = dfi_if.dfi_phase1_interface_if.cke;
        dfi_lpddr4_if_dfi_cke_2 = dfi_if.dfi_phase2_interface_if.cke;
        dfi_lpddr4_if_dfi_cke_3 = dfi_if.dfi_phase3_interface_if.cke;

        dfi_lpddr4_if_dfi_odt_0 = dfi_if.dfi_phase0_interface_if.odt;
        dfi_lpddr4_if_dfi_odt_1 = dfi_if.dfi_phase1_interface_if.odt;
        dfi_lpddr4_if_dfi_odt_2 = dfi_if.dfi_phase2_interface_if.odt;
        dfi_lpddr4_if_dfi_odt_3 = dfi_if.dfi_phase3_interface_if.odt;

        dfi_lpddr4_if_dfi_reset_n_0 = dfi_if.dfi_phase0_interface_if.reset_n;
        dfi_lpddr4_if_dfi_reset_n_1 = dfi_if.dfi_phase1_interface_if.reset_n;
        dfi_lpddr4_if_dfi_reset_n_2 = dfi_if.dfi_phase2_interface_if.reset_n;
        dfi_lpddr4_if_dfi_reset_n_3 = dfi_if.dfi_phase3_interface_if.reset_n;

        dfi_lpddr4_if_dfi_act_n_0 = dfi_if.dfi_phase0_interface_if.act_n;
        dfi_lpddr4_if_dfi_act_n_1 = dfi_if.dfi_phase1_interface_if.act_n;
        dfi_lpddr4_if_dfi_act_n_2 = dfi_if.dfi_phase2_interface_if.act_n;
        dfi_lpddr4_if_dfi_act_n_3 = dfi_if.dfi_phase3_interface_if.act_n;

        dfi_lpddr4_if_dfi_wrdata_0 = dfi_if.dfi_phase0_interface_if.wrdata;
        dfi_lpddr4_if_dfi_wrdata_1 = dfi_if.dfi_phase1_interface_if.wrdata;
        dfi_lpddr4_if_dfi_wrdata_2 = dfi_if.dfi_phase2_interface_if.wrdata;
        dfi_lpddr4_if_dfi_wrdata_3 = dfi_if.dfi_phase3_interface_if.wrdata;


        dfi_lpddr4_if_dfi_wrdata_mask_0 = dfi_if.dfi_phase0_interface_if.wrdata_mask;
        dfi_lpddr4_if_dfi_wrdata_mask_1 = dfi_if.dfi_phase1_interface_if.wrdata_mask;
        dfi_lpddr4_if_dfi_wrdata_mask_2 = dfi_if.dfi_phase2_interface_if.wrdata_mask;
        dfi_lpddr4_if_dfi_wrdata_mask_3 = dfi_if.dfi_phase3_interface_if.wrdata_mask;

        dfi_if.dfi_phase0_interface_if.rddata = dfi_lpddr4_if_dfi_rdata_0;
        dfi_if.dfi_phase1_interface_if.rddata = dfi_lpddr4_if_dfi_rdata_1;
        dfi_if.dfi_phase2_interface_if.rddata = dfi_lpddr4_if_dfi_rdata_2;
        dfi_if.dfi_phase3_interface_if.rddata = dfi_lpddr4_if_dfi_rdata_3;

        dfi_if.dfi_phase0_interface_if.rddata_valid = dfi_lpddr4_if_dfi_rddata_valid_0;
        dfi_if.dfi_phase1_interface_if.rddata_valid = dfi_lpddr4_if_dfi_rddata_valid_1;
        dfi_if.dfi_phase2_interface_if.rddata_valid = dfi_lpddr4_if_dfi_rddata_valid_2;
        dfi_if.dfi_phase3_interface_if.rddata_valid = dfi_lpddr4_if_dfi_rddata_valid_3;

    end

logic [31:0] rddata_en_dly_line;
logic rddata_en_dly;
logic [31:0] wrdata_en_dly_line;
logic wrdata_en_dly_pre;
logic wrdata_en_dly;

tapped_delay_line32 #(.WIDTH(1)) u_tapped_delay_rden  (
    .clk        (clk),
    .rst        (rst),
    .i_d        (dfi_if.dfi_phase0_interface_if.rddata_en|dfi_if.dfi_phase1_interface_if.rddata_en|dfi_if.dfi_phase2_interface_if.rddata_en|dfi_if.dfi_phase3_interface_if.rddata_en),
    .o_d_dly    (rddata_en_dly_line)
);

assign rddata_en_dly=rddata_en_dly_line[dfi_rddata_en_latency_cfg];

assign dfi_lpddr4_if_dfi_rddata_en_0 = rddata_en_dly;
assign dfi_lpddr4_if_dfi_rddata_en_1 = rddata_en_dly;
assign dfi_lpddr4_if_dfi_rddata_en_2 = rddata_en_dly;
assign dfi_lpddr4_if_dfi_rddata_en_3 = rddata_en_dly;


tapped_delay_line32 u_tapped_delay_wren (
    .clk        (clk),
    .rst        (rst),
    .i_d        (dfi_if.dfi_phase0_interface_if.wrdata_en|dfi_if.dfi_phase1_interface_if.wrdata_en|dfi_if.dfi_phase2_interface_if.wrdata_en|dfi_if.dfi_phase3_interface_if.wrdata_en),
    .o_d_dly    (wrdata_en_dly_line)
);

always_ff@(posedge clk,posedge rst) begin
    if(rst) wrdata_en_dly_pre<=0;
    else wrdata_en_dly_pre<=wrdata_en_dly;
end

assign wrdata_en_dly=wrdata_en_dly_line[dfi_wrdata_en_latency_cfg];

assign dfi_lpddr4_if_dfi_wrdata_en_0 = (~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[1]:wrdata_en_dly;
assign dfi_lpddr4_if_dfi_wrdata_en_1 = (~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[3]:wrdata_en_dly;
assign dfi_lpddr4_if_dfi_wrdata_en_2 = (~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[5]:wrdata_en_dly;
assign dfi_lpddr4_if_dfi_wrdata_en_3 = (~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[7]:wrdata_en_dly;



endmodule
