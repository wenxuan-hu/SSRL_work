package core_test_pkg;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "tb_defs.svh"
    
    `include "dfi_monitor.svh"
    `include "dfi_lpddr4_responder.svh"
    `include "dfi_lpddr4_monitor.svh"
    `include "dfi_lpddr4_agent.svh"

    `include "nat_trans.svh"
    `include "nat_cmd_sequence.svh"
    `include "nat_sequencer.svh"
    `include "nat_driver.svh"
    `include "nat_monitor.svh"
    `include "nat_agent.svh"

    `include "core_checker.svh"
    `include "core_virtual_sequencer.svh"
    `include "core_env.svh"
    `include "core_basic_test.svh"

endpackage