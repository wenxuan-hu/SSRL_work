  class DFIAdapter_checker extends uvm_scoreboard;
    int error_count;
    int cmp_count;
    local virtual dfi_interface dfi_vif;
    local virtual dfi_lpddr4_interface dfi_lpddr4_vif;
    uvm_tlm_analysis_fifo #(dfi_cmd_t) in_tlm_fifo;
    uvm_tlm_analysis_fifo #(dfi_cmd_t) out_tlm_fifo;

    `uvm_component_utils(DFIAdapter_checker)

    function new (string name = "DFIAdapter_checker", uvm_component parent);
      super.new(name, parent);
      in_tlm_fifo = new("in_tlm_fifo", this);
      out_tlm_fifo = new("out_tlm_fifo", this);
      this.error_count = 0;
      this.cmp_count = 0;
    endfunction

    function void set_interface(virtual dfi_interface dfi_vif, virtual dfi_lpddr4_interface dfi_lpddr4_vif);
      if(dfi_vif == null)
        $error("dfi interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dfi_vif = dfi_vif;
      end

      if(dfi_lpddr4_vif == null)
        $error("dfi_lpddr4 interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.dfi_lpddr4_vif = dfi_lpddr4_vif;
      end
    endfunction

    task run_phase(uvm_phase phase);
      this.do_cmd_compare();
    endtask

    task do_cmd_compare();
      dfi_cmd_t im;
      dfi_cmd_t om;
      
      forever begin
        out_tlm_fifo.get(om);
        in_tlm_fifo.get(im);
        if(om.cmd!= im.cmd) begin
          this.error_count++;
          `uvm_error("CMD CMPFAIL", $sformatf("Compared failed! DFIAdapter out [cmd]=[%s] is not equal with [%s]", DDR_CMD[om.cmd],DDR_CMD[im.cmd]))
        end
        else begin
          case(om.cmd) 
            COL_READ, COL_READ_AP, COL_WRITE, COL_WRITE_AP, MASKED_WRITE,MASKED_WRITE_AP: begin
              if(om.address[9:0]!= im.address[9:0]) `uvm_error("CMD CMPFAIL", $sformatf("Compared Address failed! DFIAdapter out CMD %s, col 0x%0h, is not equal with 0x%0h", DDR_CMD[om.cmd],om.address[9:0],im.address[9:0]))
              if(om.bank!= im.bank) `uvm_error("CMD CMPFAIL", $sformatf("Compared Bank failed! DFIAdapter out CMD %s, bank %0d, is not equal with %0d", DDR_CMD[om.cmd],om.bank,im.bank))
            end
            PRECHARGE:begin
              if(om.bank!= im.bank) `uvm_error("CMD CMPFAIL", $sformatf("Compared Bank failed! DFIAdapter out CMD %s, bank %0d, is not equal with %0d", DDR_CMD[om.cmd],om.bank,im.bank))
            end
            ACTIVATE: begin
              if(om.address!= im.address) `uvm_error("CMD CMPFAIL", $sformatf("Compared Address failed! DFIAdapter out CMD %s, row 0x%0h, is not equal with 0x%0h", DDR_CMD[om.cmd],om.address,im.address))
              if(om.bank!= im.bank) `uvm_error("CMD CMPFAIL", $sformatf("Compared Bank failed! DFIAdapter out CMD %s, bank %0d, is not equal with %0d", DDR_CMD[om.cmd],om.bank,im.bank))
            end
            default:begin
            end
          endcase
          `uvm_info("CMD CMPSUCD", $sformatf("Compared success! DFIAdapter out [cmd,address]=[%s,%0h] is equal with input", DDR_CMD[om.cmd],om.address), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask
  endclass: DFIAdapter_checker
