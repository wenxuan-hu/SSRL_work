/* Machine-generated using Migen */
module bankmachine_2(
	input req_valid,
	output req_ready,
	input req_mw,
	input req_we,
	input [22:0] req_addr,
	output req_lock,
	output reg req_wdata_ready,
	output reg req_rdata_valid,
	input refresh_req,
	output reg refresh_gnt,
	output reg cmd_valid,
	input cmd_ready,
	input cmd_first,
	input cmd_last,
	output reg [16:0] cmd_payload_a,
	output [2:0] cmd_payload_ba,
	output reg cmd_payload_cas,
	output reg cmd_payload_ras,
	output reg cmd_payload_we,
	output reg cmd_payload_is_cmd,
	output reg cmd_payload_is_read,
	output reg cmd_payload_is_write,
	output reg cmd_payload_is_mw,
	input [7:0] bm_tRTP_cfg,
	input [7:0] bm_tWTP_cfg,
	input [7:0] bm_tRC_cfg,
	input [7:0] bm_tRAS_cfg,
	input [7:0] bm_tRP_cfg,
	input [7:0] bm_tRCD_cfg,
	input [7:0] bm_tCCDMW_cfg,
	input sys_clk,
	input sys_rst
);

reg auto_precharge;
wire cmd_buffer_lookahead_sink_valid;
wire cmd_buffer_lookahead_sink_ready;
reg cmd_buffer_lookahead_sink_first = 1'd0;
reg cmd_buffer_lookahead_sink_last = 1'd0;
wire cmd_buffer_lookahead_sink_payload_we;
wire cmd_buffer_lookahead_sink_payload_mw;
wire [22:0] cmd_buffer_lookahead_sink_payload_addr;
wire cmd_buffer_lookahead_source_valid;
wire cmd_buffer_lookahead_source_ready;
wire cmd_buffer_lookahead_source_first;
wire cmd_buffer_lookahead_source_last;
wire cmd_buffer_lookahead_source_payload_we;
wire cmd_buffer_lookahead_source_payload_mw;
wire [22:0] cmd_buffer_lookahead_source_payload_addr;
wire cmd_buffer_lookahead_syncfifo_we;
wire cmd_buffer_lookahead_syncfifo_writable;
wire cmd_buffer_lookahead_syncfifo_re;
wire cmd_buffer_lookahead_syncfifo_readable;
wire [26:0] cmd_buffer_lookahead_syncfifo_din;
wire [26:0] cmd_buffer_lookahead_syncfifo_dout;
reg [1:0] cmd_buffer_lookahead_level = 2'd0;
reg cmd_buffer_lookahead_replace = 1'd0;
reg cmd_buffer_lookahead_produce = 1'd0;
reg cmd_buffer_lookahead_consume = 1'd0;
reg cmd_buffer_lookahead_wrport_adr;
wire [26:0] cmd_buffer_lookahead_wrport_dat_r;
wire cmd_buffer_lookahead_wrport_we;
wire [26:0] cmd_buffer_lookahead_wrport_dat_w;
wire cmd_buffer_lookahead_do_read;
wire cmd_buffer_lookahead_rdport_adr;
wire [26:0] cmd_buffer_lookahead_rdport_dat_r;
wire cmd_buffer_lookahead_fifo_in_payload_we;
wire cmd_buffer_lookahead_fifo_in_payload_mw;
wire [22:0] cmd_buffer_lookahead_fifo_in_payload_addr;
wire cmd_buffer_lookahead_fifo_in_first;
wire cmd_buffer_lookahead_fifo_in_last;
wire cmd_buffer_lookahead_fifo_out_payload_we;
wire cmd_buffer_lookahead_fifo_out_payload_mw;
wire [22:0] cmd_buffer_lookahead_fifo_out_payload_addr;
wire cmd_buffer_lookahead_fifo_out_first;
wire cmd_buffer_lookahead_fifo_out_last;
wire cmd_buffer_sink_valid;
wire cmd_buffer_sink_ready;
wire cmd_buffer_sink_first;
wire cmd_buffer_sink_last;
wire cmd_buffer_sink_payload_we;
wire cmd_buffer_sink_payload_mw;
wire [22:0] cmd_buffer_sink_payload_addr;
reg cmd_buffer_source_valid = 1'd0;
wire cmd_buffer_source_ready;
reg cmd_buffer_source_first = 1'd0;
reg cmd_buffer_source_last = 1'd0;
reg cmd_buffer_source_payload_we = 1'd0;
reg cmd_buffer_source_payload_mw = 1'd0;
reg [22:0] cmd_buffer_source_payload_addr = 23'd0;
reg [16:0] row = 17'd0;
reg row_opened = 1'd0;
wire row_hit;
reg row_open;
reg row_close;
reg row_col_n_addr_sel;
wire tccdmwcon_valid;
(* no_retiming = "true" *) reg tccdmwcon_ready = 1'd1;
reg [7:0] tccdmwcon_count = 8'd0;
wire trtpcon_valid;
(* no_retiming = "true" *) reg trtpcon_ready = 1'd1;
reg [7:0] trtpcon_count = 8'd0;
wire twtpcon_valid;
(* no_retiming = "true" *) reg twtpcon_ready = 1'd1;
reg [7:0] twtpcon_count = 8'd0;
wire trccon_valid;
(* no_retiming = "true" *) reg trccon_ready = 1'd1;
reg [7:0] trccon_count = 8'd0;
wire trascon_valid;
(* no_retiming = "true" *) reg trascon_ready = 1'd1;
reg [7:0] trascon_count = 8'd0;
reg trpcon_valid;
(* no_retiming = "true" *) reg trpcon_ready = 1'd1;
reg [7:0] trpcon_count = 8'd0;
wire trcdcon_valid;
(* no_retiming = "true" *) reg trcdcon_ready = 1'd1;
reg [7:0] trcdcon_count = 8'd0;
reg [2:0] state = 3'd0;
reg [2:0] next_state;
reg req_rdata_valid_next_value0;
reg req_rdata_valid_next_value_ce0;
reg req_wdata_ready_next_value1;
reg req_wdata_ready_next_value_ce1;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign cmd_buffer_lookahead_sink_valid = req_valid;
assign req_ready = cmd_buffer_lookahead_sink_ready;
assign cmd_buffer_lookahead_sink_payload_mw = req_mw;
assign cmd_buffer_lookahead_sink_payload_we = req_we;
assign cmd_buffer_lookahead_sink_payload_addr = req_addr;
assign cmd_buffer_sink_valid = cmd_buffer_lookahead_source_valid;
assign cmd_buffer_lookahead_source_ready = cmd_buffer_sink_ready;
assign cmd_buffer_sink_first = cmd_buffer_lookahead_source_first;
assign cmd_buffer_sink_last = cmd_buffer_lookahead_source_last;
assign cmd_buffer_sink_payload_we = cmd_buffer_lookahead_source_payload_we;
assign cmd_buffer_sink_payload_mw = cmd_buffer_lookahead_source_payload_mw;
assign cmd_buffer_sink_payload_addr = cmd_buffer_lookahead_source_payload_addr;
assign cmd_buffer_source_ready = (req_wdata_ready | req_rdata_valid);
assign req_lock = (cmd_buffer_lookahead_source_valid | cmd_buffer_source_valid);
assign row_hit = (row == cmd_buffer_source_payload_addr[22:6]);
assign cmd_payload_ba = 2'd2;

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	cmd_payload_a <= 17'd0;
	if (row_col_n_addr_sel) begin
		cmd_payload_a <= cmd_buffer_source_payload_addr[22:6];
	end else begin
		cmd_payload_a <= ((auto_precharge <<< 4'd10) | {cmd_buffer_source_payload_addr[5:0], {4{1'd0}}});
	end
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign tccdmwcon_valid = ((cmd_valid & cmd_ready) & cmd_payload_is_write);
assign trtpcon_valid = ((cmd_valid & cmd_ready) & cmd_payload_is_read);
assign twtpcon_valid = ((cmd_valid & cmd_ready) & cmd_payload_is_write);
assign trccon_valid = ((cmd_valid & cmd_ready) & row_open);
assign trascon_valid = ((cmd_valid & cmd_ready) & row_open);
assign trcdcon_valid = ((cmd_valid & cmd_ready) & row_open);

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	auto_precharge <= 1'd0;
	if ((cmd_buffer_lookahead_source_valid & cmd_buffer_source_valid)) begin
		if ((cmd_buffer_lookahead_source_payload_addr[22:6] != cmd_buffer_source_payload_addr[22:6])) begin
			auto_precharge <= (row_close == 1'd0);
		end
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign cmd_buffer_lookahead_syncfifo_din = {cmd_buffer_lookahead_fifo_in_last, cmd_buffer_lookahead_fifo_in_first, cmd_buffer_lookahead_fifo_in_payload_addr, cmd_buffer_lookahead_fifo_in_payload_mw, cmd_buffer_lookahead_fifo_in_payload_we};
assign {cmd_buffer_lookahead_fifo_out_last, cmd_buffer_lookahead_fifo_out_first, cmd_buffer_lookahead_fifo_out_payload_addr, cmd_buffer_lookahead_fifo_out_payload_mw, cmd_buffer_lookahead_fifo_out_payload_we} = cmd_buffer_lookahead_syncfifo_dout;
assign cmd_buffer_lookahead_sink_ready = cmd_buffer_lookahead_syncfifo_writable;
assign cmd_buffer_lookahead_syncfifo_we = cmd_buffer_lookahead_sink_valid;
assign cmd_buffer_lookahead_fifo_in_first = cmd_buffer_lookahead_sink_first;
assign cmd_buffer_lookahead_fifo_in_last = cmd_buffer_lookahead_sink_last;
assign cmd_buffer_lookahead_fifo_in_payload_we = cmd_buffer_lookahead_sink_payload_we;
assign cmd_buffer_lookahead_fifo_in_payload_mw = cmd_buffer_lookahead_sink_payload_mw;
assign cmd_buffer_lookahead_fifo_in_payload_addr = cmd_buffer_lookahead_sink_payload_addr;
assign cmd_buffer_lookahead_source_valid = cmd_buffer_lookahead_syncfifo_readable;
assign cmd_buffer_lookahead_source_first = cmd_buffer_lookahead_fifo_out_first;
assign cmd_buffer_lookahead_source_last = cmd_buffer_lookahead_fifo_out_last;
assign cmd_buffer_lookahead_source_payload_we = cmd_buffer_lookahead_fifo_out_payload_we;
assign cmd_buffer_lookahead_source_payload_mw = cmd_buffer_lookahead_fifo_out_payload_mw;
assign cmd_buffer_lookahead_source_payload_addr = cmd_buffer_lookahead_fifo_out_payload_addr;
assign cmd_buffer_lookahead_syncfifo_re = cmd_buffer_lookahead_source_ready;

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	cmd_buffer_lookahead_wrport_adr <= 1'd0;
	if (cmd_buffer_lookahead_replace) begin
		cmd_buffer_lookahead_wrport_adr <= (cmd_buffer_lookahead_produce - 1'd1);
	end else begin
		cmd_buffer_lookahead_wrport_adr <= cmd_buffer_lookahead_produce;
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end
assign cmd_buffer_lookahead_wrport_dat_w = cmd_buffer_lookahead_syncfifo_din;
assign cmd_buffer_lookahead_wrport_we = (cmd_buffer_lookahead_syncfifo_we & (cmd_buffer_lookahead_syncfifo_writable | cmd_buffer_lookahead_replace));
assign cmd_buffer_lookahead_do_read = (cmd_buffer_lookahead_syncfifo_readable & cmd_buffer_lookahead_syncfifo_re);
assign cmd_buffer_lookahead_rdport_adr = cmd_buffer_lookahead_consume;
assign cmd_buffer_lookahead_syncfifo_dout = cmd_buffer_lookahead_rdport_dat_r;
assign cmd_buffer_lookahead_syncfifo_writable = (cmd_buffer_lookahead_level != 2'd2);
assign cmd_buffer_lookahead_syncfifo_readable = (cmd_buffer_lookahead_level != 1'd0);
assign cmd_buffer_sink_ready = ((~cmd_buffer_source_valid) | cmd_buffer_source_ready);

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	refresh_gnt <= 1'd0;
	cmd_valid <= 1'd0;
	cmd_payload_cas <= 1'd0;
	cmd_payload_ras <= 1'd0;
	cmd_payload_we <= 1'd0;
	cmd_payload_is_cmd <= 1'd0;
	cmd_payload_is_read <= 1'd0;
	cmd_payload_is_write <= 1'd0;
	cmd_payload_is_mw <= 1'd0;
	row_open <= 1'd0;
	row_close <= 1'd1;
	row_col_n_addr_sel <= 1'd0;
	trpcon_valid <= 1'd0;
	next_state <= 3'd0;
	req_rdata_valid_next_value0 <= 1'd0;
	req_rdata_valid_next_value_ce0 <= 1'd0;
	req_wdata_ready_next_value1 <= 1'd0;
	req_wdata_ready_next_value_ce1 <= 1'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			if (((twtpcon_ready & trtpcon_ready) & trascon_ready)) begin
				cmd_valid <= 1'd1;
				if (cmd_ready) begin
					next_state <= 3'd5;
					trpcon_valid <= 1'd1;
				end
				cmd_payload_ras <= 1'd1;
				cmd_payload_cas <= 1'd0;
				cmd_payload_we <= 1'd1;
				cmd_payload_is_cmd <= 1'd1;
			end
			row_close <= 1'd1;
		end
		2'd2: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			if (((twtpcon_ready & trtpcon_ready) & trascon_ready)) begin
				next_state <= 3'd5;
				trpcon_valid <= 1'd1;
			end
			row_close <= 1'd1;
		end
		2'd3: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			if (trccon_ready) begin
				row_col_n_addr_sel <= 1'd1;
				row_close <= 1'd0;
				row_open <= 1'd1;
				cmd_valid <= 1'd1;
				cmd_payload_is_cmd <= 1'd1;
				if (cmd_ready) begin
					next_state <= 3'd6;
				end
				cmd_payload_ras <= 1'd1;
			end
		end
		3'd4: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			if ((twtpcon_ready & trascon_ready)) begin
				refresh_gnt <= 1'd1;
			end
			row_close <= 1'd1;
			cmd_payload_is_cmd <= 1'd1;
			if ((~refresh_req)) begin
				next_state <= 1'd0;
			end
		end
		3'd5: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			row_close <= 1'd0;
			trpcon_valid <= 1'd0;
			if (trpcon_ready) begin
				next_state <= 2'd3;
			end
		end
		3'd6: begin
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			row_close <= 1'd0;
			if (trcdcon_ready) begin
				next_state <= 1'd0;
			end
		end
		default: begin
			row_close <= 1'd0;
			req_rdata_valid_next_value0 <= 1'd0;
			req_rdata_valid_next_value_ce0 <= 1'd1;
			req_wdata_ready_next_value1 <= 1'd0;
			req_wdata_ready_next_value_ce1 <= 1'd1;
			if (refresh_req) begin
				next_state <= 3'd4;
			end else begin
				if (cmd_buffer_source_valid) begin
					if (row_opened) begin
						if (row_hit) begin
							if (cmd_buffer_source_payload_we) begin
								if (cmd_buffer_source_payload_mw) begin
									if (tccdmwcon_ready) begin
										cmd_valid <= 1'd1;
										cmd_payload_is_mw <= 1'd1;
										if (cmd_ready) begin
											req_wdata_ready_next_value1 <= 1'd1;
											req_wdata_ready_next_value_ce1 <= 1'd1;
										end else begin
											req_wdata_ready_next_value1 <= 1'd0;
											req_wdata_ready_next_value_ce1 <= 1'd1;
										end
										cmd_payload_is_write <= 1'd1;
										cmd_payload_cas <= 1'd1;
										cmd_payload_we <= 1'd1;
									end else begin
										req_wdata_ready_next_value1 <= 1'd0;
										req_wdata_ready_next_value_ce1 <= 1'd1;
									end
								end else begin
									cmd_valid <= 1'd1;
									cmd_payload_is_mw <= 1'd0;
									if (cmd_ready) begin
										req_wdata_ready_next_value1 <= 1'd1;
										req_wdata_ready_next_value_ce1 <= 1'd1;
									end else begin
										req_wdata_ready_next_value1 <= 1'd0;
										req_wdata_ready_next_value_ce1 <= 1'd1;
									end
									cmd_payload_is_write <= 1'd1;
									cmd_payload_we <= 1'd1;
									cmd_payload_cas <= 1'd1;
								end
							end else begin
								cmd_valid <= 1'd1;
								if (cmd_ready) begin
									req_rdata_valid_next_value0 <= 1'd1;
									req_rdata_valid_next_value_ce0 <= 1'd1;
								end else begin
									req_rdata_valid_next_value0 <= 1'd0;
									req_rdata_valid_next_value_ce0 <= 1'd1;
								end
								cmd_payload_is_read <= 1'd1;
								cmd_payload_cas <= 1'd1;
							end
							if (((cmd_valid & cmd_ready) & auto_precharge)) begin
								next_state <= 2'd2;
							end
						end else begin
							next_state <= 1'd1;
						end
					end else begin
						next_state <= 1'd1;
					end
				end
			end
		end
	endcase
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end

always @(posedge sys_clk) begin
	if (row_close) begin
		row_opened <= 1'd0;
	end else begin
		if (row_open) begin
			row_opened <= 1'd1;
			row <= cmd_buffer_source_payload_addr[22:6];
		end
	end
	if (((cmd_buffer_lookahead_syncfifo_we & cmd_buffer_lookahead_syncfifo_writable) & (~cmd_buffer_lookahead_replace))) begin
		cmd_buffer_lookahead_produce <= (cmd_buffer_lookahead_produce + 1'd1);
	end
	if (cmd_buffer_lookahead_do_read) begin
		cmd_buffer_lookahead_consume <= (cmd_buffer_lookahead_consume + 1'd1);
	end
	if (((cmd_buffer_lookahead_syncfifo_we & cmd_buffer_lookahead_syncfifo_writable) & (~cmd_buffer_lookahead_replace))) begin
		if ((~cmd_buffer_lookahead_do_read)) begin
			cmd_buffer_lookahead_level <= (cmd_buffer_lookahead_level + 1'd1);
		end
	end else begin
		if (cmd_buffer_lookahead_do_read) begin
			cmd_buffer_lookahead_level <= (cmd_buffer_lookahead_level - 1'd1);
		end
	end
	if (((~cmd_buffer_source_valid) | cmd_buffer_source_ready)) begin
		cmd_buffer_source_valid <= cmd_buffer_sink_valid;
		cmd_buffer_source_first <= cmd_buffer_sink_first;
		cmd_buffer_source_last <= cmd_buffer_sink_last;
		cmd_buffer_source_payload_we <= cmd_buffer_sink_payload_we;
		cmd_buffer_source_payload_mw <= cmd_buffer_sink_payload_mw;
		cmd_buffer_source_payload_addr <= cmd_buffer_sink_payload_addr;
	end
	if (tccdmwcon_valid) begin
		tccdmwcon_count <= (bm_tCCDMW_cfg - 1'd1);
		if (((bm_tCCDMW_cfg - 1'd1) == 1'd0)) begin
			tccdmwcon_ready <= 1'd1;
		end else begin
			tccdmwcon_ready <= 1'd0;
		end
	end else begin
		if ((~tccdmwcon_ready)) begin
			tccdmwcon_count <= (tccdmwcon_count - 1'd1);
			if ((tccdmwcon_count == 1'd1)) begin
				tccdmwcon_ready <= 1'd1;
			end
		end
	end
	if (trtpcon_valid) begin
		trtpcon_count <= (bm_tRTP_cfg - 1'd1);
		if (((bm_tRTP_cfg - 1'd1) == 1'd0)) begin
			trtpcon_ready <= 1'd1;
		end else begin
			trtpcon_ready <= 1'd0;
		end
	end else begin
		if ((~trtpcon_ready)) begin
			trtpcon_count <= (trtpcon_count - 1'd1);
			if ((trtpcon_count == 1'd1)) begin
				trtpcon_ready <= 1'd1;
			end
		end
	end
	if (twtpcon_valid) begin
		twtpcon_count <= (bm_tWTP_cfg - 1'd1);
		if (((bm_tWTP_cfg - 1'd1) == 1'd0)) begin
			twtpcon_ready <= 1'd1;
		end else begin
			twtpcon_ready <= 1'd0;
		end
	end else begin
		if ((~twtpcon_ready)) begin
			twtpcon_count <= (twtpcon_count - 1'd1);
			if ((twtpcon_count == 1'd1)) begin
				twtpcon_ready <= 1'd1;
			end
		end
	end
	if (trccon_valid) begin
		trccon_count <= (bm_tRC_cfg - 1'd1);
		if (((bm_tRC_cfg - 1'd1) == 1'd0)) begin
			trccon_ready <= 1'd1;
		end else begin
			trccon_ready <= 1'd0;
		end
	end else begin
		if ((~trccon_ready)) begin
			trccon_count <= (trccon_count - 1'd1);
			if ((trccon_count == 1'd1)) begin
				trccon_ready <= 1'd1;
			end
		end
	end
	if (trascon_valid) begin
		trascon_count <= (bm_tRAS_cfg - 1'd1);
		if (((bm_tRAS_cfg - 1'd1) == 1'd0)) begin
			trascon_ready <= 1'd1;
		end else begin
			trascon_ready <= 1'd0;
		end
	end else begin
		if ((~trascon_ready)) begin
			trascon_count <= (trascon_count - 1'd1);
			if ((trascon_count == 1'd1)) begin
				trascon_ready <= 1'd1;
			end
		end
	end
	if (trpcon_valid) begin
		trpcon_count <= (bm_tRP_cfg - 1'd1);
		if (((bm_tRP_cfg - 1'd1) == 1'd0)) begin
			trpcon_ready <= 1'd1;
		end else begin
			trpcon_ready <= 1'd0;
		end
	end else begin
		if ((~trpcon_ready)) begin
			trpcon_count <= (trpcon_count - 1'd1);
			if ((trpcon_count == 1'd1)) begin
				trpcon_ready <= 1'd1;
			end
		end
	end
	if (trcdcon_valid) begin
		trcdcon_count <= (bm_tRCD_cfg - 1'd1);
		if (((bm_tRCD_cfg - 1'd1) == 1'd0)) begin
			trcdcon_ready <= 1'd1;
		end else begin
			trcdcon_ready <= 1'd0;
		end
	end else begin
		if ((~trcdcon_ready)) begin
			trcdcon_count <= (trcdcon_count - 1'd1);
			if ((trcdcon_count == 1'd1)) begin
				trcdcon_ready <= 1'd1;
			end
		end
	end
	state <= next_state;
	if (req_rdata_valid_next_value_ce0) begin
		req_rdata_valid <= req_rdata_valid_next_value0;
	end
	if (req_wdata_ready_next_value_ce1) begin
		req_wdata_ready <= req_wdata_ready_next_value1;
	end
	if (sys_rst) begin
		req_wdata_ready <= 1'd0;
		req_rdata_valid <= 1'd0;
		cmd_buffer_lookahead_level <= 2'd0;
		cmd_buffer_lookahead_produce <= 1'd0;
		cmd_buffer_lookahead_consume <= 1'd0;
		cmd_buffer_source_valid <= 1'd0;
		cmd_buffer_source_payload_we <= 1'd0;
		cmd_buffer_source_payload_mw <= 1'd0;
		cmd_buffer_source_payload_addr <= 23'd0;
		row <= 17'd0;
		row_opened <= 1'd0;
		tccdmwcon_ready <= 1'd1;
		tccdmwcon_count <= 8'd0;
		trtpcon_ready <= 1'd1;
		trtpcon_count <= 8'd0;
		twtpcon_ready <= 1'd1;
		twtpcon_count <= 8'd0;
		trccon_ready <= 1'd1;
		trccon_count <= 8'd0;
		trascon_ready <= 1'd1;
		trascon_count <= 8'd0;
		trpcon_ready <= 1'd1;
		trpcon_count <= 8'd0;
		trcdcon_ready <= 1'd1;
		trcdcon_count <= 8'd0;
		state <= 3'd0;
	end
end

reg [26:0] storage[0:1];
reg [26:0] memdat;
always @(posedge sys_clk) begin
	if (cmd_buffer_lookahead_wrport_we)
		storage[cmd_buffer_lookahead_wrport_adr] <= cmd_buffer_lookahead_wrport_dat_w;
	memdat <= storage[cmd_buffer_lookahead_wrport_adr];
end

always @(posedge sys_clk) begin
end

assign cmd_buffer_lookahead_wrport_dat_r = memdat;
assign cmd_buffer_lookahead_rdport_dat_r = storage[cmd_buffer_lookahead_rdport_adr];

endmodule
