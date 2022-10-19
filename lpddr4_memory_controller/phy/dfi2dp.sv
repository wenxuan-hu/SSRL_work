module dfi2dp (
   input  logic                      i_dfi_cke_p0,
   input  logic                      i_dfi_cke_p1,
   input  logic                      i_dfi_cke_p2,
   input  logic                      i_dfi_cke_p3,
   input  logic                      i_dfi_cke_p4,
   input  logic                      i_dfi_cke_p5,
   input  logic                      i_dfi_cke_p6,
   input  logic                      i_dfi_cke_p7,
   input  logic                      i_dfi_cs_p0,
   input  logic                      i_dfi_cs_p1,
   input  logic                      i_dfi_cs_p2,
   input  logic                      i_dfi_cs_p3,
   input  logic                      i_dfi_cs_p4,
   input  logic                      i_dfi_cs_p5,
   input  logic                      i_dfi_cs_p6,
   input  logic                      i_dfi_cs_p7,
   input  logic [5:0]                i_dfi_ca_p0,
   input  logic [5:0]                i_dfi_ca_p1,
   input  logic [5:0]                i_dfi_ca_p2,
   input  logic [5:0]                i_dfi_ca_p3,
   input  logic [5:0]                i_dfi_ca_p4,
   input  logic [5:0]                i_dfi_ca_p5,
   input  logic [5:0]                i_dfi_ca_p6,
   input  logic [5:0]                i_dfi_ca_p7,
   input  logic [7:0]                i_dq0_dfi_wrdata_p0,
   input  logic [7:0]                i_dq0_dfi_wrdata_p1,
   input  logic [7:0]                i_dq0_dfi_wrdata_p2,
   input  logic [7:0]                i_dq0_dfi_wrdata_p3,
   input  logic [7:0]                i_dq0_dfi_wrdata_p4,
   input  logic [7:0]                i_dq0_dfi_wrdata_p5,
   input  logic [7:0]                i_dq0_dfi_wrdata_p6,
   input  logic [7:0]                i_dq0_dfi_wrdata_p7,
   input  logic                      i_dq0_dfi_wrdata_mask_p0,
   input  logic                      i_dq0_dfi_wrdata_mask_p1,
   input  logic                      i_dq0_dfi_wrdata_mask_p2,
   input  logic                      i_dq0_dfi_wrdata_mask_p3,
   input  logic                      i_dq0_dfi_wrdata_mask_p4,
   input  logic                      i_dq0_dfi_wrdata_mask_p5,
   input  logic                      i_dq0_dfi_wrdata_mask_p6,
   input  logic                      i_dq0_dfi_wrdata_mask_p7,
   input  logic                      i_dq0_dfi_rddata_en_p0,
   input  logic                      i_dq0_dfi_rddata_en_p1,
   input  logic                      i_dq0_dfi_rddata_en_p2,
   input  logic                      i_dq0_dfi_rddata_en_p3,
   input  logic                      i_dq0_dfi_rddata_en_p4,
   input  logic                      i_dq0_dfi_rddata_en_p5,
   input  logic                      i_dq0_dfi_rddata_en_p6,
   input  logic                      i_dq0_dfi_rddata_en_p7,
   output logic [7:0]                o_dq0_dfi_rddata_w0,
   output logic [7:0]                o_dq0_dfi_rddata_w1,
   output logic [7:0]                o_dq0_dfi_rddata_w2,
   output logic [7:0]                o_dq0_dfi_rddata_w3,
   output logic [7:0]                o_dq0_dfi_rddata_w4,
   output logic [7:0]                o_dq0_dfi_rddata_w5,
   output logic [7:0]                o_dq0_dfi_rddata_w6,
   output logic [7:0]                o_dq0_dfi_rddata_w7,
   output logic                      o_dq0_dfi_rddata_dbi_w0,
   output logic                      o_dq0_dfi_rddata_dbi_w1,
   output logic                      o_dq0_dfi_rddata_dbi_w2,
   output logic                      o_dq0_dfi_rddata_dbi_w3,
   output logic                      o_dq0_dfi_rddata_dbi_w4,
   output logic                      o_dq0_dfi_rddata_dbi_w5,
   output logic                      o_dq0_dfi_rddata_dbi_w6,
   output logic                      o_dq0_dfi_rddata_dbi_w7,
   output logic [7:0]                o_dq0_dfi_rddata_valid,
   input  logic [7:0]                i_dq1_dfi_wrdata_p0,
   input  logic [7:0]                i_dq1_dfi_wrdata_p1,
   input  logic [7:0]                i_dq1_dfi_wrdata_p2,
   input  logic [7:0]                i_dq1_dfi_wrdata_p3,
   input  logic [7:0]                i_dq1_dfi_wrdata_p4,
   input  logic [7:0]                i_dq1_dfi_wrdata_p5,
   input  logic [7:0]                i_dq1_dfi_wrdata_p6,
   input  logic [7:0]                i_dq1_dfi_wrdata_p7,
   input  logic                      i_dq1_dfi_wrdata_mask_p0,
   input  logic                      i_dq1_dfi_wrdata_mask_p1,
   input  logic                      i_dq1_dfi_wrdata_mask_p2,
   input  logic                      i_dq1_dfi_wrdata_mask_p3,
   input  logic                      i_dq1_dfi_wrdata_mask_p4,
   input  logic                      i_dq1_dfi_wrdata_mask_p5,
   input  logic                      i_dq1_dfi_wrdata_mask_p6,
   input  logic                      i_dq1_dfi_wrdata_mask_p7,
   input  logic                      i_dq1_dfi_rddata_en_p0,
   input  logic                      i_dq1_dfi_rddata_en_p1,
   input  logic                      i_dq1_dfi_rddata_en_p2,
   input  logic                      i_dq1_dfi_rddata_en_p3,
   input  logic                      i_dq1_dfi_rddata_en_p4,
   input  logic                      i_dq1_dfi_rddata_en_p5,
   input  logic                      i_dq1_dfi_rddata_en_p6,
   input  logic                      i_dq1_dfi_rddata_en_p7,
   output logic [7:0]                o_dq1_dfi_rddata_w0,
   output logic [7:0]                o_dq1_dfi_rddata_w1,
   output logic [7:0]                o_dq1_dfi_rddata_w2,
   output logic [7:0]                o_dq1_dfi_rddata_w3,
   output logic [7:0]                o_dq1_dfi_rddata_w4,
   output logic [7:0]                o_dq1_dfi_rddata_w5,
   output logic [7:0]                o_dq1_dfi_rddata_w6,
   output logic [7:0]                o_dq1_dfi_rddata_w7,
   output logic                      o_dq1_dfi_rddata_dbi_w0,
   output logic                      o_dq1_dfi_rddata_dbi_w1,
   output logic                      o_dq1_dfi_rddata_dbi_w2,
   output logic                      o_dq1_dfi_rddata_dbi_w3,
   output logic                      o_dq1_dfi_rddata_dbi_w4,
   output logic                      o_dq1_dfi_rddata_dbi_w5,
   output logic                      o_dq1_dfi_rddata_dbi_w6,
   output logic                      o_dq1_dfi_rddata_dbi_w7,
   output logic [7:0]                o_dq1_dfi_rddata_valid,


    //DQS pattern
   input logic [7:0]                i_tx_dqs0_sdr,
   input logic [7:0]                i_tx_dqs1_sdr,
   //CK pattern
   input  logic [7:0]               i_tx_ck_sdr,
   // Internal (PHY) interface
   output logic [71:0]              o_dq0_sdr,
   input  logic [71:0]              i_dq0_sdr,
   input  logic [8:0]               i_dq0_sdr_vld,
   output logic [15:0]              o_dqs0_sdr,
   output logic [71:0]              o_dq1_sdr,
   input  logic [71:0]              i_dq1_sdr,
   input  logic [8:0]               i_dq1_sdr_vld,
   output logic [15:0]              o_dqs1_sdr,

   // External interface
   input  logic                     i_txrx_mode,
   input  logic [71:0]              i_tx0_sdr,
   input  logic [7:0]               i_tx_ck0_sdr,
   output logic [71:0]              o_rx0_sdr,
   output logic [8:0]               o_rx0_sdr_vld,
   input  logic [71:0]              i_tx1_sdr,
   input  logic [7:0]               i_tx_ck1_sdr,
   output logic [71:0]              o_rx1_sdr,
   output logic [8:0]               o_rx1_sdr_vld,

   output logic [63:0]     o_ca_sdr,
   output logic [7:0]      o_ck_sdr 

);

   // ------------------------------------------------------------------------
   // Datapath Bus Assignment
   // ------------------------------------------------------------------------

   logic [71:0]           tx_dq0_sdr;
   logic [71:0]           int_tx_dq0_sdr;
   logic [7:0] int_tx_dqs0_sdr;

   // DQ Transmitter
   assign tx_dq0_sdr = {
                    {i_dq0_dfi_wrdata_mask_p7,i_dq0_dfi_wrdata_p7},
                    {i_dq0_dfi_wrdata_mask_p6,i_dq0_dfi_wrdata_p6},
                    {i_dq0_dfi_wrdata_mask_p5,i_dq0_dfi_wrdata_p5},
                    {i_dq0_dfi_wrdata_mask_p4,i_dq0_dfi_wrdata_p4},
                    {i_dq0_dfi_wrdata_mask_p3,i_dq0_dfi_wrdata_p3},
                    {i_dq0_dfi_wrdata_mask_p2,i_dq0_dfi_wrdata_p2},
                    {i_dq0_dfi_wrdata_mask_p1,i_dq0_dfi_wrdata_p1},
                    {i_dq0_dfi_wrdata_mask_p0,i_dq0_dfi_wrdata_p0}
                   };

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   ddr_dp_pow2wop #(.WIDTH(9), .NUM_PH(8)) u_dq0_tx_pow2wop (.i_d(tx_dq0_sdr),.o_d(int_tx_dq0_sdr));

   // External vs DFI mode select
   assign o_dq0_sdr = i_txrx_mode ? i_tx0_sdr : int_tx_dq0_sdr;

   logic [71:0]          rx_dq0_sdr;

   // Convert to Phases-Of-Words (POW) format
   //    Wn[Pn...P0]...W0[Pn...P0] -> Pn[Wn...W0]...P0[Wn...W0]
   ddr_dp_wop2pow #(.WIDTH(9), .NUM_PH(8)) u_dq0_rx_wop2pow (.i_d(i_dq0_sdr),.o_d(rx_dq0_sdr));

   // Pass External data - no format change required
   assign o_rx0_sdr = i_dq0_sdr;

   // DQ Receiver
   assign {
           {o_dq0_dfi_rddata_dbi_w7,o_dq0_dfi_rddata_w7},
           {o_dq0_dfi_rddata_dbi_w6,o_dq0_dfi_rddata_w6},
           {o_dq0_dfi_rddata_dbi_w5,o_dq0_dfi_rddata_w5},
           {o_dq0_dfi_rddata_dbi_w4,o_dq0_dfi_rddata_w4},
           {o_dq0_dfi_rddata_dbi_w3,o_dq0_dfi_rddata_w3},
           {o_dq0_dfi_rddata_dbi_w2,o_dq0_dfi_rddata_w2},
           {o_dq0_dfi_rddata_dbi_w1,o_dq0_dfi_rddata_w1},
           {o_dq0_dfi_rddata_dbi_w0,o_dq0_dfi_rddata_w0}
          } = rx_dq0_sdr;

   assign o_dq0_dfi_rddata_valid = i_dq0_sdr_vld;

   // Pass Exteranl data - no format change required
   assign o_rx0_sdr_vld = i_dq0_sdr_vld;

   // DQS Transmitter

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   //ddr_dp_pow2wop #(.WIDTH(DQS_WIDTH), .NUM_PH(8)) u_dqs0_tx_pow2wop (.i_d(tx_dqs0_sdr),.o_d(int_tx_dqs0_sdr));
   assign int_tx_dqs0_sdr=i_tx_dqs0_sdr; 

   // External vs DFI mode select
   assign o_dqs0_sdr = i_txrx_mode ? i_tx_ck0_sdr : int_tx_dqs0_sdr;
   logic [71:0]           tx_dq1_sdr;
   logic [71:0]           int_tx_dq1_sdr;
   logic [7:0] int_tx_dqs1_sdr;

   // DQ Transmitter
   assign tx_dq1_sdr = {
                    {i_dq1_dfi_wrdata_mask_p7,i_dq1_dfi_wrdata_p7},
                    {i_dq1_dfi_wrdata_mask_p6,i_dq1_dfi_wrdata_p6},
                    {i_dq1_dfi_wrdata_mask_p5,i_dq1_dfi_wrdata_p5},
                    {i_dq1_dfi_wrdata_mask_p4,i_dq1_dfi_wrdata_p4},
                    {i_dq1_dfi_wrdata_mask_p3,i_dq1_dfi_wrdata_p3},
                    {i_dq1_dfi_wrdata_mask_p2,i_dq1_dfi_wrdata_p2},
                    {i_dq1_dfi_wrdata_mask_p1,i_dq1_dfi_wrdata_p1},
                    {i_dq1_dfi_wrdata_mask_p0,i_dq1_dfi_wrdata_p0}
                   };

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   ddr_dp_pow2wop #(.WIDTH(9), .NUM_PH(8)) u_dq1_tx_pow2wop (.i_d(tx_dq1_sdr),.o_d(int_tx_dq1_sdr));

   // External vs DFI mode select
   assign o_dq1_sdr = i_txrx_mode ? i_tx1_sdr : int_tx_dq1_sdr;

   logic [71:0]          rx_dq1_sdr;

   // Convert to Phases-Of-Words (POW) format
   //    Wn[Pn...P0]...W0[Pn...P0] -> Pn[Wn...W0]...P0[Wn...W0]
   ddr_dp_wop2pow #(.WIDTH(9), .NUM_PH(8)) u_dq1_rx_wop2pow (.i_d(i_dq1_sdr),.o_d(rx_dq1_sdr));

   // Pass External data - no format change required
   assign o_rx1_sdr = i_dq1_sdr;

   // DQ Receiver
   assign {
           {o_dq1_dfi_rddata_dbi_w7,o_dq1_dfi_rddata_w7},
           {o_dq1_dfi_rddata_dbi_w6,o_dq1_dfi_rddata_w6},
           {o_dq1_dfi_rddata_dbi_w5,o_dq1_dfi_rddata_w5},
           {o_dq1_dfi_rddata_dbi_w4,o_dq1_dfi_rddata_w4},
           {o_dq1_dfi_rddata_dbi_w3,o_dq1_dfi_rddata_w3},
           {o_dq1_dfi_rddata_dbi_w2,o_dq1_dfi_rddata_w2},
           {o_dq1_dfi_rddata_dbi_w1,o_dq1_dfi_rddata_w1},
           {o_dq1_dfi_rddata_dbi_w0,o_dq1_dfi_rddata_w0}
          } = rx_dq1_sdr;

   assign o_dq1_dfi_rddata_valid = i_dq1_sdr_vld;

   // Pass Exteranl data - no format change required
   assign o_rx1_sdr_vld = i_dq1_sdr_vld;

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   //ddr_dp_pow2wop #(.WIDTH(DQS_WIDTH), .NUM_PH(8)) u_dqs1_tx_pow2wop (.i_d(tx_dqs1_sdr),.o_d(int_tx_dqs1_sdr));
   assign int_tx_dqs1_sdr=i_tx_dqs1_sdr;
   // External vs DFI mode select
   assign o_dqs1_sdr = i_txrx_mode ? i_tx_ck1_sdr : int_tx_dqs1_sdr;

   logic [63:0] tx_ca_sdr;

   // CA Transmitter
   assign tx_ca_sdr = {
                       {i_dfi_cke_p7, i_dfi_cs_p7, i_dfi_ca_p7},
                       {i_dfi_cke_p6, i_dfi_cs_p6, i_dfi_ca_p6},
                       {i_dfi_cke_p5, i_dfi_cs_p5, i_dfi_ca_p5},
                       {i_dfi_cke_p4, i_dfi_cs_p4, i_dfi_ca_p4},
                       {i_dfi_cke_p3, i_dfi_cs_p3, i_dfi_ca_p3},
                       {i_dfi_cke_p2, i_dfi_cs_p2, i_dfi_ca_p2},
                       {i_dfi_cke_p1, i_dfi_cs_p1, i_dfi_ca_p1},
                       {i_dfi_cke_p0, i_dfi_cs_p0, i_dfi_ca_p0}
                      };

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   ddr_dp_pow2wop #(.WIDTH(8), .NUM_PH(8)) u_ca_tx_pow2wop (.i_d(tx_ca_sdr),.o_d(o_ca_sdr));

   // Convert to Words-Of-Phases (WOP) format
   //    Pn[Wn...W0]...P0[Wn...W0] -> Wn[Pn...P0]...W0[Pn...P0]
   //ddr_dp_pow2wop #(.WIDTH(CK_WIDTH), .NUM_PH(8)) u_ck_tx_pow2wop (.i_d(tx_ck_sdr),.o_d(o_ck_sdr));
    assign o_ck_sdr=i_tx_ck_sdr;
endmodule