
source ../../src/syn/config.tcl

# Reports generation                                                          #
#=============================================================================#

# Path timing 
report_timing -path end  -delay max -max_paths 200 -cap -nets -nosplit > "./$reports/timing.max.rpt"
report_timing -path end  -delay min -max_paths 200 -cap -nets -nosplit > "./$reports/timing.min.rpt"
report_timing -path full -delay max -max_paths 5  -cap -nets -nosplit > "./$reports/timing.max.fullpath.rpt"
report_timing -path full -delay min -max_paths 5  -cap -nets -nosplit > "./$reports/timing.min.fullpath.rpt"

# Constraint violations
report_constraints -all_violators -verbose > "./$reports/constraints.rpt"
# Area 
report_area -physical -hier -nosplit > "./$reports/area.rpt"
# Power
report_power -hier -nosplit > "./$reports/power.hier.rpt"
report_power -verbose -nosplit > "./$reports/power.rpt"
# QOR
report_qor > "./$reports/qor.rpt"
# Latches
query_objects -truncate 0 [all_registers -level_sensitive ] > "$reports/latches.rpt"
# High fanout nets
report_net_fanout -threshold 32 -nosplit > "$reports/high_fanout.rpt"
# Add NAND2 size equivalent report to the area report file
current_design $TOPLEVEL
if {[info exists NAND2_NAME]} {
    set nand2_area [get_attribute [get_lib_cell $LIB_WC_NAME/$NAND2_NAME] area]
    redirect -variable area {report_area}
    regexp {Total cell area:\s+([^\n]+)\n} $area whole_match area
    set nand2_eq [expr $area/$nand2_area]
    set fp [open "./$reports/nand2_area.rpt" w]
    puts $fp ""
    puts $fp "NAND2 equivalent cell area: $nand2_eq"
    close $fp
}
# Check for design errors
check_design > "./$reports/check_design.rpt"


