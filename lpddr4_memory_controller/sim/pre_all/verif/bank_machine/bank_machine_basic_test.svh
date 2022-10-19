  class bank_machine_root_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    req_cmd_sequence req_cmd_seq;
    `uvm_object_utils(bank_machine_root_virtual_sequence)
    `uvm_declare_p_sequencer(bank_machine_virtual_sequencer)

    function new (string name = "bank_machine_root_virtual_sequence");
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
      repeat(n) @(posedge p_sequencer.cmd_vif.clk);
    endtask
  endclass:bank_machine_root_virtual_sequence

  class bank_machine_root_test extends uvm_test;
    bank_machine_env env;
    virtual cmd_rw_interface cmd_vif;
    virtual litedram_cmd_interface ld_vif;

    `uvm_component_utils(bank_machine_root_test)

    function new(string name = "bank_machine_root_test", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // get virtual interface from top TB
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","cmd_vif", cmd_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual litedram_cmd_interface)::get(this,"","ld_vif", ld_vif)) begin
        `uvm_fatal("GETVIF","cannot get litedram cmd vif handle from config DB")
      end
      env = bank_machine_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // After get virtual interface from config_db, and then set them to
      // child components
      this.set_interface(cmd_vif, ld_vif);
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

    virtual function void set_interface(virtual cmd_rw_interface cmd_vif 
                                        ,virtual litedram_cmd_interface ld_vif
                                      );
      this.env.agent.set_interface(ld_vif);
      this.env.bm_mon.set_interface(cmd_vif);
      this.env.bm_res.set_interface(cmd_vif);
      this.env.bank_machine_chker.set_interface(cmd_vif,ld_vif);
      //this.env.cvrg.set_interface('{ch0_vif, ch1_vif, ch2_vif}, reg_vif, arb_vif, fmt_vif, mcdf_vif);
      this.env.virt_sqr.set_interface(cmd_vif);
    endfunction
  endclass: bank_machine_root_test

  class bank_machine_basic_virtual_sequence extends bank_machine_root_virtual_sequence;
    `uvm_object_utils(bank_machine_basic_virtual_sequence)
    function new (string name = "bank_machine_basic_virtual_sequence");
      super.new(name);
    endfunction
    task do_data();
      // User
      @(negedge p_sequencer.cmd_vif.rst);
      //wait for timers to ready
      this.wait_cycles(10);
      fork
        `uvm_do_on_with(req_cmd_seq, p_sequencer.req_sqr, 
                        {ntrans== 2000;}
                       )
      join
      #1us; // wait until all data haven been transfered
    endtask
  endclass: bank_machine_basic_virtual_sequence


  class bank_machine_basic_test extends bank_machine_root_test;
    `uvm_component_utils(bank_machine_basic_test)
    function new(string name = "bank_machine_basic_test", uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_top_virtual_sequence();
      bank_machine_basic_virtual_sequence top_seq = new();
      top_seq.start(env.virt_sqr);
    endtask
  endclass: bank_machine_basic_test