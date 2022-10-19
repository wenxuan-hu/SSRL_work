`timescale 1ns/10ps

module bank_machine_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    logic clk,rst;
    cmd_rw_interface cmd_rw_if_0(clk,rst);
    litedram_cmd_interface req_if(clk,rst);

    assign cmd_rw_if_0.refresh_req=1'b0;

    logic [7:0] bm_tRTP_cfg=4;
    logic [7:0] bm_tWTP_cfg=17;
	logic [7:0] bm_tRC_cfg=35;
	logic [7:0] bm_tRAS_cfg=24;
	logic [7:0] bm_tRP_cfg=12;
	logic [7:0] bm_tRCD_cfg=11;
	logic [7:0] bm_tCCDMW_cfg=8;

    bankmachine_0 u_bankmachine_0 (
    .req_valid                (req_if.interface_bank_valid),
    .req_ready                (req_if.interface_bank_ready),
    .req_mw                   (req_if.interface_bank_mw),
    .req_we                   (req_if.interface_bank_we),
    .req_addr                 (req_if.interface_bank_addr),
    .req_lock                 (req_if.interface_bank_lock),
    .req_wdata_ready          (req_if.interface_bank_wdata_ready),
    .req_rdata_valid          (req_if.interface_bank_rdata_valid),
    .refresh_req              (cmd_rw_if_0.refresh_req),
    .refresh_gnt              (cmd_rw_if_0.refresh_gnt),
    .cmd_valid                (cmd_rw_if_0.cmd_valid),
    .cmd_ready                (cmd_rw_if_0.cmd_ready),
    .cmd_first                (cmd_rw_if_0.cmd_first),
    .cmd_last                 (cmd_rw_if_0.cmd_last),
    .cmd_payload_a            (cmd_rw_if_0.cmd_payload_a),
    .cmd_payload_ba           (cmd_rw_if_0.cmd_payload_ba),
    .cmd_payload_cas          (cmd_rw_if_0.cmd_payload_cas),
    .cmd_payload_ras          (cmd_rw_if_0.cmd_payload_ras),
    .cmd_payload_we           (cmd_rw_if_0.cmd_payload_we),
    .cmd_payload_is_cmd       (cmd_rw_if_0.cmd_payload_is_cmd),
    .cmd_payload_is_read      (cmd_rw_if_0.cmd_payload_is_read),
    .cmd_payload_is_write     (cmd_rw_if_0.cmd_payload_is_write),
    .cmd_payload_is_mw        (cmd_rw_if_0.cmd_payload_is_mw),
    .bm_tRTP_cfg              (bm_tRTP_cfg),
    .bm_tWTP_cfg              (bm_tWTP_cfg),
    .bm_tRC_cfg               (bm_tRC_cfg),
    .bm_tRAS_cfg              (bm_tRAS_cfg),
    .bm_tRP_cfg               (bm_tRP_cfg),
    .bm_tRCD_cfg              (bm_tRCD_cfg),
    .bm_tCCDMW_cfg            (bm_tCCDMW_cfg),
    .sys_clk                  (clk),
    .sys_rst                  (rst)
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
        $vcdpluson(0,bank_machine_tb);
        uvm_config_db #(virtual cmd_rw_interface)::set(uvm_root::get(), "uvm_test_top", "cmd_vif", cmd_rw_if_0);
        uvm_config_db #(virtual litedram_cmd_interface)::set(uvm_root::get(), "uvm_test_top", "ld_vif", req_if);
        run_test("bank_machine_basic_test");
        $finish;
    end
endmodule