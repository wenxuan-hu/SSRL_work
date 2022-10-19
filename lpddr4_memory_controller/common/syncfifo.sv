`ifndef _COMMON_SYNCFIFO_SV
`define _COMMON_SYNCFIFO_SV
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

module syncfifo
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

localparam FIFO_DEPTH_REG_WID   = (FIFO_DEPTH_WID <= 2) ? FIFO_DEPTH_WID : 2;
localparam FIFO_DEPTH_RAM_WID  = (FIFO_DEPTH_WID <= 2) ? 0              : (FIFO_DEPTH_WID-2) ;
localparam FIFO_COUNT_WID      = ((FIFO_DEPTH_WID == 1)     ? 1 : $clog2(FIFO_DEPTH_WID+1))     ; // The plus covers the full/empty case. Exponents of 2 depth will rquire an extra bit.
localparam FIFO_COUNT_REG_WID  = ((FIFO_DEPTH_REG_WID == 1) ? 1 : $clog2(FIFO_DEPTH_REG_WID+1)) ; // The plus covers the full/empty case. Exponents of 2 depth will rquire an extra bit.
localparam FIFO_COUNT_RAM_WID  = ((FIFO_DEPTH_RAM_WID == 1) ? 1 : $clog2(FIFO_DEPTH_RAM_WID+1)) ; // The plus covers the full/empty case. Exponents of 2 depth will rquire an extra bit.

localparam FIFO_WIDTH_MSB     = FIFO_WIDTH_WID     - 1 ;
localparam FIFO_COUNT_MSB     = FIFO_COUNT_WID     - 1 ;
localparam FIFO_COUNT_REG_MSB = FIFO_COUNT_REG_WID - 1 ;
localparam FIFO_COUNT_RAM_MSB = FIFO_COUNT_RAM_WID - 1 ;
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


wire                            empty_reg;
wire                            full_reg;
wire                            overflow_pulse_reg;
wire                            underflow_pulse_reg;
wire                            read_pop_reg;
wire                            write_push_reg;
wire [FIFO_COUNT_REG_MSB:0]     numempty_reg;
wire [FIFO_COUNT_REG_MSB:0]     numfilled_reg;
wire [FIFO_WIDTH_MSB:0]         rddata_reg;
wire [FIFO_WIDTH_MSB:0]         wrdata_reg;

wire                            fifo_ram_disabled;
wire                            empty_ram;
wire                            full_ram;
wire                            overflow_pulse_ram;
wire                            underflow_pulse_ram;
wire                            read_pop_ram;
wire                            write_push_ram;
wire [FIFO_COUNT_RAM_MSB:0]     numempty_ram;
wire [FIFO_COUNT_RAM_MSB:0]     numfilled_ram;
wire [FIFO_WIDTH_MSB:0]         rddata_ram;
wire [FIFO_WIDTH_MSB:0]         wrdata_ram;

reg                             read_popram_dly_reg;
reg                             write_empty_ram_dly1_reg;
reg                             ram_read_cornercase_reg;




   syncfifo_reg #(.FIFO_WIDTH_WID(FIFO_WIDTH_WID), .FIFO_DEPTH_WID(FIFO_DEPTH_REG_WID)) syncfifo_reg (
        .empty           (empty_reg),
        .full            (full_reg),
        .numempty        (numempty_reg),
        .numfilled       (numfilled_reg),
        .overflow_pulse  (overflow_pulse_reg),
        .underflow_pulse (underflow_pulse_reg),
        .rddata          (rddata_reg),
        .clk_core        (clk_core),
        .read_pop        (read_pop_reg),
        .rst_core_n      (rst_core_n),
        .soft_reset      (soft_reset),
        .wrdata          (wrdata_reg),
        .write_push      (write_push_reg) );


// Optionally instantiate RAM FIFO if deep enough
generate
   if (FIFO_DEPTH_RAM_WID > 0)
   begin
     assign fifo_ram_disabled = 0;

     syncfifo_ram #(.FIFO_WIDTH_WID(FIFO_WIDTH_WID), .FIFO_DEPTH_WID(FIFO_DEPTH_RAM_WID)) syncfifo_ram (
          .empty           (empty_ram),
          .full            (full_ram),
          .numempty        (numempty_ram),
          .numfilled       (numfilled_ram),
          .overflow_pulse  (overflow_pulse_ram),
          .underflow_pulse (underflow_pulse_ram),
          .rddata          (rddata_ram),
          .clk_core        (clk_core),
          .read_pop        (read_pop_ram),
          .rst_core_n      (rst_core_n),
          .soft_reset      (soft_reset),
          .wrdata          (wrdata_ram),
          .write_push      (write_push_ram) );
   end
   else
   begin
     assign fifo_ram_disabled = 1;
     assign empty_ram           = 1'b1                   ; // Setting both empty and full to 1 may seem
     assign full_ram            = 1'b1                   ; // nonsensical, but it optimizes the code away.
     assign overflow_pulse_ram  = 1'b0                   ;
     assign underflow_pulse_ram = 1'b0                   ;
     assign numempty_ram        = 1'b0                   ;
     assign numfilled_ram       = 1'b0                   ;
     assign rddata_ram          = {FIFO_WIDTH_WID{1'b0}} ;
   end

endgenerate


// ////////////////////////////////////////////////////////////////////
// // FIFO Control
//
//
// // The goal of this is to have a small register output stage of the FIFO that acts as a head of the FIFO.
// // This gives two benefits:
// // 1. Reduced latency for the first transaction.
// // 2. To hide the latench of the RAM Read sequence.
// //
// // In the simple case, we start with empty REG and RAM FIFOs. When we pop, we pop from
// // the REG. At the same time, we pop and entry from RAM to push into the REG. So in the
// // normal case, we always pop from the REG FIFO.
// //
// // However, in the unique case where the REG FIFO is filled and exactly 1 entry is
// // pushed into the RAM and the next cycle a steady stream of POPs occurs. The first
// // entry is popped out of the REG as per normal. However, because the write to the RAM
// // occurred in the previous cycle, the data is not available for reading yet (at least
// // assuming the RAM does not have a write through feature). So in this corner case,
// // we won't push to the REG. If the POP continues for a second cycle, then we'll start
// // reading directly from the RAM.
// // Eventually, we should stop popping. Once this happens,the RAM is popped one more time
// // to load the REG and we areback to the normal case.
//
//
// wire fifo_reg_gets_new_push;
// wire fifo_rampop_regpush_due2pop;
// wire fifo_rampop_due2_reg_not_head;     // Pop RAM because REG FIFO is notcurrent head of FIFO.
//
// assign fifo_reg_gets_new_push         = empty_ram & ((~full_reg) | read_pop);
// assign fifo_rampop_regpush_due2pop    = (read_pop & (~empty_ram) & ~write_empty_ram_dly1_reg);
// assign fifo_rampop_due2_reg_not_head  = (~empty_ram) & (~full_reg);
//
//
// assign write_push_reg = fifo_ram_disabled ? write_push :  (  (write_push &  fifo_reg_gets_new_push) | (fifo_rampop_regpush_due2pop & ~ram_read_cornercase_reg) | (fifo_rampop_due2_reg_not_head & (~read_pop))  );
// assign write_push_ram = fifo_ram_disabled ? 1'b0       :  (write_push & ~fifo_reg_gets_new_push) ;
//
// assign read_pop_reg   = read_pop & (~(read_pop_ram & ram_read_cornercase_reg));
// assign read_pop_ram   = fifo_rampop_regpush_due2pop | (fifo_rampop_due2_reg_not_head);
//
// assign rddata         = ram_read_cornercase_reg ? rddata_ram : rddata_reg;
//
// assign wrdata_reg     = read_pop_ram ? rddata_ram : wrdata;
// assign wrdata_ram     = wrdata;
//
// always @(posedge clk_core or negedge rst_core_n)
// if (~rst_core_n)
//   read_popram_dly_reg <= 1'b0;
// else
//   read_popram_dly_reg <= read_pop_ram;
//
// always @(posedge clk_core or negedge rst_core_n)
// if (~rst_core_n)
//   write_empty_ram_dly1_reg <= 1'b0;
// else
//   write_empty_ram_dly1_reg <= (write_push_ram & (empty_ram | ((numempty_ram == 1) & read_pop_ram)));
//
// always @(posedge clk_core or negedge rst_core_n)
// if (~rst_core_n)
//   ram_read_cornercase_reg <= 1'b0;
// else
//   ram_read_cornercase_reg <= (read_pop & write_empty_ram_dly1_reg) | (fifo_rampop_due2_reg_not_head & ram_read_cornercase_reg);
//
//
// assign numfilled = numfilled_ram + numfilled_reg + read_popram_dly_reg;
// assign numempty  = numempty_ram + numempty_reg - read_popram_dly_reg;
//
// assign full   = full_ram  & full_reg;
// assign empty  = empty_ram & empty_reg;
//
// assign overflow_pulse  = overflow_pulse_reg  | overflow_pulse_ram  ;
// assign underflow_pulse = underflow_pulse_reg | underflow_pulse_ram ;



////////////////////////////////////////////////////////////////////
// FIFO Control


// The goal of this is to have a small register output stage of the FIFO that acts as a head of the FIFO.
// This gives two benefits:
// 1. Reduced latency for the first transaction.
// 2. To hide the latench of the RAM Read sequence.
//
// In the simple case, we start with empty REG and RAM FIFOs. When we pop, we pop from
// the REG. At the same time, we pop and entry from RAM to push into the REG. So in the
// normal case, we always pop from the REG FIFO.
//
// However, in the unique case where the REG FIFO is filled and exactly 1 entry is
// pushed into the RAM and the next cycle a steady stream of POPs occurs. The first
// entry is popped out of the REG as per normal. However, because the write to the RAM
// occurred in the previous cycle, the data is not available for reading yet (at least
// assuming the RAM does not have a write through feature). So in this corner case,
// we won't push to the REG. If the POP continues for a second cycle, then we'll start
// reading directly from the RAM.
// Eventually, we should stop popping. Once this happens,the RAM is popped one more time
// to load the REG and we are back to the normal case.


wire fifo_reg_gets_new_push;
wire fifo_rampop_regpush_due2pop;
wire fifo_rampop_due2_reg_not_head;     // Pop RAM because REG FIFO is notcurrent head of FIFO.

assign fifo_reg_gets_new_push         = empty_ram & ((~full_reg) | read_pop);
assign fifo_rampop_regpush_due2pop    = (read_pop & (~empty_ram) & ~write_empty_ram_dly1_reg);
assign fifo_rampop_due2_reg_not_head  = (~empty_ram) & (~full_reg);

assign write_push_reg = fifo_ram_disabled ? write_push :  (  (write_push &  fifo_reg_gets_new_push) | (fifo_rampop_regpush_due2pop & ~ram_read_cornercase_reg) | (fifo_rampop_due2_reg_not_head & (~read_pop))  );
assign write_push_ram = fifo_ram_disabled ? 1'b0       :  (write_push & ~fifo_reg_gets_new_push) ;

assign read_pop_reg   = read_pop & (~(read_pop_ram & ram_read_cornercase_reg));
assign read_pop_ram   = fifo_rampop_regpush_due2pop | (fifo_rampop_due2_reg_not_head);

assign rddata         = ram_read_cornercase_reg ? rddata_ram : rddata_reg;

assign wrdata_reg     = read_pop_ram ? rddata_ram : wrdata;
assign wrdata_ram     = wrdata;

always @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  read_popram_dly_reg <= 1'b0;
else if (soft_reset)
  read_popram_dly_reg <= 1'b0;
else
  read_popram_dly_reg <= read_pop_ram;

always @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  write_empty_ram_dly1_reg <= 1'b0;
else if (soft_reset)
  write_empty_ram_dly1_reg <= 1'b0;
else
  write_empty_ram_dly1_reg <= (write_push_ram & (empty_ram | ((numempty_ram == 1) & read_pop_ram)));

always @(posedge clk_core or negedge rst_core_n)
if (~rst_core_n)
  ram_read_cornercase_reg <= 1'b0;
else if (soft_reset)
  ram_read_cornercase_reg <= 1'b0;
else
  ram_read_cornercase_reg <= ((read_pop & write_empty_ram_dly1_reg) | (fifo_rampop_due2_reg_not_head & ram_read_cornercase_reg)) & (empty_reg) ;


// assign numfilled = numfilled_ram + numfilled_reg + read_popram_dly_reg;
// assign numempty  = numempty_ram + numempty_reg - read_popram_dly_reg;

assign numfilled = numfilled_ram + numfilled_reg ;
assign numempty  = numempty_ram + numempty_reg ;

assign full   = full_ram  & full_reg;
assign empty  = empty_ram & empty_reg;

assign overflow_pulse  = overflow_pulse_reg  | overflow_pulse_ram  ;
assign underflow_pulse = underflow_pulse_reg | underflow_pulse_ram ;





endmodule // syncfifo //

////////////////////////////////////////////////////////////
//Module:	syncfifo
//$Id$
////////////////////////////////////////////////////////////

`endif
