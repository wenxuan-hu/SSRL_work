  //uvm_env
  class DFIAdapter_env extends uvm_env;
    dfi_agent agent;
    dfi_lpddr4_monitor dfi_lpddr4_mon;
    DFIAdapter_checker DFIAdapter_chker;
    DFIAdapter_virtual_sequencer virt_sqr;
    //DFIAdapter_coverage DFIAdapter_cvrg;

    `uvm_component_utils(DFIAdapter_env)

    function new (string name = "DFIAdapter_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      this.DFIAdapter_chker = DFIAdapter_checker::type_id::create("DFIAdapter_chker", this);
      this.agent = dfi_agent::type_id::create("dfi_agent", this);
      this.dfi_lpddr4_mon = dfi_lpddr4_monitor::type_id::create("dfi_lpddr4_mon", this);
      virt_sqr = DFIAdapter_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      this.agent.monitor.mon_dfi_port.connect(this.DFIAdapter_chker.in_tlm_fifo.analysis_export);
      this.dfi_lpddr4_mon.mon_cmd_port.connect(this.DFIAdapter_chker.out_tlm_fifo.analysis_export);
      virt_sqr.dfi_sqr=agent.sequencer;
    endfunction
  endclass: DFIAdapter_env