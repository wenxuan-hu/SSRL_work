`ifndef _COMMON_LEVELSYNC_SV
`define _COMMON_LEVELSYNC_SV
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
//  This seems like a trivial block, just two FF in a row.
// However, for timing checks / gate level sims, etc.,  it
// is _VERY_ advantageous to have all of these in a known local.
// like inside these blocks.
//
//  It is concieveable we may want to hardcode this, so that
// we can forcibly apply don't touches, etc. to specific
// instances.
//
//  Note, to add in "realistic" simulation events,
// we add a semi-random delay to the "input" of the first
// FF.  This represents the uncertain nature of the async
// sampling (i.e. the clk_dest fires too soon to get the
// latest src_data).  We do this by adding a # delay.
//
// Note that in true, legit synthesis, the #delay would
// be synthesized away.  Still, I like the minimize the
// number of synthesis warnings, so I only enable this
// during simulations.
//
////////////////////////////////////////////////////////////

module levelsync
   (/*AUTOARG*/
   //Outputs
   dest_data,
   //Inputs
   clk_dest, rst_dest_n, src_data
   );

parameter RESET_VALUE = 1'b0;

input   rst_dest_n;
input   clk_dest;
input   src_data;

output  dest_data;

reg             AsYnCiNpUt_ff0_reg;
wire            src_data_input;
reg             ff1_reg;

always_ff @(posedge clk_dest or negedge rst_dest_n)
if (!rst_dest_n)
begin
  AsYnCiNpUt_ff0_reg <= RESET_VALUE;
  ff1_reg <= RESET_VALUE;
end
else
begin
  AsYnCiNpUt_ff0_reg <= src_data_input;
  ff1_reg <= AsYnCiNpUt_ff0_reg;
end


`ifndef SIM_LEVELSYNC_ADD_DELAY
assign src_data_input = src_data;
`else // `ifndef SIM_LEVELSYNC_ADD_DELAY

wire src_data_input_delay;
reg [3:0] lsfr4_reg ;
initial lsfr4_reg = $random | 4'h1 ; // Non-zero start for 4 bit LSFR

always_ff @(posedge clk_dest)
begin
  lsfr4_reg [3:1] <= lsfr4_reg [2:0];
  lsfr4_reg [0]   <= lsfr4_reg [3] ^ lsfr4_reg [2] ;
end

assign #(`SIM_LEVELSYNC_ADD_DELAY) src_data_input_delay = src_data;

// ~50/50 chance of delay
assign src_data_input = lsfr4_reg[0]  ? src_data : src_data_input_delay;

`endif // `ifndef SIM_LEVELSYNC_ADD_DELAY





assign dest_data = ff1_reg;

// synopsys translate_off
`ifdef FIND_DFT_ASYNC
initial $display("ASYNC:levelsync:%m");
`endif //FIND_DFT
// synopsys translate_on


endmodule // levelsync //

////////////////////////////////////////////////////////////
//Module:	levelsync
//$Id$
////////////////////////////////////////////////////////////

`endif
