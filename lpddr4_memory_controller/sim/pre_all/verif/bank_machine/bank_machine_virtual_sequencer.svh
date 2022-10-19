  // vsqr
  class bank_machine_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    req_sequencer req_sqr;
    virtual cmd_rw_interface cmd_vif;
    `uvm_component_utils(bank_machine_virtual_sequencer)

    function new (string name = "bank_machine_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual cmd_rw_interface vif);
      this.cmd_vif = vif;
    endfunction
  endclass