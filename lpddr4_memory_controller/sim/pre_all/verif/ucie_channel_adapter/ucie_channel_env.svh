  //uvm_env
  class ucie_channel_env extends uvm_env;
    rdi_mb_agent agent;
    ucie_channel_checker ucie_channel_chker;
    ucie_channel_virtual_sequencer virt_sqr;
    //ucie_channel_coverage ucie_channel_cvrg;

    `uvm_component_utils(ucie_channel_env)

    function new (string name = "ucie_channel_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      this.ucie_channel_chker = ucie_channel_checker::type_id::create("ucie_channel_chker", this);
      this.agent = rdi_mb_agent::type_id::create("rdi_agent", this);
      virt_sqr = ucie_channel_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      this.agent.monitor.mon_wdata_port.connect(this.ucie_channel_chker.in_tlm_fifo_wdata.analysis_export);
      this.agent.monitor.mon_rdata_port.connect(this.ucie_channel_chker.in_tlm_fifo_rdata.analysis_export);
      virt_sqr.rdi_sqr=agent.sequencer;
    endfunction
  endclass: ucie_channel_env