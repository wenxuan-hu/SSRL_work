  class nat_monitor extends uvm_monitor;
    virtual native_interface intf;
    uvm_analysis_port #(nat_cmd_t) mon_cmd_port;
    uvm_analysis_port #(data_t) mon_wdata_port;
    uvm_analysis_port #(data_t) mon_rdata_port;

    `uvm_component_utils(nat_monitor)

    function new(string name="nat_monitor", uvm_component parent);
      super.new(name, parent);
      mon_cmd_port = new("mon_cmd_port", this);
      mon_wdata_port = new("mon_wdata_port", this);
      mon_rdata_port = new("mon_rdata_port", this);
    endfunction

    function void set_interface(virtual native_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "native interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      fork
        this.mon_cmd();
        this.mon_wdata();
        this.mon_rdata();
      join
    endtask

    task mon_cmd();
      nat_cmd_t m;
      forever begin
        @(intf.mon_ck iff (intf.mon_ck.native_cmd_valid==='b1 && intf.mon_ck.native_cmd_ready==='b1));
        m.address[29:4] = intf.mon_ck.native_cmd_payload_addr;
        m.address[3:0] = 4'd0;
        m.we = intf.mon_ck.native_cmd_payload_we;
        m.mw = intf.mon_ck.native_cmd_payload_mw;
        m.t=$time;
        mon_cmd_port.write(m);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Native cmd [we,mw]=[%b,%b] at address 0x%h", m.t,m.we,m.mw,m.address), UVM_HIGH)
      end
    endtask

    task mon_rdata();
      data_t rd;
      forever begin
        @(intf.mon_ck iff (intf.mon_ck.rdata_valid==='b1));
        rd.data = intf.mon_ck.rdata_payload_data;
        rd.we = 1'd0;
        mon_rdata_port.write(rd);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Native READ DATA 0x%0h", $time,rd.data), UVM_HIGH)
      end
    endtask

    task mon_wdata();
      data_t wr;
      forever begin
        @(intf.mon_ck iff (intf.mon_ck.wdata_valid==='b1 && intf.mon_ck.wdata_ready==='b1));
        wr.data = intf.mon_ck.wdata_payload_data;
        wr.data_mask = ~intf.mon_ck.wdata_payload_we;
        wr.we = 1'd1;
        mon_wdata_port.write(wr);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Native WRITE DATA 0x%0h", $time,wr.data), UVM_HIGH)
      end
    endtask
  endclass: nat_monitor