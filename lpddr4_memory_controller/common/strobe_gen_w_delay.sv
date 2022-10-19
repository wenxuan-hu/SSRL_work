`ifndef _COMMON_STROBE_GEN_W_DELAY_SV
`define _COMMON_STROBE_GEN_W_DELAY_SV
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

module strobe_gen_w_delay (

    input logic         clk,
    input logic         rst_n,

    input logic  [15:0] interval,          // Set to 0 for back to back strobes. Otherwise, interval is the time between strobes (so if you want a strobe every 10 cycles, set to 9)
    input logic  [15:0] delay_value,       // Delay after online before we start sending strobes.
    input logic         user_marker,       // Effectiely the OR reduction of all user_marker bits. We only increment strobe count when we send a remote side word
    input logic         online,            // Set to 1 to begin strobe generation (0 to stop)

    output logic        user_strobe

   );


logic delayed_online;


   level_delay level_delay (
        .delayed_en  (delayed_online),
        .clk_core    (clk),
        .rst_core_n  (rst_n),
        .enable      (online),
        .delay_value (delay_value) );

   strobe_gen strobe_gen (
        .user_strobe    (user_strobe),
        .clk            (clk),
        .rst_n          (rst_n),
        .interval       (interval),
        .user_marker    (user_marker),
        .online         (delayed_online) );


endmodule // strobe_gen_w_delay //

////////////////////////////////////////////////////////////
//Module:	level_delay
//$Id$
////////////////////////////////////////////////////////////

`endif
