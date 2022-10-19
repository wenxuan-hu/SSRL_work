  // bankmachine monitor
  class req_monitor extends uvm_monitor;
    virtual litedram_cmd_interface intf;
    uvm_analysis_port #(req_t) mon_req_port;
    uvm_analysis_port #(data_t)mon_rdata_port;
    uvm_analysis_port #(data_t)mon_wdata_port;
    uvm_analysis_port #(data_t)mon_rdata_valid_port;
    uvm_analysis_port #(data_t)mon_wdata_ready_port;

    `uvm_component_utils(req_monitor)

    function new(string name="req_monitor", uvm_component parent);
      super.new(name, parent);
      mon_req_port = new("mon_req_port", this);
      mon_rdata_port = new("mon_rdata_port", this);
      mon_wdata_port = new("mon_wdata_port", this);
      mon_rdata_valid_port = new("mon_rdata_valid_port", this);
      mon_wdata_ready_port = new("mon_wdata_ready_port", this);
    endfunction

    function void set_interface(virtual litedram_cmd_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      this.mon_trans();
    endtask

    task mon_trans();
      req_t m;
      data_t d;

      forever begin
        @(posedge intf.clk iff ((intf.mon_ck.interface_bank_valid==='b1 && intf.mon_ck.interface_bank_ready==='b1)||((intf.mon_ck.interface_bank_wdata_ready==='b1)||(intf.mon_ck.interface_bank_rdata_valid==='b1))));
        if(intf.mon_ck.interface_bank_valid==='b1 && intf.mon_ck.interface_bank_ready==='b1) begin
          m.we = intf.mon_ck.interface_bank_we;
          m.mw = intf.mon_ck.interface_bank_mw;
          m.address = intf.mon_ck.interface_bank_addr;
          m.t=$time;
          mon_req_port.write(m);

          if(m.we==0) begin
            d.we=0;
            mon_rdata_port.write(d);
            `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Crossbar cmd READ at row 0x%0h, col 0x%0h0", m.t,m.address[22:6],m.address[5:0]), UVM_HIGH)
          end else if(m.mw==0) begin
            d.we=1;
            mon_wdata_port.write(d);
            `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Crossbar cmd WRITE at row 0x%0h, col 0x%0h0", m.t,m.address[22:6],m.address[5:0]), UVM_HIGH)
          end else begin
            d.we=1;
            mon_wdata_port.write(d);
            `uvm_info(get_type_name(), $sformatf("Time %0t Monitored Crossbar cmd MASKED_WRITE at row 0x%0h, col 0x%0h0", m.t,m.address[22:6],m.address[5:0]), UVM_HIGH)
          end
        end

        //write data channel
        if(intf.mon_ck.interface_bank_wdata_ready==='b1) begin
          d.we=1;
          mon_wdata_ready_port.write(d);
        end

        //read data channel
        if(intf.mon_ck.interface_bank_rdata_valid==='b1) begin
          d.we=0;
          mon_rdata_valid_port.write(d);
        end
      end
    endtask
  endclass: req_monitor