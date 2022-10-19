  // bankmachine agent
  class nat_agent extends uvm_agent;
    nat_driver driver;
    nat_monitor monitor;
    nat_sequencer sequencer;
    virtual native_interface vif;

    `uvm_component_utils(nat_agent)

    function new(string name = "nat_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = nat_driver::type_id::create("driver", this);
      monitor = nat_monitor::type_id::create("monitor", this);
      sequencer = nat_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual native_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: nat_agent