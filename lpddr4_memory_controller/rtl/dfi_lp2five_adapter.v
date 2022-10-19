/* Machine-generated using Migen */
module dfi_lp2five_adatper(
	dfi_lpddr4_interface dfi_lpddr4_if,
	dfi_5_0_interface dfi_5_0_if,
	input sys_clk,
	input sys_rst
);

always_comb begin
	dfi_5_0_if.dfi_phase0_5_0_if.ca=dfi_lpddr4_if.dfi_phase0_lpddr4_if.ca;
end


endmodule
