//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-04 21:34
//  Email             : huwe0427@uw.edu
//  Filename          : clk_swith.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



// ----------------------------------------------------
//clock switching  AXI clock and pixel clock

module clk_switch(
  input clk0_rst_n,
  input clk1_rst_n,
  input clk0,
  input clk1,
  input clk0_enable,
  input clk1_enable,

  output clk
);


// sync clk0
logic       clk0_sync_in;
logic [2:0] clk0_sync_r;

always_ff(posedge clk0  or negedge clk0_rst_n)  begin
  if(~clk0_rst_n)
      clk0_sync_r <=  3'b000;
  else
      clk0_sync_r <=  {clk0_sync_r[1:0],  clk0_sync_in};
end

// sync clk1
logic       clk1_sync_in;
logic [2:0] clk1_sync_r;

always_ff(posedge clk1  or negedge clk1_rst_n)  begin
  if(~clk1_rst_n)
      clk1_sync_r <=  3'b000;
  else
      clk1_sync_r <=  {clk0_sync_r[1:0],  clk1_sync_in};
end

// ----------------------------------------------------
//get sync in
assign  clk0_sync_in  = (~clk1_sync_r[2])  & clk0_enable;
assign  clk1_sync_in  = (~clk0_sync_r[2])  & clk1_enable;



//clock gate
logic clk0_gated;
logic clk1_gated;
logic clk0_gated_en;
logic clk1_gated_en;

assign  clk0_gated_en = clk0_sync_r[1];
assign  clk1_gated_en = clk1_sync_r[1];




clk_gate clk_gate_u0(
.cp(clk0),
.te(1'b0),
.enable(clk0_gated_en),
.q(clk0_gated)
);


clk_gate clk_gate_u1(
.cp(clk1),
.te(1'b0),
.enable(clk1_gated_en),
.q(clk1_gated)
);






assign clk  = clk0_gated  | clk1_gated;


endmodule
