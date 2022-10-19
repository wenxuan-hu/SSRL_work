`ifndef _COMMON_ASYNCFIFO_SV
`define _COMMON_ASYNCFIFO_SV
////////////////////////////////////////////////////////////
//
//        Copyright (C) 2021 Eximius Design
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////
//
//Functional Descript:
//
//  A standard asynchronous FIFO. Depths must be exponents of 2.
// Port names indicate which clock they origiate from. Read/
// Write pointers are passed using greycoding to help with
// asynchronous crossing. No assumption is made on the
// relation between
//
//  In case of overflow, we drop the "overflowed" data to maintain
// order in the rest of the data.
//
// FIFO_WIDTH_WID is the data width of the FIFO (any number).
// FIFO_DEPTH_WID is the requested depth of the FIFO.  Must
//                an exponent of 2 and less than 1023 (i.e. max = 512).
//
//   Use the wr_full/rd_empty if you only care about "is there data /
// space".  Use the rd_numfilled / wr_numempty to determine how many
// entries are currently on the FIFO / how many spaces are
// available.  The rd_numfilled/wr_numempty will (obviously) use more
// gates than just wr_full/rd_empty.  The "wr_" and "rd_" prefixes
// indicate which clocks those signals are valid on (clk_write or
// clk_read).
//
////////////////////////////////////////////////////////////

module asyncfifo (/*AUTOARG*/
   // Outputs
   rddata, rd_numfilled, wr_numempty, wr_full, rd_empty,
   wr_overflow_pulse, rd_underflow_pulse,
   // Inputs
   clk_write, rst_write_n, clk_read, rst_read_n, wrdata, write_push,
   read_pop, rd_soft_reset, wr_soft_reset
   );

////////////////////////////////////////////////////////////
//  User modifyable parts
parameter FIFO_WIDTH_WID = 32;
parameter FIFO_DEPTH_WID = 4;
//  User modifyable parts
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//  Do Not Modify
// Note, $clog2 doesn't quite work for 1 deep FIFOs, but neither does the asyncfifo.
localparam FIFO_ADDR_WID  = $clog2(FIFO_DEPTH_WID) + 1 ; // For this FIFO, we use one extra bit for full/empty.
localparam FIFO_COUNT_WID = FIFO_ADDR_WID ;

localparam FIFO_WIDTH_MSB = FIFO_WIDTH_WID - 1 ;
localparam FIFO_DEPTH_MSB = FIFO_DEPTH_WID - 1 ;
localparam FIFO_ADDR_MSB  = FIFO_ADDR_WID  - 1 ;
localparam FIFO_COUNT_MSB = FIFO_COUNT_WID - 1 ;
//  Do Not Modify
////////////////////////////////////////////////////////////

input                                   clk_write;              // Clock of the "write" side.
input                                   rst_write_n;            // reset of the "write" side.
input                                   clk_read;               // Clock of the "read" side.
input                                   rst_read_n;             // reset of the "read" side.

output  [FIFO_WIDTH_WID-1:0]            rddata;                 // Read data.
input   [FIFO_WIDTH_WID-1:0]            wrdata;                 // Write Data.
input                                   write_push;             // Write push (validates write data)
input                                   read_pop;               // Read Pop (advances to _next_ read data).

input                                   rd_soft_reset;          // Soft reset for read side  (assigns Read rptr = wrptr)
input                                   wr_soft_reset;          // Soft reset for write side (assigns Write side w rptr = wrptr)

output  [FIFO_ADDR_WID-1:0]             rd_numfilled;
output  [FIFO_ADDR_WID-1:0]             wr_numempty;

output                                  wr_full;                // Full signal, synchronous to WRITE side
output                                  rd_empty;               // Empty signal, synchronous to READ side

output                                  wr_overflow_pulse;      // Overflow signal, synchronous to WRITE side that only pulses high (not held).
output                                  rd_underflow_pulse;     // Underflow signal, synchronous to READ side that only pulses high (not held).


reg  [FIFO_ADDR_WID-1:0]      wr_wptr_gray_reg ;
reg  [FIFO_ADDR_WID-1:0]      wr_wptr_bin_reg ;
wire  [FIFO_ADDR_WID-1:0]     wr_wptr_bin_nxt ;
wire  [FIFO_ADDR_WID-1:0]     wr_wptr_gray_nxt ;

reg  [FIFO_ADDR_WID-1:0]      rd_rptr_gray_reg ;
reg  [FIFO_ADDR_WID-1:0]      rd_rptr_bin_reg ;
wire  [FIFO_ADDR_WID-1:0]     rd_rptr_bin_nxt ;
wire  [FIFO_ADDR_WID-1:0]     rd_rptr_gray_nxt ;

wire  [FIFO_ADDR_WID-1:0]     rd_wptr_gray ;
wire  [FIFO_ADDR_WID-1:0]     rd_wptr_bin ;
wire  [FIFO_ADDR_WID-1:0]     wr_rptr_gray ;
wire  [FIFO_ADDR_WID-1:0]     wr_rptr_bin ;
wire  [FIFO_ADDR_WID-1:0]     wr_rptr_gray_compare ;

wire  [FIFO_COUNT_MSB:0]      wr_numfilled;

wire                          wrstrobe;
wire                          rdstrobe;

////////////////////////////////////////////////////////////
// Generate Read Pointer / Gray Encoding

always_ff @(posedge clk_read or negedge rst_read_n)
if (!rst_read_n)
begin
  rd_rptr_bin_reg  <= {FIFO_ADDR_WID{1'b0}};
  rd_rptr_gray_reg <= {FIFO_ADDR_WID{1'b0}};
end
else
begin
  rd_rptr_bin_reg  <= rd_soft_reset ? rd_wptr_bin : rd_rptr_bin_nxt;
  rd_rptr_gray_reg <= rd_rptr_gray_nxt;
end


assign rd_rptr_bin_nxt = !rd_empty ? rd_rptr_bin_reg + rdstrobe : rd_rptr_bin_reg;
assign rd_rptr_gray_nxt = (rd_rptr_bin_nxt>>1) ^ rd_rptr_bin_nxt; // binary-to-gray conversion

// Generate Read Pointer / Gray Encoding
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Generate Write Pointer / Gray Encoding

always_ff @(posedge clk_write or negedge rst_write_n)
if (!rst_write_n)
begin
  wr_wptr_bin_reg  <= {FIFO_ADDR_WID{1'b0}};
  wr_wptr_gray_reg <= {FIFO_ADDR_WID{1'b0}};
end
else
begin
  wr_wptr_bin_reg  <= wr_soft_reset ? wr_rptr_bin : wr_wptr_bin_nxt;
  wr_wptr_gray_reg <= wr_wptr_gray_nxt;
end

assign wr_wptr_bin_nxt  = !wr_full ? wr_wptr_bin_reg + wrstrobe : wr_wptr_bin_reg;
assign wr_wptr_gray_nxt = (wr_wptr_bin_nxt>>1) ^ wr_wptr_bin_nxt; // binary-to-gray conversion

// Generate Write Pointer / Gray Encoding
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Async conversions

// Level sync converts one bit from one domain to another
// The generate commands generate X number of level syncs.
// Note that there is a basic assumption that if a legitimate
// gray scale counter is firing on one clock, that clock speed
// is slow enough that it does not violate the setup/hold of the
// capturing clock.  If that assumption is not maintained, then
// the "gray" coding could have more than 1 transaction, and
// this entire design fails.  Of course, if the clock
// is faster than setup/hold, I'm not sure how anything is
// working.

genvar index0;
generate
	for(index0=0; index0<FIFO_ADDR_WID; index0=index0+1)
	begin : generate_levelsync_wr_rptr
          levelsync #(.RESET_VALUE(1'b0)) levelsync_wr_rptr (
               .dest_data  (wr_rptr_gray[index0]),
               .clk_dest   (clk_write),
               .rst_dest_n (rst_write_n),
               .src_data   (rd_rptr_gray_reg[index0]) );
	end
endgenerate

genvar index1;
generate
	for(index1=0; index1<FIFO_ADDR_WID; index1=index1+1)
	begin : generate_levelsync_rd_wptr
          levelsync #(.RESET_VALUE(1'b0)) levelsync_rd_wptr (
               .dest_data  (rd_wptr_gray[index1]),
               .clk_dest   (clk_read),
               .rst_dest_n (rst_read_n),
               .src_data   (wr_wptr_gray_reg[index1]) );
	end
endgenerate

// Async conversions
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Generate Full, Empty.

// Empty is easy, do the pointers match (one bit larger than needed for equal)
// If so, then we're empty.

// Full is tricky.  Assume we have 8 deep FIFO, so we _need_ 3 bit for address.
// We add one more bit for full/empty, so we have 4 bits, like:
//
// 0000    0
// 0001    1
// 0011    2
// 0010    3
// 0110    4
// 0111    5
// 0101    6
// 0100    7
//
// 1100    8
// 1101    9
// 1111    a
// 1110    b
// 1010    c
// 1011    d
// 1001    e
// 1000    f
//
//
// Well, if we start from 0, and push 8 entries in, the wptr = 1100.  But, the
// symetricness (is that a word?) of gray says the most sig 2 bits are the inverse
// of the lower "half".  So, if the rptr = 0000, then we are full.  Likewise with
// push 10, pop 2 (assuming no overflow), then we have wptr=1111, rptr=0011.  Invert
// the upper 2 and compare.
//

assign rd_empty = (rd_rptr_gray_reg == rd_wptr_gray) ;

// assign wr_full =  (wr_wptr_gray_reg == {~wr_rptr_gray [FIFO_ADDR_WID-1:FIFO_ADDR_WID-2],
//                                       wr_rptr_gray [FIFO_ADDR_WID-3:0]               } );

assign wr_rptr_gray_compare = wr_rptr_gray ^ (2'b11 << FIFO_ADDR_WID-2);
assign wr_full =  (wr_wptr_gray_reg == wr_rptr_gray_compare );  // This supports depth of 2.


assign wr_overflow_pulse  = write_push & wr_full;
assign rd_underflow_pulse = read_pop & rd_empty;

assign wrstrobe  = write_push & !wr_full;
assign rdstrobe  = read_pop   & !rd_empty;
// Generate Full, Empty.
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Counters (if not needed, do not connect and will synth away)
// This uses a bunch more logic because we have
// to convert from gray back to binary.

assign rd_wptr_bin = f_gray2binary (rd_wptr_gray);
assign wr_rptr_bin = f_gray2binary (wr_rptr_gray);

assign rd_numfilled = (rd_wptr_bin  - rd_rptr_bin_reg);
assign wr_numfilled = (wr_wptr_bin_reg - wr_rptr_bin);
assign wr_numempty  = (FIFO_DEPTH_WID - wr_numfilled);


function automatic [FIFO_ADDR_WID-1:0] f_gray2binary;
input [FIFO_ADDR_WID-1:0] gray;

reg  [FIFO_ADDR_WID-1:0]      binary;
reg  [FIFO_ADDR_WID-1:0]      index_i;
reg  [FIFO_ADDR_WID-1:0]      index_j;
begin
  binary = gray;

  for(index_i=0; index_i<FIFO_ADDR_WID; index_i=index_i+1)
    for(index_j=index_i+1; index_j<FIFO_ADDR_WID; index_j=index_j+1)
      binary[index_i] = ^{binary[index_i], gray[index_j]};

  f_gray2binary = binary;

end
endfunction

// Counters (if not needed, do not connect and will synth away)
////////////////////////////////////////////////////////////

   syncfifo_mem1r1w
   #(.FIFO_WIDTH_WID (FIFO_WIDTH_WID),
     .FIFO_DEPTH_WID (FIFO_DEPTH_WID))
   syncfifo_mem1r1w_i (
        .rddata       (rddata)          ,
        .clk_write    (clk_write)       ,
        .clk_read     (clk_read)        ,
        .rst_write_n  (rst_write_n)     ,
        .rst_read_n   (rst_read_n)      ,
        .rdaddr       (rd_rptr_bin_reg [FIFO_ADDR_WID-2:0]),
        .wraddr       (wr_wptr_bin_reg [FIFO_ADDR_WID-2:0]),
        .wrdata       (wrdata),
        .wrstrobe     (wrstrobe) );

////////////////////////////////////////////////////////////
//Debug

//Debug
////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////
// Sim Debug
// synopsys translate_off
`ifdef FOR_SIM_ONLY

  initial
  begin
    if ((FIFO_DEPTH_WID !== 1024) &
        (FIFO_DEPTH_WID !==  512) &
        (FIFO_DEPTH_WID !==  256) &
        (FIFO_DEPTH_WID !==  128) &
        (FIFO_DEPTH_WID !==   64) &
        (FIFO_DEPTH_WID !==   32) &
        (FIFO_DEPTH_WID !==   16) &
        (FIFO_DEPTH_WID !==    8) &
        (FIFO_DEPTH_WID !==    4) &
        (FIFO_DEPTH_WID !==    2) )
      begin
        $display ("ERROR: %m:  Invalid config of ASYNC FIFO.  Depth must be exponent of 2, not %d", FIFO_DEPTH_WID);
        $finish;
      end
  end

  always @(posedge clk_read)
  if (rd_underflow_pulse === 1'b1)
  begin
    $display ("WARNING:  %m suffered an underflow at time %0d", $time);
  end

  always @(posedge clk_write)
  if (wr_overflow_pulse === 1'b1)
  begin
    $display ("WARNING:  %m suffered an overflow at time %0d", $time);
  end

`endif // `ifdef FOR_SIM_ONLY
// synopsys translate_on

// Sim Debug
////////////////////////////////////////////////////////////


endmodule // asyncfifo //

////////////////////////////////////////////////////////////
//Module:	asyncfifo
//$Id$
////////////////////////////////////////////////////////////

// Local Variables:
// verilog-library-directories:("../*" "../../*")
// End:
//

`endif
