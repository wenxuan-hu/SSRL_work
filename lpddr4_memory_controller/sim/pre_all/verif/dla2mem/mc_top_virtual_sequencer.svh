  // vsqr
  class mc_top_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    dla_sequencer dla_sqrs[2];
    //dfi_lpddr4_rdata_sequencer rdata_sqr;
    virtual mosi_interface dla_vif_0;
    virtual mosi_interface dla_vif_1;
    virtual dfi_lpddr4_interface dfi_lpddr4_vif;
    `uvm_component_utils(mc_top_virtual_sequencer)

    function new (string name = "mc_top_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual mosi_interface dla_vif_0,virtual mosi_interface dla_vif_1,virtual dfi_lpddr4_interface dfi_lpddr4_vif);
      this.dla_vif_0 = dla_vif_0;
      this.dla_vif_1 = dla_vif_1;
      this.dfi_lpddr4_vif = dfi_lpddr4_vif;
    endfunction
  endclass
