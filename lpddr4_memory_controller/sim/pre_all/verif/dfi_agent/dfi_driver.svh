// dfi driver
  class dfi_driver extends uvm_driver #(dfi_trans);
    virtual dfi_interface intf;
    mailbox #(dfi_trans) req_mb;
    mailbox #(dfi_trans) rsp_mb;

    `uvm_component_utils(dfi_driver)
  
    function new (string name = "dfi_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual dfi_interface intf);
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
          intf.dfi_phase0_interface_if.drv_ck.cs_n<= 1'b1;
          intf.dfi_phase0_interface_if.drv_ck.address<= 'd0;
          intf.dfi_phase0_interface_if.drv_ck.bank<= 'd0;
	        intf.dfi_phase0_interface_if.drv_ck.cas_n<= 1'b1;
	        intf.dfi_phase0_interface_if.drv_ck.ras_n<= 1'b1;
          intf.dfi_phase0_interface_if.drv_ck.we_n<= 1'b1;
          intf.dfi_phase0_interface_if.drv_ck.reset_n<= 1'b0;
          intf.dfi_phase0_interface_if.drv_ck.mw<= 1'b0;

          intf.dfi_phase1_interface_if.drv_ck.cs_n<= 1'b1;
          intf.dfi_phase1_interface_if.drv_ck.address<= 'd0;
          intf.dfi_phase1_interface_if.drv_ck.bank<= 'd0;
	        intf.dfi_phase1_interface_if.drv_ck.cas_n<= 1'b1;
	        intf.dfi_phase1_interface_if.drv_ck.ras_n<= 1'b1;
          intf.dfi_phase1_interface_if.drv_ck.we_n<= 1'b1;
          intf.dfi_phase1_interface_if.drv_ck.mw<= 1'b0;
          intf.dfi_phase1_interface_if.drv_ck.reset_n<= 1'b0;

          intf.dfi_phase2_interface_if.drv_ck.cs_n<= 1'b1;
          intf.dfi_phase2_interface_if.drv_ck.address<= 'd0;
          intf.dfi_phase2_interface_if.drv_ck.bank<= 'd0;
	        intf.dfi_phase2_interface_if.drv_ck.cas_n<= 1'b1;
	        intf.dfi_phase2_interface_if.drv_ck.ras_n<= 1'b1;
          intf.dfi_phase2_interface_if.drv_ck.we_n<= 1'b1;
          intf.dfi_phase2_interface_if.drv_ck.mw<= 1'b0;
          intf.dfi_phase2_interface_if.drv_ck.reset_n<= 1'b0;

          intf.dfi_phase3_interface_if.drv_ck.cs_n<= 1'b1;
          intf.dfi_phase3_interface_if.drv_ck.address<= 'd0;
          intf.dfi_phase3_interface_if.drv_ck.bank<= 'd0;
	        intf.dfi_phase3_interface_if.drv_ck.cas_n<= 1'b1;
	        intf.dfi_phase3_interface_if.drv_ck.ras_n<= 1'b1;
          intf.dfi_phase3_interface_if.drv_ck.we_n<= 1'b1;
          intf.dfi_phase3_interface_if.drv_ck.mw<= 1'b0;
          intf.dfi_phase3_interface_if.drv_ck.reset_n<= 1'b0;
        end
    endtask

    task do_drive();
      dfi_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
        this.dfi_write(req);
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
      end
    endtask

    task drive_phase(virtual dfi_phase_interface intf,dfi_trans t);
      case(t.cmd)
        PRECHARGE: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= 'd0;
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b1;
	        intf.drv_ck.ras_n<= 1'b0;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ",DDR_CMD[t.cmd],t.bank), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        PRECHARGE_ALL: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd1,10'd0};
          intf.drv_ck.bank<= 'd0;
	        intf.drv_ck.cas_n<= 1'b1;
	        intf.drv_ck.ras_n<= 1'b0;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s",DDR_CMD[t.cmd]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        REFRESH_ALL: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd1,10'd0};
          intf.drv_ck.bank<= 'd0;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b0;
          intf.drv_ck.we_n<= 1'b1;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s",DDR_CMD[t.cmd]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        ACTIVATE: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= t.address;
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b1;
	        intf.drv_ck.ras_n<= 1'b0;
          intf.drv_ck.we_n<= 1'b1;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,row 0x%0h",DDR_CMD[t.cmd],t.bank,t.address), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        COL_READ: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd0,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b1;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        COL_READ_AP: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd1,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b1;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        COL_WRITE: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd0,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        COL_WRITE_AP: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd1,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b0;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        MASKED_WRITE: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd0,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b1;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        MASKED_WRITE_AP: begin
          @(intf.drv_ck);
          intf.drv_ck.cs_n<= 1'b0;
          intf.drv_ck.address<= {7'd1,t.address[9:4],4'd0};
          intf.drv_ck.bank<= t.bank;
	        intf.drv_ck.cas_n<= 1'b0;
	        intf.drv_ck.ras_n<= 1'b1;
          intf.drv_ck.we_n<= 1'b0;
          intf.drv_ck.reset_n<= 1'b1;
          intf.drv_ck.mw<= 1'b1;
          `uvm_info(get_type_name(), $sformatf("DFI sent command %s at bank %0d ,col 0x%0h0",DDR_CMD[t.cmd],t.bank,t.address[9:4]), UVM_HIGH)
          repeat(t.idle_n) this.dfi_idle();
        end
        default:begin
          this.dfi_idle();
        end
       endcase
    endtask
  
    task dfi_write(dfi_trans t);
      case(t.phase)
        2'd0: this.drive_phase(intf.dfi_phase0_interface_if,t);
        2'd1: this.drive_phase(intf.dfi_phase1_interface_if,t);
        2'd2: this.drive_phase(intf.dfi_phase2_interface_if,t);
        2'd3: this.drive_phase(intf.dfi_phase3_interface_if,t);
      endcase
    endtask
    
    task dfi_idle();
      @(intf.dfi_phase0_interface_if.drv_ck);
        intf.dfi_phase0_interface_if.drv_ck.cs_n<= 1'b1;
        intf.dfi_phase0_interface_if.drv_ck.address<= 'd0;
        intf.dfi_phase0_interface_if.drv_ck.bank<= 'd0;
	      intf.dfi_phase0_interface_if.drv_ck.cas_n<= 1'b1;
	      intf.dfi_phase0_interface_if.drv_ck.ras_n<= 1'b1;
        intf.dfi_phase0_interface_if.drv_ck.we_n<= 1'b1;
        intf.dfi_phase0_interface_if.drv_ck.reset_n<= 1'b1;
        intf.dfi_phase0_interface_if.drv_ck.mw<= 1'b0;

        intf.dfi_phase1_interface_if.drv_ck.cs_n<= 1'b1;
        intf.dfi_phase1_interface_if.drv_ck.address<= 'd0;
        intf.dfi_phase1_interface_if.drv_ck.bank<= 'd0;
	      intf.dfi_phase1_interface_if.drv_ck.cas_n<= 1'b1;
	      intf.dfi_phase1_interface_if.drv_ck.ras_n<= 1'b1;
        intf.dfi_phase1_interface_if.drv_ck.we_n<= 1'b1;
        intf.dfi_phase1_interface_if.drv_ck.mw<= 1'b0;
        intf.dfi_phase1_interface_if.drv_ck.reset_n<= 1'b1;

        intf.dfi_phase2_interface_if.drv_ck.cs_n<= 1'b1;
        intf.dfi_phase2_interface_if.drv_ck.address<= 'd0;
        intf.dfi_phase2_interface_if.drv_ck.bank<= 'd0;
	      intf.dfi_phase2_interface_if.drv_ck.cas_n<= 1'b1;
	      intf.dfi_phase2_interface_if.drv_ck.ras_n<= 1'b1;
        intf.dfi_phase2_interface_if.drv_ck.we_n<= 1'b1;
        intf.dfi_phase2_interface_if.drv_ck.mw<= 1'b0;
        intf.dfi_phase2_interface_if.drv_ck.reset_n<= 1'b1;

        intf.dfi_phase3_interface_if.drv_ck.cs_n<= 1'b1;
        intf.dfi_phase3_interface_if.drv_ck.address<= 'd0;
        intf.dfi_phase3_interface_if.drv_ck.bank<= 'd0;
	      intf.dfi_phase3_interface_if.drv_ck.cas_n<= 1'b1;
	      intf.dfi_phase3_interface_if.drv_ck.ras_n<= 1'b1;
        intf.dfi_phase3_interface_if.drv_ck.we_n<= 1'b1;
        intf.dfi_phase3_interface_if.drv_ck.mw<= 1'b0;
        intf.dfi_phase3_interface_if.drv_ck.reset_n<= 1'b1;
    endtask
  endclass: dfi_driver