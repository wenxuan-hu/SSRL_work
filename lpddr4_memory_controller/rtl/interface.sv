`timescale 1ns/10ps

interface rdi_mb_interface(input clk,rst);
	//RDI mainband
    logic [383:0] lp_data;
    logic lp_valid;
    logic lp_irdy;
    logic pl_trdy;
    
    logic [383:0] pl_data;
    logic pl_valid;
	clocking drv_ck @(posedge clk);
        default input #0.1 output #0.05;
        output lp_data,lp_valid,lp_irdy;
        input pl_trdy,pl_data,pl_valid;
    endclocking
	clocking mon_ck @(posedge clk);
        default input #0.1 output #0.05;
        input lp_data,lp_valid,lp_irdy,pl_trdy,pl_data,pl_valid;
    endclocking
endinterface


interface ahb_interface(input clk,rst);
	//ahb bus
   	logic [31:0]         haddr;
   	logic                hwrite;
   	logic                hsel;
   	logic                hreadyin;
   	logic [31:0]         hwdata;
   	logic [1:0]          htrans;
   	logic [2:0]          hsize;
   	logic [2:0]          hburst;
   	logic                hready;
   	logic [31:0]         hrdata;
   	logic [1:0]          hresp;
   	logic                hgrant;
endinterface

interface axi_interface(input clk,rst);
    axi_aw_interface aw_if(clk,rst);
    axi_w_interface w_if(clk,rst);
    axi_b_interface b_if(clk,rst);
    axi_ar_interface ar_if(clk,rst);
    axi_r_interface r_if(clk,rst);
endinterface

interface axi_aw_interface(input clk,rst);
    //axi aw channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [31:0] addr;
	logic [1:0] burst;
	logic [7:0] len;
	logic [3:0] size;
	logic [1:0] lock;
	logic [2:0] prot;
	logic [3:0] cache;
	logic [3:0] qos;
	logic [3:0]id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        input ready;
        output valid,first,last,addr,burst,len,size,id;
        output lock,prot,cache,qos;
    endclocking
endinterface

interface axi_w_interface(input clk,rst);
    //axi w channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [255:0] data;
	logic [31:0] strb;
	logic [3:0]id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        input ready;
        output valid,first,last,data,strb,id;
    endclocking
endinterface

interface axi_b_interface(input clk,rst);
    //axi b channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [1:0] resp;
	logic [3:0]id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        output ready;
        input valid,first,last,resp,id;
    endclocking
endinterface
	
interface axi_ar_interface(input clk,rst);
    //axi ar channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [31:0] addr;
	logic [1:0] burst;
	logic [7:0] len;
	logic [3:0] size;
	logic [1:0] lock;
	logic [2:0] prot;
	logic [3:0] cache;
	logic [3:0] qos;
	logic [3:0]id;
    clocking axi_master @(posedge clk);
        default input #0.1 output #0.1;
        input ready;
        output valid,first,last,addr,burst,len,size,id;
        output lock,prot,cache,qos;
    endclocking

endinterface
	
interface axi_r_interface(input clk,rst);
    //axi r channel
	logic valid;
	logic ready;
	logic first;
	logic last;
	logic [1:0] resp;
	logic [255:0] data;
	logic [3:0]id;
    clocking axi_master @(posedge clk);
        default input #500ps output #500ps;
        output ready;
        input valid,first,last,data,resp,id;
    endclocking
endinterface
	

interface wishbone_interface(input clk,rst);
    logic [31:0] wishbone_port_adr;
	logic [255:0] wishbone_port_dat_w;
	logic [255:0] wishbone_port_dat_r;
	logic [31:0] wishbone_port_sel;
	logic wishbone_port_cyc;
	logic wishbone_port_stb;
	logic wishbone_port_ack;
	logic wishbone_port_we;
	logic [2:0] wishbone_port_cti;
	logic [1:0] wishbone_port_bte;
	logic wishbone_port_err;
endinterface

interface native_interface(input clk,rst);
    logic native_cmd_valid;
	logic native_cmd_ready;
	logic native_cmd_first;
	logic native_cmd_last;
	logic native_cmd_payload_we;
	logic native_cmd_payload_mw;
	logic [25:0] native_cmd_payload_addr;
	logic wdata_valid;
	logic wdata_ready;
	logic wdata_first;
	logic wdata_last;
	logic [255:0] wdata_payload_data;
	logic [31:0] wdata_payload_we;
	logic rdata_valid;
	logic rdata_ready;
	logic rdata_first;
	logic rdata_last;
	logic [255:0] rdata_payload_data;
	clocking drv_ck @(posedge clk);
        default input #0.1 output #0.05;
        output native_cmd_valid,native_cmd_payload_we,native_cmd_payload_mw,native_cmd_payload_addr,wdata_valid,wdata_payload_data,wdata_payload_we;
        input native_cmd_ready,wdata_ready,rdata_valid,rdata_payload_data;
    endclocking
	clocking mon_ck @(posedge clk);
        default input #0.1 output #0.05;
        input native_cmd_valid,native_cmd_payload_we,native_cmd_payload_mw,native_cmd_payload_addr,wdata_valid,wdata_payload_data,wdata_payload_we,native_cmd_ready,wdata_ready,rdata_valid,rdata_payload_data;
    endclocking
endinterface

interface litedram_interface(input clk,rst);
    litedram_cmd_interface litedram_cmd_if_0(clk,rst);
	litedram_cmd_interface litedram_cmd_if_1(clk,rst);
	litedram_cmd_interface litedram_cmd_if_2(clk,rst);
	litedram_cmd_interface litedram_cmd_if_3(clk,rst);
	litedram_cmd_interface litedram_cmd_if_4(clk,rst);
	litedram_cmd_interface litedram_cmd_if_5(clk,rst);
	litedram_cmd_interface litedram_cmd_if_6(clk,rst);
	litedram_cmd_interface litedram_cmd_if_7(clk,rst);
	litedram_data_interface litedram_data_if(clk,rst);
endinterface

interface litedram_cmd_interface(input clk,rst);
    logic interface_bank_valid;
	logic interface_bank_ready;
	logic interface_bank_we;
	logic interface_bank_mw;
	logic [22:0] interface_bank_addr;
	logic interface_bank_lock;
	logic interface_bank_wdata_ready;
	logic interface_bank_rdata_valid;
	clocking drv_ck @(posedge clk);
        default input #0.1 output #0.05;
        output interface_bank_valid,interface_bank_we,interface_bank_mw,interface_bank_addr;
        input interface_bank_ready,interface_bank_rdata_valid,interface_bank_wdata_ready,interface_bank_lock;
    endclocking
	clocking mon_ck @(posedge clk);
        default input #0.1 output #0.05;
        input interface_bank_valid,interface_bank_we,interface_bank_mw,interface_bank_addr,interface_bank_ready,interface_bank_rdata_valid,interface_bank_wdata_ready,interface_bank_lock;
    endclocking
endinterface

interface litedram_data_interface(input clk,rst);
    logic [255:0] interface_wdata;
	logic [31:0] interface_wdata_we;
	logic [255:0] interface_rdata;
	clocking drv_ck @(posedge clk);
        default input #0.1 output #0.05;
        output interface_wdata,interface_wdata_we;
        input interface_rdata;
    endclocking
	clocking mon_ck @(posedge clk);
        default input #0.1 output #0.05;
        input interface_wdata,interface_wdata_we,interface_rdata;
    endclocking
endinterface

interface cmd_rw_interface(input clk,rst);
    logic cmd_valid;
	logic cmd_ready;
	logic cmd_first;
	logic cmd_last;
	logic [16:0] cmd_payload_a;
	logic [2:0] cmd_payload_ba;
	logic cmd_payload_cas;
	logic cmd_payload_ras;
	logic cmd_payload_we;
	logic cmd_payload_is_cmd;
	logic cmd_payload_is_read;
	logic cmd_payload_is_write;
	logic cmd_payload_is_mw;
	logic refresh_req;
	logic refresh_gnt;
	clocking drv_ck @(posedge clk);
        default input #0.1 output #0.05;
        output cmd_valid,cmd_payload_a,cmd_payload_ba,cmd_payload_cas,cmd_payload_ras,cmd_payload_we,cmd_payload_is_cmd,cmd_payload_is_read,cmd_payload_is_write,cmd_payload_is_mw,refresh_gnt;
        input cmd_ready,refresh_req;
    endclocking
	clocking mon_ck @(posedge clk);
        default input #0.1 output #0.05;
        input refresh_gnt,refresh_req,cmd_valid,cmd_payload_a,cmd_payload_ba,cmd_payload_cas,cmd_payload_ras,cmd_payload_we,cmd_payload_is_cmd,cmd_payload_is_read,cmd_payload_is_write,cmd_payload_is_mw,cmd_ready;
    endclocking

	clocking rsp_ck @(posedge clk);
        default input #0.1 output #0.05;
        input cmd_valid;
		output cmd_ready;
    endclocking
endinterface

interface dfi_interface(input clk,rst);
    dfi_phase_interface dfi_phase0_interface_if(clk,rst);
	dfi_phase_interface dfi_phase1_interface_if(clk,rst);
	dfi_phase_interface dfi_phase2_interface_if(clk,rst);
	dfi_phase_interface dfi_phase3_interface_if(clk,rst);
endinterface

interface dfi_phase_interface(input clk,rst);
    logic [16:0] address;
	logic [2:0] bank;
	logic cas_n;
	logic cs_n;
	logic ras_n;
	logic we_n;
	logic mw;
	logic cke;
	logic odt;
	logic reset_n;
	logic act_n;
	logic [63:0] wrdata;
	logic wrdata_en;
	logic [7:0] wrdata_mask;
	logic rddata_en;
	logic [63:0] rddata;
	logic rddata_valid;
	clocking mon_ck @(posedge clk);
    	default input #0.1 output #0.05;
    	input address,bank,cas_n,cs_n,ras_n,we_n,mw,cke,odt,reset_n,act_n,wrdata,wrdata_en,wrdata_mask,rddata_en,rddata,rddata_valid;
  	endclocking
	clocking drv_ck @(posedge clk);
    	default input #0.1 output #0.05;
    	output address,bank,cas_n,cs_n,ras_n,we_n,mw,cke,odt,reset_n,act_n,wrdata,wrdata_en,wrdata_mask,rddata_en;
		input rddata,rddata_valid;
  	endclocking
endinterface

interface dfi_lpddr4_interface(input clk,rst);
    dfi_phase_lpddr4_interface dfi_phase0_lpddr4_if(clk,rst);
	dfi_phase_lpddr4_interface dfi_phase1_lpddr4_if(clk,rst);
	dfi_phase_lpddr4_interface dfi_phase2_lpddr4_if(clk,rst);
	dfi_phase_lpddr4_interface dfi_phase3_lpddr4_if(clk,rst);
endinterface

interface dfi_phase_lpddr4_interface(input clk,rst);
    logic [5:0] ca;
	logic cs;
	logic cke;
	logic odt;
	logic reset_n;
	logic act_n;
	logic dbi[1:0];
	logic [63:0] wrdata;
	logic wrdata_en;
	logic [7:0] wrdata_mask;
	logic rddata_en;
	logic [63:0] rddata;
	logic rddata_valid;
	clocking mon_ck @(posedge clk);
    	default input #0.1 output #0.05;
    	input ca,cs,cke,odt,reset_n,act_n,wrdata,wrdata_en,wrdata_mask,rddata_en,rddata,rddata_valid;
  	endclocking
	clocking drv_ck @(posedge clk);
    	default input #0.1 output #0.05;
    	output ca,cs,cke,odt,reset_n,act_n,wrdata,wrdata_en,wrdata_mask,rddata_en;
		input rddata,rddata_valid;
  	endclocking
	clocking sdrv_ck @(posedge clk);
    	default input #0.1 output #0.05;
		input rddata_en;
		output rddata,rddata_valid;
  	endclocking
endinterface
