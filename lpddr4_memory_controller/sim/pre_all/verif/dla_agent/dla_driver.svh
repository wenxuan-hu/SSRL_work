// Bankmachine driver
  class dla_driver extends uvm_driver #(dla_trans);
    //virtual native_interface intf;
    virtual mosi_interface intf;
    mailbox #(dla_trans) req_mb;
    mailbox #(dla_trans) rsp_mb;

    `uvm_component_utils(dla_driver)
  
    function new (string name = "dla_driver", uvm_component parent);
      super.new(name, parent);
    endfunction

    function void set_interface(virtual mosi_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","mosi_interface interface handle is NULL, please check if target interface has been intantiated")
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
        intf.drv_cb.mosi_data_i <= 0;
        intf.drv_cb.mosi_valid_i<= 0;
	      intf.drv_cb.miso_ready_i  <= 1'b1;
      end
    endtask

    task do_drive();
      dla_trans req, rsp;
      wait(intf.rst===1'b0);
      forever begin
        seq_item_port.get_next_item(req);
//        fork
//          this.dla_write_cmd(req);
//          this.dla_write_data(req);
//        join
       begin 
          this.dla_write_cmd(req);
          this.dla_write_data(req);
      end
        void'($cast(rsp, req.clone()));
        rsp.rsp = 1;
        rsp.set_sequence_id(req.get_sequence_id());
        seq_item_port.item_done(rsp);
      end
    endtask
  
    task dla_write_cmd(dla_trans t);
        $display("  try to trans  ---------      %0h",t.address);
        $display("  burst_length  ---------      %0h",t.length);
      @(posedge intf.clk);
      intf.drv_cb.mosi_valid_i <= 1'b1;
      intf.drv_cb.mosi_data_i <=  { 192'd0  , t.we, t.length, 24'd0,t.address};
      @(negedge intf.clk);
      wait(intf.mosi_ready_o===1'b1);
      `uvm_info(get_type_name(), $sformatf("MOSI Port %h sent command [we]=[%0d] at address 0x%0h0",t.channel,t.we,{t.address}), UVM_HIGH)
      //repeat(t.dla_idles) dla_cmd_idle();
      repeat(1) dla_cmd_idle();
    endtask

    task dla_write_data(dla_trans t);
    int i;
      if(t.we==2'b10) begin
        
        //bit [256*32-1:0]  cur_data=t.dla_data;
        //logic   cur_data[4:0][255:0];
        logic  [255:0] cur_data[31:0];
        cur_data  = t.dla_data;

        //int i;
        i=0;
      
        $display("  try to trans  ---------      %0h",t.dla_data[0]);
        $display("  actually trans  ---------      %0h",cur_data[0]);
        $display("  burst_length  ---------      %0h",t.length);

        repeat(t.length)  begin
          
        @(posedge intf.clk) begin
        //intf.drv_cb.mosi_data_i <= t.dla_data[256*(i+1)-1 :  256*i];
        //intf.drv_cb.mosi_data_i <= cur_data[255:0];
        intf.drv_cb.mosi_data_i <= cur_data[i];
        intf.drv_cb.mosi_valid_i<= 1'b1;
	      intf.drv_cb.miso_ready_i  <= 1'b1;
        end
        @(negedge intf.clk);
        wait(intf.mosi_ready_o===1'b1);
        //`uvm_info(get_type_name(), $sformatf("MOSI Nort %h sent WDATA [data=[0x%0h]",t.channel,cur_data[ 255:0  ]), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("MOSI Nort %h sent WDATA[data=[0x%0h]",t.channel,cur_data[i]), UVM_HIGH)
            
           //cur_data = cur_data >>  'd32; 
          i=i+1;
        end
      


//        @(posedge intf.clk)
//        intf.drv_ck.wdata_valid<= 1'b1;
//	      intf.drv_ck.wdata_payload_data<= t.data[255:0];
//        intf.drv_ck.wdata_payload_we<= ~t.data_mask[31:0];
//        @(negedge intf.clk);
//        wait(intf.wdata_ready===1'b1);
//        `uvm_info(get_type_name(), $sformatf("MOSI Nort %h sent WDATA [data=[0x%0h]",t.channel,t.data[255:0]), UVM_HIGH)
//        @(posedge intf.clk)
//        intf.drv_ck.wdata_valid<= 1'b1;
//        intf.drv_ck.wdata_payload_data<= t.data[511:256];
//        intf.drv_ck.wdata_payload_we<= ~t.data_mask[63:32];
//        @(negedge intf.clk);
//        wait(intf.wdata_ready===1'b1);
//        `uvm_info(get_type_name(), $sformatf("MOSI Port %h sent WDATA [data=[0x%0h]",t.channel,t.data[511:256]), UVM_HIGH)
        //repeat(t.dla_idles) dla_wdata_idle();
        repeat(100) dla_wdata_idle();
      end
    endtask

    
    task dla_cmd_idle();
      @(posedge intf.clk);
        intf.drv_cb.mosi_data_i <= 0;
        intf.drv_cb.mosi_valid_i<= 0;
	      intf.drv_cb.miso_ready_i  <= 1'b1;
    endtask

    task dla_wdata_idle();
      @(posedge intf.clk);
        intf.drv_cb.mosi_data_i <= 0;
        intf.drv_cb.mosi_valid_i<= 0;
	      intf.drv_cb.miso_ready_i  <= 1'b1;
    endtask

  endclass: dla_driver
