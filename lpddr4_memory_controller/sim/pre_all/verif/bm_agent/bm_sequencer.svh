  // sequencer
  class bm_sequencer extends uvm_sequencer #(bm_trans);
    `uvm_component_utils(bm_sequencer)
    function new (string name = "bm_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: bm_sequencer
