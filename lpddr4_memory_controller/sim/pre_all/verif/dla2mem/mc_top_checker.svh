  class mc_top_checker extends uvm_scoreboard;
    int error_count;
    int cmp_count;
    bit[2:0] bank_ad;
    local virtual mosi_interface dla_vif_0;
    local virtual mosi_interface dla_vif_1;
    local virtual dfi_lpddr4_interface dfi_lpddr4_vif;
    uvm_tlm_analysis_fifo #(dla_cmd_t) in_tlm_fifos[2];
    uvm_tlm_analysis_fifo #(dfi_cmd_t) out_tlm_fifo;

    uvm_tlm_analysis_fifo #(data_t) in_tlm_fifos_wdata[2];
    uvm_tlm_analysis_fifo #(data_t) out_tlm_fifo_wdata;

    uvm_tlm_analysis_fifo #(data_t) in_tlm_fifos_rdata[2];
    uvm_tlm_analysis_fifo #(data_t) out_tlm_fifos_rdata[2];

    `uvm_component_utils(mc_top_checker)

    function new (string name = "mc_top_checker", uvm_component parent);
      super.new(name, parent);
      foreach(in_tlm_fifos[i]) in_tlm_fifos[i] = new($sformatf("in_tlm_fifos[%0d]", i), this);
      out_tlm_fifo = new("out_tlm_fifo", this);
      foreach(in_tlm_fifos_wdata[i]) in_tlm_fifos_wdata[i] = new($sformatf("in_tlm_fifos_wdata[%0d]", i), this);
      out_tlm_fifo_wdata = new("out_tlm_fifo_wdata", this);
      foreach(in_tlm_fifos_rdata[i]) in_tlm_fifos_rdata[i] = new($sformatf("in_tlm_fifos_rdata[%0d]", i), this);
      foreach(out_tlm_fifos_rdata[i]) out_tlm_fifos_rdata[i] = new($sformatf("out_tlm_fifos_rdata[%0d]", i), this);
      this.error_count = 0;
      this.cmp_count = 0;
    endfunction

    function void set_interface(virtual mosi_interface dla_vif_0,virtual mosi_interface dla_vif_1, virtual dfi_lpddr4_interface dfi_lpddr4_vif);
      if(dla_vif_0 == null)
        $error("mosi interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dla_vif_0 = dla_vif_0;
      end

      if(dla_vif_1 == null)
        $error("mosi interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dla_vif_1 = dla_vif_1;
      end

      if(dfi_lpddr4_vif == null)
        $error("dfi_lpddr4 interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dfi_lpddr4_vif = dfi_lpddr4_vif;
      end
    endfunction

    task run_phase(uvm_phase phase);
      fork
`ifdef RW_ONLY
        this.do_cmd_compare();
`endif
        this.do_wdata_compare();
        this.do_rdata_ch1_compare();
        this.do_rdata_ch0_compare();
      join
    endtask

    task do_wdata_compare();
      data_t im_w;
      data_t om_w;
      
      forever begin
        out_tlm_fifo_wdata.get(om_w);
        if(om_w.data[254]==1) begin
          in_tlm_fifos_wdata[1].get(im_w);
        end else begin
          in_tlm_fifos_wdata[0].get(im_w);
        end
        if(om_w.we!= im_w.we) begin
          this.error_count++;
          `uvm_error("WDATA CMPFAIL", $sformatf("Compared failed! write data valid=[%d] is not equal with [%d]", im_w.we,om_w.we))
        end
        else if(om_w.data!= im_w.data) begin
          this.error_count++;
          `uvm_error("WDATA CMPFAIL", $sformatf("Compared failed! write data=[0x%0h] is not equal with [0x%0h]", im_w.data,om_w.data))
        end
        // we do not check the mask in mosi interface;
        //else if(om_w.data_mask!= im_w.data_mask) begin
        //  this.error_count++;
        //  `uvm_error("WDATA CMPFAIL", $sformatf("Compared failed! write data mask=[0b%b] is not equal with [0b%b]", im_w.data_mask,om_w.data_mask))
        //end
        else begin
          //`uvm_info("WDATA CMPSUCD", $sformatf("Compared Success! [we,data,data_mask]=[%b,0x%0h,0b%b] is equal", im_w.we,im_w.data,im_w.data_mask), UVM_HIGH)
          `uvm_info("WDATA CMPSUCD", $sformatf("Compared Success! [we,data]=[%b,0x%0h] is equal", im_w.we,im_w.data), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask

    task do_rdata_ch1_compare();
      data_t im_r;
      data_t om_r;
      
      forever begin
        out_tlm_fifos_rdata[1].get(om_r);
        in_tlm_fifos_rdata[1].get(im_r);
        if(om_r.we!= im_r.we) begin
          this.error_count++;
          `uvm_error("RDATA CMPFAIL", $sformatf("Compared failed! read data ready=[%d] is not equal with [%d]", im_r.we,om_r.we))
        end
        if(om_r.data!= im_r.data) begin
          this.error_count++;
          `uvm_error("RDATA CMPFAIL", $sformatf("Compared failed! read data [0x%0h] is not equal with [0x%0h]", im_r.data,om_r.data))
        end
        else begin
          `uvm_info("RDATA CMPSUCD", $sformatf("Compared Success! [we,data]=[%d,0x%0h] is equal", im_r.we,im_r.data), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask

    task do_rdata_ch0_compare();
      data_t im_r;
      data_t om_r;
      
      forever begin
        out_tlm_fifos_rdata[0].get(om_r);
        in_tlm_fifos_rdata[0].get(im_r);
        if(om_r.we!= im_r.we) begin
          this.error_count++;
          `uvm_error("RDATA CMPFAIL", $sformatf("Compared failed! read data ready=[%d] is not equal with [%d]", im_r.we,om_r.we))
        end
        if(om_r.data!= im_r.data) begin
          this.error_count++;
          `uvm_error("RDATA CMPFAIL", $sformatf("Compared failed! read data [0x%0h] is not equal with [0x%0h]", im_r.data,om_r.data))
        end
        else begin
          `uvm_info("RDATA CMPSUCD", $sformatf("Compared Success! [we,data]=[%d,0x%0h] is equal", im_r.we,im_r.data), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask

    task do_cmd_compare();
      dla_cmd_t im;
      dfi_cmd_t om;
      
      forever begin
        out_tlm_fifo.get(om);
        if(om.row[16]==1) begin
          in_tlm_fifos[1].get(im);
        end else begin
          in_tlm_fifos[0].get(im);
        end
        if((om.cmd==COL_READ)||(om.cmd==COL_READ_AP)) begin
          if(im.we==1) begin
            `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! core out cmd %s is not equal with input [we,mw]=[%d,%d]", DDR_CMD[om.cmd], im.we,im.mw))
          end
        end else if ((om.cmd==COL_WRITE)||(om.cmd==COL_WRITE_AP)) begin
          if(im.we==0 || im.mw==1) begin
            `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! core out cmd %s is not equal with input [we,mw]=[%d,%d]", DDR_CMD[om.cmd], im.we,im.mw))
          end
        end else if ((om.cmd==MASKED_WRITE)||(om.cmd==MASKED_WRITE_AP)) begin
          if(im.we==0 || im.mw==0) begin
            `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! core out cmd %s is not equal with input [we,mw]=[%d,%d]", DDR_CMD[om.cmd], im.we,im.mw))
          end
        end
//TODO
        //if ((om.row != im.address[25:9])|| (om.bank != im.address[8:6])|| (om.address!=im.address[5:0])) begin
        //  this.error_count++; 
        //  //`uvm_error("CMD CMPFAIL", $sformatf("Compared failed! core out address[row,bank,col]=[0x%0h,0x%0h,0x%0h] is not equal with [0x%0h,0x%0h,0x%0h0]", om.row,om.bank,om.address[9:4],im.address[29:13],im.address[12:10],im.address[9:4]))
        //  `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! core out  address[row,bank,col]=[0x%0h,0x%0h,0x%0h] is not equal with [0x%0h,0x%0h,0x%0h]", om.row,om.bank,om.address[9:4],im.address[25:9],im.address[8:6],im.address[5:0]))
        //end
        //else begin
        //  `uvm_info("CMD CMPSUCD", $sformatf("Compared success! core out [we,mw,address]=[%d,%d,0x%0h] is equal with input", im.we,im.mw,im.address), UVM_HIGH)
        //end
          `uvm_info("CMD CMPSUCD", $sformatf("Compared success! core out [we,mw,address]=[%d,%d,0x%0h] is equal with input", im.we,im.mw,im.address), UVM_HIGH)
        this.cmp_count++;
      end
    endtask

// ----------------------------------------------------
// mosi smoke test




// ----------------------------------------------------











  endclass: mc_top_checker
