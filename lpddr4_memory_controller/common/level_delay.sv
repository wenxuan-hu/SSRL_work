`ifndef _COMMON_LEVEL_DELAY_SV
`define _COMMON_LEVEL_DELAY_SV
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
//  This is a simple delay element that implements an 8 bit counter
// that waits for enable to go high to begin counting. Once it
// Reaches delay_value, it will set delayed_en high. If enable
// goes back low, the counter resets. The counter does a simple
// compare to delay_value, so changing delay_value on the fly can
// have unpredictable results. delay_value == 0 necessarily means
// the counter is unused and should be synthesized away (assuming
// delay_value is a constant).
//
// It is assumed enable is synchronized to clk_core.
//
////////////////////////////////////////////////////////////

module level_delay
   (/*AUTOARG*/
   //Outputs
   delayed_en,
   //Inputs
   clk_core, rst_core_n, enable, delay_value
   );

input           rst_core_n;
input           clk_core;
input           enable;
input [15:0]    delay_value;

output          delayed_en;

reg  [15:0]     count_reg;
reg             count_eq_dlyval_reg;

always_ff @(posedge clk_core or negedge rst_core_n)
if (!rst_core_n)
  count_reg <= 16'h0;
else if (~enable)
  count_reg <= 16'h0;
else if (count_reg != delay_value)
  count_reg <= (count_reg + 16'h1);

always_ff @(posedge clk_core or negedge rst_core_n)
if (!rst_core_n)
  count_eq_dlyval_reg <= 1'h0;
else if (~enable)
  count_eq_dlyval_reg <= 1'h0;
else
  count_eq_dlyval_reg <= (count_reg == delay_value);

// Note: delay_value == 0 in the following should resolve as a constant
// So the logic below should result in either enable (top level IO) or a register.
assign delayed_en = (delay_value == 16'h0) ? enable : count_eq_dlyval_reg ;

endmodule // level_delay //

////////////////////////////////////////////////////////////
//Module:	level_delay
//$Id$
////////////////////////////////////////////////////////////

`endif

