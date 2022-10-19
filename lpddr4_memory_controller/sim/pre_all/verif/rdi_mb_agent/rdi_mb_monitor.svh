  class rdi_mb_monitor extends uvm_monitor;
    virtual rdi_mb_interface intf;
    uvm_analysis_port #(rdi_data_t) mon_wdata_port;
    uvm_analysis_port #(rdi_data_t) mon_rdata_port;

    `uvm_component_utils(rdi_mb_monitor)

    function new(string name="rdi_mb_monitor", uvm_component parent);
      super.new(name, parent);
      mon_wdata_port = new("mon_wdata_port", this);
      mon_rdata_port = new("mon_rdata_port", this);
    endfunction

    function void set_interface(virtual rdi_mb_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "rdi_mb interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      fork
        this.mon_ig_data();
        this.mon_eg_data();
      join
    endtask

    task mon_ig_data();
      rdi_data_t rdi_w_t;
      forever begin
        @(intf.mon_ck iff ((intf.mon_ck.lp_valid==='b1)&&(intf.mon_ck.lp_irdy==='b1)&&(intf.mon_ck.pl_trdy==='b1)));
        rdi_w_t.data = intf.mon_ck.lp_data;
        mon_wdata_port.write(rdi_w_t);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored UCIE RDI IGRESS DATA 0x%0h", $time,rdi_w_t.data), UVM_HIGH)
      end
    endtask

    task mon_eg_data();
      rdi_data_t rdi_r_t;
      forever begin
        @(intf.mon_ck iff (intf.mon_ck.pl_valid==='b1));
        rdi_r_t.data = intf.mon_ck.pl_data;
        mon_rdata_port.write(rdi_r_t);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored UCIE RDI EGRESS DATA 0x%0h", $time,rdi_r_t.data), UVM_HIGH)
      end
    endtask

  endclass: rdi_mb_monitor