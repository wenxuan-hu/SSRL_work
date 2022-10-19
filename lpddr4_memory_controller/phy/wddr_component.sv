module ddr_pipeline #(
   parameter DWIDTH          = 8
) (
   input  logic              i_clk,
   input  logic [DWIDTH-1:0] i_pipe_en,
   input  logic [DWIDTH-1:0] i_d,
   output logic [DWIDTH-1:0] o_q
);

   logic [DWIDTH-1:0] q;

   // Pipeline
   always_ff @(posedge i_clk) begin
    q<=i_d;
   end

   assign o_q=i_pipe_en?q:i_d;

endmodule


module ddr_dp_dbi #(
   parameter       WIDTH  = 8,              // Parallel bus width
   parameter       NUM_PH = 8,              // Number of data phases
   parameter [0:0] EGRESS = 1'b0,           // 0: Ingress, 1: Egress
   parameter       DWIDTH = NUM_PH * WIDTH  // Read data width
) (

   input  logic                    i_clk,
   input  logic                    i_rst,

   // Receiver
   input  logic                    i_dbi_en,
   input  logic                    i_dbi_ones,
   input  logic                    i_dbi_pipe_en,
   input  logic [WIDTH-1:0]        i_dbi_mask,
   input  logic [DWIDTH-1:0]       i_sdr,
   output logic [DWIDTH-1:0]       o_sdr,
   input  logic [NUM_PH-1:0]       i_sdr_dbi,
   output logic [NUM_PH-1:0]       o_sdr_dbi
);

   // ------------------------------------------------------------------------
   // DBI
   // ------------------------------------------------------------------------

   genvar i;
   generate
      for (i=0; i<NUM_PH; i++) begin : DBI
         ddr_dbi #(
            .DWIDTH           (WIDTH),
            .EGRESS           (EGRESS)
         ) u_dbi (
            .i_clk            (i_clk),
            .i_rst            (i_rst),
            .i_dbi_en         (i_dbi_en),
            .i_dbi_ones       (i_dbi_ones),
            .i_dbi_mask       (i_dbi_mask),
            .i_dbi_pipe_en    (i_dbi_pipe_en),
            .i_dbi            (i_sdr_dbi[i]),
            .i_bus            (i_sdr[i*WIDTH+:WIDTH]),
            .o_dbi            (o_sdr_dbi[i]),
            .o_bus            (o_sdr[i*WIDTH+:WIDTH])
         );
      end
   endgenerate

endmodule

module ddr_dbi #(
   parameter       DWIDTH = 8,   // Bus Width
   parameter [0:0] EGRESS = 1'b1  // DBI   1: Egress, 0: Ingress
) (
   input  logic              i_clk,
   input  logic              i_rst,
   input  logic              i_dbi_en,
   input  logic              i_dbi_ones,
   input  logic              i_dbi_pipe_en,
   input  logic [DWIDTH-1:0] i_dbi_mask,
   input  logic              i_dbi,
   input  logic [DWIDTH-1:0] i_bus,
   output logic              o_dbi,
   output logic [DWIDTH-1:0] o_bus
);

   localparam AWIDTH = $clog2(DWIDTH) + 'd1;

   logic [AWIDTH-1:0] count, count_msk;
   logic [DWIDTH-1:0] bus, bus_d, bus_q, bus_mask;
   logic dbi_d, dbi_q;

   assign bus_mask = ~i_dbi_mask;

   // Select ONES or ZEROS to count and mask
   assign bus = bus_mask & (i_dbi_ones ? i_bus : ~i_bus);

   // Count the number of ones or zeros
   integer i;
   always_comb begin
      count = 0;                               // Initialize count variable.
      for(i=0; i<DWIDTH; i++)                  // For all the bits...
         count = count + bus[i];               // Add the bit to the count.
   end

   // Count the number of unmasked bits
   integer j;
   always_comb begin
      count_msk = 0;                           // Initialize count variable.
      for(j=0; j<DWIDTH; j++) begin            // For all the bits...
         count_msk = count_msk + bus_mask[j];  // Add the bit to the count.
      end
   end

   // SPEC[GDDR4] :: 4.2 - CABI
   // Determine inversion requirement
   assign dbi_d = i_dbi_en & (EGRESS ? count > (count_msk>>1) : i_dbi);

   // Perform the data bus inversion
   assign bus_d = ({DWIDTH{dbi_d}} & bus_mask) ^ i_bus;

   // Pipeline for timing
   always_ff @(posedge i_clk, posedge i_rst) begin
      if (i_rst) begin
         bus_q <= '0;
         dbi_q <= '0;
      end else begin
         bus_q <= bus_d;
         dbi_q <= dbi_d;
      end
   end

   // Programmable pipeline
   assign o_bus = i_dbi_pipe_en ? bus_q : bus_d;
   assign o_dbi = 1'b0 ? dbi_q : dbi_d;

endmodule

module ddr_cgc_rl (
   input  logic i_cgc_en,
   input  logic i_clk_en,
   input  logic i_clk,
   output logic o_clk
);
   logic clk_en, inv_clk, clk_test_en;

   assign clk_test_en=i_clk_en | i_cgc_en;
   assign inv_clk=~i_clk;
   always_latch begin
    if(inv_clk) clk_en=clk_test_en;
   end

   assign o_clk=i_clk&clk_en;

endmodule

module ddr_demet_r #(
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

endmodule

module ddr_fifo #(
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
         ddr_demet_r wsync [AWIDTH+1] (
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
         ddr_demet_r rsync [AWIDTH+1] (
            .i_clk   (i_wclk),
            .i_rst   (wrst_scan),
            .i_d     (rgray_q),
            .o_q     (rgray_sync)
         );
     end
   endgenerate

endmodule

module ddr_dp_wop2pow #(
   parameter WIDTH  = 1,             // Parallel bus width
   parameter NUM_PH = 4,             // Number of data phases
   parameter DWIDTH = WIDTH * NUM_PH
) (
   input  logic [DWIDTH-1:0] i_d,
   output logic [DWIDTH-1:0] o_d
);

   integer i,j;
   // Convert Words-Of-Phases (WOP) to Phases-Of-Words (POW)
   always_comb
      for (j=0; j<NUM_PH; j++)
         for (i=0; i<WIDTH; i++)
            o_d[(j*WIDTH)+i] = i_d[(i*NUM_PH)+j];
endmodule

module ddr_dp_pow2wop #(
   parameter WIDTH  = 1,             // Parallel bus width
   parameter NUM_PH = 4,             // Number of data phases
   parameter DWIDTH = WIDTH * NUM_PH
) (
   input  logic [DWIDTH-1:0] i_d,
   output logic [DWIDTH-1:0] o_d
);

   integer i,j;
   // Convert Phases-Of-Words (POW) to Words-Of-Phases (WOP)
   always_comb
      for (i=0; i<WIDTH; i++)
         for (j=0; j<NUM_PH; j++)
            o_d[(i*NUM_PH)+j] = i_d[(j*WIDTH)+i];
endmodule

module ddr_pulse_extender # (
   parameter  WIDTH         = 4
) (
   input  logic             i_d,
   input  logic             i_clk,
   input  logic             i_rst,
   input  logic [WIDTH-1:0] i_num_pulses,
   output logic             o_d
);

   logic [WIDTH-1:0] cnt_q;
   logic d_q;
   logic d_asserted ;

   always_ff @ (posedge i_clk, posedge i_rst)
   begin
      if(i_rst)
         cnt_q <= '0;
      else if (i_d)
         cnt_q <= i_num_pulses;
      else if (~i_d && cnt_q != '0)
         cnt_q <= cnt_q - 1'b1;
   end

   always_ff @ (posedge i_clk, posedge i_rst)
   begin
      if(i_rst)
        d_q <= '0;
      else if (i_d || (~i_d && cnt_q == '0))
        d_q <= i_d;
   end

   assign d_asserted = i_d & ~d_q ;
   assign o_d = i_d | d_q ;

endmodule