  // vsqr
  class DFIAdapter_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    dfi_sequencer dfi_sqr;
    virtual dfi_lpddr4_interface dfi_lpddr4_vif;
    `uvm_component_utils(DFIAdapter_virtual_sequencer)

    function new (string name = "DFIAdapter_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual dfi_lpddr4_interface vif);
      this.dfi_lpddr4_vif = vif;
    endfunction
  endclass