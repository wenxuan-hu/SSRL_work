module ucie_buf (
   input  logic                     clk,
   input  logic                     rst,

   input  logic                     i_buf_mode,
   input  logic                     i_buf_clk_en,
   input  logic                     i_intf_pipe_en,
   input  logic                     i_ts_enable,
   input  logic                     i_ts_reset,
   input  logic                     i_ts_brkpt_en,
   input  logic [15:0]              i_ts_brkpt_val,

   input  logic                     i_ig_loop_mode,
   input  logic [3:0]               i_ig_num_loops,
   input  logic                     i_ig_load_ptr,
   input  logic [4:0]               i_ig_stop_ptr,
   input  logic [4:0]               i_ig_start_ptr,
   input  logic                     i_ig_wdata_clr,
   input  logic                     i_ig_wdata_hold,
   input  logic                     i_ig_wdata_en,
   input  logic                     i_ig_wdata_upd,
   input  logic [31:0]              i_ig_wdata,
   output logic                     o_ig_empty,
   output logic                     o_ig_write_done,
   output logic                     o_ig_full,
   output logic                     o_ig_overflow,

   input  logic                     i_eg_rdata_clr,
   input  logic                     i_eg_rdata_en,
   input  logic                     i_eg_rdata_upd,
   output logic [31:0]              o_eg_rdata,
   output logic                     o_eg_empty,
   output logic                     o_eg_read_done,
   output logic                     o_eg_full,
   output logic                     o_eg_overflow,
   output logic [31:0]               o_debug,

//tx ingress mux
    input logic [71:0] i_ch0_tx_dq0_sdr,
    input logic [71:0] i_ch0_tx_dq1_sdr,
    input logic [63:0] i_ch0_tx_ca_sdr,
    input logic [71:0] i_ch1_tx_dq0_sdr,
    input logic [71:0] i_ch1_tx_dq1_sdr,
    input logic [63:0] i_ch1_tx_ca_sdr,

    input logic [71:0] i_ch0_tx_dq0_pam4_sdr,
    input logic [71:0] i_ch0_tx_dq1_pam4_sdr,
    input logic [63:0] i_ch0_tx_ca_pam4_sdr,
    input logic [71:0] i_ch1_tx_dq0_pam4_sdr,
    input logic [71:0] i_ch1_tx_dq1_pam4_sdr,
    input logic [63:0] i_ch1_tx_ca_pam4_sdr,

    output logic [71:0] o_ch0_tx_dq0_sdr,
    output logic [71:0] o_ch0_tx_dq1_sdr,
    output logic [63:0] o_ch0_tx_ca_sdr,
    output logic [71:0] o_ch1_tx_dq0_sdr,
    output logic [71:0] o_ch1_tx_dq1_sdr,
    output logic [63:0] o_ch1_tx_ca_sdr,

    output logic [71:0] o_ch0_tx_dq0_pam4_sdr,
    output logic [71:0] o_ch0_tx_dq1_pam4_sdr,
    output logic [63:0] o_ch0_tx_ca_pam4_sdr,
    output logic [71:0] o_ch1_tx_dq0_pam4_sdr,
    output logic [71:0] o_ch1_tx_dq1_pam4_sdr,
    output logic [63:0] o_ch1_tx_ca_pam4_sdr,

    //tx dqs ingress mux
    input logic [71:0] i_ch0_tx_dqs0_sdr,
    input logic [71:0] i_ch0_tx_dqs1_sdr,
    input logic [71:0] i_ch0_tx_ck_sdr,
    input logic [71:0] i_ch1_tx_dqs0_sdr,
    input logic [71:0] i_ch1_tx_dqs1_sdr,
    input logic [71:0] i_ch1_tx_ck_sdr,
    output logic [71:0] o_ch0_tx_dqs0_sdr,
    output logic [71:0] o_ch0_tx_dqs1_sdr,
    output logic [71:0] o_ch0_tx_ck_sdr,
    output logic [71:0] o_ch1_tx_dqs0_sdr,
    output logic [71:0] o_ch1_tx_dqs1_sdr,
    output logic [71:0] o_ch1_tx_ck_sdr,

    //rx egress
    input logic [71:0] i_ch0_rx_dq0_sdr,
    input logic [71:0] i_ch0_rx_dq1_sdr,
    input logic [63:0] i_ch0_rx_ca_sdr,
    input logic [71:0] i_ch1_rx_dq0_sdr,
    input logic [71:0] i_ch1_rx_dq1_sdr,
    input logic [63:0] i_ch1_rx_ca_sdr,

    input logic [71:0] i_ch0_rx_dq0_pam4_sdr,
    input logic [71:0] i_ch0_rx_dq1_pam4_sdr,
    input logic [63:0] i_ch0_rx_ca_pam4_sdr,
    input logic [71:0] i_ch1_rx_dq0_pam4_sdr,
    input logic [71:0] i_ch1_rx_dq1_pam4_sdr,
    input logic [63:0] i_ch1_rx_ca_pam4_sdr,

    input logic [8:0] i_ch0_rx_dq0_sdr_vld,
    input logic [8:0] i_ch0_rx_dq1_sdr_vld,
    input logic [7:0] i_ch0_rx_ca_sdr_vld,
    input logic [8:0] i_ch1_rx_dq0_sdr_vld,
    input logic [8:0] i_ch1_rx_dq1_sdr_vld,
    input logic [7:0] i_ch1_rx_ca_sdr_vld,
    // rx output to fifo
    output logic [71:0] o_ch0_rx_dq0_sdr,
    output logic [71:0] o_ch0_rx_dq1_sdr,
    output logic [63:0] o_ch0_rx_ca_sdr,
    output logic [71:0] o_ch1_rx_dq0_sdr,
    output logic [71:0] o_ch1_rx_dq1_sdr,
    output logic [63:0] o_ch1_rx_ca_sdr,

    output logic [71:0] o_ch0_rx_dq0_pam4_sdr,
    output logic [71:0] o_ch0_rx_dq1_pam4_sdr,
    output logic [63:0] o_ch0_rx_ca_pam4_sdr,
    output logic [71:0] o_ch1_rx_dq0_pam4_sdr,
    output logic [71:0] o_ch1_rx_dq1_pam4_sdr,
    output logic [63:0] o_ch1_rx_ca_pam4_sdr,

    output logic [8:0] o_ch0_rx_dq0_sdr_vld,
    output logic [8:0] o_ch0_rx_dq1_sdr_vld,
    output logic [7:0] o_ch0_rx_ca_sdr_vld,
    output logic [8:0] o_ch1_rx_dq0_sdr_vld,
    output logic [8:0] o_ch1_rx_dq1_sdr_vld,
    output logic [7:0] o_ch1_rx_ca_sdr_vld

);

   logic buf_mode_sync, buf_clk_en_sync;

   ddr_demet_r u_demet_6     (.i_clk(clk), .i_rst(rst), .i_d(i_buf_mode), .o_q(buf_mode_sync));  
   ddr_demet_r u_demet_9     (.i_clk(clk), .i_rst(rst), .i_d(i_buf_clk_en), .o_q(buf_clk_en_sync));
   // ------------------------------------------------------------------------
   // Timestamp Counter
   // ------------------------------------------------------------------------

   logic [15:0] timestamp_q;
   logic ts_enable_sync;
   logic ts_reset_sync;
   logic ts_brkpt_en_sync;
   logic ts_brkpt ;

   // Synchronize CSR controls
   ddr_demet_r u_demet_0 (.i_clk(clk), .i_rst(rst), .i_d(i_ts_enable),        .o_q(ts_enable_sync));
   ddr_demet_r u_demet_1 (.i_clk(clk), .i_rst(rst), .i_d(i_ts_reset ),        .o_q(ts_reset_sync ));
   ddr_demet_r u_demet_7 (.i_clk(clk), .i_rst(rst), .i_d(i_ts_brkpt_en),      .o_q(ts_brkpt_en_sync ));

   assign ts_brkpt = ts_brkpt_en_sync && (timestamp_q == i_ts_brkpt_val) ;

   // Timestamp counter
   always_ff @ (posedge clk, posedge rst) begin
      if (rst)
         timestamp_q <= '0;
      else if (ts_reset_sync)
         timestamp_q <= '0;
      else if (ts_enable_sync)
         timestamp_q <=  ts_brkpt ? timestamp_q : timestamp_q + 'b1;
   end

   // ------------------------------------------------------------------------
   // Buffer Ingress - To UCIe Datapath
   // ------------------------------------------------------------------------

   localparam IG_WIDTH = 16+(72+72+64+72*3)*2;

   logic [15:0] ig_timestamp, timestamp_early;
   logic ig_read, ig_write, ig_empty_n, ig_empty_n_q, ig_write_toggle_q ;
   logic [IG_WIDTH-1:0] ig_wdata, ig_rdata, ig_rdata_q, ig_mask_n, ig_mask_n_q;
   logic ig_wdata_en_sync, ig_wdata_en_q;
   logic ig_wdata_upd_sync, ig_wdata_upd_q;
   logic ig_load_ptr_sync ;
   logic wdata_loader_en, wdata_loader_upd;
   logic [IG_WIDTH-1:0] wdata_loader_q;
   logic [3:0] ig_loop_cnt_q ;
   logic [3:0] ig_loop_cnt_d ;

   logic [71:0] ig_ch0_sequence_dq0;
   logic [71:0] ig_ch0_sequence_dq1;
   logic [63:0] ig_ch0_sequence_ca;
   logic [71:0] ig_ch1_sequence_dq0;
   logic [71:0] ig_ch1_sequence_dq1;
   logic [63:0] ig_ch1_sequence_ca;

   logic [71:0] ig_ch0_sequence_dqs0;
   logic [71:0] ig_ch0_sequence_dqs1;
   logic [71:0] ig_ch0_sequence_ck;
   logic [71:0] ig_ch1_sequence_dqs0;
   logic [71:0] ig_ch1_sequence_dqs1;
   logic [71:0] ig_ch1_sequence_ck;

   // Current timestamp at the head of the FIFO
   assign timestamp_early = ig_rdata[IG_WIDTH-1:IG_WIDTH-16];

   // If the FIFO "head" timestamp matches the current running timestamp, then pop data
   assign ig_read = ((timestamp_early == timestamp_q) & ig_empty_n & ( (ig_loop_cnt_q != 0) || (i_ig_loop_mode == 1'b0) ));

   // Remove the timestamp from the read mask. Output data masked when TS does not match
   assign ig_mask_n = {{16{1'b1}},{IG_WIDTH-16{ig_read}}};

   // Ingress Read Data
   assign {
       ig_timestamp,
      ig_ch0_sequence_dq0,
      ig_ch0_sequence_dq1,
      ig_ch0_sequence_ca,
      ig_ch1_sequence_dq0,
      ig_ch1_sequence_dq1,
      ig_ch1_sequence_ca,

      ig_ch0_sequence_dqs0,
      ig_ch0_sequence_dqs1,
      ig_ch0_sequence_ck,
      ig_ch1_sequence_dqs0,
      ig_ch1_sequence_dqs1,
      ig_ch1_sequence_ck
   } = ig_rdata_q & ig_mask_n_q;

   // Synchronize CSR controls
   ddr_demet_r u_demet_2 (.i_clk(clk), .i_rst(rst), .i_d(i_ig_wdata_en ), .o_q(ig_wdata_en_sync ));
   ddr_demet_r u_demet_3 (.i_clk(clk), .i_rst(rst), .i_d(i_ig_wdata_upd), .o_q(ig_wdata_upd_sync));
   ddr_demet_r u_demet_8 (.i_clk(clk), .i_rst(rst), .i_d(i_ig_load_ptr),  .o_q(ig_load_ptr_sync));

   always_ff @ (posedge clk, posedge rst) begin
      if (rst) begin
         ig_wdata_en_q     <= '0;
         ig_wdata_upd_q    <= '0;
         ig_write_toggle_q <= '0;
      end else begin
         ig_wdata_en_q     <= ig_wdata_en_sync;
         ig_wdata_upd_q    <= ig_wdata_upd_sync;
         ig_write_toggle_q <= ig_write_toggle_q ^ ig_write ;
      end
   end

   // Update the data loader on a CSR toggle
   assign wdata_loader_upd =  ig_wdata_upd_q ^ ig_wdata_upd_sync;

   // Enable the data loader on a CSR toggle
   assign wdata_loader_en = ig_wdata_en_q ^ ig_wdata_en_sync;

   // Ingress Write Data Loader
   always_ff @ (posedge clk, posedge rst) begin
      if (rst)
         wdata_loader_q <= '0;
      else if (wdata_loader_en)
         wdata_loader_q <= {wdata_loader_q[IG_WIDTH-31:0]          , i_ig_wdata};
   end

   assign ig_wdata        = wdata_loader_q;
   assign ig_write        = wdata_loader_upd;
   assign o_ig_empty      = ~ig_empty_n_q;
   assign o_ig_overflow   = o_ig_full & ig_write;
   assign o_ig_write_done = ig_write_toggle_q ;

   ddr_fifo #(
      .WWIDTH                       (IG_WIDTH),
      .RWIDTH                       (IG_WIDTH),
      .DEPTH                        (32),
      .SYNC                         (1'b1),
      .RAM_MODEL                    (1'b0)
   ) u_ig_fifo (
      .i_scan_mode                  (0),
      .i_scan_rst_ctrl              (0),
      .i_scan_cgc_ctrl              (0),
      .i_clr                        (i_ig_wdata_clr),
      .i_loop_mode                  (i_ig_loop_mode),
      .i_load_ptr                   (ig_load_ptr_sync),
      .i_stop_ptr                   (i_ig_stop_ptr ),
      .i_start_ptr                  (i_ig_start_ptr),
      .i_wclk                       (clk),
      .i_wrst                       (rst),
      .i_write                      (ig_write),
      .i_wdata                      (ig_wdata),
      .o_full                       (o_ig_full),
      .o_early_full                 (/*OPEN*/),
      .i_rclk                       (clk),
      .i_rrst                       (rst),
      .i_read                       (ig_read),
      .o_rdata                      (ig_rdata),
      .o_early_empty_n              (/*OPEN*/),
      .o_empty_n                    (ig_empty_n)
   );

   assign ig_loop_cnt_d = ig_load_ptr_sync             ? i_ig_num_loops :
                          (ig_empty_n_q & ~ig_empty_n) ? ig_loop_cnt_q - 1'b1 :
                          ig_loop_cnt_q ;

   // Hold data so values persist on bus
   always_ff @ (posedge clk, posedge rst) begin
      if (rst) begin
         ig_rdata_q    <= '0;
         ig_mask_n_q   <= '0;
         ig_empty_n_q  <= '0;
         ig_loop_cnt_q <= 4'h1;
      end else begin
         if (ig_read || !i_ig_wdata_hold) begin
            ig_rdata_q  <= ig_rdata;
            ig_mask_n_q <= ig_mask_n;
         end
         ig_empty_n_q  <= ig_empty_n;
         if (i_ig_loop_mode)
            ig_loop_cnt_q <= ig_loop_cnt_d;
      end
   end

   // ------------------------------------------------------------------------
   // Buffer Egress - From Datapath
   // ------------------------------------------------------------------------

   localparam EG_WIDTH = 16+(72+72+64)*2;

   logic [EG_WIDTH-1:0] eg_wdata, eg_rdata;
   logic eg_write, eg_read, eg_empty_n, eg_read_toggle_q ;
   logic eg_rdata_en_sync, eg_rdata_en_q;
   logic eg_rdata_upd_sync, eg_rdata_upd_q;
   logic rdata_loader_en, rdata_loader_upd;
   logic [EG_WIDTH-1:0] rdata_loader_q;

   // Read Data
   assign eg_wdata = {
       timestamp_q
       ,i_ch0_rx_dq0_sdr
       ,i_ch0_rx_dq1_sdr
       ,i_ch0_rx_ca_sdr
       ,i_ch1_rx_dq0_sdr
       ,i_ch1_rx_dq1_sdr
       ,i_ch1_rx_ca_sdr
   };

   assign eg_write   = (
    (|i_ch0_rx_dq0_sdr_vld) |
    (|i_ch0_rx_dq1_sdr_vld) |
    (|i_ch0_rx_ca_sdr_vld) |
    (|i_ch1_rx_dq0_sdr_vld) |
    (|i_ch1_rx_dq1_sdr_vld) |
    (|i_ch1_rx_ca_sdr_vld) |
      1'b0
   );
 
   assign o_ch0_rx_dq0_sdr=i_ch0_rx_dq0_sdr;
   assign o_ch0_rx_dq1_sdr=i_ch0_rx_dq1_sdr;
   assign o_ch0_rx_ca_sdr=i_ch0_rx_ca_sdr;
   assign o_ch1_rx_dq0_sdr=i_ch1_rx_dq0_sdr;
   assign o_ch1_rx_dq1_sdr=i_ch1_rx_dq1_sdr;
   assign o_ch1_rx_ca_sdr=i_ch1_rx_ca_sdr;

   assign o_ch0_rx_dq0_pam4_sdr=i_ch0_rx_dq0_pam4_sdr;
   assign o_ch0_rx_dq1_pam4_sdr=i_ch0_rx_dq1_pam4_sdr;
   assign o_ch0_rx_ca_pam4_sdr=i_ch0_rx_ca_pam4_sdr;
   assign o_ch1_rx_dq0_pam4_sdr=i_ch1_rx_dq0_pam4_sdr;
   assign o_ch1_rx_dq1_pam4_sdr=i_ch1_rx_dq1_pam4_sdr;
   assign o_ch1_rx_ca_pam4_sdr=i_ch1_rx_ca_pam4_sdr;

   assign o_ch0_rx_dq0_sdr_vld=buf_mode_sync?'0:i_ch0_rx_dq0_sdr_vld;
   assign o_ch0_rx_dq1_sdr_vld=buf_mode_sync?'0:i_ch0_rx_dq1_sdr_vld;
   assign o_ch0_rx_ca_sdr_vld=buf_mode_sync?'0:i_ch0_rx_ca_sdr_vld;
   assign o_ch1_rx_dq0_sdr_vld=buf_mode_sync?'0:i_ch1_rx_dq0_sdr_vld;
   assign o_ch1_rx_dq1_sdr_vld=buf_mode_sync?'0:i_ch1_rx_dq1_sdr_vld;
   assign o_ch1_rx_ca_sdr_vld=buf_mode_sync?'0:i_ch1_rx_ca_sdr_vld;


   assign o_eg_empty     =  ~eg_empty_n ;
   assign o_eg_overflow  = o_eg_full & eg_write;
   assign o_eg_read_done = eg_read_toggle_q ;

   ddr_fifo #(
      .WWIDTH                       (EG_WIDTH),
      .RWIDTH                       (EG_WIDTH),
      .DEPTH                        (32),
      .SYNC                         (1'b1),
      .RAM_MODEL                    (0)
   ) u_eg_fifo (
      .i_scan_mode                  (0),
      .i_scan_rst_ctrl              (0),
      .i_scan_cgc_ctrl              (0),
      .i_clr                        (i_eg_rdata_clr),
      .i_loop_mode                  ('0),
      .i_load_ptr                   ('0),
      .i_stop_ptr                   ('0),
      .i_start_ptr                  ('0),
      .i_wclk                       (clk),
      .i_wrst                       (rst),
      .i_write                      (eg_write),
      .i_wdata                      (eg_wdata),
      .o_full                       (o_eg_full),
      .o_early_full                 (/*OPEN*/),
      .i_rclk                       (clk),
      .i_rrst                       (rst),
      .i_read                       (eg_read),
      .o_rdata                      (eg_rdata),
      .o_early_empty_n              (/*OPEN*/),
      .o_empty_n                    (eg_empty_n)
   );

   // Synchronize CSR controls
   ddr_demet_r u_demet_4 (.i_clk(clk), .i_rst(rst), .i_d(i_eg_rdata_en ), .o_q(eg_rdata_en_sync ));
   ddr_demet_r u_demet_5 (.i_clk(clk), .i_rst(rst), .i_d(i_eg_rdata_upd), .o_q(eg_rdata_upd_sync));

   always_ff @ (posedge clk, posedge rst) begin
      if (rst) begin
         eg_rdata_en_q     <= '0;
         eg_rdata_upd_q    <= '0;
         eg_read_toggle_q  <= '0;
      end else begin
         eg_rdata_en_q     <= eg_rdata_en_sync;
         eg_rdata_upd_q    <= eg_rdata_upd_sync;
         eg_read_toggle_q  <= eg_read_toggle_q ^ eg_read ;
      end
   end

   // Update the data loader on a CSR toggle
   assign rdata_loader_upd =  eg_rdata_upd_q ^ eg_rdata_upd_sync;

   // Enable the data loader on a CSR toggle
   assign rdata_loader_en = eg_rdata_en_q ^ eg_rdata_en_sync;

   // Egress Write Data Loader
   always_ff @ (posedge clk, posedge rst) begin
      if (rst)
         rdata_loader_q <= '0;
      else if (rdata_loader_upd)
         rdata_loader_q <= eg_rdata;
      else if (rdata_loader_en)
         rdata_loader_q <= {{32{1'b0}},rdata_loader_q[EG_WIDTH-1:32]};
   end

   // Pop read data from Egress FIFO
   assign eg_read = rdata_loader_upd;

   // Read data to CSR
   assign o_eg_rdata = rdata_loader_q[31:0];

   // ------------------------------------------------------------------------
   // Mode Mux
   // ------------------------------------------------------------------------
   // Write Command Address Data
   logic [71:0] intf_ch0_tx_dq0_sdr;
   logic [71:0] intf_ch0_tx_dq1_sdr;
   logic [63:0] intf_ch0_tx_ca_sdr;
   logic [71:0] intf_ch1_tx_dq0_sdr;
   logic [71:0] intf_ch1_tx_dq1_sdr;
   logic [63:0] intf_ch1_tx_ca_sdr;

   logic [71:0] intf_ch0_tx_dq0_pam4_sdr;
   logic [71:0] intf_ch0_tx_dq1_pam4_sdr;
   logic [63:0] intf_ch0_tx_ca_pam4_sdr;
   logic [71:0] intf_ch1_tx_dq0_pam4_sdr;
   logic [71:0] intf_ch1_tx_dq1_pam4_sdr;
   logic [63:0] intf_ch1_tx_ca_pam4_sdr;

   logic [71:0] intf_ch0_tx_dqs0_sdr;
   logic [71:0] intf_ch0_tx_dqs1_sdr;
   logic [71:0] intf_ch0_tx_ck_sdr;
   logic [71:0] intf_ch1_tx_dqs0_sdr;
   logic [71:0] intf_ch1_tx_dqs1_sdr;
   logic [71:0] intf_ch1_tx_ck_sdr;

    assign intf_ch0_tx_dq0_sdr=buf_mode_sync?ig_ch0_sequence_dq0:i_ch0_tx_dq0_sdr;
    assign intf_ch0_tx_dq1_sdr=buf_mode_sync?ig_ch0_sequence_dq1:i_ch0_tx_dq1_sdr;
    assign intf_ch0_tx_ca_sdr=buf_mode_sync?ig_ch0_sequence_ca:i_ch0_tx_ca_sdr;

    assign intf_ch1_tx_dq0_sdr=buf_mode_sync?ig_ch1_sequence_dq0:i_ch1_tx_dq0_sdr;
    assign intf_ch1_tx_dq1_sdr=buf_mode_sync?ig_ch1_sequence_dq1:i_ch1_tx_dq1_sdr;
    assign intf_ch1_tx_ca_sdr=buf_mode_sync?ig_ch1_sequence_ca:i_ch1_tx_ca_sdr;

    assign intf_ch0_tx_dq0_pam4_sdr=i_ch0_tx_dq0_pam4_sdr;
    assign intf_ch0_tx_dq1_pam4_sdr=i_ch0_tx_dq1_pam4_sdr;
    assign intf_ch0_tx_ca_pam4_sdr=i_ch0_tx_ca_pam4_sdr;

    assign intf_ch1_tx_dq0_pam4_sdr=i_ch1_tx_dq0_pam4_sdr;
    assign intf_ch1_tx_dq1_pam4_sdr=i_ch1_tx_dq1_pam4_sdr;
    assign intf_ch1_tx_ca_pam4_sdr=i_ch1_tx_ca_pam4_sdr;

    assign intf_ch0_tx_dqs0_sdr=buf_mode_sync?ig_ch0_sequence_dqs0:i_ch0_tx_dqs0_sdr;
    assign intf_ch0_tx_dqs1_sdr=buf_mode_sync?ig_ch0_sequence_dqs1:i_ch0_tx_dqs1_sdr;
    assign intf_ch0_tx_ck_sdr=buf_mode_sync?ig_ch0_sequence_ck:i_ch0_tx_ck_sdr;

    assign intf_ch1_tx_dqs0_sdr=buf_mode_sync?ig_ch1_sequence_dqs0:i_ch1_tx_dqs0_sdr;
    assign intf_ch1_tx_dqs1_sdr=buf_mode_sync?ig_ch1_sequence_dqs1:i_ch1_tx_dqs1_sdr;
    assign intf_ch1_tx_ck_sdr=buf_mode_sync?ig_ch1_sequence_ck:i_ch1_tx_ck_sdr;


   // ------------------------------------------------------------------------
   // Pipeline to Isolate from Interface
   // ------------------------------------------------------------------------
   ddr_pipeline #(.DWIDTH(72)) u_ch0_dq0_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dq0_sdr), .o_q(o_ch0_tx_dq0_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch0_dq1_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dq1_sdr), .o_q(o_ch0_tx_dq1_sdr));
   ddr_pipeline #(.DWIDTH(64)) u_ch0_ca_pipe (.i_clk(clk), .i_pipe_en({64{i_intf_pipe_en}}), .i_d(intf_ch0_tx_ca_sdr), .o_q(o_ch0_tx_ca_sdr));

   ddr_pipeline #(.DWIDTH(72)) u_ch1_dq0_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dq0_sdr), .o_q(o_ch1_tx_dq0_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch1_dq1_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dq1_sdr), .o_q(o_ch1_tx_dq1_sdr));
   ddr_pipeline #(.DWIDTH(64)) u_ch1_ca_pipe (.i_clk(clk), .i_pipe_en({64{i_intf_pipe_en}}), .i_d(intf_ch1_tx_ca_sdr), .o_q(o_ch1_tx_ca_sdr));

   ddr_pipeline #(.DWIDTH(72)) u_ch0_dq0_pam4_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dq0_pam4_sdr), .o_q(o_ch0_tx_dq0_pam4_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch0_dq1_pam4_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dq1_pam4_sdr), .o_q(o_ch0_tx_dq1_pam4_sdr));
   ddr_pipeline #(.DWIDTH(64)) u_ch0_ca_pam4_pipe (.i_clk(clk), .i_pipe_en({64{i_intf_pipe_en}}), .i_d(intf_ch0_tx_ca_pam4_sdr), .o_q(o_ch0_tx_ca_pam4_sdr));

   ddr_pipeline #(.DWIDTH(72)) u_ch1_dq0_pam4_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dq0_pam4_sdr), .o_q(o_ch1_tx_dq0_pam4_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch1_dq1_pam4_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dq1_pam4_sdr), .o_q(o_ch1_tx_dq1_pam4_sdr));
   ddr_pipeline #(.DWIDTH(64)) u_ch1_ca_pam4_pipe (.i_clk(clk), .i_pipe_en({64{i_intf_pipe_en}}), .i_d(intf_ch1_tx_ca_pam4_sdr), .o_q(o_ch1_tx_ca_pam4_sdr));

   ddr_pipeline #(.DWIDTH(72)) u_ch0_dqs0_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dqs0_sdr), .o_q(o_ch0_tx_dqs0_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch0_dqs1_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_dqs1_sdr), .o_q(o_ch0_tx_dqs1_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch0_ck_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch0_tx_ck_sdr), .o_q(o_ch0_tx_ck_sdr));

   ddr_pipeline #(.DWIDTH(72)) u_ch1_dqs0_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dqs0_sdr), .o_q(o_ch1_tx_dqs0_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch1_dqs1_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_dqs1_sdr), .o_q(o_ch1_tx_dqs1_sdr));
   ddr_pipeline #(.DWIDTH(72)) u_ch1_ck_pipe (.i_clk(clk), .i_pipe_en({72{i_intf_pipe_en}}), .i_d(intf_ch1_tx_ck_sdr), .o_q(o_ch1_tx_ck_sdr));
   //---------------------------------------------------------------------------
   // Debug Bus
   //---------------------------------------------------------------------------
   assign o_debug = { 24'b0,
                      ig_write,
                      ig_read,
                      ig_empty_n,
                      o_ig_overflow,
                      eg_write,
                      eg_read,
                      eg_empty_n,
                      o_eg_overflow
                    } ;
endmodule