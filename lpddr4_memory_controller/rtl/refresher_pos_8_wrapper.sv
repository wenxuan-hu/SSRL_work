module refresher_pos_8_wrapper(
	cmd_rw_interface cmd_rw_if_refresher,
	input [7:0] ref_tRP_cfg,
	input [7:0] ref_tRFC_cfg,
	input [11:0] ref_tREFI_cfg,
	input [3:0] ref_POSTPONE_cfg,
	input clk,
	input rst
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
endmodule