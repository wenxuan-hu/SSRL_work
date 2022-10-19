module mc_core(
    native_interface native_if_0,native_if_1,
    dfi_lpddr4_interface dfi_lpddr4_if,
	//system clock/reset
	input clk,
	input rst,

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

crossbar_2ports_wrapper u_crossbar_2ports_wrapper (
    .clk                      (clk),
    .rst                      (rst),
    .crb_READ_LATENCY_cfg     (crb_READ_LATENCY_cfg),
    .crb_WRITE_LATENCY_cfg    (crb_WRITE_LATENCY_cfg),
    .native_if_0              (native_if_0),
    .native_if_1              (native_if_1),
    .litedram_if              (litedram_if)
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
    .cs                ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase2_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase1_lpddr4_if.cs,dfi_lpddr4_if.dfi_phase0_lpddr4_if.cs}),
    .ca                ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[0],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[0],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[0],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[0]}),
    .ca_1              ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[1],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[1],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[1],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[1]}),
    .ca_2              ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[2],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[2],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[2],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[2]}),
    .ca_3              ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[3],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[3],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[3],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[3]}),
    .ca_4              ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[4],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[4],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[4],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[4]}),
    .ca_5              ({dfi_lpddr4_if.dfi_phase3_lpddr4_if.ca[5],dfi_lpddr4_if.dfi_phase2_lpddr4_if.ca[5],dfi_lpddr4_if.dfi_phase1_lpddr4_if.ca[5],dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca[5]}),
    .sys_clk           (clk),
    .sys_rst           (rst)
);

    always_comb begin
        dfi_lpddr4_if.dfi_phase0_lpddr4_if.cke=dfi_if.dfi_phase0_interface_if.cke;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.cke=dfi_if.dfi_phase1_interface_if.cke;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.cke=dfi_if.dfi_phase2_interface_if.cke;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.cke=dfi_if.dfi_phase3_interface_if.cke;

        dfi_lpddr4_if.dfi_phase0_lpddr4_if.odt=dfi_if.dfi_phase0_interface_if.odt;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.odt=dfi_if.dfi_phase1_interface_if.odt;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.odt=dfi_if.dfi_phase2_interface_if.odt;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.odt=dfi_if.dfi_phase3_interface_if.odt;

        dfi_lpddr4_if.dfi_phase0_lpddr4_if.reset_n=dfi_if.dfi_phase0_interface_if.reset_n;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.reset_n=dfi_if.dfi_phase1_interface_if.reset_n;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.reset_n=dfi_if.dfi_phase2_interface_if.reset_n;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.reset_n=dfi_if.dfi_phase3_interface_if.reset_n;

        dfi_lpddr4_if.dfi_phase0_lpddr4_if.act_n=dfi_if.dfi_phase0_interface_if.act_n;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.act_n=dfi_if.dfi_phase1_interface_if.act_n;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.act_n=dfi_if.dfi_phase2_interface_if.act_n;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.act_n=dfi_if.dfi_phase3_interface_if.act_n;

        dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata=dfi_if.dfi_phase0_interface_if.wrdata;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata=dfi_if.dfi_phase1_interface_if.wrdata;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata=dfi_if.dfi_phase2_interface_if.wrdata;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata=dfi_if.dfi_phase3_interface_if.wrdata;

        dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_mask=dfi_if.dfi_phase0_interface_if.wrdata_mask;
        dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_mask=dfi_if.dfi_phase1_interface_if.wrdata_mask;
        dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_mask=dfi_if.dfi_phase2_interface_if.wrdata_mask;
        dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_mask=dfi_if.dfi_phase3_interface_if.wrdata_mask;

        dfi_if.dfi_phase0_interface_if.rddata=dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata;
        dfi_if.dfi_phase1_interface_if.rddata=dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata;
        dfi_if.dfi_phase2_interface_if.rddata=dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata;
        dfi_if.dfi_phase3_interface_if.rddata=dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata;

        dfi_if.dfi_phase0_interface_if.rddata_valid=dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_valid;
        dfi_if.dfi_phase1_interface_if.rddata_valid=dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_valid;
        dfi_if.dfi_phase2_interface_if.rddata_valid=dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_valid;
        dfi_if.dfi_phase3_interface_if.rddata_valid=dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_valid;
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

assign dfi_lpddr4_if.dfi_phase0_lpddr4_if.rddata_en=rddata_en_dly;
assign dfi_lpddr4_if.dfi_phase1_lpddr4_if.rddata_en=rddata_en_dly;
assign dfi_lpddr4_if.dfi_phase2_lpddr4_if.rddata_en=rddata_en_dly;
assign dfi_lpddr4_if.dfi_phase3_lpddr4_if.rddata_en=rddata_en_dly;

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

assign dfi_lpddr4_if.dfi_phase0_lpddr4_if.wrdata_en=(~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[1]:wrdata_en_dly;
assign dfi_lpddr4_if.dfi_phase1_lpddr4_if.wrdata_en=(~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[3]:wrdata_en_dly;
assign dfi_lpddr4_if.dfi_phase2_lpddr4_if.wrdata_en=(~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[5]:wrdata_en_dly;
assign dfi_lpddr4_if.dfi_phase3_lpddr4_if.wrdata_en=(~wrdata_en_dly_pre && wrdata_en_dly)? dfi_wdqs_preamble_cfg[7]:wrdata_en_dly;


endmodule