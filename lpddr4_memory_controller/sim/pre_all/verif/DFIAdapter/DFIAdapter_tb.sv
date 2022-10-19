`timescale 1ns/10ps

module DFIAdapter_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    logic clk,rst;
    dfi_interface dfi_if(clk,rst);
    dfi_lpddr4_interface dfi_lpddr4_if(clk,rst);

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
        $vcdpluson(0,DFIAdapter_tb);
        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", dfi_if);
        uvm_config_db #(virtual dfi_lpddr4_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_lpddr4_vif", dfi_lpddr4_if);
        run_test("DFIAdapter_basic_test");
        $finish;
    end
endmodule