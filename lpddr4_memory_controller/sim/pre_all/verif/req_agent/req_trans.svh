// litedram cmd sequence item
  class req_trans extends uvm_sequence_item;
    //rand bit reset;
    rand bit[2:0] bank_address;
    rand bit[16:0] row_address;
    rand bit[5:0] col_address[];
    rand bit we[];//read or write
    rand bit mw[];

    rand int idle_n =1;
    bit rsp;

    constraint ba_cst{
      soft bank_address == 0;
    };

    constraint idle_n_cst{
      idle_n>0;
      idle_n<8;
    }

    //constraint rst{reset==1;}
    constraint col_cmd_num_cst{
      col_address.size>0;
      col_address.size<8;
    }
    
    constraint col_address_size_cst{
      we.size==(col_address.size);
      mw.size==(col_address.size);
    }

    constraint mw_cst{
      foreach(we[i]){
        if(we[i]==0){
          mw[i]==0;
        }
      }
    }

    `uvm_object_utils_begin(req_trans)
      `uvm_field_int(row_address, UVM_ALL_ON)
      `uvm_field_int(bank_address, UVM_ALL_ON)
      `uvm_field_array_int(col_address, UVM_ALL_ON)
      `uvm_field_array_int(we, UVM_ALL_ON)
      `uvm_field_array_int(mw, UVM_ALL_ON)
      `uvm_field_int(idle_n, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "req_trans");
      super.new(name);
    endfunction
  endclass: req_trans