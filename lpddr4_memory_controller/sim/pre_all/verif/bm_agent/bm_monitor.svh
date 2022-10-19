  class bm_monitor extends uvm_monitor;
    virtual cmd_rw_interface intf;
    uvm_analysis_port #(cmd_t) mon_cmd_port;
    uvm_analysis_port #(req_t) mon_rw_cmd_port;
    cmd_t m_last;
    bit [16:0] current_row;
    bit row_closed=1;

    `uvm_component_utils(bm_monitor)

    function new(string name="bm_monitor", uvm_component parent);
      super.new(name, parent);
      mon_cmd_port = new("mon_cmd_port", this);
      mon_rw_cmd_port = new("mon_rw_cmd_port", this);
    endfunction

    function void set_interface(virtual cmd_rw_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction

    task run_phase(uvm_phase phase);
      this.mon_trans();
    endtask

    task update_row_status(cmd_t m);
      req_t r;
      case(m.cmd)
        PRECHARGE: begin 
          row_closed=1;
          `uvm_info("BANK_MACHINE", $sformatf("[ROW CLOSE]Time %0t monitored PRECHARGE BANK %0d", m.t,m.bank), UVM_HIGH)
        end
        ACTIVATE: begin 
          current_row=m.address;
          row_closed=0;
          `uvm_info("BANK_MACHINE", $sformatf("[ROW OPEN]Time %0t monitored ACTIVATE BANK %0d, row 0x%0h", m.t ,m.bank,m.address), UVM_HIGH)
        end
        COL_READ: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
        end
        COL_READ_AP: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
          row_closed=1;
          `uvm_info("BANK_MACHINE", $sformatf("[ROW CLOSE]Time %0t monitored AutoPrecharge BANK %0d", m.t ,m.bank), UVM_HIGH)
        end
        COL_WRITE: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
        end
        COL_WRITE_AP: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
          row_closed=1;
          `uvm_info("BANK_MACHINE", $sformatf("[ROW CLOSE]Time %0t monitored AutoPrecharge BANK %0d", m.t ,m.bank), UVM_HIGH)
        end
        MASKED_WRITE: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
        end
        MASKED_WRITE_AP: begin
          if(row_closed==1) `uvm_error("ROW NOT OPEN", "Illegal access with no rows open!")
          r.t=$time;
          r.we=m.we;
          r.mw=m.mw;
          r.address={current_row,m.address[9:4]};
          mon_rw_cmd_port.write(r);
          `uvm_info("BANK_MACHINE", $sformatf("Time %0t monitored %s BANK %0d, row 0x%0h ,col 0x%0h", m.t ,DDR_CMD[m.cmd],m.bank,current_row,m.address), UVM_HIGH)
          row_closed=1;
          `uvm_info("BANK_MACHINE", $sformatf("[ROW CLOSE]Time %0t monitored AutoPrecharge BANK %0d", m.t ,m.bank), UVM_HIGH)
        end
        default:`uvm_error("COMMAND VIOLATION", $sformatf("Receive BM command %s",DDR_CMD[m.cmd]))
      endcase
    endtask


    task check_cycle(int cycle_interval,int cycle_cst,string cmd_a,string cmd_b,string timing_name);
      if(cycle_interval<cycle_cst) begin
        `uvm_error($sformatf("%s VIOLATION",timing_name), $sformatf("[SB]Time interval between %s and %s is %0d nCK < %s= %0d nCK.",cmd_b,cmd_a,cycle_interval, timing_name,cycle_cst))
      end else begin
        `uvm_info($sformatf("%s MET",timing_name), $sformatf("[SB]Time interval between %s and %s is %0d nCK >= %s= %0d nCK.",cmd_b,cmd_a,cycle_interval, timing_name,cycle_cst),UVM_HIGH)
      end
    endtask

    task check_timing(time t_diff,time t_cst,string cmd_a,string cmd_b,string timing_name);
      if(t_diff<t_cst) begin
        `uvm_error($sformatf("%s VIOLATION",timing_name), $sformatf("[SB]Time interval between %s and %s is %0d ns < %s= %0d ns.",cmd_b,cmd_a,t_diff, timing_name,t_cst))
      end else begin
        `uvm_info($sformatf("%s MET",timing_name), $sformatf("[SB]Time interval between %s and %s is %0d ns >= %s= %0d ns.",cmd_b,cmd_a,t_diff, timing_name,t_cst),UVM_HIGH)
      end
    endtask

    task check_bm_timing(cmd_t m,cmd_t m_last);
      int cycle_interval;
      int t_diff;
      t_diff=m.t-m_last.t;//t ns
      cycle_interval=(m.t-m_last.t)/2; // system clock cycle
      case(m_last.cmd) 
          COL_READ_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_cycle(cycle_interval,(tRTP_sb+tRP),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTP_sb+tRP");
              end
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          COL_WRITE_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_cycle(cycle_interval,(tWTP_sb+tRP),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb+tRP");
              end
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          MASKED_WRITE_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_cycle(cycle_interval,(tWTP_sb+tRP),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb+tRP");
              end
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          PRECHARGE: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_timing(t_diff,tRP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP_ns");
              end
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          ACTIVATE: begin
            case(m.cmd)
              COL_READ: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_READ_AP: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_WRITE: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_WRITE_AP: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              MASKED_WRITE_AP: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              MASKED_WRITE: begin
                this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              PRECHARGE: begin
                this.check_timing(t_diff,tRAS_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRAS_ns");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
            
          end
          COL_READ: begin
            case(m.cmd)
              PRECHARGE: begin
                this.check_timing(t_diff,tRTP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTP_ns");
              end
              ACTIVATE:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              COL_READ: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_WRITE: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              COL_WRITE_AP: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              MASKED_WRITE: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              MASKED_WRITE_AP: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          COL_WRITE: begin
            case(m.cmd)
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
              end
              ACTIVATE:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              COL_READ: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_READ_AP: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE: begin
                this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
              end
              MASKED_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          MASKED_WRITE: begin
            case(m.cmd)
              PRECHARGE: begin
                this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
              end
              ACTIVATE:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              COL_READ: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_READ_AP: begin
                //comment out when checking bankmachine
                //this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE: begin
                this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
              end
              MASKED_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          default:begin
          end
      endcase
    endtask

    task mon_trans();
      cmd_t m;
      m_last.cmd=ERROR_1;

      forever begin
        @(intf.mon_ck iff (intf.mon_ck.cmd_valid==='b1 && intf.mon_ck.cmd_ready==='b1));
        m.cas = intf.mon_ck.cmd_payload_cas;
        m.ras = intf.mon_ck.cmd_payload_ras;
        m.we = intf.mon_ck.cmd_payload_we;
        m.mw = intf.mon_ck.cmd_payload_is_mw;
        case({intf.mon_ck.cmd_payload_ras,intf.mon_ck.cmd_payload_cas,intf.mon_ck.cmd_payload_we,intf.mon_ck.cmd_payload_is_mw})
          4'b1010: m.cmd=PRECHARGE;
          4'b1000: m.cmd=ACTIVATE;
          4'b0100: begin
            m.cmd=COL_READ;
            if(intf.mon_ck.cmd_payload_a[10]==1'b1) m.cmd=COL_READ_AP;
          end
          4'b0110: begin
            m.cmd=COL_WRITE;
            if(intf.mon_ck.cmd_payload_a[10]==1'b1) m.cmd=COL_WRITE_AP;
          end
          4'b0111: begin
            m.cmd=MASKED_WRITE;
            if(intf.mon_ck.cmd_payload_a[10]==1'b1) m.cmd=MASKED_WRITE_AP;
          end
          default: m.cmd=ERROR_0;
        endcase
        m.address = intf.mon_ck.cmd_payload_a;
        m.bank=intf.mon_ck.cmd_payload_ba;
        m.t=$time;
        mon_cmd_port.write(m);
        `uvm_info(get_type_name(), $sformatf("Time %0t Monitored BM cmd %s at bank %h, address %h", m.t,DDR_CMD[m.cmd],m.bank,m.address), UVM_HIGH)

        //update row status
`ifdef ROW_CHECK
        this.update_row_status(m);
`endif
        //check timing
        this.check_bm_timing(m,m_last);
        m_last=m;
      end
    endtask
  endclass: bm_monitor