parameter [2:0] AHB_SIZE_BYTE      = 3'b000;
parameter [2:0] AHB_SIZE_HWORD     = 3'b001;
parameter [2:0] AHB_SIZE_WORD      = 3'b010;
parameter [2:0] AHB_SIZE_DWORD     = 3'b011;
parameter [2:0] AHB_SIZE_BIT128    = 3'b100;
parameter [2:0] AHB_SIZE_BIT256    = 3'b101;
parameter [2:0] AHB_SIZE_BIT512    = 3'b110;

parameter [2:0] AHB_BURST_SINGLE   = 3'b000;
parameter [2:0] AHB_BURST_INCR     = 3'b001;
parameter [2:0] AHB_BURST_INCR4    = 3'b011;
parameter [2:0] AHB_BURST_INCR8    = 3'b101;
parameter [2:0] AHB_BURST_INCR16   = 3'b111;

parameter [1:0] AHB_TRANS_IDLE     = 2'b00;
parameter [1:0] AHB_TRANS_BUSY     = 2'b01;
parameter [1:0] AHB_TRANS_NONSEQ   = 2'b10;
parameter [1:0] AHB_TRANS_SEQ      = 2'b11;

parameter [1:0] AHB_RESP_OK        = 2'b00;
parameter [1:0] AHB_RESP_ERROR     = 2'b01;
parameter [1:0] AHB_RESP_RETRY     = 2'b10;
parameter [1:0] AHB_RESP_SPLIT     = 2'b11;

module mc_ahb_csr (
   input   logic                i_sysclk,
   input   logic                i_sysrst,

   input   logic                i_ahb_extclk,
   input   logic                i_ahb_extrst,
   input   logic [31:0]         i_haddr,
   input   logic                i_hwrite,
   input   logic                i_hbusreq,
   input   logic                i_hreadyin,
   input   logic [31:0]         i_hwdata,
   input   logic [1:0]          i_htrans,
   input   logic [2:0]          i_hsize,
   input   logic [2:0]          i_hburst,
   output  logic                o_hready,
   output  logic [31:0]         o_hrdata,
   output  logic [1:0]          o_hresp,
   output  logic                o_hgrant,

   output  logic [1:0] o_mul_rdphase_cfg,
   output  logic [1:0] o_mul_wrphase_cfg,
   output  logic [1:0] o_mul_rdcmd_phase_cfg,
   output  logic [1:0] o_mul_wrcmd_phase_cfg,
   output  logic [7:0] o_mul_tRRD_cfg,
   output  logic [7:0] o_mul_tFAW_cfg,
   output  logic [7:0] o_mul_tCCD_cfg,
   output  logic [7:0] o_mul_WTR_LATENCY_cfg,
   output  logic [7:0] o_mul_RTW_LATENCY_cfg,
   output  logic [7:0] o_mul_READ_TIME_cfg,
   output  logic [7:0] o_mul_WRITE_TIME_cfg,

   output  logic [11:0] o_ref_tREFI_cfg,
   output  logic [3:0] o_ref_POSTPONE_cfg,
   output  logic [7:0] o_ref_tRP_cfg,
   output  logic [7:0] o_ref_tRFC_cfg,

   output  logic [7:0] o_bm_tRTP_cfg,
   output  logic [7:0] o_bm_tWTP_cfg,
   output  logic [7:0] o_bm_tRAS_cfg,
   output  logic [7:0] o_bm_tRC_cfg,
   output  logic [7:0] o_bm_tRP_cfg,
   output  logic [7:0] o_bm_tRCD_cfg,
   output  logic [7:0] o_bm_tCCDMW_cfg,

   output  logic [7:0] o_crb_READ_LATENCY_cfg,
   output  logic [7:0] o_crb_WRITE_LATENCY_cfg,

   output logic [7:0] o_dfi_rddata_en_latency_cfg,
   output logic [7:0] o_dfi_wrdata_en_latency_cfg,
   output logic [7:0] o_dfi_wdqs_preamble_cfg,

   output logic [7:0] o_initialize_done,
   output logic [1:0] o_native_fifo_clr,
   output logic       o_sys_rst_ovr
);

   /*
   logic                               async_hgrant;
   logic [31:0]                        async_haddr;
   logic                               async_hwrite;
   logic                               async_hbusreq;
   logic [31:0]                        async_hwdata;
   logic [1:0]                         async_htrans;
   logic [2:0]                         async_hsize;
   logic [2:0]                         async_hburst;
   logic                               async_hready;
   logic [31:0]                        async_hrdata;
   logic [1:0]                         async_hresp;
   """

   
   """
   mc_ahb_slave2master #(
      .AWIDTH  (32)
   ) u_mc_ahbm_s2m (
      .i_hclk                          (i_ahb_extclk),
      .i_hreset                        (i_ahb_extrst),
      .i_ahbs_haddr                    (i_haddr ),
      .i_ahbs_hwrite                   (i_hwrite),
      .i_ahbs_hsel                     (i_hsel  ),
      .i_ahbs_hwdata                   (i_hwdata),
      .i_ahbs_htrans                   (i_htrans), //ignored
      .i_ahbs_hsize                    (i_hsize ),
      .i_ahbs_hburst                   (i_hburst),
      .i_ahbs_hreadyin                 (i_hreadyin),
      .o_ahbs_hready                   (o_hready),
      .o_ahbs_hrdata                   (o_hrdata),
      .o_ahbs_hresp                    (o_hresp ),

      .i_ahbm_hgrant                   (async_hgrant),
      .o_ahbm_haddr                    (async_haddr ),
      .o_ahbm_hwrite                   (async_hwrite),
      .o_ahbm_hbusreq                  (async_hbusreq),
      .o_ahbm_hwdata                   (async_hwdata),
      .o_ahbm_htrans                   (async_htrans),
      .o_ahbm_hsize                    (async_hsize ),
      .o_ahbm_hburst                   (async_hburst),
      .i_ahbm_hready                   (async_hready),
      .i_ahbm_hrdata                   (async_hrdata),
      .i_ahbm_hresp                    (async_hresp )
   );

   assign o_hgrant=async_hgrant;
   */
   logic                               mc_hgrant;
   logic [31:0]                        mc_haddr;
   logic                               mc_hwrite;
   logic                               mc_hbusreq;
   logic [31:0]                        mc_hwdata;
   logic [1:0]                         mc_htrans;
   logic [2:0]                         mc_hsize;
   logic [2:0]                         mc_hburst;
   logic                               mc_hready;
   logic [31:0]                        mc_hrdata;
   logic [1:0]                         mc_hresp;

   logic mc_csr_rst_sync,mc_csr_rst_sync_q;
   always_ff @ (posedge i_sysclk, posedge i_ahb_extrst) begin
      if(i_ahb_extrst) begin
         mc_csr_rst_sync<=1;
         mc_csr_rst_sync_q<=1;
      end else begin
         mc_csr_rst_sync_q<=i_ahb_extrst;
         mc_csr_rst_sync<=mc_csr_rst_sync_q;
      end
   end

   mc_ahb2ahb_sync #(
      .AWIDTH     (32),
      .ASYNC      (1)
   ) u_mc_ahb_sync (

      .i_m2freq_hi                   (1'b1),

      .i_m1_hclk                     (i_ahb_extclk),
      .i_m1_hreset                   (i_ahb_extrst),

      .i_m2_hclk                     (i_sysclk),
      .i_m2_hreset                   (mc_csr_rst_sync),

      .i_m1_haddr                    (i_haddr ),
      .i_m1_hwrite                   (i_hwrite),
      .i_m1_hbusreq                  (i_hbusreq),
      .i_m1_hwdata                   (i_hwdata),
      .i_m1_htrans                   (i_htrans),
      .i_m1_hsize                    (i_hsize ),
      .i_m1_hburst                   (i_hburst),
      .o_m1_hready                   (o_hready),
      .o_m1_hrdata                   (o_hrdata),
      .o_m1_hresp                    (o_hresp ),
      .o_m1_hgrant                   (o_hgrant),
      .o_m1_clkon                    (/*OPEN*/),//FIXME
      .o_m2_clkon                    (/*OPEN*/),//FIXME

      .o_m2_haddr                    (mc_haddr ),
      .o_m2_hwrite                   (mc_hwrite),
      .o_m2_hbusreq                  (mc_hbusreq),
      .o_m2_hwdata                   (mc_hwdata),
      .o_m2_htrans                   (mc_htrans),
      .o_m2_hsize                    (mc_hsize ),
      .o_m2_hburst                   (mc_hburst),
      .i_m2_hready                   (mc_hready),
      .i_m2_hrdata                   (mc_hrdata),
      .i_m2_hresp                    (mc_hresp ),
      .i_m2_hgrant                   (1'b1)
   );


   logic mc_hsel;
   assign mc_hsel=(mc_haddr>=32'h00000000) & (mc_haddr<=32'h00000020)? 1'b1:1'b0;
   
   logic                slv_write;
   logic                slv_read;
   logic                slv_error;
   logic [31:0]         slv_addr;
   logic [31:0]         slv_wdata;
   logic [31:0]         slv_rdata;
   logic                slv_ready;

   mc_ahb_slave #(
      .AWIDTH(32),
      .DWIDTH(32)
   ) mc_ahb_slave (
      .i_hclk     (i_sysclk),
      .i_hreset   (mc_csr_rst_sync),
      .i_haddr    (mc_haddr),
      .i_hwrite   (mc_hwrite),
      .i_hsel     (mc_hsel),
      .i_hwdata   (mc_hwdata),
      .i_htrans   (mc_htrans),
      .i_hsize    (mc_hsize),
      .i_hburst   (mc_hburst),
      .i_hreadyin (1'b1),
      .o_hready   (mc_hready),
      .o_hrdata   (mc_hrdata),
      .o_hresp    (mc_hresp),
      .o_write    (slv_write),
      .o_read     (slv_read),
      .o_wdata    (slv_wdata),
      .o_addr     (slv_addr),
      .i_rdata    (slv_rdata),
      .i_error    (slv_error),
      .i_ready    (slv_ready)
   );

   

   mc_csr #(
      .AWIDTH(32),
      .DWIDTH(32)
   ) mc_csr (
      .i_hclk   (i_sysclk),
      .i_hreset (mc_csr_rst_sync),
      .i_write  (slv_write),
      .i_read   (slv_read),
      .i_wdata  (slv_wdata),
      .i_addr   (slv_addr),
      .o_rdata  (slv_rdata),
      .o_error  (slv_error),
      .o_ready  (slv_ready),
      .o_mul_rdphase_cfg(o_mul_rdphase_cfg),
      .o_mul_wrphase_cfg(o_mul_wrphase_cfg),
      .o_mul_rdcmd_phase_cfg(o_mul_rdcmd_phase_cfg),
      .o_mul_wrcmd_phase_cfg(o_mul_wrcmd_phase_cfg),
      .o_mul_tRRD_cfg(o_mul_tRRD_cfg),
      .o_mul_tFAW_cfg(o_mul_tFAW_cfg),
      .o_mul_tCCD_cfg(o_mul_tCCD_cfg),
      .o_mul_WTR_LATENCY_cfg(o_mul_WTR_LATENCY_cfg),
      .o_mul_RTW_LATENCY_cfg(o_mul_RTW_LATENCY_cfg),
      .o_mul_READ_TIME_cfg(o_mul_READ_TIME_cfg),
      .o_mul_WRITE_TIME_cfg(o_mul_WRITE_TIME_cfg),

      .o_ref_tREFI_cfg(o_ref_tREFI_cfg),
      .o_ref_POSTPONE_cfg(o_ref_POSTPONE_cfg),
      .o_ref_tRP_cfg(o_ref_tRP_cfg),
      .o_ref_tRFC_cfg(o_ref_tRFC_cfg),

      .o_bm_tRTP_cfg(o_bm_tRTP_cfg),
      .o_bm_tWTP_cfg(o_bm_tWTP_cfg),
      .o_bm_tRAS_cfg(o_bm_tRAS_cfg),
      .o_bm_tRC_cfg(o_bm_tRC_cfg),
      .o_bm_tRP_cfg(o_bm_tRP_cfg),
      .o_bm_tRCD_cfg(o_bm_tRCD_cfg),
      .o_bm_tCCDMW_cfg(o_bm_tCCDMW_cfg),

      .o_crb_READ_LATENCY_cfg(o_crb_READ_LATENCY_cfg),
      .o_crb_WRITE_LATENCY_cfg(o_crb_WRITE_LATENCY_cfg),

      .o_dfi_rddata_en_latency_cfg(o_dfi_rddata_en_latency_cfg),
      .o_dfi_wrdata_en_latency_cfg(o_dfi_wrdata_en_latency_cfg),
      .o_dfi_wdqs_preamble_cfg(o_dfi_wdqs_preamble_cfg),

      .o_initialize_done(o_initialize_done),
      .o_native_fifo_clr(o_native_fifo_clr),
      .o_sys_rst_ovr(o_sys_rst_ovr)
   );
endmodule

module mc_csr #(
   parameter AWIDTH = 32,
   parameter DWIDTH = 32
) (
   input   logic                i_hclk,
   input   logic                i_hreset,
   input   logic                i_write,
   input   logic                i_read,
   input   logic [AWIDTH-1:0]   i_addr,
   input   logic [DWIDTH-1:0]   i_wdata,
   output  logic [DWIDTH-1:0]   o_rdata,
   output  logic                o_error,
   output  logic                o_ready,
   output  logic [1:0] o_mul_rdphase_cfg,
   output  logic [1:0] o_mul_wrphase_cfg,
   output  logic [1:0] o_mul_rdcmd_phase_cfg,
   output  logic [1:0] o_mul_wrcmd_phase_cfg,
   output  logic [7:0] o_mul_tRRD_cfg,
   output  logic [7:0] o_mul_tFAW_cfg,
   output  logic [7:0] o_mul_tCCD_cfg,
   output  logic [7:0] o_mul_WTR_LATENCY_cfg,
   output  logic [7:0] o_mul_RTW_LATENCY_cfg,
   output  logic [7:0] o_mul_READ_TIME_cfg,
   output  logic [7:0] o_mul_WRITE_TIME_cfg,

   output  logic [11:0] o_ref_tREFI_cfg,
   output  logic [3:0] o_ref_POSTPONE_cfg,
   output  logic [7:0] o_ref_tRP_cfg,
   output  logic [7:0] o_ref_tRFC_cfg,

   output  logic [7:0] o_bm_tRTP_cfg,
   output  logic [7:0] o_bm_tWTP_cfg,
   output  logic [7:0] o_bm_tRAS_cfg,
   output  logic [7:0] o_bm_tRC_cfg,
   output  logic [7:0] o_bm_tRP_cfg,
   output  logic [7:0] o_bm_tRCD_cfg,
   output  logic [7:0] o_bm_tCCDMW_cfg,
   
   output  logic [7:0] o_crb_READ_LATENCY_cfg,
   output  logic [7:0] o_crb_WRITE_LATENCY_cfg,

   output logic [7:0] o_dfi_rddata_en_latency_cfg,
   output logic [7:0] o_dfi_wrdata_en_latency_cfg,
   output logic [7:0] o_dfi_wdqs_preamble_cfg,

   output logic [7:0] o_initialize_done,
   output logic [1:0] o_native_fifo_clr,
   output logic       o_sys_rst_ovr
);
typedef enum logic [3:0] {
      DECODE_MC_MUL_TIMING_CFG,
      DECODE_MC_MUL_LATENCY_CFG,
      DECODE_MC_REF_TIMING_CFG,
      DECODE_MC_BM_TIMING1_CFG,
      DECODE_MC_BM_TIMING2_CFG,
      DECODE_MC_CRB_CFG,
      DECODE_MC_DFI_CFG,
      DECODE_INIT_DONE,
      DECODE_NOOP_0,
      DECODE_NOOP_1,
      DECODE_NOOP_2
   } DECODE_T;

   DECODE_T decode;

   assign o_ready = 1'b1;

   always_comb begin
      o_error = 1'b0;
      case (i_addr)
         32'h00000000 : decode = DECODE_MC_MUL_TIMING_CFG;
         32'h00000004 : decode = DECODE_MC_MUL_LATENCY_CFG;
         32'h00000008 : decode = DECODE_MC_REF_TIMING_CFG;
         32'h0000000C : decode = DECODE_MC_BM_TIMING1_CFG;
         32'h00000010 : decode = DECODE_MC_BM_TIMING2_CFG;
         32'h00000014 : decode = DECODE_MC_CRB_CFG;
         32'h00000018 : decode = DECODE_MC_DFI_CFG;
         32'h0000001C : decode = DECODE_INIT_DONE;
         default : begin 
            decode = DECODE_NOOP_0;
            o_error = 1'b1;
         end
      endcase
   end

   logic [31:0] mc_mul_timing_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_mul_timing_cfg_q <= 32'h02100708 ;
      else
         if (i_write)
            if (decode == DECODE_MC_MUL_TIMING_CFG)
               mc_mul_timing_cfg_q <= i_wdata;

   assign o_mul_rdphase_cfg = mc_mul_timing_cfg_q[1:0];
   assign o_mul_wrphase_cfg = mc_mul_timing_cfg_q[3:2];
   assign o_mul_rdcmd_phase_cfg = mc_mul_timing_cfg_q[5:4];
   assign o_mul_wrcmd_phase_cfg = mc_mul_timing_cfg_q[7:6];
   assign o_mul_tRRD_cfg = mc_mul_timing_cfg_q[15:8];
   assign o_mul_tFAW_cfg = mc_mul_timing_cfg_q[23:16];
   assign o_mul_tCCD_cfg = mc_mul_timing_cfg_q[31:24];


   logic [31:0] mc_mul_latency_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_mul_latency_cfg_q <= 32'h20400a0d;
      else
         if (i_write)
            if (decode ==DECODE_MC_MUL_LATENCY_CFG)
               mc_mul_latency_cfg_q <= i_wdata;

   assign o_mul_WTR_LATENCY_cfg = mc_mul_latency_cfg_q[7:0];
   assign o_mul_RTW_LATENCY_cfg = mc_mul_latency_cfg_q[15:8];
   assign o_mul_READ_TIME_cfg = mc_mul_latency_cfg_q[23:16];
   assign o_mul_WRITE_TIME_cfg = mc_mul_latency_cfg_q[31:24];


   logic [31:0] mc_ref_timing_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_ref_timing_cfg_q <= 32'h610C8726;
      else
         if (i_write)
            if (decode == DECODE_MC_REF_TIMING_CFG)
               mc_ref_timing_cfg_q <= i_wdata;

   assign o_ref_tREFI_cfg = mc_ref_timing_cfg_q[11:0];
   assign o_ref_POSTPONE_cfg = mc_ref_timing_cfg_q[15:12];
   assign o_ref_tRP_cfg = mc_ref_timing_cfg_q[23:16];
   assign o_ref_tRFC_cfg = mc_ref_timing_cfg_q[31:24];

   logic [31:0] mc_bm_timing_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_bm_timing_cfg_q <= 32'h23181104;
      else
         if (i_write) 
            if (decode == DECODE_MC_BM_TIMING1_CFG)
               mc_bm_timing_cfg_q <= i_wdata;

   assign o_bm_tRTP_cfg = mc_bm_timing_cfg_q[7:0];
   assign o_bm_tWTP_cfg = mc_bm_timing_cfg_q[15:8];
   assign o_bm_tRAS_cfg = mc_bm_timing_cfg_q[23:16];
   assign o_bm_tRC_cfg = mc_bm_timing_cfg_q[31:24];

   logic [31:0] mc_bm_t_cfg_q; // address 10
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_bm_t_cfg_q <= 32'h00080b0c; //top 8 bits not needed
      else
         if (i_write)
            if (decode == DECODE_MC_BM_TIMING2_CFG)
               mc_bm_t_cfg_q <= i_wdata;

   assign o_bm_tRP_cfg = mc_bm_t_cfg_q[7:0];
   assign o_bm_tRCD_cfg = mc_bm_t_cfg_q[15:8];
   assign o_bm_tCCDMW_cfg = mc_bm_t_cfg_q[23:16];

   logic [31:0] mc_bm_crb_cfg_q; // address 14
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_bm_crb_cfg_q <= 32'h00000a0c;
      else
         if (i_write)
            if (decode == DECODE_MC_CRB_CFG)
               mc_bm_crb_cfg_q <= i_wdata;

   assign o_crb_READ_LATENCY_cfg = mc_bm_crb_cfg_q[7:0];
   assign o_crb_WRITE_LATENCY_cfg = mc_bm_crb_cfg_q[15:8];

   logic [31:0] mc_bm_dfi_cfg_q; // address 18
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_bm_dfi_cfg_q <= 32'h00f0090a;
      else
         if (i_write)
            if (decode == DECODE_MC_DFI_CFG)
               mc_bm_dfi_cfg_q <= i_wdata;

   assign o_dfi_rddata_en_latency_cfg = mc_bm_dfi_cfg_q[7:0];
   assign o_dfi_wrdata_en_latency_cfg = mc_bm_dfi_cfg_q[15:8];
   assign o_dfi_wdqs_preamble_cfg = mc_bm_dfi_cfg_q[23:16];


   logic [31:0] mc_init_done_q; // address 1C
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         mc_init_done_q <= 32'h00000100;
      else
         if (i_write)
            if (decode == DECODE_INIT_DONE)
               mc_init_done_q <= i_wdata;

   assign o_initialize_done = mc_init_done_q[0];
   assign o_native_fifo_clr = mc_init_done_q[5:4];
   assign o_sys_rst_ovr = mc_init_done_q[8];


   always_comb
      if (i_read)
         case (decode)
            DECODE_MC_MUL_TIMING_CFG : o_rdata = mc_mul_timing_cfg_q;
            DECODE_MC_MUL_LATENCY_CFG : o_rdata = mc_mul_latency_cfg_q;
            DECODE_MC_REF_TIMING_CFG : o_rdata = mc_ref_timing_cfg_q;
            DECODE_MC_BM_TIMING1_CFG : o_rdata = mc_bm_timing_cfg_q;
            DECODE_MC_BM_TIMING2_CFG : o_rdata = mc_bm_t_cfg_q;
            DECODE_MC_CRB_CFG : o_rdata = mc_bm_crb_cfg_q;
            DECODE_MC_DFI_CFG : o_rdata = mc_bm_dfi_cfg_q;
            DECODE_INIT_DONE: o_rdata = mc_init_done_q;
            default : o_rdata = '0;
         endcase
      else
         o_rdata = '0;

endmodule

/*
module mc_ahb_slave2master #(
   parameter AWIDTH = 32
) (
   input   logic                i_hclk,
   input   logic                i_hreset,
   // AHB slave
   input   logic [AWIDTH-1:0]   i_ahbs_haddr,
   input   logic                i_ahbs_hwrite,
   input   logic                i_ahbs_hsel,
   input   logic [31:0]         i_ahbs_hwdata,
   input   logic [1:0]          i_ahbs_htrans,
   input   logic [2:0]          i_ahbs_hsize,
   input   logic [2:0]          i_ahbs_hburst,
   input   logic                i_ahbs_hreadyin,
   output  logic                o_ahbs_hready,
   output  logic [31:0]         o_ahbs_hrdata,
   output  logic [1:0]          o_ahbs_hresp,

   // AHB Master
   output  logic [AWIDTH-1:0]   o_ahbm_haddr,
   output  logic                o_ahbm_hbusreq,
   input   logic                i_ahbm_hgrant,
   output  logic                o_ahbm_hwrite,
   output  logic [31:0]         o_ahbm_hwdata,
   output  logic [1:0]          o_ahbm_htrans,
   output  logic [2:0]          o_ahbm_hsize,
   output  logic [2:0]          o_ahbm_hburst,
   input   logic                i_ahbm_hready,
   input   logic [31:0]         i_ahbm_hrdata,
   input   logic [1:0]          i_ahbm_hresp
);

  logic vldtrans ;
  logic vldtrans_q ;
  logic wait_grant_q;

   assign vldtrans =  ((o_ahbm_htrans == AHB_TRANS_SEQ) | (o_ahbm_htrans == AHB_TRANS_NONSEQ)) & (o_ahbm_hbusreq == 1'b1);

   always_ff @ (posedge i_hclk, posedge i_hreset) begin
     if(i_hreset) begin
        vldtrans_q   <= '0 ;
        wait_grant_q <= '0 ;
     end
     else begin
        if (vldtrans & i_ahbm_hgrant) begin
           wait_grant_q <= 1'b0 ;
           vldtrans_q   <= 1'b1 ;
        end
        else if (vldtrans & !i_ahbm_hgrant) begin
           wait_grant_q <= 1'b1 ;
           vldtrans_q   <= 1'b1 ;
        end
        else if (vldtrans_q & i_ahbm_hready) begin
           wait_grant_q <= 1'b0 ;
           vldtrans_q   <= 1'b0 ;
        end
     end
   end

   // Master
   assign o_ahbm_haddr   = i_ahbs_haddr;
   assign o_ahbm_hbusreq = i_ahbs_hsel ; //& i_ahbs_hreadyin ;
   assign o_ahbm_hwrite  = i_ahbs_hwrite;
   assign o_ahbm_hwdata  = i_ahbs_hwdata;
   assign o_ahbm_htrans  = i_ahbs_htrans;
   assign o_ahbm_hsize   = i_ahbs_hsize;
   assign o_ahbm_hburst  = i_ahbs_hburst;
   // Slave
   assign o_ahbs_hready  = (vldtrans & !i_ahbm_hgrant) ? 1'b0 : (i_ahbm_hgrant | vldtrans_q) ? i_ahbm_hready  : 1'b1 ;
   assign o_ahbs_hrdata  = i_ahbm_hrdata;
   assign o_ahbs_hresp   = i_ahbm_hresp;

endmodule
*/
module mc_ahb_slave #(
   parameter AWIDTH = 32,
   parameter DWIDTH = 32
)(
   input   logic                i_hclk,
   input   logic                i_hreset,
   input   logic [AWIDTH-1:0]   i_haddr,
   input   logic                i_hwrite,
   input   logic                i_hsel,
   input   logic                i_hreadyin,
   input   logic [DWIDTH-1:0]   i_hwdata,
   input   logic [1:0]          i_htrans,
   input   logic [2:0]          i_hsize,
   input   logic [2:0]          i_hburst,
   output  logic                o_hready,
   output  logic [DWIDTH-1:0]   o_hrdata,
   output  logic [1:0]          o_hresp,

   output  logic                o_write,
   output  logic                o_read,
   output  logic [AWIDTH-1:0]   o_addr,
   output  logic [DWIDTH-1:0]   o_wdata,
   input   logic [DWIDTH-1:0]   i_rdata,
   input   logic                i_error,
   input   logic                i_ready
);

   logic [AWIDTH-1:0] addr_d;
   logic [AWIDTH-1:0] addr_q;
   logic write_d;
   logic write_q;
   logic read_d;
   logic read_q;
   logic [DWIDTH-1:0] wdata_q;
   //logic [DWIDTH-1:0] rdata_q;
   logic [DWIDTH-1:0] wdata_d;
   logic wr_q;

   assign write_d  =  i_hwrite & i_hsel /*& i_hreadyin*/ & ((i_htrans == AHB_TRANS_SEQ) | (i_htrans == AHB_TRANS_NONSEQ));
   assign read_d   = ~i_hwrite & i_hsel /*& i_hreadyin*/ & ((i_htrans == AHB_TRANS_SEQ) | (i_htrans == AHB_TRANS_NONSEQ));
   assign addr_d   =             i_hsel /*& i_hreadyin*/ & ((i_htrans == AHB_TRANS_SEQ) | (i_htrans == AHB_TRANS_NONSEQ)) ? i_haddr : addr_q;

   always_ff @(posedge i_hclk, posedge i_hreset) begin
      if (i_hreset) begin
         addr_q  <= '0;
         write_q <= '0;
         read_q  <= '0;
         wr_q    <= '0;
         wdata_q <= '0;
         //rdata_q <= '0;
      end
      else begin
         // Write or Read to start the transaction, ready to keep the command
         // on the output. A slave must only sample the address and control
         // signals and hsel when HREADY is asserted.
         if (i_ready || write_d || read_d) begin
            addr_q  <= addr_d;
            write_q <= write_d;
            read_q  <= read_d;
         end

         // Write signal delayed one cycle to align with data
         wr_q <= write_d;

         // Capture data if not ready and previous cycle was a write
         if (wr_q && !i_ready) begin
            wdata_q <= i_hwdata;
         end
         //if (read_d) begin
         //   rdata_q <= i_rdata;
         //end
      end
   end

   // Previous cycle was not command cycle, but slave may not be ready so
   // select the captured data
   assign wdata_d = !wr_q ? wdata_q : i_hwdata;

   // Delay the write address by one cycle to align to data
   assign o_addr   = addr_q;
   assign o_write  = write_q;
   assign o_read   = read_q;
   assign o_wdata  = wdata_d;
   assign o_hrdata = i_rdata;
   assign o_hready = i_ready;
   assign o_hresp  = (i_error==1'b0) ? AHB_RESP_OK : AHB_RESP_ERROR ;

endmodule

module mc_ahb2ahb_sync #(
   parameter DWIDTH           = 32,
   parameter AWIDTH           = 32,
   parameter ASYNC            = 0
) (
    input logic                 i_m2freq_hi    ,

    input logic                 i_m1_hclk    ,
    input logic                 i_m1_hreset  ,
    input logic                 i_m2_hclk    ,
    input logic                 i_m2_hreset  ,
    output logic                o_m1_clkon   ,
    output logic                o_m2_clkon   ,

    input  logic [AWIDTH-1:0]   i_m1_haddr,
    input  logic                i_m1_hwrite,
    input  logic                i_m1_hbusreq,
    input  logic [DWIDTH-1:0]   i_m1_hwdata,
    input  logic [1:0]          i_m1_htrans,
    input  logic [2:0]          i_m1_hsize,
    input  logic [2:0]          i_m1_hburst,
    output logic                o_m1_hready,
    output logic [DWIDTH-1:0]   o_m1_hrdata,
    output logic [1:0]          o_m1_hresp ,
    output logic                o_m1_hgrant,

    output logic [AWIDTH-1:0]   o_m2_haddr,
    output logic                o_m2_hwrite,
    output logic                o_m2_hbusreq,
    output logic [DWIDTH-1:0]   o_m2_hwdata,
    output logic [1:0]          o_m2_htrans,
    output logic [2:0]          o_m2_hsize,
    output logic [2:0]          o_m2_hburst,
    input  logic                i_m2_hready,
    input  logic [DWIDTH-1:0]   i_m2_hrdata,
    input  logic [1:0]          i_m2_hresp ,
    input  logic                i_m2_hgrant
   );

   localparam CWIDTH = AWIDTH+10;
   localparam WWIDTH = DWIDTH ;
   localparam RWIDTH = DWIDTH+4;
   generate
   if(ASYNC==1) begin: ASYNC_FIFO
   // ASYNC FIFO
     logic [AWIDTH-1:0]   m1_haddr_q;
     logic                m1_hwrite_q;
     logic                m1_hbusreq_q;
     logic [DWIDTH-1:0]   m1_hwdata_q;
     logic [1:0]          m1_htrans_q;
     logic [2:0]          m1_hsize_q;
     logic [2:0]          m1_hburst_q;

     logic                m1_hready;
     logic [DWIDTH-1:0]   m1_hrdata;
     logic [1:0]          m1_hresp ;
     logic                m1_hgrant;

     logic [AWIDTH-1:0]   m2_haddr;
     logic                m2_hwrite;
     logic                m2_hbusreq;
     logic [DWIDTH-1:0]   m2_hwdata;
     logic [1:0]          m2_htrans;
     logic [2:0]          m2_hsize;
     logic [2:0]          m2_hburst;

     logic                hready ;

     logic [AWIDTH-1:0]   m2_haddr_q;
     logic                m2_hwrite_q;
     logic                m2_hbusreq_q;
     logic [DWIDTH-1:0]   m2_hwdata_q;
     logic [1:0]          m2_htrans_q;
     logic [2:0]          m2_hsize_q;
     logic [2:0]          m2_hburst_q;

     logic                m1_vld_wrtrans  , m2_vld_wrtrans ;
     logic                m1_vld_rdtrans  , m2_vld_rdtrans ;
     logic                m1_vld_rsp      , m2_vld_rsp     ;

     logic                req_fifo_wr  ;
     logic                reqd_fifo_wr ;
     logic                rsp_fifo_wr  ;

     logic                req_fifo_rd,  req_fifo_rd_q;
     logic                reqd_fifo_rd, reqd_fifo_rd_q;
     logic                rsp_fifo_rd,  rsp_fifo_rd_q;

     logic [CWIDTH-1:0]   req_fifo_wdata;
     logic [CWIDTH-1:0]   req_fifo_rdata;
     logic [WWIDTH-1:0]   reqd_fifo_wdata;
     logic [WWIDTH-1:0]   reqd_fifo_rdata;
     logic [RWIDTH-1:0]   rsp_fifo_wdata;
     logic [RWIDTH-1:0]   rsp_fifo_rdata;

     logic                rsp_fifo_empty_n;
     logic                rsp_fifo_full;
     logic                rsp_fifo_full_q;
     logic                req_fifo_empty_n;
     logic                req_fifo_full;
     logic                req_fifo_full_q;
     logic                reqd_fifo_empty_n;
     logic                reqd_fifo_early_empty_n;
     logic                reqd_fifo_full;
     logic                reqd_fifo_full_q;
     logic                wrreq_fifo_full;

     typedef enum logic [2:0] {
        IDLE                  = 3'h0,
        WR_PHASE              = 3'h1,
        WR_DATA_PHASE         = 3'h2,
        RD_PHASE              = 3'h3,
        RD_DATA_PHASE         = 3'h4,
        RD_DATA_WR_ADDR_PHASE = 3'h5,
        RD_DATA_RD_ADDR_PHASE = 3'h6
     } state_t;

     state_t reqwr_state_q, reqwr_state_d ;
     state_t reqrd_state_q, reqrd_state_d ;

     assign wrreq_fifo_full     = (req_fifo_full_q | reqd_fifo_full_q);
     assign m1_vld_wrtrans      = o_m1_hready & ~wrreq_fifo_full & i_m1_hbusreq & (i_m1_hwrite & ((i_m1_htrans == AHB_TRANS_SEQ) | (i_m1_htrans == AHB_TRANS_NONSEQ)));
     assign m1_vld_rdtrans      = o_m1_hready & ~req_fifo_full_q & i_m1_hbusreq & (~i_m1_hwrite & ((i_m1_htrans == AHB_TRANS_SEQ) | (i_m1_htrans == AHB_TRANS_NONSEQ)));
     assign m1_vld_rsp          = m1_hready & rsp_fifo_empty_n;

     assign req_fifo_wdata      = { i_m1_htrans, i_m1_hsize, i_m1_hburst, i_m1_hwrite, i_m1_hbusreq, i_m1_haddr };
     assign reqd_fifo_wdata     = i_m1_hwdata ;

     assign { m1_hresp, m1_hgrant, m1_hready, m1_hrdata } = rsp_fifo_rdata;

     always_ff @(posedge i_m1_hclk, posedge i_m1_hreset) begin
        if (i_m1_hreset) begin
          reqwr_state_q     <= IDLE;
          req_fifo_full_q   <= '0;
          reqd_fifo_full_q  <= '0;
        end
        else begin
          reqwr_state_q     <= reqwr_state_d ;
          req_fifo_full_q   <= req_fifo_full   ;
          reqd_fifo_full_q  <= reqd_fifo_full  ;
        end
     end

     assign o_m1_hready = ((reqwr_state_q == RD_PHASE) && m1_vld_rsp) ?  m1_hready : hready      ;
     assign o_m1_hrdata = ((reqwr_state_q == RD_PHASE) && m1_vld_rsp) ?  m1_hrdata : '0          ;
     assign o_m1_hresp  = ((reqwr_state_q == RD_PHASE) && m1_vld_rsp) ?  m1_hresp  : AHB_RESP_OK ;
     assign o_m1_hgrant = (reqwr_state_q == RD_PHASE)                 ?  1'b1      : hready      ;
     assign o_m1_clkon  = (reqwr_state_q != IDLE) ;

     always_comb begin
        reqwr_state_d = reqwr_state_q ;
        req_fifo_wr   = '0 ;
        reqd_fifo_wr  = '0 ;
        rsp_fifo_rd   = '0 ;
        hready        = ~wrreq_fifo_full ;
        case(reqwr_state_q)
           IDLE : begin
              if(m1_vld_wrtrans ) begin
                 reqwr_state_d   = WR_PHASE ;
                 req_fifo_wr    = 1'b1 ;
              end
              else if (m1_vld_rdtrans) begin
                 reqwr_state_d   = RD_PHASE ;
                 req_fifo_wr    = 1'b1 ;
              end
           end
           WR_PHASE : begin
              reqd_fifo_wr = 1'b1;
              if(m1_vld_wrtrans) begin
                 req_fifo_wr    = 1'b1 ;
                 reqwr_state_d   = WR_PHASE ;
              end
              else if(m1_vld_rdtrans) begin
                 req_fifo_wr    = 1'b1 ;
                 reqwr_state_d   = RD_PHASE ;
              end
              else begin
                 reqwr_state_d   = IDLE ;
              end
           end
           RD_PHASE : begin
              hready = 1'b0 ;
              if(m1_vld_wrtrans && m1_vld_rsp) begin
                 reqwr_state_d   = WR_PHASE ;
                 req_fifo_wr     = 1'b1 ;
                 rsp_fifo_rd     = 1'b1 ;
              end
              else if (m1_vld_rdtrans && m1_vld_rsp) begin
                 reqwr_state_d   = RD_PHASE ;
                 req_fifo_wr     = 1'b1 ;
                 rsp_fifo_rd     = 1'b1 ;
              end
              else if (m1_vld_rsp) begin
                 reqwr_state_d   = IDLE;
                 rsp_fifo_rd     = 1'b1 ;
              end
           end
            default:begin
               reqwr_state_d = reqwr_state_q ;
               req_fifo_wr   = '0 ;
               reqd_fifo_wr  = '0 ;
               rsp_fifo_rd   = '0 ;
               hready        = ~wrreq_fifo_full ;
            end
        endcase
     end

     mc_fifo #(
        .WWIDTH    ( CWIDTH ),
        .RWIDTH    ( CWIDTH ),
        .DEPTH     ( 4  )
     ) u_mc_ahb_req_buf (


        .i_clr           (1'b0),
        .i_loop_mode     ('0),
        .i_load_ptr      ('0),
        .i_stop_ptr      ('0),
        .i_start_ptr     ('0),

        .i_wclk          (i_m1_hclk),
        .i_wrst          (i_m1_hreset),
        .i_write         (req_fifo_wr),
        .i_wdata         (req_fifo_wdata),
        .o_early_full    (req_fifo_full),
        .o_full          (/*OPEN*/),

        .i_rclk          (i_m2_hclk),
        .i_rrst          (i_m2_hreset),
        .i_read          (req_fifo_rd),
        .o_rdata         (req_fifo_rdata),
        .o_early_empty_n (/*OPEN*/),
        .o_empty_n       (req_fifo_empty_n)
     );

     mc_fifo #(
        .WWIDTH    ( WWIDTH ),
        .RWIDTH    ( WWIDTH ),
        .DEPTH     ( 4  )
     ) u_mc_ahb_wrd_buf (

        .i_clr           (1'b0),
        .i_loop_mode     ('0),
        .i_load_ptr      ('0),
        .i_stop_ptr      ('0),
        .i_start_ptr     ('0),

        .i_wclk          (i_m1_hclk),
        .i_wrst          (i_m1_hreset),
        .i_write         (reqd_fifo_wr),
        .i_wdata         (reqd_fifo_wdata),
        .o_early_full    (reqd_fifo_full),
        .o_full          (/*OPEN*/),

        .i_rclk          (i_m2_hclk),
        .i_rrst          (i_m2_hreset),
        .i_read          (reqd_fifo_rd),
        .o_rdata         (reqd_fifo_rdata),
        .o_early_empty_n (reqd_fifo_early_empty_n),
        .o_empty_n       (reqd_fifo_empty_n)
     );

     assign { m2_htrans, m2_hsize, m2_hburst, m2_hwrite, m2_hbusreq, m2_haddr } = req_fifo_rdata ;
     assign m2_hwdata                                                           = reqd_fifo_rdata ;

     assign m2_vld_rsp        = i_m2_hready ;
     //assign m2_vld_rsp        = i_m2_hready & i_m2_hgrant ;
     assign m2_vld_wrtrans    = (req_fifo_empty_n & reqd_fifo_empty_n) & (m2_hbusreq & m2_hwrite & ((m2_htrans == AHB_TRANS_SEQ) | (m2_htrans == AHB_TRANS_NONSEQ)));
     assign m2_vld_rdtrans    = (req_fifo_empty_n & ~rsp_fifo_full_q) & (m2_hbusreq & ~m2_hwrite & ((m2_htrans == AHB_TRANS_SEQ) | (m2_htrans == AHB_TRANS_NONSEQ)));
     assign rsp_fifo_wdata    = { i_m2_hresp, i_m2_hgrant, i_m2_hready, i_m2_hrdata };

     always_ff @(posedge i_m2_hclk, posedge i_m2_hreset) begin
        if (i_m2_hreset) begin
          reqrd_state_q   <= IDLE ;
          req_fifo_rd_q   <= '0 ;
          reqd_fifo_rd_q  <= '0 ;
          rsp_fifo_full_q <= '0;
        end
        else begin
          reqrd_state_q   <= reqrd_state_d ;
          reqd_fifo_rd_q  <= reqd_fifo_rd ;
          rsp_fifo_full_q <= rsp_fifo_full ;
          if (req_fifo_rd | (req_fifo_rd_q & m2_vld_rsp))
             req_fifo_rd_q   <= req_fifo_rd ;
        end
     end

     always_ff @(posedge i_m2_hclk, posedge i_m2_hreset) begin
        if (i_m2_hreset) begin
          m2_haddr_q      <= '0;
          m2_hwrite_q     <= '0;
          m2_hbusreq_q    <= '0;
          m2_htrans_q     <= '0;
          m2_hsize_q      <= '0;
          m2_hburst_q     <= '0;
          m2_hwdata_q     <= '0;
        end
        else begin
          if (req_fifo_rd_q && !req_fifo_rd  && m2_vld_rsp ) begin
            m2_haddr_q      <= m2_haddr_q ;
            m2_hbusreq_q    <= 1'b0 ;
            m2_hwrite_q     <= 1'b0 ;
            m2_htrans_q     <= AHB_TRANS_IDLE  ;
            m2_hsize_q      <= m2_hsize   ;
            m2_hburst_q     <= m2_hburst  ;
          end
          else if(req_fifo_rd) begin
            m2_haddr_q      <= m2_haddr   ;
            m2_hwrite_q     <= m2_hwrite  ;
            m2_hbusreq_q    <= m2_hbusreq ;
            m2_htrans_q     <= m2_htrans  ;
            m2_hsize_q      <= m2_hsize   ;
            m2_hburst_q     <= m2_hburst  ;
          end
          if(reqd_fifo_rd) begin
            m2_hwdata_q     <= m2_hwdata  ;
          end

        end
     end

     assign o_m2_haddr      = m2_haddr_q  ;
     assign o_m2_hwrite     = m2_hwrite_q ;
     assign o_m2_hbusreq    = m2_hbusreq_q;
     assign o_m2_htrans     = m2_htrans_q ;
     assign o_m2_hsize      = m2_hsize_q  ;
     assign o_m2_hburst     = m2_hburst_q ;
     assign o_m2_hwdata     = m2_hwdata_q ;
     assign o_m2_clkon      = (reqrd_state_q != IDLE) ;

     always_comb begin
        reqrd_state_d  = reqrd_state_q ;
        req_fifo_rd    = '0 ;
        reqd_fifo_rd   = '0 ;
        rsp_fifo_wr    = '0 ;
        case(reqrd_state_q)
           IDLE : begin
              if( m2_vld_wrtrans ) begin
                 reqrd_state_d   = WR_PHASE ;
                 req_fifo_rd    = 1'b1 ;
              end
              else if ( m2_vld_rdtrans ) begin
                 reqrd_state_d   = RD_PHASE ;
                 req_fifo_rd    = 1'b1 ;
              end
           end
           WR_PHASE : begin
              if(~i_m2freq_hi & m2_vld_rsp & m2_vld_wrtrans & reqd_fifo_early_empty_n ) begin
                 reqd_fifo_rd   = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = WR_PHASE ;
              end
              else if(~i_m2freq_hi & m2_vld_rsp & m2_vld_rdtrans ) begin
                 reqd_fifo_rd   = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 reqd_fifo_rd    = 1'b1 ;
                 reqrd_state_d   = WR_DATA_PHASE ;
              end
           end
           WR_DATA_PHASE : begin
              if(m2_vld_rsp & m2_vld_wrtrans & reqd_fifo_early_empty_n ) begin
                 req_fifo_rd   = 1'b1 ;
                 reqrd_state_d  = WR_PHASE ;
              end
              else if(m2_vld_rsp & m2_vld_rdtrans ) begin
                 req_fifo_rd   = 1'b1 ;
                 reqrd_state_d  = RD_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 reqrd_state_d  = IDLE ;
              end
           end
           RD_PHASE : begin
              if( ~i_m2freq_hi & m2_vld_rsp & m2_vld_wrtrans ) begin
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_DATA_WR_ADDR_PHASE ;
              end
              else if(~i_m2freq_hi & m2_vld_rsp & m2_vld_rdtrans ) begin
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_DATA_RD_ADDR_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 reqrd_state_d  = RD_DATA_PHASE ;
              end
           end
           RD_DATA_WR_ADDR_PHASE : begin
              if(m2_vld_rsp & m2_vld_wrtrans ) begin
                 rsp_fifo_wr    = 1'b1 ;
                 reqd_fifo_rd   = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = WR_PHASE ;
              end
              else if(m2_vld_rsp & m2_vld_rdtrans ) begin
                 reqd_fifo_rd   = 1'b1 ;
                 rsp_fifo_wr    = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 reqd_fifo_rd   = 1'b1 ;
                 rsp_fifo_wr    = 1'b1 ;
                 reqrd_state_d  = WR_DATA_PHASE ;
              end
           end
           RD_DATA_RD_ADDR_PHASE : begin
              if(m2_vld_rsp & m2_vld_wrtrans ) begin
                 rsp_fifo_wr    = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = WR_PHASE ;
              end
              else if(m2_vld_rsp & m2_vld_rdtrans ) begin
                 rsp_fifo_wr    = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 rsp_fifo_wr    = 1'b1 ;
                 reqrd_state_d  = RD_DATA_PHASE ;
              end
           end
           RD_DATA_PHASE : begin
              if(m2_vld_rsp & m2_vld_wrtrans ) begin
                 rsp_fifo_wr    = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = WR_PHASE ;
              end
              else if(~i_m2freq_hi & m2_vld_rsp & m2_vld_rdtrans ) begin
                 rsp_fifo_wr    = 1'b1 ;
                 req_fifo_rd    = 1'b1 ;
                 reqrd_state_d  = RD_PHASE ;
              end
              else if(m2_vld_rsp) begin
                 rsp_fifo_wr    = 1'b1 ;
                 reqrd_state_d  = IDLE ;
              end
           end
           default:begin
            reqrd_state_d  = reqrd_state_q ;
            req_fifo_rd    = '0 ;
            reqd_fifo_rd   = '0 ;
            rsp_fifo_wr    = '0 ;
           end
        endcase
     end

     mc_fifo #(
        .WWIDTH    ( RWIDTH ),
        .RWIDTH    ( RWIDTH ),
        .DEPTH     ( 4  )
     ) u_mc_ahbm_rsp_buf (

        .i_clr           (1'b0),  //FIXME
        .i_loop_mode     ('0),
        .i_load_ptr      ('0),
        .i_stop_ptr      ('0),
        .i_start_ptr     ('0),

        .i_wclk          (i_m2_hclk),
        .i_wrst          (i_m2_hreset),
        .i_write         (rsp_fifo_wr),
        .i_wdata         (rsp_fifo_wdata),
        .o_early_full    (rsp_fifo_full),
        .o_full          (/*OPEN*/),

        .i_rclk          (i_m1_hclk),
        .i_rrst          (i_m1_hreset),
        .i_read          (rsp_fifo_rd),
        .o_rdata         (rsp_fifo_rdata),
        .o_early_empty_n (/*OPEN*/),
        .o_empty_n       (rsp_fifo_empty_n)
     );

  end
//else if (ISO_SYNC2LO==1) begin

//end
//else if (ISO_SYNC2HI==1) begin

//end
  else begin : FEEDTHROUGH
    assign  o_m2_haddr   = i_m1_haddr  ;
    assign  o_m2_hwrite  = i_m1_hwrite ;
    assign  o_m2_hbusreq = i_m1_hbusreq;
    assign  o_m2_hwdata  = i_m1_hwdata ;
    assign  o_m2_htrans  = i_m1_htrans ;
    assign  o_m2_hsize   = i_m1_hsize  ;
    assign  o_m2_hburst  = i_m1_hburst ;

    assign  o_m1_hready  = i_m2_hready;
    assign  o_m1_hrdata  = i_m2_hrdata;
    assign  o_m1_hresp   = i_m2_hresp ;
    assign  o_m1_hgrant  = i_m2_hgrant;
  end
   endgenerate
endmodule

module mc_fifo #(
   parameter       WWIDTH    = 32,
   parameter       RWIDTH    = 32,
   parameter       BWIDTH    = 8,
   parameter       DEPTH     = 8,
   parameter [0:0] SYNC      = 1'b0,
   parameter [0:0] RAM_MODEL = 1'b0,
   parameter       AWIDTH    = $clog2(DEPTH)
) (


   input   logic                i_clr,
   input   logic                i_loop_mode,
   input   logic                i_load_ptr,
   input   logic [AWIDTH-1:0]   i_stop_ptr,
   input   logic [AWIDTH-1:0]   i_start_ptr,

   input   logic                i_wclk,
   input   logic                i_wrst,
   input   logic                i_write,
   input   logic [WWIDTH-1:0]   i_wdata,
   output  logic                o_full,
   output  logic                o_early_full,

   input   logic                i_rclk,
   input   logic                i_rrst,
   input   logic                i_read,
   output  logic [RWIDTH-1:0]   o_rdata,
   output  logic                o_early_empty_n,
   output  logic                o_empty_n
);

   logic [  AWIDTH:0] rbin_d , wbin_d;
   logic [  AWIDTH:0] rbin_q , wbin_q;
   logic [  AWIDTH:0] rgray_d, wgray_d;
   logic [  AWIDTH:0] wbin_next_d ;
   logic [  AWIDTH:0] wgray_next_d ;
   logic [  AWIDTH:0] rgray_q, wgray_q;
   logic [  AWIDTH:0] rbin_next_d ;
   logic [  AWIDTH:0] rgray_next_q, rgray_next_d;
   logic [  AWIDTH:0] rgray_sync, wgray_sync;
   logic [AWIDTH-1:0] raddr, waddr;

   // ------------------------------------------------------------------------
   // Clock Gate
   // ------------------------------------------------------------------------

   logic rclk_g;
   //ddr_cgc_rl u_cgc_rl (.i_clk(i_rclk), .i_clk_en(o_empty_n), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(rclk_g));
   assign rclk_g=i_rclk;
   // ------------------------------------------------------------------------
   // Reset
   // ------------------------------------------------------------------------

   logic rrst, rrst_scan;
   logic wrst, wrst_scan;

   assign rrst = i_rrst | i_clr;
   assign wrst = i_wrst | i_clr;

   //ddr_scan_rst u_scan_rrst ( .i_scan_rst_ctrl(i_scan_rst_ctrl), .i_rst(rrst), .o_rst(rrst_scan));
   //ddr_scan_rst u_scan_wrst ( .i_scan_rst_ctrl(i_scan_rst_ctrl), .i_rst(wrst), .o_rst(wrst_scan));
   assign rrst_scan=rrst;
   assign wrst_scan=wrst;
   // ------------------------------------------------------------------------
   // FIFO Memory
   // ------------------------------------------------------------------------

   // Choose Flip-Flop register file or RAM model
   /*
   generate
      if (!RAM_MODEL) begin : REGFILE
         logic [RWIDTH-1:0] mem [DEPTH-1:0];
         always_ff @(posedge i_wclk)
            if (i_write)
               mem[waddr] <= i_wdata;

         assign o_rdata = mem[raddr];
      end else begin : RAM
         ddr_ram_dp #(
            .DWIDTH     (RWIDTH),
            .BWIDTH     (BWIDTH),
            .SIZE       (DEPTH)
         ) u_ram_dp (
            .i_clk_0    (i_wclk),
            .i_addr_0   (waddr),
            .i_en_0     (i_write),
            .i_we_0     (1'b1),
            .i_be_0     ('1),
            .i_wdata_0  (i_wdata),
            .o_rdata_0  (),
            .i_clk_1    (rclk_g),
            .i_addr_1   (raddr),
            .i_en_1     (1'b1),
            .i_we_1     (1'b0),
            .i_be_1     ('1),
            .i_wdata_1  ('0),
            .o_rdata_1  (o_rdata)
         );
      end
   endgenerate
   */
   logic [RWIDTH-1:0] mem [DEPTH-1:0];
   always_ff @(posedge i_wclk)
      if (i_write)
         mem[waddr] <= i_wdata;

   assign o_rdata = mem[raddr];

   // ------------------------------------------------------------------------
   // Write Counter
   // ------------------------------------------------------------------------
   logic  max_loop_wptr;
   assign max_loop_wptr = i_loop_mode && (wbin_q == i_stop_ptr) ;

// assign wbin_d       = i_write ?  wbin_q + 'b1 : wbin_q;
   assign wbin_d       = i_load_ptr ? i_start_ptr :
                         i_write && max_loop_wptr ? i_start_ptr :
                         i_write ?  wbin_q + 'b1 : wbin_q;

   assign wgray_d      = (wbin_d >> 1) ^ wbin_d;
   assign wbin_next_d  = wbin_d + 'b1 ;
   assign wgray_next_d = (wbin_next_d >> 1) ^ wbin_next_d;

   always_ff @(posedge i_wclk, posedge wrst_scan) begin
      if (wrst_scan) begin
         wbin_q       <= '0;
         wgray_q      <= '0;
      end else begin
         if (i_write || i_load_ptr ) begin
            wbin_q    <= wbin_d;
            wgray_q   <= wgray_d;
         end
      end
   end

   assign o_early_full = wgray_next_d == {~rgray_sync[AWIDTH:AWIDTH-1],rgray_sync[AWIDTH-2:0]};
   assign o_full       = wgray_d == {~rgray_sync[AWIDTH:AWIDTH-1],rgray_sync[AWIDTH-2:0]};
   assign waddr        = wbin_q[AWIDTH-1:0];

   // ------------------------------------------------------------------------
   // Read Counter
   // ------------------------------------------------------------------------
   logic  max_loop_rptr;
   assign max_loop_rptr = i_loop_mode && (rbin_q == i_stop_ptr) ;

//   assign rbin_d  = i_read ? rbin_q + 'b1 : rbin_q;
   assign rbin_d       = i_load_ptr ? i_start_ptr :
                         i_read && max_loop_rptr ? i_start_ptr :
                         i_read ?  rbin_q + 'b1 : rbin_q;

   assign rgray_d = (rbin_d >> 1) ^ rbin_d;
   assign rbin_next_d  = rbin_d + 'b1 ;
   assign rgray_next_d = (rbin_next_d >> 1) ^ rbin_next_d;

   always_ff @(posedge rclk_g, posedge rrst_scan) begin
      if (rrst_scan) begin
         rbin_q       <= '0;
         rgray_q      <= '0;
         rgray_next_q <= '0;
      end else begin
         if (i_read) begin
            rbin_q       <= rbin_d;
            rgray_q      <= rgray_d;
            rgray_next_q <= rgray_next_d;
         end
      end
   end

   assign o_early_empty_n = (rgray_next_q != wgray_sync) & o_empty_n ;
   assign o_empty_n       = rgray_q != wgray_sync; 
   assign raddr           = rbin_q[AWIDTH-1:0];
   // ------------------------------------------------------------------------
   // Synchronizers
   // ------------------------------------------------------------------------

   generate
     if (SYNC) begin : WR_SYNC
         assign wgray_sync = wgray_q;
     end else begin : WR_ASYNC
         mc_demet_r wsync [AWIDTH+1] (
            .i_clk   (i_rclk),
            .i_rst   (rrst_scan),
            .i_d     (wgray_q),
            .o_q     (wgray_sync)
         );
     end
   endgenerate

   generate
     if (SYNC) begin : RD_SYNC
         assign rgray_sync = rgray_q;
     end else begin : RD_ASYNC
         mc_demet_r rsync [AWIDTH+1] (
            .i_clk   (i_wclk),
            .i_rst   (wrst_scan),
            .i_d     (rgray_q),
            .o_q     (rgray_sync)
         );
     end
   endgenerate

endmodule

module mc_demet_r #(
   parameter DWIDTH = 1
) (
   input  logic              i_clk,
   input  logic              i_rst,
   input  logic [DWIDTH-1:0] i_d,
   output logic [DWIDTH-1:0] o_q
);

   logic [DWIDTH-1:0] q0;
   always_ff@(posedge i_clk) begin 
      if(i_rst) begin 
         q0<='d0;
         o_q<='d0;
      end else begin
         q0<=i_d;
         o_q<=q0;
      end
   end
   //ddr_dff_r u_dff_0 [DWIDTH-1:0] (.i_clk(i_clk), .i_rst(i_rst), .i_d(i_d), .o_q(q0));
   //ddr_dff_r u_dff_1 [DWIDTH-1:0] (.i_clk(i_clk), .i_rst(i_rst), .i_d(q0), .o_q(o_q));

endmodule