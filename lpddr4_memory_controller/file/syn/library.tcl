
##############################################################################
#                                                                            #
#                            SPECIFY LIBRARIES                               #
#                                                                            #
##############################################################################

# Get configuration settings
source ../../src/syn/config.tcl 

# Set library search path
set_app_var search_path [concat $search_path $ADDITIONAL_SEARCH_PATHS]

# Set the target libraries
set_app_var target_library "$TARGET_LIBS"

# Set symbol library, link path, and link libs
set_app_var link_path [list "*" $TARGET_LIBS]
set_app_var link_library "* $TARGET_LIBS $SYNOPSYS_SYNTHETIC_LIB"

if {[llength $ADDITIONAL_TARGET_LIBS] > 0} {
   set_app_var target_library "$target_library $ADDITIONAL_TARGET_LIBS"
   set_app_var link_path "$link_path $ADDITIONAL_TARGET_LIBS"
   set_app_var link_library "$link_library $ADDITIONAL_TARGET_LIBS"
}

set_app_var symbol_library $SYMBOL_LIB

# Set up tlu_plus files (for virtual route and post route extraction)
if {$TOOL_NAME != "PTPX"} {
   #set_tlu_plus_files \
     -max_tluplus $MW_TLUPLUS_PATH/$MAX_TLUPLUS_FILE \
     -min_tluplus $MW_TLUPLUS_PATH/$MIN_TLUPLUS_FILE \
     -tech2itf_map $MW_TLUPLUS_PATH/$TECH2ITF_MAP_FILE

   # Create a MW design lib and attach the reference lib and techfiles
   if {[file isdirectory $DESIGN_MW_LIB_NAME]} {
      file delete -force $DESIGN_MW_LIB_NAME
   }

   if {[llength $MW_ADDITIONAL_REFERENCE_LIBS] > 0} {
      set ref_libs [list $MW_REFERENCE_LIBS $MW_ADDITIONAL_REFERENCE_LIBS] 
   } else {
      set ref_libs [list $MW_REFERENCE_LIBS] 
   }

   create_mw_lib $DESIGN_MW_LIB_NAME \
      -technology $MW_TECHFILE_PATH/$MW_TECHFILE \
      -mw_reference_library $ref_libs 
   open_mw_lib $DESIGN_MW_LIB_NAME
}

