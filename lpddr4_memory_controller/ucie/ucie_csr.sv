
module ucie_csr #(
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
//CSR
output logic o_ucie_rxfifo_write,
output logic o_ucie_mode_en,
    output logic o_rxfifo_clr,
    output logic [3:0] o_txrx_mode, // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    output  logic                     o_buf_mode,
    output logic                     o_pam4_en,
    output logic [7:0]               o_pam4_cfg,
   output  logic                     o_buf_clk_en,
   output  logic                     o_intf_pipe_en,
   output  logic                     o_ts_enable,
   output  logic                     o_ts_reset,
   output  logic                     o_ts_brkpt_en,
   output  logic [15:0]              o_ts_brkpt_val,

   output  logic                     o_ig_loop_mode,
   output  logic [3:0]               o_ig_num_loops,
   output  logic                     o_ig_load_ptr,
   output  logic [4:0]               o_ig_stop_ptr,
   output  logic [4:0]               o_ig_start_ptr,
   output  logic                     o_ig_wdata_clr,
   output  logic                     o_ig_wdata_hold,
   output  logic                     o_ig_wdata_en,
   output  logic                     o_ig_wdata_upd,
   output  logic [31:0]              o_ig_wdata,
   input logic                     i_ig_empty,
   input logic                     i_ig_write_done,
   input logic                     i_ig_full,
   input logic                     i_ig_overflow,

   output  logic                     o_eg_rdata_clr,
   output  logic                     o_eg_rdata_en,
   output  logic                     o_eg_rdata_upd,
   input logic [31:0]              i_eg_rdata,
   input logic                     i_eg_empty,
   input logic                     i_eg_read_done,
   input logic                     i_eg_full,
   input logic                     i_eg_overflow,
   input logic [31:0]              i_debug
);

   typedef enum logic [5:0] {
      DECODE_UCIE_TOP_0_CFG,
      DECODE_UCIE_DEBUG_STA,
      DECODE_UCIE_TS_CFG,
      DECODE_UCIE_IG_CTRL_CFG,
      DECODE_UCIE_IG_DATA_CFG,
      DECODE_UCIE_IG_STA,
      DECODE_UCIE_EG_CTRL_CFG,
      DECODE_UCIE_EG_STA,
      DECODE_UCIE_EG_DATA_STA,
      DECODE_UCIE_PAM4_CFG,
      DECODE_NOOP
   } DECODE_T;

   DECODE_T decode;

   assign o_ready = 1'b1;

   always_comb begin
      o_error = 1'b0;
      case (i_addr)
         32'h0: decode = DECODE_UCIE_TOP_0_CFG;
         32'h4:decode =DECODE_UCIE_DEBUG_STA;
         32'h8:decode =DECODE_UCIE_TS_CFG;
         32'hC:decode =DECODE_UCIE_IG_CTRL_CFG;
         32'h10:decode =DECODE_UCIE_IG_DATA_CFG;
         32'h14:decode =DECODE_UCIE_IG_STA;
         32'h18:decode =DECODE_UCIE_EG_CTRL_CFG;
         32'h1C:decode =DECODE_UCIE_EG_STA;
         32'h20:decode =DECODE_UCIE_EG_DATA_STA;
         32'h24:decode =DECODE_UCIE_PAM4_CFG;
         default : begin 
            decode = DECODE_NOOP;
            o_error = 1'b1;
         end
      endcase
   end

   logic [31:0] ucie_top_0_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_top_0_cfg_q <= 32'h00101000;
      else
         if (i_write)
            if (decode == DECODE_UCIE_TOP_0_CFG)
               ucie_top_0_cfg_q <= i_wdata;

   assign o_txrx_mode = ucie_top_0_cfg_q[3:0];
   assign o_rxfifo_clr = ucie_top_0_cfg_q[4];
   assign o_buf_mode = ucie_top_0_cfg_q[8];
   assign o_buf_clk_en = ucie_top_0_cfg_q[9];
   assign o_intf_pipe_en = ucie_top_0_cfg_q[12];
   assign o_ucie_mode_en = ucie_top_0_cfg_q[16];
   assign o_ucie_rxfifo_write = ucie_top_0_cfg_q[20];


   logic [31:0] debug_sta_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         debug_sta_q <= '0;
      else
         debug_sta_q <= i_debug;


   logic [31:0] ucie_ts_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_ts_cfg_q <= 32'h0;
      else
         if (i_write)
            if (decode == DECODE_UCIE_TS_CFG)
               ucie_ts_cfg_q <= i_wdata;

   assign o_ts_enable = ucie_ts_cfg_q[0];
   assign o_ts_reset = ucie_ts_cfg_q[4];
   assign o_ts_brkpt_en = ucie_ts_cfg_q[8];
   assign o_ts_brkpt_val= ucie_ts_cfg_q[31:16];

   logic [31:0] ucie_ig_ctrl_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_ig_ctrl_cfg_q <= 32'h0;
      else
         if (i_write)
            if (decode == DECODE_UCIE_IG_CTRL_CFG)
               ucie_ig_ctrl_cfg_q <= i_wdata;

   assign o_ig_loop_mode = ucie_ig_ctrl_cfg_q[0];
   assign o_ig_num_loops = ucie_ig_ctrl_cfg_q[7:4];
   assign o_ig_load_ptr = ucie_ig_ctrl_cfg_q[8];
   assign o_ig_stop_ptr= ucie_ig_ctrl_cfg_q[16:12];
   assign o_ig_start_ptr = ucie_ig_ctrl_cfg_q[24:20];
   assign o_ig_wdata_clr = ucie_ig_ctrl_cfg_q[28];
   assign o_ig_wdata_hold = ucie_ig_ctrl_cfg_q[29];
   assign o_ig_wdata_en = ucie_ig_ctrl_cfg_q[30];
   assign o_ig_wdata_upd = ucie_ig_ctrl_cfg_q[31];

   logic [31:0] ucie_ig_data_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_ig_data_cfg_q <= 32'h0;
      else
         if (i_write)
            if (decode == DECODE_UCIE_IG_DATA_CFG)
               ucie_ig_data_cfg_q <= i_wdata;

   assign o_ig_wdata = ucie_ig_data_cfg_q[31:0];

   logic [31:0] ig_sta_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ig_sta_q <= '0;
      else begin
         ig_sta_q[0] <= i_ig_empty;
         ig_sta_q[4] <= i_ig_write_done;
         ig_sta_q[8] <= i_ig_full;
         ig_sta_q[12] <= i_ig_overflow;
      end

   logic [31:0] ucie_eg_ctrl_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_eg_ctrl_cfg_q <= 32'h0;
      else
         if (i_write)
            if (decode == DECODE_UCIE_EG_CTRL_CFG)
               ucie_eg_ctrl_cfg_q <= i_wdata;

   assign o_eg_rdata_clr = ucie_eg_ctrl_cfg_q[0];
   assign o_eg_rdata_en = ucie_eg_ctrl_cfg_q[4];
   assign o_eg_rdata_upd = ucie_eg_ctrl_cfg_q[8];

   logic [31:0] eg_sta_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         eg_sta_q <= '0;
      else begin
         eg_sta_q[0] <= i_eg_empty;
         eg_sta_q[4] <= i_eg_read_done;
         eg_sta_q[8] <= i_eg_full;
         eg_sta_q[12] <= i_eg_overflow;
      end

   logic [31:0] eg_data_sta_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         eg_data_sta_q <= '0;
      else
         eg_data_sta_q <= i_eg_rdata;

   logic [31:0] ucie_pam4_cfg_q;
   always_ff @( posedge i_hclk, posedge i_hreset)
      if (i_hreset)
         ucie_pam4_cfg_q <= 32'h0;
      else
         if (i_write)
            if (decode == DECODE_UCIE_PAM4_CFG)
               ucie_pam4_cfg_q <= i_wdata;

   assign o_pam4_en = ucie_pam4_cfg_q[0];
   assign o_pam4_cfg = ucie_pam4_cfg_q[15:8];
            

   always_comb
      if (i_read)
         case (decode)
            DECODE_UCIE_TOP_0_CFG:o_rdata=ucie_top_0_cfg_q;
            DECODE_UCIE_DEBUG_STA:o_rdata=debug_sta_q;
            DECODE_UCIE_TS_CFG:o_rdata=ucie_ts_cfg_q;
            DECODE_UCIE_IG_CTRL_CFG:o_rdata=ucie_ig_ctrl_cfg_q;
            DECODE_UCIE_IG_DATA_CFG:o_rdata=ucie_ig_data_cfg_q;
            DECODE_UCIE_IG_STA:o_rdata=ig_sta_q;
            DECODE_UCIE_EG_CTRL_CFG:o_rdata=ucie_eg_ctrl_cfg_q;
            DECODE_UCIE_EG_STA:o_rdata=eg_sta_q;
            DECODE_UCIE_EG_DATA_STA:o_rdata=eg_data_sta_q;
            DECODE_UCIE_PAM4_CFG:o_rdata=ucie_pam4_cfg_q;
            default : o_rdata = '0;
         endcase
      else
         o_rdata = '0;

endmodule
