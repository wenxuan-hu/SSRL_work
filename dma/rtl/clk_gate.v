//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-30 17:22
//  Email             : huwe0427@uw.edu
//  Filename          : clk_gate.v
//  Description       : clock_gate based on latch
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************




module  clk_gate(

  input   cp, // clock in
  input   te, // set 0, should be always 0 when clk_gate is used.
  input   enable, //clk_enable,
  output  q //clk out
);


reg qd;
always @(*) begin
  if(!cp)
    qd  = te  | enable;
end


assign q  = qd  & cp;



endmodule
