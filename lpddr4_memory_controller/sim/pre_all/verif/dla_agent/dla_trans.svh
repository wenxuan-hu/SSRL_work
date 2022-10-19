//  sequence item
  class dla_trans extends uvm_sequence_item;
    //rand bit reset;
    rand bit [29:0] address;
    //rand bit [256*32-1:0] dla_data;
    rand bit [255:0] dla_data[31:0];
    //rand bit  dla_data[4:0][255:0];
    rand bit [7:0] length;
    rand bit [1:0]  we;//read or write
    rand bit channel;
    bit rsp;


    constraint ba_cst{
      soft channel == 0;
    };


    constraint we_cst{
      we  > 2'b00;
      we  < 2'b11;
    }

    constraint addr_cst{
      address  > 'd0;
      address  < 'd100;
    }

    constraint data_cst{
      foreach(dla_data[beat]){
        dla_data[beat][255] ==  1'b1;
        dla_data[beat][254] ==  channel;
        }
    }

    constraint len_cst{
      length  == 'd32;
    }

    `uvm_object_utils_begin(dla_trans)
      `uvm_field_int(address, UVM_ALL_ON)
      //`uvm_field_int(dla_data, UVM_ALL_ON)
      `uvm_field_sarray_int(dla_data, UVM_ALL_ON)
      `uvm_field_int(we, UVM_ALL_ON)
      `uvm_field_int(channel, UVM_ALL_ON)
      `uvm_field_int(length, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "dla_trans");
      super.new(name);
    endfunction
  endclass: dla_trans
