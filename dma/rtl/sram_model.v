module sram_model(inst_clk, inst_rst_n, inst_cs_n, inst_wr_n,
                             inst_rw_addr, inst_data_in,
                             data_out_inst);



  localparam data_width = `SRAM_WIDTH;
  localparam depth = `SRAM_DEPTH;
  localparam rst_mode = 0;
  `define bit_width_depth 9 // ceil(log2(depth)) 

  input inst_clk;
  input inst_rst_n;
  input inst_cs_n;
  input inst_wr_n;
  input [`bit_width_depth-1 : 0] inst_rw_addr;
  input [data_width-1 : 0] inst_data_in;
  output reg [data_width-1 : 0] data_out_inst;






// ----------------------------------------------------
// this is only for behavior simulation
// regs will take up large area; nead to be replaced by real sram
// TODO
//

reg [data_width-1:0]  ram [depth-1:0];

always @(posedge inst_clk or negedge inst_rst_n)  begin
  if (~inst_rst_n);
    //ram <=  'd0;
  else  if(~inst_cs_n & ~inst_wr_n) begin
    ram[inst_rw_addr] <=  inst_data_in;
  end
end




always @(posedge inst_clk or negedge inst_rst_n)  begin
  if (~inst_rst_n)
    data_out_inst <=  'd0;
  else  if(~inst_cs_n & inst_wr_n) begin
    data_out_inst <=  ram[inst_rw_addr] ;
  end
end




endmodule
