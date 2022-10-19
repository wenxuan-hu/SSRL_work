
source ../../src/syn/config.tcl

# Read in the design RTL
# ======================================
set_svf ./$results/$TOPLEVEL.syn.svf
define_design_lib WORK -path ./tmp/WORK

analyze -format sverilog $RTL_SOURCE_FILES -define $RTL_DEFINES
set_app_var template_parameter_style "%d"
elaborate $TOPLEVEL
current_design $TOPLEVEL

link
