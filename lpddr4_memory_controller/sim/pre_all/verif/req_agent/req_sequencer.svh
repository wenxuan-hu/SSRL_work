  // sequencer
  class req_sequencer extends uvm_sequencer #(req_trans);
    `uvm_component_utils(req_sequencer)
    function new (string name = "req_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass: req_sequencer
