  // sequencer
  class rdi_mb_sequencer extends uvm_sequencer #(rdi_mb_trans);
    `uvm_component_utils(rdi_mb_sequencer)
    function new (string name = "rdi_mb_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: rdi_mb_sequencer
