// bankmachine sequence item
  class bm_trans extends uvm_sequence_item;
    //rand bit reset;
    rand bit[2:0] bank_address;
    rand bit[16:0] row_address;
    rand bit[5:0] col_address[];
    rand bit we[];//read or write
    rand bit with_autoprecharge;
    //bit[2:0] bank_address[];
    
    rand bit cas[];
    rand bit ras[];
    rand bit is_cmd[];
    rand bit is_write[];
    rand bit is_read[];
    rand bit is_mw[];
    bit rsp;

    constraint ba_cst{
      soft bank_address == 0;
    };

    //constraint rst{reset==1;}
    //positive access time
    constraint col_cmd_num_cst{
      col_address.size()>0;
      col_address.size()<8;
    }

    //one col_address/rw one access
    
    constraint col_address_size_cst{
      cas.size()==(col_address.size()+2);
      ras.size()==(col_address.size()+2);
      we.size()==(col_address.size()+2);
      is_cmd.size()==(col_address.size()+2);
      is_write.size()==(col_address.size()+2);
      is_read.size()==(col_address.size()+2);
      is_mw.size()==(col_address.size()+2);
    }
    
    constraint bm_cmd_cst{
      //precharge
      cas[0]==0;
      ras[0]==1;
      we[0]==1;
      //activate;
      cas[1]==0;
      ras[1]==1;
      we[1]==0;
      //rw
      foreach(cas[i]){
        if(i>=2){
          cas[i]==1;
          ras[i]==0;
        }
      }
    }

    constraint bm_is_cmd_cst{
      foreach(cas[i]){
        if((cas[i]==0) && (ras[i]==1)){
          is_cmd[i]==1;
          is_read[i]==0;
          is_write[i]==0;
          is_mw[i]==0;
        }
        else {
          is_cmd[i]==0;
          if((cas[i]==1) &&(ras[i]==0)){
            if(we[i]==1) {
              is_write[i]==1;
              is_read[i]==0;
            }
            else {
              is_read[i]==1;
              is_write[i]==0;
              is_mw[i]==0;
            }
          }
          else{
            is_read[i]==0;
            is_write[i]==0;
            is_mw[i]==0;
          }
        }
      }
    }

    `uvm_object_utils_begin(bm_trans)
      `uvm_field_int(row_address, UVM_ALL_ON)
      `uvm_field_int(bank_address, UVM_ALL_ON)
      `uvm_field_int(with_autoprecharge, UVM_ALL_ON)
      `uvm_field_array_int(col_address, UVM_ALL_ON)
      `uvm_field_array_int(cas, UVM_ALL_ON)
      `uvm_field_array_int(ras, UVM_ALL_ON)
      `uvm_field_array_int(we, UVM_ALL_ON)
      `uvm_field_array_int(is_cmd, UVM_ALL_ON)
      `uvm_field_array_int(is_write, UVM_ALL_ON)
      `uvm_field_array_int(is_read, UVM_ALL_ON)
      `uvm_field_array_int(is_mw, UVM_ALL_ON)
      //`uvm_field_int(reset, UVM_ALL_ON)
      `uvm_field_int(rsp, UVM_ALL_ON)
    `uvm_object_utils_end

    function new (string name = "bm_trans");
      super.new(name);
    endfunction
  endclass: bm_trans