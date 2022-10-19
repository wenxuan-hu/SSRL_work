module tapped_delay_line32 #(
    parameter WIDTH=1
)
(
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] i_d,
    output logic[32*WIDTH-1:0] o_d_dly
);

    always_ff@(posedge clk,posedge rst) begin
        if(rst) o_d_dly<=32'd0;
        else begin
            o_d_dly[WIDTH-1:0]<=i_d[WIDTH-1:0];
            for(int i=1;i<32;i++) begin
                o_d_dly[i*WIDTH+:WIDTH]<=o_d_dly[(i-1)*WIDTH+:WIDTH];
            end
        end
    end


endmodule