  class refresher_monitor extends uvm_monitor;
    virtual cmd_rw_interface intf;
    uvm_analysis_port #(cmd_t) mon_cmd_port;
    cmd_t m_last;

    `uvm_component_utils(refresher_monitor)

    function new(string name="refresher_monitor", uvm_component parent);
      super.new(name, parent);
      mon_cmd_port = new("mon_cmd_port", this);
    endfunction

    function void set_interface(virtual cmd_rw_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      this.mon_trans();
    endtask

    task mon_trans();
      cmd_t m;
      m_last.cmd=ERROR_0;
      forever begin
        @(posedge intf.clk iff (intf.mon_ck.cmd_valid===1'b1 && intf.mon_ck.cmd_ready===1'b1 &&intf.mon_ck.cmd_payload_ras==1'b1));
        case({intf.mon_ck.cmd_payload_ras,intf.mon_ck.cmd_payload_cas,intf.mon_ck.cmd_payload_we})
          3'b101: m.cmd=PRECHARGE_ALL;
          3'b110: m.cmd=REFRESH_ALL;
          default: m.cmd=ERROR_0;
        endcase
        m.address=intf.mon_ck.cmd_payload_a;
        m.t=$time;
        mon_cmd_port.write(m);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Refresher cmd %s at address %h", m.t ,DDR_CMD[m.cmd],m.address), UVM_HIGH)
        m_last=m;
      end
    endtask
  endclass: refresher_monitor