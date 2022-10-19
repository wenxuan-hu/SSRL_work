`ifndef _COMMON_SYNCFIFO_MEM1R1W_SV
`define _COMMON_SYNCFIFO_MEM1R1W_SV
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
// This is a simple module that implements a set of FF
// that behaves as a 1 read 1 write RAM. It is coded such
// that FPGAs should emulate a RAM, ASICs should instantiate
// an array of FF and can be replaced with real RAMs or
// packed FF arrays as layout desires.
//
// It is highly parameterizable and is used in FIFOs.
//
// It does not support bit or byte masking on the writes.
//
////////////////////////////////////////////////////////////

module syncfifo_mem1r1w
   (/*AUTOARG*/
   //Outputs
   rddata,
   //Inputs
   clk_write, clk_read, rst_write_n, rst_read_n, rdaddr, wraddr, wrdata, wrstrobe
   );

////////////////////////////////////////////////////////////
//  User modifyable parts
parameter FIFO_WIDTH_WID = 32;
parameter FIFO_DEPTH_WID = 4;
//  User modifyable parts
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
//  Do Not Modify
// In unique case of depth = 1, $clog2 returns 0, which is unhelpful.
// While it can be argued that write and read pointers could be removed for a 1 deep FIFO,
// it is far more scalable to require always having a minimum of a 1 bit pointer, even if
// there is only one legitimate value.
localparam FIFO_ADDR_WID   = ((FIFO_DEPTH_WID == 1) ? 1 : $clog2(FIFO_DEPTH_WID)  ) ;

localparam FIFO_WIDTH_MSB = FIFO_WIDTH_WID - 1 ;
localparam FIFO_DEPTH_MSB = FIFO_DEPTH_WID - 1 ;
localparam FIFO_ADDR_MSB  = FIFO_ADDR_WID  - 1 ;
//  Do Not Modify
////////////////////////////////////////////////////////////

input                           clk_write;
input                           rst_write_n;
input                           clk_read;
input                           rst_read_n;

input                           wrstrobe;
input [FIFO_WIDTH_MSB:0]        wrdata;
input [FIFO_ADDR_MSB:0]         wraddr;
input [FIFO_ADDR_MSB:0]         rdaddr;
output [FIFO_WIDTH_MSB:0]       rddata;



reg [FIFO_WIDTH_MSB:0] memory [FIFO_DEPTH_MSB:0];
reg [FIFO_WIDTH_MSB:0] rddata;

`ifdef FPGA

  integer unsigned index0;

  always @(posedge clk_write)
  begin
    if (wrstrobe)
      memory[wraddr] <= wrdata;
  end

  always @(posedge clk_read)
  begin
     rddata <= memory[rdaddr] ;
  end

`else

  integer unsigned index0;

  always_ff @(posedge clk_write or negedge rst_write_n)
  if (!rst_write_n)
  begin
    for (index0 = 0; index0 < FIFO_DEPTH_WID ; index0 = index0 + 1)
      memory[index0] <= {FIFO_WIDTH_WID{1'b0}};
  end
  else if (wrstrobe)
  begin
    memory[wraddr] <= wrdata;
  end

  always_ff @(posedge clk_read or negedge rst_read_n)
  if (!rst_read_n)
  begin
    rddata <= {FIFO_WIDTH_WID{1'b0}};
  end
  else
  begin
     rddata <= memory[rdaddr] ;
  end

`endif


endmodule // syncfifo_mem1r1w //

////////////////////////////////////////////////////////////
//Module:	syncfifo_mem1r1w
//$Id$
////////////////////////////////////////////////////////////

`endif
