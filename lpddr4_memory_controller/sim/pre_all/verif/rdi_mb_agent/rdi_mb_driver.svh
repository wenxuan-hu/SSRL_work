// Bankmachine driver
  class rdi_mb_driver extends uvm_driver #(rdi_mb_trans);
    virtual rdi_mb_interface intf;
    mailbox #(rdi_mb_trans) req_mb;
    mailbox #(rdi_mb_trans) rsp_mb;

    `uvm_component_utils(rdi_mb_driver)
  
    function new (string name = "rdi_mb_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual rdi_mb_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","rdi_mb_interface interface handle is NULL, please check if target interface has been intantiated")
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
        intf.drv_ck.lp_valid <= 0;
        intf.drv_ck.lp_irdy<= 0;
	      intf.drv_ck.lp_data<= 0;
      end
    endtask

    task do_drive();
      rdi_mb_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
        this.rdi_mb_write(req);
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
      end
    endtask
  
    task rdi_mb_write(rdi_mb_trans t);
      @(posedge intf.clk);
      intf.drv_ck.lp_valid <= 1'b1;
      intf.drv_ck.lp_irdy<= 1'b1;
	    intf.drv_ck.lp_data<= t.data;
      @(negedge intf.clk);
      wait(intf.pl_trdy===1'b1);
      `uvm_info(get_type_name(), $sformatf("RDI Port sent data [0x%0h]",t.data), UVM_HIGH)
      repeat(t.n_idles) rdi_mb_idle();
    endtask
    
    task rdi_mb_idle();
      @(posedge intf.clk);
        intf.drv_ck.lp_valid <= 0;
        intf.drv_ck.lp_irdy<= 0;
	      intf.drv_ck.lp_data<= 0;
    endtask

  endclass: rdi_mb_driver