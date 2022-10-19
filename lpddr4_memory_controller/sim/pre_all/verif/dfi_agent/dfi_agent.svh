  // dfi agent
  class dfi_agent extends uvm_agent;
    dfi_driver driver;
    dfi_monitor monitor;
    dfi_sequencer sequencer;
    virtual dfi_interface vif;

    `uvm_component_utils(dfi_agent)

    function new(string name = "dfi_agent", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      driver = dfi_driver::type_id::create("driver", this);
      monitor = dfi_monitor::type_id::create("monitor", this);
      sequencer = dfi_sequencer::type_id::create("sequencer", this);
    endfunction

    function void set_interface(virtual dfi_interface vif);
      this.vif = vif;
      driver.set_interface(vif);
      monitor.set_interface(vif);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
  endclass: dfi_agent