//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-26 21:44
//  Email             : huwe0427@uw.edu
//  Filename          : native2protocol.v
//  Description       :native port, DLA to protocol layer
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************
module native2protocol(

// ----------------------------------------------------
// input from top
  input   clk;
  input   rst_n;
  input   enable;

// ----------------------------------------------------
// input from  DLA master
  input   [DLA_DATA_W-1:0]    dla_data_i;
  input                       dla_valid_i;  








// ----------------------------------------------------
// input from protocol layer



// ----------------------------------------------------
// output to  DLA master
  output                      dla_ready_o;
  output                      dla_allocatable_o;

// ----------------------------------------------------
// output to protocol layer



// ----------------------------------------------------
// output to top
);










endmodule
