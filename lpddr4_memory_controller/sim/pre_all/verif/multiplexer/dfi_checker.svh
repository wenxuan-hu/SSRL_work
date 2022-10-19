  class dfi_checker extends uvm_scoreboard;
    int error_count;
    int cmp_count;
    bit[2:0] bank_ad;
    local virtual dfi_interface dfi_vif;
    local virtual cmd_rw_interface bm_vifs[8];
    uvm_tlm_analysis_fifo #(cmd_t) in_tlm_fifos[8];
    uvm_tlm_analysis_fifo #(cmd_t) in_tlm_fifo_refresher;
    uvm_tlm_analysis_fifo #(dfi_cmd_t) out_tlm_fifo;

    `uvm_component_utils(dfi_checker)

    function new (string name = "dfi_checker", uvm_component parent);
      super.new(name, parent);
      foreach(in_tlm_fifos[i]) in_tlm_fifos[i] = new($sformatf("in_tlm_fifos[%0d]", i), this);
      in_tlm_fifo_refresher= new("in_tlm_fifo_refresher", this);
      out_tlm_fifo = new("out_tlm_fifo", this);
      this.error_count = 0;
      this.cmp_count = 0;
    endfunction

    function void set_interface(virtual dfi_interface dfi_vif, virtual cmd_rw_interface bm_vifs[8]);
      if(dfi_vif == null)
        $error("dfi interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dfi_vif = dfi_vif;
      end

      foreach(bm_vifs[i]) begin
        if(bm_vifs[i] == null)
          $error("cmd interface handle is NULL, please check if target interface has been intantiated");
        else begin
          this.bm_vifs[i] = bm_vifs[i];
      end
      end
    endfunction

    task run_phase(uvm_phase phase);
      this.do_data_compare();
    endtask

    task do_data_compare();
      cmd_t im;
      dfi_cmd_t om;
      forever begin
        out_tlm_fifo.get(om);
        if((om.cmd==PRECHARGE_ALL)||(om.cmd==REFRESH_ALL)) begin
          in_tlm_fifo_refresher.get(im);
        end else begin
          case(om.bank)
            0: begin in_tlm_fifos[0].get(im); this.bank_ad=0; end
            1: begin in_tlm_fifos[1].get(im); this.bank_ad=1; end
            2: begin in_tlm_fifos[2].get(im); this.bank_ad=2; end
            3: begin in_tlm_fifos[3].get(im); this.bank_ad=3; end
            4: begin in_tlm_fifos[4].get(im); this.bank_ad=4; end
            5: begin in_tlm_fifos[5].get(im); this.bank_ad=5; end
            6: begin in_tlm_fifos[6].get(im); this.bank_ad=6; end
            7: begin in_tlm_fifos[7].get(im); this.bank_ad=7; end
            default: `uvm_fatal(get_type_name(), $sformatf("bank %0d is not available", om.bank))
          endcase
        end
        if((om.cmd != im.cmd) || (om.address != im.address) ) begin
          this.error_count++;
          `uvm_error("CMPFAIL", $sformatf("Compared failed! multiplexer out DFI cmd %s at bank %0d at address %h is not equal with bankmachine %d in cmd %s at address %h", DDR_CMD[om.cmd], om.bank, om.address,this.bank_ad,DDR_CMD[im.cmd],im.address))
        end
        else begin
          `uvm_info("CMPSUCD", $sformatf("Compared Success! multiplexer out DFI cmd %s at bank %0d at address %h is transmitted correctly!", DDR_CMD[om.cmd], om.bank, om.address), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask
  endclass: dfi_checker