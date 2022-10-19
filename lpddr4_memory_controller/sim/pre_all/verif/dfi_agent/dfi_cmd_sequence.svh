  class dfi_cmd_sequence extends uvm_sequence #(dfi_trans);
    rand int ntrans = 1;
    `uvm_object_utils_begin(dfi_cmd_sequence)
      `uvm_field_int(ntrans, UVM_ALL_ON)
    `uvm_object_utils_end
    function new (string name = "dfi_cmd_sequence");
      super.new(name);
    endfunction

    task body();
      repeat(ntrans) send_trans();
    endtask

    task send_trans();
      dfi_trans req, rsp;
      `uvm_do(req)
      `uvm_info(get_type_name(), req.sprint(), UVM_HIGH)
      get_response(rsp);
      //`uvm_info(get_type_name(), rsp.sprint(), UVM_HIGH)
      assert(rsp.rsp)
        else $error("[RSPERR] %0t error response received!", $time);
    endtask

    function void post_randomize();
      string s;
      s = {s, "AFTER RANDOMIZATION \n"};
      s = {s, "=======================================\n"};
      s = {s, "dfi_cmd_sequence object content is as below: \n"};
      s = {s, super.sprint()};
      s = {s, "=======================================\n"};
      //`uvm_info(get_type_name(), s, UVM_HIGH)
    endfunction
  endclass: dfi_cmd_sequence