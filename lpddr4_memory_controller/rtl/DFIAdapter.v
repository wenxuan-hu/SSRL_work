/* Machine-generated using Migen */
module DFIAdapter(
	input [16:0] dfi_p0_address,
	input [5:0] dfi_p0_bank,
	input dfi_p0_cas_n,
	input dfi_p0_cs_n,
	input dfi_p0_ras_n,
	input dfi_p0_we_n,
	input dfi_p0_mw,
	input [16:0] dfi_p1_address,
	input [5:0] dfi_p1_bank,
	input dfi_p1_cas_n,
	input dfi_p1_cs_n,
	input dfi_p1_ras_n,
	input dfi_p1_we_n,
	input dfi_p1_mw,
	input [16:0] dfi_p2_address,
	input [5:0] dfi_p2_bank,
	input dfi_p2_cas_n,
	input dfi_p2_cs_n,
	input dfi_p2_ras_n,
	input dfi_p2_we_n,
	input dfi_p2_mw,
	input [16:0] dfi_p3_address,
	input [5:0] dfi_p3_bank,
	input dfi_p3_cas_n,
	input dfi_p3_cs_n,
	input dfi_p3_ras_n,
	input dfi_p3_we_n,
	input dfi_p3_mw,
	output [3:0] cs,
	output [3:0] ca,
	output [3:0] ca_1,
	output [3:0] ca_2,
	output [3:0] ca_3,
	output [3:0] ca_4,
	output [3:0] ca_5,
	input sys_clk,
	input sys_rst
);

reg [3:0] dfiphaseadapter0_cs;
wire [5:0] dfiphaseadapter00;
wire [5:0] dfiphaseadapter01;
wire [5:0] dfiphaseadapter02;
wire [5:0] dfiphaseadapter03;
reg dfiphaseadapter0_valid;
reg [1:0] dfiphaseadapter0_command0_cs0;
reg [5:0] dfiphaseadapter0_command00;
reg [5:0] dfiphaseadapter0_command01;
reg [1:0] dfiphaseadapter0_command0_cs1;
reg [5:0] dfiphaseadapter0_command02;
reg [5:0] dfiphaseadapter0_command03;
wire [2:0] dfiphaseadapter0_dfi_cmd;
reg [3:0] dfiphaseadapter1_cs;
wire [5:0] dfiphaseadapter10;
wire [5:0] dfiphaseadapter11;
wire [5:0] dfiphaseadapter12;
wire [5:0] dfiphaseadapter13;
reg dfiphaseadapter1_valid;
reg [1:0] dfiphaseadapter1_command1_cs0;
reg [5:0] dfiphaseadapter1_command10;
reg [5:0] dfiphaseadapter1_command11;
reg [1:0] dfiphaseadapter1_command1_cs1;
reg [5:0] dfiphaseadapter1_command12;
reg [5:0] dfiphaseadapter1_command13;
wire [2:0] dfiphaseadapter1_dfi_cmd;
reg [3:0] dfiphaseadapter2_cs;
wire [5:0] dfiphaseadapter20;
wire [5:0] dfiphaseadapter21;
wire [5:0] dfiphaseadapter22;
wire [5:0] dfiphaseadapter23;
reg dfiphaseadapter2_valid;
reg [1:0] dfiphaseadapter2_command2_cs0;
reg [5:0] dfiphaseadapter2_command20;
reg [5:0] dfiphaseadapter2_command21;
reg [1:0] dfiphaseadapter2_command2_cs1;
reg [5:0] dfiphaseadapter2_command22;
reg [5:0] dfiphaseadapter2_command23;
wire [2:0] dfiphaseadapter2_dfi_cmd;
reg [3:0] dfiphaseadapter3_cs;
wire [5:0] dfiphaseadapter30;
wire [5:0] dfiphaseadapter31;
wire [5:0] dfiphaseadapter32;
wire [5:0] dfiphaseadapter33;
reg dfiphaseadapter3_valid;
reg [1:0] dfiphaseadapter3_command3_cs0;
reg [5:0] dfiphaseadapter3_command30;
reg [5:0] dfiphaseadapter3_command31;
reg [1:0] dfiphaseadapter3_command3_cs1;
reg [5:0] dfiphaseadapter3_command32;
reg [5:0] dfiphaseadapter3_command33;
wire [2:0] dfiphaseadapter3_dfi_cmd;
wire [3:0] i;
wire [3:0] o;
wire [7:0] r;
reg [3:0] reg_1 = 4'd0;
reg [7:0] valids_hist;
wire [3:0] constbitslip0_i0;
wire [3:0] constbitslip0_o0;
reg [7:0] constbitslip0_r0 = 8'd0;
wire [3:0] constbitslip0_i1;
wire [3:0] constbitslip0_o1;
reg [7:0] constbitslip0_r1 = 8'd0;
wire [3:0] constbitslip1_i0;
wire [3:0] constbitslip1_o0;
reg [7:0] constbitslip1_r0 = 8'd0;
wire [3:0] constbitslip2_i0;
wire [3:0] constbitslip2_o0;
reg [7:0] constbitslip2_r0 = 8'd0;
wire [3:0] constbitslip3_i0;
wire [3:0] constbitslip3_o0;
reg [7:0] constbitslip3_r0 = 8'd0;
wire [3:0] constbitslip4_i;
wire [3:0] constbitslip4_o;
reg [7:0] constbitslip4_r = 8'd0;
wire [3:0] constbitslip5_i;
wire [3:0] constbitslip5_o;
reg [7:0] constbitslip5_r = 8'd0;
wire [3:0] constbitslip1_i1;
wire [3:0] constbitslip1_o1;
reg [7:0] constbitslip1_r1 = 8'd0;
wire [3:0] constbitslip6_i;
wire [3:0] constbitslip6_o;
reg [7:0] constbitslip6_r = 8'd0;
wire [3:0] constbitslip7_i;
wire [3:0] constbitslip7_o;
reg [7:0] constbitslip7_r = 8'd0;
wire [3:0] constbitslip8_i;
wire [3:0] constbitslip8_o;
reg [7:0] constbitslip8_r = 8'd0;
wire [3:0] constbitslip9_i;
wire [3:0] constbitslip9_o;
reg [7:0] constbitslip9_r = 8'd0;
wire [3:0] constbitslip10_i;
wire [3:0] constbitslip10_o;
reg [7:0] constbitslip10_r = 8'd0;
wire [3:0] constbitslip11_i;
wire [3:0] constbitslip11_o;
reg [7:0] constbitslip11_r = 8'd0;
wire [3:0] constbitslip2_i1;
wire [3:0] constbitslip2_o1;
reg [7:0] constbitslip2_r1 = 8'd0;
wire [3:0] constbitslip12_i;
wire [3:0] constbitslip12_o;
reg [7:0] constbitslip12_r = 8'd0;
wire [3:0] constbitslip13_i;
wire [3:0] constbitslip13_o;
reg [7:0] constbitslip13_r = 8'd0;
wire [3:0] constbitslip14_i;
wire [3:0] constbitslip14_o;
reg [7:0] constbitslip14_r = 8'd0;
wire [3:0] constbitslip15_i;
wire [3:0] constbitslip15_o;
reg [7:0] constbitslip15_r = 8'd0;
wire [3:0] constbitslip16_i;
wire [3:0] constbitslip16_o;
reg [7:0] constbitslip16_r = 8'd0;
wire [3:0] constbitslip17_i;
wire [3:0] constbitslip17_o;
reg [7:0] constbitslip17_r = 8'd0;
wire [3:0] constbitslip3_i1;
wire [3:0] constbitslip3_o1;
reg [7:0] constbitslip3_r1 = 8'd0;
wire [3:0] constbitslip18_i;
wire [3:0] constbitslip18_o;
reg [7:0] constbitslip18_r = 8'd0;
wire [3:0] constbitslip19_i;
wire [3:0] constbitslip19_o;
reg [7:0] constbitslip19_r = 8'd0;
wire [3:0] constbitslip20_i;
wire [3:0] constbitslip20_o;
reg [7:0] constbitslip20_r = 8'd0;
wire [3:0] constbitslip21_i;
wire [3:0] constbitslip21_o;
reg [7:0] constbitslip21_r = 8'd0;
wire [3:0] constbitslip22_i;
wire [3:0] constbitslip22_o;
reg [7:0] constbitslip22_r = 8'd0;
wire [3:0] constbitslip23_i;
wire [3:0] constbitslip23_o;
reg [7:0] constbitslip23_r = 8'd0;
wire slice_proxy0;
wire [1:0] slice_proxy1;
wire [1:0] slice_proxy2;
wire [2:0] slice_proxy3;
wire [2:0] slice_proxy4;
wire [2:0] slice_proxy5;
wire [2:0] slice_proxy6;
wire [2:0] slice_proxy7;
wire [2:0] slice_proxy8;
wire [2:0] slice_proxy9;
wire [2:0] slice_proxy10;
wire [2:0] slice_proxy11;
wire [2:0] slice_proxy12;
wire [2:0] slice_proxy13;
wire [2:0] slice_proxy14;
wire [2:0] slice_proxy15;
wire [2:0] slice_proxy16;
wire [2:0] slice_proxy17;
wire [2:0] slice_proxy18;
wire [2:0] slice_proxy19;
wire [2:0] slice_proxy20;
wire [2:0] slice_proxy21;
wire [2:0] slice_proxy22;
wire [2:0] slice_proxy23;
wire [2:0] slice_proxy24;
wire [2:0] slice_proxy25;
wire [2:0] slice_proxy26;
wire [2:0] slice_proxy27;
wire [2:0] slice_proxy28;
wire [2:0] slice_proxy29;
wire [2:0] slice_proxy30;
wire [2:0] slice_proxy31;
wire [2:0] slice_proxy32;
wire [2:0] slice_proxy33;
wire [2:0] slice_proxy34;
wire [2:0] slice_proxy35;
wire [2:0] slice_proxy36;
wire [2:0] slice_proxy37;
wire [2:0] slice_proxy38;
wire [2:0] slice_proxy39;
wire [2:0] slice_proxy40;
wire [2:0] slice_proxy41;
wire [2:0] slice_proxy42;
wire [2:0] slice_proxy43;
wire [2:0] slice_proxy44;
wire [2:0] slice_proxy45;
wire [2:0] slice_proxy46;
wire [2:0] slice_proxy47;
wire [2:0] slice_proxy48;
wire [2:0] slice_proxy49;
wire [2:0] slice_proxy50;
wire [2:0] slice_proxy51;
wire [2:0] slice_proxy52;
wire [2:0] slice_proxy53;
wire [2:0] slice_proxy54;
wire [2:0] slice_proxy55;
wire [2:0] slice_proxy56;
wire [2:0] slice_proxy57;
wire [2:0] slice_proxy58;
wire [2:0] slice_proxy59;
wire [2:0] slice_proxy60;
wire [2:0] slice_proxy61;
wire [2:0] slice_proxy62;
wire [2:0] slice_proxy63;
wire [2:0] slice_proxy64;
wire [2:0] slice_proxy65;
wire [2:0] slice_proxy66;
wire [2:0] slice_proxy67;
wire [2:0] slice_proxy68;
wire [2:0] slice_proxy69;
wire [2:0] slice_proxy70;
wire [2:0] slice_proxy71;
wire [2:0] slice_proxy72;
wire [2:0] slice_proxy73;
wire [2:0] slice_proxy74;
wire [2:0] slice_proxy75;
wire [2:0] slice_proxy76;
wire [2:0] slice_proxy77;
wire [2:0] slice_proxy78;
wire [2:0] slice_proxy79;
wire [2:0] slice_proxy80;
wire [2:0] slice_proxy81;
wire [2:0] slice_proxy82;
wire [2:0] slice_proxy83;
wire [2:0] slice_proxy84;
wire [2:0] slice_proxy85;
wire [2:0] slice_proxy86;
wire [2:0] slice_proxy87;
wire [2:0] slice_proxy88;
wire [2:0] slice_proxy89;
wire [2:0] slice_proxy90;
wire [2:0] slice_proxy91;
wire [2:0] slice_proxy92;
wire [2:0] slice_proxy93;
wire [2:0] slice_proxy94;
wire [2:0] slice_proxy95;
wire [2:0] slice_proxy96;
wire [2:0] slice_proxy97;
wire [2:0] slice_proxy98;
wire [2:0] slice_proxy99;
wire [2:0] slice_proxy100;
wire [2:0] slice_proxy101;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on


// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter0_cs <= 4'd0;
	dfiphaseadapter0_cs[1:0] <= dfiphaseadapter0_command0_cs0;
	dfiphaseadapter0_cs[3:2] <= dfiphaseadapter0_command0_cs1;
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end
assign dfiphaseadapter00 = dfiphaseadapter0_command00;
assign dfiphaseadapter01 = dfiphaseadapter0_command01;
assign dfiphaseadapter02 = dfiphaseadapter0_command02;
assign dfiphaseadapter03 = dfiphaseadapter0_command03;
assign dfiphaseadapter0_dfi_cmd = {(~dfi_p0_cas_n), (~dfi_p0_ras_n), (~dfi_p0_we_n)};

// synthesis translate_off
reg dummy_d_1;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter0_valid <= 1'd0;
	dfiphaseadapter0_command0_cs0 <= 2'd0;
	dfiphaseadapter0_command00 <= 6'd0;
	dfiphaseadapter0_command01 <= 6'd0;
	dfiphaseadapter0_command0_cs1 <= 2'd0;
	dfiphaseadapter0_command02 <= 6'd0;
	dfiphaseadapter0_command03 <= 6'd0;
	if ((dfi_p0_cs_n == 1'd0)) begin
		case (dfiphaseadapter0_dfi_cmd)
			1'd1: begin
				case (dfi_p0_bank)
					1'd0: begin
						dfiphaseadapter0_command00[0] <= 1'd0;
						dfiphaseadapter0_command00[1] <= 1'd0;
						dfiphaseadapter0_command00[2] <= 1'd0;
						dfiphaseadapter0_command00[3] <= 1'd0;
						dfiphaseadapter0_command00[4] <= 1'd0;
						dfiphaseadapter0_command00[5] <= 1'd0;
						dfiphaseadapter0_command01[0] <= 1'd0;
						dfiphaseadapter0_command01[1] <= 1'd0;
						dfiphaseadapter0_command01[2] <= 1'd0;
						dfiphaseadapter0_command01[3] <= 1'd0;
						dfiphaseadapter0_command01[4] <= 1'd0;
						dfiphaseadapter0_command01[5] <= 1'd0;
						dfiphaseadapter0_command02[0] <= 1'd0;
						dfiphaseadapter0_command02[1] <= 1'd0;
						dfiphaseadapter0_command02[2] <= 1'd0;
						dfiphaseadapter0_command02[3] <= 1'd0;
						dfiphaseadapter0_command02[4] <= 1'd0;
						dfiphaseadapter0_command02[5] <= dfi_p0_address[6];
						dfiphaseadapter0_command03[0] <= dfi_p0_address[0];
						dfiphaseadapter0_command03[1] <= dfi_p0_address[1];
						dfiphaseadapter0_command03[2] <= dfi_p0_address[2];
						dfiphaseadapter0_command03[3] <= dfi_p0_address[3];
						dfiphaseadapter0_command03[4] <= dfi_p0_address[4];
						dfiphaseadapter0_command03[5] <= dfi_p0_address[5];
						dfiphaseadapter0_command0_cs1[0] <= 1'd1;
						dfiphaseadapter0_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter0_command00[0] <= 1'd0;
						dfiphaseadapter0_command00[1] <= 1'd1;
						dfiphaseadapter0_command00[2] <= 1'd1;
						dfiphaseadapter0_command00[3] <= 1'd1;
						dfiphaseadapter0_command00[4] <= 1'd0;
						dfiphaseadapter0_command00[5] <= 1'd0;
						dfiphaseadapter0_command01[0] <= dfi_p0_address[0];
						dfiphaseadapter0_command01[1] <= dfi_p0_address[1];
						dfiphaseadapter0_command01[2] <= dfi_p0_address[2];
						dfiphaseadapter0_command01[3] <= dfi_p0_address[3];
						dfiphaseadapter0_command01[4] <= dfi_p0_address[4];
						dfiphaseadapter0_command01[5] <= dfi_p0_address[5];
						dfiphaseadapter0_command0_cs0[0] <= 1'd1;
						dfiphaseadapter0_command02[0] <= 1'd0;
						dfiphaseadapter0_command02[1] <= 1'd1;
						dfiphaseadapter0_command02[2] <= 1'd0;
						dfiphaseadapter0_command02[3] <= 1'd0;
						dfiphaseadapter0_command02[4] <= 1'd1;
						dfiphaseadapter0_command02[5] <= dfi_p0_address[8];
						dfiphaseadapter0_command03[0] <= dfi_p0_address[2];
						dfiphaseadapter0_command03[1] <= dfi_p0_address[3];
						dfiphaseadapter0_command03[2] <= dfi_p0_address[4];
						dfiphaseadapter0_command03[3] <= dfi_p0_address[5];
						dfiphaseadapter0_command03[4] <= dfi_p0_address[6];
						dfiphaseadapter0_command03[5] <= dfi_p0_address[7];
						dfiphaseadapter0_command0_cs1[0] <= 1'd1;
						dfiphaseadapter0_valid <= 1'd1;
					end
					default: begin
						dfiphaseadapter0_command00[0] <= 1'd0;
						dfiphaseadapter0_command00[1] <= 1'd0;
						dfiphaseadapter0_command00[2] <= 1'd0;
						dfiphaseadapter0_command00[3] <= 1'd0;
						dfiphaseadapter0_command00[4] <= 1'd0;
						dfiphaseadapter0_command00[5] <= 1'd0;
						dfiphaseadapter0_command01[0] <= 1'd0;
						dfiphaseadapter0_command01[1] <= 1'd0;
						dfiphaseadapter0_command01[2] <= 1'd0;
						dfiphaseadapter0_command01[3] <= 1'd0;
						dfiphaseadapter0_command01[4] <= 1'd0;
						dfiphaseadapter0_command01[5] <= 1'd0;
						dfiphaseadapter0_command02[0] <= 1'd0;
						dfiphaseadapter0_command02[1] <= 1'd0;
						dfiphaseadapter0_command02[2] <= 1'd0;
						dfiphaseadapter0_command02[3] <= 1'd0;
						dfiphaseadapter0_command02[4] <= 1'd0;
						dfiphaseadapter0_command02[5] <= 1'd0;
						dfiphaseadapter0_command03[0] <= 1'd0;
						dfiphaseadapter0_command03[1] <= 1'd0;
						dfiphaseadapter0_command03[2] <= 1'd0;
						dfiphaseadapter0_command03[3] <= 1'd0;
						dfiphaseadapter0_command03[4] <= 1'd0;
						dfiphaseadapter0_command03[5] <= 1'd0;
						dfiphaseadapter0_valid <= 1'd0;
					end
				endcase
			end
			2'd2: begin
				dfiphaseadapter0_command00[0] <= 1'd1;
				dfiphaseadapter0_command00[1] <= 1'd0;
				dfiphaseadapter0_command00[2] <= dfi_p0_address[12];
				dfiphaseadapter0_command00[3] <= dfi_p0_address[13];
				dfiphaseadapter0_command00[4] <= dfi_p0_address[14];
				dfiphaseadapter0_command00[5] <= dfi_p0_address[15];
				dfiphaseadapter0_command01[0] <= dfi_p0_bank[0];
				dfiphaseadapter0_command01[1] <= dfi_p0_bank[1];
				dfiphaseadapter0_command01[2] <= dfi_p0_bank[2];
				dfiphaseadapter0_command01[3] <= dfi_p0_address[16];
				dfiphaseadapter0_command01[4] <= dfi_p0_address[10];
				dfiphaseadapter0_command01[5] <= dfi_p0_address[11];
				dfiphaseadapter0_command0_cs0[0] <= 1'd1;
				dfiphaseadapter0_command02[0] <= 1'd1;
				dfiphaseadapter0_command02[1] <= 1'd1;
				dfiphaseadapter0_command02[2] <= dfi_p0_address[6];
				dfiphaseadapter0_command02[3] <= dfi_p0_address[7];
				dfiphaseadapter0_command02[4] <= dfi_p0_address[8];
				dfiphaseadapter0_command02[5] <= dfi_p0_address[9];
				dfiphaseadapter0_command03[0] <= dfi_p0_address[0];
				dfiphaseadapter0_command03[1] <= dfi_p0_address[1];
				dfiphaseadapter0_command03[2] <= dfi_p0_address[2];
				dfiphaseadapter0_command03[3] <= dfi_p0_address[3];
				dfiphaseadapter0_command03[4] <= dfi_p0_address[4];
				dfiphaseadapter0_command03[5] <= dfi_p0_address[5];
				dfiphaseadapter0_command0_cs1[0] <= 1'd1;
				dfiphaseadapter0_valid <= 1'd1;
			end
			2'd3: begin
				dfiphaseadapter0_command00[0] <= 1'd0;
				dfiphaseadapter0_command00[1] <= 1'd0;
				dfiphaseadapter0_command00[2] <= 1'd0;
				dfiphaseadapter0_command00[3] <= 1'd0;
				dfiphaseadapter0_command00[4] <= 1'd0;
				dfiphaseadapter0_command00[5] <= 1'd0;
				dfiphaseadapter0_command01[0] <= 1'd0;
				dfiphaseadapter0_command01[1] <= 1'd0;
				dfiphaseadapter0_command01[2] <= 1'd0;
				dfiphaseadapter0_command01[3] <= 1'd0;
				dfiphaseadapter0_command01[4] <= 1'd0;
				dfiphaseadapter0_command01[5] <= 1'd0;
				dfiphaseadapter0_command02[0] <= 1'd0;
				dfiphaseadapter0_command02[1] <= 1'd0;
				dfiphaseadapter0_command02[2] <= 1'd0;
				dfiphaseadapter0_command02[3] <= 1'd0;
				dfiphaseadapter0_command02[4] <= 1'd1;
				dfiphaseadapter0_command02[5] <= dfi_p0_address[10];
				dfiphaseadapter0_command03[0] <= dfi_p0_bank[0];
				dfiphaseadapter0_command03[1] <= dfi_p0_bank[1];
				dfiphaseadapter0_command03[2] <= dfi_p0_bank[2];
				dfiphaseadapter0_command03[3] <= 1'd0;
				dfiphaseadapter0_command03[4] <= 1'd0;
				dfiphaseadapter0_command03[5] <= 1'd0;
				dfiphaseadapter0_command0_cs1[0] <= 1'd1;
				dfiphaseadapter0_valid <= 1'd1;
			end
			3'd4: begin
				dfiphaseadapter0_command00[0] <= 1'd0;
				dfiphaseadapter0_command00[1] <= 1'd1;
				dfiphaseadapter0_command00[2] <= 1'd0;
				dfiphaseadapter0_command00[3] <= 1'd0;
				dfiphaseadapter0_command00[4] <= 1'd0;
				dfiphaseadapter0_command00[5] <= 1'd0;
				dfiphaseadapter0_command01[0] <= dfi_p0_bank[0];
				dfiphaseadapter0_command01[1] <= dfi_p0_bank[1];
				dfiphaseadapter0_command01[2] <= dfi_p0_bank[2];
				dfiphaseadapter0_command01[3] <= 1'd0;
				dfiphaseadapter0_command01[4] <= dfi_p0_address[9];
				dfiphaseadapter0_command01[5] <= dfi_p0_address[10];
				dfiphaseadapter0_command0_cs0[0] <= 1'd1;
				dfiphaseadapter0_command02[0] <= 1'd0;
				dfiphaseadapter0_command02[1] <= 1'd1;
				dfiphaseadapter0_command02[2] <= 1'd0;
				dfiphaseadapter0_command02[3] <= 1'd0;
				dfiphaseadapter0_command02[4] <= 1'd1;
				dfiphaseadapter0_command02[5] <= dfi_p0_address[8];
				dfiphaseadapter0_command03[0] <= dfi_p0_address[2];
				dfiphaseadapter0_command03[1] <= dfi_p0_address[3];
				dfiphaseadapter0_command03[2] <= dfi_p0_address[4];
				dfiphaseadapter0_command03[3] <= dfi_p0_address[5];
				dfiphaseadapter0_command03[4] <= dfi_p0_address[6];
				dfiphaseadapter0_command03[5] <= dfi_p0_address[7];
				dfiphaseadapter0_command0_cs1[0] <= 1'd1;
				dfiphaseadapter0_valid <= 1'd1;
			end
			3'd5: begin
				case (dfi_p0_mw)
					1'd0: begin
						dfiphaseadapter0_command00[0] <= 1'd0;
						dfiphaseadapter0_command00[1] <= 1'd0;
						dfiphaseadapter0_command00[2] <= 1'd1;
						dfiphaseadapter0_command00[3] <= 1'd0;
						dfiphaseadapter0_command00[4] <= 1'd0;
						dfiphaseadapter0_command00[5] <= 1'd0;
						dfiphaseadapter0_command01[0] <= dfi_p0_bank[0];
						dfiphaseadapter0_command01[1] <= dfi_p0_bank[1];
						dfiphaseadapter0_command01[2] <= dfi_p0_bank[2];
						dfiphaseadapter0_command01[3] <= 1'd0;
						dfiphaseadapter0_command01[4] <= dfi_p0_address[9];
						dfiphaseadapter0_command01[5] <= dfi_p0_address[10];
						dfiphaseadapter0_command0_cs0[0] <= 1'd1;
						dfiphaseadapter0_command02[0] <= 1'd0;
						dfiphaseadapter0_command02[1] <= 1'd1;
						dfiphaseadapter0_command02[2] <= 1'd0;
						dfiphaseadapter0_command02[3] <= 1'd0;
						dfiphaseadapter0_command02[4] <= 1'd1;
						dfiphaseadapter0_command02[5] <= dfi_p0_address[8];
						dfiphaseadapter0_command03[0] <= dfi_p0_address[2];
						dfiphaseadapter0_command03[1] <= dfi_p0_address[3];
						dfiphaseadapter0_command03[2] <= dfi_p0_address[4];
						dfiphaseadapter0_command03[3] <= dfi_p0_address[5];
						dfiphaseadapter0_command03[4] <= dfi_p0_address[6];
						dfiphaseadapter0_command03[5] <= dfi_p0_address[7];
						dfiphaseadapter0_command0_cs1[0] <= 1'd1;
						dfiphaseadapter0_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter0_command00[0] <= 1'd0;
						dfiphaseadapter0_command00[1] <= 1'd0;
						dfiphaseadapter0_command00[2] <= 1'd1;
						dfiphaseadapter0_command00[3] <= 1'd1;
						dfiphaseadapter0_command00[4] <= 1'd0;
						dfiphaseadapter0_command00[5] <= 1'd0;
						dfiphaseadapter0_command01[0] <= dfi_p0_bank[0];
						dfiphaseadapter0_command01[1] <= dfi_p0_bank[1];
						dfiphaseadapter0_command01[2] <= dfi_p0_bank[2];
						dfiphaseadapter0_command01[3] <= 1'd0;
						dfiphaseadapter0_command01[4] <= dfi_p0_address[9];
						dfiphaseadapter0_command01[5] <= dfi_p0_address[10];
						dfiphaseadapter0_command0_cs0[0] <= 1'd1;
						dfiphaseadapter0_command02[0] <= 1'd0;
						dfiphaseadapter0_command02[1] <= 1'd1;
						dfiphaseadapter0_command02[2] <= 1'd0;
						dfiphaseadapter0_command02[3] <= 1'd0;
						dfiphaseadapter0_command02[4] <= 1'd1;
						dfiphaseadapter0_command02[5] <= dfi_p0_address[8];
						dfiphaseadapter0_command03[0] <= dfi_p0_address[2];
						dfiphaseadapter0_command03[1] <= dfi_p0_address[3];
						dfiphaseadapter0_command03[2] <= dfi_p0_address[4];
						dfiphaseadapter0_command03[3] <= dfi_p0_address[5];
						dfiphaseadapter0_command03[4] <= dfi_p0_address[6];
						dfiphaseadapter0_command03[5] <= dfi_p0_address[7];
						dfiphaseadapter0_command0_cs1[0] <= 1'd1;
						dfiphaseadapter0_valid <= 1'd1;
					end
				endcase
			end
			3'd6: begin
				dfiphaseadapter0_command00[0] <= 1'd0;
				dfiphaseadapter0_command00[1] <= 1'd0;
				dfiphaseadapter0_command00[2] <= 1'd0;
				dfiphaseadapter0_command00[3] <= 1'd0;
				dfiphaseadapter0_command00[4] <= 1'd0;
				dfiphaseadapter0_command00[5] <= 1'd0;
				dfiphaseadapter0_command01[0] <= 1'd0;
				dfiphaseadapter0_command01[1] <= 1'd0;
				dfiphaseadapter0_command01[2] <= 1'd0;
				dfiphaseadapter0_command01[3] <= 1'd0;
				dfiphaseadapter0_command01[4] <= 1'd0;
				dfiphaseadapter0_command01[5] <= 1'd0;
				dfiphaseadapter0_command02[0] <= 1'd0;
				dfiphaseadapter0_command02[1] <= 1'd0;
				dfiphaseadapter0_command02[2] <= 1'd0;
				dfiphaseadapter0_command02[3] <= 1'd1;
				dfiphaseadapter0_command02[4] <= 1'd0;
				dfiphaseadapter0_command02[5] <= dfi_p0_address[10];
				dfiphaseadapter0_command03[0] <= dfi_p0_bank[0];
				dfiphaseadapter0_command03[1] <= dfi_p0_bank[1];
				dfiphaseadapter0_command03[2] <= dfi_p0_bank[2];
				dfiphaseadapter0_command03[3] <= 1'd0;
				dfiphaseadapter0_command03[4] <= 1'd0;
				dfiphaseadapter0_command03[5] <= 1'd0;
				dfiphaseadapter0_command0_cs1[0] <= 1'd1;
				dfiphaseadapter0_valid <= 1'd1;
			end
			3'd7: begin
				dfiphaseadapter0_command00[0] <= 1'd0;
				dfiphaseadapter0_command00[1] <= 1'd1;
				dfiphaseadapter0_command00[2] <= 1'd1;
				dfiphaseadapter0_command00[3] <= 1'd0;
				dfiphaseadapter0_command00[4] <= 1'd0;
				dfiphaseadapter0_command00[5] <= dfi_p0_address[7];
				dfiphaseadapter0_command01[0] <= dfi_p0_bank[0];
				dfiphaseadapter0_command01[1] <= dfi_p0_bank[1];
				dfiphaseadapter0_command01[2] <= dfi_p0_bank[2];
				dfiphaseadapter0_command01[3] <= dfi_p0_bank[3];
				dfiphaseadapter0_command01[4] <= dfi_p0_bank[4];
				dfiphaseadapter0_command01[5] <= dfi_p0_bank[5];
				dfiphaseadapter0_command0_cs0[0] <= 1'd1;
				dfiphaseadapter0_command02[0] <= 1'd0;
				dfiphaseadapter0_command02[1] <= 1'd1;
				dfiphaseadapter0_command02[2] <= 1'd1;
				dfiphaseadapter0_command02[3] <= 1'd0;
				dfiphaseadapter0_command02[4] <= 1'd1;
				dfiphaseadapter0_command02[5] <= dfi_p0_address[6];
				dfiphaseadapter0_command03[0] <= dfi_p0_address[0];
				dfiphaseadapter0_command03[1] <= dfi_p0_address[1];
				dfiphaseadapter0_command03[2] <= dfi_p0_address[2];
				dfiphaseadapter0_command03[3] <= dfi_p0_address[3];
				dfiphaseadapter0_command03[4] <= dfi_p0_address[4];
				dfiphaseadapter0_command03[5] <= dfi_p0_address[5];
				dfiphaseadapter0_command0_cs1[0] <= 1'd1;
				dfiphaseadapter0_valid <= 1'd1;
			end
			default: begin
				dfiphaseadapter0_command00[0] <= 1'd0;
				dfiphaseadapter0_command00[1] <= 1'd0;
				dfiphaseadapter0_command00[2] <= 1'd0;
				dfiphaseadapter0_command00[3] <= 1'd0;
				dfiphaseadapter0_command00[4] <= 1'd0;
				dfiphaseadapter0_command00[5] <= 1'd0;
				dfiphaseadapter0_command01[0] <= 1'd0;
				dfiphaseadapter0_command01[1] <= 1'd0;
				dfiphaseadapter0_command01[2] <= 1'd0;
				dfiphaseadapter0_command01[3] <= 1'd0;
				dfiphaseadapter0_command01[4] <= 1'd0;
				dfiphaseadapter0_command01[5] <= 1'd0;
				dfiphaseadapter0_command02[0] <= 1'd0;
				dfiphaseadapter0_command02[1] <= 1'd0;
				dfiphaseadapter0_command02[2] <= 1'd0;
				dfiphaseadapter0_command02[3] <= 1'd0;
				dfiphaseadapter0_command02[4] <= 1'd0;
				dfiphaseadapter0_command02[5] <= 1'd0;
				dfiphaseadapter0_command03[0] <= 1'd0;
				dfiphaseadapter0_command03[1] <= 1'd0;
				dfiphaseadapter0_command03[2] <= 1'd0;
				dfiphaseadapter0_command03[3] <= 1'd0;
				dfiphaseadapter0_command03[4] <= 1'd0;
				dfiphaseadapter0_command03[5] <= 1'd0;
				dfiphaseadapter0_valid <= 1'd0;
			end
		endcase
	end
// synthesis translate_off
	dummy_d_1 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_2;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter1_cs <= 4'd0;
	dfiphaseadapter1_cs[1:0] <= dfiphaseadapter1_command1_cs0;
	dfiphaseadapter1_cs[3:2] <= dfiphaseadapter1_command1_cs1;
// synthesis translate_off
	dummy_d_2 <= dummy_s;
// synthesis translate_on
end
assign dfiphaseadapter10 = dfiphaseadapter1_command10;
assign dfiphaseadapter11 = dfiphaseadapter1_command11;
assign dfiphaseadapter12 = dfiphaseadapter1_command12;
assign dfiphaseadapter13 = dfiphaseadapter1_command13;
assign dfiphaseadapter1_dfi_cmd = {(~dfi_p1_cas_n), (~dfi_p1_ras_n), (~dfi_p1_we_n)};

// synthesis translate_off
reg dummy_d_3;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter1_valid <= 1'd0;
	dfiphaseadapter1_command1_cs0 <= 2'd0;
	dfiphaseadapter1_command10 <= 6'd0;
	dfiphaseadapter1_command11 <= 6'd0;
	dfiphaseadapter1_command1_cs1 <= 2'd0;
	dfiphaseadapter1_command12 <= 6'd0;
	dfiphaseadapter1_command13 <= 6'd0;
	if ((dfi_p1_cs_n == 1'd0)) begin
		case (dfiphaseadapter1_dfi_cmd)
			1'd1: begin
				case (dfi_p1_bank)
					1'd0: begin
						dfiphaseadapter1_command10[0] <= 1'd0;
						dfiphaseadapter1_command10[1] <= 1'd0;
						dfiphaseadapter1_command10[2] <= 1'd0;
						dfiphaseadapter1_command10[3] <= 1'd0;
						dfiphaseadapter1_command10[4] <= 1'd0;
						dfiphaseadapter1_command10[5] <= 1'd0;
						dfiphaseadapter1_command11[0] <= 1'd0;
						dfiphaseadapter1_command11[1] <= 1'd0;
						dfiphaseadapter1_command11[2] <= 1'd0;
						dfiphaseadapter1_command11[3] <= 1'd0;
						dfiphaseadapter1_command11[4] <= 1'd0;
						dfiphaseadapter1_command11[5] <= 1'd0;
						dfiphaseadapter1_command12[0] <= 1'd0;
						dfiphaseadapter1_command12[1] <= 1'd0;
						dfiphaseadapter1_command12[2] <= 1'd0;
						dfiphaseadapter1_command12[3] <= 1'd0;
						dfiphaseadapter1_command12[4] <= 1'd0;
						dfiphaseadapter1_command12[5] <= dfi_p1_address[6];
						dfiphaseadapter1_command13[0] <= dfi_p1_address[0];
						dfiphaseadapter1_command13[1] <= dfi_p1_address[1];
						dfiphaseadapter1_command13[2] <= dfi_p1_address[2];
						dfiphaseadapter1_command13[3] <= dfi_p1_address[3];
						dfiphaseadapter1_command13[4] <= dfi_p1_address[4];
						dfiphaseadapter1_command13[5] <= dfi_p1_address[5];
						dfiphaseadapter1_command1_cs1[0] <= 1'd1;
						dfiphaseadapter1_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter1_command10[0] <= 1'd0;
						dfiphaseadapter1_command10[1] <= 1'd1;
						dfiphaseadapter1_command10[2] <= 1'd1;
						dfiphaseadapter1_command10[3] <= 1'd1;
						dfiphaseadapter1_command10[4] <= 1'd0;
						dfiphaseadapter1_command10[5] <= 1'd0;
						dfiphaseadapter1_command11[0] <= dfi_p1_address[0];
						dfiphaseadapter1_command11[1] <= dfi_p1_address[1];
						dfiphaseadapter1_command11[2] <= dfi_p1_address[2];
						dfiphaseadapter1_command11[3] <= dfi_p1_address[3];
						dfiphaseadapter1_command11[4] <= dfi_p1_address[4];
						dfiphaseadapter1_command11[5] <= dfi_p1_address[5];
						dfiphaseadapter1_command1_cs0[0] <= 1'd1;
						dfiphaseadapter1_command12[0] <= 1'd0;
						dfiphaseadapter1_command12[1] <= 1'd1;
						dfiphaseadapter1_command12[2] <= 1'd0;
						dfiphaseadapter1_command12[3] <= 1'd0;
						dfiphaseadapter1_command12[4] <= 1'd1;
						dfiphaseadapter1_command12[5] <= dfi_p1_address[8];
						dfiphaseadapter1_command13[0] <= dfi_p1_address[2];
						dfiphaseadapter1_command13[1] <= dfi_p1_address[3];
						dfiphaseadapter1_command13[2] <= dfi_p1_address[4];
						dfiphaseadapter1_command13[3] <= dfi_p1_address[5];
						dfiphaseadapter1_command13[4] <= dfi_p1_address[6];
						dfiphaseadapter1_command13[5] <= dfi_p1_address[7];
						dfiphaseadapter1_command1_cs1[0] <= 1'd1;
						dfiphaseadapter1_valid <= 1'd1;
					end
					default: begin
						dfiphaseadapter1_command10[0] <= 1'd0;
						dfiphaseadapter1_command10[1] <= 1'd0;
						dfiphaseadapter1_command10[2] <= 1'd0;
						dfiphaseadapter1_command10[3] <= 1'd0;
						dfiphaseadapter1_command10[4] <= 1'd0;
						dfiphaseadapter1_command10[5] <= 1'd0;
						dfiphaseadapter1_command11[0] <= 1'd0;
						dfiphaseadapter1_command11[1] <= 1'd0;
						dfiphaseadapter1_command11[2] <= 1'd0;
						dfiphaseadapter1_command11[3] <= 1'd0;
						dfiphaseadapter1_command11[4] <= 1'd0;
						dfiphaseadapter1_command11[5] <= 1'd0;
						dfiphaseadapter1_command12[0] <= 1'd0;
						dfiphaseadapter1_command12[1] <= 1'd0;
						dfiphaseadapter1_command12[2] <= 1'd0;
						dfiphaseadapter1_command12[3] <= 1'd0;
						dfiphaseadapter1_command12[4] <= 1'd0;
						dfiphaseadapter1_command12[5] <= 1'd0;
						dfiphaseadapter1_command13[0] <= 1'd0;
						dfiphaseadapter1_command13[1] <= 1'd0;
						dfiphaseadapter1_command13[2] <= 1'd0;
						dfiphaseadapter1_command13[3] <= 1'd0;
						dfiphaseadapter1_command13[4] <= 1'd0;
						dfiphaseadapter1_command13[5] <= 1'd0;
						dfiphaseadapter1_valid <= 1'd0;
					end
				endcase
			end
			2'd2: begin
				dfiphaseadapter1_command10[0] <= 1'd1;
				dfiphaseadapter1_command10[1] <= 1'd0;
				dfiphaseadapter1_command10[2] <= dfi_p1_address[12];
				dfiphaseadapter1_command10[3] <= dfi_p1_address[13];
				dfiphaseadapter1_command10[4] <= dfi_p1_address[14];
				dfiphaseadapter1_command10[5] <= dfi_p1_address[15];
				dfiphaseadapter1_command11[0] <= dfi_p1_bank[0];
				dfiphaseadapter1_command11[1] <= dfi_p1_bank[1];
				dfiphaseadapter1_command11[2] <= dfi_p1_bank[2];
				dfiphaseadapter1_command11[3] <= dfi_p1_address[16];
				dfiphaseadapter1_command11[4] <= dfi_p1_address[10];
				dfiphaseadapter1_command11[5] <= dfi_p1_address[11];
				dfiphaseadapter1_command1_cs0[0] <= 1'd1;
				dfiphaseadapter1_command12[0] <= 1'd1;
				dfiphaseadapter1_command12[1] <= 1'd1;
				dfiphaseadapter1_command12[2] <= dfi_p1_address[6];
				dfiphaseadapter1_command12[3] <= dfi_p1_address[7];
				dfiphaseadapter1_command12[4] <= dfi_p1_address[8];
				dfiphaseadapter1_command12[5] <= dfi_p1_address[9];
				dfiphaseadapter1_command13[0] <= dfi_p1_address[0];
				dfiphaseadapter1_command13[1] <= dfi_p1_address[1];
				dfiphaseadapter1_command13[2] <= dfi_p1_address[2];
				dfiphaseadapter1_command13[3] <= dfi_p1_address[3];
				dfiphaseadapter1_command13[4] <= dfi_p1_address[4];
				dfiphaseadapter1_command13[5] <= dfi_p1_address[5];
				dfiphaseadapter1_command1_cs1[0] <= 1'd1;
				dfiphaseadapter1_valid <= 1'd1;
			end
			2'd3: begin
				dfiphaseadapter1_command10[0] <= 1'd0;
				dfiphaseadapter1_command10[1] <= 1'd0;
				dfiphaseadapter1_command10[2] <= 1'd0;
				dfiphaseadapter1_command10[3] <= 1'd0;
				dfiphaseadapter1_command10[4] <= 1'd0;
				dfiphaseadapter1_command10[5] <= 1'd0;
				dfiphaseadapter1_command11[0] <= 1'd0;
				dfiphaseadapter1_command11[1] <= 1'd0;
				dfiphaseadapter1_command11[2] <= 1'd0;
				dfiphaseadapter1_command11[3] <= 1'd0;
				dfiphaseadapter1_command11[4] <= 1'd0;
				dfiphaseadapter1_command11[5] <= 1'd0;
				dfiphaseadapter1_command12[0] <= 1'd0;
				dfiphaseadapter1_command12[1] <= 1'd0;
				dfiphaseadapter1_command12[2] <= 1'd0;
				dfiphaseadapter1_command12[3] <= 1'd0;
				dfiphaseadapter1_command12[4] <= 1'd1;
				dfiphaseadapter1_command12[5] <= dfi_p1_address[10];
				dfiphaseadapter1_command13[0] <= dfi_p1_bank[0];
				dfiphaseadapter1_command13[1] <= dfi_p1_bank[1];
				dfiphaseadapter1_command13[2] <= dfi_p1_bank[2];
				dfiphaseadapter1_command13[3] <= 1'd0;
				dfiphaseadapter1_command13[4] <= 1'd0;
				dfiphaseadapter1_command13[5] <= 1'd0;
				dfiphaseadapter1_command1_cs1[0] <= 1'd1;
				dfiphaseadapter1_valid <= 1'd1;
			end
			3'd4: begin
				dfiphaseadapter1_command10[0] <= 1'd0;
				dfiphaseadapter1_command10[1] <= 1'd1;
				dfiphaseadapter1_command10[2] <= 1'd0;
				dfiphaseadapter1_command10[3] <= 1'd0;
				dfiphaseadapter1_command10[4] <= 1'd0;
				dfiphaseadapter1_command10[5] <= 1'd0;
				dfiphaseadapter1_command11[0] <= dfi_p1_bank[0];
				dfiphaseadapter1_command11[1] <= dfi_p1_bank[1];
				dfiphaseadapter1_command11[2] <= dfi_p1_bank[2];
				dfiphaseadapter1_command11[3] <= 1'd0;
				dfiphaseadapter1_command11[4] <= dfi_p1_address[9];
				dfiphaseadapter1_command11[5] <= dfi_p1_address[10];
				dfiphaseadapter1_command1_cs0[0] <= 1'd1;
				dfiphaseadapter1_command12[0] <= 1'd0;
				dfiphaseadapter1_command12[1] <= 1'd1;
				dfiphaseadapter1_command12[2] <= 1'd0;
				dfiphaseadapter1_command12[3] <= 1'd0;
				dfiphaseadapter1_command12[4] <= 1'd1;
				dfiphaseadapter1_command12[5] <= dfi_p1_address[8];
				dfiphaseadapter1_command13[0] <= dfi_p1_address[2];
				dfiphaseadapter1_command13[1] <= dfi_p1_address[3];
				dfiphaseadapter1_command13[2] <= dfi_p1_address[4];
				dfiphaseadapter1_command13[3] <= dfi_p1_address[5];
				dfiphaseadapter1_command13[4] <= dfi_p1_address[6];
				dfiphaseadapter1_command13[5] <= dfi_p1_address[7];
				dfiphaseadapter1_command1_cs1[0] <= 1'd1;
				dfiphaseadapter1_valid <= 1'd1;
			end
			3'd5: begin
				case (dfi_p1_mw)
					1'd0: begin
						dfiphaseadapter1_command10[0] <= 1'd0;
						dfiphaseadapter1_command10[1] <= 1'd0;
						dfiphaseadapter1_command10[2] <= 1'd1;
						dfiphaseadapter1_command10[3] <= 1'd0;
						dfiphaseadapter1_command10[4] <= 1'd0;
						dfiphaseadapter1_command10[5] <= 1'd0;
						dfiphaseadapter1_command11[0] <= dfi_p1_bank[0];
						dfiphaseadapter1_command11[1] <= dfi_p1_bank[1];
						dfiphaseadapter1_command11[2] <= dfi_p1_bank[2];
						dfiphaseadapter1_command11[3] <= 1'd0;
						dfiphaseadapter1_command11[4] <= dfi_p1_address[9];
						dfiphaseadapter1_command11[5] <= dfi_p1_address[10];
						dfiphaseadapter1_command1_cs0[0] <= 1'd1;
						dfiphaseadapter1_command12[0] <= 1'd0;
						dfiphaseadapter1_command12[1] <= 1'd1;
						dfiphaseadapter1_command12[2] <= 1'd0;
						dfiphaseadapter1_command12[3] <= 1'd0;
						dfiphaseadapter1_command12[4] <= 1'd1;
						dfiphaseadapter1_command12[5] <= dfi_p1_address[8];
						dfiphaseadapter1_command13[0] <= dfi_p1_address[2];
						dfiphaseadapter1_command13[1] <= dfi_p1_address[3];
						dfiphaseadapter1_command13[2] <= dfi_p1_address[4];
						dfiphaseadapter1_command13[3] <= dfi_p1_address[5];
						dfiphaseadapter1_command13[4] <= dfi_p1_address[6];
						dfiphaseadapter1_command13[5] <= dfi_p1_address[7];
						dfiphaseadapter1_command1_cs1[0] <= 1'd1;
						dfiphaseadapter1_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter1_command10[0] <= 1'd0;
						dfiphaseadapter1_command10[1] <= 1'd0;
						dfiphaseadapter1_command10[2] <= 1'd1;
						dfiphaseadapter1_command10[3] <= 1'd1;
						dfiphaseadapter1_command10[4] <= 1'd0;
						dfiphaseadapter1_command10[5] <= 1'd0;
						dfiphaseadapter1_command11[0] <= dfi_p1_bank[0];
						dfiphaseadapter1_command11[1] <= dfi_p1_bank[1];
						dfiphaseadapter1_command11[2] <= dfi_p1_bank[2];
						dfiphaseadapter1_command11[3] <= 1'd0;
						dfiphaseadapter1_command11[4] <= dfi_p1_address[9];
						dfiphaseadapter1_command11[5] <= dfi_p1_address[10];
						dfiphaseadapter1_command1_cs0[0] <= 1'd1;
						dfiphaseadapter1_command12[0] <= 1'd0;
						dfiphaseadapter1_command12[1] <= 1'd1;
						dfiphaseadapter1_command12[2] <= 1'd0;
						dfiphaseadapter1_command12[3] <= 1'd0;
						dfiphaseadapter1_command12[4] <= 1'd1;
						dfiphaseadapter1_command12[5] <= dfi_p1_address[8];
						dfiphaseadapter1_command13[0] <= dfi_p1_address[2];
						dfiphaseadapter1_command13[1] <= dfi_p1_address[3];
						dfiphaseadapter1_command13[2] <= dfi_p1_address[4];
						dfiphaseadapter1_command13[3] <= dfi_p1_address[5];
						dfiphaseadapter1_command13[4] <= dfi_p1_address[6];
						dfiphaseadapter1_command13[5] <= dfi_p1_address[7];
						dfiphaseadapter1_command1_cs1[0] <= 1'd1;
						dfiphaseadapter1_valid <= 1'd1;
					end
				endcase
			end
			3'd6: begin
				dfiphaseadapter1_command10[0] <= 1'd0;
				dfiphaseadapter1_command10[1] <= 1'd0;
				dfiphaseadapter1_command10[2] <= 1'd0;
				dfiphaseadapter1_command10[3] <= 1'd0;
				dfiphaseadapter1_command10[4] <= 1'd0;
				dfiphaseadapter1_command10[5] <= 1'd0;
				dfiphaseadapter1_command11[0] <= 1'd0;
				dfiphaseadapter1_command11[1] <= 1'd0;
				dfiphaseadapter1_command11[2] <= 1'd0;
				dfiphaseadapter1_command11[3] <= 1'd0;
				dfiphaseadapter1_command11[4] <= 1'd0;
				dfiphaseadapter1_command11[5] <= 1'd0;
				dfiphaseadapter1_command12[0] <= 1'd0;
				dfiphaseadapter1_command12[1] <= 1'd0;
				dfiphaseadapter1_command12[2] <= 1'd0;
				dfiphaseadapter1_command12[3] <= 1'd1;
				dfiphaseadapter1_command12[4] <= 1'd0;
				dfiphaseadapter1_command12[5] <= dfi_p1_address[10];
				dfiphaseadapter1_command13[0] <= dfi_p1_bank[0];
				dfiphaseadapter1_command13[1] <= dfi_p1_bank[1];
				dfiphaseadapter1_command13[2] <= dfi_p1_bank[2];
				dfiphaseadapter1_command13[3] <= 1'd0;
				dfiphaseadapter1_command13[4] <= 1'd0;
				dfiphaseadapter1_command13[5] <= 1'd0;
				dfiphaseadapter1_command1_cs1[0] <= 1'd1;
				dfiphaseadapter1_valid <= 1'd1;
			end
			3'd7: begin
				dfiphaseadapter1_command10[0] <= 1'd0;
				dfiphaseadapter1_command10[1] <= 1'd1;
				dfiphaseadapter1_command10[2] <= 1'd1;
				dfiphaseadapter1_command10[3] <= 1'd0;
				dfiphaseadapter1_command10[4] <= 1'd0;
				dfiphaseadapter1_command10[5] <= dfi_p1_address[7];
				dfiphaseadapter1_command11[0] <= dfi_p1_bank[0];
				dfiphaseadapter1_command11[1] <= dfi_p1_bank[1];
				dfiphaseadapter1_command11[2] <= dfi_p1_bank[2];
				dfiphaseadapter1_command11[3] <= dfi_p1_bank[3];
				dfiphaseadapter1_command11[4] <= dfi_p1_bank[4];
				dfiphaseadapter1_command11[5] <= dfi_p1_bank[5];
				dfiphaseadapter1_command1_cs0[0] <= 1'd1;
				dfiphaseadapter1_command12[0] <= 1'd0;
				dfiphaseadapter1_command12[1] <= 1'd1;
				dfiphaseadapter1_command12[2] <= 1'd1;
				dfiphaseadapter1_command12[3] <= 1'd0;
				dfiphaseadapter1_command12[4] <= 1'd1;
				dfiphaseadapter1_command12[5] <= dfi_p1_address[6];
				dfiphaseadapter1_command13[0] <= dfi_p1_address[0];
				dfiphaseadapter1_command13[1] <= dfi_p1_address[1];
				dfiphaseadapter1_command13[2] <= dfi_p1_address[2];
				dfiphaseadapter1_command13[3] <= dfi_p1_address[3];
				dfiphaseadapter1_command13[4] <= dfi_p1_address[4];
				dfiphaseadapter1_command13[5] <= dfi_p1_address[5];
				dfiphaseadapter1_command1_cs1[0] <= 1'd1;
				dfiphaseadapter1_valid <= 1'd1;
			end
			default: begin
				dfiphaseadapter1_command10[0] <= 1'd0;
				dfiphaseadapter1_command10[1] <= 1'd0;
				dfiphaseadapter1_command10[2] <= 1'd0;
				dfiphaseadapter1_command10[3] <= 1'd0;
				dfiphaseadapter1_command10[4] <= 1'd0;
				dfiphaseadapter1_command10[5] <= 1'd0;
				dfiphaseadapter1_command11[0] <= 1'd0;
				dfiphaseadapter1_command11[1] <= 1'd0;
				dfiphaseadapter1_command11[2] <= 1'd0;
				dfiphaseadapter1_command11[3] <= 1'd0;
				dfiphaseadapter1_command11[4] <= 1'd0;
				dfiphaseadapter1_command11[5] <= 1'd0;
				dfiphaseadapter1_command12[0] <= 1'd0;
				dfiphaseadapter1_command12[1] <= 1'd0;
				dfiphaseadapter1_command12[2] <= 1'd0;
				dfiphaseadapter1_command12[3] <= 1'd0;
				dfiphaseadapter1_command12[4] <= 1'd0;
				dfiphaseadapter1_command12[5] <= 1'd0;
				dfiphaseadapter1_command13[0] <= 1'd0;
				dfiphaseadapter1_command13[1] <= 1'd0;
				dfiphaseadapter1_command13[2] <= 1'd0;
				dfiphaseadapter1_command13[3] <= 1'd0;
				dfiphaseadapter1_command13[4] <= 1'd0;
				dfiphaseadapter1_command13[5] <= 1'd0;
				dfiphaseadapter1_valid <= 1'd0;
			end
		endcase
	end
// synthesis translate_off
	dummy_d_3 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_4;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter2_cs <= 4'd0;
	dfiphaseadapter2_cs[1:0] <= dfiphaseadapter2_command2_cs0;
	dfiphaseadapter2_cs[3:2] <= dfiphaseadapter2_command2_cs1;
// synthesis translate_off
	dummy_d_4 <= dummy_s;
// synthesis translate_on
end
assign dfiphaseadapter20 = dfiphaseadapter2_command20;
assign dfiphaseadapter21 = dfiphaseadapter2_command21;
assign dfiphaseadapter22 = dfiphaseadapter2_command22;
assign dfiphaseadapter23 = dfiphaseadapter2_command23;
assign dfiphaseadapter2_dfi_cmd = {(~dfi_p2_cas_n), (~dfi_p2_ras_n), (~dfi_p2_we_n)};

// synthesis translate_off
reg dummy_d_5;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter2_valid <= 1'd0;
	dfiphaseadapter2_command2_cs0 <= 2'd0;
	dfiphaseadapter2_command20 <= 6'd0;
	dfiphaseadapter2_command21 <= 6'd0;
	dfiphaseadapter2_command2_cs1 <= 2'd0;
	dfiphaseadapter2_command22 <= 6'd0;
	dfiphaseadapter2_command23 <= 6'd0;
	if ((dfi_p2_cs_n == 1'd0)) begin
		case (dfiphaseadapter2_dfi_cmd)
			1'd1: begin
				case (dfi_p2_bank)
					1'd0: begin
						dfiphaseadapter2_command20[0] <= 1'd0;
						dfiphaseadapter2_command20[1] <= 1'd0;
						dfiphaseadapter2_command20[2] <= 1'd0;
						dfiphaseadapter2_command20[3] <= 1'd0;
						dfiphaseadapter2_command20[4] <= 1'd0;
						dfiphaseadapter2_command20[5] <= 1'd0;
						dfiphaseadapter2_command21[0] <= 1'd0;
						dfiphaseadapter2_command21[1] <= 1'd0;
						dfiphaseadapter2_command21[2] <= 1'd0;
						dfiphaseadapter2_command21[3] <= 1'd0;
						dfiphaseadapter2_command21[4] <= 1'd0;
						dfiphaseadapter2_command21[5] <= 1'd0;
						dfiphaseadapter2_command22[0] <= 1'd0;
						dfiphaseadapter2_command22[1] <= 1'd0;
						dfiphaseadapter2_command22[2] <= 1'd0;
						dfiphaseadapter2_command22[3] <= 1'd0;
						dfiphaseadapter2_command22[4] <= 1'd0;
						dfiphaseadapter2_command22[5] <= dfi_p2_address[6];
						dfiphaseadapter2_command23[0] <= dfi_p2_address[0];
						dfiphaseadapter2_command23[1] <= dfi_p2_address[1];
						dfiphaseadapter2_command23[2] <= dfi_p2_address[2];
						dfiphaseadapter2_command23[3] <= dfi_p2_address[3];
						dfiphaseadapter2_command23[4] <= dfi_p2_address[4];
						dfiphaseadapter2_command23[5] <= dfi_p2_address[5];
						dfiphaseadapter2_command2_cs1[0] <= 1'd1;
						dfiphaseadapter2_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter2_command20[0] <= 1'd0;
						dfiphaseadapter2_command20[1] <= 1'd1;
						dfiphaseadapter2_command20[2] <= 1'd1;
						dfiphaseadapter2_command20[3] <= 1'd1;
						dfiphaseadapter2_command20[4] <= 1'd0;
						dfiphaseadapter2_command20[5] <= 1'd0;
						dfiphaseadapter2_command21[0] <= dfi_p2_address[0];
						dfiphaseadapter2_command21[1] <= dfi_p2_address[1];
						dfiphaseadapter2_command21[2] <= dfi_p2_address[2];
						dfiphaseadapter2_command21[3] <= dfi_p2_address[3];
						dfiphaseadapter2_command21[4] <= dfi_p2_address[4];
						dfiphaseadapter2_command21[5] <= dfi_p2_address[5];
						dfiphaseadapter2_command2_cs0[0] <= 1'd1;
						dfiphaseadapter2_command22[0] <= 1'd0;
						dfiphaseadapter2_command22[1] <= 1'd1;
						dfiphaseadapter2_command22[2] <= 1'd0;
						dfiphaseadapter2_command22[3] <= 1'd0;
						dfiphaseadapter2_command22[4] <= 1'd1;
						dfiphaseadapter2_command22[5] <= dfi_p2_address[8];
						dfiphaseadapter2_command23[0] <= dfi_p2_address[2];
						dfiphaseadapter2_command23[1] <= dfi_p2_address[3];
						dfiphaseadapter2_command23[2] <= dfi_p2_address[4];
						dfiphaseadapter2_command23[3] <= dfi_p2_address[5];
						dfiphaseadapter2_command23[4] <= dfi_p2_address[6];
						dfiphaseadapter2_command23[5] <= dfi_p2_address[7];
						dfiphaseadapter2_command2_cs1[0] <= 1'd1;
						dfiphaseadapter2_valid <= 1'd1;
					end
					default: begin
						dfiphaseadapter2_command20[0] <= 1'd0;
						dfiphaseadapter2_command20[1] <= 1'd0;
						dfiphaseadapter2_command20[2] <= 1'd0;
						dfiphaseadapter2_command20[3] <= 1'd0;
						dfiphaseadapter2_command20[4] <= 1'd0;
						dfiphaseadapter2_command20[5] <= 1'd0;
						dfiphaseadapter2_command21[0] <= 1'd0;
						dfiphaseadapter2_command21[1] <= 1'd0;
						dfiphaseadapter2_command21[2] <= 1'd0;
						dfiphaseadapter2_command21[3] <= 1'd0;
						dfiphaseadapter2_command21[4] <= 1'd0;
						dfiphaseadapter2_command21[5] <= 1'd0;
						dfiphaseadapter2_command22[0] <= 1'd0;
						dfiphaseadapter2_command22[1] <= 1'd0;
						dfiphaseadapter2_command22[2] <= 1'd0;
						dfiphaseadapter2_command22[3] <= 1'd0;
						dfiphaseadapter2_command22[4] <= 1'd0;
						dfiphaseadapter2_command22[5] <= 1'd0;
						dfiphaseadapter2_command23[0] <= 1'd0;
						dfiphaseadapter2_command23[1] <= 1'd0;
						dfiphaseadapter2_command23[2] <= 1'd0;
						dfiphaseadapter2_command23[3] <= 1'd0;
						dfiphaseadapter2_command23[4] <= 1'd0;
						dfiphaseadapter2_command23[5] <= 1'd0;
						dfiphaseadapter2_valid <= 1'd0;
					end
				endcase
			end
			2'd2: begin
				dfiphaseadapter2_command20[0] <= 1'd1;
				dfiphaseadapter2_command20[1] <= 1'd0;
				dfiphaseadapter2_command20[2] <= dfi_p2_address[12];
				dfiphaseadapter2_command20[3] <= dfi_p2_address[13];
				dfiphaseadapter2_command20[4] <= dfi_p2_address[14];
				dfiphaseadapter2_command20[5] <= dfi_p2_address[15];
				dfiphaseadapter2_command21[0] <= dfi_p2_bank[0];
				dfiphaseadapter2_command21[1] <= dfi_p2_bank[1];
				dfiphaseadapter2_command21[2] <= dfi_p2_bank[2];
				dfiphaseadapter2_command21[3] <= dfi_p2_address[16];
				dfiphaseadapter2_command21[4] <= dfi_p2_address[10];
				dfiphaseadapter2_command21[5] <= dfi_p2_address[11];
				dfiphaseadapter2_command2_cs0[0] <= 1'd1;
				dfiphaseadapter2_command22[0] <= 1'd1;
				dfiphaseadapter2_command22[1] <= 1'd1;
				dfiphaseadapter2_command22[2] <= dfi_p2_address[6];
				dfiphaseadapter2_command22[3] <= dfi_p2_address[7];
				dfiphaseadapter2_command22[4] <= dfi_p2_address[8];
				dfiphaseadapter2_command22[5] <= dfi_p2_address[9];
				dfiphaseadapter2_command23[0] <= dfi_p2_address[0];
				dfiphaseadapter2_command23[1] <= dfi_p2_address[1];
				dfiphaseadapter2_command23[2] <= dfi_p2_address[2];
				dfiphaseadapter2_command23[3] <= dfi_p2_address[3];
				dfiphaseadapter2_command23[4] <= dfi_p2_address[4];
				dfiphaseadapter2_command23[5] <= dfi_p2_address[5];
				dfiphaseadapter2_command2_cs1[0] <= 1'd1;
				dfiphaseadapter2_valid <= 1'd1;
			end
			2'd3: begin
				dfiphaseadapter2_command20[0] <= 1'd0;
				dfiphaseadapter2_command20[1] <= 1'd0;
				dfiphaseadapter2_command20[2] <= 1'd0;
				dfiphaseadapter2_command20[3] <= 1'd0;
				dfiphaseadapter2_command20[4] <= 1'd0;
				dfiphaseadapter2_command20[5] <= 1'd0;
				dfiphaseadapter2_command21[0] <= 1'd0;
				dfiphaseadapter2_command21[1] <= 1'd0;
				dfiphaseadapter2_command21[2] <= 1'd0;
				dfiphaseadapter2_command21[3] <= 1'd0;
				dfiphaseadapter2_command21[4] <= 1'd0;
				dfiphaseadapter2_command21[5] <= 1'd0;
				dfiphaseadapter2_command22[0] <= 1'd0;
				dfiphaseadapter2_command22[1] <= 1'd0;
				dfiphaseadapter2_command22[2] <= 1'd0;
				dfiphaseadapter2_command22[3] <= 1'd0;
				dfiphaseadapter2_command22[4] <= 1'd1;
				dfiphaseadapter2_command22[5] <= dfi_p2_address[10];
				dfiphaseadapter2_command23[0] <= dfi_p2_bank[0];
				dfiphaseadapter2_command23[1] <= dfi_p2_bank[1];
				dfiphaseadapter2_command23[2] <= dfi_p2_bank[2];
				dfiphaseadapter2_command23[3] <= 1'd0;
				dfiphaseadapter2_command23[4] <= 1'd0;
				dfiphaseadapter2_command23[5] <= 1'd0;
				dfiphaseadapter2_command2_cs1[0] <= 1'd1;
				dfiphaseadapter2_valid <= 1'd1;
			end
			3'd4: begin
				dfiphaseadapter2_command20[0] <= 1'd0;
				dfiphaseadapter2_command20[1] <= 1'd1;
				dfiphaseadapter2_command20[2] <= 1'd0;
				dfiphaseadapter2_command20[3] <= 1'd0;
				dfiphaseadapter2_command20[4] <= 1'd0;
				dfiphaseadapter2_command20[5] <= 1'd0;
				dfiphaseadapter2_command21[0] <= dfi_p2_bank[0];
				dfiphaseadapter2_command21[1] <= dfi_p2_bank[1];
				dfiphaseadapter2_command21[2] <= dfi_p2_bank[2];
				dfiphaseadapter2_command21[3] <= 1'd0;
				dfiphaseadapter2_command21[4] <= dfi_p2_address[9];
				dfiphaseadapter2_command21[5] <= dfi_p2_address[10];
				dfiphaseadapter2_command2_cs0[0] <= 1'd1;
				dfiphaseadapter2_command22[0] <= 1'd0;
				dfiphaseadapter2_command22[1] <= 1'd1;
				dfiphaseadapter2_command22[2] <= 1'd0;
				dfiphaseadapter2_command22[3] <= 1'd0;
				dfiphaseadapter2_command22[4] <= 1'd1;
				dfiphaseadapter2_command22[5] <= dfi_p2_address[8];
				dfiphaseadapter2_command23[0] <= dfi_p2_address[2];
				dfiphaseadapter2_command23[1] <= dfi_p2_address[3];
				dfiphaseadapter2_command23[2] <= dfi_p2_address[4];
				dfiphaseadapter2_command23[3] <= dfi_p2_address[5];
				dfiphaseadapter2_command23[4] <= dfi_p2_address[6];
				dfiphaseadapter2_command23[5] <= dfi_p2_address[7];
				dfiphaseadapter2_command2_cs1[0] <= 1'd1;
				dfiphaseadapter2_valid <= 1'd1;
			end
			3'd5: begin
				case (dfi_p2_mw)
					1'd0: begin
						dfiphaseadapter2_command20[0] <= 1'd0;
						dfiphaseadapter2_command20[1] <= 1'd0;
						dfiphaseadapter2_command20[2] <= 1'd1;
						dfiphaseadapter2_command20[3] <= 1'd0;
						dfiphaseadapter2_command20[4] <= 1'd0;
						dfiphaseadapter2_command20[5] <= 1'd0;
						dfiphaseadapter2_command21[0] <= dfi_p2_bank[0];
						dfiphaseadapter2_command21[1] <= dfi_p2_bank[1];
						dfiphaseadapter2_command21[2] <= dfi_p2_bank[2];
						dfiphaseadapter2_command21[3] <= 1'd0;
						dfiphaseadapter2_command21[4] <= dfi_p2_address[9];
						dfiphaseadapter2_command21[5] <= dfi_p2_address[10];
						dfiphaseadapter2_command2_cs0[0] <= 1'd1;
						dfiphaseadapter2_command22[0] <= 1'd0;
						dfiphaseadapter2_command22[1] <= 1'd1;
						dfiphaseadapter2_command22[2] <= 1'd0;
						dfiphaseadapter2_command22[3] <= 1'd0;
						dfiphaseadapter2_command22[4] <= 1'd1;
						dfiphaseadapter2_command22[5] <= dfi_p2_address[8];
						dfiphaseadapter2_command23[0] <= dfi_p2_address[2];
						dfiphaseadapter2_command23[1] <= dfi_p2_address[3];
						dfiphaseadapter2_command23[2] <= dfi_p2_address[4];
						dfiphaseadapter2_command23[3] <= dfi_p2_address[5];
						dfiphaseadapter2_command23[4] <= dfi_p2_address[6];
						dfiphaseadapter2_command23[5] <= dfi_p2_address[7];
						dfiphaseadapter2_command2_cs1[0] <= 1'd1;
						dfiphaseadapter2_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter2_command20[0] <= 1'd0;
						dfiphaseadapter2_command20[1] <= 1'd0;
						dfiphaseadapter2_command20[2] <= 1'd1;
						dfiphaseadapter2_command20[3] <= 1'd1;
						dfiphaseadapter2_command20[4] <= 1'd0;
						dfiphaseadapter2_command20[5] <= 1'd0;
						dfiphaseadapter2_command21[0] <= dfi_p2_bank[0];
						dfiphaseadapter2_command21[1] <= dfi_p2_bank[1];
						dfiphaseadapter2_command21[2] <= dfi_p2_bank[2];
						dfiphaseadapter2_command21[3] <= 1'd0;
						dfiphaseadapter2_command21[4] <= dfi_p2_address[9];
						dfiphaseadapter2_command21[5] <= dfi_p2_address[10];
						dfiphaseadapter2_command2_cs0[0] <= 1'd1;
						dfiphaseadapter2_command22[0] <= 1'd0;
						dfiphaseadapter2_command22[1] <= 1'd1;
						dfiphaseadapter2_command22[2] <= 1'd0;
						dfiphaseadapter2_command22[3] <= 1'd0;
						dfiphaseadapter2_command22[4] <= 1'd1;
						dfiphaseadapter2_command22[5] <= dfi_p2_address[8];
						dfiphaseadapter2_command23[0] <= dfi_p2_address[2];
						dfiphaseadapter2_command23[1] <= dfi_p2_address[3];
						dfiphaseadapter2_command23[2] <= dfi_p2_address[4];
						dfiphaseadapter2_command23[3] <= dfi_p2_address[5];
						dfiphaseadapter2_command23[4] <= dfi_p2_address[6];
						dfiphaseadapter2_command23[5] <= dfi_p2_address[7];
						dfiphaseadapter2_command2_cs1[0] <= 1'd1;
						dfiphaseadapter2_valid <= 1'd1;
					end
				endcase
			end
			3'd6: begin
				dfiphaseadapter2_command20[0] <= 1'd0;
				dfiphaseadapter2_command20[1] <= 1'd0;
				dfiphaseadapter2_command20[2] <= 1'd0;
				dfiphaseadapter2_command20[3] <= 1'd0;
				dfiphaseadapter2_command20[4] <= 1'd0;
				dfiphaseadapter2_command20[5] <= 1'd0;
				dfiphaseadapter2_command21[0] <= 1'd0;
				dfiphaseadapter2_command21[1] <= 1'd0;
				dfiphaseadapter2_command21[2] <= 1'd0;
				dfiphaseadapter2_command21[3] <= 1'd0;
				dfiphaseadapter2_command21[4] <= 1'd0;
				dfiphaseadapter2_command21[5] <= 1'd0;
				dfiphaseadapter2_command22[0] <= 1'd0;
				dfiphaseadapter2_command22[1] <= 1'd0;
				dfiphaseadapter2_command22[2] <= 1'd0;
				dfiphaseadapter2_command22[3] <= 1'd1;
				dfiphaseadapter2_command22[4] <= 1'd0;
				dfiphaseadapter2_command22[5] <= dfi_p2_address[10];
				dfiphaseadapter2_command23[0] <= dfi_p2_bank[0];
				dfiphaseadapter2_command23[1] <= dfi_p2_bank[1];
				dfiphaseadapter2_command23[2] <= dfi_p2_bank[2];
				dfiphaseadapter2_command23[3] <= 1'd0;
				dfiphaseadapter2_command23[4] <= 1'd0;
				dfiphaseadapter2_command23[5] <= 1'd0;
				dfiphaseadapter2_command2_cs1[0] <= 1'd1;
				dfiphaseadapter2_valid <= 1'd1;
			end
			3'd7: begin
				dfiphaseadapter2_command20[0] <= 1'd0;
				dfiphaseadapter2_command20[1] <= 1'd1;
				dfiphaseadapter2_command20[2] <= 1'd1;
				dfiphaseadapter2_command20[3] <= 1'd0;
				dfiphaseadapter2_command20[4] <= 1'd0;
				dfiphaseadapter2_command20[5] <= dfi_p2_address[7];
				dfiphaseadapter2_command21[0] <= dfi_p2_bank[0];
				dfiphaseadapter2_command21[1] <= dfi_p2_bank[1];
				dfiphaseadapter2_command21[2] <= dfi_p2_bank[2];
				dfiphaseadapter2_command21[3] <= dfi_p2_bank[3];
				dfiphaseadapter2_command21[4] <= dfi_p2_bank[4];
				dfiphaseadapter2_command21[5] <= dfi_p2_bank[5];
				dfiphaseadapter2_command2_cs0[0] <= 1'd1;
				dfiphaseadapter2_command22[0] <= 1'd0;
				dfiphaseadapter2_command22[1] <= 1'd1;
				dfiphaseadapter2_command22[2] <= 1'd1;
				dfiphaseadapter2_command22[3] <= 1'd0;
				dfiphaseadapter2_command22[4] <= 1'd1;
				dfiphaseadapter2_command22[5] <= dfi_p2_address[6];
				dfiphaseadapter2_command23[0] <= dfi_p2_address[0];
				dfiphaseadapter2_command23[1] <= dfi_p2_address[1];
				dfiphaseadapter2_command23[2] <= dfi_p2_address[2];
				dfiphaseadapter2_command23[3] <= dfi_p2_address[3];
				dfiphaseadapter2_command23[4] <= dfi_p2_address[4];
				dfiphaseadapter2_command23[5] <= dfi_p2_address[5];
				dfiphaseadapter2_command2_cs1[0] <= 1'd1;
				dfiphaseadapter2_valid <= 1'd1;
			end
			default: begin
				dfiphaseadapter2_command20[0] <= 1'd0;
				dfiphaseadapter2_command20[1] <= 1'd0;
				dfiphaseadapter2_command20[2] <= 1'd0;
				dfiphaseadapter2_command20[3] <= 1'd0;
				dfiphaseadapter2_command20[4] <= 1'd0;
				dfiphaseadapter2_command20[5] <= 1'd0;
				dfiphaseadapter2_command21[0] <= 1'd0;
				dfiphaseadapter2_command21[1] <= 1'd0;
				dfiphaseadapter2_command21[2] <= 1'd0;
				dfiphaseadapter2_command21[3] <= 1'd0;
				dfiphaseadapter2_command21[4] <= 1'd0;
				dfiphaseadapter2_command21[5] <= 1'd0;
				dfiphaseadapter2_command22[0] <= 1'd0;
				dfiphaseadapter2_command22[1] <= 1'd0;
				dfiphaseadapter2_command22[2] <= 1'd0;
				dfiphaseadapter2_command22[3] <= 1'd0;
				dfiphaseadapter2_command22[4] <= 1'd0;
				dfiphaseadapter2_command22[5] <= 1'd0;
				dfiphaseadapter2_command23[0] <= 1'd0;
				dfiphaseadapter2_command23[1] <= 1'd0;
				dfiphaseadapter2_command23[2] <= 1'd0;
				dfiphaseadapter2_command23[3] <= 1'd0;
				dfiphaseadapter2_command23[4] <= 1'd0;
				dfiphaseadapter2_command23[5] <= 1'd0;
				dfiphaseadapter2_valid <= 1'd0;
			end
		endcase
	end
// synthesis translate_off
	dummy_d_5 <= dummy_s;
// synthesis translate_on
end

// synthesis translate_off
reg dummy_d_6;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter3_cs <= 4'd0;
	dfiphaseadapter3_cs[1:0] <= dfiphaseadapter3_command3_cs0;
	dfiphaseadapter3_cs[3:2] <= dfiphaseadapter3_command3_cs1;
// synthesis translate_off
	dummy_d_6 <= dummy_s;
// synthesis translate_on
end
assign dfiphaseadapter30 = dfiphaseadapter3_command30;
assign dfiphaseadapter31 = dfiphaseadapter3_command31;
assign dfiphaseadapter32 = dfiphaseadapter3_command32;
assign dfiphaseadapter33 = dfiphaseadapter3_command33;
assign dfiphaseadapter3_dfi_cmd = {(~dfi_p3_cas_n), (~dfi_p3_ras_n), (~dfi_p3_we_n)};

// synthesis translate_off
reg dummy_d_7;
// synthesis translate_on
always @(*) begin
	dfiphaseadapter3_valid <= 1'd0;
	dfiphaseadapter3_command3_cs0 <= 2'd0;
	dfiphaseadapter3_command30 <= 6'd0;
	dfiphaseadapter3_command31 <= 6'd0;
	dfiphaseadapter3_command3_cs1 <= 2'd0;
	dfiphaseadapter3_command32 <= 6'd0;
	dfiphaseadapter3_command33 <= 6'd0;
	if ((dfi_p3_cs_n == 1'd0)) begin
		case (dfiphaseadapter3_dfi_cmd)
			1'd1: begin
				case (dfi_p3_bank)
					1'd0: begin
						dfiphaseadapter3_command30[0] <= 1'd0;
						dfiphaseadapter3_command30[1] <= 1'd0;
						dfiphaseadapter3_command30[2] <= 1'd0;
						dfiphaseadapter3_command30[3] <= 1'd0;
						dfiphaseadapter3_command30[4] <= 1'd0;
						dfiphaseadapter3_command30[5] <= 1'd0;
						dfiphaseadapter3_command31[0] <= 1'd0;
						dfiphaseadapter3_command31[1] <= 1'd0;
						dfiphaseadapter3_command31[2] <= 1'd0;
						dfiphaseadapter3_command31[3] <= 1'd0;
						dfiphaseadapter3_command31[4] <= 1'd0;
						dfiphaseadapter3_command31[5] <= 1'd0;
						dfiphaseadapter3_command32[0] <= 1'd0;
						dfiphaseadapter3_command32[1] <= 1'd0;
						dfiphaseadapter3_command32[2] <= 1'd0;
						dfiphaseadapter3_command32[3] <= 1'd0;
						dfiphaseadapter3_command32[4] <= 1'd0;
						dfiphaseadapter3_command32[5] <= dfi_p3_address[6];
						dfiphaseadapter3_command33[0] <= dfi_p3_address[0];
						dfiphaseadapter3_command33[1] <= dfi_p3_address[1];
						dfiphaseadapter3_command33[2] <= dfi_p3_address[2];
						dfiphaseadapter3_command33[3] <= dfi_p3_address[3];
						dfiphaseadapter3_command33[4] <= dfi_p3_address[4];
						dfiphaseadapter3_command33[5] <= dfi_p3_address[5];
						dfiphaseadapter3_command3_cs1[0] <= 1'd1;
						dfiphaseadapter3_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter3_command30[0] <= 1'd0;
						dfiphaseadapter3_command30[1] <= 1'd1;
						dfiphaseadapter3_command30[2] <= 1'd1;
						dfiphaseadapter3_command30[3] <= 1'd1;
						dfiphaseadapter3_command30[4] <= 1'd0;
						dfiphaseadapter3_command30[5] <= 1'd0;
						dfiphaseadapter3_command31[0] <= dfi_p3_address[0];
						dfiphaseadapter3_command31[1] <= dfi_p3_address[1];
						dfiphaseadapter3_command31[2] <= dfi_p3_address[2];
						dfiphaseadapter3_command31[3] <= dfi_p3_address[3];
						dfiphaseadapter3_command31[4] <= dfi_p3_address[4];
						dfiphaseadapter3_command31[5] <= dfi_p3_address[5];
						dfiphaseadapter3_command3_cs0[0] <= 1'd1;
						dfiphaseadapter3_command32[0] <= 1'd0;
						dfiphaseadapter3_command32[1] <= 1'd1;
						dfiphaseadapter3_command32[2] <= 1'd0;
						dfiphaseadapter3_command32[3] <= 1'd0;
						dfiphaseadapter3_command32[4] <= 1'd1;
						dfiphaseadapter3_command32[5] <= dfi_p3_address[8];
						dfiphaseadapter3_command33[0] <= dfi_p3_address[2];
						dfiphaseadapter3_command33[1] <= dfi_p3_address[3];
						dfiphaseadapter3_command33[2] <= dfi_p3_address[4];
						dfiphaseadapter3_command33[3] <= dfi_p3_address[5];
						dfiphaseadapter3_command33[4] <= dfi_p3_address[6];
						dfiphaseadapter3_command33[5] <= dfi_p3_address[7];
						dfiphaseadapter3_command3_cs1[0] <= 1'd1;
						dfiphaseadapter3_valid <= 1'd1;
					end
					default: begin
						dfiphaseadapter3_command30[0] <= 1'd0;
						dfiphaseadapter3_command30[1] <= 1'd0;
						dfiphaseadapter3_command30[2] <= 1'd0;
						dfiphaseadapter3_command30[3] <= 1'd0;
						dfiphaseadapter3_command30[4] <= 1'd0;
						dfiphaseadapter3_command30[5] <= 1'd0;
						dfiphaseadapter3_command31[0] <= 1'd0;
						dfiphaseadapter3_command31[1] <= 1'd0;
						dfiphaseadapter3_command31[2] <= 1'd0;
						dfiphaseadapter3_command31[3] <= 1'd0;
						dfiphaseadapter3_command31[4] <= 1'd0;
						dfiphaseadapter3_command31[5] <= 1'd0;
						dfiphaseadapter3_command32[0] <= 1'd0;
						dfiphaseadapter3_command32[1] <= 1'd0;
						dfiphaseadapter3_command32[2] <= 1'd0;
						dfiphaseadapter3_command32[3] <= 1'd0;
						dfiphaseadapter3_command32[4] <= 1'd0;
						dfiphaseadapter3_command32[5] <= 1'd0;
						dfiphaseadapter3_command33[0] <= 1'd0;
						dfiphaseadapter3_command33[1] <= 1'd0;
						dfiphaseadapter3_command33[2] <= 1'd0;
						dfiphaseadapter3_command33[3] <= 1'd0;
						dfiphaseadapter3_command33[4] <= 1'd0;
						dfiphaseadapter3_command33[5] <= 1'd0;
						dfiphaseadapter3_valid <= 1'd0;
					end
				endcase
			end
			2'd2: begin
				dfiphaseadapter3_command30[0] <= 1'd1;
				dfiphaseadapter3_command30[1] <= 1'd0;
				dfiphaseadapter3_command30[2] <= dfi_p3_address[12];
				dfiphaseadapter3_command30[3] <= dfi_p3_address[13];
				dfiphaseadapter3_command30[4] <= dfi_p3_address[14];
				dfiphaseadapter3_command30[5] <= dfi_p3_address[15];
				dfiphaseadapter3_command31[0] <= dfi_p3_bank[0];
				dfiphaseadapter3_command31[1] <= dfi_p3_bank[1];
				dfiphaseadapter3_command31[2] <= dfi_p3_bank[2];
				dfiphaseadapter3_command31[3] <= dfi_p3_address[16];
				dfiphaseadapter3_command31[4] <= dfi_p3_address[10];
				dfiphaseadapter3_command31[5] <= dfi_p3_address[11];
				dfiphaseadapter3_command3_cs0[0] <= 1'd1;
				dfiphaseadapter3_command32[0] <= 1'd1;
				dfiphaseadapter3_command32[1] <= 1'd1;
				dfiphaseadapter3_command32[2] <= dfi_p3_address[6];
				dfiphaseadapter3_command32[3] <= dfi_p3_address[7];
				dfiphaseadapter3_command32[4] <= dfi_p3_address[8];
				dfiphaseadapter3_command32[5] <= dfi_p3_address[9];
				dfiphaseadapter3_command33[0] <= dfi_p3_address[0];
				dfiphaseadapter3_command33[1] <= dfi_p3_address[1];
				dfiphaseadapter3_command33[2] <= dfi_p3_address[2];
				dfiphaseadapter3_command33[3] <= dfi_p3_address[3];
				dfiphaseadapter3_command33[4] <= dfi_p3_address[4];
				dfiphaseadapter3_command33[5] <= dfi_p3_address[5];
				dfiphaseadapter3_command3_cs1[0] <= 1'd1;
				dfiphaseadapter3_valid <= 1'd1;
			end
			2'd3: begin
				dfiphaseadapter3_command30[0] <= 1'd0;
				dfiphaseadapter3_command30[1] <= 1'd0;
				dfiphaseadapter3_command30[2] <= 1'd0;
				dfiphaseadapter3_command30[3] <= 1'd0;
				dfiphaseadapter3_command30[4] <= 1'd0;
				dfiphaseadapter3_command30[5] <= 1'd0;
				dfiphaseadapter3_command31[0] <= 1'd0;
				dfiphaseadapter3_command31[1] <= 1'd0;
				dfiphaseadapter3_command31[2] <= 1'd0;
				dfiphaseadapter3_command31[3] <= 1'd0;
				dfiphaseadapter3_command31[4] <= 1'd0;
				dfiphaseadapter3_command31[5] <= 1'd0;
				dfiphaseadapter3_command32[0] <= 1'd0;
				dfiphaseadapter3_command32[1] <= 1'd0;
				dfiphaseadapter3_command32[2] <= 1'd0;
				dfiphaseadapter3_command32[3] <= 1'd0;
				dfiphaseadapter3_command32[4] <= 1'd1;
				dfiphaseadapter3_command32[5] <= dfi_p3_address[10];
				dfiphaseadapter3_command33[0] <= dfi_p3_bank[0];
				dfiphaseadapter3_command33[1] <= dfi_p3_bank[1];
				dfiphaseadapter3_command33[2] <= dfi_p3_bank[2];
				dfiphaseadapter3_command33[3] <= 1'd0;
				dfiphaseadapter3_command33[4] <= 1'd0;
				dfiphaseadapter3_command33[5] <= 1'd0;
				dfiphaseadapter3_command3_cs1[0] <= 1'd1;
				dfiphaseadapter3_valid <= 1'd1;
			end
			3'd4: begin
				dfiphaseadapter3_command30[0] <= 1'd0;
				dfiphaseadapter3_command30[1] <= 1'd1;
				dfiphaseadapter3_command30[2] <= 1'd0;
				dfiphaseadapter3_command30[3] <= 1'd0;
				dfiphaseadapter3_command30[4] <= 1'd0;
				dfiphaseadapter3_command30[5] <= 1'd0;
				dfiphaseadapter3_command31[0] <= dfi_p3_bank[0];
				dfiphaseadapter3_command31[1] <= dfi_p3_bank[1];
				dfiphaseadapter3_command31[2] <= dfi_p3_bank[2];
				dfiphaseadapter3_command31[3] <= 1'd0;
				dfiphaseadapter3_command31[4] <= dfi_p3_address[9];
				dfiphaseadapter3_command31[5] <= dfi_p3_address[10];
				dfiphaseadapter3_command3_cs0[0] <= 1'd1;
				dfiphaseadapter3_command32[0] <= 1'd0;
				dfiphaseadapter3_command32[1] <= 1'd1;
				dfiphaseadapter3_command32[2] <= 1'd0;
				dfiphaseadapter3_command32[3] <= 1'd0;
				dfiphaseadapter3_command32[4] <= 1'd1;
				dfiphaseadapter3_command32[5] <= dfi_p3_address[8];
				dfiphaseadapter3_command33[0] <= dfi_p3_address[2];
				dfiphaseadapter3_command33[1] <= dfi_p3_address[3];
				dfiphaseadapter3_command33[2] <= dfi_p3_address[4];
				dfiphaseadapter3_command33[3] <= dfi_p3_address[5];
				dfiphaseadapter3_command33[4] <= dfi_p3_address[6];
				dfiphaseadapter3_command33[5] <= dfi_p3_address[7];
				dfiphaseadapter3_command3_cs1[0] <= 1'd1;
				dfiphaseadapter3_valid <= 1'd1;
			end
			3'd5: begin
				case (dfi_p3_mw)
					1'd0: begin
						dfiphaseadapter3_command30[0] <= 1'd0;
						dfiphaseadapter3_command30[1] <= 1'd0;
						dfiphaseadapter3_command30[2] <= 1'd1;
						dfiphaseadapter3_command30[3] <= 1'd0;
						dfiphaseadapter3_command30[4] <= 1'd0;
						dfiphaseadapter3_command30[5] <= 1'd0;
						dfiphaseadapter3_command31[0] <= dfi_p3_bank[0];
						dfiphaseadapter3_command31[1] <= dfi_p3_bank[1];
						dfiphaseadapter3_command31[2] <= dfi_p3_bank[2];
						dfiphaseadapter3_command31[3] <= 1'd0;
						dfiphaseadapter3_command31[4] <= dfi_p3_address[9];
						dfiphaseadapter3_command31[5] <= dfi_p3_address[10];
						dfiphaseadapter3_command3_cs0[0] <= 1'd1;
						dfiphaseadapter3_command32[0] <= 1'd0;
						dfiphaseadapter3_command32[1] <= 1'd1;
						dfiphaseadapter3_command32[2] <= 1'd0;
						dfiphaseadapter3_command32[3] <= 1'd0;
						dfiphaseadapter3_command32[4] <= 1'd1;
						dfiphaseadapter3_command32[5] <= dfi_p3_address[8];
						dfiphaseadapter3_command33[0] <= dfi_p3_address[2];
						dfiphaseadapter3_command33[1] <= dfi_p3_address[3];
						dfiphaseadapter3_command33[2] <= dfi_p3_address[4];
						dfiphaseadapter3_command33[3] <= dfi_p3_address[5];
						dfiphaseadapter3_command33[4] <= dfi_p3_address[6];
						dfiphaseadapter3_command33[5] <= dfi_p3_address[7];
						dfiphaseadapter3_command3_cs1[0] <= 1'd1;
						dfiphaseadapter3_valid <= 1'd1;
					end
					1'd1: begin
						dfiphaseadapter3_command30[0] <= 1'd0;
						dfiphaseadapter3_command30[1] <= 1'd0;
						dfiphaseadapter3_command30[2] <= 1'd1;
						dfiphaseadapter3_command30[3] <= 1'd1;
						dfiphaseadapter3_command30[4] <= 1'd0;
						dfiphaseadapter3_command30[5] <= 1'd0;
						dfiphaseadapter3_command31[0] <= dfi_p3_bank[0];
						dfiphaseadapter3_command31[1] <= dfi_p3_bank[1];
						dfiphaseadapter3_command31[2] <= dfi_p3_bank[2];
						dfiphaseadapter3_command31[3] <= 1'd0;
						dfiphaseadapter3_command31[4] <= dfi_p3_address[9];
						dfiphaseadapter3_command31[5] <= dfi_p3_address[10];
						dfiphaseadapter3_command3_cs0[0] <= 1'd1;
						dfiphaseadapter3_command32[0] <= 1'd0;
						dfiphaseadapter3_command32[1] <= 1'd1;
						dfiphaseadapter3_command32[2] <= 1'd0;
						dfiphaseadapter3_command32[3] <= 1'd0;
						dfiphaseadapter3_command32[4] <= 1'd1;
						dfiphaseadapter3_command32[5] <= dfi_p3_address[8];
						dfiphaseadapter3_command33[0] <= dfi_p3_address[2];
						dfiphaseadapter3_command33[1] <= dfi_p3_address[3];
						dfiphaseadapter3_command33[2] <= dfi_p3_address[4];
						dfiphaseadapter3_command33[3] <= dfi_p3_address[5];
						dfiphaseadapter3_command33[4] <= dfi_p3_address[6];
						dfiphaseadapter3_command33[5] <= dfi_p3_address[7];
						dfiphaseadapter3_command3_cs1[0] <= 1'd1;
						dfiphaseadapter3_valid <= 1'd1;
					end
				endcase
			end
			3'd6: begin
				dfiphaseadapter3_command30[0] <= 1'd0;
				dfiphaseadapter3_command30[1] <= 1'd0;
				dfiphaseadapter3_command30[2] <= 1'd0;
				dfiphaseadapter3_command30[3] <= 1'd0;
				dfiphaseadapter3_command30[4] <= 1'd0;
				dfiphaseadapter3_command30[5] <= 1'd0;
				dfiphaseadapter3_command31[0] <= 1'd0;
				dfiphaseadapter3_command31[1] <= 1'd0;
				dfiphaseadapter3_command31[2] <= 1'd0;
				dfiphaseadapter3_command31[3] <= 1'd0;
				dfiphaseadapter3_command31[4] <= 1'd0;
				dfiphaseadapter3_command31[5] <= 1'd0;
				dfiphaseadapter3_command32[0] <= 1'd0;
				dfiphaseadapter3_command32[1] <= 1'd0;
				dfiphaseadapter3_command32[2] <= 1'd0;
				dfiphaseadapter3_command32[3] <= 1'd1;
				dfiphaseadapter3_command32[4] <= 1'd0;
				dfiphaseadapter3_command32[5] <= dfi_p3_address[10];
				dfiphaseadapter3_command33[0] <= dfi_p3_bank[0];
				dfiphaseadapter3_command33[1] <= dfi_p3_bank[1];
				dfiphaseadapter3_command33[2] <= dfi_p3_bank[2];
				dfiphaseadapter3_command33[3] <= 1'd0;
				dfiphaseadapter3_command33[4] <= 1'd0;
				dfiphaseadapter3_command33[5] <= 1'd0;
				dfiphaseadapter3_command3_cs1[0] <= 1'd1;
				dfiphaseadapter3_valid <= 1'd1;
			end
			3'd7: begin
				dfiphaseadapter3_command30[0] <= 1'd0;
				dfiphaseadapter3_command30[1] <= 1'd1;
				dfiphaseadapter3_command30[2] <= 1'd1;
				dfiphaseadapter3_command30[3] <= 1'd0;
				dfiphaseadapter3_command30[4] <= 1'd0;
				dfiphaseadapter3_command30[5] <= dfi_p3_address[7];
				dfiphaseadapter3_command31[0] <= dfi_p3_bank[0];
				dfiphaseadapter3_command31[1] <= dfi_p3_bank[1];
				dfiphaseadapter3_command31[2] <= dfi_p3_bank[2];
				dfiphaseadapter3_command31[3] <= dfi_p3_bank[3];
				dfiphaseadapter3_command31[4] <= dfi_p3_bank[4];
				dfiphaseadapter3_command31[5] <= dfi_p3_bank[5];
				dfiphaseadapter3_command3_cs0[0] <= 1'd1;
				dfiphaseadapter3_command32[0] <= 1'd0;
				dfiphaseadapter3_command32[1] <= 1'd1;
				dfiphaseadapter3_command32[2] <= 1'd1;
				dfiphaseadapter3_command32[3] <= 1'd0;
				dfiphaseadapter3_command32[4] <= 1'd1;
				dfiphaseadapter3_command32[5] <= dfi_p3_address[6];
				dfiphaseadapter3_command33[0] <= dfi_p3_address[0];
				dfiphaseadapter3_command33[1] <= dfi_p3_address[1];
				dfiphaseadapter3_command33[2] <= dfi_p3_address[2];
				dfiphaseadapter3_command33[3] <= dfi_p3_address[3];
				dfiphaseadapter3_command33[4] <= dfi_p3_address[4];
				dfiphaseadapter3_command33[5] <= dfi_p3_address[5];
				dfiphaseadapter3_command3_cs1[0] <= 1'd1;
				dfiphaseadapter3_valid <= 1'd1;
			end
			default: begin
				dfiphaseadapter3_command30[0] <= 1'd0;
				dfiphaseadapter3_command30[1] <= 1'd0;
				dfiphaseadapter3_command30[2] <= 1'd0;
				dfiphaseadapter3_command30[3] <= 1'd0;
				dfiphaseadapter3_command30[4] <= 1'd0;
				dfiphaseadapter3_command30[5] <= 1'd0;
				dfiphaseadapter3_command31[0] <= 1'd0;
				dfiphaseadapter3_command31[1] <= 1'd0;
				dfiphaseadapter3_command31[2] <= 1'd0;
				dfiphaseadapter3_command31[3] <= 1'd0;
				dfiphaseadapter3_command31[4] <= 1'd0;
				dfiphaseadapter3_command31[5] <= 1'd0;
				dfiphaseadapter3_command32[0] <= 1'd0;
				dfiphaseadapter3_command32[1] <= 1'd0;
				dfiphaseadapter3_command32[2] <= 1'd0;
				dfiphaseadapter3_command32[3] <= 1'd0;
				dfiphaseadapter3_command32[4] <= 1'd0;
				dfiphaseadapter3_command32[5] <= 1'd0;
				dfiphaseadapter3_command33[0] <= 1'd0;
				dfiphaseadapter3_command33[1] <= 1'd0;
				dfiphaseadapter3_command33[2] <= 1'd0;
				dfiphaseadapter3_command33[3] <= 1'd0;
				dfiphaseadapter3_command33[4] <= 1'd0;
				dfiphaseadapter3_command33[5] <= 1'd0;
				dfiphaseadapter3_valid <= 1'd0;
			end
		endcase
	end
// synthesis translate_off
	dummy_d_7 <= dummy_s;
// synthesis translate_on
end
assign i = {dfiphaseadapter3_valid, dfiphaseadapter2_valid, dfiphaseadapter1_valid, dfiphaseadapter0_valid};

// synthesis translate_off
reg dummy_d_8;
// synthesis translate_on
always @(*) begin
	valids_hist <= 8'd0;
	valids_hist[0] <= ($signed({1'd0, r[0]}) & 1'sd1);
	valids_hist[1] <= (r[1] & (~(1'd0 | slice_proxy0)));
	valids_hist[2] <= (r[2] & (~((1'd0 | slice_proxy1[0]) | slice_proxy2[1])));
	valids_hist[3] <= (r[3] & (~(((1'd0 | slice_proxy3[0]) | slice_proxy4[1]) | slice_proxy5[2])));
	valids_hist[4] <= (r[4] & (~(((1'd0 | slice_proxy6[0]) | slice_proxy7[1]) | slice_proxy8[2])));
	valids_hist[5] <= (r[5] & (~(((1'd0 | slice_proxy9[0]) | slice_proxy10[1]) | slice_proxy11[2])));
	valids_hist[6] <= (r[6] & (~(((1'd0 | slice_proxy12[0]) | slice_proxy13[1]) | slice_proxy14[2])));
	valids_hist[7] <= (r[7] & (~(((1'd0 | slice_proxy15[0]) | slice_proxy16[1]) | slice_proxy17[2])));
// synthesis translate_off
	dummy_d_8 <= dummy_s;
// synthesis translate_on
end
assign constbitslip0_i0 = ({dfiphaseadapter0_cs} & {4{(~((slice_proxy18[0] | slice_proxy19[1]) | slice_proxy20[2]))}});
assign constbitslip0_i1 = ({dfiphaseadapter03[0], dfiphaseadapter02[0], dfiphaseadapter01[0], dfiphaseadapter00[0]} & {4{(~((slice_proxy21[0] | slice_proxy22[1]) | slice_proxy23[2]))}});
assign constbitslip1_i0 = ({dfiphaseadapter03[1], dfiphaseadapter02[1], dfiphaseadapter01[1], dfiphaseadapter00[1]} & {4{(~((slice_proxy24[0] | slice_proxy25[1]) | slice_proxy26[2]))}});
assign constbitslip2_i0 = ({dfiphaseadapter03[2], dfiphaseadapter02[2], dfiphaseadapter01[2], dfiphaseadapter00[2]} & {4{(~((slice_proxy27[0] | slice_proxy28[1]) | slice_proxy29[2]))}});
assign constbitslip3_i0 = ({dfiphaseadapter03[3], dfiphaseadapter02[3], dfiphaseadapter01[3], dfiphaseadapter00[3]} & {4{(~((slice_proxy30[0] | slice_proxy31[1]) | slice_proxy32[2]))}});
assign constbitslip4_i = ({dfiphaseadapter03[4], dfiphaseadapter02[4], dfiphaseadapter01[4], dfiphaseadapter00[4]} & {4{(~((slice_proxy33[0] | slice_proxy34[1]) | slice_proxy35[2]))}});
assign constbitslip5_i = ({dfiphaseadapter03[5], dfiphaseadapter02[5], dfiphaseadapter01[5], dfiphaseadapter00[5]} & {4{(~((slice_proxy36[0] | slice_proxy37[1]) | slice_proxy38[2]))}});
assign constbitslip1_i1 = ({dfiphaseadapter1_cs} & {4{(~((slice_proxy39[0] | slice_proxy40[1]) | slice_proxy41[2]))}});
assign constbitslip6_i = ({dfiphaseadapter13[0], dfiphaseadapter12[0], dfiphaseadapter11[0], dfiphaseadapter10[0]} & {4{(~((slice_proxy42[0] | slice_proxy43[1]) | slice_proxy44[2]))}});
assign constbitslip7_i = ({dfiphaseadapter13[1], dfiphaseadapter12[1], dfiphaseadapter11[1], dfiphaseadapter10[1]} & {4{(~((slice_proxy45[0] | slice_proxy46[1]) | slice_proxy47[2]))}});
assign constbitslip8_i = ({dfiphaseadapter13[2], dfiphaseadapter12[2], dfiphaseadapter11[2], dfiphaseadapter10[2]} & {4{(~((slice_proxy48[0] | slice_proxy49[1]) | slice_proxy50[2]))}});
assign constbitslip9_i = ({dfiphaseadapter13[3], dfiphaseadapter12[3], dfiphaseadapter11[3], dfiphaseadapter10[3]} & {4{(~((slice_proxy51[0] | slice_proxy52[1]) | slice_proxy53[2]))}});
assign constbitslip10_i = ({dfiphaseadapter13[4], dfiphaseadapter12[4], dfiphaseadapter11[4], dfiphaseadapter10[4]} & {4{(~((slice_proxy54[0] | slice_proxy55[1]) | slice_proxy56[2]))}});
assign constbitslip11_i = ({dfiphaseadapter13[5], dfiphaseadapter12[5], dfiphaseadapter11[5], dfiphaseadapter10[5]} & {4{(~((slice_proxy57[0] | slice_proxy58[1]) | slice_proxy59[2]))}});
assign constbitslip2_i1 = ({dfiphaseadapter2_cs} & {4{(~((slice_proxy60[0] | slice_proxy61[1]) | slice_proxy62[2]))}});
assign constbitslip12_i = ({dfiphaseadapter23[0], dfiphaseadapter22[0], dfiphaseadapter21[0], dfiphaseadapter20[0]} & {4{(~((slice_proxy63[0] | slice_proxy64[1]) | slice_proxy65[2]))}});
assign constbitslip13_i = ({dfiphaseadapter23[1], dfiphaseadapter22[1], dfiphaseadapter21[1], dfiphaseadapter20[1]} & {4{(~((slice_proxy66[0] | slice_proxy67[1]) | slice_proxy68[2]))}});
assign constbitslip14_i = ({dfiphaseadapter23[2], dfiphaseadapter22[2], dfiphaseadapter21[2], dfiphaseadapter20[2]} & {4{(~((slice_proxy69[0] | slice_proxy70[1]) | slice_proxy71[2]))}});
assign constbitslip15_i = ({dfiphaseadapter23[3], dfiphaseadapter22[3], dfiphaseadapter21[3], dfiphaseadapter20[3]} & {4{(~((slice_proxy72[0] | slice_proxy73[1]) | slice_proxy74[2]))}});
assign constbitslip16_i = ({dfiphaseadapter23[4], dfiphaseadapter22[4], dfiphaseadapter21[4], dfiphaseadapter20[4]} & {4{(~((slice_proxy75[0] | slice_proxy76[1]) | slice_proxy77[2]))}});
assign constbitslip17_i = ({dfiphaseadapter23[5], dfiphaseadapter22[5], dfiphaseadapter21[5], dfiphaseadapter20[5]} & {4{(~((slice_proxy78[0] | slice_proxy79[1]) | slice_proxy80[2]))}});
assign constbitslip3_i1 = ({dfiphaseadapter3_cs} & {4{(~((slice_proxy81[0] | slice_proxy82[1]) | slice_proxy83[2]))}});
assign constbitslip18_i = ({dfiphaseadapter33[0], dfiphaseadapter32[0], dfiphaseadapter31[0], dfiphaseadapter30[0]} & {4{(~((slice_proxy84[0] | slice_proxy85[1]) | slice_proxy86[2]))}});
assign constbitslip19_i = ({dfiphaseadapter33[1], dfiphaseadapter32[1], dfiphaseadapter31[1], dfiphaseadapter30[1]} & {4{(~((slice_proxy87[0] | slice_proxy88[1]) | slice_proxy89[2]))}});
assign constbitslip20_i = ({dfiphaseadapter33[2], dfiphaseadapter32[2], dfiphaseadapter31[2], dfiphaseadapter30[2]} & {4{(~((slice_proxy90[0] | slice_proxy91[1]) | slice_proxy92[2]))}});
assign constbitslip21_i = ({dfiphaseadapter33[3], dfiphaseadapter32[3], dfiphaseadapter31[3], dfiphaseadapter30[3]} & {4{(~((slice_proxy93[0] | slice_proxy94[1]) | slice_proxy95[2]))}});
assign constbitslip22_i = ({dfiphaseadapter33[4], dfiphaseadapter32[4], dfiphaseadapter31[4], dfiphaseadapter30[4]} & {4{(~((slice_proxy96[0] | slice_proxy97[1]) | slice_proxy98[2]))}});
assign constbitslip23_i = ({dfiphaseadapter33[5], dfiphaseadapter32[5], dfiphaseadapter31[5], dfiphaseadapter30[5]} & {4{(~((slice_proxy99[0] | slice_proxy100[1]) | slice_proxy101[2]))}});
assign cs = (((constbitslip0_o0 | constbitslip1_o1) | constbitslip2_o1) | constbitslip3_o1);
assign ca = (((constbitslip0_o1 | constbitslip6_o) | constbitslip12_o) | constbitslip18_o);
assign ca_1 = (((constbitslip1_o0 | constbitslip7_o) | constbitslip13_o) | constbitslip19_o);
assign ca_2 = (((constbitslip2_o0 | constbitslip8_o) | constbitslip14_o) | constbitslip20_o);
assign ca_3 = (((constbitslip3_o0 | constbitslip9_o) | constbitslip15_o) | constbitslip21_o);
assign ca_4 = (((constbitslip4_o | constbitslip10_o) | constbitslip16_o) | constbitslip22_o);
assign ca_5 = (((constbitslip5_o | constbitslip11_o) | constbitslip17_o) | constbitslip23_o);
assign r = {i, reg_1};
assign o = r[7:4];
assign constbitslip0_o0 = constbitslip0_r0[7:4];
assign constbitslip0_o1 = constbitslip0_r1[7:4];
assign constbitslip1_o0 = constbitslip1_r0[7:4];
assign constbitslip2_o0 = constbitslip2_r0[7:4];
assign constbitslip3_o0 = constbitslip3_r0[7:4];
assign constbitslip4_o = constbitslip4_r[7:4];
assign constbitslip5_o = constbitslip5_r[7:4];
assign constbitslip1_o1 = constbitslip1_r1[6:3];
assign constbitslip6_o = constbitslip6_r[6:3];
assign constbitslip7_o = constbitslip7_r[6:3];
assign constbitslip8_o = constbitslip8_r[6:3];
assign constbitslip9_o = constbitslip9_r[6:3];
assign constbitslip10_o = constbitslip10_r[6:3];
assign constbitslip11_o = constbitslip11_r[6:3];
assign constbitslip2_o1 = constbitslip2_r1[5:2];
assign constbitslip12_o = constbitslip12_r[5:2];
assign constbitslip13_o = constbitslip13_r[5:2];
assign constbitslip14_o = constbitslip14_r[5:2];
assign constbitslip15_o = constbitslip15_r[5:2];
assign constbitslip16_o = constbitslip16_r[5:2];
assign constbitslip17_o = constbitslip17_r[5:2];
assign constbitslip3_o1 = constbitslip3_r1[4:1];
assign constbitslip18_o = constbitslip18_r[4:1];
assign constbitslip19_o = constbitslip19_r[4:1];
assign constbitslip20_o = constbitslip20_r[4:1];
assign constbitslip21_o = constbitslip21_r[4:1];
assign constbitslip22_o = constbitslip22_r[4:1];
assign constbitslip23_o = constbitslip23_r[4:1];
assign slice_proxy0 = valids_hist[0];
assign slice_proxy1 = valids_hist[1:0];
assign slice_proxy2 = valids_hist[1:0];
assign slice_proxy3 = valids_hist[2:0];
assign slice_proxy4 = valids_hist[2:0];
assign slice_proxy5 = valids_hist[2:0];
assign slice_proxy6 = valids_hist[3:1];
assign slice_proxy7 = valids_hist[3:1];
assign slice_proxy8 = valids_hist[3:1];
assign slice_proxy9 = valids_hist[4:2];
assign slice_proxy10 = valids_hist[4:2];
assign slice_proxy11 = valids_hist[4:2];
assign slice_proxy12 = valids_hist[5:3];
assign slice_proxy13 = valids_hist[5:3];
assign slice_proxy14 = valids_hist[5:3];
assign slice_proxy15 = valids_hist[6:4];
assign slice_proxy16 = valids_hist[6:4];
assign slice_proxy17 = valids_hist[6:4];
assign slice_proxy18 = valids_hist[3:1];
assign slice_proxy19 = valids_hist[3:1];
assign slice_proxy20 = valids_hist[3:1];
assign slice_proxy21 = valids_hist[3:1];
assign slice_proxy22 = valids_hist[3:1];
assign slice_proxy23 = valids_hist[3:1];
assign slice_proxy24 = valids_hist[3:1];
assign slice_proxy25 = valids_hist[3:1];
assign slice_proxy26 = valids_hist[3:1];
assign slice_proxy27 = valids_hist[3:1];
assign slice_proxy28 = valids_hist[3:1];
assign slice_proxy29 = valids_hist[3:1];
assign slice_proxy30 = valids_hist[3:1];
assign slice_proxy31 = valids_hist[3:1];
assign slice_proxy32 = valids_hist[3:1];
assign slice_proxy33 = valids_hist[3:1];
assign slice_proxy34 = valids_hist[3:1];
assign slice_proxy35 = valids_hist[3:1];
assign slice_proxy36 = valids_hist[3:1];
assign slice_proxy37 = valids_hist[3:1];
assign slice_proxy38 = valids_hist[3:1];
assign slice_proxy39 = valids_hist[4:2];
assign slice_proxy40 = valids_hist[4:2];
assign slice_proxy41 = valids_hist[4:2];
assign slice_proxy42 = valids_hist[4:2];
assign slice_proxy43 = valids_hist[4:2];
assign slice_proxy44 = valids_hist[4:2];
assign slice_proxy45 = valids_hist[4:2];
assign slice_proxy46 = valids_hist[4:2];
assign slice_proxy47 = valids_hist[4:2];
assign slice_proxy48 = valids_hist[4:2];
assign slice_proxy49 = valids_hist[4:2];
assign slice_proxy50 = valids_hist[4:2];
assign slice_proxy51 = valids_hist[4:2];
assign slice_proxy52 = valids_hist[4:2];
assign slice_proxy53 = valids_hist[4:2];
assign slice_proxy54 = valids_hist[4:2];
assign slice_proxy55 = valids_hist[4:2];
assign slice_proxy56 = valids_hist[4:2];
assign slice_proxy57 = valids_hist[4:2];
assign slice_proxy58 = valids_hist[4:2];
assign slice_proxy59 = valids_hist[4:2];
assign slice_proxy60 = valids_hist[5:3];
assign slice_proxy61 = valids_hist[5:3];
assign slice_proxy62 = valids_hist[5:3];
assign slice_proxy63 = valids_hist[5:3];
assign slice_proxy64 = valids_hist[5:3];
assign slice_proxy65 = valids_hist[5:3];
assign slice_proxy66 = valids_hist[5:3];
assign slice_proxy67 = valids_hist[5:3];
assign slice_proxy68 = valids_hist[5:3];
assign slice_proxy69 = valids_hist[5:3];
assign slice_proxy70 = valids_hist[5:3];
assign slice_proxy71 = valids_hist[5:3];
assign slice_proxy72 = valids_hist[5:3];
assign slice_proxy73 = valids_hist[5:3];
assign slice_proxy74 = valids_hist[5:3];
assign slice_proxy75 = valids_hist[5:3];
assign slice_proxy76 = valids_hist[5:3];
assign slice_proxy77 = valids_hist[5:3];
assign slice_proxy78 = valids_hist[5:3];
assign slice_proxy79 = valids_hist[5:3];
assign slice_proxy80 = valids_hist[5:3];
assign slice_proxy81 = valids_hist[6:4];
assign slice_proxy82 = valids_hist[6:4];
assign slice_proxy83 = valids_hist[6:4];
assign slice_proxy84 = valids_hist[6:4];
assign slice_proxy85 = valids_hist[6:4];
assign slice_proxy86 = valids_hist[6:4];
assign slice_proxy87 = valids_hist[6:4];
assign slice_proxy88 = valids_hist[6:4];
assign slice_proxy89 = valids_hist[6:4];
assign slice_proxy90 = valids_hist[6:4];
assign slice_proxy91 = valids_hist[6:4];
assign slice_proxy92 = valids_hist[6:4];
assign slice_proxy93 = valids_hist[6:4];
assign slice_proxy94 = valids_hist[6:4];
assign slice_proxy95 = valids_hist[6:4];
assign slice_proxy96 = valids_hist[6:4];
assign slice_proxy97 = valids_hist[6:4];
assign slice_proxy98 = valids_hist[6:4];
assign slice_proxy99 = valids_hist[6:4];
assign slice_proxy100 = valids_hist[6:4];
assign slice_proxy101 = valids_hist[6:4];

always @(posedge sys_clk) begin
	reg_1 <= i;
	constbitslip0_r0 <= {constbitslip0_i0, constbitslip0_r0[7:4]};
	constbitslip0_r1 <= {constbitslip0_i1, constbitslip0_r1[7:4]};
	constbitslip1_r0 <= {constbitslip1_i0, constbitslip1_r0[7:4]};
	constbitslip2_r0 <= {constbitslip2_i0, constbitslip2_r0[7:4]};
	constbitslip3_r0 <= {constbitslip3_i0, constbitslip3_r0[7:4]};
	constbitslip4_r <= {constbitslip4_i, constbitslip4_r[7:4]};
	constbitslip5_r <= {constbitslip5_i, constbitslip5_r[7:4]};
	constbitslip1_r1 <= {constbitslip1_i1, constbitslip1_r1[7:4]};
	constbitslip6_r <= {constbitslip6_i, constbitslip6_r[7:4]};
	constbitslip7_r <= {constbitslip7_i, constbitslip7_r[7:4]};
	constbitslip8_r <= {constbitslip8_i, constbitslip8_r[7:4]};
	constbitslip9_r <= {constbitslip9_i, constbitslip9_r[7:4]};
	constbitslip10_r <= {constbitslip10_i, constbitslip10_r[7:4]};
	constbitslip11_r <= {constbitslip11_i, constbitslip11_r[7:4]};
	constbitslip2_r1 <= {constbitslip2_i1, constbitslip2_r1[7:4]};
	constbitslip12_r <= {constbitslip12_i, constbitslip12_r[7:4]};
	constbitslip13_r <= {constbitslip13_i, constbitslip13_r[7:4]};
	constbitslip14_r <= {constbitslip14_i, constbitslip14_r[7:4]};
	constbitslip15_r <= {constbitslip15_i, constbitslip15_r[7:4]};
	constbitslip16_r <= {constbitslip16_i, constbitslip16_r[7:4]};
	constbitslip17_r <= {constbitslip17_i, constbitslip17_r[7:4]};
	constbitslip3_r1 <= {constbitslip3_i1, constbitslip3_r1[7:4]};
	constbitslip18_r <= {constbitslip18_i, constbitslip18_r[7:4]};
	constbitslip19_r <= {constbitslip19_i, constbitslip19_r[7:4]};
	constbitslip20_r <= {constbitslip20_i, constbitslip20_r[7:4]};
	constbitslip21_r <= {constbitslip21_i, constbitslip21_r[7:4]};
	constbitslip22_r <= {constbitslip22_i, constbitslip22_r[7:4]};
	constbitslip23_r <= {constbitslip23_i, constbitslip23_r[7:4]};
	if (sys_rst) begin
	end
end

endmodule
