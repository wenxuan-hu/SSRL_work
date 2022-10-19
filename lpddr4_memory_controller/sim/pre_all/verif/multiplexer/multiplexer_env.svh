  //uvm_env
  class multiplexer_env extends uvm_env;
    bm_agent agents[8];
    refresher_monitor refresher_mon;
    dfi_monitor dfi_mon;
    dfi_checker dfi_chker;
    multiplexer_virtual_sequencer virt_sqr;
    //dfi_coverage dfi_cvrg;

    `uvm_component_utils(multiplexer_env)

    function new (string name = "multiplexer_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      this.dfi_chker = dfi_checker::type_id::create("dfi_chker", this);
      foreach(agents[i]) begin
        this.agents[i] = bm_agent::type_id::create($sformatf("bm_agents[%0d]",i), this);
        //this.agents[i].driver.set_bank_address(i);
      end
      this.dfi_mon = dfi_monitor::type_id::create("dfi_mon", this);
      this.refresher_mon = refresher_monitor::type_id::create("refresher_mon", this);
      //this.dfi_cvrg = dfi_coverage::type_id::create("dfi_cvrg", this);
      virt_sqr = multiplexer_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      foreach(agents[i]) begin
        this.agents[i].monitor.mon_cmd_port.connect(this.dfi_chker.in_tlm_fifos[i].analysis_export);
      end
      this.dfi_mon.mon_dfi_port.connect(this.dfi_chker.out_tlm_fifo.analysis_export);
      this.refresher_mon.mon_cmd_port.connect(this.dfi_chker.in_tlm_fifo_refresher.analysis_export);
      foreach(virt_sqr.bm_sqrs[i]) begin
        virt_sqr.bm_sqrs[i]=agents[i].sequencer;
      end
    endfunction
  endclass: multiplexer_env