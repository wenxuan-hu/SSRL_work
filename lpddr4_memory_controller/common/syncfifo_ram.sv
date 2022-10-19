`ifndef _COMMON_SYNCFIFO_RAM_SV
`define _COMMON_SYNCFIFO_RAM_SV
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
//   Attempt at one FIFO to rule them all.  Use the full/empty if you
// only care about "is there data / space".  Use the numfilled / numempty
// to determine how many entries are currently on the FIFO / how many spaces
// are available.  The numfilled/numempty will (obviously?) use more gates
// than just full/empty.
//
//   These were meant to be used mutually exclusively.  If you dont want
// numfilled/empty, don't connect.  Synthesis should remove the rest.
//
//   In the case where an a push will result in an overflow, the
// newly arrived data will be dropped.
//
//   FIFO_DEPTH_WID is the actual depth (in human numbers) desired.
//                  It cannot be greater than 1023, but may be any
//                  other integer.
//   FIFO_COUNT_WID is similar to the address width, but has room to
//                  indicate full and empty (i.e. one more bit than
//                  FIFO_ADDR_WID)
////////////////////////////////////////////////////////////

module syncfifo_ram
   (/*AUTOARG*/
   //Outputs
   empty, full, numempty, numfilled, overflow_pulse, rddata, underflow_pulse,
   //Inputs
   clk_core, read_pop, rst_core_n, wrdata, write_push, soft_reset
   );

////////////////////////////////////////////////////////////
//  User modifiable parts
parameter FIFO_WIDTH_WID = 32;
parameter FIFO_DEPTH_WID = 4;
//  User modifiable parts
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//  Do Not Modify
// In unique case of depth = 1, $clog2 returns 0, which is unhelpful.
// While it can be argued that write and read pointers could be removed for a 1 deep FIFO,
// it is far more scalable to require always having a minimum of a 1 bit pointer, even if
// there is only one legitimate value.
localparam FIFO_ADDR_WID   = ((FIFO_DEPTH_WID == 1) ? 1 : $clog2(FIFO_DEPTH_WID)  ) ;
localparam FIFO_COUNT_WID  = ((FIFO_DEPTH_WID == 1) ? 1 : $clog2(FIFO_DEPTH_WID+1)) ; // The plus covers the full/empty case. Exponents of 2 depth will rquire an extra bit.

localparam FIFO_WIDTH_MSB = FIFO_WIDTH_WID - 1 ;
localparam FIFO_DEPTH_MSB = FIFO_DEPTH_WID - 1 ;
localparam FIFO_ADDR_MSB  = FIFO_ADDR_WID  - 1 ;
localparam FIFO_COUNT_MSB = FIFO_COUNT_WID  - 1 ;
//  Do Not Modify
////////////////////////////////////////////////////////////

input                           clk_core;
input                           rst_core_n;
input                           soft_reset;

input                           write_push;          // Read data.
input [FIFO_WIDTH_MSB:0]        wrdata;              // Write Data.
input                           read_pop;            // Write push (validates write data)
output [FIFO_WIDTH_MSB:0]       rddata;              // Read Pop (advances to _next_ read data).

output [FIFO_COUNT_MSB:0]       numfilled;
output [FIFO_COUNT_MSB:0]       numempty;

output                          full;                // Full signal
output                          empty;               // Empty signal

output                          overflow_pulse;      // Overflow signal
output                          underflow_pulse;     // Underflow signal


reg [FIFO_ADDR_MSB:0]           write_addr_reg;
reg [FIFO_ADDR_MSB:0]           write_addr_nxt;
reg [FIFO_ADDR_MSB:0]           read_addr_reg;
reg [FIFO_ADDR_MSB:0]           read_addr_nxt;

reg [FIFO_COUNT_MSB:0]          numfilled_reg;
reg [FIFO_COUNT_MSB:0]          numempty_reg;
reg [FIFO_COUNT_MSB:0]          numfilled_nxt;
reg [FIFO_COUNT_MSB:0]          numempty_nxt;

wire                            wrstrobe;
wire                            rdstrobe;

////////////////////////////////////////////////////////////
// Write FIFO Address
always_comb
if (wrstrobe & (write_addr_reg == FIFO_DEPTH_MSB))
  write_addr_nxt = {FIFO_ADDR_WID{1'b0}};
else if (wrstrobe)
  write_addr_nxt = write_addr_reg + 1;
else
  write_addr_nxt = write_addr_reg ;

always_ff @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  write_addr_reg <= {FIFO_ADDR_WID{1'b0}};
else if (soft_reset)
  write_addr_reg <= {FIFO_ADDR_WID{1'b0}};
else
  write_addr_reg <= write_addr_nxt;
// Write FIFO Address
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Read FIFO Address
always_comb
if (rdstrobe & (read_addr_reg == FIFO_DEPTH_MSB))
  read_addr_nxt = {FIFO_ADDR_WID{1'b0}};
else if (rdstrobe)
  read_addr_nxt = read_addr_reg + 1;
else
  read_addr_nxt = read_addr_reg;

always_ff @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  read_addr_reg <= {FIFO_ADDR_WID{1'b0}};
else if (soft_reset)
  read_addr_reg <= {FIFO_ADDR_WID{1'b0}};
else
  read_addr_reg <= read_addr_nxt;
// Read FIFO Address
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Counters (if not needed, do not connect and will synth away)
always_comb
if (rdstrobe & wrstrobe)
  numfilled_nxt = numfilled_reg;
else if (wrstrobe)
  numfilled_nxt = numfilled_reg + 1;
else if (rdstrobe)
  numfilled_nxt = numfilled_reg - 1;
else
  numfilled_nxt = numfilled_reg;

always_comb
if (rdstrobe & wrstrobe)
  numempty_nxt = numempty_reg;
else if (wrstrobe)
  numempty_nxt = numempty_reg - 1;
else if (rdstrobe)
  numempty_nxt = numempty_reg + 1;
else
  numempty_nxt = numempty_reg;

always_ff @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
begin
  numfilled_reg <= {FIFO_COUNT_WID{1'b0}};
  numempty_reg  <= FIFO_DEPTH_WID;
end
else if (soft_reset)
begin
  numfilled_reg <= {FIFO_COUNT_WID{1'b0}};
  numempty_reg  <= FIFO_DEPTH_WID;
end
else
begin
  numfilled_reg <= numfilled_nxt;
  numempty_reg  <= numempty_nxt;
end

assign numfilled = numfilled_reg;
assign numempty = numempty_reg;
// Counters (if not needed, do not connect and will synth away)
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Full / Empty status
// // These are simplier versions of numfilled/empty
// // These use a state bit that indicates if the previous write-read addr was
// // aproaching 0 (EMPTY) or 0 (FULL).
// reg             fifo_data_filling;
// always_ff @(posedge clk_core or negedge rst_core_n)
// if (~rst_core_n)
//   fifo_data_filling <= 1'b0 ;
// else if (soft_reset)
//   fifo_data_filling <= 1'b0 ;
// else if ((write_addr_nxt == read_addr_nxt) & (rdstrobe & wrstrobe))  // Keeping pace... no change
//   fifo_data_filling <= fifo_data_filling ;
// else if ((write_addr_nxt == read_addr_nxt) & (           wrstrobe))  // Write caught up with read... full
//   fifo_data_filling <= 1'b1 ;
// else if ((write_addr_nxt == read_addr_nxt) & (rdstrobe           ))  // Read caught up with write... empty
//   fifo_data_filling <= 1'b0 ;


// The following is implemented two ways, combinatorial and register based.
// The register based is more timing closure friendly, but both are functional.
// wire full_comb;
// wire empty_comb;
reg full_reg;
reg empty_reg;

always_ff @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  full_reg <= 1'b0 ;
else if (soft_reset)
  full_reg <= 1'b0 ;
else if ((write_addr_nxt == read_addr_nxt) & (rdstrobe & wrstrobe))  // Keeping pace... no change
  full_reg <= full_reg ;
else if ((write_addr_nxt == read_addr_nxt) & (           wrstrobe))  // Write caught up with read... full
  full_reg <= 1'b1 ;
else if ((write_addr_nxt != read_addr_nxt) | (rdstrobe           ))
  full_reg <= 1'b0 ;

always_ff @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  empty_reg <= 1'b1 ;
else if (soft_reset)
  empty_reg <= 1'b1 ;
else if ((write_addr_nxt == read_addr_nxt) & (rdstrobe & wrstrobe))  // Keeping pace... no change
  empty_reg <= empty_reg ;
else if ((write_addr_nxt == read_addr_nxt) & (rdstrobe           ))  // Read caught up with write... empty
  empty_reg <= 1'b1 ;
else if ((write_addr_nxt != read_addr_nxt) | (           wrstrobe))
  empty_reg <= 1'b0 ;

// assign full_comb  = (write_addr_reg == read_addr_reg) &  fifo_data_filling;
// assign empty_comb = (write_addr_reg == read_addr_reg) & !fifo_data_filling;

assign full   = full_reg;
assign empty  = empty_reg;

// Full / Empty status
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Overflow / Underflow
assign overflow_pulse  = write_push & !read_pop & full;
assign underflow_pulse =               read_pop & empty;

assign wrstrobe = write_push ;
assign rdstrobe = read_pop   ;
// Overflow / Underflow
////////////////////////////////////////////////////////////

   syncfifo_mem1r1w
   #(.FIFO_WIDTH_WID (FIFO_WIDTH_WID),
     .FIFO_DEPTH_WID (FIFO_DEPTH_WID))
   syncfifo_mem1r1w_i (
        .rddata       (rddata)         ,
        .clk_write    (clk_core)       ,
        .clk_read     (clk_core)       ,
        .rst_write_n  (rst_core_n)     ,
        .rst_read_n   (rst_core_n)     ,
        .rdaddr       (read_addr_nxt)  ,
        .wraddr       (write_addr_reg) ,
        .wrdata       (wrdata)         ,
        .wrstrobe     (wrstrobe)       ) ;


////////////////////////////////////////////////////////////
// Internal Debug

// synopsys translate_off
`ifdef FOR_SIM_ONLY

always @(posedge clk_core)
if (underflow_pulse === 1'b1)
begin
  $display ("WARNING:  %m suffered an underflow at time %0d", $time);
end

always @(posedge clk_core)
if (overflow_pulse === 1'b1)
begin
  $display ("WARNING:  %m suffered an overflow at time %0d", $time);
end

`endif // `ifdef FOR_SIM_ONLY
// synopsys translate_on

// Internal Debug
////////////////////////////////////////////////////////////

endmodule // syncfifo //

////////////////////////////////////////////////////////////
//Module:	syncfifo
//$Id$
////////////////////////////////////////////////////////////

`endif
