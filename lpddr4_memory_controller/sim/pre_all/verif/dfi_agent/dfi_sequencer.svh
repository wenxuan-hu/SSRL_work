  // sequencer
  class dfi_sequencer extends uvm_sequencer #(dfi_trans);
    `uvm_component_utils(dfi_sequencer)
    function new (string name = "dfi_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: dfi_sequencer
