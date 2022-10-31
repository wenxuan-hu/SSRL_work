//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-08-27 08:12
//  Email             : huwe0427@uw.edu
//  Filename          : sram259x64.v
//  Description       : WR_S SRAM, 259x64 widthxdepth
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************



//module  sram259x64(
//input       clk,
//input       rst_n,
//input       cs_n,
//input       wr_n,
//input       rw_addr,
//input       rw_addr,
//
//input       data_in,
//output      data_out
//
//);


module sram259x64(inst_clk, inst_rst_n, inst_cs_n, inst_wr_n,
                             inst_rw_addr, inst_data_in,
                             data_out_inst );

  parameter data_width = 518;
  parameter depth = 64;
  parameter rst_mode = 0;
  `define bit_width_depth 6 // ceil(log2(depth)) 

  input inst_clk;
  input inst_rst_n;
  input inst_cs_n;
  input inst_wr_n;
  input [`bit_width_depth-1 : 0] inst_rw_addr;
  input [data_width-1 : 0] inst_data_in;
  output [data_width-1 : 0] data_out_inst;



//SRAM 1a  1b    low 259bits
//SRAM 2a  2b    high 259bits
//this model will be replaced by real SRAM in syn phase

  // Instance of DW_ram_rw_s_dff
  DW_ram_rw_s_dff #(256, depth, rst_mode)
    U1a (.clk(inst_clk),   .rst_n(inst_rst_n),   .cs_n(inst_cs_n),
        .wr_n(inst_wr_n),   .rw_addr(inst_rw_addr),   .data_in(inst_data_in[258:3]),
        .data_out(data_out_inst[258:3]) );

  DW_ram_rw_s_dff #(3, depth, rst_mode)
    U1b (.clk(inst_clk),   .rst_n(inst_rst_n),   .cs_n(inst_cs_n),
        .wr_n(inst_wr_n),   .rw_addr(inst_rw_addr),   .data_in(inst_data_in[2:0]),
        .data_out(data_out_inst[2:0]) );

  DW_ram_rw_s_dff #(256, depth, rst_mode)
    U2a (.clk(inst_clk),   .rst_n(inst_rst_n),   .cs_n(inst_cs_n),
        .wr_n(inst_wr_n),   .rw_addr(inst_rw_addr),   .data_in(inst_data_in[517:262]),
        .data_out(data_out_inst[517:262]) );

  DW_ram_rw_s_dff #(3, depth, rst_mode)
    U2b (.clk(inst_clk),   .rst_n(inst_rst_n),   .cs_n(inst_cs_n),
        .wr_n(inst_wr_n),   .rw_addr(inst_rw_addr),   .data_in(inst_data_in[261:259]),
        .data_out(data_out_inst[261:259]) );

endmodule
