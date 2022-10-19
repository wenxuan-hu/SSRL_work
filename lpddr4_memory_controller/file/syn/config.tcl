
# Project and design
# ==========================================================================
set TOPLEVEL "jtag_top_new"
set PROJECT_DIR ""
set BOUNDARY_CELL "singleBSC"

set PROCESS "65GP"; # 65LP or 65GP
set CORNER "LOW"

# Source files 
# ==========================================================================
set BASE "/homes/ruihong/project/submit/jtag_sapr/jtag/src/verilog"

set RTL_SOURCE_FILES [list \
   "$BASE/BSC_input_chain.sv" "$BASE/BSC_output_chain.sv" "$BASE/bypass_reg.sv" "$BASE/id_reg_cell.sv" "$BASE/instr_decode.sv" "$BASE/instruction_register.sv" "$BASE/jtag_top_new.sv" "$BASE/tap_state_machine.sv" "$BASE/tdo_mux.sv" "$BASE/test_logic.sv" "$BASE/singleBSC.sv"  \
]

set RTL_DEFINES ""

# Runtime options 
# ==========================================================================

# Multicore acceleration
if {$TOOL_NAME != "PTPX"} {
   set_host_options -max_cores 8 ;   
}

# Silence the unholy number of warnings that are known to be harmless
suppress_message "DPI-025"
suppress_message "PSYN-485"

# Check for latches in RTL
set_app_var hdlin_check_no_latch true

# Library setup
# ==========================================================================

# Design libraries 
set DESIGN_MW_LIB_NAME "design_lib"

if {$PROCESS == "65LP"} {
   # Logic libraries 
   set TSMC_PATH "/home/lab.apps/vlsiapps/kits/tsmc/N65LP/digital"
   set TARGETCELLLIB_PATH "$TSMC_PATH/Front_End/timing_power_noise/NLDM/tcbn65lp_200a"
   set ADDITIONAL_SEARCH_PATHS [list \
      "$TARGETCELLLIB_PATH" \
      "$TSMC_PATH/Back_End/milkyway/tcbn65lp_200a/cell_frame/tcbn65lp/LM/*" \
      "$synopsys_root/libraries/syn" \
      "./" \
   ]

   # Technology files
   set MW_TECHFILE_PATH "$TSMC_PATH/Back_End/milkyway/tcbn65lp_200a/techfiles"
   set MW_TLUPLUS_PATH "$MW_TECHFILE_PATH/tluplus"
   set MAX_TLUPLUS_FILE "cln65lp_1p09m+alrdl_rcbest_top2.tluplus"
   set MIN_TLUPLUS_FILE "cln65lp_1p09m+alrdl_rcworst_top2.tluplus"

   # Reference libraries 
   set MW_REFERENCE_LIBS "$TSMC_PATH/Back_End/milkyway/tcbn65lp_200a/frame_only/tcbn65lp"
   set MW_ADDITIONAL_REFERENCE_LIBS [list \
   "/homes/projects/ee478/ruihong/NMS_syn/sapr/syn/design_lib"\
   "/homes/projects/ee478/ruihong/score_syn/sapr/syn/design_lib" \
   ]
   set SYNOPSYS_SYNTHETIC_LIB "dw_foundation.sldb"

   # set specific corner libraries
   # WC - 0.9V 
   if {$CORNER == "LOW"} {
      # Target corners
      set TARGET_LIBS [list \
         "tcbn65lptc1d0.db" \
         "tcbn65lpbc.db" \
      ]
      set SYMBOL_LIB "tcbn65lptc1d0.db"
      set ADDITIONAL_TARGET_LIBS ""
      # Worst case library
      set LIB_WC_FILE   "tcbn65lptc1d0.db"
      set LIB_WC_NAME   "tcbn65lptc1d0"
      # Best case library
      set LIB_BC_FILE   "tcbn65lpbc.db"
      set LIB_BC_NAME   "tcbn65lpbc"
      # Operating conditions
      set LIB_WC_OPCON  "NC1D0COM"
      set LIB_BC_OPCON  "BCCOM"
   # TC - 1.2V
   } elseif {$CORNER == "HIGH"} {
      # Target corners
      set TARGET_LIBS [list \
         "tcbn65lptc.db" \
         "tcbn65lpbc.db" \
      ]
      set SYMBOL_LIB "tcbn65lptc.db"
      set ADDITIONAL_TARGET_LIBS "{}"
      # Worst case library
      set LIB_WC_FILE   "tcbn65lptc.db"
      set LIB_WC_NAME   "tcbn65lptc"
      # Best case library
      set LIB_BC_FILE   "tcbn65lpbc.db"
      set LIB_BC_NAME   "tcbn65lpbc"
      # Operating conditions
      set LIB_WC_OPCON  "NCCOM"
      set LIB_BC_OPCON  "BCCOM"
   }

} elseif {$PROCESS == "65GP"} {
   # Logic libraries 
   set TSMC_PATH "/home/lab.apps/vlsiapps/kits/tsmc/N65RF/1.0c/digital"
   set TARGETCELLLIB_PATH "$TSMC_PATH/Front_End/timing_power_noise/NLDM/tcbn65gplus_140b"
   set ADDITIONAL_SEARCH_PATHS [list \
      "$TARGETCELLLIB_PATH" \
      "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/cell_frame/tcbn65gplus/LM/*" \
      "$synopsys_root/libraries/syn" \
      "./" \
   ]
   set TARGET_LIBS [list \
      "tcbn65gplustc0d8.db" \
      "tcbn65gplusbc0d88.db" \
   ]
   set ADDITIONAL_TARGET_LIBS ""
   set SYMBOL_LIB "tcbn65gplustc0d8.db"
   set SYNOPSYS_SYNTHETIC_LIB "dw_foundation.sldb"

   # Reference libraries 
   set MW_REFERENCE_LIBS "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/frame_only/tcbn65gplus"
   set MW_ADDITIONAL_REFERENCE_LIBS ""
   set MW_ADDITIONAL_REFERENCE_LIBS ""

   # Worst case library
   set LIB_WC_FILE   "tcbn65gplustc0d8.db"
   set LIB_WC_NAME   "tcbn65gplustc0d8"

   # Best case library
   set LIB_BC_FILE   "tcbn65gplusbc0d88.db"
   set LIB_BC_NAME   "tcbn65gplusbc0d88"

   # Operating conditions
   set LIB_WC_OPCON  "NC0D8COM"
   set LIB_BC_OPCON  "BC0D88COM"

   # Technology files
   set MW_TECHFILE_PATH "$TSMC_PATH/Back_End/milkyway/tcbn65gplus_200a/techfiles"
   set MW_TLUPLUS_PATH "$MW_TECHFILE_PATH/tluplus"
   set MAX_TLUPLUS_FILE "cln65g+_1p09m+alrdl_rcbest_top2.tluplus"
   set MIN_TLUPLUS_FILE "cln65g+_1p09m+alrdl_rcworst_top2.tluplus"
}

set TECH2ITF_MAP_FILE "star.map_9M"
set MW_TECHFILE "tsmcn65_9lmT2.tf"

# nand2 gate name for area size calculation
set NAND2_NAME    "ND2D1"

# Clock 
# ==========================================================================
#  - Assumes a single clock

# Name of the port
set CLK_PORT   "jtag_tck"

# Frequency 
if {$CORNER == "LOW"} {
   set CLK_PERIOD 1.5
} elseif {$CORNER == "HIGH"} {
   set CLK_PERIOD 1.5
}


# Timing uncertainties
set clk_critical_range 0.010
set clk_setup_uncertainty 0.030
set clk_hold_uncertainty 0.030

# Transition
set clk_trans 0.050

# General timing
# ==========================================================================
# - simplified timing constraints

set max_fanout 50
set max_trans 1.200

set blanket_output_delay 0.100
set blanket_input_delay 0.100

set blanket_output_drive "${LIB_WC_NAME}/INVD1/ZN"
set blanket_input_load "${LIB_WC_NAME}/INVD16/I"


# DC compile options
# ==========================================================================

# Reduce runtime
set DC_PREFER_RUNTIME 0

# Preserve design hierarchy
set DC_KEEP_HIER 1

# Register retiming
set DC_REG_RETIME 0
set DC_REG_RETIME_XFORM "multiclass"

# Logic flattening
set DC_FLATTEN 0
set DC_FLATTEN_EFFORT "medium"

# Logic structuring
set DC_STRUCTURE 0
set DC_STRUCTURE_TIMING "true"
set DC_STRUCTURE_LOGIC  "true"

set DC_GLOBAL_CLK_GATING 1

# Do an additional incremental compile for better results
set DC_COMPILE_ADDITIONAL 1

# Result generation and reporting
# ==========================================================================
set results "results"
set reports "reports"


