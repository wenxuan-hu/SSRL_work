
# Get configuration settings
source ../../src/syn/config.tcl

# Clocks
# =====================================
create_clock -name     "jtag_tck"                      \
             -period   "$CLK_PERIOD"            \
             -waveform "0 [expr $CLK_PERIOD/2]" \
             [get_ports $CLK_PORT]

# create_clock -name     "clk"                      \
             # -period   "$CLK_PERIOD"            \
             # -waveform "0 [expr $CLK_PERIOD/2]" \
             # [get_pins i_root_clk_gater/gclk]

#High fanout net
set_ideal_network [get_net jtag_trst] -no_propagate

# global margin
set_critical_range $clk_critical_range $current_design
# uncertainty
set_clock_uncertainty -setup ${clk_setup_uncertainty} "jtag_tck"
set_clock_uncertainty -hold ${clk_hold_uncertainty}  "jtag_tck"
# transition
set_clock_transition ${clk_trans} [get_clocks]
set_fix_hold [get_clocks]

# Fanout, transition,
# ==============================================
set_max_fanout $max_fanout $current_design
set_max_transition $max_trans $current_design


##############################################################################
#                                                                            #
#             TIMING DERATE AND RECONVERGENCE PESSIMISM REMOVAL		     #
#                                                                            #
##############################################################################
# Set setup/hold derating factors. 20%. 
# -clk ensures application of derate only to clk paths. 
# This will be applied to both setup and hold paths (see definition of set_timing_derate)
# If you want the part to really not end up faster than you built it for, will likely have to relax cycle time.
set_timing_derate -early 0.8
set_timing_derate -late  1.0
#Avoid tracking entire early and late paths altogether. That is excessive. Remoe that pessimism.
set timing_remove_clock_reconvergence_pessimism true



# Path groups 
# ==============================================
group_path -name "Inputs"       -from [remove_from_collection [all_inputs] [get_ports $CLK_PORT]]
group_path -name "Outputs"      -to [all_outputs]
group_path -name "Feedthroughs" -from [remove_from_collection [all_inputs] [get_ports $CLK_PORT]] \
                                -to [all_outputs]
group_path -name "Regs_to_Regs" -from [all_registers] -to [all_registers]

# Boundary timing/loading
# ==============================================

# outputs 
set_output_delay $blanket_output_delay -clock "jtag_tck" [all_outputs]
set_load [load_of $blanket_input_load] [all_outputs]

# inputs 
set_input_delay $blanket_input_delay -clock "jtag_tck" \
   [remove_from_collection [all_inputs] [get_ports $CLK_PORT]]
set_drive [drive_of $blanket_output_drive] [all_inputs]

# Operating conditions
# ==============================================
set_operating_conditions -max $LIB_WC_OPCON -max_library $LIB_WC_NAME \
                         -min $LIB_BC_OPCON -min_library $LIB_BC_NAME

