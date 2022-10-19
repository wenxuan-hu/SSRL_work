  class bank_machine_checker extends uvm_scoreboard;
    int error_count;
    int cmp_count;
    bit[2:0] bank_ad;
    local virtual litedram_cmd_interface ld_vif;
    local virtual cmd_rw_interface cmd_vif;
    uvm_tlm_analysis_fifo #(req_t) in_tlm_fifo;
    uvm_tlm_analysis_fifo #(req_t) out_tlm_fifo;

    uvm_tlm_analysis_fifo #(data_t) in_tlm_fifo_wdata;
    uvm_tlm_analysis_fifo #(data_t) out_tlm_fifo_wdata;

    uvm_tlm_analysis_fifo #(data_t) in_tlm_fifo_rdata;
    uvm_tlm_analysis_fifo #(data_t) out_tlm_fifo_rdata;

    `uvm_component_utils(bank_machine_checker)

    function new (string name = "bank_machine_checker", uvm_component parent);
      super.new(name, parent);
      in_tlm_fifo = new("in_tlm_fifo", this);
      out_tlm_fifo = new("out_tlm_fifo", this);
      in_tlm_fifo_wdata = new("in_tlm_fifo_wdata", this);
      out_tlm_fifo_wdata = new("out_tlm_fifo_wdata", this);
      in_tlm_fifo_rdata = new("in_tlm_fifo_rdata", this);
      out_tlm_fifo_rdata = new("out_tlm_fifo_rdata", this);
      this.error_count = 0;
      this.cmp_count = 0;
    endfunction

    function void set_interface(virtual cmd_rw_interface cmd_vif, virtual litedram_cmd_interface ld_vif);
      if(cmd_vif == null)
        $error("cmd_rw interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.cmd_vif = cmd_vif;
      end

      if(ld_vif == null)
        $error("litedram cmd interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.ld_vif = ld_vif;
      end
    endfunction

    task run_phase(uvm_phase phase);
      fork
        this.do_cmd_compare();
        this.do_wdata_compare();
        this.do_rdata_compare();
      join
    endtask

    task do_wdata_compare();
      data_t im_w;
      data_t om_w;
      
      forever begin
        out_tlm_fifo_wdata.get(om_w);
        in_tlm_fifo_wdata.get(im_w);
        if(om_w.we!= im_w.we) begin
          this.error_count++;
          `uvm_error("WDATA CMPFAIL", $sformatf("Compared failed! write data valid=[%d] is not equal with [%d]", im_w.we,om_w.we))
        end
        else begin
          `uvm_info("WDATA CMPSUCD", $sformatf("Compared Success! write data valid=[%d] is equal", im_w.we), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask

    task do_rdata_compare();
      data_t im_r;
      data_t om_r;
      
      forever begin
        out_tlm_fifo_rdata.get(om_r);
        in_tlm_fifo_rdata.get(im_r);
        if(om_r.we!= im_r.we) begin
          this.error_count++;
          `uvm_error("RDATA CMPFAIL", $sformatf("Compared failed! read data ready=[%d] is not equal with [%d]", im_r.we,om_r.we))
        end
        else begin
          `uvm_info("RDATA CMPSUCD", $sformatf("Compared Success! read data ready=[%d] is equal", im_r.we), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask

    task do_cmd_compare();
      req_t im;
      req_t om;
      
      forever begin
        out_tlm_fifo.get(om);
        in_tlm_fifo.get(im);
        if(((om.we!= im.we) ||(om.mw!= im.mw))|| (om.address != im.address) ) begin
          this.error_count++;
          `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! bank_machine out [we,mw,address]=[%d,%d,%0h,%0h] is not equal with [%d,%d,%0h,%0h]", im.we,im.mw,im.address[22:6],im.address[5:0], om.we,om.mw,om.address[22:6],om.address[5:0]))
        end
        else begin
          `uvm_info("CMD CMPSUCD", $sformatf("Compared success! bank_machine out [we,mw,address]=[%d,%d,%0h,%0h] is equal with input", im.we,im.mw,im.address[22:6],im.address[5:0]), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask
  endclass: bank_machine_checker
