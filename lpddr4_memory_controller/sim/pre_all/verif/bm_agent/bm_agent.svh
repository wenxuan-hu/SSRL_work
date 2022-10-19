  // bankmachine agent
  class bm_agent extends uvm_agent;
    bm_driver driver;
    bm_monitor monitor;
    bm_sequencer sequencer;
    virtual cmd_rw_interface vif;

    `uvm_component_utils(bm_agent)

    function new(string name = "bm_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = bm_driver::type_id::create("driver", this);
      monitor = bm_monitor::type_id::create("monitor", this);
      sequencer = bm_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual cmd_rw_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: bm_agent