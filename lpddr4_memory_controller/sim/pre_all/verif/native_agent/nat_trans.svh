//  sequence item
  class nat_trans extends uvm_sequence_item;
    //rand bit reset;
    rand bit channel;
    rand bit [24:0] address;
    rand bit [511:0] data;
    rand bit [63:0] data_mask;
    rand bit we;//read or write
    rand bit mw;
    rand int n_idles;
    bit rsp;

    constraint ba_cst{
      soft channel == 0;
    };

    //one col_address/rw one access

    constraint mw_cst{
      if(we==0){
        mw==0;
      } 
    }

    //constraint we_cst{we==1;}
    
    constraint data_mask_cst{
      if(we==1 && mw==0){
        data_mask==64'h0;
      } else if(we==1){
        data_mask!=64'hffffffffffffffff;
      }
    }

    constraint channel_cst{
      data[0]==channel;
      data[256]==channel;
    }

    constraint idle_cst{
      n_idles>0;
      n_idles<5;
    }


    `uvm_object_utils_begin(nat_trans)
      `uvm_field_int(address, UVM_ALL_ON)
      `uvm_field_int(channel, UVM_ALL_ON)
      `uvm_field_int(data, UVM_ALL_ON)
      `uvm_field_int(data_mask, UVM_ALL_ON)
      `uvm_field_int(we, UVM_ALL_ON)
      `uvm_field_int(mw, UVM_ALL_ON)
      `uvm_field_int(n_idles, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "nat_trans");
      super.new(name);
    endfunction
  endclass: nat_trans