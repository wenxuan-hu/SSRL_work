  //  dfi_lpddr4_agent
  class dfi_lpddr4_agent extends uvm_agent;
    dfi_lpddr4_responder responder;
    dfi_lpddr4_monitor monitor;
    //dfi_data_sequencer sequencer;
    virtual dfi_lpddr4_interface vif;

    `uvm_component_utils(dfi_lpddr4_agent)

    function new(string name = "dfi_lpddr4_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      responder = dfi_lpddr4_responder::type_id::create("responder", this);
      monitor = dfi_lpddr4_monitor::type_id::create("monitor", this);
      //sequencer = dfi_data_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual dfi_lpddr4_interface vif);
      this.vif = vif;
      responder.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      //responder.seq_item_port.connect(sequencer.seq_item_export);
      this.monitor.mon_rsp_port.connect(this.responder.data_request_port.analysis_export);
    endfunction
  endclass