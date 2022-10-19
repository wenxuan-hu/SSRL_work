  class ucie_channel_root_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    rdi_mb_sequence rdi_mb_seq;
    `uvm_object_utils(ucie_channel_root_virtual_sequence)
    `uvm_declare_p_sequencer(ucie_channel_virtual_sequencer)

    function new (string name = "ucie_channel_root_virtual_sequence");
      super.new(name);
    endfunction

    virtual task body();
      `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
      this.do_data();
      `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    endtask

    // do data transition from 3 channel slaves
    virtual task do_data();
      //User to implment the task in the child virtual sequence
    endtask

    task wait_cycles(int n);
      repeat(n) @(posedge p_sequencer.rdi_mb_vif.clk);
    endtask
  endclass:ucie_channel_root_virtual_sequence

  class ucie_channel_root_test extends uvm_test;
    ucie_channel_env env;
    virtual rdi_mb_interface rdi_mb_vif;

    `uvm_component_utils(ucie_channel_root_test)

    function new(string name = "ucie_channel_root_test", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // get virtual interface from top TB
      if(!uvm_config_db#(virtual rdi_mb_interface)::get(this,"","rdi_mb_vif", rdi_mb_vif)) begin
        `uvm_fatal("GETVIF","cannot get rdi_mb vif handle from config DB")
      end
      env = ucie_channel_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // After get virtual interface from config_db, and then set them to
      // child components
      this.set_interface(rdi_mb_vif);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_root::get().set_report_verbosity_level_hier(UVM_HIGH);
      uvm_root::get().set_report_max_quit_count(1);
      uvm_root::get().set_timeout(10ms);
    endfunction

    task run_phase(uvm_phase phase);
      // NOTE:: raise objection to prevent simulation stopping
      phase.raise_objection(this);
      this.run_top_virtual_sequence();
      // NOTE:: drop objection to request simulation stopping
      phase.drop_objection(this);
    endtask

    virtual task run_top_virtual_sequence();
      // User
    endtask

    virtual function void set_interface(virtual rdi_mb_interface rdi_mb_vif);
      this.env.agent.set_interface(rdi_mb_vif);
      this.env.ucie_channel_chker.set_interface(rdi_mb_vif);
      this.env.virt_sqr.set_interface(rdi_mb_vif);
    endfunction
  endclass: ucie_channel_root_test

  class ucie_channel_basic_virtual_sequence extends ucie_channel_root_virtual_sequence;
    `uvm_object_utils(ucie_channel_basic_virtual_sequence)
    function new (string name = "ucie_channel_basic_virtual_sequence");
      super.new(name);
    endfunction
    task do_data();
      // User
      @(negedge p_sequencer.rdi_mb_vif.rst);
      //wait for timers to ready
      this.wait_cycles(1000);
      fork
        `uvm_do_on_with(rdi_mb_seq, p_sequencer.rdi_sqr, 
                        {ntrans== 2;}
                       )
      join
      #1us; // wait until all data haven been transfered
    endtask
  endclass: ucie_channel_basic_virtual_sequence


  class ucie_channel_basic_test extends ucie_channel_root_test;
    `uvm_component_utils(ucie_channel_basic_test)
    function new(string name = "ucie_channel_basic_test", uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_top_virtual_sequence();
      ucie_channel_basic_virtual_sequence top_seq = new();
      top_seq.start(env.virt_sqr);
    endtask
  endclass: ucie_channel_basic_test