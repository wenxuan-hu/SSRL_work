/* Machine-generated using Migen */
module axi2native(
	input axi_aw_valid,
	output axi_aw_ready,
	input axi_aw_first,
	input axi_aw_last,
	input [31:0] axi_aw_payload_addr,
	input [1:0] axi_aw_payload_burst,
	input [7:0] axi_aw_payload_len,
	input [3:0] axi_aw_payload_size,
	input [1:0] axi_aw_payload_lock,
	input [2:0] axi_aw_payload_prot,
	input [3:0] axi_aw_payload_cache,
	input [3:0] axi_aw_payload_qos,
	input [3:0] axi_aw_payload_id,
	input axi_w_valid,
	output reg axi_w_ready,
	input axi_w_first,
	input axi_w_last,
	input [255:0] axi_w_payload_data,
	input [31:0] axi_w_payload_strb,
	input [3:0] axi_w_payload_id,
	output axi_b_valid,
	input axi_b_ready,
	output axi_b_first,
	output axi_b_last,
	output [1:0] axi_b_payload_resp,
	output [3:0] axi_b_payload_id,
	input axi_ar_valid,
	output axi_ar_ready,
	input axi_ar_first,
	input axi_ar_last,
	input [31:0] axi_ar_payload_addr,
	input [1:0] axi_ar_payload_burst,
	input [7:0] axi_ar_payload_len,
	input [3:0] axi_ar_payload_size,
	input [1:0] axi_ar_payload_lock,
	input [2:0] axi_ar_payload_prot,
	input [3:0] axi_ar_payload_cache,
	input [3:0] axi_ar_payload_qos,
	input [3:0] axi_ar_payload_id,
	output axi_r_valid,
	input axi_r_ready,
	output axi_r_first,
	output axi_r_last,
	output reg [1:0] axi_r_payload_resp,
	output [255:0] axi_r_payload_data,
	output [3:0] axi_r_payload_id,
	output reg cmd_valid,
	input cmd_ready,
	input cmd_first,
	output reg cmd_last,
	output reg cmd_payload_we,
	output reg [26:0] cmd_payload_addr,
	output wdata_valid,
	input wdata_ready,
	output wdata_first,
	output wdata_last,
	output [255:0] wdata_payload_data,
	output [31:0] wdata_payload_we,
	input rdata_valid,
	output reg rdata_ready,
	input rdata_first,
	input rdata_last,
	input [255:0] rdata_payload_data,
	input sys_clk,
	input sys_rst
);

wire write_cmd_request;
wire write_cmd_grant;
reg write_can_write;
wire write_aw_buffer_sink_valid;
wire write_aw_buffer_sink_ready;
wire write_aw_buffer_sink_first;
wire write_aw_buffer_sink_last;
wire [31:0] write_aw_buffer_sink_payload_addr;
wire [1:0] write_aw_buffer_sink_payload_burst;
wire [7:0] write_aw_buffer_sink_payload_len;
wire [3:0] write_aw_buffer_sink_payload_size;
wire [1:0] write_aw_buffer_sink_payload_lock;
wire [2:0] write_aw_buffer_sink_payload_prot;
wire [3:0] write_aw_buffer_sink_payload_cache;
wire [3:0] write_aw_buffer_sink_payload_qos;
wire [3:0] write_aw_buffer_sink_payload_id;
reg write_aw_buffer_source_valid = 1'd0;
reg write_aw_buffer_source_ready;
reg write_aw_buffer_source_first = 1'd0;
reg write_aw_buffer_source_last = 1'd0;
reg [31:0] write_aw_buffer_source_payload_addr = 32'd0;
reg [1:0] write_aw_buffer_source_payload_burst = 2'd0;
reg [7:0] write_aw_buffer_source_payload_len = 8'd0;
reg [3:0] write_aw_buffer_source_payload_size = 4'd0;
reg [1:0] write_aw_buffer_source_payload_lock = 2'd0;
reg [2:0] write_aw_buffer_source_payload_prot = 3'd0;
reg [3:0] write_aw_buffer_source_payload_cache = 4'd0;
reg [3:0] write_aw_buffer_source_payload_qos = 4'd0;
reg [3:0] write_aw_buffer_source_payload_id = 4'd0;
wire write_aw_valid;
reg write_aw_ready;
wire write_aw_first;
wire write_aw_last;
wire [31:0] write_aw_payload_addr;
wire [3:0] write_aw_payload_id;
reg [7:0] write_beat_count = 8'd0;
wire [11:0] write_beat_size;
reg signed [12:0] write_beat_offset = 13'sd0;
wire [11:0] write_beat_wrap;
reg write_w_buffer_sink_valid;
wire write_w_buffer_sink_ready;
reg write_w_buffer_sink_first;
reg write_w_buffer_sink_last;
reg [255:0] write_w_buffer_sink_payload_data;
reg [31:0] write_w_buffer_sink_payload_strb;
reg [3:0] write_w_buffer_sink_payload_id;
wire write_w_buffer_source_valid;
wire write_w_buffer_source_ready;
wire write_w_buffer_source_first;
wire write_w_buffer_source_last;
wire [255:0] write_w_buffer_source_payload_data;
wire [31:0] write_w_buffer_source_payload_strb;
wire [3:0] write_w_buffer_source_payload_id;
wire write_w_buffer_re;
reg write_w_buffer_readable = 1'd0;
wire write_w_buffer_syncfifo_we;
wire write_w_buffer_syncfifo_writable;
wire write_w_buffer_syncfifo_re;
wire write_w_buffer_syncfifo_readable;
wire [293:0] write_w_buffer_syncfifo_din;
wire [293:0] write_w_buffer_syncfifo_dout;
reg [4:0] write_w_buffer_level0 = 5'd0;
reg write_w_buffer_replace = 1'd0;
reg [3:0] write_w_buffer_produce = 4'd0;
reg [3:0] write_w_buffer_consume = 4'd0;
reg [3:0] write_w_buffer_wrport_adr;
wire [293:0] write_w_buffer_wrport_dat_r;
wire write_w_buffer_wrport_we;
wire [293:0] write_w_buffer_wrport_dat_w;
wire write_w_buffer_do_read;
wire [3:0] write_w_buffer_rdport_adr;
wire [293:0] write_w_buffer_rdport_dat_r;
wire write_w_buffer_rdport_re;
wire [4:0] write_w_buffer_level1;
wire [255:0] write_w_buffer_fifo_in_payload_data;
wire [31:0] write_w_buffer_fifo_in_payload_strb;
wire [3:0] write_w_buffer_fifo_in_payload_id;
wire write_w_buffer_fifo_in_first;
wire write_w_buffer_fifo_in_last;
wire [255:0] write_w_buffer_fifo_out_payload_data;
wire [31:0] write_w_buffer_fifo_out_payload_strb;
wire [3:0] write_w_buffer_fifo_out_payload_id;
wire write_w_buffer_fifo_out_first;
wire write_w_buffer_fifo_out_last;
wire write_id_buffer_sink_valid;
wire write_id_buffer_sink_ready;
reg write_id_buffer_sink_first = 1'd0;
reg write_id_buffer_sink_last = 1'd0;
wire [3:0] write_id_buffer_sink_payload_id;
wire write_id_buffer_source_valid;
reg write_id_buffer_source_ready;
wire write_id_buffer_source_first;
wire write_id_buffer_source_last;
wire [3:0] write_id_buffer_source_payload_id;
wire write_id_buffer_syncfifo_we;
wire write_id_buffer_syncfifo_writable;
wire write_id_buffer_syncfifo_re;
wire write_id_buffer_syncfifo_readable;
wire [5:0] write_id_buffer_syncfifo_din;
wire [5:0] write_id_buffer_syncfifo_dout;
reg [4:0] write_id_buffer_level = 5'd0;
reg write_id_buffer_replace = 1'd0;
reg [3:0] write_id_buffer_produce = 4'd0;
reg [3:0] write_id_buffer_consume = 4'd0;
reg [3:0] write_id_buffer_wrport_adr;
wire [5:0] write_id_buffer_wrport_dat_r;
wire write_id_buffer_wrport_we;
wire [5:0] write_id_buffer_wrport_dat_w;
wire write_id_buffer_do_read;
wire [3:0] write_id_buffer_rdport_adr;
wire [5:0] write_id_buffer_rdport_dat_r;
wire [3:0] write_id_buffer_fifo_in_payload_id;
wire write_id_buffer_fifo_in_first;
wire write_id_buffer_fifo_in_last;
wire [3:0] write_id_buffer_fifo_out_payload_id;
wire write_id_buffer_fifo_out_first;
wire write_id_buffer_fifo_out_last;
reg write_resp_buffer_sink_valid;
wire write_resp_buffer_sink_ready;
reg write_resp_buffer_sink_first = 1'd0;
reg write_resp_buffer_sink_last = 1'd0;
reg [3:0] write_resp_buffer_sink_payload_id;
reg [1:0] write_resp_buffer_sink_payload_resp;
wire write_resp_buffer_source_valid;
wire write_resp_buffer_source_ready;
wire write_resp_buffer_source_first;
wire write_resp_buffer_source_last;
wire [3:0] write_resp_buffer_source_payload_id;
wire [1:0] write_resp_buffer_source_payload_resp;
wire write_resp_buffer_syncfifo_we;
wire write_resp_buffer_syncfifo_writable;
wire write_resp_buffer_syncfifo_re;
wire write_resp_buffer_syncfifo_readable;
wire [7:0] write_resp_buffer_syncfifo_din;
wire [7:0] write_resp_buffer_syncfifo_dout;
reg [4:0] write_resp_buffer_level = 5'd0;
reg write_resp_buffer_replace = 1'd0;
reg [3:0] write_resp_buffer_produce = 4'd0;
reg [3:0] write_resp_buffer_consume = 4'd0;
reg [3:0] write_resp_buffer_wrport_adr;
wire [7:0] write_resp_buffer_wrport_dat_r;
wire write_resp_buffer_wrport_we;
wire [7:0] write_resp_buffer_wrport_dat_w;
wire write_resp_buffer_do_read;
wire [3:0] write_resp_buffer_rdport_adr;
wire [7:0] write_resp_buffer_rdport_dat_r;
wire [3:0] write_resp_buffer_fifo_in_payload_id;
wire [1:0] write_resp_buffer_fifo_in_payload_resp;
wire write_resp_buffer_fifo_in_first;
wire write_resp_buffer_fifo_in_last;
wire [3:0] write_resp_buffer_fifo_out_payload_id;
wire [1:0] write_resp_buffer_fifo_out_payload_resp;
wire write_resp_buffer_fifo_out_first;
wire write_resp_buffer_fifo_out_last;
wire write_w_buffer_queue;
wire write_w_buffer_dequeue;
reg [4:0] write_w_buffer_level2 = 5'd0;
reg write_axi_w_connect;
reg write_rmw_request;
wire write_rmw_rgrant;
wire write_rmw_wgrant;
reg [255:0] write_rmw_data = 256'd0;
reg [255:0] write_rmw_mask;
reg write_rmw_cmd_done = 1'd0;
reg write_rmw_data_done = 1'd0;
wire read_cmd_request;
wire read_cmd_grant;
reg read_can_read;
wire read_ar_buffer_sink_valid;
wire read_ar_buffer_sink_ready;
wire read_ar_buffer_sink_first;
wire read_ar_buffer_sink_last;
wire [31:0] read_ar_buffer_sink_payload_addr;
wire [1:0] read_ar_buffer_sink_payload_burst;
wire [7:0] read_ar_buffer_sink_payload_len;
wire [3:0] read_ar_buffer_sink_payload_size;
wire [1:0] read_ar_buffer_sink_payload_lock;
wire [2:0] read_ar_buffer_sink_payload_prot;
wire [3:0] read_ar_buffer_sink_payload_cache;
wire [3:0] read_ar_buffer_sink_payload_qos;
wire [3:0] read_ar_buffer_sink_payload_id;
reg read_ar_buffer_source_valid = 1'd0;
reg read_ar_buffer_source_ready;
reg read_ar_buffer_source_first = 1'd0;
reg read_ar_buffer_source_last = 1'd0;
reg [31:0] read_ar_buffer_source_payload_addr = 32'd0;
reg [1:0] read_ar_buffer_source_payload_burst = 2'd0;
reg [7:0] read_ar_buffer_source_payload_len = 8'd0;
reg [3:0] read_ar_buffer_source_payload_size = 4'd0;
reg [1:0] read_ar_buffer_source_payload_lock = 2'd0;
reg [2:0] read_ar_buffer_source_payload_prot = 3'd0;
reg [3:0] read_ar_buffer_source_payload_cache = 4'd0;
reg [3:0] read_ar_buffer_source_payload_qos = 4'd0;
reg [3:0] read_ar_buffer_source_payload_id = 4'd0;
wire read_ar_valid;
reg read_ar_ready;
wire read_ar_first;
wire read_ar_last;
wire [31:0] read_ar_payload_addr;
wire [3:0] read_ar_payload_id;
reg [7:0] read_beat_count = 8'd0;
wire [11:0] read_beat_size;
reg signed [12:0] read_beat_offset = 13'sd0;
wire [11:0] read_beat_wrap;
reg read_r_buffer_sink_valid;
wire read_r_buffer_sink_ready;
wire read_r_buffer_sink_first;
wire read_r_buffer_sink_last;
reg [1:0] read_r_buffer_sink_payload_resp = 2'd0;
wire [255:0] read_r_buffer_sink_payload_data;
reg [3:0] read_r_buffer_sink_payload_id = 4'd0;
wire read_r_buffer_source_valid;
wire read_r_buffer_source_ready;
wire read_r_buffer_source_first;
wire read_r_buffer_source_last;
wire [1:0] read_r_buffer_source_payload_resp;
wire [255:0] read_r_buffer_source_payload_data;
wire [3:0] read_r_buffer_source_payload_id;
wire read_r_buffer_re;
reg read_r_buffer_readable = 1'd0;
wire read_r_buffer_syncfifo_we;
wire read_r_buffer_syncfifo_writable;
wire read_r_buffer_syncfifo_re;
wire read_r_buffer_syncfifo_readable;
wire [263:0] read_r_buffer_syncfifo_din;
wire [263:0] read_r_buffer_syncfifo_dout;
reg [4:0] read_r_buffer_level0 = 5'd0;
reg read_r_buffer_replace = 1'd0;
reg [3:0] read_r_buffer_produce = 4'd0;
reg [3:0] read_r_buffer_consume = 4'd0;
reg [3:0] read_r_buffer_wrport_adr;
wire [263:0] read_r_buffer_wrport_dat_r;
wire read_r_buffer_wrport_we;
wire [263:0] read_r_buffer_wrport_dat_w;
wire read_r_buffer_do_read;
wire [3:0] read_r_buffer_rdport_adr;
wire [263:0] read_r_buffer_rdport_dat_r;
wire read_r_buffer_rdport_re;
wire [4:0] read_r_buffer_level1;
wire [1:0] read_r_buffer_fifo_in_payload_resp;
wire [255:0] read_r_buffer_fifo_in_payload_data;
wire [3:0] read_r_buffer_fifo_in_payload_id;
wire read_r_buffer_fifo_in_first;
wire read_r_buffer_fifo_in_last;
wire [1:0] read_r_buffer_fifo_out_payload_resp;
wire [255:0] read_r_buffer_fifo_out_payload_data;
wire [3:0] read_r_buffer_fifo_out_payload_id;
wire read_r_buffer_fifo_out_first;
wire read_r_buffer_fifo_out_last;
reg read_r_buffer_queue;
wire read_r_buffer_dequeue;
reg [4:0] read_r_buffer_level2 = 5'd0;
wire read_id_buffer_sink_valid;
wire read_id_buffer_sink_ready;
reg read_id_buffer_sink_first = 1'd0;
wire read_id_buffer_sink_last;
wire [3:0] read_id_buffer_sink_payload_id;
wire read_id_buffer_source_valid;
wire read_id_buffer_source_ready;
wire read_id_buffer_source_first;
wire read_id_buffer_source_last;
wire [3:0] read_id_buffer_source_payload_id;
wire read_id_buffer_syncfifo_we;
wire read_id_buffer_syncfifo_writable;
wire read_id_buffer_syncfifo_re;
wire read_id_buffer_syncfifo_readable;
wire [5:0] read_id_buffer_syncfifo_din;
wire [5:0] read_id_buffer_syncfifo_dout;
reg [4:0] read_id_buffer_level = 5'd0;
reg read_id_buffer_replace = 1'd0;
reg [3:0] read_id_buffer_produce = 4'd0;
reg [3:0] read_id_buffer_consume = 4'd0;
reg [3:0] read_id_buffer_wrport_adr;
wire [5:0] read_id_buffer_wrport_dat_r;
wire read_id_buffer_wrport_we;
wire [5:0] read_id_buffer_wrport_dat_w;
wire read_id_buffer_do_read;
wire [3:0] read_id_buffer_rdport_adr;
wire [5:0] read_id_buffer_rdport_dat_r;
wire [3:0] read_id_buffer_fifo_in_payload_id;
wire read_id_buffer_fifo_in_first;
wire read_id_buffer_fifo_in_last;
wire [3:0] read_id_buffer_fifo_out_payload_id;
wire read_id_buffer_fifo_out_first;
wire read_id_buffer_fifo_out_last;
wire read_rmw_request;
wire read_rmw_rgrant;
reg [1:0] request;
reg grant = 1'd0;
wire ce;
reg [1:0] state = 2'd0;
reg [1:0] next_state;
reg write_rmw_cmd_done_next_value0;
reg write_rmw_cmd_done_next_value_ce0;
reg write_rmw_data_done_next_value1;
reg write_rmw_data_done_next_value_ce1;
reg [255:0] write_rmw_data_next_value2;
reg write_rmw_data_next_value_ce2;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign ce = ((~cmd_valid) | (cmd_ready & cmd_last));
assign write_cmd_grant = (grant == 1'd0);

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	request <= 2'd0;
	request[0] <= write_cmd_request;
	request[1] <= read_cmd_request;
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign read_cmd_grant = (grant == 1'd1);
assign read_rmw_request = write_rmw_request;
assign write_rmw_rgrant = read_rmw_rgrant;
assign write_aw_buffer_sink_valid = axi_aw_valid;
assign axi_aw_ready = write_aw_buffer_sink_ready;
assign write_aw_buffer_sink_first = axi_aw_first;
assign write_aw_buffer_sink_last = axi_aw_last;
assign write_aw_buffer_sink_payload_addr = axi_aw_payload_addr;
assign write_aw_buffer_sink_payload_burst = axi_aw_payload_burst;
assign write_aw_buffer_sink_payload_len = axi_aw_payload_len;
assign write_aw_buffer_sink_payload_size = axi_aw_payload_size;
assign write_aw_buffer_sink_payload_lock = axi_aw_payload_lock;
assign write_aw_buffer_sink_payload_prot = axi_aw_payload_prot;
assign write_aw_buffer_sink_payload_cache = axi_aw_payload_cache;
assign write_aw_buffer_sink_payload_qos = axi_aw_payload_qos;
assign write_aw_buffer_sink_payload_id = axi_aw_payload_id;
assign write_id_buffer_sink_valid = ((write_aw_valid & write_aw_first) & write_aw_ready);
assign write_id_buffer_sink_payload_id = write_aw_payload_id;

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	write_id_buffer_source_ready <= 1'd0;
	write_resp_buffer_sink_valid <= 1'd0;
	write_resp_buffer_sink_payload_id <= 4'd0;
	write_resp_buffer_sink_payload_resp <= 2'd0;
	if (((write_w_buffer_source_valid & write_w_buffer_source_last) & write_w_buffer_source_ready)) begin
		write_resp_buffer_sink_valid <= 1'd1;
		write_resp_buffer_sink_payload_resp <= 1'd0;
		write_resp_buffer_sink_payload_id <= write_id_buffer_source_payload_id;
		write_id_buffer_source_ready <= 1'd1;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign axi_b_valid = write_resp_buffer_source_valid;
assign write_resp_buffer_source_ready = axi_b_ready;
assign axi_b_first = write_resp_buffer_source_first;
assign axi_b_last = write_resp_buffer_source_last;
assign axi_b_payload_id = write_resp_buffer_source_payload_id;
assign axi_b_payload_resp = write_resp_buffer_source_payload_resp;
assign write_w_buffer_queue = ((cmd_valid & cmd_ready) & cmd_payload_we);
assign write_w_buffer_dequeue = (write_w_buffer_source_valid & write_w_buffer_source_ready);
assign write_cmd_request = (write_aw_valid & write_can_write);
assign wdata_valid = write_w_buffer_source_valid;
assign write_w_buffer_source_ready = wdata_ready;
assign wdata_first = write_w_buffer_source_first;
assign wdata_last = write_w_buffer_source_last;
assign wdata_payload_data = write_w_buffer_source_payload_data;
assign wdata_payload_we = write_w_buffer_source_payload_strb;
assign write_rmw_wgrant = ((~write_w_buffer_queue) & (write_w_buffer_level2 == 1'd0));

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	write_can_write <= 1'd0;
	write_can_write <= (write_w_buffer_level1 > write_w_buffer_level2);
	if (write_rmw_request) begin
		write_can_write <= 1'd0;
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	write_axi_w_connect <= 1'd1;
	if (write_rmw_request) begin
		write_axi_w_connect <= 1'd0;
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end
assign write_aw_buffer_sink_ready = ((~write_aw_buffer_source_valid) | write_aw_buffer_source_ready);
assign write_beat_size = (1'd1 <<< write_aw_buffer_source_payload_size);
assign write_beat_wrap = (write_aw_buffer_source_payload_len <<< write_aw_buffer_source_payload_size);
assign write_aw_valid = (write_aw_buffer_source_valid | (~write_aw_first));
assign write_aw_first = (write_beat_count == 1'd0);
assign write_aw_last = (write_beat_count == write_aw_buffer_source_payload_len);
assign write_aw_payload_addr = ($signed({1'd0, write_aw_buffer_source_payload_addr}) + write_beat_offset);
assign write_aw_payload_id = write_aw_buffer_source_payload_id;

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	write_aw_buffer_source_ready <= 1'd0;
	if (write_aw_ready) begin
		if (write_aw_last) begin
			write_aw_buffer_source_ready <= 1'd1;
		end
	end
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end
assign write_w_buffer_syncfifo_din = {write_w_buffer_fifo_in_last, write_w_buffer_fifo_in_first, write_w_buffer_fifo_in_payload_id, write_w_buffer_fifo_in_payload_strb, write_w_buffer_fifo_in_payload_data};
assign {write_w_buffer_fifo_out_last, write_w_buffer_fifo_out_first, write_w_buffer_fifo_out_payload_id, write_w_buffer_fifo_out_payload_strb, write_w_buffer_fifo_out_payload_data} = write_w_buffer_syncfifo_dout;
assign write_w_buffer_sink_ready = write_w_buffer_syncfifo_writable;
assign write_w_buffer_syncfifo_we = write_w_buffer_sink_valid;
assign write_w_buffer_fifo_in_first = write_w_buffer_sink_first;
assign write_w_buffer_fifo_in_last = write_w_buffer_sink_last;
assign write_w_buffer_fifo_in_payload_data = write_w_buffer_sink_payload_data;
assign write_w_buffer_fifo_in_payload_strb = write_w_buffer_sink_payload_strb;
assign write_w_buffer_fifo_in_payload_id = write_w_buffer_sink_payload_id;
assign write_w_buffer_source_valid = write_w_buffer_readable;
assign write_w_buffer_source_first = write_w_buffer_fifo_out_first;
assign write_w_buffer_source_last = write_w_buffer_fifo_out_last;
assign write_w_buffer_source_payload_data = write_w_buffer_fifo_out_payload_data;
assign write_w_buffer_source_payload_strb = write_w_buffer_fifo_out_payload_strb;
assign write_w_buffer_source_payload_id = write_w_buffer_fifo_out_payload_id;
assign write_w_buffer_re = write_w_buffer_source_ready;
assign write_w_buffer_syncfifo_re = (write_w_buffer_syncfifo_readable & ((~write_w_buffer_readable) | write_w_buffer_re));
assign write_w_buffer_level1 = (write_w_buffer_level0 + write_w_buffer_readable);

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	write_w_buffer_wrport_adr <= 4'd0;
	if (write_w_buffer_replace) begin
		write_w_buffer_wrport_adr <= (write_w_buffer_produce - 1'd1);
	end else begin
		write_w_buffer_wrport_adr <= write_w_buffer_produce;
	end
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end
assign write_w_buffer_wrport_dat_w = write_w_buffer_syncfifo_din;
assign write_w_buffer_wrport_we = (write_w_buffer_syncfifo_we & (write_w_buffer_syncfifo_writable | write_w_buffer_replace));
assign write_w_buffer_do_read = (write_w_buffer_syncfifo_readable & write_w_buffer_syncfifo_re);
assign write_w_buffer_rdport_adr = write_w_buffer_consume;
assign write_w_buffer_syncfifo_dout = write_w_buffer_rdport_dat_r;
assign write_w_buffer_rdport_re = write_w_buffer_do_read;
assign write_w_buffer_syncfifo_writable = (write_w_buffer_level0 != 5'd16);
assign write_w_buffer_syncfifo_readable = (write_w_buffer_level0 != 1'd0);
assign write_id_buffer_syncfifo_din = {write_id_buffer_fifo_in_last, write_id_buffer_fifo_in_first, write_id_buffer_fifo_in_payload_id};
assign {write_id_buffer_fifo_out_last, write_id_buffer_fifo_out_first, write_id_buffer_fifo_out_payload_id} = write_id_buffer_syncfifo_dout;
assign write_id_buffer_sink_ready = write_id_buffer_syncfifo_writable;
assign write_id_buffer_syncfifo_we = write_id_buffer_sink_valid;
assign write_id_buffer_fifo_in_first = write_id_buffer_sink_first;
assign write_id_buffer_fifo_in_last = write_id_buffer_sink_last;
assign write_id_buffer_fifo_in_payload_id = write_id_buffer_sink_payload_id;
assign write_id_buffer_source_valid = write_id_buffer_syncfifo_readable;
assign write_id_buffer_source_first = write_id_buffer_fifo_out_first;
assign write_id_buffer_source_last = write_id_buffer_fifo_out_last;
assign write_id_buffer_source_payload_id = write_id_buffer_fifo_out_payload_id;
assign write_id_buffer_syncfifo_re = write_id_buffer_source_ready;

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	write_id_buffer_wrport_adr <= 4'd0;
	if (write_id_buffer_replace) begin
		write_id_buffer_wrport_adr <= (write_id_buffer_produce - 1'd1);
	end else begin
		write_id_buffer_wrport_adr <= write_id_buffer_produce;
	end
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end
assign write_id_buffer_wrport_dat_w = write_id_buffer_syncfifo_din;
assign write_id_buffer_wrport_we = (write_id_buffer_syncfifo_we & (write_id_buffer_syncfifo_writable | write_id_buffer_replace));
assign write_id_buffer_do_read = (write_id_buffer_syncfifo_readable & write_id_buffer_syncfifo_re);
assign write_id_buffer_rdport_adr = write_id_buffer_consume;
assign write_id_buffer_syncfifo_dout = write_id_buffer_rdport_dat_r;
assign write_id_buffer_syncfifo_writable = (write_id_buffer_level != 5'd16);
assign write_id_buffer_syncfifo_readable = (write_id_buffer_level != 1'd0);
assign write_resp_buffer_syncfifo_din = {write_resp_buffer_fifo_in_last, write_resp_buffer_fifo_in_first, write_resp_buffer_fifo_in_payload_resp, write_resp_buffer_fifo_in_payload_id};
assign {write_resp_buffer_fifo_out_last, write_resp_buffer_fifo_out_first, write_resp_buffer_fifo_out_payload_resp, write_resp_buffer_fifo_out_payload_id} = write_resp_buffer_syncfifo_dout;
assign write_resp_buffer_sink_ready = write_resp_buffer_syncfifo_writable;
assign write_resp_buffer_syncfifo_we = write_resp_buffer_sink_valid;
assign write_resp_buffer_fifo_in_first = write_resp_buffer_sink_first;
assign write_resp_buffer_fifo_in_last = write_resp_buffer_sink_last;
assign write_resp_buffer_fifo_in_payload_id = write_resp_buffer_sink_payload_id;
assign write_resp_buffer_fifo_in_payload_resp = write_resp_buffer_sink_payload_resp;
assign write_resp_buffer_source_valid = write_resp_buffer_syncfifo_readable;
assign write_resp_buffer_source_first = write_resp_buffer_fifo_out_first;
assign write_resp_buffer_source_last = write_resp_buffer_fifo_out_last;
assign write_resp_buffer_source_payload_id = write_resp_buffer_fifo_out_payload_id;
assign write_resp_buffer_source_payload_resp = write_resp_buffer_fifo_out_payload_resp;
assign write_resp_buffer_syncfifo_re = write_resp_buffer_source_ready;

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	write_resp_buffer_wrport_adr <= 4'd0;
	if (write_resp_buffer_replace) begin
		write_resp_buffer_wrport_adr <= (write_resp_buffer_produce - 1'd1);
	end else begin
		write_resp_buffer_wrport_adr <= write_resp_buffer_produce;
	end
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end
assign write_resp_buffer_wrport_dat_w = write_resp_buffer_syncfifo_din;
assign write_resp_buffer_wrport_we = (write_resp_buffer_syncfifo_we & (write_resp_buffer_syncfifo_writable | write_resp_buffer_replace));
assign write_resp_buffer_do_read = (write_resp_buffer_syncfifo_readable & write_resp_buffer_syncfifo_re);
assign write_resp_buffer_rdport_adr = write_resp_buffer_consume;
assign write_resp_buffer_syncfifo_dout = write_resp_buffer_rdport_dat_r;
assign write_resp_buffer_syncfifo_writable = (write_resp_buffer_level != 5'd16);
assign write_resp_buffer_syncfifo_readable = (write_resp_buffer_level != 1'd0);
assign read_ar_buffer_sink_valid = axi_ar_valid;
assign axi_ar_ready = read_ar_buffer_sink_ready;
assign read_ar_buffer_sink_first = axi_ar_first;
assign read_ar_buffer_sink_last = axi_ar_last;
assign read_ar_buffer_sink_payload_addr = axi_ar_payload_addr;
assign read_ar_buffer_sink_payload_burst = axi_ar_payload_burst;
assign read_ar_buffer_sink_payload_len = axi_ar_payload_len;
assign read_ar_buffer_sink_payload_size = axi_ar_payload_size;
assign read_ar_buffer_sink_payload_lock = axi_ar_payload_lock;
assign read_ar_buffer_sink_payload_prot = axi_ar_payload_prot;
assign read_ar_buffer_sink_payload_cache = axi_ar_payload_cache;
assign read_ar_buffer_sink_payload_qos = axi_ar_payload_qos;
assign read_ar_buffer_sink_payload_id = axi_ar_payload_id;
assign read_r_buffer_dequeue = (read_r_buffer_source_valid & read_r_buffer_source_ready);
assign read_id_buffer_sink_valid = (read_ar_valid & read_ar_ready);
assign read_id_buffer_sink_last = read_ar_last;
assign read_id_buffer_sink_payload_id = read_ar_payload_id;
assign axi_r_last = read_id_buffer_source_last;
assign axi_r_payload_id = read_id_buffer_source_payload_id;
assign read_id_buffer_source_ready = (axi_r_valid & axi_r_ready);
assign read_cmd_request = (read_ar_valid & read_can_read);
assign read_r_buffer_sink_first = rdata_first;
assign read_r_buffer_sink_last = rdata_last;
assign read_r_buffer_sink_payload_data = rdata_payload_data;
assign axi_r_valid = read_r_buffer_source_valid;
assign read_r_buffer_source_ready = axi_r_ready;
assign axi_r_first = read_r_buffer_source_first;
assign axi_r_payload_data = read_r_buffer_source_payload_data;

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	axi_r_payload_resp <= 2'd0;
	axi_r_payload_resp <= read_r_buffer_source_payload_resp;
	axi_r_payload_resp <= 1'd0;
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end
assign read_rmw_rgrant = ((~read_r_buffer_queue) & (read_r_buffer_level2 == 1'd0));

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	read_can_read <= 1'd0;
	read_r_buffer_queue <= 1'd0;
	read_r_buffer_queue <= ((cmd_valid & cmd_ready) & (~cmd_payload_we));
	read_can_read <= (read_r_buffer_level2 != 5'd16);
	if (read_rmw_request) begin
		read_r_buffer_queue <= 1'd0;
		read_can_read <= 1'd0;
	end
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	axi_w_ready <= 1'd0;
	cmd_valid <= 1'd0;
	cmd_last <= 1'd0;
	cmd_payload_we <= 1'd0;
	cmd_payload_addr <= 27'd0;
	rdata_ready <= 1'd0;
	write_aw_ready <= 1'd0;
	write_w_buffer_sink_valid <= 1'd0;
	write_w_buffer_sink_first <= 1'd0;
	write_w_buffer_sink_last <= 1'd0;
	write_w_buffer_sink_payload_data <= 256'd0;
	write_w_buffer_sink_payload_strb <= 32'd0;
	write_w_buffer_sink_payload_id <= 4'd0;
	write_rmw_request <= 1'd0;
	write_rmw_mask <= 256'd0;
	read_ar_ready <= 1'd0;
	read_r_buffer_sink_valid <= 1'd0;
	next_state <= 2'd0;
	write_rmw_cmd_done_next_value0 <= 1'd0;
	write_rmw_cmd_done_next_value_ce0 <= 1'd0;
	write_rmw_data_done_next_value1 <= 1'd0;
	write_rmw_data_done_next_value_ce1 <= 1'd0;
	write_rmw_data_next_value2 <= 256'd0;
	write_rmw_data_next_value_ce2 <= 1'd0;
	if ((write_cmd_request & write_cmd_grant)) begin
		cmd_valid <= 1'd1;
		cmd_last <= write_aw_last;
		cmd_payload_we <= 1'd1;
		cmd_payload_addr <= ((write_aw_payload_addr - 1'd0) >>> 3'd5);
		if (cmd_ready) begin
			write_aw_ready <= 1'd1;
		end
	end
	if (write_axi_w_connect) begin
		write_w_buffer_sink_valid <= axi_w_valid;
		axi_w_ready <= write_w_buffer_sink_ready;
		write_w_buffer_sink_first <= axi_w_first;
		write_w_buffer_sink_last <= axi_w_last;
		write_w_buffer_sink_payload_data <= axi_w_payload_data;
		write_w_buffer_sink_payload_strb <= axi_w_payload_strb;
		write_w_buffer_sink_payload_id <= axi_w_payload_id;
	end
	next_state <= state;
	case (state)
		1'd1: begin
			write_rmw_request <= 1'd1;
			cmd_valid <= 1'd1;
			cmd_last <= write_aw_last;
			cmd_payload_we <= 1'd0;
			cmd_payload_addr <= ((write_aw_payload_addr - 1'd0) >>> 3'd5);
			if (cmd_ready) begin
				next_state <= 2'd2;
			end
		end
		2'd2: begin
			write_rmw_request <= 1'd1;
			write_rmw_mask[7:0] <= {8{axi_w_payload_strb[0]}};
			write_rmw_mask[15:8] <= {8{axi_w_payload_strb[1]}};
			write_rmw_mask[23:16] <= {8{axi_w_payload_strb[2]}};
			write_rmw_mask[31:24] <= {8{axi_w_payload_strb[3]}};
			write_rmw_mask[39:32] <= {8{axi_w_payload_strb[4]}};
			write_rmw_mask[47:40] <= {8{axi_w_payload_strb[5]}};
			write_rmw_mask[55:48] <= {8{axi_w_payload_strb[6]}};
			write_rmw_mask[63:56] <= {8{axi_w_payload_strb[7]}};
			write_rmw_mask[71:64] <= {8{axi_w_payload_strb[8]}};
			write_rmw_mask[79:72] <= {8{axi_w_payload_strb[9]}};
			write_rmw_mask[87:80] <= {8{axi_w_payload_strb[10]}};
			write_rmw_mask[95:88] <= {8{axi_w_payload_strb[11]}};
			write_rmw_mask[103:96] <= {8{axi_w_payload_strb[12]}};
			write_rmw_mask[111:104] <= {8{axi_w_payload_strb[13]}};
			write_rmw_mask[119:112] <= {8{axi_w_payload_strb[14]}};
			write_rmw_mask[127:120] <= {8{axi_w_payload_strb[15]}};
			write_rmw_mask[135:128] <= {8{axi_w_payload_strb[16]}};
			write_rmw_mask[143:136] <= {8{axi_w_payload_strb[17]}};
			write_rmw_mask[151:144] <= {8{axi_w_payload_strb[18]}};
			write_rmw_mask[159:152] <= {8{axi_w_payload_strb[19]}};
			write_rmw_mask[167:160] <= {8{axi_w_payload_strb[20]}};
			write_rmw_mask[175:168] <= {8{axi_w_payload_strb[21]}};
			write_rmw_mask[183:176] <= {8{axi_w_payload_strb[22]}};
			write_rmw_mask[191:184] <= {8{axi_w_payload_strb[23]}};
			write_rmw_mask[199:192] <= {8{axi_w_payload_strb[24]}};
			write_rmw_mask[207:200] <= {8{axi_w_payload_strb[25]}};
			write_rmw_mask[215:208] <= {8{axi_w_payload_strb[26]}};
			write_rmw_mask[223:216] <= {8{axi_w_payload_strb[27]}};
			write_rmw_mask[231:224] <= {8{axi_w_payload_strb[28]}};
			write_rmw_mask[239:232] <= {8{axi_w_payload_strb[29]}};
			write_rmw_mask[247:240] <= {8{axi_w_payload_strb[30]}};
			write_rmw_mask[255:248] <= {8{axi_w_payload_strb[31]}};
			rdata_ready <= 1'd1;
			if (rdata_valid) begin
				write_rmw_data_next_value2 <= ((rdata_payload_data & (~write_rmw_mask)) | (axi_w_payload_data & write_rmw_mask));
				write_rmw_data_next_value_ce2 <= 1'd1;
				next_state <= 2'd3;
			end
		end
		2'd3: begin
			write_rmw_request <= 1'd1;
			cmd_valid <= (~write_rmw_cmd_done);
			cmd_last <= write_aw_last;
			cmd_payload_we <= 1'd1;
			cmd_payload_addr <= ((write_aw_payload_addr - 1'd0) >>> 3'd5);
			if ((cmd_valid & cmd_ready)) begin
				write_aw_ready <= 1'd1;
				write_rmw_cmd_done_next_value0 <= 1'd1;
				write_rmw_cmd_done_next_value_ce0 <= 1'd1;
			end
			write_w_buffer_sink_valid <= (~write_rmw_data_done);
			write_w_buffer_sink_last <= axi_w_last;
			write_w_buffer_sink_payload_data <= write_rmw_data;
			write_w_buffer_sink_payload_strb <= 32'd4294967295;
			if ((write_w_buffer_sink_valid & write_w_buffer_sink_ready)) begin
				axi_w_ready <= 1'd1;
				write_rmw_data_done_next_value1 <= 1'd1;
				write_rmw_data_done_next_value_ce1 <= 1'd1;
			end
			if (((cmd_ready | write_rmw_cmd_done) & (write_w_buffer_sink_ready | write_rmw_data_done))) begin
				next_state <= 1'd0;
			end
		end
		default: begin
			write_rmw_cmd_done_next_value0 <= 1'd0;
			write_rmw_cmd_done_next_value_ce0 <= 1'd1;
			write_rmw_data_done_next_value1 <= 1'd0;
			write_rmw_data_done_next_value_ce1 <= 1'd1;
			if ((axi_w_valid & (axi_w_payload_strb != 32'd4294967295))) begin
				write_rmw_request <= 1'd1;
				if ((write_rmw_rgrant & write_rmw_wgrant)) begin
					next_state <= 1'd1;
				end
			end
		end
	endcase
	if ((read_cmd_request & read_cmd_grant)) begin
		cmd_valid <= 1'd1;
		cmd_last <= read_ar_last;
		cmd_payload_we <= 1'd0;
		cmd_payload_addr <= ((read_ar_payload_addr - 1'd0) >>> 3'd5);
		if (cmd_ready) begin
			read_ar_ready <= 1'd1;
		end
	end
	read_r_buffer_sink_valid <= rdata_valid;
	rdata_ready <= read_r_buffer_sink_ready;
	if ((read_rmw_request & read_rmw_rgrant)) begin
		rdata_ready <= 1'd1;
		read_r_buffer_sink_valid <= 1'd0;
	end
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end
assign read_ar_buffer_sink_ready = ((~read_ar_buffer_source_valid) | read_ar_buffer_source_ready);
assign read_beat_size = (1'd1 <<< read_ar_buffer_source_payload_size);
assign read_beat_wrap = (read_ar_buffer_source_payload_len <<< read_ar_buffer_source_payload_size);
assign read_ar_valid = (read_ar_buffer_source_valid | (~read_ar_first));
assign read_ar_first = (read_beat_count == 1'd0);
assign read_ar_last = (read_beat_count == read_ar_buffer_source_payload_len);
assign read_ar_payload_addr = ($signed({1'd0, read_ar_buffer_source_payload_addr}) + read_beat_offset);
assign read_ar_payload_id = read_ar_buffer_source_payload_id;

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	read_ar_buffer_source_ready <= 1'd0;
	if (read_ar_ready) begin
		if (read_ar_last) begin
			read_ar_buffer_source_ready <= 1'd1;
		end
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end
assign read_r_buffer_syncfifo_din = {read_r_buffer_fifo_in_last, read_r_buffer_fifo_in_first, read_r_buffer_fifo_in_payload_id, read_r_buffer_fifo_in_payload_data, read_r_buffer_fifo_in_payload_resp};
assign {read_r_buffer_fifo_out_last, read_r_buffer_fifo_out_first, read_r_buffer_fifo_out_payload_id, read_r_buffer_fifo_out_payload_data, read_r_buffer_fifo_out_payload_resp} = read_r_buffer_syncfifo_dout;
assign read_r_buffer_sink_ready = read_r_buffer_syncfifo_writable;
assign read_r_buffer_syncfifo_we = read_r_buffer_sink_valid;
assign read_r_buffer_fifo_in_first = read_r_buffer_sink_first;
assign read_r_buffer_fifo_in_last = read_r_buffer_sink_last;
assign read_r_buffer_fifo_in_payload_resp = read_r_buffer_sink_payload_resp;
assign read_r_buffer_fifo_in_payload_data = read_r_buffer_sink_payload_data;
assign read_r_buffer_fifo_in_payload_id = read_r_buffer_sink_payload_id;
assign read_r_buffer_source_valid = read_r_buffer_readable;
assign read_r_buffer_source_first = read_r_buffer_fifo_out_first;
assign read_r_buffer_source_last = read_r_buffer_fifo_out_last;
assign read_r_buffer_source_payload_resp = read_r_buffer_fifo_out_payload_resp;
assign read_r_buffer_source_payload_data = read_r_buffer_fifo_out_payload_data;
assign read_r_buffer_source_payload_id = read_r_buffer_fifo_out_payload_id;
assign read_r_buffer_re = read_r_buffer_source_ready;
assign read_r_buffer_syncfifo_re = (read_r_buffer_syncfifo_readable & ((~read_r_buffer_readable) | read_r_buffer_re));
assign read_r_buffer_level1 = (read_r_buffer_level0 + read_r_buffer_readable);

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	read_r_buffer_wrport_adr <= 4'd0;
	if (read_r_buffer_replace) begin
		read_r_buffer_wrport_adr <= (read_r_buffer_produce - 1'd1);
	end else begin
		read_r_buffer_wrport_adr <= read_r_buffer_produce;
	end
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end
assign read_r_buffer_wrport_dat_w = read_r_buffer_syncfifo_din;
assign read_r_buffer_wrport_we = (read_r_buffer_syncfifo_we & (read_r_buffer_syncfifo_writable | read_r_buffer_replace));
assign read_r_buffer_do_read = (read_r_buffer_syncfifo_readable & read_r_buffer_syncfifo_re);
assign read_r_buffer_rdport_adr = read_r_buffer_consume;
assign read_r_buffer_syncfifo_dout = read_r_buffer_rdport_dat_r;
assign read_r_buffer_rdport_re = read_r_buffer_do_read;
assign read_r_buffer_syncfifo_writable = (read_r_buffer_level0 != 5'd16);
assign read_r_buffer_syncfifo_readable = (read_r_buffer_level0 != 1'd0);
assign read_id_buffer_syncfifo_din = {read_id_buffer_fifo_in_last, read_id_buffer_fifo_in_first, read_id_buffer_fifo_in_payload_id};
assign {read_id_buffer_fifo_out_last, read_id_buffer_fifo_out_first, read_id_buffer_fifo_out_payload_id} = read_id_buffer_syncfifo_dout;
assign read_id_buffer_sink_ready = read_id_buffer_syncfifo_writable;
assign read_id_buffer_syncfifo_we = read_id_buffer_sink_valid;
assign read_id_buffer_fifo_in_first = read_id_buffer_sink_first;
assign read_id_buffer_fifo_in_last = read_id_buffer_sink_last;
assign read_id_buffer_fifo_in_payload_id = read_id_buffer_sink_payload_id;
assign read_id_buffer_source_valid = read_id_buffer_syncfifo_readable;
assign read_id_buffer_source_first = read_id_buffer_fifo_out_first;
assign read_id_buffer_source_last = read_id_buffer_fifo_out_last;
assign read_id_buffer_source_payload_id = read_id_buffer_fifo_out_payload_id;
assign read_id_buffer_syncfifo_re = read_id_buffer_source_ready;

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	read_id_buffer_wrport_adr <= 4'd0;
	if (read_id_buffer_replace) begin
		read_id_buffer_wrport_adr <= (read_id_buffer_produce - 1'd1);
	end else begin
		read_id_buffer_wrport_adr <= read_id_buffer_produce;
	end
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end
assign read_id_buffer_wrport_dat_w = read_id_buffer_syncfifo_din;
assign read_id_buffer_wrport_we = (read_id_buffer_syncfifo_we & (read_id_buffer_syncfifo_writable | read_id_buffer_replace));
assign read_id_buffer_do_read = (read_id_buffer_syncfifo_readable & read_id_buffer_syncfifo_re);
assign read_id_buffer_rdport_adr = read_id_buffer_consume;
assign read_id_buffer_syncfifo_dout = read_id_buffer_rdport_dat_r;
assign read_id_buffer_syncfifo_writable = (read_id_buffer_level != 5'd16);
assign read_id_buffer_syncfifo_readable = (read_id_buffer_level != 1'd0);

always @(posedge sys_clk) begin
	if (write_w_buffer_queue) begin
		if ((~write_w_buffer_dequeue)) begin
			write_w_buffer_level2 <= (write_w_buffer_level2 + 1'd1);
		end
	end else begin
		if (write_w_buffer_dequeue) begin
			write_w_buffer_level2 <= (write_w_buffer_level2 - 1'd1);
		end
	end
	if (((~write_aw_buffer_source_valid) | write_aw_buffer_source_ready)) begin
		write_aw_buffer_source_valid <= write_aw_buffer_sink_valid;
		write_aw_buffer_source_first <= write_aw_buffer_sink_first;
		write_aw_buffer_source_last <= write_aw_buffer_sink_last;
		write_aw_buffer_source_payload_addr <= write_aw_buffer_sink_payload_addr;
		write_aw_buffer_source_payload_burst <= write_aw_buffer_sink_payload_burst;
		write_aw_buffer_source_payload_len <= write_aw_buffer_sink_payload_len;
		write_aw_buffer_source_payload_size <= write_aw_buffer_sink_payload_size;
		write_aw_buffer_source_payload_lock <= write_aw_buffer_sink_payload_lock;
		write_aw_buffer_source_payload_prot <= write_aw_buffer_sink_payload_prot;
		write_aw_buffer_source_payload_cache <= write_aw_buffer_sink_payload_cache;
		write_aw_buffer_source_payload_qos <= write_aw_buffer_sink_payload_qos;
		write_aw_buffer_source_payload_id <= write_aw_buffer_sink_payload_id;
	end
	if ((write_aw_valid & write_aw_ready)) begin
		if (write_aw_last) begin
			write_beat_count <= 1'd0;
			write_beat_offset <= 1'd0;
		end else begin
			write_beat_count <= (write_beat_count + 1'd1);
			if ((((write_aw_buffer_source_payload_burst == 1'd1) & 1'd1) | ((write_aw_buffer_source_payload_burst == 2'd2) & 1'd1))) begin
				write_beat_offset <= (write_beat_offset + $signed({1'd0, write_beat_size}));
			end
		end
		if (((write_aw_buffer_source_payload_burst == 2'd2) & 1'd1)) begin
			if (((write_aw_payload_addr & write_beat_wrap) == write_beat_wrap)) begin
				write_beat_offset <= (write_beat_offset - $signed({1'd0, write_beat_wrap}));
			end
		end
	end
	if (write_w_buffer_syncfifo_re) begin
		write_w_buffer_readable <= 1'd1;
	end else begin
		if (write_w_buffer_re) begin
			write_w_buffer_readable <= 1'd0;
		end
	end
	if (((write_w_buffer_syncfifo_we & write_w_buffer_syncfifo_writable) & (~write_w_buffer_replace))) begin
		write_w_buffer_produce <= (write_w_buffer_produce + 1'd1);
	end
	if (write_w_buffer_do_read) begin
		write_w_buffer_consume <= (write_w_buffer_consume + 1'd1);
	end
	if (((write_w_buffer_syncfifo_we & write_w_buffer_syncfifo_writable) & (~write_w_buffer_replace))) begin
		if ((~write_w_buffer_do_read)) begin
			write_w_buffer_level0 <= (write_w_buffer_level0 + 1'd1);
		end
	end else begin
		if (write_w_buffer_do_read) begin
			write_w_buffer_level0 <= (write_w_buffer_level0 - 1'd1);
		end
	end
	if (((write_id_buffer_syncfifo_we & write_id_buffer_syncfifo_writable) & (~write_id_buffer_replace))) begin
		write_id_buffer_produce <= (write_id_buffer_produce + 1'd1);
	end
	if (write_id_buffer_do_read) begin
		write_id_buffer_consume <= (write_id_buffer_consume + 1'd1);
	end
	if (((write_id_buffer_syncfifo_we & write_id_buffer_syncfifo_writable) & (~write_id_buffer_replace))) begin
		if ((~write_id_buffer_do_read)) begin
			write_id_buffer_level <= (write_id_buffer_level + 1'd1);
		end
	end else begin
		if (write_id_buffer_do_read) begin
			write_id_buffer_level <= (write_id_buffer_level - 1'd1);
		end
	end
	if (((write_resp_buffer_syncfifo_we & write_resp_buffer_syncfifo_writable) & (~write_resp_buffer_replace))) begin
		write_resp_buffer_produce <= (write_resp_buffer_produce + 1'd1);
	end
	if (write_resp_buffer_do_read) begin
		write_resp_buffer_consume <= (write_resp_buffer_consume + 1'd1);
	end
	if (((write_resp_buffer_syncfifo_we & write_resp_buffer_syncfifo_writable) & (~write_resp_buffer_replace))) begin
		if ((~write_resp_buffer_do_read)) begin
			write_resp_buffer_level <= (write_resp_buffer_level + 1'd1);
		end
	end else begin
		if (write_resp_buffer_do_read) begin
			write_resp_buffer_level <= (write_resp_buffer_level - 1'd1);
		end
	end
	state <= next_state;
	if (write_rmw_cmd_done_next_value_ce0) begin
		write_rmw_cmd_done <= write_rmw_cmd_done_next_value0;
	end
	if (write_rmw_data_done_next_value_ce1) begin
		write_rmw_data_done <= write_rmw_data_done_next_value1;
	end
	if (write_rmw_data_next_value_ce2) begin
		write_rmw_data <= write_rmw_data_next_value2;
	end
	if (read_r_buffer_queue) begin
		if ((~read_r_buffer_dequeue)) begin
			read_r_buffer_level2 <= (read_r_buffer_level2 + 1'd1);
		end
	end else begin
		if (read_r_buffer_dequeue) begin
			read_r_buffer_level2 <= (read_r_buffer_level2 - 1'd1);
		end
	end
	if (((~read_ar_buffer_source_valid) | read_ar_buffer_source_ready)) begin
		read_ar_buffer_source_valid <= read_ar_buffer_sink_valid;
		read_ar_buffer_source_first <= read_ar_buffer_sink_first;
		read_ar_buffer_source_last <= read_ar_buffer_sink_last;
		read_ar_buffer_source_payload_addr <= read_ar_buffer_sink_payload_addr;
		read_ar_buffer_source_payload_burst <= read_ar_buffer_sink_payload_burst;
		read_ar_buffer_source_payload_len <= read_ar_buffer_sink_payload_len;
		read_ar_buffer_source_payload_size <= read_ar_buffer_sink_payload_size;
		read_ar_buffer_source_payload_lock <= read_ar_buffer_sink_payload_lock;
		read_ar_buffer_source_payload_prot <= read_ar_buffer_sink_payload_prot;
		read_ar_buffer_source_payload_cache <= read_ar_buffer_sink_payload_cache;
		read_ar_buffer_source_payload_qos <= read_ar_buffer_sink_payload_qos;
		read_ar_buffer_source_payload_id <= read_ar_buffer_sink_payload_id;
	end
	if ((read_ar_valid & read_ar_ready)) begin
		if (read_ar_last) begin
			read_beat_count <= 1'd0;
			read_beat_offset <= 1'd0;
		end else begin
			read_beat_count <= (read_beat_count + 1'd1);
			if ((((read_ar_buffer_source_payload_burst == 1'd1) & 1'd1) | ((read_ar_buffer_source_payload_burst == 2'd2) & 1'd1))) begin
				read_beat_offset <= (read_beat_offset + $signed({1'd0, read_beat_size}));
			end
		end
		if (((read_ar_buffer_source_payload_burst == 2'd2) & 1'd1)) begin
			if (((read_ar_payload_addr & read_beat_wrap) == read_beat_wrap)) begin
				read_beat_offset <= (read_beat_offset - $signed({1'd0, read_beat_wrap}));
			end
		end
	end
	if (read_r_buffer_syncfifo_re) begin
		read_r_buffer_readable <= 1'd1;
	end else begin
		if (read_r_buffer_re) begin
			read_r_buffer_readable <= 1'd0;
		end
	end
	if (((read_r_buffer_syncfifo_we & read_r_buffer_syncfifo_writable) & (~read_r_buffer_replace))) begin
		read_r_buffer_produce <= (read_r_buffer_produce + 1'd1);
	end
	if (read_r_buffer_do_read) begin
		read_r_buffer_consume <= (read_r_buffer_consume + 1'd1);
	end
	if (((read_r_buffer_syncfifo_we & read_r_buffer_syncfifo_writable) & (~read_r_buffer_replace))) begin
		if ((~read_r_buffer_do_read)) begin
			read_r_buffer_level0 <= (read_r_buffer_level0 + 1'd1);
		end
	end else begin
		if (read_r_buffer_do_read) begin
			read_r_buffer_level0 <= (read_r_buffer_level0 - 1'd1);
		end
	end
	if (((read_id_buffer_syncfifo_we & read_id_buffer_syncfifo_writable) & (~read_id_buffer_replace))) begin
		read_id_buffer_produce <= (read_id_buffer_produce + 1'd1);
	end
	if (read_id_buffer_do_read) begin
		read_id_buffer_consume <= (read_id_buffer_consume + 1'd1);
	end
	if (((read_id_buffer_syncfifo_we & read_id_buffer_syncfifo_writable) & (~read_id_buffer_replace))) begin
		if ((~read_id_buffer_do_read)) begin
			read_id_buffer_level <= (read_id_buffer_level + 1'd1);
		end
	end else begin
		if (read_id_buffer_do_read) begin
			read_id_buffer_level <= (read_id_buffer_level - 1'd1);
		end
	end
	if (ce) begin
		case (grant)
			1'd0: begin
				if (request[1]) begin
					grant <= 1'd1;
				end
			end
			1'd1: begin
				if (request[0]) begin
					grant <= 1'd0;
				end
			end
		endcase
	end
	if (sys_rst) begin
		write_aw_buffer_source_valid <= 1'd0;
		write_aw_buffer_source_payload_addr <= 32'd0;
		write_aw_buffer_source_payload_burst <= 2'd0;
		write_aw_buffer_source_payload_len <= 8'd0;
		write_aw_buffer_source_payload_size <= 4'd0;
		write_aw_buffer_source_payload_lock <= 2'd0;
		write_aw_buffer_source_payload_prot <= 3'd0;
		write_aw_buffer_source_payload_cache <= 4'd0;
		write_aw_buffer_source_payload_qos <= 4'd0;
		write_aw_buffer_source_payload_id <= 4'd0;
		write_beat_count <= 8'd0;
		write_beat_offset <= 13'sd0;
		write_w_buffer_readable <= 1'd0;
		write_w_buffer_level0 <= 5'd0;
		write_w_buffer_produce <= 4'd0;
		write_w_buffer_consume <= 4'd0;
		write_id_buffer_level <= 5'd0;
		write_id_buffer_produce <= 4'd0;
		write_id_buffer_consume <= 4'd0;
		write_resp_buffer_level <= 5'd0;
		write_resp_buffer_produce <= 4'd0;
		write_resp_buffer_consume <= 4'd0;
		write_w_buffer_level2 <= 5'd0;
		write_rmw_data <= 256'd0;
		write_rmw_cmd_done <= 1'd0;
		write_rmw_data_done <= 1'd0;
		read_ar_buffer_source_valid <= 1'd0;
		read_ar_buffer_source_payload_addr <= 32'd0;
		read_ar_buffer_source_payload_burst <= 2'd0;
		read_ar_buffer_source_payload_len <= 8'd0;
		read_ar_buffer_source_payload_size <= 4'd0;
		read_ar_buffer_source_payload_lock <= 2'd0;
		read_ar_buffer_source_payload_prot <= 3'd0;
		read_ar_buffer_source_payload_cache <= 4'd0;
		read_ar_buffer_source_payload_qos <= 4'd0;
		read_ar_buffer_source_payload_id <= 4'd0;
		read_beat_count <= 8'd0;
		read_beat_offset <= 13'sd0;
		read_r_buffer_readable <= 1'd0;
		read_r_buffer_level0 <= 5'd0;
		read_r_buffer_produce <= 4'd0;
		read_r_buffer_consume <= 4'd0;
		read_r_buffer_level2 <= 5'd0;
		read_id_buffer_level <= 5'd0;
		read_id_buffer_produce <= 4'd0;
		read_id_buffer_consume <= 4'd0;
		grant <= 1'd0;
		state <= 2'd0;
	end
end

reg [293:0] storage[0:15];
reg [293:0] memdat;
reg [293:0] memdat_1;
always @(posedge sys_clk) begin
	if (write_w_buffer_wrport_we)
		storage[write_w_buffer_wrport_adr] <= write_w_buffer_wrport_dat_w;
	memdat <= storage[write_w_buffer_wrport_adr];
end

always @(posedge sys_clk) begin
	if (write_w_buffer_rdport_re)
		memdat_1 <= storage[write_w_buffer_rdport_adr];
end

assign write_w_buffer_wrport_dat_r = memdat;
assign write_w_buffer_rdport_dat_r = memdat_1;

reg [5:0] storage_1[0:15];
reg [5:0] memdat_2;
always @(posedge sys_clk) begin
	if (write_id_buffer_wrport_we)
		storage_1[write_id_buffer_wrport_adr] <= write_id_buffer_wrport_dat_w;
	memdat_2 <= storage_1[write_id_buffer_wrport_adr];
end

always @(posedge sys_clk) begin
end

assign write_id_buffer_wrport_dat_r = memdat_2;
assign write_id_buffer_rdport_dat_r = storage_1[write_id_buffer_rdport_adr];

reg [7:0] storage_2[0:15];
reg [7:0] memdat_3;
always @(posedge sys_clk) begin
	if (write_resp_buffer_wrport_we)
		storage_2[write_resp_buffer_wrport_adr] <= write_resp_buffer_wrport_dat_w;
	memdat_3 <= storage_2[write_resp_buffer_wrport_adr];
end

always @(posedge sys_clk) begin
end

assign write_resp_buffer_wrport_dat_r = memdat_3;
assign write_resp_buffer_rdport_dat_r = storage_2[write_resp_buffer_rdport_adr];

reg [263:0] storage_3[0:15];
reg [263:0] memdat_4;
reg [263:0] memdat_5;
always @(posedge sys_clk) begin
	if (read_r_buffer_wrport_we)
		storage_3[read_r_buffer_wrport_adr] <= read_r_buffer_wrport_dat_w;
	memdat_4 <= storage_3[read_r_buffer_wrport_adr];
end

always @(posedge sys_clk) begin
	if (read_r_buffer_rdport_re)
		memdat_5 <= storage_3[read_r_buffer_rdport_adr];
end

assign read_r_buffer_wrport_dat_r = memdat_4;
assign read_r_buffer_rdport_dat_r = memdat_5;

reg [5:0] storage_4[0:15];
reg [5:0] memdat_6;
always @(posedge sys_clk) begin
	if (read_id_buffer_wrport_we)
		storage_4[read_id_buffer_wrport_adr] <= read_id_buffer_wrport_dat_w;
	memdat_6 <= storage_4[read_id_buffer_wrport_adr];
end

always @(posedge sys_clk) begin
end

assign read_id_buffer_wrport_dat_r = memdat_6;
assign read_id_buffer_rdport_dat_r = storage_4[read_id_buffer_rdport_adr];

endmodule
