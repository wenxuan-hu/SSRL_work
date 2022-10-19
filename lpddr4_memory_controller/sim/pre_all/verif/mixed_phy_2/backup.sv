task link_initialize_0();
    begin
        $display ("[%t] #########  Initializing DIE 0  #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(0,32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(0,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(0,32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(0,32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(0,32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(0,32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(0,32'h0009000C,32'h000002FA);
        //ZQCAL process
        u_sram_loader.ahb_write(0,32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(0,32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(0,32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(0,32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(0,32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(0,32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        end
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(0,32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(0,32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(0,32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(0,32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(0,32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(0,32'h0009800C,ahb_rdata);
        end
        //VCO1
        u_sram_loader.ahb_write(0,32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(0,32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(0,32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(0,32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(0,32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(0,32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(0,32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(0,32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(0,32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(0,32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(0,32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(0,32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(0,32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(0,32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(0,32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(0,32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(0,32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(0,32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(0,32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(0,32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:tx ch1:rx
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111016);
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(0,32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(0,32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(0,32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(0,32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(0,32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(0,32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(0,32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A7C,32'h00004040);

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(0,32'h001207F4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207E4,32'h00004040);

        u_sram_loader.ahb_write(0,32'h001207F8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207D8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(0,32'h001307F4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307E4,32'h00004040);

        u_sram_loader.ahb_write(0,32'h001307F8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307D8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(0,32'h0014098C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0014096C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0014097C,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00140990,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(0,32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(0,32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(0,32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(0,32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(0,32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        u_sram_loader.ahb_write(0,32'h0012083C,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(0,32'h0013083C,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(0,32'h001409C4,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(0,32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(0,32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(0,32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(0,32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(0,32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(0,32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(0,32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(0,32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(0,32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
        $display ("[%t] #########  Die 0 Initializing Done   #########",$time);
    end
endtask

task link_initialize_1();
    begin
        $display ("[%t] #########  Initializing Die 1   #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(1,32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(1,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(1,32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(1,32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(1,32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(1,32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(1,32'h0009000C,32'h000002FA);
        //ZQCAL process
        u_sram_loader.ahb_write(1,32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(1,32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(1,32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(1,32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(1,32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        end
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(1,32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(1,32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(1,32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(1,32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(1,32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(1,32'h0009800C,ahb_rdata);
        end
        //VCO1
        u_sram_loader.ahb_write(1,32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(1,32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(1,32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(1,32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(1,32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(1,32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(1,32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(1,32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(1,32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(1,32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(1,32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(1,32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(1,32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(1,32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(1,32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(1,32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(1,32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(1,32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(1,32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:rx ch1:tx
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111019);
        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(1,32'h00120290,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202B0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202D0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00120294,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202B4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h00130290,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302B0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302D0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00130294,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302B4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h00140318,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140338,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140358,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(1,32'h0014031C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0014033C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0014035C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(1,32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A7C,32'h00004040);

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(1,32'h000F07F4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07E4,32'h00004040);

        u_sram_loader.ahb_write(1,32'h000F07F8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07D8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h001007F4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007E4,32'h00004040);

        u_sram_loader.ahb_write(1,32'h001007F8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007D8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h0011098C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0011096C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0011097C,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00110990,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(1,32'h001201F0,32'h00000004); //Ch1_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00120880,32'h00000004); //Ch1_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h001301F0,32'h00000004); //Ch1_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00130880,32'h00000004); //Ch1_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00140258,32'h00000004); //Ch1_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(1,32'h001409F8,32'h00000004); //Ch1_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(1,32'h001203A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h001303A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00140454,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(1,32'h00120A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(1,32'h00140AAC,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(1,32'h00120554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00140664,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(1,32'h00120C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(1,32'h00140ADC,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        u_sram_loader.ahb_write(1,32'h000F083C,32'h00427777); //Ch0_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(1,32'h0010083C,32'h00427777); //Ch0_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(1,32'h001109C4,32'h00427777); //Ch0_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(1,32'h000F07B8,32'h00000084); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(1,32'h001007B8,32'h00000084); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(1,32'h00110950,32'h00000084); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(1,32'h000F0000,32'h00000100); //Ch0_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(1,32'h00100000,32'h00000100); //Ch0_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(1,32'h00110000,32'h00000100); //Ch0_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(1,32'h000F0000,32'h00000000); //Ch0_DQ0_FIFO_EN
        u_sram_loader.ahb_write(1,32'h00100000,32'h00000000); //Ch0_DQ1_FIFO_EN
        u_sram_loader.ahb_write(1,32'h00110000,32'h00000000); //Ch0_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
        $display ("[%t] #########  Die 1 Initializing Done   #########",$time);
    end
endtask

 


task link_rdqs_training_D1_2_D0();
    begin
        $display ("[%t] #########  Begin Link Training D1 CH1->D0 CH1  #########",$time);
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        //lt_mode<=3'b001; //send 01010101
        //D1 buf_mode=1
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111109);
        // ts enable
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        u_sram_loader.ahb_write(1,32'h0015000C,32'h20000000); //ig_hold=1
        u_sram_loader.ahb_read(1,32'h0015000C,ahb_rdata); //ig_hold=1
        while(ahb_rdata[29]!=1) begin
            u_sram_loader.ahb_read(1,32'h0015000C,ahb_rdata);
        end
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000||00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||};
        //valid disable
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //valid enable
        send_ucie_ingress_data(1,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid disable
        send_ucie_ingress_data(1,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //reset timestamp
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //read egress data
        $display ("[%t] #########  Before Training     #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);//read ch0 rx data
        //clr
        u_sram_loader.ahb_write(0,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //begin link rdqs training, rdqs delay tuning
        u_sram_loader.ahb_write(0,32'h00120820,32'h00004949); //d0 Ch1_DQ0_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(0,32'h00130820,32'h00004949); //d0 Ch1_DQ1_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(0,32'h00120824,32'h00004949); //d0 Ch1_DQ0_DQS_RX_IO_M0_R1
        u_sram_loader.ahb_write(0,32'h00130824,32'h00004949); //d0 Ch1_DQ1_DQS_RX_IO_M0_R1
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        /*
        should further check if egress fifo is empty. If not, means valid signal is not aligned correctly.
        */
        //clr
        u_sram_loader.ahb_write(0,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  RDQS Calibration Done     #########",$time);
    end
endtask


task link_rdqs_training_D0_2_D1();
    begin
        $display ("[%t] #########  Begin Link Training D0 CH0->D1 CH0  #########",$time);
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        //lt_mode<=3'b001; //send 01010101
        //D0 buf_mode=1
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111106);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
        // ts enable
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        u_sram_loader.ahb_write(0,32'h0015000C,32'h20000000); //ig_hold=1
        u_sram_loader.ahb_read(0,32'h0015000C,ahb_rdata); //ig_hold=1
        while(ahb_rdata[29]!=1) begin
            u_sram_loader.ahb_read(0,32'h0015000C,ahb_rdata);
        end
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid disable
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(0,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //read egress data
        $display ("[%t] #########  Before Training     #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);//read ch0 rx data
        //clr
        u_sram_loader.ahb_write(1,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(1,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //begin link rdqs training, rdqs delay tuning
        u_sram_loader.ahb_write(1,32'h000F0820,32'h00004949); //d1 Ch0_DQ0_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(1,32'h00100820,32'h00004949); //d1 Ch0_DQ1_DQS_RX_IO_M0_R0
        u_sram_loader.ahb_write(1,32'h000F0824,32'h00004949); //d1 Ch0_DQ0_DQS_RX_IO_M0_R1
        u_sram_loader.ahb_write(1,32'h00100824,32'h00004949); //d1 Ch0_DQ1_DQS_RX_IO_M0_R1
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        /*
        should further check if egress fifo is empty. If not, means valid signal is not aligned correctly.
        */
        //clr
        u_sram_loader.ahb_write(1,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(1,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  RDQS Calibration Done     #########",$time);
    end
endtask

`timescale 1ns/1ps
module mixed_phy_2_tb();
    parameter half_clk_cycle=13;

    logic rst,csp_rst_n;
    logic ref_clk;
    rdi_mb_interface rdi_mb_if_0(clk,rst);
    rdi_mb_interface rdi_mb_if_1(clk,rst);
//virtual channel

    wire [17:0]  pad_ch0_dq;
    wire [7:0]  pad_ch0_ca;
    wire  pad_ch0_ck_c;
    wire  pad_ch0_ck_t;
    wire [1:0] pad_ch0_dqs_c;
    wire [1:0] pad_ch0_dqs_t;

    wire [17:0]  pad_ch1_dq;
    wire [7:0]  pad_ch1_ca;
    wire  pad_ch1_ck_c;
    wire  pad_ch1_ck_t;
    wire [1:0] pad_ch1_dqs_c;
    wire [1:0] pad_ch1_dqs_t;

    logic [383:0] xmit_q_0 [$];
    logic [383:0] xmit_q_1 [$];
    int err_count;
    int run_for_n_pkts;
    bit [447:0] egress_data;

//clks
   logic ahb_clk;
   logic clk_0,clk_1;
    always #half_clk_cycle ref_clk=~ref_clk;
    always #half_clk_cycle ahb_clk=~ahb_clk;

//AHB
   logic [31:0]                  ahb_if_haddr;
   logic                         ahb_if_hwrite;
   logic [31:0]                  ahb_if_hwdata;
   logic [1:0]                   ahb_if_htrans;
   logic [2:0]                   ahb_if_hsize;
   logic                         ahb_if_hsel;
   logic [2:0]                   ahb_if_hburst;
   logic                         ahb_if_hreadyin;
   logic                         ahb_if_hready;
   logic [31:0]                  ahb_if_hrdata;
   logic [1:0]                   ahb_if_hresp;

   logic [31:0]                  phy0_ahbs_haddr;
   logic                         phy0_ahbs_hwrite;
   logic [31:0]                  phy0_ahbs_hwdata;
   logic [1:0]                   phy0_ahbs_htrans;
   logic [2:0]                   phy0_ahbs_hsize;
   logic                         phy0_ahbs_hsel;
   logic [2:0]                   phy0_ahbs_hburst;
   logic                         phy0_ahbs_hreadyin;
   logic                         phy0_ahbs_hready;
   logic [31:0]                  phy0_ahbs_hrdata;
   logic [1:0]                   phy0_ahbs_hresp;

   logic [31:0]                  phy1_ahbs_haddr;
   logic                         phy1_ahbs_hwrite;
   logic [31:0]                  phy1_ahbs_hwdata;
   logic [1:0]                   phy1_ahbs_htrans;
   logic [2:0]                   phy1_ahbs_hsize;
   logic                         phy1_ahbs_hsel;
   logic [2:0]                   phy1_ahbs_hburst;
   logic                         phy1_ahbs_hreadyin;
   logic                         phy1_ahbs_hready;
   logic [31:0]                  phy1_ahbs_hrdata;
   logic [1:0]                   phy1_ahbs_hresp;

   logic [31:0]                  phy2_ahbs_haddr;
   logic                         phy2_ahbs_hwrite;
   logic [31:0]                  phy2_ahbs_hwdata;
   logic [1:0]                   phy2_ahbs_htrans;
   logic [2:0]                   phy2_ahbs_hsize;
   logic                         phy2_ahbs_hsel;
   logic [2:0]                   phy2_ahbs_hburst;
   logic                         phy2_ahbs_hreadyin;
   logic                         phy2_ahbs_hready=0;
   logic [31:0]                  phy2_ahbs_hrdata=0;
   logic [1:0]                   phy2_ahbs_hresp=0;

   logic [31:0]                  phy3_ahbs_haddr;
   logic                         phy3_ahbs_hwrite;
   logic [31:0]                  phy3_ahbs_hwdata;
   logic [1:0]                   phy3_ahbs_htrans;
   logic [2:0]                   phy3_ahbs_hsize;
   logic                         phy3_ahbs_hsel;
   logic [2:0]                   phy3_ahbs_hburst;
   logic                         phy3_ahbs_hreadyin;
   logic                         phy3_ahbs_hready=0;
   logic [31:0]                  phy3_ahbs_hrdata=0;
   logic [1:0]                   phy3_ahbs_hresp=0;

   logic [31:0]                  ext_ahbm_haddr;
   logic                         ext_ahbm_hwrite;
   logic                         ext_ahbm_hbusreq;
   logic [31:0]                  ext_ahbm_hwdata;
   logic [1:0]                   ext_ahbm_htrans;
   logic [2:0]                   ext_ahbm_hsize;
   logic [2:0]                   ext_ahbm_hburst;
   logic                         ext_ahbm_hready;
   logic [31:0]                  ext_ahbm_hrdata;
   logic [1:0]                   ext_ahbm_hresp;
   logic                         ext_ahbm_hgrant;

   logic [31:0]                  phy0_ahbm_haddr;
   logic                         phy0_ahbm_hwrite;
   logic                         phy0_ahbm_hbusreq;
   logic [31:0]                  phy0_ahbm_hwdata;
   logic [1:0]                   phy0_ahbm_htrans;
   logic [2:0]                   phy0_ahbm_hsize;
   logic [2:0]                   phy0_ahbm_hburst;
   logic                         phy0_ahbm_hready;
   logic [31:0]                  phy0_ahbm_hrdata;
   logic [1:0]                   phy0_ahbm_hresp;
   logic                         phy0_ahbm_hgrant;

   logic [31:0]                  phy1_ahbm_haddr;
   logic                         phy1_ahbm_hwrite;
   logic                         phy1_ahbm_hbusreq;
   logic [31:0]                  phy1_ahbm_hwdata;
   logic [1:0]                   phy1_ahbm_htrans;
   logic [2:0]                   phy1_ahbm_hsize;
   logic [2:0]                   phy1_ahbm_hburst;
   logic                         phy1_ahbm_hready;
   logic [31:0]                  phy1_ahbm_hrdata;
   logic [1:0]                   phy1_ahbm_hresp;
   logic                         phy1_ahbm_hgrant;

   logic [31:0]                  phy2_ahbm_haddr=0;
   logic                         phy2_ahbm_hwrite=0;
   logic                         phy2_ahbm_hbusreq=0;
   logic [31:0]                  phy2_ahbm_hwdata=0;
   logic [1:0]                   phy2_ahbm_htrans=0;
   logic [2:0]                   phy2_ahbm_hsize=0;
   logic [2:0]                   phy2_ahbm_hburst=0;
   logic                         phy2_ahbm_hready;
   logic [31:0]                  phy2_ahbm_hrdata;
   logic [1:0]                   phy2_ahbm_hresp;
   logic                         phy2_ahbm_hgrant;

   logic [31:0]                  phy3_ahbm_haddr=0;
   logic                         phy3_ahbm_hwrite=0;
   logic                         phy3_ahbm_hbusreq=0;
   logic [31:0]                  phy3_ahbm_hwdata=0;
   logic [1:0]                   phy3_ahbm_htrans=0;
   logic [2:0]                   phy3_ahbm_hsize=0;
   logic [2:0]                   phy3_ahbm_hburst=0;
   logic                         phy3_ahbm_hready;
   logic [31:0]                  phy3_ahbm_hrdata;
   logic [1:0]                   phy3_ahbm_hresp;
   logic                         phy3_ahbm_hgrant;

global_sram_loader u_sram_loader (
    //AHB
    .ahb_if_haddr       (ahb_if_haddr),
    .ahb_if_hwrite      (ahb_if_hwrite),
    .ahb_if_hwdata      (ahb_if_hwdata),
    .ahb_if_htrans      (ahb_if_htrans),
    .ahb_if_hsize       (ahb_if_hsize),
    .ahb_if_hsel        (ahb_if_hsel),
    .ahb_if_hburst      (ahb_if_hburst),
    .ahb_if_hreadyin    (ahb_if_hreadyin),
    .ahb_if_hready      (ahb_if_hready),
    .ahb_if_hrdata      (ahb_if_hrdata),
    .ahb_if_hresp       (ahb_if_hresp),
    .clk                (ahb_clk)
);


wav_ahb_slave2master #(
      .AWIDTH  (32)
   ) u_ext_ahbm_s2m (
      .i_hclk                          (ahb_clk),
      .i_hreset                        (rst),
      .i_ahbs_haddr                    (ahb_if_haddr ),
      .i_ahbs_hwrite                   (ahb_if_hwrite),
      .i_ahbs_hsel                     (ahb_if_hsel  ),
      .i_ahbs_hreadyin                 (ahb_if_hreadyin),
      .i_ahbs_hwdata                   (ahb_if_hwdata),
      .i_ahbs_htrans                   (ahb_if_htrans),
      .i_ahbs_hsize                    (ahb_if_hsize ),
      .i_ahbs_hburst                   (ahb_if_hburst),
      .o_ahbs_hready                   (ahb_if_hready),
      .o_ahbs_hrdata                   (ahb_if_hrdata),
      .o_ahbs_hresp                    (ahb_if_hresp ),

      .i_ahbm_hgrant                   (ext_ahbm_hgrant),
      .o_ahbm_haddr                    (ext_ahbm_haddr ),
      .o_ahbm_hwrite                   (ext_ahbm_hwrite),
      .o_ahbm_hbusreq                  (ext_ahbm_hbusreq),
      .o_ahbm_hwdata                   (ext_ahbm_hwdata),
      .o_ahbm_htrans                   (ext_ahbm_htrans),
      .o_ahbm_hsize                    (ext_ahbm_hsize ),
      .o_ahbm_hburst                   (ext_ahbm_hburst),
      .i_ahbm_hready                   (ext_ahbm_hready),
      .i_ahbm_hrdata                   (ext_ahbm_hrdata),
      .i_ahbm_hresp                    (ext_ahbm_hresp )
   );
    



d2d_ahb_ic_model #(
    .AWIDTH                  (32),
    .DWIDTH                  (32)
) u_d2d_ahb_ic_model (
    .i_hclk                  (ahb_clk),
    .i_hrst                  (rst),
    // from ext AHB mater
    .i_ext_ahbm_haddr        (ext_ahbm_haddr),
    .i_ext_ahbm_hwrite       (ext_ahbm_hwrite),
    .i_ext_ahbm_hwdata       (ext_ahbm_hwdata),
    .i_ext_ahbm_htrans       (ext_ahbm_htrans),
    .i_ext_ahbm_hsize        (ext_ahbm_hsize),
    .i_ext_ahbm_hburst       (ext_ahbm_hburst),
    .i_ext_ahbm_hbusreq      (ext_ahbm_hbusreq),
    .o_ext_ahbm_hgrant       (ext_ahbm_hgrant),
    .o_ext_ahbm_hready       (ext_ahbm_hready),
    .o_ext_ahbm_hrdata       (ext_ahbm_hrdata),
    .o_ext_ahbm_hresp        (ext_ahbm_hresp),
    // from PHY0_M Port
    .i_phy0_ahbm_haddr       (phy0_ahbm_haddr),
    .i_phy0_ahbm_hwrite      (phy0_ahbm_hwrite),
    .i_phy0_ahbm_hwdata      (phy0_ahbm_hwdata),
    .i_phy0_ahbm_htrans      (phy0_ahbm_htrans),
    .i_phy0_ahbm_hsize       (phy0_ahbm_hsize),
    .i_phy0_ahbm_hburst      (phy0_ahbm_hburst),
    .i_phy0_ahbm_hbusreq     (phy0_ahbm_hbusreq),
    .o_phy0_ahbm_hready      (phy0_ahbm_hready),
    .o_phy0_ahbm_hrdata      (phy0_ahbm_hrdata),
    .o_phy0_ahbm_hresp       (phy0_ahbm_hresp),
    .o_phy0_ahbm_hgrant      (phy0_ahbm_hgrant),
    // from PHY1_M Port
    .i_phy1_ahbm_haddr       (phy1_ahbm_haddr),
    .i_phy1_ahbm_hwrite      (phy1_ahbm_hwrite),
    .i_phy1_ahbm_hbusreq     (phy1_ahbm_hbusreq),
    .i_phy1_ahbm_hwdata      (phy1_ahbm_hwdata),
    .i_phy1_ahbm_htrans      (phy1_ahbm_htrans),
    .i_phy1_ahbm_hsize       (phy1_ahbm_hsize),
    .i_phy1_ahbm_hburst      (phy1_ahbm_hburst),
    .o_phy1_ahbm_hready      (phy1_ahbm_hready),
    .o_phy1_ahbm_hrdata      (phy1_ahbm_hrdata),
    .o_phy1_ahbm_hresp       (phy1_ahbm_hresp),
    .o_phy1_ahbm_hgrant      (phy1_ahbm_hgrant),
    // from PHY2_M Port
    .i_phy2_ahbm_haddr       (phy2_ahbm_haddr),
    .i_phy2_ahbm_hwrite      (phy2_ahbm_hwrite),
    .i_phy2_ahbm_hbusreq     (phy2_ahbm_hbusreq),
    .i_phy2_ahbm_hwdata      (phy2_ahbm_hwdata),
    .i_phy2_ahbm_htrans      (phy2_ahbm_htrans),
    .i_phy2_ahbm_hsize       (phy2_ahbm_hsize),
    .i_phy2_ahbm_hburst      (phy2_ahbm_hburst),
    .o_phy2_ahbm_hready      (phy2_ahbm_hready),
    .o_phy2_ahbm_hrdata      (phy2_ahbm_hrdata),
    .o_phy2_ahbm_hresp       (phy2_ahbm_hresp),
    .o_phy2_ahbm_hgrant      (phy2_ahbm_hgrant),
    // from PHY3_M Port
    .i_phy3_ahbm_haddr       (phy3_ahbm_haddr),
    .i_phy3_ahbm_hwrite      (phy3_ahbm_hwrite),
    .i_phy3_ahbm_hbusreq     (phy3_ahbm_hbusreq),
    .i_phy3_ahbm_hwdata      (phy3_ahbm_hwdata),
    .i_phy3_ahbm_htrans      (phy3_ahbm_htrans),
    .i_phy3_ahbm_hsize       (phy3_ahbm_hsize),
    .i_phy3_ahbm_hburst      (phy3_ahbm_hburst),
    .o_phy3_ahbm_hready      (phy3_ahbm_hready),
    .o_phy3_ahbm_hrdata      (phy3_ahbm_hrdata),
    .o_phy3_ahbm_hresp       (phy3_ahbm_hresp),
    .o_phy3_ahbm_hgrant      (phy3_ahbm_hgrant),
    //to PHY0_S Port
    .o_phy0_ahbs_haddr       (phy0_ahbs_haddr),
    .o_phy0_ahbs_hwrite      (phy0_ahbs_hwrite),
    .o_phy0_ahbs_hsel        (phy0_ahbs_hsel),
    .o_phy0_ahbs_hreadyin    (phy0_ahbs_hreadyin),
    .o_phy0_ahbs_hwdata      (phy0_ahbs_hwdata),
    .o_phy0_ahbs_htrans      (phy0_ahbs_htrans),
    .o_phy0_ahbs_hsize       (phy0_ahbs_hsize),
    .o_phy0_ahbs_hburst      (phy0_ahbs_hburst),
    .i_phy0_ahbs_hready      (phy0_ahbs_hready),
    .i_phy0_ahbs_hrdata      (phy0_ahbs_hrdata),
    .i_phy0_ahbs_hresp       (phy0_ahbs_hresp),
    //to PHY1_S Port
    .o_phy1_ahbs_haddr       (phy1_ahbs_haddr),
    .o_phy1_ahbs_hwrite      (phy1_ahbs_hwrite),
    .o_phy1_ahbs_hsel        (phy1_ahbs_hsel),
    .o_phy1_ahbs_hreadyin    (phy1_ahbs_hreadyin),
    .o_phy1_ahbs_hwdata      (phy1_ahbs_hwdata),
    .o_phy1_ahbs_htrans      (phy1_ahbs_htrans),
    .o_phy1_ahbs_hsize       (phy1_ahbs_hsize),
    .o_phy1_ahbs_hburst      (phy1_ahbs_hburst),
    .i_phy1_ahbs_hready      (phy1_ahbs_hready),
    .i_phy1_ahbs_hrdata      (phy1_ahbs_hrdata),
    .i_phy1_ahbs_hresp       (phy1_ahbs_hresp),
    //to PHY2_S Port
    .o_phy2_ahbs_haddr       (phy2_ahbs_haddr),
    .o_phy2_ahbs_hwrite      (phy2_ahbs_hwrite),
    .o_phy2_ahbs_hsel        (phy2_ahbs_hsel),
    .o_phy2_ahbs_hreadyin    (phy2_ahbs_hreadyin),
    .o_phy2_ahbs_hwdata      (phy2_ahbs_hwdata),
    .o_phy2_ahbs_htrans      (phy2_ahbs_htrans),
    .o_phy2_ahbs_hsize       (phy2_ahbs_hsize),
    .o_phy2_ahbs_hburst      (phy2_ahbs_hburst),
    .i_phy2_ahbs_hready      (phy2_ahbs_hready),
    .i_phy2_ahbs_hrdata      (phy2_ahbs_hrdata),
    .i_phy2_ahbs_hresp       (phy2_ahbs_hresp),
    //to PHY3_S Port
    .o_phy3_ahbs_haddr       (phy3_ahbs_haddr),
    .o_phy3_ahbs_hwrite      (phy3_ahbs_hwrite),
    .o_phy3_ahbs_hsel        (phy3_ahbs_hsel),
    .o_phy3_ahbs_hreadyin    (phy3_ahbs_hreadyin),
    .o_phy3_ahbs_hwdata      (phy3_ahbs_hwdata),
    .o_phy3_ahbs_htrans      (phy3_ahbs_htrans),
    .o_phy3_ahbs_hsize       (phy3_ahbs_hsize),
    .o_phy3_ahbs_hburst      (phy3_ahbs_hburst),
    .i_phy3_ahbs_hready      (phy3_ahbs_hready),
    .i_phy3_ahbs_hrdata      (phy3_ahbs_hrdata),
    .i_phy3_ahbs_hresp       (phy3_ahbs_hresp)
);

mixed_phy #(
    .SECONDARY_PHY                ('0),
    // Secondary PHY configuration (no CMN, no MCU)
    .NUM_CH                       (2),
    // Number of PHY channels.
    .NUM_DQ                       (2),
    // Number of DQ lanes per PHY channel.
    .NUM_DFI_CH                   (1),
    // Number of DFI channels
    .NUM_DFI_DQ                   (4),
    // Number of DQ lanes per DFI channel.
    .AHB_AWIDTH                   (32),
    // AHB Address width
    .AHB_DWIDTH                   (32),
    // AHB Data width
    .SWIDTH                       (8),
    // PHY Slice Width
    .AWIDTH                       (6),
    // Cmd/Address bus width
    .NUM_RDPH                     (4),
    // Read datapath data phases (includes R/F)
    .NUM_RPH                      (8),
    // Read fifo data phases (includes R/F)
    .NUM_WDPH                     (4),
    // Write datapath data phases (includes R/F)
    .NUM_WPH                      (8),
    // Write gearbox data phases (includes R/F)
    .DQ_WIDTH                     (9),
    // DQ bus width
    .DQS_WIDTH                    (9+0),
    // DQS bus width
    .CA_WIDTH                     (8),
    // DQ bus width
    .CK_WIDTH                     (1+8),
    // DQS bus width
    .NUM_IRQ                      (`DDR_NUM_IRQ),
    // Max number of IRQ supported = 32
    .TSWIDTH                      (16),
    // Timestamp Width
    .DFI_BUF_IG_DEPTH             (32),
    // DFI ingress buffer depth
    // DFI egress buffer depth
    .DFI_BUF_EG_DEPTH             (32)
) u_mixed_phy_0 (
    // Reset
    .i_phy_rst                    (rst),
    // Clocks
    .i_dfi_clk_on                 (1'b1),
    .o_dfi_clk                    (clk_0),
    .i_ana_refclk                 (ref_clk),
    .i_refclk                     (ref_clk),
    .o_refclk_on                  (),
    .i_refclk_alt                 (ref_clk),
    // Interrupts
    .i_irq                        ('0),
    .o_irq                        (),
    // General Purpose Bus
    .i_gpb                        ('0),
    .o_gpb                        (),
    // Channel clocks (from primary channel)
    .i_pll_clk_0                  ('0),
    .i_pll_clk_90                 ('0),
    .i_pll_clk_180                ('0),
    .i_pll_clk_270                ('0),
    .i_vco0_clk                   ('0),
    // Channel clocks (to secondary channel)
    .o_pll_clk_0                  (),
    .o_pll_clk_90                 (),
    .o_pll_clk_180                (),
    .o_pll_clk_270                (),
    .o_vco0_clk                   (),
    // TEST
    .i_scan_mode                  ('0),
    .i_scan_clk                   ('0),
    .i_scan_en                    ('0),
    .i_scan_freq_en               ('0),
    .i_scan_cgc_ctrl              ('0),
    .i_scan_rst_ctrl              ('0),
    .i_scan                       ('0),
    .o_scan                       (),
    .i_freeze_n                   (1'b1),
    .i_hiz_n                      (1'b1),
    .i_iddq_mode                  ('0),
    .o_dtst                       (),
    // Power Collapse
    .i_ret_en                     ('0),
    // IFR_FIXME - Connect to support power collapse.
    .i_hs_en                      ('0),
    // IFR_FIXME - Connect to support power collapse.

    // JTAG Interface
    .i_jtag_tck                   ('0),
    .i_jtag_trst_n                ('0),
    .i_jtag_tms                   ('0),
    .i_jtag_tdi                   ('0),
    .o_jtag_tdo                   (),
    // AHB Interface
    .i_ahb_clk                    (ahb_clk),
    .o_ahb_clk_on                 (),
    .i_ahb_rst                    (rst),
    .i_ahb_csr_rst                (rst),
    // AHB Slave
    .i_ahb_haddr                  (phy0_ahbs_haddr),
    .i_ahb_hwrite                 (phy0_ahbs_hwrite),
    .i_ahb_hsel                   (phy0_ahbs_hsel),
    .i_ahb_hreadyin               (phy0_ahbs_hreadyin),
    .i_ahb_hwdata                 (phy0_ahbs_hwdata),
    .i_ahb_htrans                 (phy0_ahbs_htrans),
    .i_ahb_hsize                  (phy0_ahbs_hsize),
    .i_ahb_hburst                 (phy0_ahbs_hburst),
    .o_ahb_hready                 (phy0_ahbs_hready),
    .o_ahb_hrdata                 (phy0_ahbs_hrdata),
    .o_ahb_hresp                  (phy0_ahbs_hresp),
    // AHB Master (to external Slave)
    .o_ahb_haddr                  (phy0_ahbm_haddr),
    .o_ahb_hwrite                 (phy0_ahbm_hwrite),
    .o_ahb_hwdata                 (phy0_ahbm_hwdata),
    .o_ahb_htrans                 (phy0_ahbm_htrans),
    .o_ahb_hsize                  (phy0_ahbm_hsize),
    .o_ahb_hburst                 (phy0_ahbm_hburst),
    .o_ahb_hbusreq                (phy0_ahbm_hbusreq),
    .i_ahb_hgrant                 (phy0_ahbm_hgrant),
    .i_ahb_hready                 (phy0_ahbm_hready),
    .i_ahb_hrdata                 (phy0_ahbm_hrdata),
    .i_ahb_hresp                  (phy0_ahbm_hresp),
    // Update
    .o_dfi_ctrlupd_ack            (),
    .i_dfi_ctrlupd_req            ('0),
    .i_dfi_phyupd_ack             ('0),
    .o_dfi_phyupd_req             (),
    .o_dfi_phyupd_type            (),
    // Status
    .i_dfi_freq_fsp               ('0),
    .i_dfi_freq_ratio             ('0),
    .i_dfi_frequency              ('0),
    .o_dfi_init_complete          (),
    .i_dfi_init_start             ('0),
    // PHY Master
    .i_dfi_phymstr_ack            ('0),
    .o_dfi_phymstr_cs_state       (),
    .o_dfi_phymstr_req            (),
    .o_dfi_phymstr_state_sel      (),
    .o_dfi_phymstr_type           (),
    // Low Power Control
    .o_dfi_lp_ctrl_ack            (),
    .i_dfi_lp_ctrl_req            ('0),
    .i_dfi_lp_ctrl_wakeup         ('0),
    .o_dfi_lp_data_ack            (),
    .i_dfi_lp_data_req            ('0),
    .i_dfi_lp_data_wakeup         ('0),
    .i_dfi_reset_n_p0             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p1             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p2             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p3             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p4             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p5             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p6             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p7             ('0),
    // DDR/3/4/5 and LPDDR4/5
    // Command
    .i_dfi_address_p0             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p1             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p2             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p3             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p4             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p5             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p6             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p7             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_cke_p0                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p1                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p2                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p3                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p4                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p5                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p6                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p7                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cs_p0                  ('0),
    .i_dfi_cs_p1                  ('0),
    .i_dfi_cs_p2                  ('0),
    .i_dfi_cs_p3                  ('0),
    .i_dfi_cs_p4                  ('0),
    .i_dfi_cs_p5                  ('0),
    .i_dfi_cs_p6                  ('0),
    .i_dfi_cs_p7                  ('0),
    .i_dfi_dram_clk_disable_p0    ('0),
    .i_dfi_dram_clk_disable_p1    ('0),
    .i_dfi_dram_clk_disable_p2    ('0),
    .i_dfi_dram_clk_disable_p3    ('0),
    .i_dfi_dram_clk_disable_p4    ('0),
    .i_dfi_dram_clk_disable_p5    ('0),
    .i_dfi_dram_clk_disable_p6    ('0),
    .i_dfi_dram_clk_disable_p7    ('0),
    // Write
    .i_dfi_wrdata_p0              ('0),
    .i_dfi_wrdata_p1              ('0),
    .i_dfi_wrdata_p2              ('0),
    .i_dfi_wrdata_p3              ('0),
    .i_dfi_wrdata_p4              ('0),
    .i_dfi_wrdata_p5              ('0),
    .i_dfi_wrdata_p6              ('0),
    .i_dfi_wrdata_p7              ('0),
    .i_dfi_parity_in_p0           ('0),
    .i_dfi_parity_in_p1           ('0),
    .i_dfi_parity_in_p2           ('0),
    .i_dfi_parity_in_p3           ('0),
    .i_dfi_parity_in_p4           ('0),
    .i_dfi_parity_in_p5           ('0),
    .i_dfi_parity_in_p6           ('0),
    .i_dfi_parity_in_p7           ('0),
    .i_dfi_wrdata_cs_p0           ('0),
    .i_dfi_wrdata_cs_p1           ('0),
    .i_dfi_wrdata_cs_p2           ('0),
    .i_dfi_wrdata_cs_p3           ('0),
    .i_dfi_wrdata_cs_p4           ('0),
    .i_dfi_wrdata_cs_p5           ('0),
    .i_dfi_wrdata_cs_p6           ('0),
    .i_dfi_wrdata_cs_p7           ('0),
    .i_dfi_wck_cs_p0              ('0),
    .i_dfi_wck_cs_p1              ('0),
    .i_dfi_wck_cs_p2              ('0),
    .i_dfi_wck_cs_p3              ('0),
    .i_dfi_wck_cs_p4              ('0),
    .i_dfi_wck_cs_p5              ('0),
    .i_dfi_wck_cs_p6              ('0),
    .i_dfi_wck_cs_p7              ('0),
    .i_dfi_wrdata_mask_p0         ('0),
    .i_dfi_wrdata_mask_p1         ('0),
    .i_dfi_wrdata_mask_p2         ('0),
    .i_dfi_wrdata_mask_p3         ('0),
    .i_dfi_wrdata_mask_p4         ('0),
    .i_dfi_wrdata_mask_p5         ('0),
    .i_dfi_wrdata_mask_p6         ('0),
    .i_dfi_wrdata_mask_p7         ('0),
    .i_dfi_wrdata_en_p0           ('0),
    .i_dfi_wrdata_en_p1           ('0),
    .i_dfi_wrdata_en_p2           ('0),
    .i_dfi_wrdata_en_p3           ('0),
    .i_dfi_wrdata_en_p4           ('0),
    .i_dfi_wrdata_en_p5           ('0),
    .i_dfi_wrdata_en_p6           ('0),
    .i_dfi_wrdata_en_p7           ('0),
    .i_dfi_wck_en_p0              ('0),
    .i_dfi_wck_en_p1              ('0),
    .i_dfi_wck_en_p2              ('0),
    .i_dfi_wck_en_p3              ('0),
    .i_dfi_wck_en_p4              ('0),
    .i_dfi_wck_en_p5              ('0),
    .i_dfi_wck_en_p6              ('0),
    .i_dfi_wck_en_p7              ('0),
    .i_dfi_wck_toggle_p0          ('0),
    .i_dfi_wck_toggle_p1          ('0),
    .i_dfi_wck_toggle_p2          ('0),
    .i_dfi_wck_toggle_p3          ('0),
    .i_dfi_wck_toggle_p4          ('0),
    .i_dfi_wck_toggle_p5          ('0),
    .i_dfi_wck_toggle_p6          ('0),
    .i_dfi_wck_toggle_p7          ('0),
    // Read Data
    .i_dfi_rddata_cs_p0           ('0),
    .i_dfi_rddata_cs_p1           ('0),
    .i_dfi_rddata_cs_p2           ('0),
    .i_dfi_rddata_cs_p3           ('0),
    .i_dfi_rddata_cs_p4           ('0),
    .i_dfi_rddata_cs_p5           ('0),
    .i_dfi_rddata_cs_p6           ('0),
    .i_dfi_rddata_cs_p7           ('0),
    .i_dfi_rddata_en_p0           ('0),
    .i_dfi_rddata_en_p1           ('0),
    .i_dfi_rddata_en_p2           ('0),
    .i_dfi_rddata_en_p3           ('0),
    .i_dfi_rddata_en_p4           ('0),
    .i_dfi_rddata_en_p5           ('0),
    .i_dfi_rddata_en_p6           ('0),
    .i_dfi_rddata_en_p7           ('0),
    .o_dfi_rddata_w0              (),
    .o_dfi_rddata_w1              (),
    .o_dfi_rddata_w2              (),
    .o_dfi_rddata_w3              (),
    .o_dfi_rddata_w4              (),
    .o_dfi_rddata_w5              (),
    .o_dfi_rddata_w6              (),
    .o_dfi_rddata_w7              (),
    .o_dfi_rddata_dbi_w0          (),
    .o_dfi_rddata_dbi_w1          (),
    .o_dfi_rddata_dbi_w2          (),
    .o_dfi_rddata_dbi_w3          (),
    .o_dfi_rddata_dbi_w4          (),
    .o_dfi_rddata_dbi_w5          (),
    .o_dfi_rddata_dbi_w6          (),
    .o_dfi_rddata_dbi_w7          (),
    .o_dfi_rddata_valid_w0        (),
    .o_dfi_rddata_valid_w1        (),
    .o_dfi_rddata_valid_w2        (),
    .o_dfi_rddata_valid_w3        (),
    .o_dfi_rddata_valid_w4        (),
    .o_dfi_rddata_valid_w5        (),
    .o_dfi_rddata_valid_w6        (),
    .o_dfi_rddata_valid_w7        (),
    //RDI mainband
    .lp_data               (rdi_mb_if_0.lp_data),
    .lp_valid              (rdi_mb_if_0.lp_valid),
    .lp_irdy               (rdi_mb_if_0.lp_irdy),
    .pl_trdy               (rdi_mb_if_0.pl_trdy),
    .pl_data               (rdi_mb_if_0.pl_data),
    .pl_valid              (rdi_mb_if_0.pl_valid),
    //RDI sideband
    .lp_cfg                (),
    .lp_cfg_vld            (),
    .lp_cfg_crd            (),
    .pl_cfg                (),
    .pl_cfg_vld            (),
    .pl_cfg_crd            (),
    // Pads
    .pad_reset_n                  ('1),
    // Reset pad
    .pad_rext                     (),
    .pad_test                     (),
    // TEST pad
    .pad_ch0_ck_t                 (pad_ch0_ck_t),
    // CK
    .pad_ch0_ck_c                 (pad_ch0_ck_c),
    // CK
    .pad_ch0_ca                   (pad_ch0_ca),
    // CA/CS/CKE
    .pad_ch0_wck_t                (),
    // WCK
    .pad_ch0_wck_c                (),
    // WCK
    .pad_ch0_dqs_t                (pad_ch0_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch0_dqs_c                (pad_ch0_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch0_dq                   (pad_ch0_dq),
    // DQ/DBI/DM/PARITY
    .pad_ch1_ck_t                 (pad_ch1_ck_t),
    // CK
    .pad_ch1_ck_c                 (pad_ch1_ck_c),
    // CK
    .pad_ch1_ca                   (pad_ch1_ca),
    // CA/CS/CKE
    .pad_ch1_wck_t                (),
    // WCK
    .pad_ch1_wck_c                (),
    // WCK
    .pad_ch1_dqs_t                (pad_ch1_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch1_dqs_c                (pad_ch1_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch1_dq                   (pad_ch1_dq),
    // DQ/DBI/DM/PARITY
    //Debug
    .o_debug                      ()
);

mixed_phy #(
    .SECONDARY_PHY                ('0),
    // Secondary PHY configuration (no CMN, no MCU)
    .NUM_CH                       (2),
    // Number of PHY channels.
    .NUM_DQ                       (2),
    // Number of DQ lanes per PHY channel.
    .NUM_DFI_CH                   (1),
    // Number of DFI channels
    .NUM_DFI_DQ                   (4),
    // Number of DQ lanes per DFI channel.
    .AHB_AWIDTH                   (32),
    // AHB Address width
    .AHB_DWIDTH                   (32),
    // AHB Data width
    .SWIDTH                       (8),
    // PHY Slice Width
    .AWIDTH                       (6),
    // Cmd/Address bus width
    .NUM_RDPH                     (4),
    // Read datapath data phases (includes R/F)
    .NUM_RPH                      (8),
    // Read fifo data phases (includes R/F)
    .NUM_WDPH                     (4),
    // Write datapath data phases (includes R/F)
    .NUM_WPH                      (8),
    // Write gearbox data phases (includes R/F)
    .DQ_WIDTH                     (9),
    // DQ bus width
    .DQS_WIDTH                    (9+0),
    // DQS bus width
    .CA_WIDTH                     (8),
    // DQ bus width
    .CK_WIDTH                     (1+8),
    // DQS bus width
    .NUM_IRQ                      (`DDR_NUM_IRQ),
    // Max number of IRQ supported = 32
    .TSWIDTH                      (16),
    // Timestamp Width
    .DFI_BUF_IG_DEPTH             (32),
    // DFI ingress buffer depth
    // DFI egress buffer depth
    .DFI_BUF_EG_DEPTH             (32)
) u_mixed_phy_1 (
    // Reset
    .i_phy_rst                    (rst),
    // Clocks
    .i_dfi_clk_on                 (1'b1),
    .o_dfi_clk                    (clk_1),
    .i_ana_refclk                 (ref_clk),
    .i_refclk                     (ref_clk),
    .o_refclk_on                  (),
    .i_refclk_alt                 (ref_clk),
    // Interrupts
    .i_irq                        ('0),
    .o_irq                        (),
    // General Purpose Bus
    .i_gpb                        ('0),
    .o_gpb                        (),
    // Channel clocks (from primary channel)
    .i_pll_clk_0                  ('0),
    .i_pll_clk_90                 ('0),
    .i_pll_clk_180                ('0),
    .i_pll_clk_270                ('0),
    .i_vco0_clk                   ('0),
    // Channel clocks (to secondary channel)
    .o_pll_clk_0                  (),
    .o_pll_clk_90                 (),
    .o_pll_clk_180                (),
    .o_pll_clk_270                (),
    .o_vco0_clk                   (),
    // TEST
    .i_scan_mode                  ('0),
    .i_scan_clk                   ('0),
    .i_scan_en                    ('0),
    .i_scan_freq_en               ('0),
    .i_scan_cgc_ctrl              ('0),
    .i_scan_rst_ctrl              ('0),
    .i_scan                       ('0),
    .o_scan                       (),
    .i_freeze_n                   (1'b1),
    .i_hiz_n                      (1'b1),
    .i_iddq_mode                  ('0),
    .o_dtst                       (),
    // Power Collapse
    .i_ret_en                     ('0),
    // IFR_FIXME - Connect to support power collapse.
    .i_hs_en                      ('0),
    // IFR_FIXME - Connect to support power collapse.

    // JTAG Interface
    .i_jtag_tck                   ('0),
    .i_jtag_trst_n                ('0),
    .i_jtag_tms                   ('0),
    .i_jtag_tdi                   ('0),
    .o_jtag_tdo                   (),
    // AHB Interface
    .i_ahb_clk                    (ahb_clk),
    .o_ahb_clk_on                 (),
    .i_ahb_rst                    (rst),
    .i_ahb_csr_rst                (rst),
    // AHB Slave
    .i_ahb_haddr                  (phy1_ahbs_haddr),
    .i_ahb_hwrite                 (phy1_ahbs_hwrite),
    .i_ahb_hsel                   (phy1_ahbs_hsel),
    .i_ahb_hreadyin               (phy1_ahbs_hreadyin),
    .i_ahb_hwdata                 (phy1_ahbs_hwdata),
    .i_ahb_htrans                 (phy1_ahbs_htrans),
    .i_ahb_hsize                  (phy1_ahbs_hsize),
    .i_ahb_hburst                 (phy1_ahbs_hburst),
    .o_ahb_hready                 (phy1_ahbs_hready),
    .o_ahb_hrdata                 (phy1_ahbs_hrdata),
    .o_ahb_hresp                  (phy1_ahbs_hresp),
    // AHB Master (to external Slave)
    .o_ahb_haddr                  (phy1_ahbm_haddr),
    .o_ahb_hwrite                 (phy1_ahbm_hwrite),
    .o_ahb_hwdata                 (phy1_ahbm_hwdata),
    .o_ahb_htrans                 (phy1_ahbm_htrans),
    .o_ahb_hsize                  (phy1_ahbm_hsize),
    .o_ahb_hburst                 (phy1_ahbm_hburst),
    .o_ahb_hbusreq                (phy1_ahbm_hbusreq),
    .i_ahb_hgrant                 (phy1_ahbm_hgrant),
    .i_ahb_hready                 (phy1_ahbm_hready),
    .i_ahb_hrdata                 (phy1_ahbm_hrdata),
    .i_ahb_hresp                  (phy1_ahbm_hresp),
    // Update
    .o_dfi_ctrlupd_ack            (),
    .i_dfi_ctrlupd_req            ('0),
    .i_dfi_phyupd_ack             ('0),
    .o_dfi_phyupd_req             (),
    .o_dfi_phyupd_type            (),
    // Status
    .i_dfi_freq_fsp               ('0),
    .i_dfi_freq_ratio             ('0),
    .i_dfi_frequency              ('0),
    .o_dfi_init_complete          (),
    .i_dfi_init_start             ('0),
    // PHY Master
    .i_dfi_phymstr_ack            ('0),
    .o_dfi_phymstr_cs_state       (),
    .o_dfi_phymstr_req            (),
    .o_dfi_phymstr_state_sel      (),
    .o_dfi_phymstr_type           (),
    // Low Power Control
    .o_dfi_lp_ctrl_ack            (),
    .i_dfi_lp_ctrl_req            ('0),
    .i_dfi_lp_ctrl_wakeup         ('0),
    .o_dfi_lp_data_ack            (),
    .i_dfi_lp_data_req            ('0),
    .i_dfi_lp_data_wakeup         ('0),
    .i_dfi_reset_n_p0             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p1             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p2             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p3             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p4             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p5             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p6             ('0),
    // DDR/3/4/5 and LPDDR4/5
    .i_dfi_reset_n_p7             ('0),
    // DDR/3/4/5 and LPDDR4/5
    // Command
    .i_dfi_address_p0             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p1             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p2             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p3             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p4             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p5             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p6             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_address_p7             ('0),
    // For DDR4 bits[16:14] are not used
    .i_dfi_cke_p0                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p1                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p2                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p3                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p4                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p5                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p6                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cke_p7                 ('0),
    // DDR4 and LPDDR3/4
    .i_dfi_cs_p0                  ('0),
    .i_dfi_cs_p1                  ('0),
    .i_dfi_cs_p2                  ('0),
    .i_dfi_cs_p3                  ('0),
    .i_dfi_cs_p4                  ('0),
    .i_dfi_cs_p5                  ('0),
    .i_dfi_cs_p6                  ('0),
    .i_dfi_cs_p7                  ('0),
    .i_dfi_dram_clk_disable_p0    ('0),
    .i_dfi_dram_clk_disable_p1    ('0),
    .i_dfi_dram_clk_disable_p2    ('0),
    .i_dfi_dram_clk_disable_p3    ('0),
    .i_dfi_dram_clk_disable_p4    ('0),
    .i_dfi_dram_clk_disable_p5    ('0),
    .i_dfi_dram_clk_disable_p6    ('0),
    .i_dfi_dram_clk_disable_p7    ('0),
    // Write
    .i_dfi_wrdata_p0              ('0),
    .i_dfi_wrdata_p1              ('0),
    .i_dfi_wrdata_p2              ('0),
    .i_dfi_wrdata_p3              ('0),
    .i_dfi_wrdata_p4              ('0),
    .i_dfi_wrdata_p5              ('0),
    .i_dfi_wrdata_p6              ('0),
    .i_dfi_wrdata_p7              ('0),
    .i_dfi_parity_in_p0           ('0),
    .i_dfi_parity_in_p1           ('0),
    .i_dfi_parity_in_p2           ('0),
    .i_dfi_parity_in_p3           ('0),
    .i_dfi_parity_in_p4           ('0),
    .i_dfi_parity_in_p5           ('0),
    .i_dfi_parity_in_p6           ('0),
    .i_dfi_parity_in_p7           ('0),
    .i_dfi_wrdata_cs_p0           ('0),
    .i_dfi_wrdata_cs_p1           ('0),
    .i_dfi_wrdata_cs_p2           ('0),
    .i_dfi_wrdata_cs_p3           ('0),
    .i_dfi_wrdata_cs_p4           ('0),
    .i_dfi_wrdata_cs_p5           ('0),
    .i_dfi_wrdata_cs_p6           ('0),
    .i_dfi_wrdata_cs_p7           ('0),
    .i_dfi_wck_cs_p0              ('0),
    .i_dfi_wck_cs_p1              ('0),
    .i_dfi_wck_cs_p2              ('0),
    .i_dfi_wck_cs_p3              ('0),
    .i_dfi_wck_cs_p4              ('0),
    .i_dfi_wck_cs_p5              ('0),
    .i_dfi_wck_cs_p6              ('0),
    .i_dfi_wck_cs_p7              ('0),
    .i_dfi_wrdata_mask_p0         ('0),
    .i_dfi_wrdata_mask_p1         ('0),
    .i_dfi_wrdata_mask_p2         ('0),
    .i_dfi_wrdata_mask_p3         ('0),
    .i_dfi_wrdata_mask_p4         ('0),
    .i_dfi_wrdata_mask_p5         ('0),
    .i_dfi_wrdata_mask_p6         ('0),
    .i_dfi_wrdata_mask_p7         ('0),
    .i_dfi_wrdata_en_p0           ('0),
    .i_dfi_wrdata_en_p1           ('0),
    .i_dfi_wrdata_en_p2           ('0),
    .i_dfi_wrdata_en_p3           ('0),
    .i_dfi_wrdata_en_p4           ('0),
    .i_dfi_wrdata_en_p5           ('0),
    .i_dfi_wrdata_en_p6           ('0),
    .i_dfi_wrdata_en_p7           ('0),
    .i_dfi_wck_en_p0              ('0),
    .i_dfi_wck_en_p1              ('0),
    .i_dfi_wck_en_p2              ('0),
    .i_dfi_wck_en_p3              ('0),
    .i_dfi_wck_en_p4              ('0),
    .i_dfi_wck_en_p5              ('0),
    .i_dfi_wck_en_p6              ('0),
    .i_dfi_wck_en_p7              ('0),
    .i_dfi_wck_toggle_p0          ('0),
    .i_dfi_wck_toggle_p1          ('0),
    .i_dfi_wck_toggle_p2          ('0),
    .i_dfi_wck_toggle_p3          ('0),
    .i_dfi_wck_toggle_p4          ('0),
    .i_dfi_wck_toggle_p5          ('0),
    .i_dfi_wck_toggle_p6          ('0),
    .i_dfi_wck_toggle_p7          ('0),
    // Read Data
    .i_dfi_rddata_cs_p0           ('0),
    .i_dfi_rddata_cs_p1           ('0),
    .i_dfi_rddata_cs_p2           ('0),
    .i_dfi_rddata_cs_p3           ('0),
    .i_dfi_rddata_cs_p4           ('0),
    .i_dfi_rddata_cs_p5           ('0),
    .i_dfi_rddata_cs_p6           ('0),
    .i_dfi_rddata_cs_p7           ('0),
    .i_dfi_rddata_en_p0           ('0),
    .i_dfi_rddata_en_p1           ('0),
    .i_dfi_rddata_en_p2           ('0),
    .i_dfi_rddata_en_p3           ('0),
    .i_dfi_rddata_en_p4           ('0),
    .i_dfi_rddata_en_p5           ('0),
    .i_dfi_rddata_en_p6           ('0),
    .i_dfi_rddata_en_p7           ('0),
    .o_dfi_rddata_w0              (),
    .o_dfi_rddata_w1              (),
    .o_dfi_rddata_w2              (),
    .o_dfi_rddata_w3              (),
    .o_dfi_rddata_w4              (),
    .o_dfi_rddata_w5              (),
    .o_dfi_rddata_w6              (),
    .o_dfi_rddata_w7              (),
    .o_dfi_rddata_dbi_w0          (),
    .o_dfi_rddata_dbi_w1          (),
    .o_dfi_rddata_dbi_w2          (),
    .o_dfi_rddata_dbi_w3          (),
    .o_dfi_rddata_dbi_w4          (),
    .o_dfi_rddata_dbi_w5          (),
    .o_dfi_rddata_dbi_w6          (),
    .o_dfi_rddata_dbi_w7          (),
    .o_dfi_rddata_valid_w0        (),
    .o_dfi_rddata_valid_w1        (),
    .o_dfi_rddata_valid_w2        (),
    .o_dfi_rddata_valid_w3        (),
    .o_dfi_rddata_valid_w4        (),
    .o_dfi_rddata_valid_w5        (),
    .o_dfi_rddata_valid_w6        (),
    .o_dfi_rddata_valid_w7        (),
    //RDI mainband
    .lp_data               (rdi_mb_if_1.lp_data),
    .lp_valid              (rdi_mb_if_1.lp_valid),
    .lp_irdy               (rdi_mb_if_1.lp_irdy),
    .pl_trdy               (rdi_mb_if_1.pl_trdy),
    .pl_data               (rdi_mb_if_1.pl_data),
    .pl_valid              (rdi_mb_if_1.pl_valid),
    //RDI sideband
    .lp_cfg                (),
    .lp_cfg_vld            (),
    .lp_cfg_crd            (),
    .pl_cfg                (),
    .pl_cfg_vld            (),
    .pl_cfg_crd            (),
    // Pads
    .pad_reset_n                  ('1),
    // Reset pad
    .pad_rext                     (),
    .pad_test                     (),
    // TEST pad
    .pad_ch0_ck_t                 (pad_ch0_ck_t),
    // CK
    .pad_ch0_ck_c                 (pad_ch0_ck_c),
    // CK
    .pad_ch0_ca                   (pad_ch0_ca),
    // CA/CS/CKE
    .pad_ch0_wck_t                (),
    // WCK
    .pad_ch0_wck_c                (),
    // WCK
    .pad_ch0_dqs_t                (pad_ch0_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch0_dqs_c                (pad_ch0_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch0_dq                   (pad_ch0_dq),
    // DQ/DBI/DM/PARITY
    .pad_ch1_ck_t                 (pad_ch1_ck_t),
    // CK
    .pad_ch1_ck_c                 (pad_ch1_ck_c),
    // CK
    .pad_ch1_ca                   (pad_ch1_ca),
    // CA/CS/CKE
    .pad_ch1_wck_t                (),
    // WCK
    .pad_ch1_wck_c                (),
    // WCK
    .pad_ch1_dqs_t                (pad_ch1_dqs_t),
    // RDQS/DQS/EDC/PARITY
    .pad_ch1_dqs_c                (pad_ch1_dqs_c),
    // RDQS/DQS/EDC
    .pad_ch1_dq                   (pad_ch1_dq),
    // DQ/DBI/DM/PARITY
    //Debug
    .o_debug                      ()
);
        bit [31:0] dq0_rt_dly;
        bit [31:0] dq1_rt_dly;
        bit [31:0] ca_rt_dly;

        bit [31:0] dq0_fc_dly;
        bit [31:0] dq1_fc_dly;
        bit [31:0] ca_fc_dly;

        bit [31:0] dq0_pipe_en;
        bit [31:0] dq1_pipe_en;
        bit [31:0] ca_pipe_en;

        bit [31:0] ahb_rdata;

    initial begin 
        $vcdpluson(0,mixed_phy_2_tb);
        itcm_dtcm_init();
        run_for_n_pkts=100;
        rdi_mb_if_0.lp_data  <= '0;
        rdi_mb_if_0.lp_valid  <= '0;
        rdi_mb_if_0.lp_irdy  <= '0;
        rdi_mb_if_1.lp_data  <= '0;
        rdi_mb_if_1.lp_valid  <= '0;
        rdi_mb_if_1.lp_irdy  <= '0;
        ahb_clk<=1'b0;
        ref_clk<=1'b0;
        rst<=1'b1;
        repeat (10) @(posedge mixed_phy_2_tb.ref_clk);
        rst<=1'b0;
        $display ("[%t] #########  Exit Reset #############", $time);
`ifdef MCU_CTRL
        $display ("[%t] #########  Begin loading SRAM #############", $time);
        u_sram_loader.begin_transfer(0);
        u_sram_loader.begin_transfer(1);
        repeat (100) @(posedge mixed_phy_2_tb.ref_clk);
        u_sram_loader.ahb_write(0,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(0,32'h00090024,32'h00000100);
        u_sram_loader.ahb_write(0,32'h00000004, 32'h1);
        repeat (100000) @(posedge mixed_phy_2_tb.ref_clk);
`else
        link_initialize(0,0,1);//ch1 rx/ch0 tx
        link_initialize(1,1,0);//ch1 tx/ch0 rx
        #10;
        $display ("[%t] #########  Initialization Done #############", $time);
        #10;
        //UCIE rxfifo clr/en
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111016);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111019);
        repeat (100) @(posedge mixed_phy_2_tb.ref_clk);
        //UCIE rxfifo clr/en
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
        u_sram_loader.ahb_read(0,32'h00150000,ahb_rdata);
        while(ahb_rdata[4]!=0) begin
            u_sram_loader.ahb_read(0,32'h00150000,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h00150000,ahb_rdata);
        while(ahb_rdata[4]!=0) begin
            u_sram_loader.ahb_read(1,32'h00150000,ahb_rdata);
        end
        $display ("[%t] #########  RXFIFO CLR #############", $time);
        link_rdqs_training(0,1,4'b0110,4'b1001);
        link_rdqs_training(1,0,4'b1001,4'b0110);
        //link_calibration_training_D0_2_D1();
        //link_calibration_training_D1_2_D0();
        #10;
        //begin txrx test
        //wait_training_done();
        $display ("[%t] #########  All Training Done #############", $time);
        //UCIE rxfifo clr/en
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111016);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111019);
        repeat (100) @(posedge mixed_phy_2_tb.ref_clk);
        //UCIE rxfifo clr/en
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
        u_sram_loader.ahb_read(0,32'h00150000,ahb_rdata);
        while(ahb_rdata[4]!=0) begin
            u_sram_loader.ahb_read(0,32'h00150000,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h00150000,ahb_rdata);
        while(ahb_rdata[4]!=0) begin
            u_sram_loader.ahb_read(1,32'h00150000,ahb_rdata);
        end
        $display ("[%t] #########  RXFIFO CLR #############", $time);
        $display ("[%t] #########  Begin Datapath Testing Tasks #############", $time);
        fork
	        data_xmit_0();
            data_xmit_1();
	        data_rcv_0();
	        data_rcv_1();
	    join
`endif
        $display ("[%t] #########  All Tasks are finished normally #############", $time);
        //end txrx test
        #100;
        Finish();
    end



//ahb write

    logic [31:0]         queue_ahb_haddr  [$] ;
    logic [31:0]         queue_ahb_hwdata  [$] ;

task itcm_dtcm_init;
    //load memory
`ifdef RAMFILE
    u_sram_loader.loadmem_00("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b0_byte03_byte00.ram");
    u_sram_loader.loadmem_01("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b1_byte03_byte00.ram");
    u_sram_loader.loadmem_02("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b2_byte03_byte00.ram");
    u_sram_loader.loadmem_03("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b3_byte03_byte00.ram");
    u_sram_loader.loadmem_04("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b4_byte03_byte00.ram");
    u_sram_loader.loadmem_05("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b5_byte03_byte00.ram");
    u_sram_loader.loadmem_06("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b6_byte03_byte00.ram");
    u_sram_loader.loadmem_07("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/itcm_2048x4_tcm0_b7_byte03_byte00.ram");
    
    u_sram_loader.loadmem_10("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b0_byte03_byte00.ram");
    u_sram_loader.loadmem_11("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b1_byte03_byte00.ram");
    u_sram_loader.loadmem_12("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b2_byte03_byte00.ram");
    u_sram_loader.loadmem_13("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b3_byte03_byte00.ram");
    u_sram_loader.loadmem_14("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b4_byte03_byte00.ram");
    u_sram_loader.loadmem_15("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b5_byte03_byte00.ram");
    u_sram_loader.loadmem_16("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b6_byte03_byte00.ram");
    u_sram_loader.loadmem_17("../wav-lpddr-hw/sw/tests/wddr_boot/ramfiles/dtcm_2048x4_tcm0_b7_byte03_byte00.ram");
`else
    u_sram_loader.loadmem_00("../wav-lpddr-hw/sw/wddr_boot_itcm_00.ram");
    u_sram_loader.loadmem_01("../wav-lpddr-hw/sw/wddr_boot_itcm_01.ram");
    u_sram_loader.loadmem_02("../wav-lpddr-hw/sw/wddr_boot_itcm_02.ram");

    u_sram_loader.loadmem_10("../wav-lpddr-hw/sw/wddr_boot_dtcm_00.ram");
    u_sram_loader.loadmem_11("../wav-lpddr-hw/sw/wddr_boot_dtcm_01.ram");
    u_sram_loader.loadmem_12("../wav-lpddr-hw/sw/wddr_boot_dtcm_02.ram");
`endif

endtask


task wait_training_done();
    wait(mixed_phy_2_tb.u_mixed_phy_0.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.buf_mode_sync==1'b0);
    wait(mixed_phy_2_tb.u_mixed_phy_1.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.buf_mode_sync==1'b0);
endtask

task data_xmit_0 ();
	static int pkts_gen = 0;
	bit [383:0] data = 0;
    int n_idles=0;
	
    while (pkts_gen < run_for_n_pkts) begin
        n_idles=$random%4;
        for(int i=1;i<48;i++) begin
	        data[i*8+:8] = $random;
        end
        data[7:0]=8'b11110000;
	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);       
	    @(negedge mixed_phy_2_tb.clk_0);
	    mixed_phy_2_tb.rdi_mb_if_0.lp_data  <= data;
        mixed_phy_2_tb.rdi_mb_if_0.lp_valid  <= 1'b1;
        mixed_phy_2_tb.rdi_mb_if_0.lp_irdy  <= 1'b1;
        @(posedge mixed_phy_2_tb.clk_0);
        while (mixed_phy_2_tb.rdi_mb_if_0.pl_trdy != 1'b1) @(posedge mixed_phy_2_tb.clk_0);
        repeat(n_idles) rdi_mb_idle_0();
        xmit_q_0.push_back(data);
        pkts_gen++;
    end
    rdi_mb_idle_0();
endtask

task data_xmit_1 ();
	static int pkts_gen = 0;
	bit [383:0] data = 0;
    int n_idles=0;
	
    while (pkts_gen < run_for_n_pkts) begin
        n_idles=$random%4;
        for(int i=1;i<48;i++) begin
	        data[i*8+:8] = $random;
        end
        data[7:0]=8'b11110000;
	    $display ("[%t] Generating data[%d] = %x \n", $time, pkts_gen, data);       
	    @(negedge mixed_phy_2_tb.clk_1);
	    mixed_phy_2_tb.rdi_mb_if_1.lp_data  <= data;
        mixed_phy_2_tb.rdi_mb_if_1.lp_valid  <= 1'b1;
        mixed_phy_2_tb.rdi_mb_if_1.lp_irdy  <= 1'b1;
        @(posedge mixed_phy_2_tb.clk_1);
        while (mixed_phy_2_tb.rdi_mb_if_1.pl_trdy != 1'b1) @(posedge mixed_phy_2_tb.clk_1);
        repeat(n_idles) rdi_mb_idle_1();
        xmit_q_1.push_back(data);
        pkts_gen++;
    end
    rdi_mb_idle_1();
endtask

task rdi_mb_idle_0();
    @(negedge mixed_phy_2_tb.clk_0);
    mixed_phy_2_tb.rdi_mb_if_0.lp_data  <= '0;
    mixed_phy_2_tb.rdi_mb_if_0.lp_valid  <= '0;
    mixed_phy_2_tb.rdi_mb_if_0.lp_irdy  <= '0;
endtask

task rdi_mb_idle_1();
    @(negedge mixed_phy_2_tb.clk_1);
    mixed_phy_2_tb.rdi_mb_if_1.lp_data  <= '0;
    mixed_phy_2_tb.rdi_mb_if_1.lp_valid  <= '0;
    mixed_phy_2_tb.rdi_mb_if_1.lp_irdy  <= '0;
endtask

//*************************************************
// task to check data received on TX side
//*************************************************
task data_rcv_0 ();
    bit [383:0] data_exp = 0;
    static int pkts_rcvd = 0;
    integer wait_timeout=5_000;
    begin
    fork
        begin
        @(posedge mixed_phy_2_tb.clk_0);
        while (wait_timeout > 0)
            begin
                wait_timeout = wait_timeout - 1;
                @(posedge mixed_phy_2_tb.clk_0);
            end
        end

        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge mixed_phy_2_tb.clk_0);
                if (mixed_phy_2_tb.rdi_mb_if_0.pl_valid===1'b1) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, mixed_phy_2_tb.rdi_mb_if_0.pl_data);
                    data_exp = xmit_q_1.pop_front();
                    pkts_rcvd++;
                    if (mixed_phy_2_tb.rdi_mb_if_0.pl_data != data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, mixed_phy_2_tb.rdi_mb_if_0.pl_data, data_exp);
                    end   
                end
            end
            if (xmit_q_1.size() != 0) //check if all the data are received
            $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q_1.size());    
        end
    join_any

    if (wait_timeout <= 0)
    begin
        $display ("ERROR Timeout waiting for rdi data at time %t", $time);
        $display (" size of data waiting to be received = %d", xmit_q_1.size  () );
        $finish();
    end

    end
endtask // mstr_req_rcv

task data_rcv_1 ();
    bit [383:0] data_exp = 0;
    static int pkts_rcvd = 0;
    integer wait_timeout=5_000;
    begin
    fork
        begin
        @(posedge mixed_phy_2_tb.clk_1);
        while (wait_timeout > 0)
            begin
                wait_timeout = wait_timeout - 1;
                @(posedge mixed_phy_2_tb.clk_1);
            end
        end

        begin
            while(pkts_rcvd < run_for_n_pkts) begin
                @ (posedge mixed_phy_2_tb.clk_1);
                if (mixed_phy_2_tb.rdi_mb_if_1.pl_valid===1'b1) begin
                    $display ("[%t] Receiving data[%d] = %x \n", $time, pkts_rcvd, mixed_phy_2_tb.rdi_mb_if_1.pl_data);
                    data_exp = xmit_q_0.pop_front();
                    pkts_rcvd++;
                    if (mixed_phy_2_tb.rdi_mb_if_1.pl_data != data_exp) begin
                        err_count++;
                        $display ("[%t]DATA COMPARE ERROR: received = %x | expected = %x\n", $time, mixed_phy_2_tb.rdi_mb_if_1.pl_data, data_exp);
                    end   
                end
            end
            if (xmit_q_0.size() != 0) //check if all the data are received
            $display("[%t]ERROR: Tramit Queue Not Empty, still %d data left\n", $time, xmit_q_0.size());    
        end
    join_any

    if (wait_timeout <= 0)
    begin
        err_count++;
        $display ("ERROR Timeout waiting for rdi data at time %t", $time);
        $display (" size of data waiting to be received = %d", xmit_q_0.size  () );
        $finish();
    end

    end
endtask // mstr_req_rcv

//---------------------------------------------------------------
    // Finish

task Finish ();
begin
	$display("%0t: %m: finishing simulation..", $time);
	repeat (10) @(posedge mixed_phy_2_tb.ref_clk);
	$display("\n////////////////////////////////////////////////////////////////////////////");
	$display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	$display("////////////////////////////////////////////////////////////////////////////\n");
    if (err_count == 0) 
    begin    
        $display("      ");
        $display("      ");
        $display("########     ###      ######    ######     ##   ##   ##"); 
        $display("##     ##   ## ##    ##    ##  ##    ##    ##   ##   ##"); 
        $display("##     ##  ##   ##   ##        ##          ##   ##   ##"); 
        $display("########  ##     ##   ######    ######     ##   ##   ##"); 
        $display("##        #########        ##        ##    ##   ##   ##"); 
        $display("##        ##     ##  ##    ##  ##    ##                "); 
        $display("##        ##     ##   ######    ######     ##   ##   ##"); 
    end
    else begin
        $display("      ");
        $display("      ");
        $display("########    ###       ####    ##          ##   ##   ##"); 
        $display("##         ## ##       ##     ##          ##   ##   ##"); 
        $display("##        ##   ##      ##     ##          ##   ##   ##"); 
        $display("######   ##     ##     ##     ##          ##   ##   ##"); 
        $display("##       #########     ##     ##          ##   ##   ##"); 
        $display("##       ##     ##     ##     ##                      "); 
        $display("##       ##     ##    ####    ########    ##   ##   ##"); 
    end
	$finish;
end
endtask

bit [4:0] ZQ_NCAL_index;
bit [5:0] ZQ_PCAL_index;
bit [31:0] ZQ_index;

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
        $display ("[%t] #########  Initializing DIE %d with CH0 %s || CH1 %s #########",$time,die_index,ch0_config,ch1_config);
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

        if(ch0_tx_rx_n==1) CH_TX_initialize(die_index,0);
        else CH_RX_initialize(die_index,0);

        if(ch1_tx_rx_n==1) CH_TX_initialize(die_index,1);
        else CH_RX_initialize(die_index,1);
        $display ("[%t] #########  Die %d Initializing Done   #########",$time,die_index);
    end
endtask

task CH_TX_initialize();
    input [1:0] die_index;
    input channel_index;
    bit [31:0] ch_offset;
    begin
        ch_offset=channel_index?32'h00030000:32'h00000000;
        //TX
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(die_index,ch_offset+32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(die_index,ch_offset+32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(die_index,ch_offset+32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(die_index,ch_offset+32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
    end
endtask

task CH_RX_initialize();
    input [1:0] die_index;
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

task link_rdqs_training();
    input [1:0] die_index_departure;
    input [1:0] die_index_distination;
    input [3:0] departure_txrx;
    input [3:0] distination_txrx;
    bit [72-1:0]tx_dqs_pattern;
    bit [72-1:0]ck_dqs_pattern_valid;
    bit [72-1:0]ck_dqs_pattern_not_valid;
    bit [72-1:0]rx_dqs_pattern;

    bit [72*3-1:0]ch0_dqs_pattern;
    bit [72*3-1:0]ch1_dqs_pattern;
    bit [72*3-1:0]ch0_dqs_pattern_valid;
    bit [72*3-1:0]ch1_dqs_pattern_valid;
    begin
        ck_dqs_pattern_valid=72'h00ffff00_00ff0000_0f;
        ck_dqs_pattern_not_valid=72'h00ffff00_00ff0000_00;
        tx_dqs_pattern=72'h00ff000000ff005500;
        rx_dqs_pattern=72'hff0000ffff00ff0000;
        ch0_dqs_pattern=(departure_txrx[1:0]==2'b10)?{{2{tx_dqs_pattern}},ck_dqs_pattern_not_valid}:{3{rx_dqs_pattern}};
        ch0_dqs_pattern_valid=(departure_txrx[1:0]==2'b10)?{{2{tx_dqs_pattern}},ck_dqs_pattern_valid}:{3{rx_dqs_pattern}};
        ch1_dqs_pattern=(departure_txrx[3:2]==2'b10)?{{2{tx_dqs_pattern}},ck_dqs_pattern_not_valid}:{3{rx_dqs_pattern}};
        ch1_dqs_pattern_valid=(departure_txrx[3:2]==2'b10)?{{2{tx_dqs_pattern}},ck_dqs_pattern_valid}:{3{rx_dqs_pattern}};
        $display ("[%t] #########  Begin Link Training D0 CH0->D1 CH0  #########",$time);
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        //lt_mode<=3'b001; //send 01010101
        //D0 buf_mode=1
        u_sram_loader.ahb_write(die_index_departure,32'h00150000,{28'h0011110,departure_txrx});
        u_sram_loader.ahb_write(die_index_distination,32'h00150000,{28'h0011100,distination_txrx});
        // ts enable
        u_sram_loader.ahb_write(die_index_departure,32'h00150008,32'h00200111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=0x20
        u_sram_loader.ahb_write(die_index_departure,32'h0015000C,32'h20000000); //ig_hold=1
        u_sram_loader.ahb_read(die_index_departure,32'h0015000C,ahb_rdata); //ig_hold=1
        while(ahb_rdata[29]!=1) begin
            u_sram_loader.ahb_read(die_index_departure,32'h0015000C,ahb_rdata);
        end
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid disable
        send_ucie_ingress_data(die_index_departure,{432'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101,ch0_dqs_pattern,ch1_dqs_pattern});
        //valid enable
        send_ucie_ingress_data(die_index_departure,{432'h00100101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101,ch0_dqs_pattern_valid,ch1_dqs_pattern_valid});
        //valid disable
        send_ucie_ingress_data(die_index_departure,{432'h00110101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101,ch0_dqs_pattern,ch1_dqs_pattern});
        //reset timestamp
        send_ucie_ingress_data(die_index_departure,{432'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101,ch0_dqs_pattern,ch1_dqs_pattern});
        u_sram_loader.ahb_write(die_index_departure,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //read egress data
        $display ("[%t] #########  Before Training     #########",$time);
        read_ucie_egress_data(die_index_distination,{distination_txrx[2],distination_txrx[0]},egress_data);//read ch0 rx data
        //distination, ch0-rx
        if(distination_txrx[0]) begin
            if((egress_data[351:344]==8'h02) || (egress_data[351:344]==8'h08) || (egress_data[351:344]==8'h20)|| (egress_data[351:344]==8'h80))
            //begin link rdqs training, rdqs delay tuning
            u_sram_loader.ahb_write(die_index_distination,32'h000F0820,32'h0000FFFF); //Ch0_DQ0_DQS_RX_IO_M0_R0
            u_sram_loader.ahb_write(die_index_distination,32'h00100820,32'h0000FFFF); //Ch0_DQ1_DQS_RX_IO_M0_R0
            u_sram_loader.ahb_write(die_index_distination,32'h000F0824,32'h0000FFFF); //Ch0_DQ0_DQS_RX_IO_M0_R1
            u_sram_loader.ahb_write(die_index_distination,32'h00100824,32'h0000FFFF); //Ch0_DQ1_DQS_RX_IO_M0_R1
        end
        //distination, ch1-rx
        if(distination_txrx[2]) begin
            if((egress_data[71:64]==8'h02) || (egress_data[71:64]==8'h08) || (egress_data[71:64]==8'h20)|| (egress_data[71:64]==8'h80))
            //begin link rdqs training, rdqs delay tuning
            u_sram_loader.ahb_write(die_index_distination,32'h00120820,32'h0000FFFF); //Ch1_DQ0_DQS_RX_IO_M0_R0
            u_sram_loader.ahb_write(die_index_distination,32'h00130820,32'h0000FFFF); //Ch1_DQ1_DQS_RX_IO_M0_R0
            u_sram_loader.ahb_write(die_index_distination,32'h00120824,32'h0000FFFF); //Ch1_DQ0_DQS_RX_IO_M0_R1
            u_sram_loader.ahb_write(die_index_distination,32'h00130824,32'h0000FFFF); //Ch1_DQ1_DQS_RX_IO_M0_R1
        end
        //clr
        u_sram_loader.ahb_write(die_index_distination,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(die_index_distination,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        /*
        should further check if egress fifo is empty. If not, means valid signal is not aligned correctly.
        */
        //clr
        u_sram_loader.ahb_write(die_index_distination,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(die_index_distination,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk); 
        $display ("[%t] #########  RDQS Calibration Done     #########",$time);
    end
endtask


task link_calibration_training_D0_2_D1();
    begin
        //D0 buf_mode=1
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111106);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
        // ts enable
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid enable
        send_ucie_ingress_data(0,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(0,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        read_ucie_egress_data(1,2'b01,egress_data);
        //end rdqs training, still  dq0 get 40404040 dq1 get 01010101 ca get 10101010
        //begin dq alignment training, 1 ddr fc delay 1 qdr cycle, qdr_pipe_en
        /*
        if (egress_data[143:136]==8'h01) begin
            dq0_fc_dly=0;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h04) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=3;
        end else if (egress_data[143:136]==8'h10) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h40) begin
            dq0_fc_dly=32'h0;
            dq0_pipe_en=3;
        end

        if (egress_data[71:64]==8'h01) begin
            dq1_fc_dly=0;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h04) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=3;
        end else if (egress_data[71:64]==8'h10) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h40) begin
            dq1_fc_dly=32'h0;
            dq1_pipe_en=3;
        end

        if (egress_data[7:0]==8'h01) begin
            ca_fc_dly=0;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h04) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=3;
        end else if (egress_data[7:0]==8'h10) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h40) begin
            ca_fc_dly=32'h0;
            ca_pipe_en=3;
        end
        */
        if (egress_data[351:344]==8'h01) begin
            dq0_fc_dly=0;
            dq0_pipe_en=0;
        end else if (egress_data[351:344]==8'h04) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=3;
        end else if (egress_data[351:344]==8'h10) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=0;
        end else if (egress_data[351:344]==8'h40) begin
            dq0_fc_dly=32'h0;
            dq0_pipe_en=3;
        end

        if (egress_data[279:272]==8'h01) begin
            dq1_fc_dly=0;
            dq1_pipe_en=0;
        end else if (egress_data[279:272]==8'h04) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=3;
        end else if (egress_data[279:272]==8'h10) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=0;
        end else if (egress_data[279:272]==8'h40) begin
            dq1_fc_dly=32'h0;
            dq1_pipe_en=3;
        end

        if (egress_data[215:208]==8'h01) begin
            ca_fc_dly=0;
            ca_pipe_en=0;
        end else if (egress_data[215:208]==8'h04) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=3;
        end else if (egress_data[215:208]==8'h10) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=0;
        end else if (egress_data[215:208]==8'h40) begin
            ca_fc_dly=32'h0;
            ca_pipe_en=3;
        end
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(0,32'h000F0434,dq0_fc_dly); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(0,32'h00100434,dq1_fc_dly); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
         //CA FC DLY
        u_sram_loader.ahb_write_all_lane(0,32'h00110504,ca_fc_dly); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //valid FC DLY (follow CA)
        u_sram_loader.ahb_write(0,32'h00110AB8,ca_fc_dly); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(0,32'h00110ABC,ca_fc_dly); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
        //now dq1/dq0/ca get 04040404
        //DQ0_DDR Pipe
        u_sram_loader.ahb_write_all_lane(0,32'h000F04C4,dq0_pipe_en); //CH0_DQ0_DQ_TX_DDR_M0_R1_CFG_0-8
        //DQ1_DDR Pipe
        u_sram_loader.ahb_write_all_lane(0,32'h001004C4,dq1_pipe_en); //CH0_DQ1_DQ_TX_DDR_M0_R1_CFG_0-8
        //CA_DDR Pipe
        u_sram_loader.ahb_write_all_lane(0,32'h001105B4,ca_pipe_en); //CH0_CA_DQ_TX_DDR_M0_R1_CFG_0-8
        //valid DDR Pipe
        u_sram_loader.ahb_write(0,32'h00110AC8,ca_pipe_en); //CH0_CA_DQS_TX_DDR_M0_R0_CFG_0
        u_sram_loader.ahb_write(0,32'h00110ACC,ca_pipe_en); //CH0_CA_DQS_TX_DDR_M0_R1_CFG_0
        //get 10101010
        u_sram_loader.wait_until_empty();
        //clr
        u_sram_loader.ahb_write(1,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(1,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid enable
        send_ucie_ingress_data(0,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(0,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        read_ucie_egress_data(1,2'b01,egress_data);
        $display ("[%t] #########  DQ Alignment Calibration Done #########",$time);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Begin Channel Alignment Training #########",$time);
        /*
        //loop mode bugs found, loop count not useful
        u_sram_loader.ahb_write(0,32'h0015000C,32'hf0000000); //ingress fifo clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h0015000C,32'he0003101); //loop mode disable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h0015000C,32'he0003001); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        send_ucie_ingress_data(864'h04000101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04010202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,0,0,30'h20003001,0);
        send_ucie_ingress_data(864'h04020303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04030404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000,0,0,30'h20003001,0);
        u_sram_loader.ahb_write(0,32'h0015000C,32'he00031f1); //loop mode enable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.ahb_write(0,32'h0015000C,32'he00030f1); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        #1000;
        */
        //use ts instead
        //clr
        u_sram_loader.ahb_write(1,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(1,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(0,864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(0,864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        dq0_rt_dly=0;
        dq1_rt_dly=0;
        ca_rt_dly=0;
        integer dq0_dly=0;
        integer dq1_dly=0;
        integer ca_dly=0;

        if(egress_data[351:344]==8'h02) begin
            dq0_dly=1;
        end else if (egress_data[351:344]==8'h03) begin
            dq0_dly=2;
        end else $display ("[%t] #########  DQ0 ahead too much!!! #########",$time);

        if(egress_data[279:272]==8'h02) begin
            dq1_dly=1;
        end else if (egress_data[279:272]==8'h03) begin
            dq1_dly=2;
        end else $display ("[%t] #########  DQ1 ahead too much!!! #########",$time);

        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        if(egress_data[351:344]==8'h01 || egress_data[279:272]==8'h01) begin
            ca_fc_dly[3:0]=ca_fc_dly[3:0]+4'd2;
            ca_rt_dly[0]=1'b0;
            //check dq0/dq1
            if (egress_data[351:344]==8'h02) begin
                if(dq0_fc_dly[3:1]==0) dq0_fc_dly[3:0]=dq0_fc_dly[3:0]+4'd2;
                else if(dq0_fc_dly[3:0]==4'd2) begin
                    dq0_fc_dly[3:0]=4'd3;
                    dq0_rt_dly[0]=1'b1;
                end
            end

            if (egress_data[279:272]==8'h02) begin
                if(dq1_fc_dly[3:1]==0) dq1_fc_dly[3:0]=dq1_fc_dly[3:0]+4'd2;
                else if(dq1_fc_dly[3:0]==4'd2) begin
                    dq1_fc_dly[3:0]=4'd3;
                    dq1_rt_dly[0]=1'b1;
                end
            end
        end 
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        if(egress_data[351:344]==8'h01 || egress_data[279:272]==8'h01) begin
            if(ca_fc_dly==4'd0) begin
                ca_fc_dly[3:0]=4'd3;
                ca_rt_dly[0]=1'b1;
                if (egress_data[351:344]==8'h03) begin
                    if(dq0_fc_dly[3:0]==0) begin
                        dq0_fc_dly[3:0]=4'd3;
                        dq0_rt_dly[0]=1'b1;
                    end else $display ("[%t] #########  DQ1 lag too much!!! #########",$time);
                end

                if (egress_data[279:272]==8'h03) begin
                    if(dq1_fc_dly[3:0]==0) begin
                        dq1_fc_dly[3:0]=4'd3;
                        dq1_rt_dly[0]=1'b1;
                    end else $display ("[%t] #########  DQ0 lag too much!!! #########",$time);
                end
            end else $display ("[%t] #########  CA ahead too much!!! #########",$time);
        end 
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        //dq1 delay 2 full cycle
        //ca delay 1 full cycle
         //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(0,32'h000F0434,{8{dq0_fc_dly[3:0]}}); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ0 RT PIPE
        u_sram_loader.ahb_write(0,32'h000F02E4,{23'h0,{9{dq0_rt_dly[0]}}}); // CH0_DQ0__DQ_TX_RT_M0_R1_CFG
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(0,32'h00100434,{8{dq1_fc_dly[3:0]}}); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 RT PIPE
        u_sram_loader.ahb_write(0,32'h001002E4,{23'h0,{9{dq1_rt_dly[0]}}}); // CH0_DQ1__DQ_TX_RT_M0_R1_CFG
         //CA FC DLY
        u_sram_loader.ahb_write_all_lane(0,32'h00110504,{8{ca_fc_dly[3:0]}}); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //CA RT PIPE
        u_sram_loader.ahb_write(0,32'h0011036C,{22'h0,{10{ca_rt_dly[0]}}}); // CH0_CA__DQ_TX_RT_M0_R1_CFG
        //valid FC DLY (follow CA)
        u_sram_loader.ahb_write(0,32'h00110AB8,{8{ca_fc_dly[3:0]}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(0,32'h00110ABC,{8{ca_fc_dly[3:0]}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
        //Valid RT PIPE
        u_sram_loader.ahb_write(0,32'h00110A88,{31'h0,ca_rt_dly[0]}); // CH0_CA__DQS_TX_RT_M0_R0_CFG
        u_sram_loader.ahb_write(0,32'h00110A8C,{31'h0,ca_rt_dly[0]}); // CH0_CA__DQS_TX_RT_M0_R1_CFG
        
        
        $display ("[%t] ######  Channel Alignment Testing After Tuning ######",$time);
        u_sram_loader.ahb_write(0,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(0,864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_020200ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_030300ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid enable
        send_ucie_ingress_data(0,864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_040400ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0fff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //valid disable
        send_ucie_ingress_data(0,864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        //reset timestamp
        send_ucie_ingress_data(0,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_010100ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff0000);
        u_sram_loader.ahb_write(0,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time);
        read_ucie_egress_data(1,2'b01,egress_data);
        $display ("[%t] ####  Channel Alignment Calibration Done, Exit D0 CH0->D1 CH0 Training Mode ####",$time);
        //buf_mode=0
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
    end
endtask


task link_calibration_training_D1_2_D0();
    begin
        //D1 buf_mode=1
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111109);
        // ts enable
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000||00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||};
        //valid enable
        send_ucie_ingress_data(1,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid disable
        send_ucie_ingress_data(1,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //reset timestamp
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        read_ucie_egress_data(0,2'b10,egress_data);
        //end rdqs training, still  dq0 get 40404040 dq1 get 01010101 ca get 10101010
        //begin dq alignment training, 1 ddr fc delay 1 qdr cycle, qdr_pipe_en
        if (egress_data[143:136]==8'h01) begin
            dq0_fc_dly=0;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h04) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=3;
        end else if (egress_data[143:136]==8'h10) begin
            dq0_fc_dly=32'h11111111;
            dq0_pipe_en=0;
        end else if (egress_data[143:136]==8'h40) begin
            dq0_fc_dly=32'h0;
            dq0_pipe_en=3;
        end

        if (egress_data[71:64]==8'h01) begin
            dq1_fc_dly=0;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h04) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=3;
        end else if (egress_data[71:64]==8'h10) begin
            dq1_fc_dly=32'h11111111;
            dq1_pipe_en=0;
        end else if (egress_data[71:64]==8'h40) begin
            dq1_fc_dly=32'h0;
            dq1_pipe_en=3;
        end

        if (egress_data[7:0]==8'h01) begin
            ca_fc_dly=0;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h04) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=3;
        end else if (egress_data[7:0]==8'h10) begin
            ca_fc_dly=32'h11111111;
            ca_pipe_en=0;
        end else if (egress_data[7:0]==8'h40) begin
            ca_fc_dly=32'h0;
            ca_pipe_en=3;
        end
        
        //DQ0 FC DLY
        u_sram_loader.ahb_write_all_lane(1,32'h00120434,dq0_fc_dly); //CH1_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        u_sram_loader.ahb_write_all_lane(1,32'h00130434,dq1_fc_dly); //CH1_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
         //CA FC DLY
        u_sram_loader.ahb_write_all_lane(1,32'h00140504,ca_fc_dly); //CH1_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //valid FC DLY (follow CA)
        u_sram_loader.ahb_write(1,32'h00140AB8,ca_fc_dly); //CH1_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        u_sram_loader.ahb_write(1,32'h00140ABC,ca_fc_dly); //CH1_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
        //now dq1/dq0/ca get 04040404
        //DQ0_DDR Pipe
        u_sram_loader.ahb_write_all_lane(1,32'h001204C4,dq0_pipe_en); //CH1_DQ0_DQ_TX_DDR_M0_R1_CFG_0-8
        //DQ1_DDR Pipe
        u_sram_loader.ahb_write_all_lane(1,32'h001304C4,dq1_pipe_en); //CH1_DQ1_DQ_TX_DDR_M0_R1_CFG_0-8
        //CA_DDR Pipe
        u_sram_loader.ahb_write_all_lane(1,32'h001405B4,ca_pipe_en); //CH1_CA_DQ_TX_DDR_M0_R1_CFG_0-8
        //valid DDR Pipe
        u_sram_loader.ahb_write(1,32'h00140AC8,ca_pipe_en); //CH1_CA_DQS_TX_DDR_M0_R0_CFG_0
        u_sram_loader.ahb_write(1,32'h00140ACC,ca_pipe_en); //CH1_CA_DQS_TX_DDR_M0_R1_CFG_0
        //get 10101010
        u_sram_loader.wait_until_empty();
        //clr
        u_sram_loader.ahb_write(0,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101.('h ts 0000|| dq/ca 0101_01010101_010101||01_01010101_01010101||01010101_01010101||01010101_01010101_01||010101_01010101_0101||0101_01010101_0101
        //dqs/ck 00ff_000000ff_005500||00_ff000000_ff005500||00ffff00_00ff0000_0f||ff0000_ffff00ff_0000||ff00_00ffff00_ff0000||ff_0000ffff_00ff0000};
        //valid enable
        send_ucie_ingress_data(1,864'h00050101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid disable
        send_ucie_ingress_data(1,864'h00060101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //reset timestamp
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        read_ucie_egress_data(0,2'b10,egress_data);
        $display ("[%t] #########  DQ Alignment Calibration Done #########",$time);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Begin Channel Alignment Training #########",$time);
        /*
        //loop mode bugs found, loop count not useful
        u_sram_loader.ahb_write(0,32'h0015000C,32'hf0000000); //ingress fifo clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h0015000C,32'he0003101); //loop mode disable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h0015000C,32'he0003001); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        send_ucie_ingress_data(864'h04000101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04010202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_0202ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f,0,0,30'h20003001,0);
        send_ucie_ingress_data(864'h04020303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_0303ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f,1,1,30'h20003001,1);
        send_ucie_ingress_data(864'h04030404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_0404ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f,0,0,30'h20003001,0);
        u_sram_loader.ahb_write(0,32'h0015000C,32'he00031f1); //loop mode enable, max loop=15, load_ptr=1,start ptr=0, stop ptr=3
        u_sram_loader.ahb_write(0,32'h0015000C,32'he00030f1); //loop mode enable, max loop=15, load_ptr=0,start ptr=0, stop ptr=3
        #1000;
        */
        //use ts instead
        //clr
        u_sram_loader.ahb_write(0,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(0,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(1,864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_0202ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_0303ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_0404ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid disable
        send_ucie_ingress_data(1,864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_0000ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //reset timestamp
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time); 
        read_ucie_egress_data(0,2'b10,egress_data);
        
        //dq1 delay 2 full cycle
        //ca delay 1 full cycle
         //DQ0 FC DLY
        //u_sram_loader.ahb_write_all_lane(1,32'h00120434,{8{dq0_fc_dly[3:0]+4'd2}}); //CH0_DQ0_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 FC_DLY
        //u_sram_loader.ahb_write_all_lane(1,32'h00130434,{8{dq1_fc_dly[3:0]+4'd2}}); //CH0_DQ1_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //DQ1 RT PIPE
        //u_sram_loader.ahb_write(1,32'h001302E4,32'h000001FF); // CH0_DQ1__DQ_TX_RT_M0_R1_CFG
         //CA FC DLY
        //u_sram_loader.ahb_write_all_lane(1,32'h00140504,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQ_TX_SDR_FC_DLY_M0_R1_CFG_0-8
        //valid FC DLY (follow CA)
        //u_sram_loader.ahb_write(1,32'h00140AB8,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R0_CFG_0
        //u_sram_loader.ahb_write(1,32'h00140ABC,{8{ca_fc_dly[3:0]+4'd2}}); //CH0_CA_DQS_TX_SDR_FC_DLY_M0_R1_CFG_0
        
        $display ("[%t] ######  Channel Alignment Testing After Tuning ######",$time);
        u_sram_loader.ahb_write(1,32'h00150018,32'h1); //clr
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(1,32'h00150018,32'h0); //en
        u_sram_loader.wait_until_empty();
        repeat (50) @(posedge mixed_phy_2_tb.ahb_clk);
        // ts enable
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0111); //ts_enable=1 ts_reset=1 ts_brkpt_enable=1  ts_brkpt_val=10
        repeat (5) @(posedge mixed_phy_2_tb.ahb_clk);
        //write 01010101/02020202/03030303/04040404
        //valid enable
        send_ucie_ingress_data(1,864'h00030101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00040202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_02020202_0202ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00050303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_03030303_0303ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid enable
        send_ucie_ingress_data(1,864'h00060404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_04040404_0404ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_0f);
        //valid disable
        send_ucie_ingress_data(1,864'h00070000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000_0000ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        //reset timestamp
        send_ucie_ingress_data(1,864'h00010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_01010101_0101ff0000_ffff00ff_0000ff00_00ffff00_ff0000ff_0000ffff_00ff000000ff_000000ff_00550000_ff000000_ff005500_00ffff00_00ff0000_00);
        u_sram_loader.ahb_write(1,32'h00150008,32'h000A0101); //release reset
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk); 
        $display ("[%t] #########  Receiving First Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Second Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Third Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        $display ("[%t] #########  Receiving Fourth Egress Data #########",$time);
        read_ucie_egress_data(0,2'b10,egress_data);
        $display ("[%t] ####  Channel Alignment Calibration Done, Exit D1 CH1->D0 CH1 Training Mode ####",$time);
        //buf_mode=0
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111006);
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111009);
    end
endtask

task send_ucie_ingress_data;
    input [1:0] die_index;
    input [863:0] ingress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit [29:0] other_csr;
    bit ig_en;
    bit init_done_sta;
    u_sram_loader.ahb_read(die_index,32'h0015000C,ahb_rdata);
    init_en_sta=ahb_rdata[30];
    init_upd_sta=ahb_rdata[31];
    other_csr=ahb_rdata[29:0];
    ig_en=init_en_sta;
    for(int i=26;i>=0;i--) begin
        ig_en=~ig_en;
        u_sram_loader.ahb_write(die_index,32'h00150010,ingress_data[i*32+:32]);
        u_sram_loader.wait_until_empty();
        u_sram_loader.ahb_write(die_index,32'h0015000C,{init_upd_sta,ig_en,other_csr}); //wdata_en=toggle wdata_hold=1
        u_sram_loader.wait_until_empty();
    end
    //upd
    u_sram_loader.ahb_write(die_index,32'h0015000C,{~init_upd_sta,ig_en,other_csr}); //wdata_upd=toggle
    u_sram_loader.wait_until_empty();
    u_sram_loader.ahb_read(die_index,32'h00150014,ahb_rdata);
    //while(ahb_rdata[4]!=(~init_done_sta)) u_sram_loader.ahb_read(0,32'h00150014,ahb_rdata);
    //wait(mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_ig_write_done==(~init_done_sta));
endtask

task read_ucie_egress_data;
    input [1:0] die_index;
    input [1:0] channel_index; //2'b01 channel 0/// 2'b10 channel 1 /// 2'b11 channel 0+1
    output [447:0] egress_data;
    bit init_en_sta;
    bit init_upd_sta;
    bit eg_en;
    bit read_done;
    u_sram_loader.ahb_read(die_index,32'h00150018,ahb_rdata);
    init_en_sta=ahb_rdata[4];
    init_upd_sta=ahb_rdata[8];
    eg_en=init_en_sta;
    u_sram_loader.ahb_read(die_index,32'h0015001C,ahb_rdata);
    while(ahb_rdata[0]==1'b1) begin
        u_sram_loader.ahb_read(die_index,32'h0015001C,ahb_rdata);
    end
    read_done=ahb_rdata[4];
    //wait(mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_empty==1'b0);
    u_sram_loader.ahb_write(die_index,32'h00150018,{23'd0,~init_upd_sta,3'd0,eg_en,4'd0}); //rdata_upd=toggle
    u_sram_loader.ahb_read(die_index,32'h0015001C,ahb_rdata);
    while(ahb_rdata[4]==read_done) begin
        u_sram_loader.ahb_read(die_index,32'h0015001C,ahb_rdata);
    end
    //wait(mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_read_done==1'b1);
    for(int i=0;i<=13;i++) begin
        eg_en=~eg_en;
        u_sram_loader.ahb_read(die_index,32'h00150020,egress_data[i*32+:32]);
        //egress_data[i*32+:32]=mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.o_eg_rdata;
        u_sram_loader.ahb_write(die_index,32'h00150018,{23'd0,~init_upd_sta,3'd0,eg_en,4'd0}); //rdata_en=toggle
        u_sram_loader.wait_until_empty();
        //wait(mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b1);
        //wait(mixed_phy_2_tb.u_mixed_phy.u_ucie_channel_adapter_wrapper.u_ucie_channel_adapter.u_ucie_buf.rdata_loader_en==1'b0);
    end
    if(channel_index[0]==1) begin
        $display ("[%t] Read Egress Data from DIE %d Time Stamp 0x%h.",$time,die_index,egress_data[431:416]);
        $display ("[%t] Read Egress Data from DIE %d CH0 DQ0 0x%h.",$time,die_index,egress_data[415:344]);
        $display ("[%t] Read Egress Data from DIE %d CH0 DQ1 0x%h.",$time,die_index,egress_data[343:272]);
        $display ("[%t] Read Egress Data from DIE %d CH0 CA 0x%h.",$time,die_index,egress_data[271:208]);
    end
    if(channel_index[1]==1) begin
        $display ("[%t] Read Egress Data from DIE %d Time Stamp 0x%h.",$time,die_index,egress_data[431:416]);
        $display ("[%t] Read Egress Data from DIE %d CH1 DQ0 0x%h.",$time,die_index,egress_data[207:136]);
        $display ("[%t] Read Egress Data from DIE %d CH1 DQ1 0x%h.",$time,die_index,egress_data[135:64]);
        $display ("[%t] Read Egress Data from DIE %d CH1 CA 0x%h.",$time,die_index,egress_data[63:0]);
    end
endtask
endmodule

task link_initialize_0();
    begin
        $display ("[%t] #########  Initializing DIE 0  #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(0,32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(0,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(0,32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(0,32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(0,32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(0,32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(0,32'h0009000C,32'h000002FA);
        //ZQCAL process
        u_sram_loader.ahb_write(0,32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(0,32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(0,32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(0,32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(0,32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(0,32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(0,32'h00090014,ahb_rdata);
        end
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(0,32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(0,32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(0,32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(0,32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(0,32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(0,32'h0009800C,ahb_rdata);
        end
        //VCO1
        u_sram_loader.ahb_write(0,32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(0,32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(0,32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(0,32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(0,32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(0,32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(0,32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(0,32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(0,32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(0,32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(0,32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(0,32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(0,32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(0,32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(0,32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(0,32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(0,32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(0,32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(0,32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(0,32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(0,32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:tx ch1:rx
        u_sram_loader.ahb_write(0,32'h00150000,32'h00111016);
        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(0,32'h000F0290,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02B0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02D0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h000F0294,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02B4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F02D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h000F0984,32'h00004040);

        //enable all TX PI__CH0_DQ1
        u_sram_loader.ahb_write(0,32'h00100290,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002B0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002D0,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00100294,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002B4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001002D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00100984,32'h00004040);

        //enable all TX PI__CH0_CA
        u_sram_loader.ahb_write(0,32'h00110318,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110338,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110358,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(0,32'h0011031C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0011033C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0011035C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(0,32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(0,32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(0,32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(0,32'h00110A6C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00110A7C,32'h00004040);

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(0,32'h001207F4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207E4,32'h00004040);

        u_sram_loader.ahb_write(0,32'h001207F8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207D8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001207E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(0,32'h001307F4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307D4,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307E4,32'h00004040);

        u_sram_loader.ahb_write(0,32'h001307F8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307D8,32'h00004040);
        u_sram_loader.ahb_write(0,32'h001307E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(0,32'h0014098C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0014096C,32'h00004040);
        u_sram_loader.ahb_write(0,32'h0014097C,32'h00004040);

        u_sram_loader.ahb_write(0,32'h00140990,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140970,32'h00004040);
        u_sram_loader.ahb_write(0,32'h00140980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F01F0,32'h00000004); //Ch0_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h000F0880,32'h00000004); //Ch0_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h001001F0,32'h00000004); //Ch0_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h00100880,32'h00000004); //Ch0_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(0,32'h00110258,32'h00000004); //Ch0_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(0,32'h001109F8,32'h00000004); //Ch0_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F03A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h001003A4,32'h00003120); //Ch0_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00110454,32'h00003120); //Ch0_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(0,32'h000F0A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100A54,32'h00003120); //Ch0_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(0,32'h00110AAC,32'h00003120); //Ch0_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(0,32'h000F0554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100554,32'h00000010); //Ch0_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00110664,32'h00000010); //Ch0_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(0,32'h000F0C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(0,32'h00100C04,32'h00000010); //Ch0_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(0,32'h00110ADC,32'h00000010); //Ch0_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        u_sram_loader.ahb_write(0,32'h0012083C,32'h00427777); //Ch1_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(0,32'h0013083C,32'h00427777); //Ch1_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(0,32'h001409C4,32'h00427777); //Ch1_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(0,32'h001207B8,32'h00000084); //Ch1_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(0,32'h001307B8,32'h00000084); //Ch1_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(0,32'h00140950,32'h00000084); //Ch1_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(0,32'h00120000,32'h00000100); //Ch1_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(0,32'h00130000,32'h00000100); //Ch1_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(0,32'h00140000,32'h00000100); //Ch1_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(0,32'h00120000,32'h00000000); //Ch1_DQ0_FIFO_EN
        u_sram_loader.ahb_write(0,32'h00130000,32'h00000000); //Ch1_DQ1_FIFO_EN
        u_sram_loader.ahb_write(0,32'h00140000,32'h00000000); //Ch1_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
        $display ("[%t] #########  Die 0 Initializing Done   #########",$time);
    end
endtask

task link_initialize_1();
    begin
        $display ("[%t] #########  Initializing Die 1   #########",$time);
        //enable IBIAS
        u_sram_loader.ahb_write(1,32'h00090018,32'h00000001);
        //LDO enable
        u_sram_loader.ahb_write(1,32'h00090020,32'h00000100);
        u_sram_loader.ahb_write(1,32'h00090024,32'h00000100);
        //enable and set VREF
        u_sram_loader.ahb_write(1,32'h00090008,32'h00000200);
        u_sram_loader.ahb_write(1,32'h00090008,32'h000002FA);
        u_sram_loader.ahb_write(1,32'h0009000C,32'h00000200);
        u_sram_loader.ahb_write(1,32'h0009000C,32'h000002FA);
        //ZQCAL process
        u_sram_loader.ahb_write(1,32'h00090010,32'h00000020);
        u_sram_loader.ahb_write(1,32'h00090010,32'h00000060);
        //NCAL
        ZQ_index=32'h00000060;
        ZQ_NCAL_index='0;
        u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(1,32'h00090010,{ZQ_index[31:5],ZQ_NCAL_index});
            ZQ_NCAL_index+=1;
            if(ZQ_NCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL NCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h00090010,ahb_rdata);
        ZQ_index=ahb_rdata;
        //PCAL
        ZQ_index[6]=1'b0;
        ZQ_PCAL_index='0;
        u_sram_loader.ahb_write(1,32'h00090010,ZQ_index);
        u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        while(ahb_rdata!='0) begin
            u_sram_loader.ahb_write(1,32'h00090010,{ZQ_index[31:14],ZQ_PCAL_index,ZQ_index[7:0]});
            ZQ_PCAL_index+=1;
            if(ZQ_PCAL_index=='0) begin
                $display ("[%t] #########  ZQCAL PCAL ERROR   #########",$time);
                err_count+=1;
                Finish();
            end
            u_sram_loader.ahb_read(1,32'h00090014,ahb_rdata);
        end
        //set PLL lock/fastlock config
        u_sram_loader.ahb_write(1,32'h00098098,32'h0000014F);
        u_sram_loader.ahb_write(1,32'h000980A0,32'h00040200);
        u_sram_loader.ahb_write(1,32'h000980A4,32'h00080100);
        //VCO0
        u_sram_loader.ahb_write(1,32'h00098018,32'h00005F43);
        //logical reset
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000003);
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000002);
        u_sram_loader.ahb_read(1,32'h0009800C,ahb_rdata);
        while(ahb_rdata[0]!=1) begin
            u_sram_loader.ahb_read(1,32'h0009800C,ahb_rdata);
        end
        //VCO1
        u_sram_loader.ahb_write(1,32'h00098048,32'h040DC080);
        u_sram_loader.ahb_write(1,32'h00098044,32'h08249F01);
        //VCO2
        u_sram_loader.ahb_write(1,32'h00098070,32'h040DC080);
        u_sram_loader.ahb_write(1,32'h0009806C,32'h08249F01);
        //wait 
        u_sram_loader.ahb_read(1,32'h00098044,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(1,32'h00098044,ahb_rdata);
        end
        u_sram_loader.ahb_read(1,32'h0009806C,ahb_rdata);
        while(ahb_rdata[28]!=1) begin
            u_sram_loader.ahb_read(1,32'h0009806C,ahb_rdata);
        end
        //VCO1 PLL
        u_sram_loader.ahb_write(1,32'h00098058,32'h04000037);
        u_sram_loader.ahb_write(1,32'h0009803C,32'h00005D4F);
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000016);
        //VCO2 PLL
        u_sram_loader.ahb_write(1,32'h00098080,32'h04000037);
        u_sram_loader.ahb_write(1,32'h00098064,32'h00005D4F);
        u_sram_loader.ahb_write(1,32'h00098000,32'h0000001A);
        //change back to vco1 pll
        u_sram_loader.ahb_write(1,32'h00098000,32'h00000016);
        //clock switch
        u_sram_loader.ahb_write(1,32'h000B0000,32'h00000309);
        u_sram_loader.ahb_write(1,32'h000B0000,32'h0000030D);
        u_sram_loader.ahb_write(1,32'h00090028,32'h00000000);
        u_sram_loader.ahb_write(1,32'h00090028,32'h00000008);
        u_sram_loader.ahb_write(1,32'h00090028,32'h0000000C);
        u_sram_loader.ahb_write(1,32'h000A0030,32'h00000000);
        u_sram_loader.ahb_write(1,32'h000D0000,32'h00000000);
        $display ("[%t] #########  PLL Initialize Done   #########",$time);
        //set UCIe adapter to ch0:rx ch1:tx
        u_sram_loader.ahb_write(1,32'h00150000,32'h00111019);
        //enable all TX PI__CH1_DQ0
        u_sram_loader.ahb_write(1,32'h00120290,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202B0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202D0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00120294,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202B4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001202D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00120984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h00130290,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302B0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302D0,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00130294,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302B4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001302D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00130984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h00140318,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140338,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140358,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A18,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A38,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A58,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A68,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A78,32'h00004040);

        u_sram_loader.ahb_write(1,32'h0014031C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0014033C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0014035C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A1C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A3C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A5C,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A7C,32'h00004040);
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);

        //enable all TX PI__CH0_DQ0
        u_sram_loader.ahb_write(1,32'h000F0920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h000F0924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F0984,32'h00004040);

        //enable all TX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h00100920,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100940,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100960,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100980,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00100924,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100944,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100964,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100974,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00100984,32'h00004040);

        //enable all TX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h00110A18,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A38,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A58,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00110A68,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A78,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00110A1C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A3C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110A5C,32'h00004040); 
        u_sram_loader.ahb_write(1,32'h00140A6C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00140A7C,32'h00004040);

        //enable all RX PI__CH1_DQ0
        u_sram_loader.ahb_write(1,32'h000F07F4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07E4,32'h00004040);

        u_sram_loader.ahb_write(1,32'h000F07F8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07D8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h000F07E8,32'h00004040);

        //enable all RX PI__CH1_DQ1
        u_sram_loader.ahb_write(1,32'h001007F4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007D4,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007E4,32'h00004040);

        u_sram_loader.ahb_write(1,32'h001007F8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007D8,32'h00004040);
        u_sram_loader.ahb_write(1,32'h001007E8,32'h00004040);

        //enable all RX PI__CH1_CA
        u_sram_loader.ahb_write(1,32'h0011098C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0011096C,32'h00004040);
        u_sram_loader.ahb_write(1,32'h0011097C,32'h00004040);

        u_sram_loader.ahb_write(1,32'h00110990,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110970,32'h00004040);
        u_sram_loader.ahb_write(1,32'h00110980,32'h00004040);
        u_sram_loader.wait_until_empty();

        //set TX QDR mode
        u_sram_loader.ahb_write_all_lane(1,32'h001201F0,32'h00000004); //Ch1_DQ0_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00120880,32'h00000004); //Ch1_DQ0_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h001301F0,32'h00000004); //Ch1_DQ1_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00130880,32'h00000004); //Ch1_DQ1_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write_all_lane(1,32'h00140258,32'h00000004); //Ch1_CA_DQ_TX_EGRESS_ANA_MO_CFG// QDR_2to1

        u_sram_loader.ahb_write(1,32'h001409F8,32'h00000004); //Ch1_CA_DQS_TX_EGRESS_ANA_MO_CFG// QDR_2to1
        //set xdr sel mode
        u_sram_loader.ahb_write_all_lane(1,32'h001203A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h001303A4,32'h00003120); //Ch1_DQ0__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00140454,32'h00003120); //Ch1_CA__DQ_TX_SDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(1,32'h00120A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130A54,32'h00003120); //Ch1_DQ0__DQS_TX_SDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(1,32'h00140AAC,32'h00003120); //Ch1_CA__DQS_TX_SDR_X_SEL_M0_R1_CFG_0
        //set ddr sel mode
        u_sram_loader.ahb_write_all_lane(1,32'h00120554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130554,32'h00000010); //Ch1_DQ0__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00140664,32'h00000010); //Ch1_CA__DQ_TX_DDR_X_SEL_M0_R1_CFG_0-8

        u_sram_loader.ahb_write_all_lane(1,32'h00120C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write_all_lane(1,32'h00130C04,32'h00000010); //Ch1_DQ0__DQS_TX_DDR_X_SEL_M0_R1_CFG_0-8
        u_sram_loader.ahb_write(1,32'h00140ADC,32'h00000010); //Ch1_CA__DQS_TX_DDR_X_SEL_M0_R1_CFG
        //set RX AC path mode
        u_sram_loader.ahb_write(1,32'h000F083C,32'h00427777); //Ch0_DQ0_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(1,32'h0010083C,32'h00427777); //Ch0_DQ1_DQS_RX_IO_CMN
        u_sram_loader.ahb_write(1,32'h001109C4,32'h00427777); //Ch0_CA_DQS_RX_IO_CMN

        //RX GB mode
        u_sram_loader.ahb_write(1,32'h000F07B8,32'h00000084); //Ch0_DQ0_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(1,32'h001007B8,32'h00000084); //Ch0_DQ1_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.ahb_write(1,32'h00110950,32'h00000084); //Ch0_CA_DQS_RX_MO_CFG//FGB_MODE=4to8 RGB_mode=4
        u_sram_loader.wait_until_empty();
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //clr fifo
        u_sram_loader.ahb_write(1,32'h000F0000,32'h00000100); //Ch0_DQ0_FIFO_CLR
        u_sram_loader.ahb_write(1,32'h00100000,32'h00000100); //Ch0_DQ1_FIFO_CLR
        u_sram_loader.ahb_write(1,32'h00110000,32'h00000100); //Ch0_CA_FIFO_CLR
        repeat (10) @(posedge mixed_phy_2_tb.ahb_clk);
        //enable fifo
        u_sram_loader.ahb_write(1,32'h000F0000,32'h00000000); //Ch0_DQ0_FIFO_EN
        u_sram_loader.ahb_write(1,32'h00100000,32'h00000000); //Ch0_DQ1_FIFO_EN
        u_sram_loader.ahb_write(1,32'h00110000,32'h00000000); //Ch0_CA_FIFO_EN
        u_sram_loader.wait_until_empty();
        $display ("[%t] #########  Die 1 Initializing Done   #########",$time);
    end
endtask