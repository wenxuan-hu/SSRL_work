//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-14 15:15
//  Email             : huwe0427@uw.edu
//  Filename          : sync_2dff.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



module sync_2dff(
  input clk_1,
  input sig_1,
  
  input rst_n,

  input clk_2,
  output logic sig_2
);

logic [2:0] sig_2_q;


always_ff@(posedge clk_2 or negedge rst_n) begin
    if(~rst_n)
      sig_2_q <=  3'b000;
    else
      sig_2_q <=  {sig_2_r[1:0],sig_1};
end

assign sig_2  = sig_2_q[2];


endmodule



