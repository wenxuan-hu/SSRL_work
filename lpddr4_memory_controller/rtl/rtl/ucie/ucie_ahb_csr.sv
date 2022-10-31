module ucie_ahb_csr #(
   parameter AWIDTH = 32,
   parameter DWIDTH = 32
) (

   input   logic                i_hclk,
   input   logic                i_hreset,
   input   logic [AWIDTH-1:0]   i_haddr,
   input   logic                i_hwrite,
   input   logic                i_hsel,
   input   logic [DWIDTH-1:0]   i_hwdata,
   input   logic [1:0]          i_htrans,
   input   logic [2:0]          i_hsize,
   input   logic [2:0]          i_hburst,
   input   logic                i_hreadyin,
   output  logic                o_hready,
   output  logic [DWIDTH-1:0]   o_hrdata,
   output  logic [1:0]          o_hresp,
 //CSR
 output logic o_ucie_rxfifo_write,
 output logic o_ucie_mode_en,
    output logic o_rxfifo_clr,
    output logic [3:0] o_txrx_mode, // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    output  logic                     o_buf_mode,
    output logic                     o_pam4_en,
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

   logic                slv_write;
   logic                slv_read;
   logic                slv_error;
   logic [AWIDTH-1:0]   slv_addr;
   logic [DWIDTH-1:0]   slv_wdata;
   logic [DWIDTH-1:0]   slv_rdata;
   logic                slv_ready;

   ddr_ahb_slave #(
      .AWIDTH(AWIDTH),
      .DWIDTH(DWIDTH)
   ) ahb_slave (
      .i_hclk     (i_hclk),
      .i_hreset   (i_hreset),
      .i_haddr    (i_haddr),
      .i_hwrite   (i_hwrite),
      .i_hsel     (i_hsel),
      .i_hwdata   (i_hwdata),
      .i_htrans   (i_htrans),
      .i_hsize    (i_hsize),
      .i_hburst   (i_hburst),
      .i_hreadyin (i_hreadyin),
      .o_hready   (o_hready),
      .o_hrdata   (o_hrdata),
      .o_hresp    (o_hresp),
      .o_write    (slv_write),
      .o_read     (slv_read),
      .o_wdata    (slv_wdata),
      .o_addr     (slv_addr),
      .i_rdata    (slv_rdata),
      .i_error    (slv_error),
      .i_ready    (slv_ready)
   );

    
   ucie_csr #(
      .AWIDTH(AWIDTH),
      .DWIDTH(DWIDTH)
   ) ucie_csr (
      .i_hclk   (i_hclk),
      .i_hreset (i_hreset),
      .i_write  (slv_write),
      .i_read   (slv_read),
      .i_wdata  (slv_wdata),
      .i_addr   (slv_addr),
      .o_rdata  (slv_rdata),
      .o_error  (slv_error),
      .o_ready  (slv_ready),
      //CSR
      .o_ucie_rxfifo_write(o_ucie_rxfifo_write),
      .o_ucie_mode_en     (o_ucie_mode_en),
    .o_txrx_mode        (o_txrx_mode),
    .o_rxfifo_clr       (o_rxfifo_clr),
    // bit(3_2) for channel 1,  bit(1_0) for channel 0. 2'b00: disable all(hiz), 2'b01: rx_mode, 2'b10: tx_mode, 2'b11 reserved(hiz)
    .o_buf_mode         (o_buf_mode),
    .o_pam4_en          (o_pam4_en),
    .o_buf_clk_en       (o_buf_clk_en),
    .o_intf_pipe_en     (o_intf_pipe_en),
    .o_ts_enable        (o_ts_enable),
    .o_ts_reset         (o_ts_reset),
    .o_ts_brkpt_en      (o_ts_brkpt_en),
    .o_ts_brkpt_val     (o_ts_brkpt_val),
    .o_ig_loop_mode     (o_ig_loop_mode),
    .o_ig_num_loops     (o_ig_num_loops),
    .o_ig_load_ptr      (o_ig_load_ptr),
    .o_ig_stop_ptr      (o_ig_stop_ptr),
    .o_ig_start_ptr     (o_ig_start_ptr),
    .o_ig_wdata_clr     (o_ig_wdata_clr),
    .o_ig_wdata_hold    (o_ig_wdata_hold),
    .o_ig_wdata_en      (o_ig_wdata_en),
    .o_ig_wdata_upd     (o_ig_wdata_upd),
    .o_ig_wdata         (o_ig_wdata),
    .i_ig_empty         (i_ig_empty),
    .i_ig_write_done    (i_ig_write_done),
    .i_ig_full          (i_ig_full),
    .i_ig_overflow      (i_ig_overflow),
    .o_eg_rdata_clr     (o_eg_rdata_clr),
    .o_eg_rdata_en      (o_eg_rdata_en),
    .o_eg_rdata_upd     (o_eg_rdata_upd),
    .i_eg_rdata         (i_eg_rdata),
    .i_eg_empty         (i_eg_empty),
    .i_eg_read_done     (i_eg_read_done),
    .i_eg_full          (i_eg_full),
    .i_eg_overflow      (i_eg_overflow),
    .i_debug            (i_debug)
);

endmodule
