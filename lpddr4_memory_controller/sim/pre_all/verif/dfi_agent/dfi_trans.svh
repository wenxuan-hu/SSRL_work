// dfi random sequence item
  class dfi_trans extends uvm_sequence_item;
    //rand bit reset;
    rand ddr_cmd_t cmd;
    rand bit[17:0] address;
    rand bit[2:0] bank;
    rand int idle_n =1;
    rand bit[1:0] phase;
    bit rsp;

    //constraint rst{reset==1;}
    //positive access time
    constraint col_cmd_num_cst{
      cmd>=0;
      cmd<12;
    }

    constraint idle_n_cst{
      idle_n>0;
      idle_n<8;
    }

    `uvm_object_utils_begin(dfi_trans)
      `uvm_field_enum(ddr_cmd_t,cmd, UVM_ALL_ON)
      `uvm_field_int(address, UVM_ALL_ON)
      `uvm_field_int(phase, UVM_ALL_ON)
      `uvm_field_int(bank, UVM_ALL_ON)
      `uvm_field_int(idle_n, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "dfi_trans");
      super.new(name);
    endfunction
  endclass: dfi_trans