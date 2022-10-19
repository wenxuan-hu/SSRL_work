`timescale 1ps/1ps

module mc_ahb_csr_testbench ();
   logic                i_sysclk;
   logic                i_sysrst;

   logic                i_ahb_extclk;
   logic                i_ahb_extrst;
   logic [31:0]         i_haddr;
   logic                i_hwrite;
   logic                i_hsel;
   logic                i_hreadyin;
   logic [31:0]         i_hwdata;
   logic [1:0]          i_htrans;
   logic [2:0]          i_hsize;
   logic [2:0]          i_hburst;
   logic                o_hready;
   logic [31:0]         o_hrdata;
   logic [1:0]          o_hresp;
   logic                o_hgrant;

   logic [1:0] o_mul_rdphase_cfg;
   logic [1:0] o_mul_wrphase_cfg;
   logic [1:0] o_mul_rdcmd_phase_cfg;
   logic [1:0] o_mul_wrcmd_phase_cfg;
   logic [7:0] o_mul_tRRD_cfg;
   logic [7:0] o_mul_tFAW_cfg;
   logic [7:0] o_mul_tCCD_cfg;
   logic [7:0] o_mul_WTR_LATENCY_cfg;
   logic [7:0] o_mul_RTW_LATENCY_cfg;
   logic [7:0] o_mul_READ_TIME_cfg;
   logic [7:0] o_mul_WRITE_TIME_cfg;

   logic [11:0] o_ref_tREFI_cfg;
   logic [3:0] o_ref_POSTPONE_cfg;
   logic [7:0] o_ref_tRP_cfg;
   logic [7:0] o_ref_tRFC_cfg;

   logic [7:0] o_bm_tRTP_cfg;
   logic [7:0] o_bm_tWTP_cfg;
   logic [7:0] o_bm_tRAS_cfg;
   logic [7:0] o_bm_tRC_cfg;
   logic [7:0] o_bm_tRP_cfg;
   logic [7:0] o_bm_tRCD_cfg;
   logic [7:0] o_bm_tCCDMW_cfg;

   logic [7:0] o_crb_READ_LATENCY_cfg;
   logic [7:0] o_crb_WRITE_LATENCY_cfg;

   mc_ahb_csr dut (
    .i_sysclk                   (i_sysclk),
    .i_sysrst                   (i_sysrst),
    .i_ahb_extclk               (i_ahb_extclk),
    .i_ahb_extrst               (i_ahb_extrst),
    .i_haddr                    (i_haddr),
    .i_hwrite                   (i_hwrite),
    .i_hsel                     (i_hsel),
    .i_hreadyin                 (i_hreadyin),
    .i_hwdata                   (i_hwdata),
    .i_htrans                   (i_htrans),
    .i_hsize                    (i_hsize),
    .i_hburst                   (i_hburst),
    .o_hready                   (o_hready),
    .o_hrdata                   (o_hrdata),
    .o_hresp                    (o_hresp),
    .o_hgrant                   (o_hgrant),
    .o_mul_rdphase_cfg          (o_mul_rdphase_cfg),
    .o_mul_wrphase_cfg          (o_mul_wrphase_cfg),
    .o_mul_rdcmd_phase_cfg      (o_mul_rdcmd_phase_cfg),
    .o_mul_wrcmd_phase_cfg      (o_mul_wrcmd_phase_cfg),
    .o_mul_tRRD_cfg             (o_mul_tRRD_cfg),
    .o_mul_tFAW_cfg             (o_mul_tFAW_cfg),
    .o_mul_tCCD_cfg             (o_mul_tCCD_cfg),
    .o_mul_WTR_LATENCY_cfg      (o_mul_WTR_LATENCY_cfg),
    .o_mul_RTW_LATENCY_cfg      (o_mul_RTW_LATENCY_cfg),
    .o_mul_READ_TIME_cfg        (o_mul_READ_TIME_cfg),
    .o_mul_WRITE_TIME_cfg       (o_mul_WRITE_TIME_cfg),
    .o_ref_tREFI_cfg            (o_ref_tREFI_cfg),
    .o_ref_POSTPONE_cfg         (o_ref_POSTPONE_cfg),
    .o_ref_tRP_cfg              (o_ref_tRP_cfg),
    .o_ref_tRFC_cfg             (o_ref_tRFC_cfg),
    .o_bm_tRTP_cfg              (o_bm_tRTP_cfg),
    .o_bm_tWTP_cfg              (o_bm_tWTP_cfg),
    .o_bm_tRAS_cfg              (o_bm_tRAS_cfg),
    .o_bm_tRC_cfg               (o_bm_tRC_cfg),
    .o_bm_tRP_cfg               (o_bm_tRP_cfg),
    .o_bm_tRCD_cfg              (o_bm_tRCD_cfg),
    .o_bm_tCCDMW_cfg            (o_bm_tCCDMW_cfg),
    .o_crb_READ_LATENCY_cfg     (o_crb_READ_LATENCY_cfg),
    .o_crb_WRITE_LATENCY_cfg    (o_crb_WRITE_LATENCY_cfg)
);
    //clk used for read and write
	initial begin
        i_sysclk <= 0;
        forever begin
            #15 i_sysclk <= ~i_sysclk;
        end
    end

    initial begin 
        i_ahb_extclk <= 0;
        forever begin
            #10 i_ahb_extclk <= ~i_ahb_extclk;
        end
    end
    // 3_2 write transfer and 3_1 read transfer
    // busreq is the and of hsel and hreadyin
    initial begin
        i_ahb_extrst <= 1;
        i_sysrst <= 1;
        i_htrans <= 2'bxx;              @(negedge i_ahb_extclk);
        i_sysrst <= 0; 
        i_ahb_extrst <= 0;              @(negedge i_ahb_extclk);
                                        @(negedge i_ahb_extclk);
                                        @(negedge i_ahb_extclk);// after the red line of hready
        i_hwrite <= 1'b1;
        i_hreadyin <= 1;
        i_hsel <= 1'b1;
        i_hsize <= 3'b001;
        i_hburst <= 3'b011;
        i_htrans <= 2'b10; 
        i_haddr <= 32'h02000008;        @(negedge i_ahb_extclk);
        i_hwdata <= 32'h001f11ff;       
        i_htrans <= 2'b11;              
        i_haddr <= 32'h0200000c;        @(negedge i_ahb_extclk);//
        i_hwdata <= 32'hbbbbbbbb;       
        i_haddr <= 32'h02000010;       @(negedge i_ahb_extclk);
        i_hwdata <= 32'hffffffff;       
        i_htrans <= 2'b11;
        i_haddr <= 32'h02000014;        @(negedge i_ahb_extclk); 
        i_hwdata <= 32'h12345678;       @(negedge i_ahb_extclk); 
        
        

                                                                                                    
    end 
endmodule 