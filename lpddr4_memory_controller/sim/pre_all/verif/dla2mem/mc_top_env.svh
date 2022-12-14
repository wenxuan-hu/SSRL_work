  //uvm_env
  class mc_top_env extends uvm_env;
    dla_agent  dla_agents[2];
    dfi_lpddr4_agent lpddr4_agent;
    mc_top_checker mc_top_chker;
    mc_top_virtual_sequencer virt_sqr;
`ifdef TIMING_CHECK
    dfi_monitor dfi_mon;
`endif

    `uvm_component_utils(mc_top_env)

    function new (string name = "mc_top_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      this.mc_top_chker = mc_top_checker::type_id::create("mc_top_chker", this);
      this.lpddr4_agent = dfi_lpddr4_agent::type_id::create("lpddr4_agent", this);
      foreach(dla_agents[i]) begin
        this.dla_agents[i] = dla_agent::type_id::create($sformatf("dla_agents[%0d]",i), this);
      end
      virt_sqr = mc_top_virtual_sequencer::type_id::create("virt_sqr", this);
`ifdef TIMING_CHECK
      this.dfi_mon=dfi_monitor::type_id::create("dfi_mon", this);
`endif
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      //cmd
      this.lpddr4_agent.monitor.mon_cmd_port.connect(this.mc_top_chker.out_tlm_fifo.analysis_export);
      foreach(dla_agents[i]) begin
        this.dla_agents[i].monitor.mon_cmd_port.connect(this.mc_top_chker.in_tlm_fifos[i].analysis_export);
      end
      //wdata
      foreach(dla_agents[i]) begin
        this.dla_agents[i].monitor.mon_wdata_port.connect(this.mc_top_chker.in_tlm_fifos_wdata[i].analysis_export);
      end
      this.lpddr4_agent.monitor.mon_wdata_port.connect(this.mc_top_chker.out_tlm_fifo_wdata.analysis_export);
      //rdata
      this.lpddr4_agent.monitor.mon_rdata_port[0].connect(this.mc_top_chker.in_tlm_fifos_rdata[0].analysis_export);
      this.lpddr4_agent.monitor.mon_rdata_port[1].connect(this.mc_top_chker.in_tlm_fifos_rdata[1].analysis_export);
      foreach(dla_agents[i]) begin
        this.dla_agents[i].monitor.mon_rdata_port.connect(this.mc_top_chker.out_tlm_fifos_rdata[i].analysis_export);
      end

      foreach(virt_sqr.dla_sqrs[i]) begin
        virt_sqr.dla_sqrs[i]=dla_agents[i].sequencer;
      end
      //virt_sqr.dfi_lpddr4_sqr=dfi_lpddr4_agent.sequencer;
    endfunction
  endclass: mc_top_env
