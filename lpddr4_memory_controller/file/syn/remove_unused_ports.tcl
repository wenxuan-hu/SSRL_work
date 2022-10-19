proc remove_unused_ports {} {
  global no_conns
  global one_conn
  global dangling_nets
  set no_conns [list]
  set one_conn [list]
  set dangling_nets [list]
  set port_list [find port "*"]
  #
  remove_unconnected_ports [get_cells -hier *]
  remove_unconnected_ports -blast_buses [get_cells -hier *]
  #
  foreach_in_collection item $port_list {
    set itemvar [get_attribute $item full_name]
    set net1 [all_connected $item]
    if {[sizeof_collection $net1] == 0} {
      set no_conns [add_to_collection $item $no_conns]
    } else {
      set netvar [get_attribute $net1 full_name]
      set ports_list [all_connected $net1]
      set ports_listvar [get_attribute $ports_list full_name]
      if {[sizeof_collection $ports_list] == 1} {
        set net1var [get_attribute $net1 full_name]
        set one_conn [add_to_collection $item $one_conn]
        set dangling_nets [add_to_collection $net1 $dangling_nets]
      }
    }
  }
  if {[sizeof_collection $no_conns] != 0} {
    concat [echo "The following ports are connected to nothing:"] [query_objects $no_conns]
    remove_port $no_conns
  }
  if {[sizeof_collection $one_conn] != 0} {
    concat [echo "The following ports are connected to a net that goes nowhere:"] [query_object $one_conn]
    remove_port $one_conn
  }
  if {[sizeof_collection $dangling_nets] != 0} {
    concat [echo "The following nets are dangling:"] [query_object $dangling_nets]
    remove_net $dangling_nets
  }

} 
