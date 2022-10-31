module top(
input clk,


  input clk_i,
  input rst_n,
  input enable,


// ----------------------------------------------------
// data/ addr
  input [DLA_DATA_W-1:0]  data_i,
  //input [FIFO_ADDR_W-1:0] wr_addr,
  //input [FIFO_ADDR_W-1:0] rd_addr,
  
  input   is_valid_in,  
  input   is_on_off_in,  
    
   

  input sw_i,
    
    
    
  
  output  reg [DLA_DATA_W-1:0]  data_o,
  output  reg  is_valid_out,
  output  reg  is_on_off_out,

  output  reg [FIFO_ADDR_W*2-1:0]  buf_bal_o,

  output  reg is_allocatable_out,
  output  reg is_allocatable_in




);





wire  [DLA_DATA_W-1:0]  data_o_0;
wire  [DLA_DATA_W-1:0]  data_o_1;


wire  is_valid_out_0;
wire  is_valid_out_1;

wire  is_on_off_out_0;
wire  is_on_off_out_1;

wire  is_allocatable_out_0;
wire  is_allocatable_out_1;

wire  is_allocatable_in_0;
wire  is_allocatable_in_1;
wire  [FIFO_ADDR_W*2-1:0]  bal_0;
wire  [FIFO_ADDR_W*2-1:0]  bal_1;

always  @(posedge clk_i or negedge rst_n) begin
  if (~rst_n) begin
    data_o  <=        'd0;
    is_valid_out  <=  'd0;
    is_on_off_out <=  'd0;
    is_allocatable_in <=  'd0;
    is_allocatable_out <=  'd0;
    buf_bal_o         <=  'd0;
  end
  else begin
    if  (sw_i)  begin
    data_o        <=   data_o_0            ;
    is_valid_out  <=   is_valid_out_0      ;
    is_on_off_out <=   is_on_off_out_0     ;
    is_on_off_out <=   is_on_off_out_0     ;
    is_on_off_out <=   is_on_off_out_0     ;
    buf_bal_o         <= bal_0; 
    end
    else  begin
    data_o        <=   data_o_1            ;
    is_valid_out  <=   is_valid_out_1      ;
    is_on_off_out <=   is_on_off_out_1     ;
    is_on_off_out <=   is_on_off_out_1     ;
    is_on_off_out <=   is_on_off_out_1     ;
    buf_bal_o         <= bal_1; 
    end
  end



end



sync_fifo inst0(


  .clk_i    (clk_i    ),
  .rst_n    (rst_n    ),
  .enable (enable ),
  .data_i      (data_i      ),
  .wr_i      (  is_valid_in    ),
  .rd_i      (  is_on_off_in    ),


  .data_o    (data_o_0    ),
  .wr_ready_o  (is_valid_out_0  ),
  .rd_ready_o (is_on_off_in_0),
  .buf_bal_o (bal_0 ),
  .empty_o (is_allocatable_out_0 ),
  .full_o (is_allocatable_in_0 )

);


sync_fifo inst1(


  .clk_i    (clk_i    ),
  .rst_n    (rst_n    ),
  .enable (enable ),
  .data_i      (data_i      ),
  .wr_i      (  is_valid_in    ),
  .rd_i      (  is_on_off_in    ),


  .data_o    (data_o_1    ),
  .wr_ready_o  (is_valid_out_1  ),
  .rd_ready_o (is_on_off_in_1),
  .buf_bal_o (bal_1 ),
  .empty_o (is_allocatable_out_1 ),
  .full_o (is_allocatable_in_1 )

);







endmodule
