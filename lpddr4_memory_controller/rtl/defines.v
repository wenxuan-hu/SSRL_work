//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-05 22:22
//  Email             : huwe0427@uw.edu
//  Filename          : defines.v
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



// ----------------------------------------------------
// dla
`define                DLA_ADDR_FIELD     29:0   
`define                DLA_CMD_FIELD     63:0   
`define                BURST_LEN_FIELD    61:54   
`define                DRT_FIELD    63:62   
parameter              MOSI_DATA_W   =   'd256;
parameter              FIFO_DEPTH   =   'd64;
parameter              FIFO_ADDR_W  =   6;


parameter             BUF_BAL     =     'h45;



// ----------------------------------------------------
// bit mask

//parameter              CRD_BIT_MASK = {{33{8'd0}},  {8'b10000000} ,{14{8'd0}}};
//parameter              ALCT_BIT_MASK = {{33{8'd0}},  {8'b00000001} ,{14{8'd0}}};

// ----------------------------------------------------
// **_B    bit mask in certain field
parameter             DLA_WRITE  =    2'b10; 
parameter             DLA_READ   =   2'b01; 
parameter              DLA_ADDR_W   =   'd30;

// ----------------------------------------------------
//ddr

parameter              DDR_DATA_W   =   'd256;
parameter              DDR_ADDR_W   =   'd26;
parameter              DDR_MASK_W   =   'd32;
`define                DDR_ADDR_FIELD     25:0   



