/* Machine-generated using Migen */
module crossbar_2ports(
	output reg interface_bank0_valid,
	input interface_bank0_ready,
	output reg interface_bank0_mw,
	output reg interface_bank0_we,
	output reg [22:0] interface_bank0_addr,
	input interface_bank0_lock,
	input interface_bank0_wdata_ready,
	input interface_bank0_rdata_valid,
	output reg interface_bank1_valid,
	input interface_bank1_ready,
	output reg interface_bank1_mw,
	output reg interface_bank1_we,
	output reg [22:0] interface_bank1_addr,
	input interface_bank1_lock,
	input interface_bank1_wdata_ready,
	input interface_bank1_rdata_valid,
	output reg interface_bank2_valid,
	input interface_bank2_ready,
	output reg interface_bank2_mw,
	output reg interface_bank2_we,
	output reg [22:0] interface_bank2_addr,
	input interface_bank2_lock,
	input interface_bank2_wdata_ready,
	input interface_bank2_rdata_valid,
	output reg interface_bank3_valid,
	input interface_bank3_ready,
	output reg interface_bank3_mw,
	output reg interface_bank3_we,
	output reg [22:0] interface_bank3_addr,
	input interface_bank3_lock,
	input interface_bank3_wdata_ready,
	input interface_bank3_rdata_valid,
	output reg interface_bank4_valid,
	input interface_bank4_ready,
	output reg interface_bank4_mw,
	output reg interface_bank4_we,
	output reg [22:0] interface_bank4_addr,
	input interface_bank4_lock,
	input interface_bank4_wdata_ready,
	input interface_bank4_rdata_valid,
	output reg interface_bank5_valid,
	input interface_bank5_ready,
	output reg interface_bank5_mw,
	output reg interface_bank5_we,
	output reg [22:0] interface_bank5_addr,
	input interface_bank5_lock,
	input interface_bank5_wdata_ready,
	input interface_bank5_rdata_valid,
	output reg interface_bank6_valid,
	input interface_bank6_ready,
	output reg interface_bank6_mw,
	output reg interface_bank6_we,
	output reg [22:0] interface_bank6_addr,
	input interface_bank6_lock,
	input interface_bank6_wdata_ready,
	input interface_bank6_rdata_valid,
	output reg interface_bank7_valid,
	input interface_bank7_ready,
	output reg interface_bank7_mw,
	output reg interface_bank7_we,
	output reg [22:0] interface_bank7_addr,
	input interface_bank7_lock,
	input interface_bank7_wdata_ready,
	input interface_bank7_rdata_valid,
	output reg [255:0] interface_wdata,
	output reg [31:0] interface_wdata_we,
	input [255:0] interface_rdata,
	input [7:0] crb_READ_LATENCY_cfg,
	input [7:0] crb_WRITE_LATENCY_cfg,
	input cmd_valid,
	output reg cmd_ready,
	input cmd_first,
	input cmd_last,
	input cmd_payload_mw,
	input cmd_payload_we,
	input [25:0] cmd_payload_addr,
	input wdata_valid,
	output reg wdata_ready,
	input wdata_first,
	input wdata_last,
	input [255:0] wdata_payload_data,
	input [31:0] wdata_payload_we,
	output reg rdata_valid,
	input rdata_ready,
	input rdata_first,
	input rdata_last,
	output reg [255:0] rdata_payload_data,
	input cmd_valid_1,
	output reg cmd_ready_1,
	input cmd_first_1,
	input cmd_last_1,
	input cmd_payload_mw_1,
	input cmd_payload_we_1,
	input [25:0] cmd_payload_addr_1,
	input wdata_valid_1,
	output reg wdata_ready_1,
	input wdata_first_1,
	input wdata_last_1,
	input [255:0] wdata_payload_data_1,
	input [31:0] wdata_payload_we_1,
	output reg rdata_valid_1,
	input rdata_ready_1,
	input rdata_first_1,
	input rdata_last_1,
	output reg [255:0] rdata_payload_data_1,
	input sys_clk,
	input sys_rst
);

wire [1:0] litedramcrossbar_roundrobin0_request;
reg litedramcrossbar_roundrobin0_grant = 1'd0;
wire litedramcrossbar_roundrobin0_ce;
wire [1:0] litedramcrossbar_roundrobin1_request;
reg litedramcrossbar_roundrobin1_grant = 1'd0;
wire litedramcrossbar_roundrobin1_ce;
wire [1:0] litedramcrossbar_roundrobin2_request;
reg litedramcrossbar_roundrobin2_grant = 1'd0;
wire litedramcrossbar_roundrobin2_ce;
wire [1:0] litedramcrossbar_roundrobin3_request;
reg litedramcrossbar_roundrobin3_grant = 1'd0;
wire litedramcrossbar_roundrobin3_ce;
wire [1:0] litedramcrossbar_roundrobin4_request;
reg litedramcrossbar_roundrobin4_grant = 1'd0;
wire litedramcrossbar_roundrobin4_ce;
wire [1:0] litedramcrossbar_roundrobin5_request;
reg litedramcrossbar_roundrobin5_grant = 1'd0;
wire litedramcrossbar_roundrobin5_ce;
wire [1:0] litedramcrossbar_roundrobin6_request;
reg litedramcrossbar_roundrobin6_grant = 1'd0;
wire litedramcrossbar_roundrobin6_ce;
wire [1:0] litedramcrossbar_roundrobin7_request;
reg litedramcrossbar_roundrobin7_grant = 1'd0;
wire litedramcrossbar_roundrobin7_ce;
reg litedramcrossbar_locked0 = 1'd0;
reg litedramcrossbar_locked1 = 1'd0;
reg litedramcrossbar_locked2 = 1'd0;
reg litedramcrossbar_locked3 = 1'd0;
reg litedramcrossbar_locked4 = 1'd0;
reg litedramcrossbar_locked5 = 1'd0;
reg litedramcrossbar_locked6 = 1'd0;
reg litedramcrossbar_locked7 = 1'd0;
reg litedramcrossbar_locked8 = 1'd0;
reg litedramcrossbar_locked9 = 1'd0;
reg litedramcrossbar_locked10 = 1'd0;
reg litedramcrossbar_locked11 = 1'd0;
reg litedramcrossbar_locked12 = 1'd0;
reg litedramcrossbar_locked13 = 1'd0;
reg litedramcrossbar_locked14 = 1'd0;
reg litedramcrossbar_locked15 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline00 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline01 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline02 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline03 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline04 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline05 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline06 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline07 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline08 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline09 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline010 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline011 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline012 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline013 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline014 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline015 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline016 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline017 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline018 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline019 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline020 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline021 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline022 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline023 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline024 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline025 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline026 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline027 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline028 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline029 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline030 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline031 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline10 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline11 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline12 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline13 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline14 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline15 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline16 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline17 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline18 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline19 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline110 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline111 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline112 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline113 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline114 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline115 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline116 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline117 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline118 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline119 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline120 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline121 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline122 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline123 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline124 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline125 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline126 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline127 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline128 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline129 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline130 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly_tappeddelayline131 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline00 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline01 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline02 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline03 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline04 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline05 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline06 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline07 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline08 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline09 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline010 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline011 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline012 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline013 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline014 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline015 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline016 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline017 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline018 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline019 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline020 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline021 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline022 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline023 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline024 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline025 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline026 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline027 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline028 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline029 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline030 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline031 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline10 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline11 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline12 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline13 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline14 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline15 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline16 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline17 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline18 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline19 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline110 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline111 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline112 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline113 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline114 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline115 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline116 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline117 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline118 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline119 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline120 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline121 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline122 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline123 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline124 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline125 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline126 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline127 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline128 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline129 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline130 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly_tappeddelayline131 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly0 = 1'd0;
reg litedramcrossbar_master_wdata_ready_dly1 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly0 = 1'd0;
reg litedramcrossbar_master_rdata_valid_dly1 = 1'd0;
wire [1:0] convert_roundrobin0_request;
reg convert_roundrobin0_grant = 1'd0;
wire convert_roundrobin0_ce;
wire [1:0] convert_roundrobin1_request;
reg convert_roundrobin1_grant = 1'd0;
wire convert_roundrobin1_ce;
wire [1:0] convert_roundrobin2_request;
reg convert_roundrobin2_grant = 1'd0;
wire convert_roundrobin2_ce;
wire [1:0] convert_roundrobin3_request;
reg convert_roundrobin3_grant = 1'd0;
wire convert_roundrobin3_ce;
wire [1:0] convert_roundrobin4_request;
reg convert_roundrobin4_grant = 1'd0;
wire convert_roundrobin4_ce;
wire [1:0] convert_roundrobin5_request;
reg convert_roundrobin5_grant = 1'd0;
wire convert_roundrobin5_ce;
wire [1:0] convert_roundrobin6_request;
reg convert_roundrobin6_grant = 1'd0;
wire convert_roundrobin6_ce;
wire [1:0] convert_roundrobin7_request;
reg convert_roundrobin7_grant = 1'd0;
wire convert_roundrobin7_ce;
reg convert_locked0 = 1'd0;
reg convert_locked1 = 1'd0;
reg convert_locked2 = 1'd0;
reg convert_locked3 = 1'd0;
reg convert_locked4 = 1'd0;
reg convert_locked5 = 1'd0;
reg convert_locked6 = 1'd0;
reg convert_locked7 = 1'd0;
reg convert_locked8 = 1'd0;
reg convert_locked9 = 1'd0;
reg convert_locked10 = 1'd0;
reg convert_locked11 = 1'd0;
reg convert_locked12 = 1'd0;
reg convert_locked13 = 1'd0;
reg convert_locked14 = 1'd0;
reg convert_locked15 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline00 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline01 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline02 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline03 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline04 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline05 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline06 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline07 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline08 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline09 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline010 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline011 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline012 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline013 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline014 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline015 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline016 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline017 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline018 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline019 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline020 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline021 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline022 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline023 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline024 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline025 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline026 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline027 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline028 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline029 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline030 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline031 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline10 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline11 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline12 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline13 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline14 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline15 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline16 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline17 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline18 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline19 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline110 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline111 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline112 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline113 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline114 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline115 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline116 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline117 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline118 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline119 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline120 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline121 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline122 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline123 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline124 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline125 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline126 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline127 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline128 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline129 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline130 = 1'd0;
reg convert_master_wdata_ready_dly_tappeddelayline131 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline00 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline01 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline02 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline03 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline04 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline05 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline06 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline07 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline08 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline09 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline010 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline011 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline012 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline013 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline014 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline015 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline016 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline017 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline018 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline019 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline020 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline021 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline022 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline023 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline024 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline025 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline026 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline027 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline028 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline029 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline030 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline031 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline10 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline11 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline12 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline13 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline14 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline15 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline16 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline17 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline18 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline19 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline110 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline111 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline112 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline113 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline114 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline115 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline116 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline117 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline118 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline119 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline120 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline121 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline122 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline123 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline124 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline125 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline126 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline127 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline128 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline129 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline130 = 1'd0;
reg convert_master_rdata_valid_dly_tappeddelayline131 = 1'd0;
reg convert_master_wdata_ready_dly0 = 1'd0;
reg convert_master_wdata_ready_dly1 = 1'd0;
reg convert_master_rdata_valid_dly0 = 1'd0;
reg convert_master_rdata_valid_dly1 = 1'd0;
reg [22:0] convert_comb_array_muxed0;
reg convert_comb_array_muxed1;
reg convert_comb_array_muxed2;
reg convert_comb_array_muxed3;
reg [22:0] convert_comb_array_muxed4;
reg convert_comb_array_muxed5;
reg convert_comb_array_muxed6;
reg convert_comb_array_muxed7;
reg [22:0] convert_comb_array_muxed8;
reg convert_comb_array_muxed9;
reg convert_comb_array_muxed10;
reg convert_comb_array_muxed11;
reg [22:0] convert_comb_array_muxed12;
reg convert_comb_array_muxed13;
reg convert_comb_array_muxed14;
reg convert_comb_array_muxed15;
reg [22:0] convert_comb_array_muxed16;
reg convert_comb_array_muxed17;
reg convert_comb_array_muxed18;
reg convert_comb_array_muxed19;
reg [22:0] convert_comb_array_muxed20;
reg convert_comb_array_muxed21;
reg convert_comb_array_muxed22;
reg convert_comb_array_muxed23;
reg [22:0] convert_comb_array_muxed24;
reg convert_comb_array_muxed25;
reg convert_comb_array_muxed26;
reg convert_comb_array_muxed27;
reg [22:0] convert_comb_array_muxed28;
reg convert_comb_array_muxed29;
reg convert_comb_array_muxed30;
reg convert_comb_array_muxed31;
reg convert_comb_array_muxed32;
reg convert_comb_array_muxed33;
reg convert_comb_array_muxed34;
reg convert_comb_array_muxed35;
reg [22:0] convert_comb_array_muxed36;
reg convert_comb_array_muxed37;
reg convert_comb_array_muxed38;
reg convert_comb_array_muxed39;
reg [22:0] convert_comb_array_muxed40;
reg convert_comb_array_muxed41;
reg convert_comb_array_muxed42;
reg convert_comb_array_muxed43;
reg [22:0] convert_comb_array_muxed44;
reg convert_comb_array_muxed45;
reg convert_comb_array_muxed46;
reg convert_comb_array_muxed47;
reg [22:0] convert_comb_array_muxed48;
reg convert_comb_array_muxed49;
reg convert_comb_array_muxed50;
reg convert_comb_array_muxed51;
reg [22:0] convert_comb_array_muxed52;
reg convert_comb_array_muxed53;
reg convert_comb_array_muxed54;
reg convert_comb_array_muxed55;
reg [22:0] convert_comb_array_muxed56;
reg convert_comb_array_muxed57;
reg convert_comb_array_muxed58;
reg convert_comb_array_muxed59;
reg [22:0] convert_comb_array_muxed60;
reg convert_comb_array_muxed61;
reg convert_comb_array_muxed62;
reg convert_comb_array_muxed63;
reg [22:0] convert_comb_array_muxed64;
reg convert_comb_array_muxed65;
reg convert_comb_array_muxed66;
reg convert_comb_array_muxed67;
reg convert_comb_array_muxed68;
reg convert_comb_array_muxed69;
reg convert_comb_array_muxed70;
reg convert_comb_array_muxed71;
reg convert_sync_array_muxed0;
reg convert_sync_array_muxed1;
reg convert_sync_array_muxed2;
reg convert_sync_array_muxed3;
reg convert_sync_array_muxed4;
reg convert_sync_array_muxed5;
reg convert_sync_array_muxed6;
reg convert_sync_array_muxed7;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign litedramcrossbar_roundrobin0_request = {(((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked1 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked0 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin0_ce = ((~interface_bank0_valid) & (~interface_bank0_lock));
assign litedramcrossbar_roundrobin1_request = {(((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked3 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked2 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin1_ce = ((~interface_bank1_valid) & (~interface_bank1_lock));
assign litedramcrossbar_roundrobin2_request = {(((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked5 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked4 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin2_ce = ((~interface_bank2_valid) & (~interface_bank2_lock));
assign litedramcrossbar_roundrobin3_request = {(((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked7 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked6 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin3_ce = ((~interface_bank3_valid) & (~interface_bank3_lock));
assign litedramcrossbar_roundrobin4_request = {(((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked9 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked8 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin4_ce = ((~interface_bank4_valid) & (~interface_bank4_lock));
assign litedramcrossbar_roundrobin5_request = {(((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked11 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked10 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin5_ce = ((~interface_bank5_valid) & (~interface_bank5_lock));
assign litedramcrossbar_roundrobin6_request = {(((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked13 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked12 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin6_ce = ((~interface_bank6_valid) & (~interface_bank6_lock));
assign litedramcrossbar_roundrobin7_request = {(((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked15 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked14 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))))) & cmd_valid)};
assign litedramcrossbar_roundrobin7_ce = ((~interface_bank7_valid) & (~interface_bank7_lock));
assign convert_roundrobin0_request = {(((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((convert_locked1 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 1'd0) & (~(((((((convert_locked0 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin0_ce = ((~interface_bank0_valid) & (~interface_bank0_lock));

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	interface_bank0_addr <= 23'd0;
	interface_bank0_addr <= convert_comb_array_muxed0;
	interface_bank0_addr <= convert_comb_array_muxed36;
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	interface_bank0_we <= 1'd0;
	interface_bank0_we <= convert_comb_array_muxed1;
	interface_bank0_we <= convert_comb_array_muxed37;
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	interface_bank0_mw <= 1'd0;
	interface_bank0_mw <= convert_comb_array_muxed2;
	interface_bank0_mw <= convert_comb_array_muxed38;
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	interface_bank0_valid <= 1'd0;
	interface_bank0_valid <= convert_comb_array_muxed3;
	interface_bank0_valid <= convert_comb_array_muxed39;
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin1_request = {(((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((convert_locked3 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 1'd1) & (~(((((((convert_locked2 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin1_ce = ((~interface_bank1_valid) & (~interface_bank1_lock));

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	interface_bank1_addr <= 23'd0;
	interface_bank1_addr <= convert_comb_array_muxed4;
	interface_bank1_addr <= convert_comb_array_muxed40;
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	interface_bank1_we <= 1'd0;
	interface_bank1_we <= convert_comb_array_muxed5;
	interface_bank1_we <= convert_comb_array_muxed41;
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	interface_bank1_mw <= 1'd0;
	interface_bank1_mw <= convert_comb_array_muxed6;
	interface_bank1_mw <= convert_comb_array_muxed42;
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	interface_bank1_valid <= 1'd0;
	interface_bank1_valid <= convert_comb_array_muxed7;
	interface_bank1_valid <= convert_comb_array_muxed43;
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin2_request = {(((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((convert_locked5 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 2'd2) & (~(((((((convert_locked4 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin2_ce = ((~interface_bank2_valid) & (~interface_bank2_lock));

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	interface_bank2_addr <= 23'd0;
	interface_bank2_addr <= convert_comb_array_muxed8;
	interface_bank2_addr <= convert_comb_array_muxed44;
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	interface_bank2_we <= 1'd0;
	interface_bank2_we <= convert_comb_array_muxed9;
	interface_bank2_we <= convert_comb_array_muxed45;
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	interface_bank2_mw <= 1'd0;
	interface_bank2_mw <= convert_comb_array_muxed10;
	interface_bank2_mw <= convert_comb_array_muxed46;
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	interface_bank2_valid <= 1'd0;
	interface_bank2_valid <= convert_comb_array_muxed11;
	interface_bank2_valid <= convert_comb_array_muxed47;
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin3_request = {(((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((convert_locked7 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 2'd3) & (~(((((((convert_locked6 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin3_ce = ((~interface_bank3_valid) & (~interface_bank3_lock));

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	interface_bank3_addr <= 23'd0;
	interface_bank3_addr <= convert_comb_array_muxed12;
	interface_bank3_addr <= convert_comb_array_muxed48;
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	interface_bank3_we <= 1'd0;
	interface_bank3_we <= convert_comb_array_muxed13;
	interface_bank3_we <= convert_comb_array_muxed49;
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	interface_bank3_mw <= 1'd0;
	interface_bank3_mw <= convert_comb_array_muxed14;
	interface_bank3_mw <= convert_comb_array_muxed50;
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	interface_bank3_valid <= 1'd0;
	interface_bank3_valid <= convert_comb_array_muxed15;
	interface_bank3_valid <= convert_comb_array_muxed51;
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin4_request = {(((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((convert_locked9 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd4) & (~(((((((convert_locked8 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin4_ce = ((~interface_bank4_valid) & (~interface_bank4_lock));

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	interface_bank4_addr <= 23'd0;
	interface_bank4_addr <= convert_comb_array_muxed16;
	interface_bank4_addr <= convert_comb_array_muxed52;
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	interface_bank4_we <= 1'd0;
	interface_bank4_we <= convert_comb_array_muxed17;
	interface_bank4_we <= convert_comb_array_muxed53;
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	interface_bank4_mw <= 1'd0;
	interface_bank4_mw <= convert_comb_array_muxed18;
	interface_bank4_mw <= convert_comb_array_muxed54;
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	interface_bank4_valid <= 1'd0;
	interface_bank4_valid <= convert_comb_array_muxed19;
	interface_bank4_valid <= convert_comb_array_muxed55;
// synthesis translate_off
	dummy_d_19 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin5_request = {(((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((convert_locked11 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd5) & (~(((((((convert_locked10 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin5_ce = ((~interface_bank5_valid) & (~interface_bank5_lock));

// synthesis translate_off
reg dummy_d_20;
// synthesis translate_on
always @(*) begin
	interface_bank5_addr <= 23'd0;
	interface_bank5_addr <= convert_comb_array_muxed20;
	interface_bank5_addr <= convert_comb_array_muxed56;
// synthesis translate_off
	dummy_d_20 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_21;
// synthesis translate_on
always @(*) begin
	interface_bank5_we <= 1'd0;
	interface_bank5_we <= convert_comb_array_muxed21;
	interface_bank5_we <= convert_comb_array_muxed57;
// synthesis translate_off
	dummy_d_21 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_22;
// synthesis translate_on
always @(*) begin
	interface_bank5_mw <= 1'd0;
	interface_bank5_mw <= convert_comb_array_muxed22;
	interface_bank5_mw <= convert_comb_array_muxed58;
// synthesis translate_off
	dummy_d_22 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_23;
// synthesis translate_on
always @(*) begin
	interface_bank5_valid <= 1'd0;
	interface_bank5_valid <= convert_comb_array_muxed23;
	interface_bank5_valid <= convert_comb_array_muxed59;
// synthesis translate_off
	dummy_d_23 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin6_request = {(((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((convert_locked13 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd6) & (~(((((((convert_locked12 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin6_ce = ((~interface_bank6_valid) & (~interface_bank6_lock));

// synthesis translate_off
reg dummy_d_24;
// synthesis translate_on
always @(*) begin
	interface_bank6_addr <= 23'd0;
	interface_bank6_addr <= convert_comb_array_muxed24;
	interface_bank6_addr <= convert_comb_array_muxed60;
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_25;
// synthesis translate_on
always @(*) begin
	interface_bank6_we <= 1'd0;
	interface_bank6_we <= convert_comb_array_muxed25;
	interface_bank6_we <= convert_comb_array_muxed61;
// synthesis translate_off
	dummy_d_25 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_26;
// synthesis translate_on
always @(*) begin
	interface_bank6_mw <= 1'd0;
	interface_bank6_mw <= convert_comb_array_muxed26;
	interface_bank6_mw <= convert_comb_array_muxed62;
// synthesis translate_off
	dummy_d_26 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_27;
// synthesis translate_on
always @(*) begin
	interface_bank6_valid <= 1'd0;
	interface_bank6_valid <= convert_comb_array_muxed27;
	interface_bank6_valid <= convert_comb_array_muxed63;
// synthesis translate_off
	dummy_d_27 <= dummy_s;
// synthesis translate_on
end
assign convert_roundrobin7_request = {(((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((convert_locked15 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))))) & cmd_valid_1), (((cmd_payload_addr[8:6] == 3'd7) & (~(((((((convert_locked14 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))))) & cmd_valid)};
assign convert_roundrobin7_ce = ((~interface_bank7_valid) & (~interface_bank7_lock));

// synthesis translate_off
reg dummy_d_28;
// synthesis translate_on
always @(*) begin
	interface_bank7_addr <= 23'd0;
	interface_bank7_addr <= convert_comb_array_muxed28;
	interface_bank7_addr <= convert_comb_array_muxed64;
// synthesis translate_off
	dummy_d_28 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_29;
// synthesis translate_on
always @(*) begin
	interface_bank7_we <= 1'd0;
	interface_bank7_we <= convert_comb_array_muxed29;
	interface_bank7_we <= convert_comb_array_muxed65;
// synthesis translate_off
	dummy_d_29 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_30;
// synthesis translate_on
always @(*) begin
	interface_bank7_mw <= 1'd0;
	interface_bank7_mw <= convert_comb_array_muxed30;
	interface_bank7_mw <= convert_comb_array_muxed66;
// synthesis translate_off
	dummy_d_30 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_31;
// synthesis translate_on
always @(*) begin
	interface_bank7_valid <= 1'd0;
	interface_bank7_valid <= convert_comb_array_muxed31;
	interface_bank7_valid <= convert_comb_array_muxed67;
// synthesis translate_off
	dummy_d_31 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_32;
// synthesis translate_on
always @(*) begin
	cmd_ready <= 1'd0;
	cmd_ready <= ((((((((1'd0 | (((litedramcrossbar_roundrobin0_grant == 1'd0) & ((cmd_payload_addr[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked0 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank0_ready)) | (((litedramcrossbar_roundrobin1_grant == 1'd0) & ((cmd_payload_addr[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked2 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank1_ready)) | (((litedramcrossbar_roundrobin2_grant == 1'd0) & ((cmd_payload_addr[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked4 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank2_ready)) | (((litedramcrossbar_roundrobin3_grant == 1'd0) & ((cmd_payload_addr[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked6 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank3_ready)) | (((litedramcrossbar_roundrobin4_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked8 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank4_ready)) | (((litedramcrossbar_roundrobin5_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked10 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank5_ready)) | (((litedramcrossbar_roundrobin6_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked12 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0)))))) & interface_bank6_ready)) | (((litedramcrossbar_roundrobin7_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked14 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0)))))) & interface_bank7_ready));
	cmd_ready <= ((((((((1'd0 | (((convert_roundrobin0_grant == 1'd0) & ((cmd_payload_addr[8:6] == 1'd0) & (~(((((((convert_locked0 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank0_ready)) | (((convert_roundrobin1_grant == 1'd0) & ((cmd_payload_addr[8:6] == 1'd1) & (~(((((((convert_locked2 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank1_ready)) | (((convert_roundrobin2_grant == 1'd0) & ((cmd_payload_addr[8:6] == 2'd2) & (~(((((((convert_locked4 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank2_ready)) | (((convert_roundrobin3_grant == 1'd0) & ((cmd_payload_addr[8:6] == 2'd3) & (~(((((((convert_locked6 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank3_ready)) | (((convert_roundrobin4_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd4) & (~(((((((convert_locked8 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank4_ready)) | (((convert_roundrobin5_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd5) & (~(((((((convert_locked10 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank5_ready)) | (((convert_roundrobin6_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd6) & (~(((((((convert_locked12 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0)))))) & interface_bank6_ready)) | (((convert_roundrobin7_grant == 1'd0) & ((cmd_payload_addr[8:6] == 3'd7) & (~(((((((convert_locked14 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0)))))) & interface_bank7_ready));
// synthesis translate_off
	dummy_d_32 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_33;
// synthesis translate_on
always @(*) begin
	cmd_ready_1 <= 1'd0;
	cmd_ready_1 <= ((((((((1'd0 | (((litedramcrossbar_roundrobin0_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked1 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank0_ready)) | (((litedramcrossbar_roundrobin1_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked3 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank1_ready)) | (((litedramcrossbar_roundrobin2_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked5 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank2_ready)) | (((litedramcrossbar_roundrobin3_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked7 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank3_ready)) | (((litedramcrossbar_roundrobin4_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked9 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank4_ready)) | (((litedramcrossbar_roundrobin5_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked11 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank5_ready)) | (((litedramcrossbar_roundrobin6_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked13 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1)))))) & interface_bank6_ready)) | (((litedramcrossbar_roundrobin7_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked15 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1)))))) & interface_bank7_ready));
	cmd_ready_1 <= ((((((((1'd0 | (((convert_roundrobin0_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((convert_locked1 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank0_ready)) | (((convert_roundrobin1_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((convert_locked3 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank1_ready)) | (((convert_roundrobin2_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((convert_locked5 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank2_ready)) | (((convert_roundrobin3_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((convert_locked7 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank3_ready)) | (((convert_roundrobin4_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((convert_locked9 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank4_ready)) | (((convert_roundrobin5_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((convert_locked11 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank5_ready)) | (((convert_roundrobin6_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((convert_locked13 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1)))))) & interface_bank6_ready)) | (((convert_roundrobin7_grant == 1'd1) & ((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((convert_locked15 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1)))))) & interface_bank7_ready));
// synthesis translate_off
	dummy_d_33 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_34;
// synthesis translate_on
always @(*) begin
	wdata_ready <= 1'd0;
	wdata_ready <= (convert_comb_array_muxed32 | litedramcrossbar_master_wdata_ready_dly0);
	wdata_ready <= (convert_comb_array_muxed68 | convert_master_wdata_ready_dly0);
// synthesis translate_off
	dummy_d_34 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_35;
// synthesis translate_on
always @(*) begin
	wdata_ready_1 <= 1'd0;
	wdata_ready_1 <= (convert_comb_array_muxed33 | litedramcrossbar_master_wdata_ready_dly1);
	wdata_ready_1 <= (convert_comb_array_muxed69 | convert_master_wdata_ready_dly1);
// synthesis translate_off
	dummy_d_35 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_36;
// synthesis translate_on
always @(*) begin
	rdata_valid <= 1'd0;
	rdata_valid <= (convert_comb_array_muxed34 | litedramcrossbar_master_rdata_valid_dly0);
	rdata_valid <= (convert_comb_array_muxed70 | convert_master_rdata_valid_dly0);
// synthesis translate_off
	dummy_d_36 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_37;
// synthesis translate_on
always @(*) begin
	rdata_valid_1 <= 1'd0;
	rdata_valid_1 <= (convert_comb_array_muxed35 | litedramcrossbar_master_rdata_valid_dly1);
	rdata_valid_1 <= (convert_comb_array_muxed71 | convert_master_rdata_valid_dly1);
// synthesis translate_off
	dummy_d_37 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_38;
// synthesis translate_on
always @(*) begin
	interface_wdata <= 256'd0;
	interface_wdata_we <= 32'd0;
	case ({wdata_ready_1, wdata_ready})
		1'd1: begin
			interface_wdata <= wdata_payload_data;
			interface_wdata_we <= wdata_payload_we;
		end
		2'd2: begin
			interface_wdata <= wdata_payload_data_1;
			interface_wdata_we <= wdata_payload_we_1;
		end
		default: begin
			interface_wdata <= 1'd0;
			interface_wdata_we <= 1'd0;
		end
	endcase
	case ({wdata_ready_1, wdata_ready})
		1'd1: begin
			interface_wdata <= wdata_payload_data;
			interface_wdata_we <= wdata_payload_we;
		end
		2'd2: begin
			interface_wdata <= wdata_payload_data_1;
			interface_wdata_we <= wdata_payload_we_1;
		end
		default: begin
			interface_wdata <= 1'd0;
			interface_wdata_we <= 1'd0;
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
	rdata_payload_data <= 256'd0;
	rdata_payload_data <= interface_rdata;
	rdata_payload_data <= interface_rdata;
// synthesis translate_off
	dummy_d_39 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_40;
// synthesis translate_on
always @(*) begin
	rdata_payload_data_1 <= 256'd0;
	rdata_payload_data_1 <= interface_rdata;
	rdata_payload_data_1 <= interface_rdata;
// synthesis translate_off
	dummy_d_40 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_41;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed0 <= 23'd0;
	case (litedramcrossbar_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed0 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed0 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed1 <= 1'd0;
	case (litedramcrossbar_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed1 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed1 <= cmd_payload_we_1;
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
	convert_comb_array_muxed2 <= 1'd0;
	case (litedramcrossbar_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed2 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed2 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed3 <= 1'd0;
	case (litedramcrossbar_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed3 <= (((cmd_payload_addr[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked0 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed3 <= (((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((litedramcrossbar_locked1 | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed4 <= 23'd0;
	case (litedramcrossbar_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed4 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed4 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed5 <= 1'd0;
	case (litedramcrossbar_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed5 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed5 <= cmd_payload_we_1;
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
	convert_comb_array_muxed6 <= 1'd0;
	case (litedramcrossbar_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed6 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed6 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed7 <= 1'd0;
	case (litedramcrossbar_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed7 <= (((cmd_payload_addr[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked2 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed7 <= (((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((litedramcrossbar_locked3 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed8 <= 23'd0;
	case (litedramcrossbar_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed8 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed8 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed9 <= 1'd0;
	case (litedramcrossbar_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed9 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed9 <= cmd_payload_we_1;
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
	convert_comb_array_muxed10 <= 1'd0;
	case (litedramcrossbar_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed10 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed10 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed11 <= 1'd0;
	case (litedramcrossbar_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed11 <= (((cmd_payload_addr[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked4 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed11 <= (((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((litedramcrossbar_locked5 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed12 <= 23'd0;
	case (litedramcrossbar_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed12 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed12 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed13 <= 1'd0;
	case (litedramcrossbar_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed13 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed13 <= cmd_payload_we_1;
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
	convert_comb_array_muxed14 <= 1'd0;
	case (litedramcrossbar_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed14 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed14 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed15 <= 1'd0;
	case (litedramcrossbar_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed15 <= (((cmd_payload_addr[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked6 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed15 <= (((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((litedramcrossbar_locked7 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed16 <= 23'd0;
	case (litedramcrossbar_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed16 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed16 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed17 <= 1'd0;
	case (litedramcrossbar_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed17 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed17 <= cmd_payload_we_1;
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
	convert_comb_array_muxed18 <= 1'd0;
	case (litedramcrossbar_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed18 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed18 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed19 <= 1'd0;
	case (litedramcrossbar_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed19 <= (((cmd_payload_addr[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked8 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed19 <= (((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((litedramcrossbar_locked9 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed20 <= 23'd0;
	case (litedramcrossbar_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed20 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed20 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed21 <= 1'd0;
	case (litedramcrossbar_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed21 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed21 <= cmd_payload_we_1;
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
	convert_comb_array_muxed22 <= 1'd0;
	case (litedramcrossbar_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed22 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed22 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed23 <= 1'd0;
	case (litedramcrossbar_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed23 <= (((cmd_payload_addr[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked10 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed23 <= (((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((litedramcrossbar_locked11 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed24 <= 23'd0;
	case (litedramcrossbar_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed24 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed24 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed25 <= 1'd0;
	case (litedramcrossbar_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed25 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed25 <= cmd_payload_we_1;
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
	convert_comb_array_muxed26 <= 1'd0;
	case (litedramcrossbar_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed26 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed26 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed27 <= 1'd0;
	case (litedramcrossbar_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed27 <= (((cmd_payload_addr[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked12 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed27 <= (((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((litedramcrossbar_locked13 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (litedramcrossbar_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed28 <= 23'd0;
	case (litedramcrossbar_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed28 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed28 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed29 <= 1'd0;
	case (litedramcrossbar_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed29 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed29 <= cmd_payload_we_1;
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
	convert_comb_array_muxed30 <= 1'd0;
	case (litedramcrossbar_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed30 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed30 <= cmd_payload_mw_1;
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
	convert_comb_array_muxed31 <= 1'd0;
	case (litedramcrossbar_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed31 <= (((cmd_payload_addr[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked14 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed31 <= (((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((litedramcrossbar_locked15 | (interface_bank0_lock & (litedramcrossbar_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (litedramcrossbar_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (litedramcrossbar_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (litedramcrossbar_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (litedramcrossbar_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (litedramcrossbar_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (litedramcrossbar_roundrobin6_grant == 1'd1))))) & cmd_valid_1);
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
	convert_comb_array_muxed32 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline030;
		end
		default: begin
			convert_comb_array_muxed32 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline031;
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
	convert_comb_array_muxed33 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline130;
		end
		default: begin
			convert_comb_array_muxed33 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline131;
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
	convert_comb_array_muxed34 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline030;
		end
		default: begin
			convert_comb_array_muxed34 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline031;
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
	convert_comb_array_muxed35 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline130;
		end
		default: begin
			convert_comb_array_muxed35 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline131;
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
	convert_comb_array_muxed36 <= 23'd0;
	case (convert_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed36 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed36 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
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
	convert_comb_array_muxed37 <= 1'd0;
	case (convert_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed37 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed37 <= cmd_payload_we_1;
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
	convert_comb_array_muxed38 <= 1'd0;
	case (convert_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed38 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed38 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_79 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_80;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed39 <= 1'd0;
	case (convert_roundrobin0_grant)
		1'd0: begin
			convert_comb_array_muxed39 <= (((cmd_payload_addr[8:6] == 1'd0) & (~(((((((convert_locked0 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed39 <= (((cmd_payload_addr_1[8:6] == 1'd0) & (~(((((((convert_locked1 | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_80 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_81;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed40 <= 23'd0;
	case (convert_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed40 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed40 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_81 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_82;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed41 <= 1'd0;
	case (convert_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed41 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed41 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_82 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_83;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed42 <= 1'd0;
	case (convert_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed42 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed42 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_83 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_84;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed43 <= 1'd0;
	case (convert_roundrobin1_grant)
		1'd0: begin
			convert_comb_array_muxed43 <= (((cmd_payload_addr[8:6] == 1'd1) & (~(((((((convert_locked2 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed43 <= (((cmd_payload_addr_1[8:6] == 1'd1) & (~(((((((convert_locked3 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_84 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_85;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed44 <= 23'd0;
	case (convert_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed44 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed44 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_85 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_86;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed45 <= 1'd0;
	case (convert_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed45 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed45 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_86 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_87;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed46 <= 1'd0;
	case (convert_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed46 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed46 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_87 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_88;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed47 <= 1'd0;
	case (convert_roundrobin2_grant)
		1'd0: begin
			convert_comb_array_muxed47 <= (((cmd_payload_addr[8:6] == 2'd2) & (~(((((((convert_locked4 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed47 <= (((cmd_payload_addr_1[8:6] == 2'd2) & (~(((((((convert_locked5 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_88 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_89;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed48 <= 23'd0;
	case (convert_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed48 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed48 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_89 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_90;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed49 <= 1'd0;
	case (convert_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed49 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed49 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_90 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_91;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed50 <= 1'd0;
	case (convert_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed50 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed50 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_91 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_92;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed51 <= 1'd0;
	case (convert_roundrobin3_grant)
		1'd0: begin
			convert_comb_array_muxed51 <= (((cmd_payload_addr[8:6] == 2'd3) & (~(((((((convert_locked6 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed51 <= (((cmd_payload_addr_1[8:6] == 2'd3) & (~(((((((convert_locked7 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_92 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_93;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed52 <= 23'd0;
	case (convert_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed52 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed52 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_93 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_94;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed53 <= 1'd0;
	case (convert_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed53 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed53 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_94 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_95;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed54 <= 1'd0;
	case (convert_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed54 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed54 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_95 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_96;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed55 <= 1'd0;
	case (convert_roundrobin4_grant)
		1'd0: begin
			convert_comb_array_muxed55 <= (((cmd_payload_addr[8:6] == 3'd4) & (~(((((((convert_locked8 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed55 <= (((cmd_payload_addr_1[8:6] == 3'd4) & (~(((((((convert_locked9 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_96 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_97;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed56 <= 23'd0;
	case (convert_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed56 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed56 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_97 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_98;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed57 <= 1'd0;
	case (convert_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed57 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed57 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_98 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_99;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed58 <= 1'd0;
	case (convert_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed58 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed58 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_99 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_100;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed59 <= 1'd0;
	case (convert_roundrobin5_grant)
		1'd0: begin
			convert_comb_array_muxed59 <= (((cmd_payload_addr[8:6] == 3'd5) & (~(((((((convert_locked10 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed59 <= (((cmd_payload_addr_1[8:6] == 3'd5) & (~(((((((convert_locked11 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_100 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_101;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed60 <= 23'd0;
	case (convert_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed60 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed60 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_101 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_102;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed61 <= 1'd0;
	case (convert_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed61 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed61 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_102 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_103;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed62 <= 1'd0;
	case (convert_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed62 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed62 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_103 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_104;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed63 <= 1'd0;
	case (convert_roundrobin6_grant)
		1'd0: begin
			convert_comb_array_muxed63 <= (((cmd_payload_addr[8:6] == 3'd6) & (~(((((((convert_locked12 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed63 <= (((cmd_payload_addr_1[8:6] == 3'd6) & (~(((((((convert_locked13 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank7_lock & (convert_roundrobin7_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_104 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_105;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed64 <= 23'd0;
	case (convert_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed64 <= {cmd_payload_addr[25:9], cmd_payload_addr[5:0]};
		end
		default: begin
			convert_comb_array_muxed64 <= {cmd_payload_addr_1[25:9], cmd_payload_addr_1[5:0]};
		end
	endcase
// synthesis translate_off
	dummy_d_105 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_106;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed65 <= 1'd0;
	case (convert_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed65 <= cmd_payload_we;
		end
		default: begin
			convert_comb_array_muxed65 <= cmd_payload_we_1;
		end
	endcase
// synthesis translate_off
	dummy_d_106 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_107;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed66 <= 1'd0;
	case (convert_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed66 <= cmd_payload_mw;
		end
		default: begin
			convert_comb_array_muxed66 <= cmd_payload_mw_1;
		end
	endcase
// synthesis translate_off
	dummy_d_107 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_108;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed67 <= 1'd0;
	case (convert_roundrobin7_grant)
		1'd0: begin
			convert_comb_array_muxed67 <= (((cmd_payload_addr[8:6] == 3'd7) & (~(((((((convert_locked14 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd0))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd0))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd0))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd0))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd0))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd0))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd0))))) & cmd_valid);
		end
		default: begin
			convert_comb_array_muxed67 <= (((cmd_payload_addr_1[8:6] == 3'd7) & (~(((((((convert_locked15 | (interface_bank0_lock & (convert_roundrobin0_grant == 1'd1))) | (interface_bank1_lock & (convert_roundrobin1_grant == 1'd1))) | (interface_bank2_lock & (convert_roundrobin2_grant == 1'd1))) | (interface_bank3_lock & (convert_roundrobin3_grant == 1'd1))) | (interface_bank4_lock & (convert_roundrobin4_grant == 1'd1))) | (interface_bank5_lock & (convert_roundrobin5_grant == 1'd1))) | (interface_bank6_lock & (convert_roundrobin6_grant == 1'd1))))) & cmd_valid_1);
		end
	endcase
// synthesis translate_off
	dummy_d_108 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_109;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed68 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline030;
		end
		default: begin
			convert_comb_array_muxed68 <= convert_master_wdata_ready_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_109 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_110;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed69 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline130;
		end
		default: begin
			convert_comb_array_muxed69 <= convert_master_wdata_ready_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_110 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_111;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed70 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline030;
		end
		default: begin
			convert_comb_array_muxed70 <= convert_master_rdata_valid_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_111 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_112;
// synthesis translate_on
always @(*) begin
	convert_comb_array_muxed71 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline130;
		end
		default: begin
			convert_comb_array_muxed71 <= convert_master_rdata_valid_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_112 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_113;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed0 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline030;
		end
		default: begin
			convert_sync_array_muxed0 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_113 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_114;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed1 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline130;
		end
		default: begin
			convert_sync_array_muxed1 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_114 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_115;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed2 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline030;
		end
		default: begin
			convert_sync_array_muxed2 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_115 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_116;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed3 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline130;
		end
		default: begin
			convert_sync_array_muxed3 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_116 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_117;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed4 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline030;
		end
		default: begin
			convert_sync_array_muxed4 <= convert_master_wdata_ready_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_117 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_118;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed5 <= 1'd0;
	case (crb_WRITE_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline130;
		end
		default: begin
			convert_sync_array_muxed5 <= convert_master_wdata_ready_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_118 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_119;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed6 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline00;
		end
		1'd1: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline01;
		end
		2'd2: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline02;
		end
		2'd3: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline03;
		end
		3'd4: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline04;
		end
		3'd5: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline05;
		end
		3'd6: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline06;
		end
		3'd7: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline07;
		end
		4'd8: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline08;
		end
		4'd9: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline09;
		end
		4'd10: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline010;
		end
		4'd11: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline011;
		end
		4'd12: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline012;
		end
		4'd13: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline013;
		end
		4'd14: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline014;
		end
		4'd15: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline015;
		end
		5'd16: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline016;
		end
		5'd17: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline017;
		end
		5'd18: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline018;
		end
		5'd19: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline019;
		end
		5'd20: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline020;
		end
		5'd21: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline021;
		end
		5'd22: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline022;
		end
		5'd23: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline023;
		end
		5'd24: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline024;
		end
		5'd25: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline025;
		end
		5'd26: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline026;
		end
		5'd27: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline027;
		end
		5'd28: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline028;
		end
		5'd29: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline029;
		end
		5'd30: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline030;
		end
		default: begin
			convert_sync_array_muxed6 <= convert_master_rdata_valid_dly_tappeddelayline031;
		end
	endcase
// synthesis translate_off
	dummy_d_119 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_120;
// synthesis translate_on
always @(*) begin
	convert_sync_array_muxed7 <= 1'd0;
	case (crb_READ_LATENCY_cfg)
		1'd0: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline10;
		end
		1'd1: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline11;
		end
		2'd2: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline12;
		end
		2'd3: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline13;
		end
		3'd4: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline14;
		end
		3'd5: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline15;
		end
		3'd6: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline16;
		end
		3'd7: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline17;
		end
		4'd8: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline18;
		end
		4'd9: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline19;
		end
		4'd10: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline110;
		end
		4'd11: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline111;
		end
		4'd12: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline112;
		end
		4'd13: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline113;
		end
		4'd14: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline114;
		end
		4'd15: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline115;
		end
		5'd16: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline116;
		end
		5'd17: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline117;
		end
		5'd18: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline118;
		end
		5'd19: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline119;
		end
		5'd20: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline120;
		end
		5'd21: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline121;
		end
		5'd22: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline122;
		end
		5'd23: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline123;
		end
		5'd24: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline124;
		end
		5'd25: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline125;
		end
		5'd26: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline126;
		end
		5'd27: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline127;
		end
		5'd28: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline128;
		end
		5'd29: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline129;
		end
		5'd30: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline130;
		end
		default: begin
			convert_sync_array_muxed7 <= convert_master_rdata_valid_dly_tappeddelayline131;
		end
	endcase
// synthesis translate_off
	dummy_d_120 <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	litedramcrossbar_master_wdata_ready_dly0 <= convert_sync_array_muxed0;
	litedramcrossbar_master_wdata_ready_dly1 <= convert_sync_array_muxed1;
	litedramcrossbar_master_rdata_valid_dly0 <= convert_sync_array_muxed2;
	litedramcrossbar_master_rdata_valid_dly1 <= convert_sync_array_muxed3;
	convert_master_wdata_ready_dly0 <= convert_sync_array_muxed4;
	convert_master_wdata_ready_dly1 <= convert_sync_array_muxed5;
	convert_master_rdata_valid_dly0 <= convert_sync_array_muxed6;
	convert_master_rdata_valid_dly1 <= convert_sync_array_muxed7;
	if (litedramcrossbar_roundrobin0_ce) begin
		case (litedramcrossbar_roundrobin0_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin0_request[1]) begin
					litedramcrossbar_roundrobin0_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin0_request[0]) begin
					litedramcrossbar_roundrobin0_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin1_ce) begin
		case (litedramcrossbar_roundrobin1_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin1_request[1]) begin
					litedramcrossbar_roundrobin1_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin1_request[0]) begin
					litedramcrossbar_roundrobin1_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin2_ce) begin
		case (litedramcrossbar_roundrobin2_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin2_request[1]) begin
					litedramcrossbar_roundrobin2_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin2_request[0]) begin
					litedramcrossbar_roundrobin2_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin3_ce) begin
		case (litedramcrossbar_roundrobin3_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin3_request[1]) begin
					litedramcrossbar_roundrobin3_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin3_request[0]) begin
					litedramcrossbar_roundrobin3_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin4_ce) begin
		case (litedramcrossbar_roundrobin4_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin4_request[1]) begin
					litedramcrossbar_roundrobin4_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin4_request[0]) begin
					litedramcrossbar_roundrobin4_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin5_ce) begin
		case (litedramcrossbar_roundrobin5_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin5_request[1]) begin
					litedramcrossbar_roundrobin5_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin5_request[0]) begin
					litedramcrossbar_roundrobin5_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin6_ce) begin
		case (litedramcrossbar_roundrobin6_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin6_request[1]) begin
					litedramcrossbar_roundrobin6_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin6_request[0]) begin
					litedramcrossbar_roundrobin6_grant <= 1'd0;
				end
			end
		endcase
	end
	if (litedramcrossbar_roundrobin7_ce) begin
		case (litedramcrossbar_roundrobin7_grant)
			1'd0: begin
				if (litedramcrossbar_roundrobin7_request[1]) begin
					litedramcrossbar_roundrobin7_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (litedramcrossbar_roundrobin7_request[0]) begin
					litedramcrossbar_roundrobin7_grant <= 1'd0;
				end
			end
		endcase
	end
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline00 <= ((((((((1'd0 | ((litedramcrossbar_roundrobin0_grant == 1'd0) & interface_bank0_wdata_ready)) | ((litedramcrossbar_roundrobin1_grant == 1'd0) & interface_bank1_wdata_ready)) | ((litedramcrossbar_roundrobin2_grant == 1'd0) & interface_bank2_wdata_ready)) | ((litedramcrossbar_roundrobin3_grant == 1'd0) & interface_bank3_wdata_ready)) | ((litedramcrossbar_roundrobin4_grant == 1'd0) & interface_bank4_wdata_ready)) | ((litedramcrossbar_roundrobin5_grant == 1'd0) & interface_bank5_wdata_ready)) | ((litedramcrossbar_roundrobin6_grant == 1'd0) & interface_bank6_wdata_ready)) | ((litedramcrossbar_roundrobin7_grant == 1'd0) & interface_bank7_wdata_ready));
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline01 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline00;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline02 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline01;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline03 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline02;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline04 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline03;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline05 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline04;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline06 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline05;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline07 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline06;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline08 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline07;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline09 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline08;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline010 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline09;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline011 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline010;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline012 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline011;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline013 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline012;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline014 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline013;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline015 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline014;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline016 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline015;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline017 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline016;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline018 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline017;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline019 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline018;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline020 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline019;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline021 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline020;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline022 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline021;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline023 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline022;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline024 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline023;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline025 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline024;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline026 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline025;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline027 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline026;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline028 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline027;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline029 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline028;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline030 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline029;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline031 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline030;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline10 <= ((((((((1'd0 | ((litedramcrossbar_roundrobin0_grant == 1'd1) & interface_bank0_wdata_ready)) | ((litedramcrossbar_roundrobin1_grant == 1'd1) & interface_bank1_wdata_ready)) | ((litedramcrossbar_roundrobin2_grant == 1'd1) & interface_bank2_wdata_ready)) | ((litedramcrossbar_roundrobin3_grant == 1'd1) & interface_bank3_wdata_ready)) | ((litedramcrossbar_roundrobin4_grant == 1'd1) & interface_bank4_wdata_ready)) | ((litedramcrossbar_roundrobin5_grant == 1'd1) & interface_bank5_wdata_ready)) | ((litedramcrossbar_roundrobin6_grant == 1'd1) & interface_bank6_wdata_ready)) | ((litedramcrossbar_roundrobin7_grant == 1'd1) & interface_bank7_wdata_ready));
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline11 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline10;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline12 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline11;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline13 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline12;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline14 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline13;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline15 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline14;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline16 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline15;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline17 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline16;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline18 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline17;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline19 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline18;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline110 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline19;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline111 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline110;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline112 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline111;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline113 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline112;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline114 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline113;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline115 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline114;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline116 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline115;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline117 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline116;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline118 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline117;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline119 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline118;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline120 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline119;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline121 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline120;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline122 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline121;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline123 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline122;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline124 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline123;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline125 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline124;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline126 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline125;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline127 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline126;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline128 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline127;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline129 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline128;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline130 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline129;
	litedramcrossbar_master_wdata_ready_dly_tappeddelayline131 <= litedramcrossbar_master_wdata_ready_dly_tappeddelayline130;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline00 <= ((((((((1'd0 | ((litedramcrossbar_roundrobin0_grant == 1'd0) & interface_bank0_rdata_valid)) | ((litedramcrossbar_roundrobin1_grant == 1'd0) & interface_bank1_rdata_valid)) | ((litedramcrossbar_roundrobin2_grant == 1'd0) & interface_bank2_rdata_valid)) | ((litedramcrossbar_roundrobin3_grant == 1'd0) & interface_bank3_rdata_valid)) | ((litedramcrossbar_roundrobin4_grant == 1'd0) & interface_bank4_rdata_valid)) | ((litedramcrossbar_roundrobin5_grant == 1'd0) & interface_bank5_rdata_valid)) | ((litedramcrossbar_roundrobin6_grant == 1'd0) & interface_bank6_rdata_valid)) | ((litedramcrossbar_roundrobin7_grant == 1'd0) & interface_bank7_rdata_valid));
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline01 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline00;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline02 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline01;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline03 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline02;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline04 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline03;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline05 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline04;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline06 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline05;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline07 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline06;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline08 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline07;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline09 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline08;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline010 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline09;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline011 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline010;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline012 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline011;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline013 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline012;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline014 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline013;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline015 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline014;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline016 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline015;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline017 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline016;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline018 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline017;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline019 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline018;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline020 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline019;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline021 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline020;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline022 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline021;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline023 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline022;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline024 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline023;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline025 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline024;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline026 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline025;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline027 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline026;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline028 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline027;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline029 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline028;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline030 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline029;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline031 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline030;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline10 <= ((((((((1'd0 | ((litedramcrossbar_roundrobin0_grant == 1'd1) & interface_bank0_rdata_valid)) | ((litedramcrossbar_roundrobin1_grant == 1'd1) & interface_bank1_rdata_valid)) | ((litedramcrossbar_roundrobin2_grant == 1'd1) & interface_bank2_rdata_valid)) | ((litedramcrossbar_roundrobin3_grant == 1'd1) & interface_bank3_rdata_valid)) | ((litedramcrossbar_roundrobin4_grant == 1'd1) & interface_bank4_rdata_valid)) | ((litedramcrossbar_roundrobin5_grant == 1'd1) & interface_bank5_rdata_valid)) | ((litedramcrossbar_roundrobin6_grant == 1'd1) & interface_bank6_rdata_valid)) | ((litedramcrossbar_roundrobin7_grant == 1'd1) & interface_bank7_rdata_valid));
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline11 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline10;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline12 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline11;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline13 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline12;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline14 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline13;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline15 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline14;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline16 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline15;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline17 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline16;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline18 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline17;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline19 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline18;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline110 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline19;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline111 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline110;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline112 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline111;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline113 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline112;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline114 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline113;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline115 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline114;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline116 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline115;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline117 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline116;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline118 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline117;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline119 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline118;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline120 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline119;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline121 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline120;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline122 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline121;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline123 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline122;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline124 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline123;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline125 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline124;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline126 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline125;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline127 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline126;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline128 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline127;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline129 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline128;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline130 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline129;
	litedramcrossbar_master_rdata_valid_dly_tappeddelayline131 <= litedramcrossbar_master_rdata_valid_dly_tappeddelayline130;
	if (convert_roundrobin0_ce) begin
		case (convert_roundrobin0_grant)
			1'd0: begin
				if (convert_roundrobin0_request[1]) begin
					convert_roundrobin0_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin0_request[0]) begin
					convert_roundrobin0_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin1_ce) begin
		case (convert_roundrobin1_grant)
			1'd0: begin
				if (convert_roundrobin1_request[1]) begin
					convert_roundrobin1_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin1_request[0]) begin
					convert_roundrobin1_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin2_ce) begin
		case (convert_roundrobin2_grant)
			1'd0: begin
				if (convert_roundrobin2_request[1]) begin
					convert_roundrobin2_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin2_request[0]) begin
					convert_roundrobin2_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin3_ce) begin
		case (convert_roundrobin3_grant)
			1'd0: begin
				if (convert_roundrobin3_request[1]) begin
					convert_roundrobin3_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin3_request[0]) begin
					convert_roundrobin3_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin4_ce) begin
		case (convert_roundrobin4_grant)
			1'd0: begin
				if (convert_roundrobin4_request[1]) begin
					convert_roundrobin4_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin4_request[0]) begin
					convert_roundrobin4_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin5_ce) begin
		case (convert_roundrobin5_grant)
			1'd0: begin
				if (convert_roundrobin5_request[1]) begin
					convert_roundrobin5_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin5_request[0]) begin
					convert_roundrobin5_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin6_ce) begin
		case (convert_roundrobin6_grant)
			1'd0: begin
				if (convert_roundrobin6_request[1]) begin
					convert_roundrobin6_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin6_request[0]) begin
					convert_roundrobin6_grant <= 1'd0;
				end
			end
		endcase
	end
	if (convert_roundrobin7_ce) begin
		case (convert_roundrobin7_grant)
			1'd0: begin
				if (convert_roundrobin7_request[1]) begin
					convert_roundrobin7_grant <= 1'd1;
				end
			end
			1'd1: begin
				if (convert_roundrobin7_request[0]) begin
					convert_roundrobin7_grant <= 1'd0;
				end
			end
		endcase
	end
	convert_master_wdata_ready_dly_tappeddelayline00 <= ((((((((1'd0 | ((convert_roundrobin0_grant == 1'd0) & interface_bank0_wdata_ready)) | ((convert_roundrobin1_grant == 1'd0) & interface_bank1_wdata_ready)) | ((convert_roundrobin2_grant == 1'd0) & interface_bank2_wdata_ready)) | ((convert_roundrobin3_grant == 1'd0) & interface_bank3_wdata_ready)) | ((convert_roundrobin4_grant == 1'd0) & interface_bank4_wdata_ready)) | ((convert_roundrobin5_grant == 1'd0) & interface_bank5_wdata_ready)) | ((convert_roundrobin6_grant == 1'd0) & interface_bank6_wdata_ready)) | ((convert_roundrobin7_grant == 1'd0) & interface_bank7_wdata_ready));
	convert_master_wdata_ready_dly_tappeddelayline01 <= convert_master_wdata_ready_dly_tappeddelayline00;
	convert_master_wdata_ready_dly_tappeddelayline02 <= convert_master_wdata_ready_dly_tappeddelayline01;
	convert_master_wdata_ready_dly_tappeddelayline03 <= convert_master_wdata_ready_dly_tappeddelayline02;
	convert_master_wdata_ready_dly_tappeddelayline04 <= convert_master_wdata_ready_dly_tappeddelayline03;
	convert_master_wdata_ready_dly_tappeddelayline05 <= convert_master_wdata_ready_dly_tappeddelayline04;
	convert_master_wdata_ready_dly_tappeddelayline06 <= convert_master_wdata_ready_dly_tappeddelayline05;
	convert_master_wdata_ready_dly_tappeddelayline07 <= convert_master_wdata_ready_dly_tappeddelayline06;
	convert_master_wdata_ready_dly_tappeddelayline08 <= convert_master_wdata_ready_dly_tappeddelayline07;
	convert_master_wdata_ready_dly_tappeddelayline09 <= convert_master_wdata_ready_dly_tappeddelayline08;
	convert_master_wdata_ready_dly_tappeddelayline010 <= convert_master_wdata_ready_dly_tappeddelayline09;
	convert_master_wdata_ready_dly_tappeddelayline011 <= convert_master_wdata_ready_dly_tappeddelayline010;
	convert_master_wdata_ready_dly_tappeddelayline012 <= convert_master_wdata_ready_dly_tappeddelayline011;
	convert_master_wdata_ready_dly_tappeddelayline013 <= convert_master_wdata_ready_dly_tappeddelayline012;
	convert_master_wdata_ready_dly_tappeddelayline014 <= convert_master_wdata_ready_dly_tappeddelayline013;
	convert_master_wdata_ready_dly_tappeddelayline015 <= convert_master_wdata_ready_dly_tappeddelayline014;
	convert_master_wdata_ready_dly_tappeddelayline016 <= convert_master_wdata_ready_dly_tappeddelayline015;
	convert_master_wdata_ready_dly_tappeddelayline017 <= convert_master_wdata_ready_dly_tappeddelayline016;
	convert_master_wdata_ready_dly_tappeddelayline018 <= convert_master_wdata_ready_dly_tappeddelayline017;
	convert_master_wdata_ready_dly_tappeddelayline019 <= convert_master_wdata_ready_dly_tappeddelayline018;
	convert_master_wdata_ready_dly_tappeddelayline020 <= convert_master_wdata_ready_dly_tappeddelayline019;
	convert_master_wdata_ready_dly_tappeddelayline021 <= convert_master_wdata_ready_dly_tappeddelayline020;
	convert_master_wdata_ready_dly_tappeddelayline022 <= convert_master_wdata_ready_dly_tappeddelayline021;
	convert_master_wdata_ready_dly_tappeddelayline023 <= convert_master_wdata_ready_dly_tappeddelayline022;
	convert_master_wdata_ready_dly_tappeddelayline024 <= convert_master_wdata_ready_dly_tappeddelayline023;
	convert_master_wdata_ready_dly_tappeddelayline025 <= convert_master_wdata_ready_dly_tappeddelayline024;
	convert_master_wdata_ready_dly_tappeddelayline026 <= convert_master_wdata_ready_dly_tappeddelayline025;
	convert_master_wdata_ready_dly_tappeddelayline027 <= convert_master_wdata_ready_dly_tappeddelayline026;
	convert_master_wdata_ready_dly_tappeddelayline028 <= convert_master_wdata_ready_dly_tappeddelayline027;
	convert_master_wdata_ready_dly_tappeddelayline029 <= convert_master_wdata_ready_dly_tappeddelayline028;
	convert_master_wdata_ready_dly_tappeddelayline030 <= convert_master_wdata_ready_dly_tappeddelayline029;
	convert_master_wdata_ready_dly_tappeddelayline031 <= convert_master_wdata_ready_dly_tappeddelayline030;
	convert_master_wdata_ready_dly_tappeddelayline10 <= ((((((((1'd0 | ((convert_roundrobin0_grant == 1'd1) & interface_bank0_wdata_ready)) | ((convert_roundrobin1_grant == 1'd1) & interface_bank1_wdata_ready)) | ((convert_roundrobin2_grant == 1'd1) & interface_bank2_wdata_ready)) | ((convert_roundrobin3_grant == 1'd1) & interface_bank3_wdata_ready)) | ((convert_roundrobin4_grant == 1'd1) & interface_bank4_wdata_ready)) | ((convert_roundrobin5_grant == 1'd1) & interface_bank5_wdata_ready)) | ((convert_roundrobin6_grant == 1'd1) & interface_bank6_wdata_ready)) | ((convert_roundrobin7_grant == 1'd1) & interface_bank7_wdata_ready));
	convert_master_wdata_ready_dly_tappeddelayline11 <= convert_master_wdata_ready_dly_tappeddelayline10;
	convert_master_wdata_ready_dly_tappeddelayline12 <= convert_master_wdata_ready_dly_tappeddelayline11;
	convert_master_wdata_ready_dly_tappeddelayline13 <= convert_master_wdata_ready_dly_tappeddelayline12;
	convert_master_wdata_ready_dly_tappeddelayline14 <= convert_master_wdata_ready_dly_tappeddelayline13;
	convert_master_wdata_ready_dly_tappeddelayline15 <= convert_master_wdata_ready_dly_tappeddelayline14;
	convert_master_wdata_ready_dly_tappeddelayline16 <= convert_master_wdata_ready_dly_tappeddelayline15;
	convert_master_wdata_ready_dly_tappeddelayline17 <= convert_master_wdata_ready_dly_tappeddelayline16;
	convert_master_wdata_ready_dly_tappeddelayline18 <= convert_master_wdata_ready_dly_tappeddelayline17;
	convert_master_wdata_ready_dly_tappeddelayline19 <= convert_master_wdata_ready_dly_tappeddelayline18;
	convert_master_wdata_ready_dly_tappeddelayline110 <= convert_master_wdata_ready_dly_tappeddelayline19;
	convert_master_wdata_ready_dly_tappeddelayline111 <= convert_master_wdata_ready_dly_tappeddelayline110;
	convert_master_wdata_ready_dly_tappeddelayline112 <= convert_master_wdata_ready_dly_tappeddelayline111;
	convert_master_wdata_ready_dly_tappeddelayline113 <= convert_master_wdata_ready_dly_tappeddelayline112;
	convert_master_wdata_ready_dly_tappeddelayline114 <= convert_master_wdata_ready_dly_tappeddelayline113;
	convert_master_wdata_ready_dly_tappeddelayline115 <= convert_master_wdata_ready_dly_tappeddelayline114;
	convert_master_wdata_ready_dly_tappeddelayline116 <= convert_master_wdata_ready_dly_tappeddelayline115;
	convert_master_wdata_ready_dly_tappeddelayline117 <= convert_master_wdata_ready_dly_tappeddelayline116;
	convert_master_wdata_ready_dly_tappeddelayline118 <= convert_master_wdata_ready_dly_tappeddelayline117;
	convert_master_wdata_ready_dly_tappeddelayline119 <= convert_master_wdata_ready_dly_tappeddelayline118;
	convert_master_wdata_ready_dly_tappeddelayline120 <= convert_master_wdata_ready_dly_tappeddelayline119;
	convert_master_wdata_ready_dly_tappeddelayline121 <= convert_master_wdata_ready_dly_tappeddelayline120;
	convert_master_wdata_ready_dly_tappeddelayline122 <= convert_master_wdata_ready_dly_tappeddelayline121;
	convert_master_wdata_ready_dly_tappeddelayline123 <= convert_master_wdata_ready_dly_tappeddelayline122;
	convert_master_wdata_ready_dly_tappeddelayline124 <= convert_master_wdata_ready_dly_tappeddelayline123;
	convert_master_wdata_ready_dly_tappeddelayline125 <= convert_master_wdata_ready_dly_tappeddelayline124;
	convert_master_wdata_ready_dly_tappeddelayline126 <= convert_master_wdata_ready_dly_tappeddelayline125;
	convert_master_wdata_ready_dly_tappeddelayline127 <= convert_master_wdata_ready_dly_tappeddelayline126;
	convert_master_wdata_ready_dly_tappeddelayline128 <= convert_master_wdata_ready_dly_tappeddelayline127;
	convert_master_wdata_ready_dly_tappeddelayline129 <= convert_master_wdata_ready_dly_tappeddelayline128;
	convert_master_wdata_ready_dly_tappeddelayline130 <= convert_master_wdata_ready_dly_tappeddelayline129;
	convert_master_wdata_ready_dly_tappeddelayline131 <= convert_master_wdata_ready_dly_tappeddelayline130;
	convert_master_rdata_valid_dly_tappeddelayline00 <= ((((((((1'd0 | ((convert_roundrobin0_grant == 1'd0) & interface_bank0_rdata_valid)) | ((convert_roundrobin1_grant == 1'd0) & interface_bank1_rdata_valid)) | ((convert_roundrobin2_grant == 1'd0) & interface_bank2_rdata_valid)) | ((convert_roundrobin3_grant == 1'd0) & interface_bank3_rdata_valid)) | ((convert_roundrobin4_grant == 1'd0) & interface_bank4_rdata_valid)) | ((convert_roundrobin5_grant == 1'd0) & interface_bank5_rdata_valid)) | ((convert_roundrobin6_grant == 1'd0) & interface_bank6_rdata_valid)) | ((convert_roundrobin7_grant == 1'd0) & interface_bank7_rdata_valid));
	convert_master_rdata_valid_dly_tappeddelayline01 <= convert_master_rdata_valid_dly_tappeddelayline00;
	convert_master_rdata_valid_dly_tappeddelayline02 <= convert_master_rdata_valid_dly_tappeddelayline01;
	convert_master_rdata_valid_dly_tappeddelayline03 <= convert_master_rdata_valid_dly_tappeddelayline02;
	convert_master_rdata_valid_dly_tappeddelayline04 <= convert_master_rdata_valid_dly_tappeddelayline03;
	convert_master_rdata_valid_dly_tappeddelayline05 <= convert_master_rdata_valid_dly_tappeddelayline04;
	convert_master_rdata_valid_dly_tappeddelayline06 <= convert_master_rdata_valid_dly_tappeddelayline05;
	convert_master_rdata_valid_dly_tappeddelayline07 <= convert_master_rdata_valid_dly_tappeddelayline06;
	convert_master_rdata_valid_dly_tappeddelayline08 <= convert_master_rdata_valid_dly_tappeddelayline07;
	convert_master_rdata_valid_dly_tappeddelayline09 <= convert_master_rdata_valid_dly_tappeddelayline08;
	convert_master_rdata_valid_dly_tappeddelayline010 <= convert_master_rdata_valid_dly_tappeddelayline09;
	convert_master_rdata_valid_dly_tappeddelayline011 <= convert_master_rdata_valid_dly_tappeddelayline010;
	convert_master_rdata_valid_dly_tappeddelayline012 <= convert_master_rdata_valid_dly_tappeddelayline011;
	convert_master_rdata_valid_dly_tappeddelayline013 <= convert_master_rdata_valid_dly_tappeddelayline012;
	convert_master_rdata_valid_dly_tappeddelayline014 <= convert_master_rdata_valid_dly_tappeddelayline013;
	convert_master_rdata_valid_dly_tappeddelayline015 <= convert_master_rdata_valid_dly_tappeddelayline014;
	convert_master_rdata_valid_dly_tappeddelayline016 <= convert_master_rdata_valid_dly_tappeddelayline015;
	convert_master_rdata_valid_dly_tappeddelayline017 <= convert_master_rdata_valid_dly_tappeddelayline016;
	convert_master_rdata_valid_dly_tappeddelayline018 <= convert_master_rdata_valid_dly_tappeddelayline017;
	convert_master_rdata_valid_dly_tappeddelayline019 <= convert_master_rdata_valid_dly_tappeddelayline018;
	convert_master_rdata_valid_dly_tappeddelayline020 <= convert_master_rdata_valid_dly_tappeddelayline019;
	convert_master_rdata_valid_dly_tappeddelayline021 <= convert_master_rdata_valid_dly_tappeddelayline020;
	convert_master_rdata_valid_dly_tappeddelayline022 <= convert_master_rdata_valid_dly_tappeddelayline021;
	convert_master_rdata_valid_dly_tappeddelayline023 <= convert_master_rdata_valid_dly_tappeddelayline022;
	convert_master_rdata_valid_dly_tappeddelayline024 <= convert_master_rdata_valid_dly_tappeddelayline023;
	convert_master_rdata_valid_dly_tappeddelayline025 <= convert_master_rdata_valid_dly_tappeddelayline024;
	convert_master_rdata_valid_dly_tappeddelayline026 <= convert_master_rdata_valid_dly_tappeddelayline025;
	convert_master_rdata_valid_dly_tappeddelayline027 <= convert_master_rdata_valid_dly_tappeddelayline026;
	convert_master_rdata_valid_dly_tappeddelayline028 <= convert_master_rdata_valid_dly_tappeddelayline027;
	convert_master_rdata_valid_dly_tappeddelayline029 <= convert_master_rdata_valid_dly_tappeddelayline028;
	convert_master_rdata_valid_dly_tappeddelayline030 <= convert_master_rdata_valid_dly_tappeddelayline029;
	convert_master_rdata_valid_dly_tappeddelayline031 <= convert_master_rdata_valid_dly_tappeddelayline030;
	convert_master_rdata_valid_dly_tappeddelayline10 <= ((((((((1'd0 | ((convert_roundrobin0_grant == 1'd1) & interface_bank0_rdata_valid)) | ((convert_roundrobin1_grant == 1'd1) & interface_bank1_rdata_valid)) | ((convert_roundrobin2_grant == 1'd1) & interface_bank2_rdata_valid)) | ((convert_roundrobin3_grant == 1'd1) & interface_bank3_rdata_valid)) | ((convert_roundrobin4_grant == 1'd1) & interface_bank4_rdata_valid)) | ((convert_roundrobin5_grant == 1'd1) & interface_bank5_rdata_valid)) | ((convert_roundrobin6_grant == 1'd1) & interface_bank6_rdata_valid)) | ((convert_roundrobin7_grant == 1'd1) & interface_bank7_rdata_valid));
	convert_master_rdata_valid_dly_tappeddelayline11 <= convert_master_rdata_valid_dly_tappeddelayline10;
	convert_master_rdata_valid_dly_tappeddelayline12 <= convert_master_rdata_valid_dly_tappeddelayline11;
	convert_master_rdata_valid_dly_tappeddelayline13 <= convert_master_rdata_valid_dly_tappeddelayline12;
	convert_master_rdata_valid_dly_tappeddelayline14 <= convert_master_rdata_valid_dly_tappeddelayline13;
	convert_master_rdata_valid_dly_tappeddelayline15 <= convert_master_rdata_valid_dly_tappeddelayline14;
	convert_master_rdata_valid_dly_tappeddelayline16 <= convert_master_rdata_valid_dly_tappeddelayline15;
	convert_master_rdata_valid_dly_tappeddelayline17 <= convert_master_rdata_valid_dly_tappeddelayline16;
	convert_master_rdata_valid_dly_tappeddelayline18 <= convert_master_rdata_valid_dly_tappeddelayline17;
	convert_master_rdata_valid_dly_tappeddelayline19 <= convert_master_rdata_valid_dly_tappeddelayline18;
	convert_master_rdata_valid_dly_tappeddelayline110 <= convert_master_rdata_valid_dly_tappeddelayline19;
	convert_master_rdata_valid_dly_tappeddelayline111 <= convert_master_rdata_valid_dly_tappeddelayline110;
	convert_master_rdata_valid_dly_tappeddelayline112 <= convert_master_rdata_valid_dly_tappeddelayline111;
	convert_master_rdata_valid_dly_tappeddelayline113 <= convert_master_rdata_valid_dly_tappeddelayline112;
	convert_master_rdata_valid_dly_tappeddelayline114 <= convert_master_rdata_valid_dly_tappeddelayline113;
	convert_master_rdata_valid_dly_tappeddelayline115 <= convert_master_rdata_valid_dly_tappeddelayline114;
	convert_master_rdata_valid_dly_tappeddelayline116 <= convert_master_rdata_valid_dly_tappeddelayline115;
	convert_master_rdata_valid_dly_tappeddelayline117 <= convert_master_rdata_valid_dly_tappeddelayline116;
	convert_master_rdata_valid_dly_tappeddelayline118 <= convert_master_rdata_valid_dly_tappeddelayline117;
	convert_master_rdata_valid_dly_tappeddelayline119 <= convert_master_rdata_valid_dly_tappeddelayline118;
	convert_master_rdata_valid_dly_tappeddelayline120 <= convert_master_rdata_valid_dly_tappeddelayline119;
	convert_master_rdata_valid_dly_tappeddelayline121 <= convert_master_rdata_valid_dly_tappeddelayline120;
	convert_master_rdata_valid_dly_tappeddelayline122 <= convert_master_rdata_valid_dly_tappeddelayline121;
	convert_master_rdata_valid_dly_tappeddelayline123 <= convert_master_rdata_valid_dly_tappeddelayline122;
	convert_master_rdata_valid_dly_tappeddelayline124 <= convert_master_rdata_valid_dly_tappeddelayline123;
	convert_master_rdata_valid_dly_tappeddelayline125 <= convert_master_rdata_valid_dly_tappeddelayline124;
	convert_master_rdata_valid_dly_tappeddelayline126 <= convert_master_rdata_valid_dly_tappeddelayline125;
	convert_master_rdata_valid_dly_tappeddelayline127 <= convert_master_rdata_valid_dly_tappeddelayline126;
	convert_master_rdata_valid_dly_tappeddelayline128 <= convert_master_rdata_valid_dly_tappeddelayline127;
	convert_master_rdata_valid_dly_tappeddelayline129 <= convert_master_rdata_valid_dly_tappeddelayline128;
	convert_master_rdata_valid_dly_tappeddelayline130 <= convert_master_rdata_valid_dly_tappeddelayline129;
	convert_master_rdata_valid_dly_tappeddelayline131 <= convert_master_rdata_valid_dly_tappeddelayline130;
	if (sys_rst) begin
		litedramcrossbar_roundrobin0_grant <= 1'd0;
		litedramcrossbar_roundrobin1_grant <= 1'd0;
		litedramcrossbar_roundrobin2_grant <= 1'd0;
		litedramcrossbar_roundrobin3_grant <= 1'd0;
		litedramcrossbar_roundrobin4_grant <= 1'd0;
		litedramcrossbar_roundrobin5_grant <= 1'd0;
		litedramcrossbar_roundrobin6_grant <= 1'd0;
		litedramcrossbar_roundrobin7_grant <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline00 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline01 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline02 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline03 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline04 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline05 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline06 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline07 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline08 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline09 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline010 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline011 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline012 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline013 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline014 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline015 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline016 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline017 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline018 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline019 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline020 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline021 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline022 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline023 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline024 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline025 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline026 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline027 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline028 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline029 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline030 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline031 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline10 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline11 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline12 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline13 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline14 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline15 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline16 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline17 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline18 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline19 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline110 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline111 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline112 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline113 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline114 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline115 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline116 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline117 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline118 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline119 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline120 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline121 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline122 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline123 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline124 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline125 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline126 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline127 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline128 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline129 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline130 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly_tappeddelayline131 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline00 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline01 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline02 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline03 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline04 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline05 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline06 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline07 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline08 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline09 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline010 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline011 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline012 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline013 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline014 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline015 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline016 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline017 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline018 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline019 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline020 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline021 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline022 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline023 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline024 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline025 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline026 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline027 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline028 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline029 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline030 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline031 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline10 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline11 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline12 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline13 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline14 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline15 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline16 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline17 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline18 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline19 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline110 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline111 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline112 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline113 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline114 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline115 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline116 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline117 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline118 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline119 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline120 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline121 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline122 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline123 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline124 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline125 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline126 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline127 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline128 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline129 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline130 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly_tappeddelayline131 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly0 <= 1'd0;
		litedramcrossbar_master_wdata_ready_dly1 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly0 <= 1'd0;
		litedramcrossbar_master_rdata_valid_dly1 <= 1'd0;
		convert_roundrobin0_grant <= 1'd0;
		convert_roundrobin1_grant <= 1'd0;
		convert_roundrobin2_grant <= 1'd0;
		convert_roundrobin3_grant <= 1'd0;
		convert_roundrobin4_grant <= 1'd0;
		convert_roundrobin5_grant <= 1'd0;
		convert_roundrobin6_grant <= 1'd0;
		convert_roundrobin7_grant <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline00 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline01 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline02 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline03 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline04 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline05 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline06 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline07 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline08 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline09 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline010 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline011 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline012 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline013 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline014 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline015 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline016 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline017 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline018 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline019 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline020 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline021 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline022 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline023 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline024 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline025 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline026 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline027 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline028 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline029 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline030 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline031 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline10 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline11 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline12 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline13 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline14 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline15 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline16 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline17 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline18 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline19 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline110 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline111 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline112 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline113 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline114 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline115 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline116 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline117 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline118 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline119 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline120 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline121 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline122 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline123 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline124 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline125 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline126 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline127 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline128 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline129 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline130 <= 1'd0;
		convert_master_wdata_ready_dly_tappeddelayline131 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline00 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline01 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline02 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline03 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline04 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline05 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline06 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline07 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline08 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline09 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline010 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline011 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline012 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline013 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline014 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline015 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline016 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline017 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline018 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline019 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline020 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline021 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline022 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline023 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline024 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline025 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline026 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline027 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline028 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline029 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline030 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline031 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline10 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline11 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline12 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline13 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline14 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline15 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline16 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline17 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline18 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline19 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline110 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline111 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline112 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline113 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline114 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline115 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline116 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline117 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline118 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline119 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline120 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline121 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline122 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline123 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline124 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline125 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline126 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline127 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline128 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline129 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline130 <= 1'd0;
		convert_master_rdata_valid_dly_tappeddelayline131 <= 1'd0;
		convert_master_wdata_ready_dly0 <= 1'd0;
		convert_master_wdata_ready_dly1 <= 1'd0;
		convert_master_rdata_valid_dly0 <= 1'd0;
		convert_master_rdata_valid_dly1 <= 1'd0;
	end
end

endmodule
