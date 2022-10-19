module dqs_pattern(
    input logic i_clk,
    input logic i_rst,
    input logic [3:0] i_mode, //0:default 1: transmit in progress 2:preamble 3: postamble 4:wlevel_en 5:wlevel_strobe
    input logic [7:0] i_preamble,
    input logic [7:0] i_postamble,
    input logic [7:0] i_wlevel_en,
    input logic [7:0] i_wlevel_strobe,
    input logic [7:0] i_dqs_default_seq,
    output logic [7:0] o_tx_dqs_sdr
);

    always_ff@(posedge i_clk,posedge i_rst) begin
        if(i_rst) o_tx_dqs_sdr<=8'b00000000;
        else case(i_mode)
            4'd0: o_tx_dqs_sdr<=8'b00000000;
            //transmit in progress
            4'd1: o_tx_dqs_sdr<=i_dqs_default_seq;
            //preamble
            4'd2: o_tx_dqs_sdr<=i_preamble;
            //postamble
            4'd3: o_tx_dqs_sdr<=i_postamble;
            //wlevel_en
            4'd4: o_tx_dqs_sdr<=i_wlevel_en;
            //wlevel_strobe
            4'd5: o_tx_dqs_sdr<=i_wlevel_strobe;
            //default
            default:o_tx_dqs_sdr<=8'b00000000;
        endcase
    end

endmodule