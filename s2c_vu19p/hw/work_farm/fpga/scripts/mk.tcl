#========================================================
# Vivado project auto run script
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 22/04/2023
#========================================================

# parsing argument
if {$argc != 5} {
	puts "Error: The argument should be fpga_act fpga_val output_dir fpga_board prj_param"
	exit
} else {
	set act [lindex $argv 0]
	set val [lindex $argv 1]
	set out_dir [lindex $argv 2]
	set board [lindex $argv 3]
	set prj_param [lindex $argv 4]
}

set script_dir [file dirname [info script]]

set prj_loc  [lindex ${prj_param} 0]
set prj_name [lindex ${prj_param} 1]

set prj_param_len [llength ${prj_param}]
if { ${prj_param_len} == "3"} {
	set prj_design [lindex ${prj_param} 2]
} else {
	set prj_design "" 
}

set design_dir ${script_dir}/../../${prj_loc}/${prj_name}/scripts

source [file join $script_dir "board/${board}.tcl"]
source [file join $script_dir "prologue.tcl"]

#====================
# Main flow
#====================
if {$act == "prj_gen"} {
	# project setup
	source [file join $script_dir "prj_setup.tcl"]
	source [file join $design_dir "prj_setup.tcl"]
	
	# Generate HDF
	write_hwdef -force -file ${out_dir}/system.hdf
	
	close_project

} elseif {$act == "run_syn"} {
	open_project ${prj_file}

	source [file join $design_dir "synth.tcl"]

	close_project

} elseif {$act == "bit_gen"} {
	# Design optimization
	source [file join $design_dir "opt.tcl"]
	# Placement
	source [file join $design_dir "place.tcl"]
	# routing
	source [file join $design_dir "route.tcl"]
	# bitstream generation
	source [file join $design_dir "bit_gen.tcl"]

} else {
	source [file join $design_dir "$act.tcl"]
}
