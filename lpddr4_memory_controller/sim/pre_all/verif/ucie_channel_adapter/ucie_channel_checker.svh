  class ucie_channel_checker extends uvm_scoreboard;
    int error_count;
    int cmp_count;
    local virtual rdi_mb_interface rdi_mb_vif;

    uvm_tlm_analysis_fifo #(rdi_data_t) in_tlm_fifo_wdata;
    uvm_tlm_analysis_fifo #(rdi_data_t) in_tlm_fifo_rdata;

    `uvm_component_utils(ucie_channel_checker)

    function new (string name = "ucie_channel_checker", uvm_component parent);
      super.new(name, parent);
      in_tlm_fifo_wdata = new("in_tlm_fifo_wdata", this);
      in_tlm_fifo_rdata = new("in_tlm_fifo_rdata", this);
      this.error_count = 0;
      this.cmp_count = 0;
    endfunction

    function void set_interface(virtual rdi_mb_interface rdi_mb_vif);
      if(rdi_mb_vif == null)
        $error("rdi_mb interface handle is NULL, please check if target interface has been intantiated");
      else begin
        this.rdi_mb_vif = rdi_mb_vif;
      end
    endfunction

    task run_phase(uvm_phase phase);
      fork
        this.do_data_compare();
      join
    endtask

    task do_data_compare();
      rdi_data_t im;
      rdi_data_t om;
      
      forever begin
        in_tlm_fifo_wdata.get(im);
        in_tlm_fifo_rdata.get(om);
        if(om.data!= im.data) begin
          this.error_count++;
          `uvm_error("DATA CMPFAIL", $sformatf("Compared failed! egress data [0x%0h] is not equal with igress data[0x%0h]", om.data,im.data))
        end
        else begin
          `uvm_info("DATA CMPSUCD", $sformatf("Compared Success! Data [0x%0h] is equal", om.data), UVM_HIGH)
        end
        this.cmp_count++;
      end
    endtask
  endclass: ucie_channel_checker
