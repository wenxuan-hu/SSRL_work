`timescale 1ns/10ps


//image  dma testbench top

module tb_top();
// ----------------------------------------------------
    `include "uvm_macros.svh"
    import uvm_pkg::*;
// ----------------------------------------------------
    logic iclk;
    logic aclk;
    logic pclk;

    logic rst_n;  

    logic [7:0] pixel_data;
    logic pixel_valid;
    logic pixel_ready;

    //clks
    parameter half_clk_cycle=13;
    always #half_clk_cycle iclk=~iclk;
    always #half_clk_cycle pclk=~pclk;
    always #half_clk_cycle aclk=~aclk;


    icb_interface icb();

    axi_interface axi(aclk,rst_n);

// ----------------------------------------------------

module image_datapath(
  .aclk(aclk),
  .pclk(pclk),
  .iclk(iclk),

  .rst_n(rst_n),

  .pixel_data_i(pixel_data),
  .pixel_valid_i(pixel_valid),
  .pixel_ready_o(pixel_ready),

  .icb(icb),
  .axi(axi)
);









logic [31:0] xmit_address_q [$];
logic [511:0] xmit_data_q [$];

int run_for_n_pkts;

    initial begin
        aclk<=0;
        pclk<=0;
        iclk<=0;
    end

    initial begin 

        run_for_n_pkts=10;
        mc_rst<=1;
        phy_rst <= 1;
        repeat(5) @(negedge ref_clk);
        phy_rst <= 0;
        $display ("[%t] #########  Exit Reset #############", $time);
        $display ("[%t] #########  Start PHY LPDDR4 Mode Test #########",$time);
`ifdef MCU_CTRL
        $display ("[%t] #########  Begin loading SRAM #############", $time);
        u_sram_loader.begin_transfer();
        repeat (100) @(posedge lpddr4_tb.ref_clk);
        u_sram_loader.ahb_write(32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(32'h00090024,32'h00000100);
        u_sram_loader.ahb_write(32'h00000004, 32'h1);
        repeat (100000) @(posedge lpddr4_tb.ref_clk);
`else
        //set reset_n=0;
        u_sram_loader.ahb_write(32'h00090054,32'h00000001);
        ibias_ldo_initialize();
        #10;
        ZQ_calibration();
        #10;
        pll_initialize_0p8();
        //pll_initialize_2p1();
        #10;
        link_initialize();
        #10;
        delay_calibration();
        #10;
        rxfifo_clr();
        #10;
        dram_initialize();
        #10;
        //delay_calibration();//retrive original value changed by training
        #10
        rxfifo_clr();
        @(posedge phy_clk);
        mc_initialize_4266();
        wait(lpddr4_tb.initialize_done==1);
        @(negedge phy_clk);
        mc_rst<=0;
        $display ("[%t] #########  Initialization Done #############", $time);
        repeat (100) @(posedge lpddr4_tb.phy_clk);
    `ifndef INIT_ONLY
        $display ("[%t] #########  Begin DRAM Data Write #############", $time);
        //data_write_0();
        repeat (10) @(posedge lpddr4_tb.phy_clk);
        $display ("[%t] #########  Finish DRAM Data Write #############", $time);
        $display ("[%t] #########  Begin DRAM Data Read #############", $time);
        //data_read_0();
        repeat (10) @(posedge lpddr4_tb.phy_clk);
        $display ("[%t] #########  Finish DRAM Data Read #############", $time);
        repeat (100) @(posedge lpddr4_tb.phy_clk);
    `endif
`endif
        Finish ();
    end

int err_count;

//task data_write_0 ();
//	static int pkts_gen = 0;
//	bit [511:0] data = 0;
//    bit [25:0] address=0;
//    int n_idles=0;
//	
//    while (pkts_gen < run_for_n_pkts) begin
//        n_idles=$random%2;
//        if(pkts_gen==0) begin
//            data=512'h00112233_44556677_8899aabb_ccddeeff_00112233_44556677_8899aabb_ccddeeff_ffeeddcc_bbaa9988_77665544_33221100_ffeeddcc_bbaa9988_77665544_33221100;
//        end else begin
//            for(int i=1;i<64;i++) begin
//	            data[i*8+:8] = $random;
//            end
//            data[7:0]=pkts_gen;
//        end
//
//	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);   
//
//        //col
//        address[5:0]=pkts_gen[5:0];//$random
//        //bank
//        address[8:6]=pkts_gen[8:6];
//        //row-14
//        address[22:9]=pkts_gen[10:9];
//        address[26:23]=0;
//        $display ("[%t] Generating address[%d] = 0x%h \n", $time, pkts_gen, address);  
//        fork
//          nat_write_cmd(address,1,0);
//          nat_write_data(data);
//        join   
//        xmit_address_q.push_back(address);
//        xmit_data_q.push_back(data);
//        pkts_gen++;
//    end
//    nat_cmd_idle();
//    nat_wdata_idle();
//endtask
//
//task nat_write_cmd();
//    input [31:0] address;
//    input we;
//    input mw;
//    integer n_idles;
//    begin
//      n_idles=$random%2;
//      @(negedge lpddr4_tb.phy_clk);
//       native_if_0.native_cmd_payload_addr<= address;
//       native_if_0.native_cmd_valid <= 1'b1;
//       native_if_0.native_cmd_payload_we <= we;
//       native_if_0.native_cmd_payload_mw <= mw;
//      @(posedge lpddr4_tb.phy_clk);
//      while (native_if_0.native_cmd_ready!= 1'b1) @(posedge lpddr4_tb.phy_clk);
//      @(negedge lpddr4_tb.phy_clk);
//      native_if_0.native_cmd_valid <= 1'b0;
//      repeat(n_idles) nat_cmd_idle();
//    end
//endtask
//
//task nat_write_data();
//    input [511:0] data;
//    integer n_idles;
//    begin
//      n_idles=$random%3;
//        @(negedge lpddr4_tb.phy_clk);
//        native_if_0.wdata_valid<= 1'b1;
//	    native_if_0.wdata_payload_data<= data[255:0];
//        native_if_0.wdata_payload_we<= '1;
//        @(posedge lpddr4_tb.phy_clk);
//        while (native_if_0.wdata_ready!= 1'b1) @(posedge lpddr4_tb.phy_clk);
//        @(negedge lpddr4_tb.phy_clk);
//        native_if_0.wdata_valid<= 1'b1;
//        native_if_0.wdata_payload_data<= data[511:256];
//        native_if_0.wdata_payload_we<= '1;
//        @(posedge lpddr4_tb.phy_clk);
//        while (native_if_0.wdata_ready!= 1'b1) @(posedge lpddr4_tb.phy_clk);
//        @(negedge lpddr4_tb.phy_clk);
//        native_if_0.wdata_valid<= 1'b0;
//        repeat(n_idles) nat_wdata_idle();
//      end
//endtask
//
//    
//task nat_cmd_idle();
//    @(negedge lpddr4_tb.phy_clk);
//       native_if_0.native_cmd_payload_addr<= 0;
//       native_if_0.native_cmd_valid <= 0;
//       native_if_0.native_cmd_payload_we <= 0;
//       native_if_0.native_cmd_payload_mw <= 0;
//endtask
//
//task nat_wdata_idle();
//    @(negedge lpddr4_tb.phy_clk);
//    native_if_0.wdata_valid<= 0;
//	native_if_0.wdata_payload_data<= 0;
//	native_if_0.wdata_payload_we<= 0;
//endtask
//
////*************************************************
//// task to check data received on TX side
////*************************************************
//task data_read_0 ();
//    bit [511:0] data_exp = 0;
//    bit [511:0] data_rcv = 0;
//    static int pkts_rcvd = 0;
//    integer wait_timeout=100_000;
//    bit [31:0] rd_addr;
//    begin
//    fork
//        begin
//            while (xmit_address_q.size!=0) begin
//                rd_addr = xmit_address_q.pop_front();
//                nat_write_cmd(rd_addr,0,0);
//            end
//        end
//
//
//        begin
//        @(posedge lpddr4_tb.phy_clk);
//        while (wait_timeout > 0)
//            begin
//                wait_timeout = wait_timeout - 1;
//                @(posedge lpddr4_tb.phy_clk);
//            end
//        end
//
//        begin
//            while(pkts_rcvd < run_for_n_pkts) begin
//                @ (posedge lpddr4_tb.phy_clk);
//                if (lpddr4_tb.native_if_0.rdata_valid===1'b1) begin
//                    data_rcv[255:0] =lpddr4_tb.native_if_0.rdata_payload_data;
//                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, lpddr4_tb.native_if_0.rdata_payload_data);
//                    @ (posedge lpddr4_tb.phy_clk);
//                    if (lpddr4_tb.native_if_0.rdata_valid===1'b1) begin
//                        data_rcv[511:256] =lpddr4_tb.native_if_0.rdata_payload_data;
//                        $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, lpddr4_tb.native_if_0.rdata_payload_data);
//                    end
//                    data_exp = xmit_data_q.pop_front();
//                    pkts_rcvd++;
//                    if (data_rcv != data_exp) begin
//                        err_count++;
//                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, data_rcv, data_exp);
//                    end   
//                end
//            end
//            if (xmit_data_q.size() != 0) //check if all the data are received
//            $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_data_q.size());    
//        end
//    join_any
//
//    if (wait_timeout <= 0)
//    begin
//        $display ("ERROR Timeout waiting for rdi data at time %t", $time);
//        $display (" size of data waiting to be received = %d", xmit_data_q.size  () );
//        $finish();
//    end
//
//    end
//endtask // mstr_req_rcv

task Finish ();
begin
	$display("%0t: %m: finishing simulation..", $time);
	repeat (10) @(posedge lpddr4_tb.ref_clk);
	$display("\n////////////////////////////////////////////////////////////////////////////");
	$display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	$display("////////////////////////////////////////////////////////////////////////////\n");
    if (err_count == 0) begin
        $display("+++++++++++++++++++++++++++++++++\n");
        $display("TEST PASSED!!!!!!!!!!!\n");
        $display("+++++++++++++++++++++++++++++++++\n");
    end
	//$finish;
end
endtask

bit [31:0] ahb_rdata;

task rxfifo_clr();
    begin
        u_sram_loader.ahb_write(32'h00110000,32'h00000100); //CH0_CA__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h000F0000,32'h00000100); //CH0_DQ0__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00100000,32'h00000100); //CH0_DQ1__TOP_CFG  (set FIFO_CLR=1)

        u_sram_loader.ahb_write(32'h00110000,32'h00000000); //CH0_CA__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h000F0000,32'h00000000); //CH0_DQ0__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00100000,32'h00000000); //CH0_DQ1__TOP_CFG  (set FIFO_CLR=0)

        u_sram_loader.ahb_write(32'h00140000,32'h00000100); //CH1_CA__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00120000,32'h00000100); //CH1_DQ0__TOP_CFG  (set FIFO_CLR=1)
        u_sram_loader.ahb_write(32'h00130000,32'h00000100); //CH1_DQ1__TOP_CFG  (set FIFO_CLR=1)

        u_sram_loader.ahb_write(32'h00140000,32'h00000000); //CH1_CA__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00120000,32'h00000000); //CH1_DQ0__TOP_CFG  (set FIFO_CLR=0)
        u_sram_loader.ahb_write(32'h00130000,32'h00000000); //CH1_DQ1__TOP_CFG  (set FIFO_CLR=0)
    end
endtask

task delay_calibration();
    begin
        bit [31:0] ch0_dq0_fc_dly;
        bit [31:0] ch0_dq1_fc_dly;
        bit [31:0] ch1_dq0_fc_dly;
        bit [31:0] ch1_dq1_fc_dly;

        bit [31:0] ch0_dqs0_fc_dly;
        bit [31:0] ch0_dqs1_fc_dly;
        bit [31:0] ch1_dqs0_fc_dly;
        bit [31:0] ch1_dqs1_fc_dly;

        bit [31:0] ch0_ca_fc_dly;
        bit [31:0] ch1_ca_fc_dly;

        ch0_dq0_fc_dly={8{4'd2}};
        ch0_dq1_fc_dly={8{4'd2}};
        ch1_dq0_fc_dly={8{4'd2}};
        ch1_dq1_fc_dly={8{4'd2}};


        ch0_dqs0_fc_dly={8{4'd1}};
        ch0_dqs1_fc_dly={8{4'd1}};//11111111
        ch1_dqs0_fc_dly={8{4'd1}};
        ch1_dqs1_fc_dly={8{4'd1}};

        ch0_ca_fc_dly={8{4'd1}};
        ch1_ca_fc_dly={8{4'd1}};

        //reset clock divider
        u_sram_loader.ahb_write(32'h000A0030,32'h00000080); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        u_sram_loader.ahb_read(32'h000A0030,ahb_rdata); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        while(ahb_rdata[7]!=1) begin
            u_sram_loader.ahb_read(32'h000A0030,ahb_rdata);
        end
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000); //FSW_CSP_1_CFG  div_rst_ovr_value=0

        //REN/RCS phase extension
        u_sram_loader.ahb_write(32'h000D0090,32'h01040404); //DFICH0__CTRL5_M0_CFG
        u_sram_loader.ahb_write(32'h000D0094,32'h01040404); //DFICH0__CTRL5_M1_CFG

        //WCS/WEN/WOE phase extension
        u_sram_loader.ahb_write(32'h000D0080,32'h000D0D00); //_DFICH0__CTRL3_M0_CFG
        u_sram_loader.ahb_write(32'h000D0084,32'h000D0D00); //_DFICH0__CTRL3_M1_CFG

        //CH0
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0410,ch0_dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0434,ch0_dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100410,ch0_dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100434,ch0_dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120410,ch1_dq0_fc_dly); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120434,ch1_dq0_fc_dly); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130410,ch1_dq1_fc_dly); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130434,ch1_dq1_fc_dly); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH0 DQS FC delay
        //DQS0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0AC0,ch0_dqs0_fc_dly); //CH0_DQ0_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0AE4,ch0_dqs0_fc_dly); //CH0_DQ0_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100AC0,ch0_dqs1_fc_dly); //CH0_DQ1_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100AE4,ch0_dqs1_fc_dly); //CH0_DQ1_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1 DQS FC delay
        //DQS0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120AC0,ch1_dqs0_fc_dly); //CH1_DQ0_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120AE4,ch1_dqs0_fc_dly); //CH1_DQ0_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130AC0,ch1_dqs1_fc_dly); //CH1_DQ1_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130AE4,ch1_dqs1_fc_dly); //CH1_DQ1_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0-8


        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0B50,32'hf); //f //CH0_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0B74,32'hf); //CH0_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00100B50,32'hf); //CH0_DD1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100B74,32'hf); //CH0_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00120B50,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120B74,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00130B50,32'hf); //CH1_DQ1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130B74,32'hf); //3 //CH1_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8

        //CH0 CA FC_DLY
        //CH0 CK FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h001104D8,ch0_ca_fc_dly); //CH0_CA__DQ_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write_all_lane(32'h001105D4,ch0_ca_fc_dly); //CH0_CA__DQ_TX_SDR_FC_DLY_M0_R1_CFG_0

        u_sram_loader.ahb_write(32'h00110AB8,ch0_ca_fc_dly); //CH0_CA__DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00110ABC,ch0_ca_fc_dly); //CH0_CA__DQS_TX_SDR_FC_DLY_M0_R1_CFG_0

        //CH1 CA/CK FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h001404D8,ch1_ca_fc_dly); //CH1_CA__DQ_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write_all_lane(32'h001405D4,ch1_ca_fc_dly); //CH1_CA__DQ_TX_SDR_FC_DLY_M0_R1_CFG_0

        u_sram_loader.ahb_write(32'h00140AB8,ch1_ca_fc_dly); //CH1_CA__DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00140ABC,ch1_ca_fc_dly); //CH1_CA__DQS_TX_SDR_FC_DLY_M0_R1_CFG_0

        //DQS RX Delay
        u_sram_loader.ahb_write(32'h000F081C,32'h00000000); //Ch0_DQ0_DQS_RX_IO_M0_R0_CFG_1 //AFAF when 1600
        u_sram_loader.ahb_write(32'h0010081C,32'h00000000); //Ch0_DQ1_DQS_RX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0824,32'h00000000); //Ch0_DQ0_DQS_RX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100824,32'h00000000); //Ch0_DQ1_DQS_RX_IO_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h0012081C,32'h00000000); //Ch1_DQ0_DQS_RX_IO_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h0013081C,32'h00000000); //Ch1_DQ1_DQS_RX_IO_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00120824,32'h00000000); //Ch1_DQ0_DQS_RX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00130824,32'h00000000); //Ch1_DQ1_DQS_RX_IO_M0_R1_CFG_1

        //set RX AC path mode, SE mode disable
        u_sram_loader.ahb_write(32'h000F083C,32'h00027777); //Ch0_DQ0_DQS_RX_IO_CMN 
        u_sram_loader.ahb_write(32'h0010083C,32'h00027777); //Ch0_DQ1_DQS_RX_IO_CMN

        u_sram_loader.ahb_write(32'h000F0838,32'h00027777); //Ch0_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h00100838,32'h00027777); //Ch0_DQ1_DQS_RX_IO_CMN

        u_sram_loader.ahb_write(32'h0012083C,32'h00027777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h0013083C,32'h00027777); //Ch1_DQ1_DQS_RX_IO_CMN

        u_sram_loader.ahb_write(32'h00120838,32'h00027777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(32'h00130838,32'h00027777); //Ch1_DQ1_DQS_RX_IO_CMN

        //DQ LPDE
        u_sram_loader.ahb_write_all_lane(32'h000F06E0,32'h000001FF); //CH0_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0704,32'h000001FF); //CH0_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001006E0,32'h000001FF); //CH0_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100704,32'h000001FF); //CH0_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001206E0,32'h000001FF); //CH1_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120704,32'h000001FF); //CH1_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001306E0,32'h000001FF); //CH1_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130704,32'h000001FF); //CH1_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        //DQS LPDE
        u_sram_loader.ahb_write(32'h000F0D94,32'h00000100); //Ch0_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00100D94,32'h00000100); //Ch0_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0D9C,32'h00000100); //Ch0_DQ0_DQS_TX_LPDE_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100D9C,32'h00000100); //Ch0_DQ1_DQS_TX_LPDE_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h00120D94,32'h00000100); //Ch1_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00130D94,32'h00000100); //Ch1_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00120D9C,32'h00000100); //Ch1_DQ0_DQS_TX_LPDE_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00130D9C,32'h00000100); //Ch1_DQ1_DQS_TX_LPDE_M0_R1_CFG_1

        //CK LPDE
        u_sram_loader.ahb_write(32'h00110B08,32'h0000013F); //Ch0_CA_DQS_TX_LPDE_M0_R0_CFG_0
        u_sram_loader.ahb_write(32'h00140B08,32'h0000013F); //Ch1_CA_DQS_TX_LPDE_M0_R0_CFG_0

    end
endtask

bit [447:0]  egress_data_from_dp;
bit [7:0] dqs_tx_dly_ctrl_ch0_dq0;
bit [7:0] dqs_tx_dly_ctrl_ch0_dq1;
bit [7:0] dqs_tx_dly_ctrl_ch1_dq0;
bit [7:0] dqs_tx_dly_ctrl_ch1_dq1;

task mc_initialize_4266();
    bit [1:0] write_phase;
    bit [1:0] read_phase;
    bit [7:0] crb_wl;
    bit [7:0] crb_rl;
    bit [7:0] dfi_wel;
    bit [7:0] dfi_rel;
    begin
        $display ("[%t] #########  Memory Controller Initialize (4266)   #########",$time);
        write_phase=2;
        read_phase=3;
        u_sram_loader.ahb_write(32'h00160000,{28'h0210070,write_phase,read_phase}); //wrphase_cfg rdphase_cfg 

        crb_wl=6;
        crb_rl=19;
        u_sram_loader.ahb_write(32'h00160014,{16'h0000,crb_wl,crb_rl}); //crb_WRITE_LATENCY_cfg crb_READ_LATENCY_cfg

        dfi_wel=5;
        dfi_rel=12;
        u_sram_loader.ahb_write(32'h00160018,{16'h00C0,dfi_wel,dfi_rel}); //dfi_wdqs_preamble_cfg=0xc0  dfi_wrdata_en_latency_cfg=2 dfi_rddata_en_latency_cfg=5

        u_sram_loader.ahb_write(32'h0016001C,32'h00000001); //mc_initialize_done=1
    end
endtask

task mc_initialize();
    begin
        $display ("[%t] #########  Memory Controller Initialize   #########",$time);
        u_sram_loader.ahb_write(32'h00160000,32'h02100705); //rdphase_cfg=1 wrphase_cfg=1
        u_sram_loader.ahb_write(32'h00160014,32'h0000030C); //crb_WRITE_LATENCY_cfg=3  crb_READ_LATENCY_cfg=12
        u_sram_loader.ahb_write(32'h00160018,32'h00C00205); //dfi_wdqs_preamble_cfg=0xc0  dfi_wrdata_en_latency_cfg=2 dfi_rddata_en_latency_cfg=5
        u_sram_loader.ahb_write(32'h0016001C,32'h00000001); //mc_initialize_done=1
    end
endtask

task dram_initialize();
    begin
        $display ("[%t] #########  DRAM Initializing   #########",$time);
        //set reset_n=0;
        $display ("[%t] #########  Release DRAM Reset_n   #########",$time);
        u_sram_loader.ahb_write(32'h00090054,32'h00000000);
        $display ("[%t] #########  Enable CK toggling   #########",$time);
        CKE_initialize();
        #100;//should be 2 us
        $display ("[%t] #########  Mode Register Write/Read   #########",$time);
        MRW(1,8'b1010_1100); //RD postample=1.5*tCK nWR=16 RD_PRE=toggle
        //MRW(1,8'b0010_0100); //RD postample=0.5*tCK nWR=16 RD_PRE=static
        repeat(10) @(posedge ref_clk);
        MRW(2,8'b0001_0010); //RL=14 WL=8
        repeat(10) @(posedge ref_clk);
        MRR(0,0);
        read_dfi_egress_data(egress_data_from_dp);
        read_dfi_egress_data(egress_data_from_dp);
        //Command Bus Training
        MRW(2,8'b0011_1111); //RL=36 WL=18
        //command_bus_training();
        //boost frequency to 2133MHz
        pll_2p1();
        repeat(10) @(posedge ref_clk);
        //write-leveling
        write_leveling_skip(); //skip training process, directly tune tx dqs with trained parameters
        //write_leveling(); //perform full training process
        repeat(1) @(posedge ref_clk);
        //read_dq_calibration_training(15);
        read_dq_calibration_training_skip(8'h38); //skip read dq calibration, directly send delay results to dqs_rx
        repeat(1) @(posedge ref_clk);
        //write_training();
        write_training_skip(8'h9f);//skip-00-200ps 9f-140ps 
        //turn off buff mode
        u_sram_loader.ahb_write(32'h000D0000,32'h000C2020);

    end
endtask

task write_training();
    bit [31:0] eye_map [0:15];
    bit [5:0] dq_dly_ctrl;
    bit [511:0] data_write;
    bit [511:0] data_read;
    bit [447:0] egress_data;
    bit [4:0] dq_drvr_dly_ctrl_lower;
    bit [4:0] dq_drvr_dly_ctrl_upper;
    bit [5:0] dq_drvr_dly_ctrl_point;
    bit [7:0] dq_drvr_dly_ctrl_set_point;
    bit [1:0] dly_gear;
    begin
        dly_gear=2;
        dq_drvr_dly_ctrl_lower=31;
        dq_drvr_dly_ctrl_upper=31;
        for(int i=0;i<64;i++) begin
            data_write[i*8+:8] = $random;
        end
        $display ("[%t] #########  Write Training Start   #########",$time);
        for (int dly=0;dly<32;dly++) begin
            $display("################### [T Iteration %0d], dq_drvr_dly_ctrl=[0x%h]  #####################",dly,{dly_gear,dly[4:0],1'b0});
            //DQ LPDE
            u_sram_loader.ahb_write_all_lane(32'h000F06E0,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH0_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
            u_sram_loader.ahb_write_all_lane(32'h000F0704,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH0_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

            u_sram_loader.ahb_write_all_lane(32'h001006E0,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH0_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
            u_sram_loader.ahb_write_all_lane(32'h00100704,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH0_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

            u_sram_loader.ahb_write_all_lane(32'h001206E0,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH1_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
            u_sram_loader.ahb_write_all_lane(32'h00120704,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH1_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

            u_sram_loader.ahb_write_all_lane(32'h001306E0,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH1_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
            u_sram_loader.ahb_write_all_lane(32'h00130704,{24'h000001,{dly_gear,dly[4:0],1'b0}}); //CH1_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8
            //data_write=512'h00112233_44556677_8899aabb_ccddeeff_00112233_44556677_8899aabb_ccddeeff_ffeeddcc_bbaa9988_77665544_33221100_ffeeddcc_bbaa9988_77665544_33221100;
            if(dly==0) write_read_dram_fifo(data_write);
            else rewrite_read_fifo();
            read_dfi_egress_data(egress_data);
            data_read[255:0]={egress_data[7:0],egress_data[87:80],egress_data[167:160],egress_data[247:240]
                            ,egress_data[17:10],egress_data[97:90],egress_data[177:170],egress_data[257:250]
                            ,egress_data[27:20],egress_data[107:100],egress_data[187:180],egress_data[267:260]
                            ,egress_data[37:30],egress_data[117:110],egress_data[197:190],egress_data[277:270]
                            ,egress_data[47:40],egress_data[127:120],egress_data[207:200],egress_data[287:280]
                            ,egress_data[57:50],egress_data[137:130],egress_data[217:210],egress_data[297:290]
                            ,egress_data[67:60],egress_data[147:140],egress_data[227:220],egress_data[307:300]
                            ,egress_data[77:70],egress_data[157:150],egress_data[237:230],egress_data[317:310]};
            read_dfi_egress_data(egress_data);
            data_read[511:256]={egress_data[7:0],egress_data[87:80],egress_data[167:160],egress_data[247:240]
                            ,egress_data[17:10],egress_data[97:90],egress_data[177:170],egress_data[257:250]
                            ,egress_data[27:20],egress_data[107:100],egress_data[187:180],egress_data[267:260]
                            ,egress_data[37:30],egress_data[117:110],egress_data[197:190],egress_data[277:270]
                            ,egress_data[47:40],egress_data[127:120],egress_data[207:200],egress_data[287:280]
                            ,egress_data[57:50],egress_data[137:130],egress_data[217:210],egress_data[297:290]
                            ,egress_data[67:60],egress_data[147:140],egress_data[227:220],egress_data[307:300]
                            ,egress_data[77:70],egress_data[157:150],egress_data[237:230],egress_data[317:310]};
            if(data_read!=data_write) begin
                $display ("[%t] get read fifo data [%h]",$time,data_read);
                $display ("[%t]  expect write data [%h]",$time,data_write);
                eye_map[15][dly]=1;
            end else begin
                eye_map[15][dly]=0;
            end

            $display("######## Current Process #######");
            for (int n=0;n<=dly;n++) begin
                if(eye_map[15][n]==1) $write("#");
                else $write(" ");
            end
            $write("<-");
            $write("\n");
        end

        //DQS RX Delay Set 
        for(int g=0;g<32;g++) begin
            if(eye_map[15][g]==0) dq_drvr_dly_ctrl_lower=(g<dq_drvr_dly_ctrl_lower)?g:dq_drvr_dly_ctrl_lower;
            else dq_drvr_dly_ctrl_upper=(g<dq_drvr_dly_ctrl_upper)?g:dq_drvr_dly_ctrl_upper;
        end
        dq_drvr_dly_ctrl_point=dq_drvr_dly_ctrl_upper+dq_drvr_dly_ctrl_lower;
        dq_drvr_dly_ctrl_set_point={dly_gear,dq_drvr_dly_ctrl_point};
        //DQ LPDE
        u_sram_loader.ahb_write_all_lane(32'h000F06E0,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH0_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0704,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH0_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001006E0,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH0_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100704,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH0_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001206E0,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH1_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120704,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH1_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001306E0,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH1_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130704,{24'h000001,dq_drvr_dly_ctrl_set_point}); //CH1_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8
        $display("Lower Bound = [0x%h], Upper Bound = [0x%h]",{dly_gear,dq_drvr_dly_ctrl_lower,1'b0},{dly_gear,dq_drvr_dly_ctrl_upper,1'b0});
        $display("Setting TX DQ DRVR DELAY CTRL as [0x%h]",dq_drvr_dly_ctrl_set_point);

        $display("######## Write Training #########");
        $display("########## Eye Diagram #########");
        $display(" ");
        for(int k=15;k>=15;k--) begin
            for (int j=0;j<32;j++) begin
                if(eye_map[k][j]==1) $write("#");
                else $write(" ");
            end
            $write("\n");
        end

        $display(" ");
        $display("####### Eye Diagram End  #######");
    end
endtask

task rewrite_read_fifo();
    begin 
        //need to read once to update rbin_q
        //load start_ptr=0
        u_sram_loader.ahb_write(32'h000D0004,32'h00000012); 
        //release tsbkt to read twice
        u_sram_loader.ahb_write(32'h000D0008,32'h00000012); 
        //now wptr=6 rptr=0
        //release load_ptr
        u_sram_loader.ahb_write(32'h000D0004,32'h00000010); 
        //reset tsbkt
        u_sram_loader.ahb_write(32'h000D0008,32'h0001001e);  //ts_brkpt enable , val=0x12
        //equivalent to load all previous things into FIFO
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask

task write_read_dram_fifo();
    input bit [511:0] data_write;
    begin
    //clr wr_fifo and rd_fifo
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3132); //TS_EN=0, TS_RESET=1, WDATA_CLR=1, WDATA_HOLD=1, RDATA_CLR=1, BUF_CLK_EN=1
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        //enable ts_brkpt
        u_sram_loader.ahb_write(32'h000D0008,32'h0001001e);  //ts_brkpt enable , val=0x12
        //send MPC RDQCT 1000011b
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f00               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,{1'b0,1'b1,5'b00000}  //dfi_address_p45   //mpc-1
        ,{1'b0,6'b000111}         //dfi_address_p67 //mpc-2  write_fifo
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h000f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,1'b0,5'b10010}  //dfi_address_p01 //cas-1
        ,7'h00                  //dfi_address_p23 //cas-2
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h3//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01 //cas-1
        ,7'h00                  //dfi_address_p23 //cas-2
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h6//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'hC0                  //dfi_wrdata_en_pN  //write_preamble
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h7//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'hff                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,data_write[255:0]       //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h8//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN  
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,data_write[511:256]    //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h9//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        //read fifo
         //send MPC RDQCT 1000011b
        send_dfi_ingress_data(16'hf//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'hf000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,{1'b0,1'b1,5'b00000}  //dfi_address_p67   //mpc-1
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h10//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h00f0               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,6'b000001}         //dfi_address_p01 //mpc-2 read_fifo
        ,{1'b0,1'b0,5'b10010}  //dfi_address_p23 //cas-1
        ,7'h00                  //dfi_address_p45 //cas-2
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h11//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01 //cas-1
        ,7'h00                  //dfi_address_p23 //cas-2
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );


        send_dfi_ingress_data(16'h1b//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h1c//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN  
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h1d//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN  
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
        //after brkpt
        send_dfi_ingress_data(16'h1f//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN  
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask

task write_training_skip();
    input [7:0] dq_dly_ctrl;
    begin
        //DQ LPDE
        u_sram_loader.ahb_write_all_lane(32'h000F06E0,{24'h000001,dq_dly_ctrl}); //CH0_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0704,{24'h000001,dq_dly_ctrl}); //CH0_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001006E0,{24'h000001,dq_dly_ctrl}); //CH0_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100704,{24'h000001,dq_dly_ctrl}); //CH0_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001206E0,{24'h000001,dq_dly_ctrl}); //CH1_DQ0__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120704,{24'h000001,dq_dly_ctrl}); //CH1_DQ0__DQ_TX_LPDE_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h001306E0,{24'h000001,dq_dly_ctrl}); //CH1_DQ1__DQ_TX_LPDE_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130704,{24'h000001,dq_dly_ctrl}); //CH1_DQ1__DQ_TX_LPDE_M0_R1_CFG_0-8
    end
endtask

task read_dq_calibration_training_skip();
    input [7:0] rcvr_dly_ctrl_set_point;
    begin
        u_sram_loader.ahb_write(32'h000F081C,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ0_DQS_RX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h0010081C,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ1_DQS_RX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0824,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ0_DQS_RX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100824,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ1_DQS_RX_IO_M0_R1_CFG_1
    end
endtask

task read_dq_calibration_training();
    input bit [3:0] vref_lower;
    bit [31:0] eye_map [0:15];
    bit [447:0] egress_data;
    bit [7:0] rcvr_dly_ctrl;
    bit [7:0] dq0_dbi_egress; //first should be 01011010 second should be 00111100
    bit [7:0] vref;
    bit [4:0] rcvr_dly_ctrl_lower;
    bit [4:0] rcvr_dly_ctrl_upper;
    bit [7:0] rcvr_dly_ctrl_set_point;
    begin
        $display ("[%t] #########  RD DQ Calibration Training Start   #########",$time);
        rcvr_dly_ctrl_lower=31;
        rcvr_dly_ctrl_upper=31;
        for(int h=15;h>=vref_lower;h--) begin
            vref={h[3:0],4'h0};
            //enable and set VREF
            u_sram_loader.ahb_write(32'h00090008,{24'h000002,vref});
            u_sram_loader.ahb_write(32'h0009000C,{24'h000002,vref});
            u_sram_loader.wait_until_empty();
            for (int i=0;i<32;i++) begin
                rcvr_dly_ctrl={i[4:0],3'd0};
                $display("################### [V Iteration %0d]  [T Iteration %0d], Vref=[0x%0h] ,rcvr_dly_ctrl=[0x%h]  #####################",h,i,vref,rcvr_dly_ctrl);
                //DQS RX Delay Set
                u_sram_loader.ahb_write(32'h000F081C,{16'h0000,rcvr_dly_ctrl,rcvr_dly_ctrl}); //Ch0_DQ0_DQS_RX_IO_M0_R0_CFG_1
                u_sram_loader.ahb_write(32'h0010081C,{16'h0000,rcvr_dly_ctrl,rcvr_dly_ctrl}); //Ch0_DQ1_DQS_RX_IO_M0_R0_CFG_1
                u_sram_loader.ahb_write(32'h000F0824,{16'h0000,rcvr_dly_ctrl,rcvr_dly_ctrl}); //Ch0_DQ0_DQS_RX_IO_M0_R1_CFG_1
                u_sram_loader.ahb_write(32'h00100824,{16'h0000,rcvr_dly_ctrl,rcvr_dly_ctrl}); //Ch0_DQ1_DQS_RX_IO_M0_R1_CFG_1
                /*
                u_sram_loader.ahb_write(32'h0012081C,32'h00000000); //Ch1_DQ0_DQS_RX_IO_M0_R0_CFG_0
                u_sram_loader.ahb_write(32'h0013081C,32'h00000000); //Ch1_DQ1_DQS_RX_IO_M0_R0_CFG_0
                u_sram_loader.ahb_write(32'h00120824,32'h00000000); //Ch1_DQ0_DQS_RX_IO_M0_R1_CFG_1
                u_sram_loader.ahb_write(32'h00130824,32'h00000000); //Ch1_DQ1_DQS_RX_IO_M0_R1_CFG_1
                */
                rxfifo_clr();
                if(i==0) send_rdqct();
                else reload_rdqct();
                read_dfi_egress_data(egress_data);
                dq0_dbi_egress={egress_data[248],egress_data[258],egress_data[268],egress_data[278]
                                ,egress_data[288],egress_data[298],egress_data[308],egress_data[318]};
                //FIXME: When dqs is delayed too much, we need to tune ren_pi to filter out the rdqs preamble, 
                //else it will pre-toggle rx_sdr_clk to fifo. The output here will be 8'b10010100 and 8'b00001110
                if(dq0_dbi_egress!=8'b01011010) begin
                    eye_map [h][i]=1;
                    $display("########## Current Process #########");
                    for (int n=0;n<=i;n++) begin
                        if(eye_map[h][n]==1) $write("#");
                        else $write(" ");
                    end
                    $write("<-");
                    $write("\n");
                    continue;
                end
                read_dfi_egress_data(egress_data);

                dq0_dbi_egress={egress_data[248],egress_data[258],egress_data[268],egress_data[278]
                                ,egress_data[288],egress_data[298],egress_data[308],egress_data[318]};
                if(dq0_dbi_egress!=8'b00111100) begin
                    eye_map[h][i]=1;
                    $display("########## Current Process #########");
                    for (int n=0;n<=i;n++) begin
                        if(eye_map[h][n]==1) $write("#");
                        else $write(" ");
                    end
                    $write("<-");
                    $write("\n");
                    continue;
                end else begin
                    eye_map[h][i]=0;
                end

                $display("######## Current Process #######");
                for (int n=0;n<=i;n++) begin
                    if(eye_map[h][n]==1) $write("#");
                    else $write(" ");
                end
                $write("<-");
                $write("\n");
            end
        end

        //DQS RX Delay Set 
        for(int g=0;g<32;g++) begin
            if(eye_map[15][g]==0) rcvr_dly_ctrl_lower=(g<rcvr_dly_ctrl_lower)?g:rcvr_dly_ctrl_lower;
            else rcvr_dly_ctrl_upper=(g<rcvr_dly_ctrl_upper)?g:rcvr_dly_ctrl_upper;
        end
        rcvr_dly_ctrl_set_point={(rcvr_dly_ctrl_upper+rcvr_dly_ctrl_lower),2'b00};
        u_sram_loader.ahb_write(32'h000F081C,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ0_DQS_RX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h0010081C,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ1_DQS_RX_IO_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0824,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ0_DQS_RX_IO_M0_R1_CFG_1
        u_sram_loader.ahb_write(32'h00100824,{16'h0000,rcvr_dly_ctrl_set_point,rcvr_dly_ctrl_set_point}); //Ch0_DQ1_DQS_RX_IO_M0_R1_CFG_1
        $display("Lower Bound = [0x%h], Upper Bound = [0x%h]",{rcvr_dly_ctrl_lower,3'd0},{rcvr_dly_ctrl_upper,3'd0});
        $display("Setting RX DQS RCVR DELAY CTRL as [0x%h]",rcvr_dly_ctrl_set_point);
            
        $display("######### Read Training #########");
        $display("########## Eye Diagram #########");
        $display(" ");
        for(int k=15;k>=vref_lower;k--) begin
            for (int j=0;j<32;j++) begin
                if(eye_map[k][j]==1) $write("#");
                else $write(" ");
            end
            $write("\n");
        end
        $display(" ");
        $display("####### Eye Diagram End  #######");
    end
endtask

task reload_rdqct();
    begin 
        //need to read once to update rbin_q
        //load start_ptr=0
        u_sram_loader.ahb_write(32'h000D0004,32'h00000012); 
        //release tsbkt to read twice
        u_sram_loader.ahb_write(32'h000D0008,32'h00000012); 
        //now wptr=6 rptr=0
        //release load_ptr
        u_sram_loader.ahb_write(32'h000D0004,32'h00000010); 
        //reset tsbkt
        u_sram_loader.ahb_write(32'h000D0008,32'h00010012);  //ts_brkpt enable , val=0x12
        //equivalent to load all previous things into FIFO
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask

task send_rdqct();
    begin
        //clr wr_fifo and rd_fifo
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3132); //TS_EN=0, TS_RESET=1, WDATA_CLR=1, WDATA_HOLD=1, RDATA_CLR=1, BUF_CLK_EN=1
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        //enable ts_brkpt
        u_sram_loader.ahb_write(32'h000D0008,32'h00010012);  //ts_brkpt enable , val=0x12
        //send MPC RDQCT 1000011b
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f00               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,{1'b0,1'b1,5'b00000}  //dfi_address_p45   //mpc-1
        ,{1'b0,6'b000011}         //dfi_address_p67 //mpc-2
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h000f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,1'b0,5'b10010}  //dfi_address_p01 //cas-1
        ,7'h00                  //dfi_address_p23 //cas-2
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h3//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01 //cas-1
        ,7'h00                  //dfi_address_p23 //cas-2
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );


        send_dfi_ingress_data(16'hd//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'he//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN  
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'hf//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h10//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
        //after brkpt
        send_dfi_ingress_data(16'h13//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask


task write_leveling();
    begin
        $display ("[%t] #########  Write-Leveling Start   #########",$time);
        MRW(2,8'b1011_1111); //set MR[2] op[7]=1 enable write-leveling mode
        //wait tWLDQSEN=20nCK
        repeat(1) @(posedge ref_clk);
        //DQS LPDE
        //CH0 DQ0
        $display ("[%t] #########  CH0 DQ0 Write-Leveling Start   #########",$time);
        wl_send_dqs(0,0,dqs_tx_dly_ctrl_ch0_dq0);
        $display ("[%t] CH0 DQ0 DQS TX DLY_CTRL[7:0]=%h",$time,dqs_tx_dly_ctrl_ch0_dq0);
        //CH0 DQ1
        $display ("[%t] #########  CH0 DQ1 Write-Leveling Start   #########",$time);
        wl_send_dqs(0,1,dqs_tx_dly_ctrl_ch0_dq1);
        $display ("[%t] CH0 DQ1 DQS TX DLY_CTRL[7:0]=%h",$time,dqs_tx_dly_ctrl_ch0_dq1);
        //CH1 DQ0
        $display ("[%t] #########  CH1 DQ0 Write-Leveling Start   #########",$time);
        wl_send_dqs(1,0,dqs_tx_dly_ctrl_ch1_dq0);
        $display ("[%t] CH1 DQ0 DQS TX DLY_CTRL[7:0]=%h",$time,dqs_tx_dly_ctrl_ch1_dq0);
        //CH1 DQ1
        $display ("[%t] #########  CH1 DQ1 Write-Leveling Start   #########",$time);
        wl_send_dqs(1,1,dqs_tx_dly_ctrl_ch1_dq1);
        $display ("[%t] CH1 DQ1 DQS TX DLY_CTRL[7:0]=%h",$time,dqs_tx_dly_ctrl_ch1_dq1);
        repeat(10) @(posedge ref_clk);
        MRW(2,8'b0011_1111); //set MR[2] op[7]=0 exit write-leveling mode
        repeat(10) @(posedge ref_clk);
        $display ("[%t] #########  Write-Leveling End #########",$time);
    end
endtask

task write_leveling_skip();
    bit[7:0] dly_ctrl=8'h14;
    begin
        u_sram_loader.ahb_write(32'h000F0D94,{24'h000001,dly_ctrl[7:0]}); //Ch0_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h000F0D9C,{24'h000001,dly_ctrl[7:0]}); //Ch0_DQ0_DQS_TX_LPDE_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h00100D94,{24'h000001,dly_ctrl[7:0]}); //Ch0_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00100D9C,{24'h000001,dly_ctrl[7:0]}); //Ch0_DQ1_DQS_TX_LPDE_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h00120D94,{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ0_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00120D9C,{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ0_DQS_TX_LPDE_M0_R1_CFG_1

        u_sram_loader.ahb_write(32'h00130D94,{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
        u_sram_loader.ahb_write(32'h00130D9C,{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ1_DQS_TX_LPDE_M0_R1_CFG_1
    end
endtask

task wl_send_dqs();
    input channel;
    input dq;
    output [7:0] dqs_dly_ctrl;
    bit dq_latch;
    bit [7:0] dly_ctrl;
    bit [31:0] channel_offset;
    bit [31:0] dq_offset;
    bit [31:0] sa_data;
    begin
        if(channel==1) channel_offset=32'h00030000;
        else channel_offset=32'h0;
        if(dq==1) dq_offset=32'h00010000;
        else dq_offset=32'h0;
        u_sram_loader.ahb_write((32'h000F0DB4+channel_offset+dq_offset),32'h00000060); //Output enable for CH0/1_DQS0/1, override_select=0
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN  dqs_t=0
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        //tWLWPRE=20nck=5_nPHY_CK
        send_dfi_ingress_data(16'h7//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN //rddata_en
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h55                  //dfi_parity_in_pN //send out 1010
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );

        //RX GB mode
        u_sram_loader.ahb_write((32'h000F07B8+channel_offset+dq_offset),32'h00000085); //Ch0/1_DQ0/1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
        dq_latch=0;
        dly_ctrl=0;
        while(dq_latch==0) begin
            u_sram_loader.ahb_write((32'h000F0D94+channel_offset+dq_offset),{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ1_DQS_TX_LPDE_M0_R0_CFG_1
            u_sram_loader.ahb_write((32'h000F0D9C+channel_offset+dq_offset),{24'h000001,dly_ctrl[7:0]}); //Ch1_DQ1_DQS_TX_LPDE_M0_R1_CFG_1
            u_sram_loader.ahb_read((32'h000F01C8+channel_offset+dq_offset),sa_data);//read sa data
            dq_latch=sa_data[0];
            $display ("[%t] Write-Leveling DQ_LATCH=%b",$time,dq_latch);
            dly_ctrl+=8'h04;
        end
        dqs_dly_ctrl=dly_ctrl;
        u_sram_loader.ahb_write((32'h000F07B8+channel_offset+dq_offset),32'h00000084);
        u_sram_loader.wait_until_empty();
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.ahb_write((32'h000F0DB4+channel_offset+dq_offset),32'h00000041); //disable sw oe for CH0/1_DQS0/1
        u_sram_loader.wait_until_empty();
    end

endtask

task cbt_set();
    begin
        //REN/RCS phase extension
        u_sram_loader.ahb_write(32'h000D0090,32'h00000000); //DFICH0__CTRL5_M0_CFG
        u_sram_loader.ahb_write(32'h000D0094,32'h00000000); //DFICH0__CTRL5_M1_CFG
        //WCS/WEN/WOE phase extension
        u_sram_loader.ahb_write(32'h000D0080,32'h00000000); //_DFICH0__CTRL3_M0_CFG
        u_sram_loader.ahb_write(32'h000D0084,32'h00000000); //_DFICH0__CTRL3_M1_CFG

         //CH0
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0410,32'h11111111); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0434,32'h11111111); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100410,32'h11111111); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100434,32'h11111111); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120410,32'h11111111); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120434,32'h11111111); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130410,32'h11111111); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130434,32'h11111111); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0B50,32'h0); //f //CH0_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0B74,32'h0); //CH0_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00100B50,32'h0); //CH0_DD1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100B74,32'h0); //CH0_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00120B50,32'h0); //CH1_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120B74,32'h0); //CH1_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00130B50,32'h0); //CH1_DQ1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130B74,32'h0); //3 //CH1_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        //RX GB mode
        u_sram_loader.ahb_write(32'h000F07B8,32'h00000085); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001007B8,32'h00000085); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00110950,32'h00000085); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4

        u_sram_loader.ahb_write(32'h001207B8,32'h00000085); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001307B8,32'h00000085); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00140950,32'h00000085); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
    end
endtask

task cbt_set_reverse();
    begin
        //REN/RCS phase extension
        u_sram_loader.ahb_write(32'h000D0090,32'h01040404); //DFICH0__CTRL5_M0_CFG
        u_sram_loader.ahb_write(32'h000D0094,32'h01040404); //DFICH0__CTRL5_M1_CFG

        //WCS/WEN/WOE phase extension
        u_sram_loader.ahb_write(32'h000D0080,32'h000D0D00); //_DFICH0__CTRL3_M0_CFG
        u_sram_loader.ahb_write(32'h000D0084,32'h000D0D00); //_DFICH0__CTRL3_M1_CFG
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0410,32'h22222222); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0434,32'h22222222); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00100410,32'h22222222); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100434,32'h22222222); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8

        //CH1
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(32'h00120410,32'h22222222); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120434,32'h22222222); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(32'h00130410,32'h22222222); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130434,32'h22222222); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h000F0B50,32'hf); //f //CH0_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0B74,32'hf); //CH0_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00100B50,32'hf); //CH0_DD1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100B74,32'hf); //CH0_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS0 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00120B50,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120B74,32'hf); //CH1_DQ0_DQS_TX_DDR_M0_R1_CFG_0-8
        //DQS1 DDR DLY
        u_sram_loader.ahb_write_all_lane(32'h00130B50,32'hf); //CH1_DQ1_DQS_TX_DDR_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130B74,32'hf); //3 //CH1_DQ1_DQS_TX_DDR_M0_R1_CFG_0-8
        
        //RX GB mode
        //use rdqs from pll to latch data from dq[13:8]
        u_sram_loader.ahb_write(32'h000F07B8,32'h00000084); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001007B8,32'h00000084); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00110950,32'h00000084); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4

        u_sram_loader.ahb_write(32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
    end
endtask

bit [5:0] send_pattern;
bit [11:0] read_pattern;

task command_bus_training();
    begin
        cbt_set();
        $display ("[%t] #########  Command Bus Training (CBT) Start   #########",$time);
        //Step 1
        MRW(13,8'b0100_0000); //set MR[13] op[6]=1
        repeat(10) @(posedge ref_clk);
        //Step 2
        MRW(1,8'b1010_1100); //RD postample=1.5*tCK nWR=16 RD_PRE=toggle
        //MRW(1,8'b0010_0100); //RD postample=0.5*tCK nWR=16 RD_PRE=static
        repeat(10) @(posedge ref_clk);
        MRW(2,8'b0011_1111); //RL=36 WL=18
        repeat(10) @(posedge ref_clk);
        //Step 3
        MRW(13,8'b0100_0001); //set MR[13] op[0]=1 entering
        //wait tMRD 
        repeat(10) @(posedge ref_clk);
        //Step 4 drive CKE low, change freq to high freq
        CKE_low();//remember
        repeat(10) @(posedge ref_clk);
        pll_2p1();
        repeat(50) @(posedge ref_clk);
        //Step 5 Vref CS/CA training
        //wait tCAENT=250ns
        repeat(10) @(posedge ref_clk);
        //send valid DQ[6:0]
        cbt_send_vref(6'b011100,1'b1); //setting 011100, range 1
        //wait tREFCA_LONG*5=1250ns
        repeat(50) @(posedge ref_clk);
        send_pattern=$random;
        cbt_send_pattern(send_pattern);
        repeat(5)  @(posedge ref_clk);
        cbt_read_pattern(read_pattern);
        if(read_pattern[5:0]!=send_pattern) begin
            $display("CH0 CBT ERROR: DQ[13:8]=[%b] is not the same with CA[5:0]=[%b]",read_pattern[5:0],send_pattern);
            err_count+=1;
            Finish();
        end
        if(read_pattern[11:6]!=send_pattern) begin
            $display("CH1 CBT ERROR: DQ[13:8]=[%b] is not the same with CA[5:0]=[%b]",read_pattern[11:6],send_pattern);
            err_count+=1;
            Finish();
        end
        //tCKPSTCS=max(7.5ns, 5nCK))
        repeat(10)  @(posedge ref_clk);
        //Step 6 exit training and assert cke
        pll_0p8();
        repeat(10) @(posedge ref_clk);
        CKE_high();
        //wait tFC_long=250ns
        repeat(10) @(posedge ref_clk);
        MRW(13,8'b0100_0000); //set MR[13] op[0]=0 exit CBT training 
        repeat(10) @(posedge ref_clk);
        //Step 7 write trained values to MR12 and MR14
        MRW(12,8'b0101_1100); //set MR[12] op[6]=1 op[5:0]=6'b011100 from STEP_5
        //Step 8
        MRW(13,8'b1100_0000); //set MR[13] op[7]=1 use FSP_OP[1] 
        repeat(10) @(posedge ref_clk);
        $display ("[%t] #########  Command Bus Training (CBT) End   #########",$time);
        cbt_set_reverse();
        repeat(10) @(posedge ref_clk);
    end
endtask


task cbt_read_pattern();
    output [11:0] read_pattern;
    bit [31:0] sa_data;
    begin
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
        #100;
        u_sram_loader.ahb_read(32'h001001C8,sa_data);
        read_pattern[0]=sa_data[0];
        u_sram_loader.ahb_read(32'h001001CC,sa_data);
        read_pattern[1]=sa_data[0];
        u_sram_loader.ahb_read(32'h001001D0,sa_data);
        read_pattern[2]=sa_data[0];
        u_sram_loader.ahb_read(32'h001001D4,sa_data);
        read_pattern[3]=sa_data[0];
        u_sram_loader.ahb_read(32'h001001D8,sa_data);
        read_pattern[4]=sa_data[0];
        u_sram_loader.ahb_read(32'h001001DC,sa_data);
        read_pattern[5]=sa_data[0];

        u_sram_loader.ahb_read(32'h001301C8,sa_data);
        read_pattern[6]=sa_data[0];
        u_sram_loader.ahb_read(32'h001301CC,sa_data);
        read_pattern[7]=sa_data[0];
        u_sram_loader.ahb_read(32'h001301D0,sa_data);
        read_pattern[8]=sa_data[0];
        u_sram_loader.ahb_read(32'h001301D4,sa_data);
        read_pattern[9]=sa_data[0];
        u_sram_loader.ahb_read(32'h001301D8,sa_data);
        read_pattern[10]=sa_data[0];
        u_sram_loader.ahb_read(32'h001301DC,sa_data);
        read_pattern[11]=sa_data[0];
        u_sram_loader.wait_until_empty();
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask

task cbt_send_pattern();
    input [5:0] pattern;
    begin
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h000f               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,{1'b0,pattern}             //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end
endtask

task cbt_send_vref();
    input [5:0] setting;
    input range;
    begin
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'hff                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,{8{9'h0,range,setting,9'h0,range,setting}} //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'hff                  //dfi_wrdata_en_pN
        ,8'h0a                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,{8{9'h0,range,setting,9'h0,range,setting}} //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h3//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h0f                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,{8{9'h0,range,setting,9'h0,range,setting}} //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h4//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                 //dfi_wrdata_pN
        );
        
        //turn on WCK mode to achieve DQ setup and hold
        u_sram_loader.ahb_write(32'h000D0000,32'h000D3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        u_sram_loader.wait_until_empty();
    end

endtask

task MRR();//!!! remember: the number of send_dfi_ingress_data() functions used here should be even! else will cause extra data been written to ingress_fifo
    input [5:0] ma;  // Mode Register address
    input [9:0] addr;
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f0f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,1'b0,5'b01110}  //dfi_address_p01
        ,{1'b0,ma[5:0]}         //dfi_address_p23
        ,{1'b0,addr[8],5'b10010}  //dfi_address_p45
        ,{1'b0,addr[7:2]}         //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h5//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hf0                  //dfi_rddata_en_pN p3
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h6//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'hff                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h7//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h0f                  //dfi_rddata_en_pN p3 p2 
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h8//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end
endtask

task MRW();
    input [5:0] ma;  // Mode Register address
    input [7:0] op;
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0f0f               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,{1'b0,op[7],5'b00110}  //dfi_address_p01
        ,{1'b0,ma[5:0]}         //dfi_address_p23
        ,{1'b0,op[6],5'b10110}  //dfi_address_p45
        ,{1'b0,op[5:0]}         //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end
endtask


task CKE_low();
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end      
endtask

task CKE_high();
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3022); //TS_EN=0, TS_RESET=1, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
        send_dfi_ingress_data(16'h2//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
        u_sram_loader.ahb_write(32'h000D0000,32'h000C3021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end    
endtask


task CKE_initialize();
    begin
        u_sram_loader.ahb_write(32'h000D0000,32'h00002132); //TS_EN=0, TS_RESET=1, WDATA_CLR=1, WDATA_HOLD=1, RDATA_CLR=1, BUF_CLK_EN=1
        u_sram_loader.ahb_write(32'h000D0000,32'h00002020); //TS_EN=0, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1
        send_dfi_ingress_data(16'h1//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'h0000               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'hffff               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'hffff               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );

        send_dfi_ingress_data(16'h10//timestamp
        ,8'hff                  //dfi_dce_pN
        ,16'h0000               //dfi_cs_pN;
        ,16'hffff               //dfi_cke_pN
        ,7'h00                  //dfi_address_p01
        ,7'h00                  //dfi_address_p23
        ,7'h00                  //dfi_address_p45
        ,7'h00                  //dfi_address_p67
        ,8'h00                  //dfi_rddata_en_pN
        ,16'h0000               //dfi_rddata_cs_pN
        ,8'h00                  //dfi_wrdata_en_pN
        ,8'h00                  //dfi_parity_in_pN
        ,16'h0000               //dfi_wrdata_cs_pN
        ,32'h0                  //dfi_wrdata_mask_pN
        ,256'h0                  //dfi_wrdata_pN
        );
    u_sram_loader.ahb_write(32'h000D0000,32'h00003021); //TS_EN=1, TS_RESET=0, WDATA_CLR=0, WDATA_HOLD=1, RDATA_CLR=0, BUF_CLK_EN=1, Buff_mode=1
    end
endtask


task read_dfi_egress_data;
    output [447:0] egress_data; //423
    bit init_en_sta;
    bit init_upd_sta;
    bit eg_en;
    bit read_done;
    bit [31:0] other_csr;
    u_sram_loader.ahb_read(32'h000D0000,ahb_rdata);
    other_csr=ahb_rdata;
    init_en_sta=ahb_rdata[9];
    init_upd_sta=ahb_rdata[10];
    eg_en=init_en_sta;
    u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    while(ahb_rdata[5:4]==2'b01) begin
        u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    end
    read_done=ahb_rdata[6];
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_empty==1'b0);
    u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:11],~init_upd_sta,other_csr[9:0]}); //rdata_upd=toggle
    u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    while(ahb_rdata[6]==read_done) begin
        u_sram_loader.ahb_read(32'h000D000C,ahb_rdata);
    end
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_read_done==1'b1);
    for(int i=0;i<=13;i++) begin
        eg_en=~eg_en;
        u_sram_loader.ahb_read(32'h000D0014,egress_data[i*32+:32]);
        //egress_data[i*32+:32]=lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_rdata;
        u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:11],~init_upd_sta,eg_en,other_csr[8:0]}); //rdata_en=toggle
        u_sram_loader.wait_until_empty();
        //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b1);
        //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b0);
    end
    $display ("[%t] Read Egress Data:.",$time);
    $display (" Timestamp %h.",egress_data[423:408]);
    $display (" dfi_cs_p0[1:0]=2'b%b.",egress_data[407:406]);
    $display (" dfi_cs_p1[1:0]=2'b%b.",egress_data[396:395]);
    $display (" dfi_cs_p2[1:0]=2'b%b.",egress_data[385:384]);
    $display (" dfi_cs_p3[1:0]=2'b%b.",egress_data[374:373]);
    $display (" dfi_cs_p4[1:0]=2'b%b.",egress_data[363:362]);
    $display (" dfi_cs_p5[1:0]=2'b%b.",egress_data[352:351]);
    $display (" dfi_cs_p6[1:0]=2'b%b.",egress_data[341:340]);
    $display (" dfi_cs_p7[1:0]=2'b%b.",egress_data[330:329]);

    $display (" dfi_cke_p0[1:0]=2'b%b.",egress_data[405:404]);
    $display (" dfi_cke_p1[1:0]=2'b%b.",egress_data[394:393]);
    $display (" dfi_cke_p2[1:0]=2'b%b.",egress_data[383:382]);
    $display (" dfi_cke_p3[1:0]=2'b%b.",egress_data[372:371]);
    $display (" dfi_cke_p4[1:0]=2'b%b.",egress_data[361:360]);
    $display (" dfi_cke_p5[1:0]=2'b%b.",egress_data[350:349]);
    $display (" dfi_cke_p6[1:0]=2'b%b.",egress_data[339:338]);
    $display (" dfi_cke_p7[1:0]=2'b%b.",egress_data[328:327]);

    $display (" dfi_address_p0[6:0]=7'b%b.",egress_data[403:397]);
    $display (" dfi_address_p1[6:0]=7'b%b.",egress_data[392:386]);
    $display (" dfi_address_p2[6:0]=7'b%b.",egress_data[381:375]);
    $display (" dfi_address_p3[6:0]=7'b%b.",egress_data[370:364]);
    $display (" dfi_address_p4[6:0]=7'b%b.",egress_data[359:353]);
    $display (" dfi_address_p5[6:0]=7'b%b.",egress_data[348:342]);
    $display (" dfi_address_p6[6:0]=7'b%b.",egress_data[337:331]);
    $display (" dfi_address_p7[6:0]=7'b%b.",egress_data[326:320]);

    $display (" dq0_rdata_valid_p0-7[7:0]=8'b%b.",{egress_data[319],egress_data[309],egress_data[299],egress_data[289],
                                                    egress_data[279],egress_data[269],egress_data[259],egress_data[249]});
    $display (" dq0_rdata_dbi_p0-7[7:0]=8'b%b.",{egress_data[318],egress_data[308],egress_data[298],egress_data[288]
                                                    ,egress_data[278],egress_data[268],egress_data[258],egress_data[248]});
    $display (" dq0_rdata_p0-7[63:0]=0x%h.",{egress_data[317:310],egress_data[307:300]
                                            ,egress_data[297:290],egress_data[287:280]
                                            ,egress_data[277:270],egress_data[267:260]
                                            ,egress_data[257:250],egress_data[247:240]});
    
    $display (" dq1_rdata_valid_p0-7[7:0]=8'b%b.",{egress_data[239],egress_data[229],egress_data[219],egress_data[209],
                                                    egress_data[199],egress_data[189],egress_data[179],egress_data[169]});
    $display (" dq1_rdata_dbi_p0-7[7:0]=8'b%b.",{egress_data[238],egress_data[228],egress_data[218],egress_data[208]
                                                    ,egress_data[198],egress_data[188],egress_data[178],egress_data[168]});
    $display (" dq1_rdata_p0-7[63:0]=0x%h.",{egress_data[237:230],egress_data[227:220]
                                            ,egress_data[217:210],egress_data[207:200]
                                            ,egress_data[197:190],egress_data[187:180]
                                            ,egress_data[177:170],egress_data[167:160]});

    $display (" dq2_rdata_valid_p0-7[7:0]=8'b%b.",{egress_data[159],egress_data[149],egress_data[139],egress_data[129],
                                                    egress_data[119],egress_data[109],egress_data[99],egress_data[89]});
    $display (" dq2_rdata_dbi_p0-7[7:0]=8'b%b.",{egress_data[158],egress_data[148],egress_data[138],egress_data[128]
                                                    ,egress_data[118],egress_data[108],egress_data[98],egress_data[88]});
    $display (" dq2_rdata_p0-7[63:0]=0x%h.",{egress_data[157:150],egress_data[147:140]
                                            ,egress_data[137:130],egress_data[127:120]
                                            ,egress_data[117:110],egress_data[107:100]
                                            ,egress_data[97:90],egress_data[87:80]});

    $display (" dq3_rdata_valid_p0-7[7:0]=8'b%b.",{egress_data[79],egress_data[69],egress_data[59],egress_data[49],
                                                    egress_data[39],egress_data[29],egress_data[19],egress_data[9]});
    $display (" dq3_rdata_dbi_p0-7[7:0]=8'b%b.",{egress_data[78],egress_data[68],egress_data[58],egress_data[48]
                                                    ,egress_data[38],egress_data[28],egress_data[18],egress_data[8]});
    $display (" dq3_rdata_p0-7[63:0]=0x%h.",{egress_data[77:70],egress_data[67:60]
                                            ,egress_data[57:50],egress_data[47:40]
                                            ,egress_data[37:30],egress_data[27:20]
                                            ,egress_data[17:10],egress_data[7:0]});
endtask

task send_dfi_ingress_data;
    input [15:0] timestamp;
    input [7:0] dfi_dce_pN;
    input [15:0] dfi_cs_pN;
    input [15:0] dfi_cke_pN;
    input [6:0] dfi_address_p01;
    input [6:0] dfi_address_p23;
    input [6:0] dfi_address_p45;
    input [6:0] dfi_address_p67;
    input [7:0] dfi_rddata_en_pN;
    input [15:0] dfi_rddata_cs_pN;
    input [7:0] dfi_wrdata_en_pN;
    input [7:0] dfi_parity_in_pN;
    input [15:0] dfi_wrdata_cs_pN;
    input [31:0] dfi_wrdata_mask_pN;
    input [255:0] dfi_wrdata_pN;
    bit [511:0] ingress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit [31:0] other_csr;
    bit ig_en;
    bit init_done_sta;
    ingress_data={16'd0,timestamp,
                dfi_dce_pN[0],
                dfi_cs_pN[1:0],
                dfi_cke_pN[1:0],
                dfi_address_p01,
                dfi_dce_pN[1],
                dfi_cs_pN[3:2],
                dfi_cke_pN[3:2],
                dfi_address_p01,
                dfi_dce_pN[2],
                dfi_cs_pN[5:4],
                dfi_cke_pN[5:4],
                dfi_address_p23,
                dfi_dce_pN[3],
                dfi_cs_pN[7:6],
                dfi_cke_pN[7:6],
                dfi_address_p23,
                dfi_dce_pN[4],
                dfi_cs_pN[9:8],
                dfi_cke_pN[9:8],
                dfi_address_p45,
                dfi_dce_pN[5],
                dfi_cs_pN[11:10],
                dfi_cke_pN[11:10],
                dfi_address_p45,
                dfi_dce_pN[6],
                dfi_cs_pN[13:12],
                dfi_cke_pN[13:12],
                dfi_address_p67,
                dfi_dce_pN[7],
                dfi_cs_pN[15:14],
                dfi_cke_pN[15:14],
                dfi_address_p67
      //p0
      ,dfi_rddata_en_pN[0]
      ,dfi_rddata_cs_pN[1:0]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[0]
      ,dfi_parity_in_pN[0]
      ,dfi_wrdata_cs_pN[1:0]
      ,dfi_wrdata_mask_pN[0]
      ,dfi_wrdata_pN[7:0]
      ,dfi_wrdata_mask_pN[1]
      ,dfi_wrdata_pN[15:8]
      ,dfi_wrdata_mask_pN[2]
      ,dfi_wrdata_pN[23:16]
      ,dfi_wrdata_mask_pN[3]
      ,dfi_wrdata_pN[31:24]
      //p1
      ,dfi_rddata_en_pN[1]
      ,dfi_rddata_cs_pN[3:2]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[1]
      ,dfi_parity_in_pN[1]
      ,dfi_wrdata_cs_pN[3:2]
      ,dfi_wrdata_mask_pN[4]
      ,dfi_wrdata_pN[39:32]
      ,dfi_wrdata_mask_pN[5]
      ,dfi_wrdata_pN[47:40]
      ,dfi_wrdata_mask_pN[6]
      ,dfi_wrdata_pN[55:48]
      ,dfi_wrdata_mask_pN[7]
      ,dfi_wrdata_pN[63:56]
      //p2
      ,dfi_rddata_en_pN[2]
      ,dfi_rddata_cs_pN[5:4]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[2]
      ,dfi_parity_in_pN[2]
      ,dfi_wrdata_cs_pN[5:4]
      ,dfi_wrdata_mask_pN[8]
      ,dfi_wrdata_pN[71:64]
      ,dfi_wrdata_mask_pN[9]
      ,dfi_wrdata_pN[79:72]
      ,dfi_wrdata_mask_pN[10]
      ,dfi_wrdata_pN[87:80]
      ,dfi_wrdata_mask_pN[11]
      ,dfi_wrdata_pN[95:88]
      //p3
      ,dfi_rddata_en_pN[3]
      ,dfi_rddata_cs_pN[7:6]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[3]
      ,dfi_parity_in_pN[3]
      ,dfi_wrdata_cs_pN[7:6]
      ,dfi_wrdata_mask_pN[12]
      ,dfi_wrdata_pN[103:96]
      ,dfi_wrdata_mask_pN[13]
      ,dfi_wrdata_pN[111:104]
      ,dfi_wrdata_mask_pN[14]
      ,dfi_wrdata_pN[119:112]
      ,dfi_wrdata_mask_pN[15]
      ,dfi_wrdata_pN[127:120]
      //p4
      ,dfi_rddata_en_pN[4]
      ,dfi_rddata_cs_pN[9:8]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[4]
      ,dfi_parity_in_pN[4]
      ,dfi_wrdata_cs_pN[9:8]
      ,dfi_wrdata_mask_pN[16]
      ,dfi_wrdata_pN[135:128]
      ,dfi_wrdata_mask_pN[17]
      ,dfi_wrdata_pN[143:136]
      ,dfi_wrdata_mask_pN[18]
      ,dfi_wrdata_pN[151:144]
      ,dfi_wrdata_mask_pN[19]
      ,dfi_wrdata_pN[159:152]
      //p5
      ,dfi_rddata_en_pN[5]
      ,dfi_rddata_cs_pN[11:10]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[5]
      ,dfi_parity_in_pN[5]
      ,dfi_wrdata_cs_pN[11:10]
      ,dfi_wrdata_mask_pN[20]
      ,dfi_wrdata_pN[167:160]
      ,dfi_wrdata_mask_pN[21]
      ,dfi_wrdata_pN[175:168]
      ,dfi_wrdata_mask_pN[22]
      ,dfi_wrdata_pN[183:176]
      ,dfi_wrdata_mask_pN[23]
      ,dfi_wrdata_pN[191:184]
      //p6
      ,dfi_rddata_en_pN[6]
      ,dfi_rddata_cs_pN[13:12]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[6]
      ,dfi_parity_in_pN[6]
      ,dfi_wrdata_cs_pN[13:12]
      ,dfi_wrdata_mask_pN[24]
      ,dfi_wrdata_pN[199:192]
      ,dfi_wrdata_mask_pN[25]
      ,dfi_wrdata_pN[207:200]
      ,dfi_wrdata_mask_pN[26]
      ,dfi_wrdata_pN[215:208]
      ,dfi_wrdata_mask_pN[27]
      ,dfi_wrdata_pN[223:216]
      //p7
      ,dfi_rddata_en_pN[7]
      ,dfi_rddata_cs_pN[15:14]
      ,2'b0
      ,1'b0
      ,2'b0
      ,dfi_wrdata_en_pN[7]
      ,dfi_parity_in_pN[7]
      ,dfi_wrdata_cs_pN[15:14]
      ,dfi_wrdata_mask_pN[28]
      ,dfi_wrdata_pN[231:224]
      ,dfi_wrdata_mask_pN[29]
      ,dfi_wrdata_pN[239:232]
      ,dfi_wrdata_mask_pN[30]
      ,dfi_wrdata_pN[247:240]
      ,dfi_wrdata_mask_pN[31]
      ,dfi_wrdata_pN[255:248]
    };

    u_sram_loader.ahb_read(32'h000D0000,ahb_rdata);
    init_en_sta=ahb_rdata[6];
    init_upd_sta=ahb_rdata[7];
    other_csr=ahb_rdata;
    ig_en=init_en_sta;
    for(int i=15;i>=0;i--) begin
        ig_en=~ig_en;
        u_sram_loader.ahb_write(32'h000D0010,ingress_data[i*32+:32]);
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:8],init_upd_sta,ig_en,other_csr[5:0]}); 
        u_sram_loader.wait_until_empty();
    end
    //upd
    u_sram_loader.ahb_write(32'h000D0000,{other_csr[31:8],~init_upd_sta,ig_en,other_csr[5:0]}); //wdata_upd=toggle
    u_sram_loader.wait_until_empty();
    u_sram_loader.ahb_read(32'h00D0000,ahb_rdata);
    //while(ahb_rdata[4]!=(~init_done_sta)) u_sram_loader.ahb_read(32'h00150014,ahb_rdata);
    //wait(lpddr4_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_ig_write_done==(~init_done_sta));
endtask

bit [4:0] ZQ_NCAL_index;
bit [5:0] ZQ_PCAL_index;
bit [31:0] ZQ_index;

task ibias_ldo_initialize();
    begin
        $display ("[%t] #########  IBIAS/LDO Initializing   #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(32'h0009000C,32'h000002FA);
    end
endtask

task ZQ_calibration();
    begin
        $display ("[%t] #########  ZQ Calibration   #########",$time);
        //ZQCAL process
        u_sram_loader.ahb_write(32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(32'h00090014,ahb_rdata);
        end
    end
endtask

task pll_initialize_0p8();
    begin     
        $display ("[%t] #########  PLL 800MHz Initializing   #########",$time);   
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        end
        //VCO1
        //2GHz 
        //u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        //u_sram_loader.ahb_write(32'h00098044,32'h08249F01);

        //850MHz
        u_sram_loader.ahb_write(32'h00098048,32'h0202C03F);
        u_sram_loader.ahb_write(32'h00098044,32'h0814910D);
        //VCO2
        //u_sram_loader.ahb_write(32'h00098070,32'h040DC080);
        //u_sram_loader.ahb_write(32'h0009806C,32'h08249F01);
        u_sram_loader.ahb_write(32'h00098070,32'h0202C03F);
        u_sram_loader.ahb_write(32'h0009806C,32'h0814910D);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        //u_sram_loader.ahb_write(32'h00098058,32'h04000037);
        //u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098058,32'h04000015);
        u_sram_loader.ahb_write(32'h0009803C,32'h00006741);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //VCO2 PLL
        //u_sram_loader.ahb_write(32'h00098080,32'h04000037);
        //u_sram_loader.ahb_write(32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098080,32'h04000015);
        u_sram_loader.ahb_write(32'h00098064,32'h00006741);
        u_sram_loader.ahb_write(32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL 800MHz Initialize Done   #########",$time);
    end
endtask

task pll_0p8();
    begin     
        $display ("[%t] #########  PLL 800MHz Changing   #########",$time);   
        //VCO1
        //2GHz 
        //u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        //u_sram_loader.ahb_write(32'h00098044,32'h08249F01);

        //850MHz
        u_sram_loader.ahb_write(32'h00098048,32'h0202C03F);
        u_sram_loader.ahb_write(32'h00098044,32'h0814910D);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        //VCO1 PLL
        //u_sram_loader.ahb_write(32'h00098058,32'h04000037);
        //u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098058,32'h04000015);
        u_sram_loader.ahb_write(32'h0009803C,32'h00006741);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        $display ("[%t] #########  PLL 800MHz Changing Done   #########",$time);
    end
endtask

task pll_initialize_2p1();
    begin        

        $display ("[%t] #########  PLL 2133MHz Initializing   #########",$time); 
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        end
        //VCO1
        //2GHz 
        u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL 2133MHz Initialize Done   #########",$time);
    end
endtask

task pll_2p1();
    begin        
        $display ("[%t] #########  PLL 2133MHz Changing  #########",$time); 
        //VCO1
        //2GHz 
        u_sram_loader.ahb_write(32'h00098048,32'h040DC080);
        //disable FLL
        //u_sram_loader.ahb_write(32'h00098044,32'h08249F00);
        u_sram_loader.ahb_write(32'h00098044,32'h08249F01);
        //VCO1 PLL
        u_sram_loader.ahb_write(32'h00098058,32'h04000037); //2500MHz??
        u_sram_loader.ahb_write(32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(32'h00098000,32'h00000016);
        u_sram_loader.ahb_write(32'h00098004,32'h00000001);

        //reset PLL
        u_sram_loader.ahb_write(32'h000980A8,32'h00000004);
        u_sram_loader.ahb_write(32'h000980A8,32'h00000000);
        //wait 
        u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
            u_sram_loader.ahb_read(32'h00098044,ahb_rdata);
        end
        //wait core ready
        u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(32'h0009800C,ahb_rdata);
        end

        //reset clock divider
        u_sram_loader.ahb_write(32'h000A0030,32'h00000080); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        u_sram_loader.ahb_read(32'h000A0030,ahb_rdata); //FSW_CSP_1_CFG  div_rst_ovr_value=1
        while(ahb_rdata[7]!=1) begin
            u_sram_loader.ahb_read(32'h000A0030,ahb_rdata);
        end
        u_sram_loader.ahb_write(32'h000A0030,32'h00000000); //FSW_CSP_1_CFG  div_rst_ovr_value=0

        $display ("[%t] #########  PLL 2133MHz Changing Done   #########",$time);
    end
endtask

task link_initialize();
    begin
        $display ("[%t] #########  Link Initializing   #########",$time);
        //ucie disable
        u_sram_loader.ahb_write(32'h00150000,32'h00100000);
        //ucien
        u_sram_loader.ahb_write(32'h00150024,32'h00000800);
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge lpddr4_tb.ahb_clk);

        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(32'h00120290,32'h00004040);
        u_sram_loader.ahb_write(32'h001202B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001202D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(32'h00120294,32'h00004040);
        u_sram_loader.ahb_write(32'h001202B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001202D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(32'h00130290,32'h00004040);
        u_sram_loader.ahb_write(32'h001302B0,32'h00004040);
        u_sram_loader.ahb_write(32'h001302D0,32'h00004040);
        u_sram_loader.ahb_write(32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(32'h00130294,32'h00004040);
        u_sram_loader.ahb_write(32'h001302B4,32'h00004040);
        u_sram_loader.ahb_write(32'h001302D4,32'h00004040);
        u_sram_loader.ahb_write(32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(32'h00140318,32'h00004040);
        u_sram_loader.ahb_write(32'h00140338,32'h00004040);
        u_sram_loader.ahb_write(32'h00140358,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(32'h0014031C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014033C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014035C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(32'h00140A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge lpddr4_tb.ahb_clk);
        //enable all RX PI__CH0_DQ0
        u_sram_loader.ahb_write(32'h000F07F4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07D4,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07E4,32'h00004040);

        u_sram_loader.ahb_write(32'h000F07F8,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07D8,32'h00004040);
        u_sram_loader.ahb_write(32'h000F07E8,32'h00004040);

        //enable all RX PI__CH0_DQ1
        u_sram_loader.ahb_write(32'h001007F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001007D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001007E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001007F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001007D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001007E8,32'h00004040);

        //enable all RX PI__CH0_CA
        u_sram_loader.ahb_write(32'h0011098C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011096C,32'h00004040);
        u_sram_loader.ahb_write(32'h0011097C,32'h00004040);

        u_sram_loader.ahb_write(32'h00110990,32'h00004040);
        u_sram_loader.ahb_write(32'h00110970,32'h00004040);
        u_sram_loader.ahb_write(32'h00110980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(32'h001207F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001207D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001207E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001207F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001207D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001207E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(32'h001307F4,32'h00004040);
        u_sram_loader.ahb_write(32'h001307D4,32'h00004040);
        u_sram_loader.ahb_write(32'h001307E4,32'h00004040);

        u_sram_loader.ahb_write(32'h001307F8,32'h00004040);
        u_sram_loader.ahb_write(32'h001307D8,32'h00004040);
        u_sram_loader.ahb_write(32'h001307E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(32'h0014098C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014096C,32'h00004040);
        u_sram_loader.ahb_write(32'h0014097C,32'h00004040);

        u_sram_loader.ahb_write(32'h00140990,32'h00004040);
        u_sram_loader.ahb_write(32'h00140970,32'h00004040);
        u_sram_loader.ahb_write(32'h00140980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001201F0,32'h00000004); //Ch1_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00120880,32'h00000004); //Ch1_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h001301F0,32'h00000004); //Ch1_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00130880,32'h00000004); //Ch1_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(32'h00140258,32'h00000004); //Ch1_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(32'h001409F8,32'h00000004); //Ch1_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F0380,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100380,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110428,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        
        //DQS
        u_sram_loader.ahb_write_all_lane(32'h000F0A30,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100A30,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AA8,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R0_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h00120380,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130380,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001203A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h001303A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140428,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140454,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h00120A30,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130A30,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AA8,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R0_CFG_0

        u_sram_loader.ahb_write_all_lane(32'h00120A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AAC,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(32'h000F0530,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100530,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110638,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h000F0BE0,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100BE0,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00110AD8,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R0_CFG

        u_sram_loader.ahb_write_all_lane(32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG

        u_sram_loader.ahb_write_all_lane(32'h00120530,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130530,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00120554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140638,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00140664,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(32'h00120BE0,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130BE0,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R0_CFG_0-8
        u_sram_loader.ahb_write(32'h00140AD8,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R0_CFG

        u_sram_loader.ahb_write_all_lane(32'h00120C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(32'h00130C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(32'h00140ADC,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG


        //RX GB mode
        u_sram_loader.ahb_write(32'h000F07B8,32'h00000084); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001007B8,32'h00000084); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00110950,32'h00000084); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4

        u_sram_loader.ahb_write(32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge lpddr4_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(32'h000F0000,32'h00000100); //Ch0_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(32'h00100000,32'h00000100); //Ch0_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(32'h00110000,32'h00000100); //Ch0_CA_FIFO_CLR

        u_sram_loader.ahb_write(32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge lpddr4_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(32'h000F0000,32'h00000000); //Ch0_DQ0_FIFO_EN
        u_sram_loader.ahb_write(32'h00100000,32'h00000000); //Ch0_DQ1_FIFO_EN
        u_sram_loader.ahb_write(32'h00110000,32'h00000000); //Ch0_CA_FIFO_EN

        u_sram_loader.ahb_write(32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();

        $display ("[%t] #########  Link Initialize Done   #########",$time);
        $finish;
    end
endtask


// ----------------------------------------------------
    initial begin 
        $vcdpluson(0,lpddr4_tb);
//        uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_0",my_mosi_0);
//		uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_1", my_mosi_1);
//        uvm_config_db #(virtual dfi_lpddr4_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_lpddr4_vif", dfi_lpddr4_if);
//`ifdef TIMING_CHECK
//        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", u_mc_top.u_mc_core.dfi_if);
//`endif
//        run_test("mc_top_basic_test");
        $finish;
    end
// ----------------------------------------------------

endmodule
