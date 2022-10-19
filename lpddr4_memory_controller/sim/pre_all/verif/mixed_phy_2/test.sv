task link_initialize();
    input [1:0] die_index;
    input ch1_tx_rx_n;
    input ch0_tx_rx_n;
    bit [3:0] txrx_mode;
    string ch0_config;
    string ch1_config;
    begin
        ch0_config=ch0_tx_rx_n?"TX":"RX";
        ch1_config=ch1_tx_rx_n?"TX":"RX";
        txrx_mode[1:0]=ch0_tx_rx_n?2'b10:2'b01;
        txrx_mode[3:2]=ch1_tx_rx_n?2'b10:2'b01;
        $display ("[%t] #########  Initializing DIE %d with CH0 %s #########",$time,die_index,ch0_config);
        //enable IBIAS
        u_sram_loader.ahb_write(die_index,32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(die_index,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(die_index,32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(die_index,32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(die_index,32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(die_index,32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(die_index,32'h0009000C,32'h000002FA);
        //ZQCAL process
        u_sram_loader.ahb_write(die_index,32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(die_index,32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(die_index,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(die_index,32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(die_index,32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(die_index,32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(die_index,32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(die_index,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(die_index,32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(die_index,32'h00090014,ahb_rdata);
        end
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(die_index,32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(die_index,32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(die_index,32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(die_index,32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(die_index,32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(die_index,32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(die_index,32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(die_index,32'h0009800C,ahb_rdata);
        end
        //VCO1
        u_sram_loader.ahb_write(die_index,32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(die_index,32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(die_index,32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(die_index,32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(die_index,32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(die_index,32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(die_index,32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(die_index,32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(die_index,32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(die_index,32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(die_index,32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(die_index,32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(die_index,32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(die_index,32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(die_index,32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(die_index,32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(die_index,32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(die_index,32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(die_index,32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(die_index,32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(die_index,32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(die_index,32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:tx/rx ch1:rx/tx
        u_sram_loader.ahb_write(die_index,32'h00150000,{28'h0011101,txrx_mode[3:0]});
        if(ch0_tx_rx_n==1) CH_TX_initialize(0);
        else CH_RX_initialize(0);

        if(ch1_tx_rx_n==1) CH_TX_initialize(1);
        else CH_RX_initialize(1);
        $display ("[%t] #########  Die %d Initializing Done   #########",$time,die_index);
    end
endtask

task CH_TX_initialize();
    input channel_index;
    bit [31:0] ch_offset;
    begin
        ch_offset=channel_index?32'h00030000:32'h00000000;
        //TX
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(die_index,channel_index+32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(die_index,channel_index+32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(die_index,channel_index+32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,channel_index+32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(die_index,channel_index+32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
    end
endtask

task CH_RX_initialize();
    input channel_index;
    bit [31:0] ch_offset_neg;
    begin
        ch_offset_neg=channel_index?32'h00000000:32'h00030000;
        //RX
        //enable all TX DQS PI__CH1_DQ0
        u_sram_loader.ahb_write(die_index,32'h00120920-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120940-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120960-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120970-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120980-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h00120924-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120944-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120964-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120974-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00120984-ch_offset_neg,32'h00004040);

        //enable all TX DQS PI__CH1_DQ1
        u_sram_loader.ahb_write(die_index,32'h00130920-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130940-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130960-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130970-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130980-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h00130924-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130944-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130964-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130974-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00130984-ch_offset_neg,32'h00004040);

        //enable all TX DQS PI__CH1_CA
        u_sram_loader.ahb_write(die_index,32'h00140A18-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140A38-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140A58-ch_offset_neg,32'h00004040); 
        u_sram_loader.ahb_write(die_index,32'h00140A68-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140A78-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h00140A1C-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140A3C-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140A5C-ch_offset_neg,32'h00004040); 
        u_sram_loader.ahb_write(die_index,32'h00110A6C-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00110A7C-ch_offset_neg,32'h00004040);

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(die_index,32'h001207F4-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001207D4-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001207E4-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h001207F8-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001207D8-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001207E8-ch_offset_neg,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(die_index,32'h001307F4-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001307D4-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001307E4-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h001307F8-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001307D8-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h001307E8-ch_offset_neg,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(die_index,32'h0014098C-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h0014096C-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h0014097C-ch_offset_neg,32'h00004040);

        u_sram_loader.ahb_write(die_index,32'h00140990-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140970-ch_offset_neg,32'h00004040);
        u_sram_loader.ahb_write(die_index,32'h00140980-ch_offset_neg,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set RX AC path mode
        u_sram_loader.ahb_write(die_index,32'h0012083C-ch_offset_neg,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(die_index,32'h0013083C-ch_offset_neg,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(die_index,32'h001409C4-ch_offset_neg,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(die_index,32'h001207B8-ch_offset_neg,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(die_index,32'h001307B8-ch_offset_neg,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(die_index,32'h00140950-ch_offset_neg,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(die_index,32'h00120000-ch_offset_neg,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(die_index,32'h00130000-ch_offset_neg,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(die_index,32'h00140000-ch_offset_neg,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(die_index,32'h00120000-ch_offset_neg,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(die_index,32'h00130000-ch_offset_neg,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(die_index,32'h00140000-ch_offset_neg,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
    end
endtask