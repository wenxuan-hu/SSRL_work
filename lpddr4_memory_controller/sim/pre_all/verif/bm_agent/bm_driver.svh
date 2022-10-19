// Bankmachine driver
  class bm_driver extends uvm_driver #(bm_trans);
    bit precharged=0;
    virtual cmd_rw_interface intf;
    bit refresh_in_progress=0;
    bit drive_in_progress=0;
    bit begin_with_refresh=0;
    bit [2:0] bank_address=0;
    //bit[2:0] bank_address;
    mailbox #(bm_trans) req_mb;
    mailbox #(bm_trans) rsp_mb;

    `uvm_component_utils(bm_driver)
  
    function new (string name = "bm_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual cmd_rw_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","cmd_rw_interface interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      fork
       this.do_refresh();
       this.do_drive();
       this.do_reset();
      join
    endtask

    task do_reset();
      forever begin
        @(posedge intf.rst);
        intf.drv_ck.cmd_valid <= 0;
        intf.drv_ck.cmd_payload_a<= 0;
	      intf.drv_ck.cmd_payload_ba<= 0;
	      intf.drv_ck.cmd_payload_cas<= 0;
	      intf.drv_ck.cmd_payload_ras<= 0;
	      intf.drv_ck.cmd_payload_we<= 0;
	      intf.drv_ck.cmd_payload_is_cmd<= 0;
	      intf.drv_ck.cmd_payload_is_read<= 0;
	      intf.drv_ck.cmd_payload_is_write<= 0;
	      intf.drv_ck.cmd_payload_is_mw<= 0;
      end
    endtask

    task do_drive();
      bm_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
        this.bm_write(req);
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
        precharged=req.with_autoprecharge;
      end
    endtask

    task do_refresh();
      forever begin
        @(intf.drv_ck);
        if(intf.drv_ck.refresh_req===1'b1) begin
          wait(drive_in_progress==0);
          refresh_in_progress=1;
          @(intf.drv_ck);
          intf.drv_ck.refresh_gnt<=1'b1;
          `uvm_info("REFRESH IN", $sformatf("Bank %h into REFRESH",bank_address), UVM_HIGH)
          while(intf.drv_ck.refresh_req===1'b1) @(intf.drv_ck);
          //wait(intf.drv_ck.refresh_req===1'b0);
          intf.drv_ck.refresh_gnt<=1'b0;
          refresh_in_progress=0;
          begin_with_refresh=1;
          `uvm_info("REFRESH OUT", $sformatf("Bank %h out of REFRESH",bank_address), UVM_HIGH)
        end
      end
    endtask
  
    task bm_write(input bm_trans t);
      bank_address=t.bank_address;
      wait(refresh_in_progress==0);
      drive_in_progress=1;
      for(int i=0;i<t.cas.size;i++) begin
        //drive precharge
        if(i==0) begin
          if((precharged==0)||(begin_with_refresh==1)) begin
            begin_with_refresh=0;
            @(intf.drv_ck);
            intf.drv_ck.cmd_valid <= 1'b1;
            intf.drv_ck.cmd_payload_a<= 0;
	          intf.drv_ck.cmd_payload_ba<= t.bank_address;
	          intf.drv_ck.cmd_payload_cas<= t.cas[i];
	          intf.drv_ck.cmd_payload_ras<= t.ras[i];
	          intf.drv_ck.cmd_payload_we<= t.we[i];
            intf.drv_ck.cmd_payload_is_cmd<= t.is_cmd[i];
	          intf.drv_ck.cmd_payload_is_read<= t.is_read[i];
	          intf.drv_ck.cmd_payload_is_write<= t.is_write[i];
	          intf.drv_ck.cmd_payload_is_mw<= t.is_mw[i];
            while(!intf.drv_ck.cmd_ready) @(intf.drv_ck);
            `uvm_info(get_type_name(), $sformatf("Bank %h sent command PRECHARGE",t.bank_address), UVM_HIGH)
            //tRP
            repeat(tRP) bm_idle();
          end
        end
        else if (i==1) begin
          @(intf.drv_ck);
          intf.drv_ck.cmd_valid <= 1'b1;
          intf.drv_ck.cmd_payload_a<= t.row_address;
	        intf.drv_ck.cmd_payload_ba<= t.bank_address;
	        intf.drv_ck.cmd_payload_cas<= t.cas[i];
	        intf.drv_ck.cmd_payload_ras<= t.ras[i];
	        intf.drv_ck.cmd_payload_we<= t.we[i];
          intf.drv_ck.cmd_payload_is_cmd<= t.is_cmd[i];
	        intf.drv_ck.cmd_payload_is_read<= t.is_read[i];
	        intf.drv_ck.cmd_payload_is_write<= t.is_write[i];
	        intf.drv_ck.cmd_payload_is_mw<= t.is_mw[i];
          while(!intf.drv_ck.cmd_ready) @(intf.drv_ck);
          `uvm_info(get_type_name(), $sformatf("Bank %h sent command ACTIVATE row 0x%0h",t.bank_address,t.row_address), UVM_HIGH)
          //tRCD
          repeat(tRCD) bm_idle();
        end
        else if(i<t.cas.size-1) begin
          //masked write
          if(t.is_mw[i]==1) begin
            repeat(tCCDMW-2) bm_idle();
          end
          @(intf.drv_ck);
          intf.drv_ck.cmd_valid <= 1'b1;
          intf.drv_ck.cmd_payload_a<= {7'd0,t.col_address[i-2],4'd0};
	        intf.drv_ck.cmd_payload_ba<= t.bank_address;
	        intf.drv_ck.cmd_payload_cas<= t.cas[i];
	        intf.drv_ck.cmd_payload_ras<= t.ras[i];
	        intf.drv_ck.cmd_payload_we<= t.we[i];
          intf.drv_ck.cmd_payload_is_cmd<= t.is_cmd[i];
	        intf.drv_ck.cmd_payload_is_read<= t.is_read[i];
	        intf.drv_ck.cmd_payload_is_write<= t.is_write[i];
	        intf.drv_ck.cmd_payload_is_mw<= t.is_mw[i];
          while(!intf.drv_ck.cmd_ready) @(intf.drv_ck);
          if(t.we[i]==1)
            `uvm_info(get_type_name(), $sformatf("Bank %h sent command WRITE/MASKED_WRITE col 0x%0h0",t.bank_address,t.col_address[i-2]), UVM_HIGH)
          else
            `uvm_info(get_type_name(), $sformatf("Bank %h sent command READ col 0x%0h0",t.bank_address,t.col_address[i-2]), UVM_HIGH)
          //tCCD
          repeat(tCCD) bm_idle();

        //last cmd, check if it with auto precharge
        end else begin    
          if(t.is_mw[i]==1) begin
            repeat(tCCDMW-2) bm_idle();
          end

          if(t.with_autoprecharge) begin
            @(intf.drv_ck);
            intf.drv_ck.cmd_valid <= 1'b1;
            intf.drv_ck.cmd_payload_a<= {6'd0,1'b1,t.col_address[i-2],4'd0};
	          intf.drv_ck.cmd_payload_ba<= t.bank_address;
	          intf.drv_ck.cmd_payload_cas<= t.cas[i];
	          intf.drv_ck.cmd_payload_ras<= t.ras[i];
	          intf.drv_ck.cmd_payload_we<= t.we[i];
            intf.drv_ck.cmd_payload_is_cmd<= t.is_cmd[i];
	          intf.drv_ck.cmd_payload_is_read<= t.is_read[i];
	          intf.drv_ck.cmd_payload_is_write<= t.is_write[i];
	          intf.drv_ck.cmd_payload_is_mw<= t.is_mw[i];
            while(!intf.drv_ck.cmd_ready) @(intf.drv_ck);
            if(t.we[i]==1)
              `uvm_info(get_type_name(), $sformatf("Bank %h sent command WRITE_AP/MASKED_WRITE_AP col 0x%0h",t.bank_address,t.col_address[i-2]), UVM_HIGH)
            else
              `uvm_info(get_type_name(), $sformatf("Bank %h sent command READ_AP col 0x%0h0",t.bank_address,t.col_address[i-2]), UVM_HIGH)
            //tCCD
            repeat(tCCD) bm_idle();
            if(t.we[i]==1)
              repeat(tWTP_sb+tRP) bm_idle();
            else 
              repeat(tRTP_sb+tRP) bm_idle();
          end else begin
            @(intf.drv_ck);
            intf.drv_ck.cmd_valid <= 1'b1;
            intf.drv_ck.cmd_payload_a<= {7'd0,t.col_address[i-2],4'd0};
	          intf.drv_ck.cmd_payload_ba<= t.bank_address;
	          intf.drv_ck.cmd_payload_cas<= t.cas[i];
	          intf.drv_ck.cmd_payload_ras<= t.ras[i];
	          intf.drv_ck.cmd_payload_we<= t.we[i];
            intf.drv_ck.cmd_payload_is_cmd<= t.is_cmd[i];
	          intf.drv_ck.cmd_payload_is_read<= t.is_read[i];
	          intf.drv_ck.cmd_payload_is_write<= t.is_write[i];
	          intf.drv_ck.cmd_payload_is_mw<= t.is_mw[i];
            while(!intf.drv_ck.cmd_ready) @(intf.drv_ck);
            if(t.we[i]==1)
              `uvm_info(get_type_name(), $sformatf("Bank %h sent command WRITE/MASKED_WRITE col 0x%0h0",t.bank_address,t.col_address[i-2]), UVM_HIGH)
            else
              `uvm_info(get_type_name(), $sformatf("Bank %h sent command READ col 0x%0h0",t.bank_address,t.col_address[i-2]), UVM_HIGH)
            //tCCD
            repeat(tCCD) bm_idle();
            if(t.we[i]==1)
              repeat(tWTP_sb) bm_idle();
            else 
              repeat(tRTP_sb) bm_idle();
          end
        end
      end
      //tWTP
      drive_in_progress=0;
      precharged=t.with_autoprecharge;
    endtask
    
    task bm_idle();
      @(intf.drv_ck);
      intf.drv_ck.cmd_valid <= 0;
      intf.drv_ck.cmd_payload_a<= 0;
	    intf.drv_ck.cmd_payload_ba<= 0;
	    intf.drv_ck.cmd_payload_cas<= 0;
	    intf.drv_ck.cmd_payload_ras<= 0;
	    intf.drv_ck.cmd_payload_we<= 0;
      intf.drv_ck.cmd_payload_is_cmd<= 0;
	    intf.drv_ck.cmd_payload_is_read<= 0;
	    intf.drv_ck.cmd_payload_is_write<= 0;
	    intf.drv_ck.cmd_payload_is_mw<= 0;
    endtask
  endclass: bm_driver