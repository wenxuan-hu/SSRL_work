//  ******************************************************
//  Author            : Wenxuan Hu
//  Last modified     : 2022-11-05 00:08
//  Email             : huwe0427@uw.edu
//  Filename          : pixel_buffer.sv
//  Description       :
//    Copyright [2021] <Copyright Wenxuan Hu>
//  ******************************************************

// ----------------------------------------------------
// pixel data buffer, work under pixel clock domain.
//pixel: RGB
// word 256 bits  RGB dummy, RGB, dummy ...

module pixel_buffer(
input clk,
input rst_n,

input [7:0] pixel_data_i,
input pixel_valid_i,

input   pixel_trigger_i,

input  [11:0]    image_width_i,

output logic  pixel_trigger_done_o, 
output logic  pixel_ready_o,
output logic   [`SRAM_WIDTH-1:0] mem_data_o,
output logic   mem_wr_o,
output logic  [8:0] mem_addr_o
);


logic  [13:0] counter;

logic ready;
logic pixel_get;



assign pixel_ready_o  = ready;

// ----------------------------------------------------
//  control signal
assign  ready = pixel_trigger_i && (counter < image_width_i*'d4);

assign  pixel_get = pixel_valid_i & ready;


assign  mem_addr_o  = counter[13:5];


always_ff@(posedge clk or negedge rst_n)  begin
    if(~rst_n)  
      counter <=  'd0;
    else if(~pixel_trigger_i)
      counter <=  'd0;
    else if (pixel_get  && counter  <  image_width_i)  begin
        case(counter[1:0])
          // Red channel
          2'b00:  counter <=  counter + 1'b1;
          // Green channel
          2'b01:  counter <=  counter + 1'b1;
          // Blue channel
          2'b10:  counter <=  counter + 2'b10;
          // dummy channel will be skipped
          2'b11:  counter <=  counter + 1'b1;

          default:counter <= counter;
        endcase
      end
end



always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)
    mem_data_o <=  'd0;
  else if (~pixel_trigger_i)
    mem_data_o <=  'd0;
  else  if(pixel_get) begin
        case(counter[1:0])
          // Red channel
          2'b00:  mem_data_o[('d32* counter[4:2] + 'd8 -'d1):'d32* counter[4:2]]  <=  pixel_data_i;
          // Green channel
          2'b01:  mem_data_o[('d32* counter[4:2] + 2*'d8 -'d1):'d32* counter[4:2] + 'd8]  <=  pixel_data_i;
          // Blue channel
          2'b10:  mem_data_o[('d32* counter[4:2] + 3*'d8 -'d1):'d32* counter[4:2] + 2*'d8]  <=  pixel_data_i;
          // dummy channel will be skipped
          2'b11:  mem_data_o[('d32* counter[4:2] + 4*'d8 -'d1):'d32* counter[4:2] + 3*'d8]  <=  'd0;

          default: mem_data_o <=  mem_data_o;
        endcase
    end
end




always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)
    pixel_trigger_done_o  <=  1'b0;
  else  if(~pixel_trigger_i)
    pixel_trigger_done_o  <=  1'b0;
   else if(counter  ==  image_width_i*'d4) 
    pixel_trigger_done_o  <=  1'b1;
end

      

always_ff@(posedge clk or negedge rst_n)  begin
  if(~rst_n)
    mem_wr_o  <=  1'b0;
  else  if(pixel_get  &&  counter[4:2]==3'b111)
    mem_wr_o  <=  1'b1; 
  else
    mem_wr_o  <=  1'b0;

end

endmodule
