  class multiplexer_root_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
    bm_cmd_sequence bm_cmd_seq;
    `uvm_object_utils(multiplexer_root_virtual_sequence)
    `uvm_declare_p_sequencer(multiplexer_virtual_sequencer)

    function new (string name = "multiplexer_root_virtual_sequence");
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
      repeat(n) @(posedge p_sequencer.dfi_vif.clk);
    endtask
  endclass:multiplexer_root_virtual_sequence

  class multiplexer_root_test extends uvm_test;
    multiplexer_env env;
    virtual cmd_rw_interface bm0_vif;
    virtual cmd_rw_interface bm1_vif;
    virtual cmd_rw_interface bm2_vif;
    virtual cmd_rw_interface bm3_vif;
    virtual cmd_rw_interface bm4_vif;
    virtual cmd_rw_interface bm5_vif;
    virtual cmd_rw_interface bm6_vif;
    virtual cmd_rw_interface bm7_vif;
    virtual cmd_rw_interface refresher_vif;
    virtual dfi_interface dfi_vif;

    `uvm_component_utils(multiplexer_root_test)

    function new(string name = "multiplexer_root_test", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // get virtual interface from top TB
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm0_vif", bm0_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm1_vif", bm1_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm2_vif", bm2_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm3_vif", bm3_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm4_vif", bm4_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm5_vif", bm5_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm6_vif", bm6_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","bm7_vif", bm7_vif)) begin
        `uvm_fatal("GETVIF","cannot get cmd vif handle from config DB")
      end
      if(!uvm_config_db#(virtual dfi_interface)::get(this,"","dfi_vif", dfi_vif)) begin
        `uvm_fatal("GETVIF","cannot get dfi vif handle from config DB")
      end
      if(!uvm_config_db#(virtual cmd_rw_interface)::get(this,"","refresher_vif", refresher_vif)) begin
        `uvm_fatal("GETVIF","cannot get refresher vif handle from config DB")
      end
      env = multiplexer_env::type_id::create("env", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      // After get virtual interface from config_db, and then set them to
      // child components
      this.set_interface(bm0_vif, bm1_vif, bm2_vif, bm3_vif, bm4_vif, bm5_vif, bm6_vif,bm7_vif,refresher_vif,dfi_vif);
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

    virtual function void set_interface(virtual cmd_rw_interface bm0_vif 
                                        ,virtual cmd_rw_interface bm1_vif
                                        ,virtual cmd_rw_interface bm2_vif 
                                        ,virtual cmd_rw_interface bm3_vif
                                        ,virtual cmd_rw_interface bm4_vif
                                        ,virtual cmd_rw_interface bm5_vif
                                        ,virtual cmd_rw_interface bm6_vif
                                        ,virtual cmd_rw_interface bm7_vif
                                        ,virtual cmd_rw_interface refresher_vif
                                        ,virtual dfi_interface dfi_vif
                                      );
      this.env.agents[0].set_interface(bm0_vif);
      this.env.agents[1].set_interface(bm1_vif);
      this.env.agents[2].set_interface(bm2_vif);
      this.env.agents[3].set_interface(bm3_vif);
      this.env.agents[4].set_interface(bm4_vif);
      this.env.agents[5].set_interface(bm5_vif);
      this.env.agents[6].set_interface(bm6_vif);
      this.env.agents[7].set_interface(bm7_vif);
      this.env.refresher_mon.set_interface(refresher_vif);
      this.env.dfi_mon.set_interface(dfi_vif);
      this.env.dfi_chker.set_interface(dfi_vif,'{bm0_vif, bm1_vif, bm2_vif,bm3_vif, bm4_vif, bm5_vif,bm6_vif, bm7_vif});
      //this.env.cvrg.set_interface('{ch0_vif, ch1_vif, ch2_vif}, reg_vif, arb_vif, fmt_vif, mcdf_vif);
      this.env.virt_sqr.set_interface(dfi_vif);
    endfunction
  endclass: multiplexer_root_test

  class multiplexer_basic_virtual_sequence extends multiplexer_root_virtual_sequence;
    int num_trans=200;
    `uvm_object_utils(multiplexer_basic_virtual_sequence)
    function new (string name = "multiplexer_basic_virtual_sequence");
      super.new(name);
    endfunction
    task do_data();
      // User
      @(negedge p_sequencer.dfi_vif.rst);
      this.wait_cycles(10);
      fork
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[0], 
                        {ntrans== num_trans; bank_address==0;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[1], 
                        {ntrans== num_trans; bank_address==1;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[2], 
                        {ntrans== num_trans; bank_address==2;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[3], 
                        {ntrans== num_trans; bank_address==3;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[4], 
                        {ntrans== num_trans; bank_address==4;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[5], 
                        {ntrans== num_trans; bank_address==5;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[6], 
                        {ntrans== num_trans; bank_address==6;}
                       )
        `uvm_do_on_with(bm_cmd_seq, p_sequencer.bm_sqrs[7], 
                        {ntrans== num_trans; bank_address==7;}
                       )
       
      join
      #10us; // wait until all data haven been transfered
    endtask
  endclass: multiplexer_basic_virtual_sequence


  class multiplexer_basic_test extends multiplexer_root_test;
    `uvm_component_utils(multiplexer_basic_test)
    function new(string name = "multiplexer_basic_test", uvm_component parent);
      super.new(name, parent);
    endfunction
    task run_top_virtual_sequence();
      multiplexer_basic_virtual_sequence top_seq = new();
      top_seq.start(env.virt_sqr);
    endtask
  endclass: multiplexer_basic_test