`include "ddr_global_define.vh"
`include "ddr_project_define.vh"
 
module d2d_ahb_ic_model #(
   parameter                            AWIDTH   = 32,
   parameter                            DWIDTH   = 32
) (

   input  logic                         i_hclk,
   input  logic                         i_hrst,

   // from ext AHB mater
   input  logic [AWIDTH-1:0]            i_ext_ahbm_haddr,
   input  logic                         i_ext_ahbm_hwrite,
   input  logic [31:0]                  i_ext_ahbm_hwdata,
   input  logic [1:0]                   i_ext_ahbm_htrans,
   input  logic [2:0]                   i_ext_ahbm_hsize,
   input  logic [2:0]                   i_ext_ahbm_hburst,
   input  logic                         i_ext_ahbm_hbusreq,
   output logic                         o_ext_ahbm_hgrant,
   output logic                         o_ext_ahbm_hready,
   output logic [DWIDTH-1:0]            o_ext_ahbm_hrdata,
   output logic [1:0]                   o_ext_ahbm_hresp,

   // from PHY0_M Port
   input  logic [AWIDTH-1:0]            i_phy0_ahbm_haddr,
   input  logic                         i_phy0_ahbm_hwrite,
   input  logic [31:0]                  i_phy0_ahbm_hwdata,
   input  logic [1:0]                   i_phy0_ahbm_htrans,
   input  logic [2:0]                   i_phy0_ahbm_hsize,
   input  logic [2:0]                   i_phy0_ahbm_hburst,
   input  logic                         i_phy0_ahbm_hbusreq,
   output logic                         o_phy0_ahbm_hready,
   output logic [DWIDTH-1:0]            o_phy0_ahbm_hrdata,
   output logic [1:0]                   o_phy0_ahbm_hresp,
   output logic                         o_phy0_ahbm_hgrant,

   // from PHY1_M Port
   input  logic [AWIDTH-1:0]            i_phy1_ahbm_haddr,
   input  logic                         i_phy1_ahbm_hwrite,
   input  logic                         i_phy1_ahbm_hbusreq,
   input  logic [31:0]                  i_phy1_ahbm_hwdata,
   input  logic [1:0]                   i_phy1_ahbm_htrans,
   input  logic [2:0]                   i_phy1_ahbm_hsize,
   input  logic [2:0]                   i_phy1_ahbm_hburst,
   output logic                         o_phy1_ahbm_hready,
   output logic [DWIDTH-1:0]            o_phy1_ahbm_hrdata,
   output logic [1:0]                   o_phy1_ahbm_hresp,
   output logic                         o_phy1_ahbm_hgrant,

   // from PHY2_M Port
   input  logic [AWIDTH-1:0]            i_phy2_ahbm_haddr,
   input  logic                         i_phy2_ahbm_hwrite,
   input  logic                         i_phy2_ahbm_hbusreq,
   input  logic [31:0]                  i_phy2_ahbm_hwdata,
   input  logic [1:0]                   i_phy2_ahbm_htrans,
   input  logic [2:0]                   i_phy2_ahbm_hsize,
   input  logic [2:0]                   i_phy2_ahbm_hburst,
   output logic                         o_phy2_ahbm_hready,
   output logic [DWIDTH-1:0]            o_phy2_ahbm_hrdata,
   output logic [1:0]                   o_phy2_ahbm_hresp,
   output logic                         o_phy2_ahbm_hgrant,

   // from PHY3_M Port
   input  logic [AWIDTH-1:0]            i_phy3_ahbm_haddr,
   input  logic                         i_phy3_ahbm_hwrite,
   input  logic                         i_phy3_ahbm_hbusreq,
   input  logic [31:0]                  i_phy3_ahbm_hwdata,
   input  logic [1:0]                   i_phy3_ahbm_htrans,
   input  logic [2:0]                   i_phy3_ahbm_hsize,
   input  logic [2:0]                   i_phy3_ahbm_hburst,
   output logic                         o_phy3_ahbm_hready,
   output logic [DWIDTH-1:0]            o_phy3_ahbm_hrdata,
   output logic [1:0]                   o_phy3_ahbm_hresp,
   output logic                         o_phy3_ahbm_hgrant,

   //to PHY0_S Port
   output logic [AWIDTH-1:0]            o_phy0_ahbs_haddr,
   output logic                         o_phy0_ahbs_hwrite,
   output logic                         o_phy0_ahbs_hsel,
   output logic                         o_phy0_ahbs_hreadyin,
   output logic [DWIDTH-1:0]            o_phy0_ahbs_hwdata,
   output logic [1:0]                   o_phy0_ahbs_htrans,
   output logic [2:0]                   o_phy0_ahbs_hsize,
   output logic [2:0]                   o_phy0_ahbs_hburst,
   input  logic                         i_phy0_ahbs_hready,
   input  logic [DWIDTH-1:0]            i_phy0_ahbs_hrdata,
   input  logic [1:0]                   i_phy0_ahbs_hresp,

   //to PHY1_S Port
   output logic [AWIDTH-1:0]            o_phy1_ahbs_haddr,
   output logic                         o_phy1_ahbs_hwrite,
   output logic                         o_phy1_ahbs_hsel,
   output logic                         o_phy1_ahbs_hreadyin,
   output logic [DWIDTH-1:0]            o_phy1_ahbs_hwdata,
   output logic [1:0]                   o_phy1_ahbs_htrans,
   output logic [2:0]                   o_phy1_ahbs_hsize,
   output logic [2:0]                   o_phy1_ahbs_hburst,
   input  logic                         i_phy1_ahbs_hready,
   input  logic [DWIDTH-1:0]            i_phy1_ahbs_hrdata,
   input  logic [1:0]                   i_phy1_ahbs_hresp,

   //to PHY2_S Port
   output logic [AWIDTH-1:0]            o_phy2_ahbs_haddr,
   output logic                         o_phy2_ahbs_hwrite,
   output logic                         o_phy2_ahbs_hsel,
   output logic                         o_phy2_ahbs_hreadyin,
   output logic [DWIDTH-1:0]            o_phy2_ahbs_hwdata,
   output logic [1:0]                   o_phy2_ahbs_htrans,
   output logic [2:0]                   o_phy2_ahbs_hsize,
   output logic [2:0]                   o_phy2_ahbs_hburst,
   input  logic                         i_phy2_ahbs_hready,
   input  logic [DWIDTH-1:0]            i_phy2_ahbs_hrdata,
   input  logic [1:0]                   i_phy2_ahbs_hresp,

   //to PHY3_S Port
   output logic [AWIDTH-1:0]            o_phy3_ahbs_haddr,
   output logic                         o_phy3_ahbs_hwrite,
   output logic                         o_phy3_ahbs_hsel,
   output logic                         o_phy3_ahbs_hreadyin,
   output logic [DWIDTH-1:0]            o_phy3_ahbs_hwdata,
   output logic [1:0]                   o_phy3_ahbs_htrans,
   output logic [2:0]                   o_phy3_ahbs_hsize,
   output logic [2:0]                   o_phy3_ahbs_hburst,
   input  logic                         i_phy3_ahbs_hready,
   input  logic [DWIDTH-1:0]            i_phy3_ahbs_hrdata,
   input  logic [1:0]                   i_phy3_ahbs_hresp
);
   logic                               intf_ahbm_hgrant;
   logic [AWIDTH-1:0]                  intf_ahbm_haddr;
   logic                               intf_ahbm_hwrite;
   logic                               intf_ahbm_hbusreq;
   logic [DWIDTH-1:0]                  intf_ahbm_hwdata;
   logic [1:0]                         intf_ahbm_htrans;
   logic [2:0]                         intf_ahbm_hsize;
   logic [2:0]                         intf_ahbm_hburst;
   logic                               intf_ahbm_hready;
   logic [DWIDTH-1:0]                  intf_ahbm_hrdata;
   logic [1:0]                         intf_ahbm_hresp;

  //-----------------------------------------------------------
  // AHB Master Mux
  //------------------------------------------------------------
   localparam NUM_MSTR = 5;

   logic [32*NUM_MSTR-1:0] ahbm_hwdata;
   logic [32*NUM_MSTR-1:0] ahbm_haddr;
   logic [2*NUM_MSTR-1:0]  ahbm_htrans;
   logic [3*NUM_MSTR-1:0]  ahbm_hsize;
   logic [3*NUM_MSTR-1:0]  ahbm_hburst;
   logic [NUM_MSTR-1:0]    ahbm_hwrite;
   logic [NUM_MSTR-1:0]    ahbm_hbusreq;
   logic [NUM_MSTR-1:0]    ahbm_hgrant;
   logic [NUM_MSTR-1:0]    ahbm_hready;
   logic [2*NUM_MSTR-1:0]  ahbm_hresp;
   logic [32*NUM_MSTR-1:0] ahbm_hrdata;

   logic [AWIDTH-1:0]      phy_ahbs_haddr;
   logic                   phy_ahbs_hwrite;
   logic                   phy_ahbs_hsel;
   logic [31:0]            phy_ahbs_hwdata;
   logic [1:0]             phy_ahbs_htrans;
   logic [2:0]             phy_ahbs_hsize;
   logic [2:0]             phy_ahbs_hburst;
   logic                   phy_ahbs_hready;
   logic [DWIDTH-1:0]      phy_ahbs_hrdata;
   logic [1:0]             phy_ahbs_hresp;

   assign ahbm_haddr   = {i_ext_ahbm_haddr  , i_phy0_ahbm_haddr , i_phy1_ahbm_haddr , i_phy2_ahbm_haddr , i_phy3_ahbm_haddr};
   assign ahbm_hbusreq = {i_ext_ahbm_hbusreq  , i_phy0_ahbm_hbusreq , i_phy1_ahbm_hbusreq , i_phy2_ahbm_hbusreq , i_phy3_ahbm_hbusreq};
   assign ahbm_hwrite  = {i_ext_ahbm_hwrite  , i_phy0_ahbm_hwrite , i_phy1_ahbm_hwrite , i_phy2_ahbm_hwrite , i_phy3_ahbm_hwrite};
   assign ahbm_hwdata  = {i_ext_ahbm_hwdata  , i_phy0_ahbm_hwdata , i_phy1_ahbm_hwdata , i_phy2_ahbm_hwdata , i_phy3_ahbm_hwdata};
   assign ahbm_htrans  = {i_ext_ahbm_htrans  , i_phy0_ahbm_htrans , i_phy1_ahbm_htrans , i_phy2_ahbm_htrans , i_phy3_ahbm_htrans};
   assign ahbm_hsize   = {i_ext_ahbm_hsize  , i_phy0_ahbm_hsize , i_phy1_ahbm_hsize , i_phy2_ahbm_hsize , i_phy3_ahbm_hsize};
   assign ahbm_hburst  = {i_ext_ahbm_hburst  , i_phy0_ahbm_hburst , i_phy1_ahbm_hburst , i_phy2_ahbm_hburst , i_phy3_ahbm_hburst};

   assign {o_ext_ahbm_hgrant  , o_phy0_ahbm_hgrant , o_phy1_ahbm_hgrant , o_phy2_ahbm_hgrant , o_phy3_ahbm_hgrant} = ahbm_hgrant;
   assign {o_ext_ahbm_hready  , o_phy0_ahbm_hready , o_phy1_ahbm_hready , o_phy2_ahbm_hready , o_phy3_ahbm_hready}  = ahbm_hready;
   assign {o_ext_ahbm_hrdata  , o_phy0_ahbm_hrdata , o_phy1_ahbm_hrdata , o_phy2_ahbm_hrdata , o_phy3_ahbm_hrdata}  = ahbm_hrdata;
   assign {o_ext_ahbm_hresp  , o_phy0_ahbm_hresp , o_phy1_ahbm_hresp , o_phy2_ahbm_hresp , o_phy3_ahbm_hresp}  = ahbm_hresp ;

   wav_ahb_master_arbiter_mux #(
      .AWIDTH            (AWIDTH),
      .DWIDTH            (32),
      .NUM_MSTR          (NUM_MSTR)
   ) u_ahbm_arbiter_mux (
      .i_hclk            (i_hclk),
      .i_hreset          (i_hrst),

      .i_ahbm_haddr      (ahbm_haddr),
      .i_ahbm_hwrite     (ahbm_hwrite),
      .i_ahbm_hwdata     (ahbm_hwdata),
      .i_ahbm_htrans     (ahbm_htrans),
      .i_ahbm_hsize      (ahbm_hsize),
      .i_ahbm_hburst     (ahbm_hburst),
      .i_ahbm_hbusreq    (ahbm_hbusreq),
      .o_ahbm_hgrant     (ahbm_hgrant),
      .o_ahbm_hrdata     (ahbm_hrdata),
      .o_ahbm_hresp      (ahbm_hresp ),
      .o_ahbm_hready     (ahbm_hready),

      .o_ahbm_haddr      (phy_ahbs_haddr),
      .o_ahbm_hwrite     (phy_ahbs_hwrite),
      .o_ahbm_hwdata     (phy_ahbs_hwdata),
      .o_ahbm_htrans     (phy_ahbs_htrans),
      .o_ahbm_hsize      (phy_ahbs_hsize),
      .o_ahbm_hburst     (phy_ahbs_hburst),
      .o_ahbm_hbusreq    (phy_ahbs_hsel),
      .i_ahbm_hready     (phy_ahbs_hready),
      .i_ahbm_hrdata     (phy_ahbs_hrdata),
      .i_ahbm_hresp      (phy_ahbs_hresp),
      .o_ahbm_hmaster    (/*OPEN*/),
      .o_ahbm_hmastlock  (/*OPEN*/)
   );

  //--------------------------------------------------------------
  //AHB Slave Mux
  //--------------------------------------------------------------
   localparam NUM_PHY_SLVS    = 5;
   localparam PHY_SWIDTH      = $clog2(NUM_PHY_SLVS)+'b1;

   localparam PHY0_IDX  = 0  ;
   localparam PHY1_IDX  = 1  ;
   localparam PHY2_IDX  = 2  ;
   localparam PHY3_IDX  = 3  ;
   localparam DEFAULT_SLV_IDX = 4 ;

   logic [AWIDTH-1:0]                 phy_ahbs_haddr_offset;
   logic [AWIDTH-1:0]                 phy_ahbs_haddr_local;

   logic [AWIDTH*NUM_PHY_SLVS-1:0]    phy_slv_mux_haddr ;
   logic [NUM_PHY_SLVS-1:0]           phy_slv_mux_hwrite;
   logic [NUM_PHY_SLVS-1:0]           phy_slv_mux_hsel  ;
   logic [NUM_PHY_SLVS-1:0]           phy_slv_mux_hreadyin ;
   logic [DWIDTH*NUM_PHY_SLVS-1:0]    phy_slv_mux_hwdata;
   logic [2*NUM_PHY_SLVS-1:0]         phy_slv_mux_htrans;
   logic [3*NUM_PHY_SLVS-1:0]         phy_slv_mux_hsize ;
   logic [3*NUM_PHY_SLVS-1:0]         phy_slv_mux_hburst;
   logic [NUM_PHY_SLVS-1:0]           phy_slv_mux_hready;
   logic [DWIDTH*NUM_PHY_SLVS-1:0]    phy_slv_mux_hrdata;
   logic [2*NUM_PHY_SLVS-1:0]         phy_slv_mux_hresp ;
   logic [PHY_SWIDTH-1:0]             phy_slv_sel ;


   logic [AWIDTH-1:0]                 default_ahbs_haddr;
   logic                              default_ahbs_hwrite;
   logic                              default_ahbs_hsel;
   logic [DWIDTH-1:0]                 default_ahbs_hwdata;
   logic [1:0]                        default_ahbs_htrans;
   logic [2:0]                        default_ahbs_hsize;
   logic [2:0]                        default_ahbs_hburst;
   logic                              default_ahbs_hready;
   logic [DWIDTH-1:0]                 default_ahbs_hrdata;
   logic [1:0]                        default_ahbs_hresp;

   assign o_phy0_ahbs_haddr    =  phy_slv_mux_haddr   [PHY0_IDX*AWIDTH+:AWIDTH];
   assign o_phy0_ahbs_hwrite   =  phy_slv_mux_hwrite  [PHY0_IDX];
   assign o_phy0_ahbs_hsel     =  phy_slv_mux_hsel    [PHY0_IDX];
   assign o_phy0_ahbs_hreadyin =  phy_slv_mux_hreadyin[PHY0_IDX];
   assign o_phy0_ahbs_hwdata   =  phy_slv_mux_hwdata  [PHY0_IDX*DWIDTH+:DWIDTH];
   assign o_phy0_ahbs_htrans   =  phy_slv_mux_htrans  [PHY0_IDX*2+:2];
   assign o_phy0_ahbs_hsize    =  phy_slv_mux_hsize   [PHY0_IDX*3+:3];
   assign o_phy0_ahbs_hburst   =  phy_slv_mux_hburst  [PHY0_IDX*3+:3];

   assign o_phy1_ahbs_haddr    =  phy_slv_mux_haddr   [PHY1_IDX*AWIDTH+:AWIDTH];
   assign o_phy1_ahbs_hwrite   =  phy_slv_mux_hwrite  [PHY1_IDX];
   assign o_phy1_ahbs_hsel     =  phy_slv_mux_hsel    [PHY1_IDX];
   assign o_phy1_ahbs_hreadyin =  phy_slv_mux_hreadyin[PHY1_IDX];
   assign o_phy1_ahbs_hwdata   =  phy_slv_mux_hwdata  [PHY1_IDX*DWIDTH+:DWIDTH];
   assign o_phy1_ahbs_htrans   =  phy_slv_mux_htrans  [PHY1_IDX*2+:2];
   assign o_phy1_ahbs_hsize    =  phy_slv_mux_hsize   [PHY1_IDX*3+:3];
   assign o_phy1_ahbs_hburst   =  phy_slv_mux_hburst  [PHY1_IDX*3+:3];

   assign o_phy2_ahbs_haddr    =  phy_slv_mux_haddr   [PHY2_IDX*AWIDTH+:AWIDTH];
   assign o_phy2_ahbs_hwrite   =  phy_slv_mux_hwrite  [PHY2_IDX];
   assign o_phy2_ahbs_hsel     =  phy_slv_mux_hsel    [PHY2_IDX];
   assign o_phy2_ahbs_hreadyin =  phy_slv_mux_hreadyin[PHY2_IDX];
   assign o_phy2_ahbs_hwdata   =  phy_slv_mux_hwdata  [PHY2_IDX*DWIDTH+:DWIDTH];
   assign o_phy2_ahbs_htrans   =  phy_slv_mux_htrans  [PHY2_IDX*2+:2];
   assign o_phy2_ahbs_hsize    =  phy_slv_mux_hsize   [PHY2_IDX*3+:3];
   assign o_phy2_ahbs_hburst   =  phy_slv_mux_hburst  [PHY2_IDX*3+:3];

   assign o_phy3_ahbs_haddr    =  phy_slv_mux_haddr   [PHY3_IDX*AWIDTH+:AWIDTH];
   assign o_phy3_ahbs_hwrite   =  phy_slv_mux_hwrite  [PHY3_IDX];
   assign o_phy3_ahbs_hsel     =  phy_slv_mux_hsel    [PHY3_IDX];
   assign o_phy3_ahbs_hreadyin =  phy_slv_mux_hreadyin[PHY3_IDX];
   assign o_phy3_ahbs_hwdata   =  phy_slv_mux_hwdata  [PHY3_IDX*DWIDTH+:DWIDTH];
   assign o_phy3_ahbs_htrans   =  phy_slv_mux_htrans  [PHY3_IDX*2+:2];
   assign o_phy3_ahbs_hsize    =  phy_slv_mux_hsize   [PHY3_IDX*3+:3];
   assign o_phy3_ahbs_hburst   =  phy_slv_mux_hburst  [PHY3_IDX*3+:3];

   assign default_ahbs_haddr      =  phy_slv_mux_haddr   [DEFAULT_SLV_IDX*AWIDTH+:AWIDTH];
   assign default_ahbs_hwrite     =  phy_slv_mux_hwrite  [DEFAULT_SLV_IDX];
   assign default_ahbs_hsel       =  phy_slv_mux_hsel    [DEFAULT_SLV_IDX];
   assign default_ahbs_hreadyin   =  phy_slv_mux_hreadyin[DEFAULT_SLV_IDX];
   assign default_ahbs_hwdata     =  phy_slv_mux_hwdata  [DEFAULT_SLV_IDX*DWIDTH+:DWIDTH];
   assign default_ahbs_htrans     =  phy_slv_mux_htrans  [DEFAULT_SLV_IDX*2+:2];
   assign default_ahbs_hsize      =  phy_slv_mux_hsize   [DEFAULT_SLV_IDX*3+:3];
   assign default_ahbs_hburst     =  phy_slv_mux_hburst  [DEFAULT_SLV_IDX*3+:3];

   assign phy_slv_mux_hready[PHY0_IDX]                 = i_phy0_ahbs_hready;
   assign phy_slv_mux_hrdata[PHY0_IDX*DWIDTH+:DWIDTH]  = i_phy0_ahbs_hrdata;
   assign phy_slv_mux_hresp [PHY0_IDX*2+:2]            = i_phy0_ahbs_hresp ;

   assign phy_slv_mux_hready[PHY1_IDX]                 = i_phy1_ahbs_hready;
   assign phy_slv_mux_hrdata[PHY1_IDX*DWIDTH+:DWIDTH]  = i_phy1_ahbs_hrdata;
   assign phy_slv_mux_hresp [PHY1_IDX*2+:2]            = i_phy1_ahbs_hresp ;

   assign phy_slv_mux_hready[PHY2_IDX]                 = i_phy2_ahbs_hready;
   assign phy_slv_mux_hrdata[PHY2_IDX*DWIDTH+:DWIDTH]  = i_phy2_ahbs_hrdata;
   assign phy_slv_mux_hresp [PHY2_IDX*2+:2]            = i_phy2_ahbs_hresp ;

   assign phy_slv_mux_hready[PHY3_IDX]                 = i_phy3_ahbs_hready;
   assign phy_slv_mux_hrdata[PHY3_IDX*DWIDTH+:DWIDTH]  = i_phy3_ahbs_hrdata;
   assign phy_slv_mux_hresp [PHY3_IDX*2+:2]            = i_phy3_ahbs_hresp ;


   assign phy_slv_mux_hready[DEFAULT_SLV_IDX]                = default_ahbs_hready;
   assign phy_slv_mux_hrdata[DEFAULT_SLV_IDX*DWIDTH+:DWIDTH] = default_ahbs_hrdata;
   assign phy_slv_mux_hresp [DEFAULT_SLV_IDX*2+:2]           = default_ahbs_hresp ;

   //Slave sel and slave decode
   assign phy_slv_sel = ((phy_ahbs_haddr >= 32'h01000000 ) & (phy_ahbs_haddr < 32'h01200000    )) ? ('b1+PHY0_IDX) :
                        ((phy_ahbs_haddr >= 32'h01200000 ) & (phy_ahbs_haddr < 32'h01400000    )) ? ('b1+PHY1_IDX ) :
                        ((phy_ahbs_haddr >= 32'h01400000 ) & (phy_ahbs_haddr < 32'h01600000    )) ? ('b1+PHY2_IDX ) :
                        ((phy_ahbs_haddr >= 32'h01600000 ) & (phy_ahbs_haddr < 32'h01800000    )) ? ('b1+PHY3_IDX ) :
                        ('b1+DEFAULT_SLV_IDX) ;

   assign phy_ahbs_haddr_offset = (phy_slv_sel == ('b1+PHY0_IDX  )) ? 32'h01000000  :
                                  (phy_slv_sel == ('b1+PHY1_IDX  )) ? 32'h01200000  :
                                  (phy_slv_sel == ('b1+PHY2_IDX  )) ? 32'h01400000  :
                                  (phy_slv_sel == ('b1+PHY3_IDX  )) ? 32'h01600000  :
                                  '0;

   assign phy_ahbs_haddr_local  = phy_ahbs_haddr - phy_ahbs_haddr_offset;

   wav_ahb_slave_mux #(
      .DWIDTH           (32),
      .AWIDTH           (32),
      .NUM_SLV          (NUM_PHY_SLVS)
   ) u_phy_slv_mux (

      .i_hclk           (i_hclk),
      .i_hreset         (i_hrst),

      .i_slv_sel        (phy_slv_sel),
      .i_hbusreq        (phy_ahbs_hsel),
      .i_hreadyin       (1'b1),
      .i_haddr          (phy_ahbs_haddr_local),
      .i_hwrite         (phy_ahbs_hwrite),
      .i_hwdata         (phy_ahbs_hwdata),
      .i_htrans         (phy_ahbs_htrans),
      .i_hsize          (phy_ahbs_hsize ),
      .i_hburst         (phy_ahbs_hburst),
      .o_hready         (phy_ahbs_hready),
      .o_hrdata         (phy_ahbs_hrdata),
      .o_hresp          (phy_ahbs_hresp ),

      .o_haddr          (phy_slv_mux_haddr ),
      .o_hreadyin       (phy_slv_mux_hreadyin),
      .o_hwrite         (phy_slv_mux_hwrite),
      .o_hsel           (phy_slv_mux_hsel  ),
      .o_hwdata         (phy_slv_mux_hwdata),
      .o_htrans         (phy_slv_mux_htrans),
      .o_hsize          (phy_slv_mux_hsize ),
      .o_hburst         (phy_slv_mux_hburst),
      .i_hready         (phy_slv_mux_hready),
      .i_hrdata         (phy_slv_mux_hrdata),
      .i_hresp          (phy_slv_mux_hresp )
   );

   wav_default_ahb_slave u_default_ahb_slave (
      .i_hclk           (i_hclk),
      .i_hreset         (i_hrst),
      .i_haddr          (default_ahbs_haddr),
      .i_hwrite         (default_ahbs_hwrite),
      .i_hsel           (default_ahbs_hsel),
      .i_hreadyin       (default_ahbs_hreadyin),
      .i_hwdata         (default_ahbs_hwdata),
      .i_htrans         (default_ahbs_htrans),
      .i_hsize          (default_ahbs_hsize),
      .i_hburst         (default_ahbs_hburst),
      .o_hready         (default_ahbs_hready),
      .o_hrdata         (default_ahbs_hrdata),
      .o_hresp          (default_ahbs_hresp)
   );
endmodule