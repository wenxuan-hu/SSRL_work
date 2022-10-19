module axi2native_wrapper(
    input clk,rst,
    axi_interface axi_if,
    native_interface nat_if
);
axi2native u_axi2native (
    .axi_aw_valid            (axi_if.aw_if.valid),
    .axi_aw_ready            (axi_if.aw_if.ready),
    .axi_aw_first            (axi_if.aw_if.first),
    .axi_aw_last             (axi_if.aw_if.last),
    .axi_aw_payload_addr     (axi_if.aw_if.addr),
    .axi_aw_payload_burst    (axi_if.aw_if.burst),
    .axi_aw_payload_len      (axi_if.aw_if.len),
    .axi_aw_payload_size     (axi_if.aw_if.size),
    .axi_aw_payload_lock     (axi_if.aw_if.lock),
    .axi_aw_payload_prot     (axi_if.aw_if.prot),
    .axi_aw_payload_cache    (axi_if.aw_if.cache),
    .axi_aw_payload_qos      (axi_if.aw_if.qos),
    .axi_aw_payload_id       (axi_if.aw_if.id),

    .axi_w_valid             (axi_if.w_if.valid),
    .axi_w_ready             (axi_if.w_if.ready),
    .axi_w_first             (axi_if.w_if.first),
    .axi_w_last              (axi_if.w_if.last),
    .axi_w_payload_data      (axi_if.w_if.data),
    .axi_w_payload_strb      (axi_if.w_if.strb),
    .axi_w_payload_id        (axi_if.w_if.id),

    .axi_b_valid             (axi_if.b_if.valid),
    .axi_b_ready             (axi_if.b_if.ready),
    .axi_b_first             (axi_if.b_if.first),
    .axi_b_last              (axi_if.b_if.last),
    .axi_b_payload_resp      (axi_if.b_if.resp),
    .axi_b_payload_id        (axi_if.b_if.id),

    .axi_ar_valid            (axi_if.ar_if.valid),
    .axi_ar_ready            (axi_if.ar_if.ready),
    .axi_ar_first            (axi_if.ar_if.first),
    .axi_ar_last             (axi_if.ar_if.last),
    .axi_ar_payload_addr     (axi_if.ar_if.addr),
    .axi_ar_payload_burst    (axi_if.ar_if.burst),
    .axi_ar_payload_len      (axi_if.ar_if.len),
    .axi_ar_payload_size     (axi_if.ar_if.size),
    .axi_ar_payload_lock     (axi_if.ar_if.lock),
    .axi_ar_payload_prot     (axi_if.ar_if.prot),
    .axi_ar_payload_cache    (axi_if.ar_if.cache),
    .axi_ar_payload_qos      (axi_if.ar_if.qos),
    .axi_ar_payload_id       (axi_if.ar_if.id),

    .axi_r_valid             (axi_if.r_if.valid),
    .axi_r_ready             (axi_if.r_if.ready),
    .axi_r_first             (axi_if.r_if.first),
    .axi_r_last              (axi_if.r_if.last),
    .axi_r_payload_resp      (axi_if.r_if.resp),
    .axi_r_payload_data      (axi_if.r_if.data),
    .axi_r_payload_id        (axi_if.r_if.id),

    .cmd_valid                      (nat_if.native_cmd_valid),
    .cmd_ready                      (nat_if.native_cmd_ready),
    .cmd_first                      (nat_if.native_cmd_first),
    .cmd_last                       (nat_if.native_cmd_last),
    //.cmd_payload_mw                 (nat_if.native_cmd_payload_mw),
    .cmd_payload_we                 (nat_if.native_cmd_payload_we),
    .cmd_payload_addr               (nat_if.native_cmd_payload_addr),

    .wdata_valid                    (nat_if.wdata_valid),
    .wdata_ready                    (nat_if.wdata_ready),
    .wdata_first                    (nat_if.wdata_first),
    .wdata_last                     (nat_if.wdata_last),
    .wdata_payload_data             (nat_if.wdata_payload_data),
    .wdata_payload_we               (nat_if.wdata_payload_we),
    
    .rdata_valid                    (nat_if.rdata_valid),
    .rdata_ready                    (nat_if.rdata_ready),
    .rdata_first                    (nat_if.rdata_first),
    .rdata_last                     (nat_if.rdata_last),
    .rdata_payload_data             (nat_if.rdata_payload_data),
    .sys_clk                 (clk),
    .sys_rst                 (rst)
);

    assign nat_if.native_cmd_payload_mw = 1'b1;
endmodule
