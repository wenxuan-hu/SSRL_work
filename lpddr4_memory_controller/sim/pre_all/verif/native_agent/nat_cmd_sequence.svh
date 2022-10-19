  //sequence
  class nat_cmd_sequence extends uvm_sequence #(nat_trans);
    //rand bit reset;
    rand int ntrans;
    rand bit channel;

    constraint n_trans_cst{
      soft ntrans==2;
    }

    `uvm_object_utils_begin(nat_cmd_sequence)
      `uvm_field_int(channel, UVM_ALL_ON)
      `uvm_field_int(ntrans, UVM_ALL_ON)
    `uvm_object_utils_end
    function new (string name = "nat_cmd_sequence");
      super.new(name);
    endfunction

    task body();
      repeat(ntrans) send_trans();
    endtask

    task send_trans();
      nat_trans req, rsp;
      `uvm_do_with(req,{local::channel >= 0 -> channel == local::channel;})
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
      s = {s, "nat_cmd_sequence object content is as below: \n"};
      s = {s, super.sprint()};
      s = {s, "=======================================\n"};
      `uvm_info(get_type_name(), s, UVM_HIGH)
    endfunction
  endclass: nat_cmd_sequence