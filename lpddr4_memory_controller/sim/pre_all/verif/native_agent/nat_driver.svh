// Bankmachine driver
  class nat_driver extends uvm_driver #(nat_trans);
    virtual native_interface intf;
    mailbox #(nat_trans) req_mb;
    mailbox #(nat_trans) rsp_mb;

    `uvm_component_utils(nat_driver)
  
    function new (string name = "nat_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual native_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","native_interface interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      fork
       this.do_drive();
       this.do_reset();
      join
    endtask

    task do_reset();
      forever begin
        @(posedge intf.rst);
        intf.drv_ck.native_cmd_valid <= 0;
        intf.drv_ck.native_cmd_payload_we<= 0;
	      intf.drv_ck.native_cmd_payload_mw<= 0;
	      intf.drv_ck.native_cmd_payload_addr<= 0;
	      intf.drv_ck.wdata_valid<= 0;
	      intf.drv_ck.wdata_payload_data<= 0;
	      intf.drv_ck.wdata_payload_we<= 0;
      end
    endtask

    task do_drive();
      nat_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
        fork
          this.nat_write_cmd(req);
          this.nat_write_data(req);
        join
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
      end
    endtask
  
    task nat_write_cmd(nat_trans t);
      @(posedge intf.clk);
      intf.drv_ck.native_cmd_valid <= 1'b1;
      intf.drv_ck.native_cmd_payload_we<= t.we;
	    intf.drv_ck.native_cmd_payload_mw<= t.mw;
	    intf.drv_ck.native_cmd_payload_addr<= {t.channel,t.address};
      @(negedge intf.clk);
      wait(intf.native_cmd_ready===1'b1);
      `uvm_info(get_type_name(), $sformatf("Native Port %h sent command [we,mw]=[%0d,%0d] at address 0x%0h0",t.channel,t.we,t.mw,{t.channel,t.address}), UVM_HIGH)
      repeat(t.n_idles) nat_cmd_idle();
    endtask

    task nat_write_data(nat_trans t);
      if(t.we==1) begin
        @(posedge intf.clk)
        intf.drv_ck.wdata_valid<= 1'b1;
	      intf.drv_ck.wdata_payload_data<= t.data[255:0];
        intf.drv_ck.wdata_payload_we<= ~t.data_mask[31:0];
        @(negedge intf.clk);
        wait(intf.wdata_ready===1'b1);
        `uvm_info(get_type_name(), $sformatf("Native Port %h sent WDATA [data=[0x%0h]",t.channel,t.data[255:0]), UVM_HIGH)
        @(posedge intf.clk)
        intf.drv_ck.wdata_valid<= 1'b1;
        intf.drv_ck.wdata_payload_data<= t.data[511:256];
        intf.drv_ck.wdata_payload_we<= ~t.data_mask[63:32];
        @(negedge intf.clk);
        wait(intf.wdata_ready===1'b1);
        `uvm_info(get_type_name(), $sformatf("Native Port %h sent WDATA [data=[0x%0h]",t.channel,t.data[511:256]), UVM_HIGH)
        repeat(t.n_idles) nat_wdata_idle();
      end
    endtask

    
    task nat_cmd_idle();
      @(posedge intf.clk);
      intf.drv_ck.native_cmd_valid <= 0;
      intf.drv_ck.native_cmd_payload_we<= 0;
	    intf.drv_ck.native_cmd_payload_mw<= 0;
	    intf.drv_ck.native_cmd_payload_addr<= 0;
    endtask

    task nat_wdata_idle();
      @(posedge intf.clk);
    	intf.drv_ck.wdata_valid<= 0;
	    intf.drv_ck.wdata_payload_data<= 0;
	    intf.drv_ck.wdata_payload_we<= 0;
    endtask

  endclass: nat_driver