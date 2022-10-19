/* Machine-generated using Migen */
module multiplexer_b8(
	input [255:0] interface_wdata,
	input [31:0] interface_wdata_we,
	output [255:0] interface_rdata,
	output reg [16:0] dfi_p0_address,
	output reg [2:0] dfi_p0_bank,
	output reg dfi_p0_cas_n,
	output reg dfi_p0_cs_n,
	output reg dfi_p0_ras_n,
	output reg dfi_p0_we_n,
	output dfi_p0_cke,
	output dfi_p0_odt,
	output dfi_p0_reset_n,
	input dfi_p0_act_n,
	output reg dfi_p0_mw,
	output [63:0] dfi_p0_wrdata,
	output reg dfi_p0_wrdata_en,
	output [7:0] dfi_p0_wrdata_mask,
	output reg dfi_p0_rddata_en,
	input [63:0] dfi_p0_rddata,
	input dfi_p0_rddata_valid,
	output reg [16:0] dfi_p1_address,
	output reg [2:0] dfi_p1_bank,
	output reg dfi_p1_cas_n,
	output reg dfi_p1_cs_n,
	output reg dfi_p1_ras_n,
	output reg dfi_p1_we_n,
	output dfi_p1_cke,
	output dfi_p1_odt,
	output dfi_p1_reset_n,
	input dfi_p1_act_n,
	output reg dfi_p1_mw,
	output [63:0] dfi_p1_wrdata,
	output reg dfi_p1_wrdata_en,
	output [7:0] dfi_p1_wrdata_mask,
	output reg dfi_p1_rddata_en,
	input [63:0] dfi_p1_rddata,
	input dfi_p1_rddata_valid,
	output reg [16:0] dfi_p2_address,
	output reg [2:0] dfi_p2_bank,
	output reg dfi_p2_cas_n,
	output reg dfi_p2_cs_n,
	output reg dfi_p2_ras_n,
	output reg dfi_p2_we_n,
	output dfi_p2_cke,
	output dfi_p2_odt,
	output dfi_p2_reset_n,
	input dfi_p2_act_n,
	output reg dfi_p2_mw,
	output [63:0] dfi_p2_wrdata,
	output reg dfi_p2_wrdata_en,
	output [7:0] dfi_p2_wrdata_mask,
	output reg dfi_p2_rddata_en,
	input [63:0] dfi_p2_rddata,
	input dfi_p2_rddata_valid,
	output reg [16:0] dfi_p3_address,
	output reg [2:0] dfi_p3_bank,
	output reg dfi_p3_cas_n,
	output reg dfi_p3_cs_n,
	output reg dfi_p3_ras_n,
	output reg dfi_p3_we_n,
	output dfi_p3_cke,
	output dfi_p3_odt,
	output dfi_p3_reset_n,
	input dfi_p3_act_n,
	output reg dfi_p3_mw,
	output [63:0] dfi_p3_wrdata,
	output reg dfi_p3_wrdata_en,
	output [7:0] dfi_p3_wrdata_mask,
	output reg dfi_p3_rddata_en,
	input [63:0] dfi_p3_rddata,
	input dfi_p3_rddata_valid,
	input cmd_valid,
	output reg cmd_ready,
	input cmd_first,
	input cmd_last,
	input [16:0] cmd_payload_a,
	input [2:0] cmd_payload_ba,
	input cmd_payload_cas,
	input cmd_payload_ras,
	input cmd_payload_we,
	input cmd_payload_is_cmd,
	input cmd_payload_is_read,
	input cmd_payload_is_write,
	input cmd_payload_is_mw,
	output refresh_req,
	input refresh_gnt,
	input cmd_valid_1,
	output reg cmd_ready_1,
	input cmd_first_1,
	input cmd_last_1,
	input [16:0] cmd_payload_a_1,
	input [2:0] cmd_payload_ba_1,
	input cmd_payload_cas_1,
	input cmd_payload_ras_1,
	input cmd_payload_we_1,
	input cmd_payload_is_cmd_1,
	input cmd_payload_is_read_1,
	input cmd_payload_is_write_1,
	input cmd_payload_is_mw_1,
	output refresh_req_1,
	input refresh_gnt_1,
	input cmd_valid_2,
	output reg cmd_ready_2,
	input cmd_first_2,
	input cmd_last_2,
	input [16:0] cmd_payload_a_2,
	input [2:0] cmd_payload_ba_2,
	input cmd_payload_cas_2,
	input cmd_payload_ras_2,
	input cmd_payload_we_2,
	input cmd_payload_is_cmd_2,
	input cmd_payload_is_read_2,
	input cmd_payload_is_write_2,
	input cmd_payload_is_mw_2,
	output refresh_req_2,
	input refresh_gnt_2,
	input cmd_valid_3,
	output reg cmd_ready_3,
	input cmd_first_3,
	input cmd_last_3,
	input [16:0] cmd_payload_a_3,
	input [2:0] cmd_payload_ba_3,
	input cmd_payload_cas_3,
	input cmd_payload_ras_3,
	input cmd_payload_we_3,
	input cmd_payload_is_cmd_3,
	input cmd_payload_is_read_3,
	input cmd_payload_is_write_3,
	input cmd_payload_is_mw_3,
	output refresh_req_3,
	input refresh_gnt_3,
	input cmd_valid_4,
	output reg cmd_ready_4,
	input cmd_first_4,
	input cmd_last_4,
	input [16:0] cmd_payload_a_4,
	input [2:0] cmd_payload_ba_4,
	input cmd_payload_cas_4,
	input cmd_payload_ras_4,
	input cmd_payload_we_4,
	input cmd_payload_is_cmd_4,
	input cmd_payload_is_read_4,
	input cmd_payload_is_write_4,
	input cmd_payload_is_mw_4,
	output refresh_req_4,
	input refresh_gnt_4,
	input cmd_valid_5,
	output reg cmd_ready_5,
	input cmd_first_5,
	input cmd_last_5,
	input [16:0] cmd_payload_a_5,
	input [2:0] cmd_payload_ba_5,
	input cmd_payload_cas_5,
	input cmd_payload_ras_5,
	input cmd_payload_we_5,
	input cmd_payload_is_cmd_5,
	input cmd_payload_is_read_5,
	input cmd_payload_is_write_5,
	input cmd_payload_is_mw_5,
	output refresh_req_5,
	input refresh_gnt_5,
	input cmd_valid_6,
	output reg cmd_ready_6,
	input cmd_first_6,
	input cmd_last_6,
	input [16:0] cmd_payload_a_6,
	input [2:0] cmd_payload_ba_6,
	input cmd_payload_cas_6,
	input cmd_payload_ras_6,
	input cmd_payload_we_6,
	input cmd_payload_is_cmd_6,
	input cmd_payload_is_read_6,
	input cmd_payload_is_write_6,
	input cmd_payload_is_mw_6,
	output refresh_req_6,
	input refresh_gnt_6,
	input cmd_valid_7,
	output reg cmd_ready_7,
	input cmd_first_7,
	input cmd_last_7,
	input [16:0] cmd_payload_a_7,
	input [2:0] cmd_payload_ba_7,
	input cmd_payload_cas_7,
	input cmd_payload_ras_7,
	input cmd_payload_we_7,
	input cmd_payload_is_cmd_7,
	input cmd_payload_is_read_7,
	input cmd_payload_is_write_7,
	input cmd_payload_is_mw_7,
	output refresh_req_7,
	input refresh_gnt_7,
	input cmd_valid_8,
	output reg cmd_ready_8,
	input cmd_first_8,
	input cmd_last_8,
	input [16:0] cmd_payload_a_8,
	input [2:0] cmd_payload_ba_8,
	input cmd_payload_cas_8,
	input cmd_payload_ras_8,
	input cmd_payload_we_8,
	input cmd_payload_is_cmd_8,
	input cmd_payload_is_read_8,
	input cmd_payload_is_write_8,
	input cmd_payload_is_mw_8,
	input [7:0] mul_tRRD_cfg,
	input [7:0] mul_tFAW_cfg,
	input [7:0] mul_tCCD_cfg,
	input [7:0] mul_WTR_LATENCY_cfg,
	input [7:0] mul_RTW_LATENCY_cfg,
	input [7:0] mul_READ_TIME_cfg,
	input [7:0] mul_WRITE_TIME_cfg,
	input [1:0] mul_rd_phase_cfg,
	input [1:0] mul_wr_phase_cfg,
	input [1:0] mul_rdcmd_phase_cfg,
	input [1:0] mul_wrcmd_phase_cfg,
	input sys_clk,
	input sys_rst
);

wire ras_allowed;
wire cas_allowed;
reg choose_cmd_want_reads = 1'd0;
reg choose_cmd_want_writes = 1'd0;
reg choose_cmd_want_cmds = 1'd0;
reg choose_cmd_want_activates = 1'd0;
wire choose_cmd_cmd_valid;
reg choose_cmd_cmd_ready = 1'd0;
wire [16:0] choose_cmd_cmd_payload_a;
wire [2:0] choose_cmd_cmd_payload_ba;
reg choose_cmd_cmd_payload_cas;
reg choose_cmd_cmd_payload_ras;
reg choose_cmd_cmd_payload_we;
wire choose_cmd_cmd_payload_is_cmd;
wire choose_cmd_cmd_payload_is_read;
wire choose_cmd_cmd_payload_is_write;
reg choose_cmd_cmd_payload_is_mw;
reg [7:0] choose_cmd_valids;
wire [7:0] choose_cmd_request;
reg [2:0] choose_cmd_grant = 3'd0;
wire choose_cmd_ce;
reg choose_req_want_reads;
reg choose_req_want_writes;
wire choose_req_want_cmds;
reg choose_req_want_activates;
wire choose_req_cmd_valid;
reg choose_req_cmd_ready;
wire [16:0] choose_req_cmd_payload_a;
wire [2:0] choose_req_cmd_payload_ba;
reg choose_req_cmd_payload_cas;
reg choose_req_cmd_payload_ras;
reg choose_req_cmd_payload_we;
wire choose_req_cmd_payload_is_cmd;
wire choose_req_cmd_payload_is_read;
wire choose_req_cmd_payload_is_write;
reg choose_req_cmd_payload_is_mw;
reg [7:0] choose_req_valids;
wire [7:0] choose_req_request;
reg [2:0] choose_req_grant = 3'd0;
wire choose_req_ce;
reg [16:0] nop_a = 17'd0;
reg [2:0] nop_ba = 3'd0;
reg [1:0] steerer_sel0;
reg [1:0] steerer_sel1;
reg [1:0] steerer_sel2;
reg [1:0] steerer_sel3;
reg steerer0 = 1'd1;
reg steerer1 = 1'd1;
reg steerer_rddata_en_dly0 = 1'd0;
reg steerer_wrdata_en_dly0 = 1'd0;
reg steerer2 = 1'd1;
reg steerer3 = 1'd1;
reg steerer_rddata_en_dly1 = 1'd0;
reg steerer_wrdata_en_dly1 = 1'd0;
reg steerer4 = 1'd1;
reg steerer5 = 1'd1;
reg steerer_rddata_en_dly2 = 1'd0;
reg steerer_wrdata_en_dly2 = 1'd0;
reg steerer6 = 1'd1;
reg steerer7 = 1'd1;
reg steerer_rddata_en_dly3 = 1'd0;
reg steerer_wrdata_en_dly3 = 1'd0;
wire trrdcon_valid;
(* no_retiming = "true" *) reg trrdcon_ready = 1'd1;
reg [7:0] trrdcon_count = 8'd0;
wire tfawcon_valid;
(* no_retiming = "true" *) reg tfawcon_ready = 1'd1;
wire [7:0] tfawcon_count;
reg [63:0] tfawcon_window_c = 64'd0;
reg [63:0] tfawcon_window;
wire tccdcon_valid;
(* no_retiming = "true" *) reg tccdcon_ready = 1'd1;
reg [7:0] tccdcon_count = 8'd0;
wire twtrcon_valid;
(* no_retiming = "true" *) reg twtrcon_ready = 1'd1;
reg [7:0] twtrcon_count = 8'd0;
wire trtwcon_valid;
(* no_retiming = "true" *) reg trtwcon_ready = 1'd1;
reg [7:0] trtwcon_count = 8'd0;
wire read_available;
wire write_available;
reg en0;
wire max_time0;
reg [7:0] time0 = 8'd0;
reg en1;
wire max_time1;
reg [7:0] time1 = 8'd0;
wire go_to_refresh;
reg [2:0] state = 3'd0;
reg [2:0] next_state;
reg rhs_array_muxed0;
reg [16:0] rhs_array_muxed1;
reg [2:0] rhs_array_muxed2;
reg rhs_array_muxed3;
reg rhs_array_muxed4;
reg rhs_array_muxed5;
reg t_array_muxed0;
reg t_array_muxed1;
reg t_array_muxed2;
reg t_array_muxed3;
reg rhs_array_muxed6;
reg [16:0] rhs_array_muxed7;
reg [2:0] rhs_array_muxed8;
reg rhs_array_muxed9;
reg rhs_array_muxed10;
reg rhs_array_muxed11;
reg t_array_muxed4;
reg t_array_muxed5;
reg t_array_muxed6;
reg t_array_muxed7;
reg [2:0] array_muxed0;
reg [16:0] array_muxed1;
reg array_muxed2;
reg array_muxed3;
reg array_muxed4;
reg array_muxed5;
reg array_muxed6;
reg array_muxed7;
reg array_muxed8;
reg array_muxed9;
reg [2:0] array_muxed10;
reg [16:0] array_muxed11;
reg array_muxed12;
reg array_muxed13;
reg array_muxed14;
reg array_muxed15;
reg array_muxed16;
reg array_muxed17;
reg array_muxed18;
reg array_muxed19;
reg [2:0] array_muxed20;
reg [16:0] array_muxed21;
reg array_muxed22;
reg array_muxed23;
reg array_muxed24;
reg array_muxed25;
reg array_muxed26;
reg array_muxed27;
reg array_muxed28;
reg array_muxed29;
reg [2:0] array_muxed30;
reg [16:0] array_muxed31;
reg array_muxed32;
reg array_muxed33;
reg array_muxed34;
reg array_muxed35;
reg array_muxed36;
reg array_muxed37;
reg array_muxed38;
reg array_muxed39;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign choose_req_want_cmds = 1'd1;
assign trrdcon_valid = ((choose_req_cmd_valid & choose_req_cmd_ready) & ((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we)));
assign tfawcon_valid = ((choose_req_cmd_valid & choose_req_cmd_ready) & ((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we)));
assign ras_allowed = (trrdcon_ready & tfawcon_ready);
assign tccdcon_valid = ((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_cmd_payload_is_write | choose_req_cmd_payload_is_read));
assign cas_allowed = tccdcon_ready;
assign twtrcon_valid = ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
assign trtwcon_valid = ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
assign read_available = ((((((((cmd_valid_1 & cmd_payload_is_read_1) | (cmd_valid_2 & cmd_payload_is_read_2)) | (cmd_valid_3 & cmd_payload_is_read_3)) | (cmd_valid_4 & cmd_payload_is_read_4)) | (cmd_valid_5 & cmd_payload_is_read_5)) | (cmd_valid_6 & cmd_payload_is_read_6)) | (cmd_valid_7 & cmd_payload_is_read_7)) | (cmd_valid_8 & cmd_payload_is_read_8));
assign write_available = ((((((((cmd_valid_1 & cmd_payload_is_write_1) | (cmd_valid_2 & cmd_payload_is_write_2)) | (cmd_valid_3 & cmd_payload_is_write_3)) | (cmd_valid_4 & cmd_payload_is_write_4)) | (cmd_valid_5 & cmd_payload_is_write_5)) | (cmd_valid_6 & cmd_payload_is_write_6)) | (cmd_valid_7 & cmd_payload_is_write_7)) | (cmd_valid_8 & cmd_payload_is_write_8));
assign max_time0 = (time0 == 1'd0);
assign max_time1 = (time1 == 1'd0);
assign refresh_req = cmd_valid;
assign refresh_req_1 = cmd_valid;
assign refresh_req_2 = cmd_valid;
assign refresh_req_3 = cmd_valid;
assign refresh_req_4 = cmd_valid;
assign refresh_req_5 = cmd_valid;
assign refresh_req_6 = cmd_valid;
assign refresh_req_7 = cmd_valid;
assign go_to_refresh = (((((((refresh_gnt & refresh_gnt_1) & refresh_gnt_2) & refresh_gnt_3) & refresh_gnt_4) & refresh_gnt_5) & refresh_gnt_6) & refresh_gnt_7);
assign interface_rdata = {dfi_p3_rddata, dfi_p2_rddata, dfi_p1_rddata, dfi_p0_rddata};
assign {dfi_p3_wrdata, dfi_p2_wrdata, dfi_p1_wrdata, dfi_p0_wrdata} = interface_wdata;
assign {dfi_p3_wrdata_mask, dfi_p2_wrdata_mask, dfi_p1_wrdata_mask, dfi_p0_wrdata_mask} = (~interface_wdata_we);

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	choose_cmd_valids <= 8'd0;
	choose_cmd_valids[0] <= (cmd_valid_1 & (((cmd_payload_is_cmd_1 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_1 & (~cmd_payload_cas_1)) & (~cmd_payload_we_1))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_1 == choose_cmd_want_reads) & (cmd_payload_is_write_1 == choose_cmd_want_writes))));
	choose_cmd_valids[1] <= (cmd_valid_2 & (((cmd_payload_is_cmd_2 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_2 & (~cmd_payload_cas_2)) & (~cmd_payload_we_2))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_2 == choose_cmd_want_reads) & (cmd_payload_is_write_2 == choose_cmd_want_writes))));
	choose_cmd_valids[2] <= (cmd_valid_3 & (((cmd_payload_is_cmd_3 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_3 & (~cmd_payload_cas_3)) & (~cmd_payload_we_3))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_3 == choose_cmd_want_reads) & (cmd_payload_is_write_3 == choose_cmd_want_writes))));
	choose_cmd_valids[3] <= (cmd_valid_4 & (((cmd_payload_is_cmd_4 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_4 & (~cmd_payload_cas_4)) & (~cmd_payload_we_4))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_4 == choose_cmd_want_reads) & (cmd_payload_is_write_4 == choose_cmd_want_writes))));
	choose_cmd_valids[4] <= (cmd_valid_5 & (((cmd_payload_is_cmd_5 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_5 & (~cmd_payload_cas_5)) & (~cmd_payload_we_5))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_5 == choose_cmd_want_reads) & (cmd_payload_is_write_5 == choose_cmd_want_writes))));
	choose_cmd_valids[5] <= (cmd_valid_6 & (((cmd_payload_is_cmd_6 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_6 & (~cmd_payload_cas_6)) & (~cmd_payload_we_6))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_6 == choose_cmd_want_reads) & (cmd_payload_is_write_6 == choose_cmd_want_writes))));
	choose_cmd_valids[6] <= (cmd_valid_7 & (((cmd_payload_is_cmd_7 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_7 & (~cmd_payload_cas_7)) & (~cmd_payload_we_7))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_7 == choose_cmd_want_reads) & (cmd_payload_is_write_7 == choose_cmd_want_writes))));
	choose_cmd_valids[7] <= (cmd_valid_8 & (((cmd_payload_is_cmd_8 & choose_cmd_want_cmds) & ((~((cmd_payload_ras_8 & (~cmd_payload_cas_8)) & (~cmd_payload_we_8))) | choose_cmd_want_activates)) | ((cmd_payload_is_read_8 == choose_cmd_want_reads) & (cmd_payload_is_write_8 == choose_cmd_want_writes))));
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign choose_cmd_request = choose_cmd_valids;
assign choose_cmd_cmd_valid = rhs_array_muxed0;
assign choose_cmd_cmd_payload_a = rhs_array_muxed1;
assign choose_cmd_cmd_payload_ba = rhs_array_muxed2;
assign choose_cmd_cmd_payload_is_read = rhs_array_muxed3;
assign choose_cmd_cmd_payload_is_write = rhs_array_muxed4;
assign choose_cmd_cmd_payload_is_cmd = rhs_array_muxed5;

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	choose_cmd_cmd_payload_cas <= 1'd0;
	if (choose_cmd_cmd_valid) begin
		choose_cmd_cmd_payload_cas <= t_array_muxed0;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	choose_cmd_cmd_payload_ras <= 1'd0;
	if (choose_cmd_cmd_valid) begin
		choose_cmd_cmd_payload_ras <= t_array_muxed1;
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	choose_cmd_cmd_payload_we <= 1'd0;
	if (choose_cmd_cmd_valid) begin
		choose_cmd_cmd_payload_we <= t_array_muxed2;
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	choose_cmd_cmd_payload_is_mw <= 1'd0;
	if (choose_cmd_cmd_valid) begin
		choose_cmd_cmd_payload_is_mw <= t_array_muxed3;
	end
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end
assign choose_cmd_ce = (choose_cmd_cmd_ready | (~choose_cmd_cmd_valid));

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	choose_req_valids <= 8'd0;
	choose_req_valids[0] <= (cmd_valid_1 & (((cmd_payload_is_cmd_1 & choose_req_want_cmds) & ((~((cmd_payload_ras_1 & (~cmd_payload_cas_1)) & (~cmd_payload_we_1))) | choose_req_want_activates)) | ((cmd_payload_is_read_1 == choose_req_want_reads) & (cmd_payload_is_write_1 == choose_req_want_writes))));
	choose_req_valids[1] <= (cmd_valid_2 & (((cmd_payload_is_cmd_2 & choose_req_want_cmds) & ((~((cmd_payload_ras_2 & (~cmd_payload_cas_2)) & (~cmd_payload_we_2))) | choose_req_want_activates)) | ((cmd_payload_is_read_2 == choose_req_want_reads) & (cmd_payload_is_write_2 == choose_req_want_writes))));
	choose_req_valids[2] <= (cmd_valid_3 & (((cmd_payload_is_cmd_3 & choose_req_want_cmds) & ((~((cmd_payload_ras_3 & (~cmd_payload_cas_3)) & (~cmd_payload_we_3))) | choose_req_want_activates)) | ((cmd_payload_is_read_3 == choose_req_want_reads) & (cmd_payload_is_write_3 == choose_req_want_writes))));
	choose_req_valids[3] <= (cmd_valid_4 & (((cmd_payload_is_cmd_4 & choose_req_want_cmds) & ((~((cmd_payload_ras_4 & (~cmd_payload_cas_4)) & (~cmd_payload_we_4))) | choose_req_want_activates)) | ((cmd_payload_is_read_4 == choose_req_want_reads) & (cmd_payload_is_write_4 == choose_req_want_writes))));
	choose_req_valids[4] <= (cmd_valid_5 & (((cmd_payload_is_cmd_5 & choose_req_want_cmds) & ((~((cmd_payload_ras_5 & (~cmd_payload_cas_5)) & (~cmd_payload_we_5))) | choose_req_want_activates)) | ((cmd_payload_is_read_5 == choose_req_want_reads) & (cmd_payload_is_write_5 == choose_req_want_writes))));
	choose_req_valids[5] <= (cmd_valid_6 & (((cmd_payload_is_cmd_6 & choose_req_want_cmds) & ((~((cmd_payload_ras_6 & (~cmd_payload_cas_6)) & (~cmd_payload_we_6))) | choose_req_want_activates)) | ((cmd_payload_is_read_6 == choose_req_want_reads) & (cmd_payload_is_write_6 == choose_req_want_writes))));
	choose_req_valids[6] <= (cmd_valid_7 & (((cmd_payload_is_cmd_7 & choose_req_want_cmds) & ((~((cmd_payload_ras_7 & (~cmd_payload_cas_7)) & (~cmd_payload_we_7))) | choose_req_want_activates)) | ((cmd_payload_is_read_7 == choose_req_want_reads) & (cmd_payload_is_write_7 == choose_req_want_writes))));
	choose_req_valids[7] <= (cmd_valid_8 & (((cmd_payload_is_cmd_8 & choose_req_want_cmds) & ((~((cmd_payload_ras_8 & (~cmd_payload_cas_8)) & (~cmd_payload_we_8))) | choose_req_want_activates)) | ((cmd_payload_is_read_8 == choose_req_want_reads) & (cmd_payload_is_write_8 == choose_req_want_writes))));
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end
assign choose_req_request = choose_req_valids;
assign choose_req_cmd_valid = rhs_array_muxed6;
assign choose_req_cmd_payload_a = rhs_array_muxed7;
assign choose_req_cmd_payload_ba = rhs_array_muxed8;
assign choose_req_cmd_payload_is_read = rhs_array_muxed9;
assign choose_req_cmd_payload_is_write = rhs_array_muxed10;
assign choose_req_cmd_payload_is_cmd = rhs_array_muxed11;

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	choose_req_cmd_payload_cas <= 1'd0;
	if (choose_req_cmd_valid) begin
		choose_req_cmd_payload_cas <= t_array_muxed4;
	end
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	choose_req_cmd_payload_ras <= 1'd0;
	if (choose_req_cmd_valid) begin
		choose_req_cmd_payload_ras <= t_array_muxed5;
	end
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	choose_req_cmd_payload_we <= 1'd0;
	if (choose_req_cmd_valid) begin
		choose_req_cmd_payload_we <= t_array_muxed6;
	end
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	choose_req_cmd_payload_is_mw <= 1'd0;
	if (choose_req_cmd_valid) begin
		choose_req_cmd_payload_is_mw <= t_array_muxed7;
	end
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	cmd_ready_1 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 1'd0))) begin
		cmd_ready_1 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 1'd0))) begin
		cmd_ready_1 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	cmd_ready_2 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 1'd1))) begin
		cmd_ready_2 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 1'd1))) begin
		cmd_ready_2 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	cmd_ready_3 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 2'd2))) begin
		cmd_ready_3 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 2'd2))) begin
		cmd_ready_3 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	cmd_ready_4 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 2'd3))) begin
		cmd_ready_4 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 2'd3))) begin
		cmd_ready_4 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	cmd_ready_5 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 3'd4))) begin
		cmd_ready_5 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 3'd4))) begin
		cmd_ready_5 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	cmd_ready_6 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 3'd5))) begin
		cmd_ready_6 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 3'd5))) begin
		cmd_ready_6 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	cmd_ready_7 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 3'd6))) begin
		cmd_ready_7 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 3'd6))) begin
		cmd_ready_7 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	cmd_ready_8 <= 1'd0;
	if (((choose_cmd_cmd_valid & choose_cmd_cmd_ready) & (choose_cmd_grant == 3'd7))) begin
		cmd_ready_8 <= 1'd1;
	end
	if (((choose_req_cmd_valid & choose_req_cmd_ready) & (choose_req_grant == 3'd7))) begin
		cmd_ready_8 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end
assign choose_req_ce = (choose_req_cmd_ready | (~choose_req_cmd_valid));
assign dfi_p0_reset_n = 1'd1;
assign dfi_p0_cke = {1{steerer0}};
assign dfi_p0_odt = {1{steerer1}};
assign dfi_p1_reset_n = 1'd1;
assign dfi_p1_cke = {1{steerer2}};
assign dfi_p1_odt = {1{steerer3}};
assign dfi_p2_reset_n = 1'd1;
assign dfi_p2_cke = {1{steerer4}};
assign dfi_p2_odt = {1{steerer5}};
assign dfi_p3_reset_n = 1'd1;
assign dfi_p3_cke = {1{steerer6}};
assign dfi_p3_odt = {1{steerer7}};

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	tfawcon_window <= 64'd0;
	if ((mul_tFAW_cfg > 1'd0)) begin
		tfawcon_window[0] <= tfawcon_window_c[0];
	end else begin
		tfawcon_window[0] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 1'd1)) begin
		tfawcon_window[1] <= tfawcon_window_c[1];
	end else begin
		tfawcon_window[1] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 2'd2)) begin
		tfawcon_window[2] <= tfawcon_window_c[2];
	end else begin
		tfawcon_window[2] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 2'd3)) begin
		tfawcon_window[3] <= tfawcon_window_c[3];
	end else begin
		tfawcon_window[3] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 3'd4)) begin
		tfawcon_window[4] <= tfawcon_window_c[4];
	end else begin
		tfawcon_window[4] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 3'd5)) begin
		tfawcon_window[5] <= tfawcon_window_c[5];
	end else begin
		tfawcon_window[5] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 3'd6)) begin
		tfawcon_window[6] <= tfawcon_window_c[6];
	end else begin
		tfawcon_window[6] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 3'd7)) begin
		tfawcon_window[7] <= tfawcon_window_c[7];
	end else begin
		tfawcon_window[7] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd8)) begin
		tfawcon_window[8] <= tfawcon_window_c[8];
	end else begin
		tfawcon_window[8] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd9)) begin
		tfawcon_window[9] <= tfawcon_window_c[9];
	end else begin
		tfawcon_window[9] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd10)) begin
		tfawcon_window[10] <= tfawcon_window_c[10];
	end else begin
		tfawcon_window[10] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd11)) begin
		tfawcon_window[11] <= tfawcon_window_c[11];
	end else begin
		tfawcon_window[11] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd12)) begin
		tfawcon_window[12] <= tfawcon_window_c[12];
	end else begin
		tfawcon_window[12] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd13)) begin
		tfawcon_window[13] <= tfawcon_window_c[13];
	end else begin
		tfawcon_window[13] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd14)) begin
		tfawcon_window[14] <= tfawcon_window_c[14];
	end else begin
		tfawcon_window[14] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 4'd15)) begin
		tfawcon_window[15] <= tfawcon_window_c[15];
	end else begin
		tfawcon_window[15] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd16)) begin
		tfawcon_window[16] <= tfawcon_window_c[16];
	end else begin
		tfawcon_window[16] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd17)) begin
		tfawcon_window[17] <= tfawcon_window_c[17];
	end else begin
		tfawcon_window[17] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd18)) begin
		tfawcon_window[18] <= tfawcon_window_c[18];
	end else begin
		tfawcon_window[18] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd19)) begin
		tfawcon_window[19] <= tfawcon_window_c[19];
	end else begin
		tfawcon_window[19] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd20)) begin
		tfawcon_window[20] <= tfawcon_window_c[20];
	end else begin
		tfawcon_window[20] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd21)) begin
		tfawcon_window[21] <= tfawcon_window_c[21];
	end else begin
		tfawcon_window[21] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd22)) begin
		tfawcon_window[22] <= tfawcon_window_c[22];
	end else begin
		tfawcon_window[22] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd23)) begin
		tfawcon_window[23] <= tfawcon_window_c[23];
	end else begin
		tfawcon_window[23] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd24)) begin
		tfawcon_window[24] <= tfawcon_window_c[24];
	end else begin
		tfawcon_window[24] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd25)) begin
		tfawcon_window[25] <= tfawcon_window_c[25];
	end else begin
		tfawcon_window[25] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd26)) begin
		tfawcon_window[26] <= tfawcon_window_c[26];
	end else begin
		tfawcon_window[26] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd27)) begin
		tfawcon_window[27] <= tfawcon_window_c[27];
	end else begin
		tfawcon_window[27] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd28)) begin
		tfawcon_window[28] <= tfawcon_window_c[28];
	end else begin
		tfawcon_window[28] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd29)) begin
		tfawcon_window[29] <= tfawcon_window_c[29];
	end else begin
		tfawcon_window[29] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd30)) begin
		tfawcon_window[30] <= tfawcon_window_c[30];
	end else begin
		tfawcon_window[30] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 5'd31)) begin
		tfawcon_window[31] <= tfawcon_window_c[31];
	end else begin
		tfawcon_window[31] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd32)) begin
		tfawcon_window[32] <= tfawcon_window_c[32];
	end else begin
		tfawcon_window[32] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd33)) begin
		tfawcon_window[33] <= tfawcon_window_c[33];
	end else begin
		tfawcon_window[33] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd34)) begin
		tfawcon_window[34] <= tfawcon_window_c[34];
	end else begin
		tfawcon_window[34] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd35)) begin
		tfawcon_window[35] <= tfawcon_window_c[35];
	end else begin
		tfawcon_window[35] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd36)) begin
		tfawcon_window[36] <= tfawcon_window_c[36];
	end else begin
		tfawcon_window[36] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd37)) begin
		tfawcon_window[37] <= tfawcon_window_c[37];
	end else begin
		tfawcon_window[37] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd38)) begin
		tfawcon_window[38] <= tfawcon_window_c[38];
	end else begin
		tfawcon_window[38] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd39)) begin
		tfawcon_window[39] <= tfawcon_window_c[39];
	end else begin
		tfawcon_window[39] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd40)) begin
		tfawcon_window[40] <= tfawcon_window_c[40];
	end else begin
		tfawcon_window[40] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd41)) begin
		tfawcon_window[41] <= tfawcon_window_c[41];
	end else begin
		tfawcon_window[41] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd42)) begin
		tfawcon_window[42] <= tfawcon_window_c[42];
	end else begin
		tfawcon_window[42] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd43)) begin
		tfawcon_window[43] <= tfawcon_window_c[43];
	end else begin
		tfawcon_window[43] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd44)) begin
		tfawcon_window[44] <= tfawcon_window_c[44];
	end else begin
		tfawcon_window[44] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd45)) begin
		tfawcon_window[45] <= tfawcon_window_c[45];
	end else begin
		tfawcon_window[45] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd46)) begin
		tfawcon_window[46] <= tfawcon_window_c[46];
	end else begin
		tfawcon_window[46] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd47)) begin
		tfawcon_window[47] <= tfawcon_window_c[47];
	end else begin
		tfawcon_window[47] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd48)) begin
		tfawcon_window[48] <= tfawcon_window_c[48];
	end else begin
		tfawcon_window[48] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd49)) begin
		tfawcon_window[49] <= tfawcon_window_c[49];
	end else begin
		tfawcon_window[49] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd50)) begin
		tfawcon_window[50] <= tfawcon_window_c[50];
	end else begin
		tfawcon_window[50] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd51)) begin
		tfawcon_window[51] <= tfawcon_window_c[51];
	end else begin
		tfawcon_window[51] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd52)) begin
		tfawcon_window[52] <= tfawcon_window_c[52];
	end else begin
		tfawcon_window[52] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd53)) begin
		tfawcon_window[53] <= tfawcon_window_c[53];
	end else begin
		tfawcon_window[53] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd54)) begin
		tfawcon_window[54] <= tfawcon_window_c[54];
	end else begin
		tfawcon_window[54] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd55)) begin
		tfawcon_window[55] <= tfawcon_window_c[55];
	end else begin
		tfawcon_window[55] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd56)) begin
		tfawcon_window[56] <= tfawcon_window_c[56];
	end else begin
		tfawcon_window[56] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd57)) begin
		tfawcon_window[57] <= tfawcon_window_c[57];
	end else begin
		tfawcon_window[57] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd58)) begin
		tfawcon_window[58] <= tfawcon_window_c[58];
	end else begin
		tfawcon_window[58] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd59)) begin
		tfawcon_window[59] <= tfawcon_window_c[59];
	end else begin
		tfawcon_window[59] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd60)) begin
		tfawcon_window[60] <= tfawcon_window_c[60];
	end else begin
		tfawcon_window[60] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd61)) begin
		tfawcon_window[61] <= tfawcon_window_c[61];
	end else begin
		tfawcon_window[61] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd62)) begin
		tfawcon_window[62] <= tfawcon_window_c[62];
	end else begin
		tfawcon_window[62] <= 1'd0;
	end
	if ((mul_tFAW_cfg > 6'd63)) begin
		tfawcon_window[63] <= tfawcon_window_c[63];
	end else begin
		tfawcon_window[63] <= 1'd0;
	end
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end
assign tfawcon_count = (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((tfawcon_window[0] + tfawcon_window[1]) + tfawcon_window[2]) + tfawcon_window[3]) + tfawcon_window[4]) + tfawcon_window[5]) + tfawcon_window[6]) + tfawcon_window[7]) + tfawcon_window[8]) + tfawcon_window[9]) + tfawcon_window[10]) + tfawcon_window[11]) + tfawcon_window[12]) + tfawcon_window[13]) + tfawcon_window[14]) + tfawcon_window[15]) + tfawcon_window[16]) + tfawcon_window[17]) + tfawcon_window[18]) + tfawcon_window[19]) + tfawcon_window[20]) + tfawcon_window[21]) + tfawcon_window[22]) + tfawcon_window[23]) + tfawcon_window[24]) + tfawcon_window[25]) + tfawcon_window[26]) + tfawcon_window[27]) + tfawcon_window[28]) + tfawcon_window[29]) + tfawcon_window[30]) + tfawcon_window[31]) + tfawcon_window[32]) + tfawcon_window[33]) + tfawcon_window[34]) + tfawcon_window[35]) + tfawcon_window[36]) + tfawcon_window[37]) + tfawcon_window[38]) + tfawcon_window[39]) + tfawcon_window[40]) + tfawcon_window[41]) + tfawcon_window[42]) + tfawcon_window[43]) + tfawcon_window[44]) + tfawcon_window[45]) + tfawcon_window[46]) + tfawcon_window[47]) + tfawcon_window[48]) + tfawcon_window[49]) + tfawcon_window[50]) + tfawcon_window[51]) + tfawcon_window[52]) + tfawcon_window[53]) + tfawcon_window[54]) + tfawcon_window[55]) + tfawcon_window[56]) + tfawcon_window[57]) + tfawcon_window[58]) + tfawcon_window[59]) + tfawcon_window[60]) + tfawcon_window[61]) + tfawcon_window[62]) + tfawcon_window[63]);

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	cmd_ready <= 1'd0;
	choose_req_want_reads <= 1'd0;
	choose_req_want_writes <= 1'd0;
	choose_req_want_activates <= 1'd0;
	choose_req_cmd_ready <= 1'd0;
	steerer_sel0 <= 2'd0;
	steerer_sel1 <= 2'd0;
	steerer_sel2 <= 2'd0;
	steerer_sel3 <= 2'd0;
	en0 <= 1'd0;
	en1 <= 1'd0;
	next_state <= 3'd0;
	choose_req_want_activates <= ras_allowed;
	next_state <= state;
	case (state)
		1'd1: begin
			en1 <= 1'd1;
			choose_req_want_writes <= 1'd1;
			if (1'd1) begin
				choose_req_cmd_ready <= (cas_allowed & ((~((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we))) | ras_allowed));
			end else begin
				choose_req_want_activates <= ras_allowed;
				choose_req_cmd_ready <= ((~((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we))) | ras_allowed);
				choose_req_cmd_ready <= cas_allowed;
			end
			steerer_sel0 <= 1'd0;
			if ((mul_wr_phase_cfg == 1'd0)) begin
				if (choose_req_cmd_payload_is_write) begin
					steerer_sel0 <= 2'd2;
				end
			end
			if ((mul_wrcmd_phase_cfg == 1'd0)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel0 <= 2'd2;
				end
			end
			steerer_sel1 <= 1'd0;
			if ((mul_wr_phase_cfg == 1'd1)) begin
				if (choose_req_cmd_payload_is_write) begin
					steerer_sel1 <= 2'd2;
				end
			end
			if ((mul_wrcmd_phase_cfg == 1'd1)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel1 <= 2'd2;
				end
			end
			steerer_sel2 <= 1'd0;
			if ((mul_wr_phase_cfg == 2'd2)) begin
				if (choose_req_cmd_payload_is_write) begin
					steerer_sel2 <= 2'd2;
				end
			end
			if ((mul_wrcmd_phase_cfg == 2'd2)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel2 <= 2'd2;
				end
			end
			steerer_sel3 <= 1'd0;
			if ((mul_wr_phase_cfg == 2'd3)) begin
				if (choose_req_cmd_payload_is_write) begin
					steerer_sel3 <= 2'd2;
				end
			end
			if ((mul_wrcmd_phase_cfg == 2'd3)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel3 <= 2'd2;
				end
			end
			if (read_available) begin
				if (((~write_available) | max_time1)) begin
					next_state <= 2'd3;
				end
			end
			if (go_to_refresh) begin
				next_state <= 2'd2;
			end
		end
		2'd2: begin
			steerer_sel0 <= 2'd3;
			cmd_ready <= 1'd1;
			if (cmd_last) begin
				next_state <= 1'd0;
			end
		end
		2'd3: begin
			if (twtrcon_ready) begin
				next_state <= 1'd0;
			end
		end
		3'd4: begin
			if (trtwcon_ready) begin
				next_state <= 1'd1;
			end
		end
		default: begin
			en0 <= 1'd1;
			choose_req_want_reads <= 1'd1;
			if (1'd1) begin
				choose_req_cmd_ready <= (cas_allowed & ((~((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we))) | ras_allowed));
			end else begin
				choose_req_want_activates <= ras_allowed;
				choose_req_cmd_ready <= ((~((choose_req_cmd_payload_ras & (~choose_req_cmd_payload_cas)) & (~choose_req_cmd_payload_we))) | ras_allowed);
				choose_req_cmd_ready <= cas_allowed;
			end
			steerer_sel0 <= 1'd0;
			if ((mul_rd_phase_cfg == 1'd0)) begin
				if (choose_req_cmd_payload_is_read) begin
					steerer_sel0 <= 2'd2;
				end
			end
			if ((mul_rdcmd_phase_cfg == 1'd0)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel0 <= 2'd2;
				end
			end
			steerer_sel1 <= 1'd0;
			if ((mul_rd_phase_cfg == 1'd1)) begin
				if (choose_req_cmd_payload_is_read) begin
					steerer_sel1 <= 2'd2;
				end
			end
			if ((mul_rdcmd_phase_cfg == 1'd1)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel1 <= 2'd2;
				end
			end
			steerer_sel2 <= 1'd0;
			if ((mul_rd_phase_cfg == 2'd2)) begin
				if (choose_req_cmd_payload_is_read) begin
					steerer_sel2 <= 2'd2;
				end
			end
			if ((mul_rdcmd_phase_cfg == 2'd2)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel2 <= 2'd2;
				end
			end
			steerer_sel3 <= 1'd0;
			if ((mul_rd_phase_cfg == 2'd3)) begin
				if (choose_req_cmd_payload_is_read) begin
					steerer_sel3 <= 2'd2;
				end
			end
			if ((mul_rdcmd_phase_cfg == 2'd3)) begin
				if (choose_req_cmd_payload_is_cmd) begin
					steerer_sel3 <= 2'd2;
				end
			end
			if (write_available) begin
				if (((~read_available) | max_time0)) begin
					next_state <= 3'd4;
				end
			end
			if (go_to_refresh) begin
				next_state <= 2'd2;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_19 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed0 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed0 <= choose_cmd_valids[0];
		end
		1'd1: begin
			rhs_array_muxed0 <= choose_cmd_valids[1];
		end
		2'd2: begin
			rhs_array_muxed0 <= choose_cmd_valids[2];
		end
		2'd3: begin
			rhs_array_muxed0 <= choose_cmd_valids[3];
		end
		3'd4: begin
			rhs_array_muxed0 <= choose_cmd_valids[4];
		end
		3'd5: begin
			rhs_array_muxed0 <= choose_cmd_valids[5];
		end
		3'd6: begin
			rhs_array_muxed0 <= choose_cmd_valids[6];
		end
		default: begin
			rhs_array_muxed0 <= choose_cmd_valids[7];
		end
	endcase
// synthesis translate_off
	dummy_d_20 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_21;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed1 <= 17'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed1 <= cmd_payload_a_1;
		end
		1'd1: begin
			rhs_array_muxed1 <= cmd_payload_a_2;
		end
		2'd2: begin
			rhs_array_muxed1 <= cmd_payload_a_3;
		end
		2'd3: begin
			rhs_array_muxed1 <= cmd_payload_a_4;
		end
		3'd4: begin
			rhs_array_muxed1 <= cmd_payload_a_5;
		end
		3'd5: begin
			rhs_array_muxed1 <= cmd_payload_a_6;
		end
		3'd6: begin
			rhs_array_muxed1 <= cmd_payload_a_7;
		end
		default: begin
			rhs_array_muxed1 <= cmd_payload_a_8;
		end
	endcase
// synthesis translate_off
	dummy_d_21 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed2 <= 3'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed2 <= cmd_payload_ba_1;
		end
		1'd1: begin
			rhs_array_muxed2 <= cmd_payload_ba_2;
		end
		2'd2: begin
			rhs_array_muxed2 <= cmd_payload_ba_3;
		end
		2'd3: begin
			rhs_array_muxed2 <= cmd_payload_ba_4;
		end
		3'd4: begin
			rhs_array_muxed2 <= cmd_payload_ba_5;
		end
		3'd5: begin
			rhs_array_muxed2 <= cmd_payload_ba_6;
		end
		3'd6: begin
			rhs_array_muxed2 <= cmd_payload_ba_7;
		end
		default: begin
			rhs_array_muxed2 <= cmd_payload_ba_8;
		end
	endcase
// synthesis translate_off
	dummy_d_22 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed3 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed3 <= cmd_payload_is_read_1;
		end
		1'd1: begin
			rhs_array_muxed3 <= cmd_payload_is_read_2;
		end
		2'd2: begin
			rhs_array_muxed3 <= cmd_payload_is_read_3;
		end
		2'd3: begin
			rhs_array_muxed3 <= cmd_payload_is_read_4;
		end
		3'd4: begin
			rhs_array_muxed3 <= cmd_payload_is_read_5;
		end
		3'd5: begin
			rhs_array_muxed3 <= cmd_payload_is_read_6;
		end
		3'd6: begin
			rhs_array_muxed3 <= cmd_payload_is_read_7;
		end
		default: begin
			rhs_array_muxed3 <= cmd_payload_is_read_8;
		end
	endcase
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed4 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed4 <= cmd_payload_is_write_1;
		end
		1'd1: begin
			rhs_array_muxed4 <= cmd_payload_is_write_2;
		end
		2'd2: begin
			rhs_array_muxed4 <= cmd_payload_is_write_3;
		end
		2'd3: begin
			rhs_array_muxed4 <= cmd_payload_is_write_4;
		end
		3'd4: begin
			rhs_array_muxed4 <= cmd_payload_is_write_5;
		end
		3'd5: begin
			rhs_array_muxed4 <= cmd_payload_is_write_6;
		end
		3'd6: begin
			rhs_array_muxed4 <= cmd_payload_is_write_7;
		end
		default: begin
			rhs_array_muxed4 <= cmd_payload_is_write_8;
		end
	endcase
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_25;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed5 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_1;
		end
		1'd1: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_2;
		end
		2'd2: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_3;
		end
		2'd3: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_4;
		end
		3'd4: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_5;
		end
		3'd5: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_6;
		end
		3'd6: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_7;
		end
		default: begin
			rhs_array_muxed5 <= cmd_payload_is_cmd_8;
		end
	endcase
// synthesis translate_off
	dummy_d_25 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	t_array_muxed0 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			t_array_muxed0 <= cmd_payload_cas_1;
		end
		1'd1: begin
			t_array_muxed0 <= cmd_payload_cas_2;
		end
		2'd2: begin
			t_array_muxed0 <= cmd_payload_cas_3;
		end
		2'd3: begin
			t_array_muxed0 <= cmd_payload_cas_4;
		end
		3'd4: begin
			t_array_muxed0 <= cmd_payload_cas_5;
		end
		3'd5: begin
			t_array_muxed0 <= cmd_payload_cas_6;
		end
		3'd6: begin
			t_array_muxed0 <= cmd_payload_cas_7;
		end
		default: begin
			t_array_muxed0 <= cmd_payload_cas_8;
		end
	endcase
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	t_array_muxed1 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			t_array_muxed1 <= cmd_payload_ras_1;
		end
		1'd1: begin
			t_array_muxed1 <= cmd_payload_ras_2;
		end
		2'd2: begin
			t_array_muxed1 <= cmd_payload_ras_3;
		end
		2'd3: begin
			t_array_muxed1 <= cmd_payload_ras_4;
		end
		3'd4: begin
			t_array_muxed1 <= cmd_payload_ras_5;
		end
		3'd5: begin
			t_array_muxed1 <= cmd_payload_ras_6;
		end
		3'd6: begin
			t_array_muxed1 <= cmd_payload_ras_7;
		end
		default: begin
			t_array_muxed1 <= cmd_payload_ras_8;
		end
	endcase
// synthesis translate_off
	dummy_d_27 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_28;
// synthesis translate_on
always @(*) begin
	t_array_muxed2 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			t_array_muxed2 <= cmd_payload_we_1;
		end
		1'd1: begin
			t_array_muxed2 <= cmd_payload_we_2;
		end
		2'd2: begin
			t_array_muxed2 <= cmd_payload_we_3;
		end
		2'd3: begin
			t_array_muxed2 <= cmd_payload_we_4;
		end
		3'd4: begin
			t_array_muxed2 <= cmd_payload_we_5;
		end
		3'd5: begin
			t_array_muxed2 <= cmd_payload_we_6;
		end
		3'd6: begin
			t_array_muxed2 <= cmd_payload_we_7;
		end
		default: begin
			t_array_muxed2 <= cmd_payload_we_8;
		end
	endcase
// synthesis translate_off
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_29;
// synthesis translate_on
always @(*) begin
	t_array_muxed3 <= 1'd0;
	case (choose_cmd_grant)
		1'd0: begin
			t_array_muxed3 <= cmd_payload_is_mw_1;
		end
		1'd1: begin
			t_array_muxed3 <= cmd_payload_is_mw_2;
		end
		2'd2: begin
			t_array_muxed3 <= cmd_payload_is_mw_3;
		end
		2'd3: begin
			t_array_muxed3 <= cmd_payload_is_mw_4;
		end
		3'd4: begin
			t_array_muxed3 <= cmd_payload_is_mw_5;
		end
		3'd5: begin
			t_array_muxed3 <= cmd_payload_is_mw_6;
		end
		3'd6: begin
			t_array_muxed3 <= cmd_payload_is_mw_7;
		end
		default: begin
			t_array_muxed3 <= cmd_payload_is_mw_8;
		end
	endcase
// synthesis translate_off
	dummy_d_29 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed6 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed6 <= choose_req_valids[0];
		end
		1'd1: begin
			rhs_array_muxed6 <= choose_req_valids[1];
		end
		2'd2: begin
			rhs_array_muxed6 <= choose_req_valids[2];
		end
		2'd3: begin
			rhs_array_muxed6 <= choose_req_valids[3];
		end
		3'd4: begin
			rhs_array_muxed6 <= choose_req_valids[4];
		end
		3'd5: begin
			rhs_array_muxed6 <= choose_req_valids[5];
		end
		3'd6: begin
			rhs_array_muxed6 <= choose_req_valids[6];
		end
		default: begin
			rhs_array_muxed6 <= choose_req_valids[7];
		end
	endcase
// synthesis translate_off
	dummy_d_30 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_31;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed7 <= 17'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed7 <= cmd_payload_a_1;
		end
		1'd1: begin
			rhs_array_muxed7 <= cmd_payload_a_2;
		end
		2'd2: begin
			rhs_array_muxed7 <= cmd_payload_a_3;
		end
		2'd3: begin
			rhs_array_muxed7 <= cmd_payload_a_4;
		end
		3'd4: begin
			rhs_array_muxed7 <= cmd_payload_a_5;
		end
		3'd5: begin
			rhs_array_muxed7 <= cmd_payload_a_6;
		end
		3'd6: begin
			rhs_array_muxed7 <= cmd_payload_a_7;
		end
		default: begin
			rhs_array_muxed7 <= cmd_payload_a_8;
		end
	endcase
// synthesis translate_off
	dummy_d_31 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed8 <= 3'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed8 <= cmd_payload_ba_1;
		end
		1'd1: begin
			rhs_array_muxed8 <= cmd_payload_ba_2;
		end
		2'd2: begin
			rhs_array_muxed8 <= cmd_payload_ba_3;
		end
		2'd3: begin
			rhs_array_muxed8 <= cmd_payload_ba_4;
		end
		3'd4: begin
			rhs_array_muxed8 <= cmd_payload_ba_5;
		end
		3'd5: begin
			rhs_array_muxed8 <= cmd_payload_ba_6;
		end
		3'd6: begin
			rhs_array_muxed8 <= cmd_payload_ba_7;
		end
		default: begin
			rhs_array_muxed8 <= cmd_payload_ba_8;
		end
	endcase
// synthesis translate_off
	dummy_d_32 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed9 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed9 <= cmd_payload_is_read_1;
		end
		1'd1: begin
			rhs_array_muxed9 <= cmd_payload_is_read_2;
		end
		2'd2: begin
			rhs_array_muxed9 <= cmd_payload_is_read_3;
		end
		2'd3: begin
			rhs_array_muxed9 <= cmd_payload_is_read_4;
		end
		3'd4: begin
			rhs_array_muxed9 <= cmd_payload_is_read_5;
		end
		3'd5: begin
			rhs_array_muxed9 <= cmd_payload_is_read_6;
		end
		3'd6: begin
			rhs_array_muxed9 <= cmd_payload_is_read_7;
		end
		default: begin
			rhs_array_muxed9 <= cmd_payload_is_read_8;
		end
	endcase
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed10 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed10 <= cmd_payload_is_write_1;
		end
		1'd1: begin
			rhs_array_muxed10 <= cmd_payload_is_write_2;
		end
		2'd2: begin
			rhs_array_muxed10 <= cmd_payload_is_write_3;
		end
		2'd3: begin
			rhs_array_muxed10 <= cmd_payload_is_write_4;
		end
		3'd4: begin
			rhs_array_muxed10 <= cmd_payload_is_write_5;
		end
		3'd5: begin
			rhs_array_muxed10 <= cmd_payload_is_write_6;
		end
		3'd6: begin
			rhs_array_muxed10 <= cmd_payload_is_write_7;
		end
		default: begin
			rhs_array_muxed10 <= cmd_payload_is_write_8;
		end
	endcase
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	rhs_array_muxed11 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_1;
		end
		1'd1: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_2;
		end
		2'd2: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_3;
		end
		2'd3: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_4;
		end
		3'd4: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_5;
		end
		3'd5: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_6;
		end
		3'd6: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_7;
		end
		default: begin
			rhs_array_muxed11 <= cmd_payload_is_cmd_8;
		end
	endcase
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	t_array_muxed4 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			t_array_muxed4 <= cmd_payload_cas_1;
		end
		1'd1: begin
			t_array_muxed4 <= cmd_payload_cas_2;
		end
		2'd2: begin
			t_array_muxed4 <= cmd_payload_cas_3;
		end
		2'd3: begin
			t_array_muxed4 <= cmd_payload_cas_4;
		end
		3'd4: begin
			t_array_muxed4 <= cmd_payload_cas_5;
		end
		3'd5: begin
			t_array_muxed4 <= cmd_payload_cas_6;
		end
		3'd6: begin
			t_array_muxed4 <= cmd_payload_cas_7;
		end
		default: begin
			t_array_muxed4 <= cmd_payload_cas_8;
		end
	endcase
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	t_array_muxed5 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			t_array_muxed5 <= cmd_payload_ras_1;
		end
		1'd1: begin
			t_array_muxed5 <= cmd_payload_ras_2;
		end
		2'd2: begin
			t_array_muxed5 <= cmd_payload_ras_3;
		end
		2'd3: begin
			t_array_muxed5 <= cmd_payload_ras_4;
		end
		3'd4: begin
			t_array_muxed5 <= cmd_payload_ras_5;
		end
		3'd5: begin
			t_array_muxed5 <= cmd_payload_ras_6;
		end
		3'd6: begin
			t_array_muxed5 <= cmd_payload_ras_7;
		end
		default: begin
			t_array_muxed5 <= cmd_payload_ras_8;
		end
	endcase
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	t_array_muxed6 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			t_array_muxed6 <= cmd_payload_we_1;
		end
		1'd1: begin
			t_array_muxed6 <= cmd_payload_we_2;
		end
		2'd2: begin
			t_array_muxed6 <= cmd_payload_we_3;
		end
		2'd3: begin
			t_array_muxed6 <= cmd_payload_we_4;
		end
		3'd4: begin
			t_array_muxed6 <= cmd_payload_we_5;
		end
		3'd5: begin
			t_array_muxed6 <= cmd_payload_we_6;
		end
		3'd6: begin
			t_array_muxed6 <= cmd_payload_we_7;
		end
		default: begin
			t_array_muxed6 <= cmd_payload_we_8;
		end
	endcase
// synthesis translate_off
	dummy_d_38 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_39;
// synthesis translate_on
always @(*) begin
	t_array_muxed7 <= 1'd0;
	case (choose_req_grant)
		1'd0: begin
			t_array_muxed7 <= cmd_payload_is_mw_1;
		end
		1'd1: begin
			t_array_muxed7 <= cmd_payload_is_mw_2;
		end
		2'd2: begin
			t_array_muxed7 <= cmd_payload_is_mw_3;
		end
		2'd3: begin
			t_array_muxed7 <= cmd_payload_is_mw_4;
		end
		3'd4: begin
			t_array_muxed7 <= cmd_payload_is_mw_5;
		end
		3'd5: begin
			t_array_muxed7 <= cmd_payload_is_mw_6;
		end
		3'd6: begin
			t_array_muxed7 <= cmd_payload_is_mw_7;
		end
		default: begin
			t_array_muxed7 <= cmd_payload_is_mw_8;
		end
	endcase
// synthesis translate_off
	dummy_d_39 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_40;
// synthesis translate_on
always @(*) begin
	array_muxed0 <= 3'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed0 <= nop_ba[2:0];
		end
		1'd1: begin
			array_muxed0 <= choose_req_cmd_payload_ba[2:0];
		end
		2'd2: begin
			array_muxed0 <= choose_req_cmd_payload_ba[2:0];
		end
		default: begin
			array_muxed0 <= cmd_payload_ba[2:0];
		end
	endcase
// synthesis translate_off
	dummy_d_40 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_41;
// synthesis translate_on
always @(*) begin
	array_muxed1 <= 17'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed1 <= nop_a;
		end
		1'd1: begin
			array_muxed1 <= choose_req_cmd_payload_a;
		end
		2'd2: begin
			array_muxed1 <= choose_req_cmd_payload_a;
		end
		default: begin
			array_muxed1 <= cmd_payload_a;
		end
	endcase
// synthesis translate_off
	dummy_d_41 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_42;
// synthesis translate_on
always @(*) begin
	array_muxed2 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed2 <= 1'd0;
		end
		1'd1: begin
			array_muxed2 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		2'd2: begin
			array_muxed2 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		default: begin
			array_muxed2 <= ((cmd_valid & cmd_ready) & cmd_payload_cas);
		end
	endcase
// synthesis translate_off
	dummy_d_42 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_43;
// synthesis translate_on
always @(*) begin
	array_muxed3 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed3 <= 1'd0;
		end
		1'd1: begin
			array_muxed3 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		2'd2: begin
			array_muxed3 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		default: begin
			array_muxed3 <= ((cmd_valid & cmd_ready) & cmd_payload_ras);
		end
	endcase
// synthesis translate_off
	dummy_d_43 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_44;
// synthesis translate_on
always @(*) begin
	array_muxed4 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed4 <= 1'd0;
		end
		1'd1: begin
			array_muxed4 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		2'd2: begin
			array_muxed4 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		default: begin
			array_muxed4 <= ((cmd_valid & cmd_ready) & cmd_payload_we);
		end
	endcase
// synthesis translate_off
	dummy_d_44 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_45;
// synthesis translate_on
always @(*) begin
	array_muxed5 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed5 <= 1'd0;
		end
		1'd1: begin
			array_muxed5 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		2'd2: begin
			array_muxed5 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		default: begin
			array_muxed5 <= ((cmd_valid & cmd_ready) & cmd_payload_is_mw);
		end
	endcase
// synthesis translate_off
	dummy_d_45 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_46;
// synthesis translate_on
always @(*) begin
	array_muxed6 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed6 <= 1'd0;
		end
		1'd1: begin
			array_muxed6 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed6 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed6 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_46 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_47;
// synthesis translate_on
always @(*) begin
	array_muxed7 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed7 <= 1'd0;
		end
		1'd1: begin
			array_muxed7 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed7 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed7 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_47 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_48;
// synthesis translate_on
always @(*) begin
	array_muxed8 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed8 <= 1'd0;
		end
		1'd1: begin
			array_muxed8 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed8 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed8 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_48 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_49;
// synthesis translate_on
always @(*) begin
	array_muxed9 <= 1'd0;
	case (steerer_sel0)
		1'd0: begin
			array_muxed9 <= 1'd0;
		end
		1'd1: begin
			array_muxed9 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed9 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed9 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_49 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_50;
// synthesis translate_on
always @(*) begin
	array_muxed10 <= 3'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed10 <= nop_ba[2:0];
		end
		1'd1: begin
			array_muxed10 <= choose_req_cmd_payload_ba[2:0];
		end
		2'd2: begin
			array_muxed10 <= choose_req_cmd_payload_ba[2:0];
		end
		default: begin
			array_muxed10 <= cmd_payload_ba[2:0];
		end
	endcase
// synthesis translate_off
	dummy_d_50 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_51;
// synthesis translate_on
always @(*) begin
	array_muxed11 <= 17'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed11 <= nop_a;
		end
		1'd1: begin
			array_muxed11 <= choose_req_cmd_payload_a;
		end
		2'd2: begin
			array_muxed11 <= choose_req_cmd_payload_a;
		end
		default: begin
			array_muxed11 <= cmd_payload_a;
		end
	endcase
// synthesis translate_off
	dummy_d_51 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_52;
// synthesis translate_on
always @(*) begin
	array_muxed12 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed12 <= 1'd0;
		end
		1'd1: begin
			array_muxed12 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		2'd2: begin
			array_muxed12 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		default: begin
			array_muxed12 <= ((cmd_valid & cmd_ready) & cmd_payload_cas);
		end
	endcase
// synthesis translate_off
	dummy_d_52 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_53;
// synthesis translate_on
always @(*) begin
	array_muxed13 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed13 <= 1'd0;
		end
		1'd1: begin
			array_muxed13 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		2'd2: begin
			array_muxed13 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		default: begin
			array_muxed13 <= ((cmd_valid & cmd_ready) & cmd_payload_ras);
		end
	endcase
// synthesis translate_off
	dummy_d_53 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_54;
// synthesis translate_on
always @(*) begin
	array_muxed14 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed14 <= 1'd0;
		end
		1'd1: begin
			array_muxed14 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		2'd2: begin
			array_muxed14 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		default: begin
			array_muxed14 <= ((cmd_valid & cmd_ready) & cmd_payload_we);
		end
	endcase
// synthesis translate_off
	dummy_d_54 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_55;
// synthesis translate_on
always @(*) begin
	array_muxed15 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed15 <= 1'd0;
		end
		1'd1: begin
			array_muxed15 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		2'd2: begin
			array_muxed15 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		default: begin
			array_muxed15 <= ((cmd_valid & cmd_ready) & cmd_payload_is_mw);
		end
	endcase
// synthesis translate_off
	dummy_d_55 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_56;
// synthesis translate_on
always @(*) begin
	array_muxed16 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed16 <= 1'd0;
		end
		1'd1: begin
			array_muxed16 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed16 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed16 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_56 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_57;
// synthesis translate_on
always @(*) begin
	array_muxed17 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed17 <= 1'd0;
		end
		1'd1: begin
			array_muxed17 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed17 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed17 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_57 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_58;
// synthesis translate_on
always @(*) begin
	array_muxed18 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed18 <= 1'd0;
		end
		1'd1: begin
			array_muxed18 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed18 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed18 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_58 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_59;
// synthesis translate_on
always @(*) begin
	array_muxed19 <= 1'd0;
	case (steerer_sel1)
		1'd0: begin
			array_muxed19 <= 1'd0;
		end
		1'd1: begin
			array_muxed19 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed19 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed19 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_59 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_60;
// synthesis translate_on
always @(*) begin
	array_muxed20 <= 3'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed20 <= nop_ba[2:0];
		end
		1'd1: begin
			array_muxed20 <= choose_req_cmd_payload_ba[2:0];
		end
		2'd2: begin
			array_muxed20 <= choose_req_cmd_payload_ba[2:0];
		end
		default: begin
			array_muxed20 <= cmd_payload_ba[2:0];
		end
	endcase
// synthesis translate_off
	dummy_d_60 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_61;
// synthesis translate_on
always @(*) begin
	array_muxed21 <= 17'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed21 <= nop_a;
		end
		1'd1: begin
			array_muxed21 <= choose_req_cmd_payload_a;
		end
		2'd2: begin
			array_muxed21 <= choose_req_cmd_payload_a;
		end
		default: begin
			array_muxed21 <= cmd_payload_a;
		end
	endcase
// synthesis translate_off
	dummy_d_61 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_62;
// synthesis translate_on
always @(*) begin
	array_muxed22 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed22 <= 1'd0;
		end
		1'd1: begin
			array_muxed22 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		2'd2: begin
			array_muxed22 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		default: begin
			array_muxed22 <= ((cmd_valid & cmd_ready) & cmd_payload_cas);
		end
	endcase
// synthesis translate_off
	dummy_d_62 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_63;
// synthesis translate_on
always @(*) begin
	array_muxed23 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed23 <= 1'd0;
		end
		1'd1: begin
			array_muxed23 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		2'd2: begin
			array_muxed23 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		default: begin
			array_muxed23 <= ((cmd_valid & cmd_ready) & cmd_payload_ras);
		end
	endcase
// synthesis translate_off
	dummy_d_63 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_64;
// synthesis translate_on
always @(*) begin
	array_muxed24 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed24 <= 1'd0;
		end
		1'd1: begin
			array_muxed24 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		2'd2: begin
			array_muxed24 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		default: begin
			array_muxed24 <= ((cmd_valid & cmd_ready) & cmd_payload_we);
		end
	endcase
// synthesis translate_off
	dummy_d_64 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_65;
// synthesis translate_on
always @(*) begin
	array_muxed25 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed25 <= 1'd0;
		end
		1'd1: begin
			array_muxed25 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		2'd2: begin
			array_muxed25 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		default: begin
			array_muxed25 <= ((cmd_valid & cmd_ready) & cmd_payload_is_mw);
		end
	endcase
// synthesis translate_off
	dummy_d_65 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_66;
// synthesis translate_on
always @(*) begin
	array_muxed26 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed26 <= 1'd0;
		end
		1'd1: begin
			array_muxed26 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed26 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed26 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_66 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_67;
// synthesis translate_on
always @(*) begin
	array_muxed27 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed27 <= 1'd0;
		end
		1'd1: begin
			array_muxed27 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed27 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed27 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_67 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_68;
// synthesis translate_on
always @(*) begin
	array_muxed28 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed28 <= 1'd0;
		end
		1'd1: begin
			array_muxed28 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed28 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed28 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_68 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_69;
// synthesis translate_on
always @(*) begin
	array_muxed29 <= 1'd0;
	case (steerer_sel2)
		1'd0: begin
			array_muxed29 <= 1'd0;
		end
		1'd1: begin
			array_muxed29 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed29 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed29 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_69 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_70;
// synthesis translate_on
always @(*) begin
	array_muxed30 <= 3'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed30 <= nop_ba[2:0];
		end
		1'd1: begin
			array_muxed30 <= choose_req_cmd_payload_ba[2:0];
		end
		2'd2: begin
			array_muxed30 <= choose_req_cmd_payload_ba[2:0];
		end
		default: begin
			array_muxed30 <= cmd_payload_ba[2:0];
		end
	endcase
// synthesis translate_off
	dummy_d_70 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_71;
// synthesis translate_on
always @(*) begin
	array_muxed31 <= 17'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed31 <= nop_a;
		end
		1'd1: begin
			array_muxed31 <= choose_req_cmd_payload_a;
		end
		2'd2: begin
			array_muxed31 <= choose_req_cmd_payload_a;
		end
		default: begin
			array_muxed31 <= cmd_payload_a;
		end
	endcase
// synthesis translate_off
	dummy_d_71 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_72;
// synthesis translate_on
always @(*) begin
	array_muxed32 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed32 <= 1'd0;
		end
		1'd1: begin
			array_muxed32 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		2'd2: begin
			array_muxed32 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_cas);
		end
		default: begin
			array_muxed32 <= ((cmd_valid & cmd_ready) & cmd_payload_cas);
		end
	endcase
// synthesis translate_off
	dummy_d_72 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_73;
// synthesis translate_on
always @(*) begin
	array_muxed33 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed33 <= 1'd0;
		end
		1'd1: begin
			array_muxed33 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		2'd2: begin
			array_muxed33 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_ras);
		end
		default: begin
			array_muxed33 <= ((cmd_valid & cmd_ready) & cmd_payload_ras);
		end
	endcase
// synthesis translate_off
	dummy_d_73 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_74;
// synthesis translate_on
always @(*) begin
	array_muxed34 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed34 <= 1'd0;
		end
		1'd1: begin
			array_muxed34 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		2'd2: begin
			array_muxed34 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_we);
		end
		default: begin
			array_muxed34 <= ((cmd_valid & cmd_ready) & cmd_payload_we);
		end
	endcase
// synthesis translate_off
	dummy_d_74 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_75;
// synthesis translate_on
always @(*) begin
	array_muxed35 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed35 <= 1'd0;
		end
		1'd1: begin
			array_muxed35 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		2'd2: begin
			array_muxed35 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_mw);
		end
		default: begin
			array_muxed35 <= ((cmd_valid & cmd_ready) & cmd_payload_is_mw);
		end
	endcase
// synthesis translate_off
	dummy_d_75 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_76;
// synthesis translate_on
always @(*) begin
	array_muxed36 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed36 <= 1'd0;
		end
		1'd1: begin
			array_muxed36 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed36 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed36 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_76 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_77;
// synthesis translate_on
always @(*) begin
	array_muxed37 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed37 <= 1'd0;
		end
		1'd1: begin
			array_muxed37 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed37 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed37 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_77 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_78;
// synthesis translate_on
always @(*) begin
	array_muxed38 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed38 <= 1'd0;
		end
		1'd1: begin
			array_muxed38 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		2'd2: begin
			array_muxed38 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_read);
		end
		default: begin
			array_muxed38 <= ((cmd_valid & cmd_ready) & cmd_payload_is_read);
		end
	endcase
// synthesis translate_off
	dummy_d_78 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_79;
// synthesis translate_on
always @(*) begin
	array_muxed39 <= 1'd0;
	case (steerer_sel3)
		1'd0: begin
			array_muxed39 <= 1'd0;
		end
		1'd1: begin
			array_muxed39 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		2'd2: begin
			array_muxed39 <= ((choose_req_cmd_valid & choose_req_cmd_ready) & choose_req_cmd_payload_is_write);
		end
		default: begin
			array_muxed39 <= ((cmd_valid & cmd_ready) & cmd_payload_is_write);
		end
	endcase
// synthesis translate_off
	dummy_d_79 <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	if ((~en0)) begin
		time0 <= (mul_READ_TIME_cfg - 1'd1);
	end else begin
		if ((~max_time0)) begin
			time0 <= (time0 - 1'd1);
		end
	end
	if ((~en1)) begin
		time1 <= (mul_WRITE_TIME_cfg - 1'd1);
	end else begin
		if ((~max_time1)) begin
			time1 <= (time1 - 1'd1);
		end
	end
	if (choose_cmd_ce) begin
		case (choose_cmd_grant)
			1'd0: begin
				if (choose_cmd_request[1]) begin
					choose_cmd_grant <= 1'd1;
				end else begin
					if (choose_cmd_request[2]) begin
						choose_cmd_grant <= 2'd2;
					end else begin
						if (choose_cmd_request[3]) begin
							choose_cmd_grant <= 2'd3;
						end else begin
							if (choose_cmd_request[4]) begin
								choose_cmd_grant <= 3'd4;
							end else begin
								if (choose_cmd_request[5]) begin
									choose_cmd_grant <= 3'd5;
								end else begin
									if (choose_cmd_request[6]) begin
										choose_cmd_grant <= 3'd6;
									end else begin
										if (choose_cmd_request[7]) begin
											choose_cmd_grant <= 3'd7;
										end
									end
								end
							end
						end
					end
				end
			end
			1'd1: begin
				if (choose_cmd_request[2]) begin
					choose_cmd_grant <= 2'd2;
				end else begin
					if (choose_cmd_request[3]) begin
						choose_cmd_grant <= 2'd3;
					end else begin
						if (choose_cmd_request[4]) begin
							choose_cmd_grant <= 3'd4;
						end else begin
							if (choose_cmd_request[5]) begin
								choose_cmd_grant <= 3'd5;
							end else begin
								if (choose_cmd_request[6]) begin
									choose_cmd_grant <= 3'd6;
								end else begin
									if (choose_cmd_request[7]) begin
										choose_cmd_grant <= 3'd7;
									end else begin
										if (choose_cmd_request[0]) begin
											choose_cmd_grant <= 1'd0;
										end
									end
								end
							end
						end
					end
				end
			end
			2'd2: begin
				if (choose_cmd_request[3]) begin
					choose_cmd_grant <= 2'd3;
				end else begin
					if (choose_cmd_request[4]) begin
						choose_cmd_grant <= 3'd4;
					end else begin
						if (choose_cmd_request[5]) begin
							choose_cmd_grant <= 3'd5;
						end else begin
							if (choose_cmd_request[6]) begin
								choose_cmd_grant <= 3'd6;
							end else begin
								if (choose_cmd_request[7]) begin
									choose_cmd_grant <= 3'd7;
								end else begin
									if (choose_cmd_request[0]) begin
										choose_cmd_grant <= 1'd0;
									end else begin
										if (choose_cmd_request[1]) begin
											choose_cmd_grant <= 1'd1;
										end
									end
								end
							end
						end
					end
				end
			end
			2'd3: begin
				if (choose_cmd_request[4]) begin
					choose_cmd_grant <= 3'd4;
				end else begin
					if (choose_cmd_request[5]) begin
						choose_cmd_grant <= 3'd5;
					end else begin
						if (choose_cmd_request[6]) begin
							choose_cmd_grant <= 3'd6;
						end else begin
							if (choose_cmd_request[7]) begin
								choose_cmd_grant <= 3'd7;
							end else begin
								if (choose_cmd_request[0]) begin
									choose_cmd_grant <= 1'd0;
								end else begin
									if (choose_cmd_request[1]) begin
										choose_cmd_grant <= 1'd1;
									end else begin
										if (choose_cmd_request[2]) begin
											choose_cmd_grant <= 2'd2;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd4: begin
				if (choose_cmd_request[5]) begin
					choose_cmd_grant <= 3'd5;
				end else begin
					if (choose_cmd_request[6]) begin
						choose_cmd_grant <= 3'd6;
					end else begin
						if (choose_cmd_request[7]) begin
							choose_cmd_grant <= 3'd7;
						end else begin
							if (choose_cmd_request[0]) begin
								choose_cmd_grant <= 1'd0;
							end else begin
								if (choose_cmd_request[1]) begin
									choose_cmd_grant <= 1'd1;
								end else begin
									if (choose_cmd_request[2]) begin
										choose_cmd_grant <= 2'd2;
									end else begin
										if (choose_cmd_request[3]) begin
											choose_cmd_grant <= 2'd3;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd5: begin
				if (choose_cmd_request[6]) begin
					choose_cmd_grant <= 3'd6;
				end else begin
					if (choose_cmd_request[7]) begin
						choose_cmd_grant <= 3'd7;
					end else begin
						if (choose_cmd_request[0]) begin
							choose_cmd_grant <= 1'd0;
						end else begin
							if (choose_cmd_request[1]) begin
								choose_cmd_grant <= 1'd1;
							end else begin
								if (choose_cmd_request[2]) begin
									choose_cmd_grant <= 2'd2;
								end else begin
									if (choose_cmd_request[3]) begin
										choose_cmd_grant <= 2'd3;
									end else begin
										if (choose_cmd_request[4]) begin
											choose_cmd_grant <= 3'd4;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd6: begin
				if (choose_cmd_request[7]) begin
					choose_cmd_grant <= 3'd7;
				end else begin
					if (choose_cmd_request[0]) begin
						choose_cmd_grant <= 1'd0;
					end else begin
						if (choose_cmd_request[1]) begin
							choose_cmd_grant <= 1'd1;
						end else begin
							if (choose_cmd_request[2]) begin
								choose_cmd_grant <= 2'd2;
							end else begin
								if (choose_cmd_request[3]) begin
									choose_cmd_grant <= 2'd3;
								end else begin
									if (choose_cmd_request[4]) begin
										choose_cmd_grant <= 3'd4;
									end else begin
										if (choose_cmd_request[5]) begin
											choose_cmd_grant <= 3'd5;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd7: begin
				if (choose_cmd_request[0]) begin
					choose_cmd_grant <= 1'd0;
				end else begin
					if (choose_cmd_request[1]) begin
						choose_cmd_grant <= 1'd1;
					end else begin
						if (choose_cmd_request[2]) begin
							choose_cmd_grant <= 2'd2;
						end else begin
							if (choose_cmd_request[3]) begin
								choose_cmd_grant <= 2'd3;
							end else begin
								if (choose_cmd_request[4]) begin
									choose_cmd_grant <= 3'd4;
								end else begin
									if (choose_cmd_request[5]) begin
										choose_cmd_grant <= 3'd5;
									end else begin
										if (choose_cmd_request[6]) begin
											choose_cmd_grant <= 3'd6;
										end
									end
								end
							end
						end
					end
				end
			end
		endcase
	end
	if (choose_req_ce) begin
		case (choose_req_grant)
			1'd0: begin
				if (choose_req_request[1]) begin
					choose_req_grant <= 1'd1;
				end else begin
					if (choose_req_request[2]) begin
						choose_req_grant <= 2'd2;
					end else begin
						if (choose_req_request[3]) begin
							choose_req_grant <= 2'd3;
						end else begin
							if (choose_req_request[4]) begin
								choose_req_grant <= 3'd4;
							end else begin
								if (choose_req_request[5]) begin
									choose_req_grant <= 3'd5;
								end else begin
									if (choose_req_request[6]) begin
										choose_req_grant <= 3'd6;
									end else begin
										if (choose_req_request[7]) begin
											choose_req_grant <= 3'd7;
										end
									end
								end
							end
						end
					end
				end
			end
			1'd1: begin
				if (choose_req_request[2]) begin
					choose_req_grant <= 2'd2;
				end else begin
					if (choose_req_request[3]) begin
						choose_req_grant <= 2'd3;
					end else begin
						if (choose_req_request[4]) begin
							choose_req_grant <= 3'd4;
						end else begin
							if (choose_req_request[5]) begin
								choose_req_grant <= 3'd5;
							end else begin
								if (choose_req_request[6]) begin
									choose_req_grant <= 3'd6;
								end else begin
									if (choose_req_request[7]) begin
										choose_req_grant <= 3'd7;
									end else begin
										if (choose_req_request[0]) begin
											choose_req_grant <= 1'd0;
										end
									end
								end
							end
						end
					end
				end
			end
			2'd2: begin
				if (choose_req_request[3]) begin
					choose_req_grant <= 2'd3;
				end else begin
					if (choose_req_request[4]) begin
						choose_req_grant <= 3'd4;
					end else begin
						if (choose_req_request[5]) begin
							choose_req_grant <= 3'd5;
						end else begin
							if (choose_req_request[6]) begin
								choose_req_grant <= 3'd6;
							end else begin
								if (choose_req_request[7]) begin
									choose_req_grant <= 3'd7;
								end else begin
									if (choose_req_request[0]) begin
										choose_req_grant <= 1'd0;
									end else begin
										if (choose_req_request[1]) begin
											choose_req_grant <= 1'd1;
										end
									end
								end
							end
						end
					end
				end
			end
			2'd3: begin
				if (choose_req_request[4]) begin
					choose_req_grant <= 3'd4;
				end else begin
					if (choose_req_request[5]) begin
						choose_req_grant <= 3'd5;
					end else begin
						if (choose_req_request[6]) begin
							choose_req_grant <= 3'd6;
						end else begin
							if (choose_req_request[7]) begin
								choose_req_grant <= 3'd7;
							end else begin
								if (choose_req_request[0]) begin
									choose_req_grant <= 1'd0;
								end else begin
									if (choose_req_request[1]) begin
										choose_req_grant <= 1'd1;
									end else begin
										if (choose_req_request[2]) begin
											choose_req_grant <= 2'd2;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd4: begin
				if (choose_req_request[5]) begin
					choose_req_grant <= 3'd5;
				end else begin
					if (choose_req_request[6]) begin
						choose_req_grant <= 3'd6;
					end else begin
						if (choose_req_request[7]) begin
							choose_req_grant <= 3'd7;
						end else begin
							if (choose_req_request[0]) begin
								choose_req_grant <= 1'd0;
							end else begin
								if (choose_req_request[1]) begin
									choose_req_grant <= 1'd1;
								end else begin
									if (choose_req_request[2]) begin
										choose_req_grant <= 2'd2;
									end else begin
										if (choose_req_request[3]) begin
											choose_req_grant <= 2'd3;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd5: begin
				if (choose_req_request[6]) begin
					choose_req_grant <= 3'd6;
				end else begin
					if (choose_req_request[7]) begin
						choose_req_grant <= 3'd7;
					end else begin
						if (choose_req_request[0]) begin
							choose_req_grant <= 1'd0;
						end else begin
							if (choose_req_request[1]) begin
								choose_req_grant <= 1'd1;
							end else begin
								if (choose_req_request[2]) begin
									choose_req_grant <= 2'd2;
								end else begin
									if (choose_req_request[3]) begin
										choose_req_grant <= 2'd3;
									end else begin
										if (choose_req_request[4]) begin
											choose_req_grant <= 3'd4;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd6: begin
				if (choose_req_request[7]) begin
					choose_req_grant <= 3'd7;
				end else begin
					if (choose_req_request[0]) begin
						choose_req_grant <= 1'd0;
					end else begin
						if (choose_req_request[1]) begin
							choose_req_grant <= 1'd1;
						end else begin
							if (choose_req_request[2]) begin
								choose_req_grant <= 2'd2;
							end else begin
								if (choose_req_request[3]) begin
									choose_req_grant <= 2'd3;
								end else begin
									if (choose_req_request[4]) begin
										choose_req_grant <= 3'd4;
									end else begin
										if (choose_req_request[5]) begin
											choose_req_grant <= 3'd5;
										end
									end
								end
							end
						end
					end
				end
			end
			3'd7: begin
				if (choose_req_request[0]) begin
					choose_req_grant <= 1'd0;
				end else begin
					if (choose_req_request[1]) begin
						choose_req_grant <= 1'd1;
					end else begin
						if (choose_req_request[2]) begin
							choose_req_grant <= 2'd2;
						end else begin
							if (choose_req_request[3]) begin
								choose_req_grant <= 2'd3;
							end else begin
								if (choose_req_request[4]) begin
									choose_req_grant <= 3'd4;
								end else begin
									if (choose_req_request[5]) begin
										choose_req_grant <= 3'd5;
									end else begin
										if (choose_req_request[6]) begin
											choose_req_grant <= 3'd6;
										end
									end
								end
							end
						end
					end
				end
			end
		endcase
	end
	dfi_p0_cs_n <= 1'd0;
	dfi_p0_bank <= array_muxed0;
	dfi_p0_address <= array_muxed1;
	dfi_p0_cas_n <= (~array_muxed2);
	dfi_p0_ras_n <= (~array_muxed3);
	dfi_p0_we_n <= (~array_muxed4);
	dfi_p0_mw <= array_muxed5;
	steerer_rddata_en_dly0 <= array_muxed6;
	steerer_wrdata_en_dly0 <= array_muxed7;
	dfi_p0_rddata_en <= (array_muxed8 | steerer_rddata_en_dly0);
	dfi_p0_wrdata_en <= (array_muxed9 | steerer_wrdata_en_dly0);
	dfi_p1_cs_n <= 1'd0;
	dfi_p1_bank <= array_muxed10;
	dfi_p1_address <= array_muxed11;
	dfi_p1_cas_n <= (~array_muxed12);
	dfi_p1_ras_n <= (~array_muxed13);
	dfi_p1_we_n <= (~array_muxed14);
	dfi_p1_mw <= array_muxed15;
	steerer_rddata_en_dly1 <= array_muxed16;
	steerer_wrdata_en_dly1 <= array_muxed17;
	dfi_p1_rddata_en <= (array_muxed18 | steerer_rddata_en_dly1);
	dfi_p1_wrdata_en <= (array_muxed19 | steerer_wrdata_en_dly1);
	dfi_p2_cs_n <= 1'd0;
	dfi_p2_bank <= array_muxed20;
	dfi_p2_address <= array_muxed21;
	dfi_p2_cas_n <= (~array_muxed22);
	dfi_p2_ras_n <= (~array_muxed23);
	dfi_p2_we_n <= (~array_muxed24);
	dfi_p2_mw <= array_muxed25;
	steerer_rddata_en_dly2 <= array_muxed26;
	steerer_wrdata_en_dly2 <= array_muxed27;
	dfi_p2_rddata_en <= (array_muxed28 | steerer_rddata_en_dly2);
	dfi_p2_wrdata_en <= (array_muxed29 | steerer_wrdata_en_dly2);
	dfi_p3_cs_n <= 1'd0;
	dfi_p3_bank <= array_muxed30;
	dfi_p3_address <= array_muxed31;
	dfi_p3_cas_n <= (~array_muxed32);
	dfi_p3_ras_n <= (~array_muxed33);
	dfi_p3_we_n <= (~array_muxed34);
	dfi_p3_mw <= array_muxed35;
	steerer_rddata_en_dly3 <= array_muxed36;
	steerer_wrdata_en_dly3 <= array_muxed37;
	dfi_p3_rddata_en <= (array_muxed38 | steerer_rddata_en_dly3);
	dfi_p3_wrdata_en <= (array_muxed39 | steerer_wrdata_en_dly3);
	if (trrdcon_valid) begin
		trrdcon_count <= (mul_tRRD_cfg - 1'd1);
		if (((mul_tRRD_cfg - 1'd1) == 1'd0)) begin
			trrdcon_ready <= 1'd1;
		end else begin
			trrdcon_ready <= 1'd0;
		end
	end else begin
		if ((~trrdcon_ready)) begin
			trrdcon_count <= (trrdcon_count - 1'd1);
			if ((trrdcon_count == 1'd1)) begin
				trrdcon_ready <= 1'd1;
			end
		end
	end
	tfawcon_window_c <= {tfawcon_window, tfawcon_valid};
	if ((tfawcon_count < 3'd4)) begin
		if ((tfawcon_count == 2'd3)) begin
			tfawcon_ready <= (~tfawcon_valid);
		end else begin
			tfawcon_ready <= 1'd1;
		end
	end
	if (tccdcon_valid) begin
		tccdcon_count <= (mul_tCCD_cfg - 1'd1);
		if (((mul_tCCD_cfg - 1'd1) == 1'd0)) begin
			tccdcon_ready <= 1'd1;
		end else begin
			tccdcon_ready <= 1'd0;
		end
	end else begin
		if ((~tccdcon_ready)) begin
			tccdcon_count <= (tccdcon_count - 1'd1);
			if ((tccdcon_count == 1'd1)) begin
				tccdcon_ready <= 1'd1;
			end
		end
	end
	if (twtrcon_valid) begin
		twtrcon_count <= (mul_WTR_LATENCY_cfg - 1'd1);
		if (((mul_WTR_LATENCY_cfg - 1'd1) == 1'd0)) begin
			twtrcon_ready <= 1'd1;
		end else begin
			twtrcon_ready <= 1'd0;
		end
	end else begin
		if ((~twtrcon_ready)) begin
			twtrcon_count <= (twtrcon_count - 1'd1);
			if ((twtrcon_count == 1'd1)) begin
				twtrcon_ready <= 1'd1;
			end
		end
	end
	if (trtwcon_valid) begin
		trtwcon_count <= (mul_RTW_LATENCY_cfg - 1'd1);
		if (((mul_RTW_LATENCY_cfg - 1'd1) == 1'd0)) begin
			trtwcon_ready <= 1'd1;
		end else begin
			trtwcon_ready <= 1'd0;
		end
	end else begin
		if ((~trtwcon_ready)) begin
			trtwcon_count <= (trtwcon_count - 1'd1);
			if ((trtwcon_count == 1'd1)) begin
				trtwcon_ready <= 1'd1;
			end
		end
	end
	state <= next_state;
	if (sys_rst) begin
		dfi_p0_address <= 17'd0;
		dfi_p0_bank <= 3'd0;
		dfi_p0_cas_n <= 1'd1;
		dfi_p0_cs_n <= 1'd1;
		dfi_p0_ras_n <= 1'd1;
		dfi_p0_we_n <= 1'd1;
		dfi_p0_mw <= 1'd0;
		dfi_p0_wrdata_en <= 1'd0;
		dfi_p0_rddata_en <= 1'd0;
		dfi_p1_address <= 17'd0;
		dfi_p1_bank <= 3'd0;
		dfi_p1_cas_n <= 1'd1;
		dfi_p1_cs_n <= 1'd1;
		dfi_p1_ras_n <= 1'd1;
		dfi_p1_we_n <= 1'd1;
		dfi_p1_mw <= 1'd0;
		dfi_p1_wrdata_en <= 1'd0;
		dfi_p1_rddata_en <= 1'd0;
		dfi_p2_address <= 17'd0;
		dfi_p2_bank <= 3'd0;
		dfi_p2_cas_n <= 1'd1;
		dfi_p2_cs_n <= 1'd1;
		dfi_p2_ras_n <= 1'd1;
		dfi_p2_we_n <= 1'd1;
		dfi_p2_mw <= 1'd0;
		dfi_p2_wrdata_en <= 1'd0;
		dfi_p2_rddata_en <= 1'd0;
		dfi_p3_address <= 17'd0;
		dfi_p3_bank <= 3'd0;
		dfi_p3_cas_n <= 1'd1;
		dfi_p3_cs_n <= 1'd1;
		dfi_p3_ras_n <= 1'd1;
		dfi_p3_we_n <= 1'd1;
		dfi_p3_mw <= 1'd0;
		dfi_p3_wrdata_en <= 1'd0;
		dfi_p3_rddata_en <= 1'd0;
		choose_cmd_grant <= 3'd0;
		choose_req_grant <= 3'd0;
		steerer_rddata_en_dly0 <= 1'd0;
		steerer_wrdata_en_dly0 <= 1'd0;
		steerer_rddata_en_dly1 <= 1'd0;
		steerer_wrdata_en_dly1 <= 1'd0;
		steerer_rddata_en_dly2 <= 1'd0;
		steerer_wrdata_en_dly2 <= 1'd0;
		steerer_rddata_en_dly3 <= 1'd0;
		steerer_wrdata_en_dly3 <= 1'd0;
		trrdcon_ready <= 1'd1;
		trrdcon_count <= 8'd0;
		tfawcon_ready <= 1'd1;
		tfawcon_window_c <= 64'd0;
		tccdcon_ready <= 1'd1;
		tccdcon_count <= 8'd0;
		twtrcon_ready <= 1'd1;
		twtrcon_count <= 8'd0;
		trtwcon_ready <= 1'd1;
		trtwcon_count <= 8'd0;
		time0 <= 8'd0;
		time1 <= 8'd0;
		state <= 3'd0;
	end
end

endmodule
