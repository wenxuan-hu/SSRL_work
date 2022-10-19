`ifndef _COMMON_RRARB_SV
`define _COMMON_RRARB_SV
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
////////////////////////////////////////////////////////////
//
//Functional Descript:
//  Round Robin arbiter.  Has max of 1024 entries.
//  After reset, req 0 is highest priority.
//  The REQUEST -> GRANT is async (no combinatoriarl), but does not
// "advance" unless the advance is set.
//
////////////////////////////////////////////////////////////

// FIXME, ADD a hold to hold grant outputs

module rrarb
   (/*AUTOARG*/
   //Outputs
   grant,
   //Inputs
   advance, clk_core, requestor, rst_core_n
   );

////////////////////////////////////////////////////////////
//  User modifyable parts
parameter REQUESTORS = 4;
//  User modifyable parts
////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////
//  Do Not Modify
parameter REQ_ADDR_WID = (REQUESTORS > 1024) ?  0 :  // Invalid
                         (REQUESTORS > 512)  ? 10 :
                         (REQUESTORS > 256)  ?  9 :
                         (REQUESTORS > 128)  ?  8 :
                         (REQUESTORS >  64)  ?  7 :
                         (REQUESTORS >  32)  ?  6 :
                         (REQUESTORS >  16)  ?  5 :
                         (REQUESTORS >   8)  ?  4 :
                         (REQUESTORS >   4)  ?  3 :
                         (REQUESTORS >   2)  ?  2 : 1 ;

parameter REQ_ADDR_MSB = REQ_ADDR_WID - 1 ;

parameter NUM_REQ_WID = REQUESTORS ;
parameter NUM_REQ_MSB = NUM_REQ_WID - 1 ;
//  Do Not Modify
////////////////////////////////////////////////////////////


input                           clk_core;
input                           rst_core_n;

input  [REQUESTORS-1:0]         requestor;     // List of valid requestor
input                           advance;        // If set, the arbitration advances.
output [REQUESTORS-1:0]         grant;          // Onehotish (0 is valid) grant.  Combinatorial from req to grant


reg [REQUESTORS-1:0]            grant;

wire [NUM_REQ_MSB:0]            req_msb_masked;
wire [NUM_REQ_MSB:0]            req_mask;

reg [REQ_ADDR_MSB:0]            last_grantaddr_reg;


// Everything "higher" than the last_grantaddr_reg has higher priority.
// So, we first get the higher priority by masking out the lower priority.

assign req_mask = {{REQUESTORS{1'b1}},1'b0} << last_grantaddr_reg; // spyglass disable W486
assign req_msb_masked = requestor & req_mask;


// The actual arbitration.
// If we have something in the "high priority" section, then use it.
// otherwise, use the full (i.e. low priority) section.
// This is LIVE, so timing critical.
always_comb
if (|req_msb_masked)
  grant = find_leading_one (req_msb_masked);
else
  grant = find_leading_one (requestor);


always_ff @(posedge clk_core or negedge rst_core_n)
if (!rst_core_n)
  last_grantaddr_reg <= {REQ_ADDR_WID{1'b1}};  // Default to Req 0 having highest priority
else if (advance & (|requestor))
  last_grantaddr_reg <= convert_onehot_to_addr (grant);










// function automatic [NUM_REQ_MSB:0] addr_to_onehot;
// input [REQ_ADDR_MSB:0] req;
// begin
//   addr_to_onehot = {{NUM_REQ_MSB{1'b0}},1'b1}<<req;
// end
// endfunction

function automatic [REQ_ADDR_MSB:0] convert_onehot_to_addr;
input [NUM_REQ_MSB:0]   onehot;
reg                     found_lead_one;
reg   [REQ_ADDR_MSB:0]  address;
integer unsigned        temp_variable;
begin

  found_lead_one = 0;
  address = 0;
  // $display ("onehot %b", onehot);
  for (temp_variable=0 ; temp_variable<NUM_REQ_WID ; temp_variable=temp_variable+1)
  begin
    if (onehot[temp_variable] & ~found_lead_one)
    begin
      address = temp_variable; // spyglass disable W310
      found_lead_one = 1;
    end
  end

  convert_onehot_to_addr = address;
end
endfunction



function automatic [NUM_REQ_MSB:0] find_leading_one;
input [NUM_REQ_MSB:0] requestor;
reg   [NUM_REQ_MSB:0] previous_requestor;
reg   [NUM_REQ_MSB:0] onehotish;
reg                  found_lead_one;
integer temp_variable;
begin
  // This is done purely for aesthetics.
  previous_requestor = {requestor[NUM_REQ_MSB-1:0],1'b0};
  found_lead_one = 0;

  // So, onehot X is set if requestor X is set and requestor X-1:0 are clear.
  // Verilog doesn't allow variables in bitwidths (stupid verilog), so we use the
  // variable found_lead_one

  for (temp_variable=0 ; temp_variable<NUM_REQ_WID ; temp_variable=temp_variable+1)
  begin
    onehotish [temp_variable] = requestor[temp_variable] & ~(|previous_requestor[temp_variable]) & ~found_lead_one;
    if (requestor[temp_variable]) found_lead_one = 1;
  end

  find_leading_one = onehotish;
end
endfunction


// Lint Info
// W486 is worried about overflow due to the shift operation, which is the intent of the RTL
// W310 is worried about a negative integer being assinged to a unsigned register. The integer in question cannot be negative.

endmodule // rrarb //

////////////////////////////////////////////////////////////
//Module:	rrarb
//$Id$
////////////////////////////////////////////////////////////

`endif
