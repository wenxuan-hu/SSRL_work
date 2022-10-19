/* Machine-generated using Migen */
module LPDDR4_mm(
	//clocks
	input logic CK_p,CK_n,
	input logic CKE,
	input logic RESET_n,
	input logic CS,
	input logic [5:0] CA,
	inout logic [15:0] DQ,
	inout logic [1:0] DMI,
	inout logic [1:0] DQS_p,DQS_n,
	inout logic ZQ,
);

int state=0;
bit [5:0] ca_x;
bit cs_x;

always_ff(@posedge CK_p) begin
	update_state(CS, CA);
end

task update_state(bit cs, bit[5:0] ca);
      bank=ca[2:0];
      case(this.state)
        //idle
        0: begin
          if(cs===1'b1) begin
            m_ddr.t=$time;
            casez(ca[4:0])
            //precharge
            5'b10000: begin
              next_state=1;
              if(ca[5]===1'b0) m_ddr.cmd=PRECHARGE;
              else if(ca[5]===1'b1) m_ddr.cmd=PRECHARGE_ALL;
            end
            //act_1
            5'b???01: begin
              next_state=3;
              m_ddr.cmd=ACTIVATE;
              m_ddr.address[15:12]=ca[5:2];
            end
            //read
            5'b00010: begin
              m_ddr.cmd=COL_READ;
              next_state=7;
            end
            //write
            5'b00100: begin
              m_ddr.cmd=COL_WRITE;
              next_state=7;
            end
            //masked-write
            5'b01100: begin
              m_ddr.cmd=MASKED_WRITE;
              next_state=7;
            end
            //refresh
            5'b01000:begin
              if(ca[5]===1'b1) begin
                m_ddr.cmd=REFRESH_ALL;
                next_state=11;
              end else begin
                `uvm_error("COMMAND ERROR", $sformatf("REFRESH_ALL ca[5]= %0b, should be 1.",ca[5]))
              end
            end
            default: begin
              `uvm_error("COMMAND ERROR", $sformatf("CMD ca= 0b%b in IDLE STATE with cs=1",ca))
            end
            endcase
          end else begin
            next_state=0;
          end
        end
        //precharge_high
        1:begin
          if(cs===1'b0) begin
            m_ddr.bank=bank;
            if(m_ddr.cmd==PRECHARGE) begin
              row_open[bank]=0;
            end else begin
              foreach(row_open[i]) row_open[i]=0;
            end
            next_state=0;
`ifndef RW_ONLY
            mon_cmd_port.write(m_ddr);
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI LPDDR4 cmd %s at bank %d", m_ddr.t,DDR_CMD[m_ddr.cmd],m_ddr.bank), UVM_HIGH)
`endif
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end
        //activate_1_high
        3:begin
          if(cs===1'b0) begin
            m_ddr.bank=bank;
            m_ddr.address[16]=ca[3];
            m_ddr.address[11:10]=ca[5:4];
            next_state=4;
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end
        //activate_1_low
        4:begin
          if(cs===1'b1 && ca[1:0]==2'b11) begin
            m_ddr.address[9:6]=ca[5:2];
            next_state=5;
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b, ca=0b%b in act_2 cycle",cs_x,ca))
          end
        end
        //activate_2_high
        5:begin
          if(cs===1'b0) begin
            m_ddr.address[5:0]=ca[5:0];
            next_state=0;
            current_row[m_ddr.bank]=m_ddr.address;
            row_open[m_ddr.bank]=1;
`ifndef RW_ONLY
            mon_cmd_port.write(m_ddr);
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI LPDDR4 cmd %s at bank %d,row 0x%0h", m_ddr.t,DDR_CMD[m_ddr.cmd],m_ddr.bank,m_ddr.address), UVM_HIGH)
`endif
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end
        //rw/mw_high
        7:begin
          if(cs===1'b0) begin
            m_ddr.bank=bank;
            m_ddr.address[9]=ca[4];
            if(ca[5]===1'b1) begin
              case(m_ddr.cmd)
                COL_READ: m_ddr.cmd=COL_READ_AP;
                COL_WRITE: m_ddr.cmd=COL_WRITE_AP;
                MASKED_WRITE: m_ddr.cmd=MASKED_WRITE_AP;
                default: `uvm_error("COMMAND ERROR", $sformatf("current command %s in rw/mw state",DDR_CMD[m_ddr.cmd]))
              endcase
            end
            next_state=8;
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end
        //rw/mw_low
        8:begin
          if(cs===1'b1 && ca[4:0]==5'b10010) begin
            m_ddr.address[8]=ca[5];
            next_state=9;
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b, ca=0b%b in cas_2 cycle",cs_x,ca))
          end
        end
        //cas-2_high
        9:begin
          if(cs===1'b0) begin
            m_ddr.address[7:2]=ca[5:0];
            m_ddr.address[1:0]=2'd0;
            m_ddr.address[16:10]=7'd0;
            next_state=0;
            m_ddr.row=current_row[m_ddr.bank];
            mon_cmd_port.write(m_ddr);
            if((m_ddr.cmd==COL_READ)||(m_ddr.cmd==COL_READ_AP)) mon_rsp_port.write(m_ddr);
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI LPDDR4 cmd %s at bank %d,col 0x%0h", m_ddr.t,DDR_CMD[m_ddr.cmd],m_ddr.bank,m_ddr.address), UVM_HIGH)
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end
        //refresh_high
        11:begin
          if(cs===1'b0) begin
            m_ddr.bank=bank;
            next_state=0;
`ifndef RW_ONLY
            mon_cmd_port.write(m_ddr);
            `uvm_info(get_type_name(), $sformatf("Time: %0t monitored DFI LPDDR4 cmd %s", m_ddr.t,DDR_CMD[m_ddr.cmd]), UVM_HIGH)
`endif
          end else begin
            `uvm_error("COMMAND ERROR", $sformatf("cs= %0b in second command cycle",cs_x))
          end
        end

        default: begin
          `uvm_error("COMMAND ERROR", "UNEXPECTED STATE")
        end
      endcase
      this.state=next_state;
    endtask



reg [15:0] bank0[0:33554431];
always @(posedge clkddr_90) begin
	if (memory0_we[0])
		mem[memory0_adr][7:0] <= memory0_dat_w[7:0];
	if (memory0_we[1])
		mem[memory0_adr][15:8] <= memory0_dat_w[15:8];
end

assign memory0_dat_r = mem[memory0_adr];

reg [15:0] bank1[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory1_we[0])
		mem_1[memory1_adr][7:0] <= memory1_dat_w[7:0];
	if (memory1_we[1])
		mem_1[memory1_adr][15:8] <= memory1_dat_w[15:8];
end

assign memory1_dat_r = mem_1[memory1_adr];

reg [15:0] bank2[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory2_we[0])
		mem_2[memory2_adr][7:0] <= memory2_dat_w[7:0];
	if (memory2_we[1])
		mem_2[memory2_adr][15:8] <= memory2_dat_w[15:8];
end

assign memory2_dat_r = mem_2[memory2_adr];

reg [15:0] bank3[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory3_we[0])
		mem_3[memory3_adr][7:0] <= memory3_dat_w[7:0];
	if (memory3_we[1])
		mem_3[memory3_adr][15:8] <= memory3_dat_w[15:8];
end

assign memory3_dat_r = mem_3[memory3_adr];

reg [15:0] bank4[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory4_we[0])
		mem_4[memory4_adr][7:0] <= memory4_dat_w[7:0];
	if (memory4_we[1])
		mem_4[memory4_adr][15:8] <= memory4_dat_w[15:8];
end

assign memory4_dat_r = mem_4[memory4_adr];

reg [15:0] bank5[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory5_we[0])
		mem_5[memory5_adr][7:0] <= memory5_dat_w[7:0];
	if (memory5_we[1])
		mem_5[memory5_adr][15:8] <= memory5_dat_w[15:8];
end

assign memory5_dat_r = mem_5[memory5_adr];

reg [15:0] bank6[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory6_we[0])
		mem_6[memory6_adr][7:0] <= memory6_dat_w[7:0];
	if (memory6_we[1])
		mem_6[memory6_adr][15:8] <= memory6_dat_w[15:8];
end

assign memory6_dat_r = mem_6[memory6_adr];

reg [15:0] bank7[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory7_we[0])
		mem_7[memory7_adr][7:0] <= memory7_dat_w[7:0];
	if (memory7_we[1])
		mem_7[memory7_adr][15:8] <= memory7_dat_w[15:8];
end

assign memory7_dat_r = mem_7[memory7_adr];

endmodule

//cmd: 000 nop 
//0001 precharge
//0010 activate
//0011 read
//0100 write
//0101 masked_write
//0110 refresh
//1011 read_AP
//1100 write_AP
//1101 masked_write_AP
module bank_model(
	input clk,rst,
	input [3:0] cmd,
	input [16:0] row,
	input [9:0] col,
	input [15:0] data_in,
	input [1:0] data_mask_in,
	output [15:0] data_out
);

bit bank_precharged;
bit row_activated;
logic [14:0] activated_row;

logic [15:0] mem[0:33554431];//15 row

always @(posedge clk,posedge rst) begin
	if(rst) begin 
		bank_precharged<=0;
		row_activated<=0;
		data_out<='d0;
	end else case(cmd)
		//NOP
		4'b0000:begin
		end
		//PRECHARGE
		4'b0001:begin
			bank_precharged<=1;
			row_activated<=0;
		end
		//ACTIVATE
		4'b0010:begin
			if(bank_precharged==1) begin
				bank_precharged<=0;
				row_activated<=1;
				activated_row<=row[14:0];
			end else $display("Bank not precharged");
		end
		//READ
		4'b0011:begin
			if(row_activated==1) data_out<=mem[activated_row*1024+col][15:0];
			else $display("Row not activated");
		end
		//READ_AP
		4'b1011:begin
			if(row_activated==1) begin
				data_out<=mem[activated_row*1024+col][15:0];
				row_activated<=0;
				bank_precharged<=1;
			end else $display("Row not activated");
		end
		//WRITE
		4'b0100: begin
			if(row_activated==1) mem[activated_row*1024+col][15:0] <= data_in[15:0];
			else $display("Row not activated");
		end
		//WRITE_AP
		4'b1100: begin//write_AP
			if(row_activated==1) begin
				mem[activated_row*1024+col][15:0] <= data_in[15:0];
				row_activated=0;
			end else $display("Row not activated");
		end
		//MASKED_WRITE
		4'b0101: begin
			if(row_activated==1) begin
				if(data_mask_in[0]==0) mem[activated_row*1024+col][7:0] <= data_in[7:0];
				if(data_mask_in[1]==0) mem[activated_row*1024+col][15:8] <= data_in[15:8];
			end 
			else $display("Row not activated");
		end
		//MASKED_WRITE_AP
		4'b1101: begin
			if(row_activated==1) begin
				if(data_mask_in[0]==0) mem[activated_row*1024+col][7:0] <= data_in[7:0];
				if(data_mask_in[1]==0) mem[activated_row*1024+col][15:8] <= data_in[15:8];
				row_activated<=0;
				bank_precharged<=1;
			end 
			else $display("Row not activated");
		end
		4'b0110: begin
			row_activated<=0;
			bank_precharged<=0;
		end
		default: begin
		end
	endcase
end

endmodule
