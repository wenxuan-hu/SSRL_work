  // bankmachine agent
  class rdi_mb_agent extends uvm_agent;
    rdi_mb_driver driver;
    rdi_mb_monitor monitor;
    rdi_mb_sequencer sequencer;
    virtual rdi_mb_interface vif;

    `uvm_component_utils(rdi_mb_agent)

    function new(string name = "rdi_mb_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = rdi_mb_driver::type_id::create("driver", this);
      monitor = rdi_mb_monitor::type_id::create("monitor", this);
      sequencer = rdi_mb_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual rdi_mb_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: rdi_mb_agent