
 source ../../src/syn/config.tcl

# Generate design data                                                        #
#=============================================================================#

current_design $TOPLEVEL

set_app_var verilogout_higher_designs_first true
set_app_var verilogout_no_tri true

change_name -rules verilog -hierarchy

# SPEF 
write_parasitics -output "./$results/$TOPLEVEL.syn.spef"
# SDF
write_sdf -context verilog -version 2.0 "./$results/$TOPLEVEL.syn.sdf"
# SDC
set_app_var write_sdc_output_lumped_net_capacitance false; # this produces higher quality netlist? 
set_app_var write_sdc_output_net_resistance false
write_sdc -version 1.7 -nosplit "./$results/$TOPLEVEL.syn.sdc"
# DDC
write -hierarchy -format ddc -output "./$results/$TOPLEVEL.syn.ddc"
# DB
write -h $TOPLEVEL -output "./$results/$TOPLEVEL.syn.db"
# Verilog netlist
write -hierarchy -format verilog -output "./$results/$TOPLEVEL.syn.v"
# If SAIF is used, write out SAIF name mapping file for PTPX
saif_map -type ptpx -write_map "$reports/${TOPLEVEL}_SAIF.namemap"


