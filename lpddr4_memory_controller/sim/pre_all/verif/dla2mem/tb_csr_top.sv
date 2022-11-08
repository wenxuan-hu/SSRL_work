`timescale 1ns/10ps

module mc_csr_top_tb();

    logic clk,rst;
	logic ahb_extrst,ahb_extclk;
    native_interface native_if_0(clk,rst);
    native_interface native_if_1(clk,rst);
	dfi_lpddr4_interface dfi_lpddr4_if(clk,rst);

   logic [31:0]                  ahb_haddr;
   logic                         ahb_hwrite;
   logic                         ahb_hbusreq;
   logic [31:0]                  ahb_hwdata;
   logic [1:0]                   ahb_htrans;
   logic [2:0]                   ahb_hsize;
   logic                         ahb_hsel;
   logic [2:0]                   ahb_hburst;
   logic                         ahb_hreadyin;
   logic                         ahb_hready;
   logic [31:0]                  ahb_hrdata;
   logic [1:0]                   ahb_hresp;
   logic                         ahb_hgrant;

mc_top u_mc_top (
    .clk               (clk),
    .rst               (rst),
    .native_if_0       (native_if_0),
    .native_if_1       (native_if_1),
    .dfi_lpddr4_if     (dfi_lpddr4_if),
    .ahb_extclk        (ahb_extclk),
    .ahb_extrst        (ahb_extrst),
    .i_ahb_haddr       (ahb_haddr),
    .i_ahb_hwrite      (ahb_hwrite),
    .i_ahb_hwdata      (ahb_hwdata),
    .i_ahb_htrans      (ahb_htrans),
    .i_ahb_hsize       (ahb_hsize),
    .i_ahb_hsel        (ahb_hsel),
    .i_ahb_hburst      (ahb_hburst),
    .i_ahb_hreadyin    (ahb_hreadyin),
    .o_ahb_hready      (ahb_hready),
    .o_ahb_hgrant     (),
    .o_ahb_hrdata     (ahb_hrdata),
    .o_ahb_hresp       (ahb_hresp)
);

sram_loader u_sram_loader (
    //AHB
    .ahb_if_haddr       (ahb_haddr),
    .ahb_if_hwrite      (ahb_hwrite),
    .ahb_if_hwdata      (ahb_hwdata),
    .ahb_if_htrans      (ahb_htrans),
    .ahb_if_hsize       (ahb_hsize),
    .ahb_if_hsel        (ahb_hsel),
    .ahb_if_hburst      (ahb_hburst),
    .ahb_if_hreadyin    (ahb_hreadyin),
    .ahb_if_hready      (ahb_hready),
    .ahb_if_hrdata      (ahb_hrdata),
    .ahb_if_hresp       (ahb_hresp),
    .clk                (ahb_extclk)
);


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

    bit [31:0] ahb_rdata;
    int err_count=0;
    int random_number;

    initial begin 
        $vcdpluson(0,mc_csr_top_tb);
        rst <= 1;
		ahb_extrst<=1;
        repeat(5) @(posedge clk);
		@(negedge ahb_extclk);
		ahb_extrst<=0;
        @(negedge ahb_extclk);
        u_sram_loader.ahb_write(32'h02000000,32'h00000000);
        u_sram_loader.ahb_write(32'h02000004,32'h00000000);
        u_sram_loader.ahb_write(32'h02000008,32'h00000000);
        u_sram_loader.ahb_write(32'h0200000C,32'h00000000);
        u_sram_loader.ahb_write(32'h02000010,32'h00000000);
        u_sram_loader.ahb_write(32'h02000014,32'h00000000);
        u_sram_loader.ahb_write(32'h02000018,32'h00000000);

        u_sram_loader.ahb_read(32'h02000000,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h02000004,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h02000008,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h0200000C,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h02000010,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h02000014,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;
        u_sram_loader.ahb_read(32'h02000018,ahb_rdata);
        if(ahb_rdata!=32'h0) err_count+=1;

        for(int i=0;i<10;i++) begin
            random_number=$random;
            u_sram_loader.ahb_write(32'h02000000,random_number);
            u_sram_loader.ahb_write(32'h02000000,random_number);
            u_sram_loader.ahb_write(32'h02000004,random_number);
            u_sram_loader.ahb_write(32'h02000008,random_number);
            u_sram_loader.ahb_write(32'h0200000C,random_number);
            u_sram_loader.ahb_write(32'h02000010,random_number);
            u_sram_loader.ahb_write(32'h02000014,random_number);
            u_sram_loader.ahb_write(32'h02000018,random_number);

            u_sram_loader.ahb_read(32'h02000000,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h02000004,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h02000008,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h0200000C,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h02000010,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h02000014,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
            u_sram_loader.ahb_read(32'h02000018,ahb_rdata);
            if(ahb_rdata!=random_number) err_count+=1;
        end
        @(negedge clk);
        rst <= 0;
        @(negedge clk);
        Finish ();
    end




task Finish ();
begin
	$display("%0t: %m: finishing simulation..", $time);
	repeat (10) @(posedge mc_csr_top_tb.ahb_extclk);
	$display("\n////////////////////////////////////////////////////////////////////////////");
	$display("%0t: Simulation ended, ERROR count: %0d", $time, err_count);
	$display("////////////////////////////////////////////////////////////////////////////\n");
    if (err_count == 0) begin
        $display("+++++++++++++++++++++++++++++++++\n");
        $display("TEST PASSED!!!!!!!!!!!\n");
        $display("+++++++++++++++++++++++++++++++++\n");
    end else begin
        $display("+++++++++++++++++++++++++++++++++\n");
        $display("TEST FAILED!!!!!!!!!!!\n");
        $display("+++++++++++++++++++++++++++++++++\n");
    end
	$finish;
end
endtask

endmodule