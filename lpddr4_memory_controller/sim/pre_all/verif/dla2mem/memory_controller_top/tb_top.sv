`timescale 1ns/10ps

module mc_top_tb();
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    logic clk,rst;
	logic ahb_extrst,ahb_extclk;
    native_interface native_if_0(clk,rst);
    native_interface native_if_1(clk,rst);

    mosi_interface  my_mosi_0();
    mosi_interface  my_mosi_1();
    dma_native_interface  my_native_0();
    dma_native_interface  my_native_1();


	dfi_lpddr4_interface dfi_lpddr4_if(clk,rst);

   logic [31:0]                  i_ahb_haddr=0;
   logic                         i_ahb_hwrite=0;
   logic                         i_ahb_hbusreq=0;
   logic [31:0]                  i_ahb_hwdata=0;
   logic [1:0]                   i_ahb_htrans=0;
   logic [2:0]                   i_ahb_hsize=0;
   logic                         i_ahb_hsel=0;
   logic [2:0]                   i_ahb_hburst=0;
   logic                         i_ahb_hreadyin=1;
   logic                         o_ahb_hready;
   logic [31:0]                  o_ahb_hrdata;
   logic [1:0]                   o_ahb_hresp;
   logic                         o_ahb_hgrant;

mc_top u_mc_top (
    .clk               (clk),
    .rst               (rst),
    .native_if_0       (native_if_0),
    .native_if_1       (native_if_1),
    .dfi_lpddr4_if     (dfi_lpddr4_if),
    .ahb_extclk        (ahb_extclk),
    .ahb_extrst        (ahb_extrst),
    .i_ahb_haddr       (i_ahb_haddr),
    .i_ahb_hwrite      (i_ahb_hwrite),
    .i_ahb_hwdata      (i_ahb_hwdata),
    .i_ahb_htrans      (i_ahb_htrans),
    .i_ahb_hsize       (i_ahb_hsize),
    .i_ahb_hsel        (i_ahb_hsel),
    .i_ahb_hburst      (i_ahb_hburst),
    .i_ahb_hreadyin    (i_ahb_hreadyin),
    .o_ahb_hready      (o_ahb_hready),
    .o_ahb_hgrant     (o_ahb_hgrant),
    .o_ahb_hrdata     (o_ahb_hrdata),
    .o_ahb_hresp      (o_ahb_hresp)
);



// ----------------------------------------------------
//dma
//mosi_native mosi_native_inst0(
//  .clk_i      (clk),
//  .rst_n      (~rst),
//  .enable     (1'b1),
//  
//  .clr_i      (1'b0),
//  .irq      (),
//  .mosi     (my_mosi_0),
//
//
//         .wdata_payload_data_o(), 
//         .rdata_payload_data_i (native_if_0.rdata_payload_data),
//         .wdata_payload_we_o(),
//         .ncmd_payload_addr_o(),
//         .ncmd_valid_o (), 
//         .ncmd_ready_i (native_if_0.native_cmd_ready), 
//         .ncmd_payload_we_o (), 
//         .ncmd_payload_mw_o (), 
//         .wdata_valid_o(), 
//         .wdata_ready_i(native_if_0.wdata_ready), 
//         .rdata_valid_i(native_if_0.rdata_valid), 
//         .rdata_ready_o()
//);


mosi_native mosi_native_inst0(
  .clk_i      (clk),
  .rst_n      (~rst),
  .enable     (1'b1),
  
  .clr_i      (1'b0),
  .irq      (),
  .mosi     (my_mosi_0),
  .native   (my_native_0)
);

assign  my_native_0.rdata_payload_data_i = native_if_0.rdata_payload_data;
assign  my_native_0.ncmd_ready_i = native_if_0.native_cmd_ready; 
assign  my_native_0.wdata_ready_i = native_if_0.wdata_ready; 
assign  my_native_0.rdata_valid_i = native_if_0.rdata_valid; 

assign  native_if_0.native_cmd_valid  =   my_native_0.ncmd_valid_o ;
assign  native_if_0.native_cmd_first  =      1'b0;
assign  native_if_0.native_cmd_last   =     1'b0 ;
assign  native_if_0.native_cmd_payload_we  =    my_native_0.ncmd_payload_we_o   ;
assign  native_if_0.native_cmd_payload_mw  =    my_native_0.ncmd_payload_mw_o    ;
assign  native_if_0.native_cmd_payload_addr  =  my_native_0.ncmd_payload_addr_o  ;
assign  native_if_0.wdata_valid  =   my_native_0.wdata_valid_o  ;
assign  native_if_0.wdata_first  =   1'b0       ;
assign  native_if_0.wdata_last  =     1'b0  ;
assign  native_if_0.rdata_ready  =     my_native_0.rdata_ready_o     ;
assign  native_if_0.wdata_payload_data  = my_native_0.wdata_payload_data_o   ;
assign  native_if_0.wdata_payload_we  =    my_native_0.wdata_payload_we_o ;




assign  my_mosi_0.rst = rst; 
assign  my_mosi_0.clk = clk; 
// ----------------------------------------------------

mosi_native mosi_native_inst1(
  .clk_i      (clk),
  .rst_n      (~rst),
  .enable     (1'b1),
  
  .clr_i      (1'b0),
  .irq      (),
  .mosi     (my_mosi_1),
  .native   (my_native_1)
);

assign  my_native_1.rdata_payload_data_i = native_if_1.rdata_payload_data;
assign  my_native_1.ncmd_ready_i = native_if_1.native_cmd_ready; 
assign  my_native_1.wdata_ready_i = native_if_1.wdata_ready; 
assign  my_native_1.rdata_valid_i = native_if_1.rdata_valid; 
assign  my_mosi_1.rst = rst; 
assign  my_mosi_1.clk = clk; 


assign  native_if_1.native_cmd_valid  =   my_native_1.ncmd_valid_o ;
assign  native_if_1.native_cmd_first  =      1'b0;
assign  native_if_1.native_cmd_last   =     1'b0 ;
assign  native_if_1.native_cmd_payload_we  =    my_native_1.ncmd_payload_we_o   ;
assign  native_if_1.native_cmd_payload_mw  =    my_native_1.ncmd_payload_mw_o    ;
assign  native_if_1.native_cmd_payload_addr  =  my_native_1.ncmd_payload_addr_o  ;
assign  native_if_1.wdata_valid  =   my_native_1.wdata_valid_o  ;
assign  native_if_1.wdata_first  =   1'b0       ;
assign  native_if_1.wdata_last  =     1'b0  ;
assign  native_if_1.rdata_ready  =     my_native_1.rdata_ready_o     ;
assign  native_if_1.wdata_payload_data  = my_native_1.wdata_payload_data_o   ;
assign  native_if_1.wdata_payload_we  =    my_native_1.wdata_payload_we_o ;



// ----------------------------------------------------


	initial begin
		ahb_extclk=0;
        forever begin
			#2 ahb_extclk=~ahb_extclk;
        end
    end

    initial begin
		clk=0;
        forever begin
            #1 clk=~clk;
        end
    end

    initial begin 
        rst <= 1;
		ahb_extrst<=1;
        repeat(5) @(posedge clk);
		@(negedge ahb_extclk);
		ahb_extrst<=0;
        @(negedge clk);
        rst <= 0;
    end

    initial begin 
        $vcdpluson(0,mc_top_tb);
        uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_0",my_mosi_0);
		uvm_config_db #(virtual mosi_interface)::set(uvm_root::get(), "uvm_test_top", "dla_vif_1", my_mosi_1);
        uvm_config_db #(virtual dfi_lpddr4_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_lpddr4_vif", dfi_lpddr4_if);
`ifdef TIMING_CHECK
        uvm_config_db #(virtual dfi_interface)::set(uvm_root::get(), "uvm_test_top", "dfi_vif", u_mc_top.u_mc_core.dfi_if);
`endif
        run_test("mc_top_basic_test");
        $finish;
    end
endmodule
