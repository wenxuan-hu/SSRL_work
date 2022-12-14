  //sequence

// add event
//event begin_write;
//event begin_read;

  class dla_cmd_sequence extends uvm_sequence #(dla_trans);
    //rand bit reset;
    rand int ntrans;
    rand bit channel;

    constraint dla_trans_cst{
      soft ntrans==2;
    }

    `uvm_object_utils_begin(dla_cmd_sequence)
      `uvm_field_int(channel, UVM_ALL_ON)
      `uvm_field_int(ntrans, UVM_ALL_ON)
    `uvm_object_utils_end
    function new (string name = "dla_cmd_sequence");
      super.new(name);
    endfunction

    task body();
      //@mc_top_tb.begin_write;
      #400000;
      //repeat(ntrans) send_trans();
// ----------------------------------------------------
      send_trans('d256,2'd01);
      #1000;
      send_trans('d256,2'd10);


// ----------------------------------------------------
    endtask

    task send_trans();
      input [29:0] addr;
      input [1:0] we;
      dla_trans rsp;
      dla_trans req;
      `uvm_do_with(req,{local::channel >= 0 -> channel == local::channel;  req.address == addr ; req.we== we; })
      //`uvm_do(req)
      `uvm_info(get_type_name(), req.sprint(), UVM_HIGH)
      get_response(rsp);
      assert(rsp.rsp)
        else $error("[RSPERR] %0t error response received!", $time);
    endtask

    function void post_randomize();
      string s;
      s = {s, "AFTER RANDOMIZATION \n"};
      s = {s, "=======================================\n"};
      s = {s, "dla_cmd_sequence object content is as below: \n"};
      s = {s, super.sprint()};
      s = {s, "=======================================\n"};
      `uvm_info(get_type_name(), s, UVM_HIGH)
    endfunction
  endclass: dla_cmd_sequence
