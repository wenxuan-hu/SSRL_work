  //uvm_env
  class bank_machine_env extends uvm_env;
    req_agent agent;
    bm_monitor bm_mon;
    bm_responder bm_res;
    bank_machine_checker bank_machine_chker;
    bank_machine_virtual_sequencer virt_sqr;
    //bank_machine_coverage bank_machine_cvrg;

    `uvm_component_utils(bank_machine_env)

    function new (string name = "bank_machine_env", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      this.bank_machine_chker = bank_machine_checker::type_id::create("bank_machine_chker", this);
      this.agent = req_agent::type_id::create("req_agent", this);
      this.bm_mon = bm_monitor::type_id::create("bm_mon", this);
      this.bm_res = bm_responder::type_id::create("bm_res", this);
      virt_sqr = bank_machine_virtual_sequencer::type_id::create("virt_sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      this.agent.monitor.mon_req_port.connect(this.bank_machine_chker.in_tlm_fifo.analysis_export);
      this.agent.monitor.mon_wdata_port.connect(this.bank_machine_chker.in_tlm_fifo_wdata.analysis_export);
      this.agent.monitor.mon_rdata_port.connect(this.bank_machine_chker.in_tlm_fifo_rdata.analysis_export);
      this.agent.monitor.mon_wdata_ready_port.connect(this.bank_machine_chker.out_tlm_fifo_wdata.analysis_export);
      this.agent.monitor.mon_rdata_valid_port.connect(this.bank_machine_chker.out_tlm_fifo_rdata.analysis_export);
      this.bm_mon.mon_rw_cmd_port.connect(this.bank_machine_chker.out_tlm_fifo.analysis_export);
      virt_sqr.req_sqr=agent.sequencer;
    endfunction
  endclass: bank_machine_env