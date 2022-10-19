`ifndef _COMMON_RST_REGEN_LOW_SV
`define _COMMON_RST_REGEN_LOW_SV
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
module rst_regen_low
(
 clk,
 async_rst_n, rst_n
);

  input  clk;          // Clock
  input  async_rst_n;  // Asynchronous Reset Signal Input (active-low)
  output rst_n;         // Synchronized Reset Signal Output (active-low)

  levelsync
    #(
      .RESET_VALUE(1'b0)
     ) levelsync_i
     (
      .clk_dest   (clk),
      .rst_dest_n (async_rst_n),
      .src_data   (1'b1),
      .dest_data  (rst_n)
     );

endmodule // rst_regen_low

`endif
