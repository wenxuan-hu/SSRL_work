//  sequence item
  class rdi_mb_trans extends uvm_sequence_item;
    //rand bit reset;
    rand bit [383:0] data;
    rand int n_idles;
    bit rsp;

    constraint idle_cst{
      n_idles<5;
    }


    `uvm_object_utils_begin(rdi_mb_trans)
      `uvm_field_int(data, UVM_ALL_ON)
      `uvm_field_int(n_idles, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "rdi_mb_trans");
      super.new(name);
    endfunction
  endclass: rdi_mb_trans