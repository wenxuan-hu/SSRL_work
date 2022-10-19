// dfi lpddr4_responder
  class dfi_lpddr4_responder extends uvm_driver;
    dram_memory_space dram_memory[$];
    virtual dfi_lpddr4_interface intf;
    uvm_tlm_analysis_fifo #(dfi_cmd_t) data_request_port;
    //uvm_nonblocking_get_port #(dfi_cmd_t) data_request_port;
    bit rd_output_en=0;
    bit rd_output_dly=0;
    bit rd_channel=0;
    bit rd_channel_dly=0;
    bit output_dly_line[16]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    bit channel_dly_line[16]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

    `uvm_component_utils(dfi_lpddr4_responder)
  
    function new (string name = "dfi_lpddr4_responder", uvm_component parent);
      super.new(name, parent);
      data_request_port=new("data_request_port", this);
    endfunction

    function void set_interface(virtual dfi_lpddr4_interface intf);
      if(intf == null)
        `uvm_error("GETVIF","dfi_lpddr4_interface interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      fork
        //this.monitor_rd_en();
        this.response();
        this.do_rdata();
        this.do_reset();
      join
    endtask

    task do_rdata();
      dfi_cmd_t req;
      forever begin
        @(posedge intf.clk);
        //implement read latency
        output_dly_line[0]<=rd_output_en|rd_output_dly;
        channel_dly_line[0]<=rd_channel|rd_channel_dly;
        for(int i=1;i<15;i++) begin
          output_dly_line[i]<=output_dly_line[i-1];
          channel_dly_line[i]<=channel_dly_line[i-1];
        end
        if(output_dly_line[8]==1) begin
          this.do_output_data(channel_dly_line[8]);
        end else begin
          this.dfi_idle();
        end
      end
    endtask

    task response();
      dfi_cmd_t req;
      forever begin
        @(posedge intf.clk);
        if(data_request_port.try_get(req)) begin
          `uvm_info("RDATA RESPONSE GENERATED", "GENERATE RDATA NOW", UVM_HIGH)
          this.rd_output_en<=1;
          this.rd_output_dly<=this.rd_output_en;
          this.rd_channel<=req.row[16];
          this.rd_channel_dly<=this.rd_channel;
        end
        else begin
          this.rd_output_en<=0;
          this.rd_output_dly<=this.rd_output_en;
          this.rd_channel<=0; 
          this.rd_channel_dly<=this.rd_channel;
        end
      end
    endtask

    task monitor_rd_en();
      forever begin
        @(posedge intf.clk);
        this.rd_output_en<=(intf.dfi_phase0_lpddr4_if.rddata_en|intf.dfi_phase1_lpddr4_if.rddata_en|intf.dfi_phase2_lpddr4_if.rddata_en|intf.dfi_phase3_lpddr4_if.rddata_en);
      end
    endtask

    task do_reset();
      forever begin
        @(posedge intf.rst);
        intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata<='d0;
	      intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata_valid<='d0;

        intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata<='d0;
	      intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata_valid<='d0;

        intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata<='d0;
	      intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata_valid<='d0;

        intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata<='d0;
	      intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata_valid<='d0;
      end
    endtask

    task write_data(bit row_address, bit col_address, bit bank,bit data);
      bit existed=0;
      foreach(dram_memory[i]) begin
        if((dram_memory[i].row==row_address)&&(dram_memory[i].col==col_address)&&(dram_memory[i].bank==bank)) begin
          dram_memory[i].data=data;
          existed=1;
          break;
        end
      end
      
      if(existed==0) begin
        dram_memory_space mem;
        mem.row=row_address;
        mem.col=col_address;
        mem.data=data;
        dram_memory.push_back(mem);
      end

      `uvm_info(get_type_name(), $sformatf("Write data %0h to Memory Space [Bank,Row,Col]=[%0d,0x%0h,0x%0h0]",data,bank,row_address,col_address), UVM_HIGH)
    endtask

    task read_data(bit row_address, bit col_address,bit bank, bit data);
      bit existed=0;
      foreach(dram_memory[i]) begin
        if((dram_memory[i].row==row_address)&&(dram_memory[i].col==col_address)&&(dram_memory[i].bank==bank)) begin
          data=dram_memory[i].data;
          existed=1;
          break;
        end
      end
      
      if(existed==0) begin
        data=0;
        `uvm_info(get_type_name(), $sformatf("Target Memory Space is not initialized. [Bank,Row,Col]=[%0d,0x%0h,0x%0h0]",bank,row_address,col_address), UVM_HIGH)
      end

      `uvm_info(get_type_name(), $sformatf("Read data %0h from Memory Space [Bank,Row,Col]=[%0d,0x%0h,0x%0h0]",data,bank,row_address,col_address), UVM_HIGH)
    endtask

    task do_output_data(bit channel);
      data_t t;
      //dla_data_t t;
      t.data=$urandom;
      t.data[0]=channel;
      @(intf.dfi_phase0_lpddr4_if.sdrv_ck);
        intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata<=t.data[63:0];
        intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata_valid<=1'b1;
      t.data=$urandom;
        intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata<=t.data[63:0];
        intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata_valid<=1'b1;
      t.data=$urandom;
        intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata<=t.data[63:0];
        intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata_valid<=1'b1;
      t.data=$urandom;
        intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata<=t.data[63:0];
        intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata_valid<=1'b1;
    endtask

    task dfi_receive_data();
    endtask
    
    task dfi_idle();
      @(intf.dfi_phase0_lpddr4_if.sdrv_ck);
	    intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata<='d0;
	    intf.dfi_phase0_lpddr4_if.sdrv_ck.rddata_valid<='d0;

      intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata<='d0;
	    intf.dfi_phase1_lpddr4_if.sdrv_ck.rddata_valid<='d0;

      intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata<='d0;
	    intf.dfi_phase2_lpddr4_if.sdrv_ck.rddata_valid<='d0;

      intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata<='d0;
	    intf.dfi_phase3_lpddr4_if.sdrv_ck.rddata_valid<='d0;
    endtask
  endclass: dfi_lpddr4_responder
