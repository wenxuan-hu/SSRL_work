sim_two_mixed_phy:
	vcs -full64  -sverilog -f ./mixed_phy_2/mixed_phy_2_tb.f  -debug_pp -timescale=1ns/1ps
	$ ./simv

sim_mixed_phy:
	vcs -full64  -sverilog -f ./mixed_phy/mixed_phy_tb.f  -debug_pp -timescale=1ns/1ps
	$ ./simv

sim_ucie_buffer:
	vcs -full64  -sverilog -f ./ucie_buffer/ucie_buffer_tb.f  -debug_pp -timescale=1ns/1ps
	$ ./simv

sim_ucie_adapter:
	vcs -full64  -sverilog -f ./ucie_channel_adapter/ucie_channel_adapter_tb.f  -debug_pp -timescale=1ns/1ps
	$ ./simv

sim_ucie_channel: clean
	$ vcs -full64  -sverilog -f ./channel/channel_tb.f  -debug_pp -timescale=1ns/10ps
	$ ./simv

sim_mc_csr:
	vcs -full64  -sverilog -f ./memory_controller_top/tb_csr_top.f  -debug_pp -timescale=1ns/1ps
	$ ./simv

sim_mc_top:
	vcs -full64  -sverilog -f ./memory_controller_top/tb_top.f  -dpi -ntb_opts uvm -debug_pp -timescale=1ns/10ps
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=mc_top_basic_test

sim_core:
	vcs -full64  -sverilog -f ./core/core_tb.f  -dpi -ntb_opts uvm -debug_pp -timescale=1ns/10ps
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=core_basic_test

sim_DFIAdapter: clean
	vcs -full64  -sverilog -f ./DFIAdapter/DFIAdapter_tb.f  -dpi -ntb_opts uvm -debug_pp -timescale=1ns/10ps
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=DFIAdapter_basic_test

sim_bank_machine:
	vcs -full64  -sverilog -f ./bank_machine/bank_machine_tb.f  -dpi -ntb_opts uvm -debug_pp -timescale=1ns/10ps
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=bank_machine_basic_test 

sim_multiplexer: clean
	vcs -full64  -sverilog -f ./multiplexer/multiplexer_tb.f  -dpi -ntb_opts uvm -debug_pp -timescale=1ns/10ps
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=multiplexer_basic_test 

sim_refresher: clean
	rm -rf csrc simv*
	$ vcs -full64  -sverilog -f ./refresher/refresher_tb.f  -debug_pp -timescale=1ns/10ps
	$ ./simv

clean:
	rm -rf csrc simv simv.daidir ucli.key .vlogansetup.args .vlogansetup.env .vcs_lib_lock simv.vdb AN.DB vc_hdrs.h *.diag *.vpd *tar.gz external.o

view_waves:
	dve -full64 &