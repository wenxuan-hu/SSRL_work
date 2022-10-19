`timescale 1ns/10ps

module multiplexer_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    logic clk,rst;
    dfi_interface dfi_if(clk,rst);
    cmd_rw_interface cmd_rw_if_0(clk,rst);
    cmd_rw_interface cmd_rw_if_1(clk,rst);
    cmd_rw_interface cmd_rw_if_2(clk,rst);
    cmd_rw_interface cmd_rw_if_3(clk,rst);
    cmd_rw_interface cmd_rw_if_4(clk,rst);
    cmd_rw_interface cmd_rw_if_5(clk,rst);
    cmd_rw_interface cmd_rw_if_6(clk,rst);
    cmd_rw_interface cmd_rw_if_7(clk,rst);

    cmd_rw_interface cmd_rw_if_refresher(clk,rst);

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

    multiplexer_b8 u_multiplexer_b8 (
    .interface_wdata           ('d0),
    .interface_wdata_we        ('d0),
    .interface_rdata           (),
    .dfi_p0_address            (dfi_if.dfi_phase0_interface_if.address),
    .dfi_p0_bank               (dfi_if.dfi_phase0_interface_if.bank),
    .dfi_p0_cas_n              (dfi_if.dfi_phase0_interface_if.cas_n),
    .dfi_p0_cs_n               (dfi_if.dfi_phase0_interface_if.cs_n),
    .dfi_p0_ras_n              (dfi_if.dfi_phase0_interface_if.ras_n),
    .dfi_p0_we_n               (dfi_if.dfi_phase0_interface_if.we_n),
    .dfi_p0_cke                (dfi_if.dfi_phase0_interface_if.cke),
    .dfi_p0_odt                (dfi_if.dfi_phase0_interface_if.odt),
    .dfi_p0_reset_n            (dfi_if.dfi_phase0_interface_if.reset_n),
    .dfi_p0_act_n              (dfi_if.dfi_phase0_interface_if.act_n),
    .dfi_p0_mw                 (dfi_if.dfi_phase0_interface_if.mw),
    .dfi_p0_wrdata             (dfi_if.dfi_phase0_interface_if.wrdata),
    .dfi_p0_wrdata_en          (dfi_if.dfi_phase0_interface_if.wrdata_en),
    .dfi_p0_wrdata_mask        (dfi_if.dfi_phase0_interface_if.wrdata_mask),
    .dfi_p0_rddata_en          (dfi_if.dfi_phase0_interface_if.rddata_en),
    .dfi_p0_rddata             (dfi_if.dfi_phase0_interface_if.rddata),
    .dfi_p0_rddata_valid       (dfi_if.dfi_phase0_interface_if.rddata_valid),
    .dfi_p1_address            (dfi_if.dfi_phase1_interface_if.address),
    .dfi_p1_bank               (dfi_if.dfi_phase1_interface_if.bank),
    .dfi_p1_cas_n              (dfi_if.dfi_phase1_interface_if.cas_n),
    .dfi_p1_cs_n               (dfi_if.dfi_phase1_interface_if.cs_n),
    .dfi_p1_ras_n              (dfi_if.dfi_phase1_interface_if.ras_n),
    .dfi_p1_we_n               (dfi_if.dfi_phase1_interface_if.we_n),
    .dfi_p1_cke                (dfi_if.dfi_phase1_interface_if.cke),
    .dfi_p1_odt                (dfi_if.dfi_phase1_interface_if.odt),
    .dfi_p1_reset_n            (dfi_if.dfi_phase1_interface_if.reset_n),
    .dfi_p1_act_n              (dfi_if.dfi_phase1_interface_if.act_n),
    .dfi_p1_mw                 (dfi_if.dfi_phase1_interface_if.mw),
    .dfi_p1_wrdata             (dfi_if.dfi_phase1_interface_if.wrdata),
    .dfi_p1_wrdata_en          (dfi_if.dfi_phase1_interface_if.wrdata_en),
    .dfi_p1_wrdata_mask        (dfi_if.dfi_phase1_interface_if.wrdata_mask),
    .dfi_p1_rddata_en          (dfi_if.dfi_phase1_interface_if.rddata_en),
    .dfi_p1_rddata             (dfi_if.dfi_phase1_interface_if.rddata),
    .dfi_p1_rddata_valid       (dfi_if.dfi_phase1_interface_if.rddata_valid),
    .dfi_p2_address            (dfi_if.dfi_phase2_interface_if.address),
    .dfi_p2_bank               (dfi_if.dfi_phase2_interface_if.bank),
    .dfi_p2_cas_n              (dfi_if.dfi_phase2_interface_if.cas_n),
    .dfi_p2_cs_n               (dfi_if.dfi_phase2_interface_if.cs_n),
    .dfi_p2_ras_n              (dfi_if.dfi_phase2_interface_if.ras_n),
    .dfi_p2_we_n               (dfi_if.dfi_phase2_interface_if.we_n),
    .dfi_p2_cke                (dfi_if.dfi_phase2_interface_if.cke),
    .dfi_p2_odt                (dfi_if.dfi_phase2_interface_if.odt),
    .dfi_p2_reset_n            (dfi_if.dfi_phase2_interface_if.reset_n),
    .dfi_p2_act_n              (dfi_if.dfi_phase2_interface_if.act_n),
    .dfi_p2_mw                 (dfi_if.dfi_phase2_interface_if.mw),
    .dfi_p2_wrdata             (dfi_if.dfi_phase2_interface_if.wrdata),
    .dfi_p2_wrdata_en          (dfi_if.dfi_phase2_interface_if.wrdata_en),
    .dfi_p2_wrdata_mask        (dfi_if.dfi_phase2_interface_if.wrdata_mask),
    .dfi_p2_rddata_en          (dfi_if.dfi_phase2_interface_if.rddata_en),
    .dfi_p2_rddata             (dfi_if.dfi_phase2_interface_if.rddata),
    .dfi_p2_rddata_valid       (dfi_if.dfi_phase2_interface_if.rddata_valid),
    .dfi_p3_address            (dfi_if.dfi_phase3_interface_if.address),
    .dfi_p3_bank               (dfi_if.dfi_phase3_interface_if.bank),
    .dfi_p3_cas_n              (dfi_if.dfi_phase3_interface_if.cas_n),
    .dfi_p3_cs_n               (dfi_if.dfi_phase3_interface_if.cs_n),
    .dfi_p3_ras_n              (dfi_if.dfi_phase3_interface_if.ras_n),
    .dfi_p3_we_n               (dfi_if.dfi_phase3_interface_if.we_n),
    .dfi_p3_cke                (dfi_if.dfi_phase3_interface_if.cke),
    .dfi_p3_odt                (dfi_if.dfi_phase3_interface_if.odt),
    .dfi_p3_reset_n            (dfi_if.dfi_phase3_interface_if.reset_n),
    .dfi_p3_act_n              (dfi_if.dfi_phase3_interface_if.act_n),
    .dfi_p3_mw                 (dfi_if.dfi_phase3_interface_if.mw),
    .dfi_p3_wrdata             (dfi_if.dfi_phase3_interface_if.wrdata),
    .dfi_p3_wrdata_en          (dfi_if.dfi_phase3_interface_if.wrdata_en),
    .dfi_p3_wrdata_mask        (dfi_if.dfi_phase3_interface_if.wrdata_mask),
    .dfi_p3_rddata_en          (dfi_if.dfi_phase3_interface_if.rddata_en),
    .dfi_p3_rddata             (dfi_if.dfi_phase3_interface_if.rddata),
    .dfi_p3_rddata_valid       (dfi_if.dfi_phase3_interface_if.rddata_valid),
    .cmd_valid                 (cmd_rw_if_refresher.cmd_valid),
    .cmd_ready                 (cmd_rw_if_refresher.cmd_ready),
    .cmd_first                 (cmd_rw_if_refresher.cmd_first),
    .cmd_last                  (cmd_rw_if_refresher.cmd_last),
    .cmd_payload_a             (cmd_rw_if_refresher.cmd_payload_a),
    .cmd_payload_ba            (cmd_rw_if_refresher.cmd_payload_ba),
    .cmd_payload_cas           (cmd_rw_if_refresher.cmd_payload_cas),
    .cmd_payload_ras           (cmd_rw_if_refresher.cmd_payload_ras),
    .cmd_payload_we            (cmd_rw_if_refresher.cmd_payload_we),
    .cmd_payload_is_cmd        (cmd_rw_if_refresher.cmd_payload_is_cmd),
    .cmd_payload_is_read       (cmd_rw_if_refresher.cmd_payload_is_read),
    .cmd_payload_is_write      (cmd_rw_if_refresher.cmd_payload_is_write),
    .cmd_payload_is_mw         (1'b0),
    .refresh_req               (cmd_rw_if_0.refresh_req),
    .refresh_gnt               (cmd_rw_if_0.refresh_gnt),
    .cmd_valid_1               (cmd_rw_if_0.cmd_valid),
    .cmd_ready_1               (cmd_rw_if_0.cmd_ready),
    .cmd_first_1               (cmd_rw_if_0.cmd_first),
    .cmd_last_1                (cmd_rw_if_0.cmd_last),
    .cmd_payload_a_1           (cmd_rw_if_0.cmd_payload_a),
    .cmd_payload_ba_1          (cmd_rw_if_0.cmd_payload_ba),
    .cmd_payload_cas_1         (cmd_rw_if_0.cmd_payload_cas),
    .cmd_payload_ras_1         (cmd_rw_if_0.cmd_payload_ras),
    .cmd_payload_we_1          (cmd_rw_if_0.cmd_payload_we),
    .cmd_payload_is_cmd_1      (cmd_rw_if_0.cmd_payload_is_cmd),
    .cmd_payload_is_read_1     (cmd_rw_if_0.cmd_payload_is_read),
    .cmd_payload_is_write_1    (cmd_rw_if_0.cmd_payload_is_write),
    .cmd_payload_is_mw_1       (cmd_rw_if_0.cmd_payload_is_mw),
    .refresh_req_1             (cmd_rw_if_1.refresh_req),
    .refresh_gnt_1             (cmd_rw_if_1.refresh_gnt),
    .cmd_valid_2               (cmd_rw_if_1.cmd_valid),
    .cmd_ready_2               (cmd_rw_if_1.cmd_ready),
    .cmd_first_2               (cmd_rw_if_1.cmd_first),
    .cmd_last_2                (cmd_rw_if_1.cmd_last),
    .cmd_payload_a_2           (cmd_rw_if_1.cmd_payload_a),
    .cmd_payload_ba_2          (cmd_rw_if_1.cmd_payload_ba),
    .cmd_payload_cas_2         (cmd_rw_if_1.cmd_payload_cas),
    .cmd_payload_ras_2         (cmd_rw_if_1.cmd_payload_ras),
    .cmd_payload_we_2          (cmd_rw_if_1.cmd_payload_we),
    .cmd_payload_is_cmd_2      (cmd_rw_if_1.cmd_payload_is_cmd),
    .cmd_payload_is_read_2     (cmd_rw_if_1.cmd_payload_is_read),
    .cmd_payload_is_write_2    (cmd_rw_if_1.cmd_payload_is_write),
    .cmd_payload_is_mw_2       (cmd_rw_if_1.cmd_payload_is_mw),
    .refresh_req_2             (cmd_rw_if_2.refresh_req),
    .refresh_gnt_2             (cmd_rw_if_2.refresh_gnt),
    .cmd_valid_3               (cmd_rw_if_2.cmd_valid),
    .cmd_ready_3               (cmd_rw_if_2.cmd_ready),
    .cmd_first_3               (cmd_rw_if_2.cmd_first),
    .cmd_last_3                (cmd_rw_if_2.cmd_last),
    .cmd_payload_a_3           (cmd_rw_if_2.cmd_payload_a),
    .cmd_payload_ba_3          (cmd_rw_if_2.cmd_payload_ba),
    .cmd_payload_cas_3         (cmd_rw_if_2.cmd_payload_cas),
    .cmd_payload_ras_3         (cmd_rw_if_2.cmd_payload_ras),
    .cmd_payload_we_3          (cmd_rw_if_2.cmd_payload_we),
    .cmd_payload_is_cmd_3      (cmd_rw_if_2.cmd_payload_is_cmd),
    .cmd_payload_is_read_3     (cmd_rw_if_2.cmd_payload_is_read),
    .cmd_payload_is_write_3    (cmd_rw_if_2.cmd_payload_is_write),
    .cmd_payload_is_mw_3       (cmd_rw_if_2.cmd_payload_is_mw),
    .refresh_req_3             (cmd_rw_if_3.refresh_req),
    .refresh_gnt_3             (cmd_rw_if_3.refresh_gnt),
    .cmd_valid_4               (cmd_rw_if_3.cmd_valid),
    .cmd_ready_4               (cmd_rw_if_3.cmd_ready),
    .cmd_first_4               (cmd_rw_if_3.cmd_first),
    .cmd_last_4                (cmd_rw_if_3.cmd_last),
    .cmd_payload_a_4           (cmd_rw_if_3.cmd_payload_a),
    .cmd_payload_ba_4          (cmd_rw_if_3.cmd_payload_ba),
    .cmd_payload_cas_4         (cmd_rw_if_3.cmd_payload_cas),
    .cmd_payload_ras_4         (cmd_rw_if_3.cmd_payload_ras),
    .cmd_payload_we_4          (cmd_rw_if_3.cmd_payload_we),
    .cmd_payload_is_cmd_4      (cmd_rw_if_3.cmd_payload_is_cmd),
    .cmd_payload_is_read_4     (cmd_rw_if_3.cmd_payload_is_read),
    .cmd_payload_is_write_4    (cmd_rw_if_3.cmd_payload_is_write),
    .cmd_payload_is_mw_4       (cmd_rw_if_3.cmd_payload_is_mw),
    .refresh_req_4             (cmd_rw_if_4.refresh_req),
    .refresh_gnt_4             (cmd_rw_if_4.refresh_gnt),
    .cmd_valid_5               (cmd_rw_if_4.cmd_valid),
    .cmd_ready_5               (cmd_rw_if_4.cmd_ready),
    .cmd_first_5               (cmd_rw_if_4.cmd_first),
    .cmd_last_5                (cmd_rw_if_4.cmd_last),
    .cmd_payload_a_5           (cmd_rw_if_4.cmd_payload_a),
    .cmd_payload_ba_5          (cmd_rw_if_4.cmd_payload_ba),
    .cmd_payload_cas_5         (cmd_rw_if_4.cmd_payload_cas),
    .cmd_payload_ras_5         (cmd_rw_if_4.cmd_payload_ras),
    .cmd_payload_we_5          (cmd_rw_if_4.cmd_payload_we),
    .cmd_payload_is_cmd_5      (cmd_rw_if_4.cmd_payload_is_cmd),
    .cmd_payload_is_read_5     (cmd_rw_if_4.cmd_payload_is_read),
    .cmd_payload_is_write_5    (cmd_rw_if_4.cmd_payload_is_write),
    .cmd_payload_is_mw_5       (cmd_rw_if_4.cmd_payload_is_mw),
    .refresh_req_5             (cmd_rw_if_5.refresh_req),
    .refresh_gnt_5             (cmd_rw_if_5.refresh_gnt),
    .cmd_valid_6               (cmd_rw_if_5.cmd_valid),
    .cmd_ready_6               (cmd_rw_if_5.cmd_ready),
    .cmd_first_6               (cmd_rw_if_5.cmd_first),
    .cmd_last_6                (cmd_rw_if_5.cmd_last),
    .cmd_payload_a_6           (cmd_rw_if_5.cmd_payload_a),
    .cmd_payload_ba_6          (cmd_rw_if_5.cmd_payload_ba),
    .cmd_payload_cas_6         (cmd_rw_if_5.cmd_payload_cas),
    .cmd_payload_ras_6         (cmd_rw_if_5.cmd_payload_ras),
    .cmd_payload_we_6          (cmd_rw_if_5.cmd_payload_we),
    .cmd_payload_is_cmd_6      (cmd_rw_if_5.cmd_payload_is_cmd),
    .cmd_payload_is_read_6     (cmd_rw_if_5.cmd_payload_is_read),
    .cmd_payload_is_write_6    (cmd_rw_if_5.cmd_payload_is_write),
    .cmd_payload_is_mw_6       (cmd_rw_if_5.cmd_payload_is_mw),
    .refresh_req_6             (cmd_rw_if_6.refresh_req),
    .refresh_gnt_6             (cmd_rw_if_6.refresh_gnt),
    .cmd_valid_7               (cmd_rw_if_6.cmd_valid),
    .cmd_ready_7               (cmd_rw_if_6.cmd_ready),
    .cmd_first_7               (cmd_rw_if_6.cmd_first),
    .cmd_last_7                (cmd_rw_if_6.cmd_last),
    .cmd_payload_a_7           (cmd_rw_if_6.cmd_payload_a),
    .cmd_payload_ba_7          (cmd_rw_if_6.cmd_payload_ba),
    .cmd_payload_cas_7         (cmd_rw_if_6.cmd_payload_cas),
    .cmd_payload_ras_7         (cmd_rw_if_6.cmd_payload_ras),
    .cmd_payload_we_7          (cmd_rw_if_6.cmd_payload_we),
    .cmd_payload_is_cmd_7      (cmd_rw_if_6.cmd_payload_is_cmd),
    .cmd_payload_is_read_7     (cmd_rw_if_6.cmd_payload_is_read),
    .cmd_payload_is_write_7    (cmd_rw_if_6.cmd_payload_is_write),
    .cmd_payload_is_mw_7       (cmd_rw_if_6.cmd_payload_is_mw),
    .refresh_req_7             (cmd_rw_if_7.refresh_req),
    .refresh_gnt_7             (cmd_rw_if_7.refresh_gnt),
    //refresher input
    .cmd_valid_8               (cmd_rw_if_7.cmd_valid),
    .cmd_ready_8               (cmd_rw_if_7.cmd_ready),
    .cmd_first_8               (cmd_rw_if_7.cmd_first),
    .cmd_last_8                (cmd_rw_if_7.cmd_last),
    .cmd_payload_a_8           (cmd_rw_if_7.cmd_payload_a),
    .cmd_payload_ba_8          (cmd_rw_if_7.cmd_payload_ba),
    .cmd_payload_cas_8         (cmd_rw_if_7.cmd_payload_cas),
    .cmd_payload_ras_8         (cmd_rw_if_7.cmd_payload_ras),
    .cmd_payload_we_8          (cmd_rw_if_7.cmd_payload_we),
    .cmd_payload_is_cmd_8      (cmd_rw_if_7.cmd_payload_is_cmd),
    .cmd_payload_is_read_8     (cmd_rw_if_7.cmd_payload_is_read),
    .cmd_payload_is_write_8    (cmd_rw_if_7.cmd_payload_is_write),
    .cmd_payload_is_mw_8       (cmd_rw_if_7.cmd_payload_is_mw),
    .mul_tRRD_cfg              (mul_tRRD_cfg),
    .mul_tFAW_cfg              (mul_tFAW_cfg),
    .mul_tCCD_cfg              (mul_tCCD_cfg),
    .mul_WTR_LATENCY_cfg       (mul_WTR_LATENCY_cfg),
    .mul_RTW_LATENCY_cfg       (mul_RTW_LATENCY_cfg),
    .mul_READ_TIME_cfg         (mul_READ_TIME_cfg),
    .mul_WRITE_TIME_cfg        (mul_WRITE_TIME_cfg),
    .mul_rd_phase_cfg          (mul_rd_phase_cfg),
    .mul_wr_phase_cfg          (mul_wr_phase_cfg),
    .mul_rdcmd_phase_cfg       (mul_rdcmd_phase_cfg),
    .mul_wrcmd_phase_cfg       (mul_wrcmd_phase_cfg),
    .sys_clk                   (clk),
    .sys_rst                   (rst)
);

    refresher_pos_8 u_refresher_pos_8 (
    .cmd_valid           (cmd_rw_if_refresher.cmd_valid),
    .cmd_ready           (cmd_rw_if_refresher.cmd_ready),
    .cmd_last            (cmd_rw_if_refresher.cmd_last),
    .cmd_payload_a       (cmd_rw_if_refresher.cmd_payload_a),
    .cmd_payload_ba      (cmd_rw_if_refresher.cmd_payload_ba),
    .cmd_payload_cas     (cmd_rw_if_refresher.cmd_payload_cas),
    .cmd_payload_ras     (cmd_rw_if_refresher.cmd_payload_ras),
    .cmd_payload_we      (cmd_rw_if_refresher.cmd_payload_we),
    .ref_tRP_cfg         (ref_tRP_cfg),
    .ref_tRFC_cfg        (ref_tRFC_cfg),
    .ref_tREFI_cfg       (ref_tREFI_cfg),
    .ref_POSTPONE_cfg    (ref_POSTPONE_cfg),
    .sys_clk             (clk),
    .sys_rst             (rst)
);

    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end

    initial begin 
        rst <= 1;
        repeat(5) @(posedge clk);
        rst <= 0;
    end

    initial begin 
        $vcdpluson(0,multiplexer_tb);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm0_vif", cmd_rw_if_0);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm1_vif", cmd_rw_if_1);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm2_vif", cmd_rw_if_2);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm3_vif", cmd_rw_if_3);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm4_vif", cmd_rw_if_4);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm5_vif", cmd_rw_if_5);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm6_vif", cmd_rw_if_6);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "bm7_vif", cmd_rw_if_7);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "refresher_vif", cmd_rw_if_refresher);
        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", dfi_if);
        run_test("multiplexer_basic_test");
        $finish;
    end
endmodule