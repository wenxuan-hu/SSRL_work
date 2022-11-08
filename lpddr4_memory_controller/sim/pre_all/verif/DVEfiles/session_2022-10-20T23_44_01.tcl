# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Thu Oct 20 23:44:01 2022
# Designs open: 1
#   V1: /home/huwe0427/work/SSRL_git/SSRL_work/lpddr4_memory_controller/sim/pre_all/verif/vcdplus.vpd
# Toplevel windows open: 1
# 	TopLevel.1
#   Source.1: mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if
#   Group count = 2
#   Group Group1 signal count = 56
#   Group Group2 signal count = 9
# End_DVE_Session_Save_Info

# DVE version: T-2022.06_Full64
# DVE build date: May 31 2022 20:53:03


#<Session mode="Full" path="/home/huwe0427/work/SSRL_git/SSRL_work/lpddr4_memory_controller/sim/pre_all/verif/DVEfiles/session.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state maximized -rect {{1 38} {1920 1134}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set HSPane.1 [gui_create_window -type HSPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 380]
catch { set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier] }
gui_set_window_pref_key -window ${HSPane.1} -key dock_width -value_type integer -value 380
gui_set_window_pref_key -window ${HSPane.1} -key dock_height -value_type integer -value -1
gui_set_window_pref_key -window ${HSPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 379} {height 836} {dock_state left} {dock_on_new_line true} {child_hier_colhier 326} {child_hier_coltype 70} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type DLPane -parent ${TopLevel.1} -dock_state left -dock_on_new_line true -dock_extent 403]
catch { set Data.1 [gui_share_window -id ${DLPane.1} -type Data] }
gui_set_window_pref_key -window ${DLPane.1} -key dock_width -value_type integer -value 403
gui_set_window_pref_key -window ${DLPane.1} -key dock_height -value_type integer -value 1077
gui_set_window_pref_key -window ${DLPane.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DLPane.1} {{left 0} {top 0} {width 402} {height 836} {dock_state left} {dock_on_new_line true} {child_data_colvariable 222} {child_data_colvalue 45} {child_data_coltype 133} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 178]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value -1
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 178
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 295} {height 179} {dock_state bottom} {dock_on_new_line true}}
set DriverLoad.1 [gui_create_window -type DriverLoad -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line false -dock_extent 180]
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_width -value_type integer -value 150
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_height -value_type integer -value 180
gui_set_window_pref_key -window ${DriverLoad.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${DriverLoad.1} {{left 0} {top 0} {width 1623} {height 179} {dock_state bottom} {dock_on_new_line false}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state maximized
gui_update_layout -id ${Source.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) none
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {/home/huwe0427/work/SSRL_git/SSRL_work/lpddr4_memory_controller/sim/pre_all/verif/vcdplus.vpd}] } {
	gui_open_db -design V1 -file /home/huwe0427/work/SSRL_git/SSRL_work/lpddr4_memory_controller/sim/pre_all/verif/vcdplus.vpd -to 442475700000 -nosource
}
gui_set_precision 1fs
gui_set_time_units 1ns
#</Database>

# DVE Global setting session: 


# Global: Bus

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if}
gui_load_child_values {mc_top_tb.my_mosi_0}
gui_load_child_values {mc_top_tb}


set _session_group_4 Group1
gui_sg_create "$_session_group_4"
set Group1 "$_session_group_4"

gui_sg_addsignal -group "$_session_group_4" { mc_top_tb.ahb_clk mc_top_tb.phy_clk mc_top_tb.ref_clk mc_top_tb.phy_rst mc_top_tb.mc_rst mc_top_tb.begin_write mc_top_tb.begin_read mc_top_tb.ahb_haddr mc_top_tb.ahb_hwrite mc_top_tb.ahb_hbusreq mc_top_tb.ahb_hwdata mc_top_tb.ahb_htrans mc_top_tb.ahb_hsize mc_top_tb.ahb_hsel mc_top_tb.ahb_hburst mc_top_tb.ahb_hreadyin mc_top_tb.ahb_hready mc_top_tb.ahb_hrdata mc_top_tb.ahb_hresp mc_top_tb.ahb_hgrant mc_top_tb.ahb_if_haddr mc_top_tb.ahb_if_hwrite mc_top_tb.ahb_if_hbusreq mc_top_tb.ahb_if_hwdata mc_top_tb.ahb_if_htrans mc_top_tb.ahb_if_hsize mc_top_tb.ahb_if_hsel mc_top_tb.ahb_if_hburst mc_top_tb.ahb_if_hreadyin mc_top_tb.ahb_if_hready mc_top_tb.ahb_if_hrdata mc_top_tb.ahb_if_hresp mc_top_tb.ahb_if_hgrant mc_top_tb.pad_ch0_dq mc_top_tb.pad_ch0_ca mc_top_tb.pad_ch0_ck_c mc_top_tb.pad_ch0_ck_t mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.address mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.bank mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cas_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cs_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.ras_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.we_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.mw mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cke mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.odt mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.reset_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.act_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata_en mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata_mask mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata_en mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata_valid mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.clk mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rst }

set _session_group_5 Group2
gui_sg_create "$_session_group_5"
set Group2 "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { mc_top_tb.my_mosi_0.rst mc_top_tb.my_mosi_0.clk mc_top_tb.my_mosi_0.mosi_data_i mc_top_tb.my_mosi_0.miso_data_o mc_top_tb.my_mosi_0.mosi_valid_i mc_top_tb.my_mosi_0.miso_valid_o mc_top_tb.my_mosi_0.miso_ready_i mc_top_tb.my_mosi_0.mosi_ready_o {mc_top_tb.my_mosi_0.$unit} }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 439327.374892



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} mc_top_tb}
catch {gui_list_expand -id ${Hier.1} mc_top_tb.u_mc_top}
catch {gui_list_expand -id ${Hier.1} mc_top_tb.u_mc_top.u_mc_core}
catch {gui_list_expand -id ${Hier.1} mc_top_tb.u_mc_top.u_mc_core.dfi_if}
catch {gui_list_select -id ${Hier.1} {mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if}}
gui_view_scroll -id ${Hier.1} -vertical -set 378
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.address mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.bank mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cas_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cs_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.ras_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.we_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.mw mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.cke mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.odt mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.reset_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.act_n mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata_en mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.wrdata_mask mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata_en mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata_valid mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.clk mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rst }}
gui_view_scroll -id ${Data.1} -vertical -set 0
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 378
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if /home/huwe0427/work/SSRL_git/SSRL_work/lpddr4_memory_controller/sim/pre_all/verif/../../../rtl/interface.sv
gui_view_scroll -id ${Source.1} -vertical -set 416
gui_src_set_reusable -id ${Source.1}

# DriverLoad 'DriverLoad.1'
gui_get_drivers -session -id ${DriverLoad.1} -signal mc_top_tb.u_mc_top.u_mc_core.dfi_if.dfi_phase0_interface_if.rddata_en -time 0 -starttime 143392.673897
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${Source.1}
	gui_set_active_window -window ${DriverLoad.1}
}
#</Session>

