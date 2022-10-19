  class dla_monitor extends uvm_monitor;
    virtual mosi_interface intf;
    uvm_analysis_port #(dla_cmd_t) mon_cmd_port;
    uvm_analysis_port #(data_t) mon_wdata_port;
    uvm_analysis_port #(data_t) mon_rdata_port;

    `uvm_component_utils(dla_monitor)

    function new(string name="dla_monitor", uvm_component parent);
      super.new(name, parent);
      mon_cmd_port = new("mon_cmd_port", this);
      mon_wdata_port = new("mon_wdata_port", this);
      mon_rdata_port = new("mon_rdata_port", this);
    endfunction

    function void set_interface(virtual mosi_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", " mosi interface handle is NULL, please check if target interface has been intantiated")
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
      dla_cmd_t m;
      forever begin
        @(intf.mon_cb iff (intf.mon_cb.mosi_valid_i==='b1 && intf.mon_cb.mosi_ready_o === 1'b1));
        //m.address[29:0] = intf.mon_cb.mosi_data_i[29:0];
        if  (~intf.mon_cb.mosi_data_i[255])  begin
          //m.address[29:0] = {intf.mon_cb.mosi_data_i[25:0], 4'b0000};
          m.address[29:0] = {intf.mon_cb.mosi_data_i[29:0]};
   $display("  real_address  ---------      %0h",   m.address);
          
          if  (intf.mon_cb.mosi_data_i[63:62] ==  2'b10)
          m.we = 1'b1;
          if  (intf.mon_cb.mosi_data_i[63:62] ==  2'b01)
          m.we = 1'b0;


          m.mw = 'd0;
          m.length = intf.mon_cb.mosi_data_i[61:54];
          m.t=$time;
          mon_cmd_port.write(m);
          `uvm_info(get_type_name(), $sformatf("Time %0t Monitored mosi cmd [we,mw]=[%b,%b] at address 0x%h", m.t,m.we,m.mw,m.address), UVM_HIGH)
        end
      end
    endtask

    task mon_rdata();
      data_t rd;
      forever begin
        @(intf.mon_cb iff (intf.mon_cb.miso_valid_o==='b1 &&  intf.mon_cb.miso_ready_i));
        if(intf.mon_cb.miso_data_o[255])  begin
          rd.data = intf.mon_cb.miso_data_o;
          rd.we = 1'b0;

          mon_rdata_port.write(rd);
          `uvm_info(get_type_name(), $sformatf("Time %0t Monitored mosi READ DATA 0x%0h", $time,rd.data), UVM_HIGH)
        end
      end
    endtask

    task mon_wdata();
      data_t wr;
      forever begin
        @(intf.mon_cb iff (intf.mon_cb.mosi_valid_i===1'b1  &&  intf.mon_cb.mosi_ready_o ));
        if(intf.mon_cb.mosi_data_i[255])begin
          wr.data = intf.mon_cb.mosi_data_i;
          wr.we = 1'b1;
          mon_wdata_port.write(wr);
          `uvm_info(get_type_name(), $sformatf("Time %0t Monitored MOSI WRITE DATA 0x%0h",
          $time,wr.data), UVM_HIGH)
        end
      end
    endtask
  endclass: dla_monitor
