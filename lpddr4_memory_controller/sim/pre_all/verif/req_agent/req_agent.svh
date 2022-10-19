  // req agent
  class req_agent extends uvm_agent;
    req_driver driver;
    req_monitor monitor;
    req_sequencer sequencer;
    virtual litedram_cmd_interface vif;

    `uvm_component_utils(req_agent)

    function new(string name = "req_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = req_driver::type_id::create("driver", this);
      monitor = req_monitor::type_id::create("monitor", this);
      sequencer = req_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual litedram_cmd_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: req_agent