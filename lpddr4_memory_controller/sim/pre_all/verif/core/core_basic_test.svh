  class core_root_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    nat_cmd_sequence nat_cmd_seq;
    `uvm_object_utils(core_root_virtual_sequence)
    `uvm_declare_p_sequencer(core_virtual_sequencer)

    function new (string name = "core_root_virtual_sequence");
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
      repeat(n) @(posedge p_sequencer.dfi_lpddr4_vif.clk);
    endtask
  endclass:core_root_virtual_sequence

  class core_root_test extends uvm_test;
    core_env env;
    virtual native_interface nat_vif_0;
    virtual native_interface nat_vif_1;
    virtual dfi_lpddr4_interface dfi_lpddr4_vif;
`ifdef TIMING_CHECK
    virtual dfi_interface dfi_vif;
`endif

    `uvm_component_utils(core_root_test)

    function new(string name = "core_root_test", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // get virtual interface from top TB
      if(!uvm_config_db#(virtual native_interface)::get(this,"","nat_vif_0", nat_vif_0)) begin
        `uvm_fatal("GETVIF","cannot get native vif handle from config DB")
      end
      if(!uvm_config_db#(virtual native_interface)::get(this,"","nat_vif_1", nat_vif_1)) begin
        `uvm_fatal("GETVIF","cannot get native vif handle from config DB")
      end
      if(!uvm_config_db#(virtual dfi_lpddr4_interface)::get(this,"","dfi_lpddr4_vif", dfi_lpddr4_vif)) begin
        `uvm_fatal("GETVIF","cannot get dfi_lpddr4 vif handle from config DB")
      end
`ifdef TIMING_CHECK
      if(!uvm_config_db#(virtual dfi_interface)::get(this,"","dfi_vif", dfi_vif)) begin
        `uvm_fatal("GETVIF","cannot get dfi vif handle from config DB")
      end
`endif
      env = core_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // After get virtual interface from config_db, and then set them to
      // child components
      this.set_interface(nat_vif_0,nat_vif_1, dfi_lpddr4_vif
`ifdef TIMING_CHECK
      ,dfi_vif
`endif
      );
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_root::get().set_report_verbosity_level_hier(UVM_HIGH);
      uvm_root::get().set_report_max_quit_count(1);
      uvm_root::get().set_timeout(1ms);
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

    virtual function void set_interface(virtual native_interface nat_vif_0
                                        ,virtual native_interface nat_vif_1 
                                        ,virtual dfi_lpddr4_interface dfi_lpddr4_vif
`ifdef TIMING_CHECK
                                        ,virtual dfi_interface dfi_vif
`endif
                                      );
      this.env.nat_agents[0].set_interface(nat_vif_0);
      this.env.nat_agents[1].set_interface(nat_vif_1);
      this.env.lpddr4_agent.set_interface(dfi_lpddr4_vif);
      this.env.core_chker.set_interface(nat_vif_0,nat_vif_1,dfi_lpddr4_vif);
      this.env.virt_sqr.set_interface(nat_vif_0,nat_vif_1,dfi_lpddr4_vif);
`ifdef TIMING_CHECK
      this.env.dfi_mon.set_interface(dfi_vif);
`endif
    endfunction
  endclass: core_root_test

  class core_basic_virtual_sequence extends core_root_virtual_sequence;
    `uvm_object_utils(core_basic_virtual_sequence)
    function new (string name = "core_basic_virtual_sequence");
      super.new(name);
    endfunction
    task do_data();
      // User
      @(negedge p_sequencer.dfi_lpddr4_vif.rst);
      //wait for timers to ready
      this.wait_cycles(10);
      fork
        `uvm_do_on_with(nat_cmd_seq, p_sequencer.nat_sqrs[0], 
                        {ntrans== 2000;channel==0;})
        `uvm_do_on_with(nat_cmd_seq, p_sequencer.nat_sqrs[1], 
                        {ntrans== 2000;channel==1;})
      join
      #1us; // wait until all data haven been transfered
    endtask
  endclass: core_basic_virtual_sequence


  class core_basic_test extends core_root_test;
    `uvm_component_utils(core_basic_test)
    function new(string name = "core_basic_test", uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_top_virtual_sequence();
      core_basic_virtual_sequence top_seq = new();
      top_seq.start(env.virt_sqr);
    endtask
  endclass: core_basic_test