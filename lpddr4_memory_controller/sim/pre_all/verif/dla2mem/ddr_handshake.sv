//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-10-21 00:40
//  Email             : huwe0427@uw.edu
//  Filename          : ddr_handshake.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

// ----------------------------------------------------
//use global interface to implement the handshake feature.
// use global interface to communicate between different 
interface ddr_handshake(
input clk,
input rst_n
);

logic initial_flag;


//always @(posedge clk or negedge rst_n)  begin
//  if (~rst_n)
//    initial_flag  <=  1'b0
//end



endinterface

