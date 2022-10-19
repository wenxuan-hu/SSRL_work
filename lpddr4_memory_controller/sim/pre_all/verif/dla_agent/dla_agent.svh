  // bankmachine agent
  class dla_agent extends uvm_agent;
    dla_driver driver;
    dla_monitor monitor;
    dla_sequencer sequencer;
    virtual mosi_interface vif;

    `uvm_component_utils(dla_agent)

    function new(string name = "dla_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = dla_driver::type_id::create("driver", this);
      monitor = dla_monitor::type_id::create("monitor", this);
      sequencer = dla_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual mosi_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: dla_agent
