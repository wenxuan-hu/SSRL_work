// Bankmachine responder
  class bm_responder extends uvm_driver;
    virtual cmd_rw_interface intf;
    `uvm_component_utils(bm_responder)
  
    function new (string name = "bm_responder", uvm_component parent);
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
        this.do_reset();
        this.generate_ready();
      join
    endtask

    task do_reset();
      forever begin
        @(posedge intf.rst);
        intf.cmd_ready <= 1'b0;
      end
    endtask


    task generate_ready();
      forever begin
        while(intf.rsp_ck.cmd_valid===1'b0) @(intf.rsp_ck);
        repeat($urandom_range(2,8)) @(intf.rsp_ck);
        @(intf.rsp_ck);
        intf.rsp_ck.cmd_ready<=1'b1;
        @(intf.rsp_ck);
        intf.rsp_ck.cmd_ready<=1'b0;
      end
    endtask
  endclass: bm_responder