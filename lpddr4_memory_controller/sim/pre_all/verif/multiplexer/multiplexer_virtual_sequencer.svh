  // vsqr
  class multiplexer_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    bm_sequencer bm_sqrs[8];
    virtual dfi_interface dfi_vif;
    `uvm_component_utils(multiplexer_virtual_sequencer)

    function new (string name = "multiplexer_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual dfi_interface vif);
      this.dfi_vif = vif;
    endfunction
  endclass