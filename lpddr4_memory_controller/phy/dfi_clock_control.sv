module ddr_dfi_clk_ctrl (
   input  logic                           i_scan_cgc_ctrl,
   input  logic                           i_rst,
   input  logic                           i_phy_clk,
   input  logic                           i_wr_clk_1,
   input  logic                           i_wr_clk_2  ,

   input  dwgb_t                          i_wrgb_mode,
   input  drgb_t                          i_rdgb_mode,
   input  logic                           i_dq_wrclk_en ,           // WR data Enbale @ dfi clock rate.
   input  logic                           i_dqs_wrclk_en ,          // WR data Enbale or WCK enable @ dfi clock rate.
   input  logic                           i_ca_clk_en ,             // CS  @ dfi clock rate.
   input  logic                           i_ck_clk_en ,             // CA Clk Enbale @ dfi clock rate.
   input  logic [5:0]                     i_dq_wrclk_en_pulse_ext,  // WR data Enbale pulse extension cycles @ dfi clock rate.
   input  logic [5:0]                     i_dqs_wrclk_en_pulse_ext, // WR data Enbale or WCK OE  pulse extension cycles @ dfi clock rate.
   input  logic [5:0]                     i_ck_clk_en_pulse_ext,    // CS pulse extension cycles @ dfi clock rate.
   input  logic [5:0]                     i_ca_clk_en_pulse_ext,    // CA clk en pulse extension cycles @ dfi clock rate.
   input  logic                           i_ca_traffic_ovr_sel,
   input  logic                           i_ca_traffic_ovr,
   input  logic                           i_ck_traffic_ovr_sel,
   input  logic                           i_ck_traffic_ovr,
   input  logic                           i_dq_wrtraffic_ovr_sel,
   input  logic                           i_dq_wrtraffic_ovr,
   input  logic                           i_dqs_wrtraffic_ovr_sel,
   input  logic                           i_dqs_wrtraffic_ovr,

   output logic                           o_dqs_wrtraffic,
   output logic                           o_dq_wrtraffic,
   output logic                           o_ca_traffic,
   output logic                           o_ck_traffic,
   output logic [9:0]                     o_dfiwrgb_mode,
   output logic [9:0]                     o_dfirdgb_mode,
   output logic                           o_wrc_clk_0  ,
   output logic                           o_wrc_clk_1  ,
   output logic                           o_wrc_clk_2  ,
   output logic                           o_wrd_clk_0  ,
   output logic                           o_wrd_clk_1  ,
   output logic                           o_wrd_clk_2  ,
   output logic                           o_cmda_clk_0  ,
   output logic                           o_cmda_clk_1  ,
   output logic                           o_cmda_clk_2  ,
   output logic                           o_cmdc_clk_0  ,
   output logic                           o_cmdc_clk_1  ,
   output logic                           o_cmdc_clk_2  ,
   output logic                           o_dfi_clk
);

   // WR Clock gating and Dividers
   logic dqs_wrclk_en_extended;
   logic dq_wrclk_en_extended;
   logic ca_clk_en_extended;
   logic ck_clk_en_extended;

   logic dqs_wrtraffic_ovr_sel_sync, dqs_wrtraffic_ovr_sync;
   logic dq_wrtraffic_ovr_sel_sync,  dq_wrtraffic_ovr_sync;
   logic ck_traffic_ovr_sel_sync,    ck_traffic_ovr_sync;
   logic ca_traffic_ovr_sel_sync,    ca_traffic_ovr_sync;

   ddr_demet_r u_demet_0     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_dqs_wrtraffic_ovr_sel), .o_q(dqs_wrtraffic_ovr_sel_sync));
   ddr_demet_r u_demet_1     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_dqs_wrtraffic_ovr),     .o_q(dqs_wrtraffic_ovr_sync));
   ddr_demet_r u_demet_2     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_dq_wrtraffic_ovr_sel),  .o_q(dq_wrtraffic_ovr_sel_sync));
   ddr_demet_r u_demet_3     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_dq_wrtraffic_ovr),      .o_q(dq_wrtraffic_ovr_sync));
   ddr_demet_r u_demet_4     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_ck_traffic_ovr_sel),    .o_q(ck_traffic_ovr_sel_sync));
   ddr_demet_r u_demet_5     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_ck_traffic_ovr),        .o_q(ck_traffic_ovr_sync));
   ddr_demet_r u_demet_6     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_ca_traffic_ovr_sel),    .o_q(ca_traffic_ovr_sel_sync));
   ddr_demet_r u_demet_7     (.i_clk(o_dfi_clk), .i_set(i_rst), .i_d(i_ca_traffic_ovr),        .o_q(ca_traffic_ovr_sync));

   ddr_pulse_extender #(.WIDTH(6)) u_dqs_wrclk_en_pulse_ext ( .i_clk(o_dfi_clk), .i_rst(i_rst), .i_d(i_dqs_wrclk_en), .i_num_pulses(i_dqs_wrclk_en_pulse_ext), .o_d (dqs_wrclk_en_extended));
   ddr_pulse_extender #(.WIDTH(6)) u_dq_wrclk_en_pulse_ext  ( .i_clk(o_dfi_clk), .i_rst(i_rst), .i_d(i_dq_wrclk_en),  .i_num_pulses(i_dq_wrclk_en_pulse_ext),  .o_d (dq_wrclk_en_extended));
   ddr_pulse_extender #(.WIDTH(6)) u_ck_clk_en_pulse_ext    ( .i_clk(o_dfi_clk), .i_rst(i_rst), .i_d(i_ck_clk_en),    .i_num_pulses(i_ck_clk_en_pulse_ext),    .o_d (ck_clk_en_extended));
   ddr_pulse_extender #(.WIDTH(6)) u_ca_clk_en_pulse_ext    ( .i_clk(o_dfi_clk), .i_rst(i_rst), .i_d(i_ca_clk_en),    .i_num_pulses(i_ca_clk_en_pulse_ext),    .o_d (ca_clk_en_extended));

   assign o_dqs_wrtraffic = dqs_wrtraffic_ovr_sel_sync ? dqs_wrtraffic_ovr_sync : dqs_wrclk_en_extended ;
   assign o_dq_wrtraffic  = dq_wrtraffic_ovr_sel_sync  ? dq_wrtraffic_ovr_sync  : dq_wrclk_en_extended ;
   assign o_ck_traffic    = ck_traffic_ovr_sel_sync    ? ck_traffic_ovr_sync    : ck_clk_en_extended ;
   assign o_ca_traffic    = ca_traffic_ovr_sel_sync    ? ca_traffic_ovr_sync    : ca_clk_en_extended ;

   assign o_dfi_clk    = i_wr_clk_2 ;

   ddr_cgc_rl u_wrc_clk_0_cgc_rl   (.i_clk(i_phy_clk),   .i_clk_en(o_dqs_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrc_clk_0));
   ddr_cgc_rl u_wrc_clk_1_cgc_rl   (.i_clk(i_wr_clk_1),  .i_clk_en(o_dqs_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrc_clk_1));
   ddr_cgc_rl u_wrc_clk_2_cgc_rl   (.i_clk(i_wr_clk_2),  .i_clk_en(o_dqs_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrc_clk_2));

   ddr_cgc_rl u_wrd_clk_0_cgc_rl   (.i_clk(i_phy_clk),   .i_clk_en(o_dq_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrd_clk_0));
   ddr_cgc_rl u_wrd_clk_1_cgc_rl   (.i_clk(i_wr_clk_1),  .i_clk_en(o_dq_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrd_clk_1));
   ddr_cgc_rl u_wrd_clk_2_cgc_rl   (.i_clk(i_wr_clk_2),  .i_clk_en(o_dq_wrtraffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_wrd_clk_2));

   ddr_cgc_rl u_ck_clk_0_cgc_rl   (.i_clk(i_phy_clk),   .i_clk_en(o_ck_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmdc_clk_0));
   ddr_cgc_rl u_ck_clk_1_cgc_rl   (.i_clk(i_wr_clk_1),  .i_clk_en(o_ck_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmdc_clk_1));
   ddr_cgc_rl u_ck_clk_2_cgc_rl   (.i_clk(i_wr_clk_2),  .i_clk_en(o_ck_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmdc_clk_2));

   ddr_cgc_rl u_ca_clk_0_cgc_rl   (.i_clk(i_phy_clk),   .i_clk_en(o_ca_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmda_clk_0));
   ddr_cgc_rl u_ca_clk_1_cgc_rl   (.i_clk(i_wr_clk_1),  .i_clk_en(o_ca_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmda_clk_1));
   ddr_cgc_rl u_ca_clk_2_cgc_rl   (.i_clk(i_wr_clk_2),  .i_clk_en(o_ca_traffic), .i_cgc_en(i_scan_cgc_ctrl), .o_clk(o_cmda_clk_2));

   always_comb begin
      o_dfiwrgb_mode = '0 ;
      case(i_wrgb_mode)
         DFIWGB_32TO16 : o_dfiwrgb_mode[8] = 1'b1 ;
         DFIWGB_32TO8  : o_dfiwrgb_mode[7]  = 1'b1 ;
         DFIWGB_16TO8  : o_dfiwrgb_mode[6]  = 1'b1 ;
         DFIWGB_8TO8   : o_dfiwrgb_mode[5]   = 1'b1 ;
         DFIWGB_8TO4   : o_dfiwrgb_mode[4]   = 1'b1 ;
         DFIWGB_8TO2   : o_dfiwrgb_mode[3]   = 1'b1 ;
         DFIWGB_4TO4   : o_dfiwrgb_mode[2]   = 1'b1 ;
         DFIWGB_4TO2   : o_dfiwrgb_mode[1]   = 1'b1 ;
         DFIWGB_2TO2   : o_dfiwrgb_mode[0]   = 1'b1 ;
         default       : o_dfiwrgb_mode[0]   = 1'b1 ;
      endcase
   end

   always_comb begin
      o_dfirdgb_mode = '0 ;
      case(i_rdgb_mode)
         DFIRGB_16TO32 : o_dfirdgb_mode[9] = 1'b1 ;
         DFIRGB_8TO32  : o_dfirdgb_mode[8]  = 1'b1 ;
         DFIRGB_8TO16  : o_dfirdgb_mode[7]  = 1'b1 ;
         DFIRGB_8TO8   : o_dfirdgb_mode[6]   = 1'b1 ;
         DFIRGB_4TO8   : o_dfirdgb_mode[5]   = 1'b1 ;
         DFIRGB_4TO4   : o_dfirdgb_mode[4]   = 1'b1 ;
         DFIRGB_2TO8   : o_dfirdgb_mode[3]   = 1'b1 ;
         DFIRGB_2TO4   : o_dfirdgb_mode[2]   = 1'b1 ;
         DFIRGB_2TO2   : o_dfirdgb_mode[1]   = 1'b1 ;
         DFIRGB_1TO1   : o_dfirdgb_mode[0]   = 1'b1 ;
         default       : o_dfirdgb_mode[0]   = 1'b1 ;
      endcase
   end
endmodule