  // sequencer
  class dla_sequencer extends uvm_sequencer #(dla_trans);
    `uvm_component_utils(dla_sequencer)
    function new (string name = "dla_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: dla_sequencer
