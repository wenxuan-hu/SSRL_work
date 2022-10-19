/* Machine-generated using Migen */
module LPDDR4_MM(
	input sys8x_90_clk,
	input sys8x_90_rst,
	input sys8x_90_ddr_clk,
	input sys8x_90_ddr_rst,
	input sys8x_ddr_clk,
	input sys8x_ddr_rst,
	input lpddr4simulationpads_cke,
	input lpddr4simulationpads_reset_n,
	input lpddr4simulationpads_cs,
	input [5:0] lpddr4simulationpads_ca,
	input [15:0] lpddr4simulationpads0,
	output reg [15:0] lpddr4simulationpads_dq_i,
	input [1:0] lpddr4simulationpads1,
	output reg [1:0] lpddr4simulationpads_dqs_i,
	input [1:0] lpddr4simulationpads2
);
reg sink_sink_valid;
wire sink_sink_ready;
reg sink_sink_first = 1'd0;
reg sink_sink_last = 1'd0;
reg sink_sink_payload_we;
reg sink_sink_payload_masked;
reg [2:0] sink_sink_payload_bank;
reg [16:0] sink_sink_payload_row;
reg [9:0] sink_sink_payload_col;
wire source_source_valid;
wire source_source_ready;
wire source_source_first;
wire source_source_last;
wire source_source_payload_we;
wire source_source_payload_masked;
wire [2:0] source_source_payload_bank;
wire [16:0] source_source_payload_row;
wire [9:0] source_source_payload_col;
wire cdc_sink_valid;
wire cdc_sink_ready;
wire cdc_sink_first;
wire cdc_sink_last;
wire cdc_sink_payload_we;
wire cdc_sink_payload_masked;
wire [2:0] cdc_sink_payload_bank;
wire [16:0] cdc_sink_payload_row;
wire [9:0] cdc_sink_payload_col;
wire cdc_source_valid;
wire cdc_source_ready;
wire cdc_source_first;
wire cdc_source_last;
wire cdc_source_payload_we;
wire cdc_source_payload_masked;
wire [2:0] cdc_source_payload_bank;
wire [16:0] cdc_source_payload_row;
wire [9:0] cdc_source_payload_col;
wire cdc_asyncfifo_we;
wire cdc_asyncfifo_writable;
wire cdc_asyncfifo_re;
wire cdc_asyncfifo_readable;
wire [33:0] cdc_asyncfifo_din;
wire [33:0] cdc_asyncfifo_dout;
wire cdc_graycounter0_ce;
(* no_retiming = "true" *) reg [2:0] cdc_graycounter0_q = 3'd0;
wire [2:0] cdc_graycounter0_q_next;
reg [2:0] cdc_graycounter0_q_binary = 3'd0;
reg [2:0] cdc_graycounter0_q_next_binary;
wire cdc_graycounter1_ce;
(* no_retiming = "true" *) reg [2:0] cdc_graycounter1_q = 3'd0;
wire [2:0] cdc_graycounter1_q_next;
reg [2:0] cdc_graycounter1_q_binary = 3'd0;
reg [2:0] cdc_graycounter1_q_next_binary;
wire [2:0] cdc_produce_rdomain;
wire [2:0] cdc_consume_wdomain;
wire [1:0] cdc_wrport_adr;
wire [33:0] cdc_wrport_dat_r;
wire cdc_wrport_we;
wire [33:0] cdc_wrport_dat_w;
wire [1:0] cdc_rdport_adr;
wire [33:0] cdc_rdport_dat_r;
wire cdc_fifo_in_payload_we;
wire cdc_fifo_in_payload_masked;
wire [2:0] cdc_fifo_in_payload_bank;
wire [16:0] cdc_fifo_in_payload_row;
wire [9:0] cdc_fifo_in_payload_col;
wire cdc_fifo_in_first;
wire cdc_fifo_in_last;
wire cdc_fifo_out_payload_we;
wire cdc_fifo_out_payload_masked;
wire [2:0] cdc_fifo_out_payload_bank;
wire [16:0] cdc_fifo_out_payload_row;
wire [9:0] cdc_fifo_out_payload_col;
wire cdc_fifo_out_first;
wire cdc_fifo_out_last;
wire [2:0] commandssim_level;
wire [63:0] commandssim_time_ps;
reg [63:0] commandssim_cnt = 64'd0;
reg [2:0] commandssim_simlogger_storage = 3'd1;
reg [7:0] commandssim0 = 8'd0;
reg [7:0] commandssim1 = 8'd0;
reg [7:0] commandssim2 = 8'd0;
reg [7:0] commandssim3 = 8'd0;
reg [7:0] commandssim4 = 8'd0;
reg [7:0] commandssim5 = 8'd0;
reg [7:0] commandssim6 = 8'd0;
reg [7:0] commandssim7 = 8'd0;
reg [7:0] commandssim8 = 8'd0;
reg [7:0] commandssim9 = 8'd0;
reg [7:0] commandssim10 = 8'd0;
reg [7:0] commandssim11 = 8'd0;
reg [7:0] commandssim12 = 8'd0;
reg [7:0] commandssim13 = 8'd0;
reg [7:0] commandssim14 = 8'd0;
reg [7:0] commandssim15 = 8'd0;
reg [7:0] commandssim16 = 8'd0;
reg [7:0] commandssim17 = 8'd0;
reg [7:0] commandssim18 = 8'd0;
reg [7:0] commandssim19 = 8'd0;
reg [7:0] commandssim20 = 8'd0;
reg [7:0] commandssim21 = 8'd0;
reg [7:0] commandssim22 = 8'd0;
reg [7:0] commandssim23 = 8'd0;
reg [7:0] commandssim24 = 8'd0;
reg [7:0] commandssim25 = 8'd0;
reg [7:0] commandssim26 = 8'd0;
reg [7:0] commandssim27 = 8'd0;
reg [7:0] commandssim28 = 8'd0;
reg [7:0] commandssim29 = 8'd0;
reg [7:0] commandssim30 = 8'd0;
reg [7:0] commandssim31 = 8'd0;
reg [7:0] commandssim32 = 8'd0;
reg [7:0] commandssim33 = 8'd0;
reg [7:0] commandssim34 = 8'd0;
reg [7:0] commandssim35 = 8'd0;
reg [7:0] commandssim36 = 8'd0;
reg [7:0] commandssim37 = 8'd0;
reg [7:0] commandssim38 = 8'd0;
reg [7:0] commandssim39 = 8'd0;
reg [7:0] commandssim40 = 8'd0;
reg [7:0] commandssim41 = 8'd0;
reg [7:0] commandssim42 = 8'd0;
reg [7:0] commandssim43 = 8'd0;
reg [7:0] commandssim44 = 8'd0;
reg [7:0] commandssim45 = 8'd0;
reg [7:0] commandssim46 = 8'd0;
reg [7:0] commandssim47 = 8'd0;
reg [7:0] commandssim48 = 8'd0;
reg [7:0] commandssim49 = 8'd0;
reg [7:0] commandssim50 = 8'd0;
reg [7:0] commandssim51 = 8'd0;
reg [7:0] commandssim52 = 8'd0;
reg [7:0] commandssim53 = 8'd0;
reg [7:0] commandssim54 = 8'd0;
reg [7:0] commandssim55 = 8'd0;
reg [7:0] commandssim56 = 8'd0;
reg [7:0] commandssim57 = 8'd0;
reg [7:0] commandssim58 = 8'd0;
reg [7:0] commandssim59 = 8'd0;
reg [7:0] commandssim60 = 8'd0;
reg [7:0] commandssim61 = 8'd0;
reg [7:0] commandssim62 = 8'd0;
reg [7:0] commandssim63 = 8'd0;
reg commandssim64 = 1'd0;
reg commandssim65 = 1'd0;
reg commandssim66 = 1'd0;
reg commandssim67 = 1'd0;
reg commandssim68 = 1'd0;
reg commandssim69 = 1'd0;
reg commandssim70 = 1'd0;
reg commandssim71 = 1'd0;
reg [16:0] commandssim72 = 17'd0;
reg [16:0] commandssim73 = 17'd0;
reg [16:0] commandssim74 = 17'd0;
reg [16:0] commandssim75 = 17'd0;
reg [16:0] commandssim76 = 17'd0;
reg [16:0] commandssim77 = 17'd0;
reg [16:0] commandssim78 = 17'd0;
reg [16:0] commandssim79 = 17'd0;
reg commandssim_data_en_tappeddelayline;
reg commandssim_data_en_tappeddelayline_tappeddelayline0 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline1 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline2 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline3 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline4 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline5 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline6 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline7 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline8 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline9 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline10 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline11 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline12 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline13 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline14 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline15 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline16 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline17 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline18 = 1'd0;
reg commandssim_data_en_tappeddelayline_tappeddelayline19 = 1'd0;
reg commandssim_cs_tappeddelayline0 = 1'd0;
reg commandssim_cs_tappeddelayline1 = 1'd0;
reg [5:0] commandssim_ca_tappeddelayline0 = 6'd0;
reg [5:0] commandssim_ca_tappeddelayline1 = 6'd0;
reg [5:0] commandssim_cs_low;
reg [5:0] commandssim_cs_high;
reg commandssim_handle_cmd;
reg [6:0] commandssim_mpc_op;
reg commandssim_cmds_enabled;
reg [5:0] commandssim_ma = 6'd0;
reg commandssim_op7 = 1'd0;
reg [7:0] commandssim_op;
reg commandssim_simlogger_cond0;
reg commandssim_simlogger_cond_d0 = 1'd0;
reg commandssim_commandssim_matched0;
reg commandssim_commandssim_cond0;
reg commandssim_commandssim_cond_d0 = 1'd0;
reg commandssim_commandssim_cond1;
reg commandssim_commandssim_cond_d1 = 1'd0;
reg commandssim_commandssim_cond2;
reg commandssim_commandssim_cond_d2 = 1'd0;
reg commandssim_simlogger_cond1;
reg commandssim_simlogger_cond_d1 = 1'd0;
reg commandssim_commandssim_matched1;
reg commandssim_commandssim_cond3;
reg commandssim_commandssim_cond_d3 = 1'd0;
reg [2:0] commandssim_bank0 = 3'd0;
reg [6:0] commandssim_row1 = 7'd0;
reg [9:0] commandssim_row2;
reg [16:0] commandssim_row0;
reg commandssim_simlogger_cond2;
reg commandssim_simlogger_cond_d2 = 1'd0;
reg commandssim_simlogger_cond3;
reg commandssim_simlogger_cond_d3 = 1'd0;
reg commandssim_commandssim_matched2;
reg commandssim_commandssim_cond4;
reg commandssim_commandssim_cond_d4 = 1'd0;
reg commandssim_commandssim_cond5;
reg commandssim_commandssim_cond_d5 = 1'd0;
reg commandssim_commandssim_cond6;
reg commandssim_commandssim_cond_d6 = 1'd0;
reg [2:0] commandssim_bank1;
reg commandssim_simlogger_cond4;
reg commandssim_simlogger_cond_d4 = 1'd0;
reg commandssim_simlogger_cond5;
reg commandssim_simlogger_cond_d5 = 1'd0;
reg commandssim_simlogger_cond6 = 1'd0;
reg commandssim_simlogger_cond_d6 = 1'd0;
reg commandssim_commandssim_matched3;
reg commandssim_commandssim_cond7;
reg commandssim_commandssim_cond_d7 = 1'd0;
reg [4:0] commandssim_cas1 = 5'd0;
reg [2:0] commandssim_bank2 = 3'd0;
reg [16:0] commandssim_row1_1;
reg commandssim_col9 = 1'd0;
reg [9:0] commandssim_col;
reg commandssim_burst_len = 1'd0;
reg commandssim_auto_precharge = 1'd0;
reg commandssim_commandssim_cond8;
reg commandssim_commandssim_cond_d8 = 1'd0;
reg commandssim_commandssim_cond9;
reg commandssim_commandssim_cond_d9 = 1'd0;
reg commandssim_commandssim_cond10;
reg commandssim_commandssim_cond_d10 = 1'd0;
reg commandssim_simlogger_cond7;
reg commandssim_simlogger_cond_d7 = 1'd0;
reg commandssim_simlogger_cond8;
reg commandssim_simlogger_cond_d8 = 1'd0;
reg commandssim_simlogger_cond9;
reg commandssim_simlogger_cond_d9 = 1'd0;
reg commandssim_simlogger_cond10;
reg commandssim_simlogger_cond_d10 = 1'd0;
reg commandssim_simlogger_cond11;
reg commandssim_simlogger_cond_d11 = 1'd0;
reg commandssim_simlogger_cond12;
reg commandssim_simlogger_cond_d12 = 1'd0;
reg commandssim_commandssim_matched4;
reg commandssim_commandssim_cond11;
reg commandssim_commandssim_cond_d11 = 1'd0;
reg commandssim_commandssim_cond12;
reg commandssim_commandssim_cond_d12 = 1'd0;
reg commandssim_commandssim_cond13;
reg commandssim_commandssim_cond_d13 = 1'd0;
reg commandssim_cases_cond0;
reg commandssim_cases_cond_d0 = 1'd0;
reg commandssim_cases_cond1;
reg commandssim_cases_cond_d1 = 1'd0;
reg commandssim_cases_cond2;
reg commandssim_cases_cond_d2 = 1'd0;
reg commandssim_cases_cond3;
reg commandssim_cases_cond_d3 = 1'd0;
reg commandssim_cases_cond4;
reg commandssim_cases_cond_d4 = 1'd0;
reg commandssim_cases_cond5;
reg commandssim_cases_cond_d5 = 1'd0;
reg commandssim_cases_cond6;
reg commandssim_cases_cond_d6 = 1'd0;
reg commandssim_cases_cond7;
reg commandssim_cases_cond_d7 = 1'd0;
reg commandssim_simlogger_cond13;
reg commandssim_simlogger_cond_d13 = 1'd0;
reg commandssim_simlogger_cond14;
reg commandssim_simlogger_cond_d14 = 1'd0;
reg commandssim_commandssim_matched5;
reg commandssim_commandssim_cond14;
reg commandssim_commandssim_cond_d14 = 1'd0;
reg commandssim_simlogger_cond15;
reg commandssim_simlogger_cond_d15 = 1'd0;
reg commandssim_tinit0_trigger = 1'd0;
wire commandssim_tinit0_ready0;
wire commandssim_tinit0_ready_p;
reg commandssim_tinit0_trigger_d = 1'd0;
reg commandssim_tinit0_triggered = 1'd0;
wire commandssim_tinit0_valid;
wire commandssim_tinit0_ready1;
reg [25:0] commandssim_tinit0_count = 26'd0;
wire commandssim_tinit0_ready2;
reg commandssim_tinit0_ready_reg = 1'd0;
reg commandssim_tinit0_cond_d0 = 1'd0;
reg commandssim_tinit0_cond_d1 = 1'd0;
reg commandssim_tinit0_cond_d2 = 1'd0;
reg commandssim_tinit0_cond_d3 = 1'd0;
wire commandssim_tinit1_trigger;
wire commandssim_tinit1_ready0;
wire commandssim_tinit1_ready_p;
reg commandssim_tinit1_trigger_d = 1'd0;
reg commandssim_tinit1_triggered = 1'd0;
wire commandssim_tinit1_valid;
wire commandssim_tinit1_ready1;
reg [18:0] commandssim_tinit1_count = 19'd0;
wire commandssim_tinit1_ready2;
reg commandssim_tinit1_ready_reg = 1'd0;
reg commandssim_tinit1_cond_d0 = 1'd0;
reg commandssim_tinit1_cond_d1 = 1'd0;
reg commandssim_tinit1_cond_d2 = 1'd0;
reg commandssim_tinit1_cond_d3 = 1'd0;
wire commandssim_tinit2_trigger;
wire commandssim_tinit2_ready0;
wire commandssim_tinit2_ready_p;
reg commandssim_tinit2_trigger_d = 1'd0;
reg commandssim_tinit2_triggered = 1'd0;
wire commandssim_tinit2_valid;
wire commandssim_tinit2_ready1;
reg [4:0] commandssim_tinit2_count = 5'd0;
wire commandssim_tinit2_ready2;
reg commandssim_tinit2_ready_reg = 1'd0;
reg commandssim_tinit2_cond_d0 = 1'd0;
reg commandssim_tinit2_cond_d1 = 1'd0;
reg commandssim_tinit2_cond_d2 = 1'd0;
reg commandssim_tinit2_cond_d3 = 1'd0;
wire commandssim_tinit3_trigger;
wire commandssim_tinit3_ready0;
wire commandssim_tinit3_ready_p;
reg commandssim_tinit3_trigger_d = 1'd0;
reg commandssim_tinit3_triggered = 1'd0;
wire commandssim_tinit3_valid;
wire commandssim_tinit3_ready1;
reg [22:0] commandssim_tinit3_count = 23'd0;
wire commandssim_tinit3_ready2;
reg commandssim_tinit3_ready_reg = 1'd0;
reg commandssim_tinit3_cond_d0 = 1'd0;
reg commandssim_tinit3_cond_d1 = 1'd0;
reg commandssim_tinit3_cond_d2 = 1'd0;
reg commandssim_tinit3_cond_d3 = 1'd0;
reg commandssim_tinit4_trigger = 1'd0;
wire commandssim_tinit4_ready0;
wire commandssim_tinit4_ready_p;
reg commandssim_tinit4_trigger_d = 1'd0;
reg commandssim_tinit4_triggered = 1'd0;
wire commandssim_tinit4_valid;
wire commandssim_tinit4_ready1;
reg [2:0] commandssim_tinit4_count = 3'd0;
wire commandssim_tinit4_ready2;
reg commandssim_tinit4_ready_reg = 1'd0;
reg commandssim_tinit4_cond_d0 = 1'd0;
reg commandssim_tinit4_cond_d1 = 1'd0;
reg commandssim_tinit4_cond_d2 = 1'd0;
reg commandssim_tinit4_cond_d3 = 1'd0;
reg commandssim_tinit5_trigger;
wire commandssim_tinit5_ready0;
wire commandssim_tinit5_ready_p;
reg commandssim_tinit5_trigger_d = 1'd0;
reg commandssim_tinit5_triggered = 1'd0;
wire commandssim_tinit5_valid;
wire commandssim_tinit5_ready1;
reg [12:0] commandssim_tinit5_count = 13'd0;
wire commandssim_tinit5_ready2;
reg commandssim_tinit5_ready_reg = 1'd0;
reg commandssim_tinit5_cond_d0 = 1'd0;
reg commandssim_tinit5_cond_d1 = 1'd0;
reg commandssim_tinit5_cond_d2 = 1'd0;
reg commandssim_tinit5_cond_d3 = 1'd0;
reg commandssim_tzqcal_trigger;
wire commandssim_tzqcal_ready0;
wire commandssim_tzqcal_ready_p;
reg commandssim_tzqcal_trigger_d = 1'd0;
reg commandssim_tzqcal_triggered = 1'd0;
wire commandssim_tzqcal_valid;
wire commandssim_tzqcal_ready1;
reg [11:0] commandssim_tzqcal_count = 12'd0;
wire commandssim_tzqcal_ready2;
reg commandssim_tzqcal_ready_reg = 1'd0;
reg commandssim_tzqcal_cond_d0 = 1'd0;
reg commandssim_tzqcal_cond_d1 = 1'd0;
reg commandssim_tzqcal_cond_d2 = 1'd0;
reg commandssim_tzqcal_cond_d3 = 1'd0;
reg commandssim_tzqlat_trigger;
wire commandssim_tzqlat_ready0;
wire commandssim_tzqlat_ready_p;
reg commandssim_tzqlat_trigger_d = 1'd0;
reg commandssim_tzqlat_triggered = 1'd0;
wire commandssim_tzqlat_valid;
wire commandssim_tzqlat_ready1;
reg [5:0] commandssim_tzqlat_count = 6'd0;
wire commandssim_tzqlat_ready2;
reg commandssim_tzqlat_ready_reg = 1'd0;
reg commandssim_tzqlat_cond_d0 = 1'd0;
reg commandssim_tzqlat_cond_d1 = 1'd0;
reg commandssim_tzqlat_cond_d2 = 1'd0;
reg commandssim_tzqlat_cond_d3 = 1'd0;
wire commandssim_tpw_reset_trigger;
wire commandssim_tpw_reset_ready0;
wire commandssim_tpw_reset_ready_p;
reg commandssim_tpw_reset_trigger_d = 1'd0;
reg commandssim_tpw_reset_triggered = 1'd0;
wire commandssim_tpw_reset_valid;
wire commandssim_tpw_reset_ready1;
reg [7:0] commandssim_tpw_reset_count = 8'd0;
wire commandssim_tpw_reset_ready2;
reg commandssim_tpw_reset_ready_reg = 1'd0;
reg commandssim_tpw_reset_cond_d0 = 1'd0;
reg commandssim_tpw_reset_cond_d1 = 1'd0;
reg commandssim_tpw_reset_cond_d2 = 1'd0;
reg commandssim_tpw_reset_cond_d3 = 1'd0;
reg commandssim_delayed_tappeddelayline0 = 1'd0;
reg commandssim_simlogger_cond16;
reg commandssim_simlogger_cond_d16 = 1'd0;
reg commandssim_simlogger_cond17;
reg commandssim_simlogger_cond_d17 = 1'd0;
reg commandssim_simlogger_cond18;
reg commandssim_simlogger_cond_d18 = 1'd0;
reg commandssim_delayed_tappeddelayline1 = 1'd0;
reg commandssim_simlogger_cond19;
reg commandssim_simlogger_cond_d19 = 1'd0;
reg commandssim_delayed_tappeddelayline2 = 1'd0;
reg commandssim_simlogger_cond20;
reg commandssim_simlogger_cond_d20 = 1'd0;
reg commandssim_delayed_tappeddelayline3 = 1'd0;
reg commandssim_simlogger_cond21;
reg commandssim_simlogger_cond_d21 = 1'd0;
reg commandssim_simlogger_cond22;
reg commandssim_simlogger_cond_d22 = 1'd0;
reg commandssim_reset;
reg commandssim_simlogger_cond23;
reg commandssim_simlogger_cond_d23 = 1'd0;
reg commandssim_simlogger_cond24;
reg commandssim_simlogger_cond_d24 = 1'd0;
reg commandssim_simlogger_cond25;
reg commandssim_simlogger_cond_d25 = 1'd0;
reg commandssim_simlogger_cond26;
reg commandssim_simlogger_cond_d26 = 1'd0;
reg commandssim_simlogger_cond27;
reg commandssim_simlogger_cond_d27 = 1'd0;
reg commandssim_simlogger_cond28;
reg commandssim_simlogger_cond_d28 = 1'd0;
reg commandssim_simlogger_cond29;
reg commandssim_simlogger_cond_d29 = 1'd0;
reg [2:0] commandssim_state = 3'd0;
reg [2:0] commandssim_next_state;
reg [2:0] commandssim_prev_state_tappeddelayline = 3'd0;
reg commandssim_commandssim_cond15;
reg commandssim_commandssim_cond_d15 = 1'd0;
reg commandssim_commandssim_cond16;
reg commandssim_commandssim_cond_d16 = 1'd0;
reg commandssim_commandssim_cond17;
reg commandssim_commandssim_cond_d17 = 1'd0;
reg commandssim_commandssim_cond18;
reg commandssim_commandssim_cond_d18 = 1'd0;
reg commandssim_commandssim_cond19;
reg commandssim_commandssim_cond_d19 = 1'd0;
reg commandssim_commandssim_cond20;
reg commandssim_commandssim_cond_d20 = 1'd0;
reg commandssim_commandssim_cond21;
reg commandssim_commandssim_cond_d21 = 1'd0;
reg commandssim_commandssim_cond22;
reg commandssim_commandssim_cond_d22 = 1'd0;
reg commandssim_commandssim_cond23;
reg commandssim_commandssim_cond_d23 = 1'd0;
reg commandssim_commandssim_cond24;
reg commandssim_commandssim_cond_d24 = 1'd0;
reg commandssim_commandssim_cond25;
reg commandssim_commandssim_cond_d25 = 1'd0;
reg commandssim_commandssim_cond26;
reg commandssim_commandssim_cond_d26 = 1'd0;
reg commandssim_commandssim_cond27;
reg commandssim_commandssim_cond_d27 = 1'd0;
reg commandssim_commandssim_cond28;
reg commandssim_commandssim_cond_d28 = 1'd0;
reg commandssim_commandssim_cond29;
reg commandssim_commandssim_cond_d29 = 1'd0;
reg commandssim_commandssim_cond30;
reg commandssim_commandssim_cond_d30 = 1'd0;
reg commandssim_commandssim_cond31;
reg commandssim_commandssim_cond_d31 = 1'd0;
reg commandssim_commandssim_cond32;
reg commandssim_commandssim_cond_d32 = 1'd0;
reg commandssim_commandssim_cond33;
reg commandssim_commandssim_cond_d33 = 1'd0;
reg commandssim_commandssim_cond34;
reg commandssim_commandssim_cond_d34 = 1'd0;
reg commandssim_commandssim_cond35;
reg commandssim_commandssim_cond_d35 = 1'd0;
reg commandssim_commandssim_cond36;
reg commandssim_commandssim_cond_d36 = 1'd0;
reg commandssim_commandssim_cond37;
reg commandssim_commandssim_cond_d37 = 1'd0;
reg commandssim_commandssim_cond38;
reg commandssim_commandssim_cond_d38 = 1'd0;
reg commandssim_commandssim_cond39;
reg commandssim_commandssim_cond_d39 = 1'd0;
wire [2:0] log_level;
wire [63:0] log_time_ps;
reg [63:0] log_cnt = 64'd0;
reg [2:0] simlogger_storage = 3'd1;
reg [24:0] memory0_adr;
wire [15:0] memory0_dat_r;
reg [1:0] memory0_we;
reg [15:0] memory0_dat_w;
reg [24:0] memory1_adr;
wire [15:0] memory1_dat_r;
reg [1:0] memory1_we;
reg [15:0] memory1_dat_w;
reg [24:0] memory2_adr;
wire [15:0] memory2_dat_r;
reg [1:0] memory2_we;
reg [15:0] memory2_dat_w;
reg [24:0] memory3_adr;
wire [15:0] memory3_dat_r;
reg [1:0] memory3_we;
reg [15:0] memory3_dat_w;
reg [24:0] memory4_adr;
wire [15:0] memory4_dat_r;
reg [1:0] memory4_we;
reg [15:0] memory4_dat_w;
reg [24:0] memory5_adr;
wire [15:0] memory5_dat_r;
reg [1:0] memory5_we;
reg [15:0] memory5_dat_w;
reg [24:0] memory6_adr;
wire [15:0] memory6_dat_r;
reg [1:0] memory6_we;
reg [15:0] memory6_dat_w;
reg [24:0] memory7_adr;
wire [15:0] memory7_dat_r;
reg [1:0] memory7_we;
reg [15:0] memory7_dat_w;
reg [2:0] bank = 3'd0;
reg [16:0] row = 17'd0;
reg [9:0] col = 10'd0;
wire [2:0] dqwrite_level;
wire [63:0] dqwrite_time_ps;
reg [63:0] dqwrite_cnt = 64'd0;
reg [2:0] dqwrite_storage = 3'd1;
wire dqwrite_trigger;
reg [3:0] dqwrite_burst_counter = 4'd0;
wire [24:0] dqwrite_addr;
wire [9:0] dqwrite_col_burst;
wire dqwrite_masked0;
reg dqwrite_masked1 = 1'd0;
reg dqwrite_cond;
wire [2:0] dqread_level;
wire [63:0] dqread_time_ps;
reg [63:0] dqread_cnt = 64'd0;
reg [2:0] dqread_storage = 3'd1;
wire dqread_trigger;
reg [3:0] dqread_burst_counter = 4'd0;
wire [24:0] dqread_addr;
wire [9:0] dqread_col_burst;
reg dqread_cond;
wire [2:0] dqswrite_level;
wire [63:0] dqswrite_time_ps;
reg [63:0] dqswrite_cnt = 64'd0;
reg [2:0] dqswrite_storage = 3'd1;
wire dqswrite_trigger;
reg [3:0] dqswrite_burst_counter = 4'd0;
reg dqswrite_dqs0;
reg dqswrite_cond;
wire [2:0] dqsread_level;
wire [63:0] dqsread_time_ps;
reg [63:0] dqsread_cnt = 64'd0;
reg [2:0] dqsread_storage = 3'd1;
wire dqsread_trigger;
reg [3:0] dqsread_burst_counter = 4'd0;
wire write;
wire read;
reg fsm0_state = 1'd0;
reg fsm0_next_state;
reg [5:0] commandssim_ma_fsm0_next_value0;
reg commandssim_ma_fsm0_next_value_ce0;
reg commandssim_op7_fsm0_next_value1;
reg commandssim_op7_fsm0_next_value_ce1;
reg [7:0] fsm0_next_value;
reg fsm0_next_value_ce;
reg fsm1_state = 1'd0;
reg fsm1_next_state;
reg [2:0] commandssim_bank0_fsm1_next_value0;
reg commandssim_bank0_fsm1_next_value_ce0;
reg [6:0] commandssim_row1_fsm1_next_value1;
reg commandssim_row1_fsm1_next_value_ce1;
reg fsm1_next_value0;
reg fsm1_next_value_ce0;
reg [16:0] fsm1_next_value1;
reg fsm1_next_value_ce1;
reg fsm2_state = 1'd0;
reg fsm2_next_state;
reg [4:0] commandssim_cas1_fsm2_next_value0;
reg commandssim_cas1_fsm2_next_value_ce0;
reg [2:0] commandssim_bank2_fsm2_next_value1;
reg commandssim_bank2_fsm2_next_value_ce1;
reg commandssim_col9_fsm2_next_value2;
reg commandssim_col9_fsm2_next_value_ce2;
reg commandssim_burst_len_fsm2_next_value3;
reg commandssim_burst_len_fsm2_next_value_ce3;
reg commandssim_auto_precharge_fsm2_next_value4;
reg commandssim_auto_precharge_fsm2_next_value_ce4;
reg fsm2_next_value;
reg fsm2_next_value_ce;
reg dqwrite_state = 1'd0;
reg dqwrite_next_state;
reg [3:0] dqwrite_burst_counter_clockdomainsrenamer0_next_value0;
reg dqwrite_burst_counter_clockdomainsrenamer0_next_value_ce0;
reg dqwrite_masked1_clockdomainsrenamer0_next_value1;
reg dqwrite_masked1_clockdomainsrenamer0_next_value_ce1;
reg dqread_state = 1'd0;
reg dqread_next_state;
reg [3:0] dqread_burst_counter_clockdomainsrenamer1_next_value;
reg dqread_burst_counter_clockdomainsrenamer1_next_value_ce;
reg dqswrite_state = 1'd0;
reg dqswrite_next_state;
reg [3:0] dqswrite_burst_counter_clockdomainsrenamer2_next_value;
reg dqswrite_burst_counter_clockdomainsrenamer2_next_value_ce;
reg dqsread_state = 1'd0;
reg dqsread_next_state;
reg [3:0] dqsread_burst_counter_clockdomainsrenamer3_next_value;
reg dqsread_burst_counter_clockdomainsrenamer3_next_value_ce;
reg comb_t_basiclowerer_array_muxed0;
reg [16:0] comb_t_rhs_array_muxed;
reg comb_t_basiclowerer_array_muxed1;
reg [1:0] comb_t_array_muxed;
reg [1:0] comb_f_array_muxed;
reg [24:0] comb_lhs_array_muxed0;
reg [15:0] comb_lhs_array_muxed1;
reg [1:0] comb_lhs_array_muxed2;
reg [24:0] comb_lhs_array_muxed3;
reg [15:0] comb_rhs_array_muxed;
reg sync_lhs_array_muxed = 1'd0;
reg sync_basiclowerer_array_muxed;
reg [7:0] sync_array_muxed0 = 8'd0;
reg sync_array_muxed1 = 1'd0;
reg [16:0] sync_array_muxed2 = 17'd0;
reg sync_array_muxed3 = 1'd0;
(* no_retiming = "true" *) reg [2:0] multiregimpl0_regs0 = 3'd0;
(* no_retiming = "true" *) reg [2:0] multiregimpl0_regs1 = 3'd0;
(* no_retiming = "true" *) reg [2:0] multiregimpl1_regs0 = 3'd0;
(* no_retiming = "true" *) reg [2:0] multiregimpl1_regs1 = 3'd0;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign cdc_sink_valid = sink_sink_valid;
assign sink_sink_ready = cdc_sink_ready;
assign cdc_sink_first = sink_sink_first;
assign cdc_sink_last = sink_sink_last;
assign cdc_sink_payload_we = sink_sink_payload_we;
assign cdc_sink_payload_masked = sink_sink_payload_masked;
assign cdc_sink_payload_bank = sink_sink_payload_bank;
assign cdc_sink_payload_row = sink_sink_payload_row;
assign cdc_sink_payload_col = sink_sink_payload_col;
assign source_source_valid = cdc_source_valid;
assign cdc_source_ready = source_source_ready;
assign source_source_first = cdc_source_first;
assign source_source_last = cdc_source_last;
assign source_source_payload_we = cdc_source_payload_we;
assign source_source_payload_masked = cdc_source_payload_masked;
assign source_source_payload_bank = cdc_source_payload_bank;
assign source_source_payload_row = cdc_source_payload_row;
assign source_source_payload_col = cdc_source_payload_col;
assign cdc_asyncfifo_din = {cdc_fifo_in_last, cdc_fifo_in_first, cdc_fifo_in_payload_col, cdc_fifo_in_payload_row, cdc_fifo_in_payload_bank, cdc_fifo_in_payload_masked, cdc_fifo_in_payload_we};
assign {cdc_fifo_out_last, cdc_fifo_out_first, cdc_fifo_out_payload_col, cdc_fifo_out_payload_row, cdc_fifo_out_payload_bank, cdc_fifo_out_payload_masked, cdc_fifo_out_payload_we} = cdc_asyncfifo_dout;
assign cdc_sink_ready = cdc_asyncfifo_writable;
assign cdc_asyncfifo_we = cdc_sink_valid;
assign cdc_fifo_in_first = cdc_sink_first;
assign cdc_fifo_in_last = cdc_sink_last;
assign cdc_fifo_in_payload_we = cdc_sink_payload_we;
assign cdc_fifo_in_payload_masked = cdc_sink_payload_masked;
assign cdc_fifo_in_payload_bank = cdc_sink_payload_bank;
assign cdc_fifo_in_payload_row = cdc_sink_payload_row;
assign cdc_fifo_in_payload_col = cdc_sink_payload_col;
assign cdc_source_valid = cdc_asyncfifo_readable;
assign cdc_source_first = cdc_fifo_out_first;
assign cdc_source_last = cdc_fifo_out_last;
assign cdc_source_payload_we = cdc_fifo_out_payload_we;
assign cdc_source_payload_masked = cdc_fifo_out_payload_masked;
assign cdc_source_payload_bank = cdc_fifo_out_payload_bank;
assign cdc_source_payload_row = cdc_fifo_out_payload_row;
assign cdc_source_payload_col = cdc_fifo_out_payload_col;
assign cdc_asyncfifo_re = cdc_source_ready;
assign cdc_graycounter0_ce = (cdc_asyncfifo_writable & cdc_asyncfifo_we);
assign cdc_graycounter1_ce = (cdc_asyncfifo_readable & cdc_asyncfifo_re);
assign cdc_asyncfifo_writable = (((cdc_graycounter0_q[2] == cdc_consume_wdomain[2]) | (cdc_graycounter0_q[1] == cdc_consume_wdomain[1])) | (cdc_graycounter0_q[0] != cdc_consume_wdomain[0]));
assign cdc_asyncfifo_readable = (cdc_graycounter1_q != cdc_produce_rdomain);
assign cdc_wrport_adr = cdc_graycounter0_q_binary[1:0];
assign cdc_wrport_dat_w = cdc_asyncfifo_din;
assign cdc_wrport_we = cdc_graycounter0_ce;
assign cdc_rdport_adr = cdc_graycounter1_q_next_binary[1:0];
assign cdc_asyncfifo_dout = cdc_rdport_dat_r;

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	cdc_graycounter0_q_next_binary <= 3'd0;
	if (cdc_graycounter0_ce) begin
		cdc_graycounter0_q_next_binary <= (cdc_graycounter0_q_binary + 1'd1);
	end else begin
		cdc_graycounter0_q_next_binary <= cdc_graycounter0_q_binary;
	end
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign cdc_graycounter0_q_next = (cdc_graycounter0_q_next_binary ^ cdc_graycounter0_q_next_binary[2:1]);

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	cdc_graycounter1_q_next_binary <= 3'd0;
	if (cdc_graycounter1_ce) begin
		cdc_graycounter1_q_next_binary <= (cdc_graycounter1_q_binary + 1'd1);
	end else begin
		cdc_graycounter1_q_next_binary <= cdc_graycounter1_q_binary;
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end
assign cdc_graycounter1_q_next = (cdc_graycounter1_q_next_binary ^ cdc_graycounter1_q_next_binary[2:1]);

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond1 <= 1'd0;
	commandssim_commandssim_matched1 <= 1'd0;
	commandssim_commandssim_cond3 <= 1'd0;
	if ((commandssim_handle_cmd & (commandssim_cs_high[4:0] == 4'd8))) begin
		commandssim_commandssim_cond3 <= 1'd1;
		commandssim_commandssim_matched1 <= 1'd1;
		if ((((((((commandssim64 | commandssim65) | commandssim66) | commandssim67) | commandssim68) | commandssim69) | commandssim70) | commandssim71)) begin
			commandssim_simlogger_cond1 <= 1'd1;
		end
	end
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	commandssim_bank1 <= 3'd0;
	commandssim_simlogger_cond4 <= 1'd0;
	commandssim_simlogger_cond5 <= 1'd0;
	commandssim_commandssim_matched3 <= 1'd0;
	commandssim_commandssim_cond7 <= 1'd0;
	if ((commandssim_handle_cmd & (commandssim_cs_high[4:0] == 5'd16))) begin
		commandssim_commandssim_cond7 <= 1'd1;
		commandssim_commandssim_matched3 <= 1'd1;
		if (commandssim_cs_high[5]) begin
			commandssim_simlogger_cond4 <= 1'd1;
			commandssim_bank1 <= 3'd7;
		end else begin
			commandssim_simlogger_cond5 <= 1'd1;
			commandssim_bank1 <= commandssim_cs_low[2:0];
		end
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	commandssim_mpc_op <= 7'd0;
	commandssim_cases_cond0 <= 1'd0;
	commandssim_cases_cond1 <= 1'd0;
	commandssim_cases_cond2 <= 1'd0;
	commandssim_cases_cond3 <= 1'd0;
	commandssim_cases_cond4 <= 1'd0;
	commandssim_cases_cond5 <= 1'd0;
	commandssim_cases_cond6 <= 1'd0;
	commandssim_cases_cond7 <= 1'd0;
	commandssim_simlogger_cond13 <= 1'd0;
	commandssim_simlogger_cond14 <= 1'd0;
	commandssim_commandssim_matched5 <= 1'd0;
	commandssim_commandssim_cond14 <= 1'd0;
	if ((commandssim_handle_cmd & (commandssim_cs_high[4:0] == 1'd0))) begin
		commandssim_commandssim_cond14 <= 1'd1;
		commandssim_commandssim_matched5 <= 1'd1;
		commandssim_mpc_op <= {commandssim_cs_high[5], commandssim_cs_low};
		if ((commandssim_cs_high[5] == 1'd0)) begin
			commandssim_simlogger_cond14 <= 1'd1;
		end else begin
			case (commandssim_mpc_op)
				1'd0: begin
					commandssim_cases_cond0 <= 1'd1;
				end
				7'd65: begin
					commandssim_cases_cond1 <= 1'd1;
				end
				7'd67: begin
					commandssim_cases_cond2 <= 1'd1;
				end
				7'd71: begin
					commandssim_cases_cond3 <= 1'd1;
				end
				7'd75: begin
					commandssim_cases_cond4 <= 1'd1;
				end
				7'd77: begin
					commandssim_cases_cond5 <= 1'd1;
				end
				7'd79: begin
					commandssim_cases_cond6 <= 1'd1;
				end
				7'd81: begin
					commandssim_cases_cond7 <= 1'd1;
				end
				default: begin
					commandssim_simlogger_cond13 <= 1'd1;
				end
			endcase
		end
	end
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	commandssim_cs_low <= 6'd0;
	commandssim_cs_high <= 6'd0;
	commandssim_handle_cmd <= 1'd0;
	if (commandssim_cmds_enabled) begin
		if (({commandssim_cs_tappeddelayline1, commandssim_cs_tappeddelayline0} == 2'd2)) begin
			commandssim_handle_cmd <= 1'd1;
			commandssim_cs_high <= commandssim_ca_tappeddelayline1;
			commandssim_cs_low <= commandssim_ca_tappeddelayline0;
		end
	end
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond15 <= 1'd0;
	if ((commandssim_handle_cmd & (~(((((commandssim_commandssim_matched0 | commandssim_commandssim_matched1) | commandssim_commandssim_matched2) | commandssim_commandssim_matched3) | commandssim_commandssim_matched4) | commandssim_commandssim_matched5)))) begin
		commandssim_simlogger_cond15 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end
assign commandssim_tinit1_trigger = 1'd1;
assign commandssim_tinit2_trigger = (~lpddr4simulationpads_cke);
assign commandssim_tinit3_trigger = lpddr4simulationpads_reset_n;
assign commandssim_tpw_reset_trigger = (~lpddr4simulationpads_reset_n);

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond16 <= 1'd0;
	commandssim_simlogger_cond17 <= 1'd0;
	commandssim_simlogger_cond18 <= 1'd0;
	if (((~commandssim_delayed_tappeddelayline0) & lpddr4simulationpads_reset_n)) begin
		commandssim_simlogger_cond16 <= 1'd1;
		if ((~commandssim_tinit1_ready0)) begin
			commandssim_simlogger_cond17 <= 1'd1;
		end
		if ((~commandssim_tinit2_ready0)) begin
			commandssim_simlogger_cond18 <= 1'd1;
		end
	end
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond19 <= 1'd0;
	if ((commandssim_delayed_tappeddelayline1 & (~lpddr4simulationpads_reset_n))) begin
		commandssim_simlogger_cond19 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_9;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond20 <= 1'd0;
	if ((commandssim_delayed_tappeddelayline2 & (~lpddr4simulationpads_cke))) begin
		commandssim_simlogger_cond20 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_9 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_10;
// synthesis translate_on
always @(*) begin
	commandssim_simlogger_cond21 <= 1'd0;
	commandssim_simlogger_cond22 <= 1'd0;
	if (((~commandssim_delayed_tappeddelayline3) & lpddr4simulationpads_cke)) begin
		commandssim_simlogger_cond21 <= 1'd1;
		if ((~commandssim_tinit3_ready0)) begin
			commandssim_simlogger_cond22 <= 1'd1;
		end
	end
// synthesis translate_off
	dummy_d_10 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_11;
// synthesis translate_on
always @(*) begin
	commandssim_reset <= 1'd0;
	commandssim_simlogger_cond23 <= 1'd0;
	if (commandssim_tpw_reset_ready_p) begin
		commandssim_reset <= 1'd1;
		commandssim_simlogger_cond23 <= 1'd1;
	end
// synthesis translate_off
	dummy_d_11 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_12;
// synthesis translate_on
always @(*) begin
	commandssim_commandssim_cond15 <= 1'd0;
	commandssim_commandssim_cond16 <= 1'd0;
	commandssim_commandssim_cond17 <= 1'd0;
	commandssim_commandssim_cond18 <= 1'd0;
	commandssim_commandssim_cond19 <= 1'd0;
	commandssim_commandssim_cond20 <= 1'd0;
	commandssim_commandssim_cond21 <= 1'd0;
	commandssim_commandssim_cond22 <= 1'd0;
	commandssim_commandssim_cond23 <= 1'd0;
	commandssim_commandssim_cond24 <= 1'd0;
	commandssim_commandssim_cond25 <= 1'd0;
	commandssim_commandssim_cond26 <= 1'd0;
	commandssim_commandssim_cond27 <= 1'd0;
	commandssim_commandssim_cond28 <= 1'd0;
	commandssim_commandssim_cond29 <= 1'd0;
	commandssim_commandssim_cond30 <= 1'd0;
	commandssim_commandssim_cond31 <= 1'd0;
	commandssim_commandssim_cond32 <= 1'd0;
	commandssim_commandssim_cond33 <= 1'd0;
	commandssim_commandssim_cond34 <= 1'd0;
	commandssim_commandssim_cond35 <= 1'd0;
	commandssim_commandssim_cond36 <= 1'd0;
	commandssim_commandssim_cond37 <= 1'd0;
	commandssim_commandssim_cond38 <= 1'd0;
	commandssim_commandssim_cond39 <= 1'd0;
	if ((commandssim_prev_state_tappeddelayline != commandssim_state)) begin
		case (commandssim_prev_state_tappeddelayline)
			1'd0: begin
				case (commandssim_state)
					1'd0: begin
						commandssim_commandssim_cond15 <= 1'd1;
					end
					1'd1: begin
						commandssim_commandssim_cond16 <= 1'd1;
					end
					2'd2: begin
						commandssim_commandssim_cond17 <= 1'd1;
					end
					2'd3: begin
						commandssim_commandssim_cond18 <= 1'd1;
					end
					3'd4: begin
						commandssim_commandssim_cond19 <= 1'd1;
					end
				endcase
			end
			1'd1: begin
				case (commandssim_state)
					1'd0: begin
						commandssim_commandssim_cond20 <= 1'd1;
					end
					1'd1: begin
						commandssim_commandssim_cond21 <= 1'd1;
					end
					2'd2: begin
						commandssim_commandssim_cond22 <= 1'd1;
					end
					2'd3: begin
						commandssim_commandssim_cond23 <= 1'd1;
					end
					3'd4: begin
						commandssim_commandssim_cond24 <= 1'd1;
					end
				endcase
			end
			2'd2: begin
				case (commandssim_state)
					1'd0: begin
						commandssim_commandssim_cond25 <= 1'd1;
					end
					1'd1: begin
						commandssim_commandssim_cond26 <= 1'd1;
					end
					2'd2: begin
						commandssim_commandssim_cond27 <= 1'd1;
					end
					2'd3: begin
						commandssim_commandssim_cond28 <= 1'd1;
					end
					3'd4: begin
						commandssim_commandssim_cond29 <= 1'd1;
					end
				endcase
			end
			2'd3: begin
				case (commandssim_state)
					1'd0: begin
						commandssim_commandssim_cond30 <= 1'd1;
					end
					1'd1: begin
						commandssim_commandssim_cond31 <= 1'd1;
					end
					2'd2: begin
						commandssim_commandssim_cond32 <= 1'd1;
					end
					2'd3: begin
						commandssim_commandssim_cond33 <= 1'd1;
					end
					3'd4: begin
						commandssim_commandssim_cond34 <= 1'd1;
					end
				endcase
			end
			3'd4: begin
				case (commandssim_state)
					1'd0: begin
						commandssim_commandssim_cond35 <= 1'd1;
					end
					1'd1: begin
						commandssim_commandssim_cond36 <= 1'd1;
					end
					2'd2: begin
						commandssim_commandssim_cond37 <= 1'd1;
					end
					2'd3: begin
						commandssim_commandssim_cond38 <= 1'd1;
					end
					3'd4: begin
						commandssim_commandssim_cond39 <= 1'd1;
					end
				endcase
			end
		endcase
	end
// synthesis translate_off
	dummy_d_12 <= dummy_s;
// synthesis translate_on
end
assign commandssim_time_ps = (commandssim_cnt * 9'd469);
assign commandssim_level = commandssim_simlogger_storage;

// synthesis translate_off
reg dummy_d_13;
// synthesis translate_on
always @(*) begin
	commandssim_op <= 8'd0;
	commandssim_simlogger_cond0 <= 1'd0;
	commandssim_commandssim_matched0 <= 1'd0;
	commandssim_commandssim_cond0 <= 1'd0;
	commandssim_commandssim_cond1 <= 1'd0;
	commandssim_commandssim_cond2 <= 1'd0;
	fsm0_next_state <= 1'd0;
	commandssim_ma_fsm0_next_value0 <= 6'd0;
	commandssim_ma_fsm0_next_value_ce0 <= 1'd0;
	commandssim_op7_fsm0_next_value1 <= 1'd0;
	commandssim_op7_fsm0_next_value_ce1 <= 1'd0;
	fsm0_next_value <= 8'd0;
	fsm0_next_value_ce <= 1'd0;
	fsm0_next_state <= fsm0_state;
	case (fsm0_state)
		1'd1: begin
			if (commandssim_handle_cmd) begin
				if ((commandssim_cs_high[4:0] == 5'd22)) begin
					commandssim_commandssim_cond1 <= 1'd1;
					commandssim_commandssim_matched0 <= 1'd1;
					commandssim_simlogger_cond0 <= 1'd1;
					commandssim_op <= {commandssim_op7, commandssim_cs_high[5], commandssim_cs_low};
					fsm0_next_value <= commandssim_op;
					fsm0_next_value_ce <= 1'd1;
				end else begin
					commandssim_commandssim_cond2 <= 1'd1;
				end
				fsm0_next_state <= 1'd0;
			end
		end
		default: begin
			if ((commandssim_handle_cmd & (commandssim_cs_high[4:0] == 3'd6))) begin
				commandssim_commandssim_cond0 <= 1'd1;
				commandssim_commandssim_matched0 <= 1'd1;
				commandssim_ma_fsm0_next_value0 <= commandssim_cs_low;
				commandssim_ma_fsm0_next_value_ce0 <= 1'd1;
				commandssim_op7_fsm0_next_value1 <= commandssim_cs_high[5];
				commandssim_op7_fsm0_next_value_ce1 <= 1'd1;
				fsm0_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_13 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_14;
// synthesis translate_on
always @(*) begin
	commandssim_row2 <= 10'd0;
	commandssim_row0 <= 17'd0;
	commandssim_simlogger_cond2 <= 1'd0;
	commandssim_simlogger_cond3 <= 1'd0;
	commandssim_commandssim_matched2 <= 1'd0;
	commandssim_commandssim_cond4 <= 1'd0;
	commandssim_commandssim_cond5 <= 1'd0;
	commandssim_commandssim_cond6 <= 1'd0;
	fsm1_next_state <= 1'd0;
	commandssim_bank0_fsm1_next_value0 <= 3'd0;
	commandssim_bank0_fsm1_next_value_ce0 <= 1'd0;
	commandssim_row1_fsm1_next_value1 <= 7'd0;
	commandssim_row1_fsm1_next_value_ce1 <= 1'd0;
	fsm1_next_value0 <= 1'd0;
	fsm1_next_value_ce0 <= 1'd0;
	fsm1_next_value1 <= 17'd0;
	fsm1_next_value_ce1 <= 1'd0;
	fsm1_next_state <= fsm1_state;
	case (fsm1_state)
		1'd1: begin
			if (commandssim_handle_cmd) begin
				if ((commandssim_cs_high[1:0] == 2'd3)) begin
					commandssim_commandssim_cond5 <= 1'd1;
					commandssim_commandssim_matched2 <= 1'd1;
					commandssim_simlogger_cond2 <= 1'd1;
					commandssim_row2 <= {commandssim_cs_high[5:2], commandssim_cs_low};
					commandssim_row0 <= {commandssim_row1, commandssim_row2};
					fsm1_next_value0 <= 1'd1;
					fsm1_next_value_ce0 <= 1'd1;
					fsm1_next_value1 <= commandssim_row0;
					fsm1_next_value_ce1 <= 1'd1;
					if (comb_t_basiclowerer_array_muxed0) begin
						commandssim_simlogger_cond3 <= 1'd1;
					end
				end else begin
					commandssim_commandssim_cond6 <= 1'd1;
				end
				fsm1_next_state <= 1'd0;
			end
		end
		default: begin
			if ((commandssim_handle_cmd & (commandssim_cs_high[1:0] == 1'd1))) begin
				commandssim_commandssim_cond4 <= 1'd1;
				commandssim_commandssim_matched2 <= 1'd1;
				commandssim_bank0_fsm1_next_value0 <= commandssim_cs_low[2:0];
				commandssim_bank0_fsm1_next_value_ce0 <= 1'd1;
				commandssim_row1_fsm1_next_value1 <= {commandssim_cs_low[3], commandssim_cs_high[5:2], commandssim_cs_low[5:4]};
				commandssim_row1_fsm1_next_value_ce1 <= 1'd1;
				fsm1_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_14 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_15;
// synthesis translate_on
always @(*) begin
	sink_sink_valid <= 1'd0;
	sink_sink_payload_we <= 1'd0;
	sink_sink_payload_masked <= 1'd0;
	sink_sink_payload_bank <= 3'd0;
	sink_sink_payload_row <= 17'd0;
	sink_sink_payload_col <= 10'd0;
	commandssim_data_en_tappeddelayline <= 1'd0;
	commandssim_row1_1 <= 17'd0;
	commandssim_col <= 10'd0;
	commandssim_commandssim_cond8 <= 1'd0;
	commandssim_commandssim_cond9 <= 1'd0;
	commandssim_commandssim_cond10 <= 1'd0;
	commandssim_simlogger_cond7 <= 1'd0;
	commandssim_simlogger_cond8 <= 1'd0;
	commandssim_simlogger_cond9 <= 1'd0;
	commandssim_simlogger_cond10 <= 1'd0;
	commandssim_simlogger_cond11 <= 1'd0;
	commandssim_simlogger_cond12 <= 1'd0;
	commandssim_commandssim_matched4 <= 1'd0;
	commandssim_commandssim_cond11 <= 1'd0;
	commandssim_commandssim_cond12 <= 1'd0;
	commandssim_commandssim_cond13 <= 1'd0;
	fsm2_next_state <= 1'd0;
	commandssim_cas1_fsm2_next_value0 <= 5'd0;
	commandssim_cas1_fsm2_next_value_ce0 <= 1'd0;
	commandssim_bank2_fsm2_next_value1 <= 3'd0;
	commandssim_bank2_fsm2_next_value_ce1 <= 1'd0;
	commandssim_col9_fsm2_next_value2 <= 1'd0;
	commandssim_col9_fsm2_next_value_ce2 <= 1'd0;
	commandssim_burst_len_fsm2_next_value3 <= 1'd0;
	commandssim_burst_len_fsm2_next_value_ce3 <= 1'd0;
	commandssim_auto_precharge_fsm2_next_value4 <= 1'd0;
	commandssim_auto_precharge_fsm2_next_value_ce4 <= 1'd0;
	fsm2_next_value <= 1'd0;
	fsm2_next_value_ce <= 1'd0;
	fsm2_next_state <= fsm2_state;
	case (fsm2_state)
		1'd1: begin
			if (commandssim_handle_cmd) begin
				if ((commandssim_cs_high[4:0] == 5'd18)) begin
					commandssim_commandssim_cond12 <= 1'd1;
					commandssim_commandssim_matched4 <= 1'd1;
					commandssim_row1_1 <= comb_t_rhs_array_muxed;
					commandssim_col <= {commandssim_col9, commandssim_cs_high[5], commandssim_cs_low, {2{1'd0}}};
					case (commandssim_cas1)
						2'd2: begin
							commandssim_commandssim_cond10 <= 1'd1;
						end
						3'd4: begin
							commandssim_commandssim_cond8 <= 1'd1;
						end
						4'd12: begin
							commandssim_commandssim_cond9 <= 1'd1;
						end
					endcase
					if ((~comb_t_basiclowerer_array_muxed1)) begin
						commandssim_simlogger_cond7 <= 1'd1;
					end
					if (((commandssim_cas1 != 2'd2) & (commandssim_col[3:0] != 1'd0))) begin
						commandssim_simlogger_cond8 <= 1'd1;
					end
					if ((commandssim3[6] | commandssim3[7])) begin
						commandssim_simlogger_cond9 <= 1'd1;
					end
					if (((commandssim_cas1 == 4'd12) & (commandssim13[5] == 1'd1))) begin
						commandssim_simlogger_cond10 <= 1'd1;
					end
					if (commandssim_auto_precharge) begin
						commandssim_simlogger_cond11 <= 1'd1;
						fsm2_next_value <= 1'd0;
						fsm2_next_value_ce <= 1'd1;
					end
					commandssim_data_en_tappeddelayline <= 1'd1;
					sink_sink_valid <= 1'd1;
					sink_sink_payload_we <= (commandssim_cas1 != 2'd2);
					sink_sink_payload_masked <= (commandssim_cas1 == 4'd12);
					sink_sink_payload_bank <= commandssim_bank2;
					sink_sink_payload_row <= commandssim_row1_1;
					sink_sink_payload_col <= commandssim_col;
					if ((~sink_sink_ready)) begin
						commandssim_simlogger_cond12 <= 1'd1;
					end
				end else begin
					commandssim_commandssim_cond13 <= 1'd1;
				end
				fsm2_next_state <= 1'd0;
			end
		end
		default: begin
			if ((commandssim_handle_cmd & (((commandssim_cs_high[4:0] == 3'd4) | (commandssim_cs_high[4:0] == 4'd12)) | (commandssim_cs_high[4:0] == 2'd2)))) begin
				commandssim_commandssim_cond11 <= 1'd1;
				commandssim_commandssim_matched4 <= 1'd1;
				commandssim_cas1_fsm2_next_value0 <= commandssim_cs_high[4:0];
				commandssim_cas1_fsm2_next_value_ce0 <= 1'd1;
				commandssim_bank2_fsm2_next_value1 <= commandssim_cs_low[2:0];
				commandssim_bank2_fsm2_next_value_ce1 <= 1'd1;
				commandssim_col9_fsm2_next_value2 <= commandssim_cs_low[4];
				commandssim_col9_fsm2_next_value_ce2 <= 1'd1;
				commandssim_burst_len_fsm2_next_value3 <= commandssim_cs_high[5];
				commandssim_burst_len_fsm2_next_value_ce3 <= 1'd1;
				commandssim_auto_precharge_fsm2_next_value4 <= commandssim_cs_low[5];
				commandssim_auto_precharge_fsm2_next_value_ce4 <= 1'd1;
				fsm2_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_15 <= dummy_s;
// synthesis translate_on
end
assign commandssim_tinit0_ready0 = ((commandssim_tinit0_triggered & commandssim_tinit0_ready1) | (1'd0 & commandssim_tinit0_trigger));
assign commandssim_tinit0_ready_p = ((((~commandssim_tinit0_cond_d0) & commandssim_tinit0_ready0) | (1'd0 & ((~commandssim_tinit0_cond_d1) & commandssim_tinit0_trigger))) | (1'd0 & ((~commandssim_tinit0_cond_d2) & commandssim_tinit0_trigger_d)));
assign commandssim_tinit0_valid = ((~commandssim_tinit0_cond_d3) & commandssim_tinit0_trigger);
assign commandssim_tinit0_ready1 = (commandssim_tinit0_ready_reg | commandssim_tinit0_ready2);
assign commandssim_tinit0_ready2 = (1'd0 & commandssim_tinit0_valid);
assign commandssim_tinit1_ready0 = ((commandssim_tinit1_triggered & commandssim_tinit1_ready1) | (1'd0 & commandssim_tinit1_trigger));
assign commandssim_tinit1_ready_p = ((((~commandssim_tinit1_cond_d0) & commandssim_tinit1_ready0) | (1'd0 & ((~commandssim_tinit1_cond_d1) & commandssim_tinit1_trigger))) | (1'd0 & ((~commandssim_tinit1_cond_d2) & commandssim_tinit1_trigger_d)));
assign commandssim_tinit1_valid = ((~commandssim_tinit1_cond_d3) & commandssim_tinit1_trigger);
assign commandssim_tinit1_ready1 = (commandssim_tinit1_ready_reg | commandssim_tinit1_ready2);
assign commandssim_tinit1_ready2 = (1'd0 & commandssim_tinit1_valid);
assign commandssim_tinit2_ready0 = ((commandssim_tinit2_triggered & commandssim_tinit2_ready1) | (1'd0 & commandssim_tinit2_trigger));
assign commandssim_tinit2_ready_p = ((((~commandssim_tinit2_cond_d0) & commandssim_tinit2_ready0) | (1'd0 & ((~commandssim_tinit2_cond_d1) & commandssim_tinit2_trigger))) | (1'd0 & ((~commandssim_tinit2_cond_d2) & commandssim_tinit2_trigger_d)));
assign commandssim_tinit2_valid = ((~commandssim_tinit2_cond_d3) & commandssim_tinit2_trigger);
assign commandssim_tinit2_ready1 = (commandssim_tinit2_ready_reg | commandssim_tinit2_ready2);
assign commandssim_tinit2_ready2 = (1'd0 & commandssim_tinit2_valid);
assign commandssim_tinit3_ready0 = ((commandssim_tinit3_triggered & commandssim_tinit3_ready1) | (1'd0 & commandssim_tinit3_trigger));
assign commandssim_tinit3_ready_p = ((((~commandssim_tinit3_cond_d0) & commandssim_tinit3_ready0) | (1'd0 & ((~commandssim_tinit3_cond_d1) & commandssim_tinit3_trigger))) | (1'd0 & ((~commandssim_tinit3_cond_d2) & commandssim_tinit3_trigger_d)));
assign commandssim_tinit3_valid = ((~commandssim_tinit3_cond_d3) & commandssim_tinit3_trigger);
assign commandssim_tinit3_ready1 = (commandssim_tinit3_ready_reg | commandssim_tinit3_ready2);
assign commandssim_tinit3_ready2 = (1'd0 & commandssim_tinit3_valid);
assign commandssim_tinit4_ready0 = ((commandssim_tinit4_triggered & commandssim_tinit4_ready1) | (1'd0 & commandssim_tinit4_trigger));
assign commandssim_tinit4_ready_p = ((((~commandssim_tinit4_cond_d0) & commandssim_tinit4_ready0) | (1'd0 & ((~commandssim_tinit4_cond_d1) & commandssim_tinit4_trigger))) | (1'd0 & ((~commandssim_tinit4_cond_d2) & commandssim_tinit4_trigger_d)));
assign commandssim_tinit4_valid = ((~commandssim_tinit4_cond_d3) & commandssim_tinit4_trigger);
assign commandssim_tinit4_ready1 = (commandssim_tinit4_ready_reg | commandssim_tinit4_ready2);
assign commandssim_tinit4_ready2 = (1'd0 & commandssim_tinit4_valid);
assign commandssim_tinit5_ready0 = ((commandssim_tinit5_triggered & commandssim_tinit5_ready1) | (1'd0 & commandssim_tinit5_trigger));
assign commandssim_tinit5_ready_p = ((((~commandssim_tinit5_cond_d0) & commandssim_tinit5_ready0) | (1'd0 & ((~commandssim_tinit5_cond_d1) & commandssim_tinit5_trigger))) | (1'd0 & ((~commandssim_tinit5_cond_d2) & commandssim_tinit5_trigger_d)));
assign commandssim_tinit5_valid = ((~commandssim_tinit5_cond_d3) & commandssim_tinit5_trigger);
assign commandssim_tinit5_ready1 = (commandssim_tinit5_ready_reg | commandssim_tinit5_ready2);
assign commandssim_tinit5_ready2 = (1'd0 & commandssim_tinit5_valid);
assign commandssim_tzqcal_ready0 = ((commandssim_tzqcal_triggered & commandssim_tzqcal_ready1) | (1'd0 & commandssim_tzqcal_trigger));
assign commandssim_tzqcal_ready_p = ((((~commandssim_tzqcal_cond_d0) & commandssim_tzqcal_ready0) | (1'd0 & ((~commandssim_tzqcal_cond_d1) & commandssim_tzqcal_trigger))) | (1'd0 & ((~commandssim_tzqcal_cond_d2) & commandssim_tzqcal_trigger_d)));
assign commandssim_tzqcal_valid = ((~commandssim_tzqcal_cond_d3) & commandssim_tzqcal_trigger);
assign commandssim_tzqcal_ready1 = (commandssim_tzqcal_ready_reg | commandssim_tzqcal_ready2);
assign commandssim_tzqcal_ready2 = (1'd0 & commandssim_tzqcal_valid);
assign commandssim_tzqlat_ready0 = ((commandssim_tzqlat_triggered & commandssim_tzqlat_ready1) | (1'd0 & commandssim_tzqlat_trigger));
assign commandssim_tzqlat_ready_p = ((((~commandssim_tzqlat_cond_d0) & commandssim_tzqlat_ready0) | (1'd0 & ((~commandssim_tzqlat_cond_d1) & commandssim_tzqlat_trigger))) | (1'd0 & ((~commandssim_tzqlat_cond_d2) & commandssim_tzqlat_trigger_d)));
assign commandssim_tzqlat_valid = ((~commandssim_tzqlat_cond_d3) & commandssim_tzqlat_trigger);
assign commandssim_tzqlat_ready1 = (commandssim_tzqlat_ready_reg | commandssim_tzqlat_ready2);
assign commandssim_tzqlat_ready2 = (1'd0 & commandssim_tzqlat_valid);
assign commandssim_tpw_reset_ready0 = ((commandssim_tpw_reset_triggered & commandssim_tpw_reset_ready1) | (1'd0 & commandssim_tpw_reset_trigger));
assign commandssim_tpw_reset_ready_p = ((((~commandssim_tpw_reset_cond_d0) & commandssim_tpw_reset_ready0) | (1'd0 & ((~commandssim_tpw_reset_cond_d1) & commandssim_tpw_reset_trigger))) | (1'd0 & ((~commandssim_tpw_reset_cond_d2) & commandssim_tpw_reset_trigger_d)));
assign commandssim_tpw_reset_valid = ((~commandssim_tpw_reset_cond_d3) & commandssim_tpw_reset_trigger);
assign commandssim_tpw_reset_ready1 = (commandssim_tpw_reset_ready_reg | commandssim_tpw_reset_ready2);
assign commandssim_tpw_reset_ready2 = (1'd0 & commandssim_tpw_reset_valid);

// synthesis translate_off
reg dummy_d_16;
// synthesis translate_on
always @(*) begin
	commandssim_cmds_enabled <= 1'd0;
	commandssim_tinit5_trigger <= 1'd0;
	commandssim_tzqcal_trigger <= 1'd0;
	commandssim_tzqlat_trigger <= 1'd0;
	commandssim_simlogger_cond24 <= 1'd0;
	commandssim_simlogger_cond25 <= 1'd0;
	commandssim_simlogger_cond26 <= 1'd0;
	commandssim_simlogger_cond27 <= 1'd0;
	commandssim_simlogger_cond28 <= 1'd0;
	commandssim_simlogger_cond29 <= 1'd0;
	commandssim_next_state <= 3'd0;
	commandssim_next_state <= commandssim_state;
	case (commandssim_state)
		1'd1: begin
			commandssim_tinit5_trigger <= 1'd1;
			if ((commandssim_tinit5_ready_p | 1'd0)) begin
				commandssim_next_state <= 2'd2;
			end
		end
		2'd2: begin
			commandssim_cmds_enabled <= 1'd1;
			if (((commandssim_handle_cmd & (~commandssim_commandssim_matched0)) & (~commandssim_commandssim_matched5))) begin
				commandssim_simlogger_cond24 <= 1'd1;
				commandssim_simlogger_cond25 <= 1'd1;
			end
			if (commandssim_commandssim_matched5) begin
				if ((commandssim_mpc_op != 7'd79)) begin
					commandssim_simlogger_cond26 <= 1'd1;
				end else begin
					commandssim_next_state <= 2'd3;
				end
			end
		end
		2'd3: begin
			commandssim_tzqcal_trigger <= 1'd1;
			commandssim_cmds_enabled <= 1'd1;
			if (commandssim_handle_cmd) begin
				if ((~(commandssim_commandssim_matched5 & (commandssim_mpc_op == 7'd81)))) begin
					commandssim_simlogger_cond27 <= 1'd1;
				end else begin
					if ((1'd1 & (~commandssim_tzqcal_ready0))) begin
						commandssim_simlogger_cond28 <= 1'd1;
					end
					commandssim_next_state <= 3'd4;
				end
			end
		end
		3'd4: begin
			commandssim_cmds_enabled <= 1'd1;
			commandssim_tzqlat_trigger <= 1'd1;
			if (((1'd1 & commandssim_handle_cmd) & (~commandssim_tzqlat_ready0))) begin
				commandssim_simlogger_cond29 <= 1'd1;
			end
		end
		default: begin
			if ((commandssim_tinit3_ready_p | 1'd0)) begin
				commandssim_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_16 <= dummy_s;
// synthesis translate_on
end
assign write = ((commandssim_data_en_tappeddelayline_tappeddelayline3 & source_source_valid) & source_source_payload_we);
assign read = ((commandssim_data_en_tappeddelayline_tappeddelayline6 & source_source_valid) & (~source_source_payload_we));
assign source_source_ready = (write | read);
assign dqwrite_masked0 = (write & source_source_payload_masked);
assign dqwrite_trigger = write;
assign dqread_trigger = read;
assign dqswrite_trigger = write;
assign dqsread_trigger = read;
assign log_time_ps = (log_cnt * 8'd234);
assign log_level = simlogger_storage;
assign dqwrite_col_burst = (col + dqwrite_burst_counter);
assign dqwrite_addr = ((row * 11'd1024) + dqwrite_col_burst);
assign dqwrite_time_ps = (dqwrite_cnt * 8'd234);
assign dqwrite_level = dqwrite_storage;
assign dqread_col_burst = (col + dqread_burst_counter);
assign dqread_addr = ((row * 11'd1024) + dqread_col_burst);
assign dqread_time_ps = (dqread_cnt * 8'd234);
assign dqread_level = dqread_storage;

// synthesis translate_off
reg dummy_d_17;
// synthesis translate_on
always @(*) begin
	lpddr4simulationpads_dq_i <= 16'd0;
	memory0_adr <= 25'd0;
	memory0_we <= 2'd0;
	memory0_dat_w <= 16'd0;
	memory1_adr <= 25'd0;
	memory1_we <= 2'd0;
	memory1_dat_w <= 16'd0;
	memory2_adr <= 25'd0;
	memory2_we <= 2'd0;
	memory2_dat_w <= 16'd0;
	memory3_adr <= 25'd0;
	memory3_we <= 2'd0;
	memory3_dat_w <= 16'd0;
	memory4_adr <= 25'd0;
	memory4_we <= 2'd0;
	memory4_dat_w <= 16'd0;
	memory5_adr <= 25'd0;
	memory5_we <= 2'd0;
	memory5_dat_w <= 16'd0;
	memory6_adr <= 25'd0;
	memory6_we <= 2'd0;
	memory6_dat_w <= 16'd0;
	memory7_adr <= 25'd0;
	memory7_we <= 2'd0;
	memory7_dat_w <= 16'd0;
	dqwrite_cond <= 1'd0;
	dqread_cond <= 1'd0;
	dqwrite_next_state <= 1'd0;
	dqwrite_burst_counter_clockdomainsrenamer0_next_value0 <= 4'd0;
	dqwrite_burst_counter_clockdomainsrenamer0_next_value_ce0 <= 1'd0;
	dqwrite_masked1_clockdomainsrenamer0_next_value1 <= 1'd0;
	dqwrite_masked1_clockdomainsrenamer0_next_value_ce1 <= 1'd0;
	dqread_next_state <= 1'd0;
	dqread_burst_counter_clockdomainsrenamer1_next_value <= 4'd0;
	dqread_burst_counter_clockdomainsrenamer1_next_value_ce <= 1'd0;
	comb_t_array_muxed <= 2'd0;
	comb_f_array_muxed <= 2'd0;
	comb_lhs_array_muxed0 <= 25'd0;
	comb_lhs_array_muxed1 <= 16'd0;
	comb_lhs_array_muxed2 <= 2'd0;
	comb_lhs_array_muxed3 <= 25'd0;
	dqwrite_next_state <= dqwrite_state;
	case (dqwrite_state)
		1'd1: begin
			dqwrite_cond <= 1'd1;
			if (dqwrite_masked1) begin
				comb_t_array_muxed <= (~lpddr4simulationpads2);
				case (bank)
					1'd0: begin
						memory0_we <= comb_t_array_muxed;
					end
					1'd1: begin
						memory1_we <= comb_t_array_muxed;
					end
					2'd2: begin
						memory2_we <= comb_t_array_muxed;
					end
					2'd3: begin
						memory3_we <= comb_t_array_muxed;
					end
					3'd4: begin
						memory4_we <= comb_t_array_muxed;
					end
					3'd5: begin
						memory5_we <= comb_t_array_muxed;
					end
					3'd6: begin
						memory6_we <= comb_t_array_muxed;
					end
					default: begin
						memory7_we <= comb_t_array_muxed;
					end
				endcase
			end else begin
				comb_f_array_muxed <= 2'd3;
				case (bank)
					1'd0: begin
						memory0_we <= comb_f_array_muxed;
					end
					1'd1: begin
						memory1_we <= comb_f_array_muxed;
					end
					2'd2: begin
						memory2_we <= comb_f_array_muxed;
					end
					2'd3: begin
						memory3_we <= comb_f_array_muxed;
					end
					3'd4: begin
						memory4_we <= comb_f_array_muxed;
					end
					3'd5: begin
						memory5_we <= comb_f_array_muxed;
					end
					3'd6: begin
						memory6_we <= comb_f_array_muxed;
					end
					default: begin
						memory7_we <= comb_f_array_muxed;
					end
				endcase
			end
			comb_lhs_array_muxed0 <= dqwrite_addr;
			case (bank)
				1'd0: begin
					memory0_adr <= comb_lhs_array_muxed0;
				end
				1'd1: begin
					memory1_adr <= comb_lhs_array_muxed0;
				end
				2'd2: begin
					memory2_adr <= comb_lhs_array_muxed0;
				end
				2'd3: begin
					memory3_adr <= comb_lhs_array_muxed0;
				end
				3'd4: begin
					memory4_adr <= comb_lhs_array_muxed0;
				end
				3'd5: begin
					memory5_adr <= comb_lhs_array_muxed0;
				end
				3'd6: begin
					memory6_adr <= comb_lhs_array_muxed0;
				end
				default: begin
					memory7_adr <= comb_lhs_array_muxed0;
				end
			endcase
			comb_lhs_array_muxed1 <= lpddr4simulationpads0;
			case (bank)
				1'd0: begin
					memory0_dat_w <= comb_lhs_array_muxed1;
				end
				1'd1: begin
					memory1_dat_w <= comb_lhs_array_muxed1;
				end
				2'd2: begin
					memory2_dat_w <= comb_lhs_array_muxed1;
				end
				2'd3: begin
					memory3_dat_w <= comb_lhs_array_muxed1;
				end
				3'd4: begin
					memory4_dat_w <= comb_lhs_array_muxed1;
				end
				3'd5: begin
					memory5_dat_w <= comb_lhs_array_muxed1;
				end
				3'd6: begin
					memory6_dat_w <= comb_lhs_array_muxed1;
				end
				default: begin
					memory7_dat_w <= comb_lhs_array_muxed1;
				end
			endcase
			dqwrite_burst_counter_clockdomainsrenamer0_next_value0 <= (dqwrite_burst_counter + 1'd1);
			dqwrite_burst_counter_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
			if ((dqwrite_burst_counter == 4'd15)) begin
				dqwrite_next_state <= 1'd0;
			end
		end
		default: begin
			dqwrite_burst_counter_clockdomainsrenamer0_next_value0 <= 1'd0;
			dqwrite_burst_counter_clockdomainsrenamer0_next_value_ce0 <= 1'd1;
			if (dqwrite_trigger) begin
				dqwrite_masked1_clockdomainsrenamer0_next_value1 <= dqwrite_masked0;
				dqwrite_masked1_clockdomainsrenamer0_next_value_ce1 <= 1'd1;
				dqwrite_next_state <= 1'd1;
			end
		end
	endcase
	dqread_next_state <= dqread_state;
	case (dqread_state)
		1'd1: begin
			dqread_cond <= 1'd1;
			comb_lhs_array_muxed2 <= 1'd0;
			case (bank)
				1'd0: begin
					memory0_we <= comb_lhs_array_muxed2;
				end
				1'd1: begin
					memory1_we <= comb_lhs_array_muxed2;
				end
				2'd2: begin
					memory2_we <= comb_lhs_array_muxed2;
				end
				2'd3: begin
					memory3_we <= comb_lhs_array_muxed2;
				end
				3'd4: begin
					memory4_we <= comb_lhs_array_muxed2;
				end
				3'd5: begin
					memory5_we <= comb_lhs_array_muxed2;
				end
				3'd6: begin
					memory6_we <= comb_lhs_array_muxed2;
				end
				default: begin
					memory7_we <= comb_lhs_array_muxed2;
				end
			endcase
			comb_lhs_array_muxed3 <= dqread_addr;
			case (bank)
				1'd0: begin
					memory0_adr <= comb_lhs_array_muxed3;
				end
				1'd1: begin
					memory1_adr <= comb_lhs_array_muxed3;
				end
				2'd2: begin
					memory2_adr <= comb_lhs_array_muxed3;
				end
				2'd3: begin
					memory3_adr <= comb_lhs_array_muxed3;
				end
				3'd4: begin
					memory4_adr <= comb_lhs_array_muxed3;
				end
				3'd5: begin
					memory5_adr <= comb_lhs_array_muxed3;
				end
				3'd6: begin
					memory6_adr <= comb_lhs_array_muxed3;
				end
				default: begin
					memory7_adr <= comb_lhs_array_muxed3;
				end
			endcase
			lpddr4simulationpads_dq_i <= comb_rhs_array_muxed;
			dqread_burst_counter_clockdomainsrenamer1_next_value <= (dqread_burst_counter + 1'd1);
			dqread_burst_counter_clockdomainsrenamer1_next_value_ce <= 1'd1;
			if ((dqread_burst_counter == 4'd15)) begin
				dqread_next_state <= 1'd0;
			end
		end
		default: begin
			dqread_burst_counter_clockdomainsrenamer1_next_value <= 1'd0;
			dqread_burst_counter_clockdomainsrenamer1_next_value_ce <= 1'd1;
			if (dqread_trigger) begin
				dqread_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_17 <= dummy_s;
// synthesis translate_on
end
assign dqswrite_time_ps = (dqswrite_cnt * 8'd234);
assign dqswrite_level = dqswrite_storage;

// synthesis translate_off
reg dummy_d_18;
// synthesis translate_on
always @(*) begin
	dqswrite_dqs0 <= 1'd0;
	dqswrite_cond <= 1'd0;
	dqswrite_next_state <= 1'd0;
	dqswrite_burst_counter_clockdomainsrenamer2_next_value <= 4'd0;
	dqswrite_burst_counter_clockdomainsrenamer2_next_value_ce <= 1'd0;
	dqswrite_next_state <= dqswrite_state;
	case (dqswrite_state)
		1'd1: begin
			dqswrite_dqs0 <= lpddr4simulationpads1[0];
			if ((lpddr4simulationpads1[0] != dqswrite_burst_counter[0])) begin
				dqswrite_cond <= 1'd1;
			end
			dqswrite_burst_counter_clockdomainsrenamer2_next_value <= (dqswrite_burst_counter + 1'd1);
			dqswrite_burst_counter_clockdomainsrenamer2_next_value_ce <= 1'd1;
			if ((dqswrite_burst_counter == 4'd15)) begin
				dqswrite_next_state <= 1'd0;
			end
		end
		default: begin
			dqswrite_burst_counter_clockdomainsrenamer2_next_value <= 1'd0;
			dqswrite_burst_counter_clockdomainsrenamer2_next_value_ce <= 1'd1;
			if (dqswrite_trigger) begin
				dqswrite_next_state <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d_18 <= dummy_s;
// synthesis translate_on
end
assign dqsread_time_ps = (dqsread_cnt * 8'd234);
assign dqsread_level = dqsread_storage;

// synthesis translate_off
reg dummy_d_19;
// synthesis translate_on
always @(*) begin
	lpddr4simulationpads_dqs_i <= 2'd0;
	dqsread_next_state <= 1'd0;
	dqsread_burst_counter_clockdomainsrenamer3_next_value <= 4'd0;
	dqsread_burst_counter_clockdomainsrenamer3_next_value_ce <= 1'd0;
	dqsread_next_state <= dqsread_state;
	case (dqsread_state)
		1'd1: begin
			lpddr4simulationpads_dqs_i[0] <= dqsread_burst_counter[0];
			lpddr4simulationpads_dqs_i[1] <= dqsread_burst_counter[0];
			dqsread_burst_counter_clockdomainsrenamer3_next_value <= (dqsread_burst_counter + 1'd1);
			dqsread_burst_counter_clockdomainsrenamer3_next_value_ce <= 1'd1;
			if ((dqsread_burst_counter == 4'd15)) begin
				dqsread_next_state <= 1'd0;
			end
		end
		default: begin
			dqsread_burst_counter_clockdomainsrenamer3_next_value <= 1'd0;
			dqsread_burst_counter_clockdomainsrenamer3_next_value_ce <= 1'd1;
			if (dqsread_trigger) begin
				dqsread_next_state <= 1'd1;
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
	comb_t_basiclowerer_array_muxed0 <= 1'd0;
	case (commandssim_bank0)
		1'd0: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim64;
		end
		1'd1: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim65;
		end
		2'd2: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim66;
		end
		2'd3: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim67;
		end
		3'd4: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim68;
		end
		3'd5: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim69;
		end
		3'd6: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim70;
		end
		default: begin
			comb_t_basiclowerer_array_muxed0 <= commandssim71;
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
	comb_t_rhs_array_muxed <= 17'd0;
	case (commandssim_bank2)
		1'd0: begin
			comb_t_rhs_array_muxed <= commandssim72;
		end
		1'd1: begin
			comb_t_rhs_array_muxed <= commandssim73;
		end
		2'd2: begin
			comb_t_rhs_array_muxed <= commandssim74;
		end
		2'd3: begin
			comb_t_rhs_array_muxed <= commandssim75;
		end
		3'd4: begin
			comb_t_rhs_array_muxed <= commandssim76;
		end
		3'd5: begin
			comb_t_rhs_array_muxed <= commandssim77;
		end
		3'd6: begin
			comb_t_rhs_array_muxed <= commandssim78;
		end
		default: begin
			comb_t_rhs_array_muxed <= commandssim79;
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
	comb_t_basiclowerer_array_muxed1 <= 1'd0;
	case (commandssim_bank2)
		1'd0: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim64;
		end
		1'd1: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim65;
		end
		2'd2: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim66;
		end
		2'd3: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim67;
		end
		3'd4: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim68;
		end
		3'd5: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim69;
		end
		3'd6: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim70;
		end
		default: begin
			comb_t_basiclowerer_array_muxed1 <= commandssim71;
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
	comb_rhs_array_muxed <= 16'd0;
	case (bank)
		1'd0: begin
			comb_rhs_array_muxed <= memory0_dat_r;
		end
		1'd1: begin
			comb_rhs_array_muxed <= memory1_dat_r;
		end
		2'd2: begin
			comb_rhs_array_muxed <= memory2_dat_r;
		end
		2'd3: begin
			comb_rhs_array_muxed <= memory3_dat_r;
		end
		3'd4: begin
			comb_rhs_array_muxed <= memory4_dat_r;
		end
		3'd5: begin
			comb_rhs_array_muxed <= memory5_dat_r;
		end
		3'd6: begin
			comb_rhs_array_muxed <= memory6_dat_r;
		end
		default: begin
			comb_rhs_array_muxed <= memory7_dat_r;
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
	sync_basiclowerer_array_muxed <= 1'd0;
	case (commandssim_bank1)
		1'd0: begin
			sync_basiclowerer_array_muxed <= commandssim64;
		end
		1'd1: begin
			sync_basiclowerer_array_muxed <= commandssim65;
		end
		2'd2: begin
			sync_basiclowerer_array_muxed <= commandssim66;
		end
		2'd3: begin
			sync_basiclowerer_array_muxed <= commandssim67;
		end
		3'd4: begin
			sync_basiclowerer_array_muxed <= commandssim68;
		end
		3'd5: begin
			sync_basiclowerer_array_muxed <= commandssim69;
		end
		3'd6: begin
			sync_basiclowerer_array_muxed <= commandssim70;
		end
		default: begin
			sync_basiclowerer_array_muxed <= commandssim71;
		end
	endcase
// synthesis translate_off
	dummy_d_24 <= dummy_s;
// synthesis translate_on
end
assign cdc_produce_rdomain = multiregimpl0_regs1;
assign cdc_consume_wdomain = multiregimpl1_regs1;

always @(posedge sys8x_90_clk) begin
	cdc_graycounter0_q_binary <= cdc_graycounter0_q_next_binary;
	cdc_graycounter0_q <= cdc_graycounter0_q_next;
	if ((commandssim_handle_cmd & (commandssim_cs_high[4:0] == 5'd16))) begin
		if (commandssim_cs_high[5]) begin
			commandssim64 <= 1'd0;
			commandssim65 <= 1'd0;
			commandssim66 <= 1'd0;
			commandssim67 <= 1'd0;
			commandssim68 <= 1'd0;
			commandssim69 <= 1'd0;
			commandssim70 <= 1'd0;
			commandssim71 <= 1'd0;
		end else begin
			sync_lhs_array_muxed = 1'd0;
			case (commandssim_bank1)
				1'd0: begin
					commandssim64 <= sync_lhs_array_muxed;
				end
				1'd1: begin
					commandssim65 <= sync_lhs_array_muxed;
				end
				2'd2: begin
					commandssim66 <= sync_lhs_array_muxed;
				end
				2'd3: begin
					commandssim67 <= sync_lhs_array_muxed;
				end
				3'd4: begin
					commandssim68 <= sync_lhs_array_muxed;
				end
				3'd5: begin
					commandssim69 <= sync_lhs_array_muxed;
				end
				3'd6: begin
					commandssim70 <= sync_lhs_array_muxed;
				end
				default: begin
					commandssim71 <= sync_lhs_array_muxed;
				end
			endcase
			if ((~sync_basiclowerer_array_muxed)) begin
				commandssim_simlogger_cond6 <= 1'd1;
			end
		end
	end
	commandssim_cnt <= (commandssim_cnt + 1'd1);
	commandssim_simlogger_cond_d0 <= commandssim_simlogger_cond0;
	commandssim_commandssim_cond_d0 <= commandssim_commandssim_cond0;
	commandssim_commandssim_cond_d1 <= commandssim_commandssim_cond1;
	commandssim_commandssim_cond_d2 <= commandssim_commandssim_cond2;
	commandssim_simlogger_cond_d1 <= commandssim_simlogger_cond1;
	commandssim_commandssim_cond_d3 <= commandssim_commandssim_cond3;
	commandssim_simlogger_cond_d2 <= commandssim_simlogger_cond2;
	commandssim_simlogger_cond_d3 <= commandssim_simlogger_cond3;
	commandssim_commandssim_cond_d4 <= commandssim_commandssim_cond4;
	commandssim_commandssim_cond_d5 <= commandssim_commandssim_cond5;
	commandssim_commandssim_cond_d6 <= commandssim_commandssim_cond6;
	commandssim_simlogger_cond_d4 <= commandssim_simlogger_cond4;
	commandssim_simlogger_cond_d5 <= commandssim_simlogger_cond5;
	commandssim_simlogger_cond_d6 <= commandssim_simlogger_cond6;
	commandssim_commandssim_cond_d7 <= commandssim_commandssim_cond7;
	commandssim_commandssim_cond_d8 <= commandssim_commandssim_cond8;
	commandssim_commandssim_cond_d9 <= commandssim_commandssim_cond9;
	commandssim_commandssim_cond_d10 <= commandssim_commandssim_cond10;
	commandssim_simlogger_cond_d7 <= commandssim_simlogger_cond7;
	commandssim_simlogger_cond_d8 <= commandssim_simlogger_cond8;
	commandssim_simlogger_cond_d9 <= commandssim_simlogger_cond9;
	commandssim_simlogger_cond_d10 <= commandssim_simlogger_cond10;
	commandssim_simlogger_cond_d11 <= commandssim_simlogger_cond11;
	commandssim_simlogger_cond_d12 <= commandssim_simlogger_cond12;
	commandssim_commandssim_cond_d11 <= commandssim_commandssim_cond11;
	commandssim_commandssim_cond_d12 <= commandssim_commandssim_cond12;
	commandssim_commandssim_cond_d13 <= commandssim_commandssim_cond13;
	commandssim_cases_cond_d0 <= commandssim_cases_cond0;
	commandssim_cases_cond_d1 <= commandssim_cases_cond1;
	commandssim_cases_cond_d2 <= commandssim_cases_cond2;
	commandssim_cases_cond_d3 <= commandssim_cases_cond3;
	commandssim_cases_cond_d4 <= commandssim_cases_cond4;
	commandssim_cases_cond_d5 <= commandssim_cases_cond5;
	commandssim_cases_cond_d6 <= commandssim_cases_cond6;
	commandssim_cases_cond_d7 <= commandssim_cases_cond7;
	commandssim_simlogger_cond_d13 <= commandssim_simlogger_cond13;
	commandssim_simlogger_cond_d14 <= commandssim_simlogger_cond14;
	commandssim_commandssim_cond_d14 <= commandssim_commandssim_cond14;
	commandssim_simlogger_cond_d15 <= commandssim_simlogger_cond15;
	commandssim_simlogger_cond_d16 <= commandssim_simlogger_cond16;
	commandssim_simlogger_cond_d17 <= commandssim_simlogger_cond17;
	commandssim_simlogger_cond_d18 <= commandssim_simlogger_cond18;
	commandssim_simlogger_cond_d19 <= commandssim_simlogger_cond19;
	commandssim_simlogger_cond_d20 <= commandssim_simlogger_cond20;
	commandssim_simlogger_cond_d21 <= commandssim_simlogger_cond21;
	commandssim_simlogger_cond_d22 <= commandssim_simlogger_cond22;
	commandssim_simlogger_cond_d23 <= commandssim_simlogger_cond23;
	commandssim_simlogger_cond_d24 <= commandssim_simlogger_cond24;
	commandssim_simlogger_cond_d25 <= commandssim_simlogger_cond25;
	commandssim_simlogger_cond_d26 <= commandssim_simlogger_cond26;
	commandssim_simlogger_cond_d27 <= commandssim_simlogger_cond27;
	commandssim_simlogger_cond_d28 <= commandssim_simlogger_cond28;
	commandssim_simlogger_cond_d29 <= commandssim_simlogger_cond29;
	commandssim_commandssim_cond_d15 <= commandssim_commandssim_cond15;
	commandssim_commandssim_cond_d16 <= commandssim_commandssim_cond16;
	commandssim_commandssim_cond_d17 <= commandssim_commandssim_cond17;
	commandssim_commandssim_cond_d18 <= commandssim_commandssim_cond18;
	commandssim_commandssim_cond_d19 <= commandssim_commandssim_cond19;
	commandssim_commandssim_cond_d20 <= commandssim_commandssim_cond20;
	commandssim_commandssim_cond_d21 <= commandssim_commandssim_cond21;
	commandssim_commandssim_cond_d22 <= commandssim_commandssim_cond22;
	commandssim_commandssim_cond_d23 <= commandssim_commandssim_cond23;
	commandssim_commandssim_cond_d24 <= commandssim_commandssim_cond24;
	commandssim_commandssim_cond_d25 <= commandssim_commandssim_cond25;
	commandssim_commandssim_cond_d26 <= commandssim_commandssim_cond26;
	commandssim_commandssim_cond_d27 <= commandssim_commandssim_cond27;
	commandssim_commandssim_cond_d28 <= commandssim_commandssim_cond28;
	commandssim_commandssim_cond_d29 <= commandssim_commandssim_cond29;
	commandssim_commandssim_cond_d30 <= commandssim_commandssim_cond30;
	commandssim_commandssim_cond_d31 <= commandssim_commandssim_cond31;
	commandssim_commandssim_cond_d32 <= commandssim_commandssim_cond32;
	commandssim_commandssim_cond_d33 <= commandssim_commandssim_cond33;
	commandssim_commandssim_cond_d34 <= commandssim_commandssim_cond34;
	commandssim_commandssim_cond_d35 <= commandssim_commandssim_cond35;
	commandssim_commandssim_cond_d36 <= commandssim_commandssim_cond36;
	commandssim_commandssim_cond_d37 <= commandssim_commandssim_cond37;
	commandssim_commandssim_cond_d38 <= commandssim_commandssim_cond38;
	commandssim_commandssim_cond_d39 <= commandssim_commandssim_cond39;
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d0) & commandssim_simlogger_cond0))) begin
		$display("[%16d ps] [INFO] MRW: MR[%d] = 0x%02x", commandssim_time_ps, commandssim_ma, commandssim_op);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d0) & commandssim_commandssim_cond0))) begin
		$display("[%16d ps] [DEBUG] MRW-1", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d1) & commandssim_commandssim_cond1))) begin
		$display("[%16d ps] [DEBUG] MRW-2", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_commandssim_cond_d2) & commandssim_commandssim_cond2))) begin
		$display("[%16d ps] [ERROR] Waiting for MRW-2 but got unexpected cs_high=0b%06b cs_low=0b%06b", commandssim_time_ps, commandssim_cs_high, commandssim_cs_low);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d1) & commandssim_simlogger_cond1))) begin
		$display("[%16d ps] [ERROR] Not all banks precharged during REFRESH", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d3) & commandssim_commandssim_cond3))) begin
		$display("[%16d ps] [DEBUG] REFRESH", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d2) & commandssim_simlogger_cond2))) begin
		$display("[%16d ps] [INFO] ACT: bank=%d row=%d", commandssim_time_ps, commandssim_bank0, commandssim_row0);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d3) & commandssim_simlogger_cond3))) begin
		$display("[%16d ps] [ERROR] ACT on already active bank: bank=%d row=%d", commandssim_time_ps, commandssim_bank0, commandssim_row0);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d4) & commandssim_commandssim_cond4))) begin
		$display("[%16d ps] [DEBUG] ACTIVATE-1", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d5) & commandssim_commandssim_cond5))) begin
		$display("[%16d ps] [DEBUG] ACTIVATE-2", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_commandssim_cond_d6) & commandssim_commandssim_cond6))) begin
		$display("[%16d ps] [ERROR] Waiting for ACTIVATE-2 but got unexpected cs_high=0b%06b cs_low=0b%06b", commandssim_time_ps, commandssim_cs_high, commandssim_cs_low);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d4) & commandssim_simlogger_cond4))) begin
		$display("[%16d ps] [INFO] PRE: all banks", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d5) & commandssim_simlogger_cond5))) begin
		$display("[%16d ps] [INFO] PRE: bank = %d", commandssim_time_ps, commandssim_bank1);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d6) & commandssim_simlogger_cond6))) begin
		$display("[%16d ps] [WARN] PRE on inactive bank: bank=%d", commandssim_time_ps, commandssim_bank1);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d7) & commandssim_commandssim_cond7))) begin
		$display("[%16d ps] [DEBUG] PRECHARGE", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d8) & commandssim_commandssim_cond8))) begin
		$display("[%16d ps] [INFO] WRITE: bank=%d row=%d col=%d", commandssim_time_ps, commandssim_bank2, commandssim_row1_1, commandssim_col);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d9) & commandssim_commandssim_cond9))) begin
		$display("[%16d ps] [INFO] MASKED-WRITE: bank=%d row=%d col=%d", commandssim_time_ps, commandssim_bank2, commandssim_row1_1, commandssim_col);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d10) & commandssim_commandssim_cond10))) begin
		$display("[%16d ps] [INFO] READ: bank=%d row=%d col=%d", commandssim_time_ps, commandssim_bank2, commandssim_row1_1, commandssim_col);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d7) & commandssim_simlogger_cond7))) begin
		$display("[%16d ps] [ERROR] CAS command on inactive bank: bank=%d row=%d col=%d", commandssim_time_ps, commandssim_bank2, commandssim_row1_1, commandssim_col);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d8) & commandssim_simlogger_cond8))) begin
		$display("[%16d ps] [ERROR] WRITE commands must use C[3:2]=0 (must be aligned to full burst)", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d9) & commandssim_simlogger_cond9))) begin
		$display("[%16d ps] [ERROR] DBI currently not supported in the simulator", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d10) & commandssim_simlogger_cond10))) begin
		$display("[%16d ps] [ERROR] MASKED-WRITE but Data Mask operation disabled in MR13[5]", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d11) & commandssim_simlogger_cond11))) begin
		$display("[%16d ps] [INFO] AUTO-PRECHARGE: bank=%d row=%d", commandssim_time_ps, commandssim_bank2, commandssim_row1_1);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d12) & commandssim_simlogger_cond12))) begin
		$display("[%16d ps] [ERROR] Simulator data FIFO overflow", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d11) & commandssim_commandssim_cond11))) begin
		$display("[%16d ps] [DEBUG] CAS-1", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d12) & commandssim_commandssim_cond12))) begin
		$display("[%16d ps] [DEBUG] CAS-2", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_commandssim_cond_d13) & commandssim_commandssim_cond13))) begin
		$display("[%16d ps] [ERROR] Waiting for CAS-2 but got unexpected cs_high=0b%06b cs_low=0b%06b", commandssim_time_ps, commandssim_cs_high, commandssim_cs_low);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d0) & commandssim_cases_cond0))) begin
		$display("[%16d ps] [INFO] MPC: NOP", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d1) & commandssim_cases_cond1))) begin
		$display("[%16d ps] [INFO] MPC: READ_FIFO", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d2) & commandssim_cases_cond2))) begin
		$display("[%16d ps] [INFO] MPC: READ_DQ_CAL", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d3) & commandssim_cases_cond3))) begin
		$display("[%16d ps] [INFO] MPC: WRITE_FIFO", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d4) & commandssim_cases_cond4))) begin
		$display("[%16d ps] [INFO] MPC: START_DQS_OSC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d5) & commandssim_cases_cond5))) begin
		$display("[%16d ps] [INFO] MPC: STOP_DQS_OSC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d6) & commandssim_cases_cond6))) begin
		$display("[%16d ps] [INFO] MPC: ZQC_START", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_cases_cond_d7) & commandssim_cases_cond7))) begin
		$display("[%16d ps] [INFO] MPC: ZQC_LATCH", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d13) & commandssim_simlogger_cond13))) begin
		$display("[%16d ps] [ERROR] Invalid MPC op=0b%07b", commandssim_time_ps, commandssim_mpc_op);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d14) & commandssim_simlogger_cond14))) begin
		$display("[%16d ps] [INFO] MPC: NOOP", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd0) & ((~commandssim_commandssim_cond_d14) & commandssim_commandssim_cond14))) begin
		$display("[%16d ps] [DEBUG] MPC", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d15) & commandssim_simlogger_cond15))) begin
		$display("[%16d ps] [ERROR] Unexpected command: cs_high=0b%06b cs_low=0b%06b", commandssim_time_ps, commandssim_cs_high, commandssim_cs_low);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d16) & commandssim_simlogger_cond16))) begin
		$display("[%16d ps] [INFO] RESET released", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d17) & commandssim_simlogger_cond17))) begin
		$display("[%16d ps] [WARN] tINIT1 violated: RESET deasserted too fast", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d18) & commandssim_simlogger_cond18))) begin
		$display("[%16d ps] [WARN] tINIT2 violated: CKE LOW too short before RESET being released", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d19) & commandssim_simlogger_cond19))) begin
		$display("[%16d ps] [INFO] RESET asserted", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d20) & commandssim_simlogger_cond20))) begin
		$display("[%16d ps] [INFO] CKE falling edge", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d21) & commandssim_simlogger_cond21))) begin
		$display("[%16d ps] [INFO] CKE rising edge", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d22) & commandssim_simlogger_cond22))) begin
		$display("[%16d ps] [WARN] tINIT3 violated: CKE set HIGH too fast after RESET being released", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_simlogger_cond_d23) & commandssim_simlogger_cond23))) begin
		$display("[%16d ps] [INFO] FSM reset", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d24) & commandssim_simlogger_cond24))) begin
		$display("[%16d ps] [WARN] Only MRW/MRR commands expected before ZQ calibration", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d25) & commandssim_simlogger_cond25))) begin
		$display("[%16d ps] [WARN] MRW=%d REF=%d ACT=%d PRE=%d CAS=%d MPC=%d", commandssim_time_ps, commandssim_commandssim_matched0, commandssim_commandssim_matched1, commandssim_commandssim_matched2, commandssim_commandssim_matched3, commandssim_commandssim_matched4, commandssim_commandssim_matched5);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d26) & commandssim_simlogger_cond26))) begin
		$display("[%16d ps] [ERROR] ZQC-START expected, got op=0b%07b", commandssim_time_ps, commandssim_mpc_op);
	end
	if (((commandssim_level <= 2'd3) & ((~commandssim_simlogger_cond_d27) & commandssim_simlogger_cond27))) begin
		$display("[%16d ps] [ERROR] Expected ZQC-LATCH", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d28) & commandssim_simlogger_cond28))) begin
		$display("[%16d ps] [WARN] tZQCAL violated", commandssim_time_ps);
	end
	if (((commandssim_level <= 2'd2) & ((~commandssim_simlogger_cond_d29) & commandssim_simlogger_cond29))) begin
		$display("[%16d ps] [WARN] tZQLAT violated", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d15) & commandssim_commandssim_cond15))) begin
		$display("[%16d ps] [INFO] FSM: RESET -> RESET", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d16) & commandssim_commandssim_cond16))) begin
		$display("[%16d ps] [INFO] FSM: RESET -> EXIT-PD", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d17) & commandssim_commandssim_cond17))) begin
		$display("[%16d ps] [INFO] FSM: RESET -> MRW", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d18) & commandssim_commandssim_cond18))) begin
		$display("[%16d ps] [INFO] FSM: RESET -> ZQC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d19) & commandssim_commandssim_cond19))) begin
		$display("[%16d ps] [INFO] FSM: RESET -> NORMAL", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d20) & commandssim_commandssim_cond20))) begin
		$display("[%16d ps] [INFO] FSM: EXIT-PD -> RESET", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d21) & commandssim_commandssim_cond21))) begin
		$display("[%16d ps] [INFO] FSM: EXIT-PD -> EXIT-PD", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d22) & commandssim_commandssim_cond22))) begin
		$display("[%16d ps] [INFO] FSM: EXIT-PD -> MRW", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d23) & commandssim_commandssim_cond23))) begin
		$display("[%16d ps] [INFO] FSM: EXIT-PD -> ZQC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d24) & commandssim_commandssim_cond24))) begin
		$display("[%16d ps] [INFO] FSM: EXIT-PD -> NORMAL", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d25) & commandssim_commandssim_cond25))) begin
		$display("[%16d ps] [INFO] FSM: MRW -> RESET", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d26) & commandssim_commandssim_cond26))) begin
		$display("[%16d ps] [INFO] FSM: MRW -> EXIT-PD", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d27) & commandssim_commandssim_cond27))) begin
		$display("[%16d ps] [INFO] FSM: MRW -> MRW", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d28) & commandssim_commandssim_cond28))) begin
		$display("[%16d ps] [INFO] FSM: MRW -> ZQC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d29) & commandssim_commandssim_cond29))) begin
		$display("[%16d ps] [INFO] FSM: MRW -> NORMAL", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d30) & commandssim_commandssim_cond30))) begin
		$display("[%16d ps] [INFO] FSM: ZQC -> RESET", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d31) & commandssim_commandssim_cond31))) begin
		$display("[%16d ps] [INFO] FSM: ZQC -> EXIT-PD", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d32) & commandssim_commandssim_cond32))) begin
		$display("[%16d ps] [INFO] FSM: ZQC -> MRW", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d33) & commandssim_commandssim_cond33))) begin
		$display("[%16d ps] [INFO] FSM: ZQC -> ZQC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d34) & commandssim_commandssim_cond34))) begin
		$display("[%16d ps] [INFO] FSM: ZQC -> NORMAL", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d35) & commandssim_commandssim_cond35))) begin
		$display("[%16d ps] [INFO] FSM: NORMAL -> RESET", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d36) & commandssim_commandssim_cond36))) begin
		$display("[%16d ps] [INFO] FSM: NORMAL -> EXIT-PD", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d37) & commandssim_commandssim_cond37))) begin
		$display("[%16d ps] [INFO] FSM: NORMAL -> MRW", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d38) & commandssim_commandssim_cond38))) begin
		$display("[%16d ps] [INFO] FSM: NORMAL -> ZQC", commandssim_time_ps);
	end
	if (((commandssim_level <= 1'd1) & ((~commandssim_commandssim_cond_d39) & commandssim_commandssim_cond39))) begin
		$display("[%16d ps] [INFO] FSM: NORMAL -> NORMAL", commandssim_time_ps);
	end
	commandssim_data_en_tappeddelayline_tappeddelayline0 <= commandssim_data_en_tappeddelayline;
	commandssim_data_en_tappeddelayline_tappeddelayline1 <= commandssim_data_en_tappeddelayline_tappeddelayline0;
	commandssim_data_en_tappeddelayline_tappeddelayline2 <= commandssim_data_en_tappeddelayline_tappeddelayline1;
	commandssim_data_en_tappeddelayline_tappeddelayline3 <= commandssim_data_en_tappeddelayline_tappeddelayline2;
	commandssim_data_en_tappeddelayline_tappeddelayline4 <= commandssim_data_en_tappeddelayline_tappeddelayline3;
	commandssim_data_en_tappeddelayline_tappeddelayline5 <= commandssim_data_en_tappeddelayline_tappeddelayline4;
	commandssim_data_en_tappeddelayline_tappeddelayline6 <= commandssim_data_en_tappeddelayline_tappeddelayline5;
	commandssim_data_en_tappeddelayline_tappeddelayline7 <= commandssim_data_en_tappeddelayline_tappeddelayline6;
	commandssim_data_en_tappeddelayline_tappeddelayline8 <= commandssim_data_en_tappeddelayline_tappeddelayline7;
	commandssim_data_en_tappeddelayline_tappeddelayline9 <= commandssim_data_en_tappeddelayline_tappeddelayline8;
	commandssim_data_en_tappeddelayline_tappeddelayline10 <= commandssim_data_en_tappeddelayline_tappeddelayline9;
	commandssim_data_en_tappeddelayline_tappeddelayline11 <= commandssim_data_en_tappeddelayline_tappeddelayline10;
	commandssim_data_en_tappeddelayline_tappeddelayline12 <= commandssim_data_en_tappeddelayline_tappeddelayline11;
	commandssim_data_en_tappeddelayline_tappeddelayline13 <= commandssim_data_en_tappeddelayline_tappeddelayline12;
	commandssim_data_en_tappeddelayline_tappeddelayline14 <= commandssim_data_en_tappeddelayline_tappeddelayline13;
	commandssim_data_en_tappeddelayline_tappeddelayline15 <= commandssim_data_en_tappeddelayline_tappeddelayline14;
	commandssim_data_en_tappeddelayline_tappeddelayline16 <= commandssim_data_en_tappeddelayline_tappeddelayline15;
	commandssim_data_en_tappeddelayline_tappeddelayline17 <= commandssim_data_en_tappeddelayline_tappeddelayline16;
	commandssim_data_en_tappeddelayline_tappeddelayline18 <= commandssim_data_en_tappeddelayline_tappeddelayline17;
	commandssim_data_en_tappeddelayline_tappeddelayline19 <= commandssim_data_en_tappeddelayline_tappeddelayline18;
	commandssim_cs_tappeddelayline0 <= lpddr4simulationpads_cs;
	commandssim_cs_tappeddelayline1 <= commandssim_cs_tappeddelayline0;
	commandssim_ca_tappeddelayline0 <= lpddr4simulationpads_ca;
	commandssim_ca_tappeddelayline1 <= commandssim_ca_tappeddelayline0;
	fsm0_state <= fsm0_next_state;
	if (commandssim_ma_fsm0_next_value_ce0) begin
		commandssim_ma <= commandssim_ma_fsm0_next_value0;
	end
	if (commandssim_op7_fsm0_next_value_ce1) begin
		commandssim_op7 <= commandssim_op7_fsm0_next_value1;
	end
	if (fsm0_next_value_ce) begin
		sync_array_muxed0 = fsm0_next_value;
		case (commandssim_ma)
			1'd0: begin
				commandssim0 <= sync_array_muxed0;
			end
			1'd1: begin
				commandssim1 <= sync_array_muxed0;
			end
			2'd2: begin
				commandssim2 <= sync_array_muxed0;
			end
			2'd3: begin
				commandssim3 <= sync_array_muxed0;
			end
			3'd4: begin
				commandssim4 <= sync_array_muxed0;
			end
			3'd5: begin
				commandssim5 <= sync_array_muxed0;
			end
			3'd6: begin
				commandssim6 <= sync_array_muxed0;
			end
			3'd7: begin
				commandssim7 <= sync_array_muxed0;
			end
			4'd8: begin
				commandssim8 <= sync_array_muxed0;
			end
			4'd9: begin
				commandssim9 <= sync_array_muxed0;
			end
			4'd10: begin
				commandssim10 <= sync_array_muxed0;
			end
			4'd11: begin
				commandssim11 <= sync_array_muxed0;
			end
			4'd12: begin
				commandssim12 <= sync_array_muxed0;
			end
			4'd13: begin
				commandssim13 <= sync_array_muxed0;
			end
			4'd14: begin
				commandssim14 <= sync_array_muxed0;
			end
			4'd15: begin
				commandssim15 <= sync_array_muxed0;
			end
			5'd16: begin
				commandssim16 <= sync_array_muxed0;
			end
			5'd17: begin
				commandssim17 <= sync_array_muxed0;
			end
			5'd18: begin
				commandssim18 <= sync_array_muxed0;
			end
			5'd19: begin
				commandssim19 <= sync_array_muxed0;
			end
			5'd20: begin
				commandssim20 <= sync_array_muxed0;
			end
			5'd21: begin
				commandssim21 <= sync_array_muxed0;
			end
			5'd22: begin
				commandssim22 <= sync_array_muxed0;
			end
			5'd23: begin
				commandssim23 <= sync_array_muxed0;
			end
			5'd24: begin
				commandssim24 <= sync_array_muxed0;
			end
			5'd25: begin
				commandssim25 <= sync_array_muxed0;
			end
			5'd26: begin
				commandssim26 <= sync_array_muxed0;
			end
			5'd27: begin
				commandssim27 <= sync_array_muxed0;
			end
			5'd28: begin
				commandssim28 <= sync_array_muxed0;
			end
			5'd29: begin
				commandssim29 <= sync_array_muxed0;
			end
			5'd30: begin
				commandssim30 <= sync_array_muxed0;
			end
			5'd31: begin
				commandssim31 <= sync_array_muxed0;
			end
			6'd32: begin
				commandssim32 <= sync_array_muxed0;
			end
			6'd33: begin
				commandssim33 <= sync_array_muxed0;
			end
			6'd34: begin
				commandssim34 <= sync_array_muxed0;
			end
			6'd35: begin
				commandssim35 <= sync_array_muxed0;
			end
			6'd36: begin
				commandssim36 <= sync_array_muxed0;
			end
			6'd37: begin
				commandssim37 <= sync_array_muxed0;
			end
			6'd38: begin
				commandssim38 <= sync_array_muxed0;
			end
			6'd39: begin
				commandssim39 <= sync_array_muxed0;
			end
			6'd40: begin
				commandssim40 <= sync_array_muxed0;
			end
			6'd41: begin
				commandssim41 <= sync_array_muxed0;
			end
			6'd42: begin
				commandssim42 <= sync_array_muxed0;
			end
			6'd43: begin
				commandssim43 <= sync_array_muxed0;
			end
			6'd44: begin
				commandssim44 <= sync_array_muxed0;
			end
			6'd45: begin
				commandssim45 <= sync_array_muxed0;
			end
			6'd46: begin
				commandssim46 <= sync_array_muxed0;
			end
			6'd47: begin
				commandssim47 <= sync_array_muxed0;
			end
			6'd48: begin
				commandssim48 <= sync_array_muxed0;
			end
			6'd49: begin
				commandssim49 <= sync_array_muxed0;
			end
			6'd50: begin
				commandssim50 <= sync_array_muxed0;
			end
			6'd51: begin
				commandssim51 <= sync_array_muxed0;
			end
			6'd52: begin
				commandssim52 <= sync_array_muxed0;
			end
			6'd53: begin
				commandssim53 <= sync_array_muxed0;
			end
			6'd54: begin
				commandssim54 <= sync_array_muxed0;
			end
			6'd55: begin
				commandssim55 <= sync_array_muxed0;
			end
			6'd56: begin
				commandssim56 <= sync_array_muxed0;
			end
			6'd57: begin
				commandssim57 <= sync_array_muxed0;
			end
			6'd58: begin
				commandssim58 <= sync_array_muxed0;
			end
			6'd59: begin
				commandssim59 <= sync_array_muxed0;
			end
			6'd60: begin
				commandssim60 <= sync_array_muxed0;
			end
			6'd61: begin
				commandssim61 <= sync_array_muxed0;
			end
			6'd62: begin
				commandssim62 <= sync_array_muxed0;
			end
			default: begin
				commandssim63 <= sync_array_muxed0;
			end
		endcase
	end
	fsm1_state <= fsm1_next_state;
	if (commandssim_bank0_fsm1_next_value_ce0) begin
		commandssim_bank0 <= commandssim_bank0_fsm1_next_value0;
	end
	if (commandssim_row1_fsm1_next_value_ce1) begin
		commandssim_row1 <= commandssim_row1_fsm1_next_value1;
	end
	if (fsm1_next_value_ce0) begin
		sync_array_muxed1 = fsm1_next_value0;
		case (commandssim_bank0)
			1'd0: begin
				commandssim64 <= sync_array_muxed1;
			end
			1'd1: begin
				commandssim65 <= sync_array_muxed1;
			end
			2'd2: begin
				commandssim66 <= sync_array_muxed1;
			end
			2'd3: begin
				commandssim67 <= sync_array_muxed1;
			end
			3'd4: begin
				commandssim68 <= sync_array_muxed1;
			end
			3'd5: begin
				commandssim69 <= sync_array_muxed1;
			end
			3'd6: begin
				commandssim70 <= sync_array_muxed1;
			end
			default: begin
				commandssim71 <= sync_array_muxed1;
			end
		endcase
	end
	if (fsm1_next_value_ce1) begin
		sync_array_muxed2 = fsm1_next_value1;
		case (commandssim_bank0)
			1'd0: begin
				commandssim72 <= sync_array_muxed2;
			end
			1'd1: begin
				commandssim73 <= sync_array_muxed2;
			end
			2'd2: begin
				commandssim74 <= sync_array_muxed2;
			end
			2'd3: begin
				commandssim75 <= sync_array_muxed2;
			end
			3'd4: begin
				commandssim76 <= sync_array_muxed2;
			end
			3'd5: begin
				commandssim77 <= sync_array_muxed2;
			end
			3'd6: begin
				commandssim78 <= sync_array_muxed2;
			end
			default: begin
				commandssim79 <= sync_array_muxed2;
			end
		endcase
	end
	fsm2_state <= fsm2_next_state;
	if (commandssim_cas1_fsm2_next_value_ce0) begin
		commandssim_cas1 <= commandssim_cas1_fsm2_next_value0;
	end
	if (commandssim_bank2_fsm2_next_value_ce1) begin
		commandssim_bank2 <= commandssim_bank2_fsm2_next_value1;
	end
	if (commandssim_col9_fsm2_next_value_ce2) begin
		commandssim_col9 <= commandssim_col9_fsm2_next_value2;
	end
	if (commandssim_burst_len_fsm2_next_value_ce3) begin
		commandssim_burst_len <= commandssim_burst_len_fsm2_next_value3;
	end
	if (commandssim_auto_precharge_fsm2_next_value_ce4) begin
		commandssim_auto_precharge <= commandssim_auto_precharge_fsm2_next_value4;
	end
	if (fsm2_next_value_ce) begin
		sync_array_muxed3 = fsm2_next_value;
		case (commandssim_bank2)
			1'd0: begin
				commandssim64 <= sync_array_muxed3;
			end
			1'd1: begin
				commandssim65 <= sync_array_muxed3;
			end
			2'd2: begin
				commandssim66 <= sync_array_muxed3;
			end
			2'd3: begin
				commandssim67 <= sync_array_muxed3;
			end
			3'd4: begin
				commandssim68 <= sync_array_muxed3;
			end
			3'd5: begin
				commandssim69 <= sync_array_muxed3;
			end
			3'd6: begin
				commandssim70 <= sync_array_muxed3;
			end
			default: begin
				commandssim71 <= sync_array_muxed3;
			end
		endcase
	end
	if (commandssim_tinit0_trigger) begin
		commandssim_tinit0_triggered <= 1'd1;
	end
	commandssim_tinit0_trigger_d <= commandssim_tinit0_trigger;
	commandssim_tinit0_cond_d0 <= commandssim_tinit0_ready0;
	commandssim_tinit0_cond_d1 <= commandssim_tinit0_trigger;
	commandssim_tinit0_cond_d2 <= commandssim_tinit0_trigger_d;
	commandssim_tinit0_cond_d3 <= commandssim_tinit0_trigger;
	if (commandssim_tinit0_valid) begin
		if (1'd0) begin
			commandssim_tinit0_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit0_count <= 26'd42559999;
			if (1'd0) begin
				commandssim_tinit0_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit0_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit0_ready2)) begin
			if ((commandssim_tinit0_count > 1'd1)) begin
				commandssim_tinit0_count <= (commandssim_tinit0_count - 1'd1);
			end
			if ((commandssim_tinit0_count == 1'd1)) begin
				commandssim_tinit0_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tinit1_trigger) begin
		commandssim_tinit1_triggered <= 1'd1;
	end
	commandssim_tinit1_trigger_d <= commandssim_tinit1_trigger;
	commandssim_tinit1_cond_d0 <= commandssim_tinit1_ready0;
	commandssim_tinit1_cond_d1 <= commandssim_tinit1_trigger;
	commandssim_tinit1_cond_d2 <= commandssim_tinit1_trigger_d;
	commandssim_tinit1_cond_d3 <= commandssim_tinit1_trigger;
	if (commandssim_tinit1_valid) begin
		if (1'd0) begin
			commandssim_tinit1_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit1_count <= 19'd425599;
			if (1'd0) begin
				commandssim_tinit1_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit1_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit1_ready2)) begin
			if ((commandssim_tinit1_count > 1'd1)) begin
				commandssim_tinit1_count <= (commandssim_tinit1_count - 1'd1);
			end
			if ((commandssim_tinit1_count == 1'd1)) begin
				commandssim_tinit1_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tinit2_trigger) begin
		commandssim_tinit2_triggered <= 1'd1;
	end
	commandssim_tinit2_trigger_d <= commandssim_tinit2_trigger;
	commandssim_tinit2_cond_d0 <= commandssim_tinit2_ready0;
	commandssim_tinit2_cond_d1 <= commandssim_tinit2_trigger;
	commandssim_tinit2_cond_d2 <= commandssim_tinit2_trigger_d;
	commandssim_tinit2_cond_d3 <= commandssim_tinit2_trigger;
	if (commandssim_tinit2_valid) begin
		if (1'd0) begin
			commandssim_tinit2_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit2_count <= 5'd21;
			if (1'd0) begin
				commandssim_tinit2_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit2_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit2_ready2)) begin
			if ((commandssim_tinit2_count > 1'd1)) begin
				commandssim_tinit2_count <= (commandssim_tinit2_count - 1'd1);
			end
			if ((commandssim_tinit2_count == 1'd1)) begin
				commandssim_tinit2_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tinit3_trigger) begin
		commandssim_tinit3_triggered <= 1'd1;
	end
	commandssim_tinit3_trigger_d <= commandssim_tinit3_trigger;
	commandssim_tinit3_cond_d0 <= commandssim_tinit3_ready0;
	commandssim_tinit3_cond_d1 <= commandssim_tinit3_trigger;
	commandssim_tinit3_cond_d2 <= commandssim_tinit3_trigger_d;
	commandssim_tinit3_cond_d3 <= commandssim_tinit3_trigger;
	if (commandssim_tinit3_valid) begin
		if (1'd0) begin
			commandssim_tinit3_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit3_count <= 23'd4255999;
			if (1'd0) begin
				commandssim_tinit3_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit3_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit3_ready2)) begin
			if ((commandssim_tinit3_count > 1'd1)) begin
				commandssim_tinit3_count <= (commandssim_tinit3_count - 1'd1);
			end
			if ((commandssim_tinit3_count == 1'd1)) begin
				commandssim_tinit3_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tinit4_trigger) begin
		commandssim_tinit4_triggered <= 1'd1;
	end
	commandssim_tinit4_trigger_d <= commandssim_tinit4_trigger;
	commandssim_tinit4_cond_d0 <= commandssim_tinit4_ready0;
	commandssim_tinit4_cond_d1 <= commandssim_tinit4_trigger;
	commandssim_tinit4_cond_d2 <= commandssim_tinit4_trigger_d;
	commandssim_tinit4_cond_d3 <= commandssim_tinit4_trigger;
	if (commandssim_tinit4_valid) begin
		if (1'd0) begin
			commandssim_tinit4_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit4_count <= 3'd4;
			if (1'd0) begin
				commandssim_tinit4_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit4_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit4_ready2)) begin
			if ((commandssim_tinit4_count > 1'd1)) begin
				commandssim_tinit4_count <= (commandssim_tinit4_count - 1'd1);
			end
			if ((commandssim_tinit4_count == 1'd1)) begin
				commandssim_tinit4_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tinit5_trigger) begin
		commandssim_tinit5_triggered <= 1'd1;
	end
	commandssim_tinit5_trigger_d <= commandssim_tinit5_trigger;
	commandssim_tinit5_cond_d0 <= commandssim_tinit5_ready0;
	commandssim_tinit5_cond_d1 <= commandssim_tinit5_trigger;
	commandssim_tinit5_cond_d2 <= commandssim_tinit5_trigger_d;
	commandssim_tinit5_cond_d3 <= commandssim_tinit5_trigger;
	if (commandssim_tinit5_valid) begin
		if (1'd0) begin
			commandssim_tinit5_ready_reg <= 1'd1;
		end else begin
			commandssim_tinit5_count <= 13'd4255;
			if (1'd0) begin
				commandssim_tinit5_ready_reg <= 1'd1;
			end else begin
				commandssim_tinit5_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tinit5_ready2)) begin
			if ((commandssim_tinit5_count > 1'd1)) begin
				commandssim_tinit5_count <= (commandssim_tinit5_count - 1'd1);
			end
			if ((commandssim_tinit5_count == 1'd1)) begin
				commandssim_tinit5_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tzqcal_trigger) begin
		commandssim_tzqcal_triggered <= 1'd1;
	end
	commandssim_tzqcal_trigger_d <= commandssim_tzqcal_trigger;
	commandssim_tzqcal_cond_d0 <= commandssim_tzqcal_ready0;
	commandssim_tzqcal_cond_d1 <= commandssim_tzqcal_trigger;
	commandssim_tzqcal_cond_d2 <= commandssim_tzqcal_trigger_d;
	commandssim_tzqcal_cond_d3 <= commandssim_tzqcal_trigger;
	if (commandssim_tzqcal_valid) begin
		if (1'd0) begin
			commandssim_tzqcal_ready_reg <= 1'd1;
		end else begin
			commandssim_tzqcal_count <= 12'd2127;
			if (1'd0) begin
				commandssim_tzqcal_ready_reg <= 1'd1;
			end else begin
				commandssim_tzqcal_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tzqcal_ready2)) begin
			if ((commandssim_tzqcal_count > 1'd1)) begin
				commandssim_tzqcal_count <= (commandssim_tzqcal_count - 1'd1);
			end
			if ((commandssim_tzqcal_count == 1'd1)) begin
				commandssim_tzqcal_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tzqlat_trigger) begin
		commandssim_tzqlat_triggered <= 1'd1;
	end
	commandssim_tzqlat_trigger_d <= commandssim_tzqlat_trigger;
	commandssim_tzqlat_cond_d0 <= commandssim_tzqlat_ready0;
	commandssim_tzqlat_cond_d1 <= commandssim_tzqlat_trigger;
	commandssim_tzqlat_cond_d2 <= commandssim_tzqlat_trigger_d;
	commandssim_tzqlat_cond_d3 <= commandssim_tzqlat_trigger;
	if (commandssim_tzqlat_valid) begin
		if (1'd0) begin
			commandssim_tzqlat_ready_reg <= 1'd1;
		end else begin
			commandssim_tzqlat_count <= 6'd63;
			if (1'd0) begin
				commandssim_tzqlat_ready_reg <= 1'd1;
			end else begin
				commandssim_tzqlat_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tzqlat_ready2)) begin
			if ((commandssim_tzqlat_count > 1'd1)) begin
				commandssim_tzqlat_count <= (commandssim_tzqlat_count - 1'd1);
			end
			if ((commandssim_tzqlat_count == 1'd1)) begin
				commandssim_tzqlat_ready_reg <= 1'd1;
			end
		end
	end
	if (commandssim_tpw_reset_trigger) begin
		commandssim_tpw_reset_triggered <= 1'd1;
	end
	commandssim_tpw_reset_trigger_d <= commandssim_tpw_reset_trigger;
	commandssim_tpw_reset_cond_d0 <= commandssim_tpw_reset_ready0;
	commandssim_tpw_reset_cond_d1 <= commandssim_tpw_reset_trigger;
	commandssim_tpw_reset_cond_d2 <= commandssim_tpw_reset_trigger_d;
	commandssim_tpw_reset_cond_d3 <= commandssim_tpw_reset_trigger;
	if (commandssim_tpw_reset_valid) begin
		if (1'd0) begin
			commandssim_tpw_reset_ready_reg <= 1'd1;
		end else begin
			commandssim_tpw_reset_count <= 8'd212;
			if (1'd0) begin
				commandssim_tpw_reset_ready_reg <= 1'd1;
			end else begin
				commandssim_tpw_reset_ready_reg <= 1'd0;
			end
		end
	end else begin
		if ((~commandssim_tpw_reset_ready2)) begin
			if ((commandssim_tpw_reset_count > 1'd1)) begin
				commandssim_tpw_reset_count <= (commandssim_tpw_reset_count - 1'd1);
			end
			if ((commandssim_tpw_reset_count == 1'd1)) begin
				commandssim_tpw_reset_ready_reg <= 1'd1;
			end
		end
	end
	commandssim_delayed_tappeddelayline0 <= lpddr4simulationpads_reset_n;
	commandssim_delayed_tappeddelayline1 <= lpddr4simulationpads_reset_n;
	commandssim_delayed_tappeddelayline2 <= lpddr4simulationpads_cke;
	commandssim_delayed_tappeddelayline3 <= lpddr4simulationpads_cke;
	commandssim_state <= commandssim_next_state;
	if (commandssim_reset) begin
		commandssim_state <= 3'd0;
	end
	commandssim_prev_state_tappeddelayline <= commandssim_state;
	if (sys8x_90_rst) begin
		cdc_graycounter0_q <= 3'd0;
		cdc_graycounter0_q_binary <= 3'd0;
		commandssim_cnt <= 64'd0;
		commandssim0 <= 8'd0;
		commandssim1 <= 8'd0;
		commandssim2 <= 8'd0;
		commandssim3 <= 8'd0;
		commandssim4 <= 8'd0;
		commandssim5 <= 8'd0;
		commandssim6 <= 8'd0;
		commandssim7 <= 8'd0;
		commandssim8 <= 8'd0;
		commandssim9 <= 8'd0;
		commandssim10 <= 8'd0;
		commandssim11 <= 8'd0;
		commandssim12 <= 8'd0;
		commandssim13 <= 8'd0;
		commandssim14 <= 8'd0;
		commandssim15 <= 8'd0;
		commandssim16 <= 8'd0;
		commandssim17 <= 8'd0;
		commandssim18 <= 8'd0;
		commandssim19 <= 8'd0;
		commandssim20 <= 8'd0;
		commandssim21 <= 8'd0;
		commandssim22 <= 8'd0;
		commandssim23 <= 8'd0;
		commandssim24 <= 8'd0;
		commandssim25 <= 8'd0;
		commandssim26 <= 8'd0;
		commandssim27 <= 8'd0;
		commandssim28 <= 8'd0;
		commandssim29 <= 8'd0;
		commandssim30 <= 8'd0;
		commandssim31 <= 8'd0;
		commandssim32 <= 8'd0;
		commandssim33 <= 8'd0;
		commandssim34 <= 8'd0;
		commandssim35 <= 8'd0;
		commandssim36 <= 8'd0;
		commandssim37 <= 8'd0;
		commandssim38 <= 8'd0;
		commandssim39 <= 8'd0;
		commandssim40 <= 8'd0;
		commandssim41 <= 8'd0;
		commandssim42 <= 8'd0;
		commandssim43 <= 8'd0;
		commandssim44 <= 8'd0;
		commandssim45 <= 8'd0;
		commandssim46 <= 8'd0;
		commandssim47 <= 8'd0;
		commandssim48 <= 8'd0;
		commandssim49 <= 8'd0;
		commandssim50 <= 8'd0;
		commandssim51 <= 8'd0;
		commandssim52 <= 8'd0;
		commandssim53 <= 8'd0;
		commandssim54 <= 8'd0;
		commandssim55 <= 8'd0;
		commandssim56 <= 8'd0;
		commandssim57 <= 8'd0;
		commandssim58 <= 8'd0;
		commandssim59 <= 8'd0;
		commandssim60 <= 8'd0;
		commandssim61 <= 8'd0;
		commandssim62 <= 8'd0;
		commandssim63 <= 8'd0;
		commandssim64 <= 1'd0;
		commandssim65 <= 1'd0;
		commandssim66 <= 1'd0;
		commandssim67 <= 1'd0;
		commandssim68 <= 1'd0;
		commandssim69 <= 1'd0;
		commandssim70 <= 1'd0;
		commandssim71 <= 1'd0;
		commandssim72 <= 17'd0;
		commandssim73 <= 17'd0;
		commandssim74 <= 17'd0;
		commandssim75 <= 17'd0;
		commandssim76 <= 17'd0;
		commandssim77 <= 17'd0;
		commandssim78 <= 17'd0;
		commandssim79 <= 17'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline0 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline1 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline2 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline3 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline4 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline5 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline6 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline7 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline8 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline9 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline10 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline11 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline12 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline13 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline14 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline15 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline16 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline17 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline18 <= 1'd0;
		commandssim_data_en_tappeddelayline_tappeddelayline19 <= 1'd0;
		commandssim_cs_tappeddelayline0 <= 1'd0;
		commandssim_cs_tappeddelayline1 <= 1'd0;
		commandssim_ca_tappeddelayline0 <= 6'd0;
		commandssim_ca_tappeddelayline1 <= 6'd0;
		commandssim_ma <= 6'd0;
		commandssim_op7 <= 1'd0;
		commandssim_simlogger_cond_d0 <= 1'd0;
		commandssim_commandssim_cond_d0 <= 1'd0;
		commandssim_commandssim_cond_d1 <= 1'd0;
		commandssim_commandssim_cond_d2 <= 1'd0;
		commandssim_simlogger_cond_d1 <= 1'd0;
		commandssim_commandssim_cond_d3 <= 1'd0;
		commandssim_bank0 <= 3'd0;
		commandssim_row1 <= 7'd0;
		commandssim_simlogger_cond_d2 <= 1'd0;
		commandssim_simlogger_cond_d3 <= 1'd0;
		commandssim_commandssim_cond_d4 <= 1'd0;
		commandssim_commandssim_cond_d5 <= 1'd0;
		commandssim_commandssim_cond_d6 <= 1'd0;
		commandssim_simlogger_cond_d4 <= 1'd0;
		commandssim_simlogger_cond_d5 <= 1'd0;
		commandssim_simlogger_cond6 <= 1'd0;
		commandssim_simlogger_cond_d6 <= 1'd0;
		commandssim_commandssim_cond_d7 <= 1'd0;
		commandssim_cas1 <= 5'd0;
		commandssim_bank2 <= 3'd0;
		commandssim_col9 <= 1'd0;
		commandssim_burst_len <= 1'd0;
		commandssim_auto_precharge <= 1'd0;
		commandssim_commandssim_cond_d8 <= 1'd0;
		commandssim_commandssim_cond_d9 <= 1'd0;
		commandssim_commandssim_cond_d10 <= 1'd0;
		commandssim_simlogger_cond_d7 <= 1'd0;
		commandssim_simlogger_cond_d8 <= 1'd0;
		commandssim_simlogger_cond_d9 <= 1'd0;
		commandssim_simlogger_cond_d10 <= 1'd0;
		commandssim_simlogger_cond_d11 <= 1'd0;
		commandssim_simlogger_cond_d12 <= 1'd0;
		commandssim_commandssim_cond_d11 <= 1'd0;
		commandssim_commandssim_cond_d12 <= 1'd0;
		commandssim_commandssim_cond_d13 <= 1'd0;
		commandssim_cases_cond_d0 <= 1'd0;
		commandssim_cases_cond_d1 <= 1'd0;
		commandssim_cases_cond_d2 <= 1'd0;
		commandssim_cases_cond_d3 <= 1'd0;
		commandssim_cases_cond_d4 <= 1'd0;
		commandssim_cases_cond_d5 <= 1'd0;
		commandssim_cases_cond_d6 <= 1'd0;
		commandssim_cases_cond_d7 <= 1'd0;
		commandssim_simlogger_cond_d13 <= 1'd0;
		commandssim_simlogger_cond_d14 <= 1'd0;
		commandssim_commandssim_cond_d14 <= 1'd0;
		commandssim_simlogger_cond_d15 <= 1'd0;
		commandssim_tinit0_trigger_d <= 1'd0;
		commandssim_tinit0_triggered <= 1'd0;
		commandssim_tinit0_count <= 26'd0;
		commandssim_tinit0_ready_reg <= 1'd0;
		commandssim_tinit0_cond_d0 <= 1'd0;
		commandssim_tinit0_cond_d1 <= 1'd0;
		commandssim_tinit0_cond_d2 <= 1'd0;
		commandssim_tinit0_cond_d3 <= 1'd0;
		commandssim_tinit1_trigger_d <= 1'd0;
		commandssim_tinit1_triggered <= 1'd0;
		commandssim_tinit1_count <= 19'd0;
		commandssim_tinit1_ready_reg <= 1'd0;
		commandssim_tinit1_cond_d0 <= 1'd0;
		commandssim_tinit1_cond_d1 <= 1'd0;
		commandssim_tinit1_cond_d2 <= 1'd0;
		commandssim_tinit1_cond_d3 <= 1'd0;
		commandssim_tinit2_trigger_d <= 1'd0;
		commandssim_tinit2_triggered <= 1'd0;
		commandssim_tinit2_count <= 5'd0;
		commandssim_tinit2_ready_reg <= 1'd0;
		commandssim_tinit2_cond_d0 <= 1'd0;
		commandssim_tinit2_cond_d1 <= 1'd0;
		commandssim_tinit2_cond_d2 <= 1'd0;
		commandssim_tinit2_cond_d3 <= 1'd0;
		commandssim_tinit3_trigger_d <= 1'd0;
		commandssim_tinit3_triggered <= 1'd0;
		commandssim_tinit3_count <= 23'd0;
		commandssim_tinit3_ready_reg <= 1'd0;
		commandssim_tinit3_cond_d0 <= 1'd0;
		commandssim_tinit3_cond_d1 <= 1'd0;
		commandssim_tinit3_cond_d2 <= 1'd0;
		commandssim_tinit3_cond_d3 <= 1'd0;
		commandssim_tinit4_trigger_d <= 1'd0;
		commandssim_tinit4_triggered <= 1'd0;
		commandssim_tinit4_count <= 3'd0;
		commandssim_tinit4_ready_reg <= 1'd0;
		commandssim_tinit4_cond_d0 <= 1'd0;
		commandssim_tinit4_cond_d1 <= 1'd0;
		commandssim_tinit4_cond_d2 <= 1'd0;
		commandssim_tinit4_cond_d3 <= 1'd0;
		commandssim_tinit5_trigger_d <= 1'd0;
		commandssim_tinit5_triggered <= 1'd0;
		commandssim_tinit5_count <= 13'd0;
		commandssim_tinit5_ready_reg <= 1'd0;
		commandssim_tinit5_cond_d0 <= 1'd0;
		commandssim_tinit5_cond_d1 <= 1'd0;
		commandssim_tinit5_cond_d2 <= 1'd0;
		commandssim_tinit5_cond_d3 <= 1'd0;
		commandssim_tzqcal_trigger_d <= 1'd0;
		commandssim_tzqcal_triggered <= 1'd0;
		commandssim_tzqcal_count <= 12'd0;
		commandssim_tzqcal_ready_reg <= 1'd0;
		commandssim_tzqcal_cond_d0 <= 1'd0;
		commandssim_tzqcal_cond_d1 <= 1'd0;
		commandssim_tzqcal_cond_d2 <= 1'd0;
		commandssim_tzqcal_cond_d3 <= 1'd0;
		commandssim_tzqlat_trigger_d <= 1'd0;
		commandssim_tzqlat_triggered <= 1'd0;
		commandssim_tzqlat_count <= 6'd0;
		commandssim_tzqlat_ready_reg <= 1'd0;
		commandssim_tzqlat_cond_d0 <= 1'd0;
		commandssim_tzqlat_cond_d1 <= 1'd0;
		commandssim_tzqlat_cond_d2 <= 1'd0;
		commandssim_tzqlat_cond_d3 <= 1'd0;
		commandssim_tpw_reset_trigger_d <= 1'd0;
		commandssim_tpw_reset_triggered <= 1'd0;
		commandssim_tpw_reset_count <= 8'd0;
		commandssim_tpw_reset_ready_reg <= 1'd0;
		commandssim_tpw_reset_cond_d0 <= 1'd0;
		commandssim_tpw_reset_cond_d1 <= 1'd0;
		commandssim_tpw_reset_cond_d2 <= 1'd0;
		commandssim_tpw_reset_cond_d3 <= 1'd0;
		commandssim_delayed_tappeddelayline0 <= 1'd0;
		commandssim_simlogger_cond_d16 <= 1'd0;
		commandssim_simlogger_cond_d17 <= 1'd0;
		commandssim_simlogger_cond_d18 <= 1'd0;
		commandssim_delayed_tappeddelayline1 <= 1'd0;
		commandssim_simlogger_cond_d19 <= 1'd0;
		commandssim_delayed_tappeddelayline2 <= 1'd0;
		commandssim_simlogger_cond_d20 <= 1'd0;
		commandssim_delayed_tappeddelayline3 <= 1'd0;
		commandssim_simlogger_cond_d21 <= 1'd0;
		commandssim_simlogger_cond_d22 <= 1'd0;
		commandssim_simlogger_cond_d23 <= 1'd0;
		commandssim_simlogger_cond_d24 <= 1'd0;
		commandssim_simlogger_cond_d25 <= 1'd0;
		commandssim_simlogger_cond_d26 <= 1'd0;
		commandssim_simlogger_cond_d27 <= 1'd0;
		commandssim_simlogger_cond_d28 <= 1'd0;
		commandssim_simlogger_cond_d29 <= 1'd0;
		commandssim_state <= 3'd0;
		commandssim_prev_state_tappeddelayline <= 3'd0;
		commandssim_commandssim_cond_d15 <= 1'd0;
		commandssim_commandssim_cond_d16 <= 1'd0;
		commandssim_commandssim_cond_d17 <= 1'd0;
		commandssim_commandssim_cond_d18 <= 1'd0;
		commandssim_commandssim_cond_d19 <= 1'd0;
		commandssim_commandssim_cond_d20 <= 1'd0;
		commandssim_commandssim_cond_d21 <= 1'd0;
		commandssim_commandssim_cond_d22 <= 1'd0;
		commandssim_commandssim_cond_d23 <= 1'd0;
		commandssim_commandssim_cond_d24 <= 1'd0;
		commandssim_commandssim_cond_d25 <= 1'd0;
		commandssim_commandssim_cond_d26 <= 1'd0;
		commandssim_commandssim_cond_d27 <= 1'd0;
		commandssim_commandssim_cond_d28 <= 1'd0;
		commandssim_commandssim_cond_d29 <= 1'd0;
		commandssim_commandssim_cond_d30 <= 1'd0;
		commandssim_commandssim_cond_d31 <= 1'd0;
		commandssim_commandssim_cond_d32 <= 1'd0;
		commandssim_commandssim_cond_d33 <= 1'd0;
		commandssim_commandssim_cond_d34 <= 1'd0;
		commandssim_commandssim_cond_d35 <= 1'd0;
		commandssim_commandssim_cond_d36 <= 1'd0;
		commandssim_commandssim_cond_d37 <= 1'd0;
		commandssim_commandssim_cond_d38 <= 1'd0;
		commandssim_commandssim_cond_d39 <= 1'd0;
		fsm0_state <= 1'd0;
		fsm1_state <= 1'd0;
		fsm2_state <= 1'd0;
	end
	multiregimpl1_regs0 <= cdc_graycounter1_q;
	multiregimpl1_regs1 <= multiregimpl1_regs0;
end

always @(posedge sys8x_90_ddr_clk) begin
	cdc_graycounter1_q_binary <= cdc_graycounter1_q_next_binary;
	cdc_graycounter1_q <= cdc_graycounter1_q_next;
	dqwrite_cnt <= (dqwrite_cnt + 1'd1);
	if (((dqwrite_level <= 1'd0) & dqwrite_cond)) begin
		$display("[%16d ps] [DEBUG] WRITE[%d]: bank=%d, row=%d, col=%d, dq=0x%04x dm=0x%02b", dqwrite_time_ps, dqwrite_burst_counter, bank, row, dqwrite_col_burst, lpddr4simulationpads0, lpddr4simulationpads2);
	end
	dqwrite_state <= dqwrite_next_state;
	if (dqwrite_burst_counter_clockdomainsrenamer0_next_value_ce0) begin
		dqwrite_burst_counter <= dqwrite_burst_counter_clockdomainsrenamer0_next_value0;
	end
	if (dqwrite_masked1_clockdomainsrenamer0_next_value_ce1) begin
		dqwrite_masked1 <= dqwrite_masked1_clockdomainsrenamer0_next_value1;
	end
	dqread_cnt <= (dqread_cnt + 1'd1);
	if (((dqread_level <= 1'd0) & dqread_cond)) begin
		$display("[%16d ps] [DEBUG] READ[%d]: bank=%d, row=%d, col=%d, dq=0x%04x", dqread_time_ps, dqread_burst_counter, bank, row, dqread_col_burst, lpddr4simulationpads_dq_i);
	end
	dqread_state <= dqread_next_state;
	if (dqread_burst_counter_clockdomainsrenamer1_next_value_ce) begin
		dqread_burst_counter <= dqread_burst_counter_clockdomainsrenamer1_next_value;
	end
	if (source_source_ready) begin
		bank <= source_source_payload_bank;
		row <= source_source_payload_row;
		col <= source_source_payload_col;
	end
	log_cnt <= (log_cnt + 1'd1);
	if (sys8x_90_ddr_rst) begin
		cdc_graycounter1_q <= 3'd0;
		cdc_graycounter1_q_binary <= 3'd0;
		log_cnt <= 64'd0;
		bank <= 3'd0;
		row <= 17'd0;
		col <= 10'd0;
		dqwrite_cnt <= 64'd0;
		dqwrite_burst_counter <= 4'd0;
		dqwrite_masked1 <= 1'd0;
		dqread_cnt <= 64'd0;
		dqread_burst_counter <= 4'd0;
		dqwrite_state <= 1'd0;
		dqread_state <= 1'd0;
	end
	multiregimpl0_regs0 <= cdc_graycounter0_q;
	multiregimpl0_regs1 <= multiregimpl0_regs0;
end

always @(posedge sys8x_ddr_clk) begin
	dqswrite_cnt <= (dqswrite_cnt + 1'd1);
	if (((dqswrite_level <= 2'd2) & dqswrite_cond)) begin
		$display("[%16d ps] [WARN] Wrong DQS=%d for cycle=%d", dqswrite_time_ps, dqswrite_dqs0, dqswrite_burst_counter);
	end
	dqswrite_state <= dqswrite_next_state;
	if (dqswrite_burst_counter_clockdomainsrenamer2_next_value_ce) begin
		dqswrite_burst_counter <= dqswrite_burst_counter_clockdomainsrenamer2_next_value;
	end
	dqsread_cnt <= (dqsread_cnt + 1'd1);
	dqsread_state <= dqsread_next_state;
	if (dqsread_burst_counter_clockdomainsrenamer3_next_value_ce) begin
		dqsread_burst_counter <= dqsread_burst_counter_clockdomainsrenamer3_next_value;
	end
	if (sys8x_ddr_rst) begin
		dqswrite_cnt <= 64'd0;
		dqswrite_burst_counter <= 4'd0;
		dqsread_cnt <= 64'd0;
		dqsread_burst_counter <= 4'd0;
		dqswrite_state <= 1'd0;
		dqsread_state <= 1'd0;
	end
end

reg [33:0] storage[0:3];
reg [1:0] memadr;
reg [1:0] memadr_1;
always @(posedge sys8x_90_clk) begin
	if (cdc_wrport_we)
		storage[cdc_wrport_adr] <= cdc_wrport_dat_w;
	memadr <= cdc_wrport_adr;
end

always @(posedge sys8x_90_ddr_clk) begin
	memadr_1 <= cdc_rdport_adr;
end

assign cdc_wrport_dat_r = storage[memadr];
assign cdc_rdport_dat_r = storage[memadr_1];

reg [15:0] mem[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory0_we[0])
		mem[memory0_adr][7:0] <= memory0_dat_w[7:0];
	if (memory0_we[1])
		mem[memory0_adr][15:8] <= memory0_dat_w[15:8];
end

assign memory0_dat_r = mem[memory0_adr];

reg [15:0] mem_1[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory1_we[0])
		mem_1[memory1_adr][7:0] <= memory1_dat_w[7:0];
	if (memory1_we[1])
		mem_1[memory1_adr][15:8] <= memory1_dat_w[15:8];
end

assign memory1_dat_r = mem_1[memory1_adr];

reg [15:0] mem_2[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory2_we[0])
		mem_2[memory2_adr][7:0] <= memory2_dat_w[7:0];
	if (memory2_we[1])
		mem_2[memory2_adr][15:8] <= memory2_dat_w[15:8];
end

assign memory2_dat_r = mem_2[memory2_adr];

reg [15:0] mem_3[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory3_we[0])
		mem_3[memory3_adr][7:0] <= memory3_dat_w[7:0];
	if (memory3_we[1])
		mem_3[memory3_adr][15:8] <= memory3_dat_w[15:8];
end

assign memory3_dat_r = mem_3[memory3_adr];

reg [15:0] mem_4[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory4_we[0])
		mem_4[memory4_adr][7:0] <= memory4_dat_w[7:0];
	if (memory4_we[1])
		mem_4[memory4_adr][15:8] <= memory4_dat_w[15:8];
end

assign memory4_dat_r = mem_4[memory4_adr];

reg [15:0] mem_5[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory5_we[0])
		mem_5[memory5_adr][7:0] <= memory5_dat_w[7:0];
	if (memory5_we[1])
		mem_5[memory5_adr][15:8] <= memory5_dat_w[15:8];
end

assign memory5_dat_r = mem_5[memory5_adr];

reg [15:0] mem_6[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory6_we[0])
		mem_6[memory6_adr][7:0] <= memory6_dat_w[7:0];
	if (memory6_we[1])
		mem_6[memory6_adr][15:8] <= memory6_dat_w[15:8];
end

assign memory6_dat_r = mem_6[memory6_adr];

reg [15:0] mem_7[0:33554431];
always @(posedge sys8x_90_ddr_clk) begin
	if (memory7_we[0])
		mem_7[memory7_adr][7:0] <= memory7_dat_w[7:0];
	if (memory7_we[1])
		mem_7[memory7_adr][15:8] <= memory7_dat_w[15:8];
end

assign memory7_dat_r = mem_7[memory7_adr];

endmodule
