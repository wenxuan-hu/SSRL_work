  // vsqr
  class core_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    nat_sequencer nat_sqrs[2];
    //dfi_lpddr4_rdata_sequencer rdata_sqr;
    virtual native_interface nat_vif_0;
    virtual native_interface nat_vif_1;
    virtual dfi_lpddr4_interface dfi_lpddr4_vif;
    `uvm_component_utils(core_virtual_sequencer)

    function new (string name = "core_virtual_sequencer", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual native_interface nat_vif_0,virtual native_interface nat_vif_1,virtual dfi_lpddr4_interface dfi_lpddr4_vif);
      this.nat_vif_0 = nat_vif_0;
      this.nat_vif_1 = nat_vif_1;
      this.dfi_lpddr4_vif = dfi_lpddr4_vif;
    endfunction
  endclass