`timescale 1ns/10ps

module refresher_tb();
    logic clk,rst;
    logic cmd_ready,cmd_valid;
    logic [7:0] ref_tRP_cfg;
    logic [7:0] ref_tRFC_cfg;
    logic [11:0] ref_tREFI_cfg;
    logic [3:0] ref_POSTPONE_cfg;
    logic [16:0] cmd_a;
    logic [2:0] cmd_ba;
    logic cmd_last;
    logic cmd_cas,cmd_ras,cmd_we;
    refresher_pos_8 dut(
	    .cmd_valid(cmd_valid),
	    .cmd_ready(cmd_ready),
	    .cmd_last(cmd_last),
	    .cmd_payload_a(cmd_a),
	    .cmd_payload_ba(cmd_ba),
	    .cmd_payload_cas(cmd_cas),
	    .cmd_payload_ras(cmd_ras),
	    .cmd_payload_we(cmd_we),
	    .ref_tRP_cfg(ref_tRP_cfg),
	    .ref_tRFC_cfg(ref_tRFC_cfg),
	    .ref_tREFI_cfg(ref_tREFI_cfg),
	    .ref_POSTPONE_cfg(ref_POSTPONE_cfg),
	    .sys_clk(clk),
	    .sys_rst(rst));

    always #1 clk=~clk; //500MHz 

    initial begin
        $vcdpluson(0, refresher_tb);
        clk<=1'b0;
        rst<=1'b1;
        cmd_ready<=1'b0;
        ref_tRP_cfg<=8'd12;
        ref_tRFC_cfg<=8'd97;
        ref_tREFI_cfg<=12'd2083;//2083
        ref_POSTPONE_cfg<=4'd8;
        #11
        cmd_ready<=1'b1; 
        rst<=1'b0;
        #100000;
        $finish;
    end 

endmodule
