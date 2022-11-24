//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-01 09:01
//  Email             : huwe0427@uw.edu
//  Filename          : define.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************


// ----------------------------------------------------
//max image size: 4k   3840*2160
//2 sram memory: 256*482, 
// 8 words in each line. R-G-B-dummy -R-G-B-dummy- R ......

//image width should be aligned.


//to suit the axi bus width, the memory width is 256 bits, depth is 482
// Image IP Owner should modify this //TODO
// ----------------------------------------------------

`define MAX_IMAGE_WIDTH 3840



// ----------------------------------------------------
//memory
`define SRAM_WIDTH  256
`define SRAM_DEPTH  482



// ----------------------------------------------------
// ICB bus
`define ICB_WIDTH  32 




// ----------------------------------------------------
// AXI bus
`define AXI_ADDR_WIDTH  32 
`define AXI_DATA_WIDTH  256 


// ----------------------------------------------------
//register space
//SOC owner should modify this //TODO


`define      DMA_TRIGGER_MASK         {{31{1'b0}},{1{1'b1}}}
`define      PIXEL_TRIGGER_MASK      {{31{1'b0}},{1{1'b1}}}   
`define      IMAGE_WIDTH_MASK       {{20{1'b0}},{12{1'b1}}}        

parameter    reg_addr_dma_trigger    'd0; 
parameter    reg_addr_pixel_trigger    'd1; 
parameter    reg_addr_memory_addr    'd2; 
parameter    reg_addr_image_width    'd3; 
