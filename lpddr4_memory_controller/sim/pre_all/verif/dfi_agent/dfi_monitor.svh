  class dfi_monitor extends uvm_monitor;
    virtual dfi_interface intf;
    uvm_analysis_port #(dfi_cmd_t) mon_dfi_port;
    dfi_cmd_t m;
    dfi_cmd_t m_last;
    time last_activate_cmd=0;
    time last_activate_cmd_pb[8]={0,0,0,0,0,0,0,0};
    time last_refresh_cmd[8]={0,0,0,0,0,0,0,0};
    int refresh_count=0;

    `uvm_component_utils(dfi_monitor)

    function new(string name="dfi_monitor", uvm_component parent);
      super.new(name, parent);
      mon_dfi_port = new("mon_dfi_port", this);
    endfunction

    task run_phase(uvm_phase phase);
      this.mon_trans();
    endtask

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
    endfunction

    function void set_interface(virtual dfi_interface intf);
      if(intf == null)
        `uvm_error("GETVIF", "dfi interface handle is NULL, please check if target interface has been intantiated")
      else
        this.intf = intf;
    endfunction
    //update cmd and check DFI timing
    task update_cmd(dfi_cmd_t m0,dfi_cmd_t m1,dfi_cmd_t m2,dfi_cmd_t m3);
      int valid_num=0;
      if(m0.cmd!=ERROR_0) begin
        m.cmd=m0.cmd;
        m.t=m0.t;
        m.bank=m0.bank;
        m.address=m0.address;
        valid_num+=1;
      end

      if(m1.cmd!=ERROR_0) begin
        m.cmd=m1.cmd;
        m.t=m1.t;
        m.bank=m1.bank;
        m.address=m1.address;
        valid_num+=1;
      end
      if(m2.cmd!=ERROR_0) begin
        m.cmd=m2.cmd;
        m.t=m2.t;
        m.bank=m2.bank;
        m.address=m2.address;
        valid_num+=1;
      end

      if(m3.cmd!=ERROR_0) begin
        m.cmd=m3.cmd;
        m.t=m3.t;
        m.bank=m3.bank;
        m.address=m3.address;
        valid_num+=1;
      end

      if(valid_num==1) begin
        this.check_dfi_timing(m,m_last);
        m_last=m;
      end else if(valid_num>1) begin
        `uvm_error("DFI COMMAND OVERLAP", "DFI COMMAND OVERLAP DETECTED")
      end
    endtask

    task check_tRRD(time t,time t_last);
      int t_diff;
      t_diff=t-t_last;
      if(t_diff<tRRD_ns) begin
        `uvm_error("tRRD VIOLATION", $sformatf("[DB]Time interval between ACTIVATE and ACTIVATE is %0d ns < tRRD= %0d ns.", t_diff, tRRD_ns))
      end else begin
        `uvm_info("tRRD MET", $sformatf("[DB]Time interval between ACTIVATE and ACTIVATE is %0d ns >= tRRD= %0d ns.",t_diff, tRRD_ns),UVM_HIGH)
      end
    endtask

    task check_tFAW();
      int i=0;
      int j=0;
      int t_diff;
      time sorted_time[8];
      time temp;
      for(i=0;i<8;i++) begin
        sorted_time[i]=last_activate_cmd_pb[i];
      end
      for(i=8;i>1;i--) begin
        for(j=0;j<i;j++) begin
          if(sorted_time[j]<sorted_time[j+1]) begin
            temp=sorted_time[j+1];
            sorted_time[j+1]=sorted_time[j];
            sorted_time[j]=temp;
          end
        end
      end

      if(sorted_time[4]!=0) begin
        t_diff=sorted_time[0]-sorted_time[4];
        if(t_diff<tFAW_ns) begin
          `uvm_error("tFAW VIOLATION", $sformatf("[FAW]Current Four Activate Bank window is %0d ns < tFAW= %0d ns.", t_diff, tFAW_ns))
        end else begin
          `uvm_info("tFAW MET", $sformatf("[FAW]Current Four Activate Bank window is %0d ns >= tFAW= %0d ns.",t_diff, tFAW_ns),UVM_HIGH)
        end
      end
    endtask

    task check_tRC(time t,time t_last);
      int t_diff;
      t_diff=t-t_last;
      if(t_diff<tRC_ns) begin
        `uvm_error("tRC VIOLATION", $sformatf("[SB]Time interval ACTIVATE and ACTIVATE is %0d ns < tRC= %0d ns.", t_diff, tRC_ns))
      end else begin
        `uvm_info("tRC MET", $sformatf("[SB]Time interval between ACTIVATE and ACTIVATE is %0d ns >= tRC= %0d ns.",t_diff, tRC_ns),UVM_HIGH)
      end
    endtask

    task check_cycle(int cycle_interval,int cycle_cst,string cmd_a,string cmd_b,string timing_name);
      if(cycle_interval<cycle_cst) begin
        `uvm_error($sformatf("DFI %s VIOLATION",timing_name), $sformatf("[DFI]Time interval between %s and %s is %0d nCK < %s= %0d nCK.",cmd_b,cmd_a,cycle_interval, timing_name,cycle_cst))
      end else begin
        `uvm_info($sformatf("DFI %s MET",timing_name), $sformatf("[DFI]Time interval between %s and %s is %0d nCK >= %s= %0d nCK.",cmd_b,cmd_a,cycle_interval, timing_name,cycle_cst),UVM_HIGH)
      end
    endtask

    task check_timing(time t_diff,time t_cst,string cmd_a,string cmd_b,string timing_name);
      if(t_diff<t_cst) begin
        `uvm_error($sformatf("DFI %s VIOLATION",timing_name), $sformatf("[DFI]Time interval between %s and %s is %0d ns < %s= %0d ns.",cmd_b,cmd_a,t_diff, timing_name,t_cst))
      end else begin
        `uvm_info($sformatf("DFI %s MET",timing_name), $sformatf("[DFI]Time interval between %s and %s is %0d ns >= %s= %0d ns.",cmd_b,cmd_a,t_diff, timing_name,t_cst),UVM_HIGH)
      end
    endtask

    task check_refresh_timing(time t,time t_cst);
      time t_diff;
      t_diff=t-last_refresh_cmd[refresh_count];
      if(t_diff>t_cst) begin
        `uvm_error("REFRESH TIMING VIOLATION", $sformatf("[REFRESH]Time interval between 2 sets of refresh %0d ns > 8*tREFI= %0d ns.",t_diff,t_cst))
      end else begin
        `uvm_info("REFRESH TIMING MET", $sformatf("[REFRESH]Time interval between 2 sets of refresh %0d ns <= 8*tREFI= %0d ns.",t_diff,t_cst),UVM_HIGH)
      end
      last_refresh_cmd[refresh_count]=t;
      if(refresh_count==7) refresh_count=0;
      else refresh_count+=1;
    endtask

    task check_dfi_timing(dfi_cmd_t m,dfi_cmd_t m_last);
      int cycle_interval;
      int t_diff;
      bit same_bank;
      same_bank=(m.bank==m_last.bank);
      t_diff=m.t-m_last.t;//t ns
      cycle_interval=(m.t-m_last.t)/2; // system clock cycle
      case(m_last.cmd) 
          PRECHARGE_ALL: begin
            case(m.cmd)
              REFRESH_ALL: begin
                this.check_timing(t_diff,tRP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP_ns");
                this.check_refresh_timing(m.t,8*tREFI_ns);
              end
              default:begin
                `uvm_error("REFRESHER COMMAND VIOLATION", $sformatf("[DFI] REFRESHER CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          REFRESH_ALL: begin
            case(m.cmd)
              PRECHARGE_ALL: begin
                this.check_timing(t_diff,tRFC_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRFC_ns");
              end
              PRECHARGE: begin
                this.check_timing(t_diff,tRFC_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRFC_ns");
              end
              default:begin
                `uvm_error("REFRESHER COMMAND VIOLATION", $sformatf("[DFI] REFRESHER CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          COL_READ_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) this.check_cycle(cycle_interval,(tRP+tRTP_sb),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP+tRTP_sb");
              end
              PRECHARGE: begin
                if (same_bank) this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              default:begin
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI-SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          COL_WRITE_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) this.check_cycle(cycle_interval,(tRP+tWTP_sb),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP+tWTP_sb");
              end
              PRECHARGE: begin
                if (same_bank) this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              default:begin
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI-SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          MASKED_WRITE_AP: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) this.check_cycle(cycle_interval,(tRP+tWTP_sb),DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP+tWTP_sb");
              end
              PRECHARGE: begin
                if (same_bank) this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              default:begin
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI-SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end

          PRECHARGE: begin
            case(m.cmd)
              ACTIVATE: begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) this.check_timing(t_diff,tRP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRP_ns");
              end
              PRECHARGE: begin
                if (same_bank) this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tPP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tPP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              default:begin
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI-SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          ACTIVATE: begin
            case(m.cmd)
              COL_READ: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_WRITE: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              MASKED_WRITE: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_READ_AP: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              COL_WRITE_AP: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              MASKED_WRITE_AP: begin
                if(same_bank) this.check_timing(t_diff,tRCD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRCD_ns");
              end
              PRECHARGE: begin
                if(same_bank) this.check_timing(t_diff,tRAS_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRAS_ns");
              end
              PRECHARGE_ALL: begin
                this.check_timing(t_diff,tRAS_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRAS_ns");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              ACTIVATE: begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI-SB]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
                else begin
                  this.check_timing(t_diff,tRRD_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRRD_ns");
                end
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          COL_READ: begin
            case(m.cmd)
              PRECHARGE: begin
                if(same_bank) this.check_timing(t_diff,tRTP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTP_ns");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              PRECHARGE_ALL: begin
                this.check_timing(t_diff,tRTP_ns,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTP_ns");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              ACTIVATE:begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_WRITE: begin
                this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              MASKED_WRITE: begin
                this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              COL_READ_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_WRITE_AP: begin
                this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              MASKED_WRITE_AP: begin
                this.check_cycle(cycle_interval,tRTW_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tRTW_sb");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          COL_WRITE: begin
            case(m.cmd)
              PRECHARGE: begin
                if(same_bank) this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              ACTIVATE:begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ: begin
                this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE: begin
                if(same_bank) this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ_AP: begin
                this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE_AP: begin
                if(same_bank) this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          MASKED_WRITE: begin
            case(m.cmd)
              PRECHARGE: begin
                if(same_bank) this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              PRECHARGE_ALL: begin
                this.check_cycle(cycle_interval,tWTP_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTP_sb");
              end
              REFRESH_ALL: begin
                `uvm_error("REFRESH COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
              ACTIVATE:begin
                this.check_tRRD(m.t,last_activate_cmd);
                this.check_tRC(m.t,last_activate_cmd_pb[m.bank]);
                last_activate_cmd=m.t;
                last_activate_cmd_pb[m.bank]=m.t;
                this.check_tFAW();
                if(same_bank) `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ: begin
                this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE: begin
                if(same_bank) this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              COL_READ_AP: begin
                this.check_cycle(cycle_interval,tWTR_sb,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tWTR_sb");
              end
              COL_WRITE_AP: begin
                this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              MASKED_WRITE_AP: begin
                if(same_bank) this.check_cycle(cycle_interval,tCCDMW,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCDMW");
                else this.check_cycle(cycle_interval,tCCD,DDR_CMD[m.cmd],DDR_CMD[m_last.cmd],"tCCD");
              end
              default:begin
                `uvm_error("COMMAND VIOLATION", $sformatf("[DFI]CMD VIOLATION BETWEEN %s and %s",DDR_CMD[m_last.cmd],DDR_CMD[m.cmd]))
              end
            endcase
          end
          default:begin
          end
      endcase
    endtask

    task mon_trans();
      dfi_cmd_t m0;
      dfi_cmd_t m1;
      dfi_cmd_t m2;
      dfi_cmd_t m3;
      
      m0.cmd=ERROR_0;
      m1.cmd=ERROR_0;
      m2.cmd=ERROR_0;
      m3.cmd=ERROR_0;

      m_last.cmd=ERROR_0;
      //p0
      forever begin
        @(posedge intf.clk iff ((intf.dfi_phase0_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase0_interface_if.mon_ck.cas_n==='b0)||(intf.dfi_phase1_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase1_interface_if.mon_ck.cas_n==='b0)||(intf.dfi_phase2_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase2_interface_if.mon_ck.cas_n==='b0)||(intf.dfi_phase3_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase3_interface_if.mon_ck.cas_n==='b0)));
        m0.cas_n = intf.dfi_phase0_interface_if.mon_ck.cas_n;
        m0.ras_n = intf.dfi_phase0_interface_if.mon_ck.ras_n;
        m0.we_n = intf.dfi_phase0_interface_if.mon_ck.we_n;
        m0.mw = intf.dfi_phase0_interface_if.mon_ck.mw;
        m0.bank= intf.dfi_phase0_interface_if.mon_ck.bank;
        m0.address = intf.dfi_phase0_interface_if.mon_ck.address;
        m0.t=$time;
        case({intf.dfi_phase0_interface_if.mon_ck.ras_n,intf.dfi_phase0_interface_if.mon_ck.cas_n,intf.dfi_phase0_interface_if.mon_ck.we_n,intf.dfi_phase0_interface_if.mon_ck.mw})
          4'b0010: m0.cmd=REFRESH_ALL;
          4'b0100: begin
            m0.cmd=PRECHARGE;
            if(intf.dfi_phase0_interface_if.mon_ck.address[10]==1'b1) m0.cmd=PRECHARGE_ALL;
          end
          4'b0110: m0.cmd=ACTIVATE;
          4'b1010: begin
            m0.cmd=COL_READ;
            if(intf.dfi_phase0_interface_if.mon_ck.address[10]==1'b1) m0.cmd=COL_READ_AP;
          end
          4'b1000: begin
            m0.cmd=COL_WRITE;
            if(intf.dfi_phase0_interface_if.mon_ck.address[10]==1'b1) m0.cmd=COL_WRITE_AP;
          end
          4'b1001: begin
            m0.cmd=MASKED_WRITE;
            if(intf.dfi_phase0_interface_if.mon_ck.address[10]==1'b1) m0.cmd=MASKED_WRITE_AP;
          end
          4'b1110:m0.cmd=ERROR_0;
          default: m0.cmd=ERROR_1;
        endcase
        if(m0.cmd!=ERROR_0) begin
`ifndef RW_ONLY
          mon_dfi_port.write(m0);
`else 
          if(m0.cmd==COL_READ||m0.cmd==COL_WRITE||m0.cmd==COL_READ_AP||m0.cmd==COL_WRITE_AP||m0.cmd==MASKED_WRITE_AP||m0.cmd==MASKED_WRITE) begin
            mon_dfi_port.write(m0);
          end
`endif
          if(m0.cmd==REFRESH_ALL||m0.cmd==PRECHARGE||m0.cmd==PRECHARGE_ALL) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p0 cmd %s at bank %d",m0.t,DDR_CMD[m0.cmd],m0.bank), UVM_HIGH)
          end else if(m0.cmd==ACTIVATE) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p0 cmd %s at bank %d, row 0x%0h",m0.t,DDR_CMD[m0.cmd],m0.bank,m0.address), UVM_HIGH)
          end else begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p0 cmd %s at bank %d, col 0x%0h0",m0.t,DDR_CMD[m0.cmd],m0.bank,m0.address[9:4]), UVM_HIGH)
          end
        end
        //p1
        //@(posedge intf.clk iff ((intf.dfi_phase1_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase1_interface_if.mon_ck.cas_n==='b0)));
        m1.cas_n = intf.dfi_phase1_interface_if.mon_ck.cas_n;
        m1.ras_n = intf.dfi_phase1_interface_if.mon_ck.ras_n;
        m1.we_n = intf.dfi_phase1_interface_if.mon_ck.we_n;
        m1.mw = intf.dfi_phase1_interface_if.mon_ck.mw;
        m1.bank= intf.dfi_phase1_interface_if.mon_ck.bank;
        m1.address = intf.dfi_phase1_interface_if.mon_ck.address;
        m1.t=$time;
        case({intf.dfi_phase1_interface_if.mon_ck.ras_n,intf.dfi_phase1_interface_if.mon_ck.cas_n,intf.dfi_phase1_interface_if.mon_ck.we_n,intf.dfi_phase1_interface_if.mon_ck.mw})
          4'b0010: m1.cmd=REFRESH_ALL;
          4'b0100: begin
            m1.cmd=PRECHARGE;
            if(intf.dfi_phase1_interface_if.mon_ck.address[10]==1'b1) m1.cmd=PRECHARGE_ALL;
          end
          4'b0110: m1.cmd=ACTIVATE;
          4'b1010: begin
            m1.cmd=COL_READ;
            if(intf.dfi_phase1_interface_if.mon_ck.address[10]==1'b1) m1.cmd=COL_READ_AP;
          end
          4'b1000: begin
            m1.cmd=COL_WRITE;
            if(intf.dfi_phase1_interface_if.mon_ck.address[10]==1'b1) m1.cmd=COL_WRITE_AP;
          end
          4'b1001: begin
            m1.cmd=MASKED_WRITE;
            if(intf.dfi_phase1_interface_if.mon_ck.address[10]==1'b1) m1.cmd=MASKED_WRITE_AP;
          end
          4'b1110:m1.cmd=ERROR_0;
          default: m1.cmd=ERROR_1;
        endcase
        if(m1.cmd!=ERROR_0) begin
`ifndef RW_ONLY
          mon_dfi_port.write(m1);
`else 
          if(m1.cmd==COL_READ||m1.cmd==COL_WRITE||m1.cmd==COL_READ_AP||m1.cmd==COL_WRITE_AP||m1.cmd==MASKED_WRITE_AP||m1.cmd==MASKED_WRITE) begin
            mon_dfi_port.write(m1);
          end
`endif
          if(m1.cmd==REFRESH_ALL||m1.cmd==PRECHARGE||m1.cmd==PRECHARGE_ALL) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p1 cmd %s at bank %d",m1.t,DDR_CMD[m1.cmd],m1.bank), UVM_HIGH)
          end else if(m1.cmd==ACTIVATE) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p1 cmd %s at bank %d, row 0x%0h",m1.t,DDR_CMD[m1.cmd],m1.bank,m1.address), UVM_HIGH)
          end else begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p1 cmd %s at bank %d, col 0x%0h0",m1.t,DDR_CMD[m1.cmd],m1.bank,m1.address[9:4]), UVM_HIGH)
          end
        end

        //p2
        //@(posedge intf.clk iff ((intf.dfi_phase2_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase2_interface_if.mon_ck.cas_n==='b0)));
        m2.cas_n = intf.dfi_phase2_interface_if.mon_ck.cas_n;
        m2.ras_n = intf.dfi_phase2_interface_if.mon_ck.ras_n;
        m2.we_n = intf.dfi_phase2_interface_if.mon_ck.we_n;
        m2.mw = intf.dfi_phase2_interface_if.mon_ck.mw;
        m2.bank= intf.dfi_phase2_interface_if.mon_ck.bank;
        m2.address = intf.dfi_phase2_interface_if.mon_ck.address;
        m2.t=$time;
        case({intf.dfi_phase2_interface_if.mon_ck.ras_n,intf.dfi_phase2_interface_if.mon_ck.cas_n,intf.dfi_phase2_interface_if.mon_ck.we_n,intf.dfi_phase2_interface_if.mon_ck.mw})
          4'b0010: m2.cmd=REFRESH_ALL;
          4'b0100: begin
            m2.cmd=PRECHARGE;
            if(intf.dfi_phase2_interface_if.mon_ck.address[10]==1'b1) m2.cmd=PRECHARGE_ALL;
          end
          4'b0110: m2.cmd=ACTIVATE;
          4'b1010: begin
            m2.cmd=COL_READ;
            if(intf.dfi_phase2_interface_if.mon_ck.address[10]==1'b1) m2.cmd=COL_READ_AP;
          end
          4'b1000: begin
            m2.cmd=COL_WRITE;
            if(intf.dfi_phase2_interface_if.mon_ck.address[10]==1'b1) m2.cmd=COL_WRITE_AP;
          end
          4'b1001: begin
            m2.cmd=MASKED_WRITE;
            if(intf.dfi_phase2_interface_if.mon_ck.address[10]==1'b1) m2.cmd=MASKED_WRITE_AP;
          end
          4'b1110:m2.cmd=ERROR_0;
          default: m2.cmd=ERROR_1;
        endcase
        if(m2.cmd!=ERROR_0) begin
`ifndef RW_ONLY
          mon_dfi_port.write(m2);
`else 
          if(m2.cmd==COL_READ||m2.cmd==COL_WRITE||m2.cmd==COL_READ_AP||m2.cmd==COL_WRITE_AP||m2.cmd==MASKED_WRITE_AP||m2.cmd==MASKED_WRITE) begin
            mon_dfi_port.write(m2);
          end
`endif
          if(m2.cmd==REFRESH_ALL||m2.cmd==PRECHARGE||m2.cmd==PRECHARGE_ALL) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p2 cmd %s at bank %d",m2.t,DDR_CMD[m2.cmd],m2.bank), UVM_HIGH)
          end else if(m2.cmd==ACTIVATE) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p2 cmd %s at bank %d, row 0x%0h",m2.t,DDR_CMD[m2.cmd],m2.bank,m2.address), UVM_HIGH)
          end else begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p2 cmd %s at bank %d, col 0x%0h0",m2.t,DDR_CMD[m2.cmd],m2.bank,m2.address[9:4]), UVM_HIGH)
          end
        end
        //p3
        //@(posedge intf.clk iff ((intf.dfi_phase3_interface_if.mon_ck.ras_n==='b0)||(intf.dfi_phase3_interface_if.mon_ck.cas_n==='b0)));
        m3.cas_n = intf.dfi_phase3_interface_if.mon_ck.cas_n;
        m3.ras_n = intf.dfi_phase3_interface_if.mon_ck.ras_n;
        m3.we_n = intf.dfi_phase3_interface_if.mon_ck.we_n;
        m3.mw = intf.dfi_phase3_interface_if.mon_ck.mw;
        m3.bank= intf.dfi_phase3_interface_if.mon_ck.bank;
        m3.address = intf.dfi_phase3_interface_if.mon_ck.address;
        m3.t=$time;
        case({intf.dfi_phase3_interface_if.mon_ck.ras_n,intf.dfi_phase3_interface_if.mon_ck.cas_n,intf.dfi_phase3_interface_if.mon_ck.we_n,intf.dfi_phase3_interface_if.mon_ck.mw})
          4'b0010: m3.cmd=REFRESH_ALL;
          4'b0100: begin
            m3.cmd=PRECHARGE;
            if(intf.dfi_phase3_interface_if.mon_ck.address[10]==1'b1) m3.cmd=PRECHARGE_ALL;
          end
          4'b0110: m3.cmd=ACTIVATE;
          4'b1010: begin
            m3.cmd=COL_READ;
            if(intf.dfi_phase3_interface_if.mon_ck.address[10]==1'b1) m3.cmd=COL_READ_AP;
          end
          4'b1000: begin
            m3.cmd=COL_WRITE;
            if(intf.dfi_phase3_interface_if.mon_ck.address[10]==1'b1) m3.cmd=COL_WRITE_AP;
          end
          4'b1001: begin
            m3.cmd=MASKED_WRITE;
            if(intf.dfi_phase3_interface_if.mon_ck.address[10]==1'b1) m3.cmd=MASKED_WRITE_AP;
          end
          4'b1110:m3.cmd=ERROR_0;
          default: m3.cmd=ERROR_1;
        endcase
        if(m3.cmd!=ERROR_0) begin
`ifndef RW_ONLY
          mon_dfi_port.write(m3);
`else 
          if(m3.cmd==COL_READ||m3.cmd==COL_WRITE||m3.cmd==COL_READ_AP||m3.cmd==COL_WRITE_AP||m3.cmd==MASKED_WRITE_AP||m3.cmd==MASKED_WRITE) begin
            mon_dfi_port.write(m3);
          end
`endif
          if(m3.cmd==REFRESH_ALL||m3.cmd==PRECHARGE||m3.cmd==PRECHARGE_ALL) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p3 cmd %s at bank %d",m3.t,DDR_CMD[m3.cmd],m3.bank), UVM_HIGH)
          end else if(m3.cmd==ACTIVATE) begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p3 cmd %s at bank %d, row 0x%0h",m3.t,DDR_CMD[m3.cmd],m3.bank,m3.address), UVM_HIGH)
          end else begin
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI p3 cmd %s at bank %d, col 0x%0h0",m3.t,DDR_CMD[m3.cmd],m3.bank,m3.address[9:4]), UVM_HIGH)
          end
        end
`ifdef TIMING_CHECK
        this.update_cmd(m0,m1,m2,m3);
`endif
      end
    endtask
  endclass: dfi_monitor
