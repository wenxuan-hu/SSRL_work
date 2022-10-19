// req driver
  class req_driver extends uvm_driver #(req_trans);
    virtual litedram_cmd_interface intf;
    mailbox #(req_trans) req_mb;
    mailbox #(req_trans) rsp_mb;

    `uvm_component_utils(req_driver)
  
    function new (string name = "req_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual litedram_cmd_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","cmd_rw_interface interface handle is NULL, please check if target interface has been intantiated")
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
        intf.drv_ck.interface_bank_valid <= 0;
        intf.drv_ck.interface_bank_we<= 0;
	      intf.drv_ck.interface_bank_mw<= 0;
	      intf.drv_ck.interface_bank_addr<= 0;
      end
    endtask

    task do_drive();
      req_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
        this.req_write(req);
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
      end
    endtask
  
    task req_write(input req_trans t);
      foreach(t.col_address[i]) begin
        @(intf.drv_ck);
        intf.drv_ck.interface_bank_valid <= 1'b1;
        intf.drv_ck.interface_bank_we<= t.we[i];
	      intf.drv_ck.interface_bank_mw<= t.mw[i];
	      intf.drv_ck.interface_bank_addr<= {t.row_address,t.col_address[i]};
        while(!intf.drv_ck.interface_bank_ready) @(intf.drv_ck);
        if(t.we[i]==0) `uvm_info(get_type_name(), $sformatf("REQ sent command READ at row 0x%0h, col 0x%0h0 ",t.row_address,t.col_address[i]), UVM_HIGH)
        else if(t.mw[i]==0) `uvm_info(get_type_name(), $sformatf("REQ sent command WRITE at row 0x%0h, col 0x%0h0 ",t.row_address,t.col_address[i]), UVM_HIGH)
        else `uvm_info(get_type_name(), $sformatf("REQ sent command MASKED_WRITE at row 0x%0h, col 0x%0h0 ",t.row_address,t.col_address[i]), UVM_HIGH)
        repeat(t.idle_n) this.req_idle();
      end
    endtask
    
    task req_idle();
      @(intf.drv_ck);
      intf.drv_ck.interface_bank_valid <= 0;
      intf.drv_ck.interface_bank_we<= 0;
	    intf.drv_ck.interface_bank_mw<= 0;
	    intf.drv_ck.interface_bank_addr<= 0;
    endtask
  endclass: req_driver