  // vsqr
  class ucie_channel_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    rdi_mb_sequencer rdi_sqr;
    virtual rdi_mb_interface rdi_mb_vif;
    `uvm_component_utils(ucie_channel_virtual_sequencer)

    function new (string name = "ucie_channel_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual rdi_mb_interface vif);
      this.rdi_mb_vif = vif;
    endfunction
  endclass