/* Machine-generated using Migen */
module refresher_pos_8(
	output reg cmd_valid,
	input cmd_ready,
	output reg cmd_last,
	output reg [16:0] cmd_payload_a,
	output reg [2:0] cmd_payload_ba,
	output reg cmd_payload_cas,
	output reg cmd_payload_ras,
	output reg cmd_payload_we,
	input cmd_payload_is_mw,
	input [7:0] ref_tRP_cfg,
	input [7:0] ref_tRFC_cfg,
	input [11:0] ref_tREFI_cfg,
	input [3:0] ref_POSTPONE_cfg,
	input sys_clk,
	input sys_rst
);

wire wants_refresh;
wire timer_wait;
wire timer_done0;
wire [11:0] timer_count0;
wire timer_done1;
reg [11:0] timer_count1 = 12'd0;
wire postponer_req_i;
reg postponer_req_o = 1'd0;
reg [3:0] postponer_count = (ref_POSTPONE_cfg - 1'd1);
reg sequencer_start0;
wire sequencer_done0;
wire sequencer_start1;
reg sequencer_done1;
reg [7:0] sequencer_count0 = 8'd0;
reg [3:0] sequencer_count1 = 4'd0;
reg [1:0] refreshsequencer_state = 2'd0;
reg [1:0] refreshsequencer_next_state;
reg [7:0] sequencer_count0_next_value;
reg sequencer_count0_next_value_ce;
reg [1:0] fsm_state = 2'd0;
reg [1:0] fsm_next_state;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign timer_wait = (~timer_done0);
assign postponer_req_i = timer_done0;
assign wants_refresh = postponer_req_o;
assign timer_done1 = (timer_count1 == 1'd0);
assign timer_done0 = timer_done1;
assign timer_count0 = timer_count1;
assign sequencer_start1 = (sequencer_start0 | (sequencer_count1 != 1'd0));
assign sequencer_done0 = (sequencer_done1 & (sequencer_count1 == 1'd0));

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	cmd_payload_a <= 17'd0;
	cmd_payload_ba <= 3'd0;
	cmd_payload_cas <= 1'd0;
	cmd_payload_ras <= 1'd0;
	cmd_payload_we <= 1'd0;
	sequencer_done1 <= 1'd0;
	refreshsequencer_next_state <= 2'd0;
	sequencer_count0_next_value <= 8'd0;
	sequencer_count0_next_value_ce <= 1'd0;
	refreshsequencer_next_state <= refreshsequencer_state;
	case (refreshsequencer_state)
		1'd1: begin
			sequencer_count0_next_value <= (sequencer_count0 - 1'd1);
			sequencer_count0_next_value_ce <= 1'd1;
			if ((sequencer_count0 == (ref_tRFC_cfg - 1'd1))) begin
				cmd_payload_a <= 11'd1024;
				cmd_payload_ba <= 1'd0;
				cmd_payload_cas <= 1'd1;
				cmd_payload_ras <= 1'd1;
				cmd_payload_we <= 1'd0;
			end else begin
				if ((sequencer_count0 == 1'd0)) begin
					cmd_payload_a <= 1'd0;
					cmd_payload_ba <= 1'd0;
					cmd_payload_cas <= 1'd0;
					cmd_payload_ras <= 1'd0;
					cmd_payload_we <= 1'd0;
					refreshsequencer_next_state <= 2'd2;
				end
			end
		end
		2'd2: begin
			sequencer_done1 <= 1'd1;
			if (sequencer_start1) begin
				sequencer_count0_next_value <= ((ref_tRP_cfg + ref_tRFC_cfg) - 1'd1);
				sequencer_count0_next_value_ce <= 1'd1;
				cmd_payload_a <= 11'd1024;
				cmd_payload_ba <= 1'd0;
				cmd_payload_cas <= 1'd0;
				cmd_payload_ras <= 1'd1;
				cmd_payload_we <= 1'd1;
				refreshsequencer_next_state <= 1'd1;
			end else begin
				refreshsequencer_next_state <= 1'd0;
			end
		end
		default: begin
			if (sequencer_start1) begin
				sequencer_count0_next_value <= ((ref_tRP_cfg + ref_tRFC_cfg) - 1'd1);
				sequencer_count0_next_value_ce <= 1'd1;
				cmd_payload_a <= 11'd1024;
				cmd_payload_ba <= 1'd0;
				cmd_payload_cas <= 1'd0;
				cmd_payload_ras <= 1'd1;
				cmd_payload_we <= 1'd1;
				refreshsequencer_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	cmd_valid <= 1'd0;
	cmd_last <= 1'd0;
	sequencer_start0 <= 1'd0;
	fsm_next_state <= 2'd0;
	fsm_next_state <= fsm_state;
	case (fsm_state)
		1'd1: begin
			cmd_valid <= 1'd1;
			if (cmd_ready) begin
				sequencer_start0 <= 1'd1;
				fsm_next_state <= 2'd2;
			end
		end
		2'd2: begin
			cmd_valid <= 1'd1;
			if (sequencer_done0) begin
				cmd_valid <= 1'd0;
				cmd_last <= 1'd1;
				fsm_next_state <= 1'd0;
			end
		end
		default: begin
			if (1'd1) begin
				if (wants_refresh) begin
					fsm_next_state <= 1'd1;
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	if ((timer_wait & (~timer_done0))) begin
		timer_count1 <= (timer_count1 - 1'd1);
	end else begin
		timer_count1 <= (ref_tREFI_cfg - 1'd1);
	end
	postponer_req_o <= 1'd0;
	if (postponer_req_i) begin
		postponer_count <= (postponer_count - 1'd1);
		if ((postponer_count == 1'd0)) begin
			postponer_count <= (ref_POSTPONE_cfg - 1'd1);
			postponer_req_o <= 1'd1;
		end
	end
	if (sequencer_start0) begin
		sequencer_count1 <= (ref_POSTPONE_cfg - 1'd1);
	end else begin
		if (sequencer_done1) begin
			if ((sequencer_count1 != 1'd0)) begin
				sequencer_count1 <= (sequencer_count1 - 1'd1);
			end
		end
	end
	refreshsequencer_state <= refreshsequencer_next_state;
	if (sequencer_count0_next_value_ce) begin
		sequencer_count0 <= sequencer_count0_next_value;
	end
	fsm_state <= fsm_next_state;
	if (sys_rst) begin
		timer_count1 <= 12'd0;
		postponer_req_o <= 1'd0;
		postponer_count <= (ref_POSTPONE_cfg - 1'd1);
		sequencer_count0 <= 8'd0;
		sequencer_count1 <= 4'd0;
		refreshsequencer_state <= 2'd0;
		fsm_state <= 2'd0;
	end
end

endmodule
