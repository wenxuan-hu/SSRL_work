//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-27 05:59
//  Email             : huwe0427@uw.edu
//  Filename          : defines.v
//  Description       :  Macro defines
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************


//`define             DLA_DATA_W        259
`define                UCIE_CTRL_FIELD     15*8-1:14*8   
`define                UCIE_DATA_FIELD     48*8-1:48*8-DLA_DATA_W   
parameter              DLA_DATA_W   =   259;
parameter              FIFO_DEPTH   =   'd64;
parameter              FIFO_ADDR_W  =   6;
parameter              NBYTES  =   48;
parameter               NC  = 32;


parameter             BUF_BAL     =     'h85;



// ----------------------------------------------------
// 48 BYTES     48 lanes
// 262bits(33 B) data +    8bits(1 B) csr register  +  112bits(14 B) dummy
// from High to Low;  left align;
// csr register:    A000,000B:    A: credit return bit   B: is_allocatable_in  bit  

parameter              CRD_BIT_MASK = {{33{8'd0}},  {8'b10000000} ,{14{8'd0}}};
parameter              ALCT_BIT_MASK = {{33{8'd0}},  {8'b00000001} ,{14{8'd0}}};

// ----------------------------------------------------
// **_B    bit mask in certain field
parameter              CRD_BIT_MASK_B = 8'b10000000;
parameter              ALCT_BIT_MASK_B = 8'b00000001;





