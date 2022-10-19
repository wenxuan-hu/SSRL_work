  // sequencer
  class nat_sequencer extends uvm_sequencer #(nat_trans);
    `uvm_component_utils(nat_sequencer)
    function new (string name = "nat_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: nat_sequencer
